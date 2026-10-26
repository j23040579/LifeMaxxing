import 'time_range.dart';

/// A fixed calendar event (lecture, meeting, game).
/// The scheduling engine NEVER moves or shrinks these without explicit user instruction.
class SchedulableEvent {
  final String id;
  final String title;
  final TimeRange timeRange;
  final String? location;
  final bool isFixed;

  const SchedulableEvent({
    required this.id,
    required this.title,
    required this.timeRange,
    this.location,
    this.isFixed = true,
  });
}

/// A candidate task requiring work time.
class SchedulableTask {
  final String id;
  final String title;
  final Duration estimatedDuration;
  final DateTime? deadline;

  /// Priority scale 1 to 5 (5 = highest).
  final int priority;

  /// Goal weight (0.0 to 1.0). Tasks linked to high-priority goals get higher weight.
  final double goalWeight;

  final String? goalId;
  final String? sourceNote;
  final bool isDone;

  const SchedulableTask({
    required this.id,
    required this.title,
    required this.estimatedDuration,
    this.deadline,
    this.priority = 3,
    this.goalWeight = 0.0,
    this.goalId,
    this.sourceNote,
    this.isDone = false,
  });

  /// Computes a composite scheduling score.
  /// Factors:
  /// - Proximity of deadline (highest if due today or tomorrow)
  /// - Goal weight (0.0 to 1.0 contributes up to 40 points)
  /// - Priority (1 to 5 contributes up to 25 points)
  double computeUrgencyScore(DateTime currentDay) {
    double score = 0.0;

    // Deadline urgency (0 to 100 points)
    if (deadline != null) {
      final daysUntilDeadline = deadline!.difference(currentDay).inDays;
      if (daysUntilDeadline < 0) {
        score += 100.0; // Overdue
      } else if (daysUntilDeadline == 0) {
        score += 80.0; // Due today
      } else if (daysUntilDeadline == 1) {
        score += 60.0; // Due tomorrow
      } else if (daysUntilDeadline <= 3) {
        score += 35.0; // Due soon
      } else {
        score += 10.0;
      }
    } else {
      score += 5.0; // No deadline
    }

    // Goal alignment (0 to 40 points)
    score += goalWeight * 40.0;

    // Base priority (1 to 5 => 5 to 25 points)
    score += priority * 5.0;

    return score;
  }
}

/// A flexible work block placed in the schedule.
class ScheduledBlock {
  final String id;
  final String taskId;
  final String title;
  final TimeRange timeRange;
  final bool isConfirmed;
  final String? sourceReason;

  const ScheduledBlock({
    required this.id,
    required this.taskId,
    required this.title,
    required this.timeRange,
    this.isConfirmed = false,
    this.sourceReason,
  });

  ScheduledBlock copyWith({
    String? id,
    String? taskId,
    String? title,
    TimeRange? timeRange,
    bool? isConfirmed,
    String? sourceReason,
  }) {
    return ScheduledBlock(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      timeRange: timeRange ?? this.timeRange,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      sourceReason: sourceReason ?? this.sourceReason,
    );
  }
}
