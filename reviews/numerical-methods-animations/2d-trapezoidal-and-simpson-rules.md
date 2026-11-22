# 2D Trapezoidal and Simpson Rules — animation review

Page: [`pages/numerical-methods/2d-trapezoidal-and-simpson-rules/index.qmd`](../../pages/numerical-methods/2d-trapezoidal-and-simpson-rules/index.qmd) · Scripts: `simpson2daa.jl`, `trapezoidal2daa.jl` · GIFs: 2

**Result:** 0 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Minor — Implementation — The wireframe overlay hides the coloured surface of f, so neither GIF shows the surface

- **Location:** `trapezoidal2daa.jl:66-72` and `simpson2daa.jl:67-73` (`surface!(...; st=:wireframe, ..., fillalpha=0.0)`). Alt text, index.qmd:57: "surface over [0,1]x[0,1], full-grid refinement".
- **Now:** The scripts draw a coloured `surface` of f (`alpha=0.82`) and then put the sample-grid wireframe on top, with `fillalpha=0.0` intended to make it see-through. With the GR backend, the wireframe is drawn as an opaque white-filled mesh, so it covers the coloured surface. In frame 1 only a thin coloured strip along the ridge shows, where f rises above the bilinear facets. From about frame 3 on, the reader sees only a black mesh on white.
- **True:** If the wireframe were see-through, the coloured surface would be visible in every frame. As drawn, the "surface vs. sample grid" comparison the script sets up never appears.
- **Evidence:** `julia reviewer/occlusion.jl`, then `python3 -I reviewer/countcolor.py reviewer/occl_*.png` (counts saturated pixels):
  - surface only: 38577 coloured pixels
  - surface plus n=2 wireframe: 2932
  - surface plus n=20 wireframe: 0

  The committed frames match this (`committed/*/frame_001.png` against `frame_008.png`).
- **Suggested fix:** Draw the grid with `wireframe` lines only. For example, plot the grid lines as `path3d` polylines (one per x = const and one per y = const), or draw the nodes with `scatter3d!(...)`, instead of `st=:wireframe`. Alternatively, drop the coloured surface and the "surface" wording in the alt text.

- **Independent check:** not run (minor finding, unverified).

### F2 — Minor — Page match — The Simpson GIF draws the same piecewise-bilinear facets as the Trapezoidal GIF; only the title differs

- **Location:** `simpson2daa.jl:67-73`. Page Case 2, index.qmd:61-63 and alt text index.qmd:67 ("tensor-product Simpson refinement").
- **Now:** Apart from the title, the plot area of every Simpson frame is the same as the matching Trapezoidal frame. A pixel diff below the title band leaves only GIF palette-dither differences: the largest per-pixel RGB difference is 100 in frame 1 (only 5 pixels above 60) and 12 in frame 8. The drawn mesh is the piecewise-bilinear interpolant of the nodes, and the integral of that interpolant is the *trapezoidal* value. In Simpson frame 1 (n=2), four flat facets are drawn, and their volume is I_T = 4.749087736. The title reports I_S = 5.106262624.
- **True:** The tensor Simpson rule integrates the piecewise-biquadratic interpolant over 2×2-panel blocks, not the bilinear facets drawn. Nothing in the picture shows what is specific to Simpson (the 1-4-2-4-1 weight pattern or the quadratic patches).
- **Evidence:** `python3 -I reviewer/framediff.py <WORK>` gives the identical plot bodies. The n=2 trapezoid value is from `julia reviewer/trapezoidal2daa_values.jl` and `python3 reviewer/indep.py`.
- **Suggested fix:** In `simpson2daa.jl`, mark the nodes by Simpson weight (for example, `scatter3d!` with marker size or colour by `ax[i]*ay[j]` ∈ {1,2,4,8,16}), or draw biquadratic patches. Alternatively, say on the page that the mesh shows only the sample grid.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `simpson2daa.jl` | yes | 3.3 | simpson2daa.gif |
| `trapezoidal2daa.jl` | yes | 3.5 | trapezoidal2daa.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 16, 19 | $I = \int_0^1\int_0^1 8e^{-x^2-y^4}\,dy\,dx$, surface $z=8e^{-x^2-y^4}$ over $[0,1]^2$ | Both scripts, line 9: `f(x,y)=8*exp(-(x^2)-(y^4))`. `xlims=ylims=(0,1)` (lines 12-13). Frame titles say "on [0,1] x [0,1]". | confirmed |
| 2 | 21-28 | Trapezoidal: $hk\sum\sum w_iw_jf(x_i,y_j)$, $w_0=w_m=\tfrac12$, $w_i=1$ interior | trapezoidal2daa.jl:25-39 builds exactly this (with m=n, h=k=1/n). Property check with the script's own routine (`reviewer/props.jl`): exact for 1 and xy, error 0.041667 for x² at n=2. Exact-rational rebuild (`reviewer/indep.py`): exact monomials are {1, x, y, xy} only. (Notation: the $j$ weights are implicitly the same pattern with $n$ in place of $m$.) | confirmed |
| 3 | 32-36 | Simpson: $\frac{hk}{9}\sum\sum a_ia_jf$, $a_0=a_m=1$, $a_i=4$ odd, $2$ even | simpson2daa.jl:25-40 builds exactly this. `props.jl`: exact for 1, xy, x², x²y³, x³y³; error 0.008333 for x⁴ and y⁴ at n=2 (0.000521 at n=4). `indep.py`: exact monomials are exactly $x^py^q$ with $p,q\le3$. (The page doesn't say m and n must be even; the script uses only even n.) | confirmed |
| 4 | 43-44 | "full-domain mesh refinement on [0,1]×[0,1] for f(x,y)=8e^{-x^2-y^4}" | n_seq = [2,4,6,8,10,12,16,20] in both scripts. Each frame recomputes the rule on the whole square. Frames show 2x2 … 20x20. | confirmed |
| 5 | 45 | "archived benchmark I≈5.04756680717" | mpmath (40 digits), three ways (2-D quad, separable product, erf closed form in x): I = 5.047566807167539662…; benchmark − I = 2.46e-12. Correct when rounded to 11 decimals. | confirmed |
| 6 | 51 | "coarse-to-fine tensor grid updates over the whole square each frame" | 8 frames per GIF, mesh 2x2 → 20x20, covering the whole square (contact sheets) | confirmed |
| 7 | 52 | "converges toward the archived reference value" | I_T increases monotonically 4.7491 → 5.0447; error 0.2985 → 0.00287 | confirmed |
| 8 | 52-53 | "with visible second-order error decay under refinement" | Error ratios when h is halved: n 2→4: 4.13; 4→8: 4.02; 6→12: 4.01; 10→20: 4.003. That is O(h²). It is visible only as the "\|error\|" numbers in the titles, which are correct. | confirmed |
| 9 | 55 | Case 1 link → trapezoidal2daa.jl | The file exists and implements the 2D trapezoid rule | confirmed |
| 10 | 57 | Alt: "2D Trapezoidal animation: surface over [0,1]x[0,1], full-grid refinement, and convergence to the archived benchmark integral" | The GIF is produced by trapezoidal2daa.jl (manifest: byte-identical). Refinement and convergence (in the titles) are present. The coloured surface is almost entirely hidden (F1). | confirmed, with caveat → F1 |
| 11 | 61 | "Simpson tensor-product weights are recomputed on each refined mesh" | simpson2daa.jl:25-31 rebuilds `ax`, `ay` for each n. The picture doesn't show the weights (F2). | confirmed (code); see F2 |
| 12 | 62-63 | "Compared with trapezoidal refinement, the Simpson estimate reaches high accuracy with fewer refinements" | Simpson n=6 error 6.68e-4 is already below Trapezoid n=20 error 2.87e-3. Simpson n=20 error 4.68e-6. Simpson ratios when h is halved: 13.8, 21.7, 18.1, 16.6, consistent with O(h⁴). | confirmed |
| 13 | 65 | Case 2 link → simpson2daa.jl | The file exists and implements the 2D Simpson rule | confirmed |
| 14 | 67 | Alt: "2D Simpson animation: tensor-product Simpson refinement over [0,1]x[0,1] and convergence toward the archived benchmark integral" | Produced by simpson2daa.jl. Convergence in the titles is correct. The drawn mesh is the same as the trapezoid one (F2). | confirmed, with caveat → F2 |
| 15 | frames | Trapezoid title values (all 8 frames): mesh, I_T, \|error\| | All 8 match the independent values to the 9 decimals shown (see the table below) | confirmed |
| 16 | frames | Simpson title values (all 8 frames): mesh, I_S, \|error\| | All 8 match the independent values to the digits shown (see the table below) | confirmed |

## Implementation checks

### trapezoidal2daa.jl
- **Method:** The composite tensor-product trapezoidal rule. The nodes are `range(0,1,length=n+1)` in x and y, with h = k = 1/n. The 1-D weights are [½,1,…,1,½], and the result is h·k·ΣΣ wx[i]·wy[j]·f(x_i,y_j). This is the method named on the page, with the same formula.
- **Property checks** (the script's own `trapezoid2d`, with f swapped by `reviewer/props.jl`):
  - f = 1 and f = xy are exact at n = 2 and 4.
  - x² has error 0.041667 at n=2 and 0.010417 at n=4: not exact, and the error falls 4× when h is halved.
  - An independent exact-rational rebuild (`reviewer/indep.py`) is exact only on {1, x, y, xy}.
- **Numbers** (script values from `julia reviewer/trapezoidal2daa_values.jl`; independent 40-digit mpmath values from `python3 reviewer/indep.py`):

| n | script I_T | independent I_T | script \|err\| (vs benchmark) | independent \|I_T − I\| | title shows |
|---|---|---|---|---|---|
| 2 | 4.7490877360051 | 4.7490877360051 | 0.29847907116 | 0.29847907 | 4.749087736 / 0.298479071 |
| 4 | 4.9753446913786 | 4.9753446913786 | 0.07222211579 | 0.072222116 | 4.975344691 / 0.072222116 |
| 6 | 5.0156047055539 | 5.0156047055539 | 0.03196210162 | 0.031962102 | 5.015604706 / 0.031962102 |
| 8 | 5.0296132190388 | 5.0296132190388 | 0.01795358813 | 0.017953588 | 5.029613219 / 0.017953588 |
| 10 | 5.0360837636030 | 5.036083763603 | 0.01148304357 | 0.011483044 | 5.036083764 / 0.011483044 |
| 12 | 5.0395951754438 | 5.0395951754438 | 0.00797163173 | 0.0079716317 | 5.039595175 / 0.007971632 |
| 16 | 5.0430842644950 | 5.043084264495 | 0.00448254268 | 0.0044825427 | 5.043084264 / 0.004482543 |
| 20 | 5.0446984216467 | 5.0446984216467 | 0.00286838552 | 0.0028683855 | 5.044698422 / 0.002868386 |

- **Reference values:** `true_val = 5.04756680717`. The true I is 5.0475668071675397, so the benchmark is off by 2.5e-12. That has no effect on any displayed digit.
- **Picture:** I read frame_001 at full size and all 8 frames on the contact sheet. In `Zg = [f(x,y) for y in yg, x in xg]` the rows run over y, which is the Plots convention, so the mesh nodes sit at f(x_i,y_j). Frame 1 shows the 3×3-node mesh with its peak at (0,0) = 8, which matches f. Each title gives the right mesh size, approximation and error for that frame. The axes are [0,1]² with z up to 8.2, and f ranges over [8e^{-2}≈1.08, 8], so the whole surface is in view. Problem: the coloured surface is hidden by the wireframe's opaque fill (F1).

### simpson2daa.jl
- **Method:** The composite tensor-product Simpson rule. The 1-D weights are [1,4,2,4,…,2,4,1], built with `isodd(i-1)` on node number i−1, which is correct. The result is (h·k/9)·ΣΣ ax[i]·ay[j]·f. Only even n are used (n_seq), as Simpson requires. This is the method named on the page, with the same formula.
- **Property checks** (`reviewer/props.jl`, the script's own `simpson2d`):
  - At n=2 and 4, these are exact to machine zero: 1, xy, x², x²y³, x³y³.
  - x⁴ and y⁴ are not exact: error 0.0083333 at n=2 and 0.00052083 at n=4, a ratio of 16.
  - The exact-rational rebuild (`indep.py`) is exact on exactly the monomials $x^py^q$ with $p,q\le3$ (bicubic), and on no others up to total degree 6.
- **Numbers:**

| n | script I_S | independent I_S | script \|err\| | independent \|I_S − I\| | title shows |
|---|---|---|---|---|---|
| 2 | 5.1062626244475 | 5.1062626244475 | 5.8695817278e-2 | 0.058695817 | 5.106262624 / 0.058695817 |
| 4 | 5.0518116265090 | 5.051811626509 | 4.2448193390e-3 | 0.0042448193 | 5.051811627 / 0.004244819 |
| 6 | 5.0482347729079 | 5.0482347729079 | 6.6796573786e-4 | 0.00066796574 | 5.048234773 / 0.000667966 |
| 8 | 5.0477627773527 | 5.0477627773527 | 1.9597018272e-4 | 0.00019597019 | 5.047762777 / 0.00019597 |
| 10 | 5.0476445860761 | 5.0476445860761 | 7.7778906085e-5 | 7.7778909e-5 | 5.047644586 / 7.7779e-5 |
| 12 | 5.0476037121171 | 5.0476037121171 | 3.6904947132e-5 | 3.690495e-5 | 5.047603712 / 3.6905e-5 |
| 16 | 5.0475783036112 | 5.0475783036112 | 1.1496441211e-5 | 1.1496444e-5 | 5.047578304 / 1.1496e-5 |
| 20 | 5.0475714831165 | 5.0475714831165 | 4.6759464762e-6 | 4.6759489e-6 | 5.047571483 / 4.676e-6 |

(The script's errors are measured against the 11-digit benchmark. The 2.5e-12 offset shows up only in the 8th significant figure of the n=20 error, beyond the digits displayed.)
- **Reference values:** Same `true_val` as the trapezoid script. It is correct (see above).
- **Picture:** I read frame_008 at full size and all 8 frames on the contact sheet. The titles are correct; at n ≥ 10, `round(digits=9)` prints them in scientific notation (for example "7.7779e-5"), and the values are right. The plotted mesh and surface code is the same as in the trapezoid script. The plot area is the same as the Trapezoidal GIF frame for frame (F2), and the coloured surface is hidden (F1).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/2d-trapezoidal-and-simpson-rules/`](evidence/2d-trapezoidal-and-simpson-rules/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
