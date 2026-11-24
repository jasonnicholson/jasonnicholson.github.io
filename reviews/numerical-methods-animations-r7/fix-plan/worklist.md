# Fix worklist — every round-7 finding

Generated from the round-7 page reports in this folder. One row per finding, grouped by the round-1 work packages. **Check**: *verified* = an independent checker confirmed it (all Error and Misleading findings were); *unverified* = a Minor finding never re-checked, so the fixer must reproduce it first. Status starts `open` and is set when the page is committed, with a link to its fix record. Decisions R2-A…R2-D and R3-A…R3-D and R4-A…R4-D and R5-A…R5-F and R6-A…R6-E and R7-A…R7-D in [`../../numerical-methods-animations/fix-plan/README.md`](../../numerical-methods-animations/fix-plan/README.md) apply.

## WP-A

### Laurent Series — `laurent-series` · [round-7 report](../laurent-series.md)

No findings in round 7.

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-7 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | final orders are far below Mathews', so many GIFs never show the convergence the archive animations were built to show | unverified | open |

### Padé Approximation — `pade-approximation` · [round-7 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | 21 frames draw a true pole as a short finite spike | unverified | open |
| F2 | Minor | Fidelity | the Mathews convergence-interval display and higher orders are dropped without saying so | unverified | open |

## WP-B

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-7 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F3 | Misleading | Implementation | clamping draws false flat tops on the interpolant between the nodes | verified | open |
| F1 | Minor | Page match | the "degree" in the titles and intro is the nominal degree, and for symmetric cases the polynomial drawn has lower degree | unverified | open |
| F2 | Minor | Fidelity | Cases 18 and 20 use wider node intervals than Mathews' worked examples for those animations, with no reason given | unverified | open |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-7 report](../newton-interpolation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Implementation | clamping draws false flat tops on the interpolant between the nodes | verified | open |
| F2 | Minor | Implementation | outside the nodes the clamped interpolant runs along the plot border | unverified | open |
| F3 | Minor | Page match | 54 of 290 frames are titled with a degree above the polynomial's exact degree | unverified | open |
| F4 | Minor | Fidelity | Case 18 uses nodes on [-2.2, 2.2]; Mathews' linked example uses [-2, 2] | unverified | open |

## WP-C

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-7 report](../2d-trapezoidal-and-simpson-rules.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the rule definitions write `≈` where the page means `=` | unverified | fixed — [fix record](../fixes/2d-trapezoidal-and-simpson-rules.md) |

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-7 report](../adaptive-simpsons-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | the 11-point stage differs from Mathews' sequence | unverified | open |
| F2 | Minor | Page match | "41 points" is the drawn node count, not the number of points the test samples | unverified | open |

### Boole's Rule — `booles-rule` · [round-7 report](../booles-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "in this set" has no referent on this page | unverified | fixed — [fix record](../fixes/booles-rule.md) |

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-7 report](../cubic-spline-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "Each frame" includes an opening frame that has no spline | unverified | fixed — [fix record](../fixes/cubic-spline-quadrature.md) |

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-7 report](../gauss-legendre-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Node stems in the bar colour make each bar look like two bars | unverified | open |

### Midpoint Rule — `midpoint-rule` · [round-7 report](../midpoint-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "From 4 sample points on" is true of the animation but not of all n | unverified | open |

### Monte Carlo Pi — `monte-carlo-pi` · [round-7 report](../monte-carlo-pi.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the alt text says the estimate "approaches pi", without the fluctuation the run shows | unverified | open |

### Newton-Cotes Integration — `newton-cotes-integration` · [round-7 report](../newton-cotes-integration.md)

No findings in round 7.

### Riemann Sums — `riemann-sums` · [round-7 report](../riemann-sums.md)

No findings in round 7.

### Romberg Integration — `romberg-integration` · [round-7 report](../romberg-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | "Each frame adds one Romberg row" is not true of the opening frame | unverified | open |

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-7 report](../simpsons-3-8-rule-for-numerical-integration.md)

No findings in round 7.

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-7 report](../simpsons-rule-for-numerical-integration.md)

No findings in round 7.

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-7 report](../trapezoidal-rule-for-numerical-integration.md)

No findings in round 7.

## WP-D

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-7 report](../adams-bashforth-moulton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "a close end value" at m = 12 is 2.6 times the exact value | verified | fixed — [fix record](../fixes/adams-bashforth-moulton-method.md) |

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-7 report](../eulers-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "each step multiplies the error ... by $1+h\,\partial f/\partial y<-1$" is false once the error is large | verified | fixed — [fix record](../fixes/eulers-method-for-odes.md) |
| F2 | Minor | Page match | the shaded band is evaluated on the reference solution, but neither the page nor the frame says so | unverified | fixed — [fix record](../fixes/eulers-method-for-odes.md) |
| F3 | Minor | Page match | "about halves when $m$ doubles" holds only from $m=45$, but the sentence is written for the whole sweep | unverified | fixed — [fix record](../fixes/eulers-method-for-odes.md) |

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-7 report](../runge-kutta-fehlberg-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the module's acceptance test is stated without its second branch | unverified | open |

### Runge-Kutta Method — `runge-kutta-method` · [round-7 report](../runge-kutta-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | $k_j$ is called a slope, then used as an increment | unverified | open |
| F2 | Minor | Page match | the "own truncation error" versus "carried error" split depends on a definition the page does not state | unverified | open |

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-7 report](../taylor-series-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Fidelity | the page says Mathews' negative-`y` evaluation is unreproduced, but his program prints the rule and it reproduces all 42 values | verified | open |
| F2 | Misleading | Page match | at $m=80$ (Case 1) the shaded "unstable" band contains no step, and "the last steps" is wrong | verified | open |
| F3 | Misleading | Page match | at $m=70$ (Case 2) the error rise is attributed to stability, but no step amplifies | verified | open |

## WP-E

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-7 report](../accelerated-and-modified-newton-raphson.md)

No findings in round 7.

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-7 report](../aitken-method-and-steffensen-acceleration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | Case 1 presents 6.6e-9 as a double-precision limit | verified | open |
| F2 | Minor | Page match | the "Convergence order" column gives a rate as if it were an order | unverified | open |
| F3 | Minor | Page match | "far more accurate than either step alone" is stated for every outer iteration | unverified | open |

### Bisection Method — `bisection-method` · [round-7 report](../bisection-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 2's walk away from the root depends on an unstated tie rule | unverified | fixed — [fix record](../fixes/bisection-method.md) |

### Brent's Method — `brents-method` · [round-7 report](../brents-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 1 alt text says the bracket narrows to the root, but it stops 3.2e-4 wide | unverified | fixed — [fix record](../fixes/brents-method.md) |

### Broyden's Method — `broydens-method` · [round-7 report](../broydens-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "each iteration is far cheaper" does not hold for the algorithm the page gives | verified | open |
| F2 | Minor | Page match | Case B's final residual is quoted to a digit that rounding decides | unverified | open |
| F3 | Minor | Implementation | false comment about term size in `broydenbb.jl` | unverified | open |

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-7 report](../false-position-or-regula-falsi-method.md)

No findings in round 7.

### Fixed Point Iteration — `fixed-point-iteration` · [round-7 report](../fixed-point-iteration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | Case 1 attributes convergence from $x_0 = 0.1$ to the slope at $x^$ | verified | open |
| F2 | Minor | Implementation | code comment), Minor: Case 6 orbit bound is wrong in the third decimal | unverified | open |

### Graeffe's Method — `graeffes-method` · [round-7 report](../graeffes-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the scripts do not "square the coefficients" | unverified | fixed — [fix record](../fixes/graeffes-method.md) |
| F2 | Minor | Page match | "halved each iteration" is not true of the first two steps | unverified | fixed — [fix record](../fixes/graeffes-method.md) |

### Halley's Method — `halleys-method` · [round-7 report](../halleys-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Timing claim holds for only one of the two displayed Halley formulas | unverified | open |

### Improved Newton Method — `improved-newton-method` · [round-7 report](../improved-newton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 5 gives the Method C candidates the wrong first index | verified | fixed — [fix record](../fixes/improved-newton-method.md) |
| F2 | Misleading | Page match | Case 4 credits "the improved methods" with an advantage that needs $m$ | verified | fixed — [fix record](../fixes/improved-newton-method.md) |
| F3 | Minor | Page match | "quadratically if the root is simple" is false for the page's own simple-root function | unverified | fixed — [fix record](../fixes/improved-newton-method.md) |

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-7 report](../madsen-reid-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | in Case 2's zoomed frames the "second Δx" cannot be seen, because earlier steps paint the whole axis green | verified | open |

### Muller's Method — `mullers-method` · [round-7 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the description of Mathews' program omits his point-selection rule, which changes his iterates from $p_7$ on | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-7 report](../newton-raphson-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "convex side of the root" gives the wrong reason for monotone convergence | verified | open |
| F2 | Minor | Page match | Case 3 heading names the wrong feature | unverified | open |
| F3 | Minor | Page match | the introduction's summary does not fit half the cases | unverified | open |

### Nonlinear Systems — `nonlinear-systems` · [round-7 report](../nonlinear-systems.md)

No findings in round 7.

### Secant Method — `secant-method` · [round-7 report](../secant-method.md)

No findings in round 7.

## WP-F

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-7 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "The intermediate entries differ" hides that the two tableaux share their whole diagonal | verified | fixed — [fix record](../fixes/aitkens-and-nevilles-interpolation.md) |

### B-Splines — `b-splines` · [round-7 report](../b-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | the legend hides the running sum where the partition of unity is being shown | unverified | open |

### Bézier Curves — `bezier-curves` · [round-7 report](../bezier-curves.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 1 alt text says the level-1 and level-2 points trace the curve | unverified | fixed — [fix record](../fixes/bezier-curves.md) |

### Catenary — `catenary` · [round-7 report](../catenary.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Fidelity | the page uses a different catenary from Mathews' without saying so, and line 17 cannot hold for the page's formula | verified | fixed — [fix record](../fixes/catenary.md) |

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-7 report](../chebyshev-approximation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the blue curve also leaves the frame inside the interval | unverified | open |
| F2 | Minor | Fidelity | Case 26 uses [0.5, 5], but the legacy animation itself uses [0.05, 5] | unverified | open |

### Cubic Splines — `cubic-splines` · [round-7 report](../cubic-splines.md)

No findings in round 7.

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-7 report](../hermite-polynomial-interpolation.md)

No findings in round 7.

### Least Squares Lines — `least-squares-lines` · [round-7 report](../least-squares-lines.md)

No findings in round 7.

### Least Squares Polynomials — `least-squares-polynomials` · [round-7 report](../least-squares-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | the printed quintic does not interpolate at its printed precision | unverified | open |

### Legendre Polynomials — `legendre-polynomials` · [round-7 report](../legendre-polynomials.md)

No findings in round 7.

### Rational Approximation — `rational-approximation` · [round-7 report](../rational-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | source comment says the minimax approximant has no interpolation nodes | unverified | open |

### The Tangent Parabola — `the-tangent-parabola` · [round-7 report](../the-tangent-parabola.md)

No findings in round 7.

## WP-G

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-7 report](../derive-numerical-differentiation-formulae.md)

No findings in round 7.

### Numerical Differentiation — `numerical-differentiation` · [round-7 report](../numerical-differentiation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Case 2 claims to follow Example 14 but omits the construction that distinguishes it | unverified | open |

### Richardson Extrapolation — `richardson-extrapolation` · [round-7 report](../richardson-extrapolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Fidelity | Example 7 (and 2(a), 6) missing from the page's otherwise explicit list of what is not animated | unverified | open |

