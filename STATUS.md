# LifeMaxxing — STATUS

> Living handoff file. Update it at the end of every session or phase.
> Last updated: 2026-10-27 (Phase 5 code delivered, NOT yet analyzed or tested; see section 3)

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

## 5. Open items and risks to verify later

- **GitHub only has the initial README commit** (checked 2026-10-27). Phases 1 to 4 exist only on the owner's laptop until committed and pushed.
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

1. Owner runs `dart format lib test`, `flutter analyze`, `flutter test` and reports results; fix any issues.
2. Owner decides persistence (drift vs hive vs other) and whether to add PDF/text-file import.
3. After Phase 5 is verified, wait for approval of Phase 6 (Gemini orchestration).
