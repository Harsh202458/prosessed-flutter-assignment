import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/entities/product_page.dart';
import 'package:shopsphere/features/products/domain/entities/product_query.dart';
import 'package:shopsphere/features/products/domain/repositories/product_repository.dart';
import 'package:shopsphere/features/products/domain/usecases/get_product_details.dart';
import 'package:shopsphere/features/products/domain/usecases/get_products.dart';

class _MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late _MockProductRepository repository;

  const product = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    price: 9.99,
    discountPercentage: 10.48,
    rating: 2.56,
    stock: 5,
    thumbnail: '',
  );
  const page = ProductPage(products: [product], total: 194, skip: 20);

  setUpAll(() => registerFallbackValue(const ProductQuery()));
  setUp(() => repository = _MockProductRepository());

  group('GetProducts', () {
    test('asks for pages of 20 at the given offset', () async {
      when(
        () => repository.getProducts(
          query: any(named: 'query'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Success(page));

      final result = await GetProducts(
        repository,
      )(query: const ProductQuery(), skip: 20);

      expect(
        result,
        isA<Success<ProductPage>>().having((s) => s.data, 'data', page),
      );
      verify(
        () => repository.getProducts(
          query: const ProductQuery(),
          skip: 20,
          limit: 20,
        ),
      ).called(1);
    });

    test('searches products with the trimmed search term', () async {
      when(
        () => repository.getProducts(
          query: any(named: 'query'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Success(page));

      final query = const ProductQuery(
        categorySlug: 'beauty',
      ).withSearch('  phone ');
      await GetProducts(repository)(query: query);

      final sent =
          verify(
                () => repository.getProducts(
                  query: captureAny(named: 'query'),
                  skip: 0,
                  limit: 20,
                ),
              ).captured.single
              as ProductQuery;
      expect(sent.search, 'phone');
      expect(sent.categorySlug, isNull);
      expect(sent.isSearching, isTrue);
    });

    test('returns network failures unchanged', () async {
      when(
        () => repository.getProducts(
          query: any(named: 'query'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Err(NetworkFailure()));

      expect(
        await GetProducts(repository)(query: const ProductQuery()),
        isA<Err<ProductPage>>().having(
          (e) => e.failure,
          'failure',
          isA<NetworkFailure>(),
        ),
      );
    });
  });

  test('GetProductDetails reports a missing product as not found', () async {
    when(
      () => repository.getProductById(9999),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    expect(
      await GetProductDetails(repository)(9999),
      isA<Err<Product>>().having(
        (e) => e.failure,
        'failure',
        isA<NotFoundFailure>(),
      ),
    );
  });
}
