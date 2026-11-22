# Fix record: bezier-curves

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/bezier-curves/fix/` (below: `$F`).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:**
  - `sed 's/<[^>]*>//g' n2003/BezierCurveMod.html` lists Examples 1–9. `grep -n 'Example [0-9]\.' bezier/BezierCurveMod.nb` gives them at lines 905, 1641, 2681, 2785, 2866, 3336, 3519, 3685 and 3803.
  - The coordinates are in the notebook: Example 3 at l.2681–2700, with values at l.2716; Example 4 at l.2785–2800; Example 6 at l.3336+. The statement images confirm them. `gr_82–85` give Example 3 as `(2,2)`, `(4,1)`, `(1,1.5)`, `(3.5,0)`. `gr_97–100` and `gr_195–198` give Examples 4 and 6 as `(2,2)`, `(4,1)`, `(0,1)`, `(3,-1)`. I upscaled them with `$F/upscale.jl` and viewed `$F/archive/stmt.png` and `$F/archive/ex6.png`.
  - The page's cases (0,0),(1,2),(3,2),(4,0) and (0,0),(0,2),(4,0),(4,2) are neither of these, and the page has no note about the module's examples. The finding holds.
- **Decision applied:** R2-A, "follow Mathews when the departure is a parameter of an existing case". The control points are the whole parameter set of a case, just as the functions are for Maclaurin T08–T12. The reviewer's first option also does this.
  - Case 1 now uses Example 3 and Case 2 uses Example 4. Together they reproduce Mathews' Example 5 comparison.
  - The remaining module examples get the R2-A one-sentence "not animated here" note.
  - Round 1 fixed the trace/red-point sync and the legend position (commit 62d6851). The new control points keep both, so this does not undo a confirmed round-1 fix.
- **Change:**
  - `bezieraa.jl`:
    - `P` changes from (0,0),(1,2),(3,2),(4,0) to (2,2),(1,1.5),(3.5,0),(4,1).
    - Limits change from (-0.2,4.2)×(-0.4,2.5) to (-0.3,4.3)×(-1.3,2.3).
    - Title: "Bézier Curve — de Casteljau" becomes "Bézier Curve (Example 3) — de Casteljau".
    - The header comment changes to match.
  - `bezierbb.jl`:
    - `P` changes from (0,0),(0,2),(4,0),(4,2) to (2,2),(0,1),(3,-1),(4,1).
    - Limits change from (-0.3,4.3)×(-0.3,2.3) to (-0.3,4.3)×(-1.3,2.3), the same as Case 1 so the two GIFs compare directly.
    - Title: "(S-shape)" becomes "(Example 4)".
    - The header comments change to match.
  - `index.qmd`:
    - both case headings, both Behavior paragraphs and both alt texts are rewritten;
    - two source-note sentences are added after the last embed (there was no legacy note before).
- **Check:**
  - **Instrumented copies** (`$F/bezier*_instr.jl`) print t, L3 and the trace ends for every frame. Both copies' GIFs are byte-identical to the regenerated repo GIFs (`cmp`). `/usr/bin/python3 $F/check_frames.py $F` gives, for each case:
    - 40 frames, with t = k/39;
    - max |L3 − B(t)| = 4.4e-16 against an independent Bernstein sum;
    - trace end = red point exactly (0.0), and trace start = P0 (0.0);
    - first point (2,2) and last point (4,1).
  - **Independent geometry:** `/usr/bin/python3 $F/check_cases.py` (sympy/numpy/scipy) gives the numbers in the ledger.
  - **Frames:** the final frames match Mathews' own solution graphs `gr_95` (Ex. 3), `gr_108` (Ex. 4) and `gr_113` (Ex. 5 overlay), which I viewed in `$F/archive/graphs.png`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 heading | "Mathews' Example 3, P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1)" | nb l.2681–2700 and the statement images gr_82–85 (viewed) give (2,2),(4,1),(1,1.5),(3.5,0); `bezieraa.jl` P is identical | yes |
| Case 1 Behavior | "leaves P0 heading toward the handle P1" | check_cases.py: B'(0) = (−3,−1.5) = 3(P1−P0) | yes |
| Case 1 Behavior | "bends one way without an inflection" | curvature numerator x'y''−y'x'' = 9(27t²−25t+11)/2, no real roots in [0,1], min 23.46 > 0 on [0,1] | yes |
| Case 1 Behavior | "arrives at P3 along the line from P2" | B'(1) = (1.5,3) = 3(P3−P2) | yes |
| Case 1 Behavior (kept) | "Level-1 (orange), level-2 (green), and curve (red) points ... from P0 to P3" | Script colours are unchanged. Frames 1 and 40: red at (2,2) and (4,1) (check_frames first/last) | yes |
| Case 1 alt | "Mathews' Example 3, control points (2,2),(1,1.5),(3.5,0),(4,1) ... blue curve from P0 to P3" | as above; the trace colour is steelblue (frame 40 viewed) | yes |
| bezieraa.gif title | "Bézier Curve (Example 3) — de Casteljau  (t = …)" | frame_040.png viewed: fits in the frame, t = 1.0 | yes |
| Case 2 heading | "Mathews' Example 4, handles twice as far out, P0=(2,2), P1=(0,1), P2=(3,-1), P3=(4,1)" | nb l.2785–2800 and gr_97–100 (viewed). P1−P0 = (−2,−1) = 2·(−1,−0.5) and P2−P3 = (−1,−2) = 2·(−0.5,−1), both True in check_cases.py | yes |
| Case 2 Behavior | "endpoints and end-tangent directions are those of Case 1" | B(0) = (2,2) and B(1) = (4,1) in both cases. Ex4 B'(0) = (−6,−3) = 2·Ex3 B'(0); Ex4 B'(1) = (3,6) = 2·Ex3 B'(1), so the directions are the same | yes |
| Case 2 Behavior | "each handle sits twice as far from its endpoint" | as the heading row | yes |
| Case 2 Behavior | "stays closer to each end tangent" | check_cases.py: distance from the end tangent line as a function of distance s along it. Ex4 < Ex3 for all s in the common range: P0 end (0, 0.388], True; P3 end (0, 0.757], True. At s = 0.25: 0.0146 vs 0.0625 (P0) and 0.0159 vs 0.0559 (P3). End curvature: P0 0.417 vs 1.312, P3 0.477 vs 1.550 | yes |
| Case 2 Behavior | "follows it farther before turning back" | the projection onto the tangent direction keeps increasing up to s = 1.044 (Ex4) vs 0.388 (Ex3) at P0, and 1.514 vs 0.757 at P3 | yes |
| Case 2 Behavior | "leftmost point is at x≈1.33 instead of x≈1.77" | x'(t) = 0 at t = 5/7 − √11/7 = 0.2405 gives x = 1.32723 (Ex4); t = 7/11 − 3√3/11 = 0.1640 gives x = 1.76615 (Ex3). The sampled x ranges are [1.3272, 4] and [1.7661, 4]. Frame 40 shows the same | yes |
| Case 2 Behavior | "This is the comparison Mathews makes in his Example 5" | nb l.2866 and Solution 5 (l.2880+) show gr1 and gr2 (Examples 3 and 4) together; gr_113 viewed | yes |
| Case 2 Behavior (kept) | "The de Casteljau construction proceeds identically" | `diff bezieraa.jl bezierbb.jl`: only comments, P, title and formatting differ; the limits are now equal | yes |
| Case 2 alt | "(2,2),(0,1),(3,-1),(4,1) ... same endpoints as Case 1 with handles twice as far out ... follows each end tangent farther and reaches left to about x = 1.33" | as the rows above | yes |
| bezierbb.gif title | "Bézier Curve (Example 4) — de Casteljau  (t = …)" | frame_040.png and frame_020.png viewed: the title fits. Frame 20 (t = 19/39, title 0.49) has the red point at about (1.83,0.40), and B(19/39) = (1.827,0.404) | yes |
| Source note, sentence 1 | "No archived animation GIF is available for this topic" | `find a2001/Animations -iname '*bez*'` → nothing. All 221 GIFs under `n2003/bezier/` and `n2003/Web/BezierCurveMod/` are single-frame (PIL n_frames check) | yes |
| Source note, sentence 1 | "use the control points of Examples 3 and 4 ... which he plots from their parametric formulas and compares in Example 5" | nb: `ParametricPlot[P1[t]]`/`P2[t]` of R[t]; Solution 5 is `Show[cont, gr1, gr2, …]`. sympy shows Mathews' R[t] is identical to the Bernstein form for both cases (`R==B: True`) | yes |
| Source note, sentence 1 | "(Example 6 rebuilds the Example 4 curve from Bernstein polynomials)" | the Example 6 statement (nb l.3336+, images gr_195–198 viewed) has the same four points as Example 4; its solution uses `Σ … t^i (1-t)^(3-i)` | yes |
| Source note, sentence 1 | "the de Casteljau construction is this page's addition" | `grep -ic casteljau` over the nb and the module HTML → 0 and 0 | yes |
| Source note, sentence 2 | "Examples 1–2, which build a cubic polynomial through four points and a clamped cubic Hermite polynomial as background" | stripped module HTML: Ex 1 "Find the cubic polynomial … that passes through the four points"; Ex 2 "Find the cubic Hermite polynomial or 'clamped cubic'". Both sit under the "Background" headings | yes |
| Source note, sentence 2 | "Example 7, a composite curve joined from four Bézier pieces" | nb l.3519: "Find composite Bézier curve" with V of 4 rows of 8 numbers. Each row's end point equals the next row's start (Python: [True, True, True]) | yes |
| Source note, sentence 2 | "Examples 8–9, on Mathematica's SplineFit package" | nb l.3685: `Needs["NumericalMath`SplineFit`"]`, `SplineFit[pts, Cubic]`; Ex 9: "What is the nature of the 'spline fit' constructed by Mathematica?" | yes |
| Description (unchanged) | "stays inside the convex hull of its control polygon" (still true for the new cases?) | check_cases.py: 100001 samples per case are all inside the Delaunay hull of the control points (True, True) | yes |

## Scripts and GIFs

- Scripts changed: `bezieraa.jl` and `bezierbb.jl` (control points, axis limits, title, header comments). The algorithm is untouched.
- GIFs regenerated: run in place with `julia bezieraa.jl` and `julia bezierbb.jl`. Both exit 0; 40 frames each at 8 fps. md5: aa `bdfd0132efcf9c48f3a864a167ab53bd`, bb `69f44a2ef4e98956e9c8f8476ba4eb60`.
- Frames viewed (`giftools.jl` into `$F/frames_bezieraa/` and `$F/frames_bezierbb/`):
  - Both contact sheets, frame 40 of each, and frame 20 of bb.
  - Checked: at t = 0, L1 = P0..P2, L2 = (P0,P1) and red = P0. The level polylines are built from the right points, and the red point sits on the end of the blue trace in every frame.
  - The final curves match Mathews' graphs gr_95 and gr_108.
  - All points lie inside the shared limits (−0.3,4.3)×(−1.3,2.3), and no legend covers a point.
  - The titles are legible and not clipped.
- `git status --short -- pages/numerical-methods/bezier-curves` after regeneration: `M bezieraa.gif`, `M bezieraa.jl`, `M bezierbb.gif`, `M bezierbb.jl`, `M index.qmd`. These are exactly the expected files.

## Legacy archive

Consulted: `n2003/BezierCurveMod.html`, the `bezier/BezierCurveMod/Links/*.html` pages, `bezier/BezierCurveMod.nb`, and the statement and graph images gr_82–85, 95, 97–100, 108, 113 and 195–198.

- No animated GIF exists for this topic. The module plots Examples 3 and 4 with `ParametricPlot` from the expanded (power-form) parametric equations and overlays them in Example 5. Example 6 redoes Example 4 with Bernstein polynomials.
- The page now uses exactly those control points. The animation still uses de Casteljau's construction, which the module does not use. Both evaluate the same curve: sympy shows R[t] equals the Bernstein form, and the instrumented L3 agrees with it to 4.4e-16. The source note says the construction is the page's own.
- Mathews' "More background" claim is that a handle farther out in the same direction makes the curve stay closer to the tangent near that endpoint. I checked it numerically for these two curves (ledger rows "stays closer" and "follows it farther") rather than taking it from the archive.

## Notes

- **Decision ambiguity:** F1 fits both R2-A branches. The control points could count as "parameters of an existing case" (follow Mathews), or the cases could count as a whole left-out example (add one sentence). I applied the follow branch to the cases, because the control points are the case's defining parameters, as functions are for Maclaurin. I applied the sentence branch to the examples that are still not shown (1–2, 7, 8–9).
  - The cost is that the page no longer shows an inflected (S-shaped) cubic, which the old Case 2 did. Neither Mathews example has an inflection (both curvature numerators are positive on [0,1]).
  - If Jason prefers to keep the S-curve, the alternative is the reviewer's second option: restore the old cases and add a sentence saying they are illustrative.
- Placement: the page had no legacy note, so the two source sentences go directly after the last embed, per the Monte Carlo pattern.
- Nothing outside the page folder was touched apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence:
  - The archive control points are confirmed in `n2003/bezier/BezierCurveMod.nb`:
    - Example 3 (line 2681 ff.): `{x0,y0}={2,2}`, `{x3,y3}={4,1}`, `{x1,y1}={1,1.5}`, `{x2,y2}={3.5,0}`. The `values` rules repeat these.
    - Example 4 (line 2785 ff.): the same endpoints with `{0,1}` and `{3,-1}`.
    - Example 5 (line 2866) overlays `gr1` and `gr2` as a comparison.
    - Example 6 (line 3336) uses the Example 4 points with Bernstein polynomials.
  - The scripts now use exactly these points: `bezieraa.jl` line 11 is `P=[[2,2],[1,1.5],[3.5,0],[4,1]]` and `bezierbb.jl` line 10 is `P=[[2,2],[0,1],[3,-1],[4,1]]`. The headings, alt text and GIF titles ("Example 3" and "Example 4") agree with them.
  - Mathews' parametric formula `R[t]` is the standard Bernstein cubic. With sympy, `R[t] - B(t)` is 0 for both cases. So the de Casteljau curve is Mathews' curve, and the expanded forms agree: Example 3 has x = −11t³/2+21t²/2−3t+2 and y = 7t³/2−3t²−3t/2+2; Example 4 has x = −7t³+15t²−6t+2 and y = 5t³−3t²−3t+2.
  - The Example 5 handle-placement lesson is now on the page (Case 2 Behavior), and the omitted examples are named in one sentence (line 43), as R2-A requires.
  - The red point is checked at t = 19/39 in both GIFs. Case 1 computes to (2.395, 0.962) and Case 2 to (1.828, 0.404), and both match the frames.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:26 | Case 1 heading: Mathews' Example 3, P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1) | .nb line 2681 ff. and the script | true |
| index.qmd:28 | "leaves P0 heading toward the handle P1" | B'(0) = (−3, −1.5) = 3(P1−P0) | true |
| index.qmd:28 | "bends one way without an inflection" | x'y''−y'x'' = 243t²/2 − 225t/2 + 99/2, discriminant < 0, so it is > 0 on [0,1] | true |
| index.qmd:28 | "arrives at P3 along the line from P2" | B'(1) = (1.5, 3) = 3(P3−P2) | true |
| index.qmd:28 | level colours and red point trace | frames 1, 20 and 40 | true |
| index.qmd:32 | alt text, Example 3 points | as above | true |
| index.qmd:34 | Case 2 heading: Example 4, "handles twice as far out", P1=(0,1), P2=(3,−1) | .nb line 2785 ff.; P1−P0 = (−2,−1) = 2·(−1,−0.5) and P2−P3 = (−1,−2) = 2·(−0.5,−1) | true |
| index.qmd:36 | "endpoints and end-tangent directions are those of Case 1" | same P0 and P3; tangents (−6,−3) ∥ (−3,−1.5) and (3,6) ∥ (1.5,3) | true |
| index.qmd:36 | "stays closer to each end tangent and follows it farther before turning back" | perpendicular deviation at equal distance along the tangent: Case 2 is smaller than Case 1 at every common distance, at both ends (`dev.py`). The farthest distance along the tangent before turning back is 1.043 vs 0.388 at the start and 1.514 vs 0.757 at the end | true |
| index.qmd:36 | leftmost x ≈ 1.33 (Case 2) and ≈ 1.77 (Case 1) | x'(t)=0 at t=0.24048 gives x=1.32723; at t=0.16399 it gives x=1.76615 | true |
| index.qmd:36 | "This is the comparison Mathews makes in his Example 5" | .nb line 2866: Show[gr1, gr2] | true |
| index.qmd:40 | alt text: Example 4 points, "reaches left to about x = 1.33" | as above | true |
| index.qmd:42 | "No archived animation GIF is available for this topic" | `find a2001/Animations -iname '*bez*'` and `grep -ril bezier` return nothing | true |
| index.qmd:42 | Examples 3 and 4 plotted from parametric formulas, compared in Example 5; Example 6 rebuilds the Example 4 curve from Bernstein polynomials | .nb: ParametricPlot of R[t]; Example 6 uses the Example 4 points and Σ Binomial[3,i] tⁱ(1−t)^(3−i) | true |
| index.qmd:43 | Examples 1–2 are a cubic through four points and a clamped cubic Hermite; Example 7 is a composite of four Bézier pieces; Examples 8–9 use SplineFit | .nb lines 905, 1641, 3519 (V has 4 rows), 3685 and 3803 | true |
| bezieraa.jl:3, bezierbb.jl:3–4 | comments: points and "twice as far" | as above | true |
| both scripts | xlims (−0.3, 4.3), ylims (−1.3, 2.3) | control points span x∈[0,4] and y∈[−1,2]; curve y minima are 0.664 and 0.144; all visible in the frames | fine |
| both scripts | titles "Bézier Curve (Example 3/4) — de Casteljau (t = …)" | frames: legible, and t = 0.49 at frame 20 matches 19/39 = 0.487 | true |

### New problems
None. This rests on:
- the full ledger above, every item checked against sympy or numpy and the archive notebook;
- full-size frames 1, 20 and 40 of both GIFs: curve, control polygon, de Casteljau levels and red point are built from the right points, the trace ends at the red point, the labels are legible and nothing is clipped.

One old quirk is unchanged and was not introduced by the fix. At t=0 and t=1 the coloured level markers sit on top of the black control-point markers. This is inherent to de Casteljau at the endpoints.

### Reproducibility and conventions
- Both scripts were run from scratch copies (`check/run/`). The output is byte-identical to the committed GIFs:
  - `bezieraa.gif`: sha256 1573919a…26d5;
  - `bezierbb.gif`: sha256 6f403968…dd26.
  
  Both match the LFS oids in the diff. Each GIF is 40 frames at 700×550.
- Conventions:
  - Description comes before Animations.
  - Each case has a source link and an embed.
  - The alt text is descriptive and names the points.
  - There are no code blocks.
  - The citation is `[@mathewsSite]`, present in references.bib.
- Outside `pages/numerical-methods/` no tracked file is modified. For this page, only the five files in its folder changed. The other modified page folders and the untracked `reviews/.../fixes/*.md` belong to other fixers and were not inspected.

**Final status:** committed
