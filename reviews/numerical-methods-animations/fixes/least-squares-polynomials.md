# Fix record: least-squares-polynomials

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/least-squares-polynomials/fix/` (called `$FIX` below).

- `$FIX/repro/reviewer/`: the round-1 scripts (`check_fits.py`, `quintic_rms.py`, `print_a{a,b,c,d}.jl`), re-run unchanged against the HEAD coefficients.
- `$FIX/repro/check.py` (+ `check_out.txt`): independent exact check (sympy rationals) of every number the fixed page states. Run with `/usr/bin/python3 -I`.
- `$FIX/repro/check_coeffs_change.py` (+ `_out.txt`): exact check that lowering the degree changes every coefficient.
- `$FIX/postfix/print_postfix.jl` (+ `postfix_out.txt`): evaluates the setup code of each fixed script (everything before `anim = @animate`) and prints the computed coefficients, residuals, RMS per frame and the exact label/title text.
- `$FIX/committed/{aa,ad}/`: frames of the HEAD GIFs. `$FIX/new/{aa,ab,ac,ad}/`: frames of the regenerated GIFs. sha256 lists in `committed/sha256.txt` and `new/sha256.txt`.

## Findings

### F1 — Misleading — fixed
- **Reproduced:** `julia print_a{a..d}.jl` (HEAD coefficients): partial-sum RMS aa k=0 1.99337, k=1 0.89688; ad k=2 0.17774, k=3 0.20267, k=4 0.10511. `check.py` gives the true LS RMS by degree 1.7994598, 0.54048016, 0.052451434, 0.027673210, 0.0073399680, 0, and the degree-0 fit a0 = 229/60 = 3.8166667 (the mean). For every m = 2..5 and every k < m the partial-sum RMS is strictly larger than the degree-k LS RMS (`partial > LS: True` in all 14 cases); for m = 5 the partial RMS is not monotone in k. Committed `ad/frame_004.png` shows title "Least Squares Polynomial Fit: Degree 5 (terms through x^3)" with RMS(partial) 0.20267.
- **Change (first option of the suggested fix, the smaller change):**
  - All four scripts: title "Least Squares Polynomial Fit: Degree m (terms through x^k)" → "Degree-m LS fit: partial sum through x^k"; legend "partial polynomial" → "partial sum through x^k"; header comments say that frame k is a partial sum, is not the degree-k LS fit for k < m, and that its RMS need not decrease.
  - `index.qmd` Animations intro (was line 36, "term-by-term construction …"): now says each animation draws the degree-m LS polynomial one partial sum at a time, only the last frame (k = m) is a LS fit, lowering the degree changes every coefficient (degree-0 fit = mean 3.8167, while a0 ranges 4.629–4.674), each earlier partial sum has a larger RMS than the degree-k LS fit, and in Case 4 the partial RMS rises from 0.17774 (k=2) to 0.20267 (k=3).
  - All four alt texts: "construction term-by-term" → "drawn as partial sums through x^0 … x^m".
- **Check:** new frames viewed (see Scripts and GIFs): titles read "Degree-m LS fit: partial sum through x^k", legend "partial sum through x^k"; ad frame_004 shows 0.20267, frame_003 0.17774. Numbers in the new text are in the ledger.
- Line 32 ("As the degree increases from 2 to 5, RMS decreases") was kept: it is about the LS fits and is true (`check.py` → strictly decreasing 0..5).

### F2 — Minor — fixed
- **Reproduced:** `check_fits.py`: for m = 5 exact SSE = 0, script coefficients differ from exact by up to 4.61e-09, RMS(script c) = 9.54956e-07; `print_ad.jl`: final_rms = 9.549557e-7, label "0.0". `quintic_rms.py`: polyfit 2.82e-15, lstsq 7.08e-14, normal eq 4.44e-15, solve V 4.05e-16 (the review quoted slightly different noise values, 3.09e-15 etc.; the point stands: the value is solver noise, the exact value is 0). For m = 2, 3, 4 the hard-coded values agree with the exact solution to within 4.96e-9.
- **Change:**
  - All four scripts: hard-coded `coeffs = [...]` replaced with `V = [x^j for x in x_data, j in 0:m]; coeffs = (V' * V) \ (V' * y_data)`, i.e. the normal equations the page presents (`using LinearAlgebra`, stdlib). Added `m = <degree>` and `for k in 0:m`.
  - RMS labels formatted with `fmt_rms(r) = r >= 1e-4 ? @sprintf("%.5f", r) : @sprintf("%.2e", r)` (`using Printf`, stdlib), so the quintic no longer shows a rounded "0.0".
  - `index.qmd` Case 4: "RMS ≈ 2.9×10⁻¹⁵" → "RMS = 0 (exact interpolation)"; Behavior "interpolates all points essentially exactly, so RMS is near machine precision" → "interpolates all six points, so its RMS is exactly 0; the animation's floating-point solve shows roundoff of about 8×10⁻¹⁵".
  - Line 38 now says the scripts compute the coefficients from the normal equations.
- **Check:** `julia print_postfix.jl`: computed coefficients agree with the page's 5-decimal values for all four cases (e.g. m=5: 4.6323237, 0.5088535, −0.0606259, −0.0007378, −0.0006505, 0.0001167); final RMS 0.05245143, 0.02767321, 0.00733997 (match exact to 1e-11) and 7.859e-15 for m = 5, label "RMS(final) = 7.86e-15". Quintic residuals are all below 1.6e-14 (largest −1.51e-14). New ad frame_006 shows "RMS(final) = 7.86e-15".

### F3 — Minor — fixed
- **Reproduced:** `check.py` → quadratic residuals 0.0639, −0.0918, −0.0140, 0.0487, 0.0231, −0.0299 at x = −4.5, −3.2, −1.4, 0.8, 2.5, 4.1. Ordered by size: −3.2 (0.0918), −4.5 (0.0639), 0.8 (0.0487), 4.1 (0.0299), 2.5 (0.0231), −1.4 (0.0140). The right end (0.0299) is smaller than x = 0.8 (0.0487), so "larger error near the ends" is false. (The review printed −0.0141 for x = −1.4; exact is −0.014045, i.e. −0.0140. Not used on the page.)
- **Change:** `index.qmd` Case 1 Behavior: "with small residuals near the center and slightly larger error near the ends." → "with all residuals below $0.1$ in size; the two largest are at the two leftmost points ($x=-4.5$ and $x=-3.2$)."
- **Check:** `check.py` → max |res| = 0.09180, all < 0.1: True; two largest at −3.2 and −4.5, which are the two smallest x values.

### F4 — Minor — fixed
- **Reproduced:** committed `ad/frame_004.png` shows "S(partial) = 0.20267" with the "RM" cut off by the left axis; the RMS(final) label sits flush at the edge.
- **Change:** both `annotate!` calls in all four scripts use `text(..., 9, :black, :left)` (anchor unchanged at x = −4.8).
- **Check:** new aa frame_001, ab frame_004, ad frame_004/006 and the ac sheet show "RMS(partial) = …" and "RMS(final) = …" in full, inside the plot box.

## Ledger of changed text

`check.py` = `/usr/bin/python3 -I $FIX/repro/check.py`; `postfix` = `cd $FIX/postfix && julia print_postfix.jl`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Animations intro | "draws the degree-m least-squares polynomial one partial sum at a time … partial sum a0 + a1x + ⋯ + akx^k of its coefficients, with k increasing frame by frame" | scripts: frame k plots `partial_eval(x, coeffs, k)` for k in 0:m; new frames' titles "partial sum through x^0 … x^m" | yes |
| same | "Only the last frame (k = m) is a least-squares fit" | check.py → for all m, k < m the partial RMS > LS RMS (strict), so no earlier frame is a LS fit; at k = m partial = p_m | yes |
| same | "lowering the degree changes every coefficient" | check_coeffs_change.py → every coefficient differs: True (min difference 1.5e-4) | yes |
| same | "degree-0 fit is the mean 3.8167" | check.py → a0 = 229/60 = 3.8166667 = mean y | yes |
| same | "a0 ranges from 4.629 to 4.674 across the four cases" | check_coeffs_change.py → 4.67425, 4.66863, 4.62863, 4.63232; min/max 4.629 4.674 | yes |
| same | "Each of these earlier partial sums has a larger RMS than the degree-k least-squares fit" | check.py → `partial > LS: True` for all 14 (m, k<m) pairs | yes |
| same | "its RMS need not fall … in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3" | check.py → m=5 k=2 0.17774, k=3 0.20267; postfix → 0.1777354, 0.2026747; ad frames 003/004 | yes |
| index.qmd line 38 | "scripts … compute the coefficients from the normal equations" | scripts: `coeffs = (V' * V) \ (V' * y_data)` | yes |
| index.qmd Case 1 Behavior | "all residuals below 0.1 in size" | check.py → max \|res\| 0.09180; all < 0.1 True | yes |
| same | "the two largest are at the two leftmost points (x = −4.5 and x = −3.2)" | check.py → order by \|res\|: −3.2 (0.0918), −4.5 (0.0639), then 0.8 (0.0487) | yes |
| index.qmd Case 1 alt | "partial sums through x^0, x^1 and x^2, ending with the smooth concave-down fitted curve" | aa has 3 frames k = 0,1,2; a2 = −0.0756 < 0 (concave down) | yes |
| index.qmd Case 2 alt | "partial sums through x^0 to x^3, ending with the fitted cubic, whose RMS is lower than the quadratic's" | 4 frames; check.py → 0.02767 < 0.05245 | yes |
| index.qmd Case 3 alt | "partial sums through x^0 to x^4, ending with a close fit to all six points" | 5 frames; postfix → quartic residuals max \|·\| 0.0106 | yes |
| index.qmd Case 4 Behavior | "six data points at distinct x values … interpolates all six points, so its RMS is exactly 0" | check.py → RMS(5) exact = 0; x values distinct | yes |
| same | "the animation's floating-point solve shows roundoff of about 8×10⁻¹⁵" | postfix → final_rms 7.859e-15, label "7.86e-15"; ad frame_006 | yes |
| index.qmd Case 4 formula | "RMS = 0 (exact interpolation)" | check.py → exact SSE 0 | yes |
| index.qmd Case 4 alt | "partial sums through x^0 to x^5, ending with the polynomial that passes through all six data points" | 6 frames; postfix residuals ≤ 1.51e-14 | yes |
| scripts, title | "Degree-m LS fit: partial sum through x^k" | frames viewed; fits in the 680 px frame | yes |
| scripts, legend | "partial sum through x^k", "final pm(x)" | frames viewed | yes |
| scripts, labels | RMS(partial)/RMS(final): aa 1.99337, 0.89688, 0.05245; ab 1.99095, 0.92296, 0.13392, 0.02767; ac 1.97417, 0.88548, 0.22093, 0.16715, 0.00734; ad 1.97569, 0.87789, 0.17774, 0.20267, 0.10511, 7.86e-15 | postfix output; check.py exact values agree to 5 dp; frames viewed | yes |
| scripts, header comments | "frame k draws the partial sum … for k < m that curve is NOT the degree-k LS fit, and its RMS need not decrease … last frame (k = m) is the full LS fit" | as intro rows above | yes |

Unchanged page numbers re-checked because the scripts now compute the coefficients: all coefficients in the four formula lines and RMS 0.05245, 0.02767, 0.00734 match `check.py` (exact, 5 dp).

## Scripts and GIFs
- **Scripts changed:** `leastsqpolyaa.jl`, `leastsqpolyab.jl`, `leastsqpolyac.jl`, `leastsqpolyad.jl` (computed coefficients, partial-sum titles/legend, left-aligned significant-figure RMS labels, header comments). Style, colours, window and `@__DIR__` outputs unchanged; only `LinearAlgebra` and `Printf` (stdlib) added.
- **GIFs regenerated:** all four (frame counts unchanged: 3, 4, 5, 6). A second run gave identical sha256 for all four (aa f274edab…, ab b390da80…, ac 8219f4ae…, ad e1264ead…), so output is deterministic.
- **Frames viewed:** aa frame_001 (full size), ab frame_004 (full), ac sheet (all 5 frames), ad frame_004 and frame_006 (full). Checked: title and legend text and index k, both RMS labels fully visible and matching postfix values, partial-sum curve drawn from the computed coefficients (constant at a0 ≈ 4.674 in aa k=0), final frame overlays the dashed p_m.
- **git status of the page folder after regeneration:**
  ```
   M pages/numerical-methods/least-squares-polynomials/index.qmd
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyaa.gif
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyaa.jl
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyab.gif
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyab.jl
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyac.gif
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyac.jl
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyad.gif
   M pages/numerical-methods/least-squares-polynomials/leastsqpolyad.jl
  ```
  All four GIFs were expected to change (titles, labels and computed coefficients all changed).

## Legacy archive
- **Consulted:** `n2003/LeastSqPolyMod.html`, `leastsquarespoly/LeastSqPolyMod/Links/LeastSqPolyMod_lnk_{2..7}.html`, graph/code images `LeastSqPolyMod_gr_39, 41, 48, 71, 74, 75`.
- **What it showed:** Examples 2–5 use the same six points {(−4.5,0.7), (−3.2,2.3), (−1.4,3.8), (0.8,5.0), (2.5,5.5), (4.1,5.6)} and Mathematica's `Fit` for degrees 2–5; each shows a static plot of the final fit (no term-by-term or partial-sum animation). His quintic is p5 = 4.63232 + 0.508854x − 0.0606259x² − 0.00073781x³ − 0.000650515x⁴ + 0.00011667x⁵, matching the computed fit, and he prints "The RMS error E5 is 4.27177×10⁻¹⁴ ≈ 0". Example 6 explains that six points with distinct abscissas give an exact fit; it also says RMS "often" decreases with degree for polynomial-type data.
- **Difference from the fixed page:** the partial-sum animation is the site's own device, not Mathews'; the page now labels it as such. Mathews' 4.27e-14 is, like the old page's 2.9e-15, roundoff from one solver; the page follows the mathematics (RMS = 0) and states the script's own roundoff.

## Notes
- **Decision:** F1 offered two fixes; I took the first (relabel as partial sums, explain in text), the smaller change consistent with D7. The alternative (draw the true degree-k LS fit in each frame) would make all four animations near-duplicates and add drawing logic.
- **Not changed (not findings):** the final quartic and quintic curves dip slightly below y = 0 near x = −5 (min −0.063 and −0.107 on the window) and the k = 1 partial lines exceed y = 6.2 on the right; both are clipped by the axes. Case 2/3 Behavior sentences were not in the findings and were left (Case 3's "about a factor of four": 0.02767/0.00734 = 3.77).
- **Outside this page:** none noticed.

## Resolution check (independent checker, not shown this record)

Independent references: `check/exact.py` (sympy, exact rational least-squares fits of degree 0..5, exact partial-sum RMS for every case and k) and `check/print_vals.jl` (Julia, the scripts' own normal-equations solve, coefficients, RMS labels exactly as `fmt_rms` formats them, cond(V'V)). Frames: `check/frames/{aa,ab,ac,ad}/` from the committed GIFs.

### Original findings

### F1 — resolved
- Evidence: The fixer chose option 1 (explain partial sums) and did it fully.
  - **Page text (line 36):** "term-by-term construction" is gone. The page now says the frames are partial sums a0+…+ak x^k of the degree-m coefficients, that only the last frame (k=m) is a least-squares fit, that earlier partial sums are not degree-k LS fits, and that their RMS need not fall.
  - **Numbers:** mean 3.8167 (exact 3.816667). a0 range 4.629–4.674 (exact 4.62863, 4.63232, 4.66863, 4.67425). Case 4 RMS(partial) 0.17774 at k=2 and 0.20267 at k=3 match exactly.
  - **"Each earlier partial sum has a larger RMS than the degree-k LS fit":** checked for all 14 (m, k<m) pairs. For example m=5, k=4 gives 0.10511 vs 0.00734, and m=3, k=2 gives 0.13392 vs 0.05245. It holds strictly in every case.
  - **Scripts:** The title is now "Degree-m LS fit: partial sum through x^k" and the legend reads "partial sum through x^k". The header comments state that the k<m curves are not LS fits.
  - **Frames:** The new title and legend are legible in aa/frame_001, ab sheet, ac/frame_003 and ad/frame_004.

### F2 — resolved
- Evidence:
  - **Scripts:** All four scripts now build `V = [x^j for x in x_data, j in 0:m]` and solve `(V'V) \ (V'y)`. No coefficient literals remain. The Julia coefficients agree with the exact rational solution to about 1e-14, even for m=5, where cond(V'V) = 4.7e6.
  - **Page, line 74:** It now reads "RMS = 0 (exact interpolation)". This is correct: the exact SSE for m=5 is 0, and the six x values are distinct.
  - **Page, line 72:** It now says the floating-point solve shows roundoff of about 8e-15. The script computes final RMS = 7.859e-15, and the last frame of the GIF shows "RMS(final) = 7.86e-15". The old 9.55e-7 / "0.0" mismatch is gone.
  - **Other cases:** The displayed p2–p5 coefficients and RMS values (unchanged lines 44/54/64/74) still match the exact values to the digits shown.

### F3 — resolved
- Evidence: Exact quadratic residuals are [0.0639, −0.0918, −0.0140, 0.0487, 0.0231, −0.0299]. All are below 0.1 in size, and the two largest in size are at x = −4.5 and x = −3.2, the two leftmost points. The new sentence is true and the false "larger error near the ends" clause is gone.

### F4 — resolved
- Evidence: The annotations now use `:left` alignment. In the full-size frames aa/frame_001, aa/frame_003, ac/frame_003, ac/frame_005, ad/frame_004 and ad/frame_006, "RMS(partial) = …" and "RMS(final) = …" are fully visible inside the axes, and nothing is clipped.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:36 | partial sum a0+a1x+…+akx^k, k increasing frame by frame | script `partial_eval`, frames | correct |
| index.qmd:36 | "Only the last frame (k=m) is a least-squares fit" | partial-sum RMS > LS RMS strictly for every k<m | correct |
| index.qmd:36 | degree-0 fit is the mean 3.8167 | exact 3.816667 | correct |
| index.qmd:36 | a0 ranges 4.629 to 4.674 | exact 4.62863…4.67425 | correct |
| index.qmd:36 | partial sums have larger RMS than degree-k LS fit | all 14 pairs checked | correct |
| index.qmd:36 | Case 4 RMS rises 0.17774 (k=2) → 0.20267 (k=3) | exact and Julia both | correct |
| index.qmd:38 | scripts compute coefficients from the normal equations | script source | correct |
| index.qmd:42 | all residuals below 0.1; two largest at x=−4.5, −3.2 | exact residuals | correct |
| index.qmd:48 alt | partial sums through x^0, x^1, x^2; ends with concave-down fitted curve | 3 frames, a2<0 | correct |
| index.qmd:58 alt | partial sums x^0 to x^3; cubic RMS lower than quadratic's | 0.02767 < 0.05245; 4 frames | correct |
| index.qmd:68 alt | partial sums x^0 to x^4; close fit to all six points | RMS 0.00734; 5 frames | correct |
| index.qmd:72 | distinct x, degree 5 interpolates, RMS exactly 0 | exact SSE = 0 | correct |
| index.qmd:72 | roundoff about 8×10⁻¹⁵ | Julia 7.86e-15 | correct |
| index.qmd:74 | RMS = 0 (exact interpolation) | exact | correct |
| index.qmd:78 alt | partial sums x^0 to x^5; passes through all six points | ad/frame_006 | correct |
| scripts: header comments | normal equations; k<m not LS fits; RMS need not decrease | as above | correct |
| scripts: title | "Degree-m LS fit: partial sum through x^k" | frames | correct, legible |
| scripts: legend | "final pm(x)", "partial sum through x^k" | frames | correct |
| scripts: RMS labels | fmt_rms: %.5f if ≥1e-4 else %.2e | aa 1.99337/0.89688/0.05245; ab 1.99095/0.92296/0.13392/0.02767; ac 1.97417/0.88548/0.22093/0.16715/0.00734; ad 1.97569/0.87789/0.17774/0.20267/0.10511/7.86e-15 match exact (last = roundoff) | correct |

### New problems
None. This rests on:
- the exact sympy check of every new number and claim;
- full-size inspection of the first, middle and last frames of each GIF, plus the ab contact sheet. Every drawn element is built from the right quantities: the dashed curve is p_m, the solid curve is the partial sum, and the orange stems run from the data to the partial sum. All text is legible, and nothing that was correct before is broken.

The unchanged lines 32, 52 and 62 were also spot-checked and still agree with the data. RMS decreases from degree 2 to 5, and 0.02767/0.00734 ≈ 3.8 ("about a factor of four").

### Reproducibility and conventions
- Each of the four scripts was run from a scratch copy (`check/run/`). All four GIFs are byte-identical (`cmp`) to the committed GIFs.
- The page keeps the conventions:
  - Description comes before Animations.
  - Each case has one `[Julia source]` link and one GIF embed.
  - The alt text is descriptive.
  - There are no code blocks.
- The fix diff touches only files in `pages/numerical-methods/least-squares-polynomials/`.

**Final status:** committed
