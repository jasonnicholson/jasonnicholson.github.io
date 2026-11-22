# Fix run — numerical-methods animations (round 2)

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r2`. Nothing was pushed.

## Headline

- **All 48 pages with round-2 findings are fixed, checked and committed.** No finding is left open, and no page failed its check twice.
  - 89 findings: 2 Error, 8 Misleading, 79 Minor.
  - 88 are `fixed`, and 1 is `not reproduced`: Madsen-Reid F3, where the r0 update uses the pre-cap step length exactly as Vestermark's `newton_real` does (R2-C).
  - All 44 Fidelity findings are fixed.
- **Every page went through an independent resolution check.** The checker saw the findings and the diff, but not the fixer's record. It recomputed every changed number and sentence, looked at the regenerated frames, and reproduced every changed GIF byte for byte from a scratch copy.
  - On 10 pages the first check found a new problem in the fix. Each went back to the same fixer and was checked again: Monte Carlo π, Runge-Kutta, Euler, Lagrange + Newton (WP-B), Madsen-Reid, Improved Newton, Least-Squares Polynomials, Rational Approximation and Richardson.
  - Chebyshev went back to its fixer before its check. The fixer had reported that it left a new pole artifact.
  - The most serious problems caught this way:
    - Madsen-Reid's new §1 heading claimed quadratic convergence at multiple roots.
    - Lagrange Case 03 became unreadable after the wider window.
    - Richardson's note said Example 8 was not animated, although Case 2 is Example 8's estimate.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **The legacy Mathews archive was used on every page** (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` and `a2001/Animations/`). Each fix record says what it showed.

## How your round-2 decisions were applied

- **R2-A (follow Mathews' case parameters and picture elements; one sentence when whole examples are left out):** applied wherever a finding called for it.
  - Case functions, intervals and windows changed to Mathews' on these pages: Maclaurin/Taylor (M10, T08–T12), Bézier (now Examples 3 and 4), Legendre Case 2 (Example 8(b)), Tangent Parabola (sin x at x₀ = 1), Chebyshev (Cases 02, 03, 04, 29 and windows), and Newton/Lagrange (Cases 01–03, 07).
  - Picture elements changed to Mathews' on these pages: Simpson's red sample dots and panel dividers, Midpoint's sample counts and red dots, and Gauss-Legendre's weight-by-sample bars.
  - Stale "legacy GIF missing" notes were corrected.
  - The "not animated here" sentence follows the Monte Carlo pattern: it names the examples by kind, contains no numbers, and every part was checked against the archive's statement and solution images.
- **R2-B (ODE pages use Mathews' step-refinement sweep):** applied to Euler, Runge-Kutta, Taylor and ABM.
  - Each frame is a full run at one m, with the true y(5) and the error.
  - The stability shading marks h·|∂f/∂y| above the method's limit.
- **R2-C (Madsen-Reid follows `newton_real`):** the three scripts now follow Vestermark's algorithm:
  - the stage test;
  - Stage 2 as plain Newton with Adams' bound;
  - the halving search with the rotated half step;
  - `alterdirection` (0.6 + 0.8i);
  - r0 = 5 × the pre-cap length.

  Checkers compared the iterates bit for bit with an instrumented, compiled copy of the reference C++. That copy was kept in scratch; nothing from `Newton_Real.cpp` was copied into the repository.
- **R2-D (Modified Euler = midpoint):** applied on the Euler page.

## For you to decide or revisit

- **Where the R2-A note sits.** The pattern from the Monte Carlo page put the "not animated here" sentence at the end, after the last case's embed, as a statement about the source. Several later checkers said that placement reads as part of the last case. So the pages are now mixed:
  - In the Animations intro, before Case 1: Improved Newton, Least-Squares Polynomials, Rational Approximation, Richardson.
  - After the last embed: Accelerated Newton, Aitken/Steffensen, Aitken/Neville, Bézier, Broyden, Catenary, Cubic Splines, Halley, Hermite, Monte Carlo π, Nonlinear Systems, Numerical Differentiation, Tangent Parabola.
  - In the Description: 2D Trapezoidal/Simpson.

  I did not churn the committed pages. If you want one placement everywhere, say which. The intro is the clearer choice.
- **Taylor method:** Mathews' derivative formulas use sign(y)|y|^{k/3}. For even k that is wrong once y < 0, so some of his printed y(5) values for coarse m differ from a correct run.
  - The page keeps the real cube root and says so.
  - The checker reproduced all 9 affected archive values from Mathews' formula.
  - Other ODE pages where y goes negative may carry the same caveat.
- **D2's sentence is method-dependent.** "From then on errors are amplified" is false for ABM4 PECE here: runs at m = 100–150 cross the linear bound and stay accurate.
  - The ABM page now calls h = 0.0311 a linear, frozen-coefficient bound, not an accuracy threshold.
  - You may want to qualify D2 in `fix-plan/README.md`.
- **Bézier:** the old S-curve case with an inflection is gone, because neither of Mathews' examples has one. The fix record gives the alternative: keep the old cases and add a note.
- **Lagrange/Newton Cases 02 and 03:** the node intervals were inferred (mirror of Case 01, and same as Case 01), because Mathews' legacy GIFs for those cases are missing.
- **Legendre:** the archive's solution images for Example 8(b) (gr_336–345) are missing, so Mathews' order and plot for that case could not be checked. No "not animated" sentence was added, because the finding did not ask for one.
- **Boole's rule:** Mathews' Examples 1–10 (other integrals) are neither animated nor mentioned. No finding named them, so no note was added.

## Found but not changed

These are pre-existing and not round-2 findings:

- **Secant:** frames 8–10 of the `cc` GIF show no secant line. The iteration stops once p₈ = 0.0 in Float64.
- **Simpson's 3/8:** frame labels drop trailing zeros (2.01581, where Mathews shows 2.015810).
- **Catenary:** the archive prints the length as 24.0869; the correct value is 24.1882. The archive number is not on the page.
- **Animation pages without a `## Description` heading** (checked at the end of this run): Bisection, Catenary, Regula Falsi, Fixed-Point, Legendre, Muller, Newton-Raphson, Runge-Kutta, Secant, Taylor method and Tangent Parabola.
- **Chebyshev Case 14:** this is the one change beyond the findings. Its asymptote lines through the poles of tan went away with the same `poles` setting that fixed the new artifact in Cases 01 and 02.

## Method notes

- **Briefs.** Each fixer brief carried:
  - the page's findings, verbatim;
  - decisions R2-A–D, plus D1, D2, D5 and D7 where they applied;
  - the archive location;
  - the pattern-setter outputs: the R2-B sweep from Runge-Kutta, the R2-A note from Monte Carlo, the picture elements from Simpson, and the exact Taylor-coefficient routine from Padé;
  - the full Fix standard.
- **Checker briefs** carried the findings, the diff and the Resolution check standard, but not the fixer's record.
- **Director notes:** on Numerical Differentiation and Tangent Parabola, the checker's only new item was the cross-page placement point above. It was recorded with a director note, and the page was not sent back.
- **Tooling fix:** commit staging now waits for `.git/index.lock`, after one race with a read-only git command during the Muller commit.

## Commits (47, oldest first)

One commit per page, and one for WP-B (Lagrange + Newton, `54b24ac`):

`2eebdb9 a00bf75 6aa114f b7eeefa c56dc2e faedaee 3c7cce4 be86c98 cb25481 3899baf ac41260 4549690 8f6992d 4a0a86d 749e176 44b2f18 e08e37d 0266a33 89af723 4880877 266f4c4 2661f21 d07140e 4bb12d1 c9d2236 d71c9bc 1897ef9 f2e3187 d93f324 89e9e74 c2269c6 6caed91 75134e3 cd90040 b009330 954326c 7b89cd8 7423bc5 fb1b5ce 54b24ac b8bd238 4f9e3cc 955d7ad 2bd3ad3 c43a4a2 4a0ebb5 33b9193`

`git log --oneline bdb068e..HEAD` lists them all. This README is in the last commit.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r3`.
