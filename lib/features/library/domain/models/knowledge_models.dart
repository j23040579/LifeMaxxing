/// How a source was provided. Drives the provenance label on every passage.
enum SourceType { fullText, summary, note, other }

extension SourceTypeX on SourceType {
  /// Short chip label.
  String get label => switch (this) {
        SourceType.fullText => 'Full text',
        SourceType.summary => 'Summary',
        SourceType.note => 'Note',
        SourceType.other => 'Other',
      };

  /// Longer description for screen readers and the passage inspector.
  String get description => switch (this) {
        SourceType.fullText => 'Full document',
        SourceType.summary => 'Your summary',
        SourceType.note => 'Your note',
        SourceType.other => 'Other source',
      };
}

/// One imported source (a book summary, a note, an article...).
///
/// A summary is a first-class source: it never needs the full book.
class KnowledgeSource {
  const KnowledgeSource({
    required this.id,
    required this.title,
    required this.type,
    required this.importedAt,
    required this.fingerprint,
    required this.chunkCount,
    this.author,
  });

  final String id;
  final String title;
  final String? author;
  final SourceType type;
  final DateTime importedAt;

  /// Hash of the normalised text, used to detect duplicate imports.
  final String fingerprint;
  final int chunkCount;
}

/// A passage of a source. [chapter] and [page] are only set when the import
/// carried them explicitly; they are never guessed.
class KnowledgeChunk {
  const KnowledgeChunk({
    required this.id,
    required this.sourceId,
    required this.position,
    required this.text,
    this.chapter,
    this.page,
  });

  final String id;
  final String sourceId;
  final int position;
  final String text;
  final String? chapter;
  final int? page;
}

/// A retrieved passage with everything needed to show where it came from.
class SearchResult {
  const SearchResult({
    required this.chunk,
    required this.source,
    required this.score,
    required this.snippet,
    required this.matchedTerms,
  });

  final KnowledgeChunk chunk;
  final KnowledgeSource source;
  final double score;
  final String snippet;
  final List<String> matchedTerms;

  /// Title, plus chapter and page only when they are known for this passage.
  String get citation {
    final buffer = StringBuffer(source.title);
    final chapter = chunk.chapter;
    if (chapter != null && chapter.isNotEmpty) {
      buffer.write(', $chapter');
    }
    final page = chunk.page;
    if (page != null) {
      buffer.write(', p. $page');
    }
    return buffer.toString();
  }
}
