import 'package:country_phone_kit/src/currencies.dart';
import 'package:country_phone_kit/src/models/country_currency.dart';
import 'package:country_phone_kit/src/widgets/currency_list_tile.dart';
import 'package:country_phone_kit/src/widgets/currency_picker_labels.dart';
import 'package:country_phone_kit/src/widgets/picker_scaffold.dart';
import 'package:flutter/material.dart';

/// Opens the currency picker and resolves to the currency the user chose, or
/// null if they dismissed the sheet.
///
/// [selected] is the currency currently in effect: it is checked in the list
/// and the sheet opens scrolled to it, so reopening the picker never starts
/// the user back at `AED`.
///
/// Pass [labels] built from your own localisation. Pass [useRootNavigator]
/// when the sheet must cover a bottom nav bar.
///
/// ```dart
/// final picked = await showCurrencyPicker(
///   context: context,
///   selected: Currencies.byCode('NPR'),
/// );
/// ```
Future<CountryCurrency?> showCurrencyPicker({
  required BuildContext context,
  CountryCurrency? selected,
  CurrencyPickerLabels labels = const CurrencyPickerLabels(),
  bool useRootNavigator = false,
}) {
  return showPickerSheet<CountryCurrency>(
    context: context,
    title: labels.title,
    useRootNavigator: useRootNavigator,
    builder: (sheetContext) => CurrencyPickerSheet(
      selected: selected,
      labels: labels,
      onSelected: (currency) => Navigator.of(sheetContext).pop(currency),
    ),
  );
}

/// The currency picker's body: a search field over every ISO-4217 currency the
/// country table knows.
///
/// Presented by [showCurrencyPicker], which wraps it in a modal bottom sheet.
/// Exposed on its own so a screen that wants the picker inline — a settings
/// page, a wide-layout side panel — can embed it without a sheet.
class CurrencyPickerSheet extends StatefulWidget {
  /// Builds the picker body.
  const CurrencyPickerSheet({
    required this.onSelected,
    this.selected,
    this.labels = const CurrencyPickerLabels(),
    super.key,
  });

  /// The currency currently in effect. Checked in the list, and scrolled to on
  /// open.
  final CountryCurrency? selected;

  /// Called with the currency the user picked.
  final ValueChanged<CountryCurrency> onSelected;

  /// Localised copy. See [CurrencyPickerLabels].
  final CurrencyPickerLabels labels;

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  final TextEditingController _search = TextEditingController();

  /// Filtering runs over an in-memory list, so it happens on the keystroke —
  /// no debounce, for the same reason the country picker has none.
  List<CountryCurrency> _results = Currencies.all;

  ScrollController? _scroll;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scroll ??= ScrollController(initialScrollOffset: _offsetOfSelected());
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll?.dispose();
    super.dispose();
  }

  /// Scroll offset that puts the selected currency on screen, or 0 when
  /// nothing is selected or it is already near the top.
  double _offsetOfSelected() {
    final selected = widget.selected;
    if (selected == null) return 0;

    final index = Currencies.all.indexOf(selected);
    if (index <= 0) return 0;

    final extent = CurrencyListTile.extentOf(context);
    return ((index - 2) * extent).clamp(0.0, double.infinity);
  }

  void _onQueryChanged(String query) {
    setState(() => _results = Currencies.search(query));
    _scroll?.jumpTo(0);
  }

  void _clearQuery() {
    _search.clear();
    _onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: PickerSearchField(
            controller: _search,
            hintText: widget.labels.searchHint,
            clearTooltip: widget.labels.clearSearchTooltip,
            onChanged: _onQueryChanged,
            onClear: _clearQuery,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _results.isEmpty
              ? PickerEmptyView(
                  title: widget.labels.emptyTitle,
                  message: widget.labels.emptyMessage,
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemExtent: CurrencyListTile.extentOf(context),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final currency = _results[index];
                    return CurrencyListTile(
                      currency: currency,
                      selected: currency == widget.selected,
                      onTap: () => widget.onSelected(currency),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
