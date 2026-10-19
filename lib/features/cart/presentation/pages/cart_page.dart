import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/widgets/app_snack_bar.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:shopsphere/features/cart/presentation/widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _remove(BuildContext context, CartItem item) {
    final cubit = context.read<CartCubit>();
    final index = cubit.state.items.indexOf(item);
    unawaited(cubit.remove(item.productId));
    showAppSnackBar(
      context,
      'Removed ${item.title}',
      actionLabel: 'Undo',
      onAction: () => unawaited(cubit.restore(item, index)),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final cubit = context.read<CartCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear your cart?'),
        content: const Text('This removes every item from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear cart'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.checkoutStatus != current.checkoutStatus ||
          (current.storageError != null &&
              previous.storageError != current.storageError),
      listener: (context, state) {
        final cubit = context.read<CartCubit>();
        if (state.checkoutStatus == CheckoutStatus.success &&
            state.order != null) {
          hideAppSnackBar(context);
          unawaited(
            context.push(AppRoutes.orderConfirmation, extra: state.order),
          );
          cubit.acknowledgeOrder();
        } else if (state.checkoutStatus == CheckoutStatus.failure) {
          showAppSnackBar(
            context,
            "Couldn't place your order. ${state.checkoutError ?? ''}",
            actionLabel: 'Retry',
            onAction: () => unawaited(cubit.placeOrder()),
          );
        } else if (state.storageError != null) {
          showAppSnackBar(context, state.storageError!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            actions: [
              if (!state.isEmpty)
                TextButton(
                  onPressed: state.isPlacingOrder
                      ? null
                      : () => unawaited(_confirmClear(context)),
                  child: const Text('Clear'),
                ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: switch (state) {
            CartState(status: CartStatus.loading) => const Center(
              child: CircularProgressIndicator(),
            ),
            CartState(isEmpty: true) => EmptyView(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Browse the shop and add something you love.',
              action: FilledButton.icon(
                onPressed: () => context.go(AppRoutes.products),
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Start shopping'),
              ),
            ),
            _ => _CartContent(
              state: state,
              onRemove: (item) => _remove(context, item),
            ),
          },
        );
      },
    );
  }
}

/// Items with the summary below on phones, or beside them on wide screens.
class _CartContent extends StatelessWidget {
  const _CartContent({required this.state, required this.onRemove});

  final CartState state;
  final ValueChanged<CartItem> onRemove;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final scheme = Theme.of(context).colorScheme;

    Widget list({Widget? footer}) => ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      itemCount: state.items.length + (footer == null ? 0 : 1),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == state.items.length) return footer;
        final item = state.items[index];
        return CartItemTile(
          key: ValueKey(item.productId),
          item: item,
          onIncrement: () => unawaited(cubit.increment(item.productId)),
          onDecrement: () => unawaited(cubit.decrement(item.productId)),
          onRemove: () => onRemove(item),
        );
      },
    );
    void placeOrder() {
      hideAppSnackBar(context);
      unawaited(cubit.placeOrder());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= WindowSize.expandedMin ||
            (constraints.maxWidth >= WindowSize.mediumMin &&
                constraints.maxWidth > constraints.maxHeight);
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: list()),
              SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: CartSummary(
                        totals: state.totals,
                        isPlacingOrder: state.isPlacingOrder,
                        onPlaceOrder: placeOrder,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        // Phones: the breakdown scrolls with the items; only the total and
        // the button stay pinned, so the fixed panel stays short.
        return Column(
          children: [
            Expanded(
              child: list(
                footer: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: CartBreakdown(totals: state.totals),
                  ),
                ),
              ),
            ),
            Material(
              color: scheme.surfaceContainer,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: CartSummary(
                    totals: state.totals,
                    isPlacingOrder: state.isPlacingOrder,
                    onPlaceOrder: placeOrder,
                    showBreakdown: false,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
