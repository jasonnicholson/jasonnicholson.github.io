# B-Splines — animation review (round 4)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

These were examined and are not findings:
- **Literal underscores in plot text (cosmetic).** GR renders the labels in `bsplinebb.gif` with literal underscores: legend `N_1,₄`, y-label `N_{i,4}(t)`, and a frame-1 title that reads "N₁,₄ … N_1,₄". The text stays readable and unambiguous, so it does not mislead.
- **Departure from Mathews (disclosed).** Mathews' module covers cubic B-spline *interpolation*: a natural cubic spline through 7 equally spaced points, built from translated copies of one B-spline. The page instead animates clamped parametric B-spline curves. The page's last paragraph says this explicitly and says neither archive example is animated. I checked that paragraph against the archive and it is accurate (see ledger L19). Because the departure is disclosed, it is not a silent drop and does not mislead a reader.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.9 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.1 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bsplineaa.gif` | 31 | byte-identical | bsplineaa |
| `bsplinebb.gif` | 7 | byte-identical | bsplinebb |

### Page references

- Scripts linked: `bsplineaa.jl`, `bsplinebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| L1 | Description | "A B-spline curve of order $k$ (degree $k-1$) … $C(t)=\sum_i P_i N_{i,k}(t)$" | `bspline_curve_point` computes exactly $\sum_i N_{i,k}(t)P_i$ (aa.jl:24-32) | confirmed |
| L2 | Description | "Cubic B-splines have order $k=4$" | `k = 4` in both scripts. Third-derivative jumps at the knots (41.5, 24, 31.5) show that the pieces are cubic. | confirmed |
| L3 | Description | Basis "defined recursively by the Cox-de Boor relation over a knot vector" | aa.jl:11-21 and bb.jl:10-20 are standard Cox–de Boor with the 0/0 = 0 convention. The scipy basis agrees to 1.1e-16. | confirmed |
| L4 | Description | Local support; smoothness controlled by degree and knot multiplicity | General property. L13 confirms the support intervals and L8 confirms C² at the simple knots. | confirmed |
| L5 | Description | "With a clamped knot vector, the curve interpolates the first and last control points while remaining inside the convex hull" | Curve endpoints are (3e-9, 6e-9) and (6.0, 4.5e-9), i.e. P1 and P7 up to the ±1e-9 parameter offset. All 200001 dense curve points pass the Delaunay hull test. | confirmed |
| L6 | Animations intro | Two views: the curve traced from control points, and the basis functions $N_{i,4}$ whose weighted sum defines the curve | Two scripts and two GIFs, as described | confirmed |
| L7 | Case 1 heading | "Cubic B-spline curve traced from 7 control points" | `ctrl_pts` has 7 entries and k=4 | confirmed |
| L8 | Case 1 Behavior | Clamped knot vector; passes through first and last control points; "smoothly pulled toward the interior control points"; "$C^2$-continuous everywhere" | Knots are [0,0,0,0,1,2,3,4,4,4,4]. Endpoint interpolation is as in L5. Jumps in value, first and second derivative at t=1, 2, 3 are ≤1.6e-6 with ±1e-7 probes (consistent with zero); the third-derivative jump is nonzero. So the curve is exactly C². | confirmed |
| L9 | Case 1 Behavior | "traces the curve parameter $t$ from start to end" | Frames 0–30 move the marker through t = 1e-9 … 3.999999999 (instrumented printout). The frames show the curve growing from P1 to P7. | confirmed |
| L10 | Case 1 alt | "traced … by summing Cox–de Boor basis functions" | As in L1 and L3. Curve agrees with scipy to 8.9e-16. | confirmed |
| L11 | Case 1 alt | "passes through only the first and last control points" | Minimum distance from the curve to P2…P6 is 0.976, 1.211, 0.912, 0.911, 0.680 | confirmed |
| L12 | Case 1 alt | "lies within the convex hull of the control polygon" | Hull test passes (L5). Curve y-range is [0, 1.089] and x-range is [0, 6]. | confirmed |
| L13 | Case 2 heading and Behavior | $N_{1,4}..N_{7,4}$ are non-negative, zero outside $[t_i,t_{i+4}]$, at most 4 spans; with knots (0,0,0,0,1,2,3,4,4,4,4) the supports are 1,2,3,4,3,2,1 spans and only $N_{4,4}$ covers all 4 | Minimum basis value is 0.0. Numerical supports are N1 [0,1], N2 [0,2], N3 [0,3], N4 [0,4], N5 [1,4], N6 [2,4], N7 [3,4]. These match $[t_i,t_{i+4}]$ with 1-indexed knots. | confirmed |
| L14 | Case 2 Behavior | "Their sum equals 1 everywhere in the domain (partition of unity)" | Sum over all 500 samples lies in [0.99999999999999970, 1.0000000000000002] | confirmed |
| L15 | Case 2 Behavior | Partition of unity plus non-negativity is why the curve lies in the convex hull | Standard argument. L12 holds numerically. | confirmed |
| L16 | Case 2 alt | "Seven … basis functions revealed one at a time" | 7 frames (`for m in 1:n_ctrl`). The frames add one curve each. | confirmed |
| L17 | Case 2 alt | "running sum shown in black approaches 1 as all functions are added" | Dashed black sum. It equals 1 only at t=0 for m≤3, then on [0, m−3] for m=4…7, reaching all of [0,4] at m=7 (computed). Frames 4 and 7 show this. | confirmed |
| L18 | Wiring | Case 1 links and embeds `bsplineaa.jl` / `bsplineaa.gif`; Case 2 links and embeds `bsplinebb.jl` / `bsplinebb.gif` | index.qmd:34,36,42,44. Each regenerated GIF is byte-identical to the committed one (manifest). | confirmed |
| L19 | Final paragraph | Mathews' Example 1 builds the natural cubic spline through equally spaced data points as a weighted sum of translated copies of one cubic B-spline, with weights from a linear system. Example 2 graphs the translated B-splines, the weighted terms and their partial sums. Neither is animated. | lnk_2: "Construct the natural cubic spline for the 7 points"; the data in gr_111 are (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1), equally spaced; "Solve the system of equations for the coefficients"; 9 terms i=−1..7. lnk_3: "Graphs of the basic functions", "Graphs of the terms", "partial sums". No animation exists in the archive or on the page. | confirmed |

### 3. Implementation checks

### `bsplineaa.jl` (Case 1: curve tracing)
- **Method.** This is a genuine B-spline curve evaluated as $\sum N_{i,4}(t)P_i$ with Cox–de Boor recursion (lines 11-32). It is not a Bézier curve and not an interpolating spline. The knot vector built at lines 49-52 is `[0,0,0,0,1,2,3,4,4,4,4]`, which is clamped and uniform, and the parameter range is [0,4].
- **Numbers.** I compared all 400 curve samples from the instrumented copy against scipy `BSpline(knots, P, 3)`; the maximum absolute difference is **8.9e-16**. The half-open indicator at k=1 would give 0 at t=4. The sampling range `t_max − 1e-9` (line 57) avoids that, so the last point is (5.999999997, 4.5e-9) ≈ P7.
- **Reference values.** None (no "exact" comparison curve).
- **Picture.** I viewed the contact sheet (frames 1, 4, 7, …, 31) and frame 31 at full size.
  - Frame 1: the red marker is at P1 and no curve is drawn yet (idx_end=1).
  - Middle frames: the marker sits at the printed curve points, e.g. frame 15 at (2.995, 1.082).
  - Frame 31: the full curve ends at P7.
  - The axes (−0.2..6.2, −1.8..2.5) contain every control point (y from −1 to 2) and the whole curve (y from 0 to 1.089).
  - The control polygon, the control points and the legend are labelled correctly.

### `bsplinebb.jl` (Case 2: basis functions)
- **Method.** It uses the same Cox–de Boor routine and the same knot vector (lines 22-30). It plots each $N_{i,4}$ cumulatively along with the running sum.
- **Numbers.** I compared all 7×500 basis values against scipy unit-coefficient `BSpline`s; the maximum absolute difference is **1.1e-16**.
  - Partition of unity: the sum stays within 1 ± 3e-16.
  - Non-negativity: the minimum is 0.
  - Peak values are N1 = N7 = 1, N2 = N6 = 0.598, N3 = N5 = 0.597 and N4 = 2/3 (0.6667, the expected value at t=2). The values are symmetric as expected.
  - The supports match $[t_i,t_{i+4}]$.
- **Reference values.** None (the "= 1" line is the computed sum, not a reference).
- **Picture.** I viewed frames 1, 4 and 7. The colours match the legend. The dashed black running sum behaves as computed: at m=4 it equals 1 on [0,1] and then decays; at m=7 it is flat at 1. The y-axis range −0.05..1.25 shows everything. The labels contain literal underscores, which is cosmetic (see Findings).

### Legacy archive
I consulted the archive and recorded what I found in Findings and ledger L19.

