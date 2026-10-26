# LifeMaxxing — STATUS

> Living handoff file. Update it at the end of every session or phase.
> Last updated: 2026-10-27 (Phase 3 complete: Google Calendar & Google Tasks integration, least-privilege auth, local completion log, 17/17 tests passing)

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
| 3 | Google Calendar and Tasks integration, goal-task links, completion log | **Done.** Official Google APIs (`googleapis`, `google_sign_in`, `extension_google_sign_in_as_googleapis_auth`, `flutter_secure_storage`), least-privilege OAuth scopes, local completion log (`LocalCompletionLogRepository`), interactive `GoogleAccountSheet`, live sync state in `SyncBar` & `DeterministicScheduler`. Unit tests passing. |
| 4 | Deterministic scheduling engine (with goal weighting) | **Done.** Pure Dart scheduling engine (`DeterministicScheduler`, `TimeRange`, `UserConstraints`, `SchedulePlan`), zero overlaps, fixed event protection, buffer handling, goal weighting, mid-day disruption replanning, 14/14 tests passing. Connected to Today screen and CommandBar. |
| 5 | Knowledge ingestion and retrieval (summary-only sources included) | Not started |
| 6 | Gemini orchestration (typed tools, preview, confirm, verify) | Not started |
| 7 | Review and experiments | Not started |
| 8 | Hardening (accessibility, Android, Chrome, security, docs) | Not started |
| 9 | Fitness context (Hevy CSV, MyFitnessPal calories) | Future, only if owner approves |

## 4. Decisions made (do not re-ask)

- App name: **LifeMaxxing**.
- Top-level tabs: **Today, Goals, Library, Review**. The AI assistant is a command bar and sheet inside Today, not a tab.
- Visual direction: machined dark look (graphite, steel, rare crimson) restyled to feel like an Apple/iOS app with smooth spring animations. Both dark and light themes.
- Native Flutter calendar UI backed by the Google Calendar API.
- Google Integration architecture:
  - Scopes strictly limited to `email`, `calendar.events`, `tasks` (no full Drive or Gmail access).
  - Local completion log (`LocalCompletionLogRepository`) records task completion times and estimated minutes independently of Google Tasks archiving.
  - Interactive bottom sheet `GoogleAccountSheet` accessible by tapping `SyncBar` on the Today screen.
  - `scheduling_controller.dart` dynamically consumes Google Calendar & Tasks when connected, falling back seamlessly to offline sample data when disconnected.
- Secret hygiene: `.env.example` provided, secret patterns (`.env`, `*.pem`, `*.jks`, `*.ics`, `*.csv`) in `.gitignore`.
- Automated test suite (17/17 tests passing).

## 5. Open items and risks to verify later

- Google OAuth app in "Testing" mode may expire refresh tokens after about 7 days. Plan around it.
- Gemini free-tier data usage terms: verify before sending private notes in Phase 6.
- MyFitnessPal has no known open public API. Hevy export or API availability is unverified. Check before Phase 9.

## 6. Session log

- 2026-10-26 (Claude): Phase 0 discovery and design. Wrote `STATUS.md`, `SPEC.md`, `DESIGN_SYSTEM.md`.
- 2026-10-27 (Claude & Gemini):
  - Verified Flutter environment (all green: Flutter 3.47.8, Dart 3.13.7, Android SDK 36.0.0, Chrome, VS 2026).
  - Built Phase 1 (Foundation): scaffolded project, implemented AppColors (dark & light), AppTypography, AppSpacing, AppTheme, AppAnimations, MainShellScreen with 4-tab AppBottomBar.
  - Built Phase 2 (Today & Goals Prototype): TodayScreen, DateStrip, CommandBar, EventTile, WorkBlock, NowLine, DoesntFitGroup, SyncBar, GoalCard, MilestoneRow, GoalsScreen, GoalDetailScreen, LibraryScreen, ReviewScreen.
  - Built Phase 4 (Deterministic Scheduling Engine):
    - `TimeRange` with intersection, subtraction, boundary checking, and buffer expansion.
    - `UserConstraints` (waking hours, bedtime, buffers, break durations).
    - `SchedulableItem` (`SchedulableEvent`, `SchedulableTask` with urgency/goal score, `ScheduledBlock`).
    - `SchedulePlan` with deterministic validity checking (`isValid`).
    - `DeterministicScheduler` with zero-overlap greedy slot placement, overflow detection, and mid-day disruption replanning.
    - Integrated engine with Riverpod (`schedulePlanProvider`) and wired to `TodayScreen` and natural-language `CommandBar`.
  - Built Phase 3 (Google Calendar & Tasks Integration):
    - Added `google_sign_in`, `googleapis`, `extension_google_sign_in_as_googleapis_auth`, `flutter_secure_storage`, `http`.
    - Implemented `GoogleAccountInfo`, `CalendarEventRef`, `TaskRef`, `CompletionLogEntry`.
    - Implemented `LocalCompletionLogRepository` to ensure goal progress survives external task deletion.
    - Implemented `GoogleAuthServiceImpl`, `GoogleCalendarServiceImpl`, `GoogleTasksServiceImpl`.
    - Implemented `GoogleSyncController` with optimistic updates, sync states, and error handling.
    - Created `GoogleAccountSheet` UI modal with permissions explanation and manual sync/disconnect controls.
    - Upgraded `SyncBar` to reflect live sync status and open account sheet on tap.
    - Connected `schedulePlanProvider` to Google Calendar events & Tasks with seamless sample fallback.
  - Added unit test suite `test/google_sync_test.dart` (3 tests).
  - Verified `flutter analyze` (0 issues).
  - Verified `flutter test` (17/17 tests passing).
  - Verified Windows build (`flutter build windows`).

## 7. Next step

Awaiting user approval to proceed to:
- **Phase 5**: Knowledge Ingestion and Retrieval (Library RAG pipeline for book summaries, notes, text chunking, keyword/embedding indexing, and provenance chips).
