import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../integrations/google/presentation/controllers/google_sync_controller.dart';
import '../../../integrations/google/presentation/widgets/google_account_sheet.dart';

/// Interactive sync status bar showing sync timestamp, connection state,
/// and allowing one-tap account management.
class SyncBar extends ConsumerWidget {
  const SyncBar({super.key});

  String _formatSyncTime(DateTime? dt) {
    if (dt == null) return 'Not synced';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Synced just now';
    if (diff.inMinutes < 60) return 'Synced ${diff.inMinutes}m ago';
    return 'Synced ${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final syncState = ref.watch(googleSyncControllerProvider);

    return InkWell(
      onTap: () => GoogleAccountSheet.show(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            if (syncState.status == GoogleSyncStatus.syncing) ...[
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: colors.accentFill,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Syncing with Google...',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
            ] else ...[
              Icon(
                syncState.isConnected
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                size: 14,
                color: syncState.isConnected ? colors.success : colors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                syncState.isConnected
                    ? _formatSyncTime(syncState.lastSyncTime)
                    : 'Tap to connect Google Calendar & Tasks',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: syncState.isConnected
                    ? colors.success.withValues(alpha: 0.12)
                    : colors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                syncState.isConnected ? 'Google Sync' : 'Sample data',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: syncState.isConnected ? colors.success : colors.warning,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
