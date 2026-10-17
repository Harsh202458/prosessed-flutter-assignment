import 'dart:async';

/// Broadcasts when the session can no longer be recovered (401 with no
/// refresh token, or the refresh itself failed with 401/403).
class SessionExpiryNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get onExpired => _controller.stream;

  void notifyExpired() => _controller.add(null);

  Future<void> dispose() => _controller.close();
}
