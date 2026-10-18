import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/network/connectivity_service.dart';

/// `true` while the device is online. Drives the offline banner and the
/// automatic refresh when the connection comes back.
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(this._service) : super(true);

  final ConnectivityService _service;
  StreamSubscription<bool>? _subscription;

  Future<void> start() async {
    _subscription ??= _service.onStatusChange.listen(emit);
    final online = await _service.isOnline();
    if (!isClosed) emit(online);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
