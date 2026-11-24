# Golden Ratio Search: review, batch 2 round 1

**Result: 0 Error, 0 Misleading, 1 Minor (unverified).** No implementation or drawing errors.

This page was the calibration pilot. The reviewer worked on a scratch copy of the page folder with two planted errors in the Case 1 Behavior paragraph (a distance changed from 6.29 × 10⁻³ to 6.59 × 10⁻³, and "squeezed alternately … starting from the left" in place of the true side list). The reviewer reported both as Errors with its own computations, so the brief was not changed. Those two planted findings are not page findings and are omitted below. The real sentences they replaced were checked by the same reviewer's runs: its own double-precision and 50-digit searches give the keep sequence cb, ad, cb, ad, cb, cb, ad, ad, cb (left at k = 0, 2, 4, 5, 8, right at 1, 3, 6, 7), and |a₉ − p| = 6.29 × 10⁻³, which is what the real page says. Line numbers below are the real page's, which match the copy.

## Findings

### F1. Minor (page match, unverified): b₉ distance in the Example 6 distance table, line 456

- **Now:** the b₉ row gives $|b_9 - p| = 6.87 \times 10^{-3}$.
- **True:** $b_9 - p = 0.0068646929\ldots$, which rounds to $6.86 \times 10^{-3}$ (mpmath, 30 digits; the director's own check gives $b_9 = 0.639320225$, $b_9 - p = 0.00686469$).
- **Fix:** change 6.87 to 6.86.

### Observation (not a finding)

The f(c) − f(d) columns in the Example 2–5 tables hold the double-precision difference of the two computed values, not the high-precision difference (Example 4, k = 30: page −4.12e−13, high precision −4.17e−13; Example 5, k = 31: page −1.89e−12, high precision −1.92e−12). The page claims high precision only for the animation titles (line 24), and every sign agrees.

## Inventory (Phase 1)

- Scripts `goldenaa.jl`, `goldenbb.jl`, `goldencc.jl`; each ran from a scratch copy and produced a GIF byte-identical to the committed one (12, 28 and 34 frames).
- The page links and embeds exactly these three scripts and GIFs; no orphan files. The section index links the page (`golden-ratio-search/`).
- Packages: Plots, Printf.

## Claim ledger (summary of the reviewer's ledger; C = confirmed)

The reviewer consulted the archive (module text, solution links lnk_2–lnk_7, program images gr_64, gr_139, gr_222, printed lists gr_115, gr_161, gr_187, gr_216, results gr_169, gr_195, gr_219, calls gr_160, gr_215, gr_223, gr_224, and the textbook section via pdftotext). Its scripts: `gs.py` (golden-section search from the definition, double or 50-digit, either tie rule, either stopping rule), `run.py`, `cmp.py` (every row of all six page tables), `nums.py`, `nums2.py`, `prec.py`, `fib.py`, `fib2.py`, `signs.py`.

- **Description (lines 12–20):** squeeze rule, c_k and d_k formulas, ρ = 0.618034, ρ² = 1 − ρ and point reuse, b_k − a_k = ρ^k L: C.
- **Animations introduction (lines 24–26):** panel contents and colours (dashed p line pixel colour (2, 129, 2), green), title contents, green keep bar, frame k = table row k, last frame held with returned endpoint and midpoint, frame counts 12/28/34 = K + 3, labels gain digits, BigFloat differences with matching double-precision signs, 50-digit runs keep the same side; Mathews' GIF and Example 6 pictures lost (gr_226–gr_244 absent), plotting program gr_222 survives with the same window, colours and fill RGB(1, .8, .85); tie rules differ but no run has a tie; ρ² and smaller-endpoint return as in Mathews' programs: C.
- **Wiring (lines 34–52):** C.
- **Case 1:** heading, max = 10 and k = 0…9 (gr_222 `While[k<max]`), window, sides, p ∈ every bracket, overlap at k = 9, last interval [0.6262, 0.6393] and ρ⁹ = 0.01316, a₉ 6.29e−3 from p, midpoint 2.87e−4 from p, alt text: C.
- **Case 2:** 25 steps (gr_115), p = 0.4501836113, ρ¹⁰ = 0.0081, differences < 2e−9 from k = 18 (largest 1.941e−9), 1.194e−12 at k = 24, last interval and width 5.96e−6, b₂₅ 1.354e−6 from p, midpoint 1.627e−6, alt text: C.
- **Case 3:** local maximum −0.6538809, minimum 0.3770021, f(−0.2361) = 1.2445 > f(0.2361) = 0.81147, f′ one sign change on [−0.2361, 1], K = 31 (also at 50 digits), final interval and width 6.644e−7, a₃₁ 2.33e−7 from p, smallest difference 4.715e−14 at k = 29 (425 ulp), alt text: C.
- **Unimodality, derivation, theorem (lines 54–114):** C, including ln 10 / ln φ = 4.785.
- **Algorithm and Mathews' programs (lines 118–137):** C against gr_64 and gr_139 (K + 2 and K + 4 evaluations, tie and return rules).
- **Example 1:** all 26 table rows (0 mismatches), steps, f(a₂₅) and f(b₂₅) differing by 2.4e−11, verification table, secant table, textbook row-23 and c₀ typo notes, Fibonacci n = 21 comparison: C. "Module list agrees at all 26 rows" confirmed by spot check of about 10 rows.
- **Examples 2–5:** tables (0 mismatches), tolerances, step counts, results and Mathews' printed values, closed forms, voltage bounds and margin: C.
- **Example 6:** table (0 mismatches), side sequence, Fibonacci match, ρ⁹, distances for a₉, c₉, d₉ and midpoint: C; **b₉ distance: wrong (F1)**.
- **Fibonacci comparison and implementation notes (lines 463–476):** ratio 0.87118 and its limit, tolerance step k = 14, precision limit (first wrong comparison k = 42, bracket loses p from k = 43, √u = 1.49e−8): C.

## Implementation checks

All three scripts share one body: golden-section search with ρ = (√5 − 1)/2, 1 − ρ computed as ρ², the surviving point and value reused (one new evaluation per step), tie keeps [a, d] (asserted never to occur), fixed-K loop matching `GoldenSearch[a0, b0, max]`, tolerance loop matching Mathews' `While[Or[...]]`, return rule FB < FA as Mathews'.

| Script | Independent check |
|---|---|
| goldenaa | all rows identical to the reviewer's run; same returned point and midpoint |
| goldenbb | all 26 rows identical; b₂₅ = 0.45018496511916045 |
| goldencc | K = 31; a₃₁ = 0.3770018229846242; smallest difference 4.7149e−14 |

References: √10/5 exact; Newton-in-BigFloat minimisers agree with mpmath findroot (0.45018361129487…, 0.3770020557, local maximum −0.6538809313); p lies in every bracket. Frames viewed: aa 1, 6, 10; bb 25, 26 and sheet; cc 1, 30, 32. Elements are built from the right quantities, titles match the reviewer's values, no clamping.
