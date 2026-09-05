import 'package:flutter/foundation.dart';

/// The user-facing copy the country picker needs.
///
/// This package owns no ARB file — the app does. Pass localized strings from
/// `context.l10n` at the call site. The English defaults exist so a widget test
/// or a spike can open the picker without wiring l10n first; **shipping code
/// should always pass its own**, because a default here is a string that never
/// reaches the translators.
@immutable
class CountryPickerLabels {
  /// Builds the picker's copy. Every field has an English fallback.
  const CountryPickerLabels({
    this.title = 'Select country',
    this.searchHint = 'Search country or code',
    this.clearSearchTooltip = 'Clear search',
    this.emptyTitle = 'No match',
    this.emptyMessage = 'No country matches that name or dialling code.',
  });

  /// Sheet heading.
  final String title;

  /// Placeholder in the search field.
  final String searchHint;

  /// Tooltip on the search field's clear button.
  final String clearSearchTooltip;

  /// Heading shown when the search matches nothing.
  final String emptyTitle;

  /// Supporting copy shown when the search matches nothing.
  final String emptyMessage;
}
