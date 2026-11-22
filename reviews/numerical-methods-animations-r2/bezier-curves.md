# Bézier Curves — animation review (round 2)

Page: `pages/numerical-methods/bezier-curves/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: neither case comes from Mathews, and his worked examples are dropped without a note

- **Location:** `index.qmd` lines 26 and 34 (the case headings: Case 1 `P_0=(0,0), P_1=(1,2), P_2=(3,2), P_3=(4,0)`; Case 2 `P_0=(0,0), P_1=(0,2), P_2=(4,0), P_3=(4,2)`), together with line 8 "Source inspiration: [@mathewsSite]".
- **What is there now:** two invented control polygons: a symmetric arch and an S-curve.
- **What the archive has:** the Mathews module (`n2003/BezierCurveMod.html`; parameters in `n2003/bezier/BezierCurveMod.nb`, lines 2681–2880 and 3336–3350) works these Bézier examples:
  - Example 3: start `(2,2)`, end `(4,1)`, handles `(1,1.5)` and `(3.5,0)`.
  - Example 4 (and Example 6, which uses Bernstein form): the same endpoints with handles `(0,1)` and `(3,-1)`.
  - Example 5 compares Examples 3 and 4 to show the "More background" point, that a handle placed farther out makes the curve follow the end tangent longer.
  - Example 7 builds a composite four-piece Bézier curve from the table `V`.

  The page uses none of these and gives no reason. In particular it drops the one behavioural lesson the module teaches through its examples: same endpoints, different handles (Examples 3–5).
- **How I know:** `sed 's/<[^>]*>//g' n2003/BezierCurveMod.html` lists Examples 3–9. `sed -n 2675,2880p` and `sed -n 3330,3370p` of `BezierCurveMod.nb` give the coordinates above. `find .../a2001/Animations -iname '*bez*'` returns nothing, so the archive has no animation to follow.
- **Why only Minor:** both invented cases are mathematically correct, and the page's own claims about them hold (see the ledger). The de Casteljau animation is a valid way to show the curve even though Mathews uses the power-basis and Bernstein forms. The departure costs the reader the archive's examples, not correctness.
- **Suggested correction:** do one of these:
  - Replace or extend the cases with Mathews' Example 3 (`(2,2),(1,1.5),(3.5,0),(4,1)`) and Example 4 (`(2,2),(0,1),(3,-1),(4,1)`). Shown together they reproduce his Example 5 comparison of handle placement.
  - Or keep the current cases and add one sentence saying they are illustrative and are not Mathews' examples.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bezieraa.jl` | 0 | 7.9 | bezieraa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bezierbb.jl` | 0 | 7.9 | bezierbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description, l.12–16 | Degree-n Bézier curve `B(t)=Σ C(n,i)(1-t)^{n-i} t^i P_i`, `t∈[0,1]` | Standard definition. The scripts' de Casteljau point equals this sum at every frame to 4.4e-16 (check.py, `|L3-B(t)|`) | confirmed |
| 2 | Description, l.18 | "The curve starts at P_0, ends at P_n" | sympy: Case 1 B(0)=(0,0), B(1)=(4,0); Case 2 B(0)=(0,0), B(1)=(4,2). Frames 1 and 40 put the red point on P0 and P3 | confirmed |
| 3 | Description, l.18 | "stays inside the convex hull of its control polygon" | 2001 sampled curve points per case all lie inside the Delaunay hull of the control points (check.py: `True` for both) | confirmed |
| 4 | Description, l.18 | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains"; numerically stable | Code `decasteljau_point` (aa l.16–23, bb l.11–18) and the in-loop L1/L2/L3 do exactly this. Stability is the standard result (only convex combinations for t∈[0,1]) | confirmed |
| 5 | Animations intro, l.22 | Each animation demonstrates de Casteljau for a **cubic** Bézier | Both scripts have 4 control points, so degree 3; levels L1 (3 pts), L2 (2), L3 (1) | confirmed |
| 6 | Animations intro, l.22 | "recursively linearly interpolates between adjacent control points through three successive levels until a single point" | L1, L2, L3 at aa l.35–37, bb l.31–33. Instrumented values match independent degree-1/2/3 Bernstein evaluations of the sub-polygons (max error 0, 8.9e-16, 4.4e-16) | confirmed |
| 7 | Animations intro, l.22 | "Tracing this point for all t∈[0,1] draws the full curve" | The frames run t=0…1 in 40 uniform steps (step 1/39). The blue trace is B(s) for s∈[0,t] and its last point equals the red point exactly (`|trace_end-red|=0`). Frame 40 shows the full curve | confirmed |
| 8 | Intro, l.24 | Julia sources linked under each case | l.30 → `bezieraa.jl`, l.38 → `bezierbb.jl`; both files exist | confirmed |
| 9 | Case 1 heading, l.26 | Arch-shaped cubic, P0=(0,0), P1=(1,2), P2=(3,2), P3=(4,0) | `bezieraa.jl` l.11 is identical. Curve x=3t+3t²−2t³, y=6t−6t² rises to max (2,1.5) at t=½ and returns to y=0; curvature numerator −72(t²−t+1) never vanishes, so it is a single arch | confirmed |
| 10 | Case 1 behaviour, l.28 | "The four control points define an arch" | as #9 | confirmed |
| 11 | Case 1 behaviour, l.28 | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each t" | aa l.60 orange `level 1`, l.65 green `level 2`, l.68 red `point on curve`. All visible in every frame inspected (contact sheet, frame 40) | confirmed |
| 12 | Case 1 behaviour, l.28 | "As t goes from 0 to 1, the red point traces the smooth cubic Bézier curve from P0 to P3" | See #2 and #7. Red at (0,0) in frame 1, (4,0) in frame 40 | confirmed |
| 13 | Case 1 alt text, l.32 | level-1 orange, level-2 green, red point traces the smooth **blue** curve from P0 to P3 | The trace uses `color=:steelblue` (aa l.50), shown blue in the frames | confirmed |
| 14 | Case 1 embed, l.32 | GIF is Case 1 | `bezieraa.gif` is produced by `bezieraa.jl` (byte-identical regen) with Case 1 points; the frame title reads "Bézier Curve — de Casteljau" | confirmed |
| 15 | Case 2 heading, l.34 | S-shaped cubic, P0=(0,0), P1=(0,2), P2=(4,0), P3=(4,2) | `bezierbb.jl` l.9 is identical. Curve x=12t²−8t³, y=6t−12t²+8t³ with vertical tangents at both ends (B′(0)=B′(1)=(0,6)) and a single curvature sign change, which is a sideways S (frame 40) | confirmed |
| 16 | Case 2 behaviour, l.36 | "The de Casteljau construction proceeds identically" | `diff bezieraa.jl bezierbb.jl`: only comments, P, axis limits and title differ | confirmed |
| 17 | Case 2 behaviour, l.36 | "the resulting curve has an inflection point" | Curvature numerator x′y″−y′x″ = 144(2t−1), a simple zero at t=½, so a genuine inflection at B(½)=(2,1) | confirmed |
| 18 | Case 2 behaviour, l.36 | the arrangement produces a "qualitatively different shape" from Case 1 | Case 1 has no inflection (#9); Case 2 has one (#17) | confirmed |
| 19 | Case 2 alt text, l.40 | control points (0,0),(0,2),(4,0),(4,2) produce a smooth S "inflecting near the center" | The inflection is at (2,1), exactly the centre of the control-point box [0,4]×[0,2]; points match l.9 | confirmed |
| 20 | Case 2 embed/link, l.38–40 | Link and GIF are Case 2 | `bezierbb.jl` and `bezierbb.gif` (byte-identical regen); the title reads "Bézier Curve (S-shape)" | confirmed |
| 21 | Frames (prominent content) | The title shows the current t | The title uses `round(t, digits=2)` of the same t that drives L1–L3. The contact-sheet titles 0.0, 0.1, 0.21, …, 0.92 and frame 40's 1.0 are consistent with t=k/39 | confirmed |
| 22 | Frames (prominent content) | Legend: "control polygon" (dashed grey), "control points P₀–P₃" (black) | aa l.53–54, bb l.48–49. Subscripts render correctly in frame 40 of both GIFs | confirmed |

I found no counts (frames, steps) stated on the page that needed checking. Each GIF has 40 frames at 8 fps.

---

### 3. Implementation checks

Both scripts share the same algorithm and differ only in P, axis limits and title (`diff`). I instrumented copies with a `println` after the red-point scatter that prints t, L1, L2, L3, the trace length and the trace's end and start points. The GIF output was redirected to the scratch folder. Commands:

```
julia bezieraa_instr.jl > aa.out; julia bezierbb_instr.jl > bb.out     # both exit 0
cmp bezieraa_instr.gif <repo>/bezieraa.gif   -> identical
cmp bezierbb_instr.gif <repo>/bezierbb.gif   -> identical
/usr/bin/python3 check.py
```

`check.py` evaluates, independently of the Julia code:
- every level-j point as the degree-j Bernstein sum over the consecutive sub-polygon `P[i:i+j+1]`. This is a property check: the i-th level-j de Casteljau point equals the Bézier curve of that sub-polygon, so it does not rely on the script's recursion.
- the curve symbolically with sympy (coordinates, end tangents, the curvature numerator and its real roots in [0,1]).
- containment of a dense sample of the curve in the convex hull of the control points.

### `bezieraa.jl` (Case 1, arch)

1. **The method it claims to be:** yes. Classic de Casteljau: repeated convex combinations `(1-t)·p_i + t·p_{i+1}` of adjacent points, 3 → 2 → 1 (l.35–37). The same recursion in `decasteljau_point` (l.16–23) draws the trace. This is the standard algorithm, not a variant.
2. **The numbers:** over all 40 frames, the script's values against independent Bernstein evaluation give:
   - max |L1 − indep| = 0
   - max |L2 − indep| = 8.9e-16
   - max |L3 − B(t)| = 4.4e-16

   For example, at t=1/39 the script gives L3=(0.0788617475, 0.1499013807), and B(t) with x=3t+3t²−2t³, y=6t−6t² gives the same.
3. **Reference values:** none are used. The blue curve comes from the same algorithm sampled at `round(Int,1+299t)` points on [0,t]. Its last sample is exactly the red point (|difference| = 0 every frame) and its first sample is P0.
4. **The picture:**
   - The orange polyline joins the three L1 points and the green segment joins the two L2 points; the red marker is L3, the dashed grey line the control polygon and the black markers the control points.
   - Frames 1, the sheet's middle frames and frame 40 are consistent with the computed values. At t=0, L1 = P0..P2 and L2 = P0,P1, so they sit on the control points; frame 40 mirrors this at the other end.
   - The axes (−0.2…4.2, −0.4…2.5) contain every point. Nothing is clamped or masked.

### `bezierbb.jl` (Case 2, S-curve)

1. **The method:** identical code to Case 1 (l.11–18, 31–33). De Casteljau, as claimed.
2. **The numbers:** over 40 frames:
   - max |L1 − indep| = 0
   - max |L2 − indep| = 4.4e-16
   - max |L3 − B(t)| = 4.4e-16

   The independent curve is x=12t²−8t³, y=6t−12t²+8t³.
3. **Reference values:** none. Trace end equals the red point exactly in every frame.
4. **The picture:**
   - The geometry is built as in Case 1.
   - Frame 40 shows a sideways S with vertical end tangents (B′(0)=B′(1)=(0,6)) and a flat inflection at (2,1), where B′(½)=(6,0). The middle frames (t≈0.51) show the red point at about (2,1) with the green segment horizontal, which matches.
   - The axes (−0.3…4.3, −0.3…2.3) contain all points.

### Things I could not determine

None. I accepted the general statement that de Casteljau is numerically stable as a standard result rather than testing it. These cases are low-degree with exactly representable inputs, so a stability test would not discriminate.

