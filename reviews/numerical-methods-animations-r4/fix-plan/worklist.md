# Fix worklist — every round-4 finding

Generated from the round-4 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D and R4-A…R4-C in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-4 report](../laurent-series.md)

No findings in round 4.

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-4 report](../maclaurin-and-taylor-series.md)

No findings in round 4.

### Padé Approximation — `pade-approximation` · [round-4 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | in Case 01, off-scale values are clamped onto the y = 0 border, so a diverging approximant is drawn as if it were 0 | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-4 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | unexplained identical "degree 1" and "degree 2" frames in Cases 14, 18, 19, 21 and 23 | unverified | open |
| F2 | Minor | Fidelity | Case 14 nodes depart from the archive's tan x example without a stated reason | unverified | open |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-4 report](../newton-interpolation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Cases 01–29 on this page do not say which function or interval they show | unverified | open |
| F2 | Minor | Fidelity | the divided-differences case uses a different interval and nodes from Mathews' Newton example, and the page gives no reason | unverified | open |

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-4 report](../2d-trapezoidal-and-simpson-rules.md)

No findings in round 4.

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-4 report](../adaptive-simpsons-rule.md)

No findings in round 4.

### Boole's Rule — `booles-rule` · [round-4 report](../booles-rule.md)

No findings in round 4.

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-4 report](../cubic-spline-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the later "largest pointwise gap" is not at the peak, as the text implies | unverified | open |

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-4 report](../gauss-legendre-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | smooth-contrast error "4×10⁻¹⁷" is not attainable in double precision | unverified | fixed — [fix record](../fixes/gauss-legendre-quadrature.md) |

### Midpoint Rule — `midpoint-rule` · [round-4 report](../midpoint-rule.md)

No findings in round 4.

### Monte Carlo Pi — `monte-carlo-pi` · [round-4 report](../monte-carlo-pi.md)

No findings in round 4.

### Newton-Cotes Integration — `newton-cotes-integration` · [round-4 report](../newton-cotes-integration.md)

No findings in round 4.

### Riemann Sums — `riemann-sums` · [round-4 report](../riemann-sums.md)

No findings in round 4.

### Romberg Integration — `romberg-integration` · [round-4 report](../romberg-integration.md)

No findings in round 4.

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-4 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 4.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-4 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 4.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-4 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 4.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-4 report](../adams-bashforth-moulton-method.md)

No findings in round 4.

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-4 report](../eulers-method-for-odes.md)

No findings in round 4.

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-4 report](../runge-kutta-fehlberg-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Case 1 says it "reconstructs" Mathews' Example 1, but its step controller is not the module's, so at the same tolerance its numbers differ from Mathews' Example | unverified | open |

### Runge-Kutta Method — `runge-kutta-method` · [round-4 report](../runge-kutta-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | the upturn is explained by stability and truncation error, but in every run that turns upward an RK4 stage value goes below y = 0, and the upturn depends on how | verified | fixed — [fix record](../fixes/runge-kutta-method.md) |

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-4 report](../taylor-series-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | The stated mechanism for Mathews' differing values is not reproduced | unverified | open |

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-4 report](../accelerated-and-modified-newton-raphson.md)

No findings in round 4.

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-4 report](../aitken-method-and-steffensen-acceleration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 2's final Steffensen error is given as "about 6 × 10⁻¹⁶", but it is 6.7 × 10⁻¹⁶ | unverified | open |

### Bisection Method — `bisection-method` · [round-4 report](../bisection-method.md)

No findings in round 4.

### Brent's Method — `brents-method` · [round-4 report](../brents-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "The non-trivial root of tan(x) = 2x" implies there is only one | unverified | open |
| F2 | Minor | Implementation | the last steps of each animation cannot be told apart, so the fast convergence the page describes does not show | unverified | open |

### Broyden's Method — `broydens-method` · [round-4 report](../broydens-method.md)

No findings in round 4.

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-4 report](../false-position-or-regula-falsi-method.md)

No findings in round 4.

### Fixed Point Iteration — `fixed-point-iteration` · [round-4 report](../fixed-point-iteration.md)

No findings in round 4.

### Graeffe's Method — `graeffes-method` · [round-4 report](../graeffes-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "Diagnostic signature of two roots of equal magnitude" claims more than is true | unverified | open |

### Halley's Method — `halleys-method` · [round-4 report](../halleys-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 2 frame annotation reads "x₂ = -2.0", which contradicts the page's "Halley [first reaches −2 exactly] at x₃" | unverified | open |

### Improved Newton Method — `improved-newton-method` · [round-4 report](../improved-newton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "each drawn line is the tangent" leaves out the vertical segments | unverified | open |

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-4 report](../madsen-reid-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the "Note on generalization" overstates how far the method's structure carries over | unverified | open |

### Muller's Method — `mullers-method` · [round-4 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | In Case 1, the window is too coarse to show the case's central claim from frame 3 onward | unverified | open |
| F2 | Minor | Fidelity | Case 1 reuses Mathews' Example 1 but replaces his complex-case rule without saying so | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-4 report](../newton-raphson-method.md)

No findings in round 4.

### Nonlinear Systems — `nonlinear-systems` · [round-4 report](../nonlinear-systems.md)

No findings in round 4.

### Secant Method — `secant-method` · [round-4 report](../secant-method.md)

No findings in round 4.

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-4 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the page says the archive's examples are only tableaux, but Examples 3–5 also plot successive Neville interpolants | unverified | open |

### B-Splines — `b-splines` · [round-4 report](../b-splines.md)

No findings in round 4.

### Bézier Curves — `bezier-curves` · [round-4 report](../bezier-curves.md)

No findings in round 4.

### Catenary — `catenary` · [round-4 report](../catenary.md)

No findings in round 4.

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-4 report](../chebyshev-approximation-polynomial.md)

No findings in round 4.

### Cubic Splines — `cubic-splines` · [round-4 report](../cubic-splines.md)

No findings in round 4.

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-4 report](../hermite-polynomial-interpolation.md)

No findings in round 4.

### Least Squares Lines — `least-squares-lines` · [round-4 report](../least-squares-lines.md)

No findings in round 4.

### Least Squares Polynomials — `least-squares-polynomials` · [round-4 report](../least-squares-polynomials.md)

No findings in round 4.

### Legendre Polynomials — `legendre-polynomials` · [round-4 report](../legendre-polynomials.md)

No findings in round 4.

### Rational Approximation — `rational-approximation` · [round-4 report](../rational-approximation.md)

No findings in round 4.

### The Tangent Parabola — `the-tangent-parabola` · [round-4 report](../the-tangent-parabola.md)

No findings in round 4.

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-4 report](../derive-numerical-differentiation-formulae.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the Derivation Notes say five-point formulas are O(h^4) without saying which derivatives | unverified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |

### Numerical Differentiation — `numerical-differentiation` · [round-4 report](../numerical-differentiation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the list of material that is not animated is incomplete | unverified | open |

### Richardson Extrapolation — `richardson-extrapolation` · [round-4 report](../richardson-extrapolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | legacy Examples 1, 3, 4 (error-bound graphs) dropped without mention | unverified | open |

