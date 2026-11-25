# Review: Gauss-Jordan Elimination and Pivoting (batch 11, text-only)

Page: `pages/numerical-methods/gauss-jordan-elimination-and-pivoting.qmd` (248 lines). Module: `n2003/GaussianJordanMod.html` ("Gauss-Jordan Elimination"), example folder `n2003/gaussjordan/GaussianJordanMod/` (7 link pages). The reviewer consulted the archive (module, all 7 link pages, images gr_49, gr_71, gr_86, gr_88, gr_116, gr_161, gr_249). Every number on the page is correct; the findings concern fidelity and wording.

**Findings: 0 Error, 1 Misleading, 4 Minor.** The Misleading finding was confirmed by an independent check.

## Findings

### F1. Fidelity, Misleading: Example 2 swaps Mathews' instructive failure for the trivial one, and Algorithm I's wording points the wrong way

*Independent check: **confirmed** (Misleading). The checker read Mathews' Example 2 (gr_71, gr_76): it runs `GaussJordan[M,3]` without interchanges and gets an all-"Indeterminate" matrix (gr_80, gr_85), "Gauss-Jordan elimination does not work without row interchanges". Original diagonal 1, 4, 5, det 49, step-2 pivot exactly 0, solution (2, −1, 1). The page's "same failure mode" is not the same: Mathews' case cannot be seen by looking at $A$. The missing solution of the page's Example 2 ((6/7, 9/7, 10/7)) is a separate Minor point.*

- **Location:** line 92, "assumes each pivot $a_{kk}$ is already nonzero and reasonably sized"; lines 172–185, Worked Example 2 with $a_{11}=0$, ending "This is the same failure mode emphasized in the original module: a no-pivot routine can break even when a unique solution exists."
- **Now:** the only failure shown is a zero in the original (1,1) entry, so a reader concludes Algorithm I is safe whenever the original diagonal is nonzero.
- **True:** Mathews' Example 2 is his Example 1 with rows 2 and 3 swapped: $A=\begin{bmatrix}1&2&3\\2&4&-1\\-3&1&5\end{bmatrix}$, $b=(3,-1,-2)^T$, diagonal (1, 4, 5), all nonzero. Algorithm I still fails, because after step 1 the matrix is `[[1,2,3,3],[0,0,-7,-7],[0,7,14,7]]`: a zero pivot at step 2. His Example 3 solves it with Algorithm II, getting $(2,-1,1)$ with one swap (rows 1↔3, largest magnitude). The page's Example 2 also never states its solution, $(6/7, 9/7, 10/7)$ (det −7).
- **Fix:** reword line 92 to "assumes every pivot that arises during elimination is nonzero (a nonzero original diagonal is not enough)"; replace or extend Example 2 with Mathews' row-swapped system (step-1 matrix with its zero (2,2) pivot, then Algorithm II to $(2,-1,1)$); if the current Example 2 is kept, state its solution.

### F2. Fidelity, Minor (unverified): Worked Example 1 is not Mathews' Example 1, with no reason given

- **Location:** lines 126–164 ($2x+y-z=8$, $-3x-y+2z=-11$, $-2x+y+2z=-3$; correct, solution (2, 3, −1)).
- **Mathews:** $x_1+2x_2+3x_3=3$, $-3x_1+x_2+5x_3=-2$, $2x_1+4x_2-x_3=-1$, solution $(2,-1,1)$ (gr_49). Using it would set up F1.

### F3. Fidelity, Minor (unverified): Mathews' Examples 4–6 dropped, leaving the inverse and interpolation sections without an example

- **Location:** lines 189–208 (inverse), 212–228 (interpolation).
- **Archive, recomputed exactly:** Ex 4: $A=\begin{bmatrix}4&8&4&0\\1&4&7&2\\1&5&4&-3\\1&3&0&-2\end{bmatrix}$, $b=(8,10,-4,-4)^T$, solution $(3,-1,1,2)$. Ex 5: $A^{-1} = \begin{bmatrix}49/48&-5/4&7/6&-3\\-23/48&3/4&-5/6&2\\3/16&-1/4&1/2&-1\\-5/24&1/2&-2/3&1\end{bmatrix}$ ($AA^{-1}=I$). Ex 6: points (1,1), (2,3), (3,0), (4,1), (5,4), (6,2), $p(x)=x^5/20-29x^4/24+31x^3/3-931x^2/24+3757x/60-32$ (residual 0 at all six).
- **Fix:** add Examples 5 and 6 under their sections; optionally Example 4.

### F4. Page text, Minor (unverified): row replacement lacks $j \ne i$, so "each operation preserves the solution set" is false as written

- **Location:** line 65, "$R_i \leftarrow R_i + cR_j$", and line 67.
- **True:** with $j = i$, $c = -1$ the row becomes zero and the solution set can grow. Mathews says "any other row".
- **Fix:** "$R_i \leftarrow R_i + cR_j$ with $j \neq i$."

### F5. Page text, Minor (unverified): the singularity test in the inverse callout is misstated

- **Location:** lines 206–207, "If a pivot column is all zeros after pivot search, $A$ is singular".
- **True:** the test is whether every candidate $a_{ik}$, $i \ge k$, is zero; entries above the pivot can be nonzero. For $S=\begin{bmatrix}1&2&3\\2&4&5\\3&6&7\end{bmatrix}$ (det 0), Algorithm II stops at step 2 with column 2 equal to $(2,0,0)^T$. Algorithm II's step 2 (line 115) states it correctly.
- **Fix:** "If at step $k$ every candidate pivot $a_{ik}$, $i\ge k$, is zero, $A$ is singular and has no inverse."

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 39 entries in the reviewer's ledger)

Confirmed: the description of GJ and GE; the nonsingularity theorem (square hypothesis present) and its link to pivot failure; interchange and scaling operations; the pivot definition; partial pivoting (matches Mathews' Algorithm II, gr_88); why pivoting helps; Algorithm I and II steps (run as written); "simple but fragile"; the RREF result; Example 1's system, augmented matrix, "with or without pivoting here" (pivots 2, 1/2, −1), RREF and solution (2, 3, −1); Example 2's matrix, det −7, failure at step 1, both swaps fixing it; the inverse method $[A\mid I]\to[I\mid A^{-1}]$; interpolation via Vandermonde; GJ costs more than GE (multiplications/divisions n = 100: 505100 vs 343300, ratio → 1.5); standard-practice remarks; summary; markup.

Not confirmed: line 65/67 (F4); line 92 and line 185's "same failure mode" (F1); lines 206–207 (F5); Examples 1 and 4–6 versus Mathews (F2, F3).

## Checks

Page Example 1, Algorithm I as written (exact): step matrices `[[1,1/2,-1/2,4],[0,1/2,1/2,1],[0,2,1,5]]`, `[[1,0,-1,3],[0,1,1,2],[0,0,-1,1]]`, `[I | (2,3,-1)]`; Algorithm II the same after swaps (1,2), (2,3); det −1. Page Example 2: Algorithm I fails at step 1; Algorithm II swaps (1,3) and gives (6/7, 9/7, 10/7). Mathews' examples: Ex 1 (2, −1, 1); Ex 2 fails at step 2; Ex 3 (2, −1, 1); Ex 4 (3, −1, 1, 2); Ex 5, Ex 6 as in F3. Operation counts: n = 3, 10, 100, 1000 give ratios 1.24, 1.30, 1.47, 1.497. Nothing undetermined.
