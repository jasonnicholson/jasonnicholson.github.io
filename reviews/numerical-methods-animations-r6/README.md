# Numerical-methods animation review — round 6

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, after the round-5 fix run (decisions R5-A to R5-F). This is a fresh, independent review. The reviewers did not read earlier rounds or fix records. The comparison with earlier rounds below was written after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 0 Error, 0 Misleading and 8 Minor, on 7 pages.
  - Two of the Minor findings are Fidelity findings, meaning departures from the Mathews archive.
  - Minor findings are not independently checked, so they are labelled unverified. No finding needed the allegation check, which applies only to Error and Misleading findings.
- **46 pages have no findings.** Each clean report has a full claim ledger, checked against the reviewer's own high-precision computation. Most also compare the page's values with Mathews' printed or animated values.
- **Every round-5 fix held up.** Reviewers confirmed all of the round-5 changes:
  - Muller Case 2;
  - Secant Case 3;
  - Aitken/Neville's new Example 3 case;
  - the Laurent pole breaks;
  - the Broyden residual;
  - the Maclaurin text;
  - the Runge-Kutta-Fehlberg h_max cap;
  - the Nonlinear Systems table.
- **Mechanical checks found no inventory problems.** All 114 scripts ran from scratch copies, and all 280 committed GIFs reproduce byte for byte.
- **Calibration passed.** A scratch copy of the Bisection page had two planted errors:
  - tan 1 ≈ 1.577, which is wrong in the third significant digit (the true value is 1.5574);
  - a false claim that from step 5 on, every midpoint lies below the root.

  The reviewer caught both and reported nothing else. The real Bisection page was then reviewed separately and is clean.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` and `a2001/Animations/`). The Madsen-Reid and Laurent topics are not in it.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2, unchanged. Python: `/usr/bin/python3`.

## The eight findings (all Minor)

- **Pictures:**
  - [Muller](mullers-method.md): Case 3 (`mullerscc.jl`) keeps a fixed window of x ∈ [0.9, 2.1].
    - In frames 7–9, the three points and the step to the axis crossing are each under 1 pixel.
    - The intro says these can be seen.
    - Cases 1 and 2 now zoom each frame for this reason (R4-A, R5-A).
  - [Accelerated & Modified Newton](accelerated-and-modified-newton-raphson.md) F1: in Case 1 the y-window reaches 1.0 while f(x₀) = 0.128, so the slow linear convergence is squeezed into a sliver. From x₅ on, nothing visibly moves and only the legend changes.
  - [Padé](pade-approximation.md): line 475 of `pade_animations_all.jl` clamps the approximant to the y-limits.
    - Off-scale parts are therefore drawn flat along the top or bottom edge, which looks like the curve levelling off.
    - This happens in 524 of 1614 frames, across 26 of the 27 GIFs. For example, `pade08` frame 55 ([9/0] for sin x) runs along y = 1.5 where the polynomial reaches about 10².
    - The reviewer suggests masking values beyond a margin to NaN, or clamping to a band wider than the window.
  - [Chebyshev](chebyshev-approximation-polynomial.md): the frames do not mark the approximation interval.
    - So the polynomial blowing up just outside it can look like the method failing (Cases 04, 24, 29 and others).
    - Mathews' animations marked the interval with vertical green lines.
  - [Tangent Parabola](the-tangent-parabola.md): in the five hold frames, T₂ is drawn twice, dashed and dotted in the same dark green. The legend therefore lists "Tangent parabola T₂(x)" twice.
- **Text:**
  - [Accelerated & Modified Newton](accelerated-and-modified-newton-raphson.md) F2: the intro says "Each animation below shows a Newton-style line diagram for three methods". Each GIF shows one method.
- **Fidelity (for you to decide):**
  - [Maclaurin](maclaurin-and-taylor-series.md): the GIFs stop at orders 8–12, where Mathews went to about 22–30.
    - The last frame is therefore within 0.01 of f on only part of Mathews' window:
      - M15 and M16 (J₀, J₁): 36–40% of it;
      - M07 and M08 (sin, cos): 42–46%;
      - T11 (Y₀): 27%.
    - The page explains its order cutoff only for M18.
    - The fix is either higher `n_terms` for those rows or one sentence in the Animations intro.
  - [B-Splines](b-splines.md): both cases show parametric clamped B-spline curves. Mathews' module is natural cubic spline *interpolation* through seven points, built from translated uniform B-splines. The page discloses the switch accurately but gives no reason, and neither archive example is animated.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 2 | findings |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [adaptive-simpsons-rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bezier-curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bisection-method](bisection-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [booles-rule](booles-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [brents-method](brents-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [broydens-method](broydens-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [b-splines](b-splines.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [catenary](catenary.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 1 | findings |
| [cubic-spline-quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [cubic-splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [derive-numerical-differentiation-formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [eulers-method-for-odes](eulers-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [false-position-or-regula-falsi-method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [fixed-point-iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [gauss-legendre-quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [graeffes-method](graeffes-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [halleys-method](halleys-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [hermite-polynomial-interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [improved-newton-method](improved-newton-method.md) | 5 | 5 | 0 | 0 | 0 | clean |
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 0 | clean |
| [laurent-series](laurent-series.md) | 1 | 27 | 0 | 0 | 0 | clean |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 1 | findings |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 0 | clean |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [nonlinear-systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [numerical-differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [pade-approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 1 | findings |
| [rational-approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [richardson-extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [riemann-sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [romberg-integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [runge-kutta-fehlberg-method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [runge-kutta-method](runge-kutta-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [secant-method](secant-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [taylor-series-method-for-odes](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [the-tangent-parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [trapezoidal-rule-for-numerical-integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| **Total (53 pages)** | **114** | **280** | **0** | **0** | **8** | |

## Compared with earlier rounds

- **Totals:**

  | Round | Error | Misleading | Minor | Archive used |
  |---|---|---|---|---|
  | 1 | 61 | 37 | 76 | no |
  | 2 | 2 | 8 | 79 | yes |
  | 3 | 0 | 3 | 28 | yes |
  | 4 | 0 | 1 | 22 | yes |
  | 5 | 0 | 0 | 9 | yes |
  | 6 | 0 | 0 | 8 | yes |

- **Round-5 fixes:** none came back (see the Headline).
- **Round-5 deferrals:** this round did not raise them again.
  - The Padé poles drawn as finite spikes (R5-C) and the Fixed-Point case order (R5-E) were not reported.
  - This round's Padé finding is a different one, about clamping. It is related to round 4's fix for Cases 01–02, which deliberately runs off-scale parts along the frame edge. Under it, the same edge-running now shows up in 26 cases.
- **Items that have come back, or that earlier rounds saw but did not count:**
  - **Accelerated Newton Case 1:** round 2 raised the same picture problem as its F1, and that fix was text only. The round-2 fix record suggested a log-error inset as the next step if you want the rate visible in the picture.
  - **Tangent Parabola duplicate legend:** every round from 1 to 5 noted it and judged it cosmetic. This round's reviewer counted it as Minor.
  - **B-Splines:** round 2 raised the switch away from Mathews' interpolation examples as a Misleading Fidelity finding, which was fixed by disclosing it. This round raises the missing reason as a Minor finding.
  - **Muller:** this is the third case with the fixed-window problem, after Case 1 (R4-A) and Case 2 (R5-A).
- **New this round:**
  - the Chebyshev interval marking;
  - the Maclaurin order cutoff;
  - the Accelerated Newton "three methods" sentence.

## Noted by reviewers, not counted

- **Possibly worth a look:**
  - **Padé pole lines.** The target curve is not masked at the true poles of tan x (Case 12) or Γ(x) (Cases 22–24), so a magenta vertical line is drawn across the plot. This is the same thing you had fixed on Laurent under R5-F. The Padé reviewer mentions it inside F1 as a related point, not a separate finding.
  - **Runge-Kutta:** the Behavior paragraph splits the error after the first upward step into the step's own truncation error and the carried error. The split uses the textbook definition of local truncation error. Under the other common definition, the attribution for m = 20–56 reverses.
- **Cosmetic:**
  - Some frame labels drop trailing zeros: Riemann Sums (left and right sums) and Simpson's Rule.
  - On Cubic Splines, the title's closing parenthesis is cut off in the 6-, 7- and 9-node frames. The error values are still fully visible.
  - On Least Squares Polynomials:
    - the k = 1 line is clipped at the top of the window;
    - p₄ and p₅ are clipped just below y = 0 near x = −5;
    - the orange residual segments are never explained.
  - On Least Squares Lines, the Case 1 fit line passes through the coefficient annotation, which stays legible.
  - Bisection Case 2 draws values clamped to ±15 in the top panel. The zoom panel plots the true values.
- **Code robustness (no effect on any GIF):** these are all in the Secant scripts.
  - `secantmethoddd.jl` has an early `break` that would leave `undef` entries if it fired before the last index. It doesn't.
  - `secantmethodee.jl` raises a soft-scope warning.
  - In `secantmethodaa.jl` frame 9, the secant is drawn only because |Δf| = 1.33e-14 just clears the 1e-14 guard.
- **Pages still without a `## Description` section:** Bisection, Runge-Kutta and Legendre, among others.
- **Could not be determined:**
  - Mathews' starting points for Nonlinear Systems Example 2 and Muller Example 3. The archive images that would show them are missing.
  - Three Madsen-Reid claims that rest on the source paper: "globally convergent", "far more reliable than unguarded Newton", and the equation number (2.9). The paper was not available to the reviewer.

## How this round was run

- **Phase 1, done once by the director:**
  - inventory;
  - isolated scratch runs of all 114 scripts, eight pages at a time;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, with the full Review standard, the page's manifest and its archive location.
  - The pilot was Bisection (on the calibration copy), Newton-Cotes, Taylor ODE and Laurent.
  - Clean reports with very short replies were checked for ledger depth: Fixed-Point had 49 confirmed rows, Graeffe 34, Simpson's 3/8 26 and Richardson 23.
- **Phase 3:** not needed, because no Error or Misleading finding was reported.
- **Process:** no reviewer wrote into the repository. `git status` was clean throughout.
