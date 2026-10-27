import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: 0.5),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.accentFill.withValues(alpha: 0.12),
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: onTap,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.today_outlined, color: colors.textMuted),
            selectedIcon: Icon(Icons.today, color: colors.accentFill),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined, color: colors.textMuted),
            selectedIcon: Icon(Icons.flag, color: colors.accentFill),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined, color: colors.textMuted),
            selectedIcon: Icon(Icons.menu_book, color: colors.accentFill),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined, color: colors.textMuted),
            selectedIcon: Icon(Icons.insights, color: colors.accentFill),
            label: 'Review',
          ),
        ],
      ),
    );
  }
}
