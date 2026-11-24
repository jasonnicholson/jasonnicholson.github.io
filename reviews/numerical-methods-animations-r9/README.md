# Numerical-methods animation review — round 9

This run (2026-11-24) is on branch `fix/numerical-methods-animations`, at commit `e89784b`, after the round-8 fixes. It is a fresh, independent review: the reviewers did not read earlier rounds or the fix records. The comparison with earlier rounds below was written only after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 0 Error, 0 Misleading and 3 Minor, on 3 pages. The other 50 pages are clean.
  - No finding reached the threshold for an independent check. The 3 Minor findings are therefore unverified. I re-checked the Newton-Raphson numbers myself.
  - Each of the three was seen in round 8 as well. One was a round-8 finding and two were notes below the threshold there (see "Compared with earlier rounds").
- **The round-8 fixes hold.**
  - The Adams-Bashforth-Moulton reviewer confirmed the new $m=12$ sentence independently: an error 1.6 times the exact value, so $y(5)$ is 2.6 times it.
  - Both interpolation reviewers confirmed the new disclosure sentence. Mathews' surviving animations do end at degree 25 (Case 01) and degree 20 (Case 04).
- **Mechanical checks found no inventory problems.** All 114 scripts ran from scratch copies, and all 261 committed GIFs reproduce byte for byte. Every page references only files that exist, and the section index links every page.
- **Calibration passed.** A scratch copy of the Halley's Method page had two planted errors:
  - Case 1b gave $x_1 \approx 1.43857$; the true value is $10/7 = 1.42857$.
  - Case 2 claimed that both first steps overshoot the root. In fact both land to its left, at −2.0222 and −2.0021, on the same side as $x_0$.

  The reviewer caught both and reported nothing else. The real Halley page was then reviewed separately and is clean.
- **The legacy Mathews archive was found and used**, at `/home/jason/Desktop/math-fullerton/baseline/mathews/` (`n2003/`, `a2001/Animations/`, and `c2003/` for Laurent).
- **No MATLAB.** Every brief this round said not to run MATLAB, and no reviewer did. The Padé reviewer left the page's MATLAB timings unchecked and said so.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2, unchanged. Python: `/usr/bin/python3`.

## The findings

1. **[Newton-Raphson](newton-raphson-method.md) F1 (Implementation, Minor).** In `newtoncc.gif` (Case 3, $f(x)=\arctan x$, $x_0=1.35$), the legend rounds to 5 decimals.
   - Frame 7 reads `x₍6₎ = 0.0` (true value $2.86\times10^{-6}$), and frame 8 reads `x₍7₎ = -0.0` (true value $-1.56\times10^{-17}$).
   - The "0.0" suggests the root was reached exactly at step 6. I recomputed both values.
   - The fix is significant-figure formatting at `newtoncc.jl` lines 57–61.
2. **[Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F1 (Implementation, Minor).** Rows 24–26 of `lagnewt_animations_all.jl` do not list Γ's pole at $x=0$, although the field comment says `poles` lists every pole in the window.
   - The GIFs are right, but only because grid point 38 of the 1000-point plot grid is exactly 0.0, where `gamma` returns `Inf`.
   - The fix is `poles=[0.0]` on those rows, which also changes how their y-limits are chosen, or a corrected comment.
   - The script is shared with Newton Interpolation. That page's reviewer saw the same thing and recorded it as a note, not a finding.
3. **[Maclaurin](maclaurin-and-taylor-series.md) F1 (Fidelity, Minor).** This is the order cutoff again.
   - The animations stop at order 8–12, where Mathews' go to about 18–50.
   - In the final frames of M07, M08, M15–M18, T06 and T07, the polynomial still leaves the window over 35–60% of the x-range, although these functions are entire. Only M18 is explained on the page.
   - **You decided to leave this in R6-D**, and it was deferred again in rounds 7 and 8. This round's reviewer rated it Minor, where round 8 called it Misleading.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [adaptive-simpsons-rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bezier-curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bisection-method](bisection-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [booles-rule](booles-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [brents-method](brents-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [broydens-method](broydens-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [b-splines](b-splines.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [catenary](catenary.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 0 | clean |
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
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 1 | findings |
| [laurent-series](laurent-series.md) | 1 | 8 | 0 | 0 | 0 | clean |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 1 | findings |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 0 | clean |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 1 | findings |
| [nonlinear-systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [numerical-differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [pade-approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 0 | clean |
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
| [the-tangent-parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [trapezoidal-rule-for-numerical-integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| **Total (53 pages)** | **114** | **261** | **0** | **0** | **3** | |

## Noted by reviewers, not counted

- **Display details below the threshold:**
  - Simpson's Rule and Newton-Cotes frame labels drop trailing zeros (for example "2.0154"). Simpson's Rule also says "Each animation" for its one animation.
  - B-Splines labels show literal subscripts (`N_{i,4}(t)`).
  - In Cubic Splines frames 4–6 the title's closing ")" is clipped. Its n=6 title says 0.00896 over the plot grid, where the true maximum rounds to 0.00897.
  - False Position Case A's first-frame "Initial bracket" label sits slightly under the legend.
  - Monte Carlo Pi's annotation overlaps points in the last two frames.
  - Broyden draws the current iterate in the same red as the $f_2$ curve.
  - Halley Case 2 clamps the tangent to the plot limits, so in frame 1 part of it runs along the border.
- **Fragile or variant, but correct:**
  - Accelerated Newton Cases 2 and 3 stall near $1\pm10^{-11}$ in Float64, so their last frames repeat. The labels are still right.
  - Brent's script uses the Netlib `zeroin` sign test rather than Brent's original ALGOL one. The page's 3.2e-4 bracket width is right for the code that runs.
  - Madsen-Reid's scripts store $P'(z_{k-1})$ where the reference code stores $P(z_{k-1})$. The animations are the same, and the page says it describes the corrected version.
  - `secantmethoddd.jl`'s early break can only fire on the final pass of its loop.
- **Pages without a `## Description` section** include Secant and Taylor ODE.
- **Could not be determined:**
  - The Padé page's MATLAB `pade` timings, because MATLAB was off-limits. Also its remark that chebfun's `padeapprox` struggles.
  - Halley's timing comparison. It matches mpmath ratios of 1.27× and 2.2×, but the page names no tool.
  - Madsen-Reid's test (2.9) and "globally convergent", because the 1975 report is not available here.
  - Archive images that are missing:
    - Mathews' Nonlinear Systems Example 2 starting points;
    - his Muller Example 3 starting values;
    - his Graeffe Example 7 polynomial;
    - his Aitken-Neville Example 6 graphs;
    - the source of the 2D Trapezoidal benchmark 5.04756680717 (its value checks out).

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
| 8 | 0 | 1 | 2 | yes |
| 9 | 0 | 0 | 3 | yes |

- **Came back:**
  - Maclaurin F1 is the order cutoff again (R6-D, deferred in rounds 6–8).
  - The Newton-Raphson `-0.0` legend and the Lagrange Γ pole were both noted below the threshold in round 8. This round's reviewers counted them as Minor.
- **Round-8 fixes:** both were confirmed by this round's reviewers, and neither was reported as wrong.
- **Not raised this round:** the Padé pole display (R5-C).

## How this round was run

- **Phase 1, done once by the director:**
  - the inventory;
  - isolated scratch runs of all 114 scripts;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, at most 20 at a time. Each was given the full Review standard, the page's manifest, its archive location, and an explicit instruction not to run MATLAB or quarto.
  - The pilot was Halley (the calibration copy), Simpson's Rule, Runge-Kutta and Newton Interpolation.
  - Each pilot report showed independent computation and a full claim ledger. I re-checked Simpson's reference integral (2.0162797) myself.
- **Phase 3:** no Error or Misleading finding was reported, so no independent check was needed.
- **Process:** no reviewer wrote into the repository, and this report is uncommitted.
