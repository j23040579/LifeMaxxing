import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_bottom_bar.dart';
import '../../../goals/presentation/screens/goals_screen.dart';
import '../../../library/presentation/screens/library_screen.dart';
import '../../../review/presentation/screens/review_screen.dart';
import '../../../today/presentation/screens/today_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    const pages = [
      TodayScreen(),
      GoalsScreen(),
      LibraryScreen(),
      ReviewScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
