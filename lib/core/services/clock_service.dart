abstract class ClockService {
  const ClockService();

  DateTime now();
}

class SystemClockService extends ClockService {
  const SystemClockService();

  @override
  DateTime now() => DateTime.now();
}
