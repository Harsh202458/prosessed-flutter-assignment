import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';

/// The signed-in customer's profile.
// An interface so the data layer can be swapped and mocked in tests.
// ignore: one_member_abstracts
abstract interface class ProfileRepository {
  /// Fetches the profile from `/auth/me`. Fails with `UnauthorizedFailure`
  /// when the session is no longer valid (HTTP 401).
  Future<Result<User>> getProfile();
}
