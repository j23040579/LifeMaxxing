import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import 'package:life_maxxing/shared/models/sample_data.dart';

/// Card showing tasks that couldn't fit in today's schedule.
///
/// Each item displays the task name, estimated duration, and a suggestion
/// for when to reschedule.
class DoesntFitGroup extends StatelessWidget {
  const DoesntFitGroup({super.key, required this.tasks});

  final List<SampleTask> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.event_busy_outlined, size: 16, color: colors.textMuted),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Doesn\u2019t fit today",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Items
          ...tasks.map((task) => _DoesntFitItem(task: task)),
        ],
      ),
    );
  }
}

class _DoesntFitItem extends StatelessWidget {
  const _DoesntFitItem({required this.task});

  final SampleTask task;

  /// Generate a mock suggestion time for the prototype.
  String get _suggestion {
    final dow = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final suggest = DateTime.now().add(const Duration(days: 2));
    return 'Suggest ${dow[suggest.weekday - 1]} 10:00';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          // Task name
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(fontSize: 14, color: colors.text),
            ),
          ),

          // Duration chip
          if (task.estimatedMinutes != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${task.estimatedMinutes}m',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],

          // Suggestion chip
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reschedule "${task.title}"')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.accentFill.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _suggestion,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.accentText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
