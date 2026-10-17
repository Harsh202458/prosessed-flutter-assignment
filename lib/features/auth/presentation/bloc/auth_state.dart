part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState._(this.status, [this.message]);

  const AuthState.unknown() : this._(AuthStatus.unknown);
  const AuthState.authenticated() : this._(AuthStatus.authenticated);

  /// [message] explains why the user was signed out, e.g. session expiry.
  const AuthState.unauthenticated([String? message])
    : this._(AuthStatus.unauthenticated, message);

  final AuthStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
