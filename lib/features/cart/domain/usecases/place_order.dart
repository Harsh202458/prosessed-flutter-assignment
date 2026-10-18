import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopsphere/features/cart/domain/usecases/calculate_cart_totals.dart';

/// Places an order for the signed-in user and clears the saved cart.
class PlaceOrder {
  const PlaceOrder({
    required this._cartRepository,
    required this._authRepository,
    this._calculateTotals = const CalculateCartTotals(),
  });

  final CartRepository _cartRepository;
  final AuthRepository _authRepository;
  final CalculateCartTotals _calculateTotals;

  Future<Result<OrderConfirmation>> call(List<CartItem> items) async {
    if (items.isEmpty) {
      return const Err(BadRequestFailure('Your cart is empty.'));
    }

    final int userId;
    switch (await _authRepository.getCurrentUser()) {
      case Success(:final data):
        userId = data.id;
      case Err(:final failure):
        return Err(failure);
    }

    final int orderId;
    switch (await _cartRepository.placeOrder(userId: userId, items: items)) {
      case Success(:final data):
        orderId = data;
      case Err(:final failure):
        return Err(failure);
    }

    // The order went through; failing to clear local storage shouldn't turn
    // that into an error for the user.
    await _cartRepository.clearCart();

    final totals = _calculateTotals(items);
    return Success(
      OrderConfirmation(
        orderId: orderId,
        itemCount: totals.itemCount,
        total: totals.total,
      ),
    );
  }
}
