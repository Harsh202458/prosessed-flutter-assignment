import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_layout.dart';

/// Shimmering placeholder grid shown during the first load.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading products',
      child: LayoutBuilder(
        builder: (context, constraints) => AppShimmer(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(ProductGridLayout.padding),
            gridDelegate: ProductGridLayout.delegate(
              context,
              constraints.maxWidth,
            ),
            itemCount: 8,
            itemBuilder: (_, _) => const _SkeletonCard(),
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
        ShimmerBox(height: 14),
        SizedBox(height: AppSpacing.xs),
        ShimmerBox(height: 14, width: 90),
        SizedBox(height: AppSpacing.sm),
        ShimmerBox(height: 18, width: 70),
      ],
    );
  }
}
