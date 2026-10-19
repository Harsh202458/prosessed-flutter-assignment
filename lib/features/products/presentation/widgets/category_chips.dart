import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';

/// Horizontally scrolling category filter. `null` means "All".
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    required this.selectedSlug,
    required this.onSelected,
    super.key,
  });

  final String? selectedSlug;
  final ValueChanged<String?> onSelected;

  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) => SizedBox(
        height: MediaQuery.textScalerOf(context).scale(_height),
        child: switch (state.status) {
          CategoriesStatus.loading => const _ChipsSkeleton(),
          CategoriesStatus.failure => _list([
            ActionChip(
              avatar: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Couldn't load categories · Retry"),
              onPressed: context.read<CategoriesCubit>().load,
            ),
          ]),
          CategoriesStatus.success => _list([
            _chip(context, 'All', null, Icons.grid_view_rounded),
            for (final c in state.categories)
              _chip(
                context,
                c.name,
                c.slug,
                CategoryStyle.iconFor(c.slug),
                imageUrl: c.imageUrl,
              ),
          ]),
        },
      ),
    );
  }

  /// The photo sits in the label row rather than the chip's avatar slot,
  /// which can't be taller than the label text.
  static const double _imageSize = 28;

  Widget _chip(
    BuildContext context,
    String label,
    String? slug,
    IconData icon, {
    String? imageUrl,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final selected = selectedSlug == slug;
    final iconAvatar = Icon(
      icon,
      size: 18,
      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
    );
    final leading = imageUrl == null
        ? iconAvatar
        : SizedBox.square(
            dimension: _imageSize,
            child: CircleAvatar(
              backgroundColor: AppColors.productPhoto,
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => iconAvatar,
                    errorWidget: (_, _, _) => iconAvatar,
                  ),
                ),
              ),
            ),
          );
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: (_) => onSelected(slug),
    );
  }

  Widget _list(List<Widget> chips) => ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    itemCount: chips.length,
    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
    itemBuilder: (_, i) => Center(child: chips[i]),
  );
}

class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  @override
  Widget build(BuildContext context) => AppShimmer(
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
      itemBuilder: (_, _) => const Center(
        child: ShimmerBox(width: 96, height: 36, radius: AppRadius.xl),
      ),
    ),
  );
}
