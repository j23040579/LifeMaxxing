import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/goal_repository.dart';
import '../../../../shared/models/goal_model.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

final goalsNotifierProvider = StateNotifierProvider<GoalNotifier, List<GoalModel>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return GoalNotifier(repository);
});

class GoalNotifier extends StateNotifier<List<GoalModel>> {
  final GoalRepository _repository;

  GoalNotifier(this._repository) : super([]) {
    loadGoals();
  }

  void loadGoals() {
    state = _repository.getAllGoals();
  }

  Future<void> toggleMilestone(String goalId, String milestoneId) async {
    await _repository.toggleMilestone(goalId, milestoneId);
    loadGoals();
  }

  Future<void> addGoal(GoalModel goal) async {
    await _repository.saveGoal(goal);
    loadGoals();
  }
}