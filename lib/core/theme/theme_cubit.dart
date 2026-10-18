import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsphere/core/storage/settings_storage.dart';

/// The user's light / dark / system choice, remembered across restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage) : super(_storage.readThemeMode());

  final SettingsStorage _storage;

  Future<void> select(ThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    try {
      await _storage.writeThemeMode(mode);
    } on Object {
      // Not saving only means the choice resets on the next launch.
    }
  }
}
