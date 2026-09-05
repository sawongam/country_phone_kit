import 'package:dlibphonenumber/dlibphonenumber.dart' as libphonenumber;
import 'package:flutter/services.dart';

/// Groups digits as they are typed, the way the country writes them.
///
/// A Nepali number becomes `98-1234-5678`, a US one `(202) 555-0100`, a German
/// one `030 12345678` — from libphonenumber's per-country formatting rules, not
/// from a mask this package invented.
///
/// The grouping is **display only**. Everything downstream reads digits:
/// `PhoneNumber.copyWithNationalNumber` strips whatever separators land in the
/// field, so the value in the cubit is never the formatted string.
class PhoneNumberInputFormatter extends TextInputFormatter {
  /// Formats for the country with ISO-3166-1 alpha-2 code [isoCode].
  ///
  /// Build a new one when the country changes — an `AsYouTypeFormatter` is
  /// bound to one region's rules and cannot be retargeted.
  PhoneNumberInputFormatter(this.isoCode);

  /// The country whose grouping rules apply.
  final String isoCode;

  static final RegExp _nonDigits = RegExp(r'\D');

  /// Formats the bare [digits] of a national number for [isoCode].
  ///
  /// Exposed for the field, which has to re-render an existing number when the
  /// country changes without any keystroke to hang the reformat on.
  static String formatDigits(String digits, String isoCode) {
    if (digits.isEmpty) return '';

    final formatter = libphonenumber.PhoneNumberUtil.instance
        .getAsYouTypeFormatter(isoCode);
    var formatted = '';
    for (final digit in digits.split('')) {
      formatted = formatter.inputDigit(digit);
    }
    // The template can leave a separator dangling where the next digit would
    // go. Trimming keeps the caret from sitting after a space the user cannot
    // delete.
    return formatted.trimRight();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(_nonDigits, '');
    if (digits.isEmpty) return TextEditingValue.empty;

    // Reformatting moves every separator, so a caret offset counted in
    // characters is meaningless afterwards. Count in *digits* instead — the one
    // thing both strings agree on — and put the caret back after the same
    // digit. This is what stops an edit mid-number from throwing the cursor to
    // the end on every keystroke.
    final digitsBeforeCaret = newValue.text
        .substring(0, newValue.selection.end.clamp(0, newValue.text.length))
        .replaceAll(_nonDigits, '')
        .length;

    final formatted = formatDigits(digits, isoCode);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _offsetAfterDigit(formatted, digitsBeforeCaret),
      ),
    );
  }

  /// The character offset in [text] that sits just after its [count]-th digit.
  static int _offsetAfterDigit(String text, int count) {
    if (count <= 0) return 0;

    var seen = 0;
    for (var i = 0; i < text.length; i++) {
      if (!_nonDigits.hasMatch(text[i])) {
        seen++;
        if (seen == count) return i + 1;
      }
    }
    return text.length;
  }
}
