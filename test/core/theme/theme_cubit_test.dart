import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/storage/settings_storage.dart';
import 'package:shopsphere/core/theme/theme_cubit.dart';

class _MockSettingsStorage extends Mock implements SettingsStorage {}

void main() {
  late _MockSettingsStorage storage;

  setUpAll(() => registerFallbackValue(ThemeMode.system));

  setUp(() {
    storage = _MockSettingsStorage();
    when(() => storage.writeThemeMode(any())).thenAnswer((_) async {});
  });

  test('starts with the saved choice', () {
    when(() => storage.readThemeMode()).thenReturn(ThemeMode.dark);
    expect(ThemeCubit(storage).state, ThemeMode.dark);
  });

  blocTest<ThemeCubit, ThemeMode>(
    'emits and saves a new choice',
    setUp: () =>
        when(() => storage.readThemeMode()).thenReturn(ThemeMode.system),
    build: () => ThemeCubit(storage),
    act: (cubit) => cubit.select(ThemeMode.light),
    expect: () => const [ThemeMode.light],
    verify: (_) => verify(() => storage.writeThemeMode(ThemeMode.light)),
  );

  blocTest<ThemeCubit, ThemeMode>(
    'keeps the new choice for this session even if saving fails',
    setUp: () {
      when(() => storage.readThemeMode()).thenReturn(ThemeMode.system);
      when(() => storage.writeThemeMode(any())).thenThrow(Exception('disk'));
    },
    build: () => ThemeCubit(storage),
    act: (cubit) => cubit.select(ThemeMode.dark),
    expect: () => const [ThemeMode.dark],
  );
}
