import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/core/widgets/app_button.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_totals.dart';

/// Total and the "Place order" button, optionally preceded by the
/// [CartBreakdown]. On phones the breakdown scrolls with the items and only
/// the total and button stay pinned, keeping the fixed panel short.
class CartSummary extends StatelessWidget {
  const CartSummary({
    required this.totals,
    required this.isPlacingOrder,
    required this.onPlaceOrder,
    this.showBreakdown = true,
    super.key,
  });

  final CartTotals totals;
  final bool isPlacingOrder;
  final VoidCallback onPlaceOrder;
  final bool showBreakdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showBreakdown) ...[
          CartBreakdown(totals: totals),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1),
          ),
        ],
        _Row(
          label: 'Total',
          value: Formatters.price(totals.total),
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: showBreakdown ? AppSpacing.lg : AppSpacing.md),
        AppButton(
          label: 'Place order',
          icon: Icons.lock_outline_rounded,
          isLoading: isPlacingOrder,
          onPressed: onPlaceOrder,
        ),
      ],
    );
  }
}

/// Subtotal, discount and delivery lines, plus the simulated-order note.
class CartBreakdown extends StatelessWidget {
  const CartBreakdown({required this.totals, super.key});

  final CartTotals totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Row(
          label:
              'Subtotal (${totals.itemCount} '
              '${totals.itemCount == 1 ? 'item' : 'items'})',
          value: Formatters.price(totals.subtotal),
        ),
        if (totals.discount > 0.005) ...[
          const SizedBox(height: AppSpacing.sm),
          _Row(
            label: 'Discount',
            value: '−${Formatters.price(totals.discount)}',
            valueColor: scheme.primary,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        const _Row(label: 'Delivery', value: 'Free'),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Orders are simulated by DummyJSON. No payment is taken.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.style,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextStyle? style;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyLarge;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: base?.copyWith(
              color: style == null ? theme.colorScheme.onSurfaceVariant : null,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          value,
          style: base?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
