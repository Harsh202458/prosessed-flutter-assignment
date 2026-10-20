import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/error/failures.dart';
import 'package:shopsphere/core/l10n/l10n.dart';
import 'package:shopsphere/core/l10n/locale_cubit.dart';
import 'package:shopsphere/core/storage/settings_storage.dart';
import 'package:shopsphere/l10n/app_localizations_en.dart';
import 'package:shopsphere/l10n/app_localizations_hi.dart';

class _MockSettingsStorage extends Mock implements SettingsStorage {}

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('English and Hindi translations define exactly the same keys', () {
    Set<String> keys(String lang) =>
        _arb(lang).keys.where((k) => !k.startsWith('@')).toSet();

    expect(keys('hi'), keys('en'));
  });

  group('errorText', () {
    final en = AppLocalizationsEn();
    final hi = AppLocalizationsHi();

    test('translates known failure messages', () {
      expect(
        hi.errorText(const NetworkFailure().message),
        'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जाँचें और फिर से कोशिश करें।',
      );
      expect(
        en.errorText(const InvalidCredentialsFailure().message),
        'Invalid username or password.',
      );
    });

    test('shows unknown messages (e.g. from the API) unchanged', () {
      expect(
        hi.errorText('products can not be empty'),
        'products can not be empty',
      );
    });

    test('falls back to a generic error for a missing message', () {
      expect(en.errorText(null), en.errorUnknown);
    });
  });

  group('LocaleCubit', () {
    late _MockSettingsStorage storage;

    setUp(() {
      storage = _MockSettingsStorage();
      when(() => storage.writeLanguageCode(any())).thenAnswer((_) async {});
    });

    test('starts with the saved language, or follows the device', () {
      when(() => storage.readLanguageCode()).thenReturn('hi');
      expect(LocaleCubit(storage).state, const Locale('hi'));

      when(() => storage.readLanguageCode()).thenReturn(null);
      expect(LocaleCubit(storage).state, isNull);

      when(() => storage.readLanguageCode()).thenReturn('fr');
      expect(LocaleCubit(storage).state, isNull);
    });

    blocTest<LocaleCubit, Locale?>(
      'switches language and remembers it',
      setUp: () => when(() => storage.readLanguageCode()).thenReturn(null),
      build: () => LocaleCubit(storage),
      act: (cubit) async {
        await cubit.select(const Locale('hi'));
        await cubit.select(null);
      },
      expect: () => const [Locale('hi'), null],
      verify: (_) {
        verify(() => storage.writeLanguageCode('hi')).called(1);
        verify(() => storage.writeLanguageCode(null)).called(1);
      },
    );
  });
}
