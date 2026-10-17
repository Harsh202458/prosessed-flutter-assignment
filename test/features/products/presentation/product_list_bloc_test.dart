import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/domain/usecases/get_products.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';

class _MockGetProducts extends Mock implements GetProducts {}

Product _product(int id) => Product(
  id: id,
  title: 'Product $id',
  price: 10,
  discountPercentage: 0,
  rating: 4,
  stock: 5,
  thumbnail: '',
);

List<Product> _products(int from, int count) => [
  for (var i = from; i < from + count; i++) _product(i),
];

void main() {
  late _MockGetProducts getProducts;

  setUpAll(() => registerFallbackValue(const ProductQuery()));
  setUp(() => getProducts = _MockGetProducts());

  void stub({required Result<ProductPage> result, int skip = 0}) => when(
    () => getProducts(
      query: any(named: 'query'),
      skip: skip,
    ),
  ).thenAnswer((_) async => result);

  final firstPage = ProductPage(products: _products(0, 20), total: 30, skip: 0);
  final lastPage = ProductPage(
    products: _products(20, 10),
    total: 30,
    skip: 20,
  );

  blocTest<ProductListBloc, ProductListState>(
    'loads the first page: [loading, success]',
    setUp: () => stub(result: Success(firstPage)),
    build: () => ProductListBloc(getProducts),
    act: (bloc) => bloc.add(const ProductListStarted()),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      ProductListState(
        status: ProductListStatus.success,
        products: firstPage.products,
      ),
    ],
  );

  blocTest<ProductListBloc, ProductListState>(
    'emits empty when the query has no results',
    setUp: () => stub(
      result: const Success(ProductPage(products: [], total: 0, skip: 0)),
    ),
    build: () => ProductListBloc(getProducts),
    act: (bloc) => bloc.add(const ProductListStarted()),
    expect: () => const [
      ProductListState(status: ProductListStatus.loading),
      ProductListState(status: ProductListStatus.empty, hasReachedEnd: true),
    ],
  );

  blocTest<ProductListBloc, ProductListState>(
    'emits failure with a user-friendly message when the first page fails',
    setUp: () => stub(result: const Err(ServerFailure())),
    build: () => ProductListBloc(getProducts),
    act: (bloc) => bloc.add(const ProductListStarted()),
    expect: () => [
      const ProductListState(status: ProductListStatus.loading),
      ProductListState(
        status: ProductListStatus.failure,
        errorMessage: const ServerFailure().message,
      ),
    ],
  );

  blocTest<ProductListBloc, ProductListState>(
    'appends the next page and stops once every item is loaded',
    setUp: () => stub(skip: 20, result: Success(lastPage)),
    build: () => ProductListBloc(getProducts),
    seed: () => ProductListState(
      status: ProductListStatus.success,
      products: firstPage.products,
    ),
    act: (bloc) => bloc
      ..add(const ProductListNextPageRequested())
      ..add(const ProductListNextPageRequested()),
    expect: () => [
      ProductListState(
        status: ProductListStatus.success,
        products: firstPage.products,
        isLoadingMore: true,
      ),
      ProductListState(
        status: ProductListStatus.success,
        products: [...firstPage.products, ...lastPage.products],
        hasReachedEnd: true,
      ),
    ],
    verify: (_) => verify(
      () => getProducts(query: any(named: 'query'), skip: 20),
    ).called(1),
  );

  blocTest<ProductListBloc, ProductListState>(
    'keeps loaded items and shows a footer error when a later page fails',
    setUp: () => stub(skip: 20, result: const Err(NetworkFailure())),
    build: () => ProductListBloc(getProducts),
    seed: () => ProductListState(
      status: ProductListStatus.success,
      products: firstPage.products,
    ),
    act: (bloc) => bloc.add(const ProductListNextPageRequested()),
    skip: 1,
    expect: () => [
      ProductListState(
        status: ProductListStatus.success,
        products: firstPage.products,
        loadMoreError: const NetworkFailure().message,
      ),
    ],
  );

  blocTest<ProductListBloc, ProductListState>(
    'debounces search so fast typing triggers a single request',
    setUp: () => stub(result: Success(firstPage)),
    build: () => ProductListBloc(getProducts),
    act: (bloc) => bloc
      ..add(const ProductSearchChanged('p'))
      ..add(const ProductSearchChanged('ph'))
      ..add(const ProductSearchChanged('phone')),
    wait: const Duration(milliseconds: 500),
    verify: (bloc) {
      verify(
        () => getProducts(
          query: const ProductQuery(search: 'phone'),
        ),
      ).called(1);
      expect(bloc.state.query.search, 'phone');
    },
  );

  blocTest<ProductListBloc, ProductListState>(
    'selecting a category reloads with that category and keeps the sort',
    setUp: () => stub(result: Success(firstPage)),
    build: () => ProductListBloc(getProducts),
    seed: () => const ProductListState(
      status: ProductListStatus.success,
      query: ProductQuery(sort: ProductSort.rating),
    ),
    act: (bloc) => bloc.add(const ProductCategorySelected('smartphones')),
    verify: (_) => verify(
      () => getProducts(
        query: const ProductQuery(
          categorySlug: 'smartphones',
          sort: ProductSort.rating,
        ),
      ),
    ).called(1),
  );
}
