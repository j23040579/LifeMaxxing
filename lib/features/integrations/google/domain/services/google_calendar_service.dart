import '../models/calendar_event_ref.dart';

abstract class GoogleCalendarService {
  /// Fetches calendar events between [timeMin] and [timeMax].
  Future<List<CalendarEventRef>> getEvents({
    required DateTime timeMin,
    required DateTime timeMax,
    String calendarId = 'primary',
  });

  /// Inserts a new calendar event (e.g. user-confirmed work block).
  Future<CalendarEventRef> createEvent({
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
  });

  /// Updates an existing calendar event with optimistic concurrency / ETag checks.
  Future<CalendarEventRef> updateEvent(CalendarEventRef event);

  /// Deletes an event by [eventId].
  Future<void> deleteEvent({
    required String calendarId,
    required String eventId,
  });
}
