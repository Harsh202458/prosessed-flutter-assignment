import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopsphere/core/network/connectivity_cubit.dart';
import 'package:shopsphere/core/network/connectivity_service.dart';

class _FakeConnectivity implements ConnectivityService {
  _FakeConnectivity({required this.initiallyOnline});

  final bool initiallyOnline;
  final StreamController<bool> controller = StreamController<bool>();

  @override
  Future<bool> isOnline() async => initiallyOnline;

  @override
  Stream<bool> get onStatusChange => controller.stream;
}

void main() {
  blocTest<ConnectivityCubit, bool>(
    'reports offline when the device starts without a connection',
    build: () => ConnectivityCubit(_FakeConnectivity(initiallyOnline: false)),
    act: (cubit) => cubit.start(),
    expect: () => const [false],
  );

  test('follows the connectivity stream after starting', () async {
    final fake = _FakeConnectivity(initiallyOnline: true);
    final cubit = ConnectivityCubit(fake);
    await cubit.start();
    expect(cubit.state, isTrue);

    fake.controller.add(false);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isFalse);

    fake.controller.add(true);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isTrue);

    await cubit.close();
  });
}
