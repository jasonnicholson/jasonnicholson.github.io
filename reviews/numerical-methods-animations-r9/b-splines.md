# B-Splines — animation review (round 9)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Count: Error 0, Misleading 0, Minor 0.

These observations are not findings under the review standard (cosmetic and still readable):
- In `bsplinebb.gif` the y-axis label `"N_{i,4}(t)"` (bsplinebb.jl:43) shows its braces literally as `N_{i,4}(t)`. The title (line 44) mixes Unicode subscripts with a literal underscore, giving `N₁,₄ … N_7,₄`, and frame 1 reads `N₁,₄ … N_1,₄`. Legend entries read `N_1,₄`. The text is still readable and correct in meaning.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 13.9 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 10.6 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description l.12 | B-spline curve of order k (degree k−1) is C(t)=Σ P_i N_{i,k}(t) | bsplineaa.jl:24-32 computes exactly Σ P_i N_{i,4}(t); k=4 | confirmed |
| D2 | l.18 | Cubic B-splines have order k=4 | both scripts use `k = 4` with cubic pieces (3rd derivative jumps at knots, see I-a) | confirmed |
| D3 | l.20 | Basis defined recursively by Cox–de Boor over a knot vector | bspline_basis (both scripts, l.11-21 / l.10-20) is the Cox–de Boor recursion with 0/0:=0; values match scipy BSpline to 1.1e-16 | confirmed |
| D4 | l.20 | local support; smoothness controlled by degree and knot multiplicity | general property; support verified per function (C5) | confirmed |
| D5 | l.22 | Clamped knot vector: curve interpolates first and last control points | C(0)=(0,0)=P1, C(4)=(6,0)=P7 (scipy) | confirmed |
| D6 | l.22 | Curve remains inside the convex hull of the control polygon | 200001 curve samples all inside Delaunay hull of P (scipy) | confirmed |
| I1 | l.26 | Two views: curve traced from control points, and the basis functions whose weighted sum defines the curve | GIF1 traces the curve, GIF2 shows N_{1..7,4} on the same knot vector | confirmed |
| I2 | l.28 | Julia source scripts linked under each case | l.34 → bsplineaa.jl, l.42 → bsplinebb.jl; both exist and generate the embedded GIFs byte-identically (manifest) | confirmed |
| C1 | Case 1 heading | Cubic curve traced from 7 control points | `ctrl_pts` has 7 points, k=4; title "Cubic B-Spline Curve (7 control points)" | confirmed |
| C2 | Case 1 Behavior | Clamped knot vector | knots printed by instrumented copy: [0,0,0,0,1,2,3,4,4,4,4] | confirmed |
| C3 | Case 1 Behavior | passes through first and last control points | see D5; frame 1 marker at (0,0), frame 31 marker at (6,0) | confirmed |
| C4 | Case 1 Behavior | smoothly pulled toward interior control points | curve bends toward each interior point; minimum distances 0.98, 1.21, 0.91, 0.91, 0.68 (P2..P6) | confirmed |
| C5 | Case 1 Behavior | curve is C²-continuous everywhere | jumps at knots t=1,2,3 in C, C′, C″ are ≤1.6e-11; C‴ jumps (−2,−41.5), (0,24), (2,−31.5), so exactly C² | confirmed |
| C6 | Case 1 Behavior | animation traces t from start to end | 31 frames; frame f shows samples 1..round(400f/30), t = 0, 0.120, …, 3.870, 4.0 (instrumented copy) | confirmed |
| C7 | Case 1 alt | traced by summing Cox–de Boor basis functions | bspline_curve_point sums b·P_i | confirmed |
| C8 | Case 1 alt | passes through only the first and last control points | min distance from curve to P2..P6 is 0.976, 1.211, 0.912, 0.911, 0.680 (> 0) | confirmed |
| C9 | Case 1 alt | lies within the convex hull of the control polygon | see D6 | confirmed |
| C10 | Case 1 wiring | link/embed are bsplineaa.jl / bsplineaa.gif | index.qmd l.34, l.36 | confirmed |
| K1 | Case 2 heading | basis functions N_{1,4},…,N_{7,4} | `for i in 1:n_ctrl`, n_ctrl=7; 7 frames, m=1..7 | confirmed |
| K2 | Case 2 Behavior | each N_{i,4} is non-negative | min over 500-point grid is 0; all values in [0,1] | confirmed |
| K3 | Case 2 Behavior | zero outside [t_i, t_{i+4}], at most 4 knot spans | sympy Cox–de Boor piecewise: non-zero spans listed below | confirmed |
| K4 | Case 2 Behavior | knot vector (0,0,0,0,1,2,3,4,4,4,4) | instrumented copy prints exactly this | confirmed |
| K5 | Case 2 Behavior | N_{1..7,4} have 1,2,3,4,3,2,1 non-zero spans; only N_{4,4} covers all 4 | sympy: N1 [0,1]; N2 [0,2]; N3 [0,3]; N4 [0,4]; N5 [1,4]; N6 [2,4]; N7 [3,4] | confirmed |
| K6 | Case 2 Behavior | sum = 1 everywhere in the domain (partition of unity) | sympy: the symbolic sum on each span [0,1],[1,2],[2,3],[3,4] simplifies to 1; script's grid sum lies in [1−3e-16, 1+2e-16] | confirmed |
| K7 | Case 2 Behavior | which is why the curve lies in the convex hull | non-negativity + partition of unity give convex combinations; also checked numerically (D6) | confirmed |
| K8 | Case 2 alt | seven functions revealed one at a time | frames 1–7 add N_1..N_7 (frames 1, 3, 7 viewed) | confirmed |
| K9 | Case 2 alt | running sum shown in black approaches 1 as all are added | black dashed running sum; frame 3 partial sum <1 for t>~0.3, frame 7 flat at 1.0 | confirmed |
| K10 | Case 2 wiring | link/embed are bsplinebb.jl / bsplinebb.gif | index.qmd l.42, l.44 | confirmed |
| L1 | l.46 | Mathews' Example 1 builds the natural cubic spline through equally spaced data points as a weighted sum of translated copies of one cubic B-spline, with the weights found by solving a linear system | archive B-SplinesMod.html and lnk_2: "Construct the natural cubic spline for the 7 points", uniform grid, "Solve the system of equations for the coefficients", 9 terms | confirmed |
| L2 | l.46 | Example 2 graphs those translated B-splines, the weighted terms and their partial sums | lnk_3: "Graphs of the basic functions…", "Graphs of the terms…", "…finds the partial sums" | confirmed |
| L3 | l.46 | neither example is animated here; on this page no linear system is solved | true of both scripts | confirmed |

Fidelity note: the page does not reproduce Mathews' two examples, which are uniform-knot interpolating natural splines. Instead it uses clamped-knot control-point curves. It states this departure explicitly and accurately (L1–L3), so I do not count it as a silent drop. a2001 has no B-spline animation to compare against.

### 3. Implementation checks

### bsplineaa.jl
- **Method:** Cox–de Boor recursion with half-open degree-0 indicator and 0/0:=0 convention; curve = Σ P_i N_{i,4}(t). This is a clamped uniform cubic B-spline curve, as the page says.
- **Numbers:** I instrumented a copy (`review/bsplineaa_inst.jl`) to dump all 400 curve samples. Independently, scipy `BSpline(T, P, 3)` gives max |difference| = **8.9e-16**. The knot vector prints as [0,0,0,0,1,2,3,4,4,4,4], with t_min=0 and t_max=4. The ±1e-9 grid offsets avoid the half-open right-end zero; C(4−1e-9) ≈ (6,0).
- **Reference values:** none (no exact comparison curve).
- **Picture:** the gray dashed polygon and black markers are the 7 control points. The blue curve is cx/cy up to idx_end, with a red marker at the current sample. Frame 1 shows only the marker at P1; frame 31 shows the full curve ending at P7. The limits x∈[−0.2,6.2], y∈[−1.8,2.5] contain all control points and the curve (y range of curve ≈ [0, 1.09]). Nothing is clamped or masked. Title and legend are correct.

### bsplinebb.jl
- **Method:** the same Cox–de Boor routine on the same knot vector; it plots N_{i,4}, i=1..m, plus the running sum.
- **Numbers:** instrumented copy (`review/bsplinebb_inst.jl`) dumps the 500×7 basis table. scipy per-basis BSpline gives max |difference| = **1.1e-16**. The peaks are below, script grid value against the scipy continuous optimum:
  - N1: 1.000 at 0, and 1 at 0
  - N2: 0.59821 at 0.4569, and 0.59824 at 0.4531
  - N3: 0.59648 at 1.106, and 0.59649 at 1.108
  - N4: 0.66665 at 1.996, and 2/3 at 2
  - N5 and N6 mirror N3 and N2
  - N7: 1 at 4

  The grid sum lies in [0.9999999999999997, 1.0000000000000002].
- **Reference values:** partition of unity checked symbolically (sympy) on every span.
- **Picture:** 7 frames, one function added per frame, dashed black running sum. The axes t∈[0,4], y∈[−0.05,1.25] show everything. Colors and legend entries match the indices. The only issue is the cosmetic label typesetting noted above.

### Commands
- `julia review/bsplineaa_inst.jl`, `julia review/bsplinebb_inst.jl`: truncated copies, with the animation removed, that dump the computed values.
- `/usr/bin/python3 -I review/check.py`: scipy curve, endpoint and hull checks, derivative jumps at knots, sympy supports and partition of unity.
- `/usr/bin/python3 -I review/cmp.py`: element-wise comparison of the script output with scipy, and the basis maxima.

