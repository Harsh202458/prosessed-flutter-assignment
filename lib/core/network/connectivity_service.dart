import 'package:connectivity_plus/connectivity_plus.dart';

/// Whether the device has a network connection. Wrapped so the rest of the
/// app (and its tests) don't depend on the plugin directly.
abstract interface class ConnectivityService {
  Future<bool> isOnline();

  Stream<bool> get onStatusChange;
}

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async =>
      _hasConnection(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_hasConnection);
}
