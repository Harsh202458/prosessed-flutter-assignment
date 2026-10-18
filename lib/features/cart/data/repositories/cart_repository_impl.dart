import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:shopsphere/features/cart/data/models/cart_item_model.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl({required this._local, required this._remote});

  final CartLocalDataSource _local;
  final CartRemoteDataSource _remote;

  @override
  Future<Result<List<CartItem>>> loadCart() => _guard(() async {
    final items = await _local.readCart();
    return [for (final item in items) item.toEntity()];
  });

  @override
  Future<Result<void>> saveCart(List<CartItem> items) => _guard(
    () => _local.writeCart([
      for (final item in items) CartItemModel.fromEntity(item),
    ]),
  );

  @override
  Future<Result<void>> clearCart() => _guard(_local.clearCart);

  @override
  Future<Result<int>> placeOrder({
    required int userId,
    required List<CartItem> items,
  }) => _guard(
    () => _remote.placeOrder(
      userId: userId,
      items: [for (final item in items) CartItemModel.fromEntity(item)],
    ),
  );

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }
}
