# Batch 9 review, round 2

**Pages reviewed: 7 of 7** (all pages changed in the round-1 fixes: Frobenius Series Solution, Power Series, Circle of Curvature, Linear Programming–Simplex Method, Nonlinear Curve Fitting, Matrix Exponential, Painlevé Property). None skipped.

**Findings: 0 Error, 0 Misleading, 7 Minor (unverified).** With no Error or Misleading finding there was nothing for independent checking, and no further round is required. No implementation or drawing error on any page; every GIF is byte-identical to what its script produces.

This was a fresh, independent review: reviewers did not read round 1's reports or the fix records, and did not compare a page with any other copy of it. Each reviewer's claim ledger covered the whole page, and every reviewer with a Mathews module consulted the legacy archive (Power Series has none). The pages were reviewed from the working tree in their round-1-fixed state (saved and committed as the "Fix … (batch 9 review)" commits). Reviewer findings about the section index linking deleted flat files were withdrawn: section-index links change in each page's "Add animations" commit.

## Calibration

Matrix Exponential was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors in Case 2 (the final radius 0.06039 changed to 0.06309, and "counterclockwise" changed to "clockwise") and reported both as Errors from its own computations. It found nothing else, so that review stands as Matrix Exponential's round-2 review.

## The findings

- **Frobenius F1:** "the table above" is below. **F2:** "each two more terms" means one more nonzero term. **F3:** Σcₙxⁿ written for a series about a general point x₀.
- **Power Series F1:** the shaded interval stops widening once it fills the window at N = 90.
- **Circle of Curvature F1:** the off-window note applies only to the right-hand panel.
- **Linear Programming F1:** the feasible region is called a polygon/polytope without the boundedness condition.
- **Nonlinear Curve Fitting F1:** the power panel's title lists contour levels (1.1, 1.25, 1.5) below that model's minimum, which are never drawn.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [matrix-exponential](matrix-exponential.md) | 4 | 4 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [frobenius-series-solution](frobenius-series-solution.md) | 3 | 3 | 0 | 0 | 3 | reviewed |
| [power-series](power-series.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [circle-of-curvature](circle-of-curvature.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [linear-programming-simplex-method](linear-programming-simplex-method.md) | 4 | 4 | 0 | 0 | 1 | reviewed |
| [nonlinear-curve-fitting](nonlinear-curve-fitting.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [painleve-property](painleve-property.md) | 3 | 3 | 0 | 0 | 0 | reviewed |

## Comparison with round 1

None of round 1's findings came back. Each reviewer confirmed the round-1 corrections now on the page (Power Series' 0.4424 step and "from N = 6"; Curvature's inside/outside-the-parabola statement; Curve Fitting's "in absolute terms"; Matrix Exponential's operator norm and "after the first, I"; Painlevé's jump direction and k; Frobenius' rim minimum and pink/cyan wording; Simplex's colour key). The Simplex reviewer independently re-derived Example 6 from Mathews' data (second constraint ≤ 300) and confirmed the page's degenerate pivot and optimum 1324, consistent with round 1's resolution of that page's F2.
