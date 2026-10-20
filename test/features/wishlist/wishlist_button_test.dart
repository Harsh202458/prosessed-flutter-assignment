import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shopsphere/features/wishlist/presentation/widgets/wishlist_button.dart';
import 'package:shopsphere/l10n/app_localizations.dart';

class _MockRepository extends Mock implements WishlistRepository {}

void main() {
  const product = Product(
    id: 7,
    title: 'Lipstick',
    price: 12,
    discountPercentage: 0,
    rating: 4,
    stock: 5,
    thumbnail: '',
  );

  setUpAll(() => registerFallbackValue(<Product>[]));

  testWidgets('tapping the heart saves the product and offers removal', (
    tester,
  ) async {
    final repository = _MockRepository();
    when(
      () => repository.save(any()),
    ).thenAnswer((_) async => const Success(null));
    final cubit = WishlistCubit(repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(
            body: Center(child: WishlistButton(product: product)),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Save to wishlist'), findsOneWidget);

    await tester.tap(find.byType(WishlistButton));
    await tester.pumpAndSettle();

    expect(cubit.state.contains(7), isTrue);
    expect(find.byTooltip('Remove from wishlist'), findsOneWidget);
    expect(find.text('Saved to your wishlist'), findsOneWidget);
  });
}
