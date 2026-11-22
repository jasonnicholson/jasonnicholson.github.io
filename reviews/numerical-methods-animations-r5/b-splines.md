# B-Splines — animation review (round 5)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every computed value I tested agrees with an independent computation (SciPy `BSpline`) to machine precision, and both committed GIFs are byte-identical to fresh scratch regenerations (manifest).

Observations that I judged are *not* findings (recorded so the owner can see they were considered):

- **Plot text rendering (cosmetic).** In `bsplinebb.gif`, the y-axis label is drawn literally as `N_{i,4}(t)`, the legend entries as `N_1,₄`, and the title as `N₁,₄ … N_7,₄` (mixed Unicode subscripts and a literal underscore; `bsplinebb.jl` lines 43, 44, 51). The text is still unambiguous and readable, so this is not misleading.
- **Fidelity to Mathews (disclosed departure).** Mathews' module is about *interpolation*: Example 1 builds the natural cubic spline through the 7 equally spaced points (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1) as a linear combination of translated copies of one cubic B-spline (9 terms, i = −1…7), with coefficients from a linear system (graph `gr_151`); Example 2 graphs those translated basis functions, the weighted terms c_j B_j(x), and the partial sums (loop in `gr_201`, final graph `gr_236`). The page instead animates parametric clamped B-spline curves. This is a substantial departure, but the page's closing paragraph (line 46) states it explicitly and describes the archive examples accurately (checked against the archive text and graphs), and says neither is animated. Because it is not silent, I did not record it as a Fidelity finding. If the owner wants the archive's examples represented, Example 2's partial-sum sequence would map naturally onto an animation; that is a content suggestion, not an error.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.9 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.6 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description l.12 | "A B-spline curve of order k (degree k−1) is expressed as … C(t)=Σ P_i N_{i,k}(t)" | `bsplineaa.jl` l.24–32 computes Σ N_i(t)·P_i; standard definition | confirmed |
| D2 | l.18 | "Cubic B-splines have order k=4, so their basis functions are written N_{i,4}" | `k = 4` in both scripts; SciPy degree 3 gives identical values | confirmed |
| D3 | l.20 | "basis functions are defined recursively by the Cox-de Boor relation over a knot vector" | scripts l.11–21 / l.10–20 implement Cox–de Boor with 0/0→0; max |Julia − SciPy| over all 7 basis functions on 500 points = 1.1e-16 | confirmed |
| D4 | l.20 | local support; smoothness controlled by degree and knot multiplicity | supports measured below (C2.3); derivative jumps at simple interior knots appear only in 3rd derivative (I2) | confirmed |
| D5 | l.22 | "With a clamped knot vector, the curve interpolates the first and last control points while remaining inside the convex hull" | C(0)=(0,0)=P1, C(4)=(6,0)=P7; all 400 curve samples inside Delaunay hull of P (0 outside) | confirmed |
| A1 | Intro l.26 | two views: curve traced from control points, and basis functions N_{i,4}(t) "whose weighted sum defines the curve" | both scripts use the same knot vector (0,0,0,0,1,2,3,4,4,4,4) and k=4, so Case 2's functions are exactly Case 1's weights | confirmed |
| A2 | l.28 | Julia scripts linked under each case | l.34 → `bsplineaa.jl`, l.42 → `bsplinebb.jl`; both exist | confirmed |
| C1.1 | Heading l.30 | "Cubic B-spline curve traced from 7 control points" | `ctrl_pts` has 7 entries, k=4; frames trace the curve | confirmed |
| C1.2 | l.32 | "clamped knot vector" | `t_knots` = [0,0,0,0,1,2,3,4,4,4,4] (printed) | confirmed |
| C1.3 | l.32 | "passes through the first and last control points" | first sample (3e-9, 6e-9) ≈ P1=(0,0); last (5.999999997, 4.5e-9) ≈ P7=(6,0); SciPy C(0)=(0,0), C(4)=(6,0); final frame red marker at (6,0) | confirmed |
| C1.4 | l.32 | "smoothly pulled toward the interior control points" | curve bends toward each interior point (frames 1–31); y range [0, 1.089] | confirmed |
| C1.5 | l.32 | "The curve is C²-continuous everywhere" | SciPy jumps at knots 1,2,3: 1st derivative ≤1.5e-8, 2nd ≤1.6e-8 (finite-difference noise of ±1e-9 probes), 3rd = (2, 41.5), (0, −24), (−2, 31.5); pieces are cubic polynomials between knots | confirmed |
| C1.6 | l.32 | "traces the curve parameter t from start to end" | 31 frames, idx = round(frame/30·400), t uniformly from 1e-9 to 4−1e-9; frame 1 = t≈0 (marker only), frame 31 = t≈4 | confirmed |
| C1.7 | Alt l.36 | "traced from 7 control points by summing Cox–de Boor basis functions" | `bspline_curve_point` | confirmed |
| C1.8 | Alt l.36 | "passes through only the first and last control points" | min distance from the 400 curve samples to P2…P6 = 0.976, 1.211, 0.912, 0.911, 0.680 | confirmed |
| C1.9 | Alt l.36 | "lies within the convex hull of the control polygon" | 0 of 400 samples outside hull (`indep.py`) | confirmed |
| C2.1 | Heading l.38 | "Basis functions N_{1,4},…,N_{7,4} and the partition of unity" | 7 basis functions drawn; final frame shows all 7 and sum ≡ 1 | confirmed |
| C2.2 | l.40 | each N_{i,4} "is non-negative" | min over grid of each = 0.0 (SciPy) | confirmed |
| C2.3 | l.40 | "zero outside [t_i, t_{i+4}], which is at most 4 knot spans" | measured supports (1-indexed knots): N1 [0,1], N2 [0,2], N3 [0,3], N4 [0,4], N5 [1,4], N6 [2,4], N7 [3,4] = [t_i, t_{i+4}] in each case | confirmed |
| C2.4 | l.40 | knot vector "(0,0,0,0,1,2,3,4,4,4,4)" | printed `t_knots` | confirmed |
| C2.5 | l.40 | non-zero spans "1, 2, 3, 4, 3, 2 and 1"; "only N_{4,4} covers all 4" | from C2.3 | confirmed |
| C2.6 | l.40 | "Their sum equals 1 everywhere in the domain (partition of unity)" | max |Σ N_i − 1| = 3.3e-16 (Julia, 500 pts) and 3.3e-16 (SciPy, 4000 pts) | confirmed |
| C2.7 | l.40 | "which is why the B-spline curve lies within the convex hull" | partition of unity + non-negativity (both stated in the paragraph) make C(t) a convex combination | confirmed |
| C2.8 | Alt l.44 | "Seven … basis functions … revealed one at a time" | 7 frames, frame m draws N_1…N_m (`for m in 1:n_ctrl`) | confirmed |
| C2.9 | Alt l.44 | "running sum shown in black approaches 1 as all functions are added" | dashed black line; partial sum of first m equals 1 on [0, m−3] for m ≥ 4 (SciPy) and on all of [0,4] at m = 7; frames match | confirmed |
| C2.10 | Frame legend | "sum (= 1 when all added)" | C2.6 | confirmed |
| C2.11 | Frame title | "N₁,₄ … N_m,₄" | frame m title shows m = 1…7 in order | confirmed |
| W1 | Wiring | Case 1 link/embed → `bsplineaa.jl` / `bsplineaa.gif`; Case 2 → `bsplinebb.jl` / `bsplinebb.gif` | `gif(...)` targets in each script; regenerated GIFs byte-identical to committed ones (manifest) | confirmed |
| L1 | l.46 | Mathews' Example 1 "builds the natural cubic spline through equally spaced data points as a weighted sum of translated copies of one cubic B-spline, with the weights found by solving a linear system" | archive `lnk_2` text and graph `gr_151` (7 points at x = 0…6, natural end conditions, 9-term sum) | confirmed |
| L2 | l.46 | Example 2 "graphs those translated B-splines, the weighted terms and their partial sums" | archive `lnk_3` text ("Graphs of the basic functions…", "Graphs of the terms…", "partial sums"), `gr_201`, `gr_236` | confirmed |
| L3 | l.46 | "neither example is animated here" | page's two cases are parametric-curve examples | confirmed |

### 3. Implementation checks

### `bsplineaa.jl`

- **Method.** Cubic (order 4) parametric B-spline curve, C(t) = Σ_{i=1}^{7} N_{i,4}(t) P_i, with Cox–de Boor recursion (right-open indicator at k = 1, zero-denominator terms dropped). Clamped knot vector with 3 uniform interior knots. This is exactly what the page names.
- **Numbers.** Instrumented copy (`review/aa_inst.jl`) vs SciPy `BSpline(t, P, 3)` (`review/indep.py`):

  | t | script C(t) | SciPy C(t) |
  |---|---|---|
  | 0.5 | (1.177083333, 0.968750000) | (1.17708333, 0.96875) |
  | 1.0 | (1.916666667, 0.250000000) | (1.91666667, 0.25) |
  | 1.5 | (2.489583333, 0.541666667) | (2.48958333, 0.54166667) |
  | 2.0 | (3.000000000, 1.083333333) | (3.0, 1.08333333) |
  | 2.5 | (3.510416667, 0.750000000) | (3.51041667, 0.75) |
  | 3.0 | (4.083333333, 0.416666667) | (4.08333333, 0.41666667) |
  | 3.5 | (4.822916667, 0.802083333) | (4.82291667, 0.80208333) |
  | ends | (3e-9, 6e-9) / (5.999999997, 4.5e-9) | (0,0) / (6,0) |

  Curve y range [4.5e-9, 1.0892] in both. Partition of unity in the script's own basis: max deviation 2.2e-16.
- **Reference values.** None (no "exact" comparator). Endpoint interpolation and convex-hull property verified as above.
- **Picture.** Frames 1, 4, 8, 12, 16, 20, 24, 28, 31 (contact sheet) and frame 31 viewed. Control polygon (grey dashed) and control points (black) are `ctrl_pts`; blue curve is `curve[1:idx_end]`; red marker is `curve[idx_end]`, starting at P1 and ending on P7. Axis limits x ∈ [−0.2, 6.2], y ∈ [−1.8, 2.5] contain all control points and the whole curve; no clamping or masking. Title "Cubic B-Spline Curve (7 control points)" correct.

### `bsplinebb.jl`

- **Method.** Same Cox–de Boor routine and the same knot vector (0,0,0,0,1,2,3,4,4,4,4), k = 4; evaluates N_{1,4}…N_{7,4} on 500 points in (0, 4) and adds them one per frame with a running sum.
- **Numbers.** All 7×500 basis values written by `review/bb_inst.jl` to `bb_basis.txt` and compared with SciPy (`review/cmp_bb.py`): max abs difference 1.1e-16. Peak values (SciPy): N1 = 1 at t = 0, N2 0.598, N3 0.596, N4 0.6667 at t = 2, N5 0.596, N6 0.598, N7 → 1 at t = 4; matches the frames. Sum of all 7: max deviation 3.3e-16.
- **Reference values.** The "= 1" line is the exact partition-of-unity value; verified above.
- **Picture.** All 7 frames viewed (contact sheet) plus frame 7 at full size. Frame m shows N_1…N_m in distinct colours with matching legend entries, and the dashed black running sum, which is 1 on [0, m−3] for m ≥ 4 and then decays to 0 at t = 4 until m = 7, when it is flat at 1. x-limits [0, 4] are exactly the parameter domain; y-limits [−0.05, 1.25] contain everything. The evaluation grid avoids t = 4 by 1e-9, so the right-open Cox–de Boor convention does not drop N7 at the endpoint (N7 → 0.99999999 there in the plot, as drawn). Only cosmetic issue: subscripts in axis label/legend/title render with literal underscores and braces (see Findings, not counted).

