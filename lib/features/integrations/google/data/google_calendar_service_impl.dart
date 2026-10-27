import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import '../domain/models/calendar_event_ref.dart';
import '../domain/services/google_calendar_service.dart';

class GoogleCalendarServiceImpl implements GoogleCalendarService {
  final Future<http.Client?> Function() _getClient;

  GoogleCalendarServiceImpl({
    required Future<http.Client?> Function() getClient,
  }) : _getClient = getClient;

  Future<calendar.CalendarApi> _getApi() async {
    final client = await _getClient();
    if (client == null) {
      throw Exception('Not signed in to Google Calendar');
    }
    return calendar.CalendarApi(client);
  }

  @override
  Future<List<CalendarEventRef>> getEvents({
    required DateTime timeMin,
    required DateTime timeMax,
    String calendarId = 'primary',
  }) async {
    final api = await _getApi();
    final eventsList = await api.events.list(
      calendarId,
      timeMin: timeMin.toUtc(),
      timeMax: timeMax.toUtc(),
      singleEvents: true,
      orderBy: 'startTime',
    );

    final items = eventsList.items ?? [];
    return items.map(_mapToRef).toList();
  }

  @override
  Future<CalendarEventRef> createEvent({
    required String calendarId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
  }) async {
    final api = await _getApi();

    final newEvent = calendar.Event(
      summary: title,
      description: description,
      location: location,
      start: calendar.EventDateTime(
        dateTime: startTime.toUtc(),
      ),
      end: calendar.EventDateTime(
        dateTime: endTime.toUtc(),
      ),
    );

    final created = await api.events.insert(newEvent, calendarId);
    return _mapToRef(created);
  }

  @override
  Future<CalendarEventRef> updateEvent(CalendarEventRef event) async {
    final api = await _getApi();

    final gEvent = calendar.Event(
      summary: event.title,
      description: event.description,
      location: event.location,
      start: calendar.EventDateTime(
        dateTime: event.startTime.toUtc(),
      ),
      end: calendar.EventDateTime(
        dateTime: event.endTime.toUtc(),
      ),
    );

    final updated = await api.events.update(
      gEvent,
      event.calendarId,
      event.id,
    );

    return _mapToRef(updated);
  }

  @override
  Future<void> deleteEvent({
    required String calendarId,
    required String eventId,
  }) async {
    final api = await _getApi();
    await api.events.delete(calendarId, eventId);
  }

  CalendarEventRef _mapToRef(calendar.Event event) {
    DateTime start;
    DateTime end;
    bool isAllDay = false;

    if (event.start?.dateTime != null) {
      start = event.start!.dateTime!.toLocal();
      end =
          event.end?.dateTime?.toLocal() ?? start.add(const Duration(hours: 1));
    } else if (event.start?.date != null) {
      start = event.start!.date!.toLocal();
      end = event.end?.date?.toLocal() ?? start.add(const Duration(days: 1));
      isAllDay = true;
    } else {
      start = DateTime.now();
      end = start.add(const Duration(hours: 1));
    }

    return CalendarEventRef(
      id: event.id ?? '',
      etag: event.etag ?? '',
      title: event.summary ?? 'Untitled Event',
      description: event.description,
      startTime: start,
      endTime: end,
      isAllDay: isAllDay,
      location: event.location,
      recurrence: event.recurrence,
      recurringEventId: event.recurringEventId,
      status: event.status ?? 'confirmed',
    );
  }
}
