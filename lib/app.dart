import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';

class ShopSphereApp extends StatelessWidget {
  const ShopSphereApp({
    required this.router,
    required this.authBloc,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        title: 'ShopSphere',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
      ),
    );
  }
}
