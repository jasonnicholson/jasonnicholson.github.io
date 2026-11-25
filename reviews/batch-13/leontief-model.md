# Review: Leontief Model (batch 13, text-only)

Page: `pages/numerical-methods/leontief-model.qmd` (231 lines). Module: `n2003/LeontiefModelMod.html` ("Leontief Economic Model"), example folder `n2003/leontiefmodel/LeontiefModelMod/` (5 link pages). The reviewer consulted the archive (module page, all 5 link pages, formula and output images gr_4–15, 20, 22–79, 81, 109–126, 147–164; gr_166–171, which hold the Example 4 solution, are missing).

**Calibration page.** This page was the batch's pilot. The reviewer worked on a scratch copy into which the director had planted two errors (Example 4's $x_4$ wrong in its third significant digit, and a false sentence bounding the column sums and $\rho(A)$ by 0.8). The reviewer found both. Those two planted findings are removed from this report. The planted sentence added two lines at line 195 of the copy, so ledger line numbers from 195 on are given below for the real page (copy line − 2).

**Findings: 1 Error, 0 Misleading, 1 Minor.** The Error finding was confirmed by an independent check.

## Findings

### F1. Page text, Error: the "Closed Model Feasibility" theorem leaves out the nonnegativity hypothesis

*Independent check: **confirmed** (Error). A fresh checker, given only the allegation, found that the page's only hypothesis is $a_{ij}\ge0$ and that its examples restrict to $t>0$, so "feasible" means nonnegative on the page's own terms. Decisive counterexample: $A=\begin{pmatrix}3/2&1/2\\1/2&3/2\end{pmatrix}$ ($a_{ij}\ge0$, eigenvalues 2 and 1, so $\det(I-A)=0$) has $\mathcal N(I-A)=\operatorname{span}\{(-1,1)\}$: no nonzero nonnegative null vector at all. With column sums 1, $A=\operatorname{diag}(B,B)$, $B$ all entries $1/2$, has the mixed-sign null vector $(1,1,-1,-1)$; positivity needs irreducibility. The checker's suggested wording: "A production vector must be a nonzero vector in $\mathcal N(I-A)$ with nonnegative entries. If each column of $A$ sums to 1 and $A$ is irreducible, $\mathcal N(I-A)$ is one-dimensional and spanned by a positive vector, so the feasible productions are its positive multiples $t\mathbf v$, $t>0$."*

- **Location:** line 45, "Any nonzero vector in $\mathcal{N}(I-A)$ gives a feasible production proportion."
- **Now:** every nonzero null vector is called feasible.
- **True:** production levels must be nonnegative, and a nonzero null vector need not be. In Example 1, $-(25,34,49)^T \in \mathcal{N}(I-A)$ but is not a feasible production vector; the page itself restricts to $t>0$ on lines 74 and 103. When the null space has dimension greater than 1 it can contain mixed-sign vectors even when $A\ge 0$ has column sums 1: the 4×4 block permutation `[[0,1,0,0],[1,0,0,0],[0,0,0,1],[0,0,1,0]]` has null vector $(1,1,-1,-1)$ of $I-A$.
- **How the reviewer knows:** `(I-A1)(-v) = [0, -3.6e-15, 0]` and `(I-B)(1,1,-1,-1) = [0,0,0,0]`.
- **Fix:** "Any nonzero vector in $\mathcal{N}(I-A)$ with nonnegative entries gives a feasible production proportion." Optionally add that when every column of $A\ge0$ sums to 1 (as in Examples 1 and 2), $\det(I-A)=0$ automatically and a nonnegative nonzero solution exists. The first sentence of the theorem (line 44) is correct.

### F2. Fidelity, Minor (unverified): the archive's iteration asides are dropped without mention

- **Location:** Examples 1–3 (lines 48–177).
- **Now:** each example is solved only by elimination or a direct solve.
- **Archive:** every Mathews solution page (lnk_2, lnk_3, lnk_4) also shows the module's one numerical-iteration idea: for the closed model $P_i = A P_{i-1}$, a power-method variant (Example 1 from $P_0=(36,36,36)$, Example 2 from $P_0=(989,\dots)$; both converge to the scaled eigenvector); for the open model $P_i = AP_{i-1}+B$, which Mathews says converges "slowly" (Example 3 from $P_0=(365,365,365)$, 22 steps). lnk_4 also has an "any demand vector" aside, $B=(80,60,100)$, giving $X\approx(204.348, 291.304, 456.522)$.
- **Checked:** the archive's values reproduce: Example 1's iteration reaches (25.000, 34.000, 49.000) after 8 steps; Example 3's reaches (234.990, 334.983, 524.972) after 22 steps; the exact solution for $B=(80,60,100)$ is $(4700, 6700, 10500)/23$.
- **Fix (optional):** a short note on the fixed-point iteration $\mathbf{x}_{k+1}=A\mathbf{x}_k+\mathbf{b}$, which converges because $\rho(A)<1$ ($\rho = 0.7513$ for Example 3, $0.85398$ for Example 4, $\lVert A\rVert_1 = 0.8$ and $0.9$), and on the power iteration for the closed model; or one sentence saying they are left out.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (whole page; real-page line numbers)

| # | Line | Claim (abridged) | Verdict |
|---|---|---|---|
| 1 | 12–13 | $x_i$ total production of industry $i$; $a_{ij}$ output of $i$ needed per unit of $j$; internal use linear | confirmed (Mathews gr_4–15) |
| 2 | 17 | $A=(a_{ij})$, $a_{ij}\ge0$ | confirmed |
| 3 | 18–21 | Production vector $\mathbf{x}$ | confirmed |
| 4 | 26 | Closed economy has no outside demand | confirmed |
| 5 | 28–31 | (1) $x_i=\sum_j a_{ij}x_j$ | confirmed |
| 6 | 35–40 | (2) $\mathbf{x}=A\mathbf{x} \iff (I-A)\mathbf{x}=\mathbf{0}$ | confirmed |
| 7 | 44 | Nontrivial levels exist only if $\det(I-A)=0$ | confirmed |
| 8 | 45 | Any nonzero vector in $\mathcal N(I-A)$ is feasible | wrong (F1) |
| 9 | 52–58 | Ex 1: $A$ | confirmed (gr_20) |
| 10 | 62–69 | Ex 1: $I-A$ | confirmed |
| 11 | 73–75 | Ex 1: $\mathbf{x}=t(25,34,49)^T$, $t>0$ | confirmed (nullity 1; gr_68–72) |
| 12 | 81–83 | Ex 1 verification rows | confirmed (both sides) |
| 13 | 89–98 | Ex 2: $A$ | confirmed (gr_81) |
| 14 | 100–104 | Ex 2: $\mathbf{x}=t(766,989,670,1056,1464)^T$ | confirmed (rank$(I-A)=4$; gr_118/120) |
| 15 | 110–114 | Ex 2 verification rows 1–5 | confirmed (exact) |
| 16 | 118–125 | (3) $\mathbf{x}=A\mathbf{x}+\mathbf{b}\iff(I-A)\mathbf{x}=\mathbf{b}$ | confirmed |
| 17 | 127–132 | (4) $\mathbf{x}=(I-A)^{-1}\mathbf{b}$ when $I-A$ is invertible | confirmed |
| 18 | 135 | $A$ productive when the open-model solution is nonnegative for nonnegative demand | confirmed (equivalent to Mathews' $(I-A)^{-1}\ge0$) |
| 19 | 142–150 | Ex 3: $A$, $\mathbf b=(92,69,115)$ | confirmed (gr_147/148) |
| 20 | 154–163 | Ex 3: $I-A$ | confirmed |
| 21 | 167–169 | Ex 3: $\mathbf x=(235,335,525)$ | confirmed (exact; gr_151) |
| 22 | 175–177 | Ex 3 verification rows | confirmed (both sides, exact) |
| 23 | 183–193 | Ex 4: $A$, $\mathbf b$ | confirmed (gr_163/164) |
| 24 | 198–204 | Ex 4 exact $\mathbf x$ = (186489700/1409, 273382080/1409, 162620, 333360540/1409, 304858700/1409) | confirmed (exact residual 0; $\det(I-A)=1409/10000$) |
| 25 | 207–211 | Ex 4 decimals 132356.068, 194025.607, 162620.000, 236593.712, 216365.295 | confirmed (on the real page; the copy's planted decimal was caught) |
| 26 | 217–221 | Ex 4 verification rows | confirmed as values of the exact solution; the left column only repeats $\mathbf{x}$ rather than showing $A\mathbf{x}+\mathbf{b}$ evaluated, so the table is a restatement, not a check (not raised as a finding; a fixer may wish to show the substitution) |
| 27 | 225–229 | Summary: closed and open models; validate by substitution | confirmed |
| 28 | all | Markup: `\tag` only inside `$$`, `\\[4pt]` in pmatrix, `\checkmark`/`\mathcal`/`\cdot` in table cells, callout fences balanced | confirmed; nothing broken |
| 29 | — | Fidelity: all four archive examples present with their matrices and demand vectors | confirmed; iteration asides dropped (F2) |

## Checks (sympy exact rationals from the decimal entries)

- **Example 1:** $\det(I-A)=0$, rank 2, nullity 1, column sums 1, eigenvalues 1, 0.1, −0.2; null vector (25, 34, 49), as on the page; $A(25,34,49)^T=(25,34,49)$ exactly.
- **Example 2:** $\det(I-A)=0$, rank 4, column sums 1, dominant eigenvalue 1 (others ≤ 0.133 in modulus); null vector (766, 989, 670, 1056, 1464), as on the page; every row expression evaluates exactly.
- **Example 3:** $\det(I-A)=23/100$; solution (235, 335, 525) exactly; $(I-A)^{-1}>0$ (minimum entry 12/23); $\rho(A)=0.7513$.
- **Example 4:** $\det(I-A)=1409/10000$; solution as on the page (exact and decimal); column sums (0.9, 0.8, 0.9, 0.8, 0.9); $\rho(A)=0.85398$; $(I-A)^{-1}>0$ (minimum entry 1051/1409). The Neumann series $\sum_k A^k\mathbf b$ reaches the direct solve by 200 terms.
- **Nullspace method (Examples 1, 2):** sympy `nullspace` reproduces both vectors; Mathews' reduced row echelon forms (gr_59, gr_109) give the same ratios.
- **Could not determine:** nothing on the page. The archive's Example 4 solution images are missing, so the archive's Example 4 answer could not be compared; the exact solve stands on its own.
