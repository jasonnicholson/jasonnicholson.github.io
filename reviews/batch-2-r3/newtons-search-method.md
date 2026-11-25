# Newton's Search Method: review, batch 2 round 3

**Result: 0 Error, 0 Misleading, 1 Minor (unverified).** No implementation or drawing errors and no fidelity findings.

This page was the round 3 calibration pilot. The reviewer worked on a scratch copy with two planted errors in the Case 3 Behavior paragraph (line 46: "From then on H stays indefinite", true: positive definite at P₁…P₅; and a distance of 6.086 × 10⁻⁷, true: 6.056 × 10⁻⁷). It reported both as Errors with its own 100-digit computation, the GIF titles and the page's own table, so the brief was not changed. The planted findings are omitted; the real page says "positive definite" and 6.056 × 10⁻⁷, which the reviewer's run confirms (smallest eigenvalues 0.4075, 0.4108, 0.3994, 0.3994, 0.3994 at k = 1…5; ‖P₃ − (1, 1)‖ = 6.05593 × 10⁻⁷). Line numbers are the real page's.

The reviewer consulted the archive (module HTML, notebook `NewtonSearchMod.nb`, printouts gr_35, gr_59, gr_143, gr_180, gr_190, gr_191, gr_192, gr_195, gr_203; the Example 3 and 6 printouts are missing).

## Findings

### M1. Minor (page match), line 22

- **Now:** "Case 1 drops them, so its $0.045$ stands for $0.04500$ and its $2.15$ for $2.150$."
- **True:** both statements hold (0.0449983, 2.1499046), but the sentence reads as a complete list; other Case 1 title values also drop trailing zeros: 0.721 for 0.7210 (frames 24–25), 5.95 for 5.950 (eigenvalues, frames 2–5), 6.69 for 6.690 (frames 6, 12), 5.73e−15, 2.07e−11, 8.65e−05 (from the instrumented `aa_titles.txt`).
- **Fix:** "for example, its $0.045$ stands for $0.04500$ and its $0.721$ for $0.7210$".

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (no `.jl` or `.gif` change since `f9a2662`); all three GIFs byte-identical to their scripts' output. References resolve; no orphans; the index links the page.

## Claim ledger (summary; 92 claims)

All confirmed except M1 (and the two planted claims). Highlights:
- **Description:** step H ΔP = −∇f by Cramer's rule in all three scripts; Newton-Raphson equivalence; one-step minimisation of a quadratic (Example 3, error 0); saddles, maximum (run from (0.3, −0.2)), runaway (−3, 2). "Recomputed in 60-digit arithmetic": could not determine (process claim); all values confirmed at 80–400 digits.
- **Introduction:** markers and typing (`kind()` in aa; H = ±I/4 in bb), titles, frame mapping, 256 bits = 77.06 digits, every title value correctly rounded (Case 1: 50/50 titles identical to the reviewer's 80-digit strings; Cases 2 and 3: 0 mismatches), trailing-zero statement (M1), no Mathews animation, Mathews' windows (notebook lines 3304, 3807), not-animated list (`FindMinimum` at notebook lines 3120/3214/3475/3614/3698/4243, `PlotVectorField` at 3367/3865), wiring.
- **Case 1:** 25 = 5 + 6 + 6 + 4 + 4 frames, Mathews' step counts and the 5-step note (gr_190, e₃ = 1.9e−18), nullclines and five crossings (degree-9 resultant), zoom units per run, contours and arrow (frames 1, 7, 22, 25), H types and eigenvalues −4.79004 and 33.75, saddle limits and f rises (+0.003482, +0.0358), f vs Q 5.61% / 0.0775%, case (ii) distances, alt text.
- **Case 2:** convergence and errors 1.063 … 1.481e−15, ratios 0.1543 … 1.054, 5 iterations (notebook line 4222), P₁ = (−5.763, 3.579), widening window, H indefinite and f rising (k = 0…80), factors 1.882 … 1.500, ‖P₁₀‖ = 281.6, P₁₀, f, alt text.
- **Case 3 (real text):** k = 0…5, valley floor, window vs Mathews' [0.5, 1.5]² (notebook line 3179), H(P₀) indefinite, y − x² = −4.03e−6, 0.01414 → 0.02673, then positive definite, distances 1.636e−4, 6.056e−7, 8.305e−14, 1.571e−25, right-hand run (P₁, P₂, P₃, f values, 4.045e−32), alt text.
- **Worked examples 1–6, convergence table (all 8 rows at 400 digits, ratios listed in the reviewer's report), enhanced method and implementation notes:** all confirmed, including Mathews' printed values (gr_35, gr_59, gr_143, gr_180, gr_192, gr_195, gr_203), the double-precision remark (six variants: 5.386–5.403e−25, then 0 or 8.1e−28), the factor 1.5000 from k = 11, and H indefinite and uphill for all 80 steps from (−3, 2).

## Implementation checks

- **`newtonsearchaa.jl`:** plain Newton search, Cramer's rule; gradient and Hessian match sympy; every iterate in `regen/newtonsearchaa.out` matches the reviewer's 100-digit mpmath run to 12 decimals; all 50 title strings match its 80-digit values; limits match the resultant roots to 13 digits; zoom offset Qc = ½ g·Δ correct; arrow and P* correct (frames 1, 7, 22, 25).
- **`newtonsearchbb.jl`:** same method; derivatives identical to the page's (sympy-confirmed); both runs and all title numbers match; (∓1, ±1) checked analytically; `pathdraw` shows off-window segments visibly leaving the frame with true labels; widening window holds the path (frames 2, 11).
- **`newtonsearchcc.jl`:** same method; both runs, titles and annotation match; (1, 1) exact; run A stays inside the zoom; the f-rise annotation sits at k = 2; titles report the Hessian type correctly (frames 4, 6).
