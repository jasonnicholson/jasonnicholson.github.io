# Bézier Curves — animation review (round 8)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Considered and rejected as findings:
- **Unequal aspect ratio.** Each frame is 700×550 with xlims 4.6 wide and ylims 3.6 tall, so one y unit is drawn about 1.4× longer than one x unit. The Bézier and de Casteljau constructions are affine-invariant. Collinearity, interpolation ratios along segments, tangency, the "twice as far" handle relation and the x-coordinate of the leftmost point all survive this scaling, so nothing the page claims changes. This is cosmetic.
- **Degenerate endpoint frames.** At t=0 and t=1 the level-1, level-2 and red markers sit exactly on the control points and hide the black markers. That is the correct geometry of de Casteljau at the endpoints, not a drawing error.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 8.2 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 9.4 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Bernstein form $B(t)=\sum\binom{n}{i}(1-t)^{n-i}t^iP_i$, $t\in[0,1]$ | Standard. Expanding it for both control sets in sympy reproduces Mathews' printed $\vec P_1[t]$ and $\vec P_2[t]$ (gr_96, gr_109) | confirmed |
| D2 | Curve starts at $P_0$, ends at $P_n$ | Script frame 1 has red=(2,2) and frame 40 has red=(4,1) | confirmed |
| D3 | Stays inside the convex hull of the control polygon | Standard property, and the frames show the curve inside the polygon hull | confirmed |
| D4 | de Casteljau evaluates points by repeated linear interpolation between adjacent points | `decasteljau_point` and the inline L1/L2/L3 do exactly this | confirmed |
| A1 | Each animation demonstrates de Casteljau for a cubic | Both scripts use 4 control points and 3 levels | confirmed |
| A2 | "three successive levels until a single point" | L1 has 3 points, L2 has 2, L3 has 1 | confirmed |
| A3 | Tracing the point for all t ∈ [0,1] draws the full curve | The trace is sampled on [0,t]; its last sample equals the red point exactly (max diff 0.0 over all 40 frames); the last frame shows the full curve | confirmed |
| A4 | Uses control points of Mathews' Examples 3 and 4, which Example 5 compares; Example 6 rebuilds Example 4 with Bernstein polynomials | gr_82–85: Example 3 is (2,2),(1,1.5),(3.5,0),(4,1). gr_97–100: Example 4 is (2,2),(0,1),(3,-1),(4,1). gr_113: Example 5 overlays both. gr_195–198: Example 6 uses the same points as Example 4 | confirmed |
| A5 | The de Casteljau construction is this page's addition | Mathews plots from the parametric power form (gr_79/80, gr_94) | confirmed |
| C1-1 | Case 1 heading: P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1) | `bezieraa.jl` line 11 | confirmed |
| C1-2 | Leaves P0 heading toward P1 | B'(0)=(-3,-1.5)=3(P1−P0) | confirmed |
| C1-3 | Bends one way without an inflection | x'y''−y'x'' = 243t²/2 − 225t/2 + 99/2 has no real roots (discriminant < 0) and is positive on [0,1] | confirmed |
| C1-4 | Arrives at P3 along the line from P2 | B'(1)=(1.5,3)=3(P3−P2) | confirmed |
| C1-5 | Level-1 orange, level-2 green, curve point red, shown at each t | Plot code lines 58–68; frames 1, 20 and 40 and the contact sheet | confirmed |
| C1-6 | The red point traces the smooth cubic curve from P0 to P3 | Frames | confirmed |
| C1-7 | Alt text: control points as listed; the red point traces the blue curve from P0 to P3 | Script and frames | confirmed |
| C1-8 | Link and embed point to `bezieraa.jl` / `bezieraa.gif`, which is Example 3 | GIF title says "Example 3" and P matches | confirmed |
| C2-1 | Case 2 heading: P0=(2,2), P1=(0,1), P2=(3,-1), P3=(4,1) | `bezierbb.jl` line 10 | confirmed |
| C2-2 | Same endpoints and end-tangent directions as Case 1 | B'(0)=(-6,-3) ∥ (-3,-1.5); B'(1)=(3,6) ∥ (1.5,3) | confirmed |
| C2-3 | Each handle twice as far from its endpoint | P1−P0: (-2,-1) vs (-1,-0.5). P2−P3: (-1,-2) vs (-0.5,-1) | confirmed |
| C2-4 | Stays closer to each end tangent and follows it farther before turning back | Endpoint curvature κ(0) is 0.417 vs 1.312 for Case 1, and κ(1) is 0.477 vs 1.550, so the curve leaves each tangent about 3× more slowly. The frames agree | confirmed |
| C2-5 | Leftmost point x≈1.33 (Case 2) vs x≈1.77 (Case 1) | sympy: x'=0 at t=0.240482, x=1.327230 (Case 2); t=0.163986, x=1.766148 (Case 1). A 200001-point Julia sampling gives the same values | confirmed |
| C2-6 | This is the comparison of Mathews' Example 5 | gr_113 | confirmed |
| C2-7 | Alt text: same endpoints, handles twice as far, reaches left to about x=1.33 | As above | confirmed |
| C2-8 | Link and embed point to `bezierbb.jl` / `bezierbb.gif`, which is Example 4 | GIF title says "Example 4" and P matches | confirmed |

### 3. Implementation checks

### `bezieraa.jl` (Example 3)
- **Method:** standard de Casteljau. Frames use the inline 3-level recursion (lines 34–37); the trace uses the general `decasteljau_point` (lines 16–23). Both are de Casteljau, not a substitute method.
- **Numbers:** `chk2.jl` compares `decasteljau_point` with Mathews' printed polynomial x=2−3t+10.5t²−5.5t³, y=2−1.5t−3t²+3.5t³ on 10001 points. The max difference is 2.7e-15. At t=19/39 (frame 20) the script gives (2.3946121815944297, 0.9619009086464707) and sympy's Bernstein form gives (2.394612181594430, 0.9619009086464708). The intermediate levels at frame 20 are L1 = (1.5128,1.7564), (2.2179,0.7692), (3.7436,0.4872) and L2 = (1.8563,1.2755), (2.9612,0.6318). Each is the stated linear interpolation, and these are the positions in the frame.
- **Reference values:** the script draws no reference curve. The trace is the method's own output, already checked against the closed form.
- **Picture:** frames 1, 20 and 40 and the sheet were inspected. The orange and green segments join the right level points, the trace ends exactly at the red point (max diff 0.0), the title's t matches range(0,1,40) rounded to 2 digits, the legend is correct, and all geometry is inside the axis limits (curve x∈[1.766,4], y∈[0.664,2]).

### `bezierbb.jl` (Example 4)
- **Method:** identical code to bezieraa.jl apart from P and the title.
- **Numbers:** compared with Mathews' x=2−6t+15t²−7t³, y=2−3t−3t²+5t³, the max difference is 2.7e-15. At t=19/39 the script gives (1.8276774726478864, 0.40457526256342813) and sympy gives (1.827677472647887, 0.4045752625634282). In frame 20 the L1, L2 and red positions match the instrumented values (red at about (1.83,0.40)).
- **Reference values:** none drawn.
- **Picture:** frames 1, 20 and 40 and the sheet were inspected. Same checks as above all pass. The curve spans x∈[1.327,4], y∈[0.144,2], and P2=(3,−1) is inside ylims (−1.3,2.3).

### Fidelity
Both cases use exactly Mathews' Example 3 and 4 control points, and the comparison matches his Example 5. The page discloses which examples it does not animate (Examples 1–2 background, Example 7 composite, Examples 8–9 SplineFit) and that the de Casteljau construction is its own addition. No undisclosed departure was found.

