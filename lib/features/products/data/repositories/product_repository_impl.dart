import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/datasources/product_local_data_source.dart';
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
  const ProductRepositoryImpl({required this._remote, required this._local});

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  /// Only the unfiltered first page is cached: it's what the user sees on
  /// opening the app, and it keeps the cache small and predictable.
  static bool _isHomePage(ProductQuery query, int skip) =>
      skip == 0 && query == const ProductQuery();

  static bool _isOffline(Failure failure) =>
      failure is NetworkFailure || failure is TimeoutFailure;

  @override
  Future<Result<ProductPage>> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  }) async {
    final cacheable = _isHomePage(query, skip);
    try {
      final page = await _remote.getProducts(
        query: query,
        skip: skip,
        limit: limit,
      );
      if (cacheable) await _ignoreCacheErrors(() => _local.writeHomePage(page));
      return Success(page.toEntity());
    } on Object catch (e) {
      final failure = mapToFailure(e);
      if (cacheable && _isOffline(failure)) {
        final cached = await _ignoreCacheErrors(_local.readHomePage);
        if (cached != null) return Success(_asCached(cached.toEntity()));
      }
      return Err(failure);
    }
  }

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final categories = await _remote.getCategories();
      await _ignoreCacheErrors(() => _local.writeCategories(categories));
      return Success([for (final c in categories) c.toEntity()]);
    } on Object catch (e) {
      final failure = mapToFailure(e);
      if (_isOffline(failure)) {
        final cached = await _ignoreCacheErrors(_local.readCategories);
        if (cached != null) {
          return Success([for (final c in cached) c.toEntity()]);
        }
      }
      return Err(failure);
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final product = await _remote.getProductById(id);
      return Success(product.toEntity());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }

  /// A cached page has no further pages to load while offline.
  static ProductPage _asCached(ProductPage page) => ProductPage(
    products: page.products,
    total: page.products.length,
    skip: 0,
    isFromCache: true,
  );

  /// The cache is a best-effort extra; it must never break a real request.
  static Future<T?> _ignoreCacheErrors<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Object {
      return null;
    }
  }
}
