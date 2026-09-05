/// The chrome both pickers share: the sheet, its handle and title, the search
/// field, and the empty state.
///
/// Internal. Nothing here is exported — the country picker and the currency
/// picker are the public surface, and they must look like one control, which
/// two copies of this file would not stay.
library;

import 'package:flutter/material.dart';

/// Tall enough to browse a long list without feeling cramped, while leaving a
/// sliver of the page behind for context.
const double pickerSheetHeightFactor = 0.88;

/// Opens [builder] as the package's modal picker sheet and resolves to what
/// the sheet pops, or null if it was dismissed.
///
/// One definition so the country and currency pickers cannot drift apart in
/// height, corner radius or drag behaviour.
Future<T?> showPickerSheet<T>({
  required BuildContext context,
  required String title,
  required Widget Function(BuildContext sheetContext) builder,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: pickerSheetHeightFactor,
        minChildSize: 0.4,
        maxChildSize: pickerSheetHeightFactor,
        expand: false,
        builder: (context, scrollController) =>
            PickerSheetContainer(title: title, child: builder(sheetContext)),
      );
    },
  );
}

/// The bottom-sheet chrome: rounded surface, drag handle, title, divider.
class PickerSheetContainer extends StatelessWidget {
  /// Wraps [child] in the sheet chrome under [title].
  const PickerSheetContainer({
    required this.title,
    required this.child,
    super.key,
  });

  /// Sheet heading.
  final String title;

  /// The picker body.
  final Widget child;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                title,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// Search field over an in-memory list.
class PickerSearchField extends StatelessWidget {
  /// Builds the search field.
  const PickerSearchField({
    required this.controller,
    required this.hintText,
    required this.clearTooltip,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  /// Holds the query.
  final TextEditingController controller;

  /// Placeholder.
  final String hintText;

  /// Tooltip on the clear button.
  final String clearTooltip;

  /// Called on every keystroke.
  final ValueChanged<String> onChanged;

  /// Called when the clear button is used.
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
          isDense: true,
          prefixIcon: const Icon(Icons.search, size: 20),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  visualDensity: VisualDensity.compact,
                  tooltip: clearTooltip,
                  onPressed: onClear,
                ),
        ),
      ),
    );
  }
}

/// Shown when a query matches nothing.
class PickerEmptyView extends StatelessWidget {
  /// Builds the empty state.
  const PickerEmptyView({
    required this.title,
    required this.message,
    super.key,
  });

  /// Heading.
  final String title;

  /// Supporting copy.
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
            Icon(Icons.search_off, size: 48, color: scheme.onSurfaceVariant),
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
