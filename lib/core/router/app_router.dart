import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/widgets/adaptive_shell.dart';
import 'package:shopsphere/features/cart/presentation/pages/cart_page.dart';
import 'package:shopsphere/features/products/presentation/pages/products_page.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';

abstract final class AppRoutes {
  static const String products = '/products';
  static const String cart = '/cart';
  static const String profile = '/profile';
}

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

GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.products,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          AdaptiveShell(navigationShell: shell, destinations: _destinations),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.products,
              builder: (context, state) => const ProductsPage(),
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
