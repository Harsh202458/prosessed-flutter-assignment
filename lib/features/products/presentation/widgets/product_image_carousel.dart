import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Hero tag shared by a product card's image and the details carousel.
String productHeroTag(int productId) => 'product-image-$productId';

/// Swipeable product photos with a page indicator. The first page is the
/// Hero target for the card thumbnail.
class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    required this.productId,
    required this.images,
    required this.title,
    this.heroEnabled = true,
    super.key,
  });

  final int productId;
  final List<String> images;
  final String title;
  final bool heroEnabled;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final images = widget.images;

    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ProductImage(
                  url: images[index],
                  semanticLabel: context.l10n.productImageLabel(
                    widget.title,
                    index + 1,
                    images.length,
                  ),
                ),
              );
              return index == 0 && widget.heroEnabled
                  ? Hero(tag: productHeroTag(widget.productId), child: image)
                  : image;
            },
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.lg,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: images.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        spacing: 4,
                        activeDotColor: scheme.primary,
                        dotColor: scheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
