import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/core/storage/token_storage.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._remote,
    required this._tokenStorage,
  });

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  static const invalidCredentials = BadRequestFailure(
    'Invalid username or password.',
  );

  @override
  Future<Result<User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final (user, tokens) = await _remote.login(
        username: username,
        password: password,
      );
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return Success(user.toEntity());
    } on BadRequestException {
      return const Err(invalidCredentials);
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final user = await _remote.getCurrentUser();
      return Success(user.toEntity());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }

  @override
  Future<bool> hasSession() async {
    try {
      final token = await _tokenStorage.readAccessToken();
      return token != null && token.isNotEmpty;
    } on CacheException {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _tokenStorage.clear();
    } on CacheException {
      // Nothing else to clean up; the user is signed out locally either way.
    }
  }
}
