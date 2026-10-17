import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  /// Signs in and stores the access and refresh tokens.
  Future<Result<User>> login({
    required String username,
    required String password,
  });

  /// Fetches the signed-in user from `/auth/me`.
  Future<Result<User>> getCurrentUser();

  /// Whether a stored session (access token) exists on this device.
  Future<bool> hasSession();

  /// Clears tokens and any local session data.
  Future<void> logout();
}
