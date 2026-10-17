part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// First load, and "Retry" after a full-screen error.
final class ProductListStarted extends ProductListEvent {
  const ProductListStarted();
}

/// Pull-to-refresh: reloads page one while keeping the current items visible.
final class ProductListRefreshed extends ProductListEvent {
  const ProductListRefreshed();
}

/// The user scrolled near the end of the list.
final class ProductListNextPageRequested extends ProductListEvent {
  const ProductListNextPageRequested();
}

final class ProductSearchChanged extends ProductListEvent {
  const ProductSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// `null` selects "All".
final class ProductCategorySelected extends ProductListEvent {
  const ProductCategorySelected(this.slug);

  final String? slug;

  @override
  List<Object?> get props => [slug];
}

final class ProductSortChanged extends ProductListEvent {
  const ProductSortChanged(this.sort);

  final ProductSort sort;

  @override
  List<Object?> get props => [sort];
}
