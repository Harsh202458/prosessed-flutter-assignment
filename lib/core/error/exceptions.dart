/// Low-level exceptions thrown by data sources.
///
/// Repositories catch these and convert them to domain `Failure`s, so they
/// never reach the presentation layer.
sealed class AppException implements Exception {
  const AppException([this.message]);

  final String? message;
}

/// HTTP 5xx or an unexpected status code.
final class ServerException extends AppException {
  const ServerException([super.message, this.statusCode]);

  final int? statusCode;
}

/// No internet connection, DNS failure or refused socket.
final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// Connect, send or receive timeout.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.message]);
}

/// HTTP 400, e.g. "Invalid credentials" from `/auth/login`.
final class BadRequestException extends AppException {
  const BadRequestException([super.message]);
}

/// HTTP 401 / 403: the session is missing, expired or cannot be refreshed.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

/// HTTP 404.
final class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

/// The response body did not match the expected shape.
final class ParseException extends AppException {
  const ParseException([super.message]);
}

/// Reading or writing local storage failed.
final class CacheException extends AppException {
  const CacheException([super.message]);
}
