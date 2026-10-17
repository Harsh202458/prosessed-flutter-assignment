import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/domain/usecases/login.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';

class _MockLogin extends Mock implements Login {}

void main() {
  late _MockLogin login;

  const user = User(
    id: 1,
    username: 'emilys',
    email: 'e@x.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: '',
  );

  setUp(() => login = _MockLogin());

  void stubLogin(Result<User> result) => when(
    () => login(
      username: any(named: 'username'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => result);

  blocTest<LoginCubit, LoginState>(
    'emits [submitting, success] when login succeeds',
    setUp: () => stubLogin(const Success(user)),
    build: () => LoginCubit(login),
    act: (cubit) => cubit.submit(username: 'emilys', password: 'emilyspass'),
    expect: () => const [
      LoginState(status: LoginStatus.submitting),
      LoginState(status: LoginStatus.success),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [submitting, failure] with the failure message on bad credentials',
    setUp: () => stubLogin(
      const Err(BadRequestFailure('Invalid username or password.')),
    ),
    build: () => LoginCubit(login),
    act: (cubit) => cubit.submit(username: 'emilys', password: 'wrongpass'),
    expect: () => const [
      LoginState(status: LoginStatus.submitting),
      LoginState(
        status: LoginStatus.failure,
        errorMessage: 'Invalid username or password.',
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'toggles password visibility',
    build: () => LoginCubit(login),
    act: (cubit) => cubit
      ..togglePasswordVisibility()
      ..togglePasswordVisibility(),
    expect: () => const [
      LoginState(obscurePassword: false),
      LoginState(),
    ],
  );
}
