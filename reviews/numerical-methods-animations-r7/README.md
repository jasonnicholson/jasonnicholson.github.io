# Numerical-methods animation review — round 7

Run of 2026-11-23 on branch `fix/numerical-methods-animations`, at commit `45ac761`, after the round-6 fix run and your Muller wording commit. This is a fresh, independent review. The reviewers did not read earlier rounds or fix records. The comparison with earlier rounds below was written after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 1 Error, 15 Misleading and 44 Minor, on 37 pages. The other 16 pages are clean.
  - All 16 Error and Misleading findings went to an independent checker. It confirmed 9 as written and 7 with a correction. It refuted none.
  - Minor findings were not independently checked, so they are labelled unverified.
- **The higher count is not a regression.** 54 of the 60 findings are on the 46 pages that did not change after the round-6 report, so round 6 passed the same text. This round's reviewers were stricter about wording, and not evenly so (see "How to read the count").
- **No round-6 fix came back.** Laurent, Tangent Parabola and Accelerated Newton are clean. One new Minor finding touches a round-6 change: Chebyshev F1 says the page's new extrapolation sentence leaves out that the curve also leaves the frame inside the interval.
- **Two findings repeat items you already decided:** Maclaurin F1 (R6-D) and Padé F1 (R5-C). Unless you change your mind, they need no action.
- **Mechanical checks found no inventory problems.** All 114 scripts ran from scratch copies, and all 261 committed GIFs reproduce byte for byte.
- **Calibration passed.** A scratch copy of the Bisection page had two planted errors, tan 2 ≈ −2.29 (true value −2.1850) and a false claim that from step 4 the midpoints alternate sides of the root. The reviewer caught both and reported nothing else. The real Bisection page was then reviewed separately.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/`: `n2003/`, `a2001/Animations/`, and `c2003/LaurentSeriesMod.html` for Laurent). Madsen-Reid is not in it.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2, unchanged. Python: `/usr/bin/python3`.

## Look at these first

1. **[Improved Newton](improved-newton-method.md) F1 (Error).** Case 5 labels Method C's trial points $x_{1,1}$ and $x_{1,2}$. By the page's own definition, $x_{n,m}$ with $n = 0$, they are $x_{0,1}$ and $x_{0,2}$. The values are right. Only the subscripts are wrong.
2. **[Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F3 and [Newton Interpolation](newton-interpolation-polynomial.md) F1 (Misleading).** The shared script clamps the interpolant to the window, so 12 frames on each page draw false flat tops *between the nodes*, in Cases 12, 13, 20, 21 and 27. In Case 12 at degree 7, the curve is drawn flat at about ±1.60 where the polynomial reaches ±5.15. This is the problem you had fixed on Padé in round 6, and the same fix applies.
3. **[Taylor Series for ODEs](taylor-series-method-for-odes.md) F1–F3 (Misleading).**
   - F1: the page says Mathews' evaluation for negative $y$ has not been reproduced. His program prints the rule, Sign[y]·|y|^(k/3), and it reproduces all 42 of his values.
   - F2: at $m = 80$ in Case 1, the shaded "unstable" band contains no step at all.
   - F3: at $m = 70$ in Case 2, the error rise is blamed on stability, but no step amplifies the error.
4. **[Euler](eulers-method-for-odes.md) F1 (Misleading).** "Each step multiplies the error by a factor below −1" fails for $m = 10$ to $40$. At 11 steps the error shrinks.
5. **[Catenary](catenary.md) F1 (Misleading).** The page plots $c\cosh(x/c)$. Mathews uses $c\cosh(x/c) - c$. The page then describes "the catenary through the origin", which its own formula cannot pass through for any $c$.
6. **[Broyden](broydens-method.md) F1 (Misleading).** "Each iteration is far cheaper" than Newton is false for the page's algorithm, which still does a full dense solve. On a dense test problem it was 8% to 38% cheaper.

## The other Misleading findings

- [Adams-Bashforth-Moulton](adams-bashforth-moulton-method.md) F1: "a close end value" at $m = 12$ is 0.0214, which is 2.6 times the exact 0.00812.
- [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md) F1: Case 1 presents 6.6 × 10⁻⁹ as the double-precision limit. The limit comes from evaluating the expanded polynomial; the factored form reaches the root.
- [Aitken/Neville](aitkens-and-nevilles-interpolation.md) F1: "the intermediate entries differ" hides that the two tableaux share their whole diagonal.
- [Fixed-Point](fixed-point-iteration.md) F1: Case 1 credits convergence from $x_0 = 0.1$ to $g'(2) < 1$, but $g' > 1$ at the first two iterates.
- [Improved Newton](improved-newton-method.md) F2: Case 4 calls knowing $m$ the core advantage of "the improved methods". Only Method A uses $m$.
- [Madsen-Reid](madsen-reid-method.md) F1: in Case 2's zoomed frames, earlier steps' thick green segments cover the current step, so the "second Δx" the page describes is not visible as a segment.
- [Newton-Raphson](newton-raphson-method.md) F1: Case 1's "convex side of the root" gives the wrong reason for monotone convergence.

## For you to decide

- **Already decided, raised again:**
  - [Maclaurin](maclaurin-and-taylor-series.md) F1: the GIFs stop at orders 8–12 where Mathews went to 18–31. You said to leave it (R6-D).
  - [Padé](pade-approximation.md) F1: 21 of 1614 frames draw a true pole as a short finite spike. You said to leave these (R5-C).
- **Fidelity findings (10, including Maclaurin F1).**
  - **Misleading:** [Catenary](catenary.md) F1 and [Taylor ODE](taylor-series-method-for-odes.md) F1, both above.
  - **Minor:**
    - [Adaptive Simpson](adaptive-simpsons-rule.md) F1: the 11-point stage splits the left half first. Mathews splits the right half first.
    - [Chebyshev](chebyshev-approximation-polynomial.md) F2: Case 26 uses [0.5, 5], as Mathews' index says, but his GIF uses [0.05, 5].
    - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F2 and [Newton Interpolation](newton-interpolation-polynomial.md) F4: wider node intervals than Mathews' worked examples. Case 18 uses [−2.2, 2.2] against his [−2, 2]. The Lagrange reviewer also flags Case 20, [−10.2, 10.2] against his [−10, 10]. The script is shared, so Newton Interpolation's Case 20 uses the same nodes, but its reviewer could not confirm Mathews' interval there because the example's code is missing from the archive.
    - [Numerical Differentiation](numerical-differentiation.md) F1: Case 2 follows Example 14 but omits its parabola and centre line.
    - [Padé](pade-approximation.md) F2: Mathews' convergence-interval overlay and higher diagonal orders are dropped without saying so.
    - [Richardson](richardson-extrapolation.md) F1: the list of unanimated examples omits Examples 2(a), 6 and 7.
- **Code comments only (3 Minor).** These are wrong statements in the linked source, not on the page: [Broyden](broydens-method.md) F3, [Fixed-Point](fixed-point-iteration.md) F2 and [Rational](rational-approximation.md) F1.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 1 | 0 | findings |
| [adaptive-simpsons-rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 2 | findings |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 1 | 2 | findings |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | 2 | 2 | 0 | 1 | 0 | findings |
| [bezier-curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [bisection-method](bisection-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [booles-rule](booles-rule.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [brents-method](brents-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [broydens-method](broydens-method.md) | 2 | 2 | 0 | 1 | 2 | findings |
| [b-splines](b-splines.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [catenary](catenary.md) | 1 | 1 | 0 | 1 | 0 | findings |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 2 | findings |
| [cubic-spline-quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [cubic-splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [derive-numerical-differentiation-formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [eulers-method-for-odes](eulers-method-for-odes.md) | 2 | 2 | 0 | 1 | 2 | findings |
| [false-position-or-regula-falsi-method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [fixed-point-iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 1 | 1 | findings |
| [gauss-legendre-quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [graeffes-method](graeffes-method.md) | 2 | 2 | 0 | 0 | 2 | findings |
| [halleys-method](halleys-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [hermite-polynomial-interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [improved-newton-method](improved-newton-method.md) | 5 | 5 | 1 | 1 | 1 | findings |
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 1 | 2 | findings |
| [laurent-series](laurent-series.md) | 1 | 8 | 0 | 0 | 0 | clean |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 1 | findings |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 1 | findings |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 1 | 0 | findings |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 1 | 3 | findings |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 1 | 2 | findings |
| [nonlinear-systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [numerical-differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [pade-approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 2 | findings |
| [rational-approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [richardson-extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [riemann-sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [romberg-integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [runge-kutta-fehlberg-method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [runge-kutta-method](runge-kutta-method.md) | 1 | 1 | 0 | 0 | 2 | findings |
| [secant-method](secant-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [taylor-series-method-for-odes](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 3 | 0 | findings |
| [the-tangent-parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [trapezoidal-rule-for-numerical-integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| **Total (53 pages)** | **114** | **261** | **1** | **15** | **44** | |

## Patterns

- **A true fact given as the cause of something it does not explain.** This is the most important pattern this round. The number is right, and the "since" or "because" around it is not: Fixed-Point F1, Newton-Raphson F1, Euler F1, Taylor F2 and F3, Broyden F1, Improved Newton F2, Aitken-Steffensen F1.
- **"Each" and "every" stated for something true of most cases.** Examples are "each frame adds one row" when the opening frame adds none (Romberg, Cubic Spline Quadrature), and claims that fail for the first steps or for a few $n$ (Graeffe F2, Euler F3, Aitken-Steffensen F3, Midpoint F1).
- **Alt text that says more than the frames show:** Bézier F1, Brent F1, Monte Carlo F1.
- **Clamping to the window.** Padé was fixed in round 6, and the shared Lagrange/Newton script has the same line. The checker counted 156 of its 290 frames with a clamped run *outside* the nodes as well (Newton Interpolation F2). That finding applies equally to Lagrange, because the script is byte-identical, but it is counted once.
- **Shared script, counted on each page.** The degree titles (Lagrange F1, Newton Interpolation F3) and Case 18's interval (Lagrange F2, Newton Interpolation F4) are one fix each.

## How to read the count

Reviewers applied different thresholds to the same kind of wording. "Each frame" with a bare opening frame is a Minor finding on Romberg and Cubic Spline Quadrature, but the Bisection, Riemann Sums and Simpson's 3/8 reviewers examined the same thing and chose not to count it. So the 44 Minor findings overstate the difference from round 6's 8. The Error and Misleading findings are the firmer signal, because each survived an independent check.

## Compared with earlier rounds

| Round | Error | Misleading | Minor | Archive used |
|---|---|---|---|---|
| 1 | 61 | 37 | 76 | no |
| 2 | 2 | 8 | 79 | yes |
| 3 | 0 | 3 | 28 | yes |
| 4 | 0 | 1 | 22 | yes |
| 5 | 0 | 0 | 9 | yes |
| 6 | 0 | 0 | 8 | yes |
| 7 | 1 | 15 | 44 | yes |

- **Round-6 deferrals:** Maclaurin F1 (R6-D) was raised again. Accelerated Newton Case 1 (R6-C) was not; its reviewer looked at the same picture and judged it fine.
- **Round-5 deferrals:** the Padé pole spikes (R5-C) were raised again. The Fixed-Point case order (R5-E) was not.
- **Text earlier rounds passed:**
  - Round 6's Newton-Raphson ledger marked the "convex side" sentence as confirmed, checking the iterates but not the reason it gives.
  - Round 3 saw the Catenary shift by $c$ and judged it an equivalent formulation. This round's new point is that the page's "through the origin" cannot hold for its own formula.

## Noted by reviewers, not counted

- **Worth a look:**
  - **Laurent Case 06 alt text** says the sum follows the curve on both shaded intervals. In the last frame it is within 0.05 on 56% and 67% of them, and departs near the ends. The Behavior paragraph gives the accurate numbers.
  - **Numerical Differentiation formulae, Case 1:** the dashed line is parallel to the chord and does not pass through the outer stencil points.
  - **Accelerated Newton:** the reviewer listed five close calls, including round-off in the plotted late iterates of Cases 2 and 3.
- **Cosmetic:** trailing zeros dropped in frame labels (Riemann Sums, Simpson's Rule, Simpson's 3/8, Trapezoidal, Newton-Cotes), and a title's closing parenthesis clipped on Cubic Splines.
- **Pages without a `## Description` section** include Bisection, Regula Falsi, Legendre and Secant.
- **Could not be determined:**
  - Mathews' Laurent example functions, because the module's formula images are missing locally.
  - Mathews' starting points for Nonlinear Systems Example 2 and Muller Example 3, because the images are missing.
  - The motion of Mathews' Regula Falsi animation, because its GIF is not in the archive.

## How this round was run

- **Phase 1, done once by the director:** inventory, isolated scratch runs of all 114 scripts, frames, contact sheets and frame hashes of every committed GIF, and one manifest per page.
- **Phase 2:** one reviewer per page, at most 20 at a time, with the full Review standard, the page's manifest and its archive location. The pilot was Bisection (on the calibration copy), Trapezoidal, Runge-Kutta and Laurent.
- **Phase 3:** 12 independent checks covering the 16 Error and Misleading findings. Each checker saw only the allegation.
- **One director addition.** The Lagrange reviewer did not report the clamping problem in the script it shares with Newton Interpolation. I added it to the Lagrange report as F3 after the independent checker tested it on that page's own frames.
- **Process:** no reviewer wrote into the repository. This report is uncommitted.
