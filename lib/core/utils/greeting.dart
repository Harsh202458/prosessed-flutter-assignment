enum DayPart { morning, afternoon, evening }

/// Part of the day for the home greeting.
DayPart dayPartOf(DateTime time) {
  final hour = time.hour;
  if (hour >= 5 && hour < 12) return DayPart.morning;
  if (hour >= 12 && hour < 17) return DayPart.afternoon;
  return DayPart.evening;
}
