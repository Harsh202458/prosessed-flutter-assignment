import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';
import 'package:shopsphere/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopsphere/features/cart/domain/usecases/place_order.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';

class _MockCartRepository extends Mock implements CartRepository {}

class _MockPlaceOrder extends Mock implements PlaceOrder {}

const _product = Product(
  id: 1,
  title: 'Mascara',
  price: 10,
  discountPercentage: 10,
  rating: 4,
  stock: 3,
  thumbnail: '',
);

const _item = CartItem(
  productId: 1,
  title: 'Mascara',
  thumbnail: '',
  price: 10,
  discountPercentage: 10,
  stock: 3,
  quantity: 1,
);

void main() {
  late _MockCartRepository repository;
  late _MockPlaceOrder placeOrder;

  setUpAll(() => registerFallbackValue(<CartItem>[]));

  setUp(() {
    repository = _MockCartRepository();
    placeOrder = _MockPlaceOrder();
    when(
      () => repository.saveCart(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => repository.clearCart(),
    ).thenAnswer((_) async => const Success(null));
  });

  CartCubit build() =>
      CartCubit(repository: repository, placeOrder: placeOrder);

  CartState ready(List<CartItem> items) =>
      build().state.copyWith(status: CartStatus.ready, items: items);

  blocTest<CartCubit, CartState>(
    'restores the saved cart on load',
    setUp: () => when(
      () => repository.loadCart(),
    ).thenAnswer((_) async => const Success([_item])),
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.status, CartStatus.ready);
      expect(cubit.state.items, const [_item]);
      expect(cubit.state.totals.itemCount, 1);
    },
  );

  blocTest<CartCubit, CartState>(
    'still becomes ready with a notice when the saved cart is unreadable',
    setUp: () => when(
      () => repository.loadCart(),
    ).thenAnswer((_) async => const Err(CacheFailure())),
    build: build,
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.status, CartStatus.ready);
      expect(cubit.state.storageError, isNotNull);
    },
  );

  blocTest<CartCubit, CartState>(
    'adds a product, merges repeat adds and caps at stock, then saves',
    build: build,
    act: (cubit) async {
      await cubit.add(_product, 2);
      await cubit.add(_product, 5);
    },
    verify: (cubit) {
      expect(cubit.state.items.single.quantity, 3);
      expect(cubit.state.totals.total, closeTo(27, 0.0001));
      verify(() => repository.saveCart(any())).called(2);
    },
  );

  blocTest<CartCubit, CartState>(
    'ignores out-of-stock products',
    build: build,
    act: (cubit) => cubit.add(
      const Product(
        id: 2,
        title: 'Gone',
        price: 1,
        discountPercentage: 0,
        rating: 0,
        stock: 0,
        thumbnail: '',
      ),
      1,
    ),
    expect: () => const <CartState>[],
  );

  blocTest<CartCubit, CartState>(
    'never lets the quantity drop below 1 or rise above stock',
    build: build,
    seed: () => ready(const [_item]),
    act: (cubit) async {
      await cubit.decrement(1);
      await cubit.increment(1);
      await cubit.increment(1);
      await cubit.increment(1);
    },
    verify: (cubit) => expect(cubit.state.items.single.quantity, 3),
  );

  blocTest<CartCubit, CartState>(
    'removes a line and can restore it for undo',
    build: build,
    seed: () => ready(const [_item]),
    act: (cubit) async {
      await cubit.remove(1);
      expect(cubit.state.isEmpty, isTrue);
      await cubit.restore(_item, 0);
    },
    verify: (cubit) => expect(cubit.state.items, const [_item]),
  );

  blocTest<CartCubit, CartState>(
    'clears the cart and shows the order once checkout succeeds',
    setUp: () => when(() => placeOrder(any())).thenAnswer(
      (_) async => const Success(
        OrderConfirmation(orderId: 209, itemCount: 1, total: 9),
      ),
    ),
    build: build,
    seed: () => ready(const [_item]),
    act: (cubit) => cubit.placeOrder(),
    expect: () => [
      isA<CartState>().having(
        (s) => s.checkoutStatus,
        'checkoutStatus',
        CheckoutStatus.submitting,
      ),
      isA<CartState>()
          .having((s) => s.checkoutStatus, 'status', CheckoutStatus.success)
          .having((s) => s.order?.orderId, 'orderId', 209)
          .having((s) => s.isEmpty, 'isEmpty', isTrue),
    ],
  );

  blocTest<CartCubit, CartState>(
    'keeps the cart and reports the error when checkout fails',
    setUp: () => when(
      () => placeOrder(any()),
    ).thenAnswer((_) async => const Err(NetworkFailure())),
    build: build,
    seed: () => ready(const [_item]),
    act: (cubit) => cubit.placeOrder(),
    skip: 1,
    expect: () => [
      isA<CartState>()
          .having((s) => s.checkoutStatus, 'status', CheckoutStatus.failure)
          .having(
            (s) => s.checkoutError,
            'error',
            const NetworkFailure().message,
          )
          .having((s) => s.items, 'items', const [_item]),
    ],
  );
}
