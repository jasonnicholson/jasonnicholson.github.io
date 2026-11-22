# Cubic Spline Quadrature — animation review (round 4)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match, Minor: the later "largest pointwise gap" is not at the peak, as the text implies

- **Location:** `index.qmd` line 32: "The largest pointwise gap does not shrink at first: it sits under the narrow peak near $x\approx0.08$, which the spline undershoots by more at $m=5$ (1.11) and $m=7$ (1.09) than at $m=3$ (0.88). From $m=5$ on it falls at every step, to 0.16 at $m=41$."
- **What is there now:** the paragraph places the largest gap under the peak near x≈0.08 and then follows the same "it" down to 0.16 at m=41. A reader would take the 0.16 at m=41 to be the remaining undershoot or overshoot at the peak. In frame 21 (m=41) the one visible red/magenta discrepancy is the spline overshooting the peak, which supports that reading.
- **What is true instead:** for m=3, 5, 7, 9 the maximum gap is indeed at the peak (x = 0.077, 0.096, 0.094, 0.076; the peak of f is at x = 0.0804, f = 1.9198). From m=11 on it moves left, onto the steep initial rise where f'(x) = (16/3)e^{-x}cos(8x^{2/3})x^{-1/3}+… blows up as x→0: x = 0.062 (m=11), 0.028 (m=21), 0.013 (m=41). At m=41 the gap of 0.157 is at x≈0.013, where the spline lies below f. At the peak, the spline overshoots f only by about 0.027 (max S = 1.9464 against max f = 1.9198). Every number the sentence quotes is right (see ledger). Only the implied location is wrong.
- **How I know:** `julia inst.jl` (script's own `natural_spline_M`/`spline_eval` on a 200 001-point grid) and `/usr/bin/python3 -I indep.py` (SciPy `CubicSpline(bc_type='natural')`) both give:

  | m | max gap | at x |
  |---|---|---|
  | 3 | 0.877303 | 0.07677 |
  | 5 | 1.110844 | 0.09648 |
  | 7 | 1.089948 | 0.09446 |
  | 9 | 0.860458 | 0.07649 |
  | 11 | 0.673649 | 0.06162 |
  | 21 | 0.304823 | 0.02837 |
  | 41 | 0.156876 | 0.01285 |
- **Suggested correction:** add one clause, e.g. "From $m=5$ on it falls at every step, to 0.16 at $m=41$; from about $m=11$ on the largest gap is no longer at the peak but on the steep rise next to $x=0$, where $x^{2/3}$ gives $f$ an infinite slope." Optionally add that this singular slope is also why the integral converges slowly. The error falls by only about 3.9 when h is halved from m=21 to m=41, roughly O(h²), not the O(h⁴) of a smooth integrand.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 7.5 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `splinequadaa.gif` | 21 | byte-identical | splinequadaa |

### Page references

- Scripts linked: `splinequadaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

True integral used below: ∫₀² f = **2.016279719617** (mpmath, with x=t³ to remove the singularity; it agrees with a direct 20-subinterval mpmath quad to 30 digits).

| # | Claim (page's words) | Location | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Approximates ∫f "by building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Description | Confirmed | Script: `natural_spline_M` (S''=0 at the ends), `spline_integral` sums the exact per-panel integral h(y_i+y_{i+1})/2 − h³(M_i+M_{i+1})/24. `spline_integral` equals a 400 001-point trapezoid of `spline_eval` to 10 digits (1.9480699762 at m=11, 2.0122088912 at m=41). |
| 2 | "each panel uses a cubic polynomial with continuity of function value, first derivative, and second derivative across knots" | Description | Confirmed | M-form gives C⁰ and C² by construction. The largest first-derivative jump at interior knots is 8.9e-16 (m=11, 41). The interpolation error at the nodes is 0. |
| 3 | Natural spline, S''(x_0)=S''(x_n)=0 | Description | Confirmed | `M[1]=M[end]=0` printed for every m. |
| 4 | ∫S = Σ ∫_{x_i}^{x_{i+1}} S_i | Description | Confirmed | Same as 1. |
| 5 | "As sample density increases … spline interpolation error decreases and the integral estimate converges" | Description | Confirmed (asymptotically) | Error goes from −2.83e-1 (m=5) to −4.07e-3 (m=41), decreasing in magnitude at every step after m=3. Max gap rises from m=3 to m=5 and then falls, which the Behavior paragraph states. |
| 6 | f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2] | Intro, Case heading | Confirmed | Script line 8 `exp(-x)*sin(8*x^(2/3))+1`, line 9 `a,b=0,2`. Matches archive `SplineQuadMod_gr_228.gif`/`_230.gif`. |
| 7 | "Each frame recomputes the spline over the full interval using a denser odd sample count from m=3 to m=41" | Intro | Confirmed | `m_seq = 3:2:41`, `xs = range(a,b,length=m)` per frame. (Frame 1 is a blank m=0 frame showing only f, so 21 frames = 1 + 20.) |
| 8 | "Each animation below…" (there is only one) | Intro | Confirmed (wording only) | One case. Not a finding. |
| 9 | Case heading "Natural Cubic Spline Quadrature, f… on [0,2]" | Case 1 | Confirmed | As in 3 and 6. GIF title is "Natural Cubic Spline Quadrature". |
| 10 | "spline interpolant and integral estimate are rebuilt globally at each density level" | Behavior | Confirmed | Script loop recomputes xs, M and approx per m. |
| 11 | "filled spline area tracks the curve more tightly as m increases" | Behavior | Confirmed | Frames 2→21. Fill is from 0 to S, and S > 0 everywhere (min S = 0.319), so the filled area is exactly the integral estimate. |
| 12 | "area between spline and curve shrinks at every step" | Behavior | Confirmed | L1 gap: 0.7100, 0.3767, 0.2922, 0.1835, 0.1143, 0.0760, 0.0538, 0.0400, 0.0310, 0.0247, 0.0202, 0.0169, 0.0143, 0.0123, 0.0107, 0.0095, 0.0084, 0.0075, 0.0068, 0.0061, strictly decreasing (Julia and SciPy agree). |
| 13 | "from 0.71 at m=3 to 0.0061 at m=41" | Behavior | Confirmed | 0.709995 and 0.006145. |
| 14 | "The largest pointwise gap does not shrink at first" | Behavior | Confirmed | 0.877 → 1.111 → 1.090. |
| 15 | "it sits under the narrow peak near x≈0.08, which the spline undershoots" | Behavior | Confirmed for m=3,5,7; see F1 for later m | Max gap at x=0.077/0.096/0.094 with S−f negative. Peak of f at x=0.0804. |
| 16 | "by more at m=5 (1.11) and m=7 (1.09) than at m=3 (0.88)" | Behavior | Confirmed | 1.110844, 1.089948, 0.877303. |
| 17 | "From m=5 on it falls at every step" | Behavior | Confirmed | 1.111, 1.090, 0.860, 0.674, 0.544, 0.454, 0.390, 0.342, 0.305, 0.276, 0.252, 0.233, 0.217, 0.203, 0.191, 0.181, 0.172, 0.164, 0.157 strictly decreasing. |
| 18 | "to 0.16 at m=41" | Behavior | Confirmed (value). The implied location is wrong, see F1. | 0.156876 at x=0.0129. |
| 19 | Source link `[Julia source](splinequadaa.jl)` | Case 1 | Confirmed | File exists. It is the only script and produces this GIF (byte-identical regeneration). |
| 20 | Embed `splinequadaa.gif` | Case 1 | Confirmed | It is the case's GIF. |
| 21 | Alt text: "…over [0,2] with full-interval density refinement: each frame increases sample points, rebuilds the spline, and updates the integral estimate" | Case 1 | Confirmed | Frames 2–21 show "Sample Points = 3…41" and "Approximation = …" updating. |
| 22 | (Frame text) "Approximation = …" values in the GIF | Frames | Confirmed | All 20 values equal `round(approx,6)` from the instrumented copy and SciPy's natural spline integral to 10 digits. They also equal the legacy table (archive_values.png) to every printed digit, e.g. m=3 2.461678, m=5 1.733199, m=25 2.00539, m=41 2.012209. |

---

### 3. Implementation checks — `splinequadaa.jl`

**It is the method it claims to be.** The script is natural cubic spline quadrature on uniform nodes, using the standard second-derivative (M) formulation. The tridiagonal system for interior nodes, h_{i-1}M_{i-1} + 2(h_{i-1}+h_i)M_i + h_iM_{i+1} = 6(Δ_i − Δ_{i-1}), is built with the correct sub-, main and super-diagonals (lines 23–28) and solved by Thomas elimination (30–40), with M_0 = M_n = 0 (line 42). The m=3 edge case (one interior unknown) is handled correctly. The panel evaluation (45–58) is the standard A, B, (A³−A)h²/6 form. The panel integral (64) is the exact integral of that cubic. It is not a variant: this is the natural spline that Mathews' `CubicSplineQuad` and the page's Description use.

**The numbers are right.**
- The script's own `spline_integral` and SciPy `CubicSpline(xs, f(xs), bc_type='natural').integrate(0,2)` agree to 10 digits for all 20 m. Selected values (script / SciPy): m=3 2.4616775047 / 2.4616775047; m=21 2.0005440202 / 2.0005440202; m=41 2.0122088912 / 2.0122088912.
- Property checks: the spline reproduces the data at the nodes (error 0). The largest C¹ jump at the knots is 8.9e-16. The natural spline integrates linear data exactly (3x+1 on [0,2] with 7 nodes: 8.000000000000). The panel-integral formula agrees with brute-force trapezoid integration of the evaluated spline to 10 digits.
- Convergence: error versus the true value 2.016279719617 is +4.45e-1 (m=3), −2.83e-1 (5), −1.57e-2 (21), −4.07e-3 (41). The ratio from m=21 to m=41 (h halved) is 3.87, so about O(h²). That is the expected degradation for an integrand whose derivative is singular at x=0 (x^{2/3}). The page claims no rate.

**Its reference values are right.** The script draws no reference value. The "exact" curve f is the stated function (line 8; f(0)=1 correctly evaluated as 0^(2/3)=0). For context only, the true integral is 2.016279719617, so the final frame's 2.012209 is still 4.1e-3 low. The page does not claim otherwise.

**The picture shows what was computed.** The fill is from 0 to S(x). S ≥ 0.319 > 0 everywhere, so the pink area is the quadrature value. The red curve is S evaluated on an 800-point grid. The largest gap on that grid is within 1e-4 of the 200 001-point value at every m, so nothing is lost visually. The magenta curve is f. The red dots are the nodes (xs, f(xs)). Axis limits are [0,2]×[0,2.1]. f ∈ [0.36,1.92] and S ∈ [0.319,1.957], so nothing is clipped. The annotations "Sample Points = m" and "Approximation = round(approx,6)" match the instrumented values for every frame. I checked frames 1 (blank, f only), 2 (m=3), the contact sheet (m=5,9,…,37) and 21 (m=41). There is no misleading clamping or masking.

### Legacy fidelity

Archive Example 6 (`SplineQuadMod_lnk_7.html`) uses the same f, the same [0,2] and the same m = 3,5,…,41 (Mathematica loop `m0=2j`, `m0+1` points, j=1..20). Its 20 tabulated `∫CS[x]dx` values equal the GIF's to every printed digit. Examples 1–5 in the archive are worked examples with other integrands, not animations. The page's "Worked Example (Planned)" placeholder covers that material, so I raise no fidelity finding.

