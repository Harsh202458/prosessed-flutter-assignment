import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_totals.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopsphere/features/cart/domain/usecases/calculate_cart_totals.dart';
import 'package:shopsphere/features/cart/domain/usecases/place_order.dart';

class _MockCartRepository extends Mock implements CartRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

CartItem _item({
  int id = 1,
  double price = 100,
  double discount = 10,
  int quantity = 2,
}) => CartItem(
  productId: id,
  title: 'Item $id',
  thumbnail: '',
  price: price,
  discountPercentage: discount,
  stock: 10,
  quantity: quantity,
);

void main() {
  group('CalculateCartTotals', () {
    const calculate = CalculateCartTotals();

    test('returns zeros for an empty cart', () {
      expect(calculate(const []), CartTotals.empty);
    });

    test('sums subtotal, discount, total and units across lines', () {
      final totals = calculate([
        _item(),
        _item(id: 2, price: 50, discount: 0, quantity: 1),
      ]);

      expect(totals.subtotal, closeTo(250, 0.0001));
      expect(totals.discount, closeTo(20, 0.0001));
      expect(totals.total, closeTo(230, 0.0001));
      expect(totals.itemCount, 3);
    });
  });

  group('PlaceOrder', () {
    late _MockCartRepository cartRepository;
    late _MockAuthRepository authRepository;
    late PlaceOrder placeOrder;

    const user = User(
      id: 7,
      username: 'emilys',
      email: '',
      firstName: 'Emily',
      lastName: 'Johnson',
      image: '',
    );

    setUp(() {
      cartRepository = _MockCartRepository();
      authRepository = _MockAuthRepository();
      placeOrder = PlaceOrder(
        cartRepository: cartRepository,
        authRepository: authRepository,
      );
      when(
        () => cartRepository.clearCart(),
      ).thenAnswer((_) async => const Success(null));
    });

    test('places the order for the current user and clears the cart', () async {
      when(
        () => authRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Success(user));
      when(
        () => cartRepository.placeOrder(
          userId: 7,
          items: any(named: 'items'),
        ),
      ).thenAnswer((_) async => const Success(209));

      final result = await placeOrder([_item()]);

      expect(
        result,
        isA<Success<OrderConfirmation>>().having(
          (s) => s.data,
          'data',
          const OrderConfirmation(orderId: 209, itemCount: 2, total: 180),
        ),
      );
      verify(() => cartRepository.clearCart()).called(1);
    });

    test('keeps the cart when the order request fails', () async {
      when(
        () => authRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Success(user));
      when(
        () => cartRepository.placeOrder(
          userId: any(named: 'userId'),
          items: any(named: 'items'),
        ),
      ).thenAnswer((_) async => const Err(NetworkFailure()));

      final result = await placeOrder([_item()]);

      expect((result as Err).failure, isA<NetworkFailure>());
      verifyNever(() => cartRepository.clearCart());
    });

    test('rejects an empty cart without calling the API', () async {
      final result = await placeOrder(const []);

      expect((result as Err).failure, isA<BadRequestFailure>());
      verifyZeroInteractions(authRepository);
    });
  });
}
