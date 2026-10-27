import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/google_auth_service_impl.dart';
import '../../data/google_calendar_service_impl.dart';
import '../../data/google_tasks_service_impl.dart';
import '../../data/local_completion_log_repository.dart';
import '../../domain/models/calendar_event_ref.dart';
import '../../domain/models/completion_log_entry.dart';
import '../../domain/models/google_account_info.dart';
import '../../domain/models/task_ref.dart';
import '../../domain/services/google_auth_service.dart';
import '../../domain/services/google_calendar_service.dart';
import '../../domain/services/google_tasks_service.dart';

enum GoogleSyncStatus {
  disconnected,
  connecting,
  idle,
  syncing,
  error,
  offline,
}

class GoogleSyncState {
  final GoogleSyncStatus status;
  final GoogleAccountInfo account;
  final DateTime? lastSyncTime;
  final int pendingCount;
  final String? errorMessage;
  final List<CalendarEventRef> calendarEvents;
  final List<TaskRef> tasks;

  const GoogleSyncState({
    this.status = GoogleSyncStatus.disconnected,
    this.account = const GoogleAccountInfo.disconnected(),
    this.lastSyncTime,
    this.pendingCount = 0,
    this.errorMessage,
    this.calendarEvents = const [],
    this.tasks = const [],
  });

  bool get isConnected => account.isConnected;

  GoogleSyncState copyWith({
    GoogleSyncStatus? status,
    GoogleAccountInfo? account,
    DateTime? lastSyncTime,
    int? pendingCount,
    String? errorMessage,
    List<CalendarEventRef>? calendarEvents,
    List<TaskRef>? tasks,
  }) {
    return GoogleSyncState(
      status: status ?? this.status,
      account: account ?? this.account,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingCount: pendingCount ?? this.pendingCount,
      errorMessage: errorMessage ?? this.errorMessage,
      calendarEvents: calendarEvents ?? this.calendarEvents,
      tasks: tasks ?? this.tasks,
    );
  }
}

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthServiceImpl();
});

final googleCalendarServiceProvider = Provider<GoogleCalendarService>((ref) {
  final auth = ref.watch(googleAuthServiceProvider);
  return GoogleCalendarServiceImpl(getClient: auth.getAuthenticatedClient);
});

final googleTasksServiceProvider = Provider<GoogleTasksService>((ref) {
  final auth = ref.watch(googleAuthServiceProvider);
  return GoogleTasksServiceImpl(getClient: auth.getAuthenticatedClient);
});

final completionLogRepositoryProvider =
    Provider<LocalCompletionLogRepository>((ref) {
  return LocalCompletionLogRepository();
});

final googleSyncControllerProvider =
    StateNotifierProvider<GoogleSyncController, GoogleSyncState>((ref) {
  return GoogleSyncController(
    authService: ref.watch(googleAuthServiceProvider),
    calendarService: ref.watch(googleCalendarServiceProvider),
    tasksService: ref.watch(googleTasksServiceProvider),
    completionLogRepo: ref.watch(completionLogRepositoryProvider),
  );
});

class GoogleSyncController extends StateNotifier<GoogleSyncState> {
  final GoogleAuthService _authService;
  final GoogleCalendarService _calendarService;
  final GoogleTasksService _tasksService;
  final LocalCompletionLogRepository _completionLogRepo;

  GoogleSyncController({
    required GoogleAuthService authService,
    required GoogleCalendarService calendarService,
    required GoogleTasksService tasksService,
    required LocalCompletionLogRepository completionLogRepo,
  })  : _authService = authService,
        _calendarService = calendarService,
        _tasksService = tasksService,
        _completionLogRepo = completionLogRepo,
        super(const GoogleSyncState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          status: GoogleSyncStatus.idle,
          account: user,
          lastSyncTime: user.lastSyncTime,
        );
        await syncNow();
      }
    } catch (_) {
      // Offline or uninitialized
    }
  }

  Future<void> signIn() async {
    state =
        state.copyWith(status: GoogleSyncStatus.connecting, errorMessage: null);
    try {
      final account = await _authService.signIn();
      state = state.copyWith(
        status: GoogleSyncStatus.idle,
        account: account,
      );
      await syncNow();
    } catch (e) {
      state = state.copyWith(
        status: GoogleSyncStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const GoogleSyncState();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> syncNow() async {
    if (!state.isConnected) return;

    state =
        state.copyWith(status: GoogleSyncStatus.syncing, errorMessage: null);

    try {
      final now = DateTime.now();
      final timeMin = DateTime(now.year, now.month, now.day, 0, 0);
      final timeMax = timeMin.add(const Duration(days: 7));

      final events = await _calendarService.getEvents(
        timeMin: timeMin,
        timeMax: timeMax,
      );

      final tasks = await _tasksService.getTasks(showCompleted: true);

      final syncTime = DateTime.now();

      state = state.copyWith(
        status: GoogleSyncStatus.idle,
        lastSyncTime: syncTime,
        calendarEvents: events,
        tasks: tasks,
        account: state.account.copyWith(lastSyncTime: syncTime),
      );
    } catch (e) {
      state = state.copyWith(
        status: GoogleSyncStatus.error,
        errorMessage:
            'Sync failed: ${e.toString().replaceFirst("Exception: ", "")}',
      );
    }
  }

  /// Completes a task in Google Tasks AND logs to the local completion log.
  Future<void> completeTask(TaskRef task, {int estimatedMinutes = 30}) async {
    // 1. Optimistic update
    final updatedTasks = state.tasks.map((t) {
      if (t.id == task.id) {
        return t.copyWith(isCompleted: true, completedAt: DateTime.now());
      }
      return t;
    }).toList();

    state = state.copyWith(tasks: updatedTasks);

    // 2. Record in local completion log immediately
    await _completionLogRepo.recordCompletion(
      CompletionLogEntry(
        id: 'comp_${task.id}_${DateTime.now().millisecondsSinceEpoch}',
        taskId: task.id,
        taskTitle: task.title,
        completedAt: DateTime.now(),
        estimatedMinutes: estimatedMinutes,
        goalId: task.goalId,
      ),
    );

    // 3. Sync to Google Tasks API
    if (state.isConnected) {
      try {
        await _tasksService.completeTask(
          taskListId: task.listId,
          taskId: task.id,
          isCompleted: true,
        );
      } catch (e) {
        // Log rollback or error
        state = state.copyWith(
            errorMessage: 'Failed to sync completion to Google Tasks');
      }
    }
  }
}
