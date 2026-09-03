import 'pomodoro_mode.dart';

class TimerSessionState {
  const TimerSessionState({
    required this.mode,
    required this.remainingSeconds,
    required this.isRunning,
    required this.completedPomodoros,
    this.endsAtEpochMs,
  });

  final PomodoroMode mode;
  final int remainingSeconds;
  final bool isRunning;
  final int completedPomodoros;
  final int? endsAtEpochMs;

  factory TimerSessionState.initial() {
    return const TimerSessionState(
      mode: PomodoroMode.pomodoro,
      remainingSeconds: 25 * 60,
      isRunning: false,
      completedPomodoros: 0,
    );
  }

  TimerSessionState copyWith({
    PomodoroMode? mode,
    int? remainingSeconds,
    bool? isRunning,
    int? completedPomodoros,
    int? endsAtEpochMs,
    bool clearEndsAt = false,
  }) {
    return TimerSessionState(
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      endsAtEpochMs: clearEndsAt ? null : (endsAtEpochMs ?? this.endsAtEpochMs),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'remainingSeconds': remainingSeconds,
      'isRunning': isRunning,
      'completedPomodoros': completedPomodoros,
      'endsAtEpochMs': endsAtEpochMs,
    };
  }

  factory TimerSessionState.fromJson(Map<String, dynamic> json) {
    return TimerSessionState(
      mode: PomodoroMode.values.firstWhere(
        (mode) => mode.name == json['mode'],
        orElse: () => PomodoroMode.pomodoro,
      ),
      remainingSeconds: json['remainingSeconds'] as int? ?? 25 * 60,
      isRunning: json['isRunning'] as bool? ?? false,
      completedPomodoros: json['completedPomodoros'] as int? ?? 0,
      endsAtEpochMs: json['endsAtEpochMs'] as int?,
    );
  }
}
