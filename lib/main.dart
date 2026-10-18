import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/app.dart';
import 'package:shopsphere/core/di/injection.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final authBloc = sl<AuthBloc>()..add(const AuthCheckRequested());
  final cartCubit = sl<CartCubit>();
  unawaited(cartCubit.load());
  final connectivityCubit = sl<ConnectivityCubit>();
  unawaited(connectivityCubit.start());

  runApp(
    ShopSphereApp(
      router: sl<GoRouter>(),
      authBloc: authBloc,
      cartCubit: cartCubit,
      profileCubit: sl<ProfileCubit>(),
      themeCubit: sl<ThemeCubit>(),
      connectivityCubit: connectivityCubit,
    ),
  );
}
