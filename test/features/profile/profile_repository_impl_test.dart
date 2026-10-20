import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/profile/data/repositories/profile_repository_impl.dart';

import '../../fixtures/fixture_reader.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = ProfileRepositoryImpl(remote);
  });

  Matcher failsWith<F extends Failure>() => isA<Err<User>>().having(
    (e) => e.failure,
    'failure',
    isA<F>(),
  );

  test('returns the profile parsed from /auth/me', () async {
    when(() => remote.getCurrentUser()).thenAnswer(
      (_) async => UserModel.fromJson(fixture('me_response.json')),
    );

    final result = await repository.getProfile();

    expect(
      result,
      isA<Success<User>>()
          .having((s) => s.data.username, 'username', 'emilys')
          .having((s) => s.data.phone, 'phone', isNotNull),
    );
  });

  test('maps a 401 to UnauthorizedFailure', () async {
    when(
      () => remote.getCurrentUser(),
    ).thenThrow(const UnauthorizedException());

    expect(await repository.getProfile(), failsWith<UnauthorizedFailure>());
  });

  test('maps a 500 to ServerFailure', () async {
    when(
      () => remote.getCurrentUser(),
    ).thenThrow(const ServerException('boom', 500));

    expect(await repository.getProfile(), failsWith<ServerFailure>());
  });

  test('maps no connection to NetworkFailure', () async {
    when(() => remote.getCurrentUser()).thenThrow(const NetworkException());

    expect(await repository.getProfile(), failsWith<NetworkFailure>());
  });
}
