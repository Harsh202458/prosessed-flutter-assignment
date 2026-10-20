import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_totals.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopsphere/features/cart/domain/usecases/calculate_cart_totals.dart';
import 'package:shopsphere/features/cart/domain/usecases/place_order.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

part 'cart_state.dart';

/// App-wide cart. Every change is saved to the device so the cart survives
/// a restart.
class CartCubit extends Cubit<CartState> {
  CartCubit({
    required this._repository,
    required this._placeOrder,
    this._calculateTotals = const CalculateCartTotals(),
  }) : super(const CartState());

  final CartRepository _repository;
  final PlaceOrder _placeOrder;
  final CalculateCartTotals _calculateTotals;

  /// Identify which storage problem happened; the UI shows translated text.
  static const String loadErrorMessage = "We couldn't restore your saved cart.";
  static const String saveErrorMessage =
      "Your cart couldn't be saved on this device.";

  Future<void> load() async {
    final result = await _repository.loadCart();
    switch (result) {
      case Success(:final data):
        emit(_withItems(data).copyWith(status: CartStatus.ready));
      case Err():
        emit(
          state.copyWith(
            status: CartStatus.ready,
            storageError: loadErrorMessage,
          ),
        );
    }
  }

  /// Adds [quantity] of [product], capped at the available stock.
  Future<void> add(Product product, int quantity) async {
    if (!product.isInStock || quantity <= 0) return;
    final items = [...state.items];
    final index = items.indexWhere((item) => item.productId == product.id);
    if (index == -1) {
      items.add(
        CartItem(
          productId: product.id,
          title: product.title,
          thumbnail: product.thumbnail,
          price: product.price,
          discountPercentage: product.discountPercentage,
          stock: product.stock,
          quantity: quantity.clamp(1, product.stock),
        ),
      );
    } else {
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: (existing.quantity + quantity).clamp(1, existing.stock),
      );
    }
    await _update(items);
  }

  Future<void> increment(int productId) => _changeQuantity(productId, 1);

  /// Never goes below 1; use [remove] to delete a line.
  Future<void> decrement(int productId) => _changeQuantity(productId, -1);

  Future<void> remove(int productId) => _update([
    for (final item in state.items)
      if (item.productId != productId) item,
  ]);

  /// Puts back a line removed by [remove] (for "Undo").
  Future<void> restore(CartItem item, int index) {
    if (state.items.any((i) => i.productId == item.productId)) {
      return Future.value();
    }
    final items = [...state.items]
      ..insert(index.clamp(0, state.items.length), item);
    return _update(items);
  }

  Future<void> clear() async {
    emit(_withItems(const []));
    await _repository.clearCart();
  }

  Future<void> placeOrder() async {
    if (state.isEmpty || state.isPlacingOrder) return;
    emit(state.copyWith(checkoutStatus: CheckoutStatus.submitting));

    final result = await _placeOrder(state.items);
    switch (result) {
      case Success(:final data):
        emit(
          _withItems(
            const [],
          ).copyWith(checkoutStatus: CheckoutStatus.success, order: data),
        );
      case Err(:final failure):
        emit(
          state.copyWith(
            checkoutStatus: CheckoutStatus.failure,
            checkoutError: failure.message,
          ),
        );
    }
  }

  /// Called once the confirmation screen has been shown.
  void acknowledgeOrder() => emit(
    CartState(
      status: state.status,
      items: state.items,
      totals: state.totals,
    ),
  );

  Future<void> _changeQuantity(int productId, int delta) {
    final items = [
      for (final item in state.items)
        if (item.productId == productId)
          item.copyWith(quantity: (item.quantity + delta).clamp(1, item.stock))
        else
          item,
    ];
    return _update(items);
  }

  CartState _withItems(List<CartItem> items) => state.copyWith(
    items: items,
    totals: _calculateTotals(items),
    checkoutStatus: CheckoutStatus.idle,
  );

  Future<void> _update(List<CartItem> items) async {
    emit(_withItems(items));
    final saved = await _repository.saveCart(items);
    if (saved is Err) emit(state.copyWith(storageError: saveErrorMessage));
  }
}
