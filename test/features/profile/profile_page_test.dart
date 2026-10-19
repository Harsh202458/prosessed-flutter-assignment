import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/theme/app_theme.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';
import 'package:shopsphere/features/auth/domain/entities/user.dart';
import 'package:shopsphere/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shopsphere/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shopsphere/features/profile/presentation/pages/profile_page.dart';
import 'package:shopsphere/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockWishlistCubit extends MockCubit<WishlistState>
    implements WishlistCubit {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

void main() {
  late _MockWishlistCubit wishlistCubit;
  late _MockProfileCubit profileCubit;
  late _MockAuthBloc authBloc;
  late _MockThemeCubit themeCubit;

  const user = User(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: '',
    phone: '+81 965-431-3024',
  );

  setUpAll(() => registerFallbackValue(const AuthLogoutRequested()));

  setUp(() {
    wishlistCubit = _MockWishlistCubit();
    when(() => wishlistCubit.state).thenReturn(const WishlistState());
    profileCubit = _MockProfileCubit();
    authBloc = _MockAuthBloc();
    themeCubit = _MockThemeCubit();
    when(() => themeCubit.state).thenReturn(ThemeMode.system);
    when(() => authBloc.state).thenReturn(const AuthState.authenticated());
  });

  Future<void> pump(WidgetTester tester, ProfileState state) async {
    when(() => profileCubit.state).thenReturn(state);
    tester.view
      ..physicalSize = const Size(400, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<WishlistCubit>.value(value: wishlistCubit),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: const ProfilePage(),
        ),
      ),
    );
  }

  testWidgets('shows the name, email and phone from /auth/me', (
    tester,
  ) async {
    await pump(
      tester,
      const ProfileState(status: ProfileStatus.success, user: user),
    );

    expect(find.text('Emily Johnson'), findsOneWidget);
    expect(find.text('emily.johnson@x.dummyjson.com'), findsOneWidget);
    expect(find.text('+81 965-431-3024'), findsOneWidget);
  });

  testWidgets('asks for confirmation before logging out', (tester) async {
    await pump(
      tester,
      const ProfileState(status: ProfileStatus.success, user: user),
    );

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.pumpAndSettle();
    verifyNever(() => authBloc.add(any()));

    await tester.tap(find.widgetWithText(FilledButton, 'Log out'));
    await tester.pumpAndSettle();
    verify(() => authBloc.add(const AuthLogoutRequested())).called(1);
  });

  testWidgets('shows a retry when the profile cannot be loaded', (
    tester,
  ) async {
    await pump(
      tester,
      const ProfileState(
        status: ProfileStatus.failure,
        errorMessage: 'No internet connection.',
      ),
    );

    expect(find.text("Couldn't load your profile"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
