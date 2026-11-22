# Graeffe's Method — animation review

Page: [`pages/numerical-methods/graeffes-method/index.qmd`](../../pages/numerical-methods/graeffes-method/index.qmd) · Scripts: `graeffesaa.jl`, `graeffesab.jl` · GIFs: 2

**Result:** 1 error, 1 misleading, 4 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — The Separated Root Theorem formula in the Description is upside down

- **Location:** index.qmd:30 `$$|r_k|^{2^m} \approx \left|\frac{c_{n-k+1}}{c_{n-k}}\right|$$` and index.qmd:34 `$$|r_k| \approx \left|\frac{c_{n-k+1}}{c_{n-k}}\right|^{1/2^m}$$`, with line 32 "where $c_0, c_1, \ldots, c_n$ are the coefficients of $p_m$". Line 28 orders the roots by decreasing magnitude, |r_1| ≫ … ≫ |r_n|.
- **Now:** |r_k| ≈ |c_{n−k+1}/c_{n−k}|^{1/2^m}.
- **True:** Take c_j as the coefficient of x^j, matching the page's own notation a_j at line 18. Vieta's formulas then give |r_k|^{2^m} ≈ |c_{n−k}/c_{n−k+1}|; for k = 1 this is |c_{n−1}/c_n|, the sum of the squared-power roots. The page's formula is the reciprocal and so gives 1/|r_k|. If c_0 is instead taken to be the leading coefficient, the formula returns the magnitudes in reverse order (k = 1 gives the smallest root). Under neither reading does it give |r_k| as labelled. The scripts use the correct orientation, `abs(c[2]/c[1])` = |c_3/c_4| for r_1 (graeffesaa.jl:34, graeffesab.jl:31), so the page contradicts its own animations.
- **Evidence:** `python3 reviewer/extra.py` on case 1 (true magnitudes 4, 3, 2, 1):
  - m = 3, page formula with c_j the coefficient of x^j: 0.2469, 0.3357, 0.5024, 1.0005. These are the reciprocals of the true magnitudes.
  - m = 3, page formula with c_0 leading: 0.9995, 1.990, 2.979, 4.050. This is the reverse order.
  - m = 3, |c_{n−k}/c_{n−k+1}|^{1/8}: 4.050, 2.979, 1.990, 0.9995. This is correct and equals the script's values.
  - m = 5: 0.25, 0.3333, 0.5, 1.0 from the page formula against 4.00001, 2.99999, 2.0, 1.0 from the corrected one.
- **Suggested fix:** On lines 30 and 34, replace `\frac{c_{n-k+1}}{c_{n-k}}` with `\frac{c_{n-k}}{c_{n-k+1}}`. On line 32, state "where $c_j$ is the coefficient of $x^j$ in $p_m$".

- **Independent check:** confirmed.

### F2 — Misleading — Implementation — In Case 2, floating-point overflow silently empties the last three frames

- **Location:** graeffesab.jl:36 (`n_iters = 10`) together with the Float64 squaring at lines 18–26. Affects GIF frames 9–11 (m = 8, 9, 10).
- **Now:** The coefficients overflow from m = 8 onward. At m = 8 the coefficient vector is `[1.0, -1.727e179, Inf, NaN, Inf]` and the estimates are `[5.01356, Inf, NaN, NaN]`. At m = 9 and m = 10 every estimate is NaN. Plots drops these points without comment. In the final frame (titled "m = 10"):
  - r₂, r₃ and r₄ stop at m = 7.
  - r₁ stops at m = 8.
  - The right quarter of the axis (m = 8.5 to 10) is empty.
  - The frames m = 9 and m = 10 add nothing.

  The double-root traces are the subject of this case, and they stop while still visibly short of the line at 5 (r₂ = 4.973 at m = 7). Nothing on the frame or page says the computation broke down. A viewer would assume the iterations were run to m = 10.
- **True:** In exact arithmetic the estimates continue: r₁/r₂ = 5.01356/4.98648 (m = 8), 5.00677/4.99324 (m = 9), 5.00339/4.99662 (m = 10). Each step continues to halve the error, which is exactly the linear convergence the page describes.
- **Evidence:** `julia reviewer/graeffesab_print.jl` printed the overflowed values quoted under "Now". `python3 reviewer/indep.py` (case ab, 50-digit) gave the continuing values. Committed frames frame_009.png to frame_011.png show the traces ending at m = 7 and 8.
- **Suggested fix:** Pick one:
  - Set `n_iters = 7`, the last step where every coefficient is finite.
  - Compute in `BigFloat` (e.g. `c0 = big.([1, -9, 13, 45, -50])`) so that all 10 squarings are real. The page's linear-convergence story then shows to m = 10.
  - Keep m ≤ 10 and add an on-plot note that Float64 overflows after m = 7. This illustrates the limitation at line 42.

- **Independent check:** confirmed with correction. Checker: at m=8 r1=5.0136 is still valid (so frame 9 adds one point); r2=Inf, r3,r4=NaN; at m=9,10 everything is NaN, so frames 10–11 add nothing. The same overflow also removes r3, r4 at Case 1's last frame (m=8) — see F3.

### F3 — Minor — Implementation — In Case 1, overflow at the last frame drops r₃ and r₄

- **Location:** graeffesaa.jl:39 (`n_iters = 8`). Affects GIF frame 9 (m = 8).
- **Now:** At m = 8 the coefficient vector is `[1.0, -1.34e154, 1.86e276, NaN, Inf]` and the estimates are `[4.0, 3.0, NaN, NaN]`. In the last frame the orange (r₃) and purple (r₄) traces end at m = 7, while blue and red continue to m = 8. Nothing explains the gap.
- **True:** In exact arithmetic all four estimates at m = 8 equal 4, 3, 2, 1 to more than 30 digits. Their relative errors are 4e-35, −4e-35, −3e-48 and 0.
- **Evidence:** `julia reviewer/graeffesaa_print.jl` and `python3 reviewer/indep.py`. Frame frame_009.png.
- **Suggested fix:** Set `n_iters = 7`, or use `BigFloat` as in F2.

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — Some starting estimates fall outside the y-axis limits

- **Location:**
  - graeffesaa.jl:54 `ylims=(0.0, 6.0)`: the r₂ estimate at m = 0 is 6.5.
  - graeffesab.jl:52 `ylims=(0.0, 7.0)`: the r₁ estimate is 9.0 at m = 0 and 7.416 at m = 1.
- **Now:**
  - Case 1, m = 0 frame (frame_001): only 3 of the 4 legend entries have a visible marker. The red trace enters later from above the frame.
  - Case 2: the r₁ marker is missing at m = 0 and m = 1 (frames 001–002), and the solid blue trace first appears at m = 2, entering from off-screen.
  - Because of this, the "initial poor approximation" for these roots is never shown.
- **True / Evidence:** The values above are from `reviewer/graeffes*_print.jl` and match `indep.py` exactly. The frames were checked visually.
- **Suggested fix:** Raise the upper y-limits to about 7 (Case 1) and 9.5 (Case 2), or use a log y-axis.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — Linear convergence is attributed to repeated or distinct roots when it depends on equal magnitudes

- **Location:**
  - index.qmd:62 "This contrast in convergence rate is the diagnostic signature of a repeated root."
  - index.qmd:40 "For polynomials with **distinct real roots**, the approximation error decreases quadratically".
- **Now:** The page says linear convergence identifies a repeated root, and that distinct real roots give quadratic convergence.
- **True:** What matters is distinct *magnitudes*. Two distinct real roots r and −r become a double root of p_1 after the first squaring. Their estimates then behave exactly like the double root's: linear convergence with the error halving. So linear convergence signals two roots of equal modulus, which may or may not be a repeated root, and "distinct real roots" is not enough for quadratic convergence.
- **Evidence:** `python3 reviewer/extra.py` ran roots {1, −2, 5, −5} and {1, −2, 5, 5}. For every m from 1 to 8 the r₁ and r₂ estimates are identical to 8 digits, for example m = 5: 5.1094857 and 4.8928603 for both.
- **Suggested fix:**
  - Line 40: "distinct real roots" → "real roots of distinct magnitudes".
  - Line 62: "…is the diagnostic signature of two roots of equal magnitude (here a repeated root)".

- **Independent check:** not run (minor finding, unverified).

### F6 — Minor — Page match — The Case 1 alt text says every estimate grows toward its target

- **Location:** index.qmd:58 "Each colored trace shows one root-magnitude estimate growing from its initial poor approximation toward the dashed true-value line".
- **Now:** The text says every estimate grows.
- **True:** Only r₃ rises monotonically to its target (1.077 → 2). The others do not:
  - r₂ falls (6.5 → 3.017 → 2.941 → 3).
  - r₄ falls, then rises (1.714 → 0.838 → 0.981 → 1).
  - r₁ overshoots (2 → 5.477 → 4.338 → 4.05 → 4).
- **Evidence:** `reviewer/graeffesaa_print.jl` and `indep.py`.
- **Suggested fix:** "Each colored trace shows one root-magnitude estimate moving from its initial poor approximation onto the dashed true-value line".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `graeffesaa.jl` | yes | 3.2 | graeffesaa.gif |
| `graeffesab.jl` | yes | 3.4 | graeffesab.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 20–22 | p_1 has roots r_i², constructed via $p_1(x) = (-1)^n p(\sqrt x) p(-\sqrt x)$ | indep.py builds p_{m+1} from exactly this definition and finds p_m == ∏(x − r^{2^m}) for every m (True for m = 0..8 in case 1 and 0..10 in case 2). The script's E(t)² − tO(t)² gives identical coefficients (m = 1: [1, −30, 273, −820, 576] in both). | confirmed |
| 2 | 24 | Applying it m times gives roots $r_i^{2^m}$ | Same check. The numpy roots of p_m, raised to 1/2^m, give 4, 3, 2, 1 for m ≤ 3. | confirmed |
| 3 | 28–30 | $\|r_k\|^{2^m} \approx \|c_{n-k+1}/c_{n-k}\|$ | extra.py: this gives 1/\|r_k\| (0.247, 0.336, 0.502, 1.0005 at m = 3) | wrong (→ F1) |
| 4 | 34 | $\|r_k\| \approx \|c_{n-k+1}/c_{n-k}\|^{1/2^m}$ | Same as #3 | wrong (→ F1) |
| 5 | 36 | Sign determined by evaluating p at the candidate magnitude | p(4) = p(−3) = p(2) = p(−1) = 0 for case 1. The scripts do not implement this step. | confirmed (as a statement; not animated) |
| 6 | 40 | For distinct real roots the error decreases quadratically; digits roughly double | Case 1 relative errors for r₁: 8.4e-2, 1.2e-2, 6.2e-4, 3.1e-6, 1.6e-10, 8e-19, 4e-35 (digits roughly double). Fails for roots ±a (extra.py). | confirmed for Case 1; condition misstated (→ F5) |
| 7 | 42 | Coefficients grow like \|r_k\|^{2^m}; overflow after a handful of iterations | Float64 overflow at m = 8 in both scripts (largest exact coefficient about 1e353 for case 1 and 1e434 for case 2 at m = 8) | confirmed (and the animations hit it silently → F2, F3) |
| 8 | 48 | Dashed horizontal lines mark true root magnitudes; colored traces show the estimates | graeffesaa.jl:62–64 and graeffesab.jl:60–63; frames 009/011 | confirmed |
| 9 | 48 | Estimates converge toward (or slowly approach) the targets as m increases | Computed sequences (Numbers below) | confirmed |
| 10 | 52 | Case 1: f(x) = (x+1)(x−2)(x+3)(x−4) | The expansion is x⁴ − 2x³ − 13x² + 14x + 24, which equals c0 in graeffesaa.jl:11. The title matches. | confirmed |
| 11 | 52 | true \|r_k\| ∈ {1, 2, 3, 4} | numpy roots: 4, −3, 2, −1 | confirmed |
| 12 | 54 | All four estimates converge quadratically; the error roughly squares at each step | The relative errors in exact arithmetic square approximately once the roots separate (m ≥ 3), as shown in the Numbers table below | confirmed |
| 13 | 54 | Roots initially close, $\|r_1\|/\|r_2\| = 4/3$ | 4/3 is the smallest adjacent ratio (others are 3/2 and 2) | confirmed |
| 14 | 54 | A few squaring steps are enough to separate them | At m = 4 every estimate is within 6.3e-4 relative error; at m = 5, within 3.2e-6 | confirmed |
| 15 | 56, 58 | Case 1 links graeffesaa.jl and embeds graeffesaa.gif | manifest: graeffesaa.gif is byte-identical to the graeffesaa.jl output, and the script is Case 1 | confirmed |
| 16 | 58 | Alt text: four distinct real roots −3, −1, 2, 4 | numpy roots | confirmed |
| 17 | 58 | Alt text: each trace shows an estimate *growing* from its initial approximation toward the line | r₂ and r₄ decrease and r₁ overshoots | wrong (→ F6) |
| 18 | 60 | Case 2: f(x) = (x−1)(x+2)(x−5)², a repeated real root at x = 5 | The expansion is x⁴ − 9x³ + 13x² + 45x − 50, which equals c0 in graeffesab.jl:12 | confirmed |
| 19 | 60 | true \|r_k\| ∈ {1, 2, 5, 5} | numpy roots: 5, 5 (±1e-7 i, numerical splitting of the double root), −2, 1 | confirmed |
| 20 | 62 | The two double-root estimates converge linearly; the error is halved each iteration | Relative errors for r₁: 9.06e-2, 4.43e-2, 2.19e-2, 1.09e-2, 5.43e-3, 2.71e-3, 1.35e-3, 6.8e-4 (m = 3..10), a ratio of 0.5. Asymptotically r₁ ≈ 5·2^{1/2^m} and r₂ ≈ 5·2^{−1/2^m}. | confirmed (the GIF shows this only to m = 7/8 → F2) |
| 21 | 62 | Because the separated-root condition is never met when two roots share a magnitude | p_m has c_{n−1} ≈ 2·5^{2^m} and c_{n−2} ≈ 5^{2^{m+1}}, so the ratio never isolates one root | confirmed |
| 22 | 62 | The two simple roots (1 and 2) converge quadratically as usual | Relative errors for r₃: 2.7e-3, 3.2e-4, 9.0e-7, 7.3e-12, 8.5e-22, 2.3e-41 (m = 2..7) | confirmed |
| 23 | 62 | The contrast is the diagnostic signature of a repeated root | Roots {5, −5} give identical traces | wrong (overstated → F5) |
| 24 | 64, 66 | Case 2 links graeffesab.jl and embeds graeffesab.gif | manifest: byte-identical, and the script is Case 2 | confirmed |
| 25 | 66 | Alt text: double root at x = 5, simple roots at x = 1 and x = −2 | numpy roots | confirmed |
| 26 | 66 | Alt text: two blue traces approach 5 slowly; crimson and orange traces converge rapidly | colors at graeffesab.jl:46 (steelblue ×2, crimson = r₃, darkorange = r₄); frames 004–011 | confirmed (but the blue traces end at m = 7/8 → F2) |

## Implementation checks

### graeffesaa.jl
- **Method:** This is Graeffe root-squaring in the form q(t) = E(t)² − t·O(t)², where p(x) = E(x²) + x·O(x²). It is identical to the page's (−1)^n p(√t) p(−√t) for n = 4, and the roots of q are r² (not −r²). The estimates are |c_{n−k}/c_{n−k+1}|^{1/2^m} with coefficients stored highest first (`c[2]/c[1]` for r₁), which is the correct Separated Root Theorem. It is the named method.
- **Numbers:** Script (Float64) beside independent (sympy exact + mpmath 50-digit, `indep.py`):

  | m | script est (r₁, r₂, r₃, r₄) | independent |
  |---|---|---|
  | 0 | 2.0, 6.5, 1.076923, 1.714286 | 2.0, 6.5, 1.076923, 1.714286 |
  | 1 | 5.477226, 3.016621, 1.733108, 0.838116 | 5.477226, 3.016621, 1.733108, 0.838116 |
  | 2 | 4.337613, 2.940917, 1.917379, 0.981227 | identical |
  | 3 | 4.049793, 2.978783, 1.990492, 0.999492 | identical |
  | 4 | 4.002498, 2.998416, 1.999810, 0.999999045 | identical |
  | 5 | 4.0000126, 2.9999908, 1.99999986, 0.99999999999 | identical |
  | 6 | 4.00000000063, 2.99999999953, 2.0, 1.0 | identical |
  | 7 | 4.0, 3.0, 2.0, 1.0 | 4, 3, 2, 1 (relative error < 1e-18) |
  | 8 | 4.0, 3.0, **NaN, NaN** | 4, 3, 2, 1 (→ F3) |

  The coefficients match exactly through m = 3. For example, m = 3 gives [1, −72354, 448510881, −110523752704, 110075314176] in both. Property check: p_m == ∏(x − r^{2^m}) exactly for m = 0..8.
- **Reference values:** true_mags = [4, 3, 2, 1]. The numpy roots of x⁴ − 2x³ − 13x² + 14x + 24 are 4, −3, 2, −1. Confirmed.
- **Picture:**
  - Frames viewed: contact sheet; frame_009 full size (m = 8); frames 001–008 via the sheet.
  - The traces are drawn at the computed values, the dashed lines sit at 4, 3, 2 and 1, and the legend labels and colours match the indices.
  - The title shows f and the current m correctly.
  - Problems: r₂ at m = 0 (6.5) is above ylim 6 (F4). At m = 8, r₃ and r₄ are missing because of NaN (F3).

### graeffesab.jl
- **Method:** Same squaring step and the same estimator as graeffesaa.jl. Correct.
- **Numbers:**

  | m | script est (r₁, r₂, r₃, r₄) | independent |
  |---|---|---|
  | 0 | 9.0, 1.444444, 3.461538, 1.111111 | identical |
  | 1 | 7.416198, 3.997727, 1.944918, 0.867110 | identical |
  | 2 | 5.966150, 4.246210, 2.005318, 0.984218 | identical |
  | 3 | 5.452763, 4.585585, 2.000647, 0.999512 | identical |
  | 4 | 5.221369, 4.788017, 2.0000018, 0.99999905 | identical |
  | 5 | 5.109486, 4.892860, 2.00000000001, 0.99999999999 | identical |
  | 6 | 5.054446, 4.946140, 2.0, 1.0 | identical |
  | 7 | 5.027150, 4.972997, 2.0, 1.0 | identical |
  | 8 | 5.013556, **Inf, NaN, NaN** | 5.013556, 4.986480, 2, 1 |
  | 9 | **NaN ×4** | 5.006774, 4.993236, 2, 1 |
  | 10 | **NaN ×4** | 5.003386, 4.996617, 2, 1 |

  The coefficients match exactly through m = 3; for example, m = 3 gives [1, −781507, 152788672131, −39215287890625, 39062500000000]. Property check: p_m == ∏(x − r^{2^m}) for m = 0..10. The m ≥ 8 failures are Float64 overflow (→ F2).
- **Reference values:** true_mags = [5, 5, 2, 1]. The roots of x⁴ − 9x³ + 13x² + 45x − 50 are 5, 5, −2 and 1. Confirmed.
- **Picture:**
  - Frames viewed: contact sheet (frames 001–011); frame_011 full size.
  - The double-root traces are two steelblue traces, one solid with circles and one dashed with diamonds. They bracket the line at 5 from above and below, which is correct, since r₁ ≈ 5·2^{1/2^m} and r₂ ≈ 5·2^{−1/2^m}. Crimson is r₃ and orange is r₄.
  - Problems:
    - r₁ at m = 0 and m = 1 (9.0 and 7.42) is above ylim 7 (F4).
    - The traces end at m = 7/8, while the title reaches m = 10 (F2).
    - On the last frame the annotation at (6, 6.3) is partly covered by the legend box: "(double root)" and "convergence" are overlapped but still legible. This is cosmetic and not filed separately.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/graeffes-method/`](evidence/graeffes-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
