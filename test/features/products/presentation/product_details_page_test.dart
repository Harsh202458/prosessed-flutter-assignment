import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:shopsphere/features/products/presentation/pages/product_details_page.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class _MockDetailsCubit extends MockCubit<ProductDetailsState>
    implements ProductDetailsCubit {}

class _MockWishlistCubit extends MockCubit<WishlistState>
    implements WishlistCubit {}

class _MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late _MockWishlistCubit wishlistCubit;
  late _MockDetailsCubit cubit;
  late _MockCartCubit cartCubit;

  setUp(() {
    wishlistCubit = _MockWishlistCubit();
    when(() => wishlistCubit.state).thenReturn(const WishlistState());
    cubit = _MockDetailsCubit();
    cartCubit = _MockCartCubit();
    when(() => cartCubit.state).thenReturn(const CartState());
  });

  Product product({required int stock}) => Product(
    id: 1,
    title: 'Mascara',
    price: 10,
    discountPercentage: 10,
    rating: 4,
    stock: stock,
    thumbnail: '',
    description: 'Long-lasting lashes.',
  );

  Future<void> pump(WidgetTester tester, ProductDetailsState state) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailsCubit>.value(value: cubit),
            BlocProvider<WishlistCubit>.value(value: wishlistCubit),
            BlocProvider<CartCubit>.value(value: cartCubit),
          ],
          child: const ProductDetailsPage(productId: 1),
        ),
      ),
    );
  }

  testWidgets('shows a not-found state with a way back', (tester) async {
    await pump(
      tester,
      const ProductDetailsState(status: ProductDetailsStatus.notFound),
    );

    expect(find.text('Product not found'), findsOneWidget);
    expect(find.text('Back to shop'), findsOneWidget);
  });

  testWidgets('disables add to cart when the product is out of stock', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product(stock: 0),
      ),
    );

    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Out of stock').last,
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('disables add to cart once all stock is in the cart', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product(stock: 2),
        inCart: 2,
      ),
    );

    expect(find.text('You have all 2 in your cart'), findsOneWidget);
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('All in your cart'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('enables add to cart and shows the total when in stock', (
    tester,
  ) async {
    await pump(
      tester,
      ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product(stock: 5),
        quantity: 2,
      ),
    );

    expect(find.text(r'Add · $18.00'), findsOneWidget);
    expect(find.text('Long-lasting lashes.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
