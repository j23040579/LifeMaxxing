import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:life_maxxing/features/integrations/google/data/local_completion_log_repository.dart';
import 'package:life_maxxing/features/integrations/google/domain/models/calendar_event_ref.dart';
import 'package:life_maxxing/features/integrations/google/domain/models/completion_log_entry.dart';
import 'package:life_maxxing/features/integrations/google/domain/models/google_account_info.dart';
import 'package:life_maxxing/features/integrations/google/domain/models/task_ref.dart';
import 'package:life_maxxing/features/integrations/google/domain/services/google_auth_service.dart';
import 'package:life_maxxing/features/integrations/google/domain/services/google_calendar_service.dart';
import 'package:life_maxxing/features/integrations/google/domain/services/google_tasks_service.dart';
import 'package:life_maxxing/features/integrations/google/presentation/controllers/google_sync_controller.dart';

class MockGoogleAuthService implements GoogleAuthService {
  bool signedIn = false;

  @override
  Future<GoogleAccountInfo?> getCurrentUser() async {
    if (!signedIn) return null;
    return const GoogleAccountInfo(
      id: 'mock-1',
      email: 'student@example.com',
      displayName: 'Test Student',
      isConnected: true,
    );
  }

  @override
  Future<GoogleAccountInfo> signIn() async {
    signedIn = true;
    return const GoogleAccountInfo(
      id: 'mock-1',
      email: 'student@example.com',
      displayName: 'Test Student',
      isConnected: true,
    );
  }

  @override
  Future<void> signOut() async {
    signedIn = false;
  }

  @override
  Future<http.Client?> getAuthenticatedClient() async => null;

  @override
  Future<bool> isAuthorized() async => signedIn;
}

class MockGoogleCalendarService implements GoogleCalendarService {
  @override
  Future<List<CalendarEventRef>> getEvents({
    required DateTime timeMin,
    required DateTime timeMax,
    String calendarId = 'primary',
  }) async {
    return [
      CalendarEventRef(
        id: 'cal-1',
        etag: 'etag-1',
        title: 'Operating Systems Exam',
        startTime: timeMin.add(const Duration(hours: 9)),
        endTime: timeMin.add(const Duration(hours: 11)),
      ),
    ];
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
    return CalendarEventRef(
      id: 'cal-new',
      etag: 'etag-new',
      title: title,
      startTime: startTime,
      endTime: endTime,
    );
  }

  @override
  Future<CalendarEventRef> updateEvent(CalendarEventRef event) async => event;

  @override
  Future<void> deleteEvent(
      {required String calendarId, required String eventId}) async {}
}

class MockGoogleTasksService implements GoogleTasksService {
  @override
  Future<List<TaskRef>> getTasks({
    String taskListId = '@default',
    bool showCompleted = true,
  }) async {
    return [
      const TaskRef(
        id: 'task-1',
        listId: '@default',
        title: 'Revise Memory Management',
        goalId: 'goal-1',
      ),
    ];
  }

  @override
  Future<TaskRef> createTask({
    String taskListId = '@default',
    required String title,
    String? notes,
    DateTime? dueDate,
    String? goalId,
  }) async {
    return TaskRef(
        id: 't-new', listId: taskListId, title: title, goalId: goalId);
  }

  @override
  Future<TaskRef> updateTask(TaskRef task) async => task;

  @override
  Future<TaskRef> completeTask({
    String taskListId = '@default',
    required String taskId,
    bool isCompleted = true,
  }) async {
    return TaskRef(
      id: taskId,
      listId: taskListId,
      title: 'Completed Task',
      isCompleted: isCompleted,
    );
  }

  @override
  Future<void> deleteTask(
      {String taskListId = '@default', required String taskId}) async {}
}

void main() {
  group('LocalCompletionLogRepository tests', () {
    test('Records completions and aggregates minutes per goal', () async {
      final repo = LocalCompletionLogRepository();

      await repo.recordCompletion(
        CompletionLogEntry(
          id: 'c-1',
          taskId: 't-1',
          taskTitle: 'Assignment 1',
          completedAt: DateTime.now(),
          estimatedMinutes: 60,
          goalId: 'goal-cs',
        ),
      );

      await repo.recordCompletion(
        CompletionLogEntry(
          id: 'c-2',
          taskId: 't-2',
          taskTitle: 'Assignment 2',
          completedAt: DateTime.now(),
          estimatedMinutes: 45,
          goalId: 'goal-cs',
        ),
      );

      await repo.recordCompletion(
        CompletionLogEntry(
          id: 'c-3',
          taskId: 't-3',
          taskTitle: 'Unlinked Task',
          completedAt: DateTime.now(),
          estimatedMinutes: 30,
        ),
      );

      expect(repo.getAllEntries().length, equals(3));
      expect(repo.getEntriesForGoal('goal-cs').length, equals(2));
      expect(repo.getTotalCompletedMinutesForGoal('goal-cs'), equals(105));
    });
  });

  group('GoogleSyncController tests', () {
    test('Completing task writes to local completion log immediately',
        () async {
      final auth = MockGoogleAuthService();
      final calendar = MockGoogleCalendarService();
      final tasks = MockGoogleTasksService();
      final completionLog = LocalCompletionLogRepository();

      final controller = GoogleSyncController(
        authService: auth,
        calendarService: calendar,
        tasksService: tasks,
        completionLogRepo: completionLog,
      );

      await controller.signIn();
      expect(controller.state.isConnected, isTrue);

      const taskToComplete = TaskRef(
        id: 'test-task-1',
        listId: '@default',
        title: 'Study Architecture',
        goalId: 'goal-honor',
      );

      await controller.completeTask(taskToComplete, estimatedMinutes: 90);

      final logged = completionLog.getEntriesForGoal('goal-honor');
      expect(logged.length, equals(1));
      expect(logged.first.taskTitle, equals('Study Architecture'));
      expect(logged.first.estimatedMinutes, equals(90));
    });
  });

  group('OAuth Scope Security tests', () {
    test('Scopes follow least-privilege principle without sensitive scopes',
        () {
      expect(GoogleAuthService.scopes, contains('email'));
      expect(GoogleAuthService.scopes,
          contains('https://www.googleapis.com/auth/calendar.events'));
      expect(GoogleAuthService.scopes,
          contains('https://www.googleapis.com/auth/tasks'));

      // Ensure no full drive, gmail, or contacts access is requested
      expect(GoogleAuthService.scopes.any((s) => s.contains('gmail')), isFalse);
      expect(GoogleAuthService.scopes.any((s) => s.contains('drive')), isFalse);
      expect(
          GoogleAuthService.scopes.any((s) => s.contains('contacts')), isFalse);
    });
  });
}
