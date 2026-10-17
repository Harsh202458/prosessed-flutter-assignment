import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              _chip(context, c.name, c.slug, CategoryStyle.iconFor(c.slug)),
          ]),
        },
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    String? slug,
    IconData icon,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final selected = selectedSlug == slug;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
      ),
      label: Text(label),
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
