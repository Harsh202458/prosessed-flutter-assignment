import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

extension ProductSortLabel on ProductSort {
  String get label => switch (this) {
    ProductSort.recommended => 'Recommended',
    ProductSort.priceLowToHigh => 'Price: low to high',
    ProductSort.priceHighToLow => 'Price: high to low',
    ProductSort.rating => 'Top rated',
    ProductSort.title => 'Name: A to Z',
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
                child: Text('Sort by', style: theme.textTheme.titleLarge),
              ),
              for (final sort in ProductSort.values)
                ListTile(
                  leading: Icon(sort.icon),
                  title: Text(sort.label),
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
