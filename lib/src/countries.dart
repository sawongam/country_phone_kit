import 'package:country_phone_kit/src/data/country_data.dart';
import 'package:country_phone_kit/src/models/country.dart';

/// The country table, plus the lookups the app actually needs.
///
/// Every map here is built once, lazily, on first use — 243 entries indexed
/// three ways costs less than a frame and is paid for by the first picker
/// that opens, not by app start.
abstract final class Countries {
  /// Every country, sorted by English name. This is the picker's list order.
  static const List<Country> all = kCountries;

  static final Map<String, Country> _byIsoCode = {
    for (final country in all) country.isoCode: country,
  };

  static final Map<String, List<Country>> _byDialCode = () {
    final grouped = <String, List<Country>>{};
    for (final country in all) {
      grouped.putIfAbsent(country.dialCode, () => []).add(country);
    }
    return grouped;
  }();

  /// Dialling codes longest first, so `+977` is never read as `+97`.
  static final List<String> _dialCodesByLength = _byDialCode.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));

  /// The country with ISO-3166-1 alpha-2 [isoCode], or null if there is none.
  ///
  /// Case-insensitive, and null-tolerant so a nullable code off the wire can be
  /// passed straight in.
  static Country? byIsoCode(String? isoCode) =>
      isoCode == null ? null : _byIsoCode[isoCode.toUpperCase()];

  /// Every country sharing [dialCode], in name order. Empty if the code is
  /// unknown. [dialCode] is given without its `+`.
  ///
  /// Eleven codes have more than one country. Use [primaryForDialCode] where
  /// exactly one answer is needed.
  static List<Country> byDialCode(String dialCode) =>
      _byDialCode[_withoutPlus(dialCode)] ?? const [];

  /// The one country [dialCode] should resolve to, or null if the code is
  /// unknown.
  ///
  /// For the eleven shared codes this is the numbering plan's home territory —
  /// `+1` is the United States, not Canada. See `kDialCodePrimaries`.
  static Country? primaryForDialCode(String dialCode) {
    final code = _withoutPlus(dialCode);
    final primary = byIsoCode(kDialCodePrimaries[code]);
    if (primary != null) return primary;

    final matches = byDialCode(code);
    return matches.isEmpty ? null : matches.first;
  }

  /// The longest dialling code [digits] starts with, or null if it starts with
  /// none. [digits] is a bare international number, no `+` and no separators.
  ///
  /// Longest-first so `9779812345678` resolves to Nepal (`977`) rather than
  /// stopping at some shorter prefix.
  static String? longestDialCodePrefix(String digits) {
    for (final code in _dialCodesByLength) {
      if (digits.length > code.length && digits.startsWith(code)) return code;
    }
    return null;
  }

  /// Countries matching a picker search [query], best matches first.
  ///
  /// Ranking is deliberately simple and stable: an exact ISO or dialling-code
  /// hit, then a name that starts with the query, then everything else that
  /// contains it, each group still in name order. Typing `in` therefore puts
  /// India above Finland without any scoring machinery to tune.
  static List<Country> search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return all;

    final digits = _withoutPlus(needle);
    final exact = <Country>[];
    final prefix = <Country>[];
    final rest = <Country>[];

    for (final country in all) {
      if (!country.matchesQuery(needle)) continue;

      if (country.isoCode.toLowerCase() == needle ||
          country.dialCode == digits) {
        exact.add(country);
      } else if (country.name.toLowerCase().startsWith(needle)) {
        prefix.add(country);
      } else {
        rest.add(country);
      }
    }

    return [...exact, ...prefix, ...rest];
  }

  static String _withoutPlus(String value) =>
      value.startsWith('+') ? value.substring(1) : value;
}
