import '../models/schedulable_item.dart';
import '../models/schedule_plan.dart';
import '../models/time_range.dart';
import '../models/user_constraints.dart';

/// Pure Dart deterministic scheduling engine.
///
/// Ensures zero overlaps, respects waking boundaries, guards fixed commitments,
/// applies user buffers, weights goals and deadlines, and replans cleanly around disruptions.
class DeterministicScheduler {
  const DeterministicScheduler();

  /// Generates a feasible, conflict-free [SchedulePlan] for [day].
  SchedulePlan generatePlan({
    required DateTime day,
    required List<SchedulableEvent> fixedEvents,
    required List<SchedulableTask> tasks,
    UserConstraints constraints = const UserConstraints(),
    DateTime? anchorTime,
  }) {
    // 1. Establish the base waking window
    final wakingWindow = constraints.wakingRangeForDay(day);

    DateTime windowStart = wakingWindow.start;
    if (anchorTime != null && anchorTime.isAfter(windowStart)) {
      // Re-planning from mid-day anchor
      windowStart = anchorTime;
    }

    if (windowStart.isAfter(wakingWindow.end)) {
      // Anchor is past bedtime: no free slots today
      return SchedulePlan(
        day: day,
        fixedEvents: fixedEvents,
        scheduledBlocks: const [],
        unfittedTasks: tasks.where((t) => !t.isDone).toList(),
        explanations: [
          'Planning time is past sleep boundary. All pending tasks moved to overflow.'
        ],
        reasonsByTaskId: {},
        remainingFreeSlots: const [],
      );
    }

    final planningWindow = TimeRange(start: windowStart, end: wakingWindow.end);

    // 2. Compute available free slots by subtracting fixed commitments & unavailable periods
    List<TimeRange> freeSlots = [planningWindow];

    final buffer = Duration(minutes: constraints.defaultBufferMinutes);

    // Subtract fixed events (expanded by transition buffer)
    for (final event in fixedEvents) {
      final bufferedEvent = event.timeRange.expand(buffer);
      final updatedSlots = <TimeRange>[];
      for (final slot in freeSlots) {
        updatedSlots.addAll(slot.subtract(bufferedEvent));
      }
      freeSlots = updatedSlots;
    }

    // Subtract unavailable periods
    for (final unavailable in constraints.unavailableWindows) {
      final updatedSlots = <TimeRange>[];
      for (final slot in freeSlots) {
        updatedSlots.addAll(slot.subtract(unavailable));
      }
      freeSlots = updatedSlots;
    }

    // Filter out useless slivers (< 15 min)
    const minUsableDuration = Duration(minutes: 15);
    freeSlots =
        freeSlots.where((slot) => slot.duration >= minUsableDuration).toList();

    // Sort free slots chronologically
    freeSlots.sort((a, b) => a.start.compareTo(b.start));

    // 3. Filter and sort tasks by composite urgency score
    final activeTasks = tasks.where((t) => !t.isDone).toList();
    activeTasks.sort((a, b) {
      final scoreA = a.computeUrgencyScore(day);
      final scoreB = b.computeUrgencyScore(day);
      return scoreB.compareTo(scoreA); // Highest urgency first
    });

    final scheduledBlocks = <ScheduledBlock>[];
    final unfittedTasks = <SchedulableTask>[];
    final explanations = <String>[];
    final reasonsByTaskId = <String, String>{};

    // 4. Place tasks into free slots
    for (final task in activeTasks) {
      Duration durationToPlace = task.estimatedDuration;

      // Cap at maxContinuousWorkMinutes if needed
      final maxBlock = Duration(minutes: constraints.maxContinuousWorkMinutes);
      if (durationToPlace > maxBlock) {
        durationToPlace = maxBlock;
      }

      int chosenSlotIndex = -1;
      for (int i = 0; i < freeSlots.length; i++) {
        if (freeSlots[i].duration >= durationToPlace) {
          chosenSlotIndex = i;
          break;
        }
      }

      if (chosenSlotIndex != -1) {
        final slot = freeSlots[chosenSlotIndex];
        final blockStart = slot.start;
        final blockEnd = blockStart.add(durationToPlace);
        final blockRange = TimeRange(start: blockStart, end: blockEnd);

        final block = ScheduledBlock(
          id: 'wb_${task.id}_${blockStart.millisecondsSinceEpoch}',
          taskId: task.id,
          title: task.title,
          timeRange: blockRange,
          isConfirmed: false,
          sourceReason: task.sourceNote ??
              'Placed based on priority ${task.priority} and deadline proximity',
        );

        scheduledBlocks.add(block);

        final reason =
            'Scheduled ${task.title} for ${durationToPlace.inMinutes} min at ${_formatTime(blockStart)} - ${_formatTime(blockEnd)}';
        explanations.add(reason);
        reasonsByTaskId[task.id] = reason;

        // Subtract the placed block plus its trailing buffer from freeSlots
        final blockWithBuffer = blockRange.expand(buffer);
        final updatedSlots = <TimeRange>[];
        for (final s in freeSlots) {
          updatedSlots.addAll(s.subtract(blockWithBuffer));
        }
        freeSlots =
            updatedSlots.where((s) => s.duration >= minUsableDuration).toList();
        freeSlots.sort((a, b) => a.start.compareTo(b.start));
      } else {
        // Cannot fit
        unfittedTasks.add(task);
        final totalFreeMin =
            freeSlots.fold(0, (sum, s) => sum + s.duration.inMinutes);
        final reason =
            'Cannot fit "${task.title}" (${task.estimatedDuration.inMinutes} min) into remaining $totalFreeMin min today. Suggested next slot: tomorrow.';
        explanations.add(reason);
        reasonsByTaskId[task.id] = reason;
      }
    }

    return SchedulePlan(
      day: day,
      fixedEvents: fixedEvents,
      scheduledBlocks: scheduledBlocks,
      unfittedTasks: unfittedTasks,
      explanations: explanations,
      reasonsByTaskId: reasonsByTaskId,
      remainingFreeSlots: freeSlots,
    );
  }

  /// Replans the rest of the day after a disruption at [disruptionTime].
  /// Preserves past/already-completed blocks, and recalculates future blocks.
  SchedulePlan replanDisruption({
    required SchedulePlan currentPlan,
    required DateTime disruptionTime,
    required List<SchedulableTask> remainingTasks,
    UserConstraints constraints = const UserConstraints(),
  }) {
    // Keep blocks that finished before the disruption
    final preservedBlocks = currentPlan.scheduledBlocks
        .where((b) => b.timeRange.end.isBefore(disruptionTime) || b.isConfirmed)
        .toList();

    // Replan pending tasks from disruptionTime onwards
    final newPlan = generatePlan(
      day: currentPlan.day,
      fixedEvents: currentPlan.fixedEvents,
      tasks: remainingTasks,
      constraints: constraints,
      anchorTime: disruptionTime,
    );

    return SchedulePlan(
      day: currentPlan.day,
      fixedEvents: currentPlan.fixedEvents,
      scheduledBlocks: [...preservedBlocks, ...newPlan.scheduledBlocks],
      unfittedTasks: newPlan.unfittedTasks,
      explanations: [
        'Disruption replanned at ${_formatTime(disruptionTime)}.',
        ...newPlan.explanations,
      ],
      reasonsByTaskId: newPlan.reasonsByTaskId,
      remainingFreeSlots: newPlan.remainingFreeSlots,
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
