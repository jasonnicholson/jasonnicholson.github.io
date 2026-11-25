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
