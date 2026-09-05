import 'package:flutter/widgets.dart';

/// A country's flag, drawn as its regional-indicator emoji.
///
/// A widget rather than a bare [Text] so every flag in the app shares one line
/// height. Emoji carry generous internal leading; left at the ambient height a
/// flag pushes its row taller than the text beside it.
class CountryFlag extends StatelessWidget {
  /// Draws [flag] — the emoji from [Country.flag] — at [size].
  const CountryFlag(this.flag, {this.size = defaultSize, super.key});

  /// Reads comfortably beside `bodyMedium` without dominating the row.
  static const double defaultSize = 20;

  /// The regional-indicator emoji pair, e.g. `🇳🇵`.
  final String flag;

  /// Font size the emoji is drawn at.
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    // A flag is decorative next to the country name it always accompanies;
    // announcing the emoji before "Nepal" is noise on a screen reader.
    child: Text(flag, style: TextStyle(fontSize: size, height: 1)),
  );
}
