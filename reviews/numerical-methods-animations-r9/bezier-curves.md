# Bézier Curves — animation review (round 9)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0. Misleading: 0. Minor: 0.

One observation that is not a finding. In the first frame (t = 0) and the last frame (t = 1), the de Casteljau level points fall exactly on control points, so their orange, green and red markers cover the black control-point markers. For example, in the last frame of `bezierbb.gif`, P1 appears orange and P2 green. This is mathematically correct, lasts only one frame at each end, and does not change what a viewer would conclude.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 17.9 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 16.5 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i,\ t\in[0,1]$ | This is the standard Bernstein form. My sympy expansion of it for n=3 matches Mathews' printed parametric formulas exactly (gr_96, gr_109; see I-2). | confirmed |
| D2 | Description | "The curve starts at $P_0$, ends at $P_n$" | B(0)=(2,2) and B(1)=(4,1) for both cases. The script prints L3 = [2.0,2.0] at t=0 and [4.0,1.0] at t=1. | confirmed |
| D3 | Description | "stays inside the convex hull of its control polygon" | I sampled 10,001 points on each curve with a Delaunay hull test, and every point lies inside the hull (`indep.out`: "all curve points in hull: True" for both). | confirmed |
| D4 | Description | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains" | Script lines 16–23 and 33–37 (aa), 12–19 and 31–34 (bb) do this. | confirmed |
| D5 | Description | de Casteljau is "numerically stable" | This is a standard property: the algorithm uses only convex combinations. I did not measure it, since no number is claimed. | confirmed (standard) |
| A1 | Animations intro | Each animation demonstrates de Casteljau for a **cubic** Bézier | Both scripts use 4 control points, giving levels L1 (3 points), L2 (2) and L3 (1). | confirmed |
| A2 | Animations intro | "three successive levels until a single point on the curve is reached" | L1, L2 and L3 in the code. L3 matches the Bernstein value to 2.7e-15 at all 40 frame parameters. | confirmed |
| A3 | Animations intro | "Tracing this point for all $t\in[0,1]$ draws the full curve" | The blue trace is `decasteljau_point(P,s)` for s∈[0,t], and its end equals the red point. Its maximum deviation from Bernstein is 2.7e-15. The last frame shows the full curve. | confirmed |
| A4 | Animations intro | Julia source linked under each case | `[Julia source](bezieraa.jl)` and `(bezierbb.jl)` are present. | confirmed |
| A5 | Archive para | No archived animation GIF is available for this topic | Nothing matching bez/casteljau is under `a2001/`, and the module has no animated GIF. | confirmed |
| A6 | Archive para | Animations use the control points of Mathews' Examples 3 and 4 | Ex 3 (lnk_4, gr_96): x=2−3t+10.5t²−5.5t³ and y=2−1.5t−3t²+3.5t³ invert to P=(2,2),(1,1.5),(3.5,0),(4,1). Ex 4 (gr_103) lists the values {2,2},{0,1},{3,−1},{4,1}. Both match the scripts. | confirmed |
| A7 | Archive para | He "plots from their parametric formulas and compares in Example 5" | lnk_4 and lnk_5 use ParametricPlot of R[t], and lnk_6 overlays gr1 and gr2 (gr_112, gr_113). | confirmed |
| A8 | Archive para | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | The notebook's Example 6 uses (2,2),(0,1),(3,−1),(4,1) with Bernstein sums. | confirmed |
| A9 | Archive para | Ex 1–2: cubic polynomial through four points and a clamped cubic Hermite polynomial | lnk_2 and lnk_3 text. | confirmed |
| A10 | Archive para | Ex 7: composite curve joined from four Bézier pieces | The notebook gives V as 4 rows of 8 numbers ("four Bézier pieces"). | confirmed |
| A11 | Archive para | Ex 8–9 on Mathematica's SplineFit package | lnk_10 and lnk_11 text. | confirmed |
| A12 | Archive para | "the de Casteljau construction is this page's addition" | The archive has no de Casteljau construction. Mathews draws only the parametric curve and the handle lines. | confirmed |
| C1-h | Case 1 heading | Mathews' Example 3, P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1) | `bezieraa.jl` line 11 and the GIF title "Example 3" match. | confirmed |
| C1-a | Case 1 | "leaves $P_0$ heading toward the handle $P_1$" | B'(0)=(−3,−1.5)=3(P1−P0). | confirmed |
| C1-b | Case 1 | "bends one way without an inflection" | x'y''−y'x''=121.5t²−112.5t+49.5 has complex roots (0.463±0.439i) and lies in [23.46, 58.5] on [0,1], so it is always positive. | confirmed |
| C1-c | Case 1 | "arrives at $P_3$ along the line from $P_2$" | B'(1)=(1.5,3)=3(P3−P2). | confirmed |
| C1-d | Case 1 | Level-1 orange, level-2 green, curve point red, shown at each t | Script lines 56–68. Frames 1, 16 and 40 and the contact sheet show it. | confirmed |
| C1-e | Case 1 | Red point traces the smooth cubic from $P_0$ to $P_3$ | Frames 1→40. The last frame shows the full blue curve ending at the red point on (4,1). | confirmed |
| C1-alt | Case 1 alt | Control points (2,2),(1,1.5),(3.5,0),(4,1); orange/green locate red; red traces smooth blue curve from P0 to P3 | Same as above. The curve colour is steelblue. | confirmed |
| C1-w | Case 1 wiring | Link `bezieraa.jl`, embed `bezieraa.gif` | The committed GIF is byte-identical to a fresh run of the unchanged script (manifest; I re-checked with `cmp`). | confirmed |
| C2-h | Case 2 heading | Mathews' Example 4, P0=(2,2), P1=(0,1), P2=(3,−1), P3=(4,1) | `bezierbb.jl` line 10 and the GIF title "Example 4" match. | confirmed |
| C2-a | Case 2 heading/text | "handles twice as far out"; endpoints and end-tangent directions are those of Case 1 | P1−P0: (−2,−1) vs (−1,−0.5). P2−P3: (−1,−2) vs (−0.5,−1). B'(0)=(−6,−3) and B'(1)=(3,6) have the same directions as in Case 1. | confirmed |
| C2-b | Case 2 | "The de Casteljau construction proceeds identically" | The code is identical apart from P and the title. | confirmed |
| C2-c | Case 2 | "The curve stays closer to each end tangent and follows it farther before turning back" | Measured at equal arclength 0.25, 0.5, 0.75 and 1.0 from P0, the distance to the start tangent is 0.015, 0.066, 0.168 and 0.334 for Case 2 against 0.057, 0.257, 0.506 and 0.745 for Case 1. Distances to the end tangent behave the same way. The maximum progress along the start-tangent direction is 1.044 for Case 2 against 0.388 for Case 1. | confirmed |
| C2-d | Case 2 | leftmost point at $x\approx1.33$ | x'(t)=0 at t=0.240482, giving x=1.327230. | confirmed |
| C2-e | Case 2 | "instead of $x\approx1.77$ in Case 1" | x'(t)=0 at t=0.163986, giving x=1.766148. | confirmed |
| C2-f | Case 2 | "This is the comparison Mathews makes in his Example 5" | lnk_6 overlays the two curves (gr_113), where the purple Ex 4 curve reaches about 1.3. | confirmed |
| C2-alt | Case 2 alt | Control points (2,2),(0,1),(3,−1),(4,1), same endpoints, handles twice as far out, reaches left to about x = 1.33 | As above. In the last frame of bezierbb the leftmost point is visibly at about 1.33. | confirmed |
| C2-w | Case 2 wiring | Link `bezierbb.jl`, embed `bezierbb.gif` | Byte-identical regeneration (manifest and `cmp`). | confirmed |

### 3. Implementation checks

Both scripts share their code apart from the control points and the title, so the four points apply to both.

**Method.** The code runs the de Casteljau algorithm as it is usually defined: repeated affine interpolation `(1-t)*a + t*b` between adjacent points. It does so explicitly for the frame (L1/L2/L3) and in a loop (`decasteljau_point`) for the traced curve. It is not a Bernstein evaluation posing as de Casteljau.

**Numbers.** I instrumented copies (`review/*_instr.jl`, plotting removed) to print L1, L2, L3 and the trace endpoint for all 40 frame values of t. I compared them with an independent computation in `review/indep.py`:
- L3 and the trace endpoint against the Bernstein form expanded symbolically by sympy. The maximum error is 1.3e-15 for aa and 2.7e-15 for bb.
- L1 against the direct lerp, and L2 against the degree-2 Bernstein combination of three consecutive control points. The maximum error is 8.9e-16 for aa and 4.4e-16 for bb.
- A property check that needs no remembered formula: the level-2 segment L2[1]−L2[0] must be parallel to B'(t). Its cross product with the symbolic B'(t) was below 1e-9 at every frame in both cases.
- The expanded polynomials match Mathews' printed results term by term:
  - aa: x=2−3t+21/2 t²−11/2 t³ and y=2−3/2 t−3t²+7/2 t³, against gr_96's 2−3t+10.5t²−5.5t³ and 2−1.5t−3t²+3.5t³.
  - bb: x=2−6t+15t²−7t³ and y=2−3t−3t²+5t³, against gr_109.

**Reference values.** The scripts draw no separate "exact" reference. The blue curve is the method itself, and it was checked against Bernstein above.

**Picture.** I viewed both contact sheets, frame 16 of aa (t=0.38), frame 14 of bb (t=0.33) and frame 40 of bb:
- The orange polyline joins the three L1 points.
- The green segment joins the two L2 points.
- The red point lies on the green segment and at the tip of the blue trace.
- The dashed grey line is the control polygon P0–P1–P2–P3.

The title states the right example number and t rounded to 2 decimals (t = k/39). The axis window x∈[−0.3,4.3], y∈[−1.3,2.3] contains every control point and both curves: the bounding boxes are aa x∈[1.766,4], y∈[0.664,2] and bb x∈[1.327,4], y∈[0.144,2]. There is no clamping or masking. Both regenerated GIFs are byte-identical to the committed ones (`cmp` on `regen/<stem>/<stem>.gif` against the repository).

**Fidelity to the archive.** The control points and examples are Mathews' Examples 3 and 4. Mathews' Example 5 overlay appears as two separate animations, with the comparison stated in numbers in the Case 2 text. The remaining examples are explicitly listed as not animated. There is no silent drop and no changed example.

