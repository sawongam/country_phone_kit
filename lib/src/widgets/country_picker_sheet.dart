import 'package:country_phone_kit/src/countries.dart';
import 'package:country_phone_kit/src/models/country.dart';
import 'package:country_phone_kit/src/widgets/country_list_tile.dart';
import 'package:country_phone_kit/src/widgets/country_picker_labels.dart';
import 'package:country_phone_kit/src/widgets/picker_scaffold.dart';
import 'package:flutter/material.dart';

/// Opens the country picker and resolves to the country the user chose, or
/// null if they dismissed the sheet.
///
/// [selected] is the country currently in effect: it is checked in the list
/// and the sheet opens scrolled to it, so reopening the picker never starts
/// the user back at Afghanistan.
///
/// Pass [labels] built from your own localisation. Pass [useRootNavigator]
/// when the sheet must cover a bottom nav bar.
Future<Country?> showCountryPicker({
  required BuildContext context,
  Country? selected,
  CountryPickerLabels labels = const CountryPickerLabels(),
  bool useRootNavigator = false,
}) {
  return showPickerSheet<Country>(
    context: context,
    title: labels.title,
    useRootNavigator: useRootNavigator,
    builder: (sheetContext) => CountryPickerSheet(
      selected: selected,
      labels: labels,
      onSelected: (country) => Navigator.of(sheetContext).pop(country),
    ),
  );
}

/// The country picker's body: a search field over the full country list.
///
/// Presented by [showCountryPicker], which wraps it in a modal bottom sheet.
/// Exposed on its own so a screen that wants the picker inline — a settings
/// page, a wide-layout side panel — can embed it without a sheet.
class CountryPickerSheet extends StatefulWidget {
  /// Builds the picker body.
  const CountryPickerSheet({
    required this.onSelected,
    this.selected,
    this.labels = const CountryPickerLabels(),
    super.key,
  });

  /// The country currently in effect. Checked in the list, and scrolled to on
  /// open.
  final Country? selected;

  /// Called with the country the user picked.
  final ValueChanged<Country> onSelected;

  /// Localised copy. See [CountryPickerLabels].
  final CountryPickerLabels labels;

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final TextEditingController _search = TextEditingController();

  /// Filtering runs over a const list in memory, so it happens on the
  /// keystroke — no debounce. A debounce here would only add lag to a search
  /// that is already finished before the next frame.
  List<Country> _results = Countries.all;

  ScrollController? _scroll;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Built here rather than in initState because the row height comes from
    // the theme, and the offset has to be right on the first frame.
    _scroll ??= ScrollController(initialScrollOffset: _offsetOfSelected());
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll?.dispose();
    super.dispose();
  }

  /// Scroll offset that puts the selected country on screen, or 0 when nothing
  /// is selected or it is already near the top.
  double _offsetOfSelected() {
    final selected = widget.selected;
    if (selected == null) return 0;

    final index = Countries.all.indexOf(selected);
    if (index <= 0) return 0;

    // Leave a couple of rows of context above the selection rather than
    // pinning it to the very top edge.
    final extent = CountryListTile.extentOf(context);
    return ((index - 2) * extent).clamp(0.0, double.infinity);
  }

  void _onQueryChanged(String query) {
    setState(() => _results = Countries.search(query));

    // Narrowing the list leaves the viewport past the new end. Go back to the
    // top on every query change — the top is where the ranking put the answer.
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
                  // A fixed extent lets the list open already scrolled to the
                  // selected country: the offset is arithmetic instead of a
                  // layout pass over every row above it.
                  itemExtent: CountryListTile.extentOf(context),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final country = _results[index];
                    return CountryListTile(
                      country: country,
                      selected: country == widget.selected,
                      onTap: () => widget.onSelected(country),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
