# Numerical Methods animations — review report, round 2

Independent re-review of the Julia animations in `pages/numerical-methods/` after the round-1 fixes (run of 2026-11-21, scope: all, branch `fix/numerical-methods-animations` at `4154c49`). Nothing under version control was changed; this folder is the only addition.

## Headline

- **Pages reviewed: 53 of 53**, every page with animations: 113 Julia scripts and 279 GIFs. Nothing was skipped.
- **Findings: 2 Error, 8 Misleading, 79 Minor** (round 1: 61 Error, 37 Misleading, 76 Minor). 5 pages came back clean.
- **Every Error and Misleading finding was checked independently.** Each checker saw only the allegation, not the reviewer's evidence.
  - All 10 were confirmed. 4 were confirmed with a correction, which is recorded next to the finding.
  - None were refuted, and none are unresolved.
  - Minor findings were not re-checked and are labelled unverified.
- **44 of the 89 findings are of kind Fidelity** (3 Misleading, 41 Minor). These are departures from Mathews' legacy archive that matter to a reader. They are listed together below so you can decide them as a group. Round 1 did not check fidelity.
- **The scripts compute what is shown.**
  - All 113 scripts ran cleanly from scratch copies.
  - All 279 committed GIFs are byte-identical to what their scripts produce now.
  - There were no inventory problems: no unreferenced files, no broken references, and every page is linked from the section index.
  - The two copies of `lagnewt_animations_all.jl` (Lagrange and Newton Interpolation pages) are identical.
- **Most of what remains is small.**
  - The numerical claims on the pages held up almost everywhere. Reviewers checked them claim by claim against independent mpmath, sympy and scipy computations.
  - What is left is mostly fidelity, pictures that do not show what the text says they show, and loosely worded statements of theory.

## Look at these first

1. **[Madsen-Reid](madsen-reid-method.md): 2 Errors.** Both concern the method itself.
   - The damping and rotation rule in the scripts is not Madsen–Reid's. The scripts halve the step up to 4 times, then take a rotated dz/16 and accept it unchecked. The 1975 report (AERE R.7986, eq. 2.6) does at most 2 halvings. It then tries ¼·e^{iθ}·dz with θ = arctan(3/4) ≈ 36.87°, followed on the next iteration by a checked rotation.
   - The page's "Stage 1 / Stage 2" definitions are wrong. In Madsen–Reid, Stage 2 is plain Newton entered through a Kantorovich test, and the scripts have no such test.
   - The checker established both from the primary report. It also corrected the reviewer's own description of Madsen's rule, so when fixing, use the version in the "Independent check" lines.
2. **[Adams-Bashforth-Moulton](adams-bashforth-moulton-method.md): Misleading.** The page presents h = 0.0311, the linear stability boundary, as the step above which ABM4 fails on this problem. Errors in fact stay small until about h ≈ 0.066–0.068. The boundary numbers themselves are correct.
3. **[Nonlinear Systems](nonlinear-systems.md): Misleading.** "Within a handful of iterations from anywhere in the basin" is false. Starts near the singular-Jacobian curve take tens of iterations.
4. **[Graeffe](graeffes-method.md): Misleading.** The Description says evaluating p at the candidate magnitude gives a root's "sign (or complex argument)". It can fix the sign of a real root, but not the argument of a complex one.
5. **[Broyden](broydens-method.md): Misleading.** After the first exact-Newton step every Broyden step is under a pixel, and the last 4 frames of each GIF are frozen. The superlinear convergence the text and alt text describe cannot be seen.
6. **[Least-Squares Lines](least-squares-lines.md): Misleading.** The vertical residuals the page points readers to are mostly invisible. Only the part beyond the marker radius shows, and in Case 3 almost nothing does.
7. **Fidelity, Misleading (3):**
   - [Euler](eulers-method-for-odes.md): Mathews' "Modified Euler" is the midpoint method, but the page runs Heun while claiming to reconstruct his Example 12.
   - [Euler](eulers-method-for-odes.md): the page says the legacy GIFs are missing. They are in the archive, and they show a step-refinement sweep.
   - [B-Splines](b-splines.md): the page replaces Mathews' subject (cubic B-spline interpolation) with parametric clamped curves without saying so.

Minor findings worth a quick look, because they affect what a reader sees:

- [Chebyshev](chebyshev-approximation-polynomial.md) F3: case 03's wider node interval makes the n = 16 error 1.43, where Mathews' interval gives 0.025.
- [Laurent](laurent-series.md) F1: clamped polynomials are drawn flat along the frame edge over up to 84% of the x-range.
- [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md): the titles of Cases 2 and 3 are cut off, hiding the root p.
- [Secant](secant-method.md) F2: legends round late iterates to "0.2" or "0.0".
- [Numerical Differentiation](numerical-differentiation.md): the legend shows only "f". The page also claims "on [0, π]" while the stencil curves and errors cover [h, π−h]. [Derive Formulae](derive-numerical-differentiation-formulae.md) has the same interval issue.
- [Maclaurin and Taylor](maclaurin-and-taylor-series.md) F4: f(x) is drawn through its poles as full-height vertical segments.

## Fidelity findings (decide as a group)

Two clusters stand out:

- **Archive examples silently dropped or replaced.** This is most of the table.
- **The ODE pages lost Mathews' step-size sweep.** [Euler](eulers-method-for-odes.md), [Runge-Kutta](runge-kutta-method.md), [Taylor](taylor-series-method-for-odes.md) and [ABM](adams-bashforth-moulton-method.md) are affected. Mathews' animations swept the number of subintervals (m = 12…150) to show coarse-step blow-up turning into convergence. The pages now animate a single stable run.
  - This follows from decision **D2** in the round-1 fix plan, which chose stable steps.
  - Restoring a sweep, or saying in the text that the legacy animation was a sweep, is your call.

Stale "legacy GIF missing" notes appear on [Euler](eulers-method-for-odes.md), [Midpoint](midpoint-rule.md), [Simpson 3/8](simpsons-3-8-rule-for-numerical-integration.md) and [Newton-Cotes](newton-cotes-integration.md). In each case the GIF is in `a2001/Animations/`.

| Page | Severity | Finding |
|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | Minor | "The archived module examples use …" overstates the archive, and Example 7 is dropped without comment |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | Minor | archive Examples 1(a), 3, 5 and 6 are left out without comment, including every case with multiplicity other than 2 |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | Minor | the legacy animation's content (a sweep over the number of subintervals) is replaced by a single fixed-step trajectory, and the page does not say so. |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | Minor | The archive's Aitken Δ² examples (Mathews Examples 1, 3, 5) are dropped, although the script headers say they were merged in |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | Minor | the only example is not one of Mathews' examples, and no reason is given |
| [b-splines](b-splines.md) | Misleading | The page replaces Mathews' subject (cubic B-spline interpolation) with parametric clamped B-spline curves and drops both archive examples  |
| [bezier-curves](bezier-curves.md) | Minor | neither case comes from Mathews, and his worked examples are dropped without a note |
| [bisection-method](bisection-method.md) | Minor | Both starting intervals differ from Mathews' examples and the page gives no reason |
| [booles-rule](booles-rule.md) | Minor | node markers and panel boundaries dropped, so the "panels" cannot be seen after the first few frames |
| [brents-method](brents-method.md) | Minor | Mathews' Example 4 finds all three roots of the cubic, but the page keeps only the first one and does not say so |
| [broydens-method](broydens-method.md) | Minor | the example system is not Mathews' system, and the page gives no reason |
| [catenary](catenary.md) | Minor | the archive's worked examples are dropped without a note |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | Minor | node intervals of cases 04 and 29 differ from Mathews' examples, with no reason given |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | Minor | cases 02 and 03 use wider node intervals than Mathews; the pole-side windows of 01/02/03/07 are cut off |
| [cubic-splines](cubic-splines.md) | Minor | the archive's worked examples (including the clamped spline) are replaced by a new example, and the page gives no reason |
| [eulers-method-for-odes](eulers-method-for-odes.md) | Misleading | Mathews' "Modified Euler" is the midpoint method, but the page runs Heun and says it reconstructed Example 12 |
| [eulers-method-for-odes](eulers-method-for-odes.md) | Misleading | the legacy animations exist and show a step-refinement sweep, but the page says they are missing and animates a single fine step |
| [fixed-point-iteration](fixed-point-iteration.md) | Minor | Cases 4–6 start far from x = 2, which weakens Mathews' "local divergence" demonstration and pushes Case 5 off-scale after 3 steps |
| [gauss-legendre-quadrature](gauss-legendre-quadrature.md) | Minor | Bars are not the legacy weight-by-sample bars; end bars sit about 18% below the curve in every frame |
| [halleys-method](halleys-method.md) | Minor | Mathews' Example 2(a) (Newton on x³−3x+2 from −2.2) is dropped without comment |
| [hermite-polynomial-interpolation](hermite-polynomial-interpolation.md) | Minor | Mathews' only Hermite worked example is dropped without mention |
| [improved-newton-method](improved-newton-method.md) | Minor | Mathews' Example 3 and the B/C comparisons are not carried over |
| [least-squares-polynomials](least-squares-polynomials.md) | Minor | Mathews' "polynomial wiggle" example (Example 7) and the wide extrapolation view (Example 6) are dropped without a word, yet the Description asserts b |
| [legendre-polynomials](legendre-polynomials.md) | Minor | Case 2 uses cos(pi x/2) instead of either of Mathews' Legendre-series functions, with no reason given |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | Minor | M10 swaps Mathews' $e^x$ for $e^{-x^2/2}$ and so repeats M17 |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | Minor | T08–T10 move the Gamma centres from Mathews' 1, 2, 3 to 2, 3, 4 |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | Minor | T11 and T12 swap Mathews' $Y_0$ about 10 and about 5 for $J_0$ about 10 and $J_1$ about 5 |
| [midpoint-rule](midpoint-rule.md) | Minor | the page says the legacy midpoint animation is partly missing, but it is in the archive |
| [monte-carlo-pi](monte-carlo-pi.md) | Minor | archive Examples 2–7 of the Mathews module are not carried over, and the page does not say so |
| [newton-cotes-integration](newton-cotes-integration.md) | Minor | legacy note falsely says the archive lacks a Simpson's 3/8 GIF |
| [newton-cotes-integration](newton-cotes-integration.md) | Minor | cases 2–4 draw no sample points or panel boundaries, so the panel structure the text describes is not visible |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | Minor | node interval for Case 01 (and likely 02, 03, 07) differs from Mathews' |
| [nonlinear-systems](nonlinear-systems.md) | Minor | Mathews' fixed-point example (Example 1) is dropped without comment |
| [numerical-differentiation](numerical-differentiation.md) | Minor | archive cases dropped without mention |
| [rational-approximation](rational-approximation.md) | Minor | Examples 2 to 5 of the Mathews module are dropped without a note |
| [richardson-extrapolation](richardson-extrapolation.md) | Minor | The legacy module's animated scenarios (Examples 8 to 10) are not represented, and the page does not say so |
| [runge-kutta-fehlberg-method](runge-kutta-fehlberg-method.md) | Minor | Mathews' second RKF example (Examples 6/7) is dropped without comment, and the provenance sentence sits under the wrong case |
| [runge-kutta-method](runge-kutta-method.md) | Minor | the legacy step-size sweep has been replaced by a single fine-step trace |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | Minor | the legacy note says the archived GIF is missing, but it is present |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | Minor | the frames never show the sample points or the boundaries between the three-subinterval panels |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | Minor | the sample points and panel boundaries are not drawn, so the panels the page describes cannot be seen in most frames |
| [taylor-series-method-for-odes](taylor-series-method-for-odes.md) | Minor | the legacy animations varied the number of subintervals, but the new ones show a single, well-resolved run |
| [the-tangent-parabola](the-tangent-parabola.md) | Minor | the example function and centre differ from Mathews, and the page gives no reason |
| [the-tangent-parabola](the-tangent-parabola.md) | Minor | the archive's animated examples (tangent cubic and degree-6 tangent polynomial) are silently dropped |

## Per-page summary

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---:|---:|---:|---:|---:|---|
| [2D Trapezoidal and Simpson Rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Accelerated & Modified Newton-Raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 3 | Reviewed |
| [Adams-Bashforth-Moulton Method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 1 | 1 | Reviewed |
| [Adaptive Simpson's Rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | Reviewed · clean |
| [Aitken's and Neville's Interpolation](aitkens-and-nevilles-interpolation.md) | 1 | 1 | 0 | 0 | 3 | Reviewed |
| [Aitken's Method & Steffensen's Acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 4 | Reviewed |
| [B-Splines](b-splines.md) | 2 | 2 | 0 | 1 | 0 | Reviewed |
| [Bisection Method](bisection-method.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Boole's Rule](booles-rule.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Brent's Method](brents-method.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Broyden's Method](broydens-method.md) | 2 | 2 | 0 | 1 | 1 | Reviewed |
| [Bézier Curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 1 | Reviewed |
| [Catenary](catenary.md) | 1 | 1 | 0 | 0 | 2 | Reviewed |
| [Chebyshev Approximation Polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 3 | Reviewed |
| [Cubic Spline Quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 0 | Reviewed · clean |
| [Cubic Splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Damped Newton with Acceleration (Madsen-Reid Method)](madsen-reid-method.md) | 3 | 3 | 2 | 0 | 1 | Reviewed |
| [Derive Numerical Differentiation Formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 2 | Reviewed |
| [Euler's Method for ODE's](eulers-method-for-odes.md) | 2 | 2 | 0 | 2 | 0 | Reviewed |
| [False Position or Regula Falsi Method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | Reviewed · clean |
| [Fixed Point Iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 0 | 2 | Reviewed |
| [Gauss-Legendre Quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 2 | Reviewed |
| [Graeffe's Method](graeffes-method.md) | 2 | 2 | 0 | 1 | 1 | Reviewed |
| [Halley's Method](halleys-method.md) | 3 | 3 | 0 | 0 | 2 | Reviewed |
| [Hermite Polynomial Interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Improved Newton Method](improved-newton-method.md) | 5 | 5 | 0 | 0 | 2 | Reviewed |
| [Lagrange Polynomial Interpolation and Approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 1 | Reviewed |
| [Laurent Series](laurent-series.md) | 1 | 27 | 0 | 0 | 2 | Reviewed |
| [Least Squares Lines](least-squares-lines.md) | 4 | 4 | 0 | 1 | 1 | Reviewed |
| [Least Squares Polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 1 | Reviewed |
| [Legendre Polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 1 | Reviewed |
| [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 4 | Reviewed |
| [Midpoint Rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Monte Carlo Pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Muller's Method](mullers-method.md) | 3 | 3 | 0 | 0 | 2 | Reviewed |
| [Newton Interpolation Polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 1 | Reviewed |
| [Newton-Cotes Integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 3 | Reviewed |
| [Newton-Raphson Method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 1 | Reviewed |
| [Nonlinear Systems](nonlinear-systems.md) | 2 | 2 | 0 | 1 | 1 | Reviewed |
| [Numerical Differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 3 | Reviewed |
| [Padé Approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 1 | Reviewed |
| [Rational Approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Richardson Extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 1 | Reviewed |
| [Riemann Sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | Reviewed · clean |
| [Romberg Integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 0 | Reviewed · clean |
| [Runge-Kutta Method](runge-kutta-method.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |
| [Runge-Kutta-Fehlberg Method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 2 | Reviewed |
| [Secant Method](secant-method.md) | 6 | 6 | 0 | 0 | 2 | Reviewed |
| [Simpson's 3/8 Rule for Numerical Integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 2 | Reviewed |
| [Simpson's Rule for Numerical Integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 2 | Reviewed |
| [Taylor Series Method for ODE's](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 0 | 1 | Reviewed |
| [The Tangent Parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 2 | Reviewed |
| [Trapezoidal Rule for Numerical Integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 1 | Reviewed |

## Patterns across pages

- **Content from the archive dropped without a note.** This is the largest group. Pages often keep one Mathews example and silently drop the rest, or swap in a different function, interval or centre with no reason given.
- **Pictures that cannot show what the text says they show.** Some features fall below pixel resolution or are hidden:
  - [Broyden](broydens-method.md) and [Accelerated Newton](accelerated-and-modified-newton-raphson.md): steps too small to see.
  - [Muller](mullers-method.md) Case 3: the parabola is a few pixels tall.
  - [Least-Squares Lines](least-squares-lines.md): residuals hidden.
  - [Derive Formulae](derive-numerical-differentiation-formulae.md): the five-point line is hidden under the tangent.
  - Panels with no sample markers or dividers: [Simpson](simpsons-rule-for-numerical-integration.md), [Simpson 3/8](simpsons-3-8-rule-for-numerical-integration.md), [Newton-Cotes](newton-cotes-integration.md) and [Boole](booles-rule.md).
- **Labels that misreport.**
  - Rounding that drops trailing zeros or flattens late iterates: [Secant](secant-method.md), [Gauss-Legendre](gauss-legendre-quadrature.md).
  - Sub/superscript markup that GR does not render: [Numerical Differentiation](numerical-differentiation.md), [B-Splines](b-splines.md) (noted).
  - Clipped titles: [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md).
- **Stated interval differs from the computed range.** Pages claim "on [0, π]" where the stencil only covers [h, π−h] or [2h, π−2h]: [Numerical Differentiation](numerical-differentiation.md), [Derive Formulae](derive-numerical-differentiation-formulae.md).
- **Clamping drawn as if it were data.** Off-window values are drawn flat along the frame edge: [Laurent](laurent-series.md); also noted on [Padé](pade-approximation.md) and [Maclaurin](maclaurin-and-taylor-series.md).
- **Loosely stated theory.**
  - [Graeffe](graeffes-method.md): the complex-argument claim.
  - [Laurent](laurent-series.md): analyticity alone forcing a_k = 0.
  - [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md): the theorem's missing hypothesis.
  - [Halley](halleys-method.md): the "bracketed factor".
  - [Padé](pade-approximation.md): conditioning blamed on "coefficient growth".
  - [Brent](brents-method.md): IQI described as an ordinary parabola.
  - [2D Simpson](2d-trapezoidal-and-simpson-rules.md): m and n must be even.
  - [Catenary](catenary.md): "sag parameter".

## Compared with round 1

This comparison was made after this round's findings were final. Neither the reviewers nor the checkers saw round 1 or the fix records.

- **No round-1 Error has come back as such.** The wrong roots, false convergence orders, unstable ODE runs, wrong coefficient routines, clamped iterates and false behaviour sentences that round 1 found are all gone. Reviewers re-derived those numbers independently and confirmed them.
- **Related issues that came back in a different form:**
  - [Madsen-Reid](madsen-reid-method.md). Round 1 found the named acceleration was not implemented. The fix added one, but round 2 finds that the damping/rotation rule and the stage logic are still not Madsen–Reid's.
  - [Aitken/Neville](aitkens-and-nevilles-interpolation.md). The text about the "degree 4" interpolant being the cubic is fixed, but the GIF title still says "degree 4" (Minor).
  - [ABM](adams-bashforth-moulton-method.md). The fix's stability sentence frames the linear stability limit as the failure step. The Runge-Kutta, Euler and Taylor pages were checked and found correctly worded.
  - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md). The function-interval alt text added in the fix overstates f's interval for Case 19 and the ln cases.
- **Listed as "found but not changed" in the round-1 fix summary and now confirmed as findings:**
  - Nonlinear Systems, line 76.
  - Euler's Heun/midpoint question and missing-GIF note.
  - The stale Simpson 3/8 note.

## How this review was done

- **Phase 1 (evidence).**
  - Every script was copied to a scratch area and run alone with the global Julia environment: Plots 1.41.2, and SpecialFunctions 2.7.2 on this machine rather than 2.9.2. The output reproduced every committed GIF byte for byte, so the version difference has no effect.
  - Every frame of every committed GIF was extracted, with a contact sheet and decoded-frame hashes.
  - Each page received a manifest of scripts, GIFs, references and regeneration results.
- **Phase 2 (review).**
  - One reviewer subagent per page worked from a common brief that included the full Review standard. Reviewers checked each page claim by claim against independent computation (mpmath, sympy, scipy, `/usr/bin/python3`) and against full-size frames.
  - Table-driven pages had every case row checked.
  - The legacy Mathews archive was found at `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/`, and every reviewer consulted its topic. No archive topic exists for Madsen-Reid or Laurent. For Madsen-Reid, the reviewer and checker used published sources, including the 1975 AERE report.
  - Reviewers were told not to read `reviews/`.
- **Calibration.**
  - The known bisection errors had been fixed, so two errors were planted in a scratch copy of the bisection page: a root wrong in the third significant digit, and a false monotonicity sentence.
  - The pilot reviewer caught both. The real page was then reviewed separately. The planted errors appear nowhere in this report.
- **Phase 3 (verification).** Each Error and Misleading finding went to a fresh checker that was shown only the location and the allegation.
- **Not counted.** One Maclaurin item about the Video Animations section is recorded as out of scope and not counted. Each page file also keeps the reviewer's "considered and not reported" notes, so that a clean result can be trusted.

Each page file holds, in order:
1. the findings, most severe first, each with its independent-check result;
2. the Phase 1 inventory;
3. the reviewer's claim ledger and implementation checks.
