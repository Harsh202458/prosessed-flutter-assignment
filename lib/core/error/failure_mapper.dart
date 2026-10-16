import 'package:shopsphere/core/error/exceptions.dart';
import 'package:shopsphere/core/error/failures.dart';

/// Converts anything thrown in the data layer into a user-facing [Failure].
Failure mapToFailure(Object error) => switch (error) {
  ServerException() => const ServerFailure(),
  NetworkException() => const NetworkFailure(),
  RequestTimeoutException() => const TimeoutFailure(),
  BadRequestException(:final message) =>
    message == null ? const BadRequestFailure() : BadRequestFailure(message),
  UnauthorizedException() => const UnauthorizedFailure(),
  NotFoundException() => const NotFoundFailure(),
  ParseException() || FormatException() || TypeError() => const ParseFailure(),
  CacheException() => const CacheFailure(),
  _ => const UnknownFailure(),
};
