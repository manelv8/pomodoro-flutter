import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/clock_service.dart';
import '../../settings/domain/pomodoro_settings.dart';
import '../../settings/viewmodels/settings_view_model.dart';
import '../../tasks/viewmodels/tasks_view_model.dart';
import '../domain/pomodoro_mode.dart';
import '../domain/session_repository.dart';
import '../domain/timer_session_state.dart';

class TimerViewModel extends ChangeNotifier {
  TimerViewModel({
    required SessionRepository sessionRepository,
    required ClockService clockService,
  })  : _sessionRepository = sessionRepository,
        _clockService = clockService;

  final SessionRepository _sessionRepository;
  final ClockService _clockService;

  SettingsViewModel? _settingsViewModel;
  TasksViewModel? _tasksViewModel;
  Timer? _ticker;
  TimerSessionState _state = TimerSessionState.initial();

  TimerSessionState get state => _state;
  PomodoroMode get mode => _state.mode;
  int get remainingSeconds => _state.remainingSeconds;
  bool get isRunning => _state.isRunning;
  int get currentRound => _state.completedPomodoros + 1;
  String get windowTitle => '${mode.label} $formattedRemaining';
  String get formattedRemaining {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> load() async {
    final restored = await _sessionRepository.load();
    if (restored != null) {
      _state = restored;
      await _restoreRunningState();
    }
    notifyListeners();
  }

  void bindSettings(SettingsViewModel settingsViewModel) {
    _settingsViewModel = settingsViewModel;
    if (!_state.isRunning) {
      final targetSeconds = _durationForMode(_state.mode);
      if (_state.remainingSeconds != targetSeconds) {
        _state = _state.copyWith(remainingSeconds: targetSeconds);
        unawaited(_persist());
        notifyListeners();
      }
    }
  }

  void bindTasks(TasksViewModel tasksViewModel) {
    _tasksViewModel = tasksViewModel;
  }

  Future<void> toggleRunning() async {
    if (_state.isRunning) {
      await pause();
      return;
    }
    await start();
  }

  Future<void> start() async {
    final endTime = _clockService
        .now()
        .add(Duration(seconds: _state.remainingSeconds))
        .millisecondsSinceEpoch;
    _state = _state.copyWith(
      isRunning: true,
      endsAtEpochMs: endTime,
    );
    _startTicker();
    notifyListeners();
    await _persist();
  }

  Future<void> pause() async {
    _updateRemainingFromClock();
    _ticker?.cancel();
    _state = _state.copyWith(
      isRunning: false,
      clearEndsAt: true,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> resetCurrentMode() async {
    _ticker?.cancel();
    _state = _state.copyWith(
      remainingSeconds: _durationForMode(_state.mode),
      isRunning: false,
      clearEndsAt: true,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> setMode(PomodoroMode mode) async {
    _ticker?.cancel();
    _state = _state.copyWith(
      mode: mode,
      remainingSeconds: _durationForMode(mode),
      isRunning: false,
      clearEndsAt: true,
    );
    notifyListeners();
    await _persist();
  }

  @visibleForTesting
  Future<void> completeCurrentSession() async {
    _ticker?.cancel();
    _state = _state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      clearEndsAt: true,
    );
    await _handleCompletedSession();
  }

  Future<void> _restoreRunningState() async {
    if (!_state.isRunning) {
      return;
    }

    _updateRemainingFromClock();
    if (_state.remainingSeconds <= 0) {
      await _handleCompletedSession();
      return;
    }

    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      _updateRemainingFromClock();
      notifyListeners();

      if (_state.remainingSeconds <= 0) {
        await _handleCompletedSession();
      } else {
        await _persist();
      }
    });
  }

  void _updateRemainingFromClock() {
    if (!_state.isRunning || _state.endsAtEpochMs == null) {
      return;
    }

    final nowEpoch = _clockService.now().millisecondsSinceEpoch;
    final remainingMs = _state.endsAtEpochMs! - nowEpoch;
    final remaining = (remainingMs / 1000).ceil();
    _state = _state.copyWith(
      remainingSeconds: remaining.clamp(0, 36000),
    );
  }

  Future<void> _handleCompletedSession() async {
    _ticker?.cancel();

    var completedPomodoros = _state.completedPomodoros;
    var nextMode = PomodoroMode.pomodoro;
    var shouldAutoStart = false;

    if (_state.mode == PomodoroMode.pomodoro) {
      completedPomodoros += 1;
      if (_tasksViewModel != null) {
        await _tasksViewModel!.recordCompletedPomodoroForActiveTask();
      }
      final interval = _settings.longBreakInterval;
      final isLongBreakTurn = interval > 0 && completedPomodoros % interval == 0;
      nextMode =
          isLongBreakTurn ? PomodoroMode.longBreak : PomodoroMode.shortBreak;
      shouldAutoStart = _settings.autoStartBreaks;
    } else {
      nextMode = PomodoroMode.pomodoro;
      shouldAutoStart = _settings.autoStartPomodoros;
    }

    final nextSeconds = _durationForMode(nextMode);
    _state = TimerSessionState(
      mode: nextMode,
      remainingSeconds: nextSeconds,
      isRunning: false,
      completedPomodoros: completedPomodoros,
    );

    if (shouldAutoStart) {
      final endTime = _clockService
          .now()
          .add(Duration(seconds: nextSeconds))
          .millisecondsSinceEpoch;
      _state = _state.copyWith(
        isRunning: true,
        endsAtEpochMs: endTime,
      );
      _startTicker();
    }

    notifyListeners();
    await _persist();
  }

  PomodoroSettings get _settings =>
      _settingsViewModel?.settings ?? PomodoroSettings.defaults;

  int _durationForMode(PomodoroMode mode) {
    switch (mode) {
      case PomodoroMode.pomodoro:
        return _settings.pomodoroMinutes * 60;
      case PomodoroMode.shortBreak:
        return _settings.shortBreakMinutes * 60;
      case PomodoroMode.longBreak:
        return _settings.longBreakMinutes * 60;
    }
  }

  Future<void> _persist() async {
    await _sessionRepository.save(_state);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
