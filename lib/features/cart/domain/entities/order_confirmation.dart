import 'package:equatable/equatable.dart';

class OrderConfirmation extends Equatable {
  const OrderConfirmation({
    required this.orderId,
    required this.itemCount,
    required this.total,
  });

  final int orderId;
  final int itemCount;

  /// The total the customer saw in their cart when placing the order.
  final double total;

  @override
  List<Object?> get props => [orderId, itemCount, total];
}
