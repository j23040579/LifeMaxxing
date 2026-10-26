# LifeMaxxing — Design System

Direction: premium, minimal, confident, masculine but calm. It should feel like a native Apple (iOS) app: large titles, grouped lists, translucent bars, continuous corners, and smooth, interruptible spring animation. Graphite, steel, and rare crimson. Not a fitness app, gaming dashboard, or generic AI chat.

## 1. Color tokens

Contrast numbers are hand-calculated approximations. Phase 1 must add an automated contrast test over every foreground/background pair.

| Token | Dark | Light |
|---|---|---|
| background | #0E0E10 | #F5F2EE |
| surface | #17171A | #FFFFFF |
| surface-raised | #1F1F23 | #FFFFFF with border |
| border (decorative) | #2E2E33 | #D9D4CC |
| control outline (needs 3:1) | #6B6862 | #8C877F |
| text | #F5F2EE | #0E0E10 |
| text-muted | #A09C97 | #5E5A55 |
| steel (fixed events) | #8E96A3 | #5C6470 (verify) |
| accent fill | #C8102E | #C8102E |
| accent as text/link | #F2566B | #C8102E |
| on-accent | #FFFFFF | #FFFFFF |
| selected | accent at ~12% tint plus 3px left bar | accent at ~8% tint plus 3px left bar |
| warning | #E0A030 | #8A5A00 for text, #E0A030 for icons and fills |
| success | #5CCB95 | #1F7A4D |
| error | #FF8A7A | #B3261E |
| focus ring | #F5F2EE | #0E0E10 |

Notes:
- Crimson is the primary accent, used sparingly (target at most about 10% of the screen): primary button, "now" line, selected day.
- Crimson on dark background is only about 3.3:1, so use the lighter accent-as-text value for text. White on crimson fill is about 5.9:1.
- Amber on light background is about 2:1, so use the dark amber for text in light mode.
- Error and accent are both red. Errors always have an icon and a label. Crimson never signals failure.
- Never rely on color alone: use icon, label, and layout.

## 2. Typography

- Display and UI: Inter (bundled, not fetched at runtime) with tight tracking on large titles. Apple's system font cannot be used on Android.
- Scale: 12 / 14 / 16 / 20 / 28 / 36. Weights 400, 500, 600.
- Large titles collapse into a small header on scroll.
- Tabular figures for times and numbers.
- Support text scaling to 200% without clipping.

## 3. Spacing, shape, elevation, icons

- 4-point base: 4, 8, 12, 16, 24, 32, 48.
- Continuous (superellipse) corners where Flutter supports it: 12 controls, 18 cards, 28 sheets, full for chips.
- Dark: tonal surface steps plus 1px hairlines, no heavy shadows or glow. Light: 1px border, soft shadow on sheets only.
- Blur/translucency only on top and bottom bars (performance).
- Icons: Material Symbols (outlined) or equivalent built-in set. Touch targets at least 48x48.

## 4. Motion and interaction

- Spring-based, interruptible, gesture-following. Typical 250-350ms. No looping or decorative animation.
- Animate only transform and opacity for performance.
- Respect the OS reduced-motion setting.
- Bottom sheets with snap heights (peek, half, full): draggable and flick-to-dismiss.
- Row swipe actions: swipe right to complete, swipe left to reschedule.
- Task completion: check fills, row collapses smoothly.
- Light haptics on confirm, complete, and snap (Android).
- Large title collapse, pull to refresh for sync, segmented pill controls, inset grouped lists.
- Profile on a real Android device in Phase 8.

## 5. Navigation and hierarchy

Tabs (bottom bar on phone, side rail on wide screens, content capped near 720px):
1. **Today** — date strip, Day/Agenda toggle, command bar, timeline.
2. **Goals** — goal cards with progress and pace, goal detail, milestones.
3. **Library** — sources, search, "ask my sources", passage inspector.
4. **Review** — daily/weekly reflection, active experiments.

The AI assistant is a command bar and preview sheet launched from Today. It is not a tab.

## 6. Components

- **EventTile (fixed):** solid steel left edge, lock icon, "Fixed" label, source tag.
- **TaskRow:** check control, due chip. Task due date is separate from planned time.
- **WorkBlock (proposed):** dashed outline, "Proposed" label, link badge to its task, "Based on" source chip. Accept / Adjust buttons.
- **WorkBlock (confirmed):** solid outline, link badge, still distinguishable from fixed events.
- **NowLine:** crimson dot and line.
- **ConflictMarker:** icon plus label, never color alone.
- **DoesntFitGroup:** unscheduled remainder with a suggested next slot.
- **ChangePreviewSheet:** before/after list of changes, explicit Confirm and Cancel, partial-failure reporting.
- **SyncBar:** "Synced 2m ago", pending count, retry.
- **ProvenanceChip:** Full text, Summary, Note, Inference.
- **GoalCard:** ring or bar, pace marker (neutral wording), how-computed link.
- **States:** empty, loading skeleton, offline/cached, permission denied, token expired, rate limited, partial failure. Empty states invite action; error copy says what happened and what to do.

## 7. Copy voice

Direct, plain, short, sentence case. No hype, no shaming, no drill-sergeant tone. Examples: "Doesn't fit today", "Accept", "Synced 2m ago". Avoid "please", "successfully", exclamation marks on system copy.

## 8. Accessibility and responsiveness

- WCAG AA: 4.5:1 for body text, 3:1 for large text and controls.
- Keyboard navigation and visible focus on web/desktop.
- Screen reader labels read in full, for example "Fixed, Algorithms lecture, 9 to 10:30".
- Responsive: phone-first, rail on wide screens, never stretch phone content across a desktop width.
- Dark and light themes both complete; default follows system.

## 9. Reference mockup (Today screen, dark)

Structure (top to bottom): date line and large "Today" title with a "Synced 2m ago" chip; day strip Mon-Fri with the selected day underlined in crimson; command bar ("Tell LifeMaxxing what changed"); timeline with fixed Algorithms lecture 09:00-10:30, a crimson "now" line at 11:05, a dashed Proposed "Essay draft" block 11:15-12:45 linked to its task (due Fri) with "Based on: Deep Work (your summary)" and Accept/Adjust, a fixed Badminton 14:00-15:30; a "Doesn't fit today" card for "Read chapter 4 notes, 45 min, suggest Tuesday 10:00"; bottom bar with Today, Goals, Library, Review.
