import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';

class GetProductDetails {
  const GetProductDetails(this._repository);

  final ProductRepository _repository;

  Future<Result<Product>> call(int id) => _repository.getProductById(id);
}
