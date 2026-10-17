import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

void main() {
  const product = Product(
    id: 1,
    title: 'Mascara',
    price: 100,
    discountPercentage: 10,
    rating: 4.5,
    stock: 0,
    thumbnail: '',
  );

  test('discountedPrice applies the discount percentage to the list price', () {
    expect(product.discountedPrice, closeTo(90, 0.0001));
    expect(product.hasDiscount, isTrue);
    expect(product.isInStock, isFalse);
  });

  test('ProductPage.hasMore is false once every item has been loaded', () {
    const twenty = [product];
    expect(
      const ProductPage(products: twenty, total: 21, skip: 0).hasMore,
      isTrue,
    );
    expect(
      const ProductPage(products: twenty, total: 21, skip: 20).hasMore,
      isFalse,
    );
  });

  test('searching clears the category, and sort is kept across changes', () {
    const query = ProductQuery(
      categorySlug: 'beauty',
      sort: ProductSort.rating,
    );

    final searched = query.withSearch('  phone ');

    expect(searched.search, 'phone');
    expect(searched.categorySlug, isNull);
    expect(searched.sort, ProductSort.rating);
    expect(searched.withCategory('laptops').isSearching, isFalse);
  });
}
