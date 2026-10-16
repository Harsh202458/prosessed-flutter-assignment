import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failure_mapper.dart';
import 'package:shopsphere/core/error/failures.dart';

void main() {
  group('mapToFailure', () {
    test('maps each AppException to its matching Failure', () {
      expect(mapToFailure(const ServerException()), const ServerFailure());
      expect(mapToFailure(const NetworkException()), const NetworkFailure());
      expect(
        mapToFailure(const RequestTimeoutException()),
        const TimeoutFailure(),
      );
      expect(
        mapToFailure(const UnauthorizedException()),
        const UnauthorizedFailure(),
      );
      expect(mapToFailure(const NotFoundException()), const NotFoundFailure());
      expect(mapToFailure(const CacheException()), const CacheFailure());
    });

    test('BadRequestFailure carries the API message when present', () {
      expect(
        mapToFailure(const BadRequestException('Invalid credentials')),
        const BadRequestFailure('Invalid credentials'),
      );
      expect(
        mapToFailure(const BadRequestException()),
        const BadRequestFailure(),
      );
    });

    test('maps parse errors to ParseFailure', () {
      expect(mapToFailure(const ParseException()), const ParseFailure());
      expect(mapToFailure(const FormatException()), const ParseFailure());
    });

    test('falls back to UnknownFailure for anything else', () {
      expect(mapToFailure(StateError('boom')), const UnknownFailure());
    });
  });
}
