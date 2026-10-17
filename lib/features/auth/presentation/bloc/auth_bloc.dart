import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/features/auth/domain/usecases/check_session.dart';
import 'package:shopsphere/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The router redirects based on [AuthState.status].
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._checkSession,
    required this._logout,
    required SessionExpiryNotifier sessionExpiry,
  }) : super(const AuthState.unknown()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoggedIn>((_, emit) => emit(const AuthState.authenticated()));
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<_AuthSessionExpired>(_onSessionExpired);

    _expirySubscription = sessionExpiry.onExpired.listen(
      (_) => add(const _AuthSessionExpired()),
    );
  }

  final CheckSession _checkSession;
  final Logout _logout;
  late final StreamSubscription<void> _expirySubscription;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final hasSession = await _checkSession();
    emit(
      hasSession
          ? const AuthState.authenticated()
          : const AuthState.unauthenticated(),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onSessionExpired(
    _AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthStatus.unauthenticated) return;
    await _logout();
    emit(AuthState.unauthenticated(const UnauthorizedFailure().message));
  }

  @override
  Future<void> close() async {
    await _expirySubscription.cancel();
    return super.close();
  }
}
