# Numerical-methods animation review — round 8

Run of 2026-11-23/24 on branch `fix/numerical-methods-animations`, at commit `c7c81ac`, after the round-7 fix run. This is a fresh, independent review. The reviewers did not read earlier rounds or fix records. The comparison with earlier rounds below was written after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 0 Error, 1 Misleading and 2 Minor, on 3 pages. The other 50 pages are clean.
  - The one Misleading finding was independently checked and confirmed with a correction. It repeats a point you have already decided to leave (Maclaurin order cutoff, R6-D).
  - One more allegation, on Taylor ODE, was checked and **refuted**, so it is dropped (see below).
  - The 2 Minor findings were not independently checked, so they are labelled unverified.
- **No round-7 fix came back as wrong**, apart from one sentence on Adams-Bashforth-Moulton, where the round-7 wording attaches "2.6 times the exact value" to the wrong noun.
- **Mechanical checks found no inventory problems.** All 114 scripts ran from scratch copies, and all 261 committed GIFs reproduce byte for byte.
- **Calibration passed.** A scratch copy of the Secant page had two planted errors in Case 1: $p_2 \approx 0.462$ (true value 0.45575), and a false claim that the iterates then alternate sides of the root (all of them stay to its right). The reviewer caught both and reported nothing else. The real Secant page was then reviewed separately and is clean.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/`: `n2003/`, `a2001/Animations/`, and `c2003/` for Laurent). Madsen-Reid is not in it.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2, unchanged. Python: `/usr/bin/python3`.

## The findings

1. **[Maclaurin](maclaurin-and-taylor-series.md) F1 (Fidelity, Misleading, confirmed with correction).** The animations stop at degree 8–12, where Mathews' go to about 19–30.
   - In the final frames of M07, M08, M15, M16, M17, T06 and T07, the polynomial leaves f over about 40–60% of the window, although these functions are entire. Only M18's shortfall is explained on the page.
   - T11, and partly T12, cannot show their convergence interval at degree 8.
   - The checker found the claim overstated for T09, T10 and T13.
   - **You decided to leave this in round 6 (R6-D)** and again in round 7. This round's reviewer rated it Misleading, where earlier rounds called it Minor. Nothing else on the page changed.
2. **[Adams-Bashforth-Moulton](adams-bashforth-moulton-method.md) F1 (Page match, Minor).** In "at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though that is still 2.6 times the exact value)", the "that" reads as the error, 0.013, which is 1.64 times the exact value. It is $y(5)$ that is 2.64 times. This wording came from the round-7 review's suggested correction. The fix is "though $y(5)$ is still 2.6 times the exact value".
3. **[Newton Interpolation](newton-interpolation-polynomial.md) F1 (Fidelity, Minor).** The animations stop at degree 15 and leave out the ±0.05 "convergence region" band that Mathews' surviving animations draw. His go to degree 25 (Case 01) and 20 (Case 04). The page describes its own degree sequence correctly, so nothing it says is false.
   - The script is shared with Lagrange, whose reviewer saw the same thing and chose not to count it.
   - On Padé in round 7, the same kind of omission was fixed with one disclosure sentence. The same sentence would serve both interpolation pages.

## Refuted

- **[Taylor ODE](taylor-series-method-for-odes.md) F1.** The reviewer alleged that Mathews' Sign(y)|y|^(k/3) rule does not reproduce his printed values, contradicting what round 7 found and wrote onto the page. The independent checker implemented his program from the archive, with his derivative formulas exactly as he wrote them, multiplied through by powers of $y^{1/3}$. That reproduces all 21 printed $y(5)$ values at order 3 and all 21 at order 4. The reviewer had applied the rule to a different algebraic form, which does not reproduce them. The page is right.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 1 | findings |
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
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 0 | clean |
| [laurent-series](laurent-series.md) | 1 | 8 | 0 | 0 | 0 | clean |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 1 | 0 | findings |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 1 | findings |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
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
| **Total (53 pages)** | **114** | **261** | **0** | **1** | **2** | |

## Noted by reviewers, not counted

- **Display details below the threshold:**
  - Newton-Raphson Case 3's legend shows `x₍7₎ = -0.0`.
  - B-Splines labels show literal underscores and braces (`N_{i,4}(t)`).
  - Cubic Spline Quadrature drops a trailing zero (2.00539) and says "Each animation" for its one animation. Riemann Sums also drops trailing zeros in frame labels.
- **Fragile but correct:**
  - Lagrange Cases 24–26 break the Γ curve at the pole only because the sample grid includes x = 0 exactly.
  - Lagrange Case 19's f curve stops about 6 px short of the end nodes.
  - Runge-Kutta-Fehlberg's "steps agree to within 0.05%" holds for the script's run (0.041%), but is sensitive to rounding near the pole.
- **Padé:** at a pole with small residue (for example Case 27 [1/1]), the 900-point grid draws the spike on one side only. This is the pole display you decided to leave (R5-C).
- **Pages without a `## Description` section** include Bisection, Regula Falsi, Legendre, Runge-Kutta and Secant.
- **Could not be determined:**
  - Mathews' starting points for Nonlinear Systems Example 2 (images missing), and his Legendre Example 8(b) graphs (missing).
  - Madsen-Reid's statement about test (2.9) in the 1975 report, which is not available here, and "globally convergent".
  - For 17 Chebyshev cases the archive has no GIF. For Cases 01, 07, 13 and 14 it does not state the interval either.

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

- **Round-7 deferrals:**
  - Maclaurin F1 (R6-D) was raised again, now as Misleading.
  - The Padé pole spikes (R5-C) were noted but not counted.
- **Round-7 fixes:** 58 were made and none was reported as wrong, except the Adams-Bashforth-Moulton sentence above. Several reviewers independently re-derived round-7 changes and confirmed them, among them Catenary's shifted formula, the Lagrange/Newton clamp and intervals, Chebyshev Case 26, Adaptive Simpson's split order and the Taylor Sign rule.

## How this round was run

- **Phase 1, done once by the director:**
  - inventory;
  - isolated scratch runs of all 114 scripts;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, at most 20 at a time, with the full Review standard, the page's manifest and its archive location. The pilot was Secant (on the calibration copy), Trapezoidal, Euler and Lagrange.
- **Phase 3:** two independent checks, each shown the allegation only. The one Misleading finding (Maclaurin) was confirmed with correction.
  - The Taylor ODE finding was rated Minor, but it contradicted what round 7 had established and written onto the page, so it was checked as well, and refuted.
- **One process slip.** The Padé reviewer re-ran the MATLAB `pade` timings the page quotes (it measured 9.3, 43.2 and 217.2 s against the page's 7, 31 and 134 s). Your standing instruction is that MATLAB is not run in these reviews. This round's brief did not repeat it, so the reviewer had no way to know. Nothing in the repository was touched, and future briefs will state it.
- **Process:** no reviewer wrote into the repository. This report is uncommitted.
