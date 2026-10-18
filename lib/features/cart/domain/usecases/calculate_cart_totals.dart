import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_totals.dart';

class CalculateCartTotals {
  const CalculateCartTotals();

  CartTotals call(List<CartItem> items) {
    var subtotal = 0.0;
    var total = 0.0;
    var itemCount = 0;
    for (final item in items) {
      subtotal += item.subtotal;
      total += item.total;
      itemCount += item.quantity;
    }
    return CartTotals(
      subtotal: subtotal,
      discount: subtotal - total,
      total: total,
      itemCount: itemCount,
    );
  }
}
