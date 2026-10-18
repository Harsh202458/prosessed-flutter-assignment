import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/cart/domain/entities/cart_item.dart';
import 'package:shopsphere/features/cart/domain/usecases/calculate_cart_totals.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/cart/presentation/pages/cart_page.dart';

class _MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late _MockCartCubit cubit;

  setUp(() => cubit = _MockCartCubit());

  Future<void> pump(WidgetTester tester, CartState state) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider<CartCubit>.value(
          value: cubit,
          child: const CartPage(),
        ),
      ),
    );
  }

  testWidgets('shows an inviting empty state', (tester) async {
    await pump(tester, const CartState(status: CartStatus.ready));

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Start shopping'), findsOneWidget);
    expect(find.text('Place order'), findsNothing);
  });

  testWidgets('lists items with subtotal, discount and total', (
    tester,
  ) async {
    const items = [
      CartItem(
        productId: 1,
        title: 'Mascara',
        thumbnail: '',
        price: 10,
        discountPercentage: 10,
        stock: 5,
        quantity: 2,
      ),
    ];
    await pump(
      tester,
      CartState(
        status: CartStatus.ready,
        items: items,
        totals: const CalculateCartTotals()(items),
      ),
    );

    expect(find.text('Mascara'), findsOneWidget);
    expect(find.text(r'$20.00'), findsOneWidget);
    expect(find.text(r'−$2.00'), findsOneWidget);
    expect(find.text(r'$18.00'), findsNWidgets(2));
    expect(find.text('Place order'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
