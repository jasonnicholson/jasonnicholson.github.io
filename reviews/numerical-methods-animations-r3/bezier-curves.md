# Bézier Curves — animation review (round 3)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page matched my own computation, the instrumented script output, the frames, and the legacy archive. Details are in sections 2 and 3.

These are not findings, but I looked at them and rejected them:
- In frame 1 (t = 0), the level-1 and level-2 points coincide with P0–P2 and the red point sits on P0. Frame 40 has the same overlap at the P3 end. This is the true geometry of de Casteljau at the endpoints, not a display artefact.
- The Case 1 alt text says "level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve". Read strictly, the grammar makes all three trace the curve, when only the red point does. The Behavior paragraph states it correctly. This is a wording nit and would not mislead a reader.
- The Description spells "Bezier" without the accent while the title uses "Bézier". This is cosmetic.
- The axis window (−0.3..4.3 × −1.3..2.3) is wider than Mathews' {{0,4},{−1,2}}. Every control point and the whole curve are visible in both GIFs.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 9.1 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 9.1 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i$, $t\in[0,1]$ | This is the standard Bernstein form. sympy: for both cases it equals Mathews' parametric R[t] identically (difference 0, `indep.py`) | confirmed |
| 2 | Description | "The curve starts at $P_0$, ends at $P_n$" | B(0)=(2,2), B(1)=(4,1) in both cases | confirmed |
| 3 | Description | "stays inside the convex hull of its control polygon" | 200001 curve samples per case, Delaunay hull test: all inside (`tangent.py`) | confirmed |
| 4 | Description | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains" | `decasteljau_point` and the L1/L2/L3 lines do exactly this | confirmed |
| 5 | Animations intro | Each animation demonstrates the de Casteljau algorithm for a **cubic** Bézier | Both scripts have 4 control points and run three levels of lerp | confirmed |
| 6 | Animations intro | "through three successive levels until a single point on the curve is reached" | L1 has 3 points, L2 has 2, L3 has 1. L3 equals Bernstein B(t) to ≤4.4e-16 on all 40 frames | confirmed |
| 7 | Animations intro | "Tracing this point for all $t\in[0,1]$ draws the full curve" | t_anim = range(0,1,40). The trace ends exactly at the red point (trace_end_err = 0 on all frames). Frame 40 shows the full curve | confirmed |
| 8 | Case 1 heading | Mathews' Example 3, P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1) | `bezieraa.jl` line 11 matches. Archive nb Example 3: {2,2},{1,1.5},{3.5,0},{4,1} | confirmed |
| 9 | Case 1 Behavior | "leaves $P_0$ heading toward the handle $P_1$" | B'(0) = (−3,−1.5) = 3(P1−P0) | confirmed |
| 10 | Case 1 Behavior | "bends one way without an inflection" | The curvature numerator x'y''−y'x'' = 243t²/2 − 225t/2 + 99/2 has no real roots. Its minimum on [0,1] is 23.46 > 0 | confirmed |
| 11 | Case 1 Behavior | "arrives at $P_3$ along the line from $P_2$" | B'(1) = (1.5,3) = 3(P3−P2) | confirmed |
| 12 | Case 1 Behavior | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each t" | Plot code lines 57–68. Frames 1, 20 and 40 and the contact sheet show orange, green and red markers in every frame | confirmed |
| 13 | Case 1 Behavior | "the red point traces the smooth cubic Bézier curve from $P_0$ to $P_3$" | Frames: red at (2,2) in frame 1 and at (4,1) in frame 40. The blue trace follows it | confirmed |
| 14 | Case 1 link/embed | `bezieraa.jl` / `bezieraa.gif` are Case 1 | The script has the Example 3 points and writes `bezieraa.gif`. The GIF title reads "Example 3". The committed GIF is byte-identical to the regenerated one (manifest) | confirmed |
| 15 | Case 1 alt | control points (2,2),(1,1.5),(3.5,0),(4,1); orange/green/red; "smooth blue curve from P0 to P3" | Matches the script and the frames. The blue is `:steelblue` (grammar nit noted above) | confirmed |
| 16 | Case 2 heading | Mathews' Example 4, P0=(2,2), P1=(0,1), P2=(3,−1), P3=(4,1) | `bezierbb.jl` line 10 matches. Archive nb Example 4: {2,2},{0,1},{3,−1},{4,1} | confirmed |
| 17 | Case 2 heading/Behavior | "handles twice as far out" / "each handle sits twice as far from its endpoint" | P1−P0: (−1,−0.5) in Case 1 vs (−2,−1) in Case 2. P2−P3: (−0.5,−1) vs (−1,−2). Both exactly ×2 | confirmed |
| 18 | Case 2 Behavior | "endpoints and end-tangent directions are those of Case 1" | Same P0 and P3. B'(0) = (−6,−3) ∥ (−3,−1.5). B'(1) = (3,6) ∥ (1.5,3) | confirmed |
| 19 | Case 2 Behavior | "The de Casteljau construction proceeds identically" | The code is the same apart from P and the title | confirmed |
| 20 | Case 2 Behavior | "stays closer to each end tangent and follows it farther before turning back" | Curvature at P0: 0.417 vs 1.312 in Case 1. At P3: 0.477 vs 1.550. Perpendicular deviation at along-tangent distance 0.25: 0.015 vs 0.063 (P0 end) and 0.016 vs 0.056 (P3 end). Maximum reach along the tangent from P0: 1.04 vs 0.39. From P3: 1.51 vs 0.76 (`tangent.py`) | confirmed |
| 21 | Case 2 Behavior + alt | "leftmost point is at $x\approx 1.33$ instead of $x\approx 1.77$ in Case 1" | x'(t)=0 at t=0.24048, x = 1.327230 (Case 2). At t=0.16399, x = 1.766148 (Case 1). Both round correctly | confirmed |
| 22 | Case 2 Behavior | "This is the comparison Mathews makes in his Example 5" | Archive nb Example 5: "Compare the Bézier curve … given in examples 3 and 4", with Show[gr1, gr2, …] | confirmed |
| 23 | Case 2 link/embed | `bezierbb.jl` / `bezierbb.gif` are Case 2 | The script has the Example 4 points. The GIF title reads "Example 4". Byte-identical regeneration (manifest) | confirmed |
| 24 | Case 2 alt | control points (0,1),(3,−1), same endpoints, "reaches left to about x = 1.33" | See #16 and #21. In frame 20 the curve's leftmost point is visibly at x≈1.33 | confirmed |
| 25 | Closing note | "No archived animation GIF is available for this topic" | `a2001/Animations/`: no file or reference matching "bez" (grep -ril, find -iname) | confirmed |
| 26 | Closing note | Mathews "plots [Examples 3 and 4] from their parametric formulas" | Archive nb Solutions 3 and 4 use R[t] in the x0−3t(x0−x1)+… form with ParametricPlot | confirmed |
| 27 | Closing note | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | Archive nb Example 6: same points as Example 4, "Use Bernstein polynomials", Σ x_i Binomial[3,i] tⁱ(1−t)^{3−i} | confirmed |
| 28 | Closing note | Examples 1–2: a cubic through four points and a clamped cubic Hermite | Archive HTML text for Examples 1 and 2 | confirmed |
| 29 | Closing note | Example 7: a composite curve from four Bézier pieces | Archive nb: V has 4 rows of 8 numbers, each a BezierCurve piece | confirmed |
| 30 | Closing note | Examples 8–9 cover Mathematica's SplineFit package | Archive HTML: "Add-ons; Standard Packages; NumericalMath; SplineFit" | confirmed |
| 31 | Count (implicit) | Two cases, two scripts, two GIFs | Manifest: 2 scripts, 2 GIFs, 40 frames each | confirmed |

**Fidelity:** Cases 1 and 2 use Mathews' Examples 3 and 4 exactly. Every example not animated is listed with a reason. The de Casteljau construction is declared as the page's own addition. No fidelity departure.

### 3. Implementation checks

### `bezieraa.jl` (Case 1, Example 3)
- **Method:** the animation computes the de Casteljau levels L1 (3 points), L2 (2 points) and L3 (1 point) explicitly at each frame t. `decasteljau_point` does the same iteration for the trace. This is genuine de Casteljau, not Bernstein evaluation passing under that name.
- **Numbers:** I instrumented a scratch copy (`bezieraa_instr.jl`), which printed L1, L2 and L3 for every frame and compared L3 with an independent Bernstein evaluation. The maximum difference over 40 frames is 4.4e-16. Spot check at frame 20 (t = 19/39), independent numpy de Casteljau against the script:
  - L1 = [(1.512821,1.756410),(2.217949,0.769231),(3.743590,0.487179)]: identical
  - L2 = [(1.856345,1.275477),(2.961210,0.631821)]: identical
  - L3 = (2.394612,0.961901): identical
- **Reference values:** none. Independently, the Bernstein form equals Mathews' R[t] (sympy difference 0). The expanded form is x = −11t³/2 + 21t²/2 − 3t + 2, y = 7t³/2 − 3t² − 3t/2 + 2.
- **Picture:** 40 frames, t = k/39. The titles match round(t,2): 0.0, 0.03, …, 0.49, 0.97, 1.0. Orange segments join the L1 points, green joins the L2 points, red marks L3. The blue trace samples [0,t] and its last sample equals the red point exactly (error 0 on all frames). Frame 20 (bb) and frames 1 and 40 (aa) were checked against the printed coordinates. The whole curve (x∈[1.766,4], y∈[0.664,2]) and all control points lie inside the axis limits. There is no clamping or masking.

### `bezierbb.jl` (Case 2, Example 4)
- **Method:** the code is identical to `bezieraa.jl` apart from P and the title. It is genuine de Casteljau.
- **Numbers:** instrumented copy (`bezierbb_instr.jl`): L3 vs Bernstein, maximum difference 4.4e-16 over 40 frames. Frame 20 against independent numpy: L1 = [(1.025641,1.512821),(1.461538,0.025641),(3.487179,−0.025641)], L2 = [(1.238001,0.788297),(2.448389,0.000657)], L3 = (1.827677,0.404575). All identical, and they match the marker positions in `committed/bezierbb/frame_020.png`.
- **Reference values:** none. Bernstein form: x = −7t³ + 15t² − 6t + 2, y = 5t³ − 3t² − 3t + 2. It equals Mathews' R[t] (difference 0). The curve has no inflection (curvature numerator 324t² − 306t + 126 > 0).
- **Picture:** 40 frames with correct titles. The curve (x∈[1.327,4], y∈[0.144,2]) and P1=(0,1) and P2=(3,−1) are all within the limits. The trace ends exactly at the red point. The contact sheet shows the curve reaching about x≈1.33 and the construction progressing as computed.

### Reproduction
Per the manifest, both scripts run from scratch copies (exit 0) and reproduce the committed GIFs byte-for-byte. The GIFs therefore reflect the code as reviewed.

