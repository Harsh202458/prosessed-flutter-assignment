import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/storage/settings_storage.dart';

/// The app language: `null` follows the device, otherwise English or Hindi.
/// Remembered across restarts.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._storage) : super(_initial(_storage));

  final SettingsStorage _storage;

  static const List<Locale> supported = [Locale('en'), Locale('hi')];

  static Locale? _initial(SettingsStorage storage) {
    final code = storage.readLanguageCode();
    return supported.where((l) => l.languageCode == code).firstOrNull;
  }

  Future<void> select(Locale? locale) async {
    if (locale == state) return;
    emit(locale);
    try {
      await _storage.writeLanguageCode(locale?.languageCode);
    } on Object {
      // Not saving only means the choice resets on the next launch.
    }
  }
}
