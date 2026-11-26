---
name: run-animation-batch
description: "Use when asked to run, continue or finish a batch of the numerical-methods plans (batches 1–14 in plans/numerical-methods-animation-plan.md, batches 15 and later in plans/numerical-methods-light-pass-plan.md), e.g. \"run batch 1\", \"do the next animation batch\", \"resume batch 4\". Directs the whole batch end to end: writes the text of skeleton pages (content-page), builds the animations (animation-page), reviews them independently (review-animations), fixes and re-reviews until no Error or Misleading findings remain, and commits each step on a batch branch. Also runs the plan's text-only batches (content-page plus a text-only review, no animations), and the light pass's overview batches (content-page in overview mode on existing animated pages, reviewed in overview mode). Not for a single quick GIF fix (use animation-page directly)."
argument-hint: "<batch number> | next"
---

# Batch director: numerical-methods animation plan

You are directing one batch of a plan for the Numerical Methods section of jasonhnicholson.com. You plan, hand each page to subagents, read their work as evidence, commit, and report. You do not write pages yourself; your judgment is spent on checking.

**Batch for this run:** $ARGUMENTS

If that is empty or a placeholder, take the batch from the user's message. `next` means the lowest-numbered batch whose pages are not all done. An animation page is done when it is a folder with an `## Animations` section. A text-only page (its batch is marked `<N> (text)` in the plan's page table) is done when it has no "(Planned)" sections and its plan row says it is done. A batch whose plan row lists tasks besides building pages (batch 14 or batch 15, for example) is run only when it is named by number. In the light-pass plan, a page is done when its plan status says so (see "Light-pass batches"), and `next` never skips Step 2, the pilot: batches 16 and later wait until Jason has approved the pilot's format. If nothing settles it, ask.

**Which plan.** Batches 1–14 are in `plans/numerical-methods-animation-plan.md`, which is finished. Batches 15 and later are in `plans/numerical-methods-light-pass-plan.md`. "The plan" below means the one that holds this batch. A light-pass batch also follows "Light-pass batches" below, which overrides the phases where they differ.

**Text-only pages** stay flat `.qmd` files. They get no animations, they never move into a folder, and they need no change to the index. Where a phase below treats them differently, it says so. If every page of the batch is text-only, skip the Julia and GIF checks of Phase 0 and all of Phase 2.

**Batch tasks.** If the plan's "Remaining batches" row for this batch lists tasks other than building or fixing pages, such as retiring a page, changing the index, adding an alias or adding `references.bib` entries, read that row as part of the batch's definition. In the light-pass plan, the batch's "Batch <N> in detail" section plays that role (batch 15 changes the index):
- You make the index, alias, folder and `references.bib` changes yourself.
- Page edits go through the skill the row names.
- Commit each task separately, with a message that names it.

**Light-pass batches (15 and later).** The light pass gives each of the 53 pages built before batch 1 a `## Description` to the plan's overview standard, and adds a few new pages and animations. Each page in the batch table is marked with an action:
- *write*, *extend* or *check*: an **overview page**. It is an existing animated folder. Only its Description is written or extended, by `content-page` in overview mode; its animations stay as they are.
- *new*: a **new page** or **new animations**, as the plan's batch section describes. A new page gets its Description in overview mode and its animations from `animation-page`, both reviewed in full. A page marked *extend, plus N new animations* (Numerical Differentiation in batch 15) is an overview page whose new cases are built in Phase 2.

The plan names pages by title. Find each slug from `pages/numerical-methods/index.qmd`. A light-pass page is done when its Description meets the overview standard, its last review round found no Error or Misleading findings, and the plan's Status section says so. The light-pass plan's Step 2 pilot is run the same way, as a two-page overview batch on the branch `light-pass-pilot` with its review in `reviews/light-pass-pilot`, and it stops after Phase 5 for Jason to check the format. The two pilot pages (Newton-Raphson and Simpson's Rule) count as done in batches 16 and 20 once Jason has approved them; skip them there.

For a new page that has no file yet, you create a flat `pages/numerical-methods/<slug>.qmd` with only its front matter (`title`, `bibliography: ../../references.bib`), the back link and the source line, as the earlier skeletons had, and link it from the index as the plan's batch section says. Commit that with the other index changes before Phase 1.

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

1. Read the plan, find the batch's pages and their "Page text" and "Legacy animation" entries. In the light-pass plan, read the batch's row of the table, its action per page, and its "Batch <N> in detail" section if it has one.
2. Read the three skills you will hand out, so your briefs match them: `.github/skills/content-page/SKILL.md`, `.github/skills/animation-page/SKILL.md`, `.github/skills/review-animations/SKILL.md`.
3. Check the machine (for a light-pass batch with no new animations, the LFS check alone is enough, since reviewers still look at the committed frames): committed GIFs are real image data (`file`), not LFS pointers (`git lfs pull` if they are); Plots and SpecialFunctions load; one existing script copied to scratch reproduces its committed GIF byte for byte. If the frames differ, stop and tell Jason.
4. Make the scratch folder `$WORK`.

## Phase 1: text for skeleton pages

For each batch page whose text is a skeleton, give a fresh subagent:
- the page path and its archive module (from the plan or the page's legacy stub);
- the instruction to read `.github/skills/content-page/SKILL.md` and follow it in full, including its Accuracy standard and claim ledger. A page that will be animated opens with `## Description`; a text-only page does not, and it stays flat;
- its scratch folder and ledger path; no git, no quarto, no MATLAB, no edits outside its page.

When it reports, read the ledger as evidence: a number with no recorded computation is not done, so send it back with what is missing. Spot-check one or two numbers yourself. Render the page and commit it ("Write <title> page text (batch <N>)").

**Overview pages (light pass).** Phase 1 runs on every page of the batch, not only on skeletons. Brief each subagent to read `.github/skills/content-page/SKILL.md` and follow it in **overview mode**, and give it:
- the page path, its action (*write*, *extend* or *check*) and its archive module;
- for a new page, what the plan's batch section says about its content and sources, and any one-line links to it that the plan asks for on other pages (those pages are then in its scope, for that line only);
- its scratch folder and ledger path; no git, no quarto, no MATLAB, and no edits outside the Description except the moves and links the skill allows.

Read its ledger as above. Also check:
- that `git diff` on the page touches only the Description, ledgered moves out of the Animations introduction, and links;
- the word count of the Description's prose (150–400);
- that each of the six points is there.

A subagent may report that another section of the page contradicts the new Description. Do not have it fixed silently: record it in the batch README for Jason, and fix it in Phase 4 only if the review confirms it as a finding. A *check* page that already met the standard has nothing to commit; note it in the README. Commit each changed page ("Write <title> overview (batch <N>)").

## Phase 2: animations

Skip this phase for text-only pages. In a light-pass batch, run it only for the pages and animations marked *new* in the batch table, following the plan's batch section (the legacy GIF to rebuild, its frame count, the parameters to read from its frames, and any new case it allows). A page that is already a folder keeps its existing cases unchanged; the subagent adds the new cases and updates the Animations introduction's "not animated" list as the plan says.

**Pilot first.** Build one page alone, preferably the one with a surviving legacy animation or the most typical of the batch. Brief the subagent to read `.github/skills/animation-page/SKILL.md` and follow it in full for this one page, with these overrides: do not edit `pages/numerical-methods/index.qmd` (you do), do not commit, do not run quarto. Give it the page path, the legacy entry from the plan, its scratch folder, the ledger path, the frame tool (`.github/skills/animation-page/scripts/giftools.jl`) and the Python path.

Read the pilot critically before launching the rest:
- Is every number and behaviour sentence in the ledger backed by a recorded computation?
- Did it look at first, middle and last frames, and do the labels use significant figures, with no silent clamping?
- Does the Animations introduction say what is not animated, or that the animation is new?
- Does every GIF regenerate byte-identically from its script?

If something is missing, fix the brief and redo the pilot. Then launch the remaining pages in parallel with the corrected brief. For each finished page: make the index link change, check `git status` shows only that page's files (and the index), render it, and commit ("Add <title> animations (batch <N>)").

## Phase 3: independent review

Invoke the `review-animations` skill with `batch=<N> out=reviews/batch-<N>`. Add one instruction to it: because this batch's page text was written in Phase 1, each reviewer's claim ledger covers the **whole page**, including the worked examples, not only the Animations section and Description. The skill reviews text-only pages in its text-only mode. Their ledger always covers the whole page, whether the text was written in Phase 1 or long before. In a light-pass batch, leave that instruction out: the skill reviews overview pages in its overview mode, where the ledger covers the text the batch changed, and gives new pages and new animations the full review. The review commits nothing; when it finishes, commit its report folder ("Add batch <N> review").

## Phase 4: fix and re-review

For each page with findings, give a fresh fixer subagent the page's findings copied in full from the report (with any independent-check corrections, which take precedence), and the instruction to fix them under `animation-page` step 15 and its Accuracy standard: reproduce each finding before changing anything; fix it or record it as not reproduced with evidence; every changed sentence or number goes in a ledger with its computation; regenerate any changed GIF and confirm only expected files changed. Minor findings are fixed when reproduced; a purely cosmetic one may be deferred with a reason.

For a text-only page, the fixer follows `.github/skills/content-page/SKILL.md` (its Accuracy standard and claim ledger) instead of `animation-page` step 15. The reproduce-first rule and the ledger rule are the same. The page stays flat and there are no GIFs. The fixer corrects what the findings name and does not rewrite the page around them. If the findings are so many that the page is wrong throughout, it stops and says so. Rewriting the page from the module with `content-page` is then a decision for you to record for Jason.

For a finding in an overview page's new text, the fixer follows `content-page` in overview mode, with its limits on what may be edited, and the same reproduce-first and ledger rules. A missing point of the overview standard (a Minor finding) is fixed by adding it. A finding in the page's other sections that contradicts the new Description is fixed on the side the review found wrong.

Then give a **different** fresh subagent the original findings and the page's `git diff`, but not the fixer's ledger or reasoning, and ask it, for each finding, whether it is resolved, partly resolved or not resolved, by its own computation and its own look at the frames, plus any new problem in the changed text or GIFs. A checker shown the fixer's argument tends to agree with it; that is why it does not get it. If anything is unresolved, send the checker's notes back to the same fixer and check again; after two failed rounds, stop on that finding and leave it for Jason.

Commit each page once its check passes ("Fix <title> (batch <N> review)"). Then run `review-animations` again on the pages that changed, into `reviews/batch-<N>-r2` (then `-r3`, …), and repeat until a round has no Error or Misleading findings.

**Decisions that are Jason's.** When a fix needs a choice the skills do not settle — following Mathews against a clearer picture, adding a case, changing what a page teaches — take the smallest correct option, record it as a decision in the batch README, and tell Jason. Do not wait on him unless the choice would change what the page teaches.

## Phase 5: finish

1. Render the whole section: `quarto render pages/numerical-methods/`; it must complete without errors.
2. Mark the batch's pages done in the plan (a short status note per page; in the light-pass plan, in its Status section) and write `reviews/batch-<N>/README.md`'s closing section: pages built, findings by round and severity, what was fixed, what is open and why, decisions taken for Jason to revisit, commits made.
3. Commit those, confirm with `git status` that nothing is left uncommitted that belongs to the batch and that no pre-existing change was staged.
4. Tell Jason in a few sentences: what was built, the final review round's numbers, anything open or decided on his behalf, the branch name, and that it is ready to merge into `main` (after merging he has previously removed the `reviews/` folder in a separate commit, keeping it in history).
