import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';

/// "In stock", "Only N left" or "Out of stock", colour-coded.
class StockBadge extends StatelessWidget {
  const StockBadge({required this.stock, super.key});

  final int stock;

  static const int lowStockThreshold = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    final (label, icon, background, foreground) = switch (stock) {
      <= 0 => (
        context.l10n.outOfStock,
        Icons.block_rounded,
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      < lowStockThreshold => (
        context.l10n.stockOnlyLeft(stock),
        Icons.hourglass_bottom_rounded,
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      _ => (
        context.l10n.stockInStock(stock),
        Icons.check_circle_outline_rounded,
        dark ? const Color(0xFF1C3B28) : const Color(0xFFDDF4E4),
        dark ? const Color(0xFF9BE2B4) : const Color(0xFF14592F),
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
