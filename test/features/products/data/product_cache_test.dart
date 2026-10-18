import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/datasources/product_local_data_source.dart';
import 'package:shopsphere/features/products/data/datasources/product_remote_data_source.dart';
import 'package:shopsphere/features/products/data/models/category_model.dart';
import 'package:shopsphere/features/products/data/models/product_page_model.dart';
import 'package:shopsphere/features/products/data/repositories/product_repository_impl.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';

import '../../../fixtures/fixture_reader.dart';

class _MockRemote extends Mock implements ProductRemoteDataSource {}

class _MockLocal extends Mock implements ProductLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late ProductRepositoryImpl repository;

  final page = ProductPageModel.fromJson(fixture('products_page.json'));

  setUpAll(() {
    registerFallbackValue(const ProductQuery());
    registerFallbackValue(page);
    registerFallbackValue(<CategoryModel>[]);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = ProductRepositoryImpl(remote: remote, local: local);
    when(() => local.writeHomePage(any())).thenAnswer((_) async {});
    when(() => local.writeCategories(any())).thenAnswer((_) async {});
  });

  void stubRemote({required int skip, Object? error}) {
    final call = when(
      () => remote.getProducts(
        query: any(named: 'query'),
        skip: skip,
        limit: any(named: 'limit'),
      ),
    );
    if (error != null) {
      call.thenThrow(error);
    } else {
      call.thenAnswer((_) async => page);
    }
  }

  test('saves the unfiltered first page after a successful load', () async {
    stubRemote(skip: 0);

    await repository.getProducts(
      query: const ProductQuery(),
      skip: 0,
      limit: 20,
    );

    verify(() => local.writeHomePage(page)).called(1);
  });

  test('does not cache searches, filters or later pages', () async {
    stubRemote(skip: 0);
    stubRemote(skip: 20);

    await repository.getProducts(
      query: const ProductQuery(search: 'phone'),
      skip: 0,
      limit: 20,
    );
    await repository.getProducts(
      query: const ProductQuery(),
      skip: 20,
      limit: 20,
    );

    verifyNever(() => local.writeHomePage(any()));
  });

  test('serves the saved page, marked as cached, when offline', () async {
    stubRemote(skip: 0, error: const NetworkException());
    when(() => local.readHomePage()).thenAnswer((_) async => page);

    final result = await repository.getProducts(
      query: const ProductQuery(),
      skip: 0,
      limit: 20,
    );

    final cached = (result as Success<ProductPage>).data;
    expect(cached.isFromCache, isTrue);
    expect(cached.products, hasLength(2));
    expect(cached.hasMore, isFalse);
  });

  test('still reports the network failure when nothing is cached', () async {
    stubRemote(skip: 0, error: const NetworkException());
    when(() => local.readHomePage()).thenAnswer((_) async => null);

    final result = await repository.getProducts(
      query: const ProductQuery(),
      skip: 0,
      limit: 20,
    );

    expect((result as Err).failure, isA<NetworkFailure>());
  });

  test('does not hide server errors behind the cache', () async {
    stubRemote(skip: 0, error: const ServerException('boom', 500));

    final result = await repository.getProducts(
      query: const ProductQuery(),
      skip: 0,
      limit: 20,
    );

    expect((result as Err).failure, isA<ServerFailure>());
    verifyNever(() => local.readHomePage());
  });

  test('a broken cache never breaks a successful request', () async {
    stubRemote(skip: 0);
    when(() => local.writeHomePage(any())).thenThrow(const CacheException());

    final result = await repository.getProducts(
      query: const ProductQuery(),
      skip: 0,
      limit: 20,
    );

    expect(result, isA<Success<ProductPage>>());
  });

  test('falls back to saved categories when offline', () async {
    when(
      () => remote.getCategories(),
    ).thenThrow(const RequestTimeoutException());
    when(() => local.readCategories()).thenAnswer(
      (_) async => const [CategoryModel(slug: 'beauty', name: 'Beauty')],
    );

    final result = await repository.getCategories();

    expect(
      (result as Success<List<Category>>).data.single.slug,
      'beauty',
    );
  });
}
