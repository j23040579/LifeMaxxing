import 'dart:math' as math;

import '../models/knowledge_models.dart';

/// Lowercases, splits on non-letters/digits, drops stop words, and folds
/// simple plurals. Used for both indexing and queries so they always agree.
class TextTokenizer {
  const TextTokenizer._();

  static final RegExp _splitter = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

  static const Set<String> _stopWords = {
    'the',
    'and',
    'of',
    'to',
    'in',
    'is',
    'it',
    'that',
    'for',
    'on',
    'with',
    'as',
    'was',
    'are',
    'be',
    'by',
    'at',
    'or',
    'an',
    'this',
    'from',
    'not',
    'but',
    'have',
    'has',
    'had',
    'you',
    'your',
    'we',
    'they',
    'their',
    'its',
    'were',
    'been',
    'will',
    'can',
  };

  static List<String> tokenize(String text) {
    final tokens = <String>[];
    for (final raw in text.toLowerCase().split(_splitter)) {
      if (raw.length < 2 || _stopWords.contains(raw)) continue;
      tokens.add(_fold(raw));
    }
    return tokens;
  }

  static String _fold(String token) {
    if (token.length > 4 && token.endsWith('ies')) {
      return '${token.substring(0, token.length - 3)}y';
    }
    if (token.length > 3 && token.endsWith('s') && !token.endsWith('ss')) {
      return token.substring(0, token.length - 1);
    }
    return token;
  }
}

/// One ranked hit from [KeywordIndex.search].
class ScoredChunk {
  const ScoredChunk({
    required this.chunkId,
    required this.score,
    required this.matchedTerms,
  });

  final String chunkId;
  final double score;
  final List<String> matchedTerms;
}

/// In-memory BM25 keyword index over chunks (Phase 5: keyword search first;
/// embeddings can be added later as a hybrid).
class KeywordIndex {
  static const double _k1 = 1.5;
  static const double _b = 0.75;

  final Map<String, Map<String, int>> _postings = {}; // term -> chunk -> tf
  final Map<String, Map<String, int>> _termsByChunk = {};
  final Map<String, int> _lengthByChunk = {};
  final Map<String, Set<String>> _chunkIdsBySource = {};
  int _totalLength = 0;

  int get chunkCount => _lengthByChunk.length;

  void addChunks(Iterable<KnowledgeChunk> chunks) {
    for (final chunk in chunks) {
      addChunk(chunk);
    }
  }

  void addChunk(KnowledgeChunk chunk) {
    _removeChunk(chunk.id);

    final terms = <String, int>{};
    var length = 0;
    for (final token in TextTokenizer.tokenize(chunk.text)) {
      terms[token] = (terms[token] ?? 0) + 1;
      length++;
    }

    _termsByChunk[chunk.id] = terms;
    _lengthByChunk[chunk.id] = length;
    _totalLength += length;
    _chunkIdsBySource
        .putIfAbsent(chunk.sourceId, () => <String>{})
        .add(chunk.id);
    terms.forEach((term, tf) {
      _postings.putIfAbsent(term, () => <String, int>{})[chunk.id] = tf;
    });
  }

  /// Drops every chunk of [sourceId] from the index.
  void removeSource(String sourceId) {
    final ids = _chunkIdsBySource.remove(sourceId);
    if (ids == null) return;
    for (final id in ids) {
      _removeChunk(id);
    }
  }

  void clear() {
    _postings.clear();
    _termsByChunk.clear();
    _lengthByChunk.clear();
    _chunkIdsBySource.clear();
    _totalLength = 0;
  }

  void _removeChunk(String chunkId) {
    final terms = _termsByChunk.remove(chunkId);
    if (terms == null) return;
    for (final term in terms.keys) {
      final posting = _postings[term];
      if (posting == null) continue;
      posting.remove(chunkId);
      if (posting.isEmpty) _postings.remove(term);
    }
    _totalLength -= _lengthByChunk.remove(chunkId) ?? 0;
  }

  List<ScoredChunk> search(String query, {int limit = 10}) {
    final terms = TextTokenizer.tokenize(query).toSet();
    if (terms.isEmpty || _lengthByChunk.isEmpty || _totalLength == 0) {
      return const [];
    }

    final n = _lengthByChunk.length;
    final avgLength = _totalLength / n;
    final scores = <String, double>{};
    final matched = <String, List<String>>{};

    for (final term in terms) {
      final posting = _postings[term];
      if (posting == null) continue;

      final df = posting.length;
      final idf = math.log(1 + (n - df + 0.5) / (df + 0.5));

      posting.forEach((chunkId, tf) {
        final length = _lengthByChunk[chunkId] ?? 0;
        final norm = tf + _k1 * (1 - _b + _b * length / avgLength);
        scores[chunkId] =
            (scores[chunkId] ?? 0) + idf * (tf * (_k1 + 1)) / norm;
        (matched[chunkId] ??= <String>[]).add(term);
      });
    }

    final ranked = scores.entries
        .map((e) => ScoredChunk(
              chunkId: e.key,
              score: e.value,
              matchedTerms: matched[e.key] ?? const [],
            ))
        .toList()
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        return byScore != 0 ? byScore : a.chunkId.compareTo(b.chunkId);
      });

    return ranked.take(limit).toList();
  }
}
