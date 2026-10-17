import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/widgets/price_view.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image.dart';
import 'package:shopsphere/features/products/presentation/widgets/rating_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, this.onTap, super.key});

  final Product product;
  final VoidCallback? onTap;

  static const double _padding = AppSpacing.md;
  static const double _gap = AppSpacing.xs;

  /// Height of a card that is [width] wide, sized from the current text
  /// scale so the text block never overflows (e.g. at 1.3× font size).
  static double extentFor(BuildContext context, double width) {
    final theme = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? style) =>
        scaler.scale(style?.fontSize ?? 14) * (style?.height ?? 1.3);

    final textBlock =
        line(theme.titleSmall) * 2 +
        line(theme.titleMedium) +
        line(theme.bodySmall) * 1.15;
    return width + _padding * 2 + _gap * 2 + textBlock + AppSpacing.xs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: scheme.surfaceContainerHigh,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: ProductImage(
                        url: product.thumbnail,
                        semanticLabel: product.title,
                      ),
                    ),
                  ),
                  if (product.discountPercentage >= 1)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _Tag(
                        label: Formatters.discount(product.discountPercentage),
                        background: AppColors.sale,
                        foreground: Colors.white,
                      ),
                    ),
                  if (!product.isInStock)
                    Positioned(
                      bottom: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _Tag(
                        label: 'Out of stock',
                        background: scheme.inverseSurface,
                        foreground: scheme.onInverseSurface,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: _gap),
                  PriceView(product: product),
                  const SizedBox(height: _gap),
                  RatingView(rating: product.rating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
