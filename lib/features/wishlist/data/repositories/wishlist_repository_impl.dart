import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:shopsphere/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  const WishlistRepositoryImpl(this._local);

  final WishlistLocalDataSource _local;

  @override
  Future<Result<List<Product>>> load() => _guard(() async {
    final products = await _local.read();
    return [for (final p in products) p.toEntity()];
  });

  @override
  Future<Result<void>> save(List<Product> products) =>
      _guard(() => _local.write([for (final p in products) _toModel(p)]));

  @override
  Future<Result<void>> clear() => _guard(_local.clear);

  /// Only what a product card needs; details are fetched fresh when opened.
  static ProductModel _toModel(Product p) => ProductModel(
    id: p.id,
    title: p.title,
    price: p.price,
    discountPercentage: p.discountPercentage,
    rating: p.rating,
    stock: p.stock,
    thumbnail: p.thumbnail,
    category: p.category,
    brand: p.brand,
  );

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }
}
