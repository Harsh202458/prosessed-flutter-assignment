import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

/// Products the user has saved for later, kept on this device.
abstract interface class WishlistRepository {
  Future<Result<List<Product>>> load();

  Future<Result<void>> save(List<Product> products);

  Future<Result<void>> clear();
}
