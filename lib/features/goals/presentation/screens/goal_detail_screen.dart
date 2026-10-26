import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import '../../../../shared/models/goal_model.dart';
import '../controllers/goal_controller.dart';
import '../widgets/milestone_row.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    final goals = ref.watch(goalsNotifierProvider);
    final goal = goals.firstWhere(
      (g) => g.id == goalId,
      orElse: () => GoalModel(
        id: goalId,
        title: 'Goal Not Found',
        why: '',
        endDate: DateTime.now(),
        progress: 0,
        paceStatusIndex: 1,
        measureTypeIndex: 0,
        milestones: [],
        linkedTaskIds: [],
        category: 'Yearly',
      ),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Goal Details',
          style: textTheme.titleMedium?.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: textTheme.headlineMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (goal.why.isNotEmpty) ...[
              Text(
                goal.why,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(goal.progress * 100).round()}%',
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.accentFill,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accentFill),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                      ),
                      Text(
                        goal.category,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Milestones',
              style: textTheme.titleMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (goal.milestones.isEmpty)
              Text(
                'No milestones specified.',
                style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goal.milestones.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final milestone = goal.milestones[index];
                  return MilestoneRow(
                    milestone: milestone,
                    onToggle: () {
                      ref
                          .read(goalsNotifierProvider.notifier)
                          .toggleMilestone(goal.id, milestone.id);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}