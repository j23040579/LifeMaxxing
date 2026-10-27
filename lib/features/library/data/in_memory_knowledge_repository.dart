import '../domain/models/knowledge_models.dart';
import '../domain/repositories/knowledge_repository.dart';

/// Holds the Library in memory. Nothing survives an app restart yet.
class InMemoryKnowledgeRepository implements KnowledgeRepository {
  final Map<String, KnowledgeSource> _sources = {};
  final Map<String, List<KnowledgeChunk>> _chunksBySource = {};
  final Map<String, KnowledgeChunk> _chunksById = {};

  @override
  List<KnowledgeSource> getSources() {
    final list = _sources.values.toList();
    list.sort((a, b) => b.importedAt.compareTo(a.importedAt));
    return list;
  }

  @override
  KnowledgeSource? getSource(String id) => _sources[id];

  @override
  List<KnowledgeChunk> getChunksForSource(String sourceId) =>
      List.unmodifiable(_chunksBySource[sourceId] ?? const <KnowledgeChunk>[]);

  @override
  KnowledgeChunk? getChunk(String chunkId) => _chunksById[chunkId];

  @override
  KnowledgeSource? findByFingerprint(String fingerprint) {
    for (final source in _sources.values) {
      if (source.fingerprint == fingerprint) return source;
    }
    return null;
  }

  @override
  Future<void> saveSource(
    KnowledgeSource source,
    List<KnowledgeChunk> chunks,
  ) async {
    _sources[source.id] = source;
    _chunksBySource[source.id] = List.of(chunks);
    for (final chunk in chunks) {
      _chunksById[chunk.id] = chunk;
    }
  }

  @override
  Future<void> removeSource(String id) async {
    _sources.remove(id);
    final chunks = _chunksBySource.remove(id) ?? const <KnowledgeChunk>[];
    for (final chunk in chunks) {
      _chunksById.remove(chunk.id);
    }
  }
}
