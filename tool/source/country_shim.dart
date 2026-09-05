/// The shape the raw `countries` list below was authored against.
///
/// This is deliberately *not* the package's public [Country] model — it is the
/// minimal class needed to make `countries_source.dart` compile so the
/// generator can read it. Editing it means editing the raw list to match.
class RawCountry {
  const RawCountry({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.minLength,
    required this.maxLength,
  });

  final String name;
  final String flag;
  final String code;
  final String dialCode;
  final int minLength;
  final int maxLength;
}
