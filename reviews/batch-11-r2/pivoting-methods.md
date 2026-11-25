# Review round 2: Pivoting Methods (batch 11, text-only)

Page: `pages/numerical-methods/pivoting-methods.qmd` (after the round-1 fixes). Module: `n2003/PivotingMod.html`. The reviewer consulted the archive (module, link pages 1–10, images gr_44–69, 81, 82, 101, 126–128, 148–155, 159, 162–164, 167/168, 191/192, 215/216, 239/240, 265/266; gr_83–100 are missing) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

Notes (not findings): the double-precision rerun claims (line 190, 234) were reproduced with 12 orderings of the floating-point operations (winner changes at n = 5–8 and 10, scaled partial always at n = 9, error ranges 1.00×10⁻⁹–7.88×10⁻⁸ at n = 5 and 7.61×10⁴–1.44×10⁵ at n = 10); two variants outside the page's stated set (reciprocal multiplier; a non-standard fraction-free update) behave slightly differently, and the page words the exception as a property of the orderings it tried, so it is accurate. Mathews' text for partial pivoting reads like his trivial-pivoting rule, but his subroutine is the standard one, which the page uses.

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 46 entries)

Confirmed, every one: GE and pivot definitions; the nonsingularity theorem; the four strategies (scale factors computed once and swapped with rows); the algorithm, run as written with each strategy on Example 1; Example 1's table (trivial, partial with its tie, scaled with ratios 1/7, 0, 1/2, 2/5 → row 3, total), the partial-pivoting triangular system, $x_4..x_1$, the solution, exact agreement of all strategies, verification rows; the omitted second 5×5 system (disclosed); six Hilbert tests with $\mathbf b = (n, \ldots, 1)$; $H_5$, its exact solution, the quoted Mathematica error norms (as quotes, gr_150), the per-$n$ winners named by Mathews, the rerun paragraph; the Hilbert verification rows; $\kappa_\infty = 943656$, $\kappa_2 \approx 4.77\times10^5$, the rule-of-thumb estimate with its stated scope, $\lVert X\rVert_2$, the three estimates (4.823×10⁻⁶, 2.44×10⁻⁶, 3.75×10⁻⁶), $\log_{10}\kappa_\infty$, the callout; markup (pandoc parses the table cells with math intact).

## Checks

`ex1.py` (sympy exact, every strategy), `hil.py` (norms and estimates), `rerun.py`/`rerun2.py` (double-precision strategies under 12+ orderings; LAPACK `gesv` for comparison). Mathews' Mathematica error norms are quoted values, not rerun.
