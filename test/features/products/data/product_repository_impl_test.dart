import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/datasources/product_local_data_source.dart';
import 'package:shopsphere/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';
import 'package:shopsphere/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

import '../../../fixtures/fixture_reader.dart';

class _MockRemote extends Mock implements ProductRemoteDataSource {}

class _MockLocal extends Mock implements ProductLocalDataSource {}

class _MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ProductQuery());
    registerFallbackValue(
      const ProductPageModel(products: [], total: 0, skip: 0, limit: 0),
    );
    registerFallbackValue(<CategoryModel>[]);
  });

  group('ProductRepositoryImpl', () {
    late _MockRemote remote;
    late _MockLocal local;
    late ProductRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      repository = ProductRepositoryImpl(remote: remote, local: local);
      when(() => local.writeHomePage(any())).thenAnswer((_) async {});
      when(() => local.writeCategories(any())).thenAnswer((_) async {});
      when(() => local.readHomePage()).thenAnswer((_) async => null);
      when(() => local.readCategories()).thenAnswer((_) async => null);
    });

    When<Future<ProductPageModel>> stubGetProducts() => when(
      () => remote.getProducts(
        query: any(named: 'query'),
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    );

    Future<Result<ProductPage>> fetch() =>
        repository.getProducts(query: const ProductQuery(), skip: 0, limit: 20);

    test('returns a ProductPage on success', () async {
      stubGetProducts().thenAnswer(
        (_) async => ProductPageModel.fromJson(fixture('products_page.json')),
      );

      final result = await fetch();

      expect((result as Success<ProductPage>).data.products, hasLength(2));
    });

    test('maps a 500 to ServerFailure', () async {
      stubGetProducts().thenThrow(const ServerException('Internal error', 500));

      final result = await fetch();

      expect((result as Err).failure, isA<ServerFailure>());
    });

    test('maps a dropped connection to NetworkFailure', () async {
      stubGetProducts().thenThrow(const NetworkException());

      final result = await fetch();

      expect((result as Err).failure, isA<NetworkFailure>());
    });

    test('maps a timeout on categories to TimeoutFailure', () async {
      when(remote.getCategories).thenThrow(const RequestTimeoutException());

      final result = await repository.getCategories();

      expect((result as Err).failure, isA<TimeoutFailure>());
    });

    test('getProductById returns the full product on success', () async {
      when(() => remote.getProductById(1)).thenAnswer(
        (_) async => ProductModel.fromJson(fixture('product_detail.json')),
      );

      final result = await repository.getProductById(1);

      expect((result as Success<Product>).data.reviews, isNotEmpty);
    });

    test('getProductById maps a 404 to NotFoundFailure', () async {
      when(
        () => remote.getProductById(9999),
      ).thenThrow(const NotFoundException('Product not found'));

      final result = await repository.getProductById(9999);

      expect((result as Err).failure, isA<NotFoundFailure>());
    });
  });

  group('ProductRemoteDataSourceImpl', () {
    late _MockDio dio;
    late ProductRemoteDataSourceImpl dataSource;

    setUp(() {
      dio = _MockDio();
      dataSource = ProductRemoteDataSourceImpl(dio);
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (invocation) async => Response(
          requestOptions: RequestOptions(),
          data: fixture('products_page.json'),
        ),
      );
    });

    test('uses the search endpoint with q and sort params', () async {
      await dataSource.getProducts(
        query: const ProductQuery(
          search: 'phone',
          sort: ProductSort.priceHighToLow,
        ),
        skip: 20,
        limit: 20,
      );

      final captured = verify(
        () => dio.get<Map<String, dynamic>>(
          captureAny(),
          queryParameters: captureAny(named: 'queryParameters'),
        ),
      ).captured;
      expect(captured[0], '/products/search');
      expect(captured[1], containsPair('q', 'phone'));
      expect(captured[1], containsPair('skip', 20));
      expect(captured[1], containsPair('sortBy', 'price'));
      expect(captured[1], containsPair('order', 'desc'));
    });

    test('uses the category endpoint when a category is selected', () async {
      await dataSource.getProducts(
        query: const ProductQuery(categorySlug: 'smartphones'),
        skip: 0,
        limit: 20,
      );

      final captured = verify(
        () => dio.get<Map<String, dynamic>>(
          captureAny(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).captured;
      expect(captured.single, '/products/category/smartphones');
    });

    test('throws a typed exception when Dio fails', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => dataSource.getProducts(
          query: const ProductQuery(),
          skip: 0,
          limit: 20,
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
