import 'package:country_phone_kit/src/models/country_currency.dart';
import 'package:flutter/material.dart';

/// One row in the currency picker: symbol, name, ISO-4217 code.
///
/// Flat by design, like [CountryListTile] — separation is the row rhythm
/// itself, and the selected row is marked by a neutral outline and a check
/// glyph rather than a brand-coloured fill.
///
/// The symbol sits in a fixed-width slot so the names line up down the list.
/// Symbols are not glyphs of equal width: `$` and `дин.` are both symbols, and
/// letting them size the column ragged is what makes a currency list hard to
/// scan.
class CurrencyListTile extends StatelessWidget {
  /// Builds a picker row for [currency].
  const CurrencyListTile({
    required this.currency,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Fixed row height so the picker can jump straight to the selected currency
  /// on open without laying out every row above it.
  static double extentOf(BuildContext context) => 56.0;

  /// The currency this row offers.
  final CountryCurrency currency;

  /// Whether this is the currency currently in effect.
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
                SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      currency.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currency.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currency.code,
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
