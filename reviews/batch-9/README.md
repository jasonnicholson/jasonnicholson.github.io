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

---

# Batch 9: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Frobenius Series Solution](../../pages/numerical-methods/frobenius-series-solution/) | written from `FrobeniusSeriesMod`, 10 examples; Mathews' plot data for Examples 1–5 is lost | 3 new: both Frobenius solutions of Example 1, the rim condition J₀(λ) = 0, the drum's normal modes |
| [Power Series](../../pages/numerical-methods/power-series/) | written from standard sources (no Mathews module): Airy, Legendre and a third example | 3 new: Airy's equation, Legendre's equation with p = 1, a series about 0 and about 1 |
| [Circle of Curvature](../../pages/numerical-methods/circle-of-curvature/) | already written; the builder fixed seven broken `\tag`s and a table header | 3: a rebuild of Mathews' collocation-circle animation (which survives as still frames in the module), the osculating circle on y = x² and on the cardioid |
| [Linear Programming-Simplex Method](../../pages/numerical-methods/linear-programming-simplex-method/) | already written; the builder noted where Mathews' statement and computation differ in Examples 1 and 3(b) | 4 new: the level line swept across the region, the simplex tableau path, one region with two objectives, Example 5 in three variables |
| [Nonlinear Curve Fitting](../../pages/numerical-methods/nonlinear-curve-fitting/) | written from Mathews' `NonLinearCurveFitMod` (the plan's path was a placeholder); Example 2's data reconstructed | 3 new: the exponential and power fits by data linearization, Gauss–Newton from the linearized fits |
| [Matrix Exponential](../../pages/numerical-methods/matrix-exponential/) | written from `MatrixExponentialMod`; Example 6 follows Mathews' worked solution rather than his statement | 4 new: the partial sums of Example 1, Mathews' solution families of Examples 3, 4 and 5 |
| [Painleve Property](../../pages/numerical-methods/painleve-property/) | written from `PainlevePropertyMod`; Examples 1, 3a, 5 and 10 images are lost | 3 new: a pole on a grid point, two poles of y' = 1 + y², two poles of a Riccati equation |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in each review's Phase 1). Frobenius Series Solution was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-9` | 1 | 2 | 12 | Frobenius Series Solution (2 of 2) |
| 2 | `reviews/batch-9-r2` | 0 | 0 | 7 | Matrix Exponential (2 of 2) |

Round 2 found no Error or Misleading findings, so the loop ended there.

## What was fixed

Every finding of both rounds was reproduced and either fixed or recorded as not reproduced, and judged by a different checker who saw only the findings and the diff.

- **Round 1.** Power Series: the left end moves 0.4424 between N = 15 and 18 (Error; the fixer kept the frames and corrected the number); "from N = 6 on". Circle of Curvature: the center is above the parabola only for |x| < 1/√2, the evolute crossing it at (±√2, 2) (Misleading); the rounding comment in the script (its GIF regenerates byte for byte). Nonlinear Curve Fitting: "costs the most" made explicitly absolute, with the factors given (Misleading); Mathews' "3 (b)" heading noted. Frobenius: the rim value the animation shows; when pink rises. Simplex: the colour key; the frame-count comment; F2 not reproduced (above). Matrix Exponential: the bound stated for the operator norm; "nonnegative, and positive for n ≥ 1". Painlevé: the jump direction stated for Mathews' runs; the multiples −1, −½, −e.
- **Round 2.** Frobenius: three wording slips. Power Series: the interval stops widening at N = 90. Circle of Curvature: the off-window note applies to the right-hand panel. Simplex: Mathews' full definition of the feasible region (bounded). Nonlinear Curve Fitting: the power panel now uses its own contour levels; `nlcurvecc.jl` and its GIF changed, and the new GIF regenerates byte for byte.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Simplex F2 not reproduced:** Mathews' Example 6 statement has ≤ 300 in the second constraint (the director viewed the original image), so the page was left as it was.
2. **Power Series has no Mathews module;** the page is from standard sources and says its animations are new.
3. **Matrix Exponential Example 6** follows Mathews' worked solution where it differs from his statement; **Nonlinear Curve Fitting Example 2's data** is reconstructed. Both pages say so.
4. **Plan corrections** (recorded in the plan): Circle of Curvature's legacy animation survives as still frames in the module (rebuilt as Case 1); Nonlinear Curve Fitting's real module is `n2003/Web/NonLinearCurveFitMod/NonLinearCurveFitMod.html`.
5. **Compartment Model's link** to Matrix Exponential was changed to the folder form in this batch's Matrix Exponential commit.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director.
- As in batches 6–8, the page states were committed from saved copies after the review loop finished. With every page now in place, `quarto render pages/numerical-methods/` completed with no errors and no warnings.

## Commits on `batch-9`

```
8c45a64 Record batch 9 archive paths in the plan
9465840 Write Frobenius Series Solution page text (batch 9)
ff46dee Write Power Series page text (batch 9)
554ed45 Write Nonlinear Curve Fitting page text (batch 9)
0aea228 Write Matrix Exponential page text (batch 9)
b2f202b Write Painleve Property page text (batch 9)
6eb422b Add Frobenius Series Solution animations (batch 9)
f020e2e Add Power Series animations (batch 9)
3ff1382 Add Circle of Curvature animations (batch 9)
5f53ac3 Add Linear Programming-Simplex Method animations (batch 9)
ffbda55 Add Nonlinear Curve Fitting animations (batch 9)
3c6b181 Add Matrix Exponential animations (batch 9)
45ec1f7 Add Painleve Property animations (batch 9)
3d3604e Add batch 9 review
9c6155e Fix Frobenius Series Solution (batch 9 review)
03cd782 Fix Power Series (batch 9 review)
3c7ab68 Fix Circle of Curvature (batch 9 review)
05e70a0 Fix Linear Programming-Simplex Method (batch 9 review)
7977daa Fix Nonlinear Curve Fitting (batch 9 review)
db71a95 Fix Matrix Exponential (batch 9 review)
331dd89 Fix Painleve Property (batch 9 review)
eacc0ee Add batch 9 review, round 2
f4ce893 Fix Frobenius Series Solution (batch 9 review, round 2)
6cd6989 Fix Power Series (batch 9 review, round 2)
274c9f1 Fix Circle of Curvature (batch 9 review, round 2)
8ba4c76 Fix Linear Programming-Simplex Method (batch 9 review, round 2)
e3db08c Fix Nonlinear Curve Fitting (batch 9 review, round 2)
```
