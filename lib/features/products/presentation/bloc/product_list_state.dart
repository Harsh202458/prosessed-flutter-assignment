part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, empty, failure }

final class ProductListState extends Equatable {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.query = const ProductQuery(),
    this.hasReachedEnd = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.isShowingCached = false,
    this.errorMessage,
    this.loadMoreError,
    this.refreshError,
  });

  final ProductListStatus status;
  final List<Product> products;
  final ProductQuery query;
  final bool hasReachedEnd;
  final bool isLoadingMore;
  final bool isRefreshing;

  /// The list is the saved copy shown while offline.
  final bool isShowingCached;

  /// Full-screen error when the first page fails.
  final String? errorMessage;

  /// Footer error when a later page fails; existing items stay visible.
  final String? loadMoreError;

  /// Shown as a snackbar when pull-to-refresh fails over existing items.
  final String? refreshError;

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    ProductQuery? query,
    bool? hasReachedEnd,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? isShowingCached,
    String? errorMessage,
    String? loadMoreError,
    String? refreshError,
  }) => ProductListState(
    status: status ?? this.status,
    products: products ?? this.products,
    query: query ?? this.query,
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    isShowingCached: isShowingCached ?? this.isShowingCached,
    // Errors are one-shot: every new state clears them unless set again.
    errorMessage: errorMessage,
    loadMoreError: loadMoreError,
    refreshError: refreshError,
  );

  @override
  List<Object?> get props => [
    status,
    products,
    query,
    hasReachedEnd,
    isLoadingMore,
    isRefreshing,
    isShowingCached,
    errorMessage,
    loadMoreError,
    refreshError,
  ];
}
