import 'package:flutter/widgets.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';

/// Shared grid geometry for the product grid and its skeleton, so the
/// placeholders line up exactly with the real cards.
abstract final class ProductGridLayout {
  static const double padding = AppSpacing.lg;
  static const double spacing = AppSpacing.md;

  static SliverGridDelegate delegate(BuildContext context, double width) {
    final columns = WindowSize.gridColumns(width);
    final tileWidth = (width - padding * 2 - spacing * (columns - 1)) / columns;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      mainAxisExtent: ProductCard.extentFor(context, tileWidth),
    );
  }
}
