import '../domain/models/completion_log_entry.dart';

/// Local completion log repository.
/// Preserves completed task records so goal progress and metrics survive external task cleanup.
class LocalCompletionLogRepository {
  final Map<String, CompletionLogEntry> _log = {};

  Future<void> recordCompletion(CompletionLogEntry entry) async {
    _log[entry.id] = entry;
  }

  List<CompletionLogEntry> getAllEntries() {
    final list = _log.values.toList();
    list.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return list;
  }

  List<CompletionLogEntry> getEntriesForGoal(String goalId) {
    return _log.values.where((e) => e.goalId == goalId).toList();
  }

  int getTotalCompletedMinutesForGoal(String goalId) {
    return getEntriesForGoal(goalId).fold(
      0,
      (sum, e) => sum + e.estimatedMinutes,
    );
  }

  Future<void> clear() async {
    _log.clear();
  }
}
