import 'package:equatable/equatable.dart';

class CartTotals extends Equatable {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.itemCount,
  });

  static const CartTotals empty = CartTotals(
    subtotal: 0,
    discount: 0,
    total: 0,
    itemCount: 0,
  );

  /// Sum of list prices × quantities.
  final double subtotal;

  /// How much the discounts save in total.
  final double discount;

  /// What the customer pays: [subtotal] − [discount].
  final double total;

  /// Total units across all lines (what the cart badge shows).
  final int itemCount;

  @override
  List<Object?> get props => [subtotal, discount, total, itemCount];
}
