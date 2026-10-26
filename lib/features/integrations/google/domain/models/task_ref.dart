/// Canonical reference to a Google Task.
/// Note: A Google Task has a due date, but NEVER a start or end time.
class TaskRef {
  final String id;
  final String listId;
  final String title;
  final String? notes;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? etag;
  final String? goalId;

  const TaskRef({
    required this.id,
    required this.listId,
    required this.title,
    this.notes,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.etag,
    this.goalId,
  });

  TaskRef copyWith({
    String? id,
    String? listId,
    String? title,
    String? notes,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    String? etag,
    String? goalId,
  }) {
    return TaskRef(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      etag: etag ?? this.etag,
      goalId: goalId ?? this.goalId,
    );
  }
}
