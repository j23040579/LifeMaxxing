import '../models/knowledge_models.dart';

/// Storage contract for the Library. Phase 5 ships an in-memory
/// implementation; a persistent one can replace it without touching callers.
abstract class KnowledgeRepository {
  /// Newest first.
  List<KnowledgeSource> getSources();
  KnowledgeSource? getSource(String id);
  List<KnowledgeChunk> getChunksForSource(String sourceId);
  KnowledgeChunk? getChunk(String chunkId);
  KnowledgeSource? findByFingerprint(String fingerprint);

  Future<void> saveSource(KnowledgeSource source, List<KnowledgeChunk> chunks);

  /// Removes the source and all of its chunks.
  Future<void> removeSource(String id);
}
