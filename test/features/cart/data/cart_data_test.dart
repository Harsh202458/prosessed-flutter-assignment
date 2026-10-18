import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:shopsphere/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:shopsphere/features/cart/data/models/cart_item_model.dart';
import 'package:shopsphere/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';

import '../../../fixtures/fixture_reader.dart';

class _MockBox extends Mock implements Box<String> {}

class _MockDio extends Mock implements Dio {}

class _MockLocal extends Mock implements CartLocalDataSource {}

class _MockRemote extends Mock implements CartRemoteDataSource {}

const _model = CartItemModel(
  productId: 1,
  title: 'Mascara',
  thumbnail: 'https://example.com/a.webp',
  price: 9.99,
  discountPercentage: 10.48,
  stock: 99,
  quantity: 2,
);

void main() {
  group('CartLocalDataSourceImpl', () {
    late _MockBox box;
    late CartLocalDataSourceImpl dataSource;

    setUp(() {
      box = _MockBox();
      dataSource = CartLocalDataSourceImpl(box);
    });

    test('round-trips the cart through JSON in the box', () async {
      String? stored;
      when(() => box.put(any<dynamic>(), any<String>())).thenAnswer((invocation) async {
        stored = invocation.positionalArguments[1] as String;
      });
      await dataSource.writeCart(const [_model]);

      when(() => box.get(any<dynamic>())).thenReturn(stored);
      final items = await dataSource.readCart();

      expect(items, const [_model]);
    });

    test('returns an empty cart when nothing was saved', () async {
      when(() => box.get(any<dynamic>())).thenReturn(null);
      expect(await dataSource.readCart(), isEmpty);
    });

    test('throws CacheException when the saved data is corrupt', () async {
      when(() => box.get(any<dynamic>())).thenReturn('{not json');
      expect(dataSource.readCart, throwsA(isA<CacheException>()));
    });
  });

  group('CartRemoteDataSourceImpl', () {
    test('posts product ids and quantities and returns the order id', () async {
      final dio = _MockDio();
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: fixture('cart_add_response.json'),
        ),
      );

      final id = await CartRemoteDataSourceImpl(
        dio,
      ).placeOrder(userId: 1, items: const [_model]);

      expect(id, 209);
      final body =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '/carts/add',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(body['userId'], 1);
      expect(body['products'], [
        {'id': 1, 'quantity': 2},
      ]);
    });
  });

  group('CartRepositoryImpl', () {
    late _MockLocal local;
    late _MockRemote remote;
    late CartRepositoryImpl repository;

    setUp(() {
      local = _MockLocal();
      remote = _MockRemote();
      repository = CartRepositoryImpl(local: local, remote: remote);
    });

    test('loads saved items as entities', () async {
      when(() => local.readCart()).thenAnswer((_) async => const [_model]);

      final result = await repository.loadCart();

      expect(
        (result as Success<List<CartItem>>).data.single.title,
        'Mascara',
      );
    });

    test('maps a storage error to CacheFailure', () async {
      when(() => local.readCart()).thenThrow(const CacheException());

      final result = await repository.loadCart();

      expect((result as Err).failure, isA<CacheFailure>());
    });

    test('maps order server and network errors to failures', () async {
      when(
        () => remote.placeOrder(
          userId: any(named: 'userId'),
          items: any(named: 'items'),
        ),
      ).thenThrow(const ServerException('boom', 500));
      expect(
        ((await repository.placeOrder(userId: 1, items: [_model.toEntity()]))
                as Err)
            .failure,
        isA<ServerFailure>(),
      );

      when(
        () => remote.placeOrder(
          userId: any(named: 'userId'),
          items: any(named: 'items'),
        ),
      ).thenThrow(const NetworkException());
      expect(
        ((await repository.placeOrder(userId: 1, items: [_model.toEntity()]))
                as Err)
            .failure,
        isA<NetworkFailure>(),
      );
    });
  });
}
