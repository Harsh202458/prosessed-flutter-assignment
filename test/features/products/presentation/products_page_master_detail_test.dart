import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/products/domain/entities/category.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/pages/products_page.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class _MockListBloc extends MockBloc<ProductListEvent, ProductListState>
    implements ProductListBloc {}

class _MockWishlistCubit extends MockCubit<WishlistState>
    implements WishlistCubit {}

class _MockCategoriesCubit extends MockCubit<CategoriesState>
    implements CategoriesCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockConnectivityCubit extends MockCubit<bool>
    implements ConnectivityCubit {}

void main() {
  late _MockWishlistCubit wishlistCubit;
  late _MockListBloc listBloc;
  late _MockCategoriesCubit categoriesCubit;
  late _MockProfileCubit profileCubit;
  late _MockConnectivityCubit connectivityCubit;

  const products = [
    Product(
      id: 1,
      title: 'Mascara',
      price: 10,
      discountPercentage: 10,
      rating: 4,
      stock: 5,
      thumbnail: '',
      category: 'beauty',
    ),
    Product(
      id: 2,
      title: 'Lipstick',
      price: 12,
      discountPercentage: 0,
      rating: 4.5,
      stock: 5,
      thumbnail: '',
      category: 'beauty',
    ),
  ];

  setUp(() {
    wishlistCubit = _MockWishlistCubit();
    when(() => wishlistCubit.state).thenReturn(const WishlistState());
    listBloc = _MockListBloc();
    categoriesCubit = _MockCategoriesCubit();
    profileCubit = _MockProfileCubit();
    connectivityCubit = _MockConnectivityCubit();
    when(() => connectivityCubit.state).thenReturn(true);
    when(() => listBloc.state).thenReturn(
      const ProductListState(
        status: ProductListStatus.success,
        products: products,
        hasReachedEnd: true,
      ),
    );
    when(() => categoriesCubit.state).thenReturn(
      const CategoriesState(
        status: CategoriesStatus.success,
        categories: [Category(slug: 'beauty', name: 'Beauty')],
      ),
    );
    when(() => profileCubit.state).thenReturn(const ProfileState());
  });

  testWidgets(
    'on a landscape tablet, tapping a card opens it in the detail pane',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1280, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          // Skips the carousel timer and entrance animations.
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ProductListBloc>.value(value: listBloc),
              BlocProvider<WishlistCubit>.value(value: wishlistCubit),
              BlocProvider<CategoriesCubit>.value(value: categoriesCubit),
              BlocProvider<ProfileCubit>.value(value: profileCubit),
              BlocProvider<ConnectivityCubit>.value(value: connectivityCubit),
            ],
            child: ProductsPage(
              detailsBuilder: (product, onClose) => Scaffold(
                body: Column(
                  children: [
                    Text('Details of ${product.title}'),
                    TextButton(onPressed: onClose, child: const Text('Close')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select a product'), findsOneWidget);

      await tester.tap(find.text('Lipstick'));
      await tester.pump();
      expect(find.text('Details of Lipstick'), findsOneWidget);
      expect(find.text('Select a product'), findsNothing);

      await tester.tap(find.text('Close'));
      await tester.pump();
      expect(find.text('Select a product'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
