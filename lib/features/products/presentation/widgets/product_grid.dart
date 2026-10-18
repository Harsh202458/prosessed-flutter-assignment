import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/widgets/fade_slide_in.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_layout.dart';

/// The loaded products plus the infinite-scroll footer, as slivers.
class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({
    required this.state,
    required this.onProductTap,
    this.selectedProductId,
    super.key,
  });

  final ProductListState state;
  final ValueChanged<Product> onProductTap;
  final int? selectedProductId;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: ProductGridLayout.padding,
          ),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final width =
                  constraints.crossAxisExtent + ProductGridLayout.padding * 2;
              final columns = WindowSize.gridColumns(width);
              return SliverGrid.builder(
                gridDelegate: ProductGridLayout.delegate(context, width),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return FadeSlideIn(
                    key: ValueKey(product.id),
                    delayFactor: (index % columns) * 0.12,
                    child: ProductCard(
                      product: product,
                      selected: product.id == selectedProductId,
                      onTap: () => onProductTap(product),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: _Footer(state: state)),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final ProductListState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(
        dimension: 28,
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    } else if (state.loadMoreError != null) {
      child = Column(
        children: [
          Text(
            state.loadMoreError!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.read<ProductListBloc>().add(
              const ProductListNextPageRequested(),
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      );
    } else if (state.hasReachedEnd) {
      child = Text(
        "You've seen all ${state.products.length} products",
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      child = const SizedBox(height: 28);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Center(child: child),
    );
  }
}
