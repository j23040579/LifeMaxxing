import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/task_model.dart';
import '../controllers/task_controller.dart';

class TaskRow extends ConsumerWidget {
  final TaskModel task;

  const TaskRow({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        color: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) {
        ref.read(tasksNotifierProvider.notifier).removeTask(task.id);
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            ref.read(tasksNotifierProvider.notifier).toggleTask(task.id);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: task.category != null
            ? Text(
                '${task.category} • ${task.estimatedMinutes}m',
                style: theme.textTheme.bodySmall,
              )
            : Text('${task.estimatedMinutes}m',
                style: theme.textTheme.bodySmall),
      ),
    );
  }
}
