import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

/// Discounted price with the struck-through list price next to it.
///
/// The sale price is never truncated: when space is tight the struck price
/// is dropped first, and only then is the sale price scaled down to fit.
class PriceView extends StatelessWidget {
  const PriceView({required this.product, this.priceStyle, super.key});

  final Product product;
  final TextStyle? priceStyle;

  /// Below this much leftover width the struck price isn't worth showing.
  static const double _minStruckWidth = 36;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = (priceStyle ?? theme.textTheme.titleMedium)?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
    );
    final salePrice = Formatters.price(product.discountedPrice);

    return Semantics(
      label: product.hasDiscount
          ? 'Price $salePrice, was ${Formatters.price(product.price)}'
          : 'Price $salePrice',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final painter = TextPainter(
            text: TextSpan(text: salePrice, style: style),
            maxLines: 1,
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout();
          final saleWidth = painter.width;
          painter.dispose();
          final showStruck =
              product.hasDiscount &&
              constraints.maxWidth - saleWidth - AppSpacing.xs >=
                  _minStruckWidth;

          return Row(
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(salePrice, style: style, maxLines: 1),
                ),
              ),
              if (showStruck) ...[
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    Formatters.price(product.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
