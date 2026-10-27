import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/storage/goal_repository.dart';
import 'core/storage/task_repository.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/goals/presentation/controllers/goal_controller.dart';
import 'features/library/data/drift_knowledge_repository.dart';
import 'features/library/data/in_memory_knowledge_repository.dart';
import 'features/library/domain/repositories/knowledge_repository.dart';
import 'features/library/presentation/controllers/library_controller.dart';
import 'features/main/presentation/screens/main_shell_screen.dart';
import 'features/today/presentation/controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskRepo = TaskRepository();
  await taskRepo.init();

  final goalRepo = GoalRepository();
  await goalRepo.init();

  final library = await _openLibraryStorage();

  runApp(
    ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(taskRepo),
        goalRepositoryProvider.overrideWithValue(goalRepo),
        knowledgeRepositoryProvider.overrideWithValue(library.repository),
        libraryStorageModeProvider.overrideWithValue(library.mode),
      ],
      child: const LifeMaxxingApp(),
    ),
  );
}

typedef _LibraryStorage = ({
  KnowledgeRepository repository,
  LibraryStorageMode mode,
});

/// Opens the on-device database and loads the saved Library.
///
/// If anything fails (for example Chrome without the drift web files), the app
/// still starts with an in-memory Library and says so in the import sheet,
/// instead of crashing or pretending to save.
Future<_LibraryStorage> _openLibraryStorage() async {
  AppDatabase? db;
  try {
    db = AppDatabase();
    final repository = DriftKnowledgeRepository(db);
    await repository.init();
    return (repository: repository, mode: LibraryStorageMode.device);
  } catch (error) {
    // Type only: never print library content.
    debugPrint('Library storage unavailable (${error.runtimeType}). '
        'Falling back to memory only.');
    try {
      await db?.close();
    } catch (_) {
      // Nothing useful to do if closing also fails.
    }
    return (
      repository: InMemoryKnowledgeRepository(),
      mode: LibraryStorageMode.memoryOnly,
    );
  }
}

class LifeMaxxingApp extends StatelessWidget {
  const LifeMaxxingApp({super.key});

  @override
  Widget build(BuildContext context) {
    const darkColors = AppColorsDark();

    return AppColorsProvider(
      colors: darkColors,
      child: MaterialApp(
        title: 'LifeMaxxing',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: const MainShellScreen(),
      ),
    );
  }
}
