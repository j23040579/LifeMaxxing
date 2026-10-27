import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/task_repository.dart';
import '../../../../shared/models/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final tasksNotifierProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return TaskNotifier(repository, selectedDate);
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;
  final DateTime _selectedDate;

  TaskNotifier(this._repository, this._selectedDate) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = _repository.getTasksForDate(_selectedDate);
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.saveTask(task);
    loadTasks();
  }

  Future<void> toggleTask(String id) async {
    await _repository.toggleTaskCompletion(id);
    loadTasks();
  }

  Future<void> removeTask(String id) async {
    await _repository.deleteTask(id);
    loadTasks();
  }
}
