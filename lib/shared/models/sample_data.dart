/// Sample data models and prototype data for the LifeMaxxing app.
library;

// ── Enums ──────────────────────────────────────────────────────────────────

/// Status of a goal relative to its pace target.
enum PaceStatus { ahead, onPace, behind }

/// How a goal measures progress.
enum MeasureType { milestones, taskWeighted, metric }

// ── Models ─────────────────────────────────────────────────────────────────

/// A fixed calendar event (e.g. lecture, appointment).
class SampleEvent {
  const SampleEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isFixed = true,
    this.location,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isFixed;
  final String? location;
}

/// A single task item.
class SampleTask {
  const SampleTask({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isDone = false,
    this.estimatedMinutes,
    this.goalId,
  });

  final String id;
  final String title;
  final DateTime dueDate;
  final bool isDone;
  final int? estimatedMinutes;
  final String? goalId;

  SampleTask copyWith({bool? isDone}) => SampleTask(
        id: id,
        title: title,
        dueDate: dueDate,
        isDone: isDone ?? this.isDone,
        estimatedMinutes: estimatedMinutes,
        goalId: goalId,
      );
}

/// A time-blocked work session assigned to a task.
class SampleWorkBlock {
  const SampleWorkBlock({
    required this.id,
    required this.taskId,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isConfirmed = false,
    this.sourceNote,
  });

  final String id;
  final String taskId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isConfirmed;
  final String? sourceNote;
}

/// A milestone within a goal.
class SampleMilestone {
  const SampleMilestone({
    required this.id,
    required this.title,
    this.isDone = false,
    this.completedDate,
  });

  final String id;
  final String title;
  final bool isDone;
  final DateTime? completedDate;
}

/// A goal or sub-goal.
class SampleGoal {
  const SampleGoal({
    required this.id,
    required this.title,
    required this.why,
    required this.endDate,
    required this.progress,
    required this.paceStatus,
    required this.measureType,
    this.parentId,
    this.milestones = const [],
    this.linkedTaskIds = const [],
  });

  final String id;
  final String title;
  final String why;
  final DateTime endDate;
  final double progress; // 0.0 – 1.0
  final PaceStatus paceStatus;
  final MeasureType measureType;
  final String? parentId;
  final List<SampleMilestone> milestones;
  final List<String> linkedTaskIds;
}

// ── Helpers ────────────────────────────────────────────────────────────────

/// Returns [DateTime] for today at the given [hour] and [minute].
DateTime _today(int hour, [int minute = 0]) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

DateTime _daysFromNow(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

// ── Sample Data ────────────────────────────────────────────────────────────

/// Fixed calendar events for today.
final List<SampleEvent> sampleEvents = [
  SampleEvent(
    id: 'evt-1',
    title: 'Algorithms lecture',
    startTime: _today(9, 0),
    endTime: _today(10, 30),
    location: 'LT-3, Engineering Block',
  ),
  SampleEvent(
    id: 'evt-2',
    title: 'Badminton',
    startTime: _today(14, 0),
    endTime: _today(15, 30),
    location: 'Sports Hall B',
  ),
  SampleEvent(
    id: 'evt-3',
    title: 'Data Structures tutorial',
    startTime: _today(16, 0),
    endTime: _today(17, 0),
    location: 'Room 204',
  ),
];

/// Tasks for today.
final List<SampleTask> sampleTasks = [
  SampleTask(
    id: 'tsk-1',
    title: 'Essay draft',
    dueDate: _daysFromNow(4), // due Friday-ish
    estimatedMinutes: 90,
    goalId: 'goal-1',
  ),
  SampleTask(
    id: 'tsk-2',
    title: 'Read chapter 4 notes',
    dueDate: _daysFromNow(3),
    estimatedMinutes: 45,
  ),
  SampleTask(
    id: 'tsk-3',
    title: 'Submit lab report',
    dueDate: _daysFromNow(1), // due tomorrow
    estimatedMinutes: 30,
    goalId: 'goal-2',
  ),
  SampleTask(
    id: 'tsk-4',
    title: 'Review lecture slides',
    dueDate: _daysFromNow(2),
    estimatedMinutes: 20,
  ),
];

/// Tasks that do not fit into today's schedule (overflow / reschedule suggestions).
final List<SampleTask> sampleDoesntFitTasks = [sampleTasks[1]];

/// Work blocks allocated by the planner.
final List<SampleWorkBlock> sampleWorkBlocks = [
  SampleWorkBlock(
    id: 'wb-1',
    taskId: 'tsk-1',
    title: 'Essay draft',
    startTime: _today(11, 15),
    endTime: _today(12, 45),
    isConfirmed: false,
    sourceNote: 'Deep Work summary',
  ),
  SampleWorkBlock(
    id: 'wb-2',
    taskId: 'tsk-3',
    title: 'Submit lab report',
    startTime: _today(17, 30),
    endTime: _today(18, 0),
    isConfirmed: true,
  ),
];

/// Goals for the prototype user.
final List<SampleGoal> sampleGoals = [
  SampleGoal(
    id: 'goal-1',
    title: 'Graduate with First Class Honours',
    why: 'Open doors for research & career opportunities',
    endDate: _daysFromNow(240),
    progress: 0.65,
    paceStatus: PaceStatus.onPace,
    measureType: MeasureType.milestones,
    milestones: [
      SampleMilestone(
          id: 'ms-1',
          title: 'Complete semester coursework',
          isDone: true,
          completedDate: _daysFromNow(-30)),
      SampleMilestone(
          id: 'ms-2',
          title: 'Achieve 70%+ in midterms',
          isDone: true,
          completedDate: _daysFromNow(-14)),
      const SampleMilestone(id: 'ms-3', title: 'Submit dissertation proposal'),
      const SampleMilestone(id: 'ms-4', title: 'Final exams preparation'),
    ],
    linkedTaskIds: ['tsk-1'],
  ),
  SampleGoal(
    id: 'goal-2',
    title: 'Complete all assignments on time',
    why: 'Reduce last-minute stress and improve quality',
    endDate: _daysFromNow(25),
    progress: 0.4,
    paceStatus: PaceStatus.behind,
    measureType: MeasureType.taskWeighted,
    parentId: 'goal-1',
    linkedTaskIds: ['tsk-3'],
  ),
  SampleGoal(
    id: 'goal-3',
    title: 'Read 2 books this month',
    why: 'Build mental models for better decision-making',
    endDate: _daysFromNow(18),
    progress: 0.5,
    paceStatus: PaceStatus.ahead,
    measureType: MeasureType.metric,
    milestones: [
      SampleMilestone(
          id: 'ms-5',
          title: 'Finish "Deep Work"',
          isDone: true,
          completedDate: _daysFromNow(-5)),
      const SampleMilestone(id: 'ms-6', title: 'Finish "Atomic Habits"'),
    ],
  ),
  SampleGoal(
    id: 'goal-4',
    title: 'Train 4× per week',
    why: 'Stay energised and maintain discipline',
    endDate: _daysFromNow(25),
    progress: 0.75,
    paceStatus: PaceStatus.onPace,
    measureType: MeasureType.metric,
  ),
];
