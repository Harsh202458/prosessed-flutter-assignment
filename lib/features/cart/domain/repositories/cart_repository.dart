import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';

abstract interface class CartRepository {
  /// The cart saved on this device; empty if nothing was saved.
  Future<Result<List<CartItem>>> loadCart();

  Future<Result<void>> saveCart(List<CartItem> items);

  Future<Result<void>> clearCart();

  /// Submits the order and returns the new order id. DummyJSON simulates
  /// this: nothing is stored server-side.
  Future<Result<int>> placeOrder({
    required int userId,
    required List<CartItem> items,
  });
}
