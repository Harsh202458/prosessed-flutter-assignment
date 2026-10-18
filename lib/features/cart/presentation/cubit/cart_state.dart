part of 'cart_cubit.dart';

enum CartStatus { loading, ready }

enum CheckoutStatus { idle, submitting, success, failure }

final class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.loading,
    this.items = const [],
    this.totals = CartTotals.empty,
    this.checkoutStatus = CheckoutStatus.idle,
    this.order,
    this.checkoutError,
    this.storageError,
  });

  final CartStatus status;
  final List<CartItem> items;
  final CartTotals totals;
  final CheckoutStatus checkoutStatus;

  /// Set once an order succeeds, for the confirmation screen.
  final OrderConfirmation? order;
  final String? checkoutError;

  /// One-shot notice when the cart couldn't be read from or saved to the
  /// device. The in-memory cart keeps working either way.
  final String? storageError;

  bool get isEmpty => items.isEmpty;
  bool get isPlacingOrder => checkoutStatus == CheckoutStatus.submitting;

  int quantityOf(int productId) => items
      .where((item) => item.productId == productId)
      .fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    CartTotals? totals,
    CheckoutStatus? checkoutStatus,
    OrderConfirmation? order,
    String? checkoutError,
    String? storageError,
  }) => CartState(
    status: status ?? this.status,
    items: items ?? this.items,
    totals: totals ?? this.totals,
    checkoutStatus: checkoutStatus ?? this.checkoutStatus,
    order: order ?? this.order,
    checkoutError: checkoutError,
    storageError: storageError,
  );

  @override
  List<Object?> get props => [
    status,
    items,
    totals,
    checkoutStatus,
    order,
    checkoutError,
    storageError,
  ];
}
