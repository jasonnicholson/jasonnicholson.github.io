# Batch 9 review, round 1

**Pages reviewed: 7 of 7** (Frobenius Series Solution, Power Series, Circle of Curvature, Linear Programming - Simplex Method, Nonlinear Curve Fitting, Matrix Exponential, Painlevé Property). None skipped.

**Findings: 1 Error, 2 Misleading, 12 Minor.** The Error and both Misleading findings were confirmed by an independent checker who was given only the allegation. No implementation or drawing error on any page: every script runs the method its page names, every value checked matches an independent computation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page. The legacy Mathews archive was consulted by every reviewer whose page has a module (Power Series has none).

**How this batch was reviewed.** Batches 6–9 were reviewed from the working tree before their pages were committed, so that batches 5–9 could be reviewed in parallel; the reviewed state of each page folder was saved and is exactly what the "Add … animations (batch 9)" commits contain. Section-index links are changed in those commits, so reviewer findings about the section index (Power Series) were withdrawn.

## Calibration

Frobenius Series Solution was the calibration page. Its reviewer worked on a scratch copy with two planted errors in Case 1 (x* = 7.319 written as 7.139, and "widens with every new partial sum" written as "narrows") and reported both as Errors from its own computations, without comparing the copy with the repository. The planted findings are not in this report; the real page's versions were confirmed by the same reviewer, and that review stands as the Frobenius review.

## The findings

- **Power Series F1 (Error, confirmed):** the left end's first quoted step, 0.4140 "between N = 15 and 18", is 0.4424 there (0.4139 is the 18 → 21 step).
- **Power Series F2:** in Example 3, "farther from N = 4 on" fails at N = 4; true from N = 6.
- **Circle of Curvature F1 (Misleading, confirmed):** the center is not "always above the parabola": it is above the tangent point on the normal, but inside the parabola only for |x| < 1/√2; the evolute crosses the parabola at (±√2, 2).
- **Circle of Curvature F2:** a script comment says ties are rounded "consistently"; the direction depends on the Float64 value (every label is a correct rounding).
- **Nonlinear Curve Fitting F1 (Misleading, confirmed):** the two Example 3 fits are not where linearization costs the most *by factor* (factors 1.23, 4.82, 4.20, 5.99); the claim holds only in absolute terms.
- **Nonlinear Curve Fitting F2 (fidelity):** Mathews' Solution 3 does have a "3 (b)" section with a graph (the power fit).
- **Frobenius F1:** Case 2 quotes the continuous rim minimum −0.4028; the animation's λ grid shows −0.4026 at most.
- **Frobenius F2:** "pink rises while cyan falls" holds only in two quarters of the period.
- **Simplex F1:** the colour key holds only for Cases 2 and 3.
- **Simplex F2 (fidelity):** alleged that Mathews' statement of Example 6 has ≤ 500 in the second constraint, so the degenerate pivot holds only for his solution page's data. **Not reproduced; see below.**
- **Simplex F3:** a `simplexbb.jl` comment miscounts frames per pivot.
- **Matrix Exponential F1:** the norm bound needs ‖I‖ ≤ 1 for the n = 0 term (fails for the Frobenius norm); convergence unaffected.
- **Matrix Exponential F2:** "every term has positive entries": the n = 0 term is I.
- **Painlevé F1:** the jump +∞ → −∞ is stated as if it held at every simple pole; it holds in Mathews' six runs, not in general.
- **Painlevé F2:** "a negative multiple" followed by the positive multiples 1, ½, e.

**Simplex F2 resolved by the director.** The reviewer read Mathews' statement image as having ≤ 500 in the second constraint, and the round-1 fix-checker agreed; the fixer recorded the finding as not reproduced. The director viewed the original image `LinearProgrammingMod_gr_440.gif` (the one both `LinearProgrammingMod.html` and Links page lnk_11 use): its first constraint has ≤ 500 and its second ≤ 300, the same data as the solution page. The page's degenerate pivot and optimum (96, 44, 44, 16), f = 1324, therefore hold for Mathews' statement as printed, and nothing was changed. The round-2 reviewer independently read the image the same way.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [frobenius-series-solution](frobenius-series-solution.md) | 3 | 3 | 0 | 0 | 2 | reviewed (calibration pilot) |
| [power-series](power-series.md) | 3 | 3 | 1 | 0 | 1 | reviewed |
| [circle-of-curvature](circle-of-curvature.md) | 3 | 3 | 0 | 1 | 1 | reviewed |
| [linear-programming-simplex-method](linear-programming-simplex-method.md) | 4 | 4 | 0 | 0 | 3 | reviewed |
| [nonlinear-curve-fitting](nonlinear-curve-fitting.md) | 3 | 3 | 0 | 1 | 1 | reviewed |
| [matrix-exponential](matrix-exponential.md) | 4 | 4 | 0 | 0 | 2 | reviewed |
| [painleve-property](painleve-property.md) | 3 | 3 | 0 | 0 | 2 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Nonlinear Curve Fitting F2: the page treats Mathews' power fit as part of 3(a), following his problem statement; his solution page heads it "3 (b)".
- Simplex F2: withdrawn (not reproduced, above).

## Patterns

- **Comparative claims whose measure is implicit** (Nonlinear Curve Fitting F1: by factor or by amount).
- **Statements about every term, pole or frame** that fail at the first or at one (Matrix Exponential F1, F2; Painlevé F1; Power Series F2).
- **Geometric words checked against the nearby object but not the named one** (Circle of Curvature F1: above the tangent point, not above the parabola).

## Phase 1 inventory

All 23 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 23 committed GIFs byte for byte. Every page reference resolves.
