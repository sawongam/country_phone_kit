// Merges the two authored sources in `tool/source/` into the single const
// table the package ships, `lib/src/data/country_data.dart`.
//
// Run from the package root:
//
// ```sh
// dart run tool/generate_countries.dart
// ```
//
// The two sources are keyed by ISO-3166-1 alpha-2 code and are otherwise
// unrelated: `countries_source.dart` has names, flags, dialling codes and
// number lengths but no currency; `currency_source.dart` has currencies and
// alpha-3 codes but no dialling codes. Merging them once, at build time, is
// what lets the app hold one `Country` instead of looking two things up.
//
// The generator is strict on purpose: an unmatched row or a currency that
// survives neither the source nor `_currencyOverrides` fails the run rather
// than emitting a country that is quietly missing half its data.

import 'dart:io';

import 'source/countries_source.dart';
import 'source/country_shim.dart';
import 'source/currency_source.dart';

/// Curated fixes for rows the upstream data gets wrong or omits.
///
/// Every entry here was checked by hand against ISO-3166 and ISO-4217. The
/// Crown Dependencies (`GG`, `IM`, `JE`) issue local pounds pegged 1:1 to
/// sterling; they are recorded as `GBP`, which is what actually changes hands
/// and what a payment processor will want.
const _currencyOverrides = <String, RawCurrency>{
  // Currency row is missing upstream.
  'GG': (
    iso3: 'GGY',
    currencyCode: 'GBP',
    currencyName: 'Pound sterling',
    currencySymbol: '£',
  ),
  'IM': (
    iso3: 'IMN',
    currencyCode: 'GBP',
    currencyName: 'Pound sterling',
    currencySymbol: '£',
  ),
  'JE': (
    iso3: 'JEY',
    currencyCode: 'GBP',
    currencyName: 'Pound sterling',
    currencySymbol: '£',
  ),
  'ME': (
    iso3: 'MNE',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'BL': (
    iso3: 'BLM',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'MF': (
    iso3: 'MAF',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'RS': (
    iso3: 'SRB',
    currencyCode: 'RSD',
    currencyName: 'Serbian dinar',
    currencySymbol: 'дин.',
  ),
  'SS': (
    iso3: 'SSD',
    currencyCode: 'SSP',
    currencyName: 'South Sudanese pound',
    currencySymbol: '£',
  ),

  // Currency row is present but wrong: upstream repeated the alpha-2 code as
  // the currency code and gave no alpha-3 code at all.
  'AX': (
    iso3: 'ALA',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),

  // Currency name is missing upstream, and the symbol was the Armenian letter
  // Դ rather than the dram sign ֏.
  'AM': (
    iso3: 'ARM',
    currencyCode: 'AMD',
    currencyName: 'Armenian dram',
    currencySymbol: '֏',
  ),

  // Retired national currencies. Upstream still records the currency each of
  // these countries used *before* it joined the euro area — Cyprus and Malta
  // in 2008, Slovakia in 2009, Estonia in 2011, Latvia in 2014, Lithuania in
  // 2015, Croatia in 2023. Two of them (CYP, MTL) even carried the euro sign
  // against the old code, which is how the staleness showed up: a currency
  // picker offered three different currencies all symbolised `€`.
  'CY': (
    iso3: 'CYP',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'MT': (
    iso3: 'MLT',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'SK': (
    iso3: 'SVK',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'EE': (
    iso3: 'EST',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'LV': (
    iso3: 'LVA',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'LT': (
    iso3: 'LTU',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),
  'HR': (
    iso3: 'HRV',
    currencyCode: 'EUR',
    currencyName: 'Euro',
    currencySymbol: '€',
  ),

  // Redenominated currencies. Upstream still records the ISO-4217 code each of
  // these countries retired, which is worse than a cosmetic problem: a picker
  // built on it hands the backend a code no payment processor will accept.
  // Dates are the redenomination, not the country.
  'GH': (
    iso3: 'GHA',
    currencyCode: 'GHS',
    currencyName: 'Ghanaian cedi',
    currencySymbol: '₵',
  ),
  'SD': (
    iso3: 'SDN',
    currencyCode: 'SDG',
    currencyName: 'Sudanese pound',
    currencySymbol: 'ج.س.',
  ),
  'TM': (
    iso3: 'TKM',
    currencyCode: 'TMT',
    currencyName: 'Turkmenistan manat',
    currencySymbol: 'm',
  ),
  'ZM': (
    iso3: 'ZMB',
    currencyCode: 'ZMW',
    currencyName: 'Zambian kwacha',
    currencySymbol: 'ZK',
  ),
  'MR': (
    iso3: 'MRT',
    currencyCode: 'MRU',
    currencyName: 'Mauritanian ouguiya',
    currencySymbol: 'UM',
  ),
  'ST': (
    iso3: 'STP',
    currencyCode: 'STN',
    currencyName: 'Sao Tome and Principe dobra',
    currencySymbol: 'Db',
  ),
  'VE': (
    iso3: 'VEN',
    currencyCode: 'VES',
    currencyName: 'Venezuelan bolivar',
    currencySymbol: 'Bs',
  ),
  'SL': (
    iso3: 'SLE',
    currencyCode: 'SLE',
    currencyName: 'Sierra Leonean leone',
    currencySymbol: 'Le',
  ),

  // Zimbabwe is the volatile one: ZWD was dropped in 2009, the country
  // dollarised, ZWL came back in 2019, and ZWG ("ZiG", gold-backed) replaced
  // it in April 2024. If your backend still settles Zimbabwe in USD, override
  // this row rather than working around it downstream.
  'ZW': (
    iso3: 'ZWE',
    currencyCode: 'ZWG',
    currencyName: 'Zimbabwe gold',
    currencySymbol: 'ZiG',
  ),

  // Currency code is right, but upstream gave a bare noun as the name — a
  // picker row reading "Dollar" or "Franc" tells the user nothing about
  // which one it is.
  'BO': (
    iso3: 'BOL',
    currencyCode: 'BOB',
    currencyName: 'Bolivian boliviano',
    currencySymbol: r'$b',
  ),
  'CL': (
    iso3: 'CHL',
    currencyCode: 'CLP',
    currencyName: 'Chilean peso',
    currencySymbol: r'$',
  ),
  'CN': (
    iso3: 'CHN',
    currencyCode: 'CNY',
    currencyName: 'Chinese yuan',
    currencySymbol: '¥',
  ),
  'GN': (
    iso3: 'GIN',
    currencyCode: 'GNF',
    currencyName: 'Guinean franc',
    currencySymbol: 'FG',
  ),
  'KM': (
    iso3: 'COM',
    currencyCode: 'KMF',
    currencyName: 'Comorian franc',
    currencySymbol: 'CF',
  ),

  // Antarctica has no currency. Upstream carried an empty code with a `$`.
  'AQ': (
    iso3: 'ATA',
    currencyCode: null,
    currencyName: null,
    currencySymbol: null,
  ),
};

/// The country a shared dialling code resolves to when a number is parsed.
///
/// Eleven dialling codes are used by more than one country, so parsing `+1`
/// has to pick one. The choice is by population of the numbering plan's home
/// territory, which is the country a user typing that prefix almost always
/// means.
const _dialCodePrimaries = <String, String>{
  '1': 'US', // over CA, DO
  '7': 'RU', // over KZ
  '44': 'GB', // over GG, IM, JE
  '47': 'NO', // over BV, SJ
  '61': 'AU', // over CX, CC
  '64': 'NZ', // over PN
  '262': 'RE', // over TF, YT
  '358': 'FI', // over AX
  '500': 'FK', // over GS
  '590': 'GP', // over BL, MF
  '672': 'NF', // over AQ, HM
};

const _output = 'lib/src/data/country_data.dart';

void main() {
  final countries = [...rawCountries]..sort((a, b) => a.name.compareTo(b.name));

  final unmatched = rawCurrencies.keys
      .where((iso) => !countries.any((c) => c.code == iso))
      .toList();
  if (unmatched.isNotEmpty) {
    _fail('currency rows with no country: ${unmatched.join(', ')}');
  }

  for (final iso in _dialCodePrimaries.values) {
    if (!countries.any((c) => c.code == iso)) {
      _fail('dial-code primary "$iso" is not a country');
    }
  }

  final buffer = StringBuffer()..write(_header);
  for (final country in countries) {
    buffer.write(_entry(country));
  }
  buffer
    ..writeln('];')
    ..writeln()
    ..write(_primaries());

  File(_output).writeAsStringSync(buffer.toString());
  stdout.writeln('Wrote ${countries.length} countries to $_output.');
  stdout.writeln('Run `dart format .` and `dart analyze` next.');
}

String _entry(RawCountry country) {
  final raw =
      _currencyOverrides[country.code] ??
      rawCurrencies[country.code] ??
      _fail('no currency data for ${country.code} (${country.name})');

  final iso3 =
      raw.iso3 ??
      _fail('no alpha-3 code for ${country.code} (${country.name})');

  final code = raw.currencyCode;
  final name = raw.currencyName;
  final symbol = raw.currencySymbol;
  final hasCurrency = code != null && name != null && symbol != null;
  if (!hasCurrency && !(code == null && name == null && symbol == null)) {
    _fail('partial currency for ${country.code}: $raw');
  }
  if (hasCurrency && code.length != 3) {
    _fail('currency code "$code" for ${country.code} is not ISO-4217');
  }

  return '''
  Country(
    name: ${_string(country.name)},
    isoCode: ${_string(country.code)},
    iso3Code: ${_string(iso3)},
    dialCode: ${_string(country.dialCode)},
    flag: ${_string(country.flag)},
    minLength: ${country.minLength},
    maxLength: ${country.maxLength},
${hasCurrency ? '''    currency: CountryCurrency(
      code: ${_string(code)},
      name: ${_string(name)},
      symbol: ${_string(symbol)},
    ),
''' : ''}  ),
''';
}

String _primaries() {
  final buffer = StringBuffer()
    ..writeln('/// The country a shared dialling code resolves to.')
    ..writeln('///')
    ..writeln(
      '/// Eleven dialling codes are used by more than one country. Parsing has to',
    )
    ..writeln('/// pick one, and picks the numbering plan\'s home territory.')
    ..writeln('const Map<String, String> kDialCodePrimaries = {');
  for (final entry in _dialCodePrimaries.entries) {
    buffer.writeln("  '${entry.key}': '${entry.value}',");
  }
  return (buffer..writeln('};')).toString();
}

String _string(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$');
  return "'$escaped'";
}

Never _fail(String message) {
  stderr.writeln('generate_countries: $message');
  exit(1);
}

const _header = '''
// GENERATED — DO NOT EDIT BY HAND.
//
// Produced by `dart run tool/generate_countries.dart` from the two authored
// sources in `tool/source/`. Fix the data there (or the generator's override
// table) and re-run; an edit made here is lost on the next generation.

import 'package:country_phone_kit/src/models/country.dart';
import 'package:country_phone_kit/src/models/country_currency.dart';

/// Every country the app knows, sorted by English name.
///
/// Read this through [Countries], which adds the lookups and the search the
/// pickers need. Nothing outside `src/` should import this file.
const List<Country> kCountries = [
''';
