---
description: Direct the correction of the numerical-methods animation pages from a review report - fix each finding, verify each fix independently, commit page by page
argument-hint: "[all | <page-slug> ... | WP-<letter>] [from=<review folder>]"
---

# Fix director: numerical-methods animations

You are directing the correction of the Julia animation pages in the Numerical Methods section of jasonhnicholson.com, under `pages/numerical-methods/` in this repository. A review has already found what is wrong. Your job is to:

- plan the work,
- hand each page to a fixer subagent,
- have every fix checked by someone who did not make it,
- commit each page once it passes, and
- write the record.

**Arguments for this run:** $ARGUMENTS

Read the arguments as follows:

- **Scope:** `all` (or empty, or an unfilled placeholder), a list of page slugs (folder names such as `bisection-method`), or a work package `WP-A` … `WP-G` from the fix plan. A page whose fix record already says `committed` is skipped unless it is named explicitly, so an interrupted run can be resumed by running the same arguments again.
- **`from=<folder>`:** the review report to fix from. The default is `reviews/numerical-methods-animations` (round 1). For later rounds pass that round's folder, for example `from=reviews/numerical-methods-animations-r2`. Call this folder `$REPORT` below.

## What you are working from

- **`$REPORT/<slug>.md`:** the review of each page. Its Findings section lists each problem with its location, what is there now, what is true instead, the evidence and a suggested fix. Under each finding is the result of the independent check, sometimes with a correction that narrows or adjusts the finding. The correction takes precedence over the original wording. The claim ledger and implementation checks further down are supporting detail.
- **`$REPORT/README.md`:** the run summary and the patterns that recur across pages.
- **`reviews/numerical-methods-animations/fix-plan/README.md`:** the fix plan. It holds the principles, the work packages and their order, and the **Decisions D1–D8**. Read it at the start of every run, because Jason may have edited a decision.
  - If a decision has been edited, follow the edited version.
  - If a decision is ambiguous for a case in front of you, follow its default and note the ambiguity in that page's fix record.
- **`reviews/numerical-methods-animations/fix-plan/worklist.md`:** one row per round-1 finding, with a Status column you keep up to date.
  - For a later round, first generate a worklist of the same shape in `$REPORT/fix-plan/worklist.md` from that round's page reports.
- **`.github/agents/animation-page.agent.md`:** the conventions the pages were built with. Fixes keep them.

The legacy Mathews archive is not on this machine. Do not look for it.

## Why this matters, and the trap to avoid

The pages are public teaching material. Jason has told readers he expects errors, and he will rely on this run to remove them. The round-1 errors were mostly not crashes. They were plausible sentences and numbers that nobody computed: a root wrong in the third decimal, "converges monotonically" for a sequence that alternates, a textbook convergence order quoted for a problem that does not have it.

A fixer who rewrites those sentences from memory or intuition makes the same mistake again. So the central rule of this run is that **every number or behaviour sentence a fix adds or changes is computed, and its check is recorded.** A finding is a claim as well, even a verified one, so it is confirmed before it is acted on.

## Ground rules

- **Branch.** Work on `fix/numerical-methods-animations`. Create it from the current branch if it does not exist. Never push.
- **Only you commit.** Subagents never run state-changing git commands.
- **Never stage `.github/agents/animation-page.agent.md`.** It has an uncommitted edit that is not part of this work. Stage paths explicitly and never use `git add -A` or `git commit -a`.
- **Changes stay on their page.** A fixer changes only its own page folder: `index.qmd`, its `.jl` scripts and its GIFs. The exceptions are the section index (decision D4) and the orphan files named in decision D3, which you handle yourself.
- **Shared scripts move together.** The two copies of `lagnewt_animations_all.jl` stay byte-identical, and one fixer owns both pages (WP-B). The series scripts of WP-A follow the order in the plan: the pattern-setter's vetted coefficient routine is handed to the other two.
- **Regenerate GIFs in place.** Once a script is fixed, run it from its own folder with plain `julia <script>.jl`, so that `@__DIR__` overwrites the committed GIFs. Afterwards, check `git status -- pages/numerical-methods/<slug>` to confirm that only the expected files changed.
  - Experiments and instrumented copies still go in the scratch folder, never in the repo.
- **Leave the Julia environment alone.** Scripts run against the global environment (Plots 1.41.2, SpecialFunctions 2.9.2).
  - A fix must not add a package dependency to a script.
  - Independent checks may use `/usr/bin/python3`, which has numpy, scipy, sympy and mpmath.
- **Concurrency.** At most 20 subagents run at once. Pages are disjoint folders, so fixers on different pages can run in parallel. Never run two fixers on the same page, and never run anything on a WP-B page while the WP-B fixer is working.

## Phase 0: set up

1. Read the fix plan, the decisions and the worklist.
2. Check the branch and record `git status --porcelain` as the baseline.
3. Check that Plots and SpecialFunctions load. If they don't, stop and tell Jason; do not repair the environment.
4. For each page in scope, collect:
   - its findings from `$REPORT/<slug>.md`, with severity, kind, location and the independent-check note;
   - its inventory items;
   - its work package.
5. Make a scratch working folder `$WORK` outside the repository, using the session scratchpad.

## Phase 1: pilot

Fix the pilot pages from the plan first. For round 1 these are:

- Bisection and Newton-Raphson: text-only patterns.
- Fixed-Point: a script fix with clamped values.
- Trapezoidal: sets the D1 wording.
- Runge-Kutta: sets the D2 pattern.
- Padé: sets the WP-A coefficient routine.

Run each pilot page through Phases 2–4 below. Then read the pilot fix records and diffs critically before going further, asking:

- Did each fixer reproduce each finding before changing anything?
- Does every new sentence have a computed check in its ledger?
- Did any fixer restructure a page, add content, or quietly drop a finding?
- Did the resolution checkers actually compute anything, or only read the diff?

If any of these went wrong, fix the brief and redo the affected pilot pages. Then continue with the rest without waiting for a go-ahead. Hand each package's pattern-setter output (its D1 or D2 wording, its coefficient routine) to the other fixers in that package, so that related pages read consistently.

## Phase 2: one fixer per page

Give each page to a fresh fixer subagent. The fixer starts with nothing but your brief, so the brief must carry:

- the page folder and scratch folder;
- the page's findings, copied in full from the review, including each independent-check note;
- the inventory items, if any;
- the decisions that apply, quoted from the plan;
- any pattern-setter output for its package;
- the path for its fix record;
- the whole of the **Fix standard** section below. Hand it over in full rather than summarising it; the parts a summary drops are the parts that prevent a careless fix.

A large table-driven page may be split across fixers by case range, with one fixer owning the shared script. Only one fixer may edit a given file.

When a fixer reports back, read the fix record as evidence, not as a verdict. A record that marks a finding fixed but shows no recomputation of the new text has not established anything. Send the page back with a note saying what is missing.

## Phase 3: independent resolution check

For each page, give a fresh checker subagent three things:

- the page's original findings, exactly as given to the fixer;
- the `git diff` of the page folder against the branch's base;
- the path to the page and its scratch folder.

**Do not give the checker the fixer's record or reasoning.** A checker shown a persuasive explanation tends to agree with it. Give it the **Resolution check standard** section below in full.

The checker returns, for each finding, `resolved`, `partly resolved` or `not resolved`, with its own evidence. It also returns any new problems it found in the changed text or regenerated GIFs.

- If anything is not fully resolved or a new problem appears, send the checker's notes back to the same fixer, using SendMessage so it keeps its context, and then check again.
- After two failed rounds, stop on that page. Mark the open findings `open (failed check)` in the worklist and leave them for Jason, with both views in the fix record.
- Findings the fixer recorded as `not reproduced` go to the checker too, as allegations to test: does the original finding hold or not? If the checker finds that it holds, it goes back to the fixer.

## Phase 4: render, commit, record

For each page that passes:

1. **Check reproducibility.** Every script on the page runs from a scratch copy, and every committed GIF is byte-identical to what its script produces. Compare decoded frame hashes when bytes differ (see "Looking at frames").
2. **Render.** Run `quarto render pages/numerical-methods/<slug>/index.qmd`; it must render without errors. Output goes to the git-ignored `_site/`.
3. **Finish the fix record** at `$REPORT/fixes/<slug>.md`, adding the resolution check result and a final status line: `committed`, or `open (failed check)`.
4. **Update the worklist** Status for each finding of the page: `fixed`, `not reproduced`, `deferred` or `open (failed check)`. Link the fix record.
5. **Commit.** Stage only `pages/numerical-methods/<slug>/`, the fix record and the worklist, and commit with the message:

   ```
   Fix <page title> animation page (<round> review)

   <one line per finding: F#, severity, outcome, a few words on what changed>
   ```

   End the message with whatever attribution lines your harness specifies for commits.

Shared-code packages (WP-A, WP-B) may be committed as one commit covering their pages. D3 and D4 get their own commit after the pages they touch.

## Phase 5: finish

1. Render the whole section with `quarto render pages/numerical-methods/` and confirm it completes without errors.
2. Write `$REPORT/fixes/README.md`, leading with what Jason most needs:
   - pages fixed, pages with open findings and why;
   - counts by outcome and severity;
   - anything a decision default had to settle that Jason may want to revisit;
   - the commits made.
3. Confirm with `git status` that nothing is left unstaged in `pages/numerical-methods/` and that `.github/agents/animation-page.agent.md` was never staged.
4. Tell Jason briefly:
   - what was fixed;
   - what is open;
   - the branch name;
   - the command for the next re-review round: `/review-animations all out=reviews/numerical-methods-animations-r2`, using the next unused round number.

## Looking at frames

An image viewer shows only the first frame of a GIF, and this machine has no system ffmpeg or ImageMagick. Plots bundles ffmpeg, and this works:

```julia
# usage: julia giftools.jl <gif> <outdir>
using Plots
gifpath, outdir = ARGS
mkpath(outdir)
ff(args...) = Plots.FFMPEG.exe("-v", "error", "-y", args...)
ff("-i", gifpath, joinpath(outdir, "frame_%03d.png"))
n = count(endswith(".png"), readdir(outdir))
k = max(1, cld(n, 12)); rows = cld(cld(n, k), 4)
ff("-i", gifpath, "-vf", "select='not(mod(n\\,$k))',scale=420:-1,tile=4x$rows",
   "-frames:v", "1", "-vsync", "0", joinpath(outdir, "sheet.png"))
ff("-i", gifpath, "-pix_fmt", "rgb24", "-f", "framemd5", joinpath(outdir, "frames.md5"))
println(n, " frames")
```

Put the tool and its output in the scratch folder, not the repo. The contact sheet is enough to follow a progression. Small title and legend text is only reliably readable in the full-size frames.

## Fix standard

*This section is written for the fixer of a single page. Pass it on in full.*

You are correcting one page of a public teaching site about numerical methods: its `index.qmd`, the Julia scripts beside it, and the GIFs those scripts produce. A review found the problems listed in your brief, and an independent checker confirmed most of them. The site owner will publish what you leave behind, so each correction has to be right, not just different.

**Mathematics is the ground truth.** The review findings, the page text, the script comments and the look of a GIF are all claims, and so is anything you are tempted to write from memory. The review's errors were mostly plausible sentences that nobody had computed. Do not add new ones.

### Before you change anything

For each finding, reproduce it yourself, using an instrumented copy of the script in your scratch folder and an independent computation (sympy, mpmath or scipy via `/usr/bin/python3`, or your own Julia code).

- If the finding holds, fix it.
- If it does not hold, change nothing for it. Record it as `not reproduced`, with your evidence.
- Where the independent-check note in your brief corrects a finding, the corrected version is the one to fix.
- Minor findings were never independently checked, so be especially careful to reproduce them.

### Choosing the fix

- **If the animation is right and the text is wrong, fix the text.**
- **If the animation is wrong, fix the script and regenerate, then make the text match the new animation.** The animation is wrong when, for example:
  - it runs a different method from the one named;
  - it shows wrong values or a numerical artifact;
  - it labels a clamped value as real;
  - a label is clipped or rounded so that it shows a false number.
- **Follow the decisions in your brief.** Where a decision does not settle your case, take the smallest correct change and note the ambiguity in your record.
- **Fix the cause, not just the symptom.** Some examples:
  - A label that rounds to "0.0" needs significant-figure formatting, such as `@sprintf("%.2e", x)` with `using Printf`, which is in the standard library.
  - A title that runs off the frame needs to fit: shorten it, wrap it, or enlarge the frame.
  - A diverging iterate that the plot clamps must keep its true value in the computation and in its label; only the drawn position may be clamped, and the clamping should be visible as such.
- **Keep the page's structure and conventions.**
  - Description before Animations, a source link and an embed per case, descriptive alt text, no code blocks on the page.
  - Do not reorganise the page, add teaching content beyond what the fix needs, or touch the "(Planned)" and legacy-inventory stubs.
  - Keep the scripts' style and their `@__DIR__` output paths.
  - Add no package dependencies.
- **Stay inside your page folder.** Touch only your own page folder, and only the files your brief allows.

### Writing corrected text

- Every number you write is computed, and stated to a precision your computation supports.
- Every behaviour you describe (converges, diverges, oscillates, is monotone, is unstable, tracks the reference) is checked against the computed sequence, not against an impression of the picture.
- Describe what this animation shows for this problem.
  - A general textbook statement can stay where it is clearly labelled as general, for example "for smooth f".
  - Do not attach a general statement to a specific case it does not fit.
- Keep a case's heading, Behavior paragraph, alt text and the GIF's own title consistent with each other.
- Keep each correction short. A wrong sentence is usually best replaced by one right sentence, not a paragraph.

### Regenerating and checking the pictures

1. After fixing a script, run it from its own folder with `julia <script>.jl`. That overwrites the committed GIF, which is now intended.
2. Run `git status -- pages/numerical-methods/<your slug>` and confirm that only the expected files changed.
3. Extract the new GIF's frames into your scratch folder (see "Looking at frames" in your brief). Look at the first frame, several middle frames and the last frame at full size. Check:
   - each drawn element is built from the right quantities;
   - the titles and legends show correct numbers with the right index, legibly;
   - the feature the page describes is visible in the window.
4. If the page's text cites a frame or a value, check it against the new frames.

### Your ledger

Before you finish, go through your own diff of `index.qmd` and the scripts. List every sentence, heading, alt text, title or label you added or changed, and every number in them. Next to each, write the computation that confirms it, with the command and its output. An entry you cannot confirm is not finished: change the text or say plainly that it could not be determined.

### What to write

Write your fix record to the path in your brief, with these sections:

```
# Fix record: <slug>

## Findings
### F# — <severity> — <outcome: fixed | not reproduced | deferred>
- Reproduced: how, with command and numbers (or why it did not reproduce)
- Change: files and lines, before → after (short)
- Check: how you confirmed the fix, with command and numbers
(deferred: why, and what Jason would need to decide)

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |

## Scripts and GIFs
- Scripts changed; GIFs regenerated; frames viewed and what was checked in them
- git status of the page folder after regeneration

## Notes
(decision ambiguities, anything outside your page you noticed but did not touch)
```

Keep your scratch scripts in your scratch folder so the evidence can be re-run.

Do not commit and do not run state-changing git commands. When you finish, reply with only one line per finding (F#, outcome, a few words) and the list of changed files.

## Resolution check standard

*This section is written for the checker of a single page. Pass it on in full.*

A fixer has changed one page of a public teaching site about numerical methods to correct the findings listed in your brief. You have the original findings and the diff, but not the fixer's explanation. That is on purpose: decide for yourself, by your own computation and your own look at the frames, whether each problem is gone and whether the fix introduced anything new.

**Mathematics is the ground truth.** The diff, the page text, the script comments and the GIFs are all claims.

**Rules.** Do not modify anything in the repository. Work on copies in your scratch folder. Run scripts only from scratch copies; they write their GIFs next to themselves.

### What to do

1. **Each original finding.** Determine whether it is now resolved:
   - Is the false statement gone, and is what replaced it true?
   - Does the script now compute and show the right thing?
   - Does the GIF match?

   Answer `resolved`, `partly resolved` or `not resolved`, with your evidence. A finding the fixer did not change is either still a problem or was never one. If the diff leaves a finding untouched, say which, with evidence.

2. **Every changed line.** Build a ledger from the diff of every added or changed sentence, heading, alt text, title or label, and every number in them. Check each one by independent computation. Prefer checks that don't depend on remembering a formula: properties, convergence orders measured by step halving, residuals, high-precision references.

3. **The regenerated pictures.** Extract frames from each changed GIF and look at the first, middle and last frames at full size. Check that:
   - each drawn element is built from the right quantities;
   - labels are legible and correct;
   - nothing that was right before is now broken.

4. **Reproducibility.** Run each changed script from a scratch copy and confirm the committed GIF is byte-identical to its output. If the bytes differ, compare decoded frame hashes.

5. **Conventions.** Check that the page still keeps the conventions: Description before Animations, a source link and an embed per case, descriptive alt text, no code blocks. Check also that no file outside the page folder was changed.

### What to write

Write your result to the path in your brief, with these sections:

```
# Resolution check: <slug>
## Original findings
### F# — <resolved | partly resolved | not resolved>
- Evidence: ...
## Changed-text ledger
| Location | Text / number | Check | Verdict |
## New problems
(each with severity Error / Misleading / Minor, location, evidence; or "None", and what that rests on)
## Reproducibility and conventions
```

Reply with only: one line per original finding (F#, verdict), and one line per new problem.
