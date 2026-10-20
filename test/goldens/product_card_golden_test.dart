// Golden tests compare pixels, and font rasterisation differs slightly
// between operating systems, so they run locally and CI skips this tag.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/widgets/product_card.dart';
import 'package:shopsphere/l10n/app_localizations.dart';

/// Loads the bundled Plus Jakarta Sans so goldens show real text instead of
/// the test font's placeholder boxes.
Future<void> _loadAppFont() async {
  final loader = FontLoader(AppTheme.fontFamily);
  for (final weight in [400, 500, 600, 700, 800]) {
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
  }
  await loader.load();
}

void main() {
  setUpAll(_loadAppFont);

  const product = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    category: 'beauty',
    brand: 'Essence',
    price: 9.99,
    discountPercentage: 10.48,
    rating: 2.56,
    stock: 5,
    thumbnail: '',
  );

  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    testWidgets('product card matches the $name golden', (tester) async {
      const width = 180.0;
      tester.view
        ..physicalSize = const Size(220, 360)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: theme,
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => SizedBox(
                  width: width,
                  height: ProductCard.extentFor(context, width),
                  child: const ProductCard(product: product),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(ProductCard),
        matchesGoldenFile('product_card_$name.png'),
      );
    });
  }
}
