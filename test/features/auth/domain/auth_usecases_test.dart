import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopsphere/features/auth/domain/usecases/check_session.dart';
import 'package:shopsphere/features/auth/domain/usecases/get_current_user.dart';
import 'package:shopsphere/features/auth/domain/usecases/login.dart';
import 'package:shopsphere/features/auth/domain/usecases/logout.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  const user = User(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: '',
  );

  setUp(() => repository = _MockAuthRepository());

  group('Login', () {
    test('trims the username and returns the signed-in user', () async {
      when(
        () => repository.login(username: 'emilys', password: ' emilyspass'),
      ).thenAnswer((_) async => const Success(user));

      final result = await Login(
        repository,
      )(username: '  emilys ', password: ' emilyspass');

      expect(result, isA<Success<User>>().having((s) => s.data, 'data', user));
      verify(
        () => repository.login(username: 'emilys', password: ' emilyspass'),
      ).called(1);
    });

    test('passes invalid credentials through as a failure', () async {
      when(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Err(InvalidCredentialsFailure()));

      final result = await Login(
        repository,
      )(username: 'emilys', password: 'wrong');

      expect(
        result,
        isA<Err<User>>().having(
          (e) => e.failure,
          'failure',
          isA<InvalidCredentialsFailure>(),
        ),
      );
    });
  });

  test('GetCurrentUser returns the user from /auth/me', () async {
    when(
      () => repository.getCurrentUser(),
    ).thenAnswer((_) async => const Success(user));

    expect(
      await GetCurrentUser(repository)(),
      isA<Success<User>>().having((s) => s.data, 'data', user),
    );
  });

  test('CheckSession reports whether a stored session exists', () async {
    when(() => repository.hasSession()).thenAnswer((_) async => true);

    expect(await CheckSession(repository)(), isTrue);
  });

  test('Logout clears the session through the repository', () async {
    when(() => repository.logout()).thenAnswer((_) async {});

    await Logout(repository)();

    verify(() => repository.logout()).called(1);
  });
}
