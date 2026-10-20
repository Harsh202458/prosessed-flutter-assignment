import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({required this.order, super.key});

  final OrderConfirmation order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _SuccessMark(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    context.l10n.orderPlaced,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.orderThanks,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          _Detail(
                            label: context.l10n.orderNumber,
                            value: '#${order.orderId}',
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _Detail(
                            label: context.l10n.items,
                            value: '${order.itemCount}',
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _Detail(
                            label: context.l10n.total,
                            value: Formatters.price(order.total),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.products),
                      icon: const Icon(Icons.storefront_outlined),
                      label: Text(context.l10n.continueShopping),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A check mark that pops in once, unless the OS asks to reduce motion.
class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mark = Semantics(
      label: context.l10n.orderConfirmed,
      child: CircleAvatar(
        radius: 48,
        backgroundColor: scheme.primaryContainer,
        child: Icon(
          Icons.check_rounded,
          size: 56,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
    if (MediaQuery.disableAnimationsOf(context)) return mark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.elasticOut,
      child: mark,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
