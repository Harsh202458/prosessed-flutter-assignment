import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';

class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({
    required this.router,
    required this.authBloc,
    required this.cartCubit,
    required this.profileCubit,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;
  final CartCubit cartCubit;
  final ProfileCubit profileCubit;

  void _onAuthChanged(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        unawaited(profileCubit.load());
      case AuthStatus.unauthenticated:
        // Signing out (by choice or on session expiry) clears the local
        // session: the profile and the cart.
        profileCubit.reset();
        unawaited(cartCubit.clear());
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
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: _onAuthChanged,
        child: MaterialApp.router(
          title: 'ShopSphere',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: router,
        ),
      ),
    );
  }
}
