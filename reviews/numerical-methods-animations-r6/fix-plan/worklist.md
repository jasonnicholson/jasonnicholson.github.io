# Fix worklist — every round-6 finding

Generated from the round-6 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D and R4-A…R4-D and R5-A…R5-F and R6-A…R6-E in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-6 report](../laurent-series.md)

No findings in round 6. F1 below is decision R6-B, not a round-6 finding.

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | — | Implementation / Page match | (R6-B) rebuild the page: Laurent reduces to Taylor at times; negative powers give vertical and horizontal asymptotes | owner decision | open |

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-6 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the GIFs stop at orders 8 to 12, so for most entire-function cases the final frame fits well under the full window that Mathews chose | unverified | deferred — owner decision (R6-D) |

### Padé Approximation — `pade-approximation` · [round-6 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | off-scale parts of the approximant are drawn along the plot border, so they look like a curve that levels off at the axis limit (Minor) | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-6 report](../lagrange-polynomial-interpolation-and-approximation.md)

No findings in round 6.

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-6 report](../newton-interpolation-polynomial.md)

No findings in round 6.

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-6 report](../2d-trapezoidal-and-simpson-rules.md)

No findings in round 6.

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-6 report](../adaptive-simpsons-rule.md)

No findings in round 6.

### Boole's Rule — `booles-rule` · [round-6 report](../booles-rule.md)

No findings in round 6.

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-6 report](../cubic-spline-quadrature.md)

No findings in round 6.

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-6 report](../gauss-legendre-quadrature.md)

No findings in round 6.

### Midpoint Rule — `midpoint-rule` · [round-6 report](../midpoint-rule.md)

No findings in round 6.

### Monte Carlo Pi — `monte-carlo-pi` · [round-6 report](../monte-carlo-pi.md)

No findings in round 6.

### Newton-Cotes Integration — `newton-cotes-integration` · [round-6 report](../newton-cotes-integration.md)

No findings in round 6.

### Riemann Sums — `riemann-sums` · [round-6 report](../riemann-sums.md)

No findings in round 6.

### Romberg Integration — `romberg-integration` · [round-6 report](../romberg-integration.md)

No findings in round 6.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-6 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 6.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-6 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 6.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-6 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 6.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-6 report](../adams-bashforth-moulton-method.md)

No findings in round 6.

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-6 report](../eulers-method-for-odes.md)

No findings in round 6.

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-6 report](../runge-kutta-fehlberg-method.md)

No findings in round 6.

### Runge-Kutta Method — `runge-kutta-method` · [round-6 report](../runge-kutta-method.md)

No findings in round 6.

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-6 report](../taylor-series-method-for-odes.md)

No findings in round 6.

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-6 report](../accelerated-and-modified-newton-raphson.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Case 1 window hides the slow convergence the case is about | unverified | deferred — owner decision (R6-C) |
| F2 | Minor | Page match | Intro says each animation shows three methods | unverified | fixed — [fix record](../fixes/accelerated-and-modified-newton-raphson.md) |

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-6 report](../aitken-method-and-steffensen-acceleration.md)

No findings in round 6.

### Bisection Method — `bisection-method` · [round-6 report](../bisection-method.md)

No findings in round 6.

### Brent's Method — `brents-method` · [round-6 report](../brents-method.md)

No findings in round 6.

### Broyden's Method — `broydens-method` · [round-6 report](../broydens-method.md)

No findings in round 6.

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-6 report](../false-position-or-regula-falsi-method.md)

No findings in round 6.

### Fixed Point Iteration — `fixed-point-iteration` · [round-6 report](../fixed-point-iteration.md)

No findings in round 6.

### Graeffe's Method — `graeffes-method` · [round-6 report](../graeffes-method.md)

No findings in round 6.

### Halley's Method — `halleys-method` · [round-6 report](../halleys-method.md)

No findings in round 6.

### Improved Newton Method — `improved-newton-method` · [round-6 report](../improved-newton-method.md)

No findings in round 6.

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-6 report](../madsen-reid-method.md)

No findings in round 6.

### Muller's Method — `mullers-method` · [round-6 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation / Page match | In Case 3 the last frames show no visible iteration | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-6 report](../newton-raphson-method.md)

No findings in round 6.

### Nonlinear Systems — `nonlinear-systems` · [round-6 report](../nonlinear-systems.md)

No findings in round 6.

### Secant Method — `secant-method` · [round-6 report](../secant-method.md)

No findings in round 6.

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-6 report](../aitkens-and-nevilles-interpolation.md)

No findings in round 6.

### B-Splines — `b-splines` · [round-6 report](../b-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the page replaces Mathews' only examples (B-spline interpolation) with a different topic (parametric clamped B-spline curves) | unverified | open |

### Bézier Curves — `bezier-curves` · [round-6 report](../bezier-curves.md)

No findings in round 6.

### Catenary — `catenary` · [round-6 report](../catenary.md)

No findings in round 6.

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-6 report](../chebyshev-approximation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity / Page match | The approximation interval is not marked in the frames, so extrapolation blow-up just past the interval looks like a failure of the method (page match / fidelit | unverified | open |

### Cubic Splines — `cubic-splines` · [round-6 report](../cubic-splines.md)

No findings in round 6.

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-6 report](../hermite-polynomial-interpolation.md)

No findings in round 6.

### Least Squares Lines — `least-squares-lines` · [round-6 report](../least-squares-lines.md)

No findings in round 6.

### Least Squares Polynomials — `least-squares-polynomials` · [round-6 report](../least-squares-polynomials.md)

No findings in round 6.

### Legendre Polynomials — `legendre-polynomials` · [round-6 report](../legendre-polynomials.md)

No findings in round 6.

### Rational Approximation — `rational-approximation` · [round-6 report](../rational-approximation.md)

No findings in round 6.

### The Tangent Parabola — `the-tangent-parabola` · [round-6 report](../the-tangent-parabola.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | the hold frames list "Tangent parabola T₂(x)" twice in the legend | unverified | open |

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-6 report](../derive-numerical-differentiation-formulae.md)

No findings in round 6.

### Numerical Differentiation — `numerical-differentiation` · [round-6 report](../numerical-differentiation.md)

No findings in round 6.

### Richardson Extrapolation — `richardson-extrapolation` · [round-6 report](../richardson-extrapolation.md)

No findings in round 6.

