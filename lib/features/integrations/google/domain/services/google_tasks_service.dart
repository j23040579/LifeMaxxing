import '../models/task_ref.dart';

abstract class GoogleTasksService {
  /// Fetches tasks from Google Tasks API.
  Future<List<TaskRef>> getTasks({
    String taskListId = '@default',
    bool showCompleted = true,
  });

  /// Inserts a new Google Task.
  Future<TaskRef> createTask({
    String taskListId = '@default',
    required String title,
    String? notes,
    DateTime? dueDate,
    String? goalId,
  });

  /// Updates task title, due date, or notes.
  Future<TaskRef> updateTask(TaskRef task);

  /// Marks a task as completed and triggers local completion log entry.
  Future<TaskRef> completeTask({
    String taskListId = '@default',
    required String taskId,
    bool isCompleted = true,
  });

  /// Deletes a task.
  Future<void> deleteTask({
    String taskListId = '@default',
    required String taskId,
  });
}
