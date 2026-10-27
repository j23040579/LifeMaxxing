import '../../shared/models/goal_model.dart';
import '../../shared/models/milestone_model.dart';
import '../../shared/models/sample_data.dart';

class GoalRepository {
  final Map<String, GoalModel> _goals = {};

  Future<void> init() async {
    for (final goal in sampleGoals) {
      _goals[goal.id] = GoalModel(
        id: goal.id,
        title: goal.title,
        why: goal.why,
        endDate: goal.endDate,
        progress: goal.progress,
        paceStatusIndex: goal.paceStatus.index,
        measureTypeIndex: goal.measureType.index,
        parentId: goal.parentId,
        milestones: goal.milestones
            .map((m) => MilestoneModel(
                  id: m.id,
                  title: m.title,
                  isDone: m.isDone,
                  completedDate: m.completedDate,
                ))
            .toList(),
        linkedTaskIds: goal.linkedTaskIds,
        category:
            goal.measureType == MeasureType.milestones ? 'Yearly' : 'Monthly',
      );
    }
  }

  List<GoalModel> getAllGoals() => _goals.values.toList();

  Future<void> saveGoal(GoalModel goal) async {
    _goals[goal.id] = goal;
  }

  Future<void> toggleMilestone(String goalId, String milestoneId) async {
    final goal = _goals[goalId];
    if (goal != null) {
      final updatedMilestones = goal.milestones.map((m) {
        if (m.id == milestoneId) {
          return m.copyWith(
            isDone: !m.isDone,
            completedDate: !m.isDone ? DateTime.now() : null,
          );
        }
        return m;
      }).toList();

      final completedCount = updatedMilestones.where((m) => m.isDone).length;
      final newProgress = updatedMilestones.isEmpty
          ? goal.progress
          : completedCount / updatedMilestones.length;

      final updatedGoal = goal.copyWith(
        milestones: updatedMilestones,
        progress: newProgress,
      );
      _goals[goalId] = updatedGoal;
    }
  }
}
