import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/models/knowledge_models.dart';
import '../domain/repositories/knowledge_repository.dart';
import 'in_memory_knowledge_repository.dart';

/// Saves the Library to the on-device database.
///
/// Reads are served from an in-memory cache that [init] fills at startup, so
/// the synchronous [KnowledgeRepository] interface stays unchanged. Every
/// write goes to the database first and only updates the cache once the
/// database confirmed it. If the database throws, the cache is untouched and
/// the screen never shows something that was not saved.
class DriftKnowledgeRepository implements KnowledgeRepository {
  DriftKnowledgeRepository(this._db);

  final AppDatabase _db;
  final InMemoryKnowledgeRepository _cache = InMemoryKnowledgeRepository();

  /// Loads every saved source and its chunks into the cache. Call once at
  /// startup, before building `KnowledgeService` (which rebuilds the search
  /// index from this cache).
  Future<void> init() async {
    final chunkRows = await (_db.select(_db.libraryChunks)
          ..orderBy([(c) => OrderingTerm.asc(c.position)]))
        .get();

    final chunksBySource = <String, List<KnowledgeChunk>>{};
    for (final row in chunkRows) {
      (chunksBySource[row.sourceId] ??= <KnowledgeChunk>[]).add(_toChunk(row));
    }

    final sourceRows = await _db.select(_db.librarySources).get();
    for (final row in sourceRows) {
      await _cache.saveSource(
        _toSource(row),
        chunksBySource[row.id] ?? const <KnowledgeChunk>[],
      );
    }
  }

  // ── Reads (from cache) ──────────────────────────────────────────────────

  @override
  List<KnowledgeSource> getSources() => _cache.getSources();

  @override
  KnowledgeSource? getSource(String id) => _cache.getSource(id);

  @override
  List<KnowledgeChunk> getChunksForSource(String sourceId) =>
      _cache.getChunksForSource(sourceId);

  @override
  KnowledgeChunk? getChunk(String chunkId) => _cache.getChunk(chunkId);

  @override
  KnowledgeSource? findByFingerprint(String fingerprint) =>
      _cache.findByFingerprint(fingerprint);

  // ── Writes (database first, then cache) ─────────────────────────────────

  @override
  Future<void> saveSource(
    KnowledgeSource source,
    List<KnowledgeChunk> chunks,
  ) async {
    await _db.transaction(() async {
      await _db.into(_db.librarySources).insertOnConflictUpdate(
            LibrarySourcesCompanion.insert(
              id: source.id,
              title: source.title,
              author: Value(source.author),
              type: source.type.name,
              importedAt: source.importedAt,
              fingerprint: source.fingerprint,
              chunkCount: source.chunkCount,
            ),
          );

      // Replace any older chunks for this id so a re-save never duplicates.
      await (_db.delete(_db.libraryChunks)
            ..where((c) => c.sourceId.equals(source.id)))
          .go();

      await _db.batch((batch) {
        batch.insertAll(_db.libraryChunks, [
          for (final chunk in chunks)
            LibraryChunksCompanion.insert(
              id: chunk.id,
              sourceId: chunk.sourceId,
              position: chunk.position,
              content: chunk.text,
              chapter: Value(chunk.chapter),
              page: Value(chunk.page),
            ),
        ]);
      });
    });

    await _cache.saveSource(source, chunks);
  }

  @override
  Future<void> removeSource(String id) async {
    await _db.transaction(() async {
      // Chunks first, explicitly. The foreign-key cascade is a second guard.
      await (_db.delete(_db.libraryChunks)..where((c) => c.sourceId.equals(id)))
          .go();
      await (_db.delete(_db.librarySources)..where((s) => s.id.equals(id)))
          .go();
    });

    await _cache.removeSource(id);
  }

  // ── Row → model mapping ─────────────────────────────────────────────────

  KnowledgeSource _toSource(SourceRow row) {
    return KnowledgeSource(
      id: row.id,
      title: row.title,
      author: row.author,
      type: SourceType.values.asNameMap()[row.type] ?? SourceType.other,
      importedAt: row.importedAt,
      fingerprint: row.fingerprint,
      chunkCount: row.chunkCount,
    );
  }

  KnowledgeChunk _toChunk(ChunkRow row) {
    return KnowledgeChunk(
      id: row.id,
      sourceId: row.sourceId,
      position: row.position,
      text: row.content,
      chapter: row.chapter,
      page: row.page,
    );
  }
}
