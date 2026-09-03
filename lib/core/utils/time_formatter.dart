String formatClock(int totalSeconds) {
  final safeSeconds = totalSeconds.clamp(0, 5999).toInt();
  final minutes = safeSeconds ~/ 60;
  final seconds = safeSeconds % 60;

  final minuteText = minutes.toString().padLeft(2, '0');
  final secondText = seconds.toString().padLeft(2, '0');

  return '$minuteText:$secondText';
}
