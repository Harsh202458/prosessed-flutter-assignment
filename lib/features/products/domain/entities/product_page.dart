import 'package:equatable/equatable.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

/// One page of results from a paginated product endpoint.
class ProductPage extends Equatable {
  const ProductPage({
    required this.products,
    required this.total,
    required this.skip,
    this.isFromCache = false,
  });

  final List<Product> products;
  final int total;
  final int skip;

  /// Served from the on-device cache because the network was unavailable.
  final bool isFromCache;

  bool get hasMore => skip + products.length < total;

  @override
  List<Object?> get props => [products, total, skip, isFromCache];
}
