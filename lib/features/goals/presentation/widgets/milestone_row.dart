import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import '../../../../shared/models/milestone_model.dart';

class MilestoneRow extends StatelessWidget {
  const MilestoneRow({
    super.key,
    required this.milestone,
    required this.onToggle,
  });

  final MilestoneModel milestone;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Checkbox(
              value: milestone.isDone,
              onChanged: (_) => onToggle(),
              activeColor: colors.accentFill,
              checkColor: colors.onAccent,
              side: BorderSide(color: colors.textMuted),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                milestone.title,
                style: textTheme.bodyMedium?.copyWith(
                  color: milestone.isDone ? colors.textMuted : colors.text,
                  decoration:
                      milestone.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}