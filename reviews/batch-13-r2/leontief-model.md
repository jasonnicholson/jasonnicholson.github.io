# Review round 2: Leontief Model (batch 13, text-only)

Page: `pages/numerical-methods/leontief-model.qmd` (246 lines after the round-1 fixes). Module: `n2003/LeontiefModelMod.html`. The reviewer consulted the archive (module, all 5 link pages, images gr_20, 60–79, 81, 110–127, 147–161, 163, 164; gr_166–171 are missing) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

Considered and judged not findings: Mathews' "any demand vector" asides, the Example 2 iteration and the RREF derivations are side remarks the page does not carry; the page's definition of "productive" is equivalent to Mathews' when $I - A$ is invertible.

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 44 entries)

Confirmed, every one: the model and definitions; the closed-model theorem with nonnegative feasibility, column sums 1 ⇒ $\det(I-A) = 0$, irreducibility ⇒ a positive null vector (Perron–Frobenius; the gloss has the right direction) and that Examples 1 and 2 are irreducible; Examples 1–4 in full (matrices from gr_20, 81, 147/148, 163/164; null vectors; solutions, exact and decimal; every verification row); the Solving by Iteration section (Mathews' iterations; the closed iteration keeps the total; Example 1 eigenvalues 1, 1/10, −1/5, error ratio → 0.2, $\mathbf x_8$; the open iteration's error $A^k(\mathbf x_0 - \mathbf x)$, $\rho < 1$, $\lVert A\rVert_1 < 1$ sufficient; Example 3 $\lVert A\rVert_1 = 0.8$, $\rho = 0.7513$, ratio → 0.75, $\mathbf x_{22}$, first rounding to (235, 335, 525) at step 37; Mathews' "slowly"; Example 4 $\lVert A\rVert_1 = 0.9$, $\rho = 0.8540$); summary; markup.

## Checks

`check.py` (sympy exact; numpy spectral radii); both iterations run as written from Mathews' starting vectors (the first iterates match his printed $P_1$–$P_4$, gr_79). Could not determine only Mathews' own printed Example 4 solution (images missing); the page's answer is verified exactly.
