import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';

/// A crimson "now" line with a dot on the left, positioned at the current
/// time within the timeline.
class NowLine extends StatelessWidget {
  const NowLine({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colors.accentFill;

    return SizedBox(
      height: 12,
      child: Row(
        children: [
          // Dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          // Line
          Expanded(
            child: Container(
              height: 2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
