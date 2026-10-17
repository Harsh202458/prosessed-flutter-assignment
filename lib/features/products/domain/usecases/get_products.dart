import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';

/// Fetches one page of products for a list, search or category query.
class GetProducts {
  const GetProducts(this._repository);

  static const int pageSize = 20;

  final ProductRepository _repository;

  Future<Result<ProductPage>> call({
    required ProductQuery query,
    int skip = 0,
  }) => _repository.getProducts(query: query, skip: skip, limit: pageSize);
}
