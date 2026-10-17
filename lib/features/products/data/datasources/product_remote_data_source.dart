import 'package:dio/dio.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';
import 'package:shopsphere/core/network/dio_exception_mapper.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

abstract interface class ProductRemoteDataSource {
  Future<ProductPageModel> getProducts({
    required ProductQuery query,
    required int skip,
    required int limit,
  });

  Future<List<CategoryModel>> getCategories();
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

  @override
  Future<List<CategoryModel>> getCategories() async {
    final json = await _get<List<dynamic>>(ApiEndpoints.categories);
    return [
      for (final item in json)
        CategoryModel.fromJson(item as Map<String, dynamic>),
    ];
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
