# Review round 2: Tri-Diagonal Matrices (batch 12, text-only)

Page: `pages/numerical-methods/tri-diagonal-matrices.qmd` (340 lines after the round-1 fixes). Module: `n2003/Tri-DiagonalMod.html`. The reviewer consulted the archive (module, all 9 link pages, images gr_5–11, 13, 19, 43–55, 57, 83, 84) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 1 Minor** (unverified).

## Findings

### F1. Fidelity, Minor: the floating-point half of Mathews' examples is left out without comment

- **Location:** lines 319–325, "Mathews also solves this system with Mathematica's full LinearSolve, with TridiagonalSolve, and as $A^{-1}\mathbf{b}$; since the solution is unique, in exact arithmetic each must return the $\mathbf{x}$ above."
- **Archive:** each of Mathews' Examples 1–4 has a decimal part and a rational part, and the decimal parts carry the module's numerical point (lnk_2: "round off error near the 14th decimal place"; lnk_4: "Mathematica is able to get a slightly better answer"; lnk_8/9 close by asking why one would or would not use $A^{-1}\mathbf b$). The page covers only exact arithmetic. It does give the reason to avoid $A^{-1}$ (dense, 961 entries against 91), and every exact claim is correct.
- **Fix (optional):** one sentence on what happens in floating point (round-off at the level Mathews observes; forming $A^{-1}$ costs more for no gain in accuracy), with any number stated measured.

Considered and not findings: Mathews' archived theorem (≥ in every row) is false (counterexamples with determinant 0); the page's strict-end-row version is a needed correction. Mathews' 12.3% storage figure is $122/992$ (counting $\mathbf b$); the page's 9.5% is $91/961$ (counting $A$); both correct for what they count.

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 61 entries)

Confirmed, apart from F1: the definitions, matrices (1) and (2) (column alignment checked), equations (3), the storage counts; the restated theorem (irreducibly diagonally dominant; 20,000 random exact cases with no singular matrix or zero pivot) and its strict variant; the Thomas algorithm (4)–(6) (matches Mathews' gr_55; run as written), no pivoting needed; Example 1 in full; Example 2 (Mathews' 31×31 system): $w_k$, $d'_k$, $b'_k$ (all 31 values), the back substitution, $\mathbf x$ (equal to gr_84), $\det A = 32$, the residual classes, the inverse formula for all 961 entries, "more than ten times"; the applications; markup.

## Checks

`check.py` (exact Fractions, the page's (4)–(6) transcribed 1-based) and `thm.py` (theorem tests); sympy `LUsolve`, `det`, `inv` cross-checks. Could not determine: the digits of Mathews' decimal outputs (not quoted on the page).
