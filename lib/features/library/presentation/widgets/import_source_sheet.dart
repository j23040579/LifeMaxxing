import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';

import '../../domain/models/knowledge_models.dart';
import '../../domain/services/knowledge_service.dart';
import '../controllers/library_controller.dart';

/// Bottom sheet for importing pasted text as a source.
class ImportSourceSheet extends ConsumerStatefulWidget {
  const ImportSourceSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const ImportSourceSheet(),
    );
  }

  @override
  ConsumerState<ImportSourceSheet> createState() => _ImportSourceSheetState();
}

class _ImportSourceSheetState extends ConsumerState<ImportSourceSheet> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _textController = TextEditingController();

  SourceType _type = SourceType.summary;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _textController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
      ),
    );
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _busy = true;
      _error = null;
    });

    final outcome =
        await ref.read(libraryControllerProvider.notifier).importText(
              title: _titleController.text,
              author: _authorController.text,
              type: _type,
              text: _textController.text,
            );

    if (!mounted) return;

    switch (outcome) {
      case ImportSucceeded(:final source):
        final count = source.chunkCount;
        navigator.pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Imported "${source.title}" ($count ${count == 1 ? 'passage' : 'passages'})',
            ),
          ),
        );
      case ImportDuplicate(:final existing):
        setState(() {
          _busy = false;
          _error = 'Already imported as "${existing.title}".';
        });
      case ImportRejected(:final reason):
        setState(() {
          _busy = false;
          _error = reason;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.92;

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
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
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
              'Import a source',
              style: textTheme.titleMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Paste a book summary, your notes, or an article. '
              'Use lines starting with # to mark chapters.',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: _decoration('Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _authorController,
              textInputAction: TextInputAction.next,
              decoration: _decoration('Author (optional)'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final type in const [
                  SourceType.summary,
                  SourceType.note,
                  SourceType.fullText,
                  SourceType.other,
                ])
                  ChoiceChip(
                    label: Text(type.label),
                    selected: _type == type,
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textController,
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: _decoration('Text', hint: 'Paste text here'),
            ),
            const SizedBox(height: 8),
            Text(
              'Kept in memory on this device for now. It resets when the app closes.',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
            if (_error != null) ...[
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
                        _error!,
                        style: TextStyle(fontSize: 12, color: colors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.accentFill,
                  foregroundColor: colors.onAccent,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusControl),
                  ),
                ),
                child: Text(_busy ? 'Importing...' : 'Import'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
