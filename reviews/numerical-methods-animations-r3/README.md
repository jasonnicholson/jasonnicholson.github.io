# Numerical-methods animations — review, round 3

Run of 2026-11-22, scope `all`, on branch `fix/numerical-methods-animations` at `d621e64`. This is an independent re-review after the round-2 fixes. Reviewers and checkers did not read earlier rounds' reports or fix records. The comparison with earlier rounds below was written after this round's findings were final. Nothing under version control was changed.

## Headline

- **All 53 animation pages were reviewed. None was skipped.** That covers 113 scripts and 279 GIFs.
- **Findings: 0 Error, 3 Misleading, 28 Minor.** 10 of the Minor findings are of kind Fidelity. 29 pages have no findings.
  - All 3 Misleading findings were checked by an independent checker, who saw only the allegation. All three were confirmed; Euler's was confirmed with a narrower scope.
  - Minor findings are reported unverified, as the brief allows.
- **No inventory findings.** Every script runs. All 279 committed GIFs are byte-identical to what their scripts produce on this machine. Every script and GIF is linked or embedded, and the section index links every animation page.
- **Calibration worked.** The bisection errors from the original brief were fixed in round 1. So the pilot reviewer was given a scratch copy of the bisection page with two planted errors: a root wrong in the third significant digit, and a false "monotonically decreasing" sentence. It caught both, with the right numbers, and raised nothing else. The real bisection page was then reviewed separately and is clean.
- **Environment and tools:**
  - Plots 1.41.2 and SpecialFunctions 2.7.2, both loaded from the global environment, which was not changed.
  - Python `/usr/bin/python3`, with numpy, scipy, sympy and mpmath.
  - The legacy Mathews archive was found and used: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/`, plus `a2001/Animations/`.
  - Madsen-Reid has no archive topic. Its reviewer and checker used the page's cited reference, Vestermark's `Newton_Real.cpp`, from a scratch copy outside the repository.

## The findings to read first (all Misleading, all independently confirmed)

1. **[Madsen-Reid](madsen-reid-method.md): the slow Stage-2 run is caused by the reference code's stage test, not by Madsen's method.**
   - `Newton_Real.cpp` forms the stage-test difference as `fz0 - fz1` after storing `fz0 = fz`, which is P(z_{k−1}). That makes it w = P(z_{k−1}) − P′(z_k).
   - The test is the Kantorovich condition 2|f||f″| ≤ |f′|², with f″ replaced by w/(z_{k−1} − z_k). That needs w = P′(z_{k−1}) − P′(z_k). The checker derived this independently.
   - With the intended w, the page's x₀ = −0.7 example leaves Stage 2 after one step. The lengthened Stage-1 steps then converge quadratically at the double root: 0.412 → 2.3e−2 → 9.1e−5 → 1.4e−9, ending in 5 steps instead of 21.
   - The page's line 27 says the choice of w does not change when the stage switches. That holds for the three animated cases, but not for this example.
   - The page currently presents the 19 linear Stage-2 steps as behaviour of the method.
2. **[Euler](eulers-method-for-odes.md): the only accuracy measure shown, the error at t = 5, hides the first-order versus second-order difference.**
   - At m = 150 the printed errors are −1.7e−6 (Euler) and +1.8e−6 (midpoint). The global errors are 2.25e−2 and 1.6e−4, about 140 times apart.
   - For Euler the end-point error is about 10⁴ times smaller than the global error.
   - For midpoint it understates the global error 2.5 to 87 times for m = 80–150, and equals it for m ≤ 70.
   - The frames themselves show the Euler curve visibly off the reference near the peak.
3. **[Laurent](laurent-series.md): "diverges beyond the radius" is contradicted in Cases 03 and 06.**
   - At the window edges beyond the radius (x = 10.5 and x = 4.1), the error shrinks in every frame up to N = 10.
   - Divergence appears only from about N = 15–20, which no frame shows.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2D Trapezoidal and Simpson Rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Accelerated & Modified Newton-Raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [Adams-Bashforth-Moulton Method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Adaptive Simpson's Rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Aitken's Method & Steffensen's Acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [Aitken's and Neville's Interpolation](aitkens-and-nevilles-interpolation.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [B-Splines](b-splines.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Bézier Curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Bisection Method](bisection-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Boole's Rule](booles-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Brent's Method](brents-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [Broyden's Method](broydens-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Catenary](catenary.md) | 1 | 1 | 0 | 0 | 2 | findings |
| [Chebyshev Approximation Polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 1 | findings |
| [Cubic Spline Quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [Cubic Splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [Derive Numerical Differentiation Formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 2 | findings |
| [Euler's Method for ODE's](eulers-method-for-odes.md) | 2 | 2 | 0 | 1 | 1 | findings |
| [False Position or Regula Falsi Method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Fixed Point Iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 0 | 2 | findings |
| [Gauss-Legendre Quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Graeffe's Method](graeffes-method.md) | 2 | 2 | 0 | 0 | 2 | findings |
| [Halley's Method](halleys-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [Hermite Polynomial Interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 2 | findings |
| [Improved Newton Method](improved-newton-method.md) | 5 | 5 | 0 | 0 | 1 | findings |
| [Lagrange Polynomial Interpolation and Approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 1 | findings |
| [Laurent Series](laurent-series.md) | 1 | 27 | 0 | 1 | 0 | findings |
| [Least Squares Lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [Least Squares Polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 1 | findings |
| [Legendre Polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 0 | clean |
| [Damped Newton with Acceleration (Madsen-Reid Method)](madsen-reid-method.md) | 3 | 3 | 0 | 1 | 0 | findings |
| [Midpoint Rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Monte Carlo Pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Muller's Method](mullers-method.md) | 3 | 3 | 0 | 0 | 2 | findings |
| [Newton-Cotes Integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 1 | findings |
| [Newton Interpolation Polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 1 | findings |
| [Newton-Raphson Method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [Nonlinear Systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Numerical Differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Padé Approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 1 | findings |
| [Rational Approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Richardson Extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [Riemann Sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [Romberg Integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Runge-Kutta-Fehlberg Method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [Runge-Kutta Method](runge-kutta-method.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [Secant Method](secant-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [Simpson's 3/8 Rule for Numerical Integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Simpson's Rule for Numerical Integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Taylor Series Method for ODE's](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [The Tangent Parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [Trapezoidal Rule for Numerical Integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |

## Fidelity findings (10, all Minor): for you to decide as a group

- **"Not animated here" lists that are incomplete or wrong:**
  - [Catenary](catenary.md) F1: the exploration numbers are wrong. "Approximated by a parabola" is Exploration 2, not 1.
  - [Catenary](catenary.md) F2: Mathews' actual Exploration 1 (catenaries are similar curves) is left out of the list.
  - [Least-Squares Polynomials](least-squares-polynomials.md) F1: the list leaves out Example 8 (a general linear least-squares cubic).
  - [Improved Newton](improved-newton-method.md) F1: the list leaves out Example 2's caveat, where Method A uses the wrong multiplicity and converges linearly.
- **Example function or start replaced with no reason given:**
  - [Cubic Splines](cubic-splines.md): sin x is used instead of Mathews' data points.
  - [Hermite](hermite-polynomial-interpolation.md) F2: e^x on [0, 1] is used instead of Example 1.
  - [Fixed-Point](fixed-point-iteration.md) F2: Cases 2 and 3 start at 3.8 and 1.0, where Mathews uses 4.0.
  - [Chebyshev](chebyshev-approximation-polynomial.md): Case 07's interval is [−1.6, 0.9], where Mathews uses [−1.5, 0.95].
- **Method or source described differently from the archive:**
  - [Muller](mullers-method.md) F2: Case 1 takes the real part of the complex root, the parabola's vertex. Mathews' program instead sets the square root to 0 and keeps the two nearest points. His sequence is 1.1091, 1.4944, 1.0558, …
  - [Derive Numerical Differentiation](derive-numerical-differentiation-formulae.md) F1: e^{−x} sin x is called "the legacy test function", but the legacy module uses no numerical test function.

## Patterns across pages

- **Text added in round 2 carries at least 6 of this round's 31 findings.** The round-2 fixes added "not animated" notes, step-refinement sweeps and the `newton_real` port. In that new text:
  - three "not animated" lists are incomplete or wrong: Catenary (2 findings), Least-Squares Polynomials and Improved Newton;
  - the Madsen-Reid sentence about w is true only of the animated cases;
  - Euler's sweep reports only the end-point error, which hides the method's order.

  An archive "examples left out" note needs every example in the module checked, not just the ones that look relevant.
- **Statements that hold only from some point on, or only in one measure:**
  - "the error roughly squares at each step" fails at Graeffe's first steps;
  - "tracks the curve more tightly" fails at Cubic Spline Quadrature's first refinement, measured by the largest gap;
  - "diverges beyond the radius" is not visible in Laurent's frames;
  - "zig-zags only for m = 12–20" is too narrow on Euler;
  - the convergence condition on Fixed-Point is stated as global when it is local;
  - Halley is called "significantly faster" in high precision, which the efficiency index and timings do not support.

  The authors tend to state a property's asymptotic or typical form as if it held at every step shown.
- **What the picture covers against what the text says:**
  - [Richardson](richardson-extrapolation.md) draws and measures on [h, π−h] while its title says [0, π].
  - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md) Case 14 draws tan as one curve through its poles. Cases 01–03 on the same page break at their poles, and the Chebyshev page breaks Case 14.
  - [Muller](mullers-method.md) F1: Case 1's feature is invisible after frame 2.
  - [Graeffe](graeffes-method.md) F2: the r₂ trace shares the reference line's style.
  - [Newton Interpolation](newton-interpolation-polynomial.md): Cases 12 and 13 show constant lines in frames titled degree 1–3, with no note. The Lagrange page has the note.
- **ODE stability shading.**
  - [Runge-Kutta](runge-kutta-method.md) F1: the shading and its legend use ∂f/∂y along the reference solution, and the page does not say so. For m = 12–24 the plotted RK4 run never exceeds the limit itself.
  - The Taylor reviewer noted the same thing without raising it.
  - The same convention is used on Euler and ABM.
- **Pages still without a `## Description` section,** noted by reviewers but not counted as findings: Newton-Raphson, Secant and others.

## Outside the review scope (not counted)

- [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md): the "Video Animations" text calls `abs` discontinuous. The brief puts that section out of scope, so it is recorded in the page file but not counted.

## Compared with earlier rounds

- **Totals:**

  | Round | Error | Misleading | Minor | Archive used |
  |---|---|---|---|---|
  | 1 | 61 | 37 | 76 | no |
  | 2 | 2 | 8 | 79 | yes |
  | 3 | 0 | 3 | 28 | yes |

- **No earlier finding has come back as a finding.** Two items earlier reviewers saw and judged harmless are rated Minor this round:
  - Richardson's [h, π−h] window;
  - Lagrange's Case 14 pole lines.
- **One earlier leftover is now a finding:** Newton Interpolation's missing note for Cases 12 and 13, listed among the round-1 leftovers.
- **Muller Case 1:** the round-1 fix kept the real-part (vertex) rule on the grounds that "Mathews' own example used the same real-arithmetic fallback". This round's reviewer reads Mathews' program as using a different fallback (square root set to 0, nearest two points kept). That is Muller F2 above, and worth settling.
- **Madsen-Reid:** round 2 took Vestermark's `newton_real` as the reference (decision R2-C). This round finds that its stage-test difference is not the intended derivative difference. With the intended one, Stage 1's lengthened steps give the quadratic convergence at multiple roots that Madsen's method is built for. Choosing between "follow the reference exactly" and "follow the intended test" is a decision for you.

## How this round was run

- **Phase 1, done once by the director:**
  - inventory;
  - isolated scratch runs of all 113 scripts, eight pages at a time;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, with the full Review standard, its manifest and its archive location.
  - The pilot was bisection (calibration copy), Simpson, Runge-Kutta and Chebyshev. It was read before the rest were launched.
  - One clean report (Cubic Spline Quadrature) had read a behaviour claim charitably. It was sent back and now carries a Minor finding.
- **Phase 3:** every Misleading finding went to a fresh checker that saw only the allegation.
- **Page files:** each page file has the findings, any check verdict, the Phase 1 inventory, and the reviewer's full claim ledger and implementation checks.
