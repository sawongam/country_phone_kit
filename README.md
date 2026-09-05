# phone_country_field

Country reference data — flag, ISO codes, dialling code, national-number
lengths, currency — and two Flutter widgets built on it: a searchable country
picker and a phone-number field.

The country table is one `const` list compiled into the binary — nothing is
decoded at runtime, nothing is fetched, and there is no third-party picker
package behind the UI. Phone validation and digit grouping run on Google's
libphonenumber metadata via `dlibphonenumber`.

The widgets are styled entirely through Flutter's standard `Theme` — no
hard-coded colours, spacing or radii. Drop them into any app and they pick up
your `ThemeData` automatically. Pass an `InputDecoration` if you need more
control.

## Installation

```yaml
dependencies:
  phone_country_field: ^1.0.0
```

## Import

```dart
import 'package:phone_country_field/phone_country_field.dart';
```

## The country table

```dart
Countries.all;                        // 243 countries, sorted by name
Countries.byIsoCode('NP');            // Country? — case-insensitive
Countries.byDialCode('977');          // every country on +977
Countries.primaryForDialCode('1');    // United States, not Canada
Countries.search('nep');              // ranked, for a picker
```

## A phone number

`PhoneNumber` keeps the country and the national number apart, which is the
whole point — a single `String` field forces every consumer to re-guess where
the dialling code ends, and they guess differently.

```dart
final nepal = Countries.byIsoCode('NP')!;

final number = PhoneNumber.parse('+977 098-1234-5678', fallbackCountry: nepal);
number.country.isoCode;     // 'NP'
number.nationalNumber;      // '9812345678'  — separators and trunk 0 gone
number.dialCode;            // '977'
number.e164;                // '+9779812345678'
number.isValid;             // true — libphonenumber, not a length check
number.error;               // null, or empty / tooShort / tooLong / invalid
number.formatNational;      // '981-2345678'
number.formatInternational; // '+977 981-2345678'
```

`isValid` is a metadata verdict, so a ten-digit Nepali number whose prefix
belongs to no carrier is rejected — a length check would wave it through:

```dart
parse('1112223333').isValid;  // false: right length, no such prefix
```

While a number is being typed the verdict moves `tooShort` → `invalid` → valid.
That middle step is not a bug: Nepal has eight-digit landlines and ten-digit
mobiles, so nine digits is a length the country does not use. A form that
validates on every keystroke should show one message for everything non-null
rather than narrate the transition.

## The field

`PhoneNumberField` is controlled: it renders the `PhoneNumber` you give it and
reports every change back.

```dart
PhoneNumberField(
  value: state.phone,
  label: 'Phone number',
  hintText: 'Enter your number',
  errorText: _phoneError(state.phone),
  onChanged: (number) => setState(() => _phone = number),
  pickerLabels: const CountryPickerLabels(
    title: 'Select country',
    searchHint: 'Search country or code',
    clearSearchTooltip: 'Clear search',
    emptyTitle: 'No match',
    emptyMessage: 'No country matches that name or dialling code.',
  ),
)
```

Digits group as they are typed — `(202) 555-0100` in the US, `981-2345678` in
Nepal, `98123 45678` in India — from libphonenumber's per-country rules, and the
caret is tracked by digit position so editing mid-number does not throw it to
the end. The grouping is display only; `onChanged` always hands back bare
digits. `PhoneNumberInputFormatter` is exported if you need it on a field of
your own.

Tapping the flag opens the picker, which can also be used on its own:

```dart
final picked = await showCountryPicker(context: context, selected: current);
```

## Styling

The field and picker use `Theme.of(context)` throughout — `colorScheme`,
`textTheme`, `InputDecorationTheme`. No overrides needed for most apps.

For full control over the field decoration, pass your own:

```dart
PhoneNumberField(
  value: _phone,
  onChanged: _onChanged,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    filled: true,
    // ... your own prefix, suffix, etc.
  ),
)
```

## What this package deliberately does not do

- **No copy of its own.** The package owns no ARB file. Pass localised strings
  through `CountryPickerLabels`, and map `PhoneNumberError` to your own
  messages — the English defaults exist so a widget test can open the picker,
  not so strings can skip the translators.
- **No state.** The current `PhoneNumber` lives in the caller's state.
- **No claim that a number is in service.** libphonenumber knows which prefixes
  a country issues, not which ones are connected. Whether someone answers is the
  backend's verdict.
- **No hard-coded default country.** Pass your own fallback.
- **No design system dependency.** Every colour, space and radius comes from
  the ambient Flutter `Theme`.

## Regenerating the data

`lib/src/data/country_data.dart` is generated. Do not edit it.

```sh
dart run tool/generate_countries.dart
dart format . && dart analyze --fatal-infos
```

The two inputs live in `tool/source/`:

| File | Holds |
| --- | --- |
| `countries_source.dart` | Name, flag emoji, alpha-2 code, dialling code, number lengths |
| `currency_source.dart` | Alpha-3 code, currency code / name / symbol |

## Tests

```sh
flutter test
```

`test/countries_test.dart` guards the generated table's shape and the lookups;
`test/phone_number_test.dart` covers parsing, validation and editing.

## Performance

Measured on AOT-compiled Dart (shipping numbers, not JIT):

| Operation | Cost |
| --- | --- |
| `Countries.search` — one keystroke in the picker | 24 µs |
| `PhoneNumber.parse` | 1.6 µs |
| `PhoneNumber.error` — one libphonenumber verdict | 197 µs |
| `formatNational` / input-formatter grouping | ~140–195 µs |
| First validation per country (metadata load) | 5,000 µs, once |
| Binary size added by `dlibphonenumber` | ~2.9 MB |

A keystroke in the phone field costs roughly 0.5 ms — grouping plus two reads
of `error` — about 3% of a frame. The 5 ms metadata load on the *first*
validation for a country lands on whichever keystroke comes first. If that
shows up as a hitch, validate a throwaway number when the page mounts to move
it off the typing path.
