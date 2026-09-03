import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_flutter/app/app_providers.dart';
import 'package:pomodoro_flutter/core/theme/app_theme.dart';
import 'package:pomodoro_flutter/features/home/presentation/home_screen.dart';
import 'package:pomodoro_flutter/features/settings/domain/pomodoro_settings.dart';
import 'package:pomodoro_flutter/features/settings/domain/settings_repository.dart';
import 'package:pomodoro_flutter/features/tasks/domain/task_item.dart';
import 'package:pomodoro_flutter/features/tasks/domain/task_repository.dart';
import 'package:pomodoro_flutter/features/timer/domain/session_repository.dart';
import 'package:pomodoro_flutter/features/timer/domain/timer_session_state.dart';

void main() {
  testWidgets('renders timer shell and opens settings', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        settingsRepository: _FakeSettingsRepository(),
        taskRepository: _FakeTaskRepository(),
        sessionRepository: _FakeSessionRepository(),
      ),
    );

    expect(find.text('Pomofocus'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-settings-button')));
    await tester.pumpAndSettle();

    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('Auto Start Breaks'), findsOneWidget);
  });

  testWidgets('adds a task from the composer', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        settingsRepository: _FakeSettingsRepository(),
        taskRepository: _FakeTaskRepository(),
        sessionRepository: _FakeSessionRepository(),
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('toggle-task-composer')),
      200,
    );
    await tester.tap(find.byKey(const Key('toggle-task-composer')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Write docs');
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.tap(find.text('Save Task'));
    await tester.pumpAndSettle();

    expect(find.text('Write docs'), findsAtLeastNWidgets(1));
    expect(find.text('0/2'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({
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
        theme: AppTheme.theme,
        home: const PomodoroHomePage(),
      ),
    );
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  PomodoroSettings settings = PomodoroSettings.defaults;

  @override
  Future<PomodoroSettings> load() async => settings;

  @override
  Future<void> save(PomodoroSettings settings) async {
    this.settings = settings;
  }
}

class _FakeTaskRepository implements TaskRepository {
  List<TaskItem> tasks = const [];

  @override
  Future<List<TaskItem>> load() async => tasks;

  @override
  Future<void> save(List<TaskItem> tasks) async {
    this.tasks = tasks;
  }
}

class _FakeSessionRepository implements SessionRepository {
  TimerSessionState? state;

  @override
  Future<TimerSessionState?> load() async => state;

  @override
  Future<void> save(TimerSessionState state) async {
    this.state = state;
  }
}
