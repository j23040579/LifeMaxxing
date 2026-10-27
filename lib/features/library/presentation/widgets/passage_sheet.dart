import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';

import '../../domain/models/knowledge_models.dart';
import 'provenance_chip.dart';

/// Lets the user read the stored passage behind a search result.
class PassageSheet extends StatelessWidget {
  const PassageSheet({super.key, required this.result});

  final SearchResult result;

  static Future<void> show(BuildContext context, SearchResult result) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PassageSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Passage',
              style: textTheme.labelSmall?.copyWith(
                color: colors.textMuted,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ProvenanceChip(type: result.source.type),
            const SizedBox(height: 8),
            Text(
              result.citation,
              style: textTheme.titleMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (result.source.author != null) ...[
              const SizedBox(height: 2),
              Text(
                result.source.author!,
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: colors.border),
              ),
              child: SelectableText(
                result.chunk.text,
                style: textTheme.bodyMedium?.copyWith(color: colors.text),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stored text of this passage, with whitespace tidied. '
              'Chapter and page appear only when the import included them.',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
