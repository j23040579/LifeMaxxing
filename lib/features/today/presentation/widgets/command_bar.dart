import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/task_model.dart';
import '../controllers/task_controller.dart';

class CommandBar extends ConsumerStatefulWidget {
  const CommandBar({super.key});

  @override
  ConsumerState<CommandBar> createState() => _CommandBarState();
}

class _CommandBarState extends ConsumerState<CommandBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitCommand() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final lower = text.toLowerCase();

    // Check for disruption commands ("lost an hour", "rebuild", "replan")
    if (lower.contains('lost') ||
        lower.contains('rebuild') ||
        lower.contains('replan') ||
        lower.contains('delay') ||
        lower.contains('overrun')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Scheduler: Replanned remaining day from now ($text)',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      _controller.clear();
      return;
    }

    // Parse simple duration if specified in command (e.g. "45m", "2 hours", "90 min")
    int estimatedMin = 45;
    final minMatch = RegExp(r'(\d+)\s*(m|min|minutes)').firstMatch(lower);
    final hourMatch = RegExp(r'(\d+)\s*(h|hr|hours)').firstMatch(lower);

    if (minMatch != null) {
      estimatedMin = int.tryParse(minMatch.group(1)!) ?? 45;
    } else if (hourMatch != null) {
      estimatedMin = (int.tryParse(hourMatch.group(1)!) ?? 1) * 60;
    }

    final selectedDate = ref.read(selectedDateProvider);

    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: text,
      scheduledDate: selectedDate,
      estimatedMinutes: estimatedMin,
    );

    ref.read(tasksNotifierProvider.notifier).addTask(newTask);
    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added task: "$text" ($estimatedMin min)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Tell LifeMaxxing what changed...',
          prefixIcon: const Icon(Icons.auto_awesome_outlined, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_upward_rounded),
            onPressed: _submitCommand,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onSubmitted: (_) => _submitCommand(),
      ),
    );
  }
}
