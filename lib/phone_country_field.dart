/// Country reference data and the pickers built on it.
///
/// One `const` table backs everything here: name, flag emoji, ISO codes,
/// dialling code, national-number lengths and currency, merged at build time
/// from the two sources in `tool/`. Nothing is decoded at runtime and nothing
/// is fetched.
///
/// ## Where to start
///
/// - [Countries] — the table, plus lookup by ISO code, lookup by dialling code
///   and the picker's search.
/// - [PhoneNumber] — a country and a national number held apart, with parsing,
///   E.164 output and length validation.
/// - [PhoneNumberField] — the phone input: country selector plus number field,
///   grouping digits as they are typed.
/// - [showCountryPicker] — the searchable country sheet on its own.
///
/// ## What this package does not do
///
/// It owns no ARB file and no state. Copy comes in through
/// [CountryPickerLabels]; the current [PhoneNumber] lives in the caller's
/// state. Validation and display grouping come from Google's libphonenumber
/// metadata (`dlibphonenumber`), so a number of the right length with a prefix
/// no carrier issues is still rejected — but whether the number is *in service*
/// is the backend's verdict, and only the backend's.
library;

export 'src/countries.dart';
export 'src/models/country.dart';
export 'src/models/country_currency.dart';
export 'src/phone_number.dart';
export 'src/phone_number_input_formatter.dart';
export 'src/widgets/country_flag.dart';
export 'src/widgets/country_list_tile.dart';
export 'src/widgets/country_picker_labels.dart';
export 'src/widgets/country_picker_sheet.dart';
export 'src/widgets/phone_number_field.dart';
