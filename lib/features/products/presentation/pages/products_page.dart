import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/breakpoints.dart';
import 'package:shopsphere/core/widgets/app_snack_bar.dart';
import 'package:shopsphere/core/widgets/empty_view.dart';
import 'package:shopsphere/core/widgets/error_view.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_chips.dart';
import 'package:shopsphere/features/products/presentation/widgets/category_style.dart';
import 'package:shopsphere/features/products/presentation/widgets/home_app_bar.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_skeleton.dart';
import 'package:shopsphere/features/products/presentation/widgets/promo_carousel.dart';
import 'package:shopsphere/features/products/presentation/widgets/sort_sheet.dart';

/// Builds the details for [product]; `onClose` dismisses the detail pane.
typedef ProductDetailsBuilder =
    Widget Function(Product product, VoidCallback onClose);

class ProductsPage extends StatefulWidget {
  const ProductsPage({required this.detailsBuilder, super.key});

  /// Used for the detail pane on expanded widths (> 1024 dp). Narrower
  /// screens navigate to a full details page instead.
  final ProductDetailsBuilder detailsBuilder;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  /// Start loading the next page this far (in dp) before the end.
  static const double _prefetchExtent = 600;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  /// Product shown in the detail pane in master-detail mode.
  Product? _selected;

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // After a failed page, wait for Retry instead of re-requesting on every
    // scroll tick.
    if (_bloc.state.loadMoreError != null) return;
    if (_scrollController.position.extentAfter < _prefetchExtent) {
      _bloc.add(const ProductListNextPageRequested());
    }
  }

  /// On tall screens the first page may not scroll, so no scroll event would
  /// ever request page two.
  void _fillViewport() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < _prefetchExtent) {
      _bloc.add(const ProductListNextPageRequested());
    }
  }

  Future<void> _onRefresh() async {
    _bloc.add(const ProductListRefreshed());
    await _bloc.stream.firstWhere(
      (s) => !s.isRefreshing && s.status != ProductListStatus.loading,
    );
  }

  Future<void> _openSort() async {
    final selected = await showSortSheet(context, _bloc.state.query.sort);
    if (selected != null && mounted) _bloc.add(ProductSortChanged(selected));
  }

  void _openProduct(Product product) {
    if (context.windowSize.isExpanded) {
      setState(() => _selected = product);
    } else {
      unawaited(
        context.push(AppRoutes.productDetails(product.id), extra: product),
      );
    }
  }

  /// Picking a category replaces any search (the API can't combine them).
  void _selectCategory(String? slug) {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    _bloc.add(ProductCategorySelected(slug));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductListBloc, ProductListState>(
          listenWhen: (previous, current) =>
              current.refreshError != null &&
              previous.refreshError != current.refreshError,
          listener: (context, state) =>
              showAppSnackBar(context, state.refreshError!),
        ),
        BlocListener<ProductListBloc, ProductListState>(
          listenWhen: (previous, current) =>
              previous.products.length != current.products.length,
          listener: (_, _) => WidgetsBinding.instance.addPostFrameCallback(
            (_) => _fillViewport(),
          ),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: _masterDetail(
            RefreshIndicator(
              onRefresh: _onRefresh,
              edgeOffset: 120,
              child: BlocBuilder<ProductListBloc, ProductListState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.query != current.query ||
                    previous.products != current.products ||
                    previous.isLoadingMore != current.isLoadingMore ||
                    previous.loadMoreError != current.loadMoreError ||
                    previous.hasReachedEnd != current.hasReachedEnd,
                builder: (context, state) => CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    HomeSliverAppBar(
                      searchController: _searchController,
                      onSearchChanged: (text) =>
                          _bloc.add(ProductSearchChanged(text)),
                      sort: state.query.sort,
                      onSortPressed: () => unawaited(_openSort()),
                    ),
                    if (!state.query.isFiltered)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: PromoCarousel(onShop: _selectCategory),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: CategoryChips(
                        selectedSlug: state.query.categorySlug,
                        onSelected: _selectCategory,
                      ),
                    ),
                    SliverToBoxAdapter(child: _SectionTitle(state: state)),
                    ..._content(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// On expanded widths the list shares the screen with a detail pane.
  Widget _masterDetail(Widget list) {
    if (!context.windowSize.isExpanded) return list;
    final selected = _selected;
    return Row(
      children: [
        Expanded(flex: 5, child: list),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          flex: 4,
          child: selected == null
              ? const EmptyView(
                  icon: Icons.touch_app_outlined,
                  title: 'Select a product',
                  message:
                      'Pick any product to see its photos, details and '
                      'reviews here.',
                )
              : KeyedSubtree(
                  key: ValueKey(selected.id),
                  child: widget.detailsBuilder(
                    selected,
                    () => setState(() => _selected = null),
                  ),
                ),
        ),
      ],
    );
  }

  List<Widget> _content(ProductListState state) => switch (state.status) {
    ProductListStatus.initial ||
    ProductListStatus.loading => const [ProductGridSkeletonSliver()],
    ProductListStatus.failure => [
      SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorView(
          title: "Couldn't load products",
          message: state.errorMessage ?? '',
          onRetry: () => _bloc.add(const ProductListStarted()),
        ),
      ),
    ],
    ProductListStatus.empty => [
      SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyResults(
          query: state.query,
          onClearFilters: () => _selectCategory(null),
        ),
      ),
    ],
    ProductListStatus.success => [
      ProductGridSliver(
        state: state,
        onProductTap: _openProduct,
        selectedProductId: context.windowSize.isExpanded ? _selected?.id : null,
      ),
    ],
  };
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.state});

  final ProductListState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = state.query;
    final title = query.isSearching
        ? 'Results for "${query.search}"'
        : query.categorySlug != null
        ? CategoryStyle.labelFor(query.categorySlug!)
        : 'All products';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          if (query.sort != ProductSort.recommended)
            Text(
              query.sort.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
        ],
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
