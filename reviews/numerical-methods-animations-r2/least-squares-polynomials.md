# Least Squares Polynomials — animation review (round 2)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Mathews' "polynomial wiggle" example (Example 7) and the wide extrapolation view (Example 6) are dropped without a word, yet the Description asserts both effects

- **Location:** `index.qmd`, Description, last paragraph: "As the degree increases from 2 to 5, RMS decreases, but this does not always mean better behavior outside the data interval. High-degree polynomial fits can exhibit oscillations ("polynomial wiggle") and poor extrapolation." Also Case 4 Behavior: "but it may still be fragile for extrapolation."
- **What is there now:** All four animations use the six-point dataset on the window x ∈ [-5, 4.5], y ∈ [0, 6.2]. That is only 0.5 beyond the data on the left and 0.4 on the right. In that window p2 to p5 agree to within about 0.25, and nothing wiggles. The page has no case that shows either effect it names.
- **What the archive has:** Example 6 (`lnk_7.html`, graph `gr_85.gif`) plots p2 to p5 for this same dataset on [-10, 10] to show them diverging outside the data ("Things might 'blow up' outside the interval where the data is located"). Example 7 (`lnk_8.html`, data image `gr_86.gif`) fits degrees 2, 3, 4, 5 to the points (0.25, 23.1), (1.0, 1.68), (1.5, 1.0), (2.0, 0.84), (2.4, 0.826), (5.0, 1.2576). Mathews says these come from a non-polynomial function, and the example exists to show "polynomial wiggle". Neither case appears, and the page does not say it left them out. Example 1 (least-squares parabola for the 8 points (-1,10), (0,9), …, (6,-1), image `gr_10.gif`) is also dropped. That one matters less. Example 8 repeats Case 2's cubic with a different solver, so dropping it is fine.
- **Evidence that the effect is real but not shown:** `numpy.polyfit` on the page's data, evaluated outside the window (command in `review/`, run inline):
  - x = -10: p2 = -8.175, p3 = -10.326, p4 = -16.189, p5 = -23.953
  - x = 10: p2 = 2.397, p3 = 4.815, p4 = -2.228, p5 = 8.082
  - x = -5 and x = 4.5 (the window edges): values lie in [-0.107, 0.140] and [5.521, 5.611].
  So the Description's caution is correct, but no frame shows it. The only trace in the window is that p4 and p5 dip slightly below y = 0 at x = -5 (-0.063 and -0.107), and `ylims = (0.0, 6.2)` clips them.
- **Suggested correction:** Either add a case that widens the x-window to about [-10, 10] for the final fits (Mathews' Example 6 view), add a case with Mathews' Example 7 data showing wiggle, or say in one sentence that these archive examples are not animated here.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 6.7 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 6.8 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 6.8 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 7.6 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `leastsqpolyaa.gif` | 3 | byte-identical | leastsqpolyaa |
| `leastsqpolyab.gif` | 4 | byte-identical | leastsqpolyab |
| `leastsqpolyac.gif` | 5 | byte-identical | leastsqpolyac |
| `leastsqpolyad.gif` | 6 | byte-identical | leastsqpolyad |

### Page references

- Scripts linked: `leastsqpolyaa.jl`, `leastsqpolyab.jl`, `leastsqpolyac.jl`, `leastsqpolyad.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

All "true" values are from `review/indep.py` (exact rational arithmetic with `fractions`/`sympy`, cross-checked with `numpy.linalg.lstsq`) unless stated otherwise.

| # | Page claim (page's own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "$p_m(x)=a_0+\dots+a_mx^m$ is chosen to minimize … $E=\sum(p_m(x_i)-y_i)^2$" | Script solves the least-squares problem for this E. Residual is orthogonal to the basis: exact $V^T r = 0$, float $\max|V^T r| \le 1.2\times10^{-12}$ | confirmed |
| D2 | "normal equations … $(V^TV)\mathbf a=V^T\mathbf y$, where V is the Vandermonde-style design matrix" | Script line 18 `V = [x^j for x in x_data, j in 0:m]`, line 19 `(V' * V) \ (V' * y_data)` | confirmed |
| D3 | RMS formula $\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | Script line 30 / 35 use exactly this, n = 6 | confirmed |
| D4 | Data points (-4.5,0.7),(-3.2,2.3),(-1.4,3.8),(0.8,5.0),(2.5,5.5),(4.1,5.6) | Script lines 16–17. Archive gr_38 (= gr_52 = gr_60 = gr_68 = gr_120, byte-identical) shows the same points | confirmed |
| D5 | "As the degree increases from 2 to 5, RMS decreases" | 0.0524514, 0.0276732, 0.0073400, 0 | confirmed |
| D6 | "this does not always mean better behavior outside the data interval … oscillations and poor extrapolation" | Fits diverge outside the data (x = ±10 values in F1). Not visible in any frame | confirmed as a statement; not shown (F1) |
| A1 | "Each animation below draws the degree-m least-squares polynomial one partial sum at a time, for the same dataset" | Loop `for k in 0:m`, `partial_eval` sums `c[1..k+1]`; same data in all 4 scripts | confirmed |
| A2 | "The blue points are the data" | `scatter!(...; color = :royalblue)`; frames | confirmed |
| A3 | "the gray dashed curve is the fitted polynomial $p_m$" | `color = :gray45, ls = :dash`, `y_full` = full coeffs; frames | confirmed |
| A4 | "the solid colored curve is the partial sum $a_0+\dots+a_kx^k$ … with k increasing frame by frame" | Line 45; frame titles "partial sum through x^0 … x^m" in order | confirmed |
| A5 | "Only the last frame (k=m) is a least-squares fit" | Partial sums with k<m differ from the degree-k LS fits (compare A7); last frame's RMS(partial) = RMS(final) | confirmed |
| A6 | "the degree-0 fit is the mean 3.8167" | mean y = 3.816667 | confirmed |
| A7 | "$a_0$ ranges from 4.629 to 4.674 across the four cases" | a0 = 4.674251, 4.668626, 4.628628, 4.632324 → min 4.6286, max 4.6743 | confirmed |
| A8 | "Each of these earlier partial sums has a larger RMS than the degree-k least-squares fit" | LS RMS for degrees 0, 1, 2, 3, 4: 1.79946, 0.54048, 0.05245, 0.02767, 0.00734. Partial-sum RMS: m=2: 1.99337, 0.89688; m=3: 1.99095, 0.92296, 0.13392; m=4: 1.97417, 0.88548, 0.22093, 0.16715; m=5: 1.97569, 0.87789, 0.17774, 0.20267, 0.10511. All 10 are larger | confirmed |
| A9 | "in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3" | 0.1777354, 0.2026747 (indep and script agree) | confirmed |
| A10 | "Julia source scripts, which compute the coefficients from the normal equations" | Line 19 in all four | confirmed |
| A11 | (Unstated) The orange vertical segments in the frames | Segments drawn from data to partial sum at each $x_i$ (lines 47–50). Correct, but the page does not describe them | n/a (omission, not a claim) |
| C1a | Case 1 heading "Quadratic fit, m=2" → `leastsqpolyaa.jl`, `leastsqpolyaa.gif` | aa script has `m = 2`. GIF has 3 frames titled "Degree-2" | confirmed |
| C1b | "captures the main concave-down trend" | a2 = -0.0756 < 0; frames | confirmed |
| C1c | "all residuals below 0.1 in size" | residuals +0.06391, -0.09180, -0.01405, +0.04873, +0.02306, -0.02986 | confirmed |
| C1d | "the two largest are at the two leftmost points (x=-4.5 and x=-3.2)" | |r| = 0.0918 at -3.2, 0.0639 at -4.5; next 0.0487 at 0.8 | confirmed |
| C1e | "baseline smooth fit used in the module" | Archive Example 2 is this quadratic | confirmed |
| C1f | $p_2=4.67425+0.52861x-0.07563x^2$ | 4.67425137, 0.52860951, -0.07563441 | confirmed |
| C1g | RMS ≈ 0.05245 | 0.05245143. Frame annotation "0.05245" | confirmed |
| C1h | Alt: "partial sums through x^0, x^1 and x^2, ending with the smooth concave-down fitted curve" | 3 frames, titles x^0, x^1, x^2 | confirmed |
| C2a | Case 2 heading "Cubic fit, m=3" → ab | ab `m = 3`, 4 frames "Degree-3" | confirmed |
| C2b | "Adding the cubic term … lowers RMS" | 0.05245 → 0.02767 | confirmed |
| C2c | "tracks the left and right tails a bit more closely" | Residual at x=-4.5: 0.0639→0.0191; -3.2: -0.0918→-0.0453; 4.1: -0.0299→+0.0117 | confirmed |
| C2d | "remaining stable across the plotted interval" | Final frame: smooth and monotone-then-flat on [-5, 4.5], range [0.031, 5.613] | confirmed |
| C2e | $p_3=4.66863+0.48939x-0.07424x^2+0.00268x^3$ | 4.66862641, 0.48939249, -0.07423867, 0.00267659 | confirmed |
| C2f | RMS ≈ 0.02767 | 0.02767321. Frame "0.02767" | confirmed |
| C2g | Alt: "partial sums through x^0 to x^3 … RMS is lower than the quadratic's" | 4 frames; 0.02767 < 0.05245 | confirmed |
| C3a | Case 3 heading "Quartic fit, m=4" → ac | ac `m = 4`, 5 frames "Degree-4" | confirmed |
| C3b | "noticeably reduces residuals" | max |r|: cubic 0.0453 → quartic 0.0106 | confirmed |
| C3c | "follows the subtle curvature changes between middle and right-side points" | Residuals at -1.4, 0.8, 2.5: cubic +0.0306, +0.0140, -0.0301 → quartic +0.0105, -0.0106, +0.0066. Qualitative wording, consistent with the numbers | confirmed (qualitative) |
| C3d | "RMS drops by about a factor of four compared with the cubic" | 0.0276732 / 0.0073400 = 3.77 | confirmed |
| C3e | $p_4=4.62863+0.49669x-0.05823x^2+0.00201x^3-0.00080x^4$ | 4.62862816, 0.49668723, -0.05823430, 0.00201395, -0.00080138 | confirmed |
| C3f | RMS ≈ 0.00734 | 0.00733997. Frame "0.00734" | confirmed |
| C3g | Alt: "x^0 to x^4, ending with a close fit to all six points" | 5 frames; last frame visually through all points | confirmed |
| C4a | Case 4 heading "Quintic fit, m=5" → ad | ad `m = 5`, 6 frames "Degree-5" | confirmed |
| C4b | "six data points at distinct x values and degree 5 … interpolates all six points, so its RMS is exactly 0" | Exact rational solve: residuals all exactly 0 | confirmed |
| C4c | "the animation's floating-point solve shows roundoff of about $8\times10^{-15}$" | Script final_rms = 7.859e-15. Frame "RMS(final) = 7.86e-15" | confirmed |
| C4d | "may still be fragile for extrapolation" | p5(-10) = -23.95, p5(10) = 8.08 vs p2: -8.18, 2.40. True, but not shown (F1) | confirmed (not shown) |
| C4e | $p_5=4.63232+0.50885x-0.06063x^2-0.00074x^3-0.00065x^4+0.00012x^5$ | 4.63232375, 0.50885354, -0.06062594, -0.00073781, -0.00065051, 0.00011667 | confirmed |
| C4f | Alt: "x^0 to x^5, ending with the polynomial that passes through all six data points" | 6 frames; last frame through all points | confirmed |
| W1 | Four source links and four embeds point at the matching script/GIF | aa/ab/ac/ad ↔ m=2/3/4/5. Committed GIFs byte-identical to regenerated output (manifest) | confirmed |

---

### 3. Implementation checks

The four scripts are identical except for `m`, the partial-sum colour and the output filename (verified with `diff`). So the checks below apply to all four, with per-script numbers given.

### Is it the method it claims to be?
Yes. The script builds the monomial design matrix `V[i,j] = x_i^j`, j = 0..m (line 18), and solves the normal equations `(V'V) a = V'y` (line 19). This is the classical least-squares polynomial fit by normal equations, which is what the Description and Mathews' theorem state. No QR or other variant is involved. Conditioning is no problem at these sizes: cond(V'V) = 3.8e2, 6.6e3, 2.3e5 and 4.7e6 for m = 2 to 5. Coefficients agree with the exact rational solution to all 8 printed decimals.

### Are the numbers right?
The instrumented copies (`review/inst_*.jl`) print the script's coefficients, its RMS and its residual orthogonality. `review/indep.py` solves the normal equations exactly in rational arithmetic and cross-checks with `numpy.linalg.lstsq`.

| m | script coeffs (a0..am) | exact rational coeffs | script RMS | exact RMS | script max|V'r| |
|---|---|---|---|---|---|
| 2 | 4.674251365, 0.528609515, -0.075634408 | 4.67425137, 0.52860951, -0.07563441 | 0.0524514345 | 0.052451435 | 3.2e-14 |
| 3 | 4.668626411, 0.489392494, -0.074238666, 0.002676594 | 4.66862641, 0.48939249, -0.07423867, 0.00267659 | 0.0276732099 | 0.02767321 | 1.0e-13 |
| 4 | 4.628628162, 0.496687229, -0.058234301, 0.002013949, -0.000801378 | 4.62862816, 0.49668723, -0.05823430, 0.00201395, -0.00080138 | 0.0073399680 | 0.007339968 | 2.6e-13 |
| 5 | 4.632323750, 0.508853540, -0.060625943, -0.000737810, -0.000650515, 0.000116670 | 4.63232375, 0.50885354, -0.06062594, -0.00073781, -0.00065051, 0.00011667 | 7.86e-15 | 0 (exact) | 1.2e-12 |

Property checks:
- Least-squares residual is orthogonal to the basis: exactly zero in rational arithmetic and ≤ 1.2e-12 in the script's floats.
- Interpolation at m = n-1 = 5: exact residuals all zero.
- Partial-sum RMS per frame, script vs exact, agree to all printed digits (see ledger A8). For example, m=5: 1.9756903, 0.8778947, 0.1777354, 0.2026747, 0.1051053, 0.

### Are the reference values right?
The only "reference" drawn is the full fit `p_m` (gray dashed), computed from the same verified coefficients. The "RMS(final)" annotation equals the exact RMS; for m=5 it shows the floating-point roundoff 7.86e-15, which the page explains. The degree-0 comparison value quoted on the page (mean 3.8167) is correct.

### Does the picture show what was computed?
I viewed every frame of all four GIFs via the contact sheets (3, 4, 5 and 6 frames; committed GIFs are byte-identical to the regenerated ones).
- Titles "Degree-m LS fit: partial sum through x^k" have the right m and k in every frame. The legend reads "final pm(x)" with the right m.
- The partial-sum curve in each frame matches the computed range. For example, m=2, k=1 is the line 4.674 + 0.529x, running from 2.03 at x=-5 to 7.05 at x=4.5. It leaves the top of the window near x ≈ 2.9, as the frame shows. Clipping a partial sum like this is acceptable: the page says partial sums are not fits.
- Orange residual segments run from each data point to the partial sum at that $x_i$ (lines 47–50). In the frames they shrink to invisibility in the final frame, consistent with the RMS.
- The RMS(partial)/RMS(final) annotations match the instrumented output in every frame.
- Display limits are x ∈ [-5, 4.5] and y ∈ [0, 6.2]. The final p4 and p5 go below 0 at x = -5 (-0.063 and -0.107) and are clipped at the bottom-left corner. This is cosmetic and does not change any conclusion. Its only relevance is that the window hides the extrapolation behaviour the page mentions (F1).

### Could not determine
- Mathews' Example 7 generating function and plots: the archive is missing images gr_88 to gr_103, so only the data (gr_86) could be read. This does not affect any claim on the page.

