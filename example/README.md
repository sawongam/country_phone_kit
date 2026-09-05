# country_phone_kit example

A gallery for the package:

| Card | Shows |
| --- | --- |
| **Just the data** | `Countries.all`, `byIsoCode`, `byDialCode`, `primaryForDialCode`, and the one-line `PhoneNumber.isValidNumber` / `formatE164` — no widget from this package on screen |
| **Type a number** | `PhoneNumberField` with live validation, as-you-type grouping and an E.164 readout |
| **Pick a country** | `showCountryPicker`, plus the dial code, digit lengths and currency of what you picked |
| **Paste any format** | `PhoneNumber.parse` against `+977 …`, `00 44 …` and `(202) 555-0100` |

Styling comes entirely from `ThemeData` — the toggle in the app bar flips
light and dark so you can watch the widgets follow along.

## Run

From this directory:

```sh
flutter pub get
flutter run
```

Linux, macOS, Windows, Chrome and attached devices all work:

```sh
flutter run -d chrome
```

If you got this from pub.dev rather than from the repository, the per-platform
folders are not in the archive — run `flutter create .` here first to put them
back.
