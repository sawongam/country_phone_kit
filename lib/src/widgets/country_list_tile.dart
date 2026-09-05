import 'package:flutter/material.dart';
import 'package:phone_country_field/src/models/country.dart';
import 'package:phone_country_field/src/widgets/country_flag.dart';

/// One row in the country picker: flag, name, dialling code.
///
/// Flat by design — 243 bordered cards in a row read as a wall. Separation is
/// the row rhythm itself; the selected row is marked by a neutral outline and
/// a check glyph, never by a brand-coloured fill or a bolder weight.
class CountryListTile extends StatelessWidget {
  /// Builds a picker row for [country].
  const CountryListTile({
    required this.country,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Fixed row height so the picker can jump straight to the selected country
  /// on open without laying out every row above it.
  static double extentOf(BuildContext context) => 56.0;

  /// The country this row offers.
  final Country country;

  /// Whether this is the country currently in effect.
  final bool selected;

  /// Called when the row is picked.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const radius = BorderRadius.all(Radius.circular(8));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? scheme.outline : Colors.transparent,
        ),
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CountryFlag(country.flag),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    country.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  country.dialCodePrefix,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: scheme.onSurface,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
