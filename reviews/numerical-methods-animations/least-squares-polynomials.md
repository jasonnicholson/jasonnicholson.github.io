# Least Squares Polynomials — animation review

Page: [`pages/numerical-methods/least-squares-polynomials/index.qmd`](../../pages/numerical-methods/least-squares-polynomials/index.qmd) · Scripts: `leastsqpolyaa.jl`, `leastsqpolyab.jl`, `leastsqpolyac.jl`, `leastsqpolyad.jl` · GIFs: 4

**Result:** 0 error, 1 misleading, 3 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — Intermediate frames are truncations of the final polynomial, not least-squares fits, yet are presented as "construction of the least-squares polynomial fit"

- **Location:** index.qmd:36: "Each animation below shows the **term-by-term construction** of the least-squares polynomial fit". All four scripts, line 16 (`partial_eval`) and line 29 (title "Least Squares Polynomial Fit: Degree m (terms through x^k)").
- **Now:** Frame k draws a0 + a1 x + … + ak x^k, using the final degree-m coefficients. Its title reads "Least Squares Polynomial Fit: Degree m (terms through x^k)" and it shows "RMS(partial)". The page calls this a "construction" of the fit.
- **True:** Least-squares fits are not built term by term. Adding a degree changes every coefficient, as the page's own four cases show: a0 = 4.674, 4.669, 4.629, 4.632. The intermediate curves are not the lower-degree least-squares fits, and their RMS is much worse:
  - **Constant frame (k = 0):** draws y ≈ 4.63–4.67 with RMS(partial) ≈ 1.97–1.99. The degree-0 least-squares fit is the mean, 3.8167, with RMS 1.7995.
  - **Linear frame (k = 1):** draws 4.674 + 0.529x (case 1) with RMS 0.897. The least-squares line is 3.976 + 0.563x with RMS 0.540.
  - **Case 4 (quintic):** RMS(partial) goes up when the x³ term is added: 0.17774 at k = 2, then 0.20267 at k = 3.

  A viewer who reads each frame as "the least-squares fit so far" learns the wrong idea. They would also see RMS rise with degree, against the page's own statement (line 32) that RMS decreases with degree.
- **Evidence:** `python3 -I reviewer/check_fits.py` gives m=0: a=[3.81666667], RMS 1.799459795; m=1: a=[3.97632107, 0.56348612], RMS 0.5404801558. `julia reviewer/print_aa.jl` gives k=0 RMS(partial)=1.99337, k=1 0.89688. `julia reviewer/print_ad.jl` gives k=2 0.17774, k=3 0.20267, k=4 0.10511. The frames show the same values (committed/leastsqpolyad/sheet.png).
- **Suggested fix:** Either:
  - say explicitly at line 36 that the intermediate curves are truncations (partial sums) of the final degree-m polynomial, are not least-squares fits of lower degree, and that their RMS need not decrease; and change the frame title to something like "Degree-m LS fit: partial sum through x^k", or
  - make each frame show the actual degree-k least-squares fit (solve for each k), which really demonstrates RMS falling with degree.

- **Independent check:** confirmed.

### F2 — Minor — Implementation / Page match — Coefficients are hard-coded rather than computed; the quintic RMS stated on the page is not what the script computes

- **Location:** leastsqpolyaa.jl:10, leastsqpolyab.jl:10, leastsqpolyac.jl:10, leastsqpolyad.jl:10 (`coeffs = [...]` literals). index.qmd:74: "$\mathrm{RMS}\approx 2.9\times 10^{-15}$". index.qmd:72: "RMS is near machine precision".
- **Now:**
  - **Scripts:** None of the four performs a least-squares solve. They plot coefficients typed in to 8 decimals. Line 38 of the page says the scripts "generated these animations", but a reader opening a script finds no normal equations or QR.
  - **Quintic RMS:** Because the coefficients are rounded, the script's quintic RMS(final) is 9.55e-7, and the GIF shows it rounded as "RMS(final) = 0.0". The page instead states 2.9e-15.
- **True:**
  - **Exact value:** In exact arithmetic the quintic least-squares fit interpolates the six points, so RMS is exactly 0.
  - **The 2.9e-15 figure:** This is floating-point noise from one particular solver and is not reproducible as a property of the fit. polyfit gives 3.09e-15, the normal equations 4.07e-15, lstsq 7.02e-14 and `solve(V, y)` 7.5e-16.
  - **The plotted curve:** The script's own curve misses the data by up to 1.75e-6 (at x = −4.5). The visual claim "exact-through-points" holds, but "near machine precision" does not describe what the script computes.
  - **Other cases:** For m = 2, 3, 4 the hard-coded values agree with the exact solution to within 5e-9, so the displayed numbers there are right.
- **Evidence:**
  - `python3 -I reviewer/check_fits.py`: for m=5, exact SSE=0, and the script coefficients' max difference from exact is 4.61e-09 with RMS(script c)=9.54956e-07.
  - `python3 -I reviewer/quintic_rms.py`: polyfit 3.09e-15, lstsq 7.02e-14, normal eq 4.07e-15, solve V 7.5e-16; the script coefficients give residuals [1.75e-6, 4.8e-7, 2.4e-8, 3.2e-9, 2.0e-7, 1.46e-6].
  - `julia reviewer/print_ad.jl`: final_rms = 9.549557e-7, shown 0.0.
- **Suggested fix:**
  - **Scripts:** Compute the coefficients in each script, for example `V = [x^j for x in x_data, j in 0:m]; coeffs = V \ y_data`, so the source actually demonstrates the method.
  - **Page, line 74:** Replace "RMS ≈ 2.9×10⁻¹⁵" with "RMS = 0 (exact interpolation; floating-point evaluation gives ~10⁻¹⁵)".

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Page match — Case 1 residual pattern misdescribed

- **Location:** index.qmd:42: "with small residuals near the center and slightly larger error near the ends."
- **Now:** The page says the residuals are larger at both ends.
- **True:** The quadratic's residuals p₂(xᵢ) − yᵢ at x = −4.5, −3.2, −1.4, 0.8, 2.5, 4.1 are 0.0639, −0.0918, −0.0141, 0.0487, 0.0231, −0.0299.
  - The largest error is at the second point (x = −3.2), not at an end.
  - On the right, the end residual (0.030) is smaller than the near-centre residual at x = 0.8 (0.049).
  - Only the left side shows larger error.
- **Evidence:** `python3 -I reviewer/check_fits.py`, m=2 "residuals exact".
- **Suggested fix:** Use "residuals are all below 0.1; the largest are on the left (x = −4.5, −3.2)", or drop the residual-location clause.

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — RMS annotation labels are cut off at the left edge in every frame

- **Location:** All four scripts, lines 42–43: `annotate!(xlims[1] + 0.2, ..., text("RMS(partial) = ...", 9, :black))`. The text is centred at x = −4.8, so its left half runs past the axis.
- **Now:** The frames read "S(partial) = 1.99337" and "MS(final) = 0.05245" (committed/leastsqpolyaa/frame_001.png, committed/leastsqpolyad/frame_006.png). The numbers can still be read, but the labels are truncated.
- **True:** The labels should read "RMS(partial)" and "RMS(final)".
- **Evidence:** Visual inspection of the full-size frames listed above and of every contact sheet.
- **Suggested fix:** Use `text(..., 9, :black, :left)` (left-aligned), or move the anchor right.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `leastsqpolyaa.jl` | yes | 3.0 | leastsqpolyaa.gif |
| `leastsqpolyab.jl` | yes | 3.0 | leastsqpolyab.gif |
| `leastsqpolyac.jl` | yes | 3.0 | leastsqpolyac.gif |
| `leastsqpolyad.jl` | yes | 3.0 | leastsqpolyad.gif |

Committed GIFs byte-identical to their regenerated output: **4 of 4**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 14 | $p_m(x)=a_0+a_1x+\cdots+a_mx^m$ | Scripts' `poly_eval` uses the monomial basis c[i]·x^(i−1) | confirmed |
| 2 | 18 | $E=\sum(p_m(x_i)-y_i)^2$ is minimized | The exact solution of the normal equations gives Vᵀr = 0 exactly for m = 0..5 (check_fits.py) | confirmed |
| 3 | 22 | Normal equations $(V^TV)\mathbf a=V^T\mathbf y$ | Solving them in exact rationals reproduces every script coefficient to ≤5e-9 | confirmed (but scripts do not solve them; → F2) |
| 4 | 26 | RMS = sqrt((1/n)Σ(p−y)²) | Scripts line 20/25 divide by length(x_data) = 6 | confirmed |
| 5 | 30 | Data (−4.5,0.7),(−3.2,2.3),(−1.4,3.8),(0.8,5.0),(2.5,5.5),(4.1,5.6) | Scripts line 8–9 identical in all four scripts | confirmed |
| 6 | 32 | "As the degree increases from 2 to 5, RMS decreases" | LS RMS: 0.052451, 0.027673, 0.007340, 0 | confirmed |
| 7 | 32 | Higher degree "does not always mean better behavior outside the data interval… oscillations… poor extrapolation" | General statement; the animations barely leave the data interval ([−5, 4.5] vs [−4.5, 4.1]) and show no wiggle | confirmed as a general statement (not demonstrated by these GIFs) |
| 8 | 36 | Animations show the "term-by-term construction of the least-squares polynomial fit" | Frames show truncations of the final polynomial, not LS fits of lower degree | wrong (→ F1) |
| 9 | 36 | "The blue points are the data" | Royal-blue scatter, legend "data points" | confirmed |
| 10 | 36 | "the gray dashed curve is the final fitted polynomial" | gray45, ls = :dash, y_full = poly_eval with the full coeffs | confirmed |
| 11 | 36 | "the solid colored curve is the partial polynomial built from terms up to degree k" | partial_eval sums c[1..k+1]; the frame title gives k | confirmed |
| 12 | 38 | Julia source scripts "generated these animations" | Manifest: every GIF is byte-identical to its script's output | confirmed (scripts plot hard-coded coefficients; → F2) |
| 13 | 40 | Case 1 is a quadratic, m = 2 | aa: 3 coeffs, k in 0:2, title "Degree 2" | confirmed |
| 14 | 42 | "The quadratic captures the main concave-down trend well" | a2 = −0.0756 < 0; p'' = −0.151; RMS 0.052 | confirmed |
| 15 | 42 | "small residuals near the center and slightly larger error near the ends" | Residuals 0.064, −0.092, −0.014, 0.049, 0.023, −0.030 | wrong (→ F3) |
| 16 | 44 | p₂ = 4.67425 + 0.52861x − 0.07563x² | Exact: 4.67425137, 0.52860951, −0.07563441 | confirmed |
| 17 | 44 | RMS ≈ 0.05245 | Exact 0.0524514345; GIF shows 0.05245 | confirmed |
| 18 | 46, 48 | Case 1 link/embed → leastsqpolyaa.jl / .gif | Manifest: aa.gif produced by aa.jl; degree 2 | confirmed |
| 19 | 48 | Alt text: "…ending with a smooth concave-down curve" | aa frame_003 | confirmed |
| 20 | 50 | Case 2 is a cubic, m = 3 | ab: 4 coeffs, title "Degree 3" | confirmed |
| 21 | 52 | "Adding the cubic term… lowers RMS" | 0.05245 → 0.02767 | confirmed |
| 22 | 52 | "tracks the left and right tails a bit more closely" | \|r\| at x = −4.5: 0.064→0.019; −3.2: 0.092→0.045; 4.1: 0.030→0.012 (but 2.5: 0.023→0.030) | confirmed (endpoints both improve) |
| 23 | 52 | "remaining stable across the plotted interval" | p₃ is concave on [−5, 4.5], max 5.613, no oscillation (curvature.py, ab frame_004) | confirmed |
| 24 | 54 | p₃ = 4.66863 + 0.48939x − 0.07424x² + 0.00268x³ | Exact 4.66862641, 0.48939249, −0.07423867, 0.00267659 | confirmed |
| 25 | 54 | RMS ≈ 0.02767 | Exact 0.0276732099 | confirmed |
| 26 | 56, 58 | Case 2 link/embed → leastsqpolyab | Manifest | confirmed |
| 27 | 58 | Alt: "improved alignment to data compared with the quadratic model" | RMS 0.0277 vs 0.0525 | confirmed |
| 28 | 60 | Case 3 is a quartic, m = 4 | ac: 5 coeffs, title "Degree 4" | confirmed |
| 29 | 62 | "The quartic noticeably reduces residuals" | max \|r\| 0.045 → 0.0106 | confirmed |
| 30 | 62 | "follows the subtle curvature changes between middle and right-side points" | Too vague to test; p₄ has no inflection on the window (p'' ∈ [−0.417, −0.113]) | could not determine (claim not specific enough to check) |
| 31 | 62 | "RMS drops by about a factor of four compared with the cubic" | 0.0276732 / 0.0073400 = 3.77 | confirmed |
| 32 | 64 | p₄ = 4.62863 + 0.49669x − 0.05823x² + 0.00201x³ − 0.00080x⁴ | Exact 4.62862816, 0.49668723, −0.05823430, 0.00201395, −0.00080138 | confirmed |
| 33 | 64 | RMS ≈ 0.00734 | Exact 0.0073399680 | confirmed |
| 34 | 66, 68 | Case 3 link/embed → leastsqpolyac | Manifest | confirmed |
| 35 | 68 | Alt: "ending with a close fit to all six points" | ac frame_005; residuals ≤ 0.0106 | confirmed |
| 36 | 70 | Case 4 is a quintic, m = 5 | ad: 6 coeffs, title "Degree 5" | confirmed |
| 37 | 72 | "interpolates all points essentially exactly" | Exact SSE = 0; script curve within 1.75e-6 | confirmed |
| 38 | 72 | "so RMS is near machine precision" | Exact 0; script's value 9.5e-7 (shown 0.0) | wrong for the script (→ F2) |
| 39 | 72 | "a degree-n−1 polynomial can match n distinct points" | Vandermonde with distinct nodes is nonsingular | confirmed |
| 40 | 74 | p₅ = 4.63232 + 0.50885x − 0.06063x² − 0.00074x³ − 0.00065x⁴ + 0.00012x⁵ | Exact 4.63232375, 0.50885354, −0.06062594, −0.00073781, −0.00065051, 0.00011667 | confirmed |
| 41 | 74 | RMS ≈ 2.9×10⁻¹⁵ | Exact 0; solver-dependent 7.5e-16 to 7e-14; script 9.5e-7 | wrong as a stated value (→ F2) |
| 42 | 76, 78 | Case 4 link/embed → leastsqpolyad | Manifest | confirmed |
| 43 | 78 | Alt: "ending in an exact-through-points polynomial" | ad frame_006 | confirmed |

## Implementation checks

All four scripts share one structure. The data is on lines 8–9 and the coefficients are hard-coded on line 10. Frame k (k = 0..m) draws:
- the data points;
- the full polynomial, as a gray dashed curve;
- the truncation through x^k;
- orange segments from each data point to the truncation's value there;
- annotations RMS(partial) and RMS(final).

No least-squares solve is performed anywhere (F2). Every committed GIF is byte-identical to its script's output (manifest), so the values printed by `reviewer/print_*.jl` are exactly the ones on screen.

### leastsqpolyaa.jl
- **Method:** Plots a degree-2 polynomial whose coefficients are, to 8 decimals, the least-squares quadratic. Intermediate frames are truncations (F1).
- **Numbers (script vs independent):**
  - **Coefficients:** script [4.67425137, 0.52860951, −0.07563441]; exact rational normal-equation solution [4.67425137, 0.52860951, −0.07563441]; polyfit and lstsq agree. Max difference 4.96e-9.
  - **Orthogonality:** Vᵀr is exactly 0 for the exact solution, and ≤1.1e-6 for the script's rounded coefficients.
  - **RMS(final):** script 0.0524514345; exact 0.0524514345.
  - **RMS(partial):** k = 0: 1.99337; k = 1: 0.89688; k = 2: 0.05245. These match what the frames show.
- **Reference values:** The gray "final" curve is the same polynomial as the last frame and matches the exact fit.
- **Picture:** Contact sheet and full-size frame_001.
  - Title degree and k are correct.
  - The orange segments run from (xᵢ, yᵢ) to the truncation's value at xᵢ, as coded.
  - The k = 1 line leaves the top of the window for x ≳ 3 (17% of samples). This is harmless clipping.
  - The RMS labels are truncated at the left (F4).

### leastsqpolyab.jl
- **Method:** As above, degree 3.
- **Numbers (script vs independent):**
  - **Coefficients:** script [4.66862641, 0.48939249, −0.07423867, 0.00267659]; exact [4.66862641, 0.48939249, −0.07423867, 0.00267659]. Max difference 4.4e-9; polyfit and lstsq agree.
  - **RMS(final):** script 0.0276732099; exact 0.0276732099.
  - **RMS(partial):** k = 0..3: 1.99095, 0.92296, 0.13392, 0.02767.
- **Reference values:** The final curve is the exact fit to 8 decimals.
- **Picture:** Contact sheet and frame_004. The final curve passes close to all points and is concave throughout the window. Same label clipping (F4).

### leastsqpolyac.jl
- **Method:** As above, degree 4.
- **Numbers (script vs independent):**
  - **Coefficients:** script [4.62862816, 0.49668723, −0.05823430, 0.00201395, −0.00080138]; exact the same to 8 decimals. Max difference 2.4e-9.
  - **RMS(final):** script 0.0073399680; exact 0.0073399680.
  - **RMS(partial):** k = 0..4: 1.97417, 0.88548, 0.22093, 0.16715, 0.00734.
- **Reference values:** As above.
- **Picture:** Contact sheet. The final curve dips to −0.063 at x = −5 and is clipped at y = 0 (0.6% of samples), which is harmless. Same label clipping (F4).

### leastsqpolyad.jl
- **Method:** As above, degree 5. With n = 6 this is the interpolating polynomial.
- **Numbers (script vs independent):**
  - **Coefficients:** script [4.63232375, 0.50885354, −0.06062594, −0.00073781, −0.00065051, 0.00011667]; exact the same to 8 decimals. Max difference 4.6e-9.
  - **RMS(final):** exact SSE is 0. The script's rounded coefficients give RMS(final) 9.55e-7, which the GIF shows as 0.0. The page's 2.9e-15 is not reproduced (F2).
  - **RMS(partial):** k = 0..5: 1.97569, 0.87789, 0.17774, 0.20267, 0.10511, 0.0. The rise at k = 3 is noted in F1.
- **Reference values:** The final curve matches the data to ≤1.75e-6.
- **Picture:** Contact sheet and full-size frame_006. The final curve passes through all six points. The curve dips to −0.107 at x = −5 and is clipped at y = 0, which is harmless. Same label clipping (F4).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/least-squares-polynomials/`](evidence/least-squares-polynomials/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
