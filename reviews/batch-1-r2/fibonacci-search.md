# Review: Fibonacci Search (batch 1, round 2)

**Result: 0 Error, 0 Misleading, 0 Minor.** This was a fresh, independent review; no earlier report was read.

Every number and behaviour statement on the page was checked against the reviewer's own computation:
- an exact `Fraction` search with f evaluated in mpmath at 50 digits;
- instrumented copies of the scripts;
- the extracted frames;
- the legacy archive: the module text, Mathews' subroutine (gr_167, gr_242), the Example 1 and 2 output images, and all 31 distinct frames of `Fibonacciaa.gif`.

Two observations the reviewer did not count as findings:
- Line 12 says "two interior points $c_k < d_k$", but at the last step $c_{n-3} = d_{n-3}$. The same paragraph and line 20 say so explicitly.
- The line 348 note, that f looks unimodal on 7 points spaced 1e-8, holds on a grid centred at p. Off-centre, about 9% of positions show one tie (never a reversal), and at 1e-9 every position fails, so the note's point stands.

## Findings

None.

## Inventory (Phase 1)

- **Scripts:** `fibonacciaa.jl`, `fibonaccibb.jl`, `fibonaccicc.jl`.
- **GIFs:** 13, 33 and 23 frames decoded (11, 31 and 21 distinct).
- Every file is referenced by the page and no reference is missing. The section index links the page.
- All three GIFs regenerate byte-identically.

## Claim ledger (whole page): 103 entries, all confirmed

Highlights:

**Description**
- The squeeze rule, the n rule (Mathews' `While[F_n ≤ …]`), and r_k.
- The last widths: 2/144, 2/2178309, 2/10946.

**Animations introduction**
- The panels, colours and green bar. A pixel check shows the dashed p line is green in every frame.
- The labels' resolution is at most w/10 against a spacing of at least w/5.
- The tie rule differs from Mathews', and no run has a tie.

**Case 1**
- The keep pattern L at k = 0, 2, 4, 5, 8.
- 91/144, 5.1109e-4 from p, against the bound 6.9444e-3.

**Case 2**
- All 30 legacy lists were transcribed, and all match the exact run (and the golden search to six decimals; the largest difference is 1.10e-7).
- F₂₂/F₃₂ = 0.008131.
- The smallest difference is 8.267e-14, which is 5957 ulp.
- All 29 Float64 decisions match the exact decisions.
- p̂ = 65604/103729 = 0.632455725978, 1.9394e-7 from p.

**Case 3**
- The differences at k = 14–17: 4.82e-8, 6.95e-8, 4.26e-9, 1.61e-8.
- c′ = 0.450208295, d − c′ = 1.827e-6, and f(c′) − f(d) = −1.1389e-10.
- The final bracket is 9.1358e-5 long.
- The points overlap in the split frame, as the page says.

**Derivation, Fibonacci numbers and Algorithm**
- The algebra was rechecked.
- Binet's formula holds for n = 0..39.
- |r_k − ρ| increases monotonically.

**Example 1**
- All 19 table rows match the exact run and Mathews' printed table.
- 0.450118764846 and 0.450301479993.
- f(c′) = −0.232465574416353 and f(d) = −0.23246557430.
- 8.558e-10, −1.579e-4 and 6.456e-5.

**Example 2**
- All 10 rows match the exact run and Mathews' gr_265.
- p = (4/25)^{1/4} = √10/5.
- 6.603e-7, −0.03706 and 0.03305.
- The split gives 0.095229527, with a bracket 0.00708333 long.

**Fibonacci versus golden ratio**
- The table: 9.318e-5, 1.070e-4, 0.8712; 7.083e-3, 8.131e-3, 0.8712.
- The range: minimum 0.86416 (n = 5), maximum 0.8739 (n = 6), limit 0.871184.

**Implementation notes**
- √eps = 1.49e-8.
- The 7-point unimodality check (`unimodal_grid.jl`).

## Implementation checks

All three scripts run textbook Fibonacci search with point reuse. `fibonaccicc.jl` adds Mathews' e-split. There are two harmless variants: the tie rule (disclosed, and no tie occurs), and no re-evaluation of f at the final midpoint (this changes only the evaluation count, which the page states for its own algorithm).

Instrumented values against the exact run:

| Case | Script | Exact |
|---|---|---|
| aa | n = 12; p̂ = 0.631944444444 | identical |
| bb | keep pattern over 29 comparisons; smallest difference 8.267e-14 at k = 28 | identical |
| cc | split c′ = 0.450208295268; difference −1.13893e-10; final width 9.13576e-5 | identical |

The reference values are right: √10/5, and the Newton root 0.450183611294874, which equals mpmath's `findroot`.

The pictures were checked in the contact sheets and in full-size frames aa 002, bb 030, cc 018 and cc 021. The bracket, the dots, the green bar and the titles all match the computation. Mathews' window is kept, nothing is clamped, and the titles fit.

The reviewer's scratch work is in `$WORK/review-batch-1-r2/fibonacci-search/reviewer/` (session scratchpad): `indep.py`, `indep2.py`, `inst_*.jl`, `unimodal_grid.jl`.
