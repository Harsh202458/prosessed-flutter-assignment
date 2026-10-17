import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

/// Discounted price with the struck-through list price next to it.
class PriceView extends StatelessWidget {
  const PriceView({
    required this.product,
    this.priceStyle,
    super.key,
  });

  final Product product;
  final TextStyle? priceStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = (priceStyle ?? theme.textTheme.titleMedium)?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
    );

    return Semantics(
      label: product.hasDiscount
          ? 'Price ${Formatters.price(product.discountedPrice)}, '
                'was ${Formatters.price(product.price)}'
          : 'Price ${Formatters.price(product.price)}',
      excludeSemantics: true,
      child: Row(
        children: [
          Flexible(
            child: Text(
              Formatters.price(product.discountedPrice),
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (product.hasDiscount) ...[
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
      ),
    );
  }
}
