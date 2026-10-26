class MilestoneModel {
  final String id;
  final String title;
  final bool isDone;
  final DateTime? completedDate;

  MilestoneModel({
    required this.id,
    required this.title,
    this.isDone = false,
    this.completedDate,
  });

  MilestoneModel copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? completedDate,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
