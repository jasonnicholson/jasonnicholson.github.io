# Bézier Curves — animation review (round 5)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every claim on the page, and both implementations and both GIFs, against computations of my own. All of them held up. The evidence is in parts 2 and 3.

These are not findings, but I noted them:
- The plots do not use an equal aspect ratio. With x in [-0.3, 4.3] and y in [-1.3, 2.3] in a roughly square plot area, y is stretched about 1.35x compared with x. A Bézier curve is affine-invariant, so the curve still runs tangent to the control legs and the de Casteljau points still sit on their segments. No conclusion on the page changes.
- In the t = 0 and t = 1 frames, the level-1 and level-2 markers fall on top of P1/P2 and P0/P3, hiding the black control-point markers. That is what happens mathematically at those values of t, so it is expected.
- The Case 1 alt text says "level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve". Grammatically this suggests all three points trace the curve. It is only wording, and the Behavior paragraph says it correctly.
- The Description spells it "Bezier" and the title spells it "Bézier". This is cosmetic.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 8.8 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| D1 | Description | $B(t)=\sum_{i=0}^{n}\binom{n}{i}(1-t)^{n-i}t^iP_i$, $t\in[0,1]$ | Confirmed | Standard Bernstein form. sympy expansion of this form for Ex3/Ex4 equals Mathews' power-form R[t] exactly (`indep.py`: "matches Mathews formula: True True"), and the scripts' de Casteljau output equals it to 4.4e-16 |
| D2 | Description | "The curve starts at $P_0$, ends at $P_n$" | Confirmed | B(0)=(2,2), B(1)=(4,1) for both cases (`indep.py`) |
| D3 | Description | "stays inside the convex hull of its control polygon" | Confirmed | 200001 samples of each curve all lie in the hull (Delaunay test, `indep.py`: True, True) |
| D4 | Description | de Casteljau is "a numerically stable way to evaluate points … repeatedly performs linear interpolation between adjacent points until one point remains" | Confirmed | That is what the code does (`decasteljau_point`). Stability test with degree 40 and random coefficients, against a 60-digit reference: de Casteljau max error 1.0e-15, power basis by Horner 1.1e+02 (`stab.py`) |
| A1 | Animations intro | "Each animation below demonstrates the de Casteljau algorithm for constructing a cubic Bézier curve" | Confirmed | Both scripts build L1 (3 pts), L2 (2 pts), L3 (1 pt) by repeated lerp. Four control points, so cubic |
| A2 | Intro | "recursively linearly interpolates between adjacent control points through three successive levels until a single point on the curve is reached" | Confirmed | Three levels L1, L2, L3. L3 equals the Bernstein value at all 40 frames (max diff 4.4e-16) |
| A3 | Intro | "Tracing this point for all $t\in[0,1]$ draws the full curve" | Confirmed | The last frame (t = 1.0) shows the full curve from P0 to P3. The trace's last sample equals the red point exactly in every frame |
| A4 | Intro | Julia scripts linked under each case | Confirmed | `bezieraa.jl` under Case 1, `bezierbb.jl` under Case 2 |
| A5 | Intro (archive) | "No archived animation GIF is available for this topic" | Confirmed | `grep -ril bezier a2001/Animations/` finds nothing, and the Interpolation folder has no Bézier entry |
| A6 | Intro (archive) | uses "the control points of Examples 3 and 4 of Mathews' Bézier Curve module" | Confirmed | nb: Ex3 {2,2},{1,1.5},{3.5,0},{4,1}; Ex4 {2,2},{0,1},{3,-1},{4,1}. These match the scripts' `P` |
| A7 | Intro (archive) | "which he plots from their parametric formulas and compares in Example 5" | Confirmed | Solutions 3/4 substitute into R[t] and ParametricPlot it (gr1/gr2). Solution 5 is `Show[cont, gr1, gr2, …]` |
| A8 | Intro (archive) | "Example 6 rebuilds the Example 4 curve from Bernstein polynomials" | Confirmed | nb Example 6 uses the points {2,2},{0,1},{3,-1},{4,1} with "Use Bernstein polynomials" |
| A9 | Intro (archive) | Examples 1–2: "a cubic polynomial through four points and a clamped cubic Hermite polynomial" | Confirmed | nb Ex1: p through (1,2),(3/2,31/16),(5/2,11/16),(3,1). Ex2: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2, "clamped cubic" |
| A10 | Intro (archive) | "Example 7, a composite curve joined from four Bézier pieces" | Confirmed | nb Ex7: V has 4 rows of 8 numbers, "Construct the four Bézier pieces" |
| A11 | Intro (archive) | "Examples 8–9, on Mathematica's SplineFit package" | Confirmed | Mod.html: Ex8 "SplineFit" procedure, Ex9 "nature of the spline fit" |
| C1-1 | Case 1 heading | "Mathews' Example 3, $P_0=(2,2)$, $P_1=(1,1.5)$, $P_2=(3.5,0)$, $P_3=(4,1)$" | Confirmed | `bezieraa.jl` line 11; GIF title "Example 3" |
| C1-2 | Case 1 Behavior | "leaves $P_0$ heading toward the handle $P_1$" | Confirmed | B'(0)=(-3,-1.5)=3(P1-P0) |
| C1-3 | Case 1 Behavior | "bends one way without an inflection" | Confirmed | Curvature numerator x'y''-y'x'' = 9(27t²-25t+11)/2. Discriminant 625-1188 < 0, so it has no real root and stays positive on [0,1] |
| C1-4 | Case 1 Behavior | "arrives at $P_3$ along the line from $P_2$" | Confirmed | B'(1)=(1.5,3)=3(P3-P2) |
| C1-5 | Case 1 Behavior | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each t" | Confirmed | Code lines 56-68. Frames 1, 10, 40 and the contact sheet show orange, green and red markers in the right places |
| C1-6 | Case 1 Behavior | "the red point traces the smooth cubic Bézier curve from $P_0$ to $P_3$" | Confirmed | Red is at (2,2) at t=0 and (4,1) at t=1. The blue trace ends at the red point in every frame |
| C1-7 | Case 1 link/embed | `bezieraa.jl` / `bezieraa.gif` is the Example 3 case | Confirmed | Script `P` matches. GIF titles read "Example 3". Committed GIF is byte-identical to the regenerated one |
| C1-8 | Case 1 alt text | control points (2,2),(1,1.5),(3.5,0),(4,1); orange/green/red, smooth blue curve from P0 to P3 | Confirmed | as C1-1, C1-5, C1-6. The wording is loose (see notes above) |
| C2-1 | Case 2 heading | "Mathews' Example 4, handles twice as far out, $P_0=(2,2)$, $P_1=(0,1)$, $P_2=(3,-1)$, $P_3=(4,1)$" | Confirmed | `bezierbb.jl` line 10. P1-P0 = (-2,-1) = 2·(-1,-0.5) and P2-P3 = (-1,-2) = 2·(-0.5,-1) |
| C2-2 | Case 2 Behavior | "endpoints and end-tangent directions are those of Case 1" | Confirmed | Same P0, P3. B'(0)=(-6,-3) ∥ (-3,-1.5). B'(1)=(3,6) ∥ (1.5,3) |
| C2-3 | Case 2 Behavior | "each handle sits twice as far from its endpoint" | Confirmed | as C2-1 |
| C2-4 | Case 2 Behavior | "The de Casteljau construction proceeds identically" | Confirmed | Same level code (lines 31-34). Only `P` differs |
| C2-5 | Case 2 Behavior | "The curve stays closer to each end tangent" | Confirmed | End curvature: Case 2 has 0.417 at P0 and 0.477 at P3, Case 1 has 1.312 and 1.550. Perpendicular distance from the P0 tangent line at the same distance along it: s=0.1: 0.0022 vs 0.0075; s=0.2: 0.0091 vs 0.0357; s=0.3: 0.0216 vs 0.1043. At P3: 0.0024/0.0100/0.0232 vs 0.0082/0.0346/0.0833 (`tangent.py`) |
| C2-6 | Case 2 Behavior | "and follows it farther before turning back" | Confirmed | Greatest progress along the P0 tangent direction: 1.0435 (Case 2) vs 0.3879 (Case 1). Along the P3 tangent: 1.514 vs 0.757 |
| C2-7 | Case 2 Behavior | "its leftmost point is at $x\approx 1.33$ instead of $x\approx 1.77$ in Case 1" | Confirmed | x'(t)=0 at t=0.240482, x=1.327230 (Case 2), and at t=0.163986, x=1.766148 (Case 1). sympy and the script's own sampled min x agree (1.3272297, 1.7661478) |
| C2-8 | Case 2 Behavior | "This is the comparison Mathews makes in his Example 5" | Confirmed | as A7 |
| C2-9 | Case 2 link/embed | `bezierbb.jl` / `bezierbb.gif` is the Example 4 case | Confirmed | Script `P` matches. GIF title "Example 4". Byte-identical to the regenerated GIF |
| C2-10 | Case 2 alt text | "(2,2),(0,1),(3,-1),(4,1) … same endpoints as Case 1 with handles twice as far out … reaches left to about x = 1.33" | Confirmed | as C2-1, C2-7. Frame 40 shows the curve's leftmost point just left of x=1.4 |

### 3. Implementation checks

### `bezieraa.jl` (Case 1, Mathews Example 3)

- **It is the method it claims to be.** The de Casteljau algorithm for a cubic: three levels of pairwise lerp `(1-t)·a + t·b` (lines 35-37), and the same recursion in `decasteljau_point` (lines 16-23) for the traced curve. It does not fall back to evaluating the Bernstein formula.
- **The numbers are right.** Instrumented copy `review/bezieraa_instr.jl` (plotting removed, prints the levels and compares with an independent Bernstein sum):
  - frame 10, t=0.2308: L3 = (1.7992717341829767, 1.5370960400546196); Bernstein (1.7992717341829765, 1.5370960400546196)
  - frame 21, t=0.5128: L3 = (2.481127463375984, 0.9138387363239435); Bernstein identical
  - all 40 frames: max |de Casteljau − Bernstein| and trace-end mismatch = 4.4e-16
  - spot check of the lerp levels at t=0.2308: L1[1] = P0 + t(P1−P0) = (2−0.2308, 2−0.1154) = (1.7692, 1.8846), which matches the printed value.
  - Independent sympy: x(t) = −11t³/2 + 21t²/2 − 3t + 2, y(t) = 7t³/2 − 3t² − 3t/2 + 2. B(0.5) = (39/16, 15/16) = (2.4375, 0.9375). Mathews' R[t] gives exactly the same polynomial.
- **Its reference values are right.** The script draws no separate reference curve. The blue curve is the same de Casteljau evaluation, checked above against Bernstein to machine precision.
- **The picture shows what was computed.** Frames 1, 10 and 40 and the contact sheet (frames at t = 0, 0.1, …, 0.92) show orange segments joining the 3 level-1 points, each lying on a control-polygon leg, and a green segment joining the 2 level-2 points, each on an orange segment. The red point sits on the green segment at the end of the blue trace. Title t is `round(t,2)` of the actual t (40 frames, t = k/39). The legend entries match the colours. Axes [-0.3,4.3]×[-1.3,2.3] contain the whole curve (x∈[1.766,4], y∈[0.664,2]) and all control points. There is no clamping or masking.

### `bezierbb.jl` (Case 2, Mathews Example 4)

- **Method.** Identical code to `bezieraa.jl`. Only the control points and title differ.
- **Numbers.** Instrumented copy `review/bezierbb_instr.jl`:
  - frame 10, t=0.2308: L3 = (1.3281747837960851, 1.2093764223941734); Bernstein (1.3281747837960853, 1.2093764223941736)
  - frame 20, t=0.4872: L3 = (1.8276774726478864, 0.40457526256342813); Bernstein (1.8276774726478866, 0.404575262563428)
  - all 40 frames: max mismatch 4.4e-16
  - Independent sympy: x(t) = −7t³ + 15t² − 6t + 2, y(t) = 5t³ − 3t² − 3t + 2 (matches Mathews' R[t]). B(0.5) = (15/8, 3/8). Min x = 1.327230 at t=0.240482. Min y = 0.144245.
- **Reference values.** None separate. The blue curve is the same de Casteljau evaluation (verified).
- **Picture.** Frames 20 and 40 and the contact sheet show the same geometry as Case 1, built correctly (for example at t=0.49 the level-1 points (1.03,1.51), (1.46,0.03), (3.49,−0.03) sit on the three legs). The whole curve (x∈[1.327,4], y∈[0.144,2]) and P2=(3,−1) are inside the axes. The title reads "Example 4" with the correct t.

### Archive fidelity

Both cases use Mathews' Examples 3 and 4 exactly, and the page compares them as his Example 5 does. The examples it leaves out (1-2, 6, 7, 8-9) are listed and described correctly in the intro. Mathews has no animation for this topic, and the page openly presents the de Casteljau construction as its own addition. I found no fidelity issue.

