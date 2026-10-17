import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Stream] into a [Listenable] so GoRouter re-runs its redirect
/// whenever the stream emits (e.g. on every auth state change).
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
