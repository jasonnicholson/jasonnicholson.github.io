# Cubic Spline Quadrature — animation review (round 2)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue.

Three observations below are recorded for completeness. None of them meets the bar for a finding, and the reasons are given.

- The on-frame approximation uses `round(approx; digits=6)`, so Julia drops trailing zeros. Frames for m = 11, 15 and 25 show `1.94807`, `1.98311` and `2.00539`, where the other frames show six decimals. All three values are correct at the digits shown. This is cosmetic and does not mislead.
- The GIF has no legend and no formula label, and the page does not say which colour is which. The legacy GIF printed `y = e^{-x} sin(8x^{2/3}) + 1` on the plot. The roles can still be read from the picture: the red curve through the dots bounds the pink fill, and the magenta curve is f. This is a presentation choice, not something false.
- The Description says that "spline interpolation error decreases" as density rises. In the sup norm this fails for the first two refinements (0.877 → 1.111 → 1.090 at m = 3, 5, 7) and holds from then on. The L1 error and |integral error| decrease monotonically across all 20 frames. The sentence is a general asymptotic statement and is true in that sense.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 7.2 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12–13 | Approximates ∫ f by "building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Script builds the natural spline (`natural_spline_M`, M₁ = Mₙ = 0) and integrates each panel with h(yᵢ+yᵢ₊₁)/2 − h³(Mᵢ+Mᵢ₊₁)/24. Simpson's rule, which is exact on cubics, applied to the script's own `spline_eval` panel by panel gives the same value to 10 digits for every m (instr.jl). | confirmed |
| 2 | Description l.14 | Each panel is a cubic with continuity of value, first and second derivative across knots | Node reproduction error is 0.0 for every m. The largest jump in first derivative at interior knots is ≤ 6.7e-15. Second-derivative continuity holds by construction in the M-form, since both adjacent panels have S''(xᵢ) = Mᵢ. | confirmed |
| 3 | Description l.16 | Natural spline, S''(x₀) = S''(xₙ) = 0 | `M[1] = M[end] = 0.0` printed for all m. scipy `CubicSpline(bc_type='natural')` has |S''| ≤ 3e-13 at both ends and gives the same integrals. | confirmed |
| 4 | Description l.17–19 | ∫f ≈ ∫S = Σ ∫_{xᵢ}^{xᵢ₊₁} Sᵢ | This is what `spline_integral` computes (see #1). | confirmed |
| 5 | Description l.20 | "As sample density increases … spline interpolation error decreases and the integral estimate converges" | \|I−Q\|: 0.445, 0.283, 0.186, 0.109, …, 4.07e-3, monotone decreasing over m = 3…41. It keeps converging (1.06e-5 at m = 1281). The L1 error is monotone decreasing. The sup error rises from m = 3 to 5 and then falls (see observation). | confirmed |
| 6 | Animations intro l.24–25 | Function f(x) = 1 + e^{−x} sin(8x^{2/3}) on [0,2] | Script l.8–9: `exp(-x)*sin(8*x^(2/3)) + 1`, `a, b = 0.0, 2.0`. Matches the legacy Example 6 and the legacy GIF label. | confirmed |
| 7 | l.25–26 | "Each frame recomputes the spline over the full interval using a denser odd sample count from m=3 to m=41" | `m_seq = 3:2:41` (20 values) plus a leading m = 0 frame showing only f. The frames read "Sample Points = 3" (frame 2) to "= 41" (frame 21). Nodes are `range(a,b,length=m)` over all of [0,2]. Strictly, frame 1 has no spline, which is a trivial intro frame. | confirmed |
| 8 | l.24 | "natural cubic spline quadrature diagram" | GIF title "Natural Cubic Spline Quadrature", with a filled spline area and nodes. | confirmed |
| 9 | Case heading l.30 | Case 1, natural cubic spline quadrature, same f, [0,2] | Same as #6. One case, and the script has one case. | confirmed |
| 10 | Behavior l.32 | "spline interpolant and integral estimate are rebuilt globally at each density level" | The loop body recomputes xs, ys, M and approx from scratch for each m. | confirmed |
| 11 | Behavior l.32 | "The filled spline area tracks the curve more tightly as m increases" | L1 ∫\|S−f\|: 0.710, 0.377, 0.292, 0.184, 0.114, 0.076, …, 0.0061 (strictly decreasing, l1.py). The frames show this visually (sheet.png; frame 21 is nearly coincident apart from a small overshoot at the x≈0.08 peak). | confirmed |
| 12 | Source link l.34 | `[Julia source](splinequadaa.jl)` | The file exists and is the script that produces this GIF (byte-identical regen). | confirmed |
| 13 | Embed l.36 | `splinequadaa.gif` | Exists, 21 frames, byte-identical to regen. | confirmed |
| 14 | Alt text l.36 | "over [0,2] with full-interval density refinement: each frame increases sample points, rebuilds the spline, and updates the integral estimate" | Same as #7 and #10. The annotation updates on every frame from frame 2 on. | confirmed |
| 15 | GIF frames | Displayed "Approximation" values for all 20 m | Every displayed value equals the script's value rounded to 6 d.p. and the independent scipy value (table in §3). | confirmed |
| 16 | Fidelity | Example matches legacy (function, interval, m = 3,5,…,41) | lnk_7 lists m = 3,5,…,41. The legacy GIF shows the same f on [0,2]. Its values at m = 5 (1.733199) and 41 (2.012209) agree exactly with the page's GIF. | confirmed |

Legacy note: the legacy GIF shows 1.983111, 1.996731, 2.003313 and 2.010748 at m = 15, 19, 23 and 35. The correct values, from both the script and scipy, are 1.983110, 1.996732, 2.003314 and 2.010751. The new page is right and the legacy is off in the last digit. This does not count against the page. Legacy Examples 1–5 are static integral exercises with no animation. The page reproduces the one legacy animation (Example 6), so nothing animated has been dropped.

### 3. Implementation checks: `splinequadaa.jl`

**It is the method it claims to be.** It is the natural cubic spline in second-derivative (M) form. The interior tridiagonal system is hᵢMᵢ + 2(hᵢ+hᵢ₊₁)Mᵢ₊₁ + hᵢ₊₁Mᵢ₊₂ = 6(Δᵢ₊₁ − Δᵢ), solved by the Thomas algorithm with Mₒ = Mₙ = 0. I checked the index alignment: sub-diagonal `dl = h[2:n-2]`, super-diagonal `du = h[2:n-2]` as `h[i+1]`, diagonal `2(h[i]+h[i+1])`. The n = 3 edge case is a single equation, the elimination loop is empty, and it is correct. Panel integral: h(yᵢ+yᵢ₊₁)/2 − h³(Mᵢ+Mᵢ₊₁)/24, which is the exact integral of the M-form cubic. The variant is the natural (free) end condition, which is the one the Description states.

**The numbers are right.** `instr.jl` (a script copy without plotting) printed the values. `indep.py` uses scipy `CubicSpline(x, f(x), bc_type='natural').integrate(0,2)`.

| m | script | scipy (independent) | error vs true |
|---|---|---|---|
| 3 | 2.4616775047 | 2.461678 | +4.454e-01 |
| 5 | 1.7331993538 | 1.733199 | −2.831e-01 |
| 7 | 1.8299124827 | 1.829912 | −1.864e-01 |
| 9 | 1.9074769312 | 1.907477 | −1.088e-01 |
| 11 | 1.9480699762 | 1.948070 | −6.821e-02 |
| 13 | 1.9701428098 | 1.970143 | −4.614e-02 |
| 15 | 1.9831098697 | 1.983110 | −3.317e-02 |
| 17 | 1.9912794381 | 1.991279 | −2.500e-02 |
| 19 | 1.9967315021 | 1.996732 | −1.955e-02 |
| 21 | 2.0005440202 | 2.000544 | −1.574e-02 |
| 23 | 2.0033135783 | 2.003314 | −1.297e-02 |
| 25 | 2.0053896820 | 2.005390 | −1.089e-02 |
| 27 | 2.0069872688 | 2.006987 | −9.292e-03 |
| 29 | 2.0082441061 | 2.008244 | −8.036e-03 |
| 31 | 2.0092516883 | 2.009252 | −7.028e-03 |
| 33 | 2.0100726689 | 2.010073 | −6.207e-03 |
| 35 | 2.0107511105 | 2.010751 | −5.529e-03 |
| 37 | 2.0113187327 | 2.011319 | −4.961e-03 |
| 39 | 2.0117988448 | 2.011799 | −4.481e-03 |
| 41 | 2.0122088912 | 2.012209 | −4.071e-03 |

Property checks that do not depend on remembering formulas:

- Interpolation at nodes is exact (error 0.0).
- C¹ jumps are ≤ 6.7e-15.
- End second derivatives are 0.
- The panel integral formula agrees with Simpson's rule on each panel to 10 digits.
- A linear function (3x+1 on [0,2], 7 nodes) integrates to exactly 8.0.

Convergence check (scipy, nodes doubled each time): the error ratio goes 4.34, 3.87, 3.50, 3.31, 3.23, 3.20, 3.19, so the observed order tends to p ≈ 1.67. That is the expected O(h^{5/3}) for f − 1 ~ 8x^{2/3} near x = 0, where f′ is unbounded. The page claims no order, so this is consistent and not a finding.

**Its reference values are right.** The script draws no reference value. For my own error column I computed the true integral two ways with mpmath at 30 digits: direct quad split at 41 points, and the substitution x = t³, which removes the x^{2/3} singularity. Both give I = 2.01627971961709632788727442192.

**The picture shows what was computed.** I viewed frames 1, 2 and 21 and the full contact sheet (frames 1, 3, 5, …, 21), alongside the legacy sheet and the legacy frames 6 and 24.

- Frame 1 shows f only.
- Frame 2 shows a 3-node spline (nodes at 0, 1, 2), annotated "Sample Points = 3, Approximation = 2.461678".
- Frame 21 shows 41 nodes and 2.012209.
- The spline curve is evaluated with the script's own `spline_eval` on 800 points, and the fill goes down to y = 0. The nodes are scatter points at (xs, f(xs)).
- The magenta curve is the same f as on l.8.
- y-limits are [0, 2.1]. The maximum of f is about 1.93 and the largest spline value at any m is 1.957 (m = 33), so nothing is clipped. The spline is never negative: its smallest value over all frames is 0.319, consistent with the fill.
- No clamping or NaN masking is used.
- There are 21 frames: one intro frame plus 20 values of m.

