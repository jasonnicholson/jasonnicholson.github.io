# Bézier Curves — animation review (round 7)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Case 1 alt text says the level-1 and level-2 points trace the curve

- **Kind:** Page match
- **Severity:** Minor
- **Location:** `index.qmd` line 35, image alt text: "level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve from P0 to P3"
- **What is there now:** The grammatical subject of "trace" is all three point sets.
- **What is true instead:** Only the red point traces the curve. The level-1 and level-2 points are intermediate construction points and generally lie off it. The Case 1 Behavior paragraph (line 31) states this correctly: "the red point traces the smooth cubic Bézier curve". The alt text is what a screen-reader user gets in place of the animation.
- **Evidence:** `/usr/bin/python3 review/check_alt.py review`, using the script's own logged points for interior frames 2-39, measured against a 400,001-point sampling of the curve:

  | Point set | Points | Min distance | Median distance | Max distance |
  |---|---:|---:|---:|---:|
  | Level 1 | 114 | 0.0006 | 0.3042 | 0.7549 |
  | Level 2 | 76 | 0.0006 | 0.0911 | 0.6743 |
  | Red | 38 | 0.0000 | 0.0000 | 0.0000 |

  At frame 20 (t = 0.4872) the three level-1 points are 0.257, 0.256 and 0.236 from the curve, and the two level-2 points are 0.094 and 0.088 from it.
- **Suggested correction:** "De Casteljau construction for the cubic Bezier curve of Mathews' Example 3, control points (2,2),(1,1.5),(3.5,0),(4,1): level-1 orange and level-2 green points locate the red point, which traces the smooth blue curve from P0 to P3".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 13.2 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 9.5 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **confirmed**, **wrong**, **could not determine**. Each was checked against the script parameters, an independent computation, the frames, or the archive source as named.

### Description (lines 12-18)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i$, $t\in[0,1]$ is the Bézier curve of degree $n$ | confirmed | Expanded symbolically for both cases; identical to Mathews' power-basis `R[t]` from the notebook (difference expands to 0 in x and y) and to his Example 6 Bernstein form |
| 2 | "The curve starts at $P_0$" | confirmed | B(0) = (2,2) exactly, both cases |
| 3 | "ends at $P_n$" | confirmed | B(1) = (4,1) exactly, both cases |
| 4 | "stays inside the convex hull of its control polygon" | confirmed | 2,000,001 samples per case; maximum signed distance outside the hull is 0 |
| 5 | de Casteljau is "a numerically stable way to evaluate points" | confirmed | Each step is a convex combination for t in [0,1]; scripts agree with the closed form to at most 8.9e-16 |
| 6 | It "repeatedly performs linear interpolation between adjacent points until one point remains" | confirmed | `decasteljau_point`, lines 16-23 (aa) and 12-19 (bb) |

### Animations introduction (lines 22-27)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 7 | Each animation demonstrates de Casteljau for a cubic Bézier curve | confirmed | Four control points; levels L1, L2, L3 computed in both scripts |
| 8 | Interpolates "through three successive levels until a single point on the curve is reached" | confirmed | 3, 2, then 1 points; L3 equals the Bernstein value to at most 4.4e-16 in all 80 frames |
| 9 | "Tracing this point for all $t\in[0,1]$ draws the full curve" | confirmed | Frame 40 of each GIF shows the complete curve; final trace has 300 samples ending at (4,1) |
| 10 | Julia source scripts are linked under each case | confirmed | Lines 33 and 41 |
| 11 | "No archived animation GIF is available for this topic" | confirmed | All 221 Bézier archive GIFs parsed block by block: maximum 1 frame. No Bézier file or text under `a2001` |
| 12 | Animations use the control points of Mathews' Examples 3 and 4 | confirmed | Notebook lines 2681-2695 and 2785-2800 |
| 13 | Mathews "plots [them] from their parametric formulas" | confirmed | Both solutions substitute into `R[t]` and use `ParametricPlot` |
| 14 | He "compares [them] in Example 5" | confirmed | Notebook line 2866 onward; `gr_113.gif` overlays both curves |
| 15 | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | confirmed | Same four points, formula is a Bernstein sum (notebook line 3336 onward) |
| 16 | The de Casteljau construction "is this page's addition" | confirmed | "Casteljau" does not occur in the module notebook |
| 17 | Examples 1-2 build "a cubic polynomial through four points and a clamped cubic Hermite polynomial as background" | confirmed | `lnk_2`, `lnk_3` |
| 18 | Example 7 is "a composite curve joined from four Bézier pieces" | confirmed | Four rows in `V`, consecutive pieces share endpoints (-4,2.5), (0,4), (5,2) |
| 19 | Examples 8-9 are "on Mathematica's SplineFit package" | confirmed | `lnk_10`, `lnk_11` |
| 20 | Those examples "are not animated here" | confirmed | Only two scripts and two GIFs exist |

### Case 1 (lines 29-35)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 21 | Heading: Mathews' Example 3 | confirmed | Notebook; GIF title reads "Example 3" |
| 22 | $P_0=(2,2)$, $P_1=(1,1.5)$, $P_2=(3.5,0)$, $P_3=(4,1)$ | confirmed | Script line 11 and notebook agree |
| 23 | "leaves $P_0$ heading toward the handle $P_1$" | confirmed | B'(0) = (-3,-3/2) = 3(P1-P0) |
| 24 | "bends one way without an inflection" | confirmed | B'×B'' = 9(27t²-25t+11)/2, complex roots, range [23.46, 58.50] on [0,1], no sign change |
| 25 | "arrives at $P_3$ along the line from $P_2$" | confirmed | B'(1) = (3/2,3) = 3(P3-P2) |
| 26 | Level-1 orange, level-2 green, curve point red, "shown at each $t$" | confirmed | Code colours; pixel check found L1 120/120, L2 80/80 at computed positions; red marker within 0.16 px of B(t) in all 40 frames |
| 27 | "the red point traces the smooth cubic Bézier curve from $P_0$ to $P_3$" | confirmed | Red starts at (2,2), ends at (4,1); min \|B'\| = 2.168, so the curve is regular |
| 28 | Source link is `bezieraa.jl` | confirmed | Line 33; the script holds the Case 1 points |
| 29 | Embed is `bezieraa.gif` | confirmed | Line 35; byte-identical to scratch regeneration |
| 30 | Alt text: control points (2,2),(1,1.5),(3.5,0),(4,1) and Example 3 | confirmed | As #21-22 |
| 31 | Alt text: "level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve" | **wrong** (F1) | Only the red point traces the curve |

### Case 2 (lines 37-43)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 32 | Heading: Mathews' Example 4 | confirmed | Notebook; GIF title reads "Example 4" |
| 33 | $P_0=(2,2)$, $P_1=(0,1)$, $P_2=(3,-1)$, $P_3=(4,1)$ | confirmed | Script line 10 and notebook agree |
| 34 | "handles twice as far out"; "each handle sits twice as far from its endpoint" | confirmed | Length ratios 2.000000 and 2.000000 |
| 35 | "endpoints and end-tangent directions are those of Case 1" | confirmed | P0 and P3 equal; handle vectors have zero cross product and positive dot product (2.5) with Case 1's |
| 36 | "The de Casteljau construction proceeds identically" | confirmed | Diff of the scripts: only control points, title, output name, and line wrapping differ |
| 37 | "stays closer to each end tangent" | confirmed, in the near-endpoint sense | At equal arc length from the endpoint, Case 2 is closer for s < 2.860 of 3.195 (P0 end) and s < 3.180 of 3.195 (P3 end). At s = 0.5: 0.0657 vs 0.2571 (P0), 0.0667 vs 0.2016 (P3). Over the whole curve Case 2's largest distance from the tangent is greater (2.123 vs 1.905 at P0; 2.537 vs 2.337 at P3). This matches Mathews' wording "near that endpoint" |
| 38 | "follows it farther before turning back" | confirmed | Furthest progress along the end tangent: 1.0435 vs 0.3879 (P0), 1.5140 vs 0.7570 (P3) |
| 39 | Leftmost point "$x\approx 1.33$" | confirmed | x = 1.327230 at t = 0.240482 (t = 5/7 - √11/7); brute force agrees |
| 40 | "instead of $x\approx 1.77$ in Case 1" | confirmed | x = 1.766148 at t = 0.163986 (t = 7/11 - 3√3/11); brute force agrees |
| 41 | "This is the comparison Mathews makes in his Example 5" | confirmed | Example 5 overlays these two curves; the "More background" note before Example 4 states the tangent effect |
| 42 | Source link is `bezierbb.jl` | confirmed | Line 41; the script holds the Case 2 points |
| 43 | Embed is `bezierbb.gif` | confirmed | Line 43; byte-identical to scratch regeneration |
| 44 | Alt text: control points, Example 4, same endpoints, handles twice as far out | confirmed | As #32-35 |
| 45 | Alt text: "follows each end tangent farther and reaches left to about x = 1.33" | confirmed | As #38-39 |

### Fidelity to the archive

No fidelity finding. Both cases use Mathews' points exactly. Every other example (1, 2, 5, 6, 7, 8, 9) is named on the page with how it relates to the animations, so none is silently dropped. The archive's Example 5 graph shows the same two curves, with leftmost extents consistent with 1.77 and 1.33.

---

### 3. Implementation checks

Instrumented copies log L1, L2, L3, the trace endpoints and the trace length for every frame. With the logging added, they still reproduce both committed GIFs byte for byte.

### `bezieraa.jl` (Case 1)

**It is the method it claims to be.** True de Casteljau: L1, L2, L3 by repeated `(1-t)·a + t·b`, and the same recurrence in `decasteljau_point` for the trace.

**The numbers are right.** Script values compared against independently written closed forms: $L^1_i=(1-t)P_i+tP_{i+1}$, $L^2_i=(1-t)^2P_i+2t(1-t)P_{i+1}+t^2P_{i+2}$, and the Bernstein cubic for $L^3$.

| Quantity (40 frames) | Max \|script - closed form\| |
|---|---:|
| L1 | 0 |
| L2 | 8.88e-16 |
| L3 | 4.44e-16 |
| Trace start vs P0, trace end vs red point | 0 |

Property checks: the 4th finite difference of the curve is at most 1.67e-15 and the 3rd is 0.096, so it is exactly degree 3. Endpoints and end derivatives match the theory exactly. Closed form: $x(t)=-\tfrac{11}{2}t^3+\tfrac{21}{2}t^2-3t+2$, $y(t)=\tfrac72t^3-3t^2-\tfrac32t+2$.

**Reference values.** The script has no separate "exact" curve. The blue trace is computed by de Casteljau and is checked here against Bernstein and Mathews' `R[t]`.

**The picture shows what was computed.** Across all 40 committed frames:

- Red marker centroid vs B(t): max residual 0.16 px, rms 0.05 px, under one affine data-to-pixel map
- Level-1 markers 120/120, level-2 markers 80/80, control points 160/160 at computed positions (allowing for correct overdraw)
- Every blue pixel within 1.73 px of the computed B([0,t]), about the half-width of the 3 px line; 100% of curve samples covered, so nothing is drawn beyond the current t
- Trace sample count equals max(2, round(1+299t)) in every frame, as the script comment says
- 40 distinct frames, t = 0 to 1 in steps of 1/39; title t is correctly rounded
- Axis limits (-0.3, 4.3) × (-1.3, 2.3) contain the whole figure; nothing is clamped or masked

Frames 20 and 40 were viewed directly, and the contact sheet (which includes frame 1 and ten evenly spaced frames in all) was viewed too.

### `bezierbb.jl` (Case 2)

**It is the method it claims to be.** Same algorithm; the scripts differ only in control points, title, output name and line wrapping.

**The numbers are right.**

| Quantity (40 frames) | Max \|script - closed form\| |
|---|---:|
| L1 | 0 |
| L2 | 4.44e-16 |
| L3 | 4.44e-16 |
| Trace start vs P0, trace end vs red point | 0 |

Property checks: the 4th finite difference is at most 2.22e-15 and the 3rd is 0.122. Closed form: $x(t)=-7t^3+15t^2-6t+2$, $y(t)=5t^3-3t^2-3t+2$. B'×B'' = 18(18t²-17t+7) has no real roots and lies in [53.75, 144] on [0,1], so Case 2 also has no inflection. Min |B'| = 3.566.

**Reference values.** None separate from the trace; verified as for Case 1.

**The picture shows what was computed.** Across all 40 committed frames:

- Red marker centroid vs B(t): max residual 0.15 px, rms 0.05 px
- Level-1 markers 120/120, level-2 markers 80/80, control points 160/160
- Every blue pixel within 2.46 px of the computed B([0,t]); 100% of curve samples covered
- Trace sample count law holds; 40 distinct frames
- The same axis limits contain the whole figure, including P2 at y = -1; nothing is clamped or masked

Frames 20 and 40 were viewed directly, and the contact sheet (which includes frame 1 and ten evenly spaced frames in all) was viewed too.

### Could not determine

Nothing on this page was left undetermined.

