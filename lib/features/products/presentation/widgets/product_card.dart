import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';
import 'package:shopsphere/features/products/presentation/widgets/price_view.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image_carousel.dart';
import 'package:shopsphere/features/products/presentation/widgets/rating_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onTap,
    this.selected = false,
    this.trailingAction,
    super.key,
  });

  final Product product;
  final VoidCallback? onTap;

  /// Optional button over the photo's top-right corner (the wishlist heart).
  final Widget? trailingAction;

  /// Highlighted as the product open in the master-detail pane.
  final bool selected;

  static const double _padding = AppSpacing.md;
  static const double _gap = AppSpacing.xs;

  /// Height of a card that is [width] wide. Derived from the current text
  /// scale so the text block fits exactly, even at 1.3× system font size.
  static double extentFor(BuildContext context, double width) {
    final theme = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? style) =>
        scaler.scale(style?.fontSize ?? 14) * (style?.height ?? 1.3);

    double tallest(List<double> heights) =>
        heights.reduce((a, b) => a > b ? a : b);

    // Top row: category/brand next to the rating (whose star icon is not
    // text-scaled). Bottom row: sale price next to the struck list price.
    final ratingIcon = (theme.bodySmall?.fontSize ?? 12) * 1.4;
    final topRow = tallest([
      line(theme.labelSmall),
      line(theme.bodySmall),
      ratingIcon,
    ]);
    final priceRow = tallest([line(theme.titleMedium), line(theme.bodySmall)]);
    final textBlock =
        topRow + _gap + line(theme.titleSmall) * 2 + _gap + priceRow;
    return width + _padding * 2 + textBlock + AppSpacing.xxs;
  }

  String get _subtitle {
    final category = CategoryStyle.labelFor(product.category);
    final brand = product.brand;
    if (category.isEmpty) return brand ?? '';
    return brand == null ? category : '$category · $brand';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: selected
            ? BorderSide(color: scheme.primary, width: 2)
            : BorderSide.none,
      ),
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
                    color: scheme.surfaceContainerHighest,
                    child: Hero(
                      tag: productHeroTag(product.id),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: ProductImage(
                          url: product.thumbnail,
                          semanticLabel: product.title,
                        ),
                      ),
                    ),
                  ),
                  if (product.discountPercentage >= 1)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _Tag(
                        label: Formatters.discount(product.discountPercentage),
                        background: scheme.primary,
                        foreground: scheme.onPrimary,
                      ),
                    ),
                  if (trailingAction != null)
                    Positioned(
                      top: AppSpacing.xxs,
                      right: AppSpacing.xxs,
                      child: trailingAction!,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      RatingView(rating: product.rating),
                    ],
                  ),
                  const SizedBox(height: _gap),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: _gap),
                  PriceView(product: product),
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
