# Review: Cholesky, Doolittle and Crout Factorizations (batch 11, text-only)

Page: `pages/numerical-methods/cholesky-doolittle-and-crout-factorizations.qmd` (179 lines). Module: `n2003/CholeskyMod.html` ("Cholesky, Doolittle and Crout Factorization"), example folder `n2003/cholesky/CholeskyMod/` (9 link pages). The reviewer consulted the archive (module, all 9 link pages, images gr_52, gr_56, gr_95, gr_185, gr_242).

**Findings: 1 Error (plus 1 inventory Error), 0 Misleading, 4 Minor.** The page-text Error was confirmed by an independent check.

## Inventory finding (mechanical check)

### I1. Page text (markup), Error: nine lines have a tab where LaTeX lost `\t`

`\t` was read as a tab, turning `\tag{…}` into a tab plus "ag{…}" on lines 42, 47 and 52, and `\tfrac` into a tab plus "frac" on lines 76, 77, 78, 160, 162 and 163 (`grep -nP '[\x07-\x0d]'`). The plan counted six lines; lines 76–78 (in $L_D$) are also broken. On the rendered page the three equation numbers and nine fractions in $L_D$ and in the Example 2 solution show as "ag{1}" / "frac12" text, so the reader loses the factor entries and the solution's exact values. The reviewer read those lines as the author intended and found their content correct. **Fix:** restore `\tag` on lines 42, 47, 52 and `\tfrac` on lines 76–78, 160, 162, 163 (plan decision B: fixed in batch 11).

No leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Findings

### F1. Page text, Error: the $A = D - L - U$ sentence is false and unrelated to the formulas

*Independent check: **confirmed** (Error). On the page's own matrix, with L and U the strict parts, `D-L-U == A` is False and `D+L+U == A` is True; the factors are not built from D, L, U. The phrase appears to have been carried over from the Jacobi and Gauss-Seidel page (its line 19), where the splitting is used with L and U defined as the negated strict parts. Suggested fix: "The three practical forms are:".*

- **Location:** line 38: "For $A=D-L-U$ splitting (diagonal part $D$, strict lower part $L$, strict upper part $U$), the three practical forms are:"
- **True:** if $A = D - L - U$, then $L$ and $U$ are the *negatives* of the strict lower and upper parts. More importantly, that additive splitting (Jacobi, Gauss–Seidel) has nothing to do with the multiplicative factorizations $A=L_DU_D$, $A=L_CU_C$, $A=R^\top R$; none of their factors is built from D, L, U (e.g. $L_D$ row 2 is [1/2, 1, 0, 0, 0], not ±[1, 0, 0, 0, 0]). It also gives L and U a third meaning on the page.
- **Fix:** delete the splitting clause, e.g. "With $L_D,U_D$ the Doolittle factors, $L_C,U_C$ the Crout factors and $R$ the Cholesky factor, the three forms are:"

### F2. Page text, Minor (unverified): the "Solve via Factorization" theorem leaves its hypothesis implicit

- **Location:** lines 28–33. Forward and back substitution need nonzero diagonals, which holds exactly when $A = LU$ is nonsingular (det A = ∏lᵢᵢ∏uᵢᵢ). The definition at line 14 has it, so the gap is small; Mathews has the same gap.
- **Fix:** "If $A=LU$ with $A$ nonsingular (so every diagonal entry of $L$ and $U$ is nonzero), then …"

### F3. Page text, Minor (unverified): $L_C$ (Crout) and $L_c$ (Cholesky) differ only in case

- **Location:** lines 25, 46, 51. They are different matrices (diagonals (2, 3/2, 7, 7/3, 2) and (√2, √6/2, √7, √21/3, √2)). **Fix:** call the Cholesky factor $G$ or $L_{\mathrm{ch}}$, or use only $R^\top R$.

### F4. Fidelity, Minor (unverified): the "Formulas" section has no formulas

- **Location:** lines 36–53 only restate $A=LU$ three ways. Mathews gives the entry recurrences for Doolittle, Crout and Cholesky ($l_{kk}=\sqrt{a_{kk}-\sum l_{ks}^2}$, …), the existence theorem (real symmetric positive definite ⇒ Cholesky exists), and the remark that LU is not unique.
- **Fix:** add the recurrences (the reviewer's row-of-U / column-of-L recurrences reproduce every entry on the page) and the SPD existence theorem.

### F5. Fidelity, Minor (unverified): archive Examples 2(b), 2(c), 3 and 4 silently dropped

- **Archive:** 2(b), 2(c): the same system by Crout and Cholesky (exact Crout $y = (-1, 10/3, -1/7, -1/7, 23/14)$; Cholesky $y = (-\sqrt2, 5\sqrt6/3, -\sqrt7/7, -\sqrt{21}/21, 23\sqrt2/14)$; same $x$). Ex 3: least-squares cubic for (0,12), (1,3), (2,3), (3,7), (4,9), (5,2) by Cholesky on the normal equations (Mathews' text says "four data points" but lists six); exact $c_0..c_3 = 169/14, -451/28, 219/28, -1$. Ex 4: continuous least-squares quartic for $\cos x$ on [0,1] (Gram matrix = 5×5 Hilbert). Also the normal-equations theorem and the Gram matrix definition. The page never uses its Cholesky factor to solve anything.
- **Fix:** add 2(b) and 2(c); add Examples 3 and 4, or say they are omitted.

## Claim ledger (condensed; 32 entries)

Confirmed: the LU definition; Doolittle (unit L) and Crout (unit U) conventions; Cholesky for SPD $A$; $Ax=b \iff Ly=b, Ux=y$; forms (1)–(3) (content); Example 1's $A$ (= Mathews gr_52), SPD (leading minors 2, 3, 21, 49, 98; eigenvalues 0.154 … 14.912); every entry of $L_D$, $U_D$, $L_C$, $U_C$ and $R$ (entrywise, exact); $L_DU_D = L_CU_C = R^\top R = A$; "one valid" Cholesky factor; Example 2's $b$ (= gr_95), $y = (-2, 5, -1, -1/3, 23/7)$, $x = (-629/98, 237/49, -53/49, 62/49, 23/14)$, decimals, all five verification rows; citation and back link.

Not confirmed: line 33 hypothesis (F2); line 38 (F1); notation (F3).

## Checks

Independent exact Doolittle, Crout and Cholesky routines on $A$ reproduce every page entry; pivots 2, 3/2, 7, 7/3, 2 multiply to det A = 98; $L_C = L_D\operatorname{diag}(U_D)$. Example 2's forward and back substitution reproduce the page's $y$ and $x$; `A.LUsolve(b)`, Crout and Cholesky solves give the same $x$; $Ax$ = (−2, 4, 3, −5, 1). Markup outside the inventory lines is valid KaTeX.
