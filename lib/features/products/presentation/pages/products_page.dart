import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';
import 'package:shopsphere/core/widgets/error_view.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_chips.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_skeleton.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_search_field.dart';
import 'package:shopsphere/features/products/presentation/widgets/sort_sheet.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _searchController = TextEditingController();

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openSort() async {
    final selected = await showSortSheet(context, _bloc.state.query.sort);
    if (selected != null && mounted) _bloc.add(ProductSortChanged(selected));
  }

  /// Picking a category replaces any search (the API can't combine them).
  void _selectCategory(String? slug) {
    _searchController.clear();
    _bloc.add(ProductCategorySelected(slug));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        actions: [
          BlocSelector<ProductListBloc, ProductListState, ProductSort>(
            selector: (state) => state.query.sort,
            builder: (context, sort) => IconButton(
              tooltip: 'Sort products',
              onPressed: () => unawaited(_openSort()),
              icon: Badge(
                isLabelVisible: sort != ProductSort.recommended,
                smallSize: 8,
                child: const Icon(Icons.swap_vert_rounded),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocListener<ProductListBloc, ProductListState>(
        listenWhen: (previous, current) =>
            current.refreshError != null &&
            previous.refreshError != current.refreshError,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.refreshError!))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: ProductSearchField(
                controller: _searchController,
                onChanged: (text) => _bloc.add(ProductSearchChanged(text)),
              ),
            ),
            BlocSelector<ProductListBloc, ProductListState, String?>(
              selector: (state) => state.query.categorySlug,
              builder: (context, slug) => CategoryChips(
                selectedSlug: slug,
                onSelected: _selectCategory,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.query != current.query,
                builder: (context, state) => switch (state.status) {
                  ProductListStatus.initial ||
                  ProductListStatus.loading => const ProductGridSkeleton(),
                  ProductListStatus.failure => ErrorView(
                    title: "Couldn't load products",
                    message: state.errorMessage ?? '',
                    onRetry: () => _bloc.add(const ProductListStarted()),
                  ),
                  ProductListStatus.empty => _EmptyResults(
                    query: state.query,
                    onClearFilters: () => _selectCategory(null),
                  ),
                  ProductListStatus.success => const ProductGrid(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query, required this.onClearFilters});

  final ProductQuery query;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      icon: Icons.search_off_rounded,
      title: 'No products found',
      message: query.isSearching
          ? 'Nothing matches "${query.search}". Try a different search.'
          : 'There are no products here yet.',
      action: query.isFiltered
          ? OutlinedButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Clear filters'),
            )
          : null,
    );
  }
}
