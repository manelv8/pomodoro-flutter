import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/clock_service.dart';
import '../features/home/viewmodels/app_shell_view_model.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/settings/viewmodels/settings_view_model.dart';
import '../features/tasks/domain/task_repository.dart';
import '../features/tasks/viewmodels/tasks_view_model.dart';
import '../features/timer/domain/session_repository.dart';
import '../features/timer/viewmodels/timer_view_model.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    super.key,
    required this.settingsRepository,
    required this.taskRepository,
    required this.sessionRepository,
    required this.child,
  });

  final SettingsRepository settingsRepository;
  final TaskRepository taskRepository;
  final SessionRepository sessionRepository;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClockService>(create: (_) => const SystemClockService()),
        ChangeNotifierProvider(create: (_) => AppShellViewModel()),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(settingsRepository)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => TasksViewModel(taskRepository)..load(),
        ),
        ChangeNotifierProxyProvider2<SettingsViewModel, TasksViewModel,
            TimerViewModel>(
          create: (context) => TimerViewModel(
            sessionRepository: sessionRepository,
            clockService: context.read<ClockService>(),
          )..load(),
          update: (_, settingsViewModel, tasksViewModel, timerViewModel) {
            timerViewModel!
              ..bindSettings(settingsViewModel)
              ..bindTasks(tasksViewModel);
            return timerViewModel;
          },
        ),
      ],
      child: child,
    );
  }
}
