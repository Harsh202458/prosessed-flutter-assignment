import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final ProductRepository _repository;

  Future<Result<List<Category>>> call() => _repository.getCategories();
}
