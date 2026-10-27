import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/sample_data.dart';
import '../../../scheduling/presentation/controllers/scheduling_controller.dart';
import '../controllers/task_controller.dart';
import '../widgets/command_bar.dart';
import '../widgets/date_strip.dart';
import '../widgets/doesnt_fit_group.dart';
import '../widgets/event_tile.dart';
import '../widgets/now_line.dart';
import '../widgets/sync_bar.dart';
import '../widgets/task_row.dart';
import '../widgets/work_block.dart';

enum TodayViewMode { day, agenda }

final todayViewModeProvider =
    StateProvider<TodayViewMode>((ref) => TodayViewMode.day);

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final tasks = ref.watch(tasksNotifierProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final viewMode = ref.watch(todayViewModeProvider);
    final plan = ref.watch(schedulePlanProvider);

    // Convert plan scheduled blocks into UI model
    final workBlocks = plan.scheduledBlocks.map((b) {
      return SampleWorkBlock(
        id: b.id,
        taskId: b.taskId,
        title: b.title,
        startTime: b.timeRange.start,
        endTime: b.timeRange.end,
        isConfirmed: b.isConfirmed,
        sourceNote: b.sourceReason,
      );
    }).toList();

    // Convert unfitted tasks into UI model
    final unfittedTasks = plan.unfittedTasks.map((u) {
      return SampleTask(
        id: u.id,
        title: u.title,
        dueDate: u.deadline ?? DateTime.now().add(const Duration(days: 1)),
        estimatedMinutes: u.estimatedDuration.inMinutes,
        goalId: u.goalId,
      );
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Sync status header
            const SyncBar(),

            // Collapsing-style large title & date strip
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Large Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Today',
                            style: textTheme.headlineLarge?.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          // View toggle: Day / Agenda
                          Container(
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(color: colors.border),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                _ToggleTab(
                                  label: 'Day',
                                  isSelected: viewMode == TodayViewMode.day,
                                  onTap: () => ref
                                      .read(todayViewModeProvider.notifier)
                                      .state = TodayViewMode.day,
                                ),
                                _ToggleTab(
                                  label: 'Agenda',
                                  isSelected: viewMode == TodayViewMode.agenda,
                                  onTap: () => ref
                                      .read(todayViewModeProvider.notifier)
                                      .state = TodayViewMode.agenda,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Horizontal Date Strip
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: DateStrip(
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          ref.read(selectedDateProvider.notifier).state = date;
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: Divider(height: 1),
                  ),

                  // Schedule content
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Section: Schedule
                        Row(
                          children: [
                            Text(
                              'SCHEDULE',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.textMuted,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.surfaceRaised,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colors.border),
                              ),
                              child: Text(
                                '${plan.fixedEvents.length} fixed • ${plan.scheduledBlocks.length} planned (${plan.totalWorkMinutes}m)',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Render chronological timeline items
                        ..._buildTimelineItems(sampleEvents, workBlocks),

                        const SizedBox(height: 20),

                        // Section: Doesn't fit today (dynamically calculated by scheduler)
                        if (unfittedTasks.isNotEmpty) ...[
                          DoesntFitGroup(tasks: unfittedTasks),
                          const SizedBox(height: 24),
                        ],

                        // Section: Prioritized tasks
                        Row(
                          children: [
                            Text(
                              'TASKS',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.textMuted,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${tasks.where((t) => t.isCompleted).length}/${tasks.length} done',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Task rows
                        ...tasks.map((task) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: TaskRow(task: task),
                            )),

                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Command bar at bottom of Today screen
            const CommandBar(),
          ],
        ),
      ),
    );
  }

  /// Builds timeline items with fixed events, planned work blocks, and the NowLine.
  List<Widget> _buildTimelineItems(
    List<SampleEvent> events,
    List<SampleWorkBlock> blocks,
  ) {
    final widgets = <Widget>[];

    // Combine and sort events and blocks chronologically
    final items = <_TimelineItem>[
      ...events.map((e) => _TimelineItem(
            start: e.startTime,
            widget: EventTile(event: e),
          )),
      ...blocks.map((b) => _TimelineItem(
            start: b.startTime,
            widget: WorkBlock(block: b),
          )),
    ];

    items.sort((a, b) => a.start.compareTo(b.start));

    final now = DateTime.now();
    bool nowLineInserted = false;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Insert NowLine if the item start is after current time
      if (!nowLineInserted && item.start.isAfter(now)) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: NowLine(),
        ));
        nowLineInserted = true;
      }

      widgets.add(item.widget);
      widgets.add(const SizedBox(height: 10));
    }

    if (!nowLineInserted) {
      widgets.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: NowLine(),
      ));
    }

    return widgets;
  }
}

class _TimelineItem {
  final DateTime start;
  final Widget widget;

  _TimelineItem({required this.start, required this.widget});
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.surfaceRaised : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colors.text : colors.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
