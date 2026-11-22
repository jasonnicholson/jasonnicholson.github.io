# B-Splines — animation review (round 3)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the frames was confirmed against independent computation (details below).

Considered and not raised:
- *Fidelity — departure from Mathews' examples.* Mathews' module uses cubic B-splines for *interpolation* (Example 1: natural cubic spline through the 7 equally spaced points (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1) as a sum of translated B-splines; Example 2: graphs of the translated B-splines, weighted terms and partial sums). The page animates a different subject (a parametric clamped B-spline curve and its basis). This is not silent: index.qmd line 46 states the difference, and I checked that its description of Mathews' Examples 1 and 2 is accurate (lnk_2: "Construct the natural cubic spline for the 7 points ... Solve the system of equations for the coefficients"; lnk_3: "Graphs of the basic functions ... Graphs of the terms ... partial sums"; gr_111 shows equally spaced abscissas 0..6). It gives no *reason* for the departure; I judge a fully disclosed departure not to mislead a reader, so it is not a finding. Owner may decide otherwise.
- *Cosmetic:* in `bsplinebb.gif` the GR backend renders the legend entries literally as "N_1,₄" … and the y-label as "N_{i,4}(t)" (no TeX subscripts); the title shows "N₁,₄ … N_7,₄". Readable and unambiguous; not misleading.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.5 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.8 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description l.12-16 | "B-spline curve of order k (degree k−1) ... C(t)=Σ P_i N_{i,k}(t)" | `bspline_curve_point` (bsplineaa.jl l.24-32) sums `b .* ctrl_pts[i]` over i=1..7 | confirmed |
| D2 | l.18 | "Cubic B-splines have order k=4 ... N_{i,4}" | `k = 4` in both scripts | confirmed |
| D3 | l.20 | basis defined recursively by Cox–de Boor over a knot vector | `bspline_basis` l.11-21 / l.10-20 is Cox–de Boor (with 0/0:=0); output agrees with SciPy BSpline to 1.1e-16 | confirmed |
| D4 | l.20 | local support; smoothness controlled by degree and knot multiplicity | standard; supports computed below (C3) | confirmed |
| D5 | l.22 | clamped knot vector ⇒ curve interpolates first and last control points | script: C(1e-9)=(3.0e-9,6.0e-9), C(4−1e-9)=(5.999999997,4.5e-9); SciPy C(0)=(0,0), C(4)=(6,0) = P1, P7 | confirmed |
| D6 | l.22 | curve remains inside convex hull of control polygon | `indep.py`: 200001 curve samples all inside Delaunay hull of P → `all in hull True` | confirmed |
| I1 | l.26 | two views: curve traced from control points, and basis N_{i,4} whose weighted sum defines the curve | both scripts use identical knots (0,0,0,0,1,2,3,4,4,4,4); frames show these | confirmed |
| I2 | l.28 | Julia sources linked under each case | l.34 → bsplineaa.jl, l.42 → bsplinebb.jl | confirmed |
| C1-h | heading l.30 | "Cubic B-spline curve traced from 7 control points" | `k=4`, 7 `ctrl_pts`; frames show red marker advancing along curve | confirmed |
| C1-a | l.32 | clamped knot vector | instrumented: knots=[0,0,0,0,1,2,3,4,4,4,4] | confirmed |
| C1-b | l.32 | passes through first and last control points | D5 | confirmed |
| C1-c | l.32 | "smoothly pulled toward the interior control points" | curve values e.g. C(1)=(1.9167,0.25), C(2)=(3,1.0833), C(3)=(4.0833,0.4167) lie between polygon vertices; frames 1-31 | confirmed |
| C1-d | l.32 | "C²-continuous everywhere" | `indep.py`: jumps across t=1,2,3 of C, C′, C″ are O(1e-6) (finite-difference noise), C‴ jumps (2,41.5), (0,−24), (−2,31.5) — exactly C² and not C³ at simple interior knots | confirmed |
| C1-e | l.32 | animation traces parameter t from start to end | frame f shows t_vals[round(400f/30)]: frame 0 t=1e-9, frame 15 t=1.995, frame 30 t=4−1e-9; last frame marker at (6,0) | confirmed |
| C1-alt1 | l.36 | "traced from 7 control points by summing Cox–de Boor basis functions" | code l.24-32 | confirmed |
| C1-alt2 | l.36 | "passes through only the first and last control points" | `indep.py` min distance from curve to P1..P7: 0, 0.976, 1.211, 0.912, 0.911, 0.680, 0 | confirmed |
| C1-alt3 | l.36 | "lies within the convex hull of the control polygon" | D6 | confirmed |
| C1-w | l.34/36 | link and embed are Case 1's script/GIF | bsplineaa.jl writes bsplineaa.gif; regenerated byte-identical (manifest) | confirmed |
| C2-h | heading l.38 | basis functions N_{1,4},…,N_{7,4} and partition of unity | 7 frames, m=1..7, `basis[i]` for i=1..7; frame titles N₁,₄ … N_m,₄ | confirmed |
| C2-a | l.40 | each N_{i,4} non-negative | script basis min over grid ≥ 0 for all i (N4 min 1.7e-28); SciPy min 0.0 | confirmed |
| C2-b | l.40 | zero outside [t_i, t_{i+4}], at most 4 knot spans | SciPy supports: N1 [0,1], N2 [0,2], N3 [0,3], N4 [0,4], N5 [1,4], N6 [2,4], N7 [3,4] = [t_i,t_{i+4}] with 1-based knots | confirmed |
| C2-c | l.40 | knot vector (0,0,0,0,1,2,3,4,4,4,4) | bb_instr.jl prints exactly this | confirmed |
| C2-d | l.40 | spans 1,2,3,4,3,2,1; only N_{4,4} covers all 4 | `indep.py` span lists [0],[0,1],[0,1,2],[0,1,2,3],[1,2,3],[2,3],[3] | confirmed |
| C2-e | l.40 | sum equals 1 everywhere in the domain | script grid: max |Σ−1| = 3.3e-16; SciPy on [0,4]: 3.3e-16 | confirmed |
| C2-f | l.40 | partition of unity is why curve lies within convex hull | with non-negativity (stated in same paragraph) this is the standard argument; D6 | confirmed |
| C2-alt1 | l.44 | "Seven ... N_{i,4} revealed one at a time" | 7 frames, one new function per frame | confirmed |
| C2-alt2 | l.44 | "running sum shown in black approaches 1 as all functions are added" | dashed black line; partial sum =1 on [0,0], [0,0.002], [0,0.039], [0,1.04], [0,2.03], [0,3.02], [0,4] for m=1..7; frame 7 flat at 1 | confirmed |
| C2-legend | frames | "sum (= 1 when all added)" | as C2-e | confirmed |
| C2-w | l.42/44 | link and embed are Case 2's script/GIF | bsplinebb.jl writes bsplinebb.gif; byte-identical regen | confirmed |
| L1 | l.46 | description of Mathews' Examples 1 and 2 | archive text lnk_2, lnk_3; gr_111 data points equally spaced | confirmed |

### 3. Implementation checks

### `bsplineaa.jl`
- *Method:* Cox–de Boor recursion (l.11-21) with the convention 0/0 := 0 for repeated knots and half-open indicator [t_i,t_{i+1}) at order 1; curve = Σ P_i N_{i,4}(t). This is a standard clamped (open-uniform) cubic B-spline curve, matching the page. Knots built as zeros(4), 1:3, fill(4,4) → (0,0,0,0,1,2,3,4,4,4,4) (11 = n+k knots). Domain [t_4, t_8] = [0,4]. The half-open convention would make C(4)=0; the script avoids this by sampling to 4−1e-9 (end point drawn at (5.999999997, 4.5e-9)), which is visually exact.
- *Numbers* (script `aa_instr.jl` vs independent SciPy `BSpline(t,P,3)`):

  | t | script | SciPy |
  |---|---|---|
  | 0.5 | (1.177083, 0.968750) | (1.17708333, 0.96875) |
  | 1.0 | (1.916667, 0.250000) | (1.91666667, 0.25) |
  | 1.5 | (2.489583, 0.541667) | (2.48958333, 0.54166667) |
  | 2.0 | (3.000000, 1.083333) | (3.0, 1.08333333) |
  | 2.5 | (3.510417, 0.750000) | (3.51041667, 0.75) |
  | 3.0 | (4.083333, 0.416667) | (4.08333333, 0.41666667) |
  | 3.5 | (4.822917, 0.802083) | (4.82291667, 0.80208333) |
  | end | (5.999999997, 4.5e-9) | (6, 0) at t=4 |

  Drawn-curve extents: script x∈[3e-9, 5.999999997], y∈[4.5e-9, 1.0891832]; SciPy on the same 400-point grid identical to 16 digits.
- *Reference values:* none drawn beyond control points/polygon (verified as plotted from `ctrl_pts`).
- *Picture:* frames 1, 2-11 (contact sheet) and 31 inspected. Frame 1 shows only the polygon, points and red marker at P1 (idx_end=1, no curve yet). Middle frame (frame 16, t≈1.995) marker at ≈(3.0,1.08) as computed. Last frame: full curve, marker at P7. Axis limits x∈[−0.2,6.2], y∈[−1.8,2.5] contain every control point and the whole curve; no clamping or masking. Title "Cubic B-Spline Curve (7 control points)" and legend entries correct. 31 frames at 5 fps.

### `bsplinebb.jl`
- *Method:* same Cox–de Boor routine and knot vector as bsplineaa; plots N_{1..m,4} and their running sum for m=1..7.
- *Numbers:* script basis values on its 500-point grid (dumped to `bb_basis.csv`) vs SciPy basis (`BSpline(t, e_i, 3)`): max abs difference 1.1e-16. Script maxima N1..N7: 0.99999999700, 0.59820790, 0.59648404, 0.66665063, 0.59648404, 0.59820790, 0.99999999700 (SciPy on a 4001-point grid: 1, 0.59824, 0.59649, 0.666667 at t=2, 0.59649, 0.59824, ≈1 at t=4). Symmetric as expected for the symmetric knot vector. Partition of unity: max |Σ−1| = 3.3e-16.
- *Reference values:* the y=1 target of the partition of unity — verified.
- *Picture:* all 7 frames inspected (sheet + frame 7). Frame m adds N_{m,4} in a new colour; dashed black running sum equals 1 on [0, m−3] (m≥4) and is 1 everywhere in frame 7. Axis limits t∈[0,4], y∈[−0.05,1.25] show everything. Title index matches m. Legend subscripts render literally (cosmetic only).

### Regeneration
Per the manifest both scratch copies ran (exit 0) and reproduced the committed GIFs byte-for-byte, so the frames reviewed are the output of the committed scripts.

