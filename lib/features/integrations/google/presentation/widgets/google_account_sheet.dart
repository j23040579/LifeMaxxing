import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';
import '../controllers/google_sync_controller.dart';

/// Modal bottom sheet for managing the Google Account connection and sync status.
class GoogleAccountSheet extends ConsumerWidget {
  const GoogleAccountSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const GoogleAccountSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final syncState = ref.watch(googleSyncControllerProvider);
    final syncController = ref.read(googleSyncControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppSpacing.borderRadiusTopLg,
        border: Border(
          top: BorderSide(color: colors.border),
          left: BorderSide(color: colors.border),
          right: BorderSide(color: colors.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.controlOutline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            children: [
              Icon(Icons.sync_rounded, color: colors.accentText, size: 24),
              const SizedBox(width: 10),
              Text(
                'Google Sync & Account',
                style: textTheme.titleMedium?.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Account Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colors.border,
                      backgroundImage: syncState.account.photoUrl != null
                          ? NetworkImage(syncState.account.photoUrl!)
                          : null,
                      child: syncState.account.photoUrl == null
                          ? Icon(Icons.person_outline, color: colors.textMuted)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            syncState.isConnected
                                ? (syncState.account.displayName ?? syncState.account.email)
                                : 'Not connected',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            syncState.isConnected
                                ? syncState.account.email
                                : 'Using offline sample data',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (syncState.isConnected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Connected',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.success,
                          ),
                        ),
                      ),
                  ],
                ),
                if (syncState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, size: 16, color: colors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            syncState.errorMessage!,
                            style: TextStyle(fontSize: 12, color: colors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Scopes and permissions explanation (Least-privilege notice)
          Text(
            'PERMISSIONS & DATA USE',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textMuted,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const _PermissionItem(
            icon: Icons.calendar_today_outlined,
            title: 'Google Calendar (view & create events)',
            subtitle: 'Reads commitments to prevent double-booking. Confirmed work blocks are placed as events.',
          ),
          const SizedBox(height: 8),
          const _PermissionItem(
            icon: Icons.check_circle_outline,
            title: 'Google Tasks (sync task items)',
            subtitle: 'Reads tasks and updates completed status. Local completion log preserves progress.',
          ),
          const SizedBox(height: 24),

          // Actions
          if (syncState.isConnected) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: syncState.status == GoogleSyncStatus.syncing
                        ? null
                        : () => syncController.syncNow(),
                    icon: syncState.status == GoogleSyncStatus.syncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      syncState.status == GoogleSyncStatus.syncing
                          ? 'Syncing...'
                          : 'Sync Now',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => syncController.signOut(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                  ),
                  child: Text(
                    'Disconnect',
                    style: TextStyle(color: colors.error),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: syncState.status == GoogleSyncStatus.connecting
                    ? null
                    : () => syncController.signIn(),
                icon: syncState.status == GoogleSyncStatus.connecting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login_rounded, size: 18),
                label: const Text('Connect Google Account'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
