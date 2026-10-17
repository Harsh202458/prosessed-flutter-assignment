import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

abstract interface class ProductRepository {
  Future<Result<ProductPage>> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  });

  Future<Result<List<Category>>> getCategories();

  /// Full product with images and reviews. Fails with `NotFoundFailure`
  /// when the id doesn't exist (HTTP 404).
  Future<Result<Product>> getProductById(int id);
}
