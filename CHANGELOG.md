# Changelog

All notable changes to this package are documented here. This project follows
[semantic versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0

First release.

### Data

- `Countries.all` — 243 countries as one `const` list, sorted by English name:
  name, flag emoji, ISO alpha-2 and alpha-3, dial code, national-number
  lengths and ISO-4217 currency.
- Lookups: `Countries.byIsoCode`, `byDialCode`, `primaryForDialCode`,
  `longestDialCodePrefix`, and a ranked `search` for pickers.
- The table is generated from the two sources in `tool/source/` by
  `dart run tool/generate_countries.dart`; nothing is decoded or fetched at
  runtime.

### Phone numbers

- `PhoneNumber` — country and national number held apart, with `parse`, `e164`,
  `formatNational`, `formatInternational`, `isValid` and `error`.
- Validation and grouping run on Google's libphonenumber metadata via
  `dlibphonenumber`, so a number of the right length with a prefix no carrier
  issues is rejected.
- `PhoneNumber.isValidNumber` and `PhoneNumber.formatE164` for one-line checks
  that do not need the model.
- `PhoneNumberInputFormatter` — as-you-type grouping with caret tracking by
  digit position, usable on any `TextField`.

### Widgets

- `PhoneNumberField` — controlled phone input with a country selector.
- `showCountryPicker` and `CountryPickerSheet` — searchable country picker as a
  modal sheet or embedded inline.
- `CountryFlag`, `CountryListTile`, `CountryPickerLabels`.
- Everything is styled through the ambient `ThemeData`; the package hard-codes
  no colours and ships no strings that cannot be replaced.
