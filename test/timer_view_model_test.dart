import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_flutter/core/services/clock_service.dart';
import 'package:pomodoro_flutter/features/settings/domain/pomodoro_settings.dart';
import 'package:pomodoro_flutter/features/settings/domain/settings_repository.dart';
import 'package:pomodoro_flutter/features/settings/viewmodels/settings_view_model.dart';
import 'package:pomodoro_flutter/features/tasks/domain/task_item.dart';
import 'package:pomodoro_flutter/features/tasks/domain/task_repository.dart';
import 'package:pomodoro_flutter/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:pomodoro_flutter/features/timer/domain/pomodoro_mode.dart';
import 'package:pomodoro_flutter/features/timer/domain/session_repository.dart';
import 'package:pomodoro_flutter/features/timer/domain/timer_session_state.dart';
import 'package:pomodoro_flutter/features/timer/viewmodels/timer_view_model.dart';

void main() {
  test('switches to short break after a completed pomodoro', () async {
    final settingsViewModel = SettingsViewModel(
      _FakeSettingsRepository(
        settings: const PomodoroSettings(
          pomodoroMinutes: 1,
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          longBreakInterval: 4,
          autoStartBreaks: false,
          autoStartPomodoros: false,
        ),
      ),
    );
    await settingsViewModel.load();

    final tasksViewModel = TasksViewModel(_FakeTaskRepository());
    await tasksViewModel.load();
    await tasksViewModel.addTask(title: 'Deep work', estimatedPomodoros: 2);

    final sessionRepository = _FakeSessionRepository();

    final timerViewModel = TimerViewModel(
      sessionRepository: sessionRepository,
      clockService: const _FakeClockService(),
    )
      ..bindSettings(settingsViewModel)
      ..bindTasks(tasksViewModel);

    await timerViewModel.completeCurrentSession();

    expect(timerViewModel.mode, PomodoroMode.shortBreak);
    expect(timerViewModel.remainingSeconds, 5 * 60);
    expect(tasksViewModel.activeTask?.completedPomodoros, 1);
  });
}

class _FakeClockService extends ClockService {
  const _FakeClockService();

  @override
  DateTime now() => DateTime.fromMillisecondsSinceEpoch(1000);
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository({required this.settings});

  PomodoroSettings settings;

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
