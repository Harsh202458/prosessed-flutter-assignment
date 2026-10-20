import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/widgets/app_snack_bar.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

/// Heart toggle for saving a product to the wishlist.
///
/// [overlay] draws it as a small disc for placing on a product photo.
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    required this.product,
    this.overlay = false,
    super.key,
  });

  final Product product;
  final bool overlay;

  Future<void> _toggle(BuildContext context) async {
    final cubit = context.read<WishlistCubit>();
    final saved = await cubit.toggle(product);
    if (!context.mounted) return;
    showAppSnackBar(
      context,
      saved ? context.l10n.savedToWishlist : context.l10n.removedFromWishlist,
      actionLabel: saved ? null : context.l10n.undo,
      onAction: saved ? null : () => unawaited(cubit.toggle(product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final saved = context.select<WishlistCubit, bool>(
      (cubit) => cubit.state.contains(product.id),
    );
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final icon = AnimatedSwitcher(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey(saved),
        size: overlay ? 20 : 24,
        color: saved ? scheme.primary : null,
      ),
    );

    return IconButton(
      tooltip: saved
          ? context.l10n.removeFromWishlist
          : context.l10n.saveToWishlist,
      onPressed: () => unawaited(_toggle(context)),
      style: overlay
          ? IconButton.styleFrom(
              backgroundColor: scheme.surface.withValues(alpha: 0.9),
              foregroundColor: scheme.onSurfaceVariant,
              minimumSize: const Size(40, 40),
              fixedSize: const Size(40, 40),
              padding: EdgeInsets.zero,
              // The disc is drawn at 40 dp; the tap area stays 48 dp.
              tapTargetSize: MaterialTapTargetSize.padded,
            )
          : null,
      icon: icon,
    );
  }
}
