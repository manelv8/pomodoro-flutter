import 'package:flutter/foundation.dart';

import '../domain/pomodoro_settings.dart';
import '../domain/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._repository);

  final SettingsRepository _repository;

  PomodoroSettings _settings = PomodoroSettings.defaults;
  bool _isLoaded = false;

  PomodoroSettings get settings => _settings;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    _settings = await _repository.load();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> update({
    int? pomodoroMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakInterval,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
  }) async {
    _settings = _settings.copyWith(
      pomodoroMinutes: pomodoroMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      longBreakInterval: longBreakInterval,
      autoStartBreaks: autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros,
    );
    notifyListeners();
    await _repository.save(_settings);
  }
}
