# Review round 2: Iterative Refinement (batch 12, text-only)

Page: `pages/numerical-methods/iterative-refinement.qmd` (after the round-1 fixes). Module: `n2003/IterativeRefinementMod.html`. The reviewer consulted the archive (module, link pages 1–11, images gr_97, 108, 122, 124, 128, 129, 132–136, 138, 140, 141, 143, 145, 146, 148, 149, 153, 156–158, 162, 203, 345, 392) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

Considered and not findings: "each refinement step uses only triangular solves" (also a residual product, which the algorithm box shows); the Example 1 verification table states equations rather than substituted arithmetic (every row holds); the ill-conditioning callout (true for the stored, rounded $H_5$, as the page itself says); the algorithm box's `$$` block as a lazy list continuation (renders inside the item). Omitted Mathews examples are disclosed (line 184).

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 51 entries)

Confirmed, apart from one could-not-determine: the method and the higher-precision residual point (Mathews' "signal feature"); stagnation in working precision (200 random starts); definitions (4)–(6) and the algorithm (run as written); Example 1 ($A$, $\mathbf b$ from gr_97, $r^{(0)}$, $\Delta x^{(0)}$, $x^{(1)}$ exact, rows, $r^{(1)} = 0$, one-step exactness); Example 2 ($H_5$, $x_{\rm true}$, omitted examples and their $\kappa_\infty$ range 2.9×10⁷–3.5×10¹³, $x^{(0)}$, exact $r^{(0)}$ and decimals, Mathematica's printed errors, exact $\Delta x$, Mathews' printed $\Delta x$ and $x^{(1)}$ digit for digit, their errors, the exact residual of the printed digits, the ulp sensitivity, Mathews' LU-solve and caveat, $x^{(2)}$, the NumPy/LAPACK step errors and residuals (identical across partial-pivoting implementations and summation orders), the exact-residual runs); conditioning ($\kappa_\infty = \kappa_1 = 943656$, $\kappa_2$, estimate (7) with its hypothesis, 3.75×10⁻⁶, Mathews' 4.82295×10⁻⁶ and its cause, 2.44×10⁻⁶, the rounded-system solution 1.68×10⁻⁸ from $x_{\rm true}$, $x^{(2)}$ agreeing with it); digits lost.

Could not determine: Mathews' starting vector for the page's Example 1 (images gr_98–107 missing); the page's arithmetic from its $x^{(0)}$ is correct.

## Checks

`ex1.py`, `ex2.py` (sympy exact), `fp.py`, `fp2.py`, `r1.py` (numpy/scipy runs, hand-written pivoted LU, alternative summation orders); details in the reviewer's report.
