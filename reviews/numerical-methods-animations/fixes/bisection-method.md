# Fix record: bisection-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/bisection-method/fix/` (below: `$S`).

Evidence scripts:
- `$S/indep.py`: independent check in exact rationals, sympy and mpmath. Run with `/usr/bin/python3 -I $S/indep.py`. Output is in `$S/indep.out`.
- `$S/instr_aa.jl`, `$S/instr_bb.jl`: the committed scripts' own bisection loops, printing every step. Output is in `$S/instr_*.out`.
- `$S/instr_new_*.jl`: the same loops taken from the fixed scripts.
- `$S/titles_*.jl`: the zoom-panel titles, checked against exact widths.
- `$S/framediff.py`, `$S/framediff_zoom.py`, `$S/pxscale.py`: pixel measurements on extracted frames.
- `$S/before_*/`, `$S/after_*/`: extracted frames of the committed GIFs and the regenerated GIFs.
- `$S/archive/`: legacy images converted to PNG.

## Findings

### F1 — Error — fixed
- **Reproduced.** `indep.py`: sympy `real_roots` gives `[1.365230013414097]` and mpmath `findroot` gives `1.36523001341409684576…`. To 4 dp the root is `1.3652`. `f(1.3688) = 0.0590558…`, so 1.3688 is not a root. The exact-rational final bracket is `[1.364990234375, 1.365234375]`; it contains x* (True) and does not contain 1.3688 (False). `instr_aa.jl` (the script's own loop) gives the same final bracket, `new=[1.364990234375, 1.365234375000]`.
- **Change.**
  - index.qmd:22 `x^* \approx 1.3688` → `x^* \approx 1.3652`.
  - index.qmd:26 alt text `x≈1.3688` → `x≈1.3652`.
  - bisectionaa.jl:3 header comment `True root ≈ 1.3688` → `True root ≈ 1.3652`.
- **Check.** `grep -n 1.3688` on the page folder now finds nothing. 1.365230013 rounds to 1.3652 (mpmath `nstr(r,5)` = `1.3652`). The zoom panel of the last frame (`$S/after_aa/frame_013.png`) shows the curve crossing y = 0 at about 1.36523, inside the shaded final bracket [1.36499, 1.36523].

### F2 — Error — fixed
- **Reproduced.** `indep.py` gives these values:
  - Midpoints: `1.5, 1.25, 1.375, 1.3125, 1.34375, 1.359375, 1.3671875, 1.36328125, 1.365234375, 1.3642578125, 1.36474609375, 1.364990234375`.
  - Signs of successive differences: `-+-+++-+-++`, so the sequence is not monotone.
  - Midpoints above the root: c₁, c₃, c₇, c₉. All the others are below it.
  - `|c_k−x*|` = `0.135, 0.115, 0.00977, 0.0527, 0.0215, 0.00586, 0.00196, 0.00195, 4.36e-06, 0.000972, 0.000484, 0.00024`. This is not monotone either.
  - Bracket widths are `1, 0.5, …, 0.000244140625`, and `widths strictly halving: True`.
  - `bound holds all k: True` for `|c_k − x*| ≤ (b₀−a₀)/2^k`.
- **Change.** index.qmd:22 "The bracket halves each step and the midpoints converge monotonically." → "The bracket width halves each step, so the error bound $|c_k - x^*| \le (b_0 - a_0)/2^k$ shrinks monotonically; the midpoints themselves are not monotone and fall on both sides of the root."
- **Check.** See the ledger rows below. Each clause is confirmed by `indep.py` output.

### F3 — Minor — fixed
- **Reproduced.**
  - **Committed frames.** The committed frames were extracted (`$S/before_aa`, `$S/before_bb`) and the contact sheets and frame 13 were viewed. From frame 8 on, the bracket is a single dashed line in both GIFs.
  - **Pixel diffs.** `framediff.py` counts the pixels changed between consecutive committed frames, outside the legend. From frame 8→9 on, every change falls in a strip about 17 px wide (Case 1 x ∈ [443, 460]; Case 2 x ∈ [430, 456]). The changed pixels there are the moving markers, not a visible bracket.
  - **Bracket width in pixels.** In the new frames' top panel, `pxscale.py` gives 157.5 px per unit for Case 1 (box columns 84–588). The bracket after step 7 is 1.23 px wide and after step 8 it is 0.62 px. For Case 2 the scale is 224.5 px per unit: the bracket is 1.75 px after step 7 and 0.88 px after step 8. Both fall below 1 px from step 8 on.
  - **Finding holds.** The finding is reproduced, so it was fixed under D5. It is not purely cosmetic, because the feature the page describes becomes invisible.
- **Change.**
  - **Second panel.** Both scripts now draw a second panel below the unchanged full view. The new panel zooms on the bracket from before the current step, padded by 10% of its width. It shows:
    - the before-step bracket ends as grey dashed lines, labelled "[a, b] before step k";
    - the after-step bracket shaded, with blue dashed ends labelled "[a, b] after step k";
    - the midpoint at its true f(c_k).
  - **Zoom-panel title.** The title reads "Zoom: step k halves [a, b] of width w", where w is the exact before-step width.
  - **Case 1 y-range.** This is the padded extent of f over the window and at the plotted points.
  - **Case 2 y-range.** The range is ±1.1 × max |f| at the window ends and at the midpoint. As a result, the midpoint is drawn unclamped in the zoom. The tan curve is split at π/2 and leaves the panel near the asymptote.
  - **Frame and margin.** Frame size changed from 600×600 to 600×980 (layout 0.55/0.45). `left_margin=5Plots.mm` was added so that the y labels are not clipped (raised to 9 mm in Round 2, below).
  - **Header comments and helper.** The header comments of both scripts describe the two panels. A helper `shade_bracket!` replaces the inline shading code.
  - **Bisection loop.** The loop is unchanged.
  - **Page text.**
    - index.qmd:15 has one new sentence describing the two panels.
    - The alt text of both GIFs now ends with ", with a lower panel zoomed on each halving".
- **Check.**
  - **Iterates.** `instr_new_*.jl` (the loops from the fixed scripts) give output byte-identical to `instr_*.out` from the committed scripts (`cmp` reports "iterates identical before/after" for both). The computation is unchanged.
  - **Zoom titles.** `titles_*.jl`: every title width equals 2^-(k-1) exactly (true for all k), and the after-step bracket is the half of the before-step bracket that contains c_k (true for all k, both cases).
  - **Zoom panel changes each frame.** `framediff_zoom.py` counts the changed pixels in the zoom panel between consecutive frames from frame 8 on. Case 1: 156030, 153550, 157269, 31966, 31716. Case 2: 158931, 28605, 30122, 31220, 150458. The zoom panel changes visibly in every late frame.
  - **Frames viewed.** These are listed under "Scripts and GIFs".

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:15 | "The top panel shows the full view; the bottom panel zooms in on the bracket from before the current step" | Script: `a_prev = as[max(frame,1)]`, the window is [a_prev, b_prev] padded by 10%. Viewed `$S/after_aa/frame_010.png`, `$S/after_bb/frame_008.png`, `frame_013.png`: the bottom panel spans the grey before-step bracket. | yes |
| index.qmd:15 | "so each halving stays visible" | `titles_*.out`: after-step bracket = half of before-step, for all k. `framediff_zoom_*.out`: ≥ 28605 changed px per late frame. The frames viewed show the shaded half at about 40% of the panel width at every step. | yes |
| index.qmd:15 | "narrower than a pixel in the full view (from step 8 on)" | `/usr/bin/python3 -I $S/pxscale.py …` → Case 1: step 7 1.23 px, step 8 0.62 px. Case 2: step 7 1.75 px, step 8 0.88 px. | yes |
| index.qmd:22 | "$x^* \approx 1.3652$" | `indep.py` → sympy `1.365230013414097`, mpmath `nstr` 5 sig. → `1.3652` | yes |
| index.qmd:22 | "The bracket width halves each step" | `indep.py` → `widths strictly halving: True` (1 → 0.000244140625) | yes |
| index.qmd:22 | "the error bound $\|c_k - x^*\| \le (b_0 - a_0)/2^k$ shrinks monotonically" | `indep.py` → `bound holds all k: True`. The bound 1/2^k is strictly decreasing (0.5 … 0.000244). | yes |
| index.qmd:22 | "the midpoints themselves are not monotone" | `indep.py` → diff signs `-+-+++-+-++` | yes |
| index.qmd:22 | "fall on both sides of the root" | `indep.py` → `side of root (c>x*): [1, 3, 7, 9]`. The others are below. | yes |
| index.qmd:26 alt | "root at x≈1.3652 over 12 steps" | Same root check as above. `n_iters = 12` and the GIF has 13 frames (giftools: "13 frames" = initial + 12 steps). | yes |
| index.qmd:26, :36 alt | "with a lower panel zoomed on each halving" | Same as the index.qmd:15 rows. | yes |
| bisectionaa.jl:3 | "True root ≈ 1.3652" | As above. | yes |
| bisectionaa.jl:4-6, bisectionbb.jl:5-7 | header: "Top panel: full view. Bottom panel: zoom on the bracket before the step, so the halving stays visible after the bracket is narrower than a pixel in the full view." | Same as the index.qmd:15 rows. | yes |
| bisectionbb.jl zoom comment | "y-range is symmetric, ±1.1 × the largest \|f\| at the window ends and the midpoint, so the midpoint is drawn at its true (unclamped) value" | Code: `ymax = 1.1*maximum(abs.(yz_pts))`, and yz_pts includes f(c_k). In frame 13 the dot sits at y ≈ 4.2×10³ (`instr_bb.out`: f(c12) = 4.172122e+03), inside ±2.06×10⁴. | yes |
| GIF zoom titles | "Zoom: initial bracket [1.0, 2.0]"; "Zoom: step k halves [a, b] of width w", with w = 1.0, 0.5, …, 0.00048828125 | `julia $S/titles_aa.jl` / `titles_bb.jl` → `width==2^-(k-1): true` for every k | yes |
| GIF zoom legends | "[a, b] before step k" (grey), "[a, b] after step k" (blue, shaded); frame 0 "bracket [a, b]" | Code: grey = `as[k], bs[k]`, blue = `as[k+1], bs[k+1]` (`a_cur, b_cur` at `frame = k`). This matches `instr_*.out` rows `[a,b]` and `new`. | yes |
| Top-panel labels | unchanged (`c_k = round(c_k, 6)`, etc.) | They have the same code, and the iterates are identical (`cmp`). Frame 13 shows `c_12 = 1.36499` for Case 1 and `c_12 = 1.570557` for Case 2, matching `instr_*.out`. | yes |

## Scripts and GIFs
- **Scripts changed:** `bisectionaa.jl`, `bisectionbb.jl`. Both scripts were regenerated with `julia bisectionaa.jl`, then `julia bisectionbb.jl`, from the page folder.
- **GIFs regenerated:** `bisectionaa.gif` and `bisectionbb.gif`, 13 frames each, 600×978.
- **Frames viewed at full size:**
  - Case 1: frames 1, 10 and 13, plus the contact sheet.
  - Case 2: frames 8 and 13, plus two contact sheets (before and after the y-range change).
- **What the frames show:**
  - **Case 1.** In frame 13, the zoom shows the curve crossing zero inside the shaded final bracket. c₁₂ ≈ 1.36499 is on the left edge, with f(c₁₂) ≈ −0.004 (`instr_aa.out`: −3.959102e-03). In frame 10 (step 9), c₉ sits on the crossing, which agrees with |c₉−x*| = 4.4e-6.
  - **Case 2.** In frame 8 (step 7), c₇ = 1.570312 is just left of the orange asymptote with f ≈ 2067 (`instr_bb.out`: 2.066855e+03). The shaded half lies to its right and contains π/2. In frame 13, the bracket hugs the asymptote.
  - **Labels.** The y labels are no longer clipped after the 5 mm margin. The titles and legends are legible.
- **Earlier iterations (not kept).**
  - A Case 2 y-range that included the before-step bracket ends was dominated by f(b₁₁) = −2.24×10⁵ at step 12.
  - A 3 mm margin clipped the y label.
- **git status of the page folder after regeneration** (`git status --short -- pages/numerical-methods/bisection-method`): `M bisectionaa.gif`, `M bisectionaa.jl`, `M bisectionbb.gif`, `M bisectionbb.jl`, `M index.qmd`. These are exactly the expected files.

## Round 2 after check

The independent resolution check confirmed that F1–F3 are resolved. It reported two new Minor problems in the zoom panel I added. A third problem appeared while fixing them.

### R2.1 — bottom-panel y label clipped (bisectionbb frames 12–13) — fixed
- **Reproduced.** `$S/edges.py` on the Round-1 frames (`$S/after_bb`) shows the zoom panel's leftmost ink at column 0 in frames 12–13. The wide ×10⁴/×10⁵ tick labels pushed the "y" label off the left edge.
- **Change.** Both scripts: `left_margin=5Plots.mm` → `left_margin=9Plots.mm`, together with the fixed-width tick labels from R2.2.
- **Check.** `/usr/bin/python3 -I $S/edges2.py $S/r2_{aa,bb}` gives the zoom panel's leftmost ink at column 7 in all 26 frames, so nothing touches the image edge (`$S/edges_r2_*.out`). The y label is fully visible in the full-size views of aa frames 1 and 13 and bb frames 8 and 13.

### R2.2 — top panel's plot area moved between frames (both GIFs) — fixed
- **Reproduced.** In the Round-1 frames (`$S/edges.py`), the top panel's left box edge moves from 73 to 84 px in aa and from 73 to 94 px in bb, and it matches the zoom panel's edge. Plots aligns the left edges of the two stacked subplots, so the full view followed the width of the zoom panel's tick labels.
- **Change.**
  - Both scripts: `using Printf`, and in the zoom panel `yformatter = y -> @sprintf("%+.2e", y)`. Every zoom tick label now has the same form (sign, 3 significant figures, exponent) and therefore the same width.
  - 3 significant figures cover every tick value Plots chooses. Its tick steps are 1, 2, 2.5, 5 × 10ⁿ, so ticks need at most 3 significant figures (for example 12.5).
  - The top panel's own tick labels are unchanged.
- **Check.**
  - `$S/edges2.py` locates each box edge as a column with a dark vertical run over 80% of the panel height. In all 13 frames of each GIF the top box is at columns 115–588, and the zoom box is at 115–588 too.
  - The tick labels in the viewed frames agree with the plotted values:
    - aa frame 13: the dot at f(c₁₂) = −3.959×10⁻³ (`instr_aa.out`) sits next to the −4.00e−03 tick.
    - bb frame 8: the dot at f(c₇) = 2066.855 (`instr_bb.out`) sits just above +2.00e+03.
    - bb frame 13: the range ends at ±2.00e+04 ticks, inside the computed ±1.1 × 18760 ≈ ±2.06×10⁴.

### R2.3 — Case 2 top title cut at the right edge (found while fixing R2.2) — fixed
- **Problem.** With the narrower plot area, "Bisection Method: f(x) = tan(x)  [cautionary case]" lost its closing "]" at the right edge (viewed in `$S/r2_bb/frame_013.png` before this change).
- **Change.** bisectionbb.jl, top panel: `titlefontsize = 12`. The title text is unchanged.
- **Check.** The title ink in the top 32 rows spans columns 88–570 in every bb frame and 153–550 in every aa frame, so both fit within the 600 px width. The bb frame 8 view shows the full title.

### Round 2 summary
- **Computation.** The bisection loops are untouched. `instr_r2_*.jl` output is byte-identical to the committed scripts' `instr_*.out` (`cmp`: "aa iterates identical", "bb iterates identical"). The zoom titles and legends are unchanged.
- **Regenerated.** `bisectionaa.gif` and `bisectionbb.gif`, 13 frames each.
- **git status** (`git status --short -- pages/numerical-methods/bisection-method`): `M bisectionaa.gif`, `M bisectionaa.jl`, `M bisectionbb.gif`, `M bisectionbb.jl`, `M index.qmd`. These are the expected files. index.qmd was not changed in Round 2.
- **Ledger additions.** No page text changed. The only new visible text is the zoom tick labels, which are formatted from Plots' tick positions and checked against the plotted values above, and the Case 2 title font size.
- **Ledger fix.** A Round-1 ledger row had a slip: "4.2×10⁴/10 ≈ 4172" is now "y ≈ 4.2×10³".

## Legacy archive
Consulted: `n2003/BisectionMod.html`, `bisection/BisectionMod/Links/BisectionMod_lnk_4.html` (Example 3) and `_lnk_5.html` (Example 4). Images gr_647, 648, 809–812, 813, 814 and 903 were viewed.

- **Example 3, "Convergence".**
  - Function: x³ + 4x² − 10 = 0, with starting interval [a, b] = [−1, 2].
  - The last iterate is c = 1.365230014082044 with Δc = ±1.39698×10⁻⁹ and f[c] = 1.103008440139774×10⁻⁸.
  - The graph uses x ∈ [−1, 2] and y ∈ [−10, 15].
  - This agrees with the corrected root, 1.36523001341…: |1.365230014082044 − x*| = 6.7×10⁻¹⁰ ≤ Δc. Mathews' value is consistent with x* ≈ 1.3652 and not with the old 1.3688.
- **Example 4, "Not a root located".**
  - Function: Tan[x] = 0, with starting interval [a, b] = [0, 2].
  - The note says: "The bisection method located a pole of tan(x)… where the graph has a vertical asymptote."
  - The graph uses x ∈ [0, 2] and y ∈ [−15, 15].
- **Differences from the page.**
  - **Starting intervals.** The page uses [1, 2] for both cases, while Mathews used [−1, 2] and [0, 2]. This difference predates this fix and was not part of any finding. The page's intervals are valid: the sign change holds and the behaviour is as described. Under "smallest correct change" I did not alter them.
  - **Case 2 endpoint.** Mathews' [0, 2] has f(0) = 0 at its left endpoint. The page's [1, 2] avoids that degenerate endpoint.
  - **Iteration count.** Mathews ran about 31 steps (3/2³¹ = 1.397×10⁻⁹ matches his Δc for a width-3 interval). The page uses 12.
  - **Decision needed.** If Jason wants archive fidelity for the intervals, that is a separate decision.

## Notes
- **D5 and D7.** D5 applied to F3: the finding reproduced and the fix was cheap and safe, so it was done. The animation was changed rather than only the text, because the finding says the described feature is invisible. D7 does not settle this case, because the text was not wrong there.
- **Intro sentence, Case 2.** This is pre-existing and was not part of any finding. The intro says "The shaded region marks the current bracket $[a, b]$ that is known to contain a root (by the Intermediate Value Theorem)". That is not true for Case 2, where tan has no zero in [1, 2]. The Case 2 paragraph itself explains this. It was left untouched as outside the findings; Jason may want "contains a sign change".
- **Top-panel clamping, Case 2.** This is pre-existing. The top panel clamps f(c_k) to ±15. For example, the c₁₂ dot is drawn at y = 15 while f(c₁₂) = 4172. The label shows only c_k, so no false number is printed, and the new zoom panel shows the true value. It was left as is.
- **Description section.** This is pre-existing. The page has no `## Description` section, which the conventions file asks for. Adding one would be new teaching content, so I did not add it.
- **Margin label.** At frame 0 (Case 1), the top-panel annotation "Initial bracket [1.0, 2.0]" touches the right frame edge. This was also the case before the fix. It is cosmetic and was not changed.

## Resolution check (independent checker, not shown this record)

Work files (all in this folder): `indep.py` (sympy/mpmath/exact-rational bisection, both cases), `px.py` (pixel scale of the top panel), `run/` (scratch copies of both scripts, re-run), `frames_bisectionaa/`, `frames_bisectionbb/` (all 13 frames, contact sheets, framemd5), `crop*.png` (enlarged left edges of zoom panels).

### Original findings

### F1 — resolved
- Evidence: index.qmd:22 now says $x^* \approx 1.3652$, the Case 1 alt text says "x≈1.3652", and bisectionaa.jl:3 says "True root ≈ 1.3652". The string 1.3688 no longer appears anywhere in the page folder. sympy `real_roots(x^3+4x^2-10)` gives the single real root 1.3652300134140968458, and mpmath `findroot` gives 1.36523001341409684576. Both round to 1.3652. The exact-rational bisection ends with the bracket [1.364990234375, 1.365234375], which contains the root, so the text now agrees with the last frame. The last frame's bottom panel shows the curve crossing y = 0 inside the shaded final bracket, right at its right edge (the root is 4.4e-6 below b), and the legend reads c_12 = 1.36499. Both match.

### F2 — resolved
- Evidence: The phrase "midpoints converge monotonically" is gone. The new sentence says the bracket width halves each step, so the error bound $|c_k - x^*| \le (b_0-a_0)/2^k$ shrinks monotonically, while the midpoints are not monotone and fall on both sides of the root. I checked each part separately:
  - The bound holds for every k from 1 to 12. For example, at k = 10 the error is 9.72e-4 against a bound of 9.77e-4, and at k = 12 it is 2.40e-4 against 2.44e-4.
  - The bound 2^-k is strictly decreasing.
  - The midpoints are neither increasing nor decreasing.
  - The sides are + − + − − − + − + − − −, so the midpoints do fall on both sides of the root.

### F3 — resolved
- Evidence: Each GIF is now 600×980 px with two panels.
  - **Top panel:** the original full view, unchanged.
  - **Bottom panel:** a zoom on the bracket from before the step, padded by 10% of its width on each side. It shows that bracket as gray dashed lines, the bracket after the step as blue dashed lines with shading, and the midpoint with its value of f.
  - **What I saw:** the full-size frames 1, 7 and 13 and both contact sheets show a visible halving at every step through step 12 in both cases. The final bracket's position relative to the root is now visible in Case 1. In Case 2 the asymptote line is visible inside the final bracket, separate from b.
  - **Zoom titles:** the "width" in each title is the bracket width before the step, 2^-(k-1): 0.03125 at step 6 and 0.00048828125 at step 12. Both are correct.
  - **Plotted values:** Case 1 step 6 has c = 1.359375, f = −0.096 and bracket [1.359375, 1.375]. Case 2 step 6 has c = 1.578125, tan = −136.4. Case 2 step 12 has c = 1.570557, tan = 4172. All agree with my independent bisection.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:15 | "top panel shows the full view; the bottom panel zooms in on the bracket from before the current step" | Script code (`a_prev = as[max(frame,1)]`) and frames: the gray lines are the previous bracket, and frame 0 shows the initial bracket | correct |
| index.qmd:15 | "narrower than a pixel in the full view (from step 8 on)" | Measured plot box: Case 1 is 157.5–160.9 px/unit, so the bracket is 1.23–1.26 px after step 7 and 0.62–0.63 px after step 8. Case 2 is 224.5–233.2 px/unit, so it is 1.75–1.82 px after step 7 and 0.88–0.91 px after step 8. | correct for both cases |
| index.qmd:22 | $x^* \approx 1.3652$ | sympy and mpmath give 1.36523001341… | correct |
| index.qmd:22 | "bracket width halves each step" | exact-rational widths are 2^-k | correct |
| index.qmd:22 | $\lvert c_k - x^*\rvert \le (b_0-a_0)/2^k$, "shrinks monotonically" | Holds for k = 1…12 (computed). It is also true by construction: c_k is the midpoint of a bracket of width 2^-(k-1). | correct |
| index.qmd:22 | "midpoints themselves are not monotone and fall on both sides of the root" | The sign pattern of c_k − x* is mixed | correct |
| index.qmd:26 alt | "x≈1.3652 over 12 steps, with a lower panel zoomed on each halving" | n_iters = 12, and the frames show the zoom | correct |
| index.qmd:36 alt | "… with a lower panel zoomed on each halving" | Frames show it. The final bracket [1.570556640625, 1.57080078125] contains π/2. | correct |
| bisectionaa.jl:3 | "True root ≈ 1.3652" | as above | correct |
| bisectionaa.jl:4-6, bisectionbb.jl:5-7 | header comment describing the panels | matches the code and frames | correct |
| bisectionbb.jl zoom comment | "y-range symmetric ±1.1 × largest \|f\| at window ends and midpoint … midpoint drawn at its true (unclamped) value" | Code matches. The red dots sit at −136 and 4172 in frames 7 and 13. | correct |
| zoom titles / legends (both scripts) | "Zoom: initial bracket [1.0, 2.0]", "Zoom: step k halves [a, b] of width 2^-(k-1)", "[a, b] before/after step k" | Checked against the exact-rational brackets for all steps | correct |

### New problems

### N1 — Minor — The y-axis label in the Case 2 zoom panel is clipped in the last two frames
- Location: bisectionbb.gif frames 12–13 (steps 11–12), bottom panel. The cause is in bisectionbb.jl: the tick labels `1.0×10^5` / `2.0×10^4` are wide, and `left_margin=5Plots.mm` is not enough.
- Evidence: in `cropbb_012.png` and `cropbb_013.png`, only the right half of the "y" glyph shows at the left image edge. In Case 1 (`cropaa_013.png`) the label is fully visible. This is cosmetic only; no number or tick is affected.

### N2 — Minor — The top (full-view) panel's plot area shifts horizontally between frames
- Location: both GIFs. Both panels share the left edge, and that edge follows the width of the zoom panel's y tick labels.
- Evidence (`px.py`): the left edge of the top panel's box moves from 73 px to 84 px in Case 1 and from 75 px to 94 px in Case 2 across frames, while the right edge stays at 588 px. So the "fixed" full view rescales by up to about 4% from frame to frame and jitters slightly. This is cosmetic; nothing drawn is wrong.

No error-level or misleading new problem. This rests on:
- my independent root and bisection computation for both cases;
- full-size frames 1, 7 and 13 and the contact sheets of both GIFs;
- the pixel-width measurement above.

### Reproducibility and conventions

- **Reproducibility:** I copied both changed scripts to `check/run/` and ran them with the global environment. Both regenerated GIFs are byte-identical to the working-tree GIFs (`cmp`). The sha256 hashes are ac8d94c5… for aa and 08af2163… for bb, and they match the new LFS oids in the diff. Each GIF has 13 frames.
- **Conventions:**
  - Each case has a source link and a GIF embed.
  - Both alt texts are descriptive.
  - There are no code blocks.
  - The fix keeps the Animations section intact.
- **Pre-existing gap:** the page has no `## Description` section before `## Animations`. The convention requires one, but the page also lacked it at HEAD, so the fix did not introduce it and it was not among the findings. I am noting it only.
- **GIF size:** the GIFs grew from 53 KB to 433 KB and from 65 KB to 526 KB because the frames are taller and have two panels. That is acceptable.
- **Files outside the page folder:** the working tree also changes the fixed-point-iteration and runge-kutta-method folders and `pages/numerical-methods/index.qmd`. The index change alters three links: Milne-Simpson, Predictor-Corrector and Shooting Methods. None of these touch bisection, and they appear to belong to other pages' fixes. The bisection fix itself changes only files inside `pages/numerical-methods/bisection-method/`.

### Re-check

The fixer's update changed only the two scripts and their GIFs; index.qmd is unchanged since the first check.
- Both scripts now load `using Printf`.
- The zoom panel's y ticks use `yformatter = y -> @sprintf("%+.2e", y)` (bottom panel only).
- The `left_margin` went from 5 mm to 9 mm.
- bisectionbb.jl sets `titlefontsize = 12` on the top panel.

The computational code (the bisection loop, the plotted quantities, the zoom windows) is untouched. Work files are in `run2/` (scratch copies, re-run), `frames2_bisectionaa/` and `frames2_bisectionbb/` (all 13 frames each), and `px2.py`.

### Original findings
- **F1 — still resolved.** The text is unchanged (1.3652). The full-size frame 13 of aa shows c_12 = 1.36499, and the final shaded bracket has the zero crossing at its right edge, which is consistent with x* = 1.3652300.
- **F2 — still resolved.** The text is unchanged and was verified earlier (the bound holds for k = 1…12, and the midpoints are mixed-side).
- **F3 — still resolved.** The zoom panel shows each halving for steps 1–12 in both cases (both contact sheets, and full-size frames 1, 7 and 13 of each GIF). The page claim "narrower than a pixel in the full view (from step 8 on)" still holds with the narrower plot area. The plot box is 115–588 px, i.e. 473 px.
  - Case 1: 147.8 px/unit, so the bracket is 1.15 px after step 7 and 0.58 px after step 8.
  - Case 2: 215 px/unit, so it is 1.68 px after step 7 and 0.84 px after step 8.

### Earlier new problems
- **N1 (clipped y label in Case 2 zoom) — resolved.** In all 26 frames, the leftmost inked column is column 7, and the full-size frames 1, 7 and 13 of bb show the whole "y" glyph left of the tick labels. The tick labels `+2.00e+04` etc. are fully inside the image.
- **N2 (top-panel jitter) — resolved.** `px2.py` measured the plot-box columns of both panels in every frame of both GIFs. Top and bottom are both (115, 588) in all 13 frames of aa and all 13 frames of bb, so there is zero movement.

### Tick labels and titles
- **Zoom tick labels:** they read correctly against the data.
  - Case 1 step 6: −4.00e−01 … +2.00e−01, with the red dot at −0.096. The true f(1.359375) is −0.0958.
  - Case 1 step 12: −8.00e−03 … 0, with the dot at −4.0e−3. The true value is −3.94e−3.
  - Case 2 step 6: ±1.50e+02, with the dot at −136. The true tan is −136.4.
  - Case 2 step 12: ±2.00e+04, with the dot at about 4.2e3. The true tan is 4172.
- **Tick legibility:** the labels are legible at full size. Using sci notation for O(1) values (e.g. "+5.00e−01") is less friendly than plain decimals, but it is correct and it is what keeps the edge fixed.
- **Case 2 title:** it now fits fully above the plot area at 12 pt.
- **Zoom titles and legends:** unchanged and correct.

### Reproducibility
Scratch copies in `run2/` regenerate both GIFs **byte-identical** to the working tree (`cmp`):
- aa sha256 f3d1aca0…
- bb sha256 dd505110…

Each GIF has 13 frames, 600×978. The GIF sizes are now 343 KB and 376 KB.

### New problems
None introduced by this update. This rests on:
- the per-frame box measurement;
- the leftmost-ink check;
- full-size frames 1, 7 and 13 of both GIFs and both contact sheets;
- the tick values checked against independent values of f.

One pre-existing cosmetic note, not introduced by either fix: in frame 0 of Case 1, the top-panel annotation "Initial bracket [1.0, 2.0]" runs across the dashed line at x = 2. The text stays readable. The same thing was in the pre-fix layout.

**Final status:** committed
