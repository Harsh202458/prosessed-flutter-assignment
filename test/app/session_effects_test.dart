import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/app.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockAuthBloc authBloc;
  late List<String> calls;

  setUp(() {
    authBloc = _MockAuthBloc();
    calls = [];
  });

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: SessionEffects(
        onSignedIn: () => calls.add('in'),
        onSignedOut: () => calls.add('out'),
        child: const SizedBox(),
      ),
    ),
  );

  testWidgets(
    'handles a session that was already restored before the app was built',
    (tester) async {
      // The race behind a real bug: the session check finished before any
      // listener existed, so the profile never loaded.
      when(() => authBloc.state).thenReturn(const AuthState.authenticated());

      await pump(tester);

      expect(calls, ['in']);
    },
  );

  testWidgets('reacts to sign-in and sign-out after start-up', (tester) async {
    final states = StreamController<AuthState>();
    addTearDown(states.close);
    whenListen(
      authBloc,
      states.stream,
      initialState: const AuthState.unknown(),
    );

    await pump(tester);
    expect(calls, isEmpty);

    states.add(const AuthState.authenticated());
    await tester.pump();
    states.add(const AuthState.unauthenticated());
    await tester.pump();

    expect(calls, ['in', 'out']);
  });
}
