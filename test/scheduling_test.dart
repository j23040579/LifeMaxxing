import 'package:flutter_test/flutter_test.dart';
import 'package:life_maxxing/features/scheduling/domain/models/schedulable_item.dart';
import 'package:life_maxxing/features/scheduling/domain/models/schedule_plan.dart';
import 'package:life_maxxing/features/scheduling/domain/models/time_range.dart';
import 'package:life_maxxing/features/scheduling/domain/models/user_constraints.dart';
import 'package:life_maxxing/features/scheduling/domain/services/deterministic_scheduler.dart';

void main() {
  final baseDay = DateTime(2026, 10, 27);
  DateTime at(int hour, int minute) =>
      DateTime(baseDay.year, baseDay.month, baseDay.day, hour, minute);

  group('TimeRange unit tests', () {
    test(
        'Overlaps returns true for intersecting intervals and false for adjacent',
        () {
      final r1 = TimeRange(start: at(9, 0), end: at(10, 30));
      final r2 = TimeRange(start: at(10, 0), end: at(11, 0));
      final r3 = TimeRange(start: at(10, 30), end: at(12, 0)); // Adjacent

      expect(r1.overlaps(r2), isTrue);
      expect(r2.overlaps(r1), isTrue);
      expect(r1.overlaps(r3), isFalse,
          reason: 'Adjacent intervals must not overlap');
    });

    test('Subtract splits a time range correctly', () {
      final wholeDay = TimeRange(start: at(8, 0), end: at(18, 0));
      final lecture = TimeRange(start: at(10, 0), end: at(11, 30));

      final remaining = wholeDay.subtract(lecture);

      expect(remaining.length, equals(2));
      expect(remaining[0].start, equals(at(8, 0)));
      expect(remaining[0].end, equals(at(10, 0)));
      expect(remaining[1].start, equals(at(11, 30)));
      expect(remaining[1].end, equals(at(18, 0)));
    });
  });

  group('DeterministicScheduler tests', () {
    const scheduler = DeterministicScheduler();
    const constraints = UserConstraints(
      wakeHour: 8,
      wakeMinute: 0,
      sleepHour: 22,
      sleepMinute: 0,
      defaultBufferMinutes: 15,
      maxContinuousWorkMinutes: 90,
    );

    test('Never overlaps with fixed commitments and respects buffers', () {
      final fixedLecture = SchedulableEvent(
        id: 'lecture-1',
        title: 'Algorithms Lecture',
        timeRange: TimeRange(start: at(10, 0), end: at(11, 30)),
      );

      const task = SchedulableTask(
        id: 'task-1',
        title: 'Essay Draft',
        estimatedDuration: Duration(minutes: 60),
        priority: 4,
        goalWeight: 0.8,
      );

      final plan = scheduler.generatePlan(
        day: baseDay,
        fixedEvents: [fixedLecture],
        tasks: [task],
        constraints: constraints,
      );

      expect(plan.isValid, isTrue);
      expect(plan.scheduledBlocks.length, equals(1));

      final placed = plan.scheduledBlocks.first;
      // Waking start is 08:00. Lecture is 10:00-11:30 with 15m buffer before it (09:45).
      // A 60m task from 08:00 to 09:00 fits cleanly before 09:45.
      expect(placed.timeRange.start, equals(at(8, 0)));
      expect(placed.timeRange.end, equals(at(9, 0)));
      expect(placed.timeRange.overlaps(fixedLecture.timeRange), isFalse);
    });

    test('Higher goal-weight and closer deadline tasks are scheduled first',
        () {
      final distantTask = SchedulableTask(
        id: 'task-low',
        title: 'Low Priority Reading',
        estimatedDuration: const Duration(minutes: 60),
        deadline: baseDay.add(const Duration(days: 7)),
        priority: 2,
        goalWeight: 0.1,
      );

      final urgentGoalTask = SchedulableTask(
        id: 'task-high',
        title: 'Urgent Lab Report (Linked to Goal)',
        estimatedDuration: const Duration(minutes: 60),
        deadline: baseDay.add(const Duration(days: 1)), // Due tomorrow
        priority: 5,
        goalWeight: 0.9,
      );

      final plan = scheduler.generatePlan(
        day: baseDay,
        fixedEvents: [],
        tasks: [distantTask, urgentGoalTask],
        constraints: constraints,
      );

      expect(plan.isValid, isTrue);
      expect(plan.scheduledBlocks.length, equals(2));

      // First slot (08:00) must go to the urgent goal task
      expect(plan.scheduledBlocks[0].taskId, equals('task-high'));
      expect(plan.scheduledBlocks[1].taskId, equals('task-low'));
    });

    test(
        'Overflow tasks that do not fit are honestly reported without cramming',
        () {
      // Fixed event taking most of the afternoon
      final tournament = SchedulableEvent(
        id: 'evt-badminton',
        title: 'Badminton Tournament',
        timeRange: TimeRange(start: at(12, 0), end: at(21, 30)),
      );

      // Morning free: 08:00 to 11:45 (accounting for 15m buffer before tournament) = 225 min
      const largeTask1 = SchedulableTask(
        id: 'task-1',
        title: 'Big Coding Project',
        estimatedDuration: Duration(minutes: 90),
        priority: 5,
      );
      const largeTask2 = SchedulableTask(
        id: 'task-2',
        title: 'Dissertation Outline',
        estimatedDuration: Duration(minutes: 90),
        priority: 4,
      );
      const overflowTask = SchedulableTask(
        id: 'task-3',
        title: 'Lengthy Paper Review',
        estimatedDuration: Duration(minutes: 90),
        priority: 2,
      );

      final plan = scheduler.generatePlan(
        day: baseDay,
        fixedEvents: [tournament],
        tasks: [largeTask1, largeTask2, overflowTask],
        constraints: constraints,
      );

      expect(plan.isValid, isTrue);
      // Only 2 fit before the tournament buffer (90m + 15m buffer + 90m = 195m <= 225m)
      expect(plan.scheduledBlocks.length, equals(2));
      expect(plan.unfittedTasks.length, equals(1));
      expect(plan.unfittedTasks.first.id, equals('task-3'));
      expect(
          plan.explanations
              .any((e) => e.contains('Cannot fit "Lengthy Paper Review"')),
          isTrue);
    });

    test(
        'Re-planning after disruption preserves past blocks and replans future blocks',
        () {
      final morningBlock = ScheduledBlock(
        id: 'wb-morning',
        taskId: 'task-done',
        title: 'Morning Flashcards',
        timeRange: TimeRange(start: at(8, 30), end: at(9, 30)),
        isConfirmed: true,
      );

      final initialPlan = SchedulePlan(
        day: baseDay,
        fixedEvents: [],
        scheduledBlocks: [morningBlock],
        unfittedTasks: [],
        explanations: [],
        reasonsByTaskId: {},
        remainingFreeSlots: [TimeRange(start: at(9, 45), end: at(22, 0))],
      );

      // Disruption happens at 14:00 (e.g. friend visit / spontaneous event)
      final disruptionTime = at(14, 0);

      const pendingTask = SchedulableTask(
        id: 'task-afternoon',
        title: 'Workout Prep & Study',
        estimatedDuration: Duration(minutes: 60),
        priority: 4,
      );

      final replanned = scheduler.replanDisruption(
        currentPlan: initialPlan,
        disruptionTime: disruptionTime,
        remainingTasks: [pendingTask],
        constraints: constraints,
      );

      expect(replanned.isValid, isTrue);
      // Morning block must be preserved
      expect(
          replanned.scheduledBlocks.any((b) => b.id == 'wb-morning'), isTrue);

      // New block must start AT OR AFTER disruptionTime (14:00)
      final newBlock = replanned.scheduledBlocks
          .firstWhere((b) => b.taskId == 'task-afternoon');
      expect(newBlock.timeRange.start.isBefore(disruptionTime), isFalse);
      expect(newBlock.timeRange.start, equals(at(14, 0)));
    });
  });
}
