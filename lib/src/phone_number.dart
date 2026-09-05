// The barrel also exports the offline geocoder, the carrier mapper and the
// time zone mapper, whose generated metadata is 16 MB of Dart on its own.
// Measured, not assumed: an AOT binary importing the barrel and one importing
// only `phone_number_util.dart` come out byte-for-byte the same size, so tree
// shaking does drop them. What the dependency does cost is ~2.9 MB of number
// metadata, which is the part we use.
import 'package:dlibphonenumber/dlibphonenumber.dart' as libphonenumber;
import 'package:flutter/foundation.dart';
import 'package:phone_country_field/src/countries.dart';
import 'package:phone_country_field/src/models/country.dart';

/// Why a [PhoneNumber] is not usable.
///
/// These map onto libphonenumber's own verdicts, so the distinction between
/// "too short" and "not a real number of the right length" is one the metadata
/// actually makes — not one guessed from a digit count.
enum PhoneNumberError {
  /// No digits typed yet.
  empty,

  /// Shorter than every valid number for the country.
  tooShort,

  /// Longer than every valid number for the country.
  tooLong,

  /// Not a number this country hands out: a prefix that belongs to no carrier,
  /// or a digit count that matches none of the country's number lengths.
  invalid,
}

/// What a form sees while a Nepali mobile is typed, digit by digit:
/// `tooShort` for one to five digits, then `invalid` from six to nine —
/// Nepal has eight-digit landlines and ten-digit mobiles, so a nine-digit
/// number is not "too short", it is a length Nepal does not use — and null at
/// ten. A form that validates on every keystroke should show one message for
/// everything non-null rather than narrating that transition to the user;
/// the distinction is there for a form that validates on submit.

/// A phone number held the way the backend wants it: a country, and the
/// national number with no dialling code, no trunk `0` and no separators.
///
/// Keeping the two apart is the whole point. A single `String` field forces
/// every consumer to re-guess where the dialling code ends, and they guess
/// differently — which is how the same user ends up as `+9779…` on one screen
/// and `09779…` on another.
///
/// Validation and display formatting run on Google's libphonenumber metadata
/// (`dlibphonenumber`). That is what lets [isValid] reject a number that is the
/// right length but belongs to no carrier, and what lets [formatNational] group
/// digits the way each country actually writes them.
@immutable
class PhoneNumber {
  /// Builds a number from a country and an already-clean national number.
  ///
  /// Prefer [PhoneNumber.parse] for anything a user typed or an API returned;
  /// this constructor trusts [nationalNumber] to be digits only.
  const PhoneNumber({required this.country, this.nationalNumber = ''});

  /// Reads [input] — typed, pasted, or off the wire — into a country and a
  /// national number.
  ///
  /// Separators are dropped. A leading `+` or `00` marks an international
  /// number, and its dialling code is matched longest-first against the
  /// country table. Anything else is read as a national number in
  /// [fallbackCountry], which is also where an unrecognised `+` code lands —
  /// the user still gets their digits back rather than an empty field.
  ///
  /// This is deliberately *our* parse, not libphonenumber's: it never throws
  /// and never refuses. A half-typed number has to survive the trip, and
  /// `PhoneNumberUtil.parse` raises on input it cannot make sense of.
  /// libphonenumber's judgement is applied later, by [error].
  factory PhoneNumber.parse(String input, {required Country fallbackCountry}) {
    final cleaned = input.replaceAll(_separators, '');
    if (cleaned.isEmpty) return PhoneNumber(country: fallbackCountry);

    var digits = cleaned;
    var isInternational = false;
    if (digits.startsWith('+')) {
      digits = digits.substring(1);
      isInternational = true;
    } else if (digits.startsWith('00')) {
      digits = digits.substring(2);
      isInternational = true;
    }
    digits = digits.replaceAll(_nonDigits, '');

    if (!isInternational) {
      return PhoneNumber(
        country: fallbackCountry,
        nationalNumber: _withoutTrunkPrefix(digits),
      );
    }

    final dialCode = Countries.longestDialCodePrefix(digits);
    if (dialCode == null) {
      return PhoneNumber(
        country: fallbackCountry,
        nationalNumber: _withoutTrunkPrefix(digits),
      );
    }

    return PhoneNumber(
      country: Countries.primaryForDialCode(dialCode) ?? fallbackCountry,
      nationalNumber: _withoutTrunkPrefix(digits.substring(dialCode.length)),
    );
  }

  static final RegExp _separators = RegExp(r'[\s\-().]');
  static final RegExp _nonDigits = RegExp(r'\D');
  static final RegExp _leadingZeros = RegExp('^0+');

  static final libphonenumber.PhoneNumberUtil _util =
      libphonenumber.PhoneNumberUtil.instance;

  /// The country the dialling code belongs to.
  final Country country;

  /// The national number: digits only, no dialling code, no leading `0`.
  final String nationalNumber;

  /// The dialling code without its `+`, e.g. `977`.
  String get dialCode => country.dialCode;

  /// Full number in E.164, e.g. `+9779812345678`.
  ///
  /// This is the format to send anywhere that wants one string. Empty when
  /// [nationalNumber] is, so an untouched field does not serialise as a bare
  /// dialling code.
  String get e164 => nationalNumber.isEmpty ? '' : '+$dialCode$nationalNumber';

  /// The number grouped the way its country writes it, e.g. `98-1234-5678`.
  ///
  /// Falls back to the raw digits while the number is still too incomplete for
  /// libphonenumber to place them — a field is mid-typing far more often than
  /// it is finished.
  String get formatNational =>
      _format(libphonenumber.PhoneNumberFormat.national) ?? nationalNumber;

  /// The number with its dialling code, grouped, e.g. `+977 98-1234-5678`.
  ///
  /// Falls back to [e164] for a number libphonenumber cannot place. Use this
  /// wherever a saved number is displayed back to the user; use [e164] for the
  /// wire.
  String get formatInternational =>
      _format(libphonenumber.PhoneNumberFormat.international) ?? e164;

  /// Whether the user has typed anything at all.
  bool get isEmpty => nationalNumber.isEmpty;

  /// Whether libphonenumber recognises this as a number the country hands out.
  ///
  /// This is a metadata verdict, not a length check: it rejects a ten-digit
  /// Nepali number whose prefix belongs to no carrier. It is still not a claim
  /// that the number is *in service* — only the backend can say that.
  bool get isValid => error == null;

  /// Why the number is unusable, or null when it passes.
  ///
  /// Recomputed on each read. See the class doc for the cost; it is far below
  /// a frame, and caching it would cost the `const` constructor.
  PhoneNumberError? get error {
    if (nationalNumber.isEmpty) return PhoneNumberError.empty;

    final libphonenumber.PhoneNumber parsed;
    try {
      parsed = _util.parse(e164, country.isoCode);
    } on libphonenumber.NumberParseException catch (exception) {
      // Too malformed for libphonenumber to read as a number at all — which is
      // what the first two digits of every number look like. Its error type
      // still says which way it is wrong, so a half-typed number reads as
      // "keep going" rather than "that number is wrong".
      return switch (exception.errorType) {
        libphonenumber.ErrorType.notANumber ||
        libphonenumber.ErrorType.tooShortAfterIdd ||
        libphonenumber.ErrorType.tooShortNsn => PhoneNumberError.tooShort,
        libphonenumber.ErrorType.tooLong => PhoneNumberError.tooLong,
        libphonenumber.ErrorType.invalidCountryCode => PhoneNumberError.invalid,
      };
    }

    if (_util.isValidNumber(parsed)) return null;

    return switch (_util.isPossibleNumberWithReason(parsed)) {
      libphonenumber.ValidationResult.tooShort => PhoneNumberError.tooShort,
      libphonenumber.ValidationResult.tooLong => PhoneNumberError.tooLong,
      // A possible-but-invalid number is the right length with a prefix the
      // country does not issue. So is invalidLength, from the user's point of
      // view: neither is a "type more" or a "type less".
      _ => PhoneNumberError.invalid,
    };
  }

  /// The same number on a different [country], keeping the digits typed so far.
  ///
  /// This is what the picker calls: switching country must not clear a number
  /// the user is halfway through.
  PhoneNumber copyWithCountry(Country country) =>
      PhoneNumber(country: country, nationalNumber: nationalNumber);

  /// The same country with a different national number.
  ///
  /// [value] is cleaned the way [PhoneNumber.parse] cleans a national number,
  /// so a field can hand over raw keystrokes.
  PhoneNumber copyWithNationalNumber(String value) => PhoneNumber(
    country: country,
    nationalNumber: _withoutTrunkPrefix(value.replaceAll(_nonDigits, '')),
  );

  /// This number as libphonenumber sees it, or null when it cannot parse it.
  ///
  /// Parsed against [Country.isoCode] rather than the dialling code, because a
  /// dialling code is ambiguous — `+1` covers twenty-odd regions with different
  /// rules — and the country is the thing the user actually picked.
  libphonenumber.PhoneNumber? get _parsed {
    try {
      return _util.parse(e164, country.isoCode);
    } on libphonenumber.NumberParseException {
      return null;
    }
  }

  String? _format(libphonenumber.PhoneNumberFormat format) {
    if (nationalNumber.isEmpty) return null;
    final parsed = _parsed;
    if (parsed == null) return null;
    return _util.format(parsed, format);
  }

  /// The backend wants the national number with no leading zero.
  static String _withoutTrunkPrefix(String number) =>
      number.startsWith('0') ? number.replaceFirst(_leadingZeros, '') : number;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhoneNumber &&
          other.country == country &&
          other.nationalNumber == nationalNumber);

  @override
  int get hashCode => Object.hash(country, nationalNumber);

  @override
  String toString() => 'PhoneNumber(${e164.isEmpty ? '+$dialCode —' : e164})';
}
