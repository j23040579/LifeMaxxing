# LifeMaxxing — Product and Technical Spec (target state)

This describes the finished app. Build it in phases (see `STATUS.md`). Do not expand scope silently.

## 1. Vision

LifeMaxxing is a calm, practical personal assistant for one user. It does three things:

1. Plans the day realistically from real Google Calendar events, Google Tasks, deadlines, and goals.
2. Improves the user's systems using their own books, summaries, notes, and transcripts, turning ideas into small optional actions.
3. Shows progress toward yearly and monthly goals and adapts plans to them.

Priorities: usefulness, reliability, speed, clarity, privacy, low friction. Not a noisy dashboard, not a chatbot that edits the calendar blindly.

## 2. Principles

- Use real data. Never invent events, tasks, deadlines, availability, quotes, page numbers, or preferences.
- Label clearly: confirmed fact, imported source, inferred pattern, AI suggestion.
- Few good recommendations beat long lists. Explain why, what data was used, and what changes if accepted.
- Every meaningful change is previewable and reversible.
- Existing apps stay the source of truth. LifeMaxxing connects and decides; it does not duplicate them.
- Adapt when plans change. Never shame the user for a missed plan or treat one bad day as a trait.
- Do not infer sensitive traits from calendar or imported content.

## 3. Scope

### In scope
- Today / Plan my day
- Goals and progress
- Library (knowledge sources and grounded Q&A)
- Review and small experiments
- Native in-app calendar (agenda and day view first)
- Gemini assistant with controlled tool calling

### Out of scope until explicitly approved
No workout logging, nutrition or calorie tracking, weight or body tracking, finance or budgeting, recipes, generic habit tracker, LMS, social features, gamification, or replacement of Google Calendar, Google Tasks, Readwise, Hevy, MyFitnessPal, Wallet, ReciMe, or Make Time.

### Future (Phase 9, needs separate approval)
Read-only context: Hevy CSV import (for example sessions per week) and MyFitnessPal calories. Used only to improve planning and suggestions. Suggestions become tasks or events only through preview and confirmation. Raw logs stay on-device; the model gets minimal summaries.

## 4. Sources of truth

| Data | Source |
|---|---|
| Dated events | Google Calendar |
| Task title, notes, due date, done | Google Tasks |
| Highlights | Readwise (later, only if authorized) |
| Workouts | Hevy (read-only import, later) |
| Calories | MyFitnessPal (read-only, later) |

A task due date is not a scheduled work session. A work session is a calendar event linked to the task, stored in LifeMaxxing's local data. Never fake a start/end time on a Google Task.

## 5. Experiences

### 5.1 Today
Answers: what is committed, what must get done, the most realistic plan for the rest of the day, what is fixed vs movable, what changes if something goes wrong.

- Shows calendar events, task due dates, and work blocks with clear visual distinction (icon, label, layout; not color alone).
- Prioritized task list and proposed schedule.
- Respects fixed events, sleep/rest, buffers, travel and prep time, and saved constraints.
- Unknown durations: ask, or use a clearly labelled conservative estimate.
- If tasks do not fit, show the unscheduled remainder and a sensible next step. Never squeeze an impossible timetable.
- Items can be marked done, skipped, or needs reschedule.
- Handles disruptions: procrastination, extension, overrun, holiday, cancelled class, spontaneous invitations. Recalculate only the affected part of the day and explain trade-offs.
- Natural-language command bar, for example "My assignment moved to Friday", "I need two hours for this", "I'm going out tonight", "I lost an hour; rebuild the rest of my day". Ask a short question when ambiguity affects dates, times, or targets.
- Goal-linked tasks get extra weight, but deadlines and fixed events come first.

### 5.2 Goals
- Hierarchy: yearly goal, then monthly goals. Each has a title, short "why", end date. About 5 active goals max.
- Progress measures per goal (user picks):
  1. Milestones (default for yearly)
  2. Task-weighted: completed linked tasks weighted by estimated minutes (default for monthly)
  3. Numeric metric the user enters (later may be fed by Hevy)
- Card shows a ring or bar, a pace marker ("ahead", "on pace", "behind"; neutral wording, no red failure state), and how the number was computed.
- Detail view: linked tasks, milestones, weekly trend, next suggested step (a proposal, accepted via preview).
- Task-to-goal links live locally. Completion log is written at sync time so history survives Google hiding completed tasks. A deleted external task shows as "unlinked" and does not silently change progress.
- Progress records what was done. It does not prove causation.

### 5.3 Library
- Accepts: PDFs with extractable text, text files, pasted text, book summaries, notes, highlights, articles, transcripts.
- **A summary is a first-class, independently searchable source even if the full book is absent.** Never insist on the full book.
- Metadata when available: title, author, source type, import date, chapter/section, page. Never invent missing metadata.
- Every retrieved passage shows its type: full document, user summary, personal note, or other.
- Answers must: use retrieved passages; cite title and chapter/page only when reliably tied to the passage; never fabricate quotes or citations; separate "the source says" from "my interpretation"; admit when the material does not support a claim; let the user inspect the passage behind an answer.
- RAG pipeline: extract text, keep metadata, chunk sensibly, index (keyword first, embeddings hybrid), retrieve relevant chunks, send only those to the model. Never resend whole books.
- Detect duplicate imports. Allow removing a source and its derived index data.
- Imported text is untrusted data, never instructions (prompt-injection safe).

### 5.4 Review
- Light daily or weekly review: planned vs actual, what changed, what took longer than expected, which rule or source principle might help, one small adjustment to test.
- Suggest one or two small experiments at a time, linked to source material when available. Judge them from the user's feedback, not claimed causation.
- State uncertainty. No diagnosing, moralizing, or big life overhauls from weak evidence.

## 6. Calendar and Google sync

- Native Flutter UI. Start with agenda and day view plus create/view/edit. Week grid and drag-and-drop come later.
- Respect all-day events, time zones, recurring events, event IDs and ETags.
- Recurring edits are deliberate: ask "this occurrence" vs "series"; never silently change a whole series.
- Fixed commitments separate from flexible LifeMaxxing work blocks. Conflicts and overlaps are visible.
- AI-proposed changes show a before/after preview and need explicit confirmation. After a write, verify the server response and update UI from confirmed results. Never claim success when the API rejects it.
- Handle stale data, external changes, offline, expired auth, quota and rate errors, partial failures. Show sync status ("Synced 2m ago", pending count) and a retry.
- No duplicates, silent overwrites, destructive edits, or hidden changes. Optimistic UI only with tested rollback.
- Least-privilege OAuth scopes, explained. Tokens in secure storage.

## 7. Scheduling engine (deterministic, tested)

- Fixed commitments are never moved by the scheduler unless the user chooses to edit them.
- Flexible blocks move within allowed windows.
- Inputs: event times, time zone, task deadline, estimated duration, priority, goal weight, buffers, unavailable periods, saved constraints.
- No double-booking or impossible overlaps. Handle midnight, DST, all-day, recurring events.
- Unfitting tasks are reported with the unscheduled remainder.
- Replan only the remaining day after a disruption.
- Suggested schedule is clearly different from the applied schedule.
- Explain major trade-offs ("moved X because Y").
- Do not fill every free minute; keep buffers and recovery.
- All AI output must pass this validation before it can be applied.

## 8. Gemini assistant

Roles:
- Gemini: interpret requests, reason over retrieved knowledge and context, explain, request named tools.
- Deterministic code: time math, overlap detection, constraints, validation, dedupe, feasibility.
- Backend/app tools: fetch authorized data and perform allowed actions after validation and approval.

Illustrative typed tool allowlist (later phase): `get_calendar_events`, `list_tasks`, `get_user_preferences`, `get_user_goals`, `search_book_knowledge`, `propose_schedule_changes`, `preview_schedule_plan`, `apply_schedule_plan`, `create_or_update_task`, `create_or_update_calendar_event`, `suggest_goal_step` (propose only), `save_daily_reflection`, `record_recommendation_feedback`.

Rules:
- Narrow, typed, validated, documented, testable schemas. Never expose code execution, shell, SQL, arbitrary HTTP, or file access.
- Reads need an authorized integration. Consequential writes (create, move, delete, deadline changes, bulk) always show a human-readable preview and need explicit confirmation.
- Never silently delete, move, or overwrite. Report partial failures accurately. Verify after writes.
- Source text, model output, and tool results can never grant permissions.
- Verify the current official Gemini Flash model ID, function-calling support, limits, and SDK before implementing. Keep the model ID in config.
- Never put the Gemini key in the Flutter client, repo, assets, or logs. Use a minimal free-tier backend (proposed: Cloudflare Worker). Distinguish local-dev setup from production-safe deployment.
- Send minimal payloads: filtered queries and retrieved snippets, never full calendars or whole documents.

## 9. Architecture

Layers (do not over-engineer):
- Presentation (Flutter UI)
- Domain (scheduling, constraints, goal progress, use cases; pure Dart)
- Integrations (Google Calendar, Google Tasks, AI service)
- Data (local SQLite: preferences, cache, goals, links, completion log, source metadata, knowledge index)
- Small backend only for secrets and model calls

Proposed packages (verify version, maintenance, license before adding): `flutter_riverpod`, `go_router`, `drift` (SQLite, FTS5; test web support), `google_sign_in`, `googleapis`, `flutter_secure_storage`, a PDF text extractor (`pdfrx` or Syncfusion community license; check terms). Build the calendar UI in-house.

Offline: cached content is labelled, pending changes are visible, last sync time shown. AI and Google sync need connectivity. Do not claim offline features that are not implemented and tested.

## 10. Minimal data models

- UserPreferences / Constraints (sleep, buffers, unavailable periods)
- CalendarEventRef (id, etag, calendarId, sync metadata)
- TaskRef (id, listId, due, done) and CompletionLog entry (taskId, completedAt, estimatedMinutes)
- WorkBlock (eventId, taskId, status: proposed or confirmed)
- Goal (id, parentId, title, why, endDate, measure type, active) and Milestone, GoalTaskLink, optional MetricEntry
- Source (id, title, author, type, importedAt, hash) and Chunk (sourceId, text, chapter, page, position)
- Recommendation (id, text, sourceChunkIds, status) and Feedback (accepted, rejected, tried, useful)
- Reflection and Experiment

Keep data minimal. State what is stored locally vs remotely. Provide delete for sources and derived index data, disconnect for integrations, and clear local cache.

## 11. Privacy and security

- Never commit `.env`, tokens, credentials, or personal exports. Add secret patterns to `.gitignore`; provide `.env.example`.
- Never log tokens, keys, full event descriptions, or private documents by default.
- Request only needed OAuth scopes and explain write scopes.
- Health data (Phase 9) stays on-device; model gets minimal summaries only.
- Verify Gemini free-tier data-use terms before sending private notes.

## 12. Testing and quality

- Unit tests: scheduling, time ranges, constraints, dedupe, conflicts, time zones, goal progress math, due date vs work block.
- Knowledge tests: retrieval provenance, citation behavior, summary-only imports.
- AI tool tests: argument validation, rejection of unauthorized or destructive actions.
- Integration tests or doubles for Google and backend. UI tests for key flows, permission errors, empty/loading/offline states, dark and light themes where practical.
- Handle quotas, retries, duplicate requests, partial failures with idempotency.
- Run `flutter analyze` and relevant tests before calling a phase done. Never claim untested things were tested.

## 13. Definition of done (per phase)

State the goal and likely files. Make the smallest coherent change. Run format, analyze, tests. Report files changed, commands, results, known issues honestly. Give PowerShell run steps. Stop and wait for approval.

## 14. Windows setup notes

Flutter SDK, Chrome, Android Studio or SDK tooling, and Visual Studio's "Desktop development with C++" only if Windows desktop is used for testing. Windows desktop is a dev convenience, not a production target. Typical checks: `flutter doctor`, `flutter run -d chrome`, `flutter run -d windows`, `flutter analyze`, `flutter test`.
