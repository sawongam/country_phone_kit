import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_phone_kit/src/models/country.dart';
import 'package:country_phone_kit/src/phone_number.dart';
import 'package:country_phone_kit/src/phone_number_input_formatter.dart';
import 'package:country_phone_kit/src/widgets/country_flag.dart';
import 'package:country_phone_kit/src/widgets/country_picker_labels.dart';
import 'package:country_phone_kit/src/widgets/country_picker_sheet.dart';

/// Phone entry: a country selector and a national-number field, in one control.
///
/// Controlled — it renders [value] and reports every change through
/// [onChanged], holding no phone state of its own. That is what keeps the
/// country and the digits from drifting apart: there is one [PhoneNumber], and
/// it lives in the caller's state.
///
/// The number the user types is filtered to digits and stripped of its trunk
/// `0`, so what [onChanged] hands back is always ready to send. Read
/// [PhoneNumber.e164] for a single string, or [PhoneNumber.dialCode] and
/// [PhoneNumber.nationalNumber] for an API that wants the two apart.
///
/// Styling follows the ambient [ThemeData] — set [InputDecorationTheme] or
/// wrap in your own [Theme] to match your design system.
class PhoneNumberField extends StatefulWidget {
  /// Builds a phone field showing [value].
  const PhoneNumberField({
    required this.value,
    required this.onChanged,
    this.label,
    this.hintText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
    this.pickerLabels = const CountryPickerLabels(),
    this.useRootNavigator = false,
    this.decoration,
    super.key,
  });

  /// The number on screen: country plus national digits.
  final PhoneNumber value;

  /// Called on every keystroke and on every country change.
  final ValueChanged<PhoneNumber> onChanged;

  /// Label above the field. Forwarded to [InputDecoration.label].
  final String? label;

  /// Placeholder inside the number input.
  final String? hintText;

  /// Validation message under the field.
  ///
  /// The package deliberately does not write this: map [PhoneNumber.error] to
  /// copy from your localisation at the call site, so the message is translated
  /// and phrased in your app's voice.
  final String? errorText;

  /// When true, an asterisk is appended to [label].
  final bool required;

  /// Whether the field and the country selector accept input.
  final bool enabled;

  /// Whether the number input takes focus on mount.
  final bool autofocus;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Focus node for the number input.
  final FocusNode? focusNode;

  /// Called when the keyboard action is used.
  final ValueChanged<PhoneNumber>? onSubmitted;

  /// Localised copy for the country picker this field opens.
  final CountryPickerLabels pickerLabels;

  /// Forwarded to [showCountryPicker]. See its doc for when to set it.
  final bool useRootNavigator;

  /// Override the entire [InputDecoration].
  ///
  /// When supplied, [label], [hintText] and [errorText] are ignored — put them
  /// in the decoration directly. Useful when you need full control over borders
  /// or filled style.
  final InputDecoration? decoration;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: _formatted(widget.value),
  );

  static final RegExp _nonDigits = RegExp(r'\D');

  @override
  void didUpdateWidget(PhoneNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // The field shows grouped digits while the value holds bare ones, so the
    // two are compared digit-wise. Comparing the strings would find them
    // different on every rebuild and reset the text under the user's caret.
    final countryChanged = widget.value.country != oldWidget.value.country;
    final typed = _digitsOf(_controller.text);
    if (!countryChanged && typed == widget.value.nationalNumber) return;

    // Either the caller set a different number, or the country changed and the
    // same digits now group differently. Re-render, caret at the end.
    final text = _formatted(widget.value);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// [number] grouped for display, e.g. `98-1234-5678`.
  String _formatted(PhoneNumber number) =>
      PhoneNumberInputFormatter.formatDigits(
        number.nationalNumber,
        number.country.isoCode,
      );

  /// The digits in [text], with the trunk `0` dropped the way the value holds
  /// them — so the two can be compared.
  String _digitsOf(String text) {
    final digits = text.replaceAll(_nonDigits, '');
    return digits.startsWith('0')
        ? digits.replaceFirst(RegExp('^0+'), '')
        : digits;
  }

  void _onNumberChanged(String text) =>
      widget.onChanged(widget.value.copyWithNationalNumber(text));

  Future<void> _pickCountry() async {
    final picked = await showCountryPicker(
      context: context,
      selected: widget.value.country,
      labels: widget.pickerLabels,
      useRootNavigator: widget.useRootNavigator,
    );
    if (picked == null || !mounted) return;

    // Keep the digits: someone correcting the country mid-entry has not
    // changed their mind about their number. didUpdateWidget regroups them for
    // the new country once the caller pushes the value back down.
    widget.onChanged(widget.value.copyWithCountry(picked));
  }

  InputDecoration _buildDecoration(BuildContext context) {
    if (widget.decoration != null) return widget.decoration!;

    final labelText = widget.required && widget.label != null
        ? '${widget.label} *'
        : widget.label;

    return InputDecoration(
      labelText: labelText,
      hintText: widget.hintText,
      errorText: widget.errorText,
      prefixIcon: _CountrySelector(
        country: widget.value.country,
        onTap: widget.enabled ? _pickCountry : null,
      ),
      // Drop the Material default 48px prefix box so the field can stay dense.
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      decoration: _buildDecoration(context),
      inputFormatters: [
        // Keeps the soft keyboard from typing letters in. A paste can still
        // carry a +code and separators; PhoneNumber strips those.
        FilteringTextInputFormatter.allow(RegExp(r'[\d+\s\-().]')),
        LengthLimitingTextInputFormatter(_maxTypedLength),
        // Rebuilt every frame so a country change retargets the grouping —
        // an AsYouTypeFormatter is bound to one region and cannot be reused.
        PhoneNumberInputFormatter(widget.value.country.isoCode),
      ],
      onChanged: _onNumberChanged,
      onSubmitted: (_) => widget.onSubmitted?.call(widget.value),
    );
  }

  /// Room for the longest national number plus the separators libphonenumber
  /// groups it with, without letting a runaway paste fill the field.
  static const int _maxTypedLength = 24;
}

/// The flag-and-dial-code button that opens the country picker.
class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.country, required this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final enabled = onTap != null;
    final foreground = enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              end: 6,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryFlag(country.flag, size: 16),
                const SizedBox(width: 4),
                Text(
                  country.dialCodePrefix,
                  style: textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    height: 1.2,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Icon(Icons.arrow_drop_down, size: 18, color: foreground),
              ],
            ),
          ),
        ),
        Container(width: 1, height: 20, color: scheme.outlineVariant),
        const SizedBox(width: 10),
      ],
    );
  }
}
