# Richardson Extrapolation — animation review

Page: [`pages/numerical-methods/richardson-extrapolation/index.qmd`](../../pages/numerical-methods/richardson-extrapolation/index.qmd) · Scripts: `richexaa.jl`, `richexab.jl` · GIFs: 2

**Result:** 0 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Implementation — Case 1 error annotation rounds the D5 error to "≈ 0.0" in 5 of 9 frames

- **Location:** `richexaa.jl:53` (`round(err5; digits=6)` inside the `annotate!` text). It shows up in committed `richexaa.gif` frames 4–9.
- **Now:** The annotation rounds both maximum errors to 6 decimal places. For h = 0.08, 0.05, 0.03, 0.02 and 0.01 the frame reads `max|error D5| ≈ 0.0`. For h = 0.12 it reads `≈ 1.0e-6`, and for h = 0.2 it reads `≈ 9.0e-6`. From h = 0.12 on, both curves lie on top of f'(x) at plot scale, so this annotation is the only thing in those frames that compares D3 with D5. What it says is that D5 is exact.
- **True:** The script's own computed values (identical to an independent 50-digit mpmath evaluation on the same 700-point grid):

  | h | max err D5 (computed) | shown |
  |---|---|---|
  | 0.2 | 8.56e-6 | 9.0e-6 |
  | 0.12 | 1.34e-6 | 1.0e-6 |
  | 0.08 | 2.89e-7 | 0.0 |
  | 0.05 | 4.70e-8 | 0.0 |
  | 0.03 | 6.35e-9 | 0.0 |
  | 0.02 | 1.28e-9 | 0.0 |
  | 0.01 | 8.17e-11 | 0.0 |

  The D5 error keeps falling by about h⁴ (2.9e-7 down to 8.2e-11), and that h⁴ decay is the point of the page. The value shown for h = 0.12 is also off by 25% at the precision it is given to (1.0e-6 against 1.34e-6). The D3 values for h = 0.03 and 0.01 lose their significant digits in the same way (`0.0003`, `3.3e-5`).
- **Evidence:** `julia $WORK/richardson-extrapolation/reviewer/instr.jl` prints err3/err5 and the label strings for each h (table above). `/usr/bin/python3 -I $WORK/richardson-extrapolation/reviewer/indep.py` gives the same maxima independently (e.g. h=0.08: 2.89031e-7; h=0.01: 8.16755e-11). Full-size `committed/richexaa/frame_005.png` reads "max|error D5| ≈ 0.0".
- **Suggested fix:** Format the errors in scientific notation with fixed significant digits, e.g. `using Printf` and `@sprintf("max|error D3| ≈ %.2e   max|error D5| ≈ %.2e", err3, err5)`.

- **Independent check:** confirmed with correction. Checker: every value is rounded correctly to 6 decimals — the issue is display: D5 error shows '≈ 0.0' in frames 5–9 (true 2.9e-7 … 8.2e-11), and values print as '1.0e-6' (true 1.34e-6, frame 4) and '9.0e-6' (true 8.56e-6, frame 3), which read as wrong two-significant-figure values.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `richexaa.jl` | yes | 3.3 | richexaa.gif |
| `richexab.jl` | yes | 3.3 | richexab.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | Combines two finite-difference estimates with different step sizes so that the leading truncation term cancels | `richexaa.jl:12`, `richexab.jl:12` combine D3(h/2) and D3(h). sympy: D3−f' = O(h²), D5−f' = O(h⁴) (indep.py) | confirmed |
| 2 | 12 | Refinement of the central three-point derivative for f(x)=e^{-x}sin(x) over [0,π] | `richexaa.jl:8,15` (f and xlims = (0, π)); `richexab.jl:8` same f | confirmed |
| 3 | 17 | D3(x,h) = (f(x+h) − f(x−h))/(2h) | `richexaa.jl:11`, `richexab.jl:11` identical | confirmed |
| 4 | 23 | D5(x,h) = (4D3(x,h/2) − D3(x,h))/3 | `richexaa.jl:12`, `richexab.jl:12` identical; legend in richexaa frames shows the same formula | confirmed |
| 5 | 26 | Upgrades the local truncation behavior from O(h²) to O(h⁴) for smooth functions | sympy series: D3−f' = √2 e^{-x} h²(10 sin(x+π/4) − h² cos(x+π/4))/30; D5−f' = √2 e^{-x} h⁴(cos(x+π/4)/120 + …). On monomials, D3 is exact through degree 2 and D5 through degree 4, and D5 fails at degree 5 (error −h⁴/4). Measured slopes at x0=1 are 2.000 and 3.99–4.00 | confirmed |
| 6 | 30 | Each animation compares the base central difference with Richardson extrapolation for the legacy test function and interval | Both scripts plot D3 and D5 for f = e^{-x}sin x. Case 1 covers [0,π]; Case 2 is at x0 = 1 ∈ [0,π] | confirmed |
| 7 | 32 | Case 1 heading: profile comparison, D3(x,h) vs. D5(x,h) | richexaa frames show f', D3 and D5 against x on [0,π] | confirmed |
| 8 | 34 | Both approximations converge as h shrinks | max err D3: 0.0681 → 3.33e-5; max err D5: 1.32e-4 → 8.17e-11, both monotone over the 9 h values (instr.jl) | confirmed |
| 9 | 34 | The Richardson curve tracks f'(x) much more closely | Numerically true in every frame (err5/err3 ≈ 2e-3 at h=0.5, falling to 2.5e-6 at h=0.01). Visibly so only in frames 1–3; after that the annotation is the only comparison, and it shows D5 error "≈ 0.0" | confirmed (but see F1 on how the frames report it) |
| 10 | 34 | ...because the dominant h² error term is canceled | sympy: the h² term of D5−f' is 0 | confirmed |
| 11 | 36, 38 | Case 1 link `richexaa.jl`, embed `richexaa.gif` | manifest: richexaa.gif is produced by richexaa.jl and is byte-identical to it | confirmed |
| 12 | 38 | Alt: compares D3 and Richardson D5 derivative curves against the true derivative over 0 to π for decreasing h | Frames: h = 0.5 … 0.01 decreasing; black f'(x) over [0,π] | confirmed |
| 13 | 40 | Case 2 heading: pointwise convergence at x0 = 1 on log-log axes | `richexab.jl:14` x0 = 1.0; `xaxis=:log, yaxis=:log` | confirmed |
| 14 | 42 | Error slope for the three-point formula follows approximately O(h²) | Successive slopes 2.007, 2.003, 2.001, then 2.000 throughout | confirmed |
| 15 | 42 | Richardson follows approximately O(h⁴) before roundoff effects appear | Slopes 3.905 … 4.000 down to h = 0.006 (3.987). At h = 0.003 and 0.0015 the float64 errors (4.26e-14, 1.29e-14) depart from the true truncation errors (7.48e-14, 4.67e-15; mpmath), giving slopes 4.82 and 1.72. Frame 12 shows the last two points leaving the h⁴ guide | confirmed |
| 16 | 44, 46 | Case 2 link `richexab.jl`, embed `richexab.gif` | manifest: richexab.gif is produced by richexab.jl and is byte-identical to it | confirmed |
| 17 | 46 | Alt: log-log error curves versus h at x0 = 1 showing second-order and fourth-order convergence trends | Frames 2–12: two straight lines lying on the O(h²) and O(h⁴) guides | confirmed |
| 18 | 50 | D3(x,h) = f'(x) + C2h² + C4h⁴ + ⋯ (even powers only) | sympy series of D3 − f' has only even powers of h | confirmed |
| 19 | 52–57 | (4D3(x,h/2) − D3(x,h))/3 = f'(x) + O(h⁴), because the C2h² contribution cancels exactly | Algebra: 4(C2h²/4) − C2h² = 0; the remainder is −C4h⁴/4 + …. sympy confirms the leading D5 error is h⁴ | confirmed |

## Implementation checks

### richexaa.jl
- **Method:** D3 is the central three-point difference (line 11). D5 is one Richardson step with ratio 2 for an error series in even powers, weights (4, −1)/3 (line 12). It equals the standard five-point central difference with spacing h/2. It is the method the page names, and there is a single extrapolation level (no deeper table).
- **Weights checked by property:** Applied to monomials xⁿ (sympy, indep.py), D3 is exact for n ≤ 2 and has error h² at n = 3. D5 is exact for n ≤ 4 and has error −h⁴/4 at n = 5. So the weights cancel the h² term and nothing more, which is the correct behaviour. The measured order at x0 = 1 is 4.00 (see richexab).
- **Reference values:** `fp(x) = exp(-x)(cos x − sin x)` agrees with the sympy derivative of e^{-x} sin x (difference simplifies to 0).
- **Numbers (script vs. independent mpmath, 50 digits, same 700-point grid):** h=0.5: err3 0.0680654 / 0.0680654, err5 1.321437e-4 / 1.32144e-4. h=0.2: 1.283335e-2 / 1.28333e-2, 8.560666e-6 / 8.56067e-6. h=0.08: 2.119238e-3 / 2.11924e-3, 2.890315e-7 / 2.89031e-7. h=0.01: 3.332970e-5 / 3.33297e-5, 8.167544e-11 / 8.16755e-11. They agree at every h.
- **Picture:** I looked at the contact sheet (all 9 frames) and full-size frame 5. The black f' is drawn on [0,π], D3 (dashed blue) and D5 (orange) on [h, π−h], and the title h matches the loop value. The y-limits (−1, 1.1) contain f' (range about −0.21 to 1). Nothing is clamped. In frames 1–3 D3 visibly departs from f' near x ≈ 0.3–1.5 while D5 does not; from frame 4 on all three curves overlap. The annotation is wrong as described in F1.

### richexab.jl
- **Method:** Same D3 and D5 as above, evaluated at x0 = 1 for 12 step sizes, h = 0.5 … 0.0015.
- **Numbers (script float64 vs. mpmath truncation error):** e3 matches at every h (e.g. h=0.5: 4.257869e-2 / 4.2578693e-2; h=0.0015: 3.812445e-7 / 3.8124451e-7). e5 matches down to h=0.01 (9.238929e-12 / 9.2325616e-12) and to 1% at h=0.006 (1.205e-12 / 1.197e-12). At h=0.003 and 0.0015, roundoff dominates (4.26e-14 / 7.48e-14; 1.29e-14 / 4.67e-15), as the page anticipates. Measured slopes: D3 2.000, D5 3.905 rising to 4.000.
- **Reference values:** f'(1) = −0.11079376530669925782 (mpmath), matching the script's `fp`. The guide constants c2 = 0.1703 and c4 = 8.60e-4 are fitted to the first point. They are close to the asymptotic |f'''(1)/6| = 0.1694 and |error coefficient of D5| = 9.23e-4, so the guides are honest reference slopes.
- **Picture:** I looked at the contact sheet (all 12 frames) and full-size frames 1 and 12. Frame k plots the first k points with circles (D3) and diamonds (D5) on log-log axes, and the guides span [min h, max h] of the points shown. Frame 1 has one point per series and an empty guide range. This is harmless, since the animation builds up from there. In frame 12 the D3 points lie on the O(h²) guide (the dashed guide is hidden under the D3 line), the D5 points lie on the dotted O(h⁴) guide, and the last two diamonds sit above the guide because of roundoff. Legend labels "|D3(1,h)-f'(1)|" and "|D5(1,h)-f'(1)|" match the computed quantities.

Scripts used: `$WORK/richardson-extrapolation/reviewer/instr.jl` (Julia, reuses the script's formulas and prints the values) and `$WORK/richardson-extrapolation/reviewer/indep.py` (sympy series and monomial checks, plus mpmath at 50 digits, independent of the scripts).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/richardson-extrapolation/`](evidence/richardson-extrapolation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
