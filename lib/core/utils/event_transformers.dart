import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

/// Default search debounce from the brief (~400 ms).
const Duration searchDebounce = Duration(milliseconds: 400);

/// Waits for [duration] of silence, then handles only the latest event and
/// cancels any in-flight handler for an older one.
EventTransformer<E> debounceRestartable<E>([
  Duration duration = searchDebounce,
]) {
  return (events, mapper) =>
      restartable<E>().call(events.debounce(duration), mapper);
}
