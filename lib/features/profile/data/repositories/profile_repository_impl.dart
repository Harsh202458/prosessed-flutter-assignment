import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/result.dart';
import 'package:shopsphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/profile/domain/repositories/profile_repository.dart';

/// Reads the profile through the auth data source, which owns `/auth/me`
/// and its `UserModel`, so the endpoint is called from one place only.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Result<User>> getProfile() async {
    try {
      final user = await _remote.getCurrentUser();
      return Success(user.toEntity());
    } on Object catch (e) {
      return Err(mapToFailure(e));
    }
  }
}
