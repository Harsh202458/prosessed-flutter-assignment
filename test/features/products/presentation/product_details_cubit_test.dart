import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/domain/usecases/get_product_details.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';

class _MockGetProductDetails extends Mock implements GetProductDetails {}

void main() {
  late _MockGetProductDetails getProductDetails;

  const product = Product(
    id: 1,
    title: 'Mascara',
    price: 10,
    discountPercentage: 0,
    rating: 4,
    stock: 2,
    thumbnail: '',
  );

  setUp(() => getProductDetails = _MockGetProductDetails());

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits [loading, success] with the product',
    setUp: () => when(
      () => getProductDetails(1),
    ).thenAnswer((_) async => const Success(product)),
    build: () => ProductDetailsCubit(getProductDetails),
    act: (cubit) => cubit.load(1),
    expect: () => const [
      ProductDetailsState(),
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product,
      ),
    ],
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits notFound for a 404, e.g. /products/9999',
    setUp: () => when(
      () => getProductDetails(9999),
    ).thenAnswer((_) async => const Err(NotFoundFailure())),
    build: () => ProductDetailsCubit(getProductDetails),
    act: (cubit) => cubit.load(9999),
    skip: 1,
    expect: () => [
      isA<ProductDetailsState>().having(
        (s) => s.status,
        'status',
        ProductDetailsStatus.notFound,
      ),
    ],
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits notFound without a request when the route id is malformed',
    build: () => ProductDetailsCubit(getProductDetails),
    act: (cubit) => cubit.load(null),
    expect: () => const [
      ProductDetailsState(status: ProductDetailsStatus.notFound),
    ],
    verify: (_) => verifyZeroInteractions(getProductDetails),
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits failure with a retryable message on a server error',
    setUp: () => when(
      () => getProductDetails(1),
    ).thenAnswer((_) async => const Err(ServerFailure())),
    build: () => ProductDetailsCubit(getProductDetails),
    act: (cubit) => cubit.load(1),
    skip: 1,
    expect: () => [
      ProductDetailsState(
        status: ProductDetailsStatus.failure,
        errorMessage: const ServerFailure().message,
      ),
    ],
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'limits the quantity to stock minus what is already in the cart',
    build: () => ProductDetailsCubit(getProductDetails),
    seed: () => const ProductDetailsState(
      status: ProductDetailsStatus.success,
      product: product,
      quantity: 2,
    ),
    act: (cubit) => cubit
      ..syncCartQuantity(1)
      ..increment(),
    verify: (cubit) {
      expect(cubit.state.available, 1);
      expect(cubit.state.quantity, 1);
      expect(cubit.state.canIncrement, isFalse);
    },
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'cannot add once the cart holds all of the stock',
    build: () => ProductDetailsCubit(getProductDetails),
    seed: () => const ProductDetailsState(
      status: ProductDetailsStatus.success,
      product: product,
    ),
    act: (cubit) => cubit.syncCartQuantity(2),
    verify: (cubit) => expect(cubit.state.canAdd, isFalse),
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'keeps the quantity between 1 and the available stock',
    build: () => ProductDetailsCubit(getProductDetails),
    seed: () => const ProductDetailsState(
      status: ProductDetailsStatus.success,
      product: product,
    ),
    act: (cubit) => cubit
      ..decrement()
      ..increment()
      ..increment()
      ..decrement(),
    expect: () => const [
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product,
        quantity: 2,
      ),
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product,
      ),
    ],
  );
}
