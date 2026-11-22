# Fix worklist — every round-1 finding

Generated from the round-1 page reports in this folder. One row per finding, grouped by work package (see [README.md](README.md)) and page. The **Status** column starts as `open`; the fix director sets it to `fixed`, `not reproduced`, `deferred` or `open (failed check)` when it commits the page, and links the page's fix record.

Severity and check columns are copied from the round-1 report: **verified** means an independent checker confirmed the finding; **unverified** means a Minor finding that was never re-checked, so the fixer must reproduce it before changing anything.

## WP-A series coefficients

### Laurent Series — `laurent-series` · [round-1 report](../laurent-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The "two-sided" Laurent truncation is just the degree-N Taylor polynomial in every case; negative-power terms are never computed and no case has a principal part | verified | open |
| F2 | Minor | Implementation | Fitted coefficients for the Γ and Y₀ cases (22–27) are inaccurate at high order, so the last frames are not quite the stated truncation | unverified | open |

### Maclaurin and Taylor Series — `maclaurin-and-taylor-series` · [round-1 report](../maclaurin-and-taylor-series.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | None of the 13 "Taylor" cases (T01–T13) uses Taylor coefficients: they come from a least-squares polynomial fit over a wide stencil, and many are wrong in sign and magnitude | verified | open |
| F2 | Error | Page match | The Description's convergence heuristic ("asymptotes" and "behaves like a polynomial") is false, and five cases on this same page contradict it | verified | open |
| F3 | Minor | Page match | "smooth transition between successive partial sums" does not describe the GIFs | unverified | open |
| F4 | Minor | Page match | Order-of-accuracy example is off by one under the site's meaning of "numerical integration" | unverified | open |
| F5 | Minor | Page match | "Other infinite series exist, such as the Laurent or the Power series" | unverified | open |

### Padé Approximation — `pade-approximation` · [round-1 report](../pade-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Γ and Y0 cases (22–27) are built from least-squares-fitted Taylor coefficients that are wrong by up to 13%, so many of their frames are not the Padé approximants of Γ or Y0 | verified | open |
| F2 | Minor | Implementation | When the Padé system is singular and inconsistent, `pinv` returns a least-squares denominator, so a few frames show a curve that is not a Padé approximant of any kind | unverified | open |
| F3 | Minor | Page match | The Description says R always matches f through order m+n, but about 170 frames show degenerate table entries that cannot | unverified | open |

## WP-B shared interpolation script

### Lagrange Polynomial Interpolation and Approximation — `lagrange-polynomial-interpolation-and-approximation` · [round-1 report](../lagrange-polynomial-interpolation-and-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | "Degree increases one step at a time" is false after degree 5 | verified | open |
| F2 | Error | Implementation | Barycentric evaluation fails far outside the nodes and draws spurious vertical bars (cases 04 and 29) | verified | open |
| F3 | Misleading | Page match | The page refers to "listed node intervals" and a "function-and-interval list" that it never gives | verified | open |
| F4 | Misleading | Implementation / Page match | Nodes are inset 3% from each end of the interval, which hides endpoint behaviour (notably √x at 0) | verified | open |
| F5 | Minor | Implementation | Case 14 degree-13 frame: two of the 14 nodes are off-screen | unverified | open |

### Newton Interpolation Polynomial — `newton-interpolation-polynomial` · [round-1 report](../newton-interpolation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Roundoff in the barycentric evaluation draws spurious vertical bars in lagnewt04 (degree 15) and lagnewt29 (degrees 13, 15) | verified | open |
| F2 | Error | Page match | "increases polynomial degree one step at a time" is false after degree 5 | verified | open |
| F3 | Minor | Page match | The linked "Newton" source never forms divided differences; it evaluates barycentric Lagrange | unverified | open |
| F4 | Minor | Implementation | newtpolybb.gif titles every frame "Runge Phenomenon", but frames 0–9 show extrapolation, not Runge oscillation (orphan file) | unverified | open |

## WP-C quadrature (non-smooth integrand)

### 2D Trapezoidal and Simpson Rules — `2d-trapezoidal-and-simpson-rules` · [round-1 report](../2d-trapezoidal-and-simpson-rules.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | The wireframe overlay hides the coloured surface of f, so neither GIF shows the surface | unverified | open |
| F2 | Minor | Page match | The Simpson GIF draws the same piecewise-bilinear facets as the Trapezoidal GIF; only the title differs | unverified | open |

### Adaptive Simpson's Rule — `adaptive-simpsons-rule` · [round-1 report](../adaptive-simpsons-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The page's 15ε criterion does not produce the refinement shown; the animation follows a factor-1 test that keeps the coarse S(a,b) | verified | fixed — [fix record](../fixes/adaptive-simpsons-rule.md) |
| F2 | Misleading | Page match | The animation never shows where the nodes are, so the claimed nonuniform concentration cannot be seen | verified | fixed — [fix record](../fixes/adaptive-simpsons-rule.md) |
| F3 | Minor | Implementation | The script runs no adaptive algorithm: `tol` is only a label and the node sets are hard-coded | unverified | fixed — [fix record](../fixes/adaptive-simpsons-rule.md) |

### Boole's Rule — `booles-rule` · [round-1 report](../booles-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Behavior paragraph claims sixth-order, rapid convergence; the computed sequence converges at order 5/3 | verified | open |

### Cubic Spline Quadrature — `cubic-spline-quadrature` · [round-1 report](../cubic-spline-quadrature.md)

No findings in round 1. Nothing to fix; included in the re-review.

### Gauss-Legendre Quadrature — `gauss-legendre-quadrature` · [round-1 report](../gauss-legendre-quadrature.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "stabilizes rapidly" hides the slow algebraic convergence caused by the x^(2/3) term | verified | open |
| F2 | Minor | Page match | "Each frame increases the quadrature order" does not hold for the first three frames | unverified | open |

### Midpoint Rule — `midpoint-rule` · [round-1 report](../midpoint-rule.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The O(Δx²) / "factor of 4" rate does not hold for the page's own integrand; the measured rate is Δx^(5/3) (factor about 3.17) | verified | open |
| F2 | Minor | Page match | "the estimate stabilizes quickly" overstates what the animated sequence does | unverified | open |

### Monte Carlo Pi — `monte-carlo-pi` · [round-1 report](../monte-carlo-pi.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Implementation | The `1/sqrt(n)` annotation is smaller than the error in every frame, so it reads as a bound that is always broken | unverified | open |

### Newton-Cotes Integration — `newton-cotes-integration` · [round-1 report](../newton-cotes-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "Higher degree ⇒ higher algebraic order" is false at the Simpson 1/3 → 3/8 step | verified | open |
| F2 | Minor | Page match | The page does not say its integrand is non-smooth at x = 0, which removes the order advantage of the higher-degree rules | unverified | open |

### Riemann Sums — `riemann-sums` · [round-1 report](../riemann-sums.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | "Lower/Upper Riemann Sum" scripts use the endpoint min/max, not the inf/sup on each subinterval | verified | open |
| F2 | Error | Page match | Cases 3 and 4 claim the sums are lower/upper bounds; the plotted values are not | verified | open |
| F3 | Misleading | Page match | "rises toward the integral" / "squeeze": the frame sequence is not monotone | verified | open |
| F4 | Minor | Implementation | "Sample Points = n" in the Lower/Upper GIFs counts subintervals, not sample points | unverified | open |

### Romberg Integration — `romberg-integration` · [round-1 report](../romberg-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The animated integrand defeats Romberg acceleration, but the page presents it as showing rapid diagonal convergence | verified | open |
| F2 | Minor | Page match | "The diagonal entry $R_{k,k}$ provides the best estimate at that stage" is false at stages k=2 and k=3 | unverified | open |
| F3 | Minor | Implementation | Romberg Table panel truncates the rows, so the triangle and the diagonal column are never visible | unverified | open |

### Simpson's 3/8 Rule for Numerical Integration — `simpsons-3-8-rule-for-numerical-integration` · [round-1 report](../simpsons-3-8-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | "fourth-order global error" and "converges rapidly" are false for this integrand; the measured order is 5/3 | verified | open |

### Simpson's Rule for Numerical Integration — `simpsons-rule-for-numerical-integration` · [round-1 report](../simpsons-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | "fourth-order global accuracy" is false for this integrand; the measured order is 5/3 | verified | open |

### Trapezoidal Rule for Numerical Integration — `trapezoidal-rule-for-numerical-integration` · [round-1 report](../trapezoidal-rule-for-numerical-integration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Stated $O(h^2)$ convergence is false for this integrand; the measured order is $5/3$ | verified | fixed — [fix record](../fixes/trapezoidal-rule-for-numerical-integration.md) |

## WP-D ODE step size and stability

### Adams-Bashforth-Moulton Method — `adams-bashforth-moulton-method` · [round-1 report](../adams-bashforth-moulton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | The ABM run goes unstable near the end; it does not track the reference "over the full interval" | verified | open |

### Euler's Method for ODE's — `eulers-method-for-odes` · [round-1 report](../eulers-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Heun does not end closer to the reference at t = 5; it ends about 9.5× farther away than Euler | verified | open |
| F2 | Misleading | Page match | Euler does not "drift low near t=5"; it runs high over the hump and then goes unstable, ending in a spike and a negative value | verified | open |

### Runge-Kutta-Fehlberg Method — `runge-kutta-fehlberg-method` · [round-1 report](../runge-kutta-fehlberg-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 2 "Behavior" puts the step tightening in the wrong place, and says the wrong thing causes the visible differences | verified | open |
| F2 | Misleading | Page match | Case 1: the RKF45 and RKF54 runs are the same to about 6 digits, and the RKF45 trace cannot be seen | verified | open |
| F3 | Misleading | Implementation (picture) | Case 1: the second half of the GIF is a frozen frame because the y-window stops at 20 while the solution reaches 139.9 | verified | open |
| F4 | Minor | Page match / Implementation | the step-size rule pairs the per-step error with the exponent that belongs to the per-unit-step error | unverified | open |

### Runge-Kutta Method — `runge-kutta-method` · [round-1 report](../runge-kutta-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | With h = 0.25, RK4 is unstable from about t = 3.25, so the second half of the animated trajectory is a numerical artifact | verified | fixed — [fix record](../fixes/runge-kutta-method.md) |
| F2 | Error | Page match | "RK4 tracks this with fourth-order accuracy even with the relatively coarse step size h=0.25" is false for the animation shown | verified | fixed — [fix record](../fixes/runge-kutta-method.md) |
| F3 | Minor | Page match | "giving $O(h^4)$ local accuracy" states the wrong error kind | unverified | fixed — [fix record](../fixes/runge-kutta-method.md) |

### Taylor Series Method for ODE's — `taylor-series-method-for-odes` · [round-1 report](../taylor-series-method-for-odes.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | With h = 0.25 both methods are unstable for t ≳ 3.25, so the last third of each animation shows a numerical blow-up, not the solution | verified | open |
| F2 | Error | Page match | "slightly better accuracy than order 3" is false in both directions | verified | open |
| F3 | Error | Page match | Order-3 Taylor does not match RK4 in order | verified | open |
| F4 | Misleading | Implementation / Page match | The "order 4" script gets y'''' by a finite difference, not analytically | verified | open |

## WP-E root finding

### Accelerated & Modified Newton-Raphson — `accelerated-and-modified-newton-raphson` · [round-1 report](../accelerated-and-modified-newton-raphson.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | Case 2's orange lines are called tangent lines but have half the tangent slope | verified | open |
| F2 | Misleading | Page match | Case 1's explanation says the tangent "crosses zero far from x*", but the frames show it landing halfway to the root | verified | open |
| F3 | Minor | Page match | Case 3 is said to converge "in just 2 steps", but the GIF shows x₂ = 0.999994 and is no faster than Case 2 | unverified | open |

### Aitken's Method & Steffensen's Acceleration — `aitken-method-and-steffensen-acceleration` · [round-1 report](../aitken-method-and-steffensen-acceleration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 1: Steffensen does not reach machine precision; it stalls at 6.6e-9 | verified | open |
| F2 | Misleading | Page match | Case 3: Steffensen stalls near 1e-8 and its error goes back up; the page says it "converges in only a few steps" | verified | open |
| F3 | Minor | Page match | Newton at a double root does not need "hundreds" of iterations and cannot reach machine precision in double precision | unverified | open |
| F4 | Minor | Page match | Case 2 wording suggests Δ² is applied to the plotted Newton iterates | unverified | open |

### Bisection Method — `bisection-method` · [round-1 report](../bisection-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Quoted root x* ≈ 1.3688 is wrong; the true root is 1.36523 | verified | fixed — [fix record](../fixes/bisection-method.md) |
| F2 | Error | Page match | "the midpoints converge monotonically" is false | verified | fixed — [fix record](../fixes/bisection-method.md) |
| F3 | Minor | Implementation (picture) | The last half of each animation is visually static because the axes never zoom | unverified | fixed — [fix record](../fixes/bisection-method.md) |

### Brent's Method — `brents-method` · [round-1 report](../brents-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 1 root is quoted as 0.3268; the true root is 0.32854 | verified | open |
| F2 | Error | Page match | Case 1 Behavior misstates the sequence of steps | verified | open |
| F3 | Error | Page match | The Description says a rejected IQI step falls back to the secant step | verified | open |
| F4 | Misleading | Implementation | The scripts run a modified Wikipedia pseudocode variant, not Brent's algorithm, and its step labels differ from Brent's | verified | open |
| F5 | Misleading | Page match | The Description's convergence guarantee is false | verified | open |
| F6 | Minor | Page match | Case 2's comparison with regula falsi: "≈ 243 iterations" cannot be reproduced, and "chord always lands near x = 0.5" is wrong | unverified | open |
| F7 | Minor | Page match | The Description mixes two incompatible labelings of a, b, c | unverified | open |

### Broyden's Method — `broydens-method` · [round-1 report](../broydens-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case B root y-coordinate is misrounded as −1.665; to 3 decimals it is −1.664 | unverified | open |
| F2 | Minor | Page match | "the second solution": the system has four real solutions, three of them inside the plotted window | unverified | open |
| F3 | Minor | Page match | Case B is said to illustrate that the method is "dimension-independent", but it does not show this | unverified | open |

### False Position or Regula Falsi Method — `false-position-or-regula-falsi-method` · [round-1 report](../false-position-or-regula-falsi-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case A root is quoted as 1.3688; the true root is 1.36523 | verified | fixed — [fix record](../fixes/false-position-or-regula-falsi-method.md) |
| F2 | Error | Page match | Case A says the left endpoint a = −1 stays fixed, but a moves and b = 2 is the fixed endpoint | verified | fixed — [fix record](../fixes/false-position-or-regula-falsi-method.md) |
| F3 | Error | Page match | Case B gets the one-sided behaviour backwards: a = 0 does not stay fixed, the points approach from the left, and the bracket shrinks from the left | verified | fixed — [fix record](../fixes/false-position-or-regula-falsi-method.md) |
| F4 | Minor | Implementation | A script comment says regula falsi is "slower than bisection"; on this problem it is faster | unverified | fixed — [fix record](../fixes/false-position-or-regula-falsi-method.md) |
| F5 | Minor | Page match | Each frame's secant joins the previous bracket's endpoints, but the frame marks and shades the updated bracket | unverified | fixed — [fix record](../fixes/false-position-or-regula-falsi-method.md) |

### Fixed Point Iteration — `fixed-point-iteration` · [round-1 report](../fixed-point-iteration.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Case 6 GIF shows clamped iterates labelled as real values, and draws a 0↔4 bounce that does not exist | verified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F2 | Error | Implementation | Case 5 GIF parks the iterate at x = 4.0 for six frames and labels it as the real value | verified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F3 | Error | Page match | Case 4 says g is "tangent to y = x at x* = 2 from below" | verified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F4 | Error | Page match | Case 4 is headed "Divergent", but the iteration converges to the other fixed point x = 0 | verified | fixed — [fix record](../fixes/fixed-point-iteration.md) |
| F5 | Misleading | Page match | Case 6 says the staircase "spirals outward"; the true orbit is bounded and settles onto a 4-cycle | verified | fixed — [fix record](../fixes/fixed-point-iteration.md) |

### Graeffe's Method — `graeffes-method` · [round-1 report](../graeffes-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | The Separated Root Theorem formula in the Description is upside down | verified | fixed — [fix record](../fixes/graeffes-method.md) |
| F2 | Misleading | Implementation | In Case 2, floating-point overflow silently empties the last three frames | verified | fixed — [fix record](../fixes/graeffes-method.md) |
| F3 | Minor | Implementation | In Case 1, overflow at the last frame drops r₃ and r₄ | unverified | fixed — [fix record](../fixes/graeffes-method.md) |
| F4 | Minor | Implementation | Some starting estimates fall outside the y-axis limits | unverified | fixed — [fix record](../fixes/graeffes-method.md) |
| F5 | Minor | Page match | Linear convergence is attributed to repeated or distinct roots when it depends on equal magnitudes | unverified | fixed — [fix record](../fixes/graeffes-method.md) |
| F6 | Minor | Page match | The Case 1 alt text says every estimate grows toward its target | unverified | fixed — [fix record](../fixes/graeffes-method.md) |

### Halley's Method — `halleys-method` · [round-1 report](../halleys-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Description says Halley's iterate is the root of the osculating Taylor parabola; it is not | verified | fixed — [fix record](../fixes/halleys-method.md) |
| F2 | Error | Implementation | The animations present the Taylor parabola as Halley's construction, but the Halley iterate is not its intercept (in Case 1b the parabola coincides with f) | verified | fixed — [fix record](../fixes/halleys-method.md) |
| F3 | Error | Page match | Case 2 says the parabola "visibly corrects the Newton overshoot"; Newton does not overshoot and nothing is visibly corrected | verified | fixed — [fix record](../fixes/halleys-method.md) |
| F4 | Minor | Page match | Animations intro describes all three animations as tangent + parabola with a "blue dotted" tangent; Case 1a has no parabola and a dashed tangent | unverified | fixed — [fix record](../fixes/halleys-method.md) |
| F5 | Minor | Page match | Case 1b cites $g'''(x^*)$ and $g''(x^*)$ without defining g | unverified | fixed — [fix record](../fixes/halleys-method.md) |

### Improved Newton Method — `improved-newton-method` · [round-1 report](../improved-newton-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Method A (m=3) frames show floating-point noise as iterates: x₃ and x₄ are wrong, and x₄ jumps away from the root | verified | open |
| F2 | Error | Page match | "Methods A, B, and C do not fix this case" is false for Method B | verified | open |
| F3 | Minor | Implementation | Method A (m=2) frame for x₄ shows 0.999999, a roundoff artefact | unverified | open |
| F4 | Minor | Page match | Intro describes every case as a "tangent-line diagram … on functions with multiple roots" | unverified | open |
| F5 | Minor | Page match | Methods B and C are cited but never defined, and Method C's stated test uses the unknown root p | unverified | open |
| F6 | Minor | Implementation | Titles cut off in the triple-root animations | unverified | open |

### Damped Newton with Acceleration (Madsen-Reid Method) — `madsen-reid-method` · [round-1 report](../madsen-reid-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | The "acceleration" the page names the method after is not implemented; r0 is only a cap that never activates | verified | open |
| F2 | Error | Page match | Case 2 claims damping, acceleration and faster-than-linear convergence; the animation shows plain linear Newton with no damping | verified | open |
| F3 | Error | Page match | Wrong explanation of why Newton slows at a multiple root | verified | open |
| F4 | Minor | Page match | "The star markers show the exact root(s)": Cases 1 and 2 have no root markers | unverified | open |
| F5 | Minor | Page match | Case 1 implies damping in the first frames; there is none | unverified | open |
| F6 | Minor | Page match | Case 3: not every orange segment is an alterdirection escape, and the path is not curved | unverified | open |
| F7 | Minor | Implementation / Page match | alterdirection is accepted unchecked; in the real scripts it is a reversal, not a 53° rotation | unverified | open |

### Muller's Method — `mullers-method` · [round-1 report](../mullers-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Case 1 is not Muller's method: every step has complex roots and the script silently keeps only the real part | verified | open |
| F2 | Error | Page match | "the next iterate is found where the parabola crosses the x-axis" is false for Case 1 | verified | open |
| F3 | Error | Page match | Convergence order "≈ 1.84" is the simple-root order; at these double roots it is ≈ 1.23 | verified | open |
| F4 | Minor | Page match | Case 3 heading says "double root near x = 2" | unverified | open |
| F5 | Minor | Implementation | Case 1 first frame shows only two of the three points | unverified | open |

### Newton-Raphson Method — `newton-raphson-method` · [round-1 report](../newton-raphson-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 1 root quoted as 0.2910; the true root is 0.25485 | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F2 | Error | Page match | Case 1 says "A single real root exists"; 3eˣ − 4cos x has infinitely many real roots | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F3 | Error | Page match | Case 1 iterates do not "overshoot then undershoot"; they decrease monotonically onto the root | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F4 | Error | Page match | Case 4 says x³ − x + 3 has no real roots; it has one, at x ≈ −1.6717 | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F5 | Error | Page match | Case 5 says Newton converges to 0 with leftward jumps; it diverges to +∞ with rightward jumps | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F6 | Misleading | Page match | Case 4 says the iterates "cycle or diverge"; they never diverge | verified | fixed — [fix record](../fixes/newton-raphson-method.md) |
| F7 | Minor | Implementation | newtondd.jl header calls the 4-cycle a cycle "between ~0 and ~3" | unverified | fixed — [fix record](../fixes/newton-raphson-method.md) |

### Nonlinear Systems — `nonlinear-systems` · [round-1 report](../nonlinear-systems.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The row-sum condition is presented as necessary for fixed-point convergence | verified | open |
| F2 | Minor | Page match | Case 2 Behavior describes the geometry wrongly | unverified | open |
| F3 | Minor | Page match | Case 1 start is not "between the two curves" | unverified | open |
| F4 | Minor | Page match | "\|g'(x*)\| ≈ 0" is scalar notation that this 2D page does not define | unverified | open |

### Secant Method — `secant-method` · [round-1 report](../secant-method.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 1 gives the wrong root (0.456 is the first iterate p2, not the root) | verified | fixed — [fix record](../fixes/secant-method.md) |
| F2 | Misleading | Page match | Case 6 says it illustrates order ≈ 1.618, but for arctan at its root the order is 2 | verified | fixed — [fix record](../fixes/secant-method.md) |
| F3 | Minor | Page match | Case 2 gives a backwards reason for the slow convergence | unverified | fixed — [fix record](../fixes/secant-method.md) |
| F4 | Minor | Implementation | Case 4 draws p3 and p9 at a clamped y = −5, off the secant line that is supposed to pass through them | unverified | fixed — [fix record](../fixes/secant-method.md) |
| F5 | Minor | Implementation | Case 5 labels p10 as "→ ∞" and shows six empty "Method diverged" frames, although the iterates only creep right by about 0.75 per step | unverified | fixed — [fix record](../fixes/secant-method.md) |
| F6 | Minor | Implementation | Case 4 script header gives the root as −1.6724 | unverified | fixed — [fix record](../fixes/secant-method.md) |

## WP-F interpolation and approximation

### Aitken's and Neville's Interpolation — `aitkens-and-nevilles-interpolation` · [round-1 report](../aitkens-and-nevilles-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Aitken's scheme is described as "the same recursion" as Neville's; it is a different recursion | verified | open |
| F2 | Misleading | Page match | The "degree 4" interpolant is the same cubic as degree 3; adding the fifth node changes nothing | verified | open |

### B-Splines — `b-splines` · [round-1 report](../b-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | "local support over exactly 4 knot spans" is false for the clamped basis the animation shows | verified | open |
| F2 | Misleading | Page match | Description uses subscript = degree, Animations use subscript = order | verified | open |
| F3 | Minor | Page match | Case 1 alt text says "traced through 7 control points using de Boor's algorithm" | unverified | open |
| F4 | Minor | Implementation | bsplineaa.jl comments misdescribe the animation and the knot vector | unverified | open |

### Bézier Curves — `bezier-curves` · [round-1 report](../bezier-curves.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | The traced blue curve is not in step with the red point and never reaches P3 | verified | open |
| F2 | Misleading | Implementation | The legend covers a control point in both GIFs, and in Case 2 it also covers the final curve point at P3 | verified | open |

### Catenary — `catenary` · [round-1 report](../catenary.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | Small-$c$ behaviour sentence misdescribes which curve is lower and where they separate | verified | open |

### Chebyshev Approximation Polynomial — `chebyshev-approximation-polynomial` · [round-1 report](../chebyshev-approximation-polynomial.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | The intro says the degree goes up one step at a time, but it skips degrees | verified | open |
| F2 | Error | Page match | Case 19 interpolates on [-0.999, 0.999], not on the [-1.5, 1.5] the alt text states | verified | open |
| F3 | Error | Implementation (picture) | The titles run off the right edge, so cases 19 and 20 show the wrong degree and case 21 shows none | verified | open |
| F4 | Minor | Implementation (picture) | For symmetric problems, "degree n−1" in the title overstates the interpolant's real degree | unverified | open |
| F5 | Minor | Implementation (picture) | The y-window cuts off the steep end of f, the outermost nodes and the largest error in several cases | unverified | open |
| F6 | Minor | Page match | "(expanded)" in the alt text for cases 04 and 29 matches nothing in the GIFs | unverified | open |

### Cubic Splines — `cubic-splines` · [round-1 report](../cubic-splines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | "Natural cubic spline converges at O(h^4) for smooth functions" is false in general | verified | open |
| F2 | Misleading | Page match | Description gives O(h^4) right after defining only the natural spline | verified | open |

### Hermite Polynomial Interpolation — `hermite-polynomial-interpolation` · [round-1 report](../hermite-polynomial-interpolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | The "doubling n cuts the error by ≈16" claim is contradicted by the frames shown | verified | open |
| F2 | Minor | Implementation | The Case 1 frame titles are cut off and hide the error value | unverified | open |
| F3 | Minor | Implementation | Case 2 y-limits clip the first two stages, so the basis-function behaviour the page describes is hidden | unverified | open |

### Least Squares Lines — `least-squares-lines` · [round-1 report](../least-squares-lines.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Minor | Page match | Case 1 "stabilize" is not what the slope sequence does | unverified | open |
| F2 | Minor | Page match | Intro says every animation shows residuals and fitted parameters | unverified | open |
| F3 | Minor | Implementation (picture) | Case 2: intersection marker never visible; k=2 label is inaccurate | unverified | open |
| F4 | Minor | Implementation (picture) | Parameter annotation overprints the legend in Cases 3 and 4 | unverified | open |
| F5 | Minor | Implementation | Mercury's distance in the Kepler data is about 0.55% low | unverified | open |

### Least Squares Polynomials — `least-squares-polynomials` · [round-1 report](../least-squares-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Page match | Intermediate frames are truncations of the final polynomial, not least-squares fits, yet are presented as "construction of the least-squares polynomial fit" | verified | open |
| F2 | Minor | Implementation / Page match | Coefficients are hard-coded rather than computed; the quintic RMS stated on the page is not what the script computes | unverified | open |
| F3 | Minor | Page match | Case 1 residual pattern misdescribed | unverified | open |
| F4 | Minor | Implementation | RMS annotation labels are cut off at the left edge in every frame | unverified | open |

### Legendre Polynomials — `legendre-polynomials` · [round-1 report](../legendre-polynomials.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | Series coefficients from a coarse trapezoid rule; c_8 is wrong by a factor of 2 and the "max err" in the last two titles is wrong | verified | open |
| F2 | Misleading | Page match | "Each added term refines the fit", but half the frames add a zero term and do not change | verified | open |

### Rational Approximation — `rational-approximation` · [round-1 report](../rational-approximation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Implementation | The "MinMax" approximant is not the minimax approximant; the search stalls at 8.846e-5 while the true minimax relative error is 8.680e-5 | verified | open |
| F2 | Misleading | Implementation (picture) | Relative-error panel's y-range (0 to 0.01) is about 60–115× the errors, so the error profiles the page discusses are invisible | verified | open |
| F3 | Minor | Implementation (picture) | Frame 3 marks the Chebyshev nodes as "nodes" although the MinMax approximant does not interpolate there | unverified | open |

### The Tangent Parabola — `the-tangent-parabola` · [round-1 report](../the-tangent-parabola.md)

No findings in round 1. Nothing to fix; included in the re-review.

## WP-G differentiation

### Derive Numerical Differentiation Formulae — `derive-numerical-differentiation-formulae` · [round-1 report](../derive-numerical-differentiation-formulae.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Page match | Case 3 heading says "at $x_0=1$", but the animation has no $x_0$ | verified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |
| F2 | Minor | Implementation | Error annotations rounded to a fixed number of decimals, so they show "0.0" or a wrong leading digit | unverified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |
| F3 | Minor | Implementation | Case 2 frame title is cut off, so the formula's divisor reads "/(12" | unverified | fixed — [fix record](../fixes/derive-numerical-differentiation-formulae.md) |

### Numerical Differentiation — `numerical-differentiation` · [round-1 report](../numerical-differentiation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Error | Implementation | numdiffaa titles are clipped, so frames 9–12 show false error values ("3.3", "8.0", "1.0", "0") | verified | fixed — [fix record](../fixes/numerical-differentiation.md) |
| F2 | Misleading | Implementation / Page match | the dashed "central secant" in numdiffab is not the secant through the stencil points | verified | fixed — [fix record](../fixes/numerical-differentiation.md) |
| F3 | Minor | Implementation | `round(maxerr; digits=6)` reports 1.33e-6 as "1.0e-6" and 3.33e-7 as "0.0" | unverified | fixed — [fix record](../fixes/numerical-differentiation.md) |
| F4 | Minor | Implementation | numdiffab title is clipped, so the "true" slope is cut short | unverified | fixed — [fix record](../fixes/numerical-differentiation.md) |

### Richardson Extrapolation — `richardson-extrapolation` · [round-1 report](../richardson-extrapolation.md)

| ID | Severity | Kind | Finding | Check | Status |
|---|---|---|---|---|---|
| F1 | Misleading | Implementation | Case 1 error annotation rounds the D5 error to "≈ 0.0" in 5 of 9 frames | verified | fixed — [fix record](../fixes/richardson-extrapolation.md) |

## Inventory items

| Item | Page | Status |
|---|---|---|
| `lagrangeaa.jl` is not linked from the page and its GIF is not committed | `lagrange-polynomial-interpolation-and-approximation` | open |
| `newtpolyaa.jl`/`.gif` and `newtpolybb.jl`/`.gif` are on disk but not linked or embedded | `newton-interpolation-polynomial` | open |
| Section index links `milne-simpsons-method/`, `predictor-corrector-methods/`, `shooting-methods-for-odes/` point to folders that do not exist (pages are flat `.qmd`) | `pages/numerical-methods/index.qmd` | open |
