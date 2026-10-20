import 'package:equatable/equatable.dart';

/// Domain-level failures with messages that are safe to show to the user.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on our side. Please try again.',
  ]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Check your network and retry.',
  ]);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'The request took too long. Please try again.',
  ]);
}

final class BadRequestFailure extends Failure {
  const BadRequestFailure([
    super.message = 'The request could not be processed.',
  ]);
}

/// HTTP 400 from `/auth/login`.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = 'Invalid username or password.',
  ]);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = "We couldn't find what you were looking for.",
  ]);
}

final class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'We received an unexpected response. Please try again.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Could not access saved data on this device.',
  ]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
