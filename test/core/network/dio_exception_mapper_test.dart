import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/network/dio_exception_mapper.dart';

void main() {
  final options = RequestOptions(path: '/test');

  DioException badResponse(int status, [Object? data]) => DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: data,
    ),
  );

  group('mapDioException', () {
    test('maps timeouts to RequestTimeoutException', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final result = mapDioException(
          DioException(requestOptions: options, type: type),
        );
        expect(result, isA<RequestTimeoutException>(), reason: '$type');
      }
    });

    test('maps connection errors and SocketException to NetworkException', () {
      expect(
        mapDioException(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ),
        isA<NetworkException>(),
      );
      expect(
        mapDioException(
          DioException(
            requestOptions: options,
            error: const SocketException('Failed host lookup'),
          ),
        ),
        isA<NetworkException>(),
      );
    });

    test('maps 400 to BadRequestException and keeps the API message', () {
      final result = mapDioException(
        badResponse(400, {'message': 'Invalid credentials'}),
      );
      expect(result, isA<BadRequestException>());
      expect(result.message, 'Invalid credentials');
    });

    test('maps 401 and 403 to UnauthorizedException', () {
      expect(mapDioException(badResponse(401)), isA<UnauthorizedException>());
      expect(mapDioException(badResponse(403)), isA<UnauthorizedException>());
    });

    test('maps 404 to NotFoundException', () {
      expect(mapDioException(badResponse(404)), isA<NotFoundException>());
    });

    test('maps 5xx to ServerException with its status code', () {
      final result = mapDioException(badResponse(500));
      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 500);
    });
  });
}
