# Cubic Spline Quadrature — animation review (round 9)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation, and the script's numbers agree with an independent implementation to 10 digits.

Things I noticed but do not count as findings:
- The frame for m=25 shows `Approximation = 2.00539` (5 decimals) where the other frames show 6. This is because `round(…; digits=6)` drops the trailing zero of 2.005390. The value is correct and the difference is cosmetic.
- The introduction says "Each animation below" although there is only one. This is a wording matter only.
- In the legacy GIF the values at m=15, 19 and 35 differ from this page in the 6th decimal (1.983111, 1.996731, 2.010748 against 1.983110, 1.996732, 2.010751). SciPy agrees with the page, not with the legacy GIF, so the page is the one that is right.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 14.8 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Script lines 17–43 solve the tridiagonal system for second derivatives M with M₀=Mₙ=0. Panel integral (line 64) h(yᵢ+yᵢ₊₁)/2 − h³(Mᵢ+Mᵢ₊₁)/24 equals Simpson's rule applied to the script's own `spline_eval` (exact for cubics) to 10 digits for every m | confirmed |
| D2 | "continuity of function value, first derivative, and second derivative across knots" | The second-derivative form is continuous in S'' by construction. The finite-difference jump in S' at the knots is ≤ 8e-5 with h=1e-7, which is consistent with finite-difference truncation error. Node residual is exactly 0 | confirmed |
| D3 | Natural BC S''(x₀)=S''(xₙ)=0 | `M[1]=M[end]=0` printed for all m | confirmed |
| D4 | Formula ∫S = Σ∫S_i | Same as D1 | confirmed |
| D5 | "As sample density increases … the integral estimate converges" | \|error\| against the true value 2.0162797196 (mpmath) is 0.445, 0.283, 0.186, …, 0.00407, decreasing at every m | confirmed |
| A1 | f(x)=1+e^{-x} sin(8x^{2/3}) on [0,2] | Script line 8–9 | confirmed |
| A2 | "After an opening frame showing f alone" | Frame 1 shows only the magenta curve (m=0 branch) | confirmed |
| A3 | "recomputes the spline over the full interval using a denser odd sample count from m=3 to m=41" | `m_seq = 3:2:41` (20 values), equally spaced on [0,2]. 21 frames in total | confirmed |
| A4 | Case heading: Natural Cubic Spline Quadrature, same f, [0,2] | Script, and the GIF title "Natural Cubic Spline Quadrature" | confirmed |
| B1 | "area between spline and curve shrinks at every step, from 0.71 at m=3 to 0.0061 at m=41" | L1 area: 0.710, 0.377, 0.292, 0.184, 0.114, …, 0.00678, 0.006145. Strictly decreasing | confirmed |
| B2 | "largest pointwise gap … sits under the narrow peak near x≈0.08" (early m) | The peak of f is at x=0.0804. The max gap is at x=0.077 (m=3), 0.0965 (m=5), 0.0945 (m=7), with S<f | confirmed |
| B3 | "undershoots by more at m=5 (1.11) and m=7 (1.09) than at m=3 (0.88)" | 1.111, 1.090, 0.877 | confirmed |
| B4 | "From m=5 on it falls at every step, to 0.16 at m=41" | 1.111, 1.090, 0.861, 0.674, …, 0.164, 0.157. Monotone | confirmed |
| B5 | "moves left onto the steep rise next to x=0 … x≈0.06 at m=11, 0.03 at m=21 and 0.013 at m=41" | 0.0616, 0.0284, 0.0129 | confirmed |
| B6 | "x^{2/3} term gives f an infinite slope" at 0 | f′ ~ (16/3)x^{-1/3}cos(8x^{2/3})e^{-x} → ∞ as x→0⁺ | confirmed |
| B7 | "At m=41 the spline's overshoot of the peak value is only 0.03" | max S = 1.9464 against max f = 1.9198, an overshoot of 0.0267 | confirmed |
| B8 | "spline interpolant and integral estimate are rebuilt globally at each density level" | Each frame rebuilds the spline from all m nodes on [0,2] | confirmed |
| W1 | Link `[Julia source](splinequadaa.jl)` | The file exists and is the script that produced the GIF | confirmed |
| W2 | Embed `splinequadaa.gif` and its alt text ("after an opening frame of the curve alone, each frame increases sample points, rebuilds the spline, and updates the integral estimate") | Frames 1–21 match this description | confirmed |
| G1 | Displayed approximations in frames (e.g. 1.733199, 1.907477, 1.970143, 1.991279, 2.000544, 2.00539, 2.008244, 2.010073, 2.011319, 2.012209) | Match the script and SciPy exactly | confirmed |

### 3. Implementation checks: `splinequadaa.jl`

**It is the method it claims to be.** The script uses a natural cubic spline in the standard second-derivative (M) form. It solves the (m−2)×(m−2) tridiagonal system with Thomas elimination, which is safe without pivoting because the system is strictly diagonally dominant, and it sets M at both ends to 0. Quadrature is the exact integral of the piecewise cubic. The nodes are equally spaced. This is the natural cubic spline quadrature that the page and the legacy module describe.

**The numbers are right.**
- I instrumented a scratch copy (`review/inst.jl`). It prints Q, a per-panel Simpson integral of the script's own `spline_eval`, the residual at the nodes and the M endpoints.
- For the independent check (`review/indep.py`, `/usr/bin/python3`), I used `scipy.interpolate.CubicSpline(bc_type='natural').integrate(0,2)`.
- Script and SciPy agree to 10 digits:
  - m=3: 2.4616775047 in both
  - m=5: 1.7331993538 in both
  - m=7: 1.8299124827 in both
  - m=25: 2.0053896820 in both
  - m=41: 2.0122088912 in both
- The intermediate m values agree as well, at the 6 printed decimals.
- Property check with SciPy's natural spline on 11 nodes:
  - It integrates 1 and x exactly.
  - It does not integrate x² (2.66744 against 2.66667) or x³ (4.00231 against 4) exactly.
  - This is expected: with the natural end condition the spline does not reproduce quadratics.

**Reference values.** The script draws no "true" integral. I computed the true value myself with mpmath, splitting the interval at the peak: 2.01627971961710. Every claim about pointwise gaps and areas was checked against f evaluated on a grid of 2,000,001 points.

**The picture shows what was computed.**
- The red curve with pink fill to y=0 is `spline_eval` on 800 points, using the same xs, ys and M as the annotation.
- The red markers are (xs, f(xs)).
- The magenta curve is f.
- The annotation shows m and `spline_integral` for the same spline.
- I viewed the contact sheet and frame 21. The final frame shows the slight spline overshoot at the peak (about 0.03) and the undershoot on the steep rise at x≈0.01. This matches B5 and B7.
- ylims are (0, 2.1). The spline maximum (1.957) and the curve maximum (1.920) are inside the window, so nothing is clamped or hidden.

**Legacy fidelity.**
- The Mathews animation `Splineaa.gif` (24 frames) uses the same function, the same interval and the same odd node counts from 3 to 41, with an opening curve-only frame.
- Its final value, 2.012209, matches the page's.
- The page drops nothing a reader would notice. There is no fidelity finding.

