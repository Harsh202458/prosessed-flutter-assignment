import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/features/cart/data/models/cart_item_model.dart';

abstract interface class CartLocalDataSource {
  Future<List<CartItemModel>> readCart();

  Future<void> writeCart(List<CartItemModel> items);

  Future<void> clearCart();
}

/// Stores the cart as one JSON string in a Hive box, which keeps the format
/// readable and avoids generated Hive type adapters.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  const CartLocalDataSourceImpl(this._box);

  static const String boxName = 'cart';
  static const String _itemsKey = 'items';

  final Box<String> _box;

  @override
  Future<List<CartItemModel>> readCart() async {
    try {
      final raw = _box.get(_itemsKey);
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in list)
          CartItemModel.fromJson(item as Map<String, dynamic>),
      ];
    } on Object catch (e) {
      throw CacheException('Could not read the saved cart: $e');
    }
  }

  @override
  Future<void> writeCart(List<CartItemModel> items) async {
    try {
      await _box.put(
        _itemsKey,
        jsonEncode([for (final item in items) item.toJson()]),
      );
    } on Object catch (e) {
      throw CacheException('Could not save the cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _box.delete(_itemsKey);
    } on Object catch (e) {
      throw CacheException('Could not clear the cart: $e');
    }
  }
}
