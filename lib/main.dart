import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/settings/data/shared_preferences_settings_repository.dart';
import 'features/tasks/data/shared_preferences_task_repository.dart';
import 'features/timer/data/shared_preferences_session_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    PomodoroApp(
      settingsRepository: SharedPreferencesSettingsRepository(preferences),
      taskRepository: SharedPreferencesTaskRepository(preferences),
      sessionRepository: SharedPreferencesSessionRepository(preferences),
    ),
  );
}
