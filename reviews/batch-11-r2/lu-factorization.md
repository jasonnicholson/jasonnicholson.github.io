# Review round 2: LU Factorization (batch 11, text-only)

Page: `pages/numerical-methods/lu-factorization.qmd` (468 lines after the round-1 fixes). Module: `n2003/LUFactorMod.html`. The reviewer consulted the archive (module, all 9 link pages, images gr_7, 8, 22, 39, 49, 92, 94, 133, 137, 141, 194, 200, 212, 242–244, 250, 256, 259, 260) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

Departures considered and judged not findings: Example 2's reordering uses rows (2, 3, 1) where Mathews uses (1, 3, 2) (both valid; the page's is exactly what partial pivoting produces); Mathews' aside reusing the factorization for $\mathbf b = (1, 5, 4)$ is omitted (answer $(1/3, -1/6, 1)$, matching gr_137); source Examples 2 and 5 are omitted with a sentence (the archive's "n = 3" in Solution 5 is a slip; the page correctly says 4×4).

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 69 entries)

Confirmed, every one: the definition, Doolittle form, the solve via (1), the no-pivoting theorem, recurrence (2)–(3) (run as written); Example 1 (every $u$, $\ell$, $L$, $U$, rows, $LU = A$); Example 2 ($\det 175$, the breakdown, the reordering, $L$, $U$, $LU = PA$); the PA = LU theorem and (5); Example 3 with partial pivoting (the swap, $P$, $PA$, multipliers, eliminated rows, $L$, $U$, leading minors 2, −36, −126, $|\ell_{ik}| \le 1$, $P\mathbf b$, $\mathbf y$, $\mathbf x = (-1, 1, 3)$, rows); the omission sentence; the least-squares setup and re-indexed (6); Example 4 ($\mathbf c = (357/10, -347/10, 21/2)$, rows); Example 5 ($\mathbf c = (0,0,0,1)$; the perturbation; $\tilde{\mathbf c}$ and decimals; perturbed rows; 35.7%; $\kappa_\infty(A) = 43{,}915{,}200$, $\kappa_\infty(\tilde A) = 28{,}751{,}832.4$); markup.

## Checks

`check.py` (sympy exact; numpy for the condition numbers): `doolittle()` and `plu()` as written, traced against Mathews' `LUfactor` (gr_92); normal equations rebuilt from the data with (6). Nothing undetermined.
