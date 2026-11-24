# Fix run — numerical-methods animations (round 9)

Run of 2026-11-24 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r9`. Nothing was pushed.

## Headline

- **Round-9 findings:** 3 Minor. There were no Error or Misleading findings.
  - **2 are fixed**, across three pages.
  - **1 is deferred** under your earlier decision R6-D: Maclaurin F1, the order cutoff. The Maclaurin page is unchanged.
  - No finding was `not reproduced` and none is `open`. Both fixers reproduced their finding before changing anything.
- **Both fixes passed an independent resolution check at the first attempt.** The checkers saw the findings and the diff, but not the fixer's record.
- **Every GIF on the changed pages reproduces byte for byte from a scratch copy of its script.**
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **One GIF changed:** `newtoncc.gif`. The section still has 261 GIFs.

| Severity | Findings | Fixed | Deferred |
|---|---|---|---|
| Error | 0 | 0 | 0 |
| Misleading | 0 | 0 | 0 |
| Minor | 3 | 2 | 1 |

## What changed

- **[Newton-Raphson](newton-raphson-method.md) F1.** In Case 3 ($\arctan x$, $x_0 = 1.35$), the legend now formats small iterates in significant figures.
  - $x_6$ reads `2.86e-06`, where it used to read `0.0`.
  - $x_7$ reads `-1.56e-17`, where it used to read `-0.0`.
  - $x_8$, which is exactly 0.0 in Float64, reads `0 (double-precision result)`. The exact Newton iterate is about $2.5\times10^{-51}$.
  - Frames 1–6 and the page text are unchanged.
- **[Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F1, under R9-B: comment only.** Both identical copies of `lagnewt_animations_all.jl` changed.
  - The `poles` field comment no longer claims to list every pole in the window.
  - A new note on rows 24–26 explains how Γ's pole at $x=0$ is handled. Grid point 38 of the 1000-point plot grid is exactly 0.0, and `gamma(0.0)` is `Inf`, which the script turns into a break.
  - The checker tested each claim, including that a 1001-point grid would draw a vertical segment at $x \approx 0$.
  - All 58 GIFs on the two pages are unchanged.

## For you to decide or revisit

- **R9-B is the director's default.** If you want the robust fix instead, add `poles=[0.0]` to rows 24–26. That would also take those cases' y-limits from f on the node interval; for Case 24 they change from (−17.6, 37.3) to (−2.7, 21.8). Six GIFs would change, three on each interpolation page.
- **Maclaurin F1** stays deferred under R6-D. Rounds 7 to 9 have each raised it again.
- **Not in scope:** the review's "Noted by reviewers, not counted" items were left alone.
- **The round-9 review report is not committed.** Its page reports and README are untracked. This folder's `fixes/` and `fix-plan/` are committed.

## Process notes

- **No MATLAB.** Every fixer and checker brief said not to run it, and none did.
- **The legacy archive was found.** Neither fix depended on it.
- The round-9 Padé reviewer had left a background task running after delivering its report. It was stopped during this run and had made no repository changes.

## Commits (4, oldest first)

`21ab538` (decisions R9-A and R9-B), `eda17a1` (Newton-Raphson), `a7a232f` (Lagrange and Newton Interpolation). This README is in a separate commit after these.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r10`.
