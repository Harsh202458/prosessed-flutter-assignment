import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/shimmer_box.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';

/// Horizontally scrolling category filter. `null` means "All".
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    required this.selectedSlug,
    required this.onSelected,
    super.key,
  });

  final String? selectedSlug;
  final ValueChanged<String?> onSelected;

  static const double _height = 48;

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
            _chip('All', null),
            for (final c in state.categories) _chip(c.name, c.slug),
          ]),
        },
      ),
    );
  }

  Widget _chip(String label, String? slug) => ChoiceChip(
    label: Text(label),
    selected: selectedSlug == slug,
    onSelected: (_) => onSelected(slug),
  );

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
        child: ShimmerBox(width: 84, height: 32, radius: AppRadius.xl),
      ),
    ),
  );
}
