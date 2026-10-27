# LifeMaxxing — STATUS

> Living handoff file. Update it at the end of every session or phase.
> Last updated: 2026-10-27 (Phases 0 to 5b done and verified on Windows; Phase 5c, PDF import only, approved but not started)

## 1. If you are a new AI session (Claude, Codex, other) — read this first

1. You have no memory of earlier chats. These files are the source of truth:
   - `STATUS.md` (this file): where we are, decisions, next step
   - `HANDOVER_PHASE_5C.md`: detailed brief for the next phase (PDF import)
   - `SPEC.md`: what the app must do and must not do
   - `DESIGN_SYSTEM.md`: visual and interaction rules
   - `MASTER_PROMPT.md` (if present): the owner's original long prompt
2. Inspect the repo (`git status`, `git log`, file tree) before proposing anything. Do not assume files exist.
3. **Approval gate:** do not write app code, install dependencies, or scaffold anything until the owner explicitly approves a named phase. Work one phase at a time and stop at the end of each phase for approval. Currently approved and not started: **Phase 5c (PDF only)**.
4. Do not commit, push, or change remote settings unless asked. Do not overwrite the owner's work.
5. Never claim something was tested or built if you did not run it. Report commands and results honestly.
6. Never put API keys, tokens, `.env` files, personal calendar exports, books or other personal documents in the repo.
7. Verify every new package's current version, license, maintenance and platform support before adding it.
8. After finishing a session, update section 3 (Progress), section 6 (Session log) and section 7 (Next step) of this file.

## 2. Project snapshot

- **Name:** LifeMaxxing
- **Repo:** https://github.com/j23040579/LifeMaxxing
- **Stack:** Flutter 3.47.8 + Dart 3.13.7. Windows desktop verified by the owner. Android and Chrome builds are not re-verified since Phase 5b (see section 5).
- **State management:** `flutter_riverpod` (2.6.1)
- **Local storage:** `drift` (SQLite) for the Library, via `drift_flutter`, with `drift_dev` and `build_runner` for code generation. Versions were chosen by `flutter pub add`; check `pubspec.lock` for the exact ones. `hive`, `hive_flutter` and `hive_generator` were removed in Phase 5b.
- **Design system:** Graphite (#0E0E10), Steel (#8E96A3), Crimson (#C8102E) accent. Dark and light themes exist; the app currently launches in dark.
- **Owner environment:** Windows laptop (Git Bash or PowerShell). Project path `C:\apps\LifeMaxxing\LifeMaxxing`.
- **Owner profile:** student and athlete in their 20s. Personal-use app, not SaaS. Prefers detailed code across multiple files with exact paths and run steps.

## 3. Progress

| Phase | Name | State |
|---|---|---|
| 0 | Discovery and design | Done. Agreed direction and handoff files created. |
| 1 | Foundation (themes, tokens, nav shell, runnable app) | **Done.** Design tokens (colors, typography, spacing, animations), 4-tab shell, WCAG contrast tests. |
| 2 | Today and Goals prototype with labelled sample data | **Done.** Today screen (EventTile, WorkBlock proposed/confirmed, NowLine, DoesntFitGroup, DateStrip, CommandBar, SyncBar). Goals screen (GoalCard, MilestoneRow, GoalDetailScreen). |
| 3 | Google Calendar and Tasks integration, goal-task links, completion log | **Done in code, with a known gap (see 3b).** Official Google APIs, least-privilege OAuth scopes, local completion log, `GoogleAccountSheet`, live sync state in `SyncBar` and the scheduler. Tested with mocks only; real sign-in not recorded as verified. |
| 3b | Calendar gap fix | **Not started.** See section 8.1. |
| 4 | Deterministic scheduling engine (with goal weighting) | **Done.** Pure Dart engine, zero overlaps, fixed event protection, buffers, goal weighting, disruption replanning. |
| 5 | Knowledge ingestion and retrieval (summary-only sources included) | **Done (Windows).** Pasted-text import, chunking, BM25 keyword search, provenance, duplicate detection, source removal, Library UI. |
| 5b | Library persistence | **Done (Windows).** Sources and chunks saved with drift. Owner confirmed the Library survives closing and reopening the app. All tests passed after the owner applied the fixes. |
| 5c | PDF import (PDF only) | **Approved, not started.** Brief: `HANDOVER_PHASE_5C.md`. |
| 6 | Gemini orchestration (typed tools, preview, confirm, verify) | Not started |
| 7 | Review and experiments | Not started |
| 8 | Hardening (accessibility, Android, Chrome, security, docs) | Not started |
| 9 | Fitness context (Hevy CSV, MyFitnessPal calories) | Future, only if owner approves |

### Verification record

- Owner ran `dart format`, `flutter analyze`, `flutter test` and `flutter run -d windows` on 2026-10-27. The first run reported 35 of 36 tests passing and 2 info-level lints. The failing test exposed a missing `try/catch` around `saveSource` in `KnowledgeService.importText`. After the fix the owner reported all tests passing (36 expected). A final `flutter analyze` result was not reported after the lint fixes; re-run it to confirm 0 issues.
- Manual persistence check on Windows: import, close app completely, reopen, source still present.
- **Not verified:** Android device or emulator, Chrome, real Google sign-in and live calendar data.

### Library contents (Phases 5 and 5b)

- `lib/features/library/domain/models/knowledge_models.dart`: `SourceType`, `KnowledgeSource`, `KnowledgeChunk` (has `chapter` and `page`), `SearchResult` (citation includes chapter/page only when known).
- `lib/features/library/domain/services/text_chunker.dart`: paragraph chunking; chapter labels only from explicit `#` headings; never produces page numbers.
- `lib/features/library/domain/services/keyword_index.dart`: tokenizer (stop words, simple plural folding) and BM25 index with per-source removal.
- `lib/features/library/domain/services/knowledge_service.dart`: import, duplicate detection (normalized-text fingerprint), search with snippets, removal of source plus index data. A failed save returns `ImportRejected` and changes nothing. `maxImportChars` is currently 1,000,000.
- `lib/features/library/domain/repositories/knowledge_repository.dart`: storage contract.
- `lib/features/library/data/in_memory_knowledge_repository.dart`: in-memory implementation (also used as the read cache and as the fallback).
- `lib/features/library/data/drift_knowledge_repository.dart`: persistent implementation. Loads everything into a cache at startup (`init()`); every write goes to the database first, then the cache.
- `lib/core/database/app_database.dart` (+ generated `app_database.g.dart`, not git-ignored so a fresh clone builds without running the generator): tables `LibrarySources` and `LibraryChunks` (columns include `chapter` and `page`), schema version 1, foreign keys on.
- `lib/main.dart`: opens the database at startup. If it cannot open, the app starts with an in-memory Library and the import sheet says so (`libraryStorageModeProvider`).
- `lib/features/library/presentation/`: `library_controller.dart`, `library_screen.dart`, `import_source_sheet.dart`, `passage_sheet.dart`, `provenance_chip.dart`.
- Tests: `test/knowledge_test.dart` and `test/knowledge_persistence_test.dart` (restart simulation, duplicates, removal and cascade, failed save).

## 4. Decisions made (do not re-ask)

- App name: **LifeMaxxing**.
- Top-level tabs: **Today, Goals, Library, Review**. The AI assistant is a command bar and sheet inside Today, not a tab.
- Visual direction: machined dark look (graphite, steel, rare crimson) restyled to feel like an Apple/iOS app with smooth spring animations. Dark and light themes.
- Native Flutter calendar UI backed by the Google Calendar API. There is **no Calendar tab** by design; the calendar lives inside **Today** (agenda and day view). A week grid needs separate owner approval.
- Google integration: scopes limited to `email`, `calendar.events`, `tasks`; local completion log independent of Google Tasks archiving; `GoogleAccountSheet` opened from `SyncBar`; scheduler uses live Google data when connected and sample data otherwise.
- Secret hygiene: `.env.example` provided, secret patterns in `.gitignore`.
- Library: a summary is a first-class source. Keyword search first, embeddings later as a hybrid. Imported text is untrusted data. Page numbers and chapters are never guessed.
- **Library persistence uses drift (SQLite).** Hive was removed. If the database cannot open, the app falls back to memory-only and says so; it never pretends to save.
- **File import scope (2026-10-27): PDF only.** No EPUB and no TXT/MD file import for now. Pasted text import already exists. Owner approved Phase 5c on this basis.
- OCR is out of scope: scanned PDFs are rejected with a clear message.

## 5. Open items and risks to verify later

- **GitHub only has the initial README commit** (as last checked on 2026-10-27). Phases 1 to 5b exist only on the owner's laptop until committed and pushed. Do not commit or push unless the owner asks.
- **Calendar on screen is incomplete** (found by reading the code, not by running it):
  - `today_screen.dart` still builds the timeline from `sampleEvents`, so live Google events are used by the scheduler but not drawn.
  - The Day/Agenda toggle changes `todayViewModeProvider`, but nothing reads it to change the layout.
  - There is no UI to create or edit an event, and "Accept" on a proposed work block only shows a snackbar (no `createEvent` call).
  - Live Google sign-in has not been verified with a real account (tests use mocks). To check: whether `google_sign_in` supports Windows desktop (believed not to), and Android needs a Google Cloud OAuth client with the app's SHA-1.
- **Android not re-verified** after adding drift. Run on an emulator or device and confirm Library persistence there. Android Gradle setup is very new (AGP 9.1.0 in `android/settings.gradle.kts`, with `android.newDsl=false` and `android.builtInKotlin=false` in `android/gradle.properties`); check new plugins (`pdfrx`, `file_picker`) build before writing much UI.
- **Chrome persistence unverified.** drift on web needs `sqlite3.wasm` and `drift_worker.js` in `web/`, with versions matching the drift release in `pubspec.lock`. Without them the app should fall back to memory-only (written, not observed).
- **Library startup cost:** all sources and chunks load into memory and the BM25 index is rebuilt at every launch. Fine for summaries and notes; revisit (SQLite FTS5) if full books make startup slow.
- **Size limit:** `KnowledgeService.maxImportChars` (1,000,000) is likely too small for full books; Phase 5c plans to raise it deliberately.
- Google OAuth app in "Testing" mode may expire refresh tokens after about 7 days.
- Gemini free-tier data usage terms: verify before sending private notes in Phase 6.
- MyFitnessPal has no known open public API. Hevy export or API availability is unverified. Check before Phase 9.

## 6. Session log

- 2026-10-26 (Claude): Phase 0 discovery and design. Wrote `STATUS.md`, `SPEC.md`, `DESIGN_SYSTEM.md`.
- 2026-10-27 (Claude and Gemini): Built Phases 1 to 4 (foundation, Today/Goals prototype, scheduling engine, Google Calendar and Tasks). `flutter analyze` 0 issues, `flutter test` 17/17 passing, Windows build verified (as reported in that session).
- 2026-10-27 (Claude): Phase 5 written (Library core, UI, tests). Could not run Flutter in that environment.
- 2026-10-27 (Claude and owner): Phase 5 verified by the owner. Phase 5b written (drift tables, `DriftKnowledgeRepository`, startup wiring, persistence tests). Owner ran format, analyze, tests and the app on Windows; one test failure revealed a missing `try/catch` in `importText`, fixed; all tests then passed and restart persistence was confirmed by hand. Phase 5c scoped to PDF only and `HANDOVER_PHASE_5C.md` written.

## 7. Next step

Each step needs the owner's explicit approval by name unless noted.

1. **Phase 5c: PDF import (approved).** Follow `HANDOVER_PHASE_5C.md`. Start by confirming the repo state, running `flutter analyze` and `flutter test`, and checking `pdfrx` and `file_picker` versions, licenses and the Android build.
2. **Phase 3b: calendar gap fix** (live events drawn on Today, working Agenda mode, real sign-in test on Android, Accept creates the calendar event with preview and confirm). See section 8.1.
3. Commit and push to GitHub when the owner asks, so the work is backed up.
4. Phase 6 (Gemini orchestration) only after the above and explicit approval.

## 8. Handover notes

### 8.1 Phase 3b: calendar gap fix (proposed, not built)

- Draw `plan.fixedEvents` (live Google events when connected, sample data otherwise) in `TodayScreen` instead of `sampleEvents`; check the date-strip selection shows the right day's events (sync currently fetches today plus 7 days).
- Make the Day/Agenda toggle change the layout (Agenda is a simple grouped list).
- Wire "Accept" on a proposed work block to `GoogleCalendarService.createEvent` through a before/after preview and explicit confirm, then update the UI from the server response; link the event to its task locally. Never claim success if the API rejects it.
- Verify real Google sign-in on an Android device or emulator (OAuth client and SHA-1 in Google Cloud). Check platform support for Windows before relying on it.
- Out of scope until separately approved: week grid, drag and drop, event editing UI for recurring events.

### 8.2 Where the calendar fits in the roadmap

- Today's day and agenda view with real events: Phase 3b (small, user-visible).
- Creating or moving events by natural language: Phase 6 (Gemini tools with preview and confirm).
- Week grid and drag and drop: after Phase 8 hardening, as its own approved phase.

### 8.3 Phase 5c

See `HANDOVER_PHASE_5C.md`. Summary: PDF only; one chunk set per page so page numbers are exact; no chapters guessed; scanned, encrypted and corrupt PDFs rejected with clear messages; raise the import size limit deliberately; no books committed to the repo.
