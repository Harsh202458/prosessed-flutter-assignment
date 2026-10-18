import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// JSON shape of a cart line persisted on the device.
@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required int productId,
    required String title,
    required String thumbnail,
    required double price,
    required double discountPercentage,
    required int stock,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItem item) => CartItemModel(
    productId: item.productId,
    title: item.title,
    thumbnail: item.thumbnail,
    price: item.price,
    discountPercentage: item.discountPercentage,
    stock: item.stock,
    quantity: item.quantity,
  );
}

extension CartItemModelX on CartItemModel {
  CartItem toEntity() => CartItem(
    productId: productId,
    title: title,
    thumbnail: thumbnail,
    price: price,
    discountPercentage: discountPercentage,
    stock: stock,
    quantity: quantity,
  );
}
