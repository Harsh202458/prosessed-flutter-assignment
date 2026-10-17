import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<Result<ProductPage>> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  }) => _guard(() async {
    final page = await _remote.getProducts(
      query: query,
      skip: skip,
      limit: limit,
    );
    return page.toEntity();
  });

  @override
  Future<Result<List<Category>>> getCategories() => _guard(() async {
    final categories = await _remote.getCategories();
    return [for (final c in categories) c.toEntity()];
  });

  @override
  Future<Result<Product>> getProductById(int id) => _guard(() async {
    final product = await _remote.getProductById(id);
    return product.toEntity();
  });

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }
}
