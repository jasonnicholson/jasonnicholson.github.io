# Review: Pivoting Methods (batch 11, text-only)

Page: `pages/numerical-methods/pivoting-methods.qmd` (229 lines). Module: `n2003/PivotingMod.html` ("Pivoting Methods"), example folder `n2003/pivoting/PivotingMod/` (10 link pages). The reviewer consulted the archive (module, all 10 link pages, images gr_81/82, gr_101, gr_125–128, gr_148–150, gr_153–155, gr_159, gr_162–164, gr_168/192/216/240/266). Example 1's solution images (gr_83–100) are missing.

**Findings: 1 Error, 3 Misleading, 1 Minor.** All four Error and Misleading findings were confirmed by an independent check.

## Findings

### F1. Page text, Error: scaled partial pivoting picks the wrong first pivot row

*Independent check: **confirmed** (Error). Ratios (1/7, 0, 1/2, 2/5); row 3 by the page's own rule (3). The rest of the table is right.*

- **Location:** line 101, `| Scaled partial | largest $|a_{i1}|/s_i$ with $s=(7,2,4,5)$ | swap row 1 with row 4 |`
- **True:** the ratios $|a_{i1}|/s_i$ are (1/7, 0, **1/2**, 2/5), so row 3 wins (also if $b$ is included in $s$). The scale vector itself is correct.
- **Fix:** "swap row 1 with row 3" (optionally "(ratios 1/7, 0, 1/2, 2/5)").

### F2. Page text, Misleading: (5)–(6) are called a bound but are a rule-of-thumb estimate, with mixed norms

*Independent check: **confirmed** (Misleading). Consistent versions: 2.44×10⁻⁶ (2-norm), 3.75×10⁻⁶ (∞-norm). The norm mixing and $\hat X$/$X$ swap are inherited from Mathews (gr_159, gr_163). In the checker's own double-precision GE with all four strategies on $H_5$–$H_{10}$, every error was ≤ 0.04 × the consistent 2-norm $\lVert X\rVert\kappa\varepsilon$.*

- **Location:** lines 202–223: `\kappa(A)=943656` (line 205), "the page gives the bound" (line 208), `\lVert X-\hat X\rVert\le \lVert \hat X\rVert\,\kappa(A)\,\varepsilon` (line 211), $\lVert X\rVert=23017.6$ (line 215).
- **True:** (1) Mathews' "Fact" (gr_159) holds "if A, B are input with machine precision": it estimates the effect of rounding the data, not the error of elimination itself, which carries growth-factor and $n$ factors. (2) 943656 is $\kappa_\infty = \kappa_1$ (exact); $\kappa_2 = 476607.25$, while $\lVert X\rVert$ and the error norms are 2-norms; a reader's `cond(H5)` gives 4.77×10⁵. (3) (5) uses $\lVert\hat X\rVert$ but (6) plugs in $\lVert X\rVert$ (Mathews uses $\lVert X\rVert$). The arithmetic (4.82295×10⁻⁶) is right and the observed errors (~10⁻⁸) are inside it.
- **Fix:** write $\kappa_\infty(A)=\lVert A\rVert_\infty\lVert A^{-1}\rVert_\infty=943656$ (2-norm about $4.77\times10^5$); present (5) as a rule-of-thumb estimate of the error caused by storing $A$ and $b$ to machine precision; use $\lVert X\rVert$ in (5).

### F3. Page text, Misleading: "This is why pivoting strategy and precision both matter"

*Independent check: **confirmed** (Misleading). At n = 10 every strategy gives an error of roughly 9×10⁴ to 1.3×10⁵; Mathews' own caveat mentions only precision. Pivoting controls the stability (growth factor) of elimination, a different point.*

- **Location:** line 228 (warning callout).
- **True:** conditioning is a property of the problem; no pivoting strategy removes it. The page's own table shows the four strategies within a factor of about 2 (7.8×10⁻⁹ to 1.7×10⁻⁸). Mathews' Hilbert examples for n = 6…10 name a different "slightly better" strategy each time; the reviewer's double-precision run on $H_5$ ranks them differently from Mathematica (trivial 1.19e-8, partial 4.22e-9, scaled 1.00e-9, total 2.32e-8).
- **Fix:** "No pivoting strategy can remove this sensitivity: all four strategies give errors of the same size. Higher working precision (or a better-conditioned formulation) is what helps."

### F4. Fidelity, Misleading: archive examples dropped, and "The module's Hilbert test uses $n=5$" is false

*Independent check: **confirmed** (Misleading). Mathews' winners for $H_5$…$H_{10}$: partial, trivial, partial, total, scaled partial, trivial; the checker's double-precision winners: scaled, trivial, partial, total, scaled, scaled. The ranking is a rounding accident, not a property of the strategy.*

- **Location:** line 158, and the example set.
- **True:** the module has 8 examples: Example 2 is a second 5×5 system, $A$ = [[1,2,4,3,5],[3,5,3,1,2],[1,4,4,2,1],[4,1,2,5,3],[5,2,1,4,1]], $b$ = (5,6,7,8,9), det −2, solution (119/2, −135/2, 87, −55, −41/2); Examples 3–8 are Hilbert systems for n = 5…10 with $B = (n, \ldots, 1)^T$. Dropping n = 6…10 hides Mathews' point that the best strategy changes from case to case, leaving line 188 ("partial pivoting gave the smallest error") as the only evidence.
- **Fix:** "The module's first Hilbert test (of six, n = 5 to 10) uses n = 5"; add a sentence or table on n = 6–10, or Example 2; at minimum say what is omitted.

### F5. Page text, Minor (unverified): when the scale factors are computed is not stated

- **Location:** lines 52–59. Mathews (and the page's own $s$) computes $s$ once from the original $A$ and swaps the factors with their rows; recomputing each step is a different variant. **Fix:** "computed once from the original matrix; when rows are swapped, swap their scale factors too."

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 54 entries)

Confirmed: GE description; pivot definition; nonsingularity theorem; the four strategies' formulas (scaled: formula only, F5); the algorithm, run as written with every strategy (all give the exact solution); Example 1's system (gr_82); trivial (no swap; pivots 1, 2, −5/2, −5), partial (tie rows 3/4, both valid), total (7 at (1,4), column swap); $s = (7,2,4,5)$; the triangular system's four rows (identical to the reviewer's partial-pivoting run); $x_4..x_1$ and $x = (-362/25, 489/25, 853/25, -142/25)$, det 25; exact-arithmetic agreement of strategies; verification rows (4, 5, 2, 9); $H_5$ and $b$; exact solution (−95, 2160, −10710, 17920, −9450); 2-norm errors; every term of the Hilbert verification rows; $\varepsilon$; $\lVert X\rVert = 23017.55$; the product 4.822953×10⁻⁶; $\log_{10}\kappa = 5.975$; markup.

Not confirmed: line 101's row (F1); line 158 (F4); (5)/(6) as a bound and the norm of $\kappa$ (F2); line 228 (F3). Could not determine: the error norms 1.56343e-8, 7.84695e-9, 1.379e-8, 1.66215e-8 are transcribed correctly from Mathews' Mathematica output (gr_150) but cannot be reproduced bit for bit; their order of magnitude agrees.

## Checks

Exact sympy elimination with every strategy (`ex1.py`): scaled step 1 prints `ratios [1/7, 0, 1/2, 2/5] chosen row 3`; total pivots 7, 41/7, 121/41. Exact Hilbert solve and norms (`ex2.py`): κ∞ = κ₁ = 943656, κ₂ = 476607.25, ‖X‖₂ = 23017.5504. Double-precision strategy runs (`ex2float.py`) as in F3. Archive Example 2 solved exactly (F4).
