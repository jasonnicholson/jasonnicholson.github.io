# Bézier Curves — animation review (round 6)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found nothing false, wrongly computed or misleading on this page, and no departure from the Mathews archive that would matter to a reader.

I looked at the following and did not count it as a finding. At t = 0 and t = 1 the level-1 and level-2 markers fall exactly on control points and cover their black markers. For example, at t = 1, P₁ is drawn orange and P₂ green. This is correct (L1 = [P₁,P₂,P₃] and L2 = [P₂,P₃] at t = 1), it is cosmetic, and the 38 frames in between make the roles clear.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 8.0 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 8.7 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i$, $t\in[0,1]$ | This is the standard Bernstein form. `check.py` shows the scripts' de Casteljau points equal it to within 8.9e-16. | confirmed |
| D2 | Description | "The curve starts at $P_0$, ends at $P_n$" | Frame 1 red point at (2,2) and frame 40 red point at (4,1) in both cases (`aa.out`/`bb.out` lines 1 and 40). | confirmed |
| D3 | Description | "stays inside the convex hull of its control polygon" | This holds because the Bernstein weights are nonnegative and sum to 1. Numerically, the bounding box of each curve (aa: x∈[1.766,4], y∈[0.664,2]; bb: x∈[1.327,4], y∈[0.144,2]) lies inside the hull, as the frames also show. | confirmed |
| D4 | Description | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains" | This matches the `decasteljau_point` loop (lines 16–23 / 12–19) and the explicit L1/L2/L3 code. | confirmed |
| A1 | Animations intro | Each animation demonstrates the de Casteljau algorithm for a **cubic** Bézier curve | Each case has 4 control points, giving levels L1 (3 points), L2 (2 points) and L3 (1 point). | confirmed |
| A2 | Animations intro | "through three successive levels until a single point on the curve is reached" | Three levels: L1, L2, L3. | confirmed |
| A3 | Animations intro | "Tracing this point for all $t\in[0,1]$ draws the full curve" | The trace is `range(0,t)` of `decasteljau_point`, which ends at the red point (`trace_end` = L3 in every line of `aa.out`/`bb.out`). Frame 40 shows the full curve. | confirmed |
| A4 | Animations intro | Julia scripts are linked under each case | `[Julia source](bezieraa.jl)` and `[Julia source](bezierbb.jl)` are present. | confirmed |
| A5 | Animations intro | "No archived animation GIF is available for this topic" | A search of `a2001/Animations/` (all subfolders) for "bezier" found nothing, and the n2003 module has only static graphs. | confirmed |
| A6 | Animations intro | The cases use the control points of Mathews' Examples 3 and 4 | Notebook lines ~2681–2800: Ex. 3 is {2,2},{1,1.5},{3.5,0},{4,1} and Ex. 4 is {2,2},{0,1},{3,−1},{4,1}. Both match the scripts. | confirmed |
| A7 | Animations intro | Mathews "plots from their parametric formulas" | The notebook's R[t] cubic with ParametricPlot. `check.py` shows R[t] is identical to the Bernstein form for both cases (`Bernstein==Mathews R: True True`). | confirmed |
| A8 | Animations intro | Mathews "compares [them] in Example 5" | The notebook's Ex. 5 shows gr1 and gr2 together. | confirmed |
| A9 | Animations intro | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | Ex. 6 uses {0,1},{3,−1} with the same endpoints and says "Use Bernstein polynomials". | confirmed |
| A10 | Animations intro | Ex. 1 is a cubic through four points, Ex. 2 is a clamped cubic Hermite, Ex. 7 is a composite of four Bézier pieces, Ex. 8–9 are on SplineFit, and none are animated | The module text and notebook line 3549 list V with 4 rows of 8 numbers, which is four cubic pieces. Ex. 8/9 are SplineFit. | confirmed |
| C1-1 | Case 1 heading | $P_0=(2,2)$, $P_1=(1,1.5)$, $P_2=(3.5,0)$, $P_3=(4,1)$ | `bezieraa.jl` line 11. | confirmed |
| C1-2 | Case 1 heading | "Mathews' Example 3" | See A6. The GIF title also reads "(Example 3)". | confirmed |
| C1-3 | Case 1 Behavior | "leaves $P_0$ heading toward the handle $P_1$" | B'(0) = (−3,−1.5) = 3(P₁−P₀). | confirmed |
| C1-4 | Case 1 Behavior | "bends one way without an inflection" | B'×B'' = 121.5t² − 112.5t + 49.5. Its discriminant is negative, it has no root in [0,1], and its minimum is ≈ 23.5 > 0 at t ≈ 0.463. | confirmed |
| C1-5 | Case 1 Behavior | "arrives at $P_3$ along the line from $P_2$" | B'(1) = (1.5,3) = 3(P₃−P₂). | confirmed |
| C1-6 | Case 1 Behavior | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each t" | Plot code lines 57–68 and the legend in every frame. | confirmed |
| C1-7 | Case 1 Behavior | "the red point traces the smooth cubic Bézier curve from $P_0$ to $P_3$" | See A3 and D2. | confirmed |
| C1-8 | Case 1 alt text | Control points (2,2),(1,1.5),(3.5,0),(4,1); level-1 orange, level-2 green; the red point traces the smooth blue curve from P0 to P3 | Code (`color=:steelblue` curve) and frames 1, 16 and 40. | confirmed |
| C1-9 | Case 1 wiring | Link and embed point to `bezieraa.jl` / `bezieraa.gif`, which is the Example 3 case | The script header and P match, and the GIF title says Example 3. | confirmed |
| C2-1 | Case 2 heading | $P_0=(2,2)$, $P_1=(0,1)$, $P_2=(3,-1)$, $P_3=(4,1)$ | `bezierbb.jl` line 10. | confirmed |
| C2-2 | Case 2 heading | "Mathews' Example 4, handles twice as far out" | P₁−P₀ = (−2,−1) = 2·(−1,−0.5) and P₂−P₃ = (−1,−2) = 2·(−0.5,−1). | confirmed |
| C2-3 | Case 2 Behavior | "endpoints and end-tangent directions are those of Case 1" | Same P₀ and P₃. B'(0) = (−6,−3) ∥ (−3,−1.5) and B'(1) = (3,6) ∥ (1.5,3). | confirmed |
| C2-4 | Case 2 Behavior | "each handle sits twice as far from its endpoint" | See C2-2. | confirmed |
| C2-5 | Case 2 Behavior | "The de Casteljau construction proceeds identically" | The code is identical apart from P (diff of loop bodies). | confirmed |
| C2-6 | Case 2 Behavior | "stays closer to each end tangent and follows it farther before turning back" | `tangent.py` measures perpendicular deviation at equal distance travelled along the tangent. Start tangent at 0.3: Case 1 0.104, Case 2 0.022. End tangent at 0.5: Case 1 0.275, Case 2 0.069. Maximum travel along the tangent before turning back: start 0.388 (Case 1) vs 1.044 (Case 2), end 0.757 vs 1.514. (At equal *parameter* t, Case 2 is farther from the tangent, but the sentence is geometric and holds geometrically, which is also Mathews' "More background" statement.) | confirmed |
| C2-7 | Case 2 Behavior | "leftmost point is at $x\approx 1.33$ instead of $x\approx 1.77$ in Case 1" | x'(t) = 0 at t = 0.240482 gives x = 1.327230 (Case 2), and at t = 0.163986 gives x = 1.766148 (Case 1). These round to 1.33 and 1.77, and frame 40 of each GIF shows the same. | confirmed |
| C2-8 | Case 2 Behavior | "This is the comparison Mathews makes in his Example 5" | See A8. | confirmed |
| C2-9 | Case 2 alt text | Control points (2,2),(0,1),(3,−1),(4,1); same endpoints as Case 1 with handles twice as far out; the blue curve follows each end tangent farther and reaches left to about x = 1.33 | See C2-1, C2-2, C2-6 and C2-7. | confirmed |
| C2-10 | Case 2 wiring | Link and embed point to `bezierbb.jl` / `bezierbb.gif`, which is the Example 4 case | The script header and P match, and the GIF title says Example 4. | confirmed |

### 3. Implementation checks

### `bezieraa.jl` (Case 1, Mathews Ex. 3)

- **It is the method it claims to be.** It is a genuine de Casteljau construction. The explicit levels (lines 34–37) apply `(1−t)·L[i] + t·L[i+1]` three times, and the traced curve uses the same recursion in `decasteljau_point`. It is not a Bernstein evaluation passing under the de Casteljau name.
- **The numbers are right.** For all 40 frames (t = k/39), `check.py` recomputed L1, L2 and L3 independently and evaluated the Bernstein/Mathews closed form x(t) = −5.5t³ + 10.5t² − 3t + 2, y(t) = 3.5t³ − 3t² − 1.5t + 2. The maximum absolute difference from the script's printed values is **8.9e-16**. Spot value, frame 16 (t = 0.384615): the script gives L3 = (2.086482, 1.178425), and the independent computation agrees.
- **Reference values.** There is no separate reference curve. The control points match Mathews' notebook exactly (A6).
- **The picture shows what was computed.** The plot code draws the L1 polyline through L1[1..3], the L2 segment, the red point at L3, and the trace over s∈[0,t]. It uses 2 to 300 samples, ending at t, and the trace end equals L3 in every frame. Frames 1, 16 and 40 match the printed values; for example, frame 16 has orange markers at (1.62,1.81), (1.96,0.92) and (3.69,0.38), green at (1.75,1.47) and (2.63,0.72), and red at (2.09,1.18). The window x∈[−0.3,4.3], y∈[−1.3,2.3] contains every control point and the whole curve. The title's t is k/39 rounded to 2 digits.

### `bezierbb.jl` (Case 2, Mathews Ex. 4)

- **It is the method it claims to be.** The code is the same as `bezieraa.jl` with different P. It is genuine de Casteljau.
- **The numbers are right.** The closed form is x(t) = −7t³ + 15t² − 6t + 2, y(t) = 5t³ − 3t² − 3t + 2, which is identical to Mathews' R[t] with Ex. 4 values. The maximum difference between the script's levels and curve point and the independent values over 40 frames is **8.9e-16**. Frame 40 gives L1 = [P₁,P₂,P₃], L2 = [P₂,P₃], L3 = P₃, as the algorithm should at t = 1.
- **Reference values.** The control points match Mathews' notebook exactly. The curve's extrema are leftmost x = 1.327230 at t = 0.2405 and lowest y = 0.144245 at t = 0.6899. Both are inside the window, so P₂ = (3,−1) lies within y ≥ −1.3.
- **The picture shows what was computed.** The plotting code is the same as Case 1. Across the contact sheet and frame 40, the curve's leftmost point is ≈ 1.33 and its bottom is ≈ 0.14 near x ≈ 2.7, matching the computation. The curve has no inflection (B'×B'' = 324t² − 306t + 126 > 0 on [0,1]), and the page does not claim otherwise.

### Archive fidelity

Both Mathews examples that are Bézier curves with a single set of four control points (Ex. 3 and Ex. 4; Ex. 6 repeats Ex. 4's data) are animated with their exact data. The page explicitly lists the examples it does not animate (1, 2, 7, 8, 9) and describes them accurately. The de Casteljau construction is labelled as the page's own addition. No fidelity issues.

