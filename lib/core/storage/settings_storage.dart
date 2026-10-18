import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

/// Small key-value store for app preferences, backed by a Hive box.
class SettingsStorage {
  const SettingsStorage(this._box);

  static const String boxName = 'settings';
  static const String _themeModeKey = 'theme_mode';

  final Box<String> _box;

  ThemeMode readThemeMode() {
    final stored = _box.get(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> writeThemeMode(ThemeMode mode) =>
      _box.put(_themeModeKey, mode.name);
}
