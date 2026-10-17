import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/core/widgets/quantity_selector.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';

/// Bottom bar with the quantity stepper and the add-to-cart button. The
/// button is disabled when the product is out of stock.
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
    final product = state.product!;
    final inStock = product.isInStock;
    final total = product.discountedPrice * state.quantity;

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              if (inStock) ...[
                QuantitySelector(
                  quantity: state.quantity,
                  onDecrement: state.canDecrement ? onDecrement : null,
                  onIncrement: state.canIncrement ? onIncrement : null,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: inStock ? onAddToCart : null,
                  icon: Icon(
                    inStock
                        ? Icons.add_shopping_cart_rounded
                        : Icons.remove_shopping_cart_outlined,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      inStock
                          ? 'Add · ${Formatters.price(total)}'
                          : 'Out of stock',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
