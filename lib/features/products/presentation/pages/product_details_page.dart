import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/core/widgets/app_snack_bar.dart';
import 'package:shopsphere/core/widgets/error_view.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:shopsphere/features/products/presentation/widgets/add_to_cart_bar.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_image_carousel.dart';
import 'package:shopsphere/features/products/presentation/widgets/rating_view.dart';
import 'package:shopsphere/features/products/presentation/widgets/review_tile.dart';
import 'package:shopsphere/features/products/presentation/widgets/stock_badge.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.productId, this.preview, super.key});

  final int? productId;

  /// The list item that was tapped, shown instantly while the full product
  /// loads so the Hero animation has something to land on.
  final Product? preview;

  void _addToCart(BuildContext context, ProductDetailsState state) {
    final product = state.product!;
    final quantity = state.quantity;
    unawaited(context.read<CartCubit>().add(product, quantity));
    context.read<ProductDetailsCubit>().resetQuantity();
    showAppSnackBar(
      context,
      'Added $quantity × ${product.title} to your cart',
      actionLabel: 'View cart',
      onAction: () => context.go(AppRoutes.cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          productId != null &&
          previous.quantityOf(productId!) != current.quantityOf(productId!),
      listener: (context, cart) => context
          .read<ProductDetailsCubit>()
          .syncCartQuantity(cart.quantityOf(productId!)),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          final cubit = context.read<ProductDetailsCubit>();
          return Scaffold(
            appBar: AppBar(),
            body: switch (state.status) {
              ProductDetailsStatus.loading => _DetailsLayout(
                product: preview,
                isLoading: true,
              ),
              ProductDetailsStatus.success => _DetailsLayout(
                product: state.product,
              ),
              ProductDetailsStatus.notFound => ErrorView(
                icon: Icons.search_off_rounded,
                title: 'Product not found',
                message:
                    "This product doesn't exist or is no longer available.",
                actionLabel: 'Back to shop',
                onRetry: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.products),
              ),
              ProductDetailsStatus.failure => ErrorView(
                title: "Couldn't load this product",
                message: state.errorMessage ?? '',
                onRetry: () => cubit.load(productId),
              ),
            },
            bottomNavigationBar: state.status == ProductDetailsStatus.success
                ? AddToCartBar(
                    state: state,
                    onDecrement: cubit.decrement,
                    onIncrement: cubit.increment,
                    onAddToCart: () => _addToCart(context, state),
                  )
                : null,
          );
        },
      ),
    );
  }
}

/// Image and info stacked on phones, side by side on wide screens.
class _DetailsLayout extends StatelessWidget {
  const _DetailsLayout({required this.product, this.isLoading = false});

  final Product? product;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product == null) return const _DetailsSkeleton();

    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];
    final gallery = isLoading
        ? Hero(
            tag: productHeroTag(product.id),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ProductImage(url: product.thumbnail),
              ),
            ),
          )
        : ProductImageCarousel(
            productId: product.id,
            images: images,
            title: product.title,
          );
    final info = _ProductInfo(product: product, isLoading: isLoading);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= WindowSize.expandedMin ||
            (constraints.maxWidth >= WindowSize.mediumMin &&
                constraints.maxWidth > constraints.maxHeight);
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    0,
                    AppSpacing.lg,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    child: gallery,
                  ),
                ),
              ),
              Expanded(child: SingleChildScrollView(child: info)),
            ],
          );
        }
        return ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: gallery,
                ),
              ),
            ),
            info,
          ],
        );
      },
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.isLoading});

  final Product product;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = [
      if (product.category.isNotEmpty) CategoryStyle.labelFor(product.category),
      if (product.brand != null) product.brand!,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          Text(product.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              RatingView(
                rating: product.rating,
                style: theme.textTheme.titleSmall,
              ),
              if (!isLoading) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${product.reviews.length} '
                  '${product.reviews.length == 1 ? 'review' : 'reviews'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                Formatters.price(product.discountedPrice),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: scheme.primary,
                ),
              ),
              if (product.hasDiscount) ...[
                Text(
                  Formatters.price(product.price),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      'Save ${product.discountPercentage.round()}%',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          StockBadge(stock: product.stock),
          const SizedBox(height: AppSpacing.xl),
          if (isLoading)
            const AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14),
                  SizedBox(height: AppSpacing.sm),
                  ShimmerBox(height: 14),
                  SizedBox(height: AppSpacing.sm),
                  ShimmerBox(height: 14, width: 180),
                ],
              ),
            )
          else ...[
            Text('Description', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.description.isEmpty
                  ? 'No description available.'
                  : product.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Customer reviews',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (product.reviews.isEmpty)
              Text(
                'No reviews yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              for (final review in product.reviews) ...[
                ReviewTile(review: review),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ],
      ),
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading product',
      child: AppShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            AspectRatio(
              aspectRatio: 1,
              child: ShimmerBox(radius: AppRadius.xl),
            ),
            SizedBox(height: AppSpacing.xl),
            ShimmerBox(height: 12, width: 120),
            SizedBox(height: AppSpacing.sm),
            ShimmerBox(height: 24),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(height: 32, width: 140),
          ],
        ),
      ),
    );
  }
}
