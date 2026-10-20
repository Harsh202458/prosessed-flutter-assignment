import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';
import 'package:shopsphere/l10n/app_localizations.dart';

void main() {
  const product = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess with an extra long name',
    category: 'home-decoration',
    brand: 'A brand with a fairly long name',
    price: 1299.99,
    discountPercentage: 12.5,
    rating: 4.56,
    stock: 0,
    thumbnail: '',
  );

  Future<void> pumpCard(WidgetTester tester, double textScale) async {
    const width = 156.0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Builder(
            builder: (context) => Center(
              child: SizedBox(
                width: width,
                height: ProductCard.extentFor(context, width),
                child: const ProductCard(product: product),
              ),
            ),
          ),
        ),
      ),
    );
  }

  for (final scale in [1.0, 1.3]) {
    testWidgets('renders without overflow at ${scale}x text scale', (
      tester,
    ) async {
      await pumpCard(tester, scale);

      expect(tester.takeException(), isNull);
      expect(find.text('-13%'), findsOneWidget);
      expect(find.text('Out of stock'), findsOneWidget);
      expect(
        find.text('Home Decoration · A brand with a fairly long name'),
        findsOneWidget,
      );
    });
  }
}
