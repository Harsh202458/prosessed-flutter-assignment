import 'package:shopsphere/core/error/failures.dart';

/// The outcome of a repository or use-case call: either data or a [Failure].
sealed class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) => switch (this) {
    Success<T>(:final data) => onSuccess(data),
    Err<T>(:final failure) => onFailure(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
