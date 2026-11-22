# Fix record: graeffes-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/graeffes-method/fix/`
(called `$FIX` below).

- `$FIX/print_iterates.jl <script>`: evaluates the computation part of a page script (everything before `# --- Animation ---`) and prints the coefficients and the four estimates for every m.
- `$FIX/repro/graeffesa{a,b}.jl`: the HEAD scripts. `$FIX/postfix/graeffesa{a,b}.jl`: the fixed scripts (identical to the repo copies, checked with `cmp`).
- `$FIX/repro/check.py`: independent check. It builds p_m from the definition p_{m+1}(x) = (−1)^n p_m(√x) p_m(−√x) in sympy (exact), checks p_m = ∏(x − r^{2^m}), and computes the estimates and their errors with mpmath (60 digits). It also evaluates the page's old formula literally.
- `$FIX/repro/extra.py`: the round-1 script, copied unchanged. It covers the formula orientation and the equal-magnitude pair {5, −5} against {5, 5}.
- `$FIX/repro/digits.py`: accurate digits −log10(|err|/|r|) for every m and both cases (80 digits).
- `$FIX/postfix/dump.jl` + `$FIX/postfix/compare.py`: these compare the fixed scripts' plotted estimates with the exact values.
- `$FIX/new/<gif>/` and `$FIX/committed/<gif>/`: frames and contact sheets of the regenerated GIFs and of the HEAD GIFs. The HEAD GIFs are LFS objects, fetched with `git show HEAD:… | git lfs smudge`.
- `$FIX/archive/gr22.png`: Mathews' separated-root formula image, upscaled 4×.

Python: `/usr/bin/python3 -I`. Julia: global environment.

## Findings

### F1 — Error — fixed
- **Reproduced:** `python3 -I check.py` (case aa). This evaluates the page formula |c_{n−k+1}/c_{n−k}|^{1/2^m}, with c_j the coefficient of x^j.
  - m = 3: 0.246926, 0.335708, 0.502388, 1.00051.
  - m = 5: 0.249999, 0.333334, 0.5, 1.0.
  - These are 1/|r_k|. `extra.py` with c_0 read as the leading coefficient gives 0.999492, 1.99049, 2.97878, 4.04979 at m = 3, which is the reverse order.
  - |c_{n−k}/c_{n−k+1}|^{1/8} gives 4.04979, 2.97878, 1.99049, 0.999492. These are the script's values (`print_iterates.jl` m = 3: 4.049792933, 2.978782576, 1.990491511, 0.999491923).
- **Change:** `index.qmd`
  - Lines 30 and 34: `\frac{c_{n-k+1}}{c_{n-k}}` → `\frac{c_{n-k}}{c_{n-k+1}}`.
  - Line 32: "where $c_0, c_1, \ldots, c_n$ are the coefficients of $p_m$" → "where $c_j$ is the coefficient of $x^j$ in $p_m$".
- **Check:** in `check.py`, `est()` implements exactly the new formula (|hi[k]/hi[k−1]| = |c_{n−k}/c_{n−k+1}|). It gives 4.00000000063, 2.99999999953, 2.0, 1.0 at m = 6 (case aa), and for case ab it converges to 5, 5, 2, 1. Endpoints: k = 1 gives |c_{n−1}/c_n| (sum of the roots of p_m) and k = n gives |c_0/c_1|, as Vieta requires.

### F2 — Misleading — fixed (corrected version)
- **Reproduced:** `cd $FIX/repro && julia ../print_iterates.jl graeffesab.jl` (HEAD, Float64).
  - m = 7: coefficients all finite, estimates 5.027149506, 4.972997117, 2, 1.
  - m = 8: coeffs `1, -1.727e+179, Inf, NaN, Inf` and estimates `5.013556375, Inf, NaN, NaN`. As the checker said, r₁ at m = 8 is still valid.
  - m = 9 and m = 10: every estimate is NaN.
  - The committed contact sheet `$FIX/committed/graeffesab/sheet.png` shows r₂–r₄ ending at m = 7, r₁ at m = 8, and frames m = 9 and m = 10 adding nothing.
  - `check.py` (exact) gives 5.01355637525/4.98648028043 at m = 8, 5.00677359946/4.99323556445 at m = 9 and 5.00338565347/4.99661663751 at m = 10. The largest |coefficient| is 1e217.5 for p_7 and 1e434.9 for p_8 (Float64 max is 1.8e308).
- **Change:** `graeffesab.jl` (and `graeffesaa.jl`, see F3)
  - `c0 = big.([1, -9, 13, 45, -50])` and `polys::Vector{Vector{BigInt}}`, so the squaring is exact integer arithmetic. No package is added; BigInt is in Base. Mathews' own module also relies on extended precision ("The extended precision in Mathematica is adequate").
  - `mag_estimates` returns `Float64.(…)`. The estimates are O(1), so this conversion is safe for plotting.
  - A new comment gives the reason.
  - `n_iters = 10` kept.
  - `index.qmd`: one sentence added after "Julia source scripts … linked under each case.": "The scripts square the coefficients in exact integer arithmetic, because in double precision they overflow at $m = 8$: the largest coefficient of $p_8$ is about $2.2 \times 10^{353}$ in Case 1 and $8.6 \times 10^{434}$ in Case 2." This tells the reader why the animations run past the overflow that Description line 42 describes.
- **Check:**
  - `cd $FIX/postfix && julia ../print_iterates.jl graeffesab.jl`: every estimate is finite for m = 0..10. m = 10 gives 5.003385653, 4.996616638, 2, 1.
  - `julia dump.jl … && python3 -I compare.py`: the maximum relative difference between the plotted estimates and the exact values is 1.57e-16 for case ab and 1.43e-16 for case aa, over every m and k.
  - New frames 001–011 viewed (sheet plus full-size frame_011). The r₁ (solid) and r₂ (dashed) traces now continue to m = 10 and close on the line at 5, from above and below.
  - The last-frame annotation now clears the legend; in HEAD frame_011 it overlapped the legend.

### F3 — Minor — fixed
- **Reproduced:** with HEAD `graeffesaa.jl` (Float64), m = 8 gives coeffs `1, -1.341e+154, 1.864e+276, NaN, Inf` and estimates `4, 3, NaN, NaN`. m = 7 is all finite. `check.py`: the largest |coefficient| of p_8 is 1e353.3, above the Float64 limit. The exact errors at m = 8 are 1.62e-34, −1.215e-34 and −6.5e-48 (r₄ is exact to 60 digits).
- **Change:** `graeffesaa.jl`: the same BigInt change as F2, with `c0 = big.([1, -2, -13, 14, 24])`. `n_iters = 8` kept.
- **Check:** postfix m = 8 estimates are 4, 3, 2, 1, all finite. compare.py max relative difference is 1.43e-16. Full-size new frame_009 shows all four traces reaching m = 8.

### F4 — Minor — fixed
- **Reproduced:** HEAD estimates at m = 0 are Case 1 r₂ = 6.5 (ylims 0–6), Case 2 r₁ = 9.0 and m = 1 r₁ = 7.416198487 (ylims 0–7). In the committed sheets the red marker is missing at m = 0 in Case 1, and in Case 2 the blue r₁ trace enters from above the frame.
- **Change:**
  - `graeffesaa.jl`: `ylims=(0.0, 6.0)` → `(0.0, 7.0)`.
  - `graeffesab.jl`: `ylims=(0.0, 7.0)` → `(0.0, 9.5)`.
- **Check:**
  - Every estimate lies inside the new limits. Case 1 max 6.5, min 0.838; Case 2 max 9.0, min 0.867 (`print_iterates.jl`, postfix).
  - Full-size new frame_001 of both GIFs shows all four markers at m = 0: Case 1 at 2, 6.5, 1.08, 1.71; Case 2 at 9.0, 1.44, 3.46, 1.11.
  - The legend (top right) covers no marker in any frame of either sheet.

### F5 — Minor — fixed
- **Reproduced:** `python3 -I extra.py`: for roots {1, −2, 5, −5} and {1, −2, 5, 5}, the r₁/r₂ estimates agree to 8 digits for every m = 1..8 (e.g. m = 5: 5.1094857, 4.8928603 for both). So equal-magnitude roots that are distinct give the same linear behaviour.
- **Change:** `index.qmd`
  - Line 40: "**distinct real roots**" → "**real roots of distinct magnitudes**".
  - Line 62: "…is the diagnostic signature of a repeated root." → "…is the diagnostic signature of two roots of equal magnitude (here a repeated root)."
- **Check:** `digits.py`
  - Case 1 (distinct magnitudes) r₁ digits are 3.2, 5.5, 9.8, 18.1, 34.4 for m = 4..8, so they roughly double per step. This supports the unchanged rest of line 40.
  - Case 2 double-root pair: 1.35, 1.66, 1.96, 2.27, 2.57, 2.87, 3.17 for m = 4..10. That is +0.30 digit per step, = log10 2, so the error halves (linear). The simple roots in the same case gain 6.05 → 11.1 → 21.1 → 40.6 → 79.5 digits.

### F6 — Minor — fixed
- **Reproduced:** HEAD/postfix estimates (identical for m ≤ 7):
  - r₁: 2, 5.477, 4.338, 4.050, 4.0025, … → 4. It overshoots.
  - r₂: 6.5, 3.017, 2.941, 2.979, 2.998, … → 3. It falls, then rises.
  - r₃: 1.077, 1.733, 1.917, 1.990, 1.9998, … → 2. All its errors are negative and shrinking (check.py), so it rises monotonically.
  - r₄: 1.714, 0.838, 0.981, 0.9995, … → 1.
  - Only r₃ "grows" all the way.
- **Change:** `index.qmd` line 58 alt text: "growing from its initial poor approximation toward the dashed true-value line" → "moving from its initial poor approximation onto the dashed true-value line".
- **Check:** at m = 8 all four relative errors are ≤ 4.1e-35 (check.py: 1.62e-34/4, 1.215e-34/3, 6.5e-48/2, 0). New full-size frame_009 shows every trace sitting on its dashed line.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:30 | $\|r_k\|^{2^m} \approx \|c_{n-k}/c_{n-k+1}\|$ | `check.py` est() = this formula → aa m=6: 4.00000000063, 2.99999999953, 2.0, 1.0; ab m=10: 5.00339, 4.99662, 2, 1 | yes |
| index.qmd:32 | "$c_j$ is the coefficient of $x^j$ in $p_m$" | the same convention as $a_j$ at line 18. Under it, the formula above returns 4, 3, 2, 1 (not 1/4 … 1, as the old one did: `check.py` PAGE formula m=5 → 0.249999, 0.333334, 0.5, 1.0) | yes |
| index.qmd:34 | $\|r_k\| \approx \|c_{n-k}/c_{n-k+1}\|^{1/2^m}$ | as line 30. Mathews' theorem (archive gr_20, gr_22: $P=\sum a_{i+1}x^i$, $r_i \approx -a_{n+1-i}/a_{n+2-i}$) is the same orientation | yes |
| index.qmd:40 | "real roots of distinct magnitudes" | `extra.py`: {1,−2,5,−5} and {1,−2,5,5} give identical r₁/r₂ estimates m=1..8, i.e. distinct real roots of equal magnitude are linear. `digits.py` case aa: 3.2→5.5→9.8→18.1→34.4 digits | yes |
| index.qmd:50 | "exact integer arithmetic" | scripts use `big.(…)` Int → BigInt; `print_iterates.jl` prints `eltype = BigInt` | yes |
| index.qmd:50 | "in double precision they overflow at $m = 8$" | HEAD Float64 runs: m=7 all finite in both cases; m=8 has Inf/NaN in both (aa `…, NaN, Inf`; ab `…, Inf, NaN, Inf`). Exact max \|coef\|: p_7 4.646e176 / 2.939e217, p_8 > 1.798e308 | yes |
| index.qmd:50 | "about $2.2 \times 10^{353}$ in Case 1" | python one-liner (sympy exact p_8) → largest \|coef\| 2.158e+353 (coefficient of x¹) | yes |
| index.qmd:50 | "$8.6 \times 10^{434}$ in Case 2" | same → 8.636e+434 | yes |
| index.qmd:58 | "moving from its initial poor approximation onto the dashed true-value line" | sequences under F6. m=8 relative errors ≤ 4.1e-35. New frame_009 viewed | yes |
| index.qmd:62 | "diagnostic signature of two roots of equal magnitude (here a repeated root)" | `extra.py` (equal magnitude ⇒ same linear behaviour as the double root). `digits.py` ab: +0.30 digit/step for r₁, r₂ (= log10 2) vs doubling for r₃, r₄ | yes |
| graeffesaa.jl:11–12 | comment: largest coefficient of p₈ ≈ (4·3·2)^256 ≈ 2.2e353 > Float64 range ≈ 1.8e308 → Inf/NaN at m = 8 | python one-liner: max \|coef\| 2.158e353, 24^256 = 2.158e353, 2^1024 = 1.798e308. HEAD Float64 m=8 has NaN, Inf | yes |
| graeffesab.jl:12–13 | comment: ≈ (5·5·2)^256 ≈ 8.6e434 … Inf/NaN from m = 8 on | max \|coef\| 8.636e434 = 50^256 to 4 digits. HEAD Float64 m=8,9,10 contain Inf/NaN | yes |
| graeffesaa.jl:37, graeffesab.jl:34 | comment "estimates are O(1), safe in Float64" | all estimates in [0.838, 9.0] (`print_iterates.jl`). compare.py max rel. diff 1.6e-16 | yes |
| graeffesaa.jl ylims | (0, 7) | max estimate 6.5, min 0.838 | yes |
| graeffesab.jl ylims | (0, 9.5) | max estimate 9.0, min 0.867 | yes |

GIF titles, legends and the Case 2 annotation text are unchanged. The annotation "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" matches `digits.py` for case ab.

## Scripts and GIFs
- Scripts changed: `graeffesaa.jl`, `graeffesab.jl` (BigInt coefficients, Float64 estimates, y-limits, comments).
- GIFs regenerated with `cd pages/numerical-methods/graeffes-method && julia graeffesaa.jl && julia graeffesab.jl`:
  - graeffesaa.gif: 9 frames, sha256 2d01b393…
  - graeffesab.gif: 11 frames, sha256 ad3bd978…
  - Rerunning the identical scripts in `$FIX/postfix` gives the same two hashes.
- Frames viewed:
  - Both contact sheets.
  - Full-size frame_001 and frame_009 of aa, and frame_001 and frame_011 of ab.
  - Checked in them:
    - every m = 0 marker is inside the window;
    - all traces reach the last m;
    - the titles read m = 0 … 8 and m = 0 … 10;
    - the legends are legible and cover no data;
    - the Case 2 annotation no longer overlaps the legend.
- `git status --short -- pages/numerical-methods/graeffes-method` after regeneration: `M graeffesaa.gif`, `M graeffesaa.jl`, `M graeffesab.gif`, `M graeffesab.jl`, `M index.qmd`. These are the expected files only.

## Legacy archive
- Consulted: `n2003/GraeffeMethodMod.html` and the Links pages lnk_2 to lnk_9.
- The archive's examples are worked Mathematica tables, not animations.
- Case 1's roots {4, −3, 2, −1} are Mathews' Example 3 (gr_129). Case 2's f₀ = −50 + 45x + 13x² − 9x³ + x⁴ is his Example 6, "Repeated Real Roots" (gr_263). He says of Example 6 that "the iteration will proceed linearly for the repeated root and quadratically for the simple roots"; `digits.py` confirms this.
- Mathews' separated-root theorem (gr_20, gr_22) writes $P_n(x)=\sum_{i=0}^n a_{i+1}x^i$ and $r_i \approx -a_{n+1-i}/a_{n+2-i}$. That is (coefficient of x^{n−i}) / (coefficient of x^{n−i+1}), the same orientation as the corrected page formula. The old page formula appears to be a mis-transcription of his shifted indices.
- His Example 9, "Unequal Real Roots of Equal Magnitude", treats the situation F5 is about.
- He notes that Graeffe's method overflows floating point and that "the extended precision in Mathematica is adequate". The exact-integer fix follows the same approach.
- There is no difference between the fixed page and the archive that needed to be resolved.

## Notes
- **F2 option choice.** F2 offered three fixes; BigInt/exact arithmetic was chosen over `n_iters = 7`. It keeps the m = 0..10 linear-convergence story the page and the on-plot annotation describe, and it fixes F3 with the same change. It uses no new dependency. An on-plot note was not needed once nothing overflows; the page sentence explains why the scripts are exact.
- **Unchanged general sentences, imprecise but not findings.** These were left as they are:
  - Line 42: "coefficients of $p_m$ grow exponentially as $|r_k|^{2^m}$". The largest coefficient actually grows like a product of the top root magnitudes to the power 2^m (24^256 and 50^256 at m = 8), and that is doubly exponential in m.
  - Line 54 (Case 1): "the error roughly squares at each step". Digits double asymptotically (`digits.py`), but at m = 1→2 r₂'s error grows (0.0166 → 0.0591).
  - Line 62 (Case 2): "the error is halved each iteration". The ratios are 0.47–0.50 from m = 3 on, but 0.60/0.40 (r₁) and 0.28/0.75 (r₂) at m = 1–2.
  Jason may want to soften these to "eventually". They were not changed because no finding names them.
- Nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

Independent references: `check/indep.py` builds p_m exactly as the monic integer polynomial with roots r^(2^m) (from the root list, not from the Graeffe recurrence), then takes |c_{n-k}/c_{n-k+1}|^(1/2^m) at 60 digits. `check/f5.py` repeats this for roots {1,−2,5,−5}, {1,−2,5,5}, {1,−2,4,−3}. `check/run/graeffes*_print.jl` are scratch copies of the fixed scripts truncated after `estimates` and printing them.

### Original findings

### F1 — resolved
- Evidence: index.qmd:30 and :34 now read |r_k|^{2^m} ≈ |c_{n−k}/c_{n−k+1}| and |r_k| ≈ |c_{n−k}/c_{n−k+1}|^{1/2^m}; line 32 now says "where c_j is the coefficient of x^j in p_m". Evaluating exactly this formula on the exact p_m for Case 1 gives, at m = 3, 4.0497929, 2.9787826, 1.9904915, 0.99949192 and at m = 6, 4, 3, 2, 1 (k = 1..4 in that order); for Case 2 at m = 10, 5.0034, 4.9966, 2, 1. Correct magnitudes in the labelled order, and identical to the scripts' `abs(c[k+1]/c[k])` (highest-degree-first indexing = c_{n−k}/c_{n−k+1}). Page and animations now agree.

### F2 — resolved
- Evidence: graeffesab.jl now squares in BigInt (`c0 = big.([1, -9, 13, 45, -50])`, `polys::Vector{Vector{BigInt}}`), so the recurrence is exact; estimates are taken in BigFloat and converted to Float64. Scratch run prints, for m = 8, 9, 10: [5.0135564, 4.9864803, 2, 1], [5.0067736, 4.9932356, 2, 1], [5.0033857, 4.9966166, 2, 1] — matching the independent exact reference to all printed digits, with no Inf/NaN. Error of r₁ halves each step (0.0271 → 0.0136 → 0.0068 → 0.0034), the linear convergence the page describes. Full-size last frame (frame_011, "m = 10"): all four traces run to m = 10, the two blue traces close in on the dashed 5 line from above/below, nothing missing on the right of the axis. n_iters stays 10, so the page's m-range story holds.

### F3 — resolved
- Evidence: graeffesaa.jl uses the same BigInt fix. Scratch run gives m = 8 estimates [4.0, 3.0, 2.0, 1.0] (reference: exact to Float64). Full-size frame_009 ("m = 8"): all four traces, including orange r₃ and purple r₄, have markers at m = 8.

### F4 — resolved
- Evidence: ylims raised to (0, 7) in Case 1 and (0, 9.5) in Case 2. Case 1 frame_001 (m = 0) shows all four markers including red r₂ at 6.5 (inside, not hidden by the legend). Case 2 frame_001 shows the r₁ marker at 9.0; frame at m = 1 range includes 7.416; the solid blue trace starts at m = 0 in frame_006 and frame_011. No marker in either GIF is now outside the axes (max estimate 6.5 and 9.0 respectively, from the reference).

### F5 — resolved
- Evidence: line 40 now "real roots of distinct magnitudes"; line 62 now "diagnostic signature of two roots of equal magnitude (here a repeated root)". `f5.py`: roots {1,−2,5,−5} (distinct, equal magnitude) and {1,−2,5,5} (repeated) give identical estimates for m = 1..8 (e.g. m = 8: 5.01355638 / 4.98648028 for both), linear; {1,−2,4,−3} (distinct magnitudes) converges to 4,3,2,1 by m = 6, quadratically. Both new statements are true.

### F6 — resolved
- Evidence: alt text (line 58) now "moving from its initial poor approximation onto the dashed true-value line". Reference values: r₁ 2 → 5.48 → … → 4; r₂ 6.5 → 3.02 → 2.94 → 3; r₃ 1.08 → 2; r₄ 1.71 → 0.84 → 1. Every trace starts away from its line and ends on it by m ≈ 5 — "moving … onto" is accurate for all four, and the frames show exactly this.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:30 | \|r_k\|^{2^m} ≈ \|c_{n−k}/c_{n−k+1}\| | Exact p_m, Case 1 & 2; ratio^(1/2^m) → true magnitudes in order k = 1..n | correct |
| index.qmd:32 | "c_j is the coefficient of x^j in p_m" | Consistent with a_j notation at line 18 and with the orientation that makes the formula true | correct |
| index.qmd:34 | \|r_k\| ≈ \|c_{n−k}/c_{n−k+1}\|^{1/2^m} | same as above | correct |
| index.qmd:40 | "real roots of distinct magnitudes" … quadratic | f5.py: {1,−2,4,−3} quadratic; equal-magnitude pair linear | correct |
| index.qmd:50 | "exact integer arithmetic" | Scripts use BigInt coefficients; Graeffe step uses only +, −, * on integers, so exact | correct |
| index.qmd:50 | "in double precision they overflow at m = 8" | Max coefficient: Case 1 m=7 4.6e176, m=8 2.2e353; Case 2 m=7 2.9e217, m=8 8.6e434; Float64 max 1.8e308. Intermediate products at step 7→8 are ≈ the squared m=7 values, also first exceed at m=8 | correct |
| index.qmd:50 | "about 2.2 × 10^353" (Case 1) | exact max \|coef\| of p_8 = 2.158e353 | correct |
| index.qmd:50 | "8.6 × 10^434" (Case 2) | exact max \|coef\| of p_8 = 8.636e434 | correct |
| index.qmd:58 | alt text "moving … onto the dashed true-value line" | reference traces, frames 001/005/009 | correct |
| index.qmd:62 | "two roots of equal magnitude (here a repeated root)" | f5.py identical behaviour for ±5 and double 5 | correct |
| graeffesaa.jl:11–12 | comment "(4·3·2)^256 ≈ 2.2e353", "Inf/NaN at m = 8" | 24^256 = 10^353.33 = 2.2e353; reference max coef 2.158e353 | correct |
| graeffesab.jl:12–13 | comment "(5·5·2)^256 ≈ 8.6e434", "Inf/NaN from m = 8 on" | 50^256 = 8.6e434; reference 8.636e434 | correct |
| graeffesaa.jl:37 / graeffesab.jl:34 | `Float64.(ratios .^ (1.0/2^m))`, comment "estimates are O(1)" | estimates lie in [0.84, 9.0]; BigFloat (256-bit) ratio then rounded | correct |
| graeffesaa.jl:56 | ylims (0, 7) | max estimate 6.5 | correct |
| graeffesab.jl:54 | ylims (0, 9.5) | max estimate 9.0 | correct |

### New problems
None. This rests on: the scripts' printed estimates match the independent exact-root reference at every m in both cases; first, middle and last frames of both GIFs viewed at full size (titles, legends, annotation legible; every marker inside the axes; Case 2 last-frame annotation at y = 6.3 still sits in empty space above the converged traces); all new numbers checked above. Unchanged neighbouring text (line 42 "cannot apply more than a handful of iterations before overflow", line 48) remains consistent with the new line 50.

### Reproducibility and conventions
- Both changed scripts run from scratch copies (`check/run/`) in ~6–8 s; output GIFs are byte-identical to the working-tree GIFs (sha256 2d01b393… for graeffesaa.gif, ad3bd978… for graeffesab.gif). Frame counts: 9 (m = 0..8) and 11 (m = 0..10).
- Page still has Description before Animations, a "Julia source" link and an embed per case, descriptive alt text, no code blocks.
- In the page folder only the five expected files changed. Outside it, git status shows no tracked change attributable to this fix; there is an untracked `reviews/numerical-methods-animations/fixes/graeffes-method.md` (workflow note, not a site page) and other pages' changes from the parallel fix branch work.

**Final status:** committed
