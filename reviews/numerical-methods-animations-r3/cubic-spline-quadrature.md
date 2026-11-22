# Cubic Spline Quadrature — animation review (round 3)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F-1. Page match, Minor: "tracks the curve more tightly" fails at the first refinement under the pointwise (sup) gap

- **Location:** `index.qmd` line 32, Case 1 Behavior: "The filled spline area tracks the curve more tightly as $m$ increases." The same applies to the Description, line 20: "As sample density increases over the full interval, spline interpolation error decreases". This is a general statement that holds asymptotically, so it needs no change on its own account.
- **What is there now:** an unqualified claim of tighter tracking as $m$ grows.
- **What is true:** the claim holds at every step if you measure the area between spline and curve. It fails at the first step if you measure the largest pointwise gap. From m = 3 to m = 5 the spline undershoots the narrow peak near $x\approx0.08$ by more, not less:

| m | sup gap \|S-f\| | at x | f there | S there | L1 gap (area between) | share of [0,2] where gap > 0.5 |
|---|---|---|---|---|---|---|
| 3 | 0.8773 | 0.0768 | 1.9188 | 1.0415 | 0.7100 | 47.2% |
| 5 | **1.1108** | 0.0965 | 1.9023 | 0.7915 | 0.3767 | 22.7% |
| 7 | 1.0899 | 0.0945 | 1.9063 | 0.8164 | 0.2922 | 21.5% |
| 9 | 0.8605 | 0.0765 | 1.9186 | 1.0582 | 0.1835 | 14.6% |
| 11 ... 41 | 0.674 ... 0.157, decreasing at every step | | | | 0.114 ... 0.0061, decreasing at every step | 9.2% ... 0% |

  The sup gap rises 0.877 to 1.111 at m = 3 to 5. It barely falls at m = 5 to 7 (1.111 to 1.090), and only at m = 9 does it get back below the m = 3 value. The L1 gap falls at every one of the 19 steps. This is visible in the frames: in frame 3 (m = 5) the red spline sits near 0.79 under the magenta peak at 1.90, lower than the near-straight arch at about 1.04 in frame 2 (m = 3). Everywhere else frame 3 tracks the dip and the second hump much better.
- **How I know:** `/usr/bin/python3 review/supgap.py` (SciPy natural `CubicSpline`, 400 001 points on [0,2], identical to the script's spline to 1e-15 per `cmp.py`). Frames `committed/splinequadaa/frame_002.png` and `frame_003.png` were checked by eye.
- **Why Minor:** "filled spline area" is most naturally measured by the area between the curves, and on that measure the claim is exactly true. The overall impression a reader takes away, that refinement converges, is correct. The only thing a reader could miss is that one feature, the peak, gets worse before it gets better.
- **Suggested rewording:** "The filled spline area tracks the curve more tightly as $m$ increases: the area between spline and curve shrinks at every step, from 0.71 at $m=3$ to 0.006 at $m=41$. The exception is the narrow peak near $x\approx0.08$, which the spline undershoots even more at $m=5$ and $m=7$ than at $m=3$. It is the last feature to be resolved."

Two further observations that I judged not to be findings are at the end of part 2.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


One finding (Minor). No Error, no Misleading, no fidelity departure. The evidence is in parts 2 and 3.

This finding was added after the coordinator asked me to read B2 as a statement about the shape of the filled region rather than about the integral. Two corrections to how that request described things. The page says "as $m$ increases", not "at every step". My first verdict rested mainly on the L1 gap (the area between spline and curve), with the integral error as support. Reading the claim strictly, it still fails at one step under the sup gap, so I record it below.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 8.0 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | approximates $\int_a^b f$ "by building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Script builds natural spline (`natural_spline_M`, M[1]=M[end]=0 at every m) and integrates each panel with $h(y_i+y_{i+1})/2-h^3(M_i+M_{i+1})/24$, the exact integral of the cubic in M-form. Script spline equals `scipy.interpolate.CubicSpline(bc_type='natural')` to 1.3e-15 at 800 points (m=7, 41); script integral equals `cs.integrate(0,2)` to all 16 digits for every m (table in part 3). | confirmed |
| D2 | Description | "each panel uses a cubic polynomial with continuity of function value, first derivative, and second derivative across knots" | Value continuity by construction (interpolation at both ends of each panel; node residual 0.0 for every m). S'' continuity by construction of M-form (shared M_i). Measured S' jump at interior knots: max 4.4e-16 (m=7), 6.7e-15 (m=41) (`checks.jl`). | confirmed |
| D3 | Description | natural spline "$S''(x_0)=S''(x_n)=0$" | Script returns `vcat(0.0, M_inner, 0.0)`; instrumented print M1=Mend=0.0 for all m. | confirmed |
| D4 | Description | $\int_a^b S = \sum_{i=0}^{n-1}\int_{x_i}^{x_{i+1}} S_i$ | Matches `spline_integral` loop over panels. | confirmed |
| D5 | Description | "As sample density increases ... spline interpolation error decreases and the integral estimate converges" | The integral error against the exact value 2.01627971961709633 falls at every step, from 4.45e-1 (m=3) to 4.07e-3 (m=41). The L1 interpolation error falls at every step, from 0.710 to 0.0061. The sup-norm error rises from m=3 (0.877) to m=5 (1.111) and then falls at every step from m=5 on. This is a general statement about the method, true asymptotically and true here from m=5 on. | confirmed as a general convergence statement; the same pre-asymptotic sup rise is covered under F-1 |
| A1 | Animations intro | $f(x)=1+e^{-x}\sin(8x^{2/3})$ | script line 8 `exp(-x) * sin(8 * x^(2 / 3)) + 1`; matches legacy title `y = e^{-x} sin(8 x^{2/3}) + 1` | confirmed |
| A2 | Animations intro / heading | on $[0,2]$ | `a, b = 0.0, 2.0`; xlims (0,2) | confirmed |
| A3 | Animations intro | "Each frame recomputes the spline over the full interval" | Each frame builds `xs = range(a,b,length=m)` afresh and recomputes M. Frame 1 is m=0 (function only, no spline) as an intro frame. | confirmed (frame 1 is an intro frame; trivial) |
| A4 | Animations intro | "denser odd sample count from $m=3$ to $m=41$ points" | `m_seq = 3:2:41` (20 values); frame labels read 3,5,...,41 in the extracted frames; legacy Example 6 table lists 3,5,...,41 | confirmed |
| A5 | Animations intro | "Each animation below shows the natural cubic spline quadrature diagram" | One animation; title in every frame "Natural Cubic Spline Quadrature" | confirmed |
| C1 | Case 1 heading | "Natural Cubic Spline Quadrature, $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$" | as A1, A2, D3 | confirmed |
| B1 | Behavior | "The spline interpolant and integral estimate are rebuilt globally at each density level." | as A3; uniform nodes over the whole [0,2] each frame, M solved globally | confirmed |
| B2 | Behavior | "The filled spline area tracks the curve more tightly as $m$ increases." | The L1 gap (area between spline and f) falls at every step: 0.710, 0.377, 0.292, 0.184, 0.114, 0.076, 0.054, 0.040, 0.031, 0.025, 0.020, 0.017, 0.014, 0.012, 0.011, 0.0095, 0.0084, 0.0075, 0.0068, 0.0061. The sup gap does not: it rises 0.877 to 1.111 (m=3 to 5), then 1.090 (m=7), then falls at every later step to 0.157. The worst point is under the peak at x of about 0.08 (`supgap.py`). Visible in frames 2 and 3. | wrong at the first step under the pointwise reading; true under the area reading. Finding F-1 (Minor) |
| W1 | Link | `[Julia source](splinequadaa.jl)` | file exists, is the only script, and produces this GIF | confirmed |
| W2 | Embed + alt text | `splinequadaa.gif`; "each frame increases sample points, rebuilds the spline, and updates the integral estimate" | GIF byte-identical to regenerated output (manifest); frame annotations "Sample Points = m" and "Approximation = ..." change every frame | confirmed |
| F1 | Frames: annotation values | "Approximation" shown in frames | Script value printed vs label: e.g. m=5 1.733199, m=21 2.000544, m=41 2.012209; independent SciPy natural-spline integral gives the same values to 15 digits. Labels are `round(approx; digits=6)` and agree. Legacy GIF shows the same numbers (e.g. 2.461678, 1.829912, 2.012209). | confirmed |
| F2 | Frames: display | spline and f inside window | ylims (0, 2.1): f range [0.3572, 1.9198]; spline range over all m [0.3188, 1.9571]; nothing clipped. Fill is to y=0, i.e. the integrated area. | confirmed |
| L1 | Fidelity | page reproduces the archive's only animation (Example 6 / `Splineaa.gif`) | Same function, interval, m sequence, natural BC and approximation values; archive has no other animated case. Examples 1-5 of the archive are static tolerance/node tables, not animations, and the page does not claim to cover them. | confirmed |

Notes, judged not to be findings:

- **N1.** (Superseded: this non-monotone sup gap is now finding F-1.) The sup-norm interpolation error is not monotone at the start: m=3 0.877, m=5 1.111, m=7 1.090, then falling to 0.157 at m=41.
- **N2.** Convergence is slow: error ratio from m=21 to m=41 (h halved) is 1.574e-2 / 4.071e-3 = 3.87, so about $O(h^2)$, not the $O(h^4)$ of a smooth function. The cause is the $x^{2/3}$ term ($f'$ unbounded at 0, and $f''(0)$ is not 0, so the natural end condition does not hold). The page states no rate, so nothing on the page is false. The final frame's value 2.012209 is still 4.1e-3 below the true integral, and the GIF never shows the true value. A reader cannot see that from the page, but per the review standard this is missing content, not an error.

### 3. Implementation checks: `splinequadaa.jl`

**Is it the method claimed?** Yes. It is natural cubic spline interpolation in second-derivative (M) form with uniform nodes, a tridiagonal system solved by the Thomas algorithm (lines 17-43), evaluated by the standard M-form formula (lines 45-58), and integrated exactly panel by panel (lines 60-67). This is the same method as the page Description and the Mathews module ("Integrate the natural cubic spline over the interval [a,b]").

**Are the numbers right?** Yes.
- Instrumented copy (`review/inst.jl`, plotting loop without `@animate`/`gif`) printed approx, M endpoints, node residual and max deviation per m.
- Independent computation (`review/indep.py`, SciPy `CubicSpline(bc_type='natural').integrate`):

| m | script | SciPy | error vs exact |
|---|---|---|---|
| 3 | 2.461677504688585 | 2.461677504688585 | 4.45e-1 |
| 5 | 1.7331993537961796 | 1.733199353796180 | 2.83e-1 |
| 7 | 1.8299124826871151 | 1.829912482687115 | 1.86e-1 |
| 11 | 1.9480699762179035 | 1.948069976217903 | 6.82e-2 |
| 21 | 2.0005440202177294 | 2.000544020217730 | 1.57e-2 |
| 31 | 2.009251688341952 | 2.009251688341952 | 7.03e-3 |
| 41 | 2.0122088912288487 | 2.012208891228848 | 4.07e-3 |

(All 20 values agree to 15-16 digits; full table in the `indep.py` output.)
- Spline values: the script's `spline_eval` agrees with SciPy's natural spline at 800 points to 8.9e-16 (m=7) and 1.3e-15 (m=41) (`cmp.py`).
- Property tests on the script's own routines (`checks.jl`): node residual 0.0 for all m; S' continuity at knots to 7e-15; linear $1+x$ integrated exactly (error 0.0 for m=5, 9, 17); $x^2$ and $x^3$ not exact (errors 1.19e-2, 3.57e-2 at m=5, falling about 8x per halving), which is expected because their $f''$ is not 0 at the ends; $\int_0^\pi \sin = 2$ (natural end condition consistent): errors -1.31e-3, -6.98e-5, -4.19e-6, -2.59e-7, -1.61e-8 for m=5..65, ratio about 16 per halving, so $O(h^4)$ as it should be.

**Are the reference values right?** The script draws no reference integral, only the function $f$ itself (line 92), which matches the stated $f$. The exact integral I used for comparison is 2.0162797196170963 (mpmath, 30 digits, split over 40 subintervals; cross-checked with `scipy.integrate.quad`, 2.0162797196173927 with error estimate 2.4e-9).

**Does the picture show what was computed?** Yes. I viewed the contact sheet and frames 3 (m=5) and 21 (m=41). The pink fill and red line are the spline from 0 to S(x), built from the same `xs, ys, M` used for the integral. The red dots are at the nodes `(xs, f(xs))` and lie on both curves. The magenta curve is `f` on 800 points. The annotations report the m and the integral of the frame being drawn. Nothing is clamped or masked, and the axis window contains every curve (F2). There are 21 frames: one intro frame with f only, then m=3..41.

