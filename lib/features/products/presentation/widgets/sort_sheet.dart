import 'package:flutter/material.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

extension ProductSortLabel on ProductSort {
  String label(AppLocalizations l10n) => switch (this) {
    ProductSort.recommended => l10n.sortRecommended,
    ProductSort.priceLowToHigh => l10n.sortPriceLowHigh,
    ProductSort.priceHighToLow => l10n.sortPriceHighLow,
    ProductSort.rating => l10n.sortTopRated,
    ProductSort.title => l10n.sortNameAZ,
  };

  IconData get icon => switch (this) {
    ProductSort.recommended => Icons.auto_awesome_outlined,
    ProductSort.priceLowToHigh => Icons.trending_up_rounded,
    ProductSort.priceHighToLow => Icons.trending_down_rounded,
    ProductSort.rating => Icons.star_outline_rounded,
    ProductSort.title => Icons.sort_by_alpha_rounded,
  };
}

/// Shows the sort options and resolves to the chosen one, or `null` if
/// dismissed.
Future<ProductSort?> showSortSheet(BuildContext context, ProductSort current) {
  return showModalBottomSheet<ProductSort>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.sm,
                ),
                child: Text(
                  context.l10n.sortBy,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              for (final sort in ProductSort.values)
                ListTile(
                  leading: Icon(sort.icon),
                  title: Text(sort.label(context.l10n)),
                  selected: sort == current,
                  trailing: sort == current
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () => Navigator.of(context).pop(sort),
                ),
            ],
          ),
        ),
      );
    },
  );
}
