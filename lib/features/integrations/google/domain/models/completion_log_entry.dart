/// An immutable log entry recorded when a task is completed.
/// Preserved locally so that even if Google Tasks hides or archives completed tasks,
/// goal progress and historical metrics remain intact.
class CompletionLogEntry {
  final String id;
  final String taskId;
  final String taskTitle;
  final DateTime completedAt;
  final int estimatedMinutes;
  final String? goalId;

  const CompletionLogEntry({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.completedAt,
    this.estimatedMinutes = 30,
    this.goalId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'taskTitle': taskTitle,
        'completedAt': completedAt.toIso8601String(),
        'estimatedMinutes': estimatedMinutes,
        'goalId': goalId,
      };

  factory CompletionLogEntry.fromJson(Map<String, dynamic> json) =>
      CompletionLogEntry(
        id: json['id'] as String,
        taskId: json['taskId'] as String,
        taskTitle: json['taskTitle'] as String,
        completedAt: DateTime.parse(json['completedAt'] as String),
        estimatedMinutes: (json['estimatedMinutes'] as int?) ?? 30,
        goalId: json['goalId'] as String?,
      );
}
