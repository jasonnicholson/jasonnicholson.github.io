# Cubic Spline Quadrature — animation review (round 8)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with independently computed values at the precision stated, the implementation is a correct natural cubic spline quadrature, and the GIF draws what was computed.

Non-findings noted for completeness (cosmetic, not misleading):
- GIF frame for m=25 reads "Approximation = 2.00539" (Julia `round(...; digits=6)` drops the trailing zero of 2.005390). Value is correct.
- Intro says "Each animation below" although there is one animation. Wording only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 7.7 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description: approximates the integral "by building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Script `natural_spline_M` sets M_1=M_n=0 and solves the standard tridiagonal system (matches a dense solve of the same system: max diff 0.0); `spline_integral` uses h(y_i+y_{i+1})/2 - h^3(M_i+M_{i+1})/24, which matches fine-grid Simpson integration of `spline_eval` to <=9e-16 for all m | confirmed |
| 2 | "continuity of function value, first derivative, and second derivative across knots" | Standard second-derivative (M) formulation; spline reproduces data at nodes (node error 0.0 for all m); scipy natural `CubicSpline` gives identical integrals to 6 decimals for all 20 m | confirmed |
| 3 | Natural BC S''(x_0)=S''(x_n)=0 | M[1]=M[end]=0 printed for every m | confirmed |
| 4 | Quadrature formula = sum of panel integrals of S_i | as #1 | confirmed |
| 5 | "As sample density increases ... the integral estimate converges" | error vs true value 2.0162797196 (mpmath): +0.445, -0.283, -0.186, ..., -0.00407 at m=41; |error| decreasing monotonically from m=5 | confirmed |
| 6 | f(x)=1+e^{-x} sin(8x^{2/3}) on [0,2] | script line 8-9 | confirmed |
| 7 | "After an opening frame showing f alone" | frame_001 shows only the magenta curve, no annotation; loop over `vcat(0, m_seq)` | confirmed |
| 8 | "each frame recomputes the spline over the full interval using a denser odd sample count from m=3 to m=41" | `m_seq = 3:2:41`, nodes `range(a,b,length=m)`; frames 2-21 annotate 3,5,...,41 | confirmed |
| 9 | Frame count implied (1 + 20) | 21 frames in committed GIF | confirmed |
| 10 | Case heading: Natural Cubic Spline Quadrature, f, [0,2] | script title, f, a,b | confirmed |
| 11 | "rebuilt globally at each density level" | spline recomputed from scratch on full interval per frame | confirmed |
| 12 | "the area between spline and curve shrinks at every step" | ∫|S-f|: 0.71, 0.3767, 0.2922, 0.1835, 0.1143, 0.0760, 0.0538, 0.0400, 0.0310, 0.0247, 0.0202, 0.0169, 0.0143, 0.0123, 0.0108, 0.00946, 0.00840, 0.00752, 0.00678, 0.006145 (both python and julia) - strictly decreasing | confirmed |
| 13 | "from 0.71 at m=3 to 0.0061 at m=41" | 0.7100, 0.006145 | confirmed |
| 14 | "largest pointwise gap does not shrink at first: it sits under the narrow peak near x≈0.08" | peak of f at x=0.0804 (f=1.9198); max gap at x=0.0768 (m=3), 0.0965 (m=5), 0.0945 (m=7), spline below f (undershoot) | confirmed |
| 15 | gaps "m=5 (1.11) and m=7 (1.09) than at m=3 (0.88)" | 1.1108, 1.0899, 0.8773 | confirmed |
| 16 | "From m=5 on it falls at every step, to 0.16 at m=41" | 1.1108, 1.0899, 0.8605, 0.6736, ..., 0.1640, 0.1569 strictly decreasing | confirmed |
| 17 | "moves left onto the steep rise next to x=0 ... to x≈0.06 at m=11, 0.03 at m=21 and 0.013 at m=41" | 0.0616, 0.0284, 0.0129 | confirmed |
| 18 | "where the x^{2/3} term gives f an infinite slope" | f'(x) ~ (16/3) x^{-1/3} cos(...) e^{-x} → ∞ as x→0+ | confirmed |
| 19 | "At m=41 the spline's overshoot of the peak value is only 0.03" | max S - max f = +0.0267 at m=41 (spline max 1.946 at x=0.0757) | confirmed (0.027 rounds to 0.03) |
| 20 | "The filled spline area tracks the curve more tightly" / pink fill = spline area | `fillrange=0.0` under spline (red), f overlaid in magenta; frames show this | confirmed |
| 21 | Link `[Julia source](splinequadaa.jl)` and embed `splinequadaa.gif` | file exists; GIF byte-identical to regeneration of that script | confirmed |
| 22 | Alt text: opening frame of curve alone, then each frame increases sample points, rebuilds spline, updates integral estimate | frames 1-21 | confirmed |

### 3. Implementation checks: `splinequadaa.jl`

**Is the method claimed.** Natural cubic spline in the M (second-derivative) formulation: interior equations h_{i-1}M_{i-1}+2(h_{i-1}+h_i)M_i+h_iM_{i+1} = 6(Δ_i - Δ_{i-1}), M_end=0, solved by Thomas algorithm. Script M equals dense solve of the same system (max diff 0.0, m=9). Evaluation formula is the standard one; reproduces data at all nodes (error 0). Integral of each panel h(y_i+y_{i+1})/2 - h^3(M_i+M_{i+1})/24 is the exact integral of the cubic piece.

**Numbers right.** Script values vs independent scipy `CubicSpline(bc_type='natural').integrate(0,2)`:

| m | script (GIF) | scipy |
|---|---|---|
| 3 | 2.461678 | 2.461678 |
| 5 | 1.733199 | 1.733199 |
| 9 | 1.907477 | 1.907477 |
| 13 | 1.970143 | 1.970143 |
| 17 | 1.991279 | 1.991279 |
| 21 | 2.000544 | 2.000544 |
| 25 | 2.00539 | 2.005390 |
| 29 | 2.008244 | 2.008244 |
| 33 | 2.010073 | 2.010073 |
| 37 | 2.011319 | 2.011319 |
| 41 | 2.012209 | 2.012209 |

All 20 values agree to 6 decimals (full list in `review/indep.py` and `review/instr.jl` output). Property checks of `spline_integral`: exact (err 0) for 1 and 3x+2 at m=5,9,17; not exact for x^2 (1.19e-2, 1.50e-3, 1.88e-4) and x^3 (3.57e-2, 4.51e-3, 5.64e-4) - ratio ~8 per halving of h, the expected O(h^2) end effect of natural BCs on functions with nonzero end curvature. This is correct behaviour for a natural spline (only linear functions satisfy S''=0 at both ends among cubics).

Legacy comparison: Mathews' frames show the same approximations (2.461678, 1.829912, 1.948070, 1.996731, 2.003313, 2.006987, 2.009252, 2.011799, 2.012209; his 1.983111 and 2.010748 differ from ours 1.983110 / 2.010751 in the last digit(s), consistent with his own implementation/rounding; scipy confirms the script's values).

**Reference values.** No reference integral is drawn or quoted on the page. True integral computed independently with mpmath (30 digits, split at 0.01, 0.1, 0.3, 0.6, 1): 2.016279719617.

**Picture shows what was computed.** Pink fill is area under the spline down to y=0 (the quantity integrated); red line = spline; red dots = nodes; magenta = f drawn on top from 800 points. Annotations show m and the computed integral for the right m in each frame. ylims (0, 2.1) contain all spline values (min 0.319, max 1.957) and f (max 1.920); xlims = [a,b]. No clamping or masking. Frames 1, 2, mid-sequence (sheet) and 21 inspected.

**Legacy fidelity.** Archive Example/animation uses the same f, interval, natural spline, odd counts 3..41 and "Approximation" readout; the page reproduces it. No archive case dropped (the module has one animation).

