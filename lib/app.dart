import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({
    required this.router,
    required this.authBloc,
    required this.cartCubit,
    required this.profileCubit,
    required this.themeCubit,
    required this.connectivityCubit,
    required this.wishlistCubit,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;
  final CartCubit cartCubit;
  final ProfileCubit profileCubit;
  final ThemeCubit themeCubit;
  final ConnectivityCubit connectivityCubit;
  final WishlistCubit wishlistCubit;

  void _onAuthChanged(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        unawaited(profileCubit.load());
      case AuthStatus.unauthenticated:
        // Signing out (by choice or on session expiry) clears the local
        // session: the profile, the cart and the wishlist.
        profileCubit.reset();
        unawaited(cartCubit.clear());
        unawaited(wishlistCubit.clear());
      case AuthStatus.unknown:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: cartCubit),
        BlocProvider.value(value: profileCubit),
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: connectivityCubit),
        BlocProvider.value(value: wishlistCubit),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onAuthChanged,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) => MaterialApp.router(
            title: 'ShopSphere',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
