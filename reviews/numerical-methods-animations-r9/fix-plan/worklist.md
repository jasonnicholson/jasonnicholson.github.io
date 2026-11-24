# Fix worklist — every round-9 finding

Generated from the round-9 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D and R4-A…R4-D and R5-A…R5-F and R6-A…R6-E and R7-A…R7-D and R8-A…R8-B and R9-A…R9-B in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-9 report](../laurent-series.md)

No findings in round 9.

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-9 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the maximum orders are far below the legacy animations, so several R = ∞ cases end with the polynomial still diverging over much of the window | unverified | deferred — owner decision R6-D, R9-A |

### Padé Approximation — `pade-approximation` · [round-9 report](../pade-approximation.md)

No findings in round 9.

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-9 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Γ's pole at x = 0 is not listed for Cases 24–26; f breaks there only because a grid point lands exactly on 0.0 | unverified | open |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-9 report](../newton-interpolation-polynomial.md)

No findings in round 9.

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-9 report](../2d-trapezoidal-and-simpson-rules.md)

No findings in round 9.

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-9 report](../adaptive-simpsons-rule.md)

No findings in round 9.

### Boole's Rule — `booles-rule` · [round-9 report](../booles-rule.md)

No findings in round 9.

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-9 report](../cubic-spline-quadrature.md)

No findings in round 9.

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-9 report](../gauss-legendre-quadrature.md)

No findings in round 9.

### Midpoint Rule — `midpoint-rule` · [round-9 report](../midpoint-rule.md)

No findings in round 9.

### Monte Carlo Pi — `monte-carlo-pi` · [round-9 report](../monte-carlo-pi.md)

No findings in round 9.

### Newton-Cotes Integration — `newton-cotes-integration` · [round-9 report](../newton-cotes-integration.md)

No findings in round 9.

### Riemann Sums — `riemann-sums` · [round-9 report](../riemann-sums.md)

No findings in round 9.

### Romberg Integration — `romberg-integration` · [round-9 report](../romberg-integration.md)

No findings in round 9.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-9 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 9.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-9 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 9.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-9 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 9.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-9 report](../adams-bashforth-moulton-method.md)

No findings in round 9.

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-9 report](../eulers-method-for-odes.md)

No findings in round 9.

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-9 report](../runge-kutta-fehlberg-method.md)

No findings in round 9.

### Runge-Kutta Method — `runge-kutta-method` · [round-9 report](../runge-kutta-method.md)

No findings in round 9.

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-9 report](../taylor-series-method-for-odes.md)

No findings in round 9.

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-9 report](../accelerated-and-modified-newton-raphson.md)

No findings in round 9.

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-9 report](../aitken-method-and-steffensen-acceleration.md)

No findings in round 9.

### Bisection Method — `bisection-method` · [round-9 report](../bisection-method.md)

No findings in round 9.

### Brent's Method — `brents-method` · [round-9 report](../brents-method.md)

No findings in round 9.

### Broyden's Method — `broydens-method` · [round-9 report](../broydens-method.md)

No findings in round 9.

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-9 report](../false-position-or-regula-falsi-method.md)

No findings in round 9.

### Fixed Point Iteration — `fixed-point-iteration` · [round-9 report](../fixed-point-iteration.md)

No findings in round 9.

### Graeffe's Method — `graeffes-method` · [round-9 report](../graeffes-method.md)

No findings in round 9.

### Halley's Method — `halleys-method` · [round-9 report](../halleys-method.md)

No findings in round 9.

### Improved Newton Method — `improved-newton-method` · [round-9 report](../improved-newton-method.md)

No findings in round 9.

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-9 report](../madsen-reid-method.md)

No findings in round 9.

### Muller's Method — `mullers-method` · [round-9 report](../mullers-method.md)

No findings in round 9.

### Newton-Raphson Method — `newton-raphson-method` · [round-9 report](../newton-raphson-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | `newtoncc.gif` legend prints `x₍6₎ = 0.0` and `x₍7₎ = -0.0` (Minor) | unverified | fixed — [fix record](../fixes/newton-raphson-method.md) |

### Nonlinear Systems — `nonlinear-systems` · [round-9 report](../nonlinear-systems.md)

No findings in round 9.

### Secant Method — `secant-method` · [round-9 report](../secant-method.md)

No findings in round 9.

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-9 report](../aitkens-and-nevilles-interpolation.md)

No findings in round 9.

### B-Splines — `b-splines` · [round-9 report](../b-splines.md)

No findings in round 9.

### Bézier Curves — `bezier-curves` · [round-9 report](../bezier-curves.md)

No findings in round 9.

### Catenary — `catenary` · [round-9 report](../catenary.md)

No findings in round 9.

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-9 report](../chebyshev-approximation-polynomial.md)

No findings in round 9.

### Cubic Splines — `cubic-splines` · [round-9 report](../cubic-splines.md)

No findings in round 9.

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-9 report](../hermite-polynomial-interpolation.md)

No findings in round 9.

### Least Squares Lines — `least-squares-lines` · [round-9 report](../least-squares-lines.md)

No findings in round 9.

### Least Squares Polynomials — `least-squares-polynomials` · [round-9 report](../least-squares-polynomials.md)

No findings in round 9.

### Legendre Polynomials — `legendre-polynomials` · [round-9 report](../legendre-polynomials.md)

No findings in round 9.

### Rational Approximation — `rational-approximation` · [round-9 report](../rational-approximation.md)

No findings in round 9.

### The Tangent Parabola — `the-tangent-parabola` · [round-9 report](../the-tangent-parabola.md)

No findings in round 9.

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-9 report](../derive-numerical-differentiation-formulae.md)

No findings in round 9.

### Numerical Differentiation — `numerical-differentiation` · [round-9 report](../numerical-differentiation.md)

No findings in round 9.

### Richardson Extrapolation — `richardson-extrapolation` · [round-9 report](../richardson-extrapolation.md)

No findings in round 9.

