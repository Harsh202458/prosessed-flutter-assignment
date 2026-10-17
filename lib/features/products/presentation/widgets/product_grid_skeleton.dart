import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_layout.dart';

/// Shimmering placeholder grid shown during the first load. Uses the same
/// geometry as the real grid so nothing jumps when products arrive.
class ProductGridSkeletonSliver extends StatelessWidget {
  const ProductGridSkeletonSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductGridLayout.padding,
      ),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) => SliverGrid.builder(
          gridDelegate: ProductGridLayout.delegate(
            context,
            constraints.crossAxisExtent + ProductGridLayout.padding * 2,
          ),
          itemCount: 8,
          itemBuilder: (_, index) => Semantics(
            label: index == 0 ? 'Loading products' : null,
            child: const AppShimmer(child: _SkeletonCard()),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1, child: ShimmerBox(radius: AppRadius.lg)),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 10, width: 80),
        SizedBox(height: AppSpacing.sm),
        ShimmerBox(height: 14),
        SizedBox(height: AppSpacing.xs),
        ShimmerBox(height: 14, width: 100),
        SizedBox(height: AppSpacing.sm),
        ShimmerBox(height: 18, width: 70),
      ],
    );
  }
}
