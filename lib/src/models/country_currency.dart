import 'package:flutter/foundation.dart';

/// The currency a country transacts in.
///
/// This is reference data — the ISO-4217 code and how to label it — not an
/// amount. Amounts stay in the app's own money type; nothing here formats one.
@immutable
class CountryCurrency {
  /// Builds a currency from its ISO-4217 code, English name and symbol.
  const CountryCurrency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  /// ISO-4217 alpha code, e.g. `NPR`, `EUR`, `USD`.
  final String code;

  /// English name, e.g. `Nepalese rupee`.
  final String name;

  /// The symbol as written locally, e.g. `Rs`, `€`, `$`.
  ///
  /// Not unique: several currencies share `$` and `£`. Show [code] alongside it
  /// wherever the country is not already obvious from context.
  final String symbol;

  /// Whether this currency matches picker search [query].
  ///
  /// [query] is expected already lowercased and trimmed — the picker does that
  /// once per keystroke rather than 160 times. Matches the code, the name and
  /// the symbol, so `usd`, `dollar` and `$` all find something.
  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    return code.toLowerCase().contains(query) ||
        name.toLowerCase().contains(query) ||
        symbol.toLowerCase().contains(query);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CountryCurrency && other.code == code);

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'CountryCurrency($code)';
}
