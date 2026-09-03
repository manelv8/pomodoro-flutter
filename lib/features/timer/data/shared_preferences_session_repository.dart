import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/session_repository.dart';
import '../domain/timer_session_state.dart';

class SharedPreferencesSessionRepository implements SessionRepository {
  SharedPreferencesSessionRepository(this._preferences);

  static const _storageKey = 'session.v1';

  final SharedPreferences _preferences;

  @override
  Future<TimerSessionState?> load() async {
    final rawValue = _preferences.getString(_storageKey);
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue) as Map<String, dynamic>;
      return TimerSessionState.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(TimerSessionState state) async {
    await _preferences.setString(_storageKey, jsonEncode(state.toJson()));
  }
}
