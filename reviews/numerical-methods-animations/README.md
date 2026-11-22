# Numerical Methods animations — review report

Review of the Julia animations in `pages/numerical-methods/` (run of 2026-11-20, scope: all). Nothing under version control was changed; this folder is the only addition.

The plan for correcting these findings is in [fix-plan/README.md](fix-plan/README.md), with every finding listed in [fix-plan/worklist.md](fix-plan/worklist.md).

## Headline

- **Pages reviewed: 53 of 53.** That is every page with animations: 115 Julia scripts and 280 GIFs. Nothing was skipped. The `fft-and-trigonometric-polynomials/` folder has no scripts or GIFs. The flat `.qmd` topic pages have no animations, so they are out of scope.
- **Findings: 61 Error, 37 Misleading, 76 Minor.** Only 2 pages came back clean: [Cubic Spline Quadrature](cubic-spline-quadrature.md) and [The Tangent Parabola](the-tangent-parabola.md).
- **Independent checking.** Every Error and Misleading finding was re-checked by a separate subagent. Each checker was given only the allegation, not the reviewer's reasoning.
  - All 98 were confirmed. None were refuted and none are unresolved.
  - 24 were confirmed with a correction (a narrower scope, a different count, a different line). The page file records each correction next to its finding.
  - I changed three severities on the checker's evidence:
    - Fixed-Point F4 and Madsen-Reid F3 went up to Error, because the page states the opposite of what is computed.
    - Rational Approximation F1 went down to Misleading.
  - Minor findings were not independently re-checked, and each is labelled that way.
- **The scripts compute what is shown.** All 115 scripts run cleanly. All 280 committed GIFs are byte-identical to what their scripts produce now, so no GIF is stale. Every finding about a picture is therefore about the script itself.
- **Most errors are in the page text, not the code.** Most scripts implement their method correctly. The typical error is a sentence about a value or behaviour that nobody computed.

## Look at these first

These are ordered roughly by how much they would mislead a reader.

1. **The 13 "Taylor" cases are not Taylor polynomials.** [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md), F1. `series_animations_all.jl` gets their coefficients from a least-squares fit over a wide window. In 8 of the 13 cases some coefficients have the wrong sign, and some are off by up to 287×. T04 (log x) even appears to converge past its radius of convergence. The same fitting code drives the Γ and Y₀ cases on [Padé](pade-approximation.md) (F1, about 70 of 270 frames visibly wrong) and [Laurent](laurent-series.md) (F2, minor there).
2. **Four ODE animations show an unstable artifact as if it were the solution.** All four use y′ = 1 − t·y^{1/3} on [0,5] with steps too coarse for the stiff tail: h·∂f/∂y reaches about −10 by t = 5. In every case the page says the method tracks the reference.
   - [Runge-Kutta](runge-kutta-method.md): the final y ≈ 0.289 against a true 0.00812.
   - [Euler/Heun](eulers-method-for-odes.md): Heun ends 9.5× farther off than Euler, while the page says it ends closer.
   - [Adams-Bashforth-Moulton](adams-bashforth-moulton-method.md): ends about 17× too large.
   - [Taylor Series Method](taylor-series-method-for-odes.md): the order-4 solution goes to −10.
3. **The quoted orders of convergence are wrong for the integrand shown.** Eleven integration pages use f(x) = 1 + e^{−x} sin(8x^{2/3}) on [0,2], whose derivative is unbounded at 0. Every rule therefore converges at order 5/3.
   - Error: [Trapezoidal](trapezoidal-rule-for-numerical-integration.md) (claims O(h²)), [Simpson](simpsons-rule-for-numerical-integration.md) and [Simpson 3/8](simpsons-3-8-rule-for-numerical-integration.md) (claim fourth order), [Boole](booles-rule.md) (claims sixth order).
   - Misleading: [Midpoint](midpoint-rule.md), [Romberg](romberg-integration.md), [Gauss-Legendre](gauss-legendre-quadrature.md) and [Newton-Cotes](newton-cotes-integration.md) describe fast convergence that this integrand does not give.
4. **Some animations are labelled with a method they do not run.**
   - [Muller](mullers-method.md), F1: Case 1 keeps only the real part of Muller's complex iterates, so it is a different iteration.
   - [Madsen-Reid](madsen-reid-method.md), F1–F2: the "acceleration" in the page title is not implemented, and Case 2 is plain linear Newton.
   - [Halley](halleys-method.md), F1–F2: the page and pictures use the Taylor parabola, whose root is not Halley's iterate.
   - [Riemann Sums](riemann-sums.md), F1–F2: the "Lower" and "Upper" sums use endpoint min/max, so they are not bounds. The n=1 lower sum shows 2.000 when the true value is 0.714.
   - [Brent](brents-method.md), F3–F4: the scripts run a modified variant of the method, and the Description states the wrong fallback rule.
5. **Several quoted roots are wrong.**

   | Page | Function | Page says | True root |
   |---|---|---|---|
   | [Bisection](bisection-method.md) | x³+4x²−10 | 1.3688 | 1.36523 |
   | [Regula Falsi](false-position-or-regula-falsi-method.md) | x³+4x²−10 | 1.3688 | 1.36523 |
   | [Newton-Raphson](newton-raphson-method.md) | 3eˣ−4cos x | 0.2910 | 0.25485 |
   | [Secant](secant-method.md) | 3eˣ−4cos x | 0.456 | 0.25485 |
   | [Brent](brents-method.md) | Case 1 | 0.3268 | 0.32854 |

   In every case the GIF's own final frame shows the correct value.
6. **Behaviour stated backwards.**
   - [Newton-Raphson](newton-raphson-method.md) Case 4 says x³−x+3 has no real root; it has one at −1.6717.
   - Newton-Raphson Case 5 says the iteration converges with leftward jumps; it diverges to +∞ with rightward jumps.
   - [Regula Falsi](false-position-or-regula-falsi-method.md) names the wrong fixed endpoint in both cases.
   - [Fixed-Point](fixed-point-iteration.md) Case 4 is headed "Divergent" but converges to x=0.
7. **Clamped values are labelled as real values.** In [Fixed-Point](fixed-point-iteration.md) Cases 5 and 6, iterates are clamped to the axes and then iterated from the clamped value. The GIFs label x = 4.0 and draw a 0↔4 bounce that the true orbit never makes.
8. **Numerical breakdown in the shared interpolation script.** `lagnewt_animations_all.jl` is shared by [Lagrange](lagrange-polynomial-interpolation-and-approximation.md) and [Newton Interpolation](newton-interpolation-polynomial.md). Its barycentric evaluation loses its sign far outside the nodes and draws spurious vertical bars in 3 frames: lagnewt04 frame 10 and lagnewt29 frames 9–10. Both pages also claim "one degree at a time", but the degrees run 1, 2, 3, 4, 5, 7, 9, …
9. **Wrong formulas in Descriptions.**
   - [Graeffe](graeffes-method.md): the root-magnitude formula is upside down.
   - [Aitken/Neville](aitkens-and-nevilles-interpolation.md): Aitken's scheme is described as the same recursion as Neville's.
   - [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md): the convergence "rule" is false, and five cases on the same page contradict it.
   - [Cubic Splines](cubic-splines.md): gives O(h⁴) for natural splines, which is true only because sin″ = 0 at both ends.

## Patterns across pages

Each pattern points at errors beyond the ones listed above, so it is worth checking for them on any page edited in future.

- **Numbers written without computing them.** Roots were quoted to four decimals and wrong in the third. The same wrong 1.3688 appears on two pages, and the same function has a different wrong root on each of two pages. The scripts' own frames show the right values.
- **Behaviour described from expectation, not from the computed sequence.** Examples are "converge monotonically", "overshoots then undershoots", "spirals outward", which endpoint stays fixed, "begins with secant steps", "steps tighten through the steeper part", and "slightly better accuracy". These phrases match the textbook picture but not the run that was animated.
- **Textbook convergence rates attached to a problem that does not have them.** One non-smooth integrand serves eleven quadrature pages, and one ODE that becomes stiff serves five ODE pages. Rates and stability that hold for smooth or non-stiff problems were stated for these ones.
- **Display devices that change the message.**
  - Titles run off the frame edge and lose exponents or degrees: Chebyshev, Numerical Differentiation, Hermite, Derive Formulae, Least-Squares Polynomials, Improved Newton.
  - `round(x; digits=6)` prints small errors as "0.0" or "1.0e-6": Richardson, Numerical Differentiation, Derive Formulae.
  - Axis limits hide the feature the page talks about: RKF45, Rational Approximation, Graeffe, Hermite.
  - Clamping is labelled as a real value: Fixed-Point.
- **Coefficients obtained numerically where exact values were easy.** These are the least-squares-fitted Taylor coefficients (Maclaurin, Padé, Laurent) and the trapezoid-rule Legendre coefficients. In each case the error is visible in the GIF.
- **Floating-point evaluation near a multiple root.** Expanded polynomials were evaluated near multiple roots in Improved Newton and Aitken-Steffensen. The cancellation shows up as iterates that stall or jump.

## Inventory results (Phase 1)

- **Scripts and GIFs:**
  - All 115 scripts were run from scratch copies and exited 0.
  - All 280 committed GIFs were reproduced byte for byte.
  - Each script was also run alone, to map it to its GIFs.
  - The two copies of `lagnewt_animations_all.jl` (Lagrange and Newton Interpolation pages) are identical.
- **Files on disk that the pages don't use:**
  - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md): `lagrangeaa.jl` is not linked, and its output `lagrangeaa.gif` is not committed. The reviewer judged it an orphaned prototype of Case 01.
  - [Newton Interpolation](newton-interpolation-polynomial.md): `newtpolyaa.jl`/`.gif` and `newtpolybb.jl`/`.gif` are on disk but neither linked nor embedded. Both compute correctly. `newtpolyaa.jl` is the only code there that actually builds divided differences, which is what that page's Description describes.
- **Links and references:** No page references a missing file. Every animation page is linked from the section index.
- **Outside the animation scope:** three links in `pages/numerical-methods/index.qmd` point to folders that do not exist: `milne-simpsons-method/`, `predictor-corrector-methods/` and `shooting-methods-for-odes/`. These pages are still flat `.qmd` files, so the links are probably broken on the built site.

## How this review was done

- **Phase 1 (evidence):** Every script was copied to a scratch area and run there with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2). For each GIF the regenerated output was compared with the committed one by bytes and by decoded-frame MD5. Every frame of every committed GIF, plus a contact sheet, was extracted for the reviewers.
- **Phase 2 (review):** One reviewer subagent per page worked from a common brief.
  - The brief told reviewers to treat the mathematics as ground truth and everything in the repository as a claim to test.
  - Each reviewer wrote a claim ledger of every checkable statement and checked each one against independent computation (sympy, mpmath, scipy, high-precision arithmetic) and full-size frames.
  - The table-driven pages had every case row checked against its heading, alt text and GIF title.
  - A pilot of four pages (bisection, Gauss-Legendre, RKF45, Laurent) came first. Bisection was the known-answer check: the pilot did catch its two known errors (root 1.3688; "midpoints converge monotonically").
- **Phase 3 (verification):** For each Error or Misleading finding, a separate subagent was given only the location and the allegation. It decided confirmed, refuted or unresolved by its own computation or its own look at the frames.
- **Spot checks:** I re-derived a few results myself, including the Newton-Raphson root and the shared-integrand and shared-ODE patterns.

Each page file holds:
1. the findings, Errors first, with the independent check result under each;
2. the Phase 1 inventory;
3. the reviewer's full claim ledger;
4. the implementation checks, with the reviewer's numbers beside independent ones.

The computation scripts used by reviewers and checkers are under [`evidence/<slug>/`](evidence/). They were run from a scratch directory, so the paths inside them need adjusting before they can be re-run.

## Per-page summary

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---:|---:|---:|---:|---:|---|
| [2D Trapezoidal and Simpson Rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Accelerated & Modified Newton-Raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 2 | 1 | Reviewed |
| [Adams-Bashforth-Moulton Method](adams-bashforth-moulton-method.md) | 1 | 1 | 1 | 0 | 0 | Reviewed |
| [Adaptive Simpson's Rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 2 | 1 | Reviewed |
| [Aitken's Method & Steffensen's Acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 1 | 1 | 2 | Reviewed |
| [Aitken's and Neville's Interpolation](aitkens-and-nevilles-interpolation.md) | 1 | 1 | 1 | 1 | 0 | Reviewed |
| [B-Splines](b-splines.md) | 2 | 2 | 0 | 2 | 2 | Reviewed |
| [Bézier Curves](bezier-curves.md) | 2 | 2 | 1 | 1 | 0 | Reviewed |
| [Bisection Method](bisection-method.md) | 2 | 2 | 2 | 0 | 1 | Reviewed |
| [Boole's Rule](booles-rule.md) | 1 | 1 | 1 | 0 | 0 | Reviewed |
| [Brent's Method](brents-method.md) | 2 | 2 | 3 | 2 | 2 | Reviewed |
| [Broyden's Method](broydens-method.md) | 2 | 2 | 0 | 0 | 3 | Reviewed |
| [Catenary](catenary.md) | 1 | 1 | 0 | 1 | 0 | Reviewed |
| [Chebyshev Approximation Polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 3 | 0 | 3 | Reviewed |
| [Cubic Spline Quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 0 | Reviewed |
| [Cubic Splines](cubic-splines.md) | 1 | 1 | 1 | 1 | 0 | Reviewed |
| [Derive Numerical Differentiation Formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 1 | 0 | 2 | Reviewed |
| [Euler's Method for ODE's](eulers-method-for-odes.md) | 2 | 2 | 1 | 1 | 0 | Reviewed |
| [False Position or Regula Falsi Method](false-position-or-regula-falsi-method.md) | 2 | 2 | 3 | 0 | 2 | Reviewed |
| [Fixed Point Iteration](fixed-point-iteration.md) | 6 | 6 | 4 | 1 | 0 | Reviewed |
| [Gauss-Legendre Quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 1 | 1 | Reviewed |
| [Graeffe's Method](graeffes-method.md) | 2 | 2 | 1 | 1 | 4 | Reviewed |
| [Halley's Method](halleys-method.md) | 3 | 3 | 3 | 0 | 2 | Reviewed |
| [Hermite Polynomial Interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 1 | 2 | Reviewed |
| [Improved Newton Method](improved-newton-method.md) | 5 | 5 | 2 | 0 | 4 | Reviewed |
| [Lagrange Polynomial Interpolation and Approximation](lagrange-polynomial-interpolation-and-approximation.md) | 2 | 29 | 2 | 2 | 1 | Reviewed · inventory: 2 |
| [Laurent Series](laurent-series.md) | 1 | 27 | 0 | 1 | 1 | Reviewed |
| [Least Squares Lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 5 | Reviewed |
| [Least Squares Polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 1 | 3 | Reviewed |
| [Legendre Polynomials](legendre-polynomials.md) | 2 | 2 | 1 | 1 | 0 | Reviewed |
| [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md) | 1 | 31 | 2 | 0 | 3 | Reviewed |
| [Damped Newton with Acceleration (Madsen-Reid Method)](madsen-reid-method.md) | 3 | 3 | 3 | 0 | 4 | Reviewed |
| [Midpoint Rule](midpoint-rule.md) | 1 | 1 | 0 | 1 | 1 | Reviewed |
| [Monte Carlo Pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Muller's Method](mullers-method.md) | 3 | 3 | 3 | 0 | 2 | Reviewed |
| [Newton-Cotes Integration](newton-cotes-integration.md) | 4 | 4 | 0 | 1 | 1 | Reviewed |
| [Newton Interpolation Polynomial](newton-interpolation-polynomial.md) | 3 | 31 | 2 | 0 | 2 | Reviewed · inventory: 4 |
| [Newton-Raphson Method](newton-raphson-method.md) | 6 | 6 | 5 | 1 | 1 | Reviewed |
| [Nonlinear Systems](nonlinear-systems.md) | 2 | 2 | 0 | 1 | 3 | Reviewed |
| [Numerical Differentiation](numerical-differentiation.md) | 2 | 2 | 1 | 1 | 2 | Reviewed |
| [Padé Approximation](pade-approximation.md) | 1 | 27 | 1 | 0 | 2 | Reviewed |
| [Rational Approximation](rational-approximation.md) | 1 | 1 | 0 | 2 | 1 | Reviewed |
| [Richardson Extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 1 | 0 | Reviewed |
| [Riemann Sums](riemann-sums.md) | 4 | 4 | 2 | 1 | 1 | Reviewed |
| [Romberg Integration](romberg-integration.md) | 1 | 1 | 0 | 1 | 2 | Reviewed |
| [Runge-Kutta-Fehlberg Method](runge-kutta-fehlberg-method.md) | 2 | 2 | 1 | 2 | 1 | Reviewed |
| [Runge-Kutta Method](runge-kutta-method.md) | 1 | 1 | 2 | 0 | 1 | Reviewed |
| [Secant Method](secant-method.md) | 6 | 6 | 1 | 1 | 4 | Reviewed |
| [Simpson's 3/8 Rule for Numerical Integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 1 | 0 | 0 | Reviewed |
| [Simpson's Rule for Numerical Integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 1 | 0 | 0 | Reviewed |
| [Taylor Series Method for ODE's](taylor-series-method-for-odes.md) | 2 | 2 | 3 | 1 | 0 | Reviewed |
| [The Tangent Parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | Reviewed |
| [Trapezoidal Rule for Numerical Integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 1 | 0 | 0 | Reviewed |
