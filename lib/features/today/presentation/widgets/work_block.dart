import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import 'package:life_maxxing/shared/models/sample_data.dart';

/// A time-blocked work session tile with two visual states:
///
/// - **Proposed** – dashed border, "Proposed" label, provenance chip,
///   Accept / Adjust action buttons.
/// - **Confirmed** – solid border, visually distinct from [EventTile].
class WorkBlock extends StatelessWidget {
  const WorkBlock({super.key, required this.block});

  final SampleWorkBlock block;

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return block.isConfirmed
        ? _buildConfirmed(context, colors)
        : _buildProposed(context, colors);
  }

  // ── Confirmed state ────────────────────────────────────────────────────

  Widget _buildConfirmed(BuildContext context, AppColors colors) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(
            color: colors.accentFill.withValues(alpha: 0.35), width: 1.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Accent left bar
            Container(width: 3, color: colors.accentFill),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Label + task link
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 13, color: colors.success),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Confirmed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.success,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.link_rounded,
                            size: 14, color: colors.textMuted),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      block.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatTime(block.startTime)} – ${_formatTime(block.endTime)}',
                      style: TextStyle(fontSize: 13, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Proposed state ─────────────────────────────────────────────────────

  Widget _buildProposed(BuildContext context, AppColors colors) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: colors.controlOutline,
        radius: AppSpacing.radiusCard,
        strokeWidth: 1.5,
        dashLength: 6,
        gapLength: 4,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label + task link
            Row(
              children: [
                Icon(Icons.auto_awesome_outlined,
                    size: 13, color: colors.accentText),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Proposed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.accentText,
                  ),
                ),
                const Spacer(),
                Icon(Icons.link_rounded, size: 14, color: colors.textMuted),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            Text(
              block.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${_formatTime(block.startTime)} – ${_formatTime(block.endTime)}',
              style: TextStyle(fontSize: 13, color: colors.textMuted),
            ),

            // Provenance chip
            if (block.sourceNote != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ProvenanceChip(source: block.sourceNote!, colors: colors),
            ],

            const SizedBox(height: AppSpacing.sm),

            // Action buttons
            Row(
              children: [
                _ActionButton(
                  label: 'Accept',
                  icon: Icons.check_rounded,
                  color: colors.accentFill,
                  textColor: colors.onAccent,
                  filled: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Work block accepted')),
                    );
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: 'Adjust',
                  icon: Icons.tune_rounded,
                  color: colors.controlOutline,
                  textColor: colors.text,
                  filled: false,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open adjust sheet')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Provenance chip ──────────────────────────────────────────────────────

class _ProvenanceChip extends StatelessWidget {
  const _ProvenanceChip({required this.source, required this.colors});

  final String source;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 12, color: colors.textMuted),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Based on: $source',
            style: TextStyle(fontSize: 11, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── Small action button ──────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          border: filled ? null : Border.all(color: color),
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dashed border painter ────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.5,
    this.dashLength = 6,
    this.gapLength = 4,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
