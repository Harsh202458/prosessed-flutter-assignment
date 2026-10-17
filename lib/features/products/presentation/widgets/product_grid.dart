import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_grid_layout.dart';

/// Paginated grid with pull-to-refresh and an infinite-scroll footer.
class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  /// Start loading the next page this far (in dp) before the end.
  static const double _prefetchExtent = 600;

  final _scrollController = ScrollController();

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fillViewport());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // After a failed page, wait for the user to tap Retry instead of
    // re-requesting on every scroll tick.
    if (_bloc.state.loadMoreError != null) return;
    if (_scrollController.position.extentAfter < _prefetchExtent) {
      _bloc.add(const ProductListNextPageRequested());
    }
  }

  /// On tall screens the first page may not be scrollable, so no scroll
  /// event would ever request page two.
  void _fillViewport() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent < _prefetchExtent) {
      _bloc.add(const ProductListNextPageRequested());
    }
  }

  Future<void> _onRefresh() async {
    _bloc.add(const ProductListRefreshed());
    await _bloc.stream.firstWhere(
      (s) => !s.isRefreshing && s.status != ProductListStatus.loading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
      listenWhen: (previous, current) =>
          previous.products.length != current.products.length,
      listener: (_, _) =>
          WidgetsBinding.instance.addPostFrameCallback((_) => _fillViewport()),
      builder: (context, state) => RefreshIndicator(
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) => CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  ProductGridLayout.padding,
                  AppSpacing.sm,
                  ProductGridLayout.padding,
                  0,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: ProductGridLayout.delegate(
                    context,
                    constraints.maxWidth,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) =>
                      ProductCard(product: state.products[index]),
                ),
              ),
              SliverToBoxAdapter(child: _Footer(state: state)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final ProductListState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(
        dimension: 28,
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    } else if (state.loadMoreError != null) {
      child = Column(
        children: [
          Text(
            state.loadMoreError!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => context.read<ProductListBloc>().add(
              const ProductListNextPageRequested(),
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      );
    } else if (state.hasReachedEnd) {
      child = Text(
        "You've seen all ${state.products.length} products",
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      child = const SizedBox(height: 28);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Center(child: child),
    );
  }
}
