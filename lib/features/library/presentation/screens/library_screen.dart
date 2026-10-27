import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_maxxing/core/theme/app_colors.dart';
import 'package:life_maxxing/core/theme/app_spacing.dart';

import '../../domain/models/knowledge_models.dart';
import '../controllers/library_controller.dart';
import '../widgets/import_source_sheet.dart';
import '../widgets/passage_sheet.dart';
import '../widgets/provenance_chip.dart';

/// Library tab: import sources, search them, inspect the passage behind
/// each result, and remove a source with its index data.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmRemove(KnowledgeSource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove source?'),
        content: Text(
          '"${source.title}" and its search index will be deleted from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(libraryControllerProvider.notifier)
          .removeSource(source.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(libraryControllerProvider);
    final hasSources = state.sources.isNotEmpty;
    final searching = state.query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 96,
            pinned: true,
            backgroundColor: colors.background,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Library',
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (!hasSources)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(
                onImport: () => ImportSourceSheet.show(context),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => ref
                            .read(libraryControllerProvider.notifier)
                            .search(value),
                        decoration: InputDecoration(
                          hintText: 'Search your sources',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: searching
                              ? IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref
                                        .read(
                                            libraryControllerProvider.notifier)
                                        .search('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusControl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Import source',
                      onPressed: () => ImportSourceSheet.show(context),
                      icon: const Icon(Icons.add_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: colors.accentFill,
                        foregroundColor: colors.onAccent,
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (searching)
              ..._resultSlivers(state, colors, textTheme)
            else
              ..._sourceSlivers(state),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    );
  }

  List<Widget> _sourceSlivers(LibraryState state) {
    return [
      const _SectionHeader(title: 'Sources'),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.separated(
          itemCount: state.sources.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final source = state.sources[index];
            return _SourceTile(
              source: source,
              onRemove: () => _confirmRemove(source),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _resultSlivers(
    LibraryState state,
    AppColors colors,
    TextTheme textTheme,
  ) {
    if (state.results.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Text(
              'No passages match. Try fewer or different words.',
              style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
          ),
        ),
      ];
    }

    return [
      _SectionHeader(
        title: '${state.results.length} '
            '${state.results.length == 1 ? 'passage' : 'passages'}',
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.separated(
          itemCount: state.results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final result = state.results[index];
            return _ResultCard(
              result: result,
              onTap: () => PassageSheet.show(context, result),
            );
          },
        ),
      ),
    ];
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onImport});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Your knowledge base',
              style: textTheme.titleMedium?.copyWith(
                color: colors.text,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Paste a book summary, notes, or an article. '
              'Search them and see exactly where each passage came from.',
              style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onImport,
              style: FilledButton.styleFrom(
                backgroundColor: colors.accentFill,
                foregroundColor: colors.onAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Import'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.source, required this.onRemove});

  final KnowledgeSource source;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final count = source.chunkCount;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (source.author != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    source.author!,
                    style:
                        textTheme.bodySmall?.copyWith(color: colors.textMuted),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ProvenanceChip(type: source.type),
                    Text(
                      '$count ${count == 1 ? 'passage' : 'passages'} \u2022 '
                      'Imported ${_formatDate(source.importedAt)}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove source',
            icon: Icon(Icons.delete_outline, color: colors.textMuted),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onTap});

  final SearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '${result.source.type.description}, ${result.citation}. '
          'Tap to read the passage.',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ProvenanceChip(type: result.source.type),
                  Text(
                    result.citation,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                result.snippet,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(color: colors.text),
              ),
              const SizedBox(height: 8),
              Text(
                'Read passage',
                style: textTheme.bodySmall?.copyWith(color: colors.accentText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
