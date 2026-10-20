import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/core/widgets/quantity_selector.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';

/// Bottom bar with the quantity stepper and the add-to-cart button. The
/// button is disabled when the product is out of stock, or when the cart
/// already holds every unit in stock.
class AddToCartBar extends StatelessWidget {
  const AddToCartBar({
    required this.state,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
    super.key,
  });

  final ProductDetailsState state;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final product = state.product!;
    final total = product.discountedPrice * state.quantity;

    final (String label, IconData icon) = switch (state) {
      _ when !product.isInStock => (
        l10n.outOfStock,
        Icons.remove_shopping_cart_outlined,
      ),
      _ when !state.canAdd => (
        l10n.allInCart,
        Icons.shopping_cart_checkout_rounded,
      ),
      _ => (
        l10n.addWithTotal(Formatters.price(total)),
        Icons.add_shopping_cart_rounded,
      ),
    };

    return Material(
      color: theme.colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.inCart > 0) ...[
                Text(
                  state.canAdd
                      ? l10n.inCartMoreAvailable(state.inCart, state.available)
                      : l10n.allStockInCart(product.stock),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              Row(
                children: [
                  if (state.canAdd) ...[
                    QuantitySelector(
                      quantity: state.quantity,
                      onDecrement: state.canDecrement ? onDecrement : null,
                      onIncrement: state.canIncrement ? onIncrement : null,
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.canAdd ? onAddToCart : null,
                      icon: Icon(icon),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(label),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
