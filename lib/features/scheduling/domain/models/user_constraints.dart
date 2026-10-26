import 'time_range.dart';

/// User constraints and preferences for deterministic schedule planning.
class UserConstraints {
  /// Hour waking day starts (e.g. 7 for 07:00).
  final int wakeHour;
  final int wakeMinute;

  /// Hour waking day ends (e.g. 23 for 23:00).
  final int sleepHour;
  final int sleepMinute;

  /// Default buffer between scheduled work blocks and fixed events (e.g. 15 min).
  final int defaultBufferMinutes;

  /// Maximum continuous deep work block before needing a break (e.g. 90 min).
  final int maxContinuousWorkMinutes;

  /// Recommended break after a full continuous work block (e.g. 15 min).
  final int breakMinutes;

  /// Custom recurring or one-off unavailable periods (e.g., meals, commute).
  final List<TimeRange> unavailableWindows;

  const UserConstraints({
    this.wakeHour = 7,
    this.wakeMinute = 0,
    this.sleepHour = 23,
    this.sleepMinute = 0,
    this.defaultBufferMinutes = 15,
    this.maxContinuousWorkMinutes = 90,
    this.breakMinutes = 15,
    this.unavailableWindows = const [],
  });

  /// Constructs waking time range for a given date.
  TimeRange wakingRangeForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day, wakeHour, wakeMinute);
    final end = DateTime(day.year, day.month, day.day, sleepHour, sleepMinute);
    return TimeRange(start: start, end: end);
  }
}
