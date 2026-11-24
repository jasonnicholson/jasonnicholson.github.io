---
name: run-animation-batch
description: "Use when asked to run, continue or finish a batch of the numerical-methods animation plan (plans/numerical-methods-animation-plan.md), e.g. \"run batch 1\", \"do the next animation batch\", \"resume batch 4\". Directs the whole batch end to end: writes the text of skeleton pages (content-page), builds the animations (animation-page), reviews them independently (review-animations), fixes and re-reviews until no Error or Misleading findings remain, and commits each step on a batch branch. Not for a single quick GIF fix (use animation-page directly)."
argument-hint: "<batch number> | next"
---

# Batch director: numerical-methods animation plan

You are directing one batch of the plan in `plans/numerical-methods-animation-plan.md` for the Numerical Methods section of jasonhnicholson.com. You plan, hand each page to subagents, read their work as evidence, commit, and report. You do not write pages yourself; your judgment is spent on checking.

**Batch for this run:** $ARGUMENTS

If that is empty or a placeholder, take the batch from the user's message. `next` means the lowest-numbered batch whose pages are not all done (a page is done when it is a folder with an `## Animations` section, or, for a "—" page, when it has no "(Planned)" sections). If nothing settles it, ask.

## Why this is set up the way it is

The first 53 animation pages were built quickly and then needed nine independent review rounds, because almost every error was a plausible number or sentence that nobody computed. The skills now carry what those rounds taught: the **Accuracy standard** in `animation-page`, the same standard for text in `content-page`, and an independent `review-animations` with planted-error calibration. This director exists to make sure each step actually happens and is evidenced, rather than claimed.

## Ground rules

- **Git.** Start from an up-to-date `main` with a clean tree. Create the branch `batch-<N>` (or check it out to resume). Record `git status --porcelain` as the baseline; anything already uncommitted is not yours and is never staged. Only you commit; subagents never run state-changing git commands. Stage paths explicitly (never `git add -A` or `git commit -a`). Do not push and do not merge into `main`; Jason does that, or asks you to. End commit messages with the attribution line your harness gives.
- **No MATLAB, anywhere.** Every brief you write says "Do not run MATLAB." Jason's standing rule; the Padé page invites it.
- **Subagents do not run quarto.** You render.
- **Concurrency.** At most 20 subagents at once. One subagent per page. Pages are disjoint folders, but `pages/numerical-methods/index.qmd` is shared: subagents never edit it; you make the index link changes yourself (flat `<slug>.qmd` → `<slug>/`).
- **Environment.** Leave the global Julia environment alone (Plots 1.41.2 and SpecialFunctions 2.7.2 on 2026-11-24). If a page needs a package that is not installed, stop and ask Jason; do not add it. Python for checks: `/usr/bin/python3` (numpy, scipy, sympy, mpmath).
- **Scratch.** All experiments, instrumented copies, frames and ledgers live in the session scratchpad (or `$TMPDIR` if there is none), never in the repository. Put each subagent's work in `$WORK/<slug>/<role>/`.
- **Archive.** `/home/jason/Desktop/math-fullerton/baseline/mathews/` (`n2003/` modules, `a2001/Animations/` animations, `c2003/` complex analysis). It is a reference for intent, not ground truth.
- **Privacy.** Send no project or personal details to outside services.

## Phase 0: set up

1. Read the plan, find the batch's pages and their "Page text" and "Legacy animation" entries.
2. Read the three skills you will hand out, so your briefs match them: `.github/skills/content-page/SKILL.md`, `.github/skills/animation-page/SKILL.md`, `.github/skills/review-animations/SKILL.md`.
3. Check the machine: committed GIFs are real image data (`file`), not LFS pointers (`git lfs pull` if they are); Plots and SpecialFunctions load; one existing script copied to scratch reproduces its committed GIF byte for byte. If the frames differ, stop and tell Jason.
4. Make the scratch folder `$WORK`.

## Phase 1: text for skeleton pages

For each batch page whose text is a skeleton, give a fresh subagent:
- the page path and its archive module (from the plan or the page's legacy stub);
- the instruction to read `.github/skills/content-page/SKILL.md` and follow it in full, including its Accuracy standard and claim ledger, and to open the page with `## Description` because the page will be animated;
- its scratch folder and ledger path; no git, no quarto, no MATLAB, no edits outside its page.

When it reports, read the ledger as evidence: a number with no recorded computation is not done, so send it back with what is missing. Spot-check one or two numbers yourself. Render the page and commit it ("Write <title> page text (batch <N>)").

## Phase 2: animations

**Pilot first.** Build one page alone, preferably the one with a surviving legacy animation or the most typical of the batch. Brief the subagent to read `.github/skills/animation-page/SKILL.md` and follow it in full for this one page, with these overrides: do not edit `pages/numerical-methods/index.qmd` (you do), do not commit, do not run quarto. Give it the page path, the legacy entry from the plan, its scratch folder, the ledger path, the frame tool (`.github/skills/animation-page/scripts/giftools.jl`) and the Python path.

Read the pilot critically before launching the rest:
- Is every number and behaviour sentence in the ledger backed by a recorded computation?
- Did it look at first, middle and last frames, and do the labels use significant figures, with no silent clamping?
- Does the Animations introduction say what is not animated, or that the animation is new?
- Does every GIF regenerate byte-identically from its script?

If something is missing, fix the brief and redo the pilot. Then launch the remaining pages in parallel with the corrected brief. For each finished page: make the index link change, check `git status` shows only that page's files (and the index), render it, and commit ("Add <title> animations (batch <N>)").

## Phase 3: independent review

Invoke the `review-animations` skill with `batch=<N> out=reviews/batch-<N>`. Add one instruction to it: because this batch's page text was written in Phase 1, each reviewer's claim ledger covers the **whole page**, including the worked examples, not only the Animations section and Description. The review commits nothing; when it finishes, commit its report folder ("Add batch <N> review").

## Phase 4: fix and re-review

For each page with findings, give a fresh fixer subagent the page's findings copied in full from the report (with any independent-check corrections, which take precedence), and the instruction to fix them under `animation-page` step 15 and its Accuracy standard: reproduce each finding before changing anything; fix it or record it as not reproduced with evidence; every changed sentence or number goes in a ledger with its computation; regenerate any changed GIF and confirm only expected files changed. Minor findings are fixed when reproduced; a purely cosmetic one may be deferred with a reason.

Then give a **different** fresh subagent the original findings and the page's `git diff`, but not the fixer's ledger or reasoning, and ask it, for each finding, whether it is resolved, partly resolved or not resolved, by its own computation and its own look at the frames, plus any new problem in the changed text or GIFs. A checker shown the fixer's argument tends to agree with it; that is why it does not get it. If anything is unresolved, send the checker's notes back to the same fixer and check again; after two failed rounds, stop on that finding and leave it for Jason.

Commit each page once its check passes ("Fix <title> (batch <N> review)"). Then run `review-animations` again on the pages that changed, into `reviews/batch-<N>-r2` (then `-r3`, …), and repeat until a round has no Error or Misleading findings.

**Decisions that are Jason's.** When a fix needs a choice the skills do not settle — following Mathews against a clearer picture, adding a case, changing what a page teaches — take the smallest correct option, record it as a decision in the batch README, and tell Jason. Do not wait on him unless the choice would change what the page teaches.

## Phase 5: finish

1. Render the whole section: `quarto render pages/numerical-methods/`; it must complete without errors.
2. Mark the batch's pages done in `plans/numerical-methods-animation-plan.md` (a short status note per page) and write `reviews/batch-<N>/README.md`'s closing section: pages built, findings by round and severity, what was fixed, what is open and why, decisions taken for Jason to revisit, commits made.
3. Commit those, confirm with `git status` that nothing is left uncommitted that belongs to the batch and that no pre-existing change was staged.
4. Tell Jason in a few sentences: what was built, the final review round's numbers, anything open or decided on his behalf, the branch name, and that it is ready to merge into `main` (after merging he has previously removed the `reviews/` folder in a separate commit, keeping it in history).
