import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/greeting.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_search_field.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';

/// Greeting header with a pinned search bar and sort button underneath.
class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({
    required this.searchController,
    required this.onSearchChanged,
    required this.sort,
    required this.onSortPressed,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ProductSort sort;
  final VoidCallback onSortPressed;

  static String _greeting(AppLocalizations l10n) =>
      switch (dayPartOf(DateTime.now())) {
        DayPart.morning => l10n.greetingMorning,
        DayPart.afternoon => l10n.greetingAfternoon,
        DayPart.evening => l10n.greetingEvening,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = context.select<ProfileCubit, String?>(
      (cubit) => cubit.state.user?.firstName,
    );
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? s) =>
        scaler.scale(s?.fontSize ?? 14) * (s?.height ?? 1.3);

    final toolbarHeight =
        line(theme.textTheme.bodyMedium) +
        line(theme.textTheme.titleLarge) +
        AppSpacing.md;
    final searchHeight = (AppSpacing.md * 2 + line(theme.textTheme.bodyLarge))
        .clamp(48.0, double.infinity);

    return SliverAppBar(
      pinned: true,
      toolbarHeight: toolbarHeight,
      titleSpacing: AppSpacing.lg,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstName == null
                ? _greeting(context.l10n)
                : context.l10n.greetingWithName(
                    _greeting(context.l10n),
                    firstName,
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            context.l10n.homeHeadline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(searchHeight + AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: ProductSearchField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SortButton(
                isActive: sort != ProductSort.recommended,
                size: searchHeight,
                onPressed: onSortPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.isActive,
    required this.size,
    required this.onPressed,
  });

  final bool isActive;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: size,
      child: IconButton.filled(
        tooltip: context.l10n.sortProducts,
        style: IconButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        onPressed: onPressed,
        icon: Badge(
          isLabelVisible: isActive,
          smallSize: 8,
          backgroundColor: scheme.onPrimary,
          child: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}
