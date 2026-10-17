import 'package:dio/dio.dart';
import 'package:shopsphere/core/network/api_endpoints.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/core/storage/token_storage.dart';

/// Attaches the Bearer token to protected requests and transparently
/// refreshes an expired access token once before giving up.
///
/// It is a [QueuedInterceptor], so concurrent 401s wait for a single refresh
/// instead of each starting their own.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._tokenStorage,
    required this._sessionExpiry,
    required this._refreshDio,
  });

  /// Set `Options(extra: {AuthInterceptor.requiresAuth: true})` on requests
  /// that need the Bearer token.
  static const String requiresAuth = 'requiresAuth';
  static const String _retried = 'authRetried';

  final TokenStorage _tokenStorage;
  final SessionExpiryNotifier _sessionExpiry;

  /// A Dio without this interceptor, used for the refresh call and the retry.
  final Dio _refreshDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuth] == true) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized ||
        request.extra[requiresAuth] != true ||
        request.extra[_retried] == true) {
      return handler.next(err);
    }

    final String? newAccessToken;
    try {
      newAccessToken = await _refreshAccessToken();
    } on DioException {
      // Offline or server error during refresh: keep the session and surface
      // the original error so the screen can offer a retry.
      return handler.next(err);
    }
    if (newAccessToken == null) {
      await _expireSession();
      return handler.next(err);
    }

    request
      ..headers['Authorization'] = 'Bearer $newAccessToken'
      ..extra[_retried] = true;
    try {
      handler.resolve(await _refreshDio.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// Returns the new access token, or `null` if the refresh token is missing
  /// or rejected (401/403). Rethrows other [DioException]s.
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) return null;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {
          'refreshToken': refreshToken,
          'expiresInMins': ApiEndpoints.sessionDurationMins,
        },
      );
      final data = response.data;
      final access = data?['accessToken'];
      final refresh = data?['refreshToken'];
      if (access is! String || refresh is! String) return null;
      await _tokenStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );
      return access;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) return null;
      rethrow;
    }
  }

  Future<void> _expireSession() async {
    await _tokenStorage.clear();
    _sessionExpiry.notifyExpired();
  }
}
