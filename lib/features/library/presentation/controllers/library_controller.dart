import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_knowledge_repository.dart';
import '../../domain/models/knowledge_models.dart';
import '../../domain/repositories/knowledge_repository.dart';
import '../../domain/services/knowledge_service.dart';

/// Where the Library is kept right now. Shown to the user so nothing is
/// silently lost.
enum LibraryStorageMode {
  /// Saved in the on-device database. Survives restarts.
  device,

  /// Kept in memory only (database could not be opened). Resets on restart.
  memoryOnly,
}

/// Overridden in `main.dart` with the real value. The default keeps widget
/// tests working without a database.
final libraryStorageModeProvider = Provider<LibraryStorageMode>((ref) {
  return LibraryStorageMode.memoryOnly;
});

/// Overridden in `main.dart` with `DriftKnowledgeRepository` when the
/// database opens. The default is in-memory.
final knowledgeRepositoryProvider = Provider<KnowledgeRepository>((ref) {
  return InMemoryKnowledgeRepository();
});

final knowledgeServiceProvider = Provider<KnowledgeService>((ref) {
  return KnowledgeService(repository: ref.watch(knowledgeRepositoryProvider));
});

class LibraryState {
  const LibraryState({
    this.sources = const [],
    this.query = '',
    this.results = const [],
  });

  final List<KnowledgeSource> sources;
  final String query;
  final List<SearchResult> results;
}

final libraryControllerProvider =
    StateNotifierProvider<LibraryController, LibraryState>((ref) {
  return LibraryController(ref.watch(knowledgeServiceProvider));
});

class LibraryController extends StateNotifier<LibraryState> {
  LibraryController(this._service) : super(const LibraryState()) {
    _refresh();
  }

  final KnowledgeService _service;

  void _refresh() {
    final query = state.query;
    state = LibraryState(
      sources: _service.sources,
      query: query,
      results: _service.search(query),
    );
  }

  Future<ImportOutcome> importText({
    required String title,
    required SourceType type,
    required String text,
    String? author,
  }) async {
    final outcome = await _service.importText(
      title: title,
      type: type,
      text: text,
      author: author,
    );
    _refresh();
    return outcome;
  }

  Future<void> removeSource(String id) async {
    await _service.removeSource(id);
    _refresh();
  }

  void search(String query) {
    state = LibraryState(
      sources: state.sources,
      query: query,
      results: _service.search(query),
    );
  }
}
