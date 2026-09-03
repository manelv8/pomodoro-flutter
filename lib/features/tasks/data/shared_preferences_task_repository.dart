import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/task_item.dart';
import '../domain/task_repository.dart';

class SharedPreferencesTaskRepository implements TaskRepository {
  SharedPreferencesTaskRepository(this._preferences);

  static const _storageKey = 'tasks.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<TaskItem>> load() async {
    final rawValue = _preferences.getString(_storageKey);
    if (rawValue == null || rawValue.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(rawValue) as List<dynamic>;
      return decoded
          .map((item) => TaskItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> save(List<TaskItem> tasks) async {
    final payload = tasks.map((task) => task.toJson()).toList();
    await _preferences.setString(_storageKey, jsonEncode(payload));
  }
}
