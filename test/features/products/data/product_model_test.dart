import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  test('parses a paginated list response built with select=', () {
    final page = ProductPageModel.fromJson(
      fixture('products_page.json'),
    ).toEntity();

    expect(page.products, hasLength(2));
    expect(page.total, greaterThan(page.products.length));
    expect(page.hasMore, isTrue);
    expect(page.products.first.description, isEmpty);
  });

  test('parses a full product with images and reviews', () {
    final product = ProductModel.fromJson(
      fixture('product_detail.json'),
    ).toEntity();

    expect(product.id, 1);
    expect(product.brand, 'Essence');
    expect(product.images, isNotEmpty);
    expect(product.reviews, isNotEmpty);
    expect(product.reviews.first.date, isNotNull);
  });

  test('treats a missing brand as null', () {
    final product = ProductModel.fromJson(
      fixture('product_no_brand.json'),
    ).toEntity();

    expect(product.brand, isNull);
  });

  test('parses the category list', () {
    final json =
        jsonDecode(File('test/fixtures/categories.json').readAsStringSync())
            as List<dynamic>;
    final categories = [
      for (final c in json)
        CategoryModel.fromJson(c as Map<String, dynamic>).toEntity(),
    ];

    expect(categories.first.slug, 'beauty');
    expect(categories.first.name, 'Beauty');
  });
}
