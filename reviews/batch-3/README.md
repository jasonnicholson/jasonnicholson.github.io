# Batch 3 review, round 1

**Pages reviewed: 3 of 3** (Steepest Descent - Gradient Search, Nelder Mead Method, Powell's Method). None skipped.

**Findings: 1 Error, 0 Misleading, 5 Minor.** The Error was confirmed by an independent checker given only the allegation; the Minor findings are reported unverified. No implementation or drawing error on any page: every script runs the method its page names (Mathews' own line search on the gradient page, his `Nelder2D` subroutine rule on the Nelder-Mead page, the basic Powell method and the taxi-cab method on the Powell page), every iterate and table cell matches an independent implementation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page (worked examples, tables, theorems, implementation notes), not only the Animations section and Description. The legacy Mathews archive was found at `/home/jason/Desktop/math-fullerton/baseline/mathews/` and every reviewer consulted it.

## Calibration

Powell's Method was the pilot. Its reviewer worked on a scratch copy with two planted errors in the Case 1 and Case 2 Behavior paragraphs (a distance wrong in the third significant digit, 0.03594 for 0.03494, and a false "stops short of P₂" for a dog-leg search with γ = 706/511 > 1) and reported both as Errors with its own computations. The brief was not changed. The planted findings are not in this report; the real page's versions of those two sentences were confirmed by the same reviewer's computations, and that review stands as the Powell review.

Reviewers in this harness cannot write report files, so they returned their reports as text and the director wrote the page files.

## The findings worth reading first

- **Steepest Descent F1 (Error, confirmed):** Example 3 says that with Mathews' work counter removed, runs (ii) and (iii) need 111 and 91 iterations. Two independent implementations give 113 and 103, stable from about 100 to 2000 digits; below about 100 digits the count wanders (103–115, 102–108), 111 appears only at 200 bits and 91 at no precision tried. The Description's "agrees with a 120-digit run to more than 50 digits" fails for these two runs.
- **Steepest Descent F2 (Minor):** the exact-line-search theorem assumes "an exact local minimiser", which does not guarantee descent (counterexample cos 2πx − 3x); it should be the first local minimiser or a global one.
- **Nelder-Mead F1 (Minor):** "his pictures are the mirror images of these frames" is true per triangle, not per cumulative picture.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [powells-method](powells-method.md) | 3 | 3 | 0 | 0 | 1 | reviewed (calibration pilot) |
| [steepest-descent-gradient-search](steepest-descent-gradient-search.md) | 4 | 4 | 1 | 0 | 2 | reviewed; Error confirmed |
| [nelder-mead-method](nelder-mead-method.md) | 3 | 3 | 0 | 0 | 2 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Steepest Descent F3 (Minor): Mathews' Qmin also leaves its bracketing loop when the trial step falls below δ; the page and scripts omit this exit. It never triggers in any run on the page.

## Patterns

- **Counts and agreement claims from runs that are not robust.** Steepest Descent F1: the iteration counts came from a run whose end depends on rounding at the 10⁻¹⁴ level, and the precision-agreement sentence was checked only on the tabulated runs. A count that ends on a threshold crossing needs a precision study, like any other number.
- **Statements about Mathews' pictures** (Nelder-Mead F1) were again the weakest wording, as in batch 2: a fact correct for one element (a triangle) was stated for the whole picture.
- **Theorem hypotheses** (Steepest Descent F2): a general statement with a slightly too weak condition.
- **Quoted bounds just exceeded** (Nelder-Mead F2: 2.04e-7 against "within 2e-7").

## Phase 1 inventory

All 10 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 10 committed GIFs byte for byte. Every page reference resolves, no file on disk is unreferenced, and the section index links all three pages. Pre-existing uncommitted changes when the run started: the Phase 1 text and Phase 2 work of later batches (4–8), which the batch director keeps out of batch 3's commits; none touch batch 3's pages.

---

# Batch 3: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Steepest Descent - Gradient Search](../../pages/numerical-methods/steepest-descent-gradient-search/) | written from `GradientSearchMod`: Examples 1–4 with tables recomputed with Mathews' own line search in 60-digit arithmetic; Example 5 (his drawing program) described only, its inputs and output being lost | 4 new animations (Examples 1–4), three panels each: path on a contour map, zoom on the current search, φ_k with the parabola fit and the exact line minimum |
| [Nelder Mead Method](../../pages/numerical-methods/nelder-mead-method/) | written from `NelderMeadMod`: both rule sets (textbook Table 8.5 and his `Nelder2D` subroutine), all examples in exact arithmetic; Example 2's run is the page's own (Mathews' is lost) | `nelderaa` animates Mathews' 16 static Example 4 pictures; `nelderbb` (Rosenbrock) and `neldercc` (Exercise 3) new |
| [Powell's Method](../../pages/numerical-methods/powells-method/) | written from `PowellMethodMod`: all eight examples, exact fractions for the quadratics | `powellaa`, `powellbb` rebuild Mathews' Animations 1 and 2 from his surviving Example 7 and 8 plotting programs; `powellcc` (Rosenbrock) new |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in each review round's Phase 1). Powell's Method was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-3` | 1 | 0 | 5 | Powell (2 of 2) |
| 2 | `reviews/batch-3-r2` | 0 | 0 | 3 | Nelder-Mead (2 of 2) |

The only Error was round 1's: Steepest Descent quoted 111 and 91 iterations for two counter-removed runs; the true counts are 113 and 103, stable from 100 to 2000 digits, while lower precisions give anything from about 102 to 115. An independent checker confirmed it from the allegation alone.

## What was fixed

Every finding of both rounds was reproduced by a fixer, fixed in the page text, and judged by a different checker who saw only the original findings and the diff; every check passed on the first try. No script or GIF changed after Phase 2. Round 1: the iteration counts (now 113 and 103 with a note that they need about 100 digits) and the Description's precision claim limited to the tabulated runs; the exact-line-search theorem's hypothesis (first local minimiser); Mathews' in-loop h < δ exit described, with the note that it never acts and the scripts omit it; the Nelder-Mead mirror wording and the FindMinimum bound (2.1e-7); the Powell Case 3 tangent contour's visibility, measured by pixel counts (the fixer's wording corrected the reviewer's suggestion, which was false for two frames), and a typo. Round 2: "within 10⁻⁵⁰" (absolute) for the precision claim; Mathews' hand-worked Example 6 starting at γ = 0.5; the orange dog-leg colour named among the differences from Mathews.

## Open

Nothing at Error, Misleading or Minor level. One cosmetic note from the last checker, not a finding: Powell's dashed current-search line is also an addition to Mathews' pictures, not named among the differences (the page describes it without attributing it to Mathews).

## Decisions taken for Jason to revisit

1. **Branches are stacked.** Batches 3–9 were run in one session; `batch-4` starts from `batch-3`'s tip, and so on, so they can be merged in order (or `batch-9` alone). `batch-3` also contains Jason's own commit `2ba2546` (status note on the section index), made on this branch during the run.
2. **The three "lost" Mathews animations were probably never made.** `Gradientaa.html`, `Nelderaa.html`, `Powellaa.html` and `Powellbb.html` show only the archive's "Under Construction" banner and no GIF (by contrast, `GoldenRatioaa.html` still references its lost GIF). The pages say it is not known whether Mathews made them, and the plan rows now say so.
3. **Nelder-Mead follows exact arithmetic, not Mathews' floating-point run.** At step 6 of his Example 1/4 the reflected point and the worst vertex tie exactly (f = −5.88); exact arithmetic contracts, his run reflected, and from then on his triangles are mirror images through (3, 2) of the exact ones one step later. The page explains this.
4. **Nelder-Mead Example 2 (Rosenbrock) uses the page's own starting triangle**, since Mathews' images for it are lost.
5. **Steepest Descent tables follow the exact-arithmetic run**, correcting the stale first row of every Mathews table and his Example 4 rounding artefacts.
6. **Steepest Descent scripts omit Mathews' in-loop h < δ test**, which never acts in any run; the page says so (adding it would change nothing in any GIF).
7. **Two GIFs are just over the 3 MB target:** `gradientcc.gif` (3.2 MB, three runs in 41 frames) and `nelderbb.gif` (3.1 MB, 84 frames).
8. **Powell cites Powell (1964) in plain text**, since `references.bib` has no entry and the writers do not edit it.

## Process notes

- Subagents in this harness cannot write report files; reviewers returned reports as text and the director wrote them.
- MATLAB was not run anywhere; quarto was run only by the director. `quarto render pages/numerical-methods/` completed without errors (exit 0) after the last fix; its only warnings are section-index links to later-batch pages that were moved in the working tree and are fixed in their own batch commits.
- The text of later batches was written in parallel and kept out of this branch's commits.

## Commits on `batch-3`

```
cbcc44b Record batch 3 archive paths in the plan
2ba2546 docs: Update the current status of numerical methods page   (Jason's commit)
dd33225 Write Powell's Method page text (batch 3)
c227958 Write Nelder Mead Method page text (batch 3)
03c599b Write Steepest Descent - Gradient Search page text (batch 3)
6430ddc Add Powell's Method animations (batch 3)
33178f2 Add Steepest Descent - Gradient Search animations (batch 3)
221df17 Add Nelder Mead Method animations (batch 3)
13132a4 Add batch 3 review
d75351f Fix Nelder Mead Method (batch 3 review)
6d84e7c Fix Powell's Method (batch 3 review)
a6f409d Fix Steepest Descent - Gradient Search (batch 3 review)
40ae1a0 Add batch 3 review round 2
9be03d9 Fix Steepest Descent - Gradient Search (batch 3 review round 2)
34b314b Fix Powell's Method (batch 3 review round 2)
```
plus this closing commit.
