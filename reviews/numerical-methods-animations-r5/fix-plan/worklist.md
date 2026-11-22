# Fix worklist — every round-5 finding

Generated from the round-5 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D and R4-A…R4-D and R5-A…R5-F in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-5 report](../laurent-series.md)

No findings in round 5.

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-5 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F2 | Minor | Page match | alt text), Minor: M03 alt text reads as a different function | unverified | fixed — [fix record](../fixes/maclaurin-and-taylor-series.md) |

### Padé Approximation — `pade-approximation` · [round-5 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | some real poles inside the plot window appear as short finite spikes, not as poles. Minor | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-5 report](../lagrange-polynomial-interpolation-and-approximation.md)

No findings in round 5.

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-5 report](../newton-interpolation-polynomial.md)

No findings in round 5.

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-5 report](../2d-trapezoidal-and-simpson-rules.md)

No findings in round 5.

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-5 report](../adaptive-simpsons-rule.md)

No findings in round 5.

### Boole's Rule — `booles-rule` · [round-5 report](../booles-rule.md)

No findings in round 5.

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-5 report](../cubic-spline-quadrature.md)

No findings in round 5.

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-5 report](../gauss-legendre-quadrature.md)

No findings in round 5.

### Midpoint Rule — `midpoint-rule` · [round-5 report](../midpoint-rule.md)

No findings in round 5.

### Monte Carlo Pi — `monte-carlo-pi` · [round-5 report](../monte-carlo-pi.md)

No findings in round 5.

### Newton-Cotes Integration — `newton-cotes-integration` · [round-5 report](../newton-cotes-integration.md)

No findings in round 5.

### Riemann Sums — `riemann-sums` · [round-5 report](../riemann-sums.md)

No findings in round 5.

### Romberg Integration — `romberg-integration` · [round-5 report](../romberg-integration.md)

No findings in round 5.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-5 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 5.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-5 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 5.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-5 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 5.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-5 report](../adams-bashforth-moulton-method.md)

No findings in round 5.

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-5 report](../eulers-method-for-odes.md)

No findings in round 5.

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-5 report](../runge-kutta-fehlberg-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | The Description's step-size rule leaves out the $h_{max}=0.25$ cap, which is binding in Case 2 | unverified | fixed — [fix record](../fixes/runge-kutta-fehlberg-method.md) |

### Runge-Kutta Method — `runge-kutta-method` · [round-5 report](../runge-kutta-method.md)

No findings in round 5.

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-5 report](../taylor-series-method-for-odes.md)

No findings in round 5.

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-5 report](../accelerated-and-modified-newton-raphson.md)

No findings in round 5.

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-5 report](../aitken-method-and-steffensen-acceleration.md)

No findings in round 5.

### Bisection Method — `bisection-method` · [round-5 report](../bisection-method.md)

No findings in round 5.

### Brent's Method — `brents-method` · [round-5 report](../brents-method.md)

No findings in round 5.

### Broyden's Method — `broydens-method` · [round-5 report](../broydens-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Final Case A residual is quoted to two digits at roundoff level (Page match, Minor) | unverified | fixed — [fix record](../fixes/broydens-method.md) |

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-5 report](../false-position-or-regula-falsi-method.md)

No findings in round 5.

### Fixed Point Iteration — `fixed-point-iteration` · [round-5 report](../fixed-point-iteration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | The file stems and case order for Mathews' Examples 7 and 8 are swapped relative to the archive | unverified | open |

### Graeffe's Method — `graeffes-method` · [round-5 report](../graeffes-method.md)

No findings in round 5.

### Halley's Method — `halleys-method` · [round-5 report](../halleys-method.md)

No findings in round 5.

### Improved Newton Method — `improved-newton-method` · [round-5 report](../improved-newton-method.md)

No findings in round 5.

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-5 report](../madsen-reid-method.md)

No findings in round 5.

### Muller's Method — `mullers-method` · [round-5 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Case 2's later frames show no visible parabola or step | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-5 report](../newton-raphson-method.md)

No findings in round 5.

### Nonlinear Systems — `nonlinear-systems` · [round-5 report](../nonlinear-systems.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "Linear (when it converges)" for fixed-point iteration | unverified | fixed — [fix record](../fixes/nonlinear-systems.md) |

### Secant Method — `secant-method` · [round-5 report](../secant-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | Case 3 animation: last frames show "p8 = 0" and then three static frames with filler iterates (Implementation/display, Minor) | unverified | fixed — [fix record](../fixes/secant-method.md) |

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-5 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | The animated example is the page's own and none of Mathews' worked examples is used | unverified | open |

### B-Splines — `b-splines` · [round-5 report](../b-splines.md)

No findings in round 5.

### Bézier Curves — `bezier-curves` · [round-5 report](../bezier-curves.md)

No findings in round 5.

### Catenary — `catenary` · [round-5 report](../catenary.md)

No findings in round 5.

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-5 report](../chebyshev-approximation-polynomial.md)

No findings in round 5.

### Cubic Splines — `cubic-splines` · [round-5 report](../cubic-splines.md)

No findings in round 5.

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-5 report](../hermite-polynomial-interpolation.md)

No findings in round 5.

### Least Squares Lines — `least-squares-lines` · [round-5 report](../least-squares-lines.md)

No findings in round 5.

### Least Squares Polynomials — `least-squares-polynomials` · [round-5 report](../least-squares-polynomials.md)

No findings in round 5.

### Legendre Polynomials — `legendre-polynomials` · [round-5 report](../legendre-polynomials.md)

No findings in round 5.

### Rational Approximation — `rational-approximation` · [round-5 report](../rational-approximation.md)

No findings in round 5.

### The Tangent Parabola — `the-tangent-parabola` · [round-5 report](../the-tangent-parabola.md)

No findings in round 5.

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-5 report](../derive-numerical-differentiation-formulae.md)

No findings in round 5.

### Numerical Differentiation — `numerical-differentiation` · [round-5 report](../numerical-differentiation.md)

No findings in round 5.

### Richardson Extrapolation — `richardson-extrapolation` · [round-5 report](../richardson-extrapolation.md)

No findings in round 5.

