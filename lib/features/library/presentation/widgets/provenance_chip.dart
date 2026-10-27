import 'package:flutter/material.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';

import '../../domain/models/knowledge_models.dart';

/// Shows what kind of source a passage comes from: icon plus label, never
/// colour alone.
class ProvenanceChip extends StatelessWidget {
  const ProvenanceChip({super.key, required this.type});

  final SourceType type;

  IconData get _icon => switch (type) {
        SourceType.fullText => Icons.description_outlined,
        SourceType.summary => Icons.short_text_rounded,
        SourceType.note => Icons.edit_note_rounded,
        SourceType.other => Icons.article_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: 'Source type: ${type.description}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 12, color: colors.textMuted),
            const SizedBox(width: 4),
            Text(
              type.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
