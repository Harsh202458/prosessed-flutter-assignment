import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';

/// Last successfully fetched home page of products and the category list,
/// so the shop still shows something when the device is offline.
abstract interface class ProductLocalDataSource {
  Future<ProductPageModel?> readHomePage();

  Future<void> writeHomePage(ProductPageModel page);

  Future<List<CategoryModel>?> readCategories();

  Future<void> writeCategories(List<CategoryModel> categories);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  const ProductLocalDataSourceImpl(this._box);

  static const String boxName = 'products_cache';
  static const String _homePageKey = 'home_page';
  static const String _categoriesKey = 'categories';

  final Box<String> _box;

  @override
  Future<ProductPageModel?> readHomePage() async {
    final raw = _read(_homePageKey);
    if (raw == null) return null;
    return _guard(
      () => ProductPageModel.fromJson(jsonDecode(raw) as Map<String, dynamic>),
    );
  }

  @override
  Future<void> writeHomePage(ProductPageModel page) =>
      _write(_homePageKey, jsonEncode(page.toJson()));

  @override
  Future<List<CategoryModel>?> readCategories() async {
    final raw = _read(_categoriesKey);
    if (raw == null) return null;
    return _guard(
      () => [
        for (final item in jsonDecode(raw) as List<dynamic>)
          CategoryModel.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  @override
  Future<void> writeCategories(List<CategoryModel> categories) => _write(
    _categoriesKey,
    jsonEncode([for (final c in categories) c.toJson()]),
  );

  String? _read(String key) => _guard(() => _box.get(key));

  Future<void> _write(String key, String value) async {
    try {
      await _box.put(key, value);
    } on Object catch (e) {
      throw CacheException('Could not cache $key: $e');
    }
  }

  T _guard<T>(T Function() action) {
    try {
      return action();
    } on Object catch (e) {
      throw CacheException('Could not read the product cache: $e');
    }
  }
}
