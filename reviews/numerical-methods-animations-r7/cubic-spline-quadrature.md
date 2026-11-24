# Cubic Spline Quadrature — animation review (round 7)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: "Each frame" includes an opening frame that has no spline

- **Location:** `index.qmd` line 25: "Each frame recomputes the spline over the full interval using a denser odd sample count from $m=3$ to $m=41$ points." The alt text on line 36 says the same: "each frame increases sample points, rebuilds the spline, and updates the integral estimate".
- **What is there now:** a statement about every frame.
- **What is true:** the GIF has 21 frames. Frame 1 draws only $f$, with no spline, nodes, fill, sample count or approximation. The script iterates `for m in vcat(0, m_seq)` (line 69) and skips the spline when `m == 0` (line 75). The 20 frames from 2 to 21 are the ones that recompute, for $m=3,5,\dots,41$.
- **How I know:** read `committed/splinequadaa/frame_001.png` (curve only) and `frame_002.png` ("Sample Points = 3"); the GIF frame count is 21 in the manifest; 20 values of $m$ come from `collect(3:2:41)`.
- **Consequence:** small. The opening frame is a sensible device, and the legacy GIF opens the same way.
- **Suggested correction:** line 25: "After an opening frame showing $f$ alone, each frame recomputes the spline over the full interval using a denser odd sample count from $m=3$ to $m=41$ points." Alt text: "after an opening frame of the curve alone, each frame increases sample points, rebuilds the spline, and updates the integral estimate".

No Fidelity findings. See section 3, "Legacy comparison".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 8.6 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Measures used below: **area gap** is $\int_0^2|S-f|\,dx$; **pointwise gap** is $\max_{[0,2]}|S-f|$ on a grid graded toward $x=0$ (more than 2.4 million points). Exact integral: $I=2.0162797196171$.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "building a natural cubic spline interpolant through sampled nodes" | Interpolation residual ≤ 3.3e-15 at all nodes for all 20 $m$; $S''$ at both ends ≤ 2e-11 | confirmed |
| D2 | "integrating that spline exactly over each panel" | `spline_integral` minus 3-point Gauss (exact to degree 5) on each panel of `spline_eval`: ≤ 8.9e-16 | confirmed |
| D3 | "each panel uses a cubic polynomial" | Evaluator is the standard second-derivative form; each piece recovered as a cubic from four interior samples reproduces both knot values to ≤ 3.3e-15 | confirmed |
| D4 | "continuity of function value, first derivative, and second derivative across knots" | Largest jumps over all $m$ from recovered pieces: C0 4.0e-15, C1 6.4e-13, C2 4.2e-11 | confirmed |
| D5 | "$S''(x_0)=S''(x_n)=0$" | `M[1] = M[end] = 0` by construction; recovered $S''$ at ends ≤ 2e-11 | confirmed |
| D6 | $\int_a^b S=\sum_{i=0}^{n-1}\int_{x_i}^{x_{i+1}}S_i$ | Script sums over panels (lines 62 to 65) with the correct per-panel formula (D2) | confirmed |
| D7 | "spline interpolation error decreases" with density | Area gap falls at every step. Pointwise gap falls from $m=5$ on and continues to 0.01324 at $m=1281$ (ratio → 1.59, about $2^{2/3}$). The $m=3\to5$ rise is stated by the page itself | confirmed |
| D8 | "the integral estimate converges" | $\lvert S-I\rvert$ falls at every step, $0.445\to0.00407$ at $m=41$, $3.35\times10^{-6}$ at $m=2561$ (ratio → 3.18, about $2^{5/3}$) | confirmed |

### Animations introduction and case heading

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ | Script line 8; legacy image `gr_228` | confirmed |
| A2 | on $[0,2]$ | Script line 9; legacy image `gr_229` | confirmed |
| A3 | "natural cubic spline quadrature diagram" | Frames show natural spline, nodes, filled area, title and estimate | confirmed |
| A4 | "Each frame recomputes the spline" | True of 20 of 21 frames; frame 1 has no spline | **wrong (F1, Minor)** |
| A5 | "over the full interval" | `range(a, b, length=m)` with $a=0,b=2$ | confirmed |
| A6 | "denser odd sample count from $m=3$ to $m=41$" | `collect(3:2:41)`; all 20 frame labels read | confirmed |
| A7 | Source script is linked under the case | Line 34 links `splinequadaa.jl`, present | confirmed |
| A8 | Case 1 heading: function and interval | Same as A1, A2 | confirmed |
| A9 | Embedded GIF is this case | Line 36 embeds `splinequadaa.gif`, byte-identical to the script's output | confirmed |
| A10 | Alt text: "over [0,2] with full-interval density refinement" | Same as A2, A5, A6 | confirmed |
| A11 | Alt text: "each frame increases sample points, rebuilds the spline, and updates the integral estimate" | True from frame 2 on; frame 1 has none | **wrong (F1, Minor)** |

### Behavior paragraph

| # | Claim | Computed | Verdict |
|---|---|---|---|
| B1 | "rebuilt globally at each density level" | Lines 76 to 87 rebuild nodes, $M$, spline and integral per frame | confirmed |
| B2 | "tracks the curve more tightly as $m$ increases" | Area gap strictly decreasing | confirmed |
| B3 | Area "shrinks at every step" | Strictly decreasing over all 19 steps, by two independent computations | confirmed |
| B4 | "from 0.71 at $m=3$" | 0.70999 | confirmed |
| B5 | "to 0.0061 at $m=41$" | 0.00614 | confirmed |
| B6 | Largest gap "does not shrink at first" | 0.8773, 1.1108, 1.0899 at $m=3,5,7$ | confirmed |
| B7 | "narrow peak near $x\approx0.08$" | Peak of $f$ at $x=0.08038$, $f=1.91976$ | confirmed |
| B8 | Gap "sits under" the peak at first | Location 0.0768, 0.0965, 0.0945 for $m=3,5,7$; $S-f<0$ | confirmed |
| B9 | Undershoot at $m=5$ is 1.11 | 1.1108 | confirmed |
| B10 | at $m=7$ is 1.09 | 1.0899 | confirmed |
| B11 | at $m=3$ is 0.88 | 0.8773 | confirmed |
| B12 | "From $m=5$ on it falls at every step" | Strictly decreasing from $m=5$ to $m=41$ | confirmed |
| B13 | "to 0.16 at $m=41$" | 0.1569 | confirmed |
| B14 | "moves left onto the steep rise next to $x=0$" | Location falls monotonically from 0.0965 ($m=5$) to 0.0129 ($m=41$), left of the peak from $m=9$ | confirmed |
| B15 | "$x^{2/3}$ term gives $f$ an infinite slope" | $f'(x)\sim\frac{16}{3}x^{-1/3}$ as $x\to0^+$; numeric slope 533.3 at $x=10^{-6}$ against $\frac{16}{3}\cdot100=533.3$ | confirmed |
| B16 | "to $x\approx0.06$ at $m=11$" | 0.0616 | confirmed |
| B17 | "$0.03$ at $m=21$" | 0.0284 | confirmed |
| B18 | "$0.013$ at $m=41$" | 0.0129 | confirmed |
| B19 | "At $m=41$ the spline's overshoot of the peak value is only 0.03" | $\max S-\max f=1.9464-1.9198=0.0267$ | confirmed |

Reverse check (frames against page): no title, label or final value contradicts the page. The final frame reports 2.012209, which matches the computation.

---

### 3. Implementation checks: `splinequadaa.jl`

### It is the method it claims to be

Natural cubic spline by the second-derivative ($M$) formulation: a tridiagonal system with Thomas elimination for interior $M_i$, $M_0=M_n=0$, evaluated by the standard form, integrated panel by panel with
$\int_{x_i}^{x_{i+1}}S=h(y_i+y_{i+1})/2-h^3(M_i+M_{i+1})/24$. Each is verified numerically below rather than by inspection. `review/check_c2.jl` recovers each cubic piece from four interior `spline_eval` samples, so it assumes no spline formula.

### The numbers are right

Three independent routes give the same 20 values to all six printed decimals: the script's routines, `scipy.interpolate.CubicSpline(bc_type='natural')`, and a dense-matrix solve for $M$ (`review/indep2.py`). The Mathews table is a fourth, external source.

| $m$ | Script | SciPy and dense solve | Legacy table | Error vs $I$ | Area gap | Pointwise gap | at $x$ |
|---|---|---|---|---|---|---|---|
| 3 | 2.461678 | 2.461678 | 2.461678 | +0.445398 | 0.70999 | 0.8773 | 0.0768 |
| 5 | 1.733199 | 1.733199 | 1.733199 | −0.283080 | 0.37670 | 1.1108 | 0.0965 |
| 7 | 1.829912 | 1.829912 | 1.829912 | −0.186367 | 0.29221 | 1.0899 | 0.0945 |
| 9 | 1.907477 | 1.907477 | 1.907477 | −0.108803 | 0.18353 | 0.8605 | 0.0765 |
| 11 | 1.948070 | 1.948070 | 1.94807 | −0.068210 | 0.11430 | 0.6736 | 0.0616 |
| 13 | 1.970143 | 1.970143 | 1.970143 | −0.046137 | 0.07600 | 0.5441 | 0.0507 |
| 15 | 1.983110 | 1.983110 | 1.98311 | −0.033170 | 0.05383 | 0.4541 | 0.0427 |
| 17 | 1.991279 | 1.991279 | 1.991279 | −0.025000 | 0.04004 | 0.3896 | 0.0367 |
| 19 | 1.996732 | 1.996732 | 1.996732 | −0.019548 | 0.03098 | 0.3416 | 0.0320 |
| 21 | 2.000544 | 2.000544 | 2.000544 | −0.015736 | 0.02472 | 0.3048 | 0.0284 |
| 23 | 2.003314 | 2.003314 | 2.003314 | −0.012966 | 0.02022 | 0.2758 | 0.0254 |
| 25 | 2.005390 | 2.005390 | 2.00539 | −0.010890 | 0.01688 | 0.2524 | 0.0230 |
| 27 | 2.006987 | 2.006987 | 2.006987 | −0.009292 | 0.01433 | 0.2331 | 0.0209 |
| 29 | 2.008244 | 2.008244 | 2.008244 | −0.008036 | 0.01234 | 0.2170 | 0.0192 |
| 31 | 2.009252 | 2.009252 | 2.009252 | −0.007028 | 0.01075 | 0.2032 | 0.0178 |
| 33 | 2.010073 | 2.010073 | 2.010073 | −0.006207 | 0.00946 | 0.1914 | 0.0165 |
| 35 | 2.010751 | 2.010751 | 2.010751 | −0.005529 | 0.00840 | 0.1811 | 0.0154 |
| 37 | 2.011319 | 2.011319 | 2.011319 | −0.004961 | 0.00752 | 0.1721 | 0.0145 |
| 39 | 2.011799 | 2.011799 | 2.011799 | −0.004481 | 0.00678 | 0.1640 | 0.0136 |
| 41 | 2.012209 | 2.012209 | 2.012209 | −0.004071 | 0.00614 | 0.1569 | 0.0129 |

The area gap was computed two ways: trapezoid on the graded grid (`review/indep.py`) and adaptive quadrature in $t=x^{1/3}$ split at knots and sign changes of $S-f$ (`review/indep3.py`). All 20 values agree to the five decimals shown.

Property checks on the script's own routines (`review/check_routines.jl`, `review/check_c2.jl`):

- Linear data: $M\approx0$ (6.6e-14), integral 10.0 against exact 10.
- $x^2$ on 11 nodes: 2.667436 against 8/3 = 2.666667, as expected, because natural end conditions do not reproduce a quadratic.
- Interpolation, C0, C1, C2 and end conditions: largest values listed in D1, D4, D5.

### Reference values

The script draws no numerical reference other than $f$ itself and states no true integral. $f$ in code equals the page's $f$. I computed $I=2.0162797196171$ two ways with 30-digit `mpmath` (direct and with $x=t^3$, which removes the singularity); they agree to all digits shown. Convergence to $I$ is at rate about $2^{5/3}$, as expected for the $x^{2/3}$ endpoint behaviour:

| $m$ | 41 | 81 | 161 | 321 | 641 | 1281 | 2561 |
|---|---|---|---|---|---|---|---|
| $S-I$ | −4.071e-3 | −1.164e-3 | −3.514e-4 | −1.086e-4 | −3.395e-5 | −1.066e-5 | −3.352e-6 |
| ratio | | 3.50 | 3.31 | 3.23 | 3.20 | 3.19 | 3.18 |

### The picture shows what was computed

- The GIF is byte-identical to a scratch regeneration of the unchanged script, so its contents are the script's output.
- I read the labels of **all 20** spline frames (`sheet.png` and `review/labels_remaining.png`). Sample count and approximation match the table above in every frame. `round(...; digits=6)` drops a trailing zero (1.94807, 1.98311, 2.00539), which is not an error.
- The pink fill, red spline and nodes are built from the same `xs`, `ys`, `M` that produce the label; the magenta curve is $f$.
- Axis limits $[0,2]\times[0,2.1]$ hold everything: $S\in[0.319,1.957]$ across all frames and $f\in[0.357,1.920]$. No clamping or masking occurs.
- Frames 1, 2, 11 and 21 were viewed at full size. The peak undershoot at low $m$ and the small overshoot at $m=41$ are both visible as the page describes.

### Legacy comparison

- Mathews Example 6 (`SplineQuadMod_lnk_7.html`) is the source of this animation: $f[x]=1+e^{-x}\sin[8x^{2/3}]$ on $[0,2]$, with $m=2j+1$ for $j=1,\dots,20$, that is $m=3,5,\dots,41$. The page matches on function, interval, method and sample counts.
- All 20 of the page's values match Mathews' printed table to its six decimals.
- The legacy **GIF** labels differ from Mathews' own table in the last digits at four frames: 1.983111 ($m=15$), 1.996731 ($m=19$), 2.003313 ($m=23$), 2.010748 ($m=35$). The page's values agree with the table and with my computation, so this is an archive quirk and not a departure to report.
- The legacy GIF also opens with $f$ alone (24 frames, 21 distinct), so F1 concerns the page's wording, not the animation's structure.
- Examples 1 to 5 are static worked examples with no legacy animation. They belong to the page's planned "Worked Example" placeholder and are not dropped animation cases.

### Could not determine

Nothing within the review's scope.

