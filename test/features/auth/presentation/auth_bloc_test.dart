import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/features/auth/domain/usecases/check_session.dart';
import 'package:shopsphere/features/auth/domain/usecases/logout.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';

class _MockCheckSession extends Mock implements CheckSession {}

class _MockLogout extends Mock implements Logout {}

void main() {
  late _MockCheckSession checkSession;
  late _MockLogout logout;
  late SessionExpiryNotifier sessionExpiry;

  setUp(() {
    checkSession = _MockCheckSession();
    logout = _MockLogout();
    sessionExpiry = SessionExpiryNotifier();
    when(() => logout()).thenAnswer((_) async {});
  });

  AuthBloc build() => AuthBloc(
    checkSession: checkSession,
    logout: logout,
    sessionExpiry: sessionExpiry,
  );

  blocTest<AuthBloc, AuthState>(
    'emits authenticated when a stored session exists',
    setUp: () => when(() => checkSession()).thenAnswer((_) async => true),
    build: build,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => const [AuthState.authenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated when there is no stored session',
    setUp: () => when(() => checkSession()).thenAnswer((_) async => false),
    build: build,
    act: (bloc) => bloc.add(const AuthCheckRequested()),
    expect: () => const [AuthState.unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'clears the session and emits unauthenticated on logout',
    build: build,
    seed: () => const AuthState.authenticated(),
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    expect: () => const [AuthState.unauthenticated()],
    verify: (_) => verify(() => logout()).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'signs out with an explanatory message when the session expires',
    build: build,
    seed: () => const AuthState.authenticated(),
    act: (_) => sessionExpiry.notifyExpired(),
    expect: () => [
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.unauthenticated)
          .having((s) => s.message, 'message', contains('expired')),
    ],
  );
}
