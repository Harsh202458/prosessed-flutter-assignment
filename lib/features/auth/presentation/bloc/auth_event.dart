part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once on app start from the splash screen.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired after a successful login.
final class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// The interceptor could not refresh the token (401/403).
final class _AuthSessionExpired extends AuthEvent {
  const _AuthSessionExpired();
}
