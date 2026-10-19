import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/data/models/product_model.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:shopsphere/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:shopsphere/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class _MockBox extends Mock implements Box<String> {}

class _MockLocal extends Mock implements WishlistLocalDataSource {}

class _MockRepository extends Mock implements WishlistRepository {}

Product _product(int id) => Product(
  id: id,
  title: 'Product $id',
  price: 10,
  discountPercentage: 5,
  rating: 4,
  stock: 3,
  thumbnail: 'https://example.com/$id.webp',
  category: 'beauty',
  brand: 'Brand',
);

void main() {
  setUpAll(() {
    registerFallbackValue(<Product>[]);
    registerFallbackValue(<ProductModel>[]);
  });

  group('WishlistLocalDataSourceImpl', () {
    test('round-trips saved products through JSON', () async {
      final box = _MockBox();
      String? stored;
      when(() => box.put(any<dynamic>(), any<String>())).thenAnswer((
        invocation,
      ) async {
        stored = invocation.positionalArguments[1] as String;
      });
      final dataSource = WishlistLocalDataSourceImpl(box);
      const model = ProductModel(id: 1, title: 'Mascara', price: 9.99);

      await dataSource.write(const [model]);
      when(() => box.get(any<dynamic>())).thenReturn(stored);

      expect(await dataSource.read(), const [model]);
    });

    test('throws CacheException on corrupt data', () async {
      final box = _MockBox();
      when(() => box.get(any<dynamic>())).thenReturn('not json');

      expect(
        WishlistLocalDataSourceImpl(box).read,
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('WishlistRepositoryImpl', () {
    test('saves the card fields and loads them back as entities', () async {
      final local = _MockLocal();
      List<ProductModel>? written;
      when(() => local.write(any())).thenAnswer((invocation) async {
        written = invocation.positionalArguments.first as List<ProductModel>;
      });
      final repository = WishlistRepositoryImpl(local);

      await repository.save([_product(1)]);
      when(local.read).thenAnswer((_) async => written!);
      final result = await repository.load();

      final loaded = (result as Success<List<Product>>).data.single;
      expect(loaded.title, 'Product 1');
      expect(loaded.brand, 'Brand');
      expect(loaded.discountedPrice, closeTo(9.5, 0.0001));
    });

    test('maps a storage error to CacheFailure', () async {
      final local = _MockLocal();
      when(local.read).thenThrow(const CacheException());

      final result = await WishlistRepositoryImpl(local).load();

      expect((result as Err).failure, isA<CacheFailure>());
    });
  });

  group('WishlistCubit', () {
    late _MockRepository repository;

    setUp(() {
      repository = _MockRepository();
      when(
        () => repository.save(any()),
      ).thenAnswer((_) async => const Success(null));
      when(
        () => repository.clear(),
      ).thenAnswer((_) async => const Success(null));
    });

    blocTest<WishlistCubit, WishlistState>(
      'restores the saved wishlist',
      setUp: () => when(
        () => repository.load(),
      ).thenAnswer((_) async => Success([_product(1)])),
      build: () => WishlistCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        WishlistState(products: [_product(1)], isLoaded: true),
      ],
    );

    blocTest<WishlistCubit, WishlistState>(
      'starts empty when the saved wishlist cannot be read',
      setUp: () => when(
        () => repository.load(),
      ).thenAnswer((_) async => const Err(CacheFailure())),
      build: () => WishlistCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [WishlistState(isLoaded: true)],
    );

    blocTest<WishlistCubit, WishlistState>(
      'toggle adds newest first, then removes, saving each time',
      build: () => WishlistCubit(repository),
      act: (cubit) async {
        expect(await cubit.toggle(_product(1)), isTrue);
        expect(await cubit.toggle(_product(2)), isTrue);
        expect(cubit.state.products.first.id, 2);
        expect(await cubit.toggle(_product(1)), isFalse);
      },
      verify: (cubit) {
        expect(cubit.state.products.map((p) => p.id), [2]);
        expect(cubit.state.contains(1), isFalse);
        verify(() => repository.save(any())).called(3);
      },
    );

    blocTest<WishlistCubit, WishlistState>(
      'clear empties the wishlist (used on sign-out)',
      build: () => WishlistCubit(repository),
      seed: () => WishlistState(products: [_product(1)], isLoaded: true),
      act: (cubit) => cubit.clear(),
      expect: () => const [WishlistState(isLoaded: true)],
      verify: (_) => verify(() => repository.clear()).called(1),
    );
  });
}
