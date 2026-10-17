import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/di/injection.dart';
import 'package:shopsphere/core/router/app_routes.dart';
import 'package:shopsphere/core/router/stream_listenable.dart';
import 'package:shopsphere/core/widgets/adaptive_shell.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/auth/presentation/pages/login_page.dart';
import 'package:shopsphere/features/auth/presentation/pages/splash_page.dart';
import 'package:shopsphere/features/cart/presentation/pages/cart_page.dart';
import 'package:shopsphere/features/products/domain/entities/product.dart';
import 'package:shopsphere/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shopsphere/features/products/presentation/cubit/categories_cubit.dart';
import 'package:shopsphere/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:shopsphere/features/products/presentation/pages/product_details_page.dart';
import 'package:shopsphere/features/products/presentation/pages/products_page.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';

const _destinations = [
  ShellDestination(
    label: 'Shop',
    icon: Icons.storefront_outlined,
    selectedIcon: Icons.storefront,
  ),
  ShellDestination(
    label: 'Cart',
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag,
  ),
  ShellDestination(
    label: 'Profile',
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          AdaptiveShell(navigationShell: shell, destinations: _destinations),
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
                child: const ProductsPage(),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.tryParse(state.pathParameters['id'] ?? '');
                    return BlocProvider(
                      create: (_) {
                        final cubit = sl<ProductDetailsCubit>();
                        unawaited(cubit.load(id));
                        return cubit;
                      },
                      child: ProductDetailsPage(
                        productId: id,
                        preview: state.extra is Product
                            ? state.extra! as Product
                            : null,
                      ),
                    );
                  },
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
