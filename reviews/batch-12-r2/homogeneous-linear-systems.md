# Review round 2: Homogeneous Linear Systems (batch 12, text-only)

Page: `pages/numerical-methods/homogeneous-linear-systems.qmd` (402 lines after the round-1 fixes). Module: `n2003/HomogenLinSystemMod.html`. The reviewer consulted the archive (module, all 6 link pages, images gr_28, 87, 200, 275, 276, 370–372) and did not read earlier rounds' reports.

**Calibration page.** This was the round's pilot, reviewed on a scratch copy with two planted errors (an entry of Example 4's Step 1 matrix changed from −9 to −7; a false sentence saying free variables always come after the pivot variables). The reviewer found both; they are removed. The copy had the same line count as the page.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

No Fidelity findings: all five of Mathews' examples are present with his systems. Mathews' FreeVariables subroutine (gr_275) is replaced by the standard parametric-form method, a valid formulation.

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 63 entries)

Confirmed, apart from the two planted claims: the definitions, rank, $\operatorname{rank}(A) = \operatorname{rank}(M)$, theorems (4)–(6) with their hypotheses; the algorithm (run as written on Example 4); Examples 1–3 in full (systems from gr_28, gr_87, gr_200; RREFs; solutions; every verification row); Example 4 (system from gr_276, the Step 1 matrix, RREF, rank 3, det 0, pivots 1, 3, 4, free $x_2$, $x_5$, the basis, all five verification rows); the propane example (atom balances, RREF, (1, 5, 3, 4), atom counts); the summary (rank versus $n$; fewer equations than unknowns); links, citation and markup.

## Checks

sympy exact arithmetic (`check.py`) and an independent Fraction-based Gauss–Jordan (`algo.py`) on every example; every page value matches. Nothing undetermined.
