import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/pomodoro_settings.dart';
import '../domain/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository(this._preferences);

  static const _storageKey = 'settings.v1';

  final SharedPreferences _preferences;

  @override
  Future<PomodoroSettings> load() async {
    final rawValue = _preferences.getString(_storageKey);
    if (rawValue == null || rawValue.isEmpty) {
      return PomodoroSettings.defaults;
    }

    try {
      final decoded = jsonDecode(rawValue) as Map<String, dynamic>;
      return PomodoroSettings.fromJson(decoded);
    } catch (_) {
      return PomodoroSettings.defaults;
    }
  }

  @override
  Future<void> save(PomodoroSettings settings) async {
    await _preferences.setString(_storageKey, jsonEncode(settings.toJson()));
  }
}
