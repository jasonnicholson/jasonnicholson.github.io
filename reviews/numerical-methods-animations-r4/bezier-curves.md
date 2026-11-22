# Bézier Curves — animation review (round 4)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

I checked every claim on the page and every element drawn in the frames. All of them agree with independent computation. Two observations do not count as findings:

- At t = 0 and t = 1 the orange and green markers sit on top of the black markers for P1 and P2 (frames 1 and 40). This is the correct degenerate geometry of the construction, and the control points are visible in every other frame.
- The page writes "Bezier" without the accent in the Description and in the alt text. This is cosmetic only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 10.7 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 8.5 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bezieraa.gif` | 40 | byte-identical | bezieraa |
| `bezierbb.gif` | 40 | byte-identical | bezierbb |

### Page references

- Scripts linked: `bezieraa.jl`, `bezierbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i,\ t\in[0,1]$ | Standard Bernstein form. sympy expansion of it equals Mathews' parametric R(t) for both examples (`indep.py`: "equals Mathews R: True") | confirmed |
| D2 | "The curve starts at $P_0$, ends at $P_n$" | B(0)=(2,2), B(1)=(4,1) for both cases (`indep.py`) | confirmed |
| D3 | "stays inside the convex hull of its control polygon" | 20001 samples of each curve tested with a Delaunay hull of the control points: all inside (`tang.py`) | confirmed |
| D4 | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains" | Matches `decasteljau_point` (lines 16–23) and L1/L2/L3 in the loop (lines 34–37) | confirmed |
| D5 | de Casteljau is "a numerically stable way to evaluate points" | It uses only convex combinations, which is the standard result. Not separately measured | confirmed (standard property) |
| A1 | Each animation demonstrates the de Casteljau algorithm for a cubic Bézier | Both scripts compute L1 (3 points), L2 (2), L3 (1) from 4 control points | confirmed |
| A2 | "through three successive levels until a single point on the curve is reached" | L1, L2, L3, and L3 equals the Bernstein value to 4.4e-16 in every frame (`cmp.py`) | confirmed |
| A3 | "Tracing this point for all $t\in[0,1]$ draws the full curve" | The trace runs over s∈[0,t]. Its last point equals the red point in every frame (traceEnd = L3), and frame 40 shows the whole curve | confirmed |
| A4 | Julia source scripts linked under each case | Case 1 links `bezieraa.jl`, Case 2 links `bezierbb.jl`. Both exist | confirmed |
| A5 | "No archived animation GIF is available for this topic" | No file named bezier under `a2001/Animations/` | confirmed |
| A6 | Uses the control points of Mathews' Examples 3 and 4 | Notebook: Ex 3 {2,2},{1,1.5},{3.5,0},{4,1}. Ex 4 {2,2},{0,1},{3,−1},{4,1}. Same as the scripts' `P` | confirmed |
| A7 | Mathews "plots [them] from their parametric formulas and compares [them] in Example 5" | Solutions 3 and 4 use ParametricPlot of R(t). Example 5 shows gr1 and gr2 together | confirmed |
| A8 | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | Ex 6 uses the Ex 4 points with "Use Bernstein polynomials" | confirmed |
| A9 | Examples 1–2 build "a cubic polynomial through four points and a clamped cubic Hermite polynomial" | Ex 1: cubic through (1,2),(3/2,31/16),(5/2,11/16),(3,1). Ex 2: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | confirmed |
| A10 | "Example 7, a composite curve joined from four Bézier pieces" | V has 4 rows of 8 numbers, and each row ends where the next begins | confirmed |
| A11 | "Examples 8–9, on Mathematica's SplineFit package" | Ex 8: SplineFit from the Help menu. Ex 9: "nature of the spline fit constructed by Mathematica" | confirmed |
| A12 | "the de Casteljau construction is this page's addition" | The archive draws only the parametric plot and the handle lines | confirmed |
| C1-h | Case 1 heading: Example 3, P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1) | `bezieraa.jl` line 11. GIF title "Example 3" | confirmed |
| C1-a | "The curve leaves $P_0$ heading toward the handle $P_1$" | B'(0) = (−3,−1.5) = 3(P1−P0) | confirmed |
| C1-b | "bends one way without an inflection" | B'×B'' = 243t²/2 − 225t/2 + 99/2 has no real roots. Range on [0,1] is [23.46, 58.5], always > 0 | confirmed |
| C1-c | "arrives at $P_3$ along the line from $P_2$" | B'(1) = (1.5,3) = 3(P3−P2) | confirmed |
| C1-d | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each $t$" | Plot code lines 57–68. Legend and colours in all frames | confirmed |
| C1-e | "the red point traces the smooth cubic Bézier curve from $P_0$ to $P_3$" | Frames 1–40. Red point equals Bernstein B(t) to 4.4e-16 | confirmed |
| C1-alt | Alt text: control points (2,2),(1,1.5),(3.5,0),(4,1); level-1 orange, level-2 green; red point traces the blue curve from P0 to P3 | Script colours: steelblue curve, orange L1, green L2, red L3 | confirmed |
| C1-w | Embed `bezieraa.gif` is Case 1 | GIF title "Example 3". Committed GIF md5 equals the regenerated one (bdfd0132…) | confirmed |
| C2-h | Case 2 heading: Example 4, "handles twice as far out", P0=(2,2), P1=(0,1), P2=(3,−1), P3=(4,1) | `bezierbb.jl` line 10. P1−P0: (−1,−0.5) becomes (−2,−1). P3−P2: (0.5,1) becomes (1,2). Both exactly ×2 | confirmed |
| C2-a | "The endpoints and end-tangent directions are those of Case 1" | Same P0 and P3. B'(0) = (−6,−3) and B'(1) = (3,6) are parallel to Case 1's (×2) | confirmed |
| C2-b | "each handle sits twice as far from its endpoint" | As in C2-h | confirmed |
| C2-c | "The de Casteljau construction proceeds identically" | The scripts differ only in `P`, the title and the output name (diff) | confirmed |
| C2-d | "The curve stays closer to each end tangent and follows it farther before turning back" | Measured as the distance along the tangent at which the curve first leaves it by more than 0.05, 0.10 or 0.20 (`tang.py`). Start: Case 1 0.229/0.296/0.360, Case 2 0.438/0.589/0.768. End: Case 1 0.238/0.326/0.439, Case 2 0.432/0.595/0.808 | confirmed |
| C2-e | "its leftmost point is at $x\approx1.33$ instead of $x\approx1.77$ in Case 1" | x'(t)=0 at t=0.24048 gives x = 1.327230 (Case 2). At t=0.16399 it gives x = 1.766148 (Case 1) | confirmed |
| C2-f | "This is the comparison Mathews makes in his Example 5" | Example 5 overlays the Ex 3 and Ex 4 curves | confirmed |
| C2-alt | Alt text: control points (2,2),(0,1),(3,−1),(4,1); same endpoints as Case 1; handles twice as far; "reaches left to about x = 1.33" | As above. In frame 40 the leftmost point is visibly ≈ 1.33 | confirmed |
| C2-w | Embed `bezierbb.gif` is Case 2 | GIF title "Example 4". md5 equals the regenerated one (69f44a2e…) | confirmed |
| X1 | Page linked from the section index | `pages/numerical-methods/index.qmd:64` | confirmed |

### 3. Implementation checks

Both scripts are the same code with different control points (`diff`: only P, the comments, the title and the output name differ). The checks below apply to both.

**It is the method claimed.** The scripts run plain de Casteljau for a cubic: three levels of pairwise linear interpolation `(1−t)·a + t·b` (lines 35–37 of `bezieraa.jl`, the same in `bezierbb.jl`). They do not evaluate the Bernstein form under the de Casteljau name. The blue trace also uses de Casteljau (`decasteljau_point`). This is the method named on the page.

**The numbers are right.** I instrumented scratch copies (`bezieraa_inst.jl`, `bezierbb_inst.jl`) to print L1, L2, L3, the trace endpoint, the trace length and the title's t for all 40 frames. `cmp.py` then compared them with an independent Python computation, which uses explicit level formulas for L1 and L2 and the Bernstein closed form for L3:

| Script | Frames | max \|L1,L2 − independent\| | max \|L3, trace end − Bernstein B(t)\| |
|---|---|---|---|
| bezieraa | 40 | 0.0 | 4.4e-16 |
| bezierbb | 40 | 0.0 | 4.4e-16 |

Sample values for bezieraa, frame 14, t = 1/3: L1 = (1.6667,1.8333), (1.8333,1.0), (3.6667,0.3333). L2 = (1.7222,1.5556), (2.4444,0.7778). L3 = (1.96296,1.29630). Bernstein B(1/3) by hand: x = (8·2 + 12·1 + 6·3.5 + 1·4)/27 = 53/27 = 1.96296, and y = (8·2 + 12·1.5 + 6·0 + 1·1)/27 = 35/27 = 1.29630. These agree, and they agree with the positions drawn in `committed/bezieraa/frame_014.png`.

t_k = (k−1)/39 for k = 1..40, with t = 0 and t = 1 included. The titles show t rounded to 2 decimals, which is correct for every frame.

**Reference values.** The scripts draw no "exact" reference curve. The blue trace is the same Bézier curve evaluated at up to 300 samples, so its accuracy is the same as above. The page's two numerical claims (x_min ≈ 1.77 and ≈ 1.33) were checked by solving x'(t) = 0 symbolically (`indep.py`).

**The picture shows what was computed.** I viewed both contact sheets (12 frames each, t = 0 … 0.92) and frames 14 and 40 of bezieraa and frame 40 of bezierbb.

- Orange segments join the three L1 points. Green joins the two L2 points. Red is L3. The black dots are P0–P3 and the dashed grey line is the control polygon.
- In frame 14 the drawn positions match the printed values above.
- The blue trace ends exactly at the red point in every frame, because the trace's last sample is s = t.
- Axis limits x∈[−0.3,4.3] and y∈[−1.3,2.3] contain both curves (bounding boxes: Case 1 x[1.766,4] y[0.664,2]; Case 2 x[1.327,4] y[0.144,2]) and all control points (y down to −1). Nothing is clamped or masked.
- The titles name the right example ("Example 3" or "Example 4").
- Both committed GIFs are byte-identical to fresh scratch regenerations (md5 bdfd0132… and 69f44a2e…).

