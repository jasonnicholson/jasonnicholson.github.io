# Fix worklist — every round-3 finding

Generated from the round-3 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-3 report](../laurent-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | In cases 03 and 06 the frames show the opposite of "diverges beyond it" | verified | open |

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-3 report](../maclaurin-and-taylor-series.md)

No findings in round 3.

### Padé Approximation — `pade-approximation` · [round-3 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | garbled wording in the Description | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-3 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation / Page match | Case 14: f = tan x is drawn as one continuous curve through its poles (vertical magenta segments at x ≈ ±π/2) | unverified | fixed — [fix record](../fixes/lagrange-polynomial-interpolation-and-approximation.md) |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-3 report](../newton-interpolation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Cases 12 and 13 show constant lines in frames titled degree 1–3, and this page never says so | unverified | fixed — [fix record](../fixes/newton-interpolation-polynomial.md) |

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-3 report](../2d-trapezoidal-and-simpson-rules.md)

No findings in round 3.

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-3 report](../adaptive-simpsons-rule.md)

No findings in round 3.

### Boole's Rule — `booles-rule` · [round-3 report](../booles-rule.md)

No findings in round 3.

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-3 report](../cubic-spline-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Page match, Minor: "tracks the curve more tightly" fails at the first refinement under the pointwise (sup) gap | unverified | fixed — [fix record](../fixes/cubic-spline-quadrature.md) |

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-3 report](../gauss-legendre-quadrature.md)

No findings in round 3.

### Midpoint Rule — `midpoint-rule` · [round-3 report](../midpoint-rule.md)

No findings in round 3.

### Monte Carlo Pi — `monte-carlo-pi` · [round-3 report](../monte-carlo-pi.md)

No findings in round 3.

### Newton-Cotes Integration — `newton-cotes-integration` · [round-3 report](../newton-cotes-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Simpson composite formula has no summation limits | unverified | fixed — [fix record](../fixes/newton-cotes-integration.md) |

### Riemann Sums — `riemann-sums` · [round-3 report](../riemann-sums.md)

No findings in round 3.

### Romberg Integration — `romberg-integration` · [round-3 report](../romberg-integration.md)

No findings in round 3.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-3 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 3.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-3 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 3.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-3 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 3.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-3 report](../adams-bashforth-moulton-method.md)

No findings in round 3.

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-3 report](../eulers-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the error in y(5) is presented as the accuracy measure, but here it is roughly 10⁴ times smaller than the global error and hides the difference between the two  | verified | fixed — [fix record](../fixes/eulers-method-for-odes.md) |
| F2 | Minor | Page match | Case 2 says only m = 12–20 zig-zag, but m = 24 (and slightly m = 28) also zig-zag in the last steps | unverified | fixed — [fix record](../fixes/eulers-method-for-odes.md) |

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-3 report](../runge-kutta-fehlberg-method.md)

No findings in round 3.

### Runge-Kutta Method — `runge-kutta-method` · [round-3 report](../runge-kutta-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | what the diagram shows — Minor | unverified | open |

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-3 report](../taylor-series-method-for-odes.md)

No findings in round 3.

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-3 report](../accelerated-and-modified-newton-raphson.md)

No findings in round 3.

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-3 report](../aitken-method-and-steffensen-acceleration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 2's final Steffensen error is measured against the rounded root, not √2 | unverified | fixed — [fix record](../fixes/aitken-method-and-steffensen-acceleration.md) |

### Bisection Method — `bisection-method` · [round-3 report](../bisection-method.md)

No findings in round 3.

### Brent's Method — `brents-method` · [round-3 report](../brents-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | script header comment), Minor | unverified | fixed — [fix record](../fixes/brents-method.md) |

### Broyden's Method — `broydens-method` · [round-3 report](../broydens-method.md)

No findings in round 3.

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-3 report](../false-position-or-regula-falsi-method.md)

No findings in round 3.

### Fixed Point Iteration — `fixed-point-iteration` · [round-3 report](../fixed-point-iteration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the convergence criterion in the introduction is stated as if it were global | unverified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F2 | Minor | Fidelity | Cases 2 and 3 change Mathews' starting value with no reason given | unverified | fixed — [fix record](../fixes/fixed-point-iteration.md) |

### Graeffe's Method — `graeffes-method` · [round-3 report](../graeffes-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "the error roughly squares at each step" fails for r₂ in the first steps of Case 1 | unverified | fixed — [fix record](../fixes/graeffes-method.md) |
| F2 | Minor | Page match | in Case 2, the r₂ trace has the same dashed steelblue style as the true-value line at 5 | unverified | fixed — [fix record](../fixes/graeffes-method.md) |

### Halley's Method — `halleys-method` · [round-3 report](../halleys-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Trade-offs). Minor | unverified | fixed — [fix record](../fixes/halleys-method.md) |

### Improved Newton Method — `improved-newton-method` · [round-3 report](../improved-newton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Mathews' "wrong m" caveat in Example 2 is dropped without mention | unverified | fixed — [fix record](../fixes/improved-newton-method.md) |

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-3 report](../madsen-reid-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The slow Stage-2 example at x0 = -0.7 is caused by the reference's substitute w, and the page says that substitution makes no difference | verified | fixed — [fix record](../fixes/madsen-reid-method.md) |

### Muller's Method — `mullers-method` · [round-3 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | In Case 1, the feature the page describes can't be seen after frame 2 | unverified | open |
| F2 | Minor | Fidelity | Case 1 handles complex roots with a different rule from Mathews' Example 1, and the page doesn't say so | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-3 report](../newton-raphson-method.md)

No findings in round 3.

### Nonlinear Systems — `nonlinear-systems` · [round-3 report](../nonlinear-systems.md)

No findings in round 3.

### Secant Method — `secant-method` · [round-3 report](../secant-method.md)

No findings in round 3.

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-3 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | says the interpolant has degree n-1, but this page's own example has degree n-2 (Page match / method description; Minor) | unverified | fixed — [fix record](../fixes/aitkens-and-nevilles-interpolation.md) |

### B-Splines — `b-splines` · [round-3 report](../b-splines.md)

No findings in round 3.

### Bézier Curves — `bezier-curves` · [round-3 report](../bezier-curves.md)

No findings in round 3.

### Catenary — `catenary` · [round-3 report](../catenary.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the exploration numbering quoted from Mathews is wrong | unverified | fixed — [fix record](../fixes/catenary.md) |
| F2 | Minor | Fidelity | Mathews' actual Exploration 1 (catenaries are similar curves) is silently dropped | unverified | fixed — [fix record](../fixes/catenary.md) |

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-3 report](../chebyshev-approximation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Case 07 approximation interval differs from Mathews' example (Fidelity, Minor) | unverified | fixed — [fix record](../fixes/chebyshev-approximation-polynomial.md) |

### Cubic Splines — `cubic-splines` · [round-3 report](../cubic-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the Mathews data-point example is replaced by sin(x), and no reason is given | unverified | fixed — [fix record](../fixes/cubic-splines.md) |

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-3 report](../hermite-polynomial-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "giving a smoother fit" | unverified | fixed — [fix record](../fixes/hermite-polynomial-interpolation.md) |
| F2 | Minor | Fidelity | Mathews' Example 1 replaced by an unexplained example | unverified | fixed — [fix record](../fixes/hermite-polynomial-interpolation.md) |

### Least Squares Lines — `least-squares-lines` · [round-3 report](../least-squares-lines.md)

No findings in round 3.

### Least Squares Polynomials — `least-squares-polynomials` · [round-3 report](../least-squares-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | The page does not mention Mathews' Example 8 | unverified | fixed — [fix record](../fixes/least-squares-polynomials.md) |

### Legendre Polynomials — `legendre-polynomials` · [round-3 report](../legendre-polynomials.md)

No findings in round 3.

### Rational Approximation — `rational-approximation` · [round-3 report](../rational-approximation.md)

No findings in round 3.

### The Tangent Parabola — `the-tangent-parabola` · [round-3 report](../the-tangent-parabola.md)

No findings in round 3.

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-3 report](../derive-numerical-differentiation-formulae.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | The page calls $e^{-x}\sin x$ "the legacy test function", but the legacy module has no test function | unverified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |
| F2 | Minor | Page match | "Each animation ... visualizes one derived stencil formula" does not describe Cases 2 and 3 | unverified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |

### Numerical Differentiation — `numerical-differentiation` · [round-3 report](../numerical-differentiation.md)

No findings in round 3.

### Richardson Extrapolation — `richardson-extrapolation` · [round-3 report](../richardson-extrapolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation / Page match | Case 1 approximations and max-error annotation cover [h, pi-h], while the title and alt text say [0, pi] (Page match / implementation display, Minor) | unverified | fixed — [fix record](../fixes/richardson-extrapolation.md) |

