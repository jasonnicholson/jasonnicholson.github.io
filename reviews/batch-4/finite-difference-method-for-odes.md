# Review: Finite Difference Method for ODE's (batch 4, round 1)

**Findings: 0 Error, 0 Misleading, 4 Minor (unverified).**

Legacy archive consulted: `FiniteDifferenceMod.html`, example pages lnk_2–7, equation and output images gr_1–58, 66–134, 150–170 (Example 5's gr_135–149 and gr_118 are missing). Independent computations: symbolic check of (8); own build of system (6) with an mpmath (50-digit) Thomas solver for every n; every cell of the Example 1, 5 and 6 tables compared to half a unit in the last digit; verification arithmetic; a 40-digit residual; `solve_bvp`; a scratch copy of `fdodecc.jl` dumping every x_j at full precision (max difference from the Python solver 5.4e−48).

## Findings

### F1 — Fidelity / page match — Minor (unverified): Mathews' magenta curve is his finite-difference solution, not the exact solution

- **Location:** `index.qmd` line 30: "draws the finite difference solution over the interval $1 \le t \le 6$ of Mathews' graphs, with the exact solution in magenta as in his graphs"; also the header of `fdodeaa.jl` line 9.
- **True instead:** in Mathews' Examples 1–3 the magenta curve is the finite-difference solution (`ListPlot[pts, PlotJoined→True, …, PlotStyle→Magenta]` on `points1`, `points2`; gr_88, gr_98, gr_109); he never plots the exact solution (Example 6 only defines `f[t_]`). His graphs use `PlotRange→{{1.0, 6.2}, …}`. In the GIF magenta is the exact solution and blue the FD solution, so a reader comparing with Mathews would misread his magenta curve.
- **Fix:** "with the exact solution in magenta (in Mathews' graphs, magenta is the joined finite difference points)", or drop "as in his graphs"; fix the script comment to match.

### F2 — Page match — Minor (unverified): no dip at n = 5

- **Location:** line 38: "For every $n$ the error changes sign once, between $t = 3$ and $t = 4$, and the error curve dips there".
- **True instead:** for n = 5 the interior errors are 0.272, 0.192, 0.226, 0.453 at t = 2, 3, 4, 5; the log-panel line runs straight from t = 3 to t = 4 with no dip (frame 1). The sign change is real. For n ≥ 10 the dip is drawn (at t = 3.5, 3.4, 3.5, 3.45, 3.475, 3.475 for n = 10 … 400).
- **Fix:** "…and, from n = 10 on, the error curve dips there".

### F3 — Page match — Minor (unverified): Mathews' c₁ is not "the same constant"

- **Location:** lines 229–232: "$c_1 = 0.0588713451552886$ … the same constants that Mathews uses in Example 6".
- **True instead:** the page's value is right (true c₁ = 0.058871345155288636…, sympy 40 digits); Mathews' Example 6 (gr_150) uses c₁ = 0.0588713451552859, differing in the last two printed digits (about 2.7e−15). His c₂ = 0.7400710957802064 agrees. No number shown is affected.
- **Fix:** "essentially the constants Mathews uses in Example 6 (his c₁ ends …2859, a rounding difference of 3×10⁻¹⁵)", or "to 14 digits".

### F4 — Page match — Minor (unverified): the j = 24 verification row does not follow from the numbers shown

- **Location:** line 316: "$-0.982759(-1.819090) + 1.960297(-1.214944) = 1.787726 - 2.381651 = -0.593925$".
- **True instead:** the printed six-figure factors give 1.7877271 and a sum of −0.593924; the page's 1.787726 and −0.593925 come from full-precision factors (1.7877262, −0.5939252). A reader checking by hand gets a last-digit mismatch beside the ✓. Row j = 1 checks.
- **Fix:** print 1.787727 and −0.593924 (≈ −0.593925 to rounding), or give the factors to 7 figures.

## Inventory (Phase 1)

3 scripts, 3 GIFs (9, 9, 11 frames); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; 107 entries; reviewer's verdicts)

- **Description (1–6):** confirmed (difference equation (5) matches Mathews gr_43 and the scripts; ratios 0.2496, 0.2496, 0.2500, 0.2500); the 40-digit process claim could not be determined.
- **Animations introduction (7–18):** confirmed except 9 (F1): log panels omit the exact-zero boundary points; timing; 256-bit with asserts; no Mathews animation (a2001 OrdinaryDE holds only IVP methods); X₂ − X₁ in green as Mathews (gr_130); Example 5's graph missing, Example 6 none.
- **Case 1 (19–32):** confirmed except 29 for n = 5 (F2): n = 5 error 0.45327988 at t = 5 with x = −3.28489 below the exact minimum −2.905675; ratios 4.78289 then 4.0071, 4.0059, 3.9998, 4.0004; max/h² 0.45328, 0.379085, 0.365956, 0.365307, 0.364771, 0.364794, 0.36476; locations; one sign change per n in [3, 4].
- **Case 2 (33–43):** all confirmed: sign pattern, ratio 0.24853 at 4.8, the dashed estimate differing from X₁ − x by exactly −(X₃ − x) (max 2.86914e−5, identity residual 5e−51), X₃ 510.196 times smaller, dip 2.82478e−7 at 3.6.
- **Case 3 (44–54):** all confirmed: reference slopes, extrapolated values plotted at the finer h, FD ratios, extrapolation maxima 2.86914e−5, 1.78793e−6, 1.11490e−7, 6.96427e−9 with ratios 0.06232, 0.06236, 0.06247, X₄₀₀ max 1.98644 times the (25, 50) extrapolation, dips at 3.6.
- **Boundary value problems (55–58):** confirmed, including Mathews' α = β slip (gr_50) and det = sin 5 ≠ 0.
- **Finite-difference method (59–67):** confirmed, including the error terms, Mathews' x₀ = β typo (gr_45), system (6), the diagonal-dominance result, its failure for q < 0, the O(h²) theorem's conditions.
- **Worked examples (68–107):** confirmed except 74 (F3) and 90 (F4); 77 (`solve_bvp` within 9e−16) could not be reproduced exactly (reviewer gets 1.3e−15; settings unknown; immaterial). Every cell of the Example 1, 5 and 6 tables matches (0 mismatches); Mathews' printed solutions and maxima 0.0146383, 0.00363805, 0.0000286914 confirmed (gr_81, gr_87, gr_117, gr_125, gr_129, gr_154–164); det −4.9036416, cond₂ 224.79; X₃(4.8) = −2.9051788; the h-halving and extrapolation tables.

## Implementation checks

All three scripts share `fdsolve` and the exact-solution code. The method is the standard second-order central-difference scheme: interior rows follow (5) exactly, boundary terms move to the right-hand side as in (6), `Tridiagonal(sub[2:end], dia, sup[1:end-1])` places a₂…a_{n−1} and c₁…c_{n−2} correctly, and Richardson extrapolation is (4X_fine[1:2:end] − X_coarse)/3. Script values match the independent solver to every digit shown (n = 5 … 400 maxima 0.4533, 0.09477, 0.01464, 0.003653, 0.0009119, 0.0002280, 5.699e−05; fdodebb maxima 0.01464, 0.003638, 0.01100, 2.869e−5; fdodecc extrapolation maxima and smallest interior errors 2.825e−7, 1.795e−8, 1.127e−9, 7.052e−11 at t = 3.6). Exact solution (8): symbolic residual 0; constants from sympy; 256-bit evaluation. Frames 1, 4, 9 (aa), 5, 9 (bb), 1, 5, 11 (cc) checked; no clamping acts (y-range (−3.5, 1.5) vs minimum −3.285; log floors below every plotted value). The only picture–text mismatch is F2.
