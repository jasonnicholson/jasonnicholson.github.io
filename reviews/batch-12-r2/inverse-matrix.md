# Review round 2: Inverse Matrix (batch 12, text-only)

Page: `pages/numerical-methods/inverse-matrix.qmd` (434 lines after the round-1 fixes). Module: `n2003/InverseMatrixMod.html`. The reviewer consulted the archive (module, all 7 link pages, images gr_14, 121, 123, 125, 126, 141, 162, 164, 167, 168, 188, 189, 218, 223, 228, 231) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 2 Minor** (unverified).

## Findings

### F1. Page text, Minor: the range of $H_{12}$ inversion errors is a typical band, not a range

- **Location:** lines 205–208, "… a computed inverse has at most about two correct digits: its relative error ranges from about 1% to 30%, depending on the method and on last-bit rounding of the entries."
- **True:** on correctly rounded $H_{12}$ the 2-norm relative error is 7.7% (LAPACK `inv`, LU solve), 5.6% (Gauss–Jordan with pivoting), 7.1% (without), 9.4% (Cholesky). Over 1000 random last-bit roundings (symmetric) it runs from 0.02% to 34% (5th–95th percentile about 0.6%–17%, median 6–7%); 6–8% of roundings give under 1% (as low as 2×10⁻⁴, about 3.7 digits). The message (one or two digits, erratic) holds, but the endpoints and "at most about two" are not hard limits.
- **Fix:** "typically has only one or two correct digits: its relative error is usually between about 1% and 20%, and varies erratically with the method and with last-bit rounding of the entries (occasionally much smaller or larger)."

### F2. Page text, Minor: the pivot rule says "largest entry", not "largest in absolute value"

- **Location:** line 46, "Find the largest entry in column $j$ at or below row $j$; swap that row with row $j$ (partial pivoting …)".
- **True:** partial pivoting takes the largest absolute value (for a column $(-10, 1)$ the literal rule would pick 1). Example 1's candidates are all positive, so it is unaffected.
- **Fix:** "Find the entry of largest absolute value in column $j$ at or below row $j$ …".

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 77 entries)

Confirmed, apart from F1 and F2: the inverse, its $O(n^2)$ cost, LU's equal per-solve cost at a third of the setup and its better accuracy (measured on random matrices with $\kappa = 10^2$–$10^{14}$: LU never meaningfully worse, often 2.5–41 times better), the Gauss–Jordan theorem and algorithm (run as written: one swap at step 2, same $A^{-1}$); Example 1 (every step matrix, $A^{-1}$, $\det -48$, rows); Hilbert definition and matrices; $\kappa_2(H_5) = 476607.25$, the magnification statement, "about 12 digits" for $H_5$ in double (11.5–12.4 digits; 10.7–13 over last-bit roundings), $\kappa(H_{12}) = 1.7132\times10^{16}$; formulas (7) and (8) (n = 1–10), $H_5^{-1}$ and the worked entries; Example 2 (the rounded $H_5$ against gr_125, its inverse to 2 decimals against gr_141, 3.33×10⁻⁷, entry (4,4) 207458.85 and the 15.8% error, (1,1) 26.93, the 4.04×10⁵ magnification, row 1 of $AA^{-1}$, the 2.13×10⁻¹² double-inversion agreement); Example 3 ($y_1$–$y_5$, the five $c$ closed forms and values, row-product terms up to 30775, the 5-decimal-$y$ result, the norm-wise error of a few parts in 10¹², $p(x)$ against Mathews' gr_231, $p(0)$, $p(1)$, max errors 1.7×10⁻⁵ and 1.364×10⁻³); the closing statements; markup.

Fidelity: Mathews' Examples 1, 3, 4 are the page's 1, 2, 3; his Example 2 (Gauss–Jordan on exact $H_5$) is covered by the formulas and the callout. No Fidelity finding.

## Checks

`ex1.py`, `hilb.py`, `ex2.py`, `ex3.py` (sympy exact), `fpinv.py`, `robust5.py`, `h12seeds.py`, `h12bracket.py`, `luvsinv.py` (double-precision measurements across methods and last-bit roundings; mpmath references).
