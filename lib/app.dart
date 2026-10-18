import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';

class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({
    required this.router,
    required this.authBloc,
    required this.cartCubit,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;
  final CartCubit cartCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: cartCubit),
      ],
      // Signing out (by choice or on session expiry) clears the local
      // session, which includes the cart.
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.status == AuthStatus.authenticated &&
            current.status == AuthStatus.unauthenticated,
        listener: (_, _) => unawaited(cartCubit.clear()),
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
