import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopsphere/core/error/exceptions.dart';

/// Persists the access and refresh tokens in the platform keystore.
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  Future<String?> readAccessToken() =>
      _guard(() => _storage.read(key: _accessKey));

  Future<String?> readRefreshToken() =>
      _guard(() => _storage.read(key: _refreshKey));

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) => _guard(() async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  });

  Future<void> clear() => _guard(() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }
}
