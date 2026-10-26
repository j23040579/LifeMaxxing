/// Canonical reference to a Google Calendar event.
class CalendarEventRef {
  final String id;
  final String etag;
  final String calendarId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String? location;
  final List<String>? recurrence;
  final String? recurringEventId;
  final String status; // 'confirmed', 'tentative', 'cancelled'

  const CalendarEventRef({
    required this.id,
    required this.etag,
    this.calendarId = 'primary',
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    this.location,
    this.recurrence,
    this.recurringEventId,
    this.status = 'confirmed',
  });

  bool get isRecurring => recurrence != null && recurrence!.isNotEmpty;
  bool get isOccurrence => recurringEventId != null;

  CalendarEventRef copyWith({
    String? id,
    String? etag,
    String? calendarId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? location,
    List<String>? recurrence,
    String? recurringEventId,
    String? status,
  }) {
    return CalendarEventRef(
      id: id ?? this.id,
      etag: etag ?? this.etag,
      calendarId: calendarId ?? this.calendarId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      location: location ?? this.location,
      recurrence: recurrence ?? this.recurrence,
      recurringEventId: recurringEventId ?? this.recurringEventId,
      status: status ?? this.status,
    );
  }
}
