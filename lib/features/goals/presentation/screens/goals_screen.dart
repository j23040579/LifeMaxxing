import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import '../controllers/goal_controller.dart';
import '../widgets/goal_card.dart';

/// Main Goals tab screen with yearly and monthly goal sections.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final goals = ref.watch(goalsNotifierProvider);

    final yearlyGoals = goals
        .where((g) => g.category.toLowerCase() == 'yearly')
        .toList();
    final monthlyGoals = goals
        .where((g) => g.category.toLowerCase() == 'monthly')
        .toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 96,
            pinned: true,
            backgroundColor: colors.background,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Goals',
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          if (yearlyGoals.isNotEmpty) ...[
            const _SectionHeader(title: 'Yearly'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: yearlyGoals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return GoalCard(goal: yearlyGoals[index]);
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],

          if (monthlyGoals.isNotEmpty) ...[
            const _SectionHeader(title: 'Monthly'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: monthlyGoals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return GoalCard(goal: monthlyGoals[index]);
                },
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}