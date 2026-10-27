# LifeMaxxing — STATUS

> Living handoff file. Update it at the end of every session or phase.
> Last updated: 2026-10-27 (Phase 5 core delivered but unverified; handover for 5b persistence, 5c importers, 3b calendar gap; see sections 7 and 8)

## 1. If you are a new AI session (Claude, Codex, other) — read this first

1. You have no memory of earlier chats. These files are the source of truth:
   - `STATUS.md` (this file): where we are, decisions, next step
   - `SPEC.md`: what the app must do and must not do
   - `DESIGN_SYSTEM.md`: visual and interaction rules
   - `MASTER_PROMPT.md` (if present): the owner's original long prompt
2. Inspect the repo (`git status`, `git log`, file tree) before proposing anything. Do not assume files exist.
3. **Approval gate:** do not write app code, install dependencies, or scaffold anything until the owner explicitly says to proceed with a named phase. Work one phase at a time and stop at the end of each phase for approval.
4. Do not commit, push, or change remote settings unless asked. Do not overwrite the owner's work.
5. Never claim something was tested or built if you did not run it. Report commands and results honestly.
6. Never put API keys, tokens, `.env` files, or personal calendar exports in the repo.
7. After finishing a session, update section 3 (Progress) and section 6 (Session log) of this file.

## 2. Project snapshot

- **Name:** LifeMaxxing
- **Repo:** https://github.com/j23040579/LifeMaxxing
- **Stack:** Flutter 3.47.8 + Dart 3.13.7. Android, Web (Chrome), Windows desktop verified.
- **State management:** `flutter_riverpod` (2.6.1)
- **Design system:** Graphite (#0E0E10), Steel (#8E96A3), Crimson (#C8102E) accent. Both Dark and Light themes.
- **Owner environment:** Windows laptop. PowerShell commands.
- **Owner profile:** student and athlete in their 20s. Personal-use app, not SaaS.

## 3. Progress

| Phase | Name | State |
|---|---|---|
| 0 | Discovery and design | Done. Agreed direction and handoff files created. |
| 1 | Foundation (themes, tokens, nav shell, runnable app) | **Done.** Project scaffolded, design tokens (colors, typography, spacing, animations), 4-tab shell, WCAG contrast tests passing. |
| 2 | Today and Goals prototype with labelled sample data | **Done.** Today screen with EventTile, WorkBlock (proposed/confirmed), NowLine, DoesntFitGroup, DateStrip, CommandBar, SyncBar. Goals screen with GoalCard, MilestoneRow, GoalDetailScreen. |
| 3 | Google Calendar and Tasks integration, goal-task links, completion log | **Done.** Official Google APIs, least-privilege OAuth scopes, local completion log, `GoogleAccountSheet`, live sync state in `SyncBar` and the scheduler. |
| 4 | Deterministic scheduling engine (with goal weighting) | **Done.** Pure Dart engine, zero overlaps, fixed event protection, buffers, goal weighting, disruption replanning. |
| 5 | Knowledge ingestion and retrieval (summary-only sources included) | **Code written, not yet verified.** Pasted-text import, chunking, BM25 keyword search, provenance, duplicate detection, source removal, Library UI. `flutter analyze` and `flutter test` have NOT been run on it. Storage is in-memory only (resets on restart). No PDF/file import yet. |
| 6 | Gemini orchestration (typed tools, preview, confirm, verify) | Not started |
| 7 | Review and experiments | Not started |
| 8 | Hardening (accessibility, Android, Chrome, security, docs) | Not started |
| 9 | Fitness context (Hevy CSV, MyFitnessPal calories) | Future, only if owner approves |

### Phase 5 contents

- `lib/features/library/domain/models/knowledge_models.dart`: `SourceType`, `KnowledgeSource`, `KnowledgeChunk`, `SearchResult` (citation only includes chapter/page when known).
- `lib/features/library/domain/services/text_chunker.dart`: paragraph chunking; chapter labels only from explicit `#` headings; never produces page numbers.
- `lib/features/library/domain/services/keyword_index.dart`: tokenizer (stop words, simple plural folding) and BM25 index with per-source removal.
- `lib/features/library/domain/services/knowledge_service.dart`: import, duplicate detection (normalized-text fingerprint), search with snippets, removal of source plus index data.
- `lib/features/library/domain/repositories/knowledge_repository.dart` and `data/in_memory_knowledge_repository.dart`.
- `lib/features/library/presentation/`: `library_controller.dart`, `library_screen.dart` (replaces the placeholder), `import_source_sheet.dart`, `passage_sheet.dart`, `provenance_chip.dart`.
- `test/knowledge_test.dart`: chunker, index, and service tests.
- No new dependencies were added (uses existing `flutter_riverpod` and `uuid`).

## 4. Decisions made (do not re-ask)

- App name: **LifeMaxxing**.
- Top-level tabs: **Today, Goals, Library, Review**. The AI assistant is a command bar and sheet inside Today, not a tab.
- Visual direction: machined dark look (graphite, steel, rare crimson) restyled to feel like an Apple/iOS app with smooth spring animations. Both dark and light themes.
- Native Flutter calendar UI backed by the Google Calendar API.
- Google integration: scopes limited to `email`, `calendar.events`, `tasks`; local completion log independent of Google Tasks archiving; `GoogleAccountSheet` opened from `SyncBar`; scheduler uses live Google data when connected and sample data otherwise.
- Secret hygiene: `.env.example` provided, secret patterns in `.gitignore`.
- Library: a summary is a first-class source. Keyword search first, embeddings later as a hybrid. Imported text is untrusted data.
- Owner approved starting Phase 5 on 2026-10-27.
- Owner wants (2026-10-27): the Library must **survive app restarts**, and import must support **PDF, EPUB and plain text files**. Exact packages are still to be confirmed with the owner (see section 8).
- There is **no Calendar tab** by design. The native calendar lives inside **Today** (agenda and day view). A week grid, if wanted, needs separate owner approval (new top-level module).

## 5. Open items and risks to verify later

- **GitHub only has the initial README commit** (checked 2026-10-27). Phases 1 to 4 exist only on the owner's laptop until committed and pushed.
- **Calendar on screen is incomplete** (found by reading the code on 2026-10-27, not by running it):
  - `today_screen.dart` still builds the timeline from `sampleEvents`, so live Google events are used by the scheduler but not drawn.
  - The Day/Agenda toggle changes `todayViewModeProvider`, but nothing reads it to change the layout.
  - There is no UI to create or edit an event, and "Accept" on a proposed work block only shows a snackbar (no `createEvent` call).
  - Live Google sign-in has not been recorded as verified with a real account (tests use mocks). To check: whether `google_sign_in` supports Windows desktop (believed not to), and Android needs a Google Cloud OAuth client with the app's SHA-1.
- **Dependency conflict risk:** `pubspec.lock` pins `analyzer 6.4.1` / `source_gen 1.5.0` / `build_runner 2.4.13`, pulled in by `hive_generator`. `hive`, `hive_flutter` and `hive_generator` appear unused. Remove them before adding `drift_dev`, then run `dart pub get` and `dart pub deps` to confirm.
- Phase 5 code is unverified: run `dart format`, `flutter analyze`, `flutter test` and fix anything they report.
- Owner decision needed: persistence for the Library. SPEC proposes `drift` (SQLite with FTS5; web support to be tested); `hive` is already in `pubspec.yaml` but unused. Verify current versions before choosing.
- Owner decision needed: file import. PDF text extraction (`pdfrx` or Syncfusion community license; check terms) and a file picker are not added yet.
- Google OAuth app in "Testing" mode may expire refresh tokens after about 7 days.
- Gemini free-tier data usage terms: verify before sending private notes in Phase 6.
- MyFitnessPal has no known open public API. Hevy export or API availability is unverified. Check before Phase 9.

## 6. Session log

- 2026-10-26 (Claude): Phase 0 discovery and design. Wrote `STATUS.md`, `SPEC.md`, `DESIGN_SYSTEM.md`.
- 2026-10-27 (Claude and Gemini): Built Phases 1 to 4 (foundation, Today/Goals prototype, scheduling engine, Google Calendar and Tasks). `flutter analyze` 0 issues, `flutter test` 17/17 passing, Windows build verified (as reported in that session).
- 2026-10-27 (Claude): Phase 5 started after owner approval. Checked GitHub (README only). Wrote the Library knowledge core, UI and tests listed in section 3. Could not run Flutter or Dart in that environment, so nothing was analyzed or tested.

## 7. Next step

Suggested order (each step needs the owner's explicit approval by name):

1. **Verify Phase 5** as delivered: `dart format lib test`, `flutter analyze`, `flutter test`, manual check in Chrome. Fix anything reported.
2. **Phase 5b: persistence** (Library survives restarts). See section 8.
3. **Phase 5c: file import** (TXT/MD, PDF, EPUB). See section 8.
4. **Phase 3b: calendar gap fix** (live events drawn on Today, working Agenda mode, real sign-in test on Android, Accept creates the calendar event with preview and confirm). See section 8.
5. Phase 6 (Gemini orchestration) only after the above and explicit approval.

## 8. Handover brief for the next session

### 8.1 Phase 5b: persistence (proposed design, not built)

- Package research done 2026-10-27 (re-check versions before adding): `drift` 2.35.x (needs Dart >= 3.10; project is on 3.13.7), `drift_flutter` for opening the database per platform, `drift_dev` plus `build_runner` for code generation. Drift documents web support but it needs `sqlite3.wasm` and `drift_worker.js` in `web/`, so treat Chrome persistence as a separate check. Android is the first target.
- Keep the existing `KnowledgeRepository` interface and `KnowledgeService`. Add `DriftKnowledgeRepository` with tables `sources` and `chunks` (chunk columns: id, sourceId, position, text, chapter, page). Index on `sources.fingerprint`.
- Simplest safe approach: persist sources and chunks only; on startup load them into the repository's memory cache in an async `init()` (same pattern as `TaskRepository.init` and the `ProviderScope` overrides in `main.dart`), then `KnowledgeService.rebuildIndex()` rebuilds the BM25 index. This keeps the sync repository interface. Move to SQLite FTS5 only if big libraries make startup slow.
- `removeSource` must delete rows and index data. Add a "clear library" option later.
- Tests: use an in-memory drift database; add a restart test (save, create a new repository on the same database, load, search).
- Update the import sheet text, which currently says the Library resets when the app closes.

### 8.2 Phase 5c: file import (proposed design, not built)

- Candidate packages (verify version, maintenance, license and platform support for each before adding): `file_picker` (pick files; on web it needs bytes), `pdfrx` 2.3.x (PDFium based; `PdfDocument.openData`/`openFile`, `PdfPage.loadText()`; Android, Windows and web with WASM assets), `epub_pro` 5.6.x (EPUB parsing in Dart; chapters with titles). Plain `.txt`/`.md` need no package (UTF-8 decode).
- Add a pure-Dart `ParsedDocument { title, author, sections: [ParsedSection { chapter?, page?, text }] }` and one extractor per format behind an interface. `KnowledgeService.importDocument(...)` chunks per section so chapter and page stay attached to the right passage.
- Page numbers are only set for PDFs, and only as the PDF's own page index. EPUB chapters come from the book's table of contents. Never guess either.
- Honest failures: a scanned PDF with no text layer returns "no extractable text" (OCR is out of scope). DRM-protected EPUBs are unsupported. Show a clear message.
- `KnowledgeService.maxImportChars` is 1,000,000, which may be too small for a full book; raise it deliberately (for example 5,000,000) and keep the check.
- Do not commit books or personal documents to the public repo. Tests should generate tiny fixtures in code.
- Tests: TXT decode, chunk page/chapter carry-through, empty/scanned PDF rejection, malformed EPUB rejection.

### 8.3 Phase 3b: calendar gap fix (proposed, not built)

- Draw `plan.fixedEvents` (live Google events when connected, sample data otherwise) in `TodayScreen` instead of `sampleEvents`; check the date-strip selection shows the right day's events (sync currently fetches today plus 7 days).
- Make the Day/Agenda toggle change the layout (Agenda is a simple grouped list).
- Wire "Accept" on a proposed work block to `GoogleCalendarService.createEvent` through a before/after preview and explicit confirm, then update the UI from the server response; link the event to its task locally. Never claim success if the API rejects it.
- Verify real Google sign-in on an Android device or emulator (OAuth client and SHA-1 in Google Cloud). Check platform support for Windows before relying on it.
- Out of scope until separately approved: week grid, drag and drop, event editing UI for recurring events.

### 8.4 Where the calendar fits in the roadmap

- Today's day and agenda view with real events: Phase 3b (small, user-visible).
- Creating or moving events by natural language: Phase 6 (Gemini tools with preview and confirm).
- Week grid and drag and drop: after Phase 8 hardening, as its own approved phase.
