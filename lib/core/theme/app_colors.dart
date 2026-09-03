import '../../features/timer/domain/pomodoro_mode.dart';

class AppColors {
  const AppColors._();

  static const int pomodoroColorValue = 0xFFBA4949;
  static const int shortBreakColorValue = 0xFF38858A;
  static const int longBreakColorValue = 0xFF397097;
}

extension PomodoroModeColors on PomodoroMode {
  int get backgroundColorValue {
    switch (this) {
      case PomodoroMode.pomodoro:
        return AppColors.pomodoroColorValue;
      case PomodoroMode.shortBreak:
        return AppColors.shortBreakColorValue;
      case PomodoroMode.longBreak:
        return AppColors.longBreakColorValue;
    }
  }
}
