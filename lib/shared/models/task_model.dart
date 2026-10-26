class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String? category;
  final DateTime scheduledDate;
  final DateTime? dueDate;
  final int estimatedMinutes;
  final String? goalId;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.category,
    required this.scheduledDate,
    this.dueDate,
    this.estimatedMinutes = 30,
    this.goalId,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? category,
    DateTime? scheduledDate,
    DateTime? dueDate,
    int? estimatedMinutes,
    String? goalId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dueDate: dueDate ?? this.dueDate,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      goalId: goalId ?? this.goalId,
    );
  }
}
