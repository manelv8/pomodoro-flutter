import 'timer_session_state.dart';

abstract class SessionRepository {
  Future<TimerSessionState?> load();

  Future<void> save(TimerSessionState state);
}
