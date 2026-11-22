# Cubic Spline Quadrature — animation review

Page: [`pages/numerical-methods/cubic-spline-quadrature/index.qmd`](../../pages/numerical-methods/cubic-spline-quadrature/index.qmd) · Scripts: `splinequadaa.jl` · GIFs: 1

**Result:** 0 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

None.

This rests on three checks. The script's natural-spline integral matches scipy `CubicSpline(bc_type="natural").integrate(0,2)` to within 9e-16 for all 20 values of m. The spline interpolates exactly, is C² at every interior knot (jumps at most 3.6e-15), and has S''=0 at both ends. Every checkable claim on the page agrees with these computed values and with the frames.

Observations that are not findings:
- The on-frame value uses `round(approx; digits=6)`, which drops trailing zeros. For m=11, 15 and 25 the frame shows "1.94807", "1.98311" and "2.00539" instead of six decimals. The values are correct and this is cosmetic.
- The page says "Each animation below" (line 24) and "these animations" (line 28), but there is only one animation. This is harmless wording.
- Convergence is slow. At m=41 the error is still −0.00407 against the true integral 2.0162797196. The reason is that f has an x^{2/3} cusp at x=0, where f′(0)=∞. The sup-norm interpolation error stays near x≈0.013 and is 0.157 at m=41. The page claims no rate and no true value, so this is not a mismatch. A reader might like to see the true value, but that is content the page does not yet have.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `splinequadaa.jl` | yes | 3.8 | splinequadaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 13 | "building a natural cubic spline interpolant through sampled nodes" | Script lines 17–43 solve the second-derivative (M) tridiagonal system with M₁=Mₙ=0 (line 42). The instrumented check gives S''(a)=S''(b)=0 to ≤3e-13. The result matches scipy `bc_type="natural"` to 1e-15. It differs from not-a-knot (e.g. m=41: 2.013876 vs 2.012209) and from clamped. | confirmed |
| 2 | 13 | "then integrating that spline exactly over each panel" | `spline_integral` (line 64) uses the per-panel exact integral h(yᵢ+yᵢ₊₁)/2 − h³(Mᵢ+Mᵢ₊₁)/24. It agrees with scipy's exact piecewise integral to ≤9e-16, and with a 200,000-panel Simpson integral of `spline_eval` to ~6e-14. | confirmed |
| 3 | 14 | "each panel uses a cubic polynomial with continuity of function value, first derivative, and second derivative across knots" | At interior knots, the maximum left/right jumps over all m are S: 0, S′: 3.6e-15, S″: 0 (instr.jl). | confirmed |
| 4 | 16 | "natural spline interpolant ($S''(x_0)=S''(x_n)=0$)" | M vector ends set to 0.0 (line 42); verified numerically in both Julia and scipy. | confirmed |
| 5 | 18 | Quadrature formula ∫S = Σ ∫_{x_i}^{x_{i+1}} S_i | Implemented as the panel sum in lines 60–67 (see #2). | confirmed |
| 6 | 20 | "As sample density increases … spline interpolation error decreases and the integral estimate converges" | The L1 error ∫\|S−f\| decreases monotonically from 0.710 (m=3) to 0.00614 (m=41). \|integral error\| decreases monotonically from 0.445 (m=3) through 0.283, 0.186, … to 0.00407 (m=41), towards the true value 2.0162797196 (mpmath, 40 digits, two different subdivisions agree). The sup-norm error rises from m=3 to m=5 (0.877 to 1.111) before falling, because of the cusp at 0. The statement is about the asymptotic trend, which holds. | confirmed |
| 7 | 24–25 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script line 8 is `exp(-x)*sin(8*x^(2/3)) + 1`, and line 9 sets a, b = 0, 2. | confirmed |
| 8 | 25 | "Each frame recomputes the spline over the full interval" | Each frame rebuilds `xs = range(a,b,length=m)` and solves for a fresh M (lines 76–78). | confirmed |
| 9 | 25–26 | "denser odd sample count from $m=3$ to $m=41$ points" | `m_seq = 3:2:41` (line 11) gives 20 odd values. The frames show "Sample Points = 3" (frame 2) through "= 41" (frame 21), and frame 1 shows f alone. "Sample Points" equals the number of nodes; the frames show m dots. | confirmed |
| 10 | 24, 30 | Diagram is "natural cubic spline quadrature diagram"; case heading names the method, f and interval | The frame title reads "Natural Cubic Spline Quadrature". The magenta curve is f, the red curve with pink fill is S, and the dots are nodes. | confirmed |
| 11 | 32 | "The spline interpolant and integral estimate are rebuilt globally at each density level." | Same as #8. | confirmed |
| 12 | 32 | "The filled spline area tracks the curve more tightly as $m$ increases." | L1 error decreases monotonically for every step of m (tracking.py). The frames show a visible gap at the first peak for m≤17 that closes progressively (sheet.png, frames 2, 6, 10, 21). | confirmed |
| 13 | 34 | `[Julia source](splinequadaa.jl)` | The file exists and the manifest shows it produces splinequadaa.gif byte-identically. | confirmed |
| 14 | 36 | Embed `splinequadaa.gif`. Alt text: "over [0,2] with full-interval density refinement: each frame increases sample points, rebuilds the spline, and updates the integral estimate" | Embed is wired correctly. Each frame after the first increases m by 2 and updates "Approximation" (values match the computed list below). Frame 1 has no spline, which is immaterial. | confirmed |

## Implementation checks

### splinequadaa.jl
- **Method:** natural cubic spline in second-derivative (M) form. The tridiagonal system has diagonal 2(hᵢ+hᵢ₊₁), off-diagonals hᵢ, and right-hand side 6(Δᵢ₊₁−Δᵢ). It is solved by the Thomas algorithm, with M₀=Mₙ=0. Evaluation uses the standard A/B form. The integral is the exact per-panel integral of that form. This is the method the page names: natural end condition, not clamped or not-a-knot.
- **Numbers:** `reviewer/instr.jl` contains the script's functions with the animation stripped, plus checks; its output is in `reviewer/script_values.txt`. `reviewer/indep.py` is an independent scipy and mpmath computation. Run with `cd reviewer && julia instr.jl && /usr/bin/python3 -I indep.py script_values.txt`.

  | m | script | scipy natural | diff | true − script |
  |---|---|---|---|---|
  | 3 | 2.461677504688585 | 2.461677504688585 | 0 | −0.445398 |
  | 5 | 1.733199353796180 | 1.733199353796180 | 0 | +0.283080 |
  | 9 | 1.907476931214697 | 1.907476931214698 | 2e-16 | +0.108803 |
  | 13 | 1.970142809796150 | 1.970142809796150 | 2e-16 | +0.046137 |
  | 21 | 2.000544020217729 | 2.000544020217729 | 4e-16 | +0.015736 |
  | 29 | 2.008244106140837 | 2.008244106140837 | 0 | +0.008036 |
  | 41 | 2.012208891228849 | 2.012208891228848 | 4e-16 | +0.004071 |

  The remaining m values also agree to ≤9e-16. The full list is printed by indep.py. Interpolation error at the nodes is exactly 0 for every m. The maximum C¹ jump is 3.6e-15, the C² jump is 0, and the end S'' is 0. Both Julia and scipy confirm C¹ and the natural end condition.
- **Reference values:** the script draws no "true" integral. The plotted f is the same expression as the page's f. The true integral is ∫₀² f = 2.0162797196170963279 (mpmath quad, 40 digits, subdivided into 40 equal panels and separately at [0, 1e-6, 1e-3, 0.01, 0.1, 0.5, 1, 1.5, 2]; both agree to 20 digits). It is given here only for the convergence check.
- **Picture:** I looked at sheet.png and full-size frames 2 (m=3) and 21 (m=41). Frame 1 shows f only. Each later frame shows the spline (red line, pink fill to y=0), the nodes (dots at xs, f(xs)) and f (magenta). The on-frame "Approximation" values for m=3, 5, 9, 13, 17, 21, 25, 29, 33, 37 and 41 (2.461678, 1.733199, 1.907477, 1.970143, 1.991279, 2.000544, 2.00539, 2.008244, 2.010073, 2.011319, 2.012209) all equal the script's values rounded to 6 decimals. The spline's range over all m is [0.357, 1.957], inside ylims (0, 2.1), so nothing is clipped. Because S>0 everywhere, the pink fill area equals the reported integral. No clamping or NaN masking is used. Nodes lie on both curves in the frames, consistent with exact interpolation.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/cubic-spline-quadrature/`](evidence/cubic-spline-quadrature/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
