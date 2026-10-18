import 'package:equatable/equatable.dart';

/// A product line in the cart. Holds a snapshot of the product's price and
/// stock at the time it was added, so the cart works offline.
class CartItem extends Equatable {
  const CartItem({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountPercentage,
    required this.stock,
    required this.quantity,
  });

  final int productId;
  final String title;
  final String thumbnail;

  /// List price per unit, before the discount.
  final double price;
  final double discountPercentage;
  final int stock;
  final int quantity;

  double get unitPrice => price * (1 - discountPercentage / 100);
  double get subtotal => price * quantity;
  double get total => unitPrice * quantity;

  bool get canIncrement => quantity < stock;
  bool get canDecrement => quantity > 1;

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    title: title,
    thumbnail: thumbnail,
    price: price,
    discountPercentage: discountPercentage,
    stock: stock,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [
    productId,
    title,
    thumbnail,
    price,
    discountPercentage,
    stock,
    quantity,
  ];
}
