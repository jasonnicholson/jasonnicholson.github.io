# Lagrange Polynomial Interpolation and Approximation — animation review

Page: [`pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/index.qmd`](../../pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/index.qmd) · Scripts: `lagnewt_animations_all.jl`, `lagrangeaa.jl` · GIFs: 29

**Result:** 2 error, 2 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — "Degree increases one step at a time" is false after degree 5

- **Location:** index.qmd:25, "Each animation increases polynomial degree one step at a time for a fixed function and interval."
- **Now:** The page says the degree goes up one step per frame.
- **True:** `lagnewt_animations_all.jl:159` sets `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`, so the 10 frames show degrees 1, 2, 3, 4, 5, 7, 9, 11, 13, 15. From degree 5 onward each frame adds two nodes and skips a degree.
- **Evidence:** script line 159; `reviewer/instr_out.txt` (from `julia reviewer/instr.jl`) lists deg = 1,2,3,4,5,7,9,11,13,15 for every case; the GIF titles in contact sheets for cases 01, 08, 14, 19, 24 and 29 read "degree 1 … 5, 7, 9, 11, 13, 15"; all 29 GIFs have 10 frames (`committed/*/nframes`).
- **Suggested fix:** Change the sentence to "Each animation raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2 to 16 equally spaced nodes) for a fixed function and node interval." Alternatively, change line 159 to `2:16` and regenerate the GIFs.

- **Independent check:** confirmed.

### F2 — Error — Implementation — Barycentric evaluation fails far outside the nodes and draws spurious vertical bars (cases 04 and 29)

- **Location:** `lagnewt_animations_all.jl:116-131` (`barycentric_eval`, the second, or "true", barycentric form), used at line 189. Visible in lagnewt04.gif frame 10 (degree 15) and lagnewt29.gif frames 9 (degree 13) and 10 (degree 15). The related claim is index.qmd:12, "In barycentric form, it is numerically stable …".
- **Now:** Where the window extends far past the node hull (case 04: nodes on [0.06, 1.94], window to x = 10.5; case 29: nodes on [0.605, 3.895], window to x = 22), the second-form denominator Σ wⱼ/(x−xⱼ) loses all its digits to cancellation. The computed P(x) is noise of size about 1e8 to 1e10 that flips sign from point to point. After clamping to the y-window, these points are drawn as a forest of full-height vertical blue bars. That suggests the interpolant swings wildly between −∞ and +∞ in that region.
- **True:** In those regions the exact interpolating polynomial is large, positive and smooth (monotone). It should be drawn as a single curve pinned to the top edge. Examples: case 04, degree 15, x = 6.538: script −2.77e9, exact +1.85e10. Case 29, degree 15, x = 14.62: script −6.43e7, exact +2.51e10. Case 29, degree 13, x = 17.71: script −4.52e9, exact +1.46e10.
- **Evidence:** `julia reviewer/clampcheck.jl` compares the clamped, plotted curve with the clamped Lagrange form evaluated in 256-bit BigFloat on the same nodes, at all 1000 plot points of all 290 frames. 27 of the 29 cases agree to ≤1.2e-9 of the y-range. Case 04 disagrees by the full y-range at 450 points, and case 29 at 532 points. `julia reviewer/clampdetail.jl` localises these to case 04 degree 15 (x ∈ [5.69, 10.5], 450 sign flips) and case 29 degree 13 (x ∈ [15.4, 21.9], 44) and degree 15 (x ∈ [10.6, 22], 488). None of the wrong values lands inside the y-window, so only the bars are affected. The frames show it: `committed/lagnewt04/frame_010.png` has bars at x ≈ 5.7 and 9.6 to 10.4, and `committed/lagnewt29/frame_010.png` has bars across x ≈ 10.5 to 21. `julia reviewer/fixcheck.jl` measures the max relative error against BigFloat. Script (second form): case 04 degree 15 4540, case 29 degree 13 129, case 29 degree 15 40.6. The first (modified Lagrange) form ℓ(x) Σ wⱼyⱼ/(x−xⱼ), with ℓ(x) = Π(x−xⱼ): 1.4e-9, 7.6e-10 and 1.6e-8 respectively, with no sign errors.
- **Suggested fix:** In `barycentric_eval`, use the first form, `prod(x .- xs) * sum(w .* ys ./ (x .- xs))`, at least when x is outside [xs[1], xs[end]] (or everywhere, since it is backward stable), then regenerate lagnewt04 and lagnewt29 on both pages. Optionally qualify index.qmd:12: the second barycentric form is stable for evaluation inside the interpolation interval, not for far extrapolation.

- **Independent check:** confirmed. Checker (512-bit reference): exactly 3 of 290 frames wrong — case 04 degree 15 (450 of 1000 plotted points) and case 29 degrees 13, 15 (44 and 488 points); every wrong point has the wrong sign.

### F3 — Misleading — Page match — The page refers to "listed node intervals" and a "function-and-interval list" that it never gives

- **Location:** index.qmd:21, "use equally spaced nodes on the listed node intervals". Every alt text at lines 31-143: "Lagrange interpolation animation for case NN from the legacy function-and-interval list." Every case heading at lines 29-141: "### Case NN".
- **Now:** The page has no list of functions or intervals. The case headings are bare numbers and the alt texts name no function. A reader learns the function only from the GIF title. The node interval appears nowhere: not on the page, and not in any GIF title.
- **True:** The functions, plot windows and node intervals exist only in the script's case table (`lagnewt_animations_all.jl:22-51`). Twelve cases (12-23) have no node interval at all; their nodes span the plot window (or the part of it where f is finite, as for asin).
- **Evidence:** Read the whole of index.qmd. The 29 GIF titles were read from full-size frames 1 and 10 of each GIF (`reviewer/titles_a.png`, `reviewer/titles_b.png`): each shows only "Interpolation Case NN: f(x) = <formula>, degree d". The table rows and the actual node intervals are in the ledger below.
- **Suggested fix:** Put the function and node interval in each heading, e.g. "### Case 04: √x, nodes on [0, 2]", using the table in the ledger. Make each alt text name the function, interval and degrees shown. Also correct line 21 (see F4) for the actual node placement.

- **Independent check:** confirmed.

### F4 — Misleading — Implementation / Page match — Nodes are inset 3% from each end of the interval, which hides endpoint behaviour (notably √x at 0)

- **Location:** `lagnewt_animations_all.jl:85-102` (`equal_nodes`: `trim = width * (0.03 + 0.01*attempt)`, applied unconditionally) and index.qmd:21, "equally spaced nodes on the listed node intervals".
- **Now:** "Equally spaced nodes on [a, b]" normally means x₀ = a and xₙ = b. The script instead spaces the nodes equally on [a + 0.03(b−a), b − 0.03(b−a)] in every case and every frame. The retry with a larger trim never fires (trim = 0.030 everywhere). The code comment says this avoids "near-singular endpoints", but the inset applies even where f is perfectly finite at the endpoint: √0 = 0, sin, exp, Bessel J and others.
- **True / effect:** Case 04 (√x, interval [0, 2]) uses nodes on [0.06, 1.94]. With 16 nodes the max interpolation error over the node hull is 0.00063. With nodes on the stated [0, 2] it is 0.0485, 77 times larger, because the infinite slope of √x at 0 is what limits convergence. The inset removes exactly the feature cases 04-06 exist to show. Case 08 (Runge-type 1/(1+10x²) on [−1, 1]) uses nodes on [−0.94, 0.94]: the degree-15 max error is 0.368, against 0.485 with nodes on [−1, 1], so the inset damps the Runge oscillation the case illustrates. Other node hulls are listed per case in the ledger (e.g. case 27: [1.085, 19.415] rather than [0.5, 20]).
- **Evidence:** `reviewer/instr_out.txt` (trim = 0.030 in all 290 rows); `/usr/bin/python3 reviewer/indep.py` rebuilds the nodes as "equally spaced on the 3%-inset interval" and matches the script's nodes to 8.9e-16; `/usr/bin/python3 reviewer/trim_effect.py` gives the error comparisons above. The script's own value 0.3684 for case 08 matches the independent value.
- **Suggested fix:** Either drop the unconditional trim (set it to 0 on the first attempt and only inset when f is non-finite at an endpoint; the table spans already avoid the true singularities), or state on the page that nodes are equally spaced on the interval inset by 3% of its width at each end, and give those intervals.

- **Independent check:** confirmed with correction. Checker: every case's nodes are inset exactly 3.0% (e.g. √x on [0,2] → nodes on [0.06,1.94]); for √x the degree-15 worst error drops 4.8e-2 → 6.3e-4. For case 08 the end oscillations still appear. Qualification: since the page never states the intervals (F3), the mismatch is with line 21's wording and the intervals set in the script.

### F5 — Minor — Implementation — Case 14 degree-13 frame: two of the 14 nodes are off-screen

- **Location:** `lagnewt_animations_all.jl:173-182` (the y-limits use node values only from the 2-node and 16-node sets) and lagnewt14.gif frame 9.
- **Now:** With 14 nodes on [−2.953, 2.953], nodes fall at x = ±1.5903, just beyond ±π/2, where tan = ∓51.72. The y-window is (−17.22, 16.86), so these two nodes and the interpolant through them are not drawn. The frame titled "degree 13" shows only 12 red nodes.
- **True:** The degree-13 interpolant passes through 14 nodes, two of them at |y| ≈ 51.7.
- **Evidence:** `reviewer/instr_out.txt`, case 14 n=14: `nodesOutsideYlims=2 minNodeY=-51.72 maxNodeY=51.72`. No other case and frame has a node outside the window. 12 nodes are visible in `committed/lagnewt14/frame_009.png`.
- **Suggested fix:** Include the node values from every frame when computing `ynode`, or note in the case text that two nodes lie off-scale near the poles. (Interpolating tan across its poles with equally spaced nodes is also a case whose error grows without bound, max 633 at degree 15; the page should say what the reader is meant to see there.)

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `lagnewt_animations_all.jl` | yes | 17.7 | 29 GIFs |
| `lagrangeaa.jl` | yes | 3.0 | lagrangeaa.gif |

Committed GIFs byte-identical to their regenerated output: **29 of 29**. Decoded frames were also compared; all match.

Inventory findings:

- script lagrangeaa.jl on disk is not linked from the page
- script(s) ['lagrangeaa.jl'] produce lagrangeaa.gif, which is not committed

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Lagrange interpolation builds a unique polynomial of degree at most $n$ through $n+1$ data points." | Standard result (distinct nodes). Every frame's nodes are distinct (equally spaced, h > 0). My mpmath Lagrange form reproduces the data to < 1e-40, and the script's interpolant matches it (row 3). | confirmed |
| 2 | 12 | "In barycentric form, it is numerically stable and efficient for evaluation while keeping the same interpolant." | The script uses the second barycentric form (lines 104-131). On every visible point of all 290 frames it matches BigFloat Lagrange to ≤ 4.2e-9 absolute (`indep2.py`, `clampcheck.jl`). "Same interpolant" holds. "Numerically stable" fails for far extrapolation in cases 04 and 29. | confirmed for x within the node interval; not true for the extrapolated parts drawn (→ F2) |
| 3 | 14-19 | $P_n(x)=\sum y_i L_i(x)$, $L_i(x)=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | The formula is correct. `indep.py` evaluates exactly this form in 50-digit mpmath for all 29 cases × 10 degrees at 9 points over each window. On points inside the y-window the max difference from the script is ≤ 4.2e-9. Off-window disagreement is limited to F2. | confirmed |
| 4 | 21 | "The 29 animations below" | 29 embeds (lines 31-143), 29 GIFs, 29 table rows | confirmed |
| 5 | 21 | "follow the legacy Mathews case ordering" | history/attribution | out of scope |
| 6 | 21 | "use equally spaced nodes" | Nodes are `range(aa, bb, length=n)`, reproduced to 8.9e-16 by `indep.py` | confirmed |
| 7 | 21 | "on the listed node intervals" | No intervals are listed on the page. Nodes sit on 3%-inset intervals. Cases 12-23 have no node interval. | wrong (→ F3, F4) |
| 8 | 25 | "Each animation increases polynomial degree one step at a time" | Degrees 1,2,3,4,5,7,9,11,13,15 | wrong (→ F1) |
| 9 | 25 | "for a fixed function and interval" | Each GIF uses one `case.f` and one `resolved_span`. Trim is 0.030 in every frame, so the node interval is fixed. | confirmed |
| 10 | 27 | "[Julia source for all cases](lagnewt_animations_all.jl)" | The file exists and produces all 29 GIFs byte-identically (manifest) | confirmed |
| 11 | 31-143 (all) | alt text "Lagrange interpolation animation …" | The plotted curve is the unique interpolating polynomial (rows 1-3), so "Lagrange interpolation" is accurate | confirmed |
| 12 | 31-143 (all) | alt text "… from the legacy function-and-interval list" | No such list on the page | wrong (→ F3) |
| 13 | (frames) | Legend: magenta "f(x)", blue "interpolant", red "nodes" | Lines 199-201. Contact sheets 01, 08, 14, 19, 24, 29 checked: red markers lie on the magenta curve, blue passes through them. | confirmed (except two hidden nodes, → F5) |
| 14 | (frames) | Title "degree d" = number of nodes − 1 | Line 195. The node count in each frame equals d+1 in the sheets checked. This is the nominal degree: e.g. case 08 "degree 1" is a horizontal line, since f is even. Consistent with "degree at most n" (line 12). | confirmed |
| C01 | 29, 31 | "### Case 01"; alt "…case 01 from the legacy function-and-interval list"; embed lagnewt01.gif | Table row 01: f=1/(1-x), window (−1.6, 0.9), table span (−1.6, 0.9). Nodes actually on [−1.525, 0.825]. GIF title "Interpolation Case 01: f(x) = 1/(1-x), degree 1…15" (frames 1 and 10). 10 frames. Degree-15 max error on node hull 0.0206. | confirmed (wiring, title and table agree; page names no function or interval → F3) |
| C02 | 33, 35 | "### Case 02"; alt; embed lagnewt02.gif | Row 02: f=1/(1+x), window (−0.9, 1.6), span (−0.9, 1.6). Nodes on [−0.825, 1.525]. Title "Case 02: f(x) = 1/(1+x)". Error 0.0206 (mirror image of 01). | confirmed (→ F3) |
| C03 | 37, 39 | "### Case 03"; alt; embed lagnewt03.gif | Row 03: f=1/(1-x)^2, window (−1.6, 0.9), span (−1.6, 0.9). Nodes on [−1.525, 0.825]. Title "Case 03: f(x) = 1/(1-x)^2". Error 0.520. | confirmed (→ F3) |
| C04 | 41, 43 | "### Case 04"; alt; embed lagnewt04.gif | Row 04: f=sqrt(x), window (0, 10.5), span (0, 2). Nodes on [0.06, 1.94]. Title "Case 04: f(x) = sqrt(x)". Error 0.00063. | confirmed wiring/title (→ F3); frame 10 drawing wrong (→ F2); inset effect (→ F4) |
| C05 | 45, 47 | "### Case 05"; alt; embed lagnewt05.gif | Row 05: f=sqrt(x), window (0, 10.5), span (0, 8). Nodes on [0.24, 7.76]. Title "Case 05: f(x) = sqrt(x)". Error 0.00126. | confirmed (→ F3, F4) |
| C06 | 49, 51 | "### Case 06"; alt; embed lagnewt06.gif | Row 06: f=sqrt(x), window (0, 10.5), span (0, 10). Nodes on [0.30, 9.70]. Title "Case 06: f(x) = sqrt(x)". Error 0.00141. | confirmed (→ F3, F4) |
| C07 | 53, 55 | "### Case 07"; alt; embed lagnewt07.gif | Row 07: f=1/sqrt(1-x), window (−1.6, 0.9), span (−1.6, 0.9). Nodes on [−1.525, 0.825]. Title "Case 07: f(x) = 1/sqrt(1-x)". Error 0.0024. | confirmed (→ F3) |
| C08 | 57, 59 | "### Case 08"; alt; embed lagnewt08.gif | Row 08: f=1/(1+10x^2), window (−1.5, 1.5), span (−1, 1). Nodes on [−0.94, 0.94]. Title "Case 08: f(x) = 1/(1+10x^2)". Error 0.368 (Runge oscillation visible at the ends, sheet checked). | confirmed (→ F3, F4) |
| C09 | 61, 63 | "### Case 09"; alt; embed lagnewt09.gif | Row 09: f=log(x), window (−0.5, 4.1), span (0.02, 2). Nodes on [0.0794, 1.9406]. Title "Case 09: f(x) = log(x)". Error 0.0061. | confirmed (→ F3, F4) |
| C10 | 65, 67 | "### Case 10"; alt; embed lagnewt10.gif | Row 10: f=log(x), window (−0.5, 4.1), span (0.02, 4). Nodes on [0.1394, 3.8806]. Title "Case 10: f(x) = log(x)". Error 0.0091. | confirmed (→ F3, F4) |
| C11 | 69, 71 | "### Case 11"; alt; embed lagnewt11.gif | Row 11: f=log(1+x), window (−1.5, 1.5), span (−0.98, 1). Nodes on [−0.9206, 0.9406]. Title "Case 11: f(x) = log(1+x)". Error 0.0062 (case 09 shifted by 1). | confirmed (→ F3, F4) |
| C12 | 73, 75 | "### Case 12"; alt; embed lagnewt12.gif | Row 12: f=sin(x), window (−3π, 3π), no span (auto = whole window). Nodes on [−8.859, 8.859]. Title "Case 12: f(x) = sin(x)". Error 0.0185. | confirmed (→ F3) |
| C13 | 77, 79 | "### Case 13"; alt; embed lagnewt13.gif | Row 13: f=cos(x), window (−3π, 3π), auto. Nodes on [−8.859, 8.859]. Title "Case 13: f(x) = cos(x)". Error 0.0328. | confirmed (→ F3) |
| C14 | 81, 83 | "### Case 14"; alt; embed lagnewt14.gif | Row 14: f=tan(x), window (−π, π), auto. Nodes on [−2.953, 2.953]. Title "Case 14: f(x) = tan(x)". Error 633 (nodes straddle the poles; no convergence). | confirmed wiring/title (→ F3); two hidden nodes at degree 13 (→ F5) |
| C15 | 85, 87 | "### Case 15"; alt; embed lagnewt15.gif | Row 15: f=exp(x), window (−2, 3), auto. Nodes on [−1.85, 2.85]. Title "Case 15: f(x) = exp(x)". Error 1.1e-10. | confirmed (→ F3) |
| C16 | 89, 91 | "### Case 16"; alt; embed lagnewt16.gif | Row 16: f=cos(x)*exp(−x), window (−2, 4), auto. Nodes on [−1.82, 3.82]. Title "Case 16: f(x) = cos(x)*exp(-x)". Error 9.0e-8. | confirmed (→ F3) |
| C17 | 93, 95 | "### Case 17"; alt; embed lagnewt17.gif | Row 17: f=cosh(x), window (−4, 4), auto. Nodes on [−3.76, 3.76]. Title "Case 17: f(x) = cosh(x)". Error 1.2e-7. | confirmed (→ F3) |
| C18 | 97, 99 | "### Case 18"; alt; embed lagnewt18.gif | Row 18: f=atan(x), window (−2.2, 2.2), auto. Nodes on [−2.068, 2.068]. Title "Case 18: f(x) = atan(x)". Error 0.0113. | confirmed (→ F3) |
| C19 | 101, 103 | "### Case 19"; alt; embed lagnewt19.gif | Row 19: f=asin(x), window (−1.5, 1.5), auto. The finite part is (−0.99932, 0.99932); `asin` throws outside [−1, 1] and is mapped to NaN. Nodes on [−0.9394, 0.9394]. Title "Case 19: f(x) = asin(x)". Error 0.0008. | confirmed (→ F3) |
| C20 | 105, 107 | "### Case 20"; alt; embed lagnewt20.gif | Row 20: f=besselj(0,x), window (−10.2, 10.2), auto. Nodes on [−9.588, 9.588]. Title "Case 20: f(x) = besselj(0,x)". Error 0.0204. | confirmed (→ F3) |
| C21 | 109, 111 | "### Case 21"; alt; embed lagnewt21.gif | Row 21: f=besselj(1,x), window (−10.2, 10.2), auto. Nodes on [−9.588, 9.588]. Title "Case 21: f(x) = besselj(1,x)". Error 0.0119. | confirmed (→ F3) |
| C22 | 113, 115 | "### Case 22"; alt; embed lagnewt22.gif | Row 22: f=exp(−x²/2)/√(2π) ("normal_pdf"), window (−3, 3), auto. Nodes on [−2.82, 2.82]. Title "Case 22: f(x) = normal_pdf(x)". Error 1.6e-4. | confirmed (→ F3) |
| C23 | 117, 119 | "### Case 23"; alt; embed lagnewt23.gif | Row 23: f=½+½erf(x/√2) ("normal_cdf"), window (−3, 3), auto. Nodes on [−2.82, 2.82]. Title "Case 23: f(x) = normal_cdf(x)". Error 3.1e-5. | confirmed (→ F3) |
| C24 | 121, 123 | "### Case 24"; alt; embed lagnewt24.gif | Row 24: f=gamma(x), window (−0.2, 5.2), span (0.05, 2). Nodes on [0.1085, 1.9415]. Title "Case 24: f(x) = gamma(x)". Error 0.069. | confirmed (→ F3, F4) |
| C25 | 125, 127 | "### Case 25"; alt; embed lagnewt25.gif | Row 25: f=gamma(x), window (−0.2, 5.2), span (0.05, 4). Nodes on [0.1685, 3.8815]. Title "Case 25: f(x) = gamma(x)". Error 0.092. | confirmed (→ F3, F4) |
| C26 | 129, 131 | "### Case 26"; alt; embed lagnewt26.gif | Row 26: f=gamma(x), window (−0.2, 5.2), span (0.5, 5). Nodes on [0.635, 4.865]. Title "Case 26: f(x) = gamma(x)". Error 0.0003. | confirmed (→ F3, F4) |
| C27 | 133, 135 | "### Case 27"; alt; embed lagnewt27.gif | Row 27: f=bessely(0,x), window (0, 22), span (0.5, 20). Nodes on [1.085, 19.415]. Title "Case 27: f(x) = bessely(0,x)". Error 0.0101. | confirmed (→ F3, F4) |
| C28 | 137, 139 | "### Case 28"; alt; embed lagnewt28.gif | Row 28: f=bessely(0,x), window (0, 22), span (0.5, 10). Nodes on [0.785, 9.715]. Title "Case 28: f(x) = bessely(0,x)". Error 0.0003. | confirmed (→ F3, F4) |
| C29 | 141, 143 | "### Case 29"; alt; embed lagnewt29.gif | Row 29: f=bessely(0,x), window (0, 22), span (0.5, 4). Nodes on [0.605, 3.895]. Title "Case 29: f(x) = bessely(0,x)". Error 6.5e-6. | confirmed wiring/title (→ F3); frames 9-10 drawing wrong (→ F2) |

For every case, the wiring check (heading number = embed GIF number = table id = number in the GIF title) passed. The function in each GIF title is the function in the matching table row, read from full-size frames 1 and 10. "Error" in the rows above means max |P₁₅ − f| over the node hull at 1000 plot points, from `instr_out.txt`.

## Implementation checks

### lagnewt_animations_all.jl
- **Method:** This is polynomial interpolation at equally spaced nodes, which gives the unique interpolant (the Lagrange polynomial). It is evaluated in the second ("true") barycentric form, with weights wⱼ = 1/Π_{k≠j}(xⱼ−x_k) (lines 104-131), not by the Lagrange product formula shown on the page. Both forms give the same polynomial, and the page mentions the barycentric form, so the variant is disclosed. The nodes come from `equal_nodes` (lines 85-102): n nodes, equally spaced on the node span inset by 3% of its width at each end (F4). For cases with `has_span=false` the span is the finite part of the plot window. Each frame rebuilds the interpolant from scratch with n = 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes (F1). The node sets are not nested, so each frame shows a different set of nodes rather than adding nodes to the previous set.
- **Numbers:** The script's nodes match my independent reconstruction to 8.9e-16 in x and 2.6e-15 (relative) in y. I evaluated f with 50-digit mpmath, including besselj/bessely/gamma/erf/asin (`/usr/bin/python3 reviewer/indep.py`). I compared the script's interpolant values with the Lagrange form at 50 digits, at 9 points across each window for all 29 × 10 frames (`reviewer/indep2.py`). At points inside the y-window the max absolute difference is ≤ 4.2e-9 (most cases ≤ 1e-12). At off-window points the relative difference is ≤ 3e-8, except cases 04, 09, 24, 28 and 29, where far extrapolation in the second form loses accuracy. Only 04 and 29 change what is drawn (F2), per `reviewer/clampcheck.jl` at all 1000 plot points of every frame. Node reproduction: my own Lagrange form reproduces the data to < 1e-40. The script's `barycentric_eval` returns yⱼ exactly at a node (lines 117-121 short-circuit). Evaluated at xⱼ + 1e-9 to bypass the short-circuit, it gives residuals of 1e-10 to 3e-7, the size f′·1e-9 predicts (6e-6 for tan near its poles). The script's degree-15 Runge error, 0.3684 on [−0.94, 0.94], matches the independent 0.3684 (`trim_effect.py`).
- **Reference values:** The "true" curve is f evaluated directly (SpecialFunctions for besselj, bessely, gamma and erf). The 2.6e-15 agreement with mpmath at all nodes confirms the function definitions, including normal_pdf = e^{−x²/2}/√(2π) and normal_cdf = ½(1+erf(x/√2)). Non-finite values, and DomainErrors for log and asin, are masked to NaN, which leaves correct gaps (x ≤ 0 for log, |x| > 1 for asin, x = 0 for gamma and bessely). The true curve is clamped to the y-window. That makes flat segments at the edge near the singularities of cases 01, 03, 07 and 24-26, and the connecting vertical strokes at the tan poles in case 14. These are acceptable display devices, since the curve is clearly leaving the window.
- **Picture:** I read the contact sheets for cases 01, 08, 14, 19, 24 and 29, full-size frames lagnewt04/frame_010, lagnewt14/frame_009 and lagnewt29/frame_010, and the title strips of frames 1 and 10 of all 29 GIFs (`reviewer/titles_a.png`, `titles_b.png`, built from the committed frames). The red nodes lie on the magenta f(x), and the blue interpolant passes through every visible node. Titles carry the right case id, function and degree = nodes − 1. Clamping the interpolant to the y-window draws it along the frame edge where it leaves the window. This is acceptable, except where the clamped values themselves are wrong (F2). The y-limits come from the 3rd to 97th percentile of f plus the node values of the 2- and 16-node sets only, so the 14-node set in case 14 has two nodes off-screen (F5). There are 10 frames per GIF at fps 2.

### lagrangeaa.jl (not linked from the page; GIF not committed, already an inventory finding)
- **Method:** Direct Lagrange product form (lines 21-34) for f(x) = 1/(1−x). There are 10 fixed equally spaced nodes on [−0.8, 0.8], and degree d uses the first d+1 of them, so the nodes are nested and the low-degree frames use only the left end of the interval (degree 1: nodes −0.8 and −0.622). This construction matches its own comment ("through first n+1 nodes").
- **Numbers:** `julia reviewer/aa_check.jl`: node residual 0.0 for all degrees 1-9. The difference from a 256-bit BigFloat Lagrange evaluation over [−1.5, 1.5] is ≤ 2.8e-11. Max error on [−0.8, 0.8] falls from 3.90 (degree 1) to 0.033 (degree 9). The script computes correctly.
- **Picture:** The GIF regenerated in `iso/lagrangeaa/` has 9 frames, degrees 1-9; frame 5 was viewed (`reviewer/aa_f5.png`). Cosmetic points only, none of them on the page: the legend reads literally "P_{5}(x)"; at degree 5 the curve colour (`colors[5] = :red`) is the same as the red nodes; f is drawn only on (−0.99, 0.99); and the dashed lines at x = ±1, labelled "Convergence radius boundary" in a comment, have no meaning for interpolation.
- **Orphan or missing case:** This looks like an orphan. It duplicates the function of Case 01 (1/(1−x)), uses a different node scheme and styling from the 29-case table, and the page's wording ("The 29 animations", one shared script) leaves no slot for it. Whether the legacy site had a separate "lagrangeaa" animation could not be determined (the archive is not available). If it is kept, it would need its own case on the page. Otherwise it can be removed.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/lagrange-polynomial-interpolation-and-approximation/`](evidence/lagrange-polynomial-interpolation-and-approximation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
