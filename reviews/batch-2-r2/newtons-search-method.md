# Newton's Search Method: review, batch 2 round 2

**Result: 0 Error, 0 Misleading, 2 Minor (unverified).** No implementation or drawing errors. All 77 title lines across the three GIFs are identical, character for character, to strings the reviewer built from its own 80-digit run, and all 10 page tables match its independent implementation (0 mismatches; a mutation test of the comparator caught 3 of 3 planted errors).

The reviewer consulted the archive (module HTML, example link pages, notebook `NewtonSearchMod.nb`, output images gr_35, 56, 143, 180, 190, 192, 195, 203; the Example 6 output images gr_225–257 are missing).

## Findings

### M1. Minor (page match), line 511

- **Now:** "by a factor that approaches $1.5$ (it is $1.5000$ to five digits from $k = 20$ on, in a run of 80 steps)".
- **True:** in a 60-digit 80-step run, ‖P_k‖/‖P_{k−1}‖ − 1.5 is 8.19e−5 at k = 10 (1.5001), 3.64e−5 at k = 11 (rounds to 1.5000 and stays there), 3.19e−6 at k = 14, 2.46e−8 at k = 20. The sentence is true but puts the threshold at k = 20 instead of k = 11 (`reviewer/fac.py`, `conv.py`).
- **Fix:** "from $k = 11$ on", or "1.5000 to five digits by k = 11, and within 10⁻⁷ of 1.5 by k = 20".

### M2. Minor (implementation / page match), `newtonsearchaa.jl` line 15 and page line 22

- **Now:** the page says "every value in a title is correct to the four significant figures shown"; `newtonsearchaa.jl` formats with `%.4g`, which drops trailing zeros, so Case 1 titles show e.g. "P₂ = (2.15, 1.589)" for (2.1499, 1.5886), "‖P₁ − P*‖ = 0.045" for 0.04500, "(-0.9021, 0.721)" for (−0.90215, 0.72102), "eigenvalues 5.95 and 10.04" for 5.9501.
- **True:** every value is correctly rounded, but some show two or three figures and a reader can take "0.045" as exact. `newtonsearchbb.jl` and `newtonsearchcc.jl` keep trailing zeros for exactly this reason (their lines 15–17).
- **Fix:** use the bb/cc `fmt` in `newtonsearchaa.jl` (keeping `fmt0` for exact zeros) and regenerate, or reword the introduction to "rounded to four significant figures (Case 1 drops trailing zeros)".

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (no `.jl` or `.gif` change since `f9a2662`); round 1 regeneration stands: all three GIFs byte-identical to their scripts' output (25, 11 and 6 frames). References resolve; no orphans; the index links the page.

## Claim ledger (summary; C = confirmed)

- **Description:** Newton step, Newton-Raphson on ∇f = 0, 1-D form (Lemma 1 symbolic) C; quadratic minimised in one step (Example 3) C; saddles, maxima, runaway C; "recomputed in 60-digit arithmetic" CND (process claim; values agree with 100-digit runs).
- **Animations introduction:** markers, titles (H type in Case 1's zoom title; ‖P_k‖ for the divergent run), frame k = row k, Case 2 to k = 10, 256 bits ≈ 77 digits, title values and 80-digit reproduction (see M2 on "figures shown"), no Mathews animation, Mathews' windows (notebook ContourPlot calls), not-animated list: C.
- **Case 1:** 25 frames = 5 + 6 + 6 + 4 + 4, Mathews' step counts and the 5-step note for (1.0, 0.8) (gr_190, e₃ = 1.9e−18), nullclines and five crossings (degree-9 resultant), zoom unit wording, contours and arrow (frames 1, 5, 12, 22), H types and eigenvalues −4.7900, 33.750, saddle limits, f rising on the first saddle step (+0.003482, +0.0358), f vs Q discrepancy 5.61% / 0.0775%, case (ii) distances, alt text and wiring: C.
- **Case 2:** k = 0…10, convergence with H positive definite and f decreasing, errors 1.063 … 1.481e−15, ratio 0.15 → 1.05 (0.1543, 0.4507, 1.009, 1.046, 1.054), 5 iterations as Mathews, P₁ = (−5.763, 3.579) leaves the window, widening window holds the path (R = 315 at k = 10), H indefinite and f rising, growth factors, ‖P₁₀‖ = 281.6, P₁₀ = (−241.0, 145.6), f = −0.004876, alt text and wiring: C.
- **Case 3:** k = 0…5, valley floor, left window vs Mathews' [0.5, 1.5]², H(P₀) indefinite, y − x² = −4.03e−6, distance 0.01414 → 0.02673, then 1.636e−4 … 1.571e−25, right panel with H positive definite (smallest eigenvalue 0.1436 at k = 1), P₁, P₂, P₃, f values and f(P₅) = 4.045e−32, alt text and wiring: C.
- **Example 1, Example 2, method section, Example 3:** every formula, value, table and verification C (symbolic checks; gr_35, gr_56).
- **Example 4:** all values, tables, eigenvalues, ratio alternation, double-precision remark (six numpy codings: 5.386–5.403e−25 at k = 4, then 0 or about 8.1e−28), Mathews' 5.4023e−25 and 3.1554e−30 (gr_143), H(1, 1) eigenvalues and ratio 2508, variant table: C.
- **Example 5:** derivatives, resultant, stationary-point table, exact first steps, all five tables, agreement with Mathews (gr_180, 195, 203), ratios 1.073 and 1.017, Mathews' (1.0, 0.8) typo, saddle f rises, neighbour values (gr_192), ‖∇f‖ < 1e−17 within five steps, global minimum −1.846283: C.
- **Example 6:** stationary points, steps 1–2, 5-row table, (−3, 2) values and divergence table, P₁₀, H indefinite and uphill for k = 0…12, "diverging to the point at infinity" (notebook line 4330), symmetry argument: C; divergence-factor threshold **M1**.
- **Convergence table:** every row C from 420-digit ratios over 7 steps; order estimates 1.92–2.11 C.
- **Enhanced method and implementation notes:** C.

## Implementation checks

All three scripts run plain Newton's method for ∇f = 0 (H ΔP = −∇f by Cramer's rule, full step, no line search) in 256-bit BigFloat, as the page describes.

- **`newtonsearchaa.jl`:** derivatives match sympy (`ex45.py`); every iterate, f, error, eigenvalue and step length matches the reviewer's 100-digit sympy/mpmath implementation; five limits match the resultant roots to ≥ 12 digits; zoom Q built from ∇f and H at P_j with a shared offset; arrow and circle correct; 77 digits suffice for the 10⁻²⁹ zoom (needs about 56); all 50 title strings identical to the independent ones; only M2.
- **`newtonsearchbb.jl`:** both runs match (P₁ = (−5.763158, 3.578947), P₁₀ = (−241.019696, 145.628489)); (∓1, ±1) exact; `segdraw` keeps the off-window segment's direction and labels use true values; widening window and log panel correct (frames 2, 11); all 11 title strings identical.
- **`newtonsearchcc.jl`:** both runs match to 12 decimals; valley floor, jump to P₂ = (1.0006, 0.3653) and its annotation correct; log panel 10⁻⁵²–10⁴ contains every f (smallest 4.937e−51); all 16 title strings identical.
