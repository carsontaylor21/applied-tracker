# APPLIED Exam Tracker — Project Notes

> Reference for future Claude sessions continuing this work. **Read this first** when picking up the project. Covers user context, strategic decisions, technical architecture, repo layout, and pending v2 ideas.

---

## TL;DR for incoming Claudes

- **What:** Personal study tracker for an ABD APPLIED exam (Mon Jul 20, 2026), built around the user's CORE percentile data. Single-page HTML + Supabase backend. Hosted on GitHub Pages.
- **Where:** This repo (`~/applied-tracker/`) holds everything: `index.html` (frontend), `supabase/` (schema migrations), `update.sh` (deploy), this file. Strategy artifacts (`.xlsx`, `.docx`) live in the Cowork outputs folder, not the repo.
- **How to deploy frontend changes:** Edit `index.html` directly (the folder is connected as a Cowork working folder), then user runs `./update.sh "msg"` from the repo to commit + push. GitHub Pages rebuilds in ~30s.
- **How to deploy schema changes:** Add a new file in `supabase/migrations/` (CLI: `supabase migration new <name>`), then `supabase db push` from inside this folder.
- **Be aware:** the user has ADHD and weak CORE percentiles — design decisions are deliberately ADHD-friendly (consistency anchors, never-skip-Anki, modality variety). Don't optimize away those constraints.

---

## What this project is

A personal study tracker for a dermatology resident preparing for the ABD APPLIED exam on **Mon Jul 20, 2026**. Three layers:

1. **Strategy artifacts** — `APPLIED_study_schedule.xlsx` (6 sheets, 88-day daily plan) and `APPLIED_study_strategy.docx` (rationale + ADHD playbook). These live in the Cowork outputs folder; user opens them as standalone files.
2. **Live tracker** — `index.html` (in this repo) deployed via GitHub Pages. Backed by Supabase for per-user persistent state. Shows daily tasks, lets user check off blocks, log energy 1-5, write per-day journal.
3. **Build scripts** — `build_schedule_v3.py` and `build_doc_v3.js` regenerate the strategy artifacts deterministically from data. These currently live in outputs (not the repo); could be moved into the repo if version-controlling them becomes useful.

---

## User context

- Dermatology resident (US, ABD track) preparing for APPLIED.
- ADHD: needs short blocks, fixed time-of-day anchors, never-skip-Anki rules. Consistency is harder than effort.
- Time envelope:
  - Weekday: 1–2 hrs (split: ~15-20 min AM Anki + 45-60 min PM block)
  - Weekend: 3–4 hrs each day
  - **Vacation week:** May 25–31 → 1 hr/day maintenance only
  - **Graduation weekend:** Jun 6–7 → 1 hr/day
  - **Last day of work:** Thu Jul 9 → W11 Fri-Sun + all of W12 are full-day study windows
- Already passed CORE but with weak percentiles across all categories.

## CORE percentile breakdown (drives all priority decisions)

| Category | Overall | Image | Written | Other notable |
|---|---|---|---|---|
| Peds derm | 6th | 3rd | 5th | BS 33 |
| Dermpath | 3rd | 7th | 67th | Virtual 2nd, BS 14 |
| Medical derm | 18th | 40th | 32nd | BS 8 |
| Surgical derm | 21st | 22nd | 27th | BS 28 |

Implications:
- **Image recognition is the dominant sub-weakness** in peds (3rd) and dermpath (image 7th, virtual 2nd). Photo atlas / WSI drilling > re-reading.
- **Dermpath written is 67th** — knowledge is fine, *visual pattern recognition* is the gap.
- **Med derm is the hidden biggest opportunity:** 55% × 18th %ile = largest score lever. Basic science (8th %ile) is the cross-cutting sub-weakness.
- **Basic science is consistently low** across all categories (8 / 14 / 28 / 33). Mechanism / pharm / immuno review woven into med derm weeks rather than getting its own week.

## APPLIED exam blueprint (per user)

- **Medical dermatology: 55%**
- **Pediatric dermatology: 15%**
- **Dermatopathology: 15%**
- **Surgical dermatology: 15%**

Format: case-based, image-heavy, pattern recognition + management. Less rote than CORE.

---

## Resources

### Learn
- **Alikhan Review of Dermatology, 1st ed** — primary text, 11 chapters. TOC mapped per-day in the schedule.
- **Bolognia Essentials** — backup for shaky topics; cut entirely if behind.

### Quiz (Anki)
- **Dermki: ~19,000 cards** organized by Alikhan chapter (subdecks 1–11). *Supplementary only* — too many to cover. Pull specific Alikhan §X.Y subsections per day's reading.
  - 1.x Basic science (~few hundred)
  - 2 Pharm (1,700) | 3 General Derm (5,228) | 4 Peds (1,879) | 5 Infectious (2,273) | 6 Neoplastic (1,399) | 7 Dermpath (3,851) | 8 Surgery (1,193) | 9 Cosmetic (796) | 10 Internal (457) | 11 Epi (104)
- **Hot Rod: 2,893 cards** topically organized (cross-references Alikhan, Bolognia, Andrews). **Primary new-card source** at ~25/day → ~70% coverage in 12 weeks. Topic decks include: Foundations, Acne, Eczematous, Psoriasis, Other papulosquamous, Lichenoid, Blistering, Connective tissue, Vascular, Granulomatous, Drug eruptions, Urticaria/erythema, Neutrophilic/eosinophilic, Pruritus/neurocutaneous, Deposition, Mucous membrane, Pigmentary, Disorders of skin appendages, Nutritional, Diseases of fat, Endocrine/metabolic, Collagen/elastic, Genodermatoses, Pregnancy/neonatal, Infections (bacterial, fungal, viral, mycobacterial, infestations), NMSC, Melanocytic, Dermal/SQ tumors, Cutaneous lymphoma, Immunology, Surgery, Cosmetics/laser.
- **Dolphin Dermatology** — random kodachromes deck, used as daily photo atlas (30-50/day). Critical for peds image 3rd %ile and dermpath image 7th. Format mimics APPLIED's no-context image questions.
- **Quizlet** — user-built supplements (esp. drug monitoring, immuno).

### Test
- **DermQbank: 2,426 total, 1,626 done, 800 unanswered.** Has subtopic filters within categories — but **not used during buildup** (mixed env preferred). Subtopic filters reserved for W11/W12 weak-spot drilling.
- **AAD Qbank: 2,110 total, 1,272 done, 838 unanswered.** Big-bucket filters only (peds/derm/path/surg/basic). Random unanswered, mixed mode.
- **Conquer the Boards (CtB)** — AAD's exam review course. Two timed sections + PDF answer review. Section 1: 94 min, 50 Qs. Section 2: 58 min, 34 Qs. Total 84 Qs. Treated as practice exams in W11.

---

## Strategic decisions

### Anki strategy: Hot Rod primary, Dermki supplementary, Dolphin daily
The math doesn't work to cover all 19K Dermki cards in 12 weeks. Strategy:
- **Hot Rod = primary new cards** (~25/day, 70% coverage by exam)
- **Dermki = topic-aligned supplement** (~10/day from current Alikhan section)
- **Dolphin = daily photo atlas** (30-50/day, image-recognition reps)
- **Mature backlog reviews capped at 50/day** (hard ceiling)

Daily structure:
- AM (after coffee anchor): 15-20 min — 50 reviews, NO new cards. Retrieval only.
- PM (after dinner anchor, fixed time): 15-20 min — 20-25 new Hot Rod + 5-10 new Dermki.
- PM Block 2: 5-10 min — 30-50 Dolphin photos.

Vacation week (W5): 30 reviews/day, 0 new. Wind-down (W12): tapers progressively, 0 Anki Fri-Sun.

### Qbank strategy: random unanswered, mixed mode, no reset
- APPLIED tests pattern recognition without telling you the category. Random mixed mode trains the actual exam skill.
- Don't reset either Qbank — the unanswered Qs are most valuable.
- Topical filters only used in W11 (weak-spot triage post-CtB) and W12 (targeted drilling).
- Volume math: ~1,484 Qs needed across schedule, 1,638 unanswered + 84 CtB available. ~240 buffer.

### W11 sequence
- Mon-Thu Jul 6-9: still working, standard weekday template
- **Thu Jul 9: last day of work**
- Fri Jul 10: CtB Section 1 (94 min, 50 Qs) + 90-min PDF review
- Sat Jul 11: CtB Section 2 (58 min, 34 Qs) + 60-min review
- Sun Jul 12: PE#1 — 100 random unanswered DermQbank, timed + review

Three exam exposures in three days drive W12 weak-spot priorities.

### W12 wind-down
- Off work entirely
- Mon-Wed: targeted weak-spot drilling using Qbank topical filters (now allowed)
- Thu: taper, 10 Qs and stop
- Fri: error log skim only, exam logistics
- Sat-Sun: REST. No studying. Sleep.

---

## Schedule structure (12 weeks)

| Week | Dates | Theme | Alikhan chapters |
|---|---|---|---|
| W1 | Apr 25 – May 3 (9d) | Peds Common — Neonatal & Viral | §4.1, 4.2, 4.7, 4.15 |
| W2 | May 4 – 10 | Peds Vascular/EB + Infectious | §4.4, 4.6, peds-relevant Ch 5 |
| W3 | May 11 – 17 | Peds Genodermatoses | §4.3, 4.5, 4.8-4.14 |
| W4 | May 18 – 24 | Dermpath 1 — Inflammatory | §7.1 |
| W5 | May 25 – 31 | 🌴 VACATION — 1 hr/day | — |
| W6 | Jun 1 – 7 | Dermpath 2 — Tumors (grad wknd 1hr) | §7.2, 7.3 |
| W7 | Jun 8 – 14 | Med Derm 1 — Papsq, Eczema, Interface, Bullous, CT | §3.1-3.5 + §2.4 biologics |
| W8 | Jun 15 – 21 | Med Derm 2 — Granulomatous → Drug + Immuno | §3.6-3.14 + §1.6 + §1.4 |
| W9 | Jun 22 – 28 | Med Derm 3 — Vascular/Pigmentary/Infections/Internal | §3.15-3.26 + Ch 5 + Ch 10 |
| W10 | Jun 29 – Jul 5 | Surgery + Cosmetic + Tumors + Basic Sci | Ch 6, 8, 9 + §1.1-1.7 |
| W11 | Jul 6 – 12 | CtB + Practice Exam (last work Thu Jul 9) | Targeted weak topics |
| W12 | Jul 13 – 19 | WIND-DOWN (off work, exam Mon Jul 20) | No new material |

W0 was eliminated — W1 starts Sat Apr 25 (Day 1 of plan).

---

## ADHD design patterns

- **Consistency anchors:** "after first coffee → Anki" (AM), "after dinner at fixed time → study block" (PM). Same cue every day.
- **Never skip Anki entirely** — 50 reviews is the daily floor. Single accountability question end-of-day: "Did I do Anki?"
- **5-card entry rule:** when stuck on starting evening block, do 5 Anki cards and reassess.
- **Catch-up→guilt→quit is the enemy.** Missed days don't get "made up" — push to weekend or W11 weak-spot list.
- **Modality variety** — Mon/Wed read days, Tue/Thu Qbank/photo days, Fri interleaved, weekends deep.
- **Energy 1-2 multiple days = upstream signal** (sleep/meals/rotation). Address root cause, don't push harder.

---

## Tech stack

- **Frontend:** Single `index.html` file. Vanilla JS, no build step. Supabase JS v2 from jsdelivr CDN. CSS in `<style>` block. ~1000 lines total.
- **Backend:** Supabase project `cywqljirhysahavtsqff`
  - URL: `https://cywqljirhysahavtsqff.supabase.co`
  - Anon key embedded in HTML (safe — public by design, RLS protects data)
  - Auth: Email magic link (OTP) via Supabase
  - Schema migrations: `supabase/migrations/` in this repo, applied via `supabase db push`
- **Hosting:** GitHub Pages (public repo, free tier)
- **State persistence:** Per-user, per-day rows in `study_log` table

### Schema (current)

```sql
create table public.study_log (
  user_id    uuid not null references auth.users(id) on delete cascade default auth.uid(),
  date       date not null,
  am_anki    boolean not null default false,
  read_done  boolean not null default false,
  new_cards  boolean not null default false,
  photos     boolean not null default false,
  qbank      boolean not null default false,
  energy     int    check (energy between 1 and 5),
  journal    text,
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

-- updated_at auto-touch trigger on each row update
-- RLS enabled, four policies (select/insert/update/delete) where auth.uid() = user_id
```

Multi-tenant by design — different users see only their own rows.

The migration that creates this schema lives at `supabase/migrations/20260426142547_create_study_log.sql`.

### Supabase Auth configuration

Hosted in dashboard at **Authentication → URL Configuration**:
- **Site URL:** the GitHub Pages URL (e.g., `https://<user>.github.io/applied-tracker/`)
- **Redirect URLs:** `https://<user>.github.io/applied-tracker/**` (the `**` wildcard covers `#access_token=...` paths)

Magic link OTP works end-to-end with these set. If `Site URL` is wrong, redirects fall back to localhost defaults.

### Key implementation details (index.html)

**Auth flow:**
- Two top-level divs: `#auth` (login form) and `#tracker` (the app)
- `sb.auth.onAuthStateChange()` listens for sign-in/sign-out and toggles visibility
- Magic link redirect uses `window.location.href` — must be in Supabase Auth allowlist
- Auth state cached on initial load via `sb.auth.getSession()`

**Data flow:**
- On sign-in: `loadAll()` fetches all `study_log` rows for the user, caches them in `logByDate` (object keyed by date string)
- On any change: `saveDay(date, fields)` upserts the row using `onConflict: 'user_id,date'` for the composite primary key
- Race-safe: only the changed fields are sent in the upsert payload, so concurrent saves merge correctly

**UI sync:**
- `syncDOM(date, field, value)` is the cross-cutting function that updates all DOM elements bound to a (date, field) tuple
- Same data appears in two places: today's card (top) and the per-day rows in the week list — `syncDOM` keeps them in lockstep
- Journal sync skips the input the user is currently typing in to avoid cursor jumps
- Each day row has its own journal text input + energy 1-5 buttons (so past days remain editable)
- `updateWeekProgress(date)` recomputes the week-header progress badge after a checkbox change without full re-render

**Save behavior:**
- Checkbox changes: instant save
- Energy clicks: instant save (clicking the active number un-sets it, saves null)
- Journal text input: 600ms debounced via `saveDayDebounced`
- Sync status indicator in top-right: idle / saving / saved / err (auto-clears after 1.5s)

---

## Repo structure

```
~/applied-tracker/
├── index.html              # The tracker. GitHub Pages serves this.
├── README.md               # Minimal repo description (auto-created on GitHub).
├── CLAUDE.md               # This file.
├── update.sh               # Deploy script — git add/commit/push.
├── .gitignore              # Excludes .DS_Store, .env, editor junk.
└── supabase/               # Supabase CLI scaffolding.
    ├── config.toml         # Supabase project config.
    ├── .gitignore          # Excludes .temp/ and .env.* (CLI-managed).
    └── migrations/
        └── 20260426142547_create_study_log.sql
```

### Files in this repo

| File | Purpose |
|---|---|
| `index.html` | Live tracker — Supabase-wired, GitHub Pages-ready. ~1000 lines. |
| `update.sh` | Deploy script. `cd ~/applied-tracker && ./update.sh "msg"` to push to GitHub Pages. |
| `CLAUDE.md` | This file. Always read it first. |
| `README.md` | One-line repo description, used by GitHub. |
| `.gitignore` | Standard exclusions. |
| `supabase/config.toml` | Supabase project config, `project_id = "cywqljirhysahavtsqff"`. |
| `supabase/migrations/*.sql` | Schema migrations, applied via `supabase db push` from this folder. |

### Files NOT in the repo (live in Cowork outputs only)

| File | Purpose | Why not in repo |
|---|---|---|
| `APPLIED_study_schedule.xlsx` | Master schedule, 6 sheets | Binary, regeneratable, distributed via Cowork file presentation |
| `APPLIED_study_strategy.docx` | Strategy doc | Binary, regeneratable |
| `build_schedule_v3.py` | Python xlsx builder | Could be added to repo if version control becomes useful — would also need .gitignore for generated `.xlsx` |
| `build_doc_v3.js` | Node docx builder | Same as above |

---

## Update workflow (going forward)

The repo at `~/applied-tracker/` is connected as a Cowork working folder. Claude can read/write directly. No more "edit in outputs, then cp."

### Setup at session start

If `Read /Users/carsontaylor/applied-tracker/...` doesn't work in a new session, call `mcp__cowork__request_cowork_directory` with `path: "~/applied-tracker"` to mount it.

Path mappings inside Claude:
- File tools (Read/Write/Edit/Grep/Glob): `/Users/carsontaylor/applied-tracker/`
- Bash sandbox: `/sessions/<session-id>/mnt/applied-tracker/`

Always use the host path (`/Users/carsontaylor/applied-tracker/`) with file tools. The bash mapping is only for `mcp__workspace__bash` calls.

### For frontend changes (index.html)

1. Claude edits `/Users/carsontaylor/applied-tracker/index.html` directly.
2. User runs from terminal:
   ```bash
   cd ~/applied-tracker
   ./update.sh "what changed"
   ```
3. GitHub Pages rebuilds in ~30s. User refreshes the URL.

What `update.sh` does (~20 lines):
- `git add -A` — stages all repo changes
- `git diff --cached --quiet` — exits gracefully if nothing changed
- `git commit -m "$1"` (default: "update tracker")
- `git push`

### For schema changes

1. Claude or user creates a new migration file:
   ```bash
   cd ~/applied-tracker/supabase
   supabase migration new <descriptive_name>
   ```
2. Claude edits the generated SQL file with the schema change.
3. User runs:
   ```bash
   cd ~/applied-tracker/supabase
   supabase db push
   ```
   (User will be prompted for the database password.)
4. Claude updates `index.html` to use the new schema columns/tables.
5. User runs `./update.sh "schema + frontend update"` from the repo root to push.

### For strategy artifact (xlsx/docx) changes

1. Claude edits/regenerates `build_schedule_v3.py` or `build_doc_v3.js` in the Cowork outputs folder.
2. Runs the build script, validates output.
3. Presents the new file to user via `mcp__cowork__present_files`.
4. These files are NOT pushed to the GitHub repo.

---

## Pending v2 ideas

Not yet built:

1. **Error log table** — track Qbank questions gotten wrong with topic + reason. Used heavily during W11 weak-spot triage.
   ```sql
   create table public.error_log (
     id uuid primary key default gen_random_uuid(),
     user_id uuid references auth.users default auth.uid(),
     date date not null,
     qbank text,         -- 'DermQbank' | 'AAD' | 'CtB'
     topic text,
     subtopic text,
     question_summary text,
     picked text,
     correct text,
     why text,
     created_at timestamptz default now()
   );
   ```
2. **Practice exam scores table** — record CtB §1, CtB §2, PE#1 scores by topic for W12 priority-setting.
3. **Streak tracking** — display "X day Anki streak" (encourages habit consistency).
4. **Weekly retro auto-summary** — read journal entries for the week, surface patterns (energy crashes by day-of-week, topic that drains, etc.).
5. **Topic-progress visualization** — chart showing % of week's checkboxes done over time, or % of total cards covered per Hot Rod topic.
6. **Anki deep-links** — clickable links to specific Dermki subdecks (if mobile Anki supports URL handlers).
7. **Search / filter** — quick way to find a specific day or topic in the schedule.
8. **Week navigation in URL** — e.g., `?week=4` to deep-link.
9. **Mobile-optimized layout** — current design is responsive but not mobile-first.

### Already built (cross off pending list)

- ✅ **Per-day energy + journal in week rows** — every day has its own journal text field and energy buttons; today's card and week-row data sync via `syncDOM`.
- ✅ **Today/week-row sync** — clicking a checkbox in either location updates both immediately.
- ✅ **Per-week progress badge** — header shows "X/Y" of checkboxes done per week.

---

## Open decisions / things to revisit

- **W11 sequencing** — currently CtB §1 Fri / §2 Sat / PE#1 Sun. Could swap to PE#1 first if user wants the harder/longer test on most-rested day.
- **Vacation week intensity** — currently 1 hr/day. If user finds it too much during travel, drop to "skip days are fine, no minimum."
- **Friday interleaved Q count** — currently 25. If user is consistently skipping or rushing, drop to 15.
- **Bolognia Essentials usage** — designated as backup; may need to be cut entirely by W6 if behind.
- **Build scripts in repo?** — `build_schedule_v3.py` / `build_doc_v3.js` currently live in outputs. If they get repeatedly regenerated, may be worth committing to repo with `.gitignore` for the generated binaries.

---

## Working with this user

- **Honest > sycophantic.** They push back on weak reasoning and appreciate it.
- **Want chapter-level granularity**, not vague placeholders. ("Alikhan §4.2 pp 234-239" is right; "Alikhan Peds chs" is not.)
- **Strong preference for mixed-mode Qbank** (no topic filter during buildup, only for W12 weak-spot drilling).
- **Time-of-day split (AM Anki + PM block) is non-negotiable.** They explicitly said "I will need help keeping consistent with this."
- **Use the strategy artifacts (xlsx/docx) as long-form source of truth**; the live tracker is the daily UI, but the xlsx is the version with full notes and rationale.
- **They have a GitHub Pages site live and a Supabase project provisioned.** The infrastructure is real; don't redesign from scratch unless asked.
