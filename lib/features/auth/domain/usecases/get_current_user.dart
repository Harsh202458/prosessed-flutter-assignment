import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/domain/repositories/auth_repository.dart';

/// The signed-in user from `/auth/me`. A 401 is refreshed or turned into a
/// sign-out by the auth interceptor before this returns.
class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call() => _repository.getCurrentUser();
}
