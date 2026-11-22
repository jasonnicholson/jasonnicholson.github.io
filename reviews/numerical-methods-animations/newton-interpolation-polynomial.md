# Newton Interpolation Polynomial — animation review

Page: [`pages/numerical-methods/newton-interpolation-polynomial/index.qmd`](../../pages/numerical-methods/newton-interpolation-polynomial/index.qmd) · Scripts: `lagnewt_animations_all.jl`, `newtpolyaa.jl`, `newtpolybb.jl` · GIFs: 31

**Result:** 2 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Roundoff in the barycentric evaluation draws spurious vertical bars in lagnewt04 (degree 15) and lagnewt29 (degrees 13, 15)

- **Location:** `lagnewt_animations_all.jl:116-131` (`barycentric_eval`, the second "true" barycentric form `num/den`), used at `:189` for every plotted x in `xlims`, including x far outside the node hull. Affects `lagnewt04.gif` frame 10, and `lagnewt29.gif` frames 9 and 10.
- **Now:** Where the plot window runs far past the last node (case 04: nodes in [0.06, 1.94], window to 10.5; case 29: nodes in [0.605, 3.895], window to 22), the second-form formula `Σ(w_j y_j/(x−x_j)) / Σ(w_j/(x−x_j))` loses all accuracy when extrapolating. It returns values of the wrong sign and magnitude. The true polynomial there is huge and positive, so it should sit clamped at the top edge. The script's value jumps between large negative and large positive garbage, so after clamping the frames show dense blue vertical bars crossing the whole window: x ≈ 5.7–5.8 and 9.6–10.5 in case 04, and x ≈ 10.6–22 in case 29. A viewer would read these bars as a degree-13/15 polynomial oscillating wildly through f(x) far from the nodes. The real interpolant does not do this: it rises monotonically off the top of the window.
- **True:** The exact interpolant (60-digit Newton divided differences) at the same nodes is, for example: case 04 deg 15: P(7.0) = +6.334e10, P(10.5) = +6.912e13 (script: −1.717e9, −9.645e9). Case 29 deg 15: P(15.0) = +3.964e10, P(22.0) = +3.067e13 (script: −9.98e7, −6.91e7). Case 29 deg 13: P(15.4374) = +1.793e9 (script −3.889e9 on the plot grid).
- **Evidence:** `reviewer/dump_grid.jl` dumps the script's unclamped interpolant on the 1000-point plot grid for every case and degree. `reviewer/check_grid.py` (`/usr/bin/python3 -I`) recomputes the interpolant independently in mpmath (Newton form, data from mpmath's own f) and compares after clamping both to the frame's ylims. The max clamped difference divided by the y-range is ≤1e-9 for all 290 (case, degree) frames **except** 04/n=16 (1.0, 450 of 1000 grid points on the wrong side), 29/n=14 (1.0, 44 points) and 29/n=16 (1.0, 488 points). `reviewer/check_flip.py` lists the points. `reviewer/fix_check.jl` shows that plain Float64 Newton divided differences with Horner evaluation, and also the first-form (modified Lagrange) barycentric formula, both agree with the BigFloat value to ~1e-10 relative at these points. The second form does not. Viewed frames: `committed/lagnewt04/frame_010.png`, `committed/lagnewt29/frame_009.png`, `frame_010.png` all show the bars.
- **Suggested fix:** Evaluate with divided differences and nested (Horner) evaluation. This is what the Newton page describes, and `newtpolyaa.jl` already has the code. Alternatively use the first-form barycentric formula `ℓ(x)·Σ w_j y_j/(x−x_j)`. Either fixes the bars. Restricting the interpolant curve to the node interval would also hide them. Regenerate lagnewt04 and lagnewt29 (and the Lagrange page's copies).

- **Independent check:** confirmed. Checker: a 512-bit reference over all 29 cases × 10 frames finds exactly these three bad frames (lagnewt04 frame 10, lagnewt29 frames 9 and 10).

### F2 — Error — Page match — "increases polynomial degree one step at a time" is false after degree 5

- **Location:** index.qmd:24, "Each animation increases polynomial degree one step at a time for a fixed function and interval."
- **Now:** The page says the degree goes up by one per frame.
- **True:** `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]` (`lagnewt_animations_all.jl:159`), so the degrees shown are 1, 2, 3, 4, 5, 7, 9, 11, 13, 15, and the step is 2 after degree 5. Each GIF has 10 frames.
- **Evidence:** Script line 159. The frame titles in `committed/lagnewt08/sheet.png` read "degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15". The manifest gives n_frames = 10 for all 29.
- **Suggested fix:** Change the sentence to "Each animation shows the interpolant on 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1–5, then 7, 9, 11, 13, 15) for a fixed function and node interval." Alternatively change the script to `n_nodes_seq = 2:16`.

- **Independent check:** confirmed. Checker: Error is fair, though the impact is small.

### F3 — Minor — Page match — The linked "Newton" source never forms divided differences; it evaluates barycentric Lagrange

- **Location:** index.qmd:26 "[Julia source for all cases](lagnewt_animations_all.jl)" together with the page title, the Description (lines 12–18) and every alt text ("Newton interpolation animation for case NN …").
- **Now:** The page presents the animations as Newton interpolation and links one source file. That file builds barycentric weights and evaluates the barycentric Lagrange formula (`barycentric_weights`, `barycentric_eval`, lines 104–131). It contains no divided-difference table and no nested evaluation. The GIF titles say only "Interpolation Case NN".
- **True:** The plotted polynomial is mathematically the same Newton interpolant, and the page correctly says the two forms give the same polynomial (line 18). So the curves are right, apart from F1. The page never says the script uses divided differences, so this is not a false statement. But a reader who opens the only source linked from the Newton page to see divided differences will find none, and the one place where the representation matters numerically (F1) comes from the Lagrange-form evaluator.
- **Evidence:** Read of `lagnewt_animations_all.jl` (whole file). The script header (line 2) says it is shared with the Lagrange page.
- **Suggested fix:** Either switch the evaluator to divided differences plus Horner, which also fixes F1, or add one sentence under "Animations": "The shared script evaluates this same polynomial in barycentric Lagrange form; see the Description for the Newton form."

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — newtpolybb.gif titles every frame "Runge Phenomenon", but frames 0–9 show extrapolation, not Runge oscillation (orphan file)

- **Location:** `newtpolybb.jl:40-50`. The nodes are `all_xs[1:n+1]`, a prefix of 11 equally spaced points on [−1, 1]. The title is "Runge Phenomenon: Newton Polynomial, degree $n".
- **Now:** For n < 10 the nodes cover only [−1, −1+0.2n]. The large swings to the right of the last node in frames 0–9 come from extrapolating beyond the data, not from the Runge phenomenon, which is about equally spaced nodes spanning the whole interval. Only the last frame (n = 10) shows the Runge phenomenon.
- **True:** The final frame is correct. The independent mpmath divided-difference coefficients match the script's to 12 digits (both end in ±220.941742081). The degree-10 interpolant overshoots to 1.9589 at x ≈ ±0.94, with max error 1.9156, which is the known value for 11 equispaced Runge nodes.
- **Evidence:** `reviewer/newtpolybb_dump.jl` (script coefficients, node residual 1.4e-13, max |P−f| = 1.9156 at x = 0.9399). `reviewer/check_newtpoly.py` (independent coefficients). `committed/newtpolybb/sheet.png`.
- **Suggested fix:** This matters only if the GIF is embedded, since it is currently an orphan (already in inventory). If it is kept, use n+1 equally spaced nodes over all of [−1, 1] in each frame, or retitle frames 0–9.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `lagnewt_animations_all.jl` | yes | 18.8 | 29 GIFs |
| `newtpolyaa.jl` | yes | 2.8 | newtpolyaa.gif |
| `newtpolybb.jl` | yes | 2.9 | newtpolybb.gif |

Committed GIFs byte-identical to their regenerated output: **31 of 31**. Decoded frames were also compared; all match.

Inventory findings:

- script newtpolyaa.jl on disk is not linked from the page
- script newtpolybb.jl on disk is not linked from the page
- committed GIF newtpolyaa.gif is not embedded/referenced by the page
- committed GIF newtpolybb.gif is not embedded/referenced by the page

## Claim ledger

Scope: Description and Animations sections. The page states no function, interval or node count for any case, so each case row checks the wiring (heading → embed → GIF) and the GIF title against the script's table row. Script parameters are from the case table (lines 22–52) and `resolved_span`/`equal_nodes`. The node range is for 16 nodes, as printed by `reviewer/dump_lagnewt.jl`. Nodes are always trimmed 3% inside the span at each end (checked for all 290 frames). Titles were read from full-size `frame_010.png` for every case (frame_009 also for case 29). A ✓ in "f values & interpolant" means `check_newton.py`/`check_grid.py` confirm that f at the nodes matches an independent mpmath f to ≤4e-16 relative, nodes are equally spaced to ≤3e-15, the independent Newton interpolant reproduces the data, and the plotted curve agrees with it to ≤1e-9 of the y-range in all 10 frames.

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | 12–15 | "Newton interpolation represents the interpolating polynomial in divided-difference form, P_n(x)=a_0 + a_1(x−x_0)+…+a_n∏_{j=0}^{n−1}(x−x_j)" | Standard Newton form, correct. Implemented in newtpolyaa/bb.jl and checked numerically. Not implemented in the linked script (F3). | confirmed (formula); see F3 |
| D2 | 18 | "where a_k=f[x_0,…,x_k] are divided differences" | Correct. newtpolyaa/bb `divided_diff` returns exactly f[x_0..x_k], matching independent mpmath values to 12 digits. | confirmed |
| D3 | 18 | "For the same nodes and data, Newton and Lagrange forms produce the same polynomial; they differ only in representation and numerical workflow." | Uniqueness of the interpolant. The script's barycentric values match the independent Newton values to ≤1e-9 of plot range wherever accurate. F1 is an example of "numerical workflow" mattering. | confirmed |
| D4 | 20 | "The 29 animations below intentionally reuse the same interpolation cases as the Lagrange page" | Lagrange page embeds lagnewt01–29 (29 embeds). Script and all 29 GIFs are byte-identical across the two folders. | confirmed |
| D5 | 20 | "29 animations" | 29 embeds, 29 GIFs, script makes 29. | confirmed |
| D6 | 15 / 146 | Nested form | The Description gives no nested-form formula. It is mentioned only in the Planned section, which is out of scope. | n/a |
| A1 | 24 | "Each animation increases polynomial degree one step at a time" | Degrees 1,2,3,4,5,7,9,11,13,15 | wrong (→ F2) |
| A2 | 24 | "for a fixed function and interval" | f, xlims and node span are fixed per case. Nodes are re-spaced over the same span each frame. | confirmed |
| A3 | 26 | "[Julia source for all cases](lagnewt_animations_all.jl)" | The link resolves and the script produces all 29 GIFs byte-identically (manifest). It contains no Newton code. | confirmed (wiring); see F3 |
| A4 | all alt texts | "Newton interpolation animation …" | The curve is the Newton interpolant mathematically. The code uses barycentric Lagrange. | confirmed with caveat (F3) |
| C01 | 28–30 | Case 01 → lagnewt01.gif | Script: 1/(1−x), xlims [−1.6,0.9], nodes [−1.525,0.825]. Title "Interpolation Case 01: f(x) = 1/(1-x), degree 15". ✓ | confirmed |
| C02 | 32–34 | Case 02 → lagnewt02.gif | 1/(1+x), [−0.9,1.6], nodes [−0.825,1.525]. Title "Case 02: f(x) = 1/(1+x)". ✓ | confirmed |
| C03 | 36–38 | Case 03 → lagnewt03.gif | 1/(1−x)^2, [−1.6,0.9], nodes [−1.525,0.825]. Title "Case 03: f(x) = 1/(1-x)^2". ✓ | confirmed |
| C04 | 40–42 | Case 04 → lagnewt04.gif | sqrt(x), xlims [0,10.5], span [0,2], nodes [0.06,1.94]. Title "Case 04: f(x) = sqrt(x)". Frames 1–9 ✓. Frame 10 has spurious bars. | confirmed (wiring/title); picture wrong in frame 10 (→ F1) |
| C05 | 44–46 | Case 05 → lagnewt05.gif | sqrt(x), [0,10.5], span [0,8], nodes [0.24,7.76]. Title "Case 05: f(x) = sqrt(x)". ✓ | confirmed |
| C06 | 48–50 | Case 06 → lagnewt06.gif | sqrt(x), [0,10.5], span [0,10], nodes [0.30,9.70]. Title "Case 06: f(x) = sqrt(x)". ✓ | confirmed |
| C07 | 52–54 | Case 07 → lagnewt07.gif | 1/sqrt(1−x), [−1.6,0.9], nodes [−1.525,0.825]. Title "Case 07: f(x) = 1/sqrt(1-x)". ✓ | confirmed |
| C08 | 56–58 | Case 08 → lagnewt08.gif | 1/(1+10x^2), xlims [−1.5,1.5], span [−1,1], nodes [−0.94,0.94]. Title "Case 08: f(x) = 1/(1+10x^2)". All 10 titles read from sheet. ✓ | confirmed |
| C09 | 60–62 | Case 09 → lagnewt09.gif | log(x), [−0.5,4.1], span [0.02,2], nodes [0.0794,1.9406]. Title "Case 09: f(x) = log(x)". ✓ | confirmed |
| C10 | 64–66 | Case 10 → lagnewt10.gif | log(x), [−0.5,4.1], span [0.02,4], nodes [0.1394,3.8806]. Title "Case 10: f(x) = log(x)". ✓ | confirmed |
| C11 | 68–70 | Case 11 → lagnewt11.gif | log(1+x), [−1.5,1.5], span [−0.98,1], nodes [−0.9206,0.9406]. Title "Case 11: f(x) = log(1+x)". ✓ | confirmed |
| C12 | 72–74 | Case 12 → lagnewt12.gif | sin(x), [−3π,3π], nodes [−8.859,8.859]. Title "Case 12: f(x) = sin(x)". ✓ | confirmed |
| C13 | 76–78 | Case 13 → lagnewt13.gif | cos(x), [−3π,3π], nodes [−8.859,8.859]. Title "Case 13: f(x) = cos(x)". ✓ | confirmed |
| C14 | 80–82 | Case 14 → lagnewt14.gif | tan(x), [−π,π], nodes [−2.953,2.953]. Title "Case 14: f(x) = tan(x)". ✓ (the magenta vertical lines at ±π/2 are the line joining clamped values across the poles, which reads as an asymptote) | confirmed |
| C15 | 84–86 | Case 15 → lagnewt15.gif | exp(x), [−2,3], nodes [−1.85,2.85]. Title "Case 15: f(x) = exp(x)". ✓ | confirmed |
| C16 | 88–90 | Case 16 → lagnewt16.gif | cos(x)·exp(−x), [−2,4], nodes [−1.82,3.82]. Title "Case 16: f(x) = cos(x)*exp(-x)". ✓ | confirmed |
| C17 | 92–94 | Case 17 → lagnewt17.gif | cosh(x), [−4,4], nodes [−3.76,3.76]. Title "Case 17: f(x) = cosh(x)". ✓ | confirmed |
| C18 | 96–98 | Case 18 → lagnewt18.gif | atan(x), [−2.2,2.2], nodes [−2.068,2.068]. Title "Case 18: f(x) = atan(x)". ✓ | confirmed |
| C19 | 100–102 | Case 19 → lagnewt19.gif | asin(x), xlims [−1.5,1.5], finite support → span [−0.9993,0.9993], nodes [−0.9394,0.9394]. Title "Case 19: f(x) = asin(x)". ✓ | confirmed |
| C20 | 104–106 | Case 20 → lagnewt20.gif | besselj(0,x), [−10.2,10.2], nodes [−9.588,9.588]. Title "Case 20: f(x) = besselj(0,x)". ✓ | confirmed |
| C21 | 108–110 | Case 21 → lagnewt21.gif | besselj(1,x), [−10.2,10.2], nodes [−9.588,9.588]. Title "Case 21: f(x) = besselj(1,x)". ✓ | confirmed |
| C22 | 112–114 | Case 22 → lagnewt22.gif | exp(−x²/2)/√(2π), [−3,3], nodes [−2.82,2.82]. Title "Case 22: f(x) = normal_pdf(x)". ✓ (formula equals mpmath `npdf`) | confirmed |
| C23 | 116–118 | Case 23 → lagnewt23.gif | ½+½erf(x/√2), [−3,3], nodes [−2.82,2.82]. Title "Case 23: f(x) = normal_cdf(x)". ✓ (equals mpmath `ncdf`) | confirmed |
| C24 | 120–122 | Case 24 → lagnewt24.gif | gamma(x), xlims [−0.2,5.2], span [0.05,2], nodes [0.1085,1.9415]. Title "Case 24: f(x) = gamma(x)". ✓ | confirmed |
| C25 | 124–126 | Case 25 → lagnewt25.gif | gamma(x), span [0.05,4], nodes [0.1685,3.8815]. Title "Case 25: f(x) = gamma(x)". ✓ | confirmed |
| C26 | 128–130 | Case 26 → lagnewt26.gif | gamma(x), span [0.5,5], nodes [0.635,4.865]. Title "Case 26: f(x) = gamma(x)". ✓ | confirmed |
| C27 | 132–134 | Case 27 → lagnewt27.gif | bessely(0,x), xlims [0,22], span [0.5,20], nodes [1.085,19.415]. Title "Case 27: f(x) = bessely(0,x)". ✓ | confirmed |
| C28 | 136–138 | Case 28 → lagnewt28.gif | bessely(0,x), span [0.5,10], nodes [0.785,9.715]. Title "Case 28: f(x) = bessely(0,x)". ✓ | confirmed |
| C29 | 140–142 | Case 29 → lagnewt29.gif | bessely(0,x), span [0.5,4], nodes [0.605,3.895]. Title "Case 29: f(x) = bessely(0,x)". Frames 1–8 ✓. Frames 9–10 have spurious bars. | confirmed (wiring/title); picture wrong in frames 9–10 (→ F1) |

Note: the case headings and alt texts name no function or interval ("from the legacy function-and-interval list"). Only the GIF title identifies the function, and nothing on the page or in any title tells cases 04/05/06, 09/10, 24/25/26 or 27/28/29 apart (they differ only in node span). This is missing content, not a false claim, so it is not listed as a finding.

## Implementation checks

### lagnewt_animations_all.jl
- **Method:** Polynomial interpolation at n equally spaced nodes, n ∈ {2,3,4,5,6,8,10,12,14,16}, placed on the case's node span shrunk by 3% of its width at each end (the trim attempt loop never needed to go past attempt 0: trim = 0.030/0.030 in all 290 frames). The span is the case's `node_span`, or `xlims` for auto cases, intersected with the numerically finite part of f on a 2200-point grid. This matters only for asin, giving [−0.9993, 0.9993]. Evaluation uses barycentric Lagrange (weights w_j = 1/∏(x_j−x_k), second/"true" form num/den, exact node values returned within 1e-12). This is a valid way to evaluate the unique interpolant, but it is not Newton divided differences (F3). The plotted interpolant is clamped to the ylims, and f is clamped likewise.
- **Numbers:** `reviewer/dump_lagnewt.jl` prints, for all 29×10 frames, the nodes, y values and the interpolant at 7 check points. `reviewer/check_newton.py` uses independent mpmath f (its own sqrt/log/tan/besselj/bessely/gamma/npdf/ncdf…) and a 60-digit divided-difference table with nested evaluation. Results: script y-values equal f(nodes) to ≤2.5e-15 relative in every frame. Nodes are equally spaced to ≤3e-15. The independent Newton polynomial reproduces the data to ≤1e-55. At interior points script and independent values agree to ~1e-12. Larger differences appear only at extrapolation points beyond the window (e.g. 24/n=16: 3e-2 relative, 28/n=16: 1e-2). These are clamped off-screen and do not change the picture. The exceptions that do change it are 04/n=16 and 29/n=14,16 (F1). Representative independent values: case 04 deg 15 P(10.5) = 6.9120111431673e13 (BigFloat Newton) vs script −9.645e9; first-form barycentric 6.91201114169e13 and Float64 Newton 6.91201114315e13 both correct.
- **Reference values:** f(x) curves checked against mpmath at all nodes (above). normal_pdf/normal_cdf formulas equal the standard ones. Labels match the lambdas for all 29 rows.
- **Picture:** Viewed full-size frame_010 for all 29 cases, frame_009 for case 29, and the full contact sheet for case 08. Titles match the case table and show degree = nodes−1 (sheet for 08 shows 2…16 red nodes with degrees 1…15). Red nodes lie on f. The blue curve passes through them. Clamping shows the off-scale interpolant as a flat run along the top or bottom edge, which reads acceptably as "off scale". `reviewer/check_grid.py` confirms that the plotted (clamped) curve equals the exact interpolant to ≤1e-9 of the y-range in 287 of 290 frames. The 3 failing frames show spurious vertical bars (F1).

### newtpolyaa.jl (orphan: not linked or embedded; recorded in inventory)
- **Method:** Genuine Newton form: in-place divided-difference table plus Horner nested evaluation. cos(x) on [0, 2π]. Frame n uses the first n+1 of 7 equally spaced nodes (step π/3), so nodes are added incrementally. This is the natural Newton "add one node" demo, and the header comment matches it.
- **Numbers:** Script coefficients [1.0, −0.477464829276, −0.227972663195, 0.145131904949, −0.0173238450548, −0.00330861068859, 0.00105316349171]. Independent mpmath values are identical to 12 digits. Node residual 4.2e-15. Max |P6−cos| on [0, 2π] = 0.0071.
- **Picture:** Contact sheet: degrees 0–6, node counts in titles correct, dashed P passes through the nodes.
- **Orphan or missing case?** It looks like an orphan: it is a self-contained Newton demo that is not one of the 29 table cases, and nothing on the page refers to it. It is also the only code in the folder that does what the Description describes, so it would be a natural fit for the page (see F3).

### newtpolybb.jl (orphan)
- **Method:** Same correct Newton routine. Runge function 1/(1+25x²), first n+1 of 11 equispaced nodes on [−1, 1], n = 0…10, P clamped to ±2.5 with ylims (−1.5, 2.0).
- **Numbers:** Script coefficients match independent mpmath to 12 digits (last two ±220.941742081). Node residual 1.4e-13. Degree-10 max |P−f| = 1.9156 at x = ±0.94 (P = 1.9589), the known Runge overshoot.
- **Picture:** Contact sheet checked. All frames are titled "Runge Phenomenon", but only the last frame has nodes spanning [−1, 1] (F4).
- **Orphan or missing case?** Orphan: a stand-alone Runge demo, not in the case table.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/newton-interpolation-polynomial/`](evidence/newton-interpolation-polynomial/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
