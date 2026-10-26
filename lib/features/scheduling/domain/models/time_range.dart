/// Represents an immutable continuous range of time between [start] and [end].
class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange({required this.start, required this.end})
      : assert(!end.isBefore(start), 'end cannot be before start: $start -> $end');

  Duration get duration => end.difference(start);

  /// Returns true if this range overlaps with [other].
  /// Adjacent intervals (e.g. 10:00-11:00 and 11:00-12:00) do NOT overlap.
  bool overlaps(TimeRange other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  /// Returns true if [dateTime] is within [start, end) (inclusive start, exclusive end).
  bool contains(DateTime dateTime) {
    return (dateTime.isAtSameMomentAs(start) || dateTime.isAfter(start)) &&
        dateTime.isBefore(end);
  }

  /// Returns the intersection between this and [other], or null if they do not overlap.
  TimeRange? intersection(TimeRange other) {
    if (!overlaps(other)) return null;
    final newStart = start.isAfter(other.start) ? start : other.start;
    final newEnd = end.isBefore(other.end) ? end : other.end;
    return TimeRange(start: newStart, end: newEnd);
  }

  /// Subtracts [subtrahend] from this time range, returning 0, 1, or 2 remaining intervals.
  List<TimeRange> subtract(TimeRange subtrahend) {
    if (!overlaps(subtrahend)) {
      return [this];
    }

    final result = <TimeRange>[];

    // Left remainder (before subtrahend starts)
    if (start.isBefore(subtrahend.start)) {
      result.add(TimeRange(start: start, end: subtrahend.start));
    }

    // Right remainder (after subtrahend ends)
    if (end.isAfter(subtrahend.end)) {
      result.add(TimeRange(start: subtrahend.end, end: end));
    }

    return result;
  }

  /// Expands both ends by [buffer].
  TimeRange expand(Duration buffer) {
    return TimeRange(
      start: start.subtract(buffer),
      end: end.add(buffer),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() {
    final sH = start.hour.toString().padLeft(2, '0');
    final sM = start.minute.toString().padLeft(2, '0');
    final eH = end.hour.toString().padLeft(2, '0');
    final eM = end.minute.toString().padLeft(2, '0');
    return '$sH:$sM - $eH:$eM';
  }
}
