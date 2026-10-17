import 'package:dio/dio.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';
import 'package:shopsphere/core/network/auth_interceptor.dart';
import 'package:shopsphere/core/network/dio_exception_mapper.dart';
import 'package:shopsphere/features/auth/data/models/auth_tokens_model.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<(UserModel, AuthTokensModel)> login({
    required String username,
    required String password,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<(UserModel, AuthTokensModel)> login({
    required String username,
    required String password,
  }) async {
    final json = await _post(
      ApiEndpoints.login,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': ApiEndpoints.sessionDurationMins,
      },
    );
    return (UserModel.fromJson(json), AuthTokensModel.fromJson(json));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        options: Options(extra: {AuthInterceptor.requiresAuth: true}),
      );
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> _post(String path, {Object? data}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
