enum PomodoroMode {
  pomodoro,
  shortBreak,
  longBreak,
}

extension PomodoroModeUi on PomodoroMode {
  String get label {
    switch (this) {
      case PomodoroMode.pomodoro:
        return 'Pomodoro';
      case PomodoroMode.shortBreak:
        return 'Short Break';
      case PomodoroMode.longBreak:
        return 'Long Break';
    }
  }
}
