# Review round 2: Cholesky, Doolittle and Crout Factorizations (batch 11, text-only)

Page: `pages/numerical-methods/cholesky-doolittle-and-crout-factorizations.qmd` (246 lines after the round-1 fixes). Module: `n2003/CholeskyMod.html`. The reviewer consulted the archive (module, Links 1–9, images gr_52, 54, 95, 185, 240–243) and did not read earlier rounds' reports. The control-character check (`grep -nP '[\x07-\x09\x0b-\x0d]'`) now finds nothing: the round-1 inventory finding is resolved.

**Findings: 0 Error, 0 Misleading, 1 Minor** (unverified).

## Findings

### F1. Page text, Minor: "One valid" suggests the Cholesky factor is not unique

- **Location:** line 143, "One valid upper-triangular Cholesky factor is".
- **True:** line 25 defines the Cholesky form with $R$ upper triangular with positive diagonal, under which the factor of an SPD matrix is unique (the only other upper-triangular $R'$ with $R'^\top R' = A$ are the sign flips $SR$, which fail the positive-diagonal condition). The wording also sits awkwardly with line 21 ("normalizations fix the choice"). The page's $R$ is that unique factor (diagonal $\sqrt2, \sqrt{3/2}, \sqrt7, \sqrt{7/3}, \sqrt2$).
- **Fix:** "The Cholesky factor (unique, since its diagonal must be positive) is", or "The Cholesky factor is".

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 42 entries)

Confirmed, apart from F1: the LU definition and non-uniqueness, the three normalized forms, the solve theorem with its nonsingularity hypothesis, forms (1)–(3) (markup now fine), the Doolittle, Crout and Cholesky recurrences (each run as written, reproducing the page's factors), the condition on divisors and radicands, the SPD existence theorem; Example 1 (Mathews' $A$, every entry of $L_D$, $U_D$, $L_C$, $U_C$, $R$, the three products, $L_C = L_D\operatorname{diag}(U_D)$); Example 2 (a) Doolittle, (b) Crout, (c) Cholesky: every $\mathbf y$, $\mathbf x$, decimal and relation stated, the shared verification table; the description of Mathews' omitted Examples 3 and 4 (his text says "four data points", his image lists six; the page is right); markup.

## Checks

`check.py` (sympy exact): the three recurrences transcribed with the page's index ranges; own forward and back substitution for Example 2; SPD check (leading minors 2, 3, 21, 49, 98). Nothing undetermined.
