import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/auth/presentation/cubit/login_cubit.dart';
import 'package:shopsphere/features/auth/presentation/pages/login_page.dart';
import 'package:shopsphere/l10n/app_localizations.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late _MockAuthBloc authBloc;
  late _MockLoginCubit loginCubit;

  setUp(() {
    authBloc = _MockAuthBloc();
    loginCubit = _MockLoginCubit();
    when(() => authBloc.state).thenReturn(const AuthState.unauthenticated());
  });

  Future<void> pumpLogin(
    WidgetTester tester, {
    LoginState state = const LoginState(),
    Size size = const Size(360, 740),
    double textScale = 1,
    Locale locale = const Locale('en'),
  }) async {
    when(() => loginCubit.state).thenReturn(state);
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<LoginCubit>.value(value: loginCubit),
          ],
          child: const LoginPage(),
        ),
      ),
    );
  }

  testWidgets('shows inline errors and does not submit an empty form', (
    tester,
  ) async {
    await pumpLogin(tester);

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    verifyNever(
      () => loginCubit.submit(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('shows the invalid credentials message from the cubit', (
    tester,
  ) async {
    await pumpLogin(
      tester,
      state: const LoginState(
        status: LoginStatus.failure,
        errorMessage: 'Invalid username or password.',
      ),
    );

    expect(find.text('Invalid username or password.'), findsOneWidget);
  });

  testWidgets('renders in Hindi, including validation messages', (
    tester,
  ) async {
    await pumpLogin(tester, locale: const Locale('hi'));

    expect(find.text('फिर से स्वागत है'), findsOneWidget);
    await tester.tap(find.text('साइन इन करें'));
    await tester.pump();

    expect(find.text('कृपया अपना यूज़रनेम डालें'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lays out without overflow on a phone at 1.3x and in landscape', (
    tester,
  ) async {
    await pumpLogin(tester, textScale: 1.3);
    expect(tester.takeException(), isNull);

    await pumpLogin(tester, size: const Size(800, 380), textScale: 1.3);
    expect(tester.takeException(), isNull);
  });
}
