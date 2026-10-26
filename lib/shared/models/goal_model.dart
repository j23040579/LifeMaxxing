import 'milestone_model.dart';
import 'sample_data.dart';

class GoalModel {
  final String id;
  final String title;
  final String why;
  final DateTime endDate;
  final double progress;
  final int paceStatusIndex;
  final int measureTypeIndex;
  final String? parentId;
  final List<MilestoneModel> milestones;
  final List<String> linkedTaskIds;
  final String category;

  PaceStatus get paceStatus => PaceStatus.values[paceStatusIndex];
  MeasureType get measureType => MeasureType.values[measureTypeIndex];

  GoalModel({
    required this.id,
    required this.title,
    required this.why,
    required this.endDate,
    required this.progress,
    required this.paceStatusIndex,
    required this.measureTypeIndex,
    this.parentId,
    this.milestones = const [],
    this.linkedTaskIds = const [],
    required this.category,
  });

  GoalModel copyWith({
    String? id,
    String? title,
    String? why,
    DateTime? endDate,
    double? progress,
    int? paceStatusIndex,
    int? measureTypeIndex,
    String? parentId,
    List<MilestoneModel>? milestones,
    List<String>? linkedTaskIds,
    String? category,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      why: why ?? this.why,
      endDate: endDate ?? this.endDate,
      progress: progress ?? this.progress,
      paceStatusIndex: paceStatusIndex ?? this.paceStatusIndex,
      measureTypeIndex: measureTypeIndex ?? this.measureTypeIndex,
      parentId: parentId ?? this.parentId,
      milestones: milestones ?? this.milestones,
      linkedTaskIds: linkedTaskIds ?? this.linkedTaskIds,
      category: category ?? this.category,
    );
  }
}
