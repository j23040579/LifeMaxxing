import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import 'package:life_maxxing/shared/models/sample_data.dart';

/// Tile for a fixed calendar event.
///
/// Features a 3 px steel left edge, lock icon, title, time range,
/// and optional location.
class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event});

  final SampleEvent event;

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── Left accent bar ───────────────────────────────────────
            Container(width: 3, color: colors.steel),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fixed label row
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outlined,
                          size: 13,
                          color: colors.steel,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Fixed',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.steel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Title
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Time range
                    Text(
                      '${_formatTime(event.startTime)} – ${_formatTime(event.endTime)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),

                    // Optional location
                    if (event.location != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13, color: colors.textMuted),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              event.location!,
                              style: TextStyle(
                                  fontSize: 12, color: colors.textMuted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
