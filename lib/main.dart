import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/goal_repository.dart';
import 'core/storage/task_repository.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/goals/presentation/controllers/goal_controller.dart';
import 'features/main/presentation/screens/main_shell_screen.dart';
import 'features/today/presentation/controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskRepo = TaskRepository();
  await taskRepo.init();

  final goalRepo = GoalRepository();
  await goalRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(taskRepo),
        goalRepositoryProvider.overrideWithValue(goalRepo),
      ],
      child: const LifeMaxxingApp(),
    ),
  );
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
