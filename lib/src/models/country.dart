import 'package:flutter/foundation.dart';
import 'package:country_phone_kit/src/models/country_currency.dart';

/// One country, as the app needs to know it: what to call it, what to draw for
/// it, what its phone numbers look like, and what it spends.
///
/// Instances are `const` and come from [Countries]. Never construct one at a
/// call site — a hand-written country is how two screens end up disagreeing
/// about Nepal's dialling code.
@immutable
class Country {
  /// Builds a country. Reserved for the generated table in
  /// `src/data/country_data.dart`; read countries off [Countries] instead.
  const Country({
    required this.name,
    required this.isoCode,
    required this.dialCode,
    required this.flag,
    required this.minLength,
    required this.maxLength,
    this.iso3Code,
    this.currency,
  });

  /// English name, e.g. `Nepal`.
  ///
  /// The app ships English only. When a second locale lands, the translations
  /// are already in `tool/source/countries_source.dart` waiting to be emitted.
  final String name;

  /// ISO-3166-1 alpha-2 code, e.g. `NP`. The country's identity — equality,
  /// lookup and every API that names a country use this.
  final String isoCode;

  /// ISO-3166-1 alpha-3 code, e.g. `NPL`.
  ///
  /// Null for the few territories the source data never assigned one (Jersey,
  /// Guernsey, the Isle of Man and a handful of French collectivities).
  final String? iso3Code;

  /// International dialling code **without** the leading `+`, e.g. `977`.
  ///
  /// Not unique — `1` is the US, Canada and the Dominican Republic. Use
  /// [Countries.primaryForDialCode] when a code has to resolve to one country.
  final String dialCode;

  /// Flag as a regional-indicator emoji pair, e.g. `🇳🇵`.
  ///
  /// Deliberately not an image asset: this renders at any size, in any colour
  /// scheme, on every platform the app ships to, and costs nothing to bundle.
  final String flag;

  /// Fewest digits a valid national number has, ignoring the dialling code.
  ///
  /// Coarse reference data from the source table, kept because it is free and
  /// occasionally useful for sizing a field. **It is not the validity rule** —
  /// `PhoneNumber.error` asks libphonenumber, which knows that a number can be
  /// the right length and still belong to no carrier. Do not add a second
  /// verdict here.
  final int minLength;

  /// Most digits a valid national number has, ignoring the dialling code.
  ///
  /// See [minLength] on why this is not the validity rule.
  final int maxLength;

  /// The currency the country transacts in.
  ///
  /// Null only for Antarctica, which has no currency of its own.
  final CountryCurrency? currency;

  /// The dialling code as it is shown to a user, e.g. `+977`.
  String get dialCodePrefix => '+$dialCode';

  /// Whether this country matches picker search [query].
  ///
  /// [query] is expected already lowercased and trimmed — the picker does that
  /// once per keystroke rather than 243 times. Matches the name, either ISO
  /// code and the dialling code, so `np`, `nepal`, `977` and `+977` all find
  /// Nepal.
  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    if (name.toLowerCase().contains(query)) return true;
    if (isoCode.toLowerCase().startsWith(query)) return true;
    if (iso3Code?.toLowerCase().startsWith(query) ?? false) return true;

    final digits = query.startsWith('+') ? query.substring(1) : query;
    return digits.isNotEmpty && dialCode.startsWith(digits);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Country && other.isoCode == isoCode);

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() => 'Country($isoCode, +$dialCode)';
}
