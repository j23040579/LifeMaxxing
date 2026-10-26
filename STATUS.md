# LifeMaxxing — STATUS

> Living handoff file. Update it at the end of every session or phase.
> Last updated: 2026-10-26 (Phase 0, design proposal agreed, awaiting Phase 1 approval)

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

- **Name:** LifeMaxxing (app name and repo name; the owner's older prompt says "LifeOS" — treat that as LifeMaxxing)
- **Repo:** https://github.com/j23040579/LifeMaxxing (public for now; owner may make it private later)
- **Repo state when inspected (2026-10-26, public GitHub page only):** one commit on `main`, only `README.md` with a one-line description. No Flutter project, no code, no dependencies. Local clone state was NOT checked.
- **Stack decided:** Flutter + Dart. Android first, Flutter Web (Chrome) for quick testing, Windows desktop only as an optional dev convenience.
- **Owner environment:** Windows laptop. Provide PowerShell commands.
- **Owner profile:** student and athlete in their 20s. Personal-use app, not SaaS.

## 3. Progress

| Phase | Name | State |
|---|---|---|
| 0 | Discovery and design | Done, owner agreed to the direction. Waiting for "proceed to Phase 1". |
| 1 | Foundation (themes, tokens, nav shell, runnable app) | Not started |
| 2 | Today and Goals prototype with labelled sample data | Not started |
| 3 | Google Calendar and Tasks integration, goal-task links, completion log | Not started |
| 4 | Deterministic scheduling engine (with goal weighting) | Not started |
| 5 | Knowledge ingestion and retrieval (summary-only sources included) | Not started |
| 6 | Gemini orchestration (typed tools, preview, confirm, verify) | Not started |
| 7 | Review and experiments | Not started |
| 8 | Hardening (accessibility, Android, Chrome, security, docs) | Not started |
| 9 | Fitness context (Hevy CSV, MyFitnessPal calories) | Future, only if the owner approves |

Optional re-order the AI suggested: do Phase 4 before Phase 3 because it is pure Dart and easy to test. Not decided; keep the table order unless the owner agrees.

## 4. Decisions made (do not re-ask)

- App name: **LifeMaxxing**.
- Top-level tabs: **Today, Goals, Library, Review**. No more tabs without asking. The AI assistant is a command bar and sheet inside Today, not a tab.
- Visual direction: the "machined" dark look (graphite, steel, rare crimson) **restyled to feel like an Apple/iOS app** with smooth, interruptible spring animations. Both dark and light themes.
- Native Flutter calendar UI backed by the Google Calendar API. No iframe as the main solution.
- Gemini is called only through a small backend that holds the key. Free options only. Proposed host: Cloudflare Worker free tier (confirm in Phase 6).
- Data is local-first on one device (SQLite). Goals and goal-task links are stored locally.
- Tasks stay basic for now: title, notes, due date, done.
- Goals: yearly goals break into monthly goals. Up to about 5 active goals. Progress measured by milestones (default for yearly), task-weighted by estimated minutes (default for monthly), or an optional numeric metric.
- Fitness: **no workout, nutrition, finance, or recipe tracking inside the app.** Later (Phase 9) read-only context from Hevy CSV and MyFitnessPal calories may feed planning and suggestions, always as previewed proposals.
- Repo may stay public for now.
- Model ID for Gemini lives in config. Verify the current official model ID and SDK when Phase 6 starts. Do not trust remembered names.

## 5. Open items and risks to verify later

- Google OAuth app in "Testing" mode may expire refresh tokens after about 7 days. Verify and plan around it in Phase 3.
- Google Tasks may hide completed tasks. The app keeps its own completion log at sync time so goal progress survives.
- Gemini free-tier data usage terms: verify before sending private notes.
- MyFitnessPal has no known open public API. Hevy export or API availability is unverified. Check before Phase 9.
- `drift` on Flutter Web needs extra setup. Test early in Phase 1 or 2.
- Check every package for current version, maintenance, and license before adding it.
- Owner mentioned earlier UI reference images that the AI could not see. Ask again if the look needs refining.
- Owner may want the repo private later: GitHub, Settings, General, Danger Zone, Change visibility.

## 6. Session log

- 2026-10-26 (Claude, chat): Inspected the public repo page. Produced the Design System Proposal and a static dark Today mockup. Agreed on the name, Apple-style look, free-only services, goals/progress tab, and future fitness context. Wrote `STATUS.md`, `SPEC.md`, `DESIGN_SYSTEM.md` for handoff. No repo files were changed by the AI.

## 7. Next step

Owner says **"approved, proceed to Phase 1"**. Then the AI must:
1. Run `git status` and inspect the repo.
2. List the exact files it plans to create or change and why.
3. Confirm Flutter setup on Windows (`flutter doctor`, Chrome, Android tooling).
4. Create only: Flutter project, theme and tokens, navigation shell (4 tabs), minimal runnable app, `.gitignore` secret patterns, `.env.example` if needed.
5. Run `flutter analyze` and tests, report honestly, give PowerShell run steps, then stop for approval.

## 8. Phase report template

```
Phase N report
Goal:
Files changed:
Commands run and results:
Tests run (and what was NOT tested):
Known issues:
How to run locally (PowerShell):
Next phase proposal (waiting for approval):
```
