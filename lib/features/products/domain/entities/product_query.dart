import 'package:equatable/equatable.dart';

enum ProductSort { recommended, priceLowToHigh, priceHighToLow, rating, title }

/// What the product list is currently showing.
///
/// DummyJSON cannot combine search with a category filter, so a non-empty
/// [search] always takes precedence and [categorySlug] is cleared.
class ProductQuery extends Equatable {
  const ProductQuery({
    this.search = '',
    this.categorySlug,
    this.sort = ProductSort.recommended,
  });

  final String search;
  final String? categorySlug;
  final ProductSort sort;

  bool get isSearching => search.isNotEmpty;
  bool get isFiltered => isSearching || categorySlug != null;

  ProductQuery withSearch(String value) =>
      ProductQuery(search: value.trim(), sort: sort);

  ProductQuery withCategory(String? slug) =>
      ProductQuery(categorySlug: slug, sort: sort);

  ProductQuery withSort(ProductSort value) =>
      ProductQuery(search: search, categorySlug: categorySlug, sort: value);

  @override
  List<Object?> get props => [search, categorySlug, sort];
}
