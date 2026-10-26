import '../../shared/models/task_model.dart';
import '../../shared/models/sample_data.dart';

class TaskRepository {
  final Map<String, TaskModel> _tasks = {};

  Future<void> init() async {
    for (final task in sampleTasks) {
      _tasks[task.id] = TaskModel(
        id: task.id,
        title: task.title,
        dueDate: task.dueDate,
        isCompleted: task.isDone,
        estimatedMinutes: task.estimatedMinutes ?? 30,
        goalId: task.goalId,
        scheduledDate: DateTime.now(),
      );
    }
  }

  List<TaskModel> getTasksForDate(DateTime date) {
    return _tasks.values.toList();
  }

  Future<void> saveTask(TaskModel task) async {
    _tasks[task.id] = task;
  }

  Future<void> deleteTask(String id) async {
    _tasks.remove(id);
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks[id];
    if (task != null) {
      _tasks[id] = task.copyWith(isCompleted: !task.isCompleted);
    }
  }
}
