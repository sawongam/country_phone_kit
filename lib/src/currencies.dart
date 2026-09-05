import 'package:country_phone_kit/src/countries.dart';
import 'package:country_phone_kit/src/models/country.dart';
import 'package:country_phone_kit/src/models/country_currency.dart';

/// The currency table, derived from the country table.
///
/// Currencies are not stored separately: each [Country] carries the currency it
/// transacts in, and this is that data indexed the other way — deduplicated by
/// ISO-4217 code, so the euro appears once rather than twenty-eight times.
///
/// Built once, lazily, on first use. Nothing here costs anything until an app
/// asks for a currency.
abstract final class Currencies {
  /// Every currency exactly once, sorted by ISO-4217 code.
  ///
  /// Code order, not name order, because a currency list is read by its codes —
  /// `AED`, `AFN`, `ALL` — and someone looking for `USD` scans for the letters
  /// they already know.
  static final List<CountryCurrency> all = () {
    final byCode = <String, CountryCurrency>{};
    for (final country in Countries.all) {
      final currency = country.currency;
      if (currency != null) byCode.putIfAbsent(currency.code, () => currency);
    }
    return List<CountryCurrency>.unmodifiable(
      byCode.values.toList()..sort((a, b) => a.code.compareTo(b.code)),
    );
  }();

  static final Map<String, CountryCurrency> _byCode = {
    for (final currency in all) currency.code: currency,
  };

  static final Map<String, List<Country>> _countriesByCode = () {
    final grouped = <String, List<Country>>{};
    for (final country in Countries.all) {
      final currency = country.currency;
      if (currency == null) continue;
      grouped.putIfAbsent(currency.code, () => []).add(country);
    }
    return grouped;
  }();

  /// The currency with ISO-4217 [code], or null if there is none.
  ///
  /// Case-insensitive, and null-tolerant so a nullable code off the wire can be
  /// passed straight in.
  static CountryCurrency? byCode(String? code) =>
      code == null ? null : _byCode[code.toUpperCase()];

  /// What the country with ISO-3166-1 alpha-2 [isoCode] transacts in, or null
  /// if the country is unknown — or is Antarctica, which has no currency.
  static CountryCurrency? forCountry(String? isoCode) =>
      Countries.byIsoCode(isoCode)?.currency;

  /// Every country that transacts in [code], in name order. Empty if the code
  /// is unknown.
  ///
  /// Thirteen currencies are shared. This is what turns "EUR" back into the
  /// twenty-eight countries a form might mean by it.
  static List<Country> countriesUsing(String code) =>
      _countriesByCode[code.toUpperCase()] ?? const [];

  /// Currencies matching a picker search [query], best matches first.
  ///
  /// Ranked the way [Countries.search] is, and for the same reason — an exact
  /// code hit, then a code or name that starts with the query, then everything
  /// else that contains it, each group still in code order. Typing `us`
  /// therefore puts `USD` above `AUD` without any scoring machinery to tune.
  static List<CountryCurrency> search(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return all;

    final exact = <CountryCurrency>[];
    final prefix = <CountryCurrency>[];
    final rest = <CountryCurrency>[];

    for (final currency in all) {
      if (!currency.matchesQuery(needle)) continue;

      final code = currency.code.toLowerCase();
      if (code == needle) {
        exact.add(currency);
      } else if (code.startsWith(needle) ||
          currency.name.toLowerCase().startsWith(needle)) {
        prefix.add(currency);
      } else {
        rest.add(currency);
      }
    }

    return [...exact, ...prefix, ...rest];
  }
}
