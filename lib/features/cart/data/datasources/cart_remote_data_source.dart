import 'package:dio/dio.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';
import 'package:shopsphere/core/network/dio_exception_mapper.dart';
import 'package:shopsphere/features/cart/data/models/cart_item_model.dart';

// An interface (not a top-level function) so the repository depends on an
// abstraction and tests can substitute a mock.
// ignore: one_member_abstracts
abstract interface class CartRemoteDataSource {
  /// Returns the id of the simulated order.
  Future<int> placeOrder({
    required int userId,
    required List<CartItemModel> items,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  const CartRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<int> placeOrder({
    required int userId,
    required List<CartItemModel> items,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.addCart,
        data: {
          'userId': userId,
          'products': [
            for (final item in items)
              {'id': item.productId, 'quantity': item.quantity},
          ],
        },
      );
      final id = response.data?['id'];
      if (id is! int) throw const ParseException('Order id missing');
      return id;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
