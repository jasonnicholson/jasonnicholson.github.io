# Numerical-methods animation review — round 5

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, after the round-4 fix run and decision R4-D. This is a fresh, independent review. The reviewers did not read earlier rounds or fix records; the comparison with earlier rounds below was written after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 0 Error, 0 Misleading and 9 Minor. Two of the Minor findings are Fidelity findings (departures from the Mathews archive).
  - Minor findings are not independently checked, so they are labelled unverified.
  - No finding needed the independent allegation check, which applies only to Error and Misleading findings.
- **44 pages have no findings.** Each clean report has a full claim ledger, checked against the reviewer's own high-precision computation. Many clean reports also compare the page's values with Mathews' printed or animated values.
- **Two items were recorded but not counted:**
  - [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md): the "Video Animations" sentence calling `abs` discontinuous. It is out of scope, as in rounds 3 and 4.
  - [Laurent](laurent-series.md): the pole lines in Cases 12 and 22–24, which you decided to leave (R4-D).
- **Mechanical checks:** there are no inventory findings. All 113 scripts ran from scratch copies, and all 279 committed GIFs reproduce byte for byte.
- **Calibration passed.** A scratch copy of the Bisection page had two planted errors:
  - π/2 ≈ 1.5808, which is wrong in the third significant digit;
  - a false claim that the actual bisection error falls at every step.

  The reviewer caught both. The real Bisection page was then reviewed separately and is clean.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` and `a2001/Animations/`). The Madsen-Reid and Laurent topics are not in it.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2, unchanged. Python: `/usr/bin/python3`.

## The nine findings (all Minor)

- **Pictures:**
  - [Muller](mullers-method.md): Case 2's later frames (5–9) show no visible parabola or step in the fixed window. This is the same kind of problem round 4 fixed in Case 1.
  - [Secant](secant-method.md): Case 3 labels p₈ = 0, a double-precision zero; the exact value is −7.6e-48. Frames 8–10 then repeat the picture with "p₉" and "p₁₀", which the method never computed.
  - [Padé](pade-approximation.md): about 13 real poles inside the window, in the Γ and Y₀ Cases 22–27, are drawn as short finite spikes. For example, Case 25 [0/1] has a pole at x = 9.776 whose spike reaches only ±1.02 in a ±2 window.
- **Text:**
  - [Runge-Kutta-Fehlberg](runge-kutta-fehlberg-method.md): the Description's step rule h_new = s·h leaves out the 0.25 cap. The cap is what sets five of Case 2's steps.
  - [Nonlinear Systems](nonlinear-systems.md): the comparison table calls fixed-point iteration "linear (when it converges)". The page's own Example 4, Newton written as a fixed-point iteration, converges quadratically.
  - [Broyden](broydens-method.md): the final Case A residual is quoted as 1.4e-15. That is roundoff, and the exact residual of the same iterate is 1.57e-15. Say "about 10⁻¹⁵".
  - [Maclaurin](maclaurin-and-taylor-series.md) F2: the alt text for M03 reads as 1/(1−x²), but the case is 1/(1−x)².
- **Fidelity (for you to decide):**
  - [Aitken/Neville](aitkens-and-nevilles-interpolation.md): the page animates its own cos x example, which it discloses. The reviewer notes that Mathews' Example 3 (eˣ at nodes 1 + i/4, x̂ = 1.8) would fit the animation directly. This is the same kind of choice you made for Newton under R4-D.
  - [Fixed-Point](fixed-point-iteration.md): the file names and the order of Cases 4 and 5 are swapped relative to Mathews' Examples 7 (x₀ = 2.03) and 8 (x₀ = 1.95). The script comments give the right example numbers.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [adaptive-simpsons-rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [bezier-curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bisection-method](bisection-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [booles-rule](booles-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [brents-method](brents-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [broydens-method](broydens-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [b-splines](b-splines.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [catenary](catenary.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 0 | clean |
| [cubic-spline-quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [cubic-splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [derive-numerical-differentiation-formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [eulers-method-for-odes](eulers-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [false-position-or-regula-falsi-method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [fixed-point-iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 0 | 1 | findings |
| [gauss-legendre-quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [graeffes-method](graeffes-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [halleys-method](halleys-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [hermite-polynomial-interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [improved-newton-method](improved-newton-method.md) | 5 | 5 | 0 | 0 | 0 | clean |
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 0 | clean |
| [laurent-series](laurent-series.md) | 1 | 27 | 0 | 0 | 0 | clean (1 excluded by decision R4-D) |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 1 | findings (1 out of scope) |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 0 | clean |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [nonlinear-systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [numerical-differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [pade-approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 1 | findings |
| [rational-approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [richardson-extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [riemann-sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [romberg-integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [runge-kutta-fehlberg-method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [runge-kutta-method](runge-kutta-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [secant-method](secant-method.md) | 6 | 6 | 0 | 0 | 1 | findings |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [taylor-series-method-for-odes](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [the-tangent-parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [trapezoidal-rule-for-numerical-integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |

## Compared with earlier rounds

- **Totals:**

  | Round | Error | Misleading | Minor | Archive used |
  |---|---|---|---|---|
  | 1 | 61 | 37 | 76 | no |
  | 2 | 2 | 8 | 79 | yes |
  | 3 | 0 | 3 | 28 | yes |
  | 4 | 0 | 1 | 22 | yes |
  | 5 | 0 | 0 | 9 | yes |

- **Round-4 fixes:** none came back.
  - Reviewers confirmed the round-4 changes on Runge-Kutta, Taylor, Padé, Muller Case 1, Newton (the R4-D divided-differences case), Lagrange, Richardson, Numerical Differentiation, Aitken-Steffensen and the others.
- **Recurring or long-standing items:**
  - **Secant Case 3:** the p₈ = 0 frames were noted, but not raised as a finding, in round 2's fix summary. This round raises them as a finding.
  - **Muller Case 2:** has the window problem that Case 1 had before R4-A.
  - **Padé:** the poles drawn as finite spikes are in different cases from round 4's clamping finding (Cases 01–02, now fixed).
- **Not counted again:** the Maclaurin "Video Animations" sentence, which is out of scope, and the Laurent pole lines, which you decided to leave.

## Noted by reviewers, not counted

- **Cosmetic:**
  - Some frame labels drop trailing zeros (Boole, Simpson, Riemann Sums).
  - Several intros say "each animation" or "each frame" when there is one animation, or when frame 1 shows only the curve (Romberg, Monte Carlo π, Simpson 3/8).
  - Bisection Case 2 draws values clamped to ±15 in the top panel. It is labelled correctly and the zoom panel plots the true values.
- **Pages still without a `## Description` section:** Bisection, Newton-Raphson, Secant, Runge-Kutta, Legendre, Tangent Parabola and Taylor, among others.
- **Archive gaps:** some of Mathews' node intervals, starting points and solution images are missing from the archive, so a few fidelity points could not be checked (Chebyshev, Lagrange, Newton Interpolation, Nonlinear Systems, Rational).

## How this round was run

- **Phase 1, done once by the director:**
  - inventory;
  - isolated scratch runs of all 113 scripts, eight pages at a time;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, with the full Review standard, the page's manifest and its archive location.
  - The pilot was Bisection (on the calibration copy), Romberg, Taylor and Newton Interpolation.
  - Clean reports with very short replies were checked for ledger depth. Derive had 64 rows, Improved Newton 68, Numerical Differentiation 64 and Adaptive Simpson 44.
- **Phase 3:** not needed, because no Error or Misleading finding was in scope.
- **Process note:** one reviewer (Monte Carlo π) briefly wrote a scratch file into the repository root and moved it out. `git status` confirmed nothing was left behind.
