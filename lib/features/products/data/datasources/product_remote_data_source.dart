import 'package:dio/dio.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';
import 'package:shopsphere/core/network/dio_exception_mapper.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

abstract interface class ProductRemoteDataSource {
  Future<ProductPageModel> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  });

  Future<List<CategoryModel>> getCategories();

  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Only the fields a product card needs, to keep list payloads small.
  static const String listFields =
      'title,price,discountPercentage,rating,stock,brand,thumbnail,category';

  @override
  Future<ProductPageModel> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  }) async {
    final path = query.isSearching
        ? ApiEndpoints.productSearch
        : query.categorySlug != null
        ? ApiEndpoints.productsByCategory(query.categorySlug!)
        : ApiEndpoints.products;

    final json = await _get<Map<String, dynamic>>(
      path,
      {
        if (query.isSearching) 'q': query.search,
        'limit': limit,
        'skip': skip,
        'select': listFields,
        ..._sortParams(query.sort),
      },
    );
    return ProductPageModel.fromJson(json);
  }

  /// Categories with a representative photo each. The photos come from a
  /// single lightweight request (every product's category and thumbnail);
  /// if it fails the categories are still returned, just without images.
  @override
  Future<List<CategoryModel>> getCategories() async {
    final (json, thumbnails) = await (
      _get<List<dynamic>>(ApiEndpoints.categories),
      _categoryThumbnails(),
    ).wait;
    return [
      for (final item in json)
        CategoryModel.fromJson(item as Map<String, dynamic>),
    ].map((c) => c.copyWith(imageUrl: thumbnails[c.slug])).toList();
  }

  Future<Map<String, String>> _categoryThumbnails() async {
    try {
      final json = await _get<Map<String, dynamic>>(
        ApiEndpoints.products,
        const {'limit': 0, 'select': 'category,thumbnail'},
      );
      final thumbnails = <String, String>{};
      for (final item in json['products'] as List<dynamic>) {
        final product = item as Map<String, dynamic>;
        final category = product['category'];
        final thumbnail = product['thumbnail'];
        if (category is String && thumbnail is String) {
          thumbnails.putIfAbsent(category, () => thumbnail);
        }
      }
      return thumbnails;
    } on Object {
      return const {};
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final json = await _get<Map<String, dynamic>>(ApiEndpoints.product(id));
    return ProductModel.fromJson(json);
  }

  Map<String, String> _sortParams(ProductSort sort) => switch (sort) {
    ProductSort.recommended => const {},
    ProductSort.priceLowToHigh => const {'sortBy': 'price', 'order': 'asc'},
    ProductSort.priceHighToLow => const {'sortBy': 'price', 'order': 'desc'},
    ProductSort.rating => const {'sortBy': 'rating', 'order': 'desc'},
    ProductSort.title => const {'sortBy': 'title', 'order': 'asc'},
  };

  Future<T> _get<T>(String path, [Map<String, dynamic>? params]) async {
    try {
      final response = await _dio.get<T>(path, queryParameters: params);
      return response.data as T;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
