# B-Splines — animation review (round 8)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Considered and judged not a finding:
- *Fidelity (archive departure).* Mathews' module is about cubic-spline *interpolation* with a uniform cubic B-spline (Example 1: natural cubic spline through 7 equally spaced points, coefficients from a linear system; Example 2: graphs of the translated basic functions, the weighted terms and partial sums). The page instead animates clamped parametric B-spline curves and their basis. This is not silent: line 46 of `index.qmd` states the departure and describes the Mathews examples accurately (checked against lnk_2 and lnk_3 text: "Construct the natural cubic spline for the 7 points", "Solve the system of equations for the coefficients", "Graphs of the basic functions ... Graphs of the terms ... Graphs of the sum ... partial sums"; main module: "you must have a uniform grid of points"). A reader is not misled.
- *Cosmetic.* GR renders `N_$i,₄` and `N_{i,4}(t)` with literal underscores/braces ("N_7,₄", "N_{i,4}(t)"), and the m=1 title reads "N₁,₄ … N_1,₄". Readable and not misleading; not a finding under the standard.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.5 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.5 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Desc. l.12 | "order k (degree k−1) ... C(t)=Σ P_i N_{i,k}(t)" | `bspline_curve_point` sums `b .* ctrl_pts[i]`, k=4 ↔ cubic; scipy `BSpline(t,P,3)` matches script curve to 8.9e-16 | confirmed |
| 2 | Desc. l.18 | "Cubic B-splines have order k=4 ... N_{i,4}" | script `k = 4` | confirmed |
| 3 | Desc. l.20 | basis defined by Cox–de Boor recursion over a knot vector | `bspline_basis` is the standard order-k recursion with 0/0:=0; matches scipy `basis_element` to 1.1e-16 | confirmed |
| 4 | Desc. l.20 | local support; smoothness controlled by degree and knot multiplicity | standard; supports confirmed numerically (row 15) | confirmed |
| 5 | Desc. l.22 | clamped knots → curve interpolates first and last control points | scipy C(0)=(0,0)=P1, C(4)=(6,0)=P7; script first/last sample (3e-9,6e-9), (6.0,4.5e-9) | confirmed |
| 6 | Desc. l.22 | curve remains inside convex hull of control polygon | 4001 points of C(t) tested with `Delaunay(P).find_simplex` → all inside | confirmed |
| 7 | Intro l.26 | two views: curve traced from control points, and basis functions N_{i,4} whose weighted sum defines the curve | both scripts use identical knot vector (0,0,0,0,1,2,3,4,4,4,4) and k=4 (printed) | confirmed |
| 8 | Intro l.28 | Julia sources linked under each case | links `bsplineaa.jl`, `bsplinebb.jl` | confirmed |
| 9 | Case 1 heading | cubic B-spline curve traced from 7 control points | `ctrl_pts` has 7 entries, k=4; frames show 7 black points | confirmed |
| 10 | Case 1 l.32 | clamped knot vector; passes through first and last control points | rows 5, 7; last frame red dot at (6,0) | confirmed |
| 11 | Case 1 l.32 | "smoothly pulled toward the interior control points" | frames: curve bends toward each interior point; min distances to P2..P6 = 0.976, 1.211, 0.912, 0.911, 0.680 | confirmed |
| 12 | Case 1 l.32 | "C^2-continuous everywhere" | scipy derivative jumps at knots 1,2,3: orders 0–2 ≤ 1.6e-11; 3rd-derivative jumps (−2,−41.5), (0,24), (2,−31.5) → exactly C² | confirmed |
| 13 | Case 1 l.32 | animation traces t from start to end | `idx_end` = 1,13,27,...,400 over 31 frames; t grid 0+1e-9 .. 4−1e-9; frames 1→31 show red dot moving (0,0)→(6,0) | confirmed |
| 14 | Case 1 alt | "by summing Cox–de Boor basis functions; passes through only the first and last control points; lies within convex hull" | rows 3, 6, 11 (no interior point closer than 0.68) | confirmed |
| 15 | Case 2 l.40 | each N_{i,4} non-negative, zero outside [t_i, t_{i+4}], ≤ 4 spans | script basis min ≥ 0; numerical supports N1 [0,1], N2 [0,2], N3 [0,3], N4 [0,4], N5 [1,4], N6 [2,4], N7 [3,4] | confirmed |
| 16 | Case 2 l.40 | knot vector (0,0,0,0,1,2,3,4,4,4,4) | printed `t_knots` from both scripts | confirmed |
| 17 | Case 2 l.40 | spans 1,2,3,4,3,2,1; only N_{4,4} covers all 4 | row 15 | confirmed |
| 18 | Case 2 l.40 | sum equals 1 everywhere in the domain | script sum over 500 points ∈ [1−3e-16, 1+2e-16]; frame 7 dashed line flat at 1 | confirmed |
| 19 | Case 2 l.40 | partition of unity is why curve lies in convex hull | together with non-negativity (stated in the same paragraph) this is the standard argument | confirmed |
| 20 | Case 2 heading | basis functions N_{1,4}..N_{7,4} | 7 functions, `n_ctrl = 7` | confirmed |
| 21 | Case 2 alt | seven functions revealed one at a time; running sum in black approaches 1 as all are added | 7 frames, frame m plots N_1..N_m plus black dashed cumulative sum; sum reaches 1 on whole [0,4] at frame 7 | confirmed |
| 22 | Wiring | Case 1 → bsplineaa.jl/gif, Case 2 → bsplinebb.jl/gif | link/embed paths; manifest: regenerated GIFs byte-identical to committed | confirmed |
| 23 | l.46 | Mathews Example 1 builds natural cubic spline through equally spaced data as weighted sum of translated copies of one cubic B-spline, weights from a linear system; Example 2 graphs translated B-splines, weighted terms, partial sums; neither animated here | archive text lnk_2, lnk_3, main module (see Findings) | confirmed |
| 24 | l.46 | on this page weights are the given control points, no linear system solved | neither script solves a system | confirmed |

### 3. Implementation checks

### `bsplineaa.jl`
- **Method:** Cox–de Boor recursion (order k, half-open indicator at k=1, zero-denominator terms dropped) and curve = Σ P_i N_{i,4}(t). This is a clamped cubic B-spline curve, as named.
- **Numbers:** instrumented copy (`review/aa_inst.jl`) dumped all 400 curve samples; independent `scipy.interpolate.BSpline(t, P, 3)` max |diff| = 8.9e-16. Spot values, script vs scipy: C(0.5) = (1.177083, 0.968750) both; C(1) = (1.916667, 0.250000) both; C(2) = (3.000000, 1.083333) both; C(3) = (4.083333, 0.416667) both; C(3.5) = (4.822917, 0.802083) both.
- **Reference values:** none drawn. One edge note: the script's routine returns (0,0) at exactly t=4 because of the half-open k=1 indicator, but the script samples only up to 4−1e-9, so the drawn curve ends correctly at (6,0).
- **Picture:** frames 1, 2–30 (sheet), 31 examined. Control polygon and points match `ctrl_pts`; blue curve matches the computed values (e.g. peak ≈1.08 near x=3, trough ≈0.2 near x=2); red marker is at `cx[idx_end]`, ending at (6,0). Axis limits (−0.2..6.2, −1.8..2.5) contain everything. Frame 1 shows only the start marker (idx_end=1), as expected.

### `bsplinebb.jl`
- **Method:** same Cox–de Boor routine and same knot vector; plots N_{1,4}..N_{m,4} and their running sum for m = 1..7.
- **Numbers:** instrumented copy (`review/bb_inst.jl`) dumped all 7×500 basis values; scipy `BSpline.basis_element(t[i:i+5])` max |diff| = 1.1e-16. Peaks: N1 1.0 at t=0, N2 0.598 at 0.457, N3 0.596 at 1.106, N4 0.667 at 2.0, N5 0.596 at 2.894, N6 0.598 at 3.543, N7 1.0 at t=4 (symmetric, as expected; N4 peak 2/3 is the uniform cubic B-spline value).
- **Reference values:** the "= 1" reference is the partition-of-unity sum; verified to 3.3e-16.
- **Picture:** all 7 frames examined. Each frame adds one coloured basis function in the correct position; the dashed black running sum equals 1 on [0, m−3] and decays after, reaching a flat 1 at frame 7. Legend and title index m match the frame. Subscript rendering is literal (cosmetic, see above).

