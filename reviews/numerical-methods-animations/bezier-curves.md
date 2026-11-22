# Bézier Curves — animation review

Page: [`pages/numerical-methods/bezier-curves/index.qmd`](../../pages/numerical-methods/bezier-curves/index.qmd) · Scripts: `bezieraa.jl`, `bezierbb.jl` · GIFs: 2

**Result:** 1 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — The traced blue curve is not in step with the red point and never reaches P3

- **Location:** `bezieraa.jl:52` and `bezierbb.jl:45`: `idx_end = min(frame_idx * div(n_curve, n_frames), n_curve)`. This shows up in the final frames of both GIFs and contradicts index.qmd lines 22, 28 and 32.
- **Now:** The backdrop curve has 300 samples and there are 40 frames, so frame k draws samples 1..7k. Frame k therefore draws the curve up to t = (7k−1)/299, while the red point sits at t = (k−1)/39. The two agree only at frame 10. Before that the blue curve runs slightly ahead of the red point (by t = 0.02 at frame 1). After that it falls further and further behind. In the last frame (t = 1.0) the blue curve stops at t = 279/299 = 0.9331:
  - bezieraa: the curve ends at (3.787, 0.374) and the red point is at P3 = (4, 0), a visible gap of 0.431.
  - bezierbb: the curve ends at (3.949, 1.650) and the red point is at P3 = (4, 2), a gap of 0.354.
  
  In the final frame of either GIF, the curve labelled "Bézier curve" visibly stops short of P3, and the "point on curve" sits off the drawn curve. This is clear in committed `bezieraa/frame_040.png`, `bezierbb/frame_036.png`, `bezierbb/frame_039.png` and `bezierbb/frame_040.png`, and in the t = 0.82 and 0.92 panels of both contact sheets.
- **True:** The Bézier curve runs from P0 to P3 (B(1) = P3, checked below). When the red point is at parameter t, the trace should end exactly at B(t).
- **Evidence:** `reviewer/dump_aa.jl` and `reviewer/dump_bb.jl` are the script bodies with the animation loop replaced by a dump of each frame's t, idx_end, t_curve[idx_end] and the de Casteljau points. `reviewer/check.py` (run as `/usr/bin/python3 -I check.py <reviewer dir>`) prints the gap between the trace end and the red point:
  - aa: frame 1 gap 0.133 (trace ahead), frame 10 gap 0, frame 20 gap 0.100, frame 30 gap 0.222, frame 39 gap 0.405, frame 40 gap 0.431.
  - bb: frame 1 gap 0.116, frame 10 gap 0, frame 20 gap 0.134, frame 30 gap 0.221, frame 39 gap 0.315, frame 40 gap 0.354.
- **Suggested fix:** Inside the loop of both scripts, draw the trace up to the current t. One way is `tt = range(0, t, length=max(2, round(Int, 1 + t*(n_curve-1))))` followed by plotting `decasteljau_point.(Ref(P), tt)`. Another is `idx_end = 1 + round(Int, t*(n_curve-1))`. Either way, frame 40 then ends exactly at P3.

- **Independent check:** confirmed with correction. Checker: idx_end = 7*frame_idx stops at sample 280 of 300 (t=0.933). Corrections: the bezierbb.jl line is 123, not 45; the curve is slightly ahead of the point in frames 1–9 and lags only from frame 11; lines 28 and 32 are what the GIF contradicts (line 22 is correct maths the GIF fails to show).

### F2 — Misleading — Implementation — The legend covers a control point in both GIFs, and in Case 2 it also covers the final curve point at P3

- **Location:** `bezieraa.jl:44-48` and `bezierbb.jl:38-43` (`legend=:topright` with the axis limits as set). This affects index.qmd lines 26/28/32 (Case 1) and 34/36/40 (Case 2).
- **Now:**
  - bezieraa: the black marker for P2 = (3, 2) sits under the legend box in every frame. The reader sees only three control points for a "cubic" with four. The dashed polygon and the orange level-1 segment both disappear into the legend near (3, 2) (see frames 001, 020 and 040).
  - bezierbb: P3 = (4, 2) sits under the legend in every frame. In frames 39 and 40 (t = 0.97 and 1.0) the red "point on curve" is also under the legend, along with the upper level-1 and level-2 points. So the moment the curve reaches its endpoint P3 is never visible. Frame 040 shows no red point at all.
- **True:** All four control points are part of the construction. The page's Case 2 heading and alt text list (4, 2) as a control point, and the page says the curve ends at P3.
- **Evidence:** I inspected committed frames `bezieraa/frame_001.png`, `frame_020.png`, `frame_040.png`, `bezierbb/frame_036.png`, `frame_039.png` and `frame_040.png`. In bb the red point is at (3.992, 1.854) at t = 0.974 and at (4, 2) at t = 1 (from `dump_bb.txt`), both inside the legend's area (about x ≥ 2.85, y ≥ 1.83).
- **Suggested fix:** Use `legend=:outerright` in both scripts. That is the simplest choice. In the S-curve every corner of the plot holds a control point, so no corner position is free. Another option is to raise the upper `ylims` (for example to 3.2) so that the legend sits above y = 2.

- **Independent check:** confirmed. Checker: legend covers P2 in all 40 frames of Case 1 and P3 in all 40 of Case 2; hides the red point in Case 2 frames 38–40.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `bezieraa.jl` | yes | 5.0 | bezieraa.gif |
| `bezierbb.jl` | yes | 4.5 | bezierbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–16 | "A Bezier curve of degree n ... defined by the Bernstein polynomial form B(t)=Σ C(n,i)(1−t)^{n−i} t^i P_i, t∈[0,1]" | Standard definition. Exact sympy Bernstein evaluation matches the scripts' de Casteljau to ≤4.4e-16 at all 40 frame t's, and the 300-point backdrop matches to ≤8.9e-16 (check.py) | confirmed |
| 2 | 18 | "The curve starts at P0, ends at Pn" | B(0) = P0 and B(1) = P3 for both cases (check.py). The GIF trace does not show this (F1) | confirmed (math); the picture contradicts it → F1 |
| 3 | 18 | "stays inside the convex hull of its control polygon" | All 300 backdrop points of both curves lie in the hull (scipy Delaunay test) | confirmed |
| 4 | 18 | de Casteljau "repeatedly performs linear interpolation between adjacent points until one point remains" | The code does exactly this (`decasteljau_point`, and L1→L2→L3 in the loop) | confirmed |
| 5 | 22 | "Each animation below demonstrates the de Casteljau algorithm for constructing a cubic Bézier curve" | Both scripts use 4 control points and draw the de Casteljau levels | confirmed |
| 6 | 22 | "through three successive levels until a single point on the curve is reached" | L1 (3 pts), L2 (2 pts), L3 (1 pt) | confirmed |
| 7 | 22 | "Tracing this point for all t∈[0,1] draws the full curve." | The animation's trace stops at t = 0.933 (F1) | wrong → F1 (true of the math, false of the GIF) |
| 8 | 24 | "Julia source scripts that generated these animations are linked under each case." | Links at lines 30 and 38. Manifest: the committed GIFs are byte-identical to the script output | confirmed |
| 9 | 26 | Case 1: P0=(0,0), P1=(1,2), P2=(3,2), P3=(4,0) | bezieraa.jl:11 | confirmed |
| 10 | 26, 28 | "Arch-shaped" / "The four control points define an arch" | y(t) = 6t(1−t) ≥ 0 with maximum 1.5 at t = 1/2. x'y''−y'x'' = −72(t²−t+1) < 0, so there is no inflection | confirmed |
| 11 | 28 | "Level-1 (orange), level-2 (green), and curve (red) points are shown at each t" | Code lines 63–74 and the frames. In frame 1 and frames 39–40 of Case 2, some of these are hidden under the legend (F2) | confirmed (colours); partly hidden → F2 |
| 12 | 28 | "the red point traces the smooth cubic Bézier curve from P0 to P3" | The red point does go from P0 to P3, but the drawn trace does not follow it and stops short (F1) | wrong → F1 |
| 13 | 30, 32 | Case 1 link `bezieraa.jl` and embed `bezieraa.gif` | Manifest: bezieraa.jl produces bezieraa.gif, and its P matches the heading | confirmed |
| 14 | 32 | alt: "level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve from P0 to P3" | The colours are correct. The blue curve does not reach P3 (F1) | wrong → F1 |
| 15 | 34 | Case 2: P0=(0,0), P1=(0,2), P2=(4,0), P3=(4,2) | bezierbb.jl:9 | confirmed |
| 16 | 36 | "The control points create an S-curve" / "the resulting curve has an inflection point" | x'y''−y'x'' = 144(2t−1): there is exactly one sign change, at t = 1/2 | confirmed |
| 17 | 36 | "The de Casteljau construction proceeds identically" | The two scripts differ only in P, the axis limits and the title (diff) | confirmed |
| 18 | 38, 40 | Case 2 link `bezierbb.jl` and embed `bezierbb.gif` | Manifest: bezierbb.jl produces bezierbb.gif, and its P matches the heading | confirmed |
| 19 | 40 | alt: "control points at (0,0),(0,2),(4,0),(4,2) produce a smooth S inflecting near the center" | The inflection is at B(1/2) = (2, 1), exactly the centre of the point-symmetric configuration. (4,2) is hidden by the legend in the GIF (F2) | confirmed (math); the (4,2) marker is not visible → F2 |

## Implementation checks

### bezieraa.jl
- **Method:** This is the cubic de Casteljau algorithm. `decasteljau_point` repeatedly forms the convex combinations (1−t)p_i + t p_{i+1}, and inside the loop the levels L1, L2 and L3 are formed explicitly in the same way. The backdrop curve is computed with the same routine. There is no substitution or simplification.
- **Numbers:** At each of the 40 frames, t = (k−1)/39 exactly. I recomputed L1 and L2 in numpy from the control points, and the script's values agree with them exactly (max difference 0). Each L1 point is a t-fraction interpolation of adjacent P's, and each L2 point is one of adjacent L1 points. The script's L3 matches the exact rational sympy Bernstein value to within 4.4e-16. The 300 backdrop points match Bernstein to within 8.9e-16. At the end frames: t = 1 gives L3 = (4, 0) = P3, and t = 0 gives L3 = (0, 0) = P0. At t = 0.4872 (frame 20) the script and Bernstein both give (1.9423, 1.4990).
- **Reference values / properties:** In exact sympy, x(t) = −2t³ + 3t² + 3t and y(t) = 6t − 6t². B'(0) = (3, 6) = 3(P1−P0) and B'(1) = (3, −6) = 3(P3−P2), so the end tangents run along the control polygon. All curve samples lie in the convex hull. There is no inflection.
- **Picture:** I viewed `sheet.png` and full frames 001, 020 and 040. The orange segments join the L1 points, the green segment joins the L2 points, and the red point lies on the green segment at fraction t. All of this is consistent with the computed values. The title t is `round(t, 2)` of the actual t. The axis limits (−0.2..4.2, −0.4..2.5) contain the whole construction. Two problems: the trace is out of step with the red point and truncated (F1), and the legend hides P2 (F2).

### bezierbb.jl
- **Method:** The code is the same as bezieraa.jl apart from P, the axis limits and the title. It is the cubic de Casteljau algorithm.
- **Numbers:** L1 and L2 agree exactly with my independent numpy recomputation, L3 agrees with exact Bernstein to within 4.4e-16 at all 40 frames, and the backdrop agrees with Bernstein to within 4.4e-16. At t = 1, L3 = (4, 2) = P3.
- **Reference values / properties:** x(t) = 12t² − 8t³ and y(t) = 8t³ − 12t² + 6t. B'(0) = (0, 6) = 3(P1−P0) and B'(1) = (0, 6) = 3(P3−P2), so the curve leaves P0 and arrives at P3 vertically, as the frames show. The curvature numerator is 144(2t−1), giving a single inflection at t = 1/2, at (2, 1). The curve stays in the convex hull. Its range is x ∈ [0, 4] and y ∈ [0, 2], inside the limits (−0.3..4.3, −0.3..2.3).
- **Picture:** I viewed `sheet.png` and full frames 036, 039 and 040. The construction lines are correct where they are visible. Problems: the trace is truncated at t = 0.933 (F1), and the legend hides P3 in every frame and hides the red point in frames 39–40 (F2).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/bezier-curves/`](evidence/bezier-curves/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
