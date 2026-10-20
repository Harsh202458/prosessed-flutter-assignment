import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/di/injection.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/router/stream_listenable.dart';
import 'package:shopsphere/core/widgets/adaptive_shell.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/auth/presentation/pages/login_page.dart';
import 'package:shopsphere/features/auth/presentation/pages/splash_page.dart';
import 'package:shopsphere/features/cart/domain/entities/order_confirmation.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/cart/presentation/pages/cart_page.dart';
import 'package:shopsphere/features/cart/presentation/pages/order_confirmation_page.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:shopsphere/features/products/presentation/pages/product_details_page.dart';
import 'package:shopsphere/features/products/presentation/pages/products_page.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';
import 'package:shopsphere/features/wishlist/presentation/pages/wishlist_page.dart';

String _shopLabel(BuildContext context) => context.l10n.navShop;
String _cartLabel(BuildContext context) => context.l10n.navCart;
String _profileLabel(BuildContext context) => context.l10n.navProfile;

const _destinations = [
  ShellDestination(
    label: _shopLabel,
    icon: Icons.storefront_outlined,
    selectedIcon: Icons.storefront,
  ),
  ShellDestination(
    label: _cartLabel,
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag,
  ),
  ShellDestination(
    label: _profileLabel,
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];

GoRouter createRouter(AuthBloc authBloc) => GoRouter(
  initialLocation: AppRoutes.splash,
  refreshListenable: StreamListenable(authBloc.stream),
  redirect: (context, state) =>
      _redirect(authBloc.state.status, state.matchedLocation),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<LoginCubit>(),
        child: const LoginPage(),
      ),
    ),
    // Full screen above the shell, so the Cart tab keeps showing the cart
    // (not a stale confirmation) after the user continues shopping.
    GoRoute(
      path: AppRoutes.orderConfirmation,
      redirect: (context, state) =>
          state.extra is OrderConfirmation ? null : AppRoutes.cart,
      builder: (context, state) =>
          OrderConfirmationPage(order: state.extra! as OrderConfirmation),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          BlocSelector<CartCubit, CartState, int>(
            selector: (cart) => cart.totals.itemCount,
            builder: (context, cartCount) => AdaptiveShell(
              navigationShell: shell,
              destinations: _destinations,
              badges: {1: cartCount},
            ),
          ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.products,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        sl<ProductListBloc>()..add(const ProductListStarted()),
                  ),
                  BlocProvider(
                    create: (_) {
                      final cubit = sl<CategoriesCubit>();
                      unawaited(cubit.load());
                      return cubit;
                    },
                  ),
                ],
                child: ProductsPage(
                  detailsBuilder: (product, onClose) => _productDetails(
                    context,
                    id: product.id,
                    preview: product,
                    onClose: onClose,
                  ),
                ),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => _productDetails(
                    context,
                    id: int.tryParse(state.pathParameters['id'] ?? ''),
                    preview: state.extra is Product
                        ? state.extra! as Product
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'wishlist',
                  builder: (context, state) => const WishlistPage(),
                  routes: [
                    // Details opened from the wishlist stay in the Profile
                    // tab instead of jumping to the Shop tab.
                    GoRoute(
                      path: ':id',
                      builder: (context, state) => _productDetails(
                        context,
                        id: int.tryParse(state.pathParameters['id'] ?? ''),
                        preview: state.extra is Product
                            ? state.extra! as Product
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Keeps users on the splash screen until the session is known, sends
/// signed-out users to login, and keeps signed-in users out of both.
String? _redirect(AuthStatus status, String location) {
  final onSplash = location == AppRoutes.splash;
  final onLogin = location == AppRoutes.login;
  return switch (status) {
    AuthStatus.unknown => onSplash ? null : AppRoutes.splash,
    AuthStatus.unauthenticated => onLogin ? null : AppRoutes.login,
    AuthStatus.authenticated => onSplash || onLogin ? AppRoutes.products : null,
  };
}

/// Product details with its own cubit, synced with what's already in the
/// cart. Used both as a full page and as the master-detail pane.
Widget _productDetails(
  BuildContext context, {
  required int? id,
  Product? preview,
  VoidCallback? onClose,
}) {
  return BlocProvider(
    create: (_) {
      final cubit = sl<ProductDetailsCubit>();
      if (id != null) {
        cubit.syncCartQuantity(context.read<CartCubit>().state.quantityOf(id));
      }
      unawaited(cubit.load(id));
      return cubit;
    },
    child: ProductDetailsPage(
      productId: id,
      preview: preview,
      onClose: onClose,
    ),
  );
}
