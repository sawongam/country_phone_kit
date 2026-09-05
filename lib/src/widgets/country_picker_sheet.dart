import 'package:flutter/material.dart';
import 'package:phone_country_field/src/countries.dart';
import 'package:phone_country_field/src/models/country.dart';
import 'package:phone_country_field/src/widgets/country_list_tile.dart';
import 'package:phone_country_field/src/widgets/country_picker_labels.dart';

/// Tall enough to browse a 243-row list without feeling cramped, while leaving
/// a sliver of the page behind for context.
const double _sheetHeightFactor = 0.88;

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
  return showModalBottomSheet<Country>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: _sheetHeightFactor,
        minChildSize: 0.4,
        maxChildSize: _sheetHeightFactor,
        expand: false,
        builder: (context, scrollController) {
          return _CountryPickerContainer(
            selected: selected,
            labels: labels,
            onSelected: (country) => Navigator.of(sheetContext).pop(country),
          );
        },
      );
    },
  );
}

/// The bottom-sheet chrome: handle, title, search, list.
class _CountryPickerContainer extends StatelessWidget {
  const _CountryPickerContainer({
    required this.selected,
    required this.labels,
    required this.onSelected,
  });

  final Country? selected;
  final CountryPickerLabels labels;
  final ValueChanged<Country> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: scheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                labels.title,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            // Picker body
            Expanded(
              child: CountryPickerSheet(
                selected: selected,
                labels: labels,
                onSelected: onSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
          child: _CountrySearchField(
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
              ? _EmptyView(
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

/// Search field over the in-memory country list.
class _CountrySearchField extends StatelessWidget {
  const _CountrySearchField({
    required this.controller,
    required this.hintText,
    required this.clearTooltip,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final String clearTooltip;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: clearTooltip,
                  onPressed: onClear,
                ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Shown when the search query matches no country.
class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
