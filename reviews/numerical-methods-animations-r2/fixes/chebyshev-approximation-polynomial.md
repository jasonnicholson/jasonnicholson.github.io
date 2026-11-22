# Fix record: chebyshev-approximation-polynomial

Scratch folder (all evidence scripts and outputs): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/chebyshev-approximation-polynomial/fix/` (below: `$F`).

Evidence tools written for this fix:
- `$F/exp/dump.jl <script> <tsv>`: runs a script's computations without rendering and dumps span, ylims, xlims, nodes, node values, clamped interpolant and clamped f for every (case, n).
- `$F/nodevis.py <dump> <framesdir>`: maps every node to pixels through the detected plot box and the script's xlims/ylims, checks for red marker pixels within ±3 px, and checks that the legend's red marker is below the plot box.
- `$F/exp/occl.jl` + `$F/exp/occl.py`: render each frame with a candidate legend position and with `legend=false`; the legend box is the diff bounding box; count node/f/interpolant pixels under it.
- `$F/hp_check.py` / `$F/hp_check2.py <dump>`: re-evaluates every interpolant through the script's own nodes in 50-digit mpmath (Lagrange form) on the plotting grid, clamps to the script's band and compares.
- `$F/indep.py`: independent Mathews-form nodes t_k = cos((2k+1)π/(2N+2)) and discrete Chebyshev-series interpolant (numpy/scipy) for the changed cases.
- `$F/legacy_cols.py`, `$F/ticks.py`: measure green bound lines and x-axis ticks in legacy frames.

## Findings

### F1 — Minor — fixed
- Reproduced: the committed GIFs were first regenerated in scratch from the unchanged script (`$F/origrun/`); all 29 match the HEAD LFS oids (sha256), 29/29. `python3 nodevis.py exp/dump_orig.tsv old` → `frames=294 nodes=2424 missing=34`. The misses are in exactly the frames the review names: 13 (n=2,6,10,14,16), 16 (n=2,5,6,8,10,12,14,16), 27 (n=8,12,14,16), 28 (n=2,5,6,8,10,12,14,16; nine nodes in eight frames), 29 (n=4,6,8,10,12,14,16). The first-frame misses are `13 n=2 (-6.6643, 0.9282)` and `16 n=2 (-1.1213, 1.3334)`, as reported. The occlusion run (`occ_orig.txt`) also shows the top-left legend over the f curve in cases 12, 13, 16, 24–29, and over the interpolant in case 08.
- Change: `chebyshev_animations_all.jl` plot call `legend=:topleft` → `legend=:outerbottom, legend_columns=3` (all cases).
  - Why global: the occlusion test with the new case parameters (`occ_new.txt`) found no inner position that is clear in every frame for case 12 or case 13. With the new window, case 02 also hides nodes under `:topleft` (frames 08–10). A per-case inner position therefore could not fix the problem everywhere.
- Check: after regeneration, `python3 nodevis.py exp/dump_new.tsv new` → `frames=294 nodes=2424 missing=0 frames_without_legend_marker_below_box=0`. Every node is visible, and the legend lies below the plot box in every frame. Full-size frames viewed: 16/frame_001 (both nodes visible), 13/frame_001 (in the outer-bottom trial, same data), 29/frame_010, 02/frame_010, 03/frame_001.

### F2 — Minor — fixed
- Reproduced:
  - Archive index `a2001/Animations/Interpolation/Chebyshev/Chebyshev.html` (tags stripped): case 4 "ununequally spaced nodes in [0, 2]", case 29 "unequally spaced nodes in [0.5, 4]".
  - Legacy GIFs measured with `ticks.py` / `legacy_cols.py`:
    - `Chebyshev04/Chebyshevdd.gif`: x ticks at px 132, 251, 371, 490, 609. Case 06 has its green bounds at px 13 and 609, which are 0 and 10, so the scale is 59.6 px/unit. Case 04's green bounds are at px 13 and 132, which is [0, 2].
    - `Chebyshev29/Chebyshevccc.gif`: ticks at px 31, 169, 307, 445, 583 (0, 5, 10, 15, 20; 27.6 px/unit). The green bounds at px 45 and 142 give x = 0.507 and 4.02, so [0.5, 4].
  - The page had [0, 4] and [0.5, 6], and gave no reason.
- Change:
  - Script case 04 span `(0.0, 4.0)` → `(0.0, 2.0)`; case 29 span `(0.5, 6.0)` → `(0.5, 4.0)`.
  - `index.qmd` captions: Case 04 "interval [0, 4]" → "interval [0, 2]"; Case 29 "interval [0.5, 6]" → "interval [0.5, 4]".
- Problem found while checking, fixed as part of this finding:
  - With [0, 2], extrapolation runs to 5.25 interval widths. The script's second-form barycentric evaluation then lost all accuracy far outside the nodes.
  - Case 04 n=16 showed vertical blue lines at x ≈ 7.2–7.6 (frame viewed). Case 29 n=16 had the same fault for x in [12.8, 22].
  - `hp_check.py` against a 50-digit reference flagged 304 and 417 grid points. At x = 7.2207 the script gave the clamped value −3.946, against a true value of +4.4e12.
  - Fix: `barycentric_eval` now uses the first form l(x)·Σ w_j y_j/(x−x_j) when x is outside [min xs, max xs]. Inside the node range the code is unchanged.
  - Before the fix the old script had 0 disagreeing frames (`hp_orig.txt`), so the fault was introduced by the new intervals, not inherited.
- Check:
  - `hp_check2.py exp/dump_new.tsv` → `frames with disagreement: 0`; the largest relative difference from the 50-digit reference over all 294 frames is 1.16e-10 (case 29, n=16).
  - `indep.py`, which uses Mathews' node form and coefficients: nodes agree to ≤ 2.2e-16, f(node) to ≤ 7.7e-16 relative, and the clamped interpolant on the plot grid to ≤ 6.7e-10 relative for cases 01, 02, 03, 04, 07 and 29. Every node lies inside the y-window.
  - The trim loop never fired: the nodes equal the untrimmed Mathews nodes.
  - The evaluation change alters no decoded frame except in 04 and 29: the frame md5s of every other GIF are identical with and without it (`new/` vs `new_legendonly/`).
  - GIF titles read "interval [0, 2]" and "interval [0.5, 4]" (sheets and full frame 29/frame_010).

### F3 — Minor — fixed (node intervals for 02 and 03; Mathews windows restored for 01, 02, 03, 07)
- Reproduced:
  - Legacy formula images `Images/Lagrange_gr_2, 4, 6, 14` (upscaled, `$F/formulas_a.png`) give the windows −1.6 ≤ x ≤ 1.5 for cases 1, 3 and 7 and −1.5 ≤ x ≤ 1.6 for case 2.
  - `Chebyshev02/Chebyshevbb.gif`: ticks every 101 px per 0.5 (0 at px 315); the green bounds at px 133 and 618 give x = −0.901 and 1.500, so [−0.9, 1.5].
  - `Chebyshev03/Chebyshevcc.gif`: ticks at px 20 (−1.5), …, 325 (0), …, 629 (1.5); the green bounds at px 20 and 487 give −1.5 and 0.797, so [−1.5, 0.8].
  - The archive has no GIF for cases 01 and 07 (only `Chebyshevaa.html` and `Chebyshevgg.html`; `find` over the archive finds no `Chebyshevaa*.gif` or `Chebyshevgg*.gif`), so their node intervals cannot be determined.
  - Impact numbers checked: f(0.8) = 25 and f(0.9) = 100. The n = 16 max error is 1.43 on [−1.6, 0.9] and 0.0251 on [−1.5, 0.8] (inline numpy, 4001 points).
- Change (R2-A: interval and window are parameters, so follow Mathews):
  - Case 01 xlims `(-1.6, 0.9)` → `(-1.6, 1.5)`, span kept `(-1.6, 0.9)` because the archive interval is undeterminable.
  - Case 02 xlims → `(-1.5, 1.6)`, span `(-0.9, 1.6)` → `(-0.9, 1.5)`.
  - Case 03 xlims → `(-1.6, 1.5)`, span `(-1.6, 0.9)` → `(-1.5, 0.8)`.
  - Case 07 xlims → `(-1.6, 1.5)`, span kept.
  - Case 03 also gets a new `ylims_from_span=true` option. With the window past the pole, the 3–97% quantile window of f over the whole plot grid became (−67.9, 521.8) and flattened the curve (trial sheet viewed). With the option, the quantile is taken over the node interval and the window is (−1.878, 26.34). Mathews' own frame tops out at about 22–25.
  - Captions: Case 02 "[-0.9, 1.6]" → "[-0.9, 1.5]"; Case 03 "[-1.6, 0.9]" → "[-1.5, 0.8]". The captions for 01 and 07 are unchanged and still true.
- Check:
  - `indep.py` reports spans and xlims as listed, with the agreement in F2.
  - Sheets viewed for 01, 02, 03 and 07 (trial runs with identical data; the later evaluation change alters none of their frames, by md5). The windows show f on both sides of the pole, or its domain end for 07, and the interpolant extrapolating.
  - The GIF titles show the new intervals.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 02 alt | "f(x)=1/(1+x), interval [-0.9, 1.5]." | `indep.py`: dumped span = (-0.9, 1.5); GIF title "interval [-0.9, 1.5]" (02/frame_010); legacy bounds px 133/618 → −0.901/1.500 | yes |
| index.qmd Case 03 alt | "f(x)=1/(1-x)^2, interval [-1.5, 0.8]." | dumped span = (-1.5, 0.8); GIF title (03/frame_001); legacy px 20/487 → −1.5/0.797 | yes |
| index.qmd Case 04 alt | "f(x)=sqrt(x), interval [0, 2]." | dumped span = (0.0, 2.0); GIF title (04 sheet); legacy px 13/132 at 59.6 px/unit → 0/2.0; archive text "[0, 2]" | yes |
| index.qmd Case 29 alt | "f(x)=bessely(0,x), interval [0.5, 4]." | dumped span = (0.5, 4.0); GIF title (29/frame_010); legacy px 45/142 → 0.507/4.02; archive text "[0.5, 4]" | yes |
| GIF titles 02, 03, 04, 29 | intervals as above via `fmt_num(span)` | frames viewed | yes |
| GIF legends (all) | f(x), interpolant, nodes in one row below the plot | `nodevis.py` → legend marker below plot box in 294/294 frames | yes |
| Script comment, barycentric_eval | "Outside the nodes … the second barycentric form … cancels badly; the first form … stays accurate there." | `hp_check.py` before the change: case 04 n=16 and case 29 n=16 disagree at 304 and 417 points (x=7.2207: script −3.946 clamped vs true 4.4e12); after the change: 0 frames disagree, max rel 1.16e-10 | yes |
| Script comment, ylims_from_span | "the pole inside the plotting window does not set the y-range" (case 03) | `dump.jl` case 03 ylims without option (−67.875, 521.751), with option (−1.878, 26.344); f(0.8)=25 | yes |
| Unchanged page sentences (A1–A5, D1–D3) | not edited; still hold | node sequence unchanged; trim loop not triggered (nodes equal Mathews nodes to 2.2e-16); none of the changed cases is even | yes |

## Scripts and GIFs
- Script changed: `chebyshev_animations_all.jl`. It is run in place with `julia chebyshev_animations_all.jl` (exit 0, 29 GIFs).
- All 29 GIFs were regenerated. Every GIF differs from HEAD because the legend moved.
- Unchanged cases (05, 06, 08–28): `dump.jl` old vs new gives identical span, ylims, xlims, nodes, node values and f curve. The interpolant differs by at most 1.8e-11 relative (case 08, n=32), only outside the node range. The decoded frames are md5-identical with and without that change, so the only visual change in these cases is the legend.
- Frames viewed:
  - sheets: 01, 02, 03 (both window variants), 07, 04, 29;
  - full size: 29/frame_010, 16/frame_001, 02/frame_010, 03/frame_001, 04/frame_010 (pre-fix artifact), 13/frame_001 (legend trial), current 14/frame_010 and 24/frame_010 (pole convention).
- Programmatic checks over all 294 frames: `nodevis.py` and `hp_check2.py`, as above.
- `git status -- pages/numerical-methods/chebyshev-approximation-polynomial`: M cheby01.gif … cheby29.gif (29), M chebyshev_animations_all.jl, M index.qmd. Nothing else.

## Legacy archive
- Consulted. `n2003/ChebyshevPolyMod.html` is the general module and holds no per-case parameters.
- The case parameters are in `a2001/Animations/Interpolation/Chebyshev/`: `Chebyshev.html` with formula images `Images/Lagrange_gr_*.gif`, and the per-case GIFs. GIFs are present for 02, 03, 04, 06, 10, 12, 15, 24, 26, 27, 28 and 29; they are missing for 01 and 07, among others.
- What it showed is recorded under F2 and F3. Mathews' frames also draw a "Tolerance ±0.05" convergence-region bar, which the page does not reproduce. No finding names it, so it was not added.
- Differences that remain:
  - The node intervals of 01 and 07 cannot be determined from the archive and are kept at [-1.6, 0.9].
  - Mathews' GIFs use more frames (for example 26 for case 03, 12 for case 04) than the page's fixed n-sequence. This is not a finding.

## Notes
- (Superseded by "Round 2 (director)" below.) In the first pass, cases 01 and 02 showed a vertical magenta segment at the pole, and I left it alone. It is now fixed.
- The review says "2424 nodes in 299 frames". The script produces 28×10 + 14 = 294 frames, and 2424 nodes is correct for 294 frames. The review's frame count is a slip and does not affect F1.
- No R2-A "left out" sentence was added: all 29 Mathews animation cases are on the page, and the decision list does not name this page.

## Round 2 (director)

The director's request: restoring Mathews' windows made Cases 01 and 02 draw f as a connected line through the pole. This artifact was new, introduced by this fix, so it had to be fixed now. The fix follows the Lagrange page's pattern: f drawn with a gap at the pole, left to run off the window, and only the interpolant clamped. Case 14's pre-existing line was to be left alone unless the same change fixed it for free.

- **Change** (`chebyshev_animations_all.jl`):
  - New `ChebyCase` field `poles::Vector{Float64}`, with keyword `poles=Float64[]` on `with_span`; `auto_span` passes `Float64[]`.
  - Case 01 `poles=[1.0]`; Case 02 `poles=[-1.0]`; Case 14 `poles=[-pi / 2, pi / 2]`. The same field fixes Case 14 at no extra cost, so I fixed it too.
  - In `render_case`, for cases with poles, f is drawn unclamped on `sort(vcat(xplot, poles))` with NaN at each pole. It is the Lagrange script's construction (`lagnewt_animations_all.jl`, read only), extended to several poles.
  - The clamping comment now says that in cases 01, 02 and 14 f is not clamped and breaks at each pole.
  - Case 03 (1/(1−x)²) was not given a pole. Both branches go to +∞, so the clamped join lies at the band top, a full window height above the frame, and is not visible. Its frames are unchanged.
  - Gamma cases 24–26 already break at x = 0, because the grid hits 0 exactly and gamma(0) = Inf becomes NaN.
- **Only the expected GIFs changed:**
  - Frame md5s against my previous run (`$F/new` vs `$F/new_poles`): 01, 02 and 14 DIFF; the other 26 are the same.
  - `dump.jl` output (nodes, node values, interpolant, ylims, clamped f array) is byte-identical to the previous run (`cmp exp/dump_poles.tsv exp/dump_new.tsv`). Only the drawn f curve changed.
- **The pole line is gone:**
  - `$F/polecheck.py` counts magenta pixels in a ±2 px column at each pole over the middle 80% of the plot height.
  - Before: 553–562 px per frame (01, 02) and 1087–1124 (14).
  - After: 0 in every frame of 01, 02 and 14.
- **Frames viewed at full size:**
  - 01/frame_001 and 01/frame_010, 02/frame_001 and 02/frame_010: f's branches run off the top and bottom of the window and are not joined.
  - 14/frame_010: no asymptote lines.
- **Nodes:** `nodevis.py exp/dump_poles.tsv new_poles` → `frames=294 nodes=2424 missing=0 frames_without_legend_marker_below_box=0`.
- **Page text:** `index.qmd` has no clamping sentence, and no alt text describes f near a pole. `grep -i 'clamp|pole|window|run off|singular'` finds only the Case 14 caption, "approximation interval [-1.45, 1.45] inside singularities", which stays true (±1.45 < π/2 = 1.5708). The page text is unchanged in this round.

| Location | New text / number | Check | Confirmed |
|---|---|---|---|
| Script comment, render_case | "In cases with poles (01, 02, 14) f is not clamped: it is drawn with a NaN point at each pole, so the curve breaks there and runs off the window instead of joining its two branches." | code path `!isempty(case.poles)` → unclamped `safe_eval`, NaN at poles; polecheck 0 px at all poles; full frames viewed | yes |
| Script field comment | "poles of f inside the plotting window (f is broken there)" | 1 ∈ [-1.6, 1.5]; −1 ∈ [-1.5, 1.6]; ±π/2 ∈ [−π, π] | yes |

## Resolution check (independent checker, not shown this record)

All work is in `check/` (scratch). Scripts: `analyze.jl`, `analyze2.jl` (BigFloat reference), `nodevis.py` and `nodevis_neg.py` (pixel check of every node, plus a negative control), `legacy_cols.py` (positions of the legacy bound lines), `formulas.jl` (stacks the legacy formula images into `legacy/formulas.png`). Frames are in `new/cNN/` and `legacy/LNN/`.

### Original findings

### F1 — resolved
- The script now has `legend=:outerbottom, legend_columns=3`. In every frame of all 29 GIFs the legend box sits at pixel rows 448–474, below the plot box (rows 54–403). It cannot cover data.
- `nodevis.py` maps every node of every frame to pixels. That is 2424 nodes in 294 frames (28 cases × 10 frames, plus 14 for case 08). It uses the plot box detected in each frame and the script's xlims/ylims, and looks for red marker pixels within ±3 px. Result: **0 misses**, and 0 nodes fall outside the y-window. Negative control: shifting every probe by (+15, +15) px gives 2415 misses, so the check does discriminate.
- Full-size views:
  - case 13, frame 1: both nodes visible at (±6.66, 0.93);
  - case 16, frame 1: both nodes visible, including (−1.12, 1.33);
  - case 29, frames 1, 5 and 10: the first Y0 maximum near x ≈ 2.2 is unobstructed;
  - case 27 contact sheet;
  - case 08, frame 14 (32 nodes).

### F2 — resolved
- Case 04 span is now (0, 2) and case 29 span is (0.5, 4). The captions and GIF titles read "interval [0, 2]" and "interval [0.5, 4]".
- Archive check: `Chebyshev.html` says "nodes in [0, 2]" for Module 4 and "[0.5, 4]" for Module 29.
- Legacy `Chebyshevdd.gif`, last frame: the green bounds are at px 13 and 132. With x = 0 at px 13 and 59.6 px/unit, that gives x = 0 and x = 2.0.
- Legacy `Chebyshevccc.gif`, last frame: the bounds are at px 45 and 142, which gives about 0.5 and 4.
- Frames agree with mpmath. Case 04 at n = 2 has nodes 0.293 and 1.707, with √ values 0.541 and 1.307. Case 29 at n = 2 has nodes 1.013 and 3.487, with Y0 values 0.098 and 0.194.

### F3 — resolved
- **Node intervals.** Case 02 is now [-0.9, 1.5] and case 03 is [-1.5, 0.8].
  - My measurement of the legacy last frames: case 02 has its bounds at px 133 and 618, with x = 0 at px 316 and about 202 px/unit, giving −0.906 and 1.495. Case 03 has its bounds at px 20 and 487, with x = 0 at px 325 and about 203 px/unit, giving −1.50 and 0.80.
  - mpmath, interpolating 1/(1−x)² at 16 Chebyshev nodes:
    - on [−1.5, 0.8]: max error 0.02514 and f(b) = 25;
    - on the old [−1.6, 0.9]: max error 1.434 and f(b) = 100.

    This confirms the finding's numbers. The case-03 y-window is now [−1.88, 26.34], set from f on the interval (`ylims_from_span`), so the curve is no longer flattened.
- **Windows.** The xlims of 01, 03 and 07 are now (−1.6, 1.5), 02 is (−1.5, 1.6) and 14 is (−π, π). These match Mathews' formula images exactly (`legacy/formulas.png`). Frames show f on both sides of the pole, and the interpolant extrapolating, in 01, 02, 03 and 14. In 07, f is not real for x > 1, so only the interpolant is shown there, as in Mathews' window.
- The node intervals of 01 and 07 are still [−1.6, 0.9]. The legacy GIFs for those two are missing, so nothing contradicts them. The finding did not ask for a change there.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.32 | Case 02 "interval [-0.9, 1.5]" | script span (-0.9, 1.5); GIF title; legacy bounds measured −0.906 and 1.495 | true |
| index.qmd l.36 | Case 03 "interval [-1.5, 0.8]" | script span; GIF title; legacy bounds −1.50 and 0.80 | true |
| index.qmd l.40 | Case 04 "interval [0, 2]" | script span; GIF title; Chebyshev.html "[0, 2]"; legacy bounds 0 and 2.0 | true |
| index.qmd l.140 | Case 29 "interval [0.5, 4]" | script span; GIF title; Chebyshev.html "[0.5, 4]" | true |
| GIF titles 02/03/04/29 | "interval [-0.9, 1.5]" / "[-1.5, 0.8]" / "[0, 2]" / "[0.5, 4]", "n = k nodes, degree ≤ k−1" | read in full-size frames 1, 5 and 10; node positions agree with mpmath (n = 2: 02 at −0.549/1.149, 03 at −1.163/0.463) | true |
| Script comment l.127–129 | second barycentric form cancels badly outside the nodes; first form stays accurate | BigFloat (1024-bit) Lagrange reference on the same Float64 data. Old (second-form) evaluation gives sign-flipped values in 304 visible points of case 04 (e.g. n=16, x=7.22: −2.7e13 vs +4.4e12) and 417 of case 29 (n=16, x=12.8: −3.8e10 vs +6.2e9). Clamped to the band, these become spurious strokes across the window. New evaluation: 0 mismatches in all 29 cases; worst in-band error 1.3e−10 of window height (case 29). | true |
| Script comment l.222–227 | poles of 01/02/14 drawn with a NaN break; case 03 y-window from the interval | code read; pixel check below | true |
| Script `poles` | 01: [1.0]; 02: [−1.0]; 14: [±π/2] | poles of 1/(1−x), 1/(1+x) and tan | true |

### New problems
None. This rests on:
- **Poles.** In every frame of 01, 02, 14 (and the unchanged 03, 24, 25, 26), the pixel columns at each pole (±2 px) have no magenta pixels in the central 60 % of the plot box. The two branches are not joined.
- **Extrapolation.** The new formula matches the BigFloat reference everywhere in all 29 GIFs. Case 29 at n = 16, mpmath: p(4.6) = −0.185 and p(5.0) = 0.843, matching the blue dip and its exit in frame 10.
- **Frames.** I looked at frames 1, 5 and 10 of 01, 02, 03, 04, 07, 14 and 29, and at 13, 16, 24, 27 (sheet) and 08 (frame 14) for the legend layout. Labels are legible and nothing is clipped. The one cosmetic point is about 40 px of empty white below the legend, which is not a defect.

### Reproducibility and conventions
- `chebyshev_animations_all.jl` was run from a scratch copy (`check/regen/`). All **29 of 29** GIFs are byte-identical (`cmp`) to the working-tree GIFs.
- The page keeps its conventions: Description comes before Animations, there is one source link, there is one embed per case (29) with its caption, and there are no code blocks.
- `git status --porcelain` shows no changes outside `pages/numerical-methods/chebyshev-approximation-polynomial/`.

**Final status:** committed
