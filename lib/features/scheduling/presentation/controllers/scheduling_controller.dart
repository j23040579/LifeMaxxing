import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/sample_data.dart';
import '../../../integrations/google/presentation/controllers/google_sync_controller.dart';
import '../../../today/presentation/controllers/task_controller.dart';
import '../../domain/models/schedulable_item.dart';
import '../../domain/models/schedule_plan.dart';
import '../../domain/models/time_range.dart';
import '../../domain/models/user_constraints.dart';
import '../../domain/services/deterministic_scheduler.dart';

final schedulerProvider = Provider<DeterministicScheduler>((ref) {
  return const DeterministicScheduler();
});

final userConstraintsProvider = StateProvider<UserConstraints>((ref) {
  return const UserConstraints(
    wakeHour: 8,
    wakeMinute: 0,
    sleepHour: 23,
    sleepMinute: 0,
    defaultBufferMinutes: 15,
    maxContinuousWorkMinutes: 90,
    breakMinutes: 15,
  );
});

final schedulePlanProvider = Provider<SchedulePlan>((ref) {
  final scheduler = ref.watch(schedulerProvider);
  final constraints = ref.watch(userConstraintsProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final localTasks = ref.watch(tasksNotifierProvider);
  final syncState = ref.watch(googleSyncControllerProvider);

  // 1. Gather Fixed Events: Live Google Calendar if connected, else Sample data
  List<SchedulableEvent> fixedEvents;
  if (syncState.isConnected && syncState.calendarEvents.isNotEmpty) {
    fixedEvents = syncState.calendarEvents
        .where((e) =>
            e.startTime.year == selectedDate.year &&
            e.startTime.month == selectedDate.month &&
            e.startTime.day == selectedDate.day)
        .map((e) => SchedulableEvent(
              id: e.id,
              title: e.title,
              timeRange: TimeRange(start: e.startTime, end: e.endTime),
              location: e.location,
              isFixed: true,
            ))
        .toList();
  } else {
    fixedEvents = sampleEvents
        .where((e) => e.isFixed)
        .map((e) => SchedulableEvent(
              id: e.id,
              title: e.title,
              timeRange: TimeRange(start: e.startTime, end: e.endTime),
              location: e.location,
              isFixed: true,
            ))
        .toList();
  }

  // 2. Gather Tasks: Live Google Tasks if connected, else local TaskModels
  List<SchedulableTask> schedulableTasks;
  if (syncState.isConnected && syncState.tasks.isNotEmpty) {
    schedulableTasks = syncState.tasks.map((t) {
      final goalWeight = t.goalId != null ? 0.8 : 0.2;
      return SchedulableTask(
        id: t.id,
        title: t.title,
        estimatedDuration: const Duration(minutes: 45),
        deadline: t.dueDate,
        priority: t.goalId != null ? 4 : 3,
        goalWeight: goalWeight,
        goalId: t.goalId,
        sourceNote: t.goalId != null ? 'Goal-linked task' : null,
        isDone: t.isCompleted,
      );
    }).toList();
  } else {
    schedulableTasks = localTasks.map((t) {
      final goalWeight = t.goalId != null ? 0.8 : 0.2;
      return SchedulableTask(
        id: t.id,
        title: t.title,
        estimatedDuration: Duration(minutes: t.estimatedMinutes),
        deadline: t.dueDate,
        priority: t.goalId != null ? 4 : 3,
        goalWeight: goalWeight,
        goalId: t.goalId,
        sourceNote: t.goalId != null ? 'Deep Work summary (Goal-linked)' : null,
        isDone: t.isCompleted,
      );
    }).toList();
  }

  return scheduler.generatePlan(
    day: selectedDate,
    fixedEvents: fixedEvents,
    tasks: schedulableTasks,
    constraints: constraints,
  );
});
