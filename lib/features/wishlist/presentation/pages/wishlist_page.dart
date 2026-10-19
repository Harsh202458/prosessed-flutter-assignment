import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_layout.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shopsphere/features/wishlist/presentation/widgets/wishlist_button.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        final count = state.products.length;
        return Scaffold(
          appBar: AppBar(
            title: Text(count == 0 ? 'Wishlist' : 'Wishlist ($count)'),
          ),
          body: count == 0
              ? EmptyView(
                  icon: Icons.favorite_border_rounded,
                  title: 'Your wishlist is empty',
                  message: 'Tap the heart on any product to save it here.',
                  action: FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.products),
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Browse products'),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        ProductGridLayout.padding,
                        AppSpacing.sm,
                        ProductGridLayout.padding,
                        AppSpacing.xxl,
                      ),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) => SliverGrid.builder(
                          gridDelegate: ProductGridLayout.delegate(
                            context,
                            constraints.crossAxisExtent +
                                ProductGridLayout.padding * 2,
                          ),
                          itemCount: count,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ProductCard(
                              key: ValueKey(product.id),
                              product: product,
                              trailingAction: WishlistButton(
                                product: product,
                                overlay: true,
                              ),
                              onTap: () => unawaited(
                                context.push(
                                  AppRoutes.wishlistProduct(product.id),
                                  extra: product,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
