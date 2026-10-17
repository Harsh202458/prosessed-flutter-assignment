import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/core/storage/token_storage.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/models/auth_tokens_model.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockRemote remote;
  late _MockTokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  final json = fixture('login_response.json');
  final user = UserModel.fromJson(json);
  final tokens = AuthTokensModel.fromJson(json);

  setUp(() {
    remote = _MockRemote();
    tokenStorage = _MockTokenStorage();
    repository = AuthRepositoryImpl(remote: remote, tokenStorage: tokenStorage);
  });

  When<Future<(UserModel, AuthTokensModel)>> stubLogin() => when(
    () => remote.login(
      username: any(named: 'username'),
      password: any(named: 'password'),
    ),
  );

  group('login', () {
    test('returns the user and stores both tokens on success', () async {
      stubLogin().thenAnswer((_) async => (user, tokens));
      when(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.login(username: 'emilys', password: 'x');

      expect(result, isA<Success<dynamic>>());
      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'fake-access-token',
          refreshToken: 'fake-refresh-token',
        ),
      ).called(1);
    });

    test(
      'maps HTTP 400 to an "invalid username or password" failure',
      () async {
        stubLogin().thenThrow(const BadRequestException('Invalid credentials'));

        final result = await repository.login(
          username: 'emilys',
          password: 'x',
        );

        expect(
          (result as Err).failure,
          AuthRepositoryImpl.invalidCredentials,
        );
        verifyNever(
          () => tokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ),
        );
      },
    );

    test('maps a network error to NetworkFailure', () async {
      stubLogin().thenThrow(const NetworkException());

      final result = await repository.login(username: 'emilys', password: 'x');

      expect((result as Err).failure, isA<NetworkFailure>());
    });

    test('maps a server error to ServerFailure', () async {
      stubLogin().thenThrow(const ServerException('boom', 500));

      final result = await repository.login(username: 'emilys', password: 'x');

      expect((result as Err).failure, isA<ServerFailure>());
    });
  });

  group('hasSession', () {
    test('is true when an access token is stored', () async {
      when(tokenStorage.readAccessToken).thenAnswer((_) async => 'token');
      expect(await repository.hasSession(), isTrue);
    });

    test('is false when no token is stored or storage fails', () async {
      when(tokenStorage.readAccessToken).thenAnswer((_) async => null);
      expect(await repository.hasSession(), isFalse);

      when(tokenStorage.readAccessToken).thenThrow(const CacheException());
      expect(await repository.hasSession(), isFalse);
    });
  });

  test('getCurrentUser maps 401 to UnauthorizedFailure', () async {
    when(remote.getCurrentUser).thenThrow(const UnauthorizedException());

    final result = await repository.getCurrentUser();

    expect((result as Err).failure, isA<UnauthorizedFailure>());
  });
}
