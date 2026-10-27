import 'package:uuid/uuid.dart';

import '../models/knowledge_models.dart';
import '../repositories/knowledge_repository.dart';
import 'keyword_index.dart';
import 'text_chunker.dart';

/// Result of an import attempt.
sealed class ImportOutcome {
  const ImportOutcome();
}

class ImportSucceeded extends ImportOutcome {
  const ImportSucceeded(this.source);
  final KnowledgeSource source;
}

class ImportDuplicate extends ImportOutcome {
  const ImportDuplicate(this.existing);
  final KnowledgeSource existing;
}

class ImportRejected extends ImportOutcome {
  const ImportRejected(this.reason);
  final String reason;
}

/// Imports, indexes, searches and removes knowledge sources.
///
/// Imported text is untrusted data. This service only stores and retrieves
/// it; nothing in a source can trigger an action or grant a permission.
class KnowledgeService {
  KnowledgeService({
    required KnowledgeRepository repository,
    TextChunker chunker = const TextChunker(),
    KeywordIndex? index,
    DateTime Function()? clock,
    String Function()? idGenerator,
  })  : _repository = repository,
        _chunker = chunker,
        _index = index ?? KeywordIndex(),
        _clock = clock ?? DateTime.now,
        _newId = idGenerator ?? (() => const Uuid().v4()) {
    rebuildIndex();
  }

  static const int maxImportChars = 1000000;

  final KnowledgeRepository _repository;
  final TextChunker _chunker;
  final KeywordIndex _index;
  final DateTime Function() _clock;
  final String Function() _newId;

  List<KnowledgeSource> get sources => _repository.getSources();

  /// Rebuilds the search index from stored chunks (needed once the
  /// repository is persistent).
  void rebuildIndex() {
    _index.clear();
    for (final source in _repository.getSources()) {
      _index.addChunks(_repository.getChunksForSource(source.id));
    }
  }

  Future<ImportOutcome> importText({
    required String title,
    required SourceType type,
    required String text,
    String? author,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      return const ImportRejected(
          'Add a title so you can find this source later.');
    }
    if (text.trim().isEmpty) {
      return const ImportRejected('There is no text to import.');
    }
    if (text.length > maxImportChars) {
      return const ImportRejected(
        'This text is over ${maxImportChars ~/ 1000}k characters. Split it into smaller sources.',
      );
    }

    final fingerprint = fingerprintOf(text);
    final existing = _repository.findByFingerprint(fingerprint);
    if (existing != null) return ImportDuplicate(existing);

    final drafts = _chunker.chunk(text);
    if (drafts.isEmpty) {
      return const ImportRejected('No readable text found.');
    }

    final sourceId = _newId();
    final chunks = [
      for (final d in drafts)
        KnowledgeChunk(
          id: '${sourceId}_${d.position}',
          sourceId: sourceId,
          position: d.position,
          text: d.text,
          chapter: d.chapter,
        ),
    ];

    final cleanAuthor = author?.trim();
    final source = KnowledgeSource(
      id: sourceId,
      title: cleanTitle,
      author: (cleanAuthor == null || cleanAuthor.isEmpty) ? null : cleanAuthor,
      type: type,
      importedAt: _clock(),
      fingerprint: fingerprint,
      chunkCount: chunks.length,
    );

    try {
      await _repository.saveSource(source, chunks);
    } catch (_) {
      return const ImportRejected(
        'Could not save this source on the device. Nothing was imported.',
      );
    }
    _index.addChunks(chunks);
    return ImportSucceeded(source);
  }

  /// Removes the source and its derived index data.
  Future<void> removeSource(String id) async {
    await _repository.removeSource(id);
    _index.removeSource(id);
  }

  List<SearchResult> search(String query, {int limit = 8}) {
    final results = <SearchResult>[];
    for (final hit in _index.search(query, limit: limit)) {
      final chunk = _repository.getChunk(hit.chunkId);
      if (chunk == null) continue;
      final source = _repository.getSource(chunk.sourceId);
      if (source == null) continue;
      results.add(SearchResult(
        chunk: chunk,
        source: source,
        score: hit.score,
        snippet: _snippet(chunk.text, hit.matchedTerms),
        matchedTerms: hit.matchedTerms,
      ));
    }
    return results;
  }

  /// Hash of lowercased, whitespace-collapsed text: two 32-bit FNV-1a hashes
  /// plus the length. Arithmetic stays below 2^53 so it also works on web.
  static String fingerprintOf(String text) {
    final normalized =
        text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    final a = _fnv1a32(normalized, 0x811C9DC5).toRadixString(16);
    final b = _fnv1a32(normalized, 0x01234567).toRadixString(16);
    return '${normalized.length}-$a-$b';
  }

  static int _fnv1a32(String s, int seed) {
    var h = seed;
    for (final unit in s.codeUnits) {
      h = (h ^ unit) % 0x100000000;
      // h * 0x01000193 (mod 2^32) without overflowing past 2^53.
      h = ((h * 0x193) + ((h % 256) * 0x1000000)) % 0x100000000;
    }
    return h;
  }

  static String _snippet(String text, List<String> terms,
      {int maxLength = 220}) {
    if (text.length <= maxLength) return text;

    final lower = text.toLowerCase();
    var first = -1;
    for (final term in terms) {
      final i = lower.indexOf(term);
      if (i >= 0 && (first < 0 || i < first)) first = i;
    }

    final center = first < 0 ? 0 : first;
    final start = center > 60 ? center - 60 : 0;
    final end =
        start + maxLength < text.length ? start + maxLength : text.length;
    final prefix = start > 0 ? '\u2026' : '';
    final suffix = end < text.length ? '\u2026' : '';
    return '$prefix${text.substring(start, end).trim()}$suffix';
  }
}
