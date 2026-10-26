import 'schedulable_item.dart';
import 'time_range.dart';

/// The output of the deterministic scheduling engine.
class SchedulePlan {
  final DateTime day;
  final List<SchedulableEvent> fixedEvents;
  final List<ScheduledBlock> scheduledBlocks;
  final List<SchedulableTask> unfittedTasks;
  final List<String> explanations;
  final Map<String, String> reasonsByTaskId;
  final List<TimeRange> remainingFreeSlots;

  const SchedulePlan({
    required this.day,
    required this.fixedEvents,
    required this.scheduledBlocks,
    required this.unfittedTasks,
    required this.explanations,
    required this.reasonsByTaskId,
    required this.remainingFreeSlots,
  });

  /// Total minutes allocated to focused work blocks today.
  int get totalWorkMinutes => scheduledBlocks.fold(
        0,
        (sum, b) => sum + b.timeRange.duration.inMinutes,
      );

  /// Total unallocated free working minutes available today.
  int get totalFreeMinutes => remainingFreeSlots.fold(
        0,
        (sum, s) => sum + s.duration.inMinutes,
      );

  /// Validates deterministically that:
  /// 1. No work blocks overlap with any fixed events.
  /// 2. No work blocks overlap with each other.
  /// 3. All work blocks have positive duration.
  bool get isValid {
    // Check block vs fixed event overlaps
    for (final block in scheduledBlocks) {
      if (block.timeRange.duration <= Duration.zero) return false;

      for (final event in fixedEvents) {
        if (block.timeRange.overlaps(event.timeRange)) {
          return false;
        }
      }
    }

    // Check block vs block overlaps
    for (int i = 0; i < scheduledBlocks.length; i++) {
      for (int j = i + 1; j < scheduledBlocks.length; j++) {
        if (scheduledBlocks[i].timeRange.overlaps(scheduledBlocks[j].timeRange)) {
          return false;
        }
      }
    }

    return true;
  }
}
