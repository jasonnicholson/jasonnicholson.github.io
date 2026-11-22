# Fix worklist — every round-2 finding

Generated from the round-2 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-2 report](../laurent-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Taylor polynomials are clamped onto the plot border and drawn along the frame edge. Minor | unverified | open |
| F2 | Minor | Page match | "analytic at x0 ⇒ principal part is zero" is stated without the annulus qualifier, and the page contradicts it later. Minor | unverified | open |

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-2 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | M10 swaps Mathews' $e^x$ for $e^{-x^2/2}$ and so repeats M17 | unverified | open |
| F2 | Minor | Fidelity | T08–T10 move the Gamma centres from Mathews' 1, 2, 3 to 2, 3, 4 | unverified | open |
| F3 | Minor | Fidelity | T11 and T12 swap Mathews' $Y_0$ about 10 and about 5 for $J_0$ about 10 and $J_1$ about 5 | unverified | open |
| F4 | Minor | Implementation | the target function is drawn as a connected line through its poles | unverified | open |

### Padé Approximation — `pade-approximation` · [round-2 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | The Description gives the wrong reason why high-order Padé approximants are hard to compute (page match, Minor) | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-2 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 19 is listed as a case where "f is drawn on a wider interval", and several alt texts say f is drawn on the whole window where f is undefined on part of it | unverified | open |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-2 report](../newton-interpolation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | node interval for Case 01 (and likely 02, 03, 07) differs from Mathews' | unverified | open |

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-2 report](../2d-trapezoidal-and-simpson-rules.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the Simpson formula leaves out its evenness condition, and h, k, m, n are never defined | unverified | open |
| F2 | Minor | Fidelity | "The archived module examples use …" overstates the archive, and Example 7 is dropped without comment | unverified | open |

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-2 report](../adaptive-simpsons-rule.md)

No findings in round 2.

### Boole's Rule — `booles-rule` · [round-2 report](../booles-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity / Page match | also affects the page match) — Minor — node markers and panel boundaries dropped, so the "panels" cannot be seen after the first few frames | unverified | fixed — [fix record](../fixes/booles-rule.md) |

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-2 report](../cubic-spline-quadrature.md)

No findings in round 2.

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-2 report](../gauss-legendre-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Bars are not the legacy weight-by-sample bars; end bars sit about 18% below the curve in every frame | unverified | open |
| F2 | Minor | Implementation | Two on-frame numbers lose their trailing zeros, so they show fewer digits than the others | unverified | open |

### Midpoint Rule — `midpoint-rule` · [round-2 report](../midpoint-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the page says the legacy midpoint animation is partly missing, but it is in the archive | unverified | open |

### Monte Carlo Pi — `monte-carlo-pi` · [round-2 report](../monte-carlo-pi.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | archive Examples 2–7 of the Mathews module are not carried over, and the page does not say so | unverified | fixed — [fix record](../fixes/monte-carlo-pi.md) |

### Newton-Cotes Integration — `newton-cotes-integration` · [round-2 report](../newton-cotes-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity / Page match | legacy note falsely says the archive lacks a Simpson's 3/8 GIF | unverified | open |
| F2 | Minor | Fidelity / Page match | cases 2–4 draw no sample points or panel boundaries, so the panel structure the text describes is not visible | unverified | open |
| F3 | Minor | Page match | the final frames put Simpson's 1/3 rule last in accuracy, the opposite of the page's comparison | unverified | open |

### Riemann Sums — `riemann-sums` · [round-2 report](../riemann-sums.md)

No findings in round 2.

### Romberg Integration — `romberg-integration` · [round-2 report](../romberg-integration.md)

No findings in round 2.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-2 report](../simpsons-3-8-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the legacy note says the archived GIF is missing, but it is present | unverified | fixed — [fix record](../fixes/simpsons-3-8-rule-for-numerical-integration.md) |
| F2 | Minor | Fidelity / Page match | the frames never show the sample points or the boundaries between the three-subinterval panels | unverified | fixed — [fix record](../fixes/simpsons-3-8-rule-for-numerical-integration.md) |

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-2 report](../simpsons-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "each frame" claims do not hold for the first frame | unverified | fixed — [fix record](../fixes/simpsons-rule-for-numerical-integration.md) |
| F2 | Minor | Fidelity | the sample points and panel boundaries are not drawn, so the panels the page describes cannot be seen in most frames | unverified | fixed — [fix record](../fixes/simpsons-rule-for-numerical-integration.md) |

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-2 report](../trapezoidal-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Behavior paragraph implies steady improvement; frame 2 is almost as accurate as the last frame | unverified | open |

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-2 report](../adams-bashforth-moulton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the h = 0.0311 "stability limit" is presented as the step size above which ABM4 fails on this problem. In practice errors stay tiny up to about h = 0.07 | verified | open |
| F2 | Minor | Fidelity | the legacy animation's content (a sweep over the number of subintervals) is replaced by a single fixed-step trajectory, and the page does not say so | unverified | open |

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-2 report](../eulers-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Fidelity | Mathews' "Modified Euler" is the midpoint method, but the page runs Heun and says it reconstructed Example 12 | verified | open |
| F2 | Misleading | Fidelity | the legacy animations exist and show a step-refinement sweep, but the page says they are missing and animates a single fine step | verified | open |

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-2 report](../runge-kutta-fehlberg-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | there is no "Modified Euler page" | unverified | open |
| F2 | Minor | Fidelity | Mathews' second RKF example (Examples 6/7) is dropped without comment, and the provenance sentence sits under the wrong case | unverified | open |

### Runge-Kutta Method — `runge-kutta-method` · [round-2 report](../runge-kutta-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the legacy step-size sweep has been replaced by a single fine-step trace | unverified | fixed — [fix record](../fixes/runge-kutta-method.md) |

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-2 report](../taylor-series-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the legacy animations varied the number of subintervals, but the new ones show a single, well-resolved run | unverified | open |

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-2 report](../accelerated-and-modified-newton-raphson.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 1 shows its "slow linear convergence" only in the legend; frames 6–13 are visually unchanged | unverified | open |
| F2 | Minor | Page match | Case 3's "tangent lines" cannot be told apart from the curve h(x) | unverified | open |
| F3 | Minor | Fidelity | archive Examples 1(a), 3, 5 and 6 are left out without comment, including every case with multiplicity other than 2 | unverified | open |

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-2 report](../aitken-method-and-steffensen-acceleration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Aitken's theorem is stated without the hypothesis it needs | unverified | open |
| F2 | Minor | Page match | animation intro and Case 3). Minor. After about 10 frames the top "tangent-line" panel is frozen and the Newton marker is hidden | unverified | open |
| F3 | Minor | Implementation | Plot titles of Cases 2 and 3 are cut off at the right edge, which hides the root p | unverified | open |
| F4 | Minor | Fidelity | The archive's Aitken Δ² examples (Mathews Examples 1, 3, 5) are dropped, although the script headers say they were merged in | unverified | open |

### Bisection Method — `bisection-method` · [round-2 report](../bisection-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | The introduction says the shaded bracket is "known to contain a root", which is false for Case 2 | unverified | fixed — [fix record](../fixes/bisection-method.md) |
| F2 | Minor | Fidelity | Both starting intervals differ from Mathews' examples and the page gives no reason | unverified | fixed — [fix record](../fixes/bisection-method.md) |

### Brent's Method — `brents-method` · [round-2 report](../brents-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | The prose description of the IQI step describes a forward parabola, not inverse interpolation | unverified | open |
| F2 | Minor | Fidelity | Mathews' Example 4 finds all three roots of the cubic, but the page keeps only the first one and does not say so | unverified | open |

### Broyden's Method — `broydens-method` · [round-2 report](../broydens-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the frames cannot show the Broyden steps or the superlinear convergence that the text and alt text attribute to them | verified | open |
| F2 | Minor | Fidelity | the example system is not Mathews' system, and the page gives no reason | unverified | open |

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-2 report](../false-position-or-regula-falsi-method.md)

No findings in round 2.

### Fixed Point Iteration — `fixed-point-iteration` · [round-2 report](../fixed-point-iteration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Cases 4–6 start far from x = 2, which weakens Mathews' "local divergence" demonstration and pushes Case 5 off-scale after 3 steps | unverified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F2 | Minor | Page match | Case 3 derives g'(2) = −½ from "strictly decreasing", which does not follow | unverified | fixed — [fix record](../fixes/fixed-point-iteration.md) |

### Graeffe's Method — `graeffes-method` · [round-2 report](../graeffes-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the sign or complex argument "is determined by evaluating p at the candidate magnitude" | verified | fixed — [fix record](../fixes/graeffes-method.md) |
| F2 | Minor | Page match | coefficient growth described as "exponentially as $/r_k/^{2^m}$" | unverified | fixed — [fix record](../fixes/graeffes-method.md) |

### Halley's Method — `halleys-method` · [round-2 report](../halleys-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match |  | unverified | fixed — [fix record](../fixes/halleys-method.md) |
| F2 | Minor | Fidelity |  | unverified | fixed — [fix record](../fixes/halleys-method.md) |

### Improved Newton Method — `improved-newton-method` · [round-2 report](../improved-newton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | ): wrong number in a script comment about cancellation | unverified | open |
| F2 | Minor | Fidelity | ): Mathews' Example 3 and the B/C comparisons are not carried over | unverified | open |

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-2 report](../madsen-reid-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation / Page match | the damped / `alterdirection` rule is not Madsen's | verified | open |
| F2 | Error | Implementation / Page match | "Stage 1" and "Stage 2" are defined wrongly | verified | open |
| F3 | Minor | Implementation / Page match | the r0 update uses the pre-limit step length | unverified | open |

### Muller's Method — `mullers-method` · [round-2 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation / Page match | Case 2's first frame does not draw the parabola as far as the axis crossing that gives the next iterate | unverified | fixed — [fix record](../fixes/mullers-method.md) |
| F2 | Minor | Implementation | Case 3's vertical scale makes the parabola and its crossing nearly unreadable | unverified | fixed — [fix record](../fixes/mullers-method.md) |

### Newton-Raphson Method — `newton-raphson-method` · [round-2 report](../newton-raphson-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Case 6 final, most divergent step is not drawn | unverified | open |

### Nonlinear Systems — `nonlinear-systems` · [round-2 report](../nonlinear-systems.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the claim that Newton needs only "a handful of iterations from anywhere in the basin" | verified | open |
| F2 | Minor | Fidelity | Mathews' fixed-point example (Example 1) is dropped without comment | unverified | open |

### Secant Method — `secant-method` · [round-2 report](../secant-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | script comment), Minor | unverified | open |
| F2 | Minor | Implementation | legend), Minor | unverified | open |

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-2 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the last frame's title says "degree 4" but the curve is the cubic the page describes | unverified | open |
| F2 | Minor | Page match | the j = 2 error the page quotes (1.66 at x = π) falls outside the plotted window | unverified | open |
| F3 | Minor | Fidelity | the only example is not one of Mathews' examples, and no reason is given | unverified | open |

### B-Splines — `b-splines` · [round-2 report](../b-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Fidelity | The page replaces Mathews' subject (cubic B-spline interpolation) with parametric clamped B-spline curves and drops both archive examples without saying so | verified | fixed — [fix record](../fixes/b-splines.md) |

### Bézier Curves — `bezier-curves` · [round-2 report](../bezier-curves.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | neither case comes from Mathews, and his worked examples are dropped without a note | unverified | open |

### Catenary — `catenary` · [round-2 report](../catenary.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | c is called the "sag parameter" | unverified | open |
| F2 | Minor | Fidelity | the archive's worked examples are dropped without a note | unverified | open |

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-2 report](../chebyshev-approximation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | the top-left legend hides nodes and the curve peak in cases 13, 16, 27, 28 and 29 | unverified | open |
| F2 | Minor | Fidelity | node intervals of cases 04 and 29 differ from Mathews' examples, with no reason given | unverified | open |
| F3 | Minor | Fidelity | cases 02 and 03 use wider node intervals than Mathews; the pole-side windows of 01/02/03/07 are cut off | unverified | open |

### Cubic Splines — `cubic-splines` · [round-2 report](../cubic-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the archive's worked examples (including the clamped spline) are replaced by a new example, and the page gives no reason | unverified | open |

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-2 report](../hermite-polynomial-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | the "slope markers" in Case 1 do not show slope | unverified | open |
| F2 | Minor | Fidelity | Mathews' only Hermite worked example is dropped without mention | unverified | open |

### Least Squares Lines — `least-squares-lines` · [round-2 report](../least-squares-lines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the "vertical residuals" the page points readers to are mostly hidden under the data markers (Case 3 almost completely) | verified | open |
| F2 | Minor | Page match | Case 3 "settles near" is not supported by the computed sequence | unverified | open |

### Least Squares Polynomials — `least-squares-polynomials` · [round-2 report](../least-squares-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Mathews' "polynomial wiggle" example (Example 7) and the wide extrapolation view (Example 6) are dropped without a word, yet the Description asserts both effect | unverified | open |

### Legendre Polynomials — `legendre-polynomials` · [round-2 report](../legendre-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Case 2 uses cos(pi x/2) instead of either of Mathews' Legendre-series functions, with no reason given | unverified | open |

### Rational Approximation — `rational-approximation` · [round-2 report](../rational-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Examples 2 to 5 of the Mathews module are dropped without a note | unverified | open |

### The Tangent Parabola — `the-tangent-parabola` · [round-2 report](../the-tangent-parabola.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the example function and centre differ from Mathews, and the page gives no reason | unverified | open |
| F2 | Minor | Fidelity | the archive's animated examples (tangent cubic and degree-6 tangent polynomial) are silently dropped | unverified | open |

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-2 report](../derive-numerical-differentiation-formulae.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation / Page match | Case 2: the green "five-point estimate" line is never visible; the true tangent covers it in every frame | unverified | open |
| F2 | Minor | Page match | Case 3: "over [0, π]" claims, but the stencil curves and the reported maximum errors cover only [2h, π−2h] | unverified | open |

### Numerical Differentiation — `numerical-differentiation` · [round-2 report](../numerical-differentiation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Case 2 legend shows "f" instead of the function (Implementation / picture, Minor) | unverified | open |
| F2 | Minor | Page match | Case 1 "max error" covers [h, π−h], not [0, π] (Page match / picture, Minor) | unverified | open |
| F3 | Minor | Fidelity | archive cases dropped without mention (Fidelity, Minor) | unverified | open |

### Richardson Extrapolation — `richardson-extrapolation` · [round-2 report](../richardson-extrapolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | The legacy module's animated scenarios (Examples 8 to 10) are not represented, and the page does not say so | unverified | open |

