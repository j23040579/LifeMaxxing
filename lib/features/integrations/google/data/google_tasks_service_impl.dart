import 'package:googleapis/tasks/v1.dart' as tasks_api;
import 'package:http/http.dart' as http;
import '../domain/models/task_ref.dart';
import '../domain/services/google_tasks_service.dart';

class GoogleTasksServiceImpl implements GoogleTasksService {
  final Future<http.Client?> Function() _getClient;

  GoogleTasksServiceImpl({
    required Future<http.Client?> Function() getClient,
  }) : _getClient = getClient;

  Future<tasks_api.TasksApi> _getApi() async {
    final client = await _getClient();
    if (client == null) {
      throw Exception('Not signed in to Google Tasks');
    }
    return tasks_api.TasksApi(client);
  }

  @override
  Future<List<TaskRef>> getTasks({
    String taskListId = '@default',
    bool showCompleted = true,
  }) async {
    final api = await _getApi();
    final tasksList = await api.tasks.list(
      taskListId,
      showCompleted: showCompleted,
      showHidden: showCompleted,
    );

    final items = tasksList.items ?? [];
    return items.map((t) => _mapToRef(t, taskListId)).toList();
  }

  @override
  Future<TaskRef> createTask({
    String taskListId = '@default',
    required String title,
    String? notes,
    DateTime? dueDate,
    String? goalId,
  }) async {
    final api = await _getApi();

    final newTask = tasks_api.Task(
      title: title,
      notes: notes,
      due: dueDate?.toUtc().toIso8601String(),
    );

    final created = await api.tasks.insert(newTask, taskListId);
    return _mapToRef(created, taskListId, goalId: goalId);
  }

  @override
  Future<TaskRef> updateTask(TaskRef task) async {
    final api = await _getApi();

    final gTask = tasks_api.Task(
      id: task.id,
      title: task.title,
      notes: task.notes,
      due: task.dueDate?.toUtc().toIso8601String(),
      status: task.isCompleted ? 'completed' : 'needsAction',
    );

    final updated = await api.tasks.update(gTask, task.listId, task.id);
    return _mapToRef(updated, task.listId, goalId: task.goalId);
  }

  @override
  Future<TaskRef> completeTask({
    String taskListId = '@default',
    required String taskId,
    bool isCompleted = true,
  }) async {
    final api = await _getApi();

    final currentTask = await api.tasks.get(taskListId, taskId);
    currentTask.status = isCompleted ? 'completed' : 'needsAction';
    if (isCompleted) {
      currentTask.completed = DateTime.now().toUtc().toIso8601String();
    } else {
      currentTask.completed = null;
    }

    final updated = await api.tasks.update(currentTask, taskListId, taskId);
    return _mapToRef(updated, taskListId);
  }

  @override
  Future<void> deleteTask({
    String taskListId = '@default',
    required String taskId,
  }) async {
    final api = await _getApi();
    await api.tasks.delete(taskListId, taskId);
  }

  TaskRef _mapToRef(tasks_api.Task task, String listId, {String? goalId}) {
    DateTime? due;
    if (task.due != null) {
      due = DateTime.tryParse(task.due!)?.toLocal();
    }

    DateTime? completed;
    if (task.completed != null) {
      completed = DateTime.tryParse(task.completed!)?.toLocal();
    }

    return TaskRef(
      id: task.id ?? '',
      listId: listId,
      title: task.title ?? 'Untitled Task',
      notes: task.notes,
      dueDate: due,
      isCompleted: task.status == 'completed',
      completedAt: completed,
      etag: task.etag,
      goalId: goalId,
    );
  }
}
