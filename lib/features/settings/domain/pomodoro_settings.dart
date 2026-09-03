class PomodoroSettings {
  const PomodoroSettings({
    required this.pomodoroMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakInterval,
    required this.autoStartBreaks,
    required this.autoStartPomodoros,
  });

  final int pomodoroMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakInterval;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;

  static const defaults = PomodoroSettings(
    pomodoroMinutes: 25,
    shortBreakMinutes: 5,
    longBreakMinutes: 15,
    longBreakInterval: 4,
    autoStartBreaks: false,
    autoStartPomodoros: false,
  );

  PomodoroSettings copyWith({
    int? pomodoroMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakInterval,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
  }) {
    return PomodoroSettings(
      pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pomodoroMinutes': pomodoroMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'longBreakInterval': longBreakInterval,
      'autoStartBreaks': autoStartBreaks,
      'autoStartPomodoros': autoStartPomodoros,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      pomodoroMinutes:
          json['pomodoroMinutes'] as int? ?? defaults.pomodoroMinutes,
      shortBreakMinutes:
          json['shortBreakMinutes'] as int? ?? defaults.shortBreakMinutes,
      longBreakMinutes:
          json['longBreakMinutes'] as int? ?? defaults.longBreakMinutes,
      longBreakInterval:
          json['longBreakInterval'] as int? ?? defaults.longBreakInterval,
      autoStartBreaks:
          json['autoStartBreaks'] as bool? ?? defaults.autoStartBreaks,
      autoStartPomodoros:
          json['autoStartPomodoros'] as bool? ?? defaults.autoStartPomodoros,
    );
  }
}
