# B-Splines — animation review

Page: [`pages/numerical-methods/b-splines/index.qmd`](../../pages/numerical-methods/b-splines/index.qmd) · Scripts: `bsplineaa.jl`, `bsplinebb.jl` · GIFs: 2

**Result:** 0 error, 2 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — "local support over exactly 4 knot spans" is false for the clamped basis the animation shows

- **Location:** index.qmd:38, "Each cubic B-spline basis function $N_{i,4}(t)$ is non-negative and has local support over exactly 4 knot spans."
- **Now:** The sentence says every one of the 7 basis functions is supported on exactly 4 knot spans.
- **True:** The knot vector in bsplinebb.jl (lines 26-28) is clamped: `[0,0,0,0,1,2,3,4,4,4,4]`. $N_{i,4}$ is supported on $[t_i, t_{i+4}]$, which is 4 knot *intervals* only if you count the zero-length ones at the repeated end knots. The number of non-zero spans is 1, 2, 3, 4, 3, 2, 1 for $N_{1,4},\dots,N_{7,4}$. Only $N_{4,4}$ spans 4 intervals. The last frame shows this: $N_{1,4}$ lives on [0,1] only, $N_{2,4}$ on [0,2], and so on. A reader who checks the sentence against the GIF will find it contradicted for 6 of the 7 curves.
- **Evidence:** `reviewer/check.py` (run with `/usr/bin/python3 -I check.py`) lists the knots of each function and its non-zero spans: N_1 [0,1]; N_2 [0,1],[1,2]; N_3 three spans; N_4 [0,1]..[3,4]; N_5 three spans; N_6 two; N_7 one. `reviewer/dump_bb.jl` gives the same result from the script's own values: N_1 is non-zero on [1e-9, 0.994], N_2 on [1e-9, 1.996], N_4 on [0.008, 3.992], N_7 on [3.006, 4.0].
- **Suggested fix:** "Each cubic basis function $N_{i,4}(t)$ is non-negative and is non-zero only on $[t_i, t_{i+4})$, which is at most 4 knot spans. With this clamped knot vector, the end functions are squeezed to 1, 2 and 3 spans by the repeated end knots. Only $N_{4,4}$ covers all 4."

- **Independent check:** confirmed. Checker: on knots [0,0,0,0,1,2,3,4,4,4,4] only N₄ spans 4 non-degenerate spans; the sentence holds only if zero-length spans at repeated end knots are counted.

### F2 — Misleading — Page match — Description uses subscript = degree, Animations use subscript = order

- **Location:** index.qmd:12-15 ("A B-spline curve of degree $p$ … $C(t)=\sum_i P_i\,N_{i,p}(t)$") against index.qmd:24, 36, 38 and the bsplinebb.gif title, legend and y-label ("$N_{i,4}$", "cubic").
- **Now:** The Description defines the second subscript as the degree $p$. The Animations section and the GIF then call the cubic basis functions $N_{i,4}$, which follows the order convention (k = degree + 1 = 4, bsplineaa.jl:35, bsplinebb.jl:22).
- **True:** Both conventions are valid, but under the convention the page itself sets up, $N_{i,4}$ means a degree-4 (quartic) basis function. The scripts compute degree-3 (cubic) functions: they match scipy `BSpline` with k=3.
- **Evidence:** `reviewer/check.py`: the largest difference between the script's basis values and scipy `BSpline.basis_element` (degree 3) on the knots above is 1.1e-16. The third derivative jumps at knots 1, 2 and 3 (by 41.5, 24.0 and 31.5), which confirms a piecewise cubic.
- **Suggested fix:** Pick one convention. The simplest change is to define the Description in terms of order: "of order $k$ (degree $k-1$) … $C(t)=\sum_i P_i N_{i,k}(t)$", and add a note that cubic means $k=4$. Alternatively, keep degree $p$ and relabel the animations as $N_{i,3}$, which means changing the script titles and labels.

- **Independent check:** confirmed.

### F3 — Minor — Page match — Case 1 alt text says "traced through 7 control points using de Boor's algorithm"

- **Location:** index.qmd:34, alt text "Cubic B-spline curve traced through 7 control points using de Boor's algorithm; …"
- **Now:** "through 7 control points" suggests the curve interpolates all 7 points. "de Boor's algorithm" names the triangular evaluation scheme on control points.
- **True:** The curve passes through only the first and last control points. Its closest approach to the interior points is 0.68 to 1.21. The Behavior text at line 30 states this correctly, so the alt text contradicts it. bsplineaa.jl does not use de Boor's algorithm: it evaluates the Cox–de Boor basis functions and sums $P_i N_{i,4}(t)$ (lines 11-32). That gives the same curve, but by a different named algorithm.
- **Evidence:** `reviewer/check.py` reports the minimum distance from each control point to the plotted curve: (0,0) 6.7e-9; (1,2) 0.976; (2,-1) 1.211; (3,2) 0.912; (4,-0.5) 0.911; (5,1.5) 0.680; (6,0) 5.4e-9.
- **Suggested fix:** "Cubic B-spline curve traced from 7 control points by summing Cox–de Boor basis functions; it passes through the first and last control points and lies within the convex hull of the control polygon".

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — bsplineaa.jl comments misdescribe the animation and the knot vector

- **Location:** bsplineaa.jl:3-4, "Reveals the curve segment by segment (left to right) then shows control polygon comparison", and bsplineaa.jl:47, "Clamped uniform knot vector: k zeros, interior knots, k zeros".
- **Now:** The header promises a reveal segment by segment followed by a control-polygon comparison phase. The knot comment says the vector ends with k zeros.
- **True:** The animation traces one continuous sweep of 400 points over 31 frames. Frame boundaries do not line up with knot segments, and there is no separate comparison phase: the control polygon is shown in every frame. The code (line 52) ends the knot vector with k copies of 4.0, not zeros, which is correct for a clamped vector. Only the comment is wrong.
- **Evidence:** `reviewer/dump_aa.jl` prints `knots = [0,0,0,0,1,2,3,4,4,4,4]` and the parameter value of each frame. These are evenly spaced, about 0.13 apart, and do not land on knots. The frames 1-31 contact sheet shows the polygon in every frame.
- **Suggested fix:** Line 3-4: "Traces the curve continuously as t runs from t_min to t_max; control polygon shown throughout". Line 47: "k copies of t_min, interior knots, k copies of t_max".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `bsplineaa.jl` | yes | 4.2 | bsplineaa.gif |
| `bsplinebb.jl` | yes | 2.9 | bsplinebb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12-15 | "A B-spline curve of degree $p$ … $C(t)=\sum_i P_i N_{i,p}(t)$" | Correct as a definition. bsplineaa.jl:24-32 sums $P_i N_{i,k}$. The subscript convention clashes with the Animations section | confirmed (formula); notation clash → F2 |
| 2 | 18 | "basis functions are defined recursively by the Cox-de Boor relation over a knot vector" | bsplineaa.jl:11-21 and bsplinebb.jl:10-20 implement Cox–de Boor; values match scipy to 1.1e-16 | confirmed |
| 3 | 18 | local support; "smoothness controlled by degree and knot multiplicity" | General properties. Here the supports are as listed in F1. C² at simple interior knots (see #10) | confirmed (general statement). Note: in this example $N_{4,4}$ covers the whole domain, so moving $P_4$ moves the entire curve |
| 4 | 20 | "With a clamped knot vector, the curve interpolates the first and last control points" | C(0)=(0,0)=P1, C(4)=(6,0)=P7 (scipy) | confirmed |
| 5 | 20 | "while remaining inside the convex hull of the control polygon" | All 400 plotted points are inside the Delaunay hull of P (check.py: True) | confirmed |
| 6 | 24 | "two complementary views of cubic B-splines" | Both scripts use k=4 (order) = cubic, with the same knot vector | confirmed |
| 7 | 24 | "individual basis functions $N_{i,4}(t)$ whose weighted sum defines the curve" | Same knots and same n=7 in both scripts. The curve equals $\sum P_i N_{i,4}$ to 8.9e-16 against scipy | confirmed (subscript convention → F2) |
| 8 | 28 | "Case 1 — Cubic B-spline curve traced from 7 control points" | bsplineaa.jl:36-44 has 7 points, k=4 | confirmed |
| 9 | 30 | "with a clamped knot vector passes through the first and last control points" | knots [0,0,0,0,1,2,3,4,4,4,4]. Endpoint distance is 6.7e-9 and 5.4e-9 (offset 1e-9 in t) | confirmed |
| 10 | 30 | "smoothly pulled toward the interior control points" | Interior points sit 0.68–1.21 from the curve, and the curve bends toward each one (frame 31) | confirmed |
| 11 | 30 | "The curve is $C^2$-continuous everywhere" | Jumps at t=1,2,3: derivatives 0-2 below 2e-11; third derivative jumps 41.5, 24.0, 31.5 | confirmed |
| 12 | 30 | "The animation traces the curve parameter $t$ from start to end" | Frames 1..31 have t from 1e-9 to 4-1e-9 (dump_aa.jl); red marker at the current point | confirmed |
| 13 | 32, 34 | Wiring: Julia source bsplineaa.jl, embed bsplineaa.gif | manifest: the GIF is byte-identical to the script's output | confirmed |
| 14 | 34 | alt: "traced through 7 control points" | Only the endpoints are interpolated | wrong (→ F3) |
| 15 | 34 | alt: "using de Boor's algorithm" | Basis-function summation, not de Boor's algorithm | wrong (→ F3) |
| 16 | 34 | alt: "the smooth curve lies within the convex hull of the control polygon" | check.py: True | confirmed |
| 17 | 36 | "Case 2 — Basis functions $N_{1,4},\ldots,N_{7,4}$" | 7 functions, one added per frame, 7 frames | confirmed |
| 18 | 36, 38 | "partition of unity" / "Their sum equals 1 everywhere in the domain" | max \|Σ−1\| = 3.3e-16 on [0,4] (script and scipy). Frame 7 dashed line is at 1 | confirmed |
| 19 | 38 | "$N_{i,4}(t)$ is non-negative" | min of all basis values = 0.0 | confirmed |
| 20 | 38 | "has local support over exactly 4 knot spans" | Non-zero spans are 1,2,3,4,3,2,1 | wrong (→ F1) |
| 21 | 38 | "which is why the B-spline curve lies within the convex hull" | Non-negativity plus partition of unity implies the convex-hull property. Correct reasoning | confirmed |
| 22 | 40, 42 | Wiring: bsplinebb.jl and bsplinebb.gif | manifest: byte-identical | confirmed |
| 23 | 42 | alt: "Seven cubic B-spline basis functions N_{i,4} revealed one at a time" | frames 1-7 add N_1..N_7 | confirmed |
| 24 | 42 | alt: "running sum shown in black approaches 1 as all functions are added" | Dashed black sum. It equals 1 on a growing left region (for example [0,~1.5] at m=4) and on all of [0,4] at m=7 | confirmed |

## Implementation checks

### bsplineaa.jl
- **Method:** A clamped cubic B-spline curve (order k=4) from 7 control points, evaluated as $\sum_i P_i N_{i,4}(t)$, with basis functions from the Cox–de Boor recursion (half-open lowest-order intervals, 0/0 treated as 0). Knot vector `[0,0,0,0,1,2,3,4,4,4,4]` (n+k=11 knots, 3 uniform interior knots), parameter range [t_k, t_{n+1}] = [0,4]. This is a correct, standard formulation. It is not de Boor's algorithm (F3).
- **Numbers:** I compared the script's 400 curve points (`reviewer/dump_aa.jl` writes `aa_curve.csv`) with scipy `BSpline(t,P,3)` built independently in `reviewer/check.py`. The largest difference is 8.9e-16. Endpoints: script (3.0e-9, 6.0e-9) and (6.0-3e-9, 4.5e-9); scipy C(0)=(0,0), C(4)=(6,0). Sample interior values: C(1)=(1.9167,0.25), C(2)=(3,1.0833), C(3)=(4.0833,0.4167). Script frame 16, at t=1.99499, gives (2.99499,1.08201), which agrees with scipy's C(2).
- **Reference values:** None drawn. The control polygon and points are drawn from `ctrl_pts` directly.
- **Picture:** I looked at frames 1 and 31 at full size and the contact sheet (frames 1–31, 12 shown). Frame 1 shows the polygon, the points and the red marker at P1 only. The curve grows left to right. Frame 31 shows the full curve ending at P7. The curve stays inside the convex hull and the axis limits (-0.2..6.2, -1.8..2.5) contain all the geometry. The title and legend are accurate. The −1e-9 offset at t_max prevents the half-open-interval evaluation from returning 0 at t=4, and it has no visible effect.

### bsplinebb.jl
- **Method:** The same Cox–de Boor routine and the same knot vector as bsplineaa.jl. It plots $N_{1,4}..N_{m,4}$ and their running sum for m=1..7.
- **Numbers:** I compared the script's basis values on 500 points (`reviewer/dump_bb.jl` writes `bb_basis.csv`) with `scipy.interpolate.BSpline.basis_element(t[i:i+5])`. The largest difference is 1.1e-16. Partition of unity: max \|Σ−1\| = 3.3e-16 (script and scipy). Non-negativity: min = 0. Peak values: N1 and N7 ≈ 1 at the ends, N2 and N6 0.598, N3 and N5 0.596, N4 0.6667 (= 2/3 at t=2, the value for a uniform cubic, correct). Supports are given in F1. At the interior knots, derivatives 0–2 are continuous and the third derivative jumps, so each function is C² at the knots, as degree 3 requires.
- **Reference values:** The dashed sum line is computed from the same basis arrays and matches the true value 1 (see above).
- **Picture:** I looked at frames 1, 4 and 7 at full size. In frame 1, N_1 (blue) and the sum coincide. In frame 4, the sum is 1 on [0,~1.5] and falls off after that, as it should with N_5..N_7 missing. In frame 7, all 7 curves are shown and the sum sits flat at 1. The title index m matches the number of curves drawn. The labels render with a literal underscore ("N_7,₄", "N_{i,4}(t)"). This is cosmetic and readable, so it is not a finding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/b-splines/`](evidence/b-splines/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
