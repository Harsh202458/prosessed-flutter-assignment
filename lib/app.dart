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
      child: SessionEffects(
        onSignedIn: () => unawaited(profileCubit.load()),
        onSignedOut: () {
          // Signing out (by choice or on session expiry) clears the local
          // session: the profile, the cart and the wishlist.
          profileCubit.reset();
          unawaited(cartCubit.clear());
          unawaited(wishlistCubit.clear());
        },
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

/// Runs [onSignedIn] / [onSignedOut] whenever the session changes, and once
/// for the session state found when it is first built.
///
/// The initial check matters: `main` starts the session check before the
/// widget tree exists, and on a fast device the result can arrive before a
/// plain listener subscribes, which would silently skip loading the profile.
class SessionEffects extends StatefulWidget {
  const SessionEffects({
    required this.onSignedIn,
    required this.onSignedOut,
    required this.child,
    super.key,
  });

  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;
  final Widget child;

  @override
  State<SessionEffects> createState() => _SessionEffectsState();
}

class _SessionEffectsState extends State<SessionEffects> {
  @override
  void initState() {
    super.initState();
    _handle(context.read<AuthBloc>().state);
  }

  void _handle(AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        widget.onSignedIn();
      case AuthStatus.unauthenticated:
        widget.onSignedOut();
      case AuthStatus.unknown:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) => _handle(state),
      child: widget.child,
    );
  }
}
