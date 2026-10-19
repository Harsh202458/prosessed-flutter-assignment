import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';

/// Stores the wishlist as one JSON string in a Hive box, newest first.
abstract interface class WishlistLocalDataSource {
  Future<List<ProductModel>> read();

  Future<void> write(List<ProductModel> products);

  Future<void> clear();
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  const WishlistLocalDataSourceImpl(this._box);

  static const String boxName = 'wishlist';
  static const String _key = 'products';

  final Box<String> _box;

  @override
  Future<List<ProductModel>> read() async {
    try {
      final raw = _box.get(_key);
      if (raw == null || raw.isEmpty) return const [];
      return [
        for (final item in jsonDecode(raw) as List<dynamic>)
          ProductModel.fromJson(item as Map<String, dynamic>),
      ];
    } on Object catch (e) {
      throw CacheException('Could not read the wishlist: $e');
    }
  }

  @override
  Future<void> write(List<ProductModel> products) async {
    try {
      await _box.put(
        _key,
        jsonEncode([for (final p in products) p.toJson()]),
      );
    } on Object catch (e) {
      throw CacheException('Could not save the wishlist: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _box.delete(_key);
    } on Object catch (e) {
      throw CacheException('Could not clear the wishlist: $e');
    }
  }
}
