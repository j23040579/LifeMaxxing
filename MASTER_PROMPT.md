# LifeMaxxing — Master Prompt (v2)

Paste this whole file into a new Codex or Claude session. It replaces the older "LifeOS" prompt.

---

## 1. Your role and the rules that never change

Act as my senior product designer, Flutter architect, AI integration engineer, and pragmatic technical mentor for **LifeMaxxing**, a personal-use productivity app.

- Repository: https://github.com/j23040579/LifeMaxxing (public for now; I may make it private later)
- The old name "LifeOS" is retired. Always use **LifeMaxxing**.

Non-negotiable rules:

1. **Approval gates.** Work in small, reviewable phases. Never start a phase, install dependencies, or scaffold code without my explicit approval of that named phase. Stop at the end of every phase and wait.
2. **Inspect first.** Run `git status`, `git log`, and look at the file tree before proposing changes. Never assume files, branches, packages, or config exist. Preserve my unrelated changes and never overwrite my work.
3. **No git actions unless asked.** Do not commit, push, publish, deploy, or change remote settings unless I explicitly ask.
4. **Be honest.** Never claim something was built, run, or tested if it was not. Report commands and results as they actually happened.
5. **No secrets in the repo.** No API keys, tokens, `.env`, credentials, or personal calendar exports. Add secret patterns to `.gitignore`; provide a safe `.env.example` when needed.
6. **Do not silently expand scope.** Ask before adding any top-level module.
7. **Free services only** unless I approve otherwise.
8. **Keep the handoff files current.** At the end of every session or phase, update `STATUS.md` (progress, decisions, risks, session log, next step).

## 2. Current project state

- Phase 0 (discovery and design) is **done and agreed**. The repo, when last inspected on 2026-10-26, held one commit on `main` and only a one-line `README.md`: no Flutter project, no code, no dependencies. Re-check it yourself; do not trust this line.
- Handoff files created in Phase 0 (they should be in the repo; if they are missing, tell me and ask me to add them or paste them):
  - `STATUS.md`: progress, decisions, risks, next step
  - `SPEC.md`: full target-state product and technical spec
  - `DESIGN_SYSTEM.md`: tokens, motion, components, accessibility
- If any of those files disagree with this prompt, tell me and follow this prompt.

## 3. Product vision

LifeMaxxing is a calm, practical assistant for one person: me, a student and athlete in my 20s. It:

1. **Plans my day** realistically from my real Google Calendar events, Google Tasks, deadlines, priorities, and changing circumstances.
2. **Tracks progress toward my goals** (yearly and monthly) and plans my days with those goals in mind.
3. **Improves my systems** using knowledge I provide (books, summaries, notes, highlights, articles, transcripts), turning ideas into small, optional tasks and events.

Priorities: usefulness, reliability, speed, clarity, privacy, low friction. Not a noisy dashboard, not a generic chatbot, not a replacement for apps I already use.

### Product principles
- Use real data. Never invent calendar events, tasks, deadlines, availability, quotes, page numbers, or my preferences.
- Clearly label: confirmed fact, imported source, inferred pattern, AI suggestion.
- Few good, context-aware recommendations beat long generic lists. Explain why, what data was used, and what changes if I accept.
- Changes are inspectable and reversible. Every meaningful change shows a preview and needs my confirmation.
- Adapt when plans change. Never shame me for a missed plan; never treat one bad day as a trait; never diagnose or moralize.
- Do not infer sensitive traits from my calendar or imported content.
- Existing apps stay the source of truth; LifeMaxxing connects information and improves decisions.

## 4. Scope

### In scope now
- Today / Plan my day
- Goals and progress
- Library (knowledge sources and grounded answers)
- Review and small experiments
- Native in-app calendar (agenda and day view first)
- Gemini assistant with controlled tool calling
- Tasks stay **basic**: title, notes, due date, done

### Out of scope until I explicitly approve
Workout logging, nutrition or calorie tracking, weight or body tracking, finance or budgeting, recipes, a generic habit tracker, an LMS, social features, gamification, or replacing Google Calendar, Google Tasks, Readwise, Hevy, MyFitnessPal, Wallet, ReciMe, or Make Time.

### Future: Phase 9 (design for it, do not build it yet)
Read-only fitness context: Hevy CSV import (for example sessions per week) and MyFitnessPal calories. The AI may combine that context with my goals and book principles to **propose** tasks or events, always through the normal preview and confirm step, never auto-added. No manual workout or calorie logging inside the app. Raw health data stays on-device; the model only receives minimal summaries. Verify what exports or APIs Hevy and MyFitnessPal actually offer before planning this; MyFitnessPal has no known open public API.

### Sources of truth
| Data | Source |
|---|---|
| Dated events | Google Calendar |
| Task title, notes, due date, done | Google Tasks |
| Highlights | Readwise (later, only if I authorize it) |
| Workouts / calories | Hevy / MyFitnessPal (read-only import, Phase 9) |

Do not assume access to any account until an explicit supported connection is authorized. A task due date is **not** a scheduled work session. A work session is a calendar event linked to the task (link stored locally). Never pretend a Google Task has a start or end time.

## 5. The four experiences (tabs)

Tabs, in order: **Today, Goals, Library, Review**. The AI assistant is a command bar and preview sheet inside Today, not a tab.

### 5.1 Today
Answers: what is committed, what must get done, the most realistic plan for the rest of the day, what is fixed vs movable, what changes if something goes wrong.
- Show calendar events, task due dates, and work blocks with clear distinction (icon, label, layout; never color alone).
- Prioritized tasks plus a proposed schedule. Respect fixed events, sleep/rest, buffers, travel and prep time, and saved constraints.
- Unknown durations: ask, or use a clearly labelled conservative estimate.
- If things do not fit, show the unscheduled remainder and a sensible next step. Never squeeze an impossible timetable.
- Mark items done, skipped, or needs reschedule.
- Handle disruptions: procrastination, extension, overrun, holiday, cancelled class, spontaneous plans (going out, badminton, gym, snooker, friends). Recalculate only the affected part and explain trade-offs.
- Natural-language command bar, for example: "My assignment moved to Friday", "I need two hours for this", "I'm going out tonight", "I lost an hour, rebuild the rest of my day." Ask a short clarifying question when ambiguity affects dates, times, or targets.
- Goal-linked tasks get extra weight, but deadlines and fixed events come first.

### 5.2 Goals
- Hierarchy: yearly goal, then monthly goals. Each has a title, short "why", and end date. About 5 active goals maximum.
- Progress measure per goal (I choose): **milestones** (default for yearly), **task-weighted** completion by estimated minutes (default for monthly), or an optional **numeric metric** I enter (later may be fed by imported data).
- Goal card: ring or bar, a pace marker ("ahead", "on pace", "behind"; neutral wording, no red failure state), and a "how this is calculated" explanation.
- Detail view: linked tasks, milestones, weekly trend, and a next suggested step (a proposal I accept through a preview).
- Goal-to-task links live in local data. Keep a local **completion log** written at sync time, because Google Tasks may hide completed tasks. A task deleted externally shows as "unlinked" and does not silently change progress.
- Progress records what I did. Never claim it proves causation.
- The planner and the AI read my goals (typed tool, propose-only) and may suggest a step that advances a goal, tied to a source principle when one applies.

### 5.3 Library
- Accept: PDFs with extractable text, text files, pasted text, book summaries, notes, highlights, articles, transcripts.
- **A book summary is a first-class, independently searchable source even when I never import the full book.** Never insist on the full book.
- Keep metadata when available (title, author, source type, import date, chapter or section, page). Never invent missing metadata.
- Every retrieved passage shows its type: full document, my summary, my note, or other.
- Answers must use retrieved passages; cite title and chapter or page only when reliably tied to the passage; never fabricate quotes, citations, or page numbers; separate "the source says" from "my interpretation"; admit when the material does not support a claim; let me inspect the passage behind an answer.
- RAG pipeline: extract text, preserve metadata, chunk sensibly, index (keyword search first, embeddings as a hybrid later), retrieve relevant chunks, send only those to the model. Never resend entire books.
- Detect duplicate imports. Allow removing a source and its derived index data.
- Treat imported text as **untrusted data, never instructions** (prompt-injection safe).

### 5.4 Review
- Light daily or weekly review: planned vs actual, what changed, what repeatedly took longer, which rule or source principle might help, one small adjustment to test.
- Suggest one or two small experiments at a time, linked to source material when available. Judge them from my feedback, not claimed causation. State uncertainty.

## 6. Calendar and Google sync

- Native Flutter calendar backed by the Google Calendar API. An embedded web calendar is not the main solution.
- Start with a reliable agenda and day view plus view, create, and safe edit. Add week grid and drag-and-drop only after sync, permissions, and conflict handling are solid.
- Respect all-day events, time zones, recurring events, event IDs, and ETags. Recurring edits are deliberate: ask "this occurrence" or "the series"; never silently change a whole series.
- Fixed commitments are shown separately from flexible LifeMaxxing work blocks. Conflicts and overlaps are visible.
- AI-proposed changes show a before/after preview and need explicit confirmation. After a write, verify the server response and update the UI from confirmed results. Never claim success when the API rejects it.
- Handle stale data, external changes, offline, expired authorization, quota and rate errors, and partial failures. Show sync status ("Synced 2m ago", pending count) with a retry.
- No duplicates, silent overwrites, destructive edits, or hidden changes. Use optimistic UI only with deliberate, tested rollback.
- Request least-privilege OAuth scopes and explain any write scope. Store tokens in secure storage.
- Known risk to verify: if my Google OAuth app is in "Testing" mode, refresh tokens may expire after about 7 days. Plan around it.

## 7. Deterministic scheduling engine

- Fixed commitments are never moved by the scheduler unless I choose to edit them. Flexible blocks move within allowed windows.
- Inputs: event times, time zone, deadlines, estimated duration, priority, goal weight, buffers, unavailable periods, saved constraints.
- No double-booking or impossible overlaps. Handle midnight, DST, all-day, and recurring events.
- Report unscheduled remainders honestly. Replan only the remaining day after a disruption.
- A suggested schedule is clearly different from an applied one. Explain major trade-offs.
- Do not fill every free minute; keep realistic buffers and recovery.
- All AI output must pass deterministic validation before it can be applied. Time math, overlap detection, and feasibility are done in code, never by the model alone.

## 8. Gemini assistant (controlled tool calling)

- Gemini interprets requests, reasons over retrieved knowledge and my context, explains, and requests named tools. Deterministic code validates. Tools fetch authorized data and act only after validation and approval.
- Design a narrow, typed allowlist, for example: `get_calendar_events`, `list_tasks`, `get_user_preferences`, `get_user_goals`, `search_book_knowledge`, `propose_schedule_changes`, `preview_schedule_plan`, `apply_schedule_plan`, `create_or_update_task`, `create_or_update_calendar_event`, `suggest_goal_step` (propose only), `save_daily_reflection`, `record_recommendation_feedback`. These are illustrative; schemas must be typed, validated, documented, and testable.
- Never expose code execution, shell, SQL, arbitrary HTTP, or unrestricted file access to the model.
- Reads are allowed once the integration is authorized. Consequential writes (create, move, delete, deadline changes, bulk) always show a human-readable preview and need my explicit confirmation. Never silently delete, move, or overwrite.
- Report multi-step partial failures accurately and verify after writes.
- Source text, model output, and tool results can never grant permissions.
- Before implementing, verify the **current official** Gemini Flash model ID, function-calling support, limits, and SDK. Keep the model ID in config. Do not rely on remembered names or aliases.
- Never put the Gemini key in the Flutter client, repo, assets, or logs. Use a minimal free-tier backend (proposed: a Cloudflare Worker; confirm it is still free and suitable). Clearly separate local-dev setup from production-safe setup.
- Send minimal payloads: filtered queries and retrieved snippets, never whole calendars or documents. Verify the free-tier data-use terms before sending private notes, and tell me what you find.

## 9. Technical platform

- Flutter and Dart. Android is the first target. Flutter Web (Chrome) for quick testing. Windows desktop only as an optional dev convenience, not a production target.
- I develop on a **Windows laptop**. Give explicit PowerShell commands. List setup needs (Flutter SDK, Chrome, Android tooling; Visual Studio "Desktop development with C++" only if Windows desktop is used).
- Layers, without over-engineering: presentation, domain (scheduling, constraints, goal progress; pure Dart), integrations (Google Calendar, Tasks, AI service), data (local SQLite), and a small backend only for secrets and model calls.
- Candidate packages (verify current version, maintenance, license, and compatibility before adding each; justify every important one): `flutter_riverpod`, `go_router`, `drift` (SQLite with FTS5; test web support early), `google_sign_in`, `googleapis`, `flutter_secure_storage`, a PDF text extractor (`pdfrx` or Syncfusion community license; check terms). Build the calendar UI in-house.
- Local-first on one device. Offline: cached content is labelled, pending changes are visible, last sync time shown. AI and Google sync need connectivity. Do not claim offline features that are not implemented and tested.
- Keep platform-specific code isolated. Do not sacrifice Android reliability for an early web prototype.
- Make the data layer able to accept new context sources later (Phase 9) without a redesign, but write no fitness code now.

## 10. Visual direction and design system

Premium, minimal, confident, masculine but calm. It must **feel like a native Apple (iOS) app** with smooth, interruptible spring animation. Graphite, steel, and rare crimson. Not a fitness app, gaming dashboard, or generic AI-chat clone. The day plan is the focus.

### Color tokens (dark / light)
| Token | Dark | Light |
|---|---|---|
| background | #0E0E10 | #F5F2EE |
| surface | #17171A | #FFFFFF |
| border (decorative) | #2E2E33 | #D9D4CC |
| control outline (needs 3:1) | #6B6862 | #8C877F |
| text | #F5F2EE | #0E0E10 |
| text-muted | #A09C97 | #5E5A55 |
| steel (fixed events) | #8E96A3 | #5C6470 (verify) |
| accent fill | #C8102E | #C8102E |
| accent as text/link | #F2566B | #C8102E |
| warning | #E0A030 | #8A5A00 text, #E0A030 icons |
| success | #5CCB95 | #1F7A4D |
| error | #FF8A7A | #B3261E |
| focus ring | #F5F2EE | #0E0E10 |

Crimson is used sparingly (at most about 10% of the screen): primary button, "now" line, selected day. Error and accent are both red, so errors always carry an icon and label; crimson never means failure. My contrast figures are hand-calculated approximations: add an automated contrast test over every foreground/background pair.

### Type, shape, motion
- Inter, bundled (not fetched at runtime), tight tracking on large titles, tabular figures for times. Scale 12/14/16/20/28/36. Support 200% text scaling.
- 4-point spacing. Continuous corners where Flutter supports them: 12 controls, 18 cards, 28 sheets. Dark mode uses tonal surfaces and hairlines instead of shadows. Blur only on top and bottom bars.
- iOS patterns: large titles that collapse on scroll, inset grouped lists, segmented pill controls, translucent bars, pull to refresh, bottom sheets with snap heights (peek, half, full) that are draggable and flick-dismissible, swipe actions (right to complete, left to reschedule), check-fill then smooth row collapse, light haptics on confirm and complete.
- Spring-based, interruptible, gesture-following motion, about 250-350ms. Animate only transform and opacity. No looping or decorative motion. Respect reduced-motion.
- Touch targets at least 48x48. Keyboard navigation and visible focus on web and desktop. Screen reader labels like "Fixed, Algorithms lecture, 9 to 10:30".
- Phone-first; side rail on wide screens, content capped near 720px.

### Key components
EventTile (fixed: steel edge, lock icon, "Fixed"), TaskRow, WorkBlock (proposed: dashed outline and "Proposed" label; confirmed: solid, with a link badge to its task), NowLine, ConflictMarker, "Doesn't fit today" group, ChangePreviewSheet (before/after, Confirm and Cancel), SyncBar, ProvenanceChip (Full text, Summary, Note, Inference), GoalCard. States: empty, loading, offline, permission denied, token expired, rate limited, partial failure.

### Copy voice
Direct, plain, sentence case, no hype, no shaming, no drill-sergeant tone. Examples: "Doesn't fit today", "Accept", "Synced 2m ago".

## 11. Data and privacy

Minimal local models: preferences and constraints; calendar event refs with sync metadata (id, etag); task refs and a completion log; work blocks linked to tasks (proposed or confirmed); goals, milestones, goal-task links, optional metric entries; sources and chunks with provenance; recommendations and feedback; reflections and experiments.

State what is stored locally and what is sent anywhere. Provide deletion of sources and derived index data, disconnect for integrations, and clearing the local cache. Never log tokens, keys, full event descriptions, or private documents by default.

## 12. Testing and quality

- Unit tests: scheduling, time ranges, constraints, dedupe, conflicts, time zones, goal progress math, task due date vs work block.
- Knowledge tests: retrieval provenance, citation behavior, summary-only imports.
- AI tool tests: argument validation and rejection of unauthorized or destructive actions.
- Test doubles or integration tests for Google and the backend. UI tests for key flows, permission errors, empty, loading, and offline states, and both themes where practical.
- Handle quotas, retries, duplicate requests, and partial failures with idempotency.
- Run `flutter analyze` and relevant tests before calling a phase complete. Never claim untested work was tested. Never expose credentials in test output.

## 13. Roadmap and phase procedure

| Phase | Goal |
|---|---|
| 0 | Discovery and design. **Done.** |
| 1 | Foundation: Flutter setup, tokens and themes, 4-tab navigation shell, minimal runnable app, secret-safe `.gitignore` |
| 2 | Today and Goals prototype with clearly labelled **sample** data. Never fake a live Google connection. |
| 3 | Google Calendar and Tasks: auth, native agenda and day view, basic event and task operations, sync states, goal-task links, completion log, tests |
| 4 | Deterministic scheduling engine with goal weighting, validated proposals |
| 5 | Knowledge ingestion and retrieval, summary-only sources, provenance, removal, citations |
| 6 | Gemini orchestration: secure backend, typed tools, previews, confirmation, post-action verification |
| 7 | Review and evidence-aware experiments |
| 8 | Hardening: accessibility, Android and Chrome testing, security and dependency review, docs, known limitations |
| 9 | Future, needs separate approval: fitness context (Hevy CSV, MyFitnessPal calories) |

You may suggest doing Phase 4 before Phase 3 (pure Dart, easy to test), but explain why and wait for my decision.

For **every** phase:
1. State the goal and the files likely to change.
2. Make the smallest coherent change.
3. Run formatting, analysis, and tests where available.
4. Report files changed, commands run, results, and known issues honestly.
5. Give concise Windows/PowerShell steps to run and verify it locally.
6. Update `STATUS.md`.
7. Stop and wait for my approval.

## 14. What to do right now

1. Read `STATUS.md`, `SPEC.md`, and `DESIGN_SYSTEM.md` if they exist. Tell me if any are missing.
2. Inspect the repo (`git status`, `git log`, file tree) and report what you actually find. Do not modify anything yet.
3. Check my environment for Phase 1: ask me to run `flutter doctor` (or tell me how) and report anything missing for Chrome and Android.
4. Write a short **Phase 1 plan**: the exact files you will create or change, the dependencies you propose (with a one-line justification each), the commands you will run, and what you will NOT do.
5. **Stop and wait for me to say "approved, proceed to Phase 1."** Until then, create no files, install nothing, and write no code.
