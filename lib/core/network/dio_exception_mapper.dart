import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopsphere/core/error/exceptions.dart';

/// Translates a [DioException] into one of the app's typed [AppException]s.
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const RequestTimeoutException();
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return const NetworkException();
    case DioExceptionType.badResponse:
      return _fromResponse(e.response);
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return e.error is SocketException
          ? const NetworkException()
          : ServerException(e.message);
  }
}

AppException _fromResponse(Response<dynamic>? response) {
  final status = response?.statusCode;
  final message = _messageFrom(response?.data);
  return switch (status) {
    400 => BadRequestException(message),
    401 || 403 => UnauthorizedException(message),
    404 => NotFoundException(message),
    _ => ServerException(message, status),
  };
}

String? _messageFrom(Object? data) {
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}
