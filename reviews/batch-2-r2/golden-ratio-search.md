# Golden Ratio Search: review, batch 2 round 2

**Result: 0 Error, 0 Misleading, 1 Minor (unverified).** No implementation or drawing errors. The reviewer's independent implementation gives points bitwise identical to the scripts' `%.17g` output (10/10, 26/26, 32/32 rows, identical keep sequences); 50-digit runs make the same choices and reach the same K.

The reviewer consulted the archive (module text, Links 2–7, program images gr_64, gr_139, gr_222, printed tables gr_115, gr_161, gr_187, gr_216, result images, textbook PDF, animation HTML).

## Findings

### F1. Minor (page match, numbers): the difference column of the Example 2–5 tables holds Float64 differences

- **Location:** `index.qmd`, Example 2 row k = 29 (line 287), Example 3 row k = 28 (line 327), Example 4 rows k = 30, 31 (lines 368–369), Example 5 rows k = 29, 31 (lines 402, 404).
- **Now vs true** (true = 50-digit evaluation of f(c_k) − f(d_k) at the same double-precision points):

| Table, row | Page | True | Float64 `fc − fd` |
|---|---|---|---|
| Ex 2, k = 29 | −6.47e−14 | −6.49e−14 | −6.473e−14 |
| Ex 3, k = 28 | 3.73e−13 | 3.74e−13 | 3.735e−13 |
| Ex 4, k = 30 | −4.12e−13 | −4.17e−13 | −4.121e−13 |
| Ex 4, k = 31 | 8.41e−12 | 8.42e−12 | 8.413e−12 |
| Ex 5, k = 29 | 4.89e−12 | 4.88e−12 | 4.889e−12 |
| Ex 5, k = 31 | −1.89e−12 | −1.92e−12 | −1.890e−12 |

- **Why it matters a little:** the column is headed f(c_k) − f(d_k), and the Example 1 table (all 26 rows correct to 3 significant figures) and the animation titles use the high-precision difference; these six entries carry the rounding of the double subtraction (about 1 ulp of f: 1.4e−14 near 118, 1.1e−16 near 0.77). All signs are correct, so no decision or conclusion changes.
- **Fix:** recompute the column of Examples 2–5 as f(big(c)) − f(big(d)), as Example 1 and the scripts' `fdiff` do: −6.49e−14, 3.74e−13, −4.17e−13, 8.42e−12, 4.88e−12, −1.92e−12.

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (no `.jl` or `.gif` change since `f9a2662`); round 1 regeneration stands: all three GIFs byte-identical (12, 28, 34 frames). References resolve; no orphans; the index links the page.

## Claim ledger (summary; C = confirmed)

110 claims checked. All C except F1's six entries. Highlights:
- **Description and introduction (claims 1–17):** formulas, ρ = 0.61803398875, reuse, panel contents (p line RGB (2, 129, 2) top, (23, 139, 23) bottom), green bar placement, frame mapping, held last frame (12, 28, 34), labels gain digits with no duplicate labels, BigFloat titles and zoom, Float64 signs = high-precision signs, lost GIF and Example 6 pictures (gr_226–gr_244 missing), Mathews' window and step count (gr_222 `While[k < max]`), not-animated list against every module example, tie rule (`If[Yc < Yd, …]`), ρ² and return rule.
- **Case 1:** sides cb, ad, cb, ad, cb, cb, ad, ad, cb; p = 0.63245553203; width 0.0131556; a₉ 6.291e−3 and midpoint 2.869e−4 from p.
- **Case 2:** `GoldenSearch[0, 1, 25]` (gr_72); p = 0.450183611295; ρ¹⁰ = 0.00813; differences 1.94e−9 at k = 18 (1.17e−8 at k = 17), 1.194e−12 at k = 24; b₂₅ 1.354e−6, midpoint 1.627e−6 from p.
- **Case 3:** critical points −0.6538809313 and 0.377002055653 (f′ scan on [−3, 1] finds only −2.379, −0.654, 0.377); f(c₀) = 1.24452 > f(d₀) = 0.811471; p in all 32 brackets; K = 31 (width 1.075e−6 at k = 30); a₃₁ 2.33e−7 from p; smallest difference 4.715e−14 = 424.7 double spacings.
- **Theory and algorithm (41–50):** derivation, ρ, ρ², φ, link to the Fibonacci page's r₁ = (1 − r₀)/r₀ (that page line 89), theorem, ln 10 / ln φ = 4.785, Mathews' programs (gr_64, gr_139).
- **Example 1 (51–67):** 26-row table 0 mismatches; module list gr_115 compared at every row; textbook Table 8.2 notes; secant table; Fibonacci n = 21 sides.
- **Examples 2–5 (68–93):** critical points and bounds, K values, results, Mathews' reported values (gr_163 and others), voltage margin 1.6946, 4×10⁶-point sampling; tables C except F1.
- **Example 6 (94–102):** table 0 mismatches, Fibonacci n = 12 sides, 6182 and 7572 vs 6000, distance table, continued run to [0.6324553, 0.6324562].
- **Comparison and implementation notes (103–108):** ratio 0.871184, tolerance step k = 14 (k = 13: 1.37e−6; k = 14: 2.11e−7), double-precision limit (max 2.0 units for k = 37…55, first wrong comparison k = 42, first interval without p k = 43, under both tie rules; Julia `prec.jl`), √u = 1.49e−8.
- **Wiring (109–110):** C.

## Implementation checks

All three scripts are one template (diff shows only parameters and headers differ): golden-section search with r1 = (√5 − 1)/2, r2 = r1², reuse of the surviving point, tie rule ≤ for [a, d] (asserted never to occur; Mathews uses <), fixed K or Mathews' `|f(b) − f(a)| > ε or b − a > δ`, Mathews' return rule. References: √10/5 exact (5p⁴ = 4/5); BigFloat Newton minimisers match mpmath `findroot`; p in every bracket. Frames (first, middle, last of each, plus sheets): dots at (x, f(x)), pink fill on [a_k, b_k], green bar matching the title and keep column, zoom titles with the right k, width and difference, green p line, orange local-maximum line at −0.6539, no clamping, the compared dots separated in the zoom at Case 2 k = 24 and Case 3 k = 31, legends clear of the curve.
