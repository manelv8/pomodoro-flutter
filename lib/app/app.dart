import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/tasks/domain/task_repository.dart';
import '../features/timer/domain/session_repository.dart';
import 'app_providers.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({
    super.key,
    required this.settingsRepository,
    required this.taskRepository,
    required this.sessionRepository,
  });

  final SettingsRepository settingsRepository;
  final TaskRepository taskRepository;
  final SessionRepository sessionRepository;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      settingsRepository: settingsRepository,
      taskRepository: taskRepository,
      sessionRepository: sessionRepository,
      child: MaterialApp(
        title: 'Pomodoro Focus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const PomodoroHomePage(),
      ),
    );
  }
}
