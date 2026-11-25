# Review: Tri-Diagonal Matrices (batch 12, text-only)

Page: `pages/numerical-methods/tri-diagonal-matrices.qmd` (241 lines). Module: `n2003/Tri-DiagonalMod.html` ("Tri-Diagonal Linear Systems"), example folder `n2003/tridiagonal/Tri-DiagonalMod/` (9 link pages). The reviewer consulted the archive (module text, the 9 link pages, images gr_1–22, gr_55, gr_84).

**Calibration page.** This page was the batch's pilot. The reviewer worked on a scratch copy into which the director had planted two errors (a wrong intermediate fraction in Example 1 and a false sentence claiming that Example 1's matrix is strictly diagonally dominant in every row, so that the theorem applies). The reviewer found both. Those two planted findings are removed from this report; the copy had no extra lines, so every line number below applies to the real page.

One observation from the planted finding is still useful for a fix: the page's uniqueness theorem (lines 85–98) uses strict inequalities in every row, which makes it true, but it then does not cover Example 1's matrix $\mathrm{tridiag}(1,2,1)$ (rows 2 and 3 have equality), nor the finite-difference and Mathews $\mathrm{tridiag}(1,2,1)$ matrices. Mathews' own version (images gr_4–gr_6) uses ≥ in every row and is false as written: $\begin{pmatrix}1&1&0\\1&2&1\\0&1&1\end{pmatrix}$ meets every condition and has determinant 0. The standard form (nonzero off-diagonals, strict inequality in the first and last rows, ≥ in the interior rows) is true; the reviewer found no singular matrix in 3000 random trials of it, and a singular counterexample when the nonzero off-diagonal hypothesis is dropped. The real page makes no false claim here, so this is not a finding, but a fix that adds Mathews' 31×31 example (F3) should state the theorem in the standard form.

**Findings: 0 Error, 0 Misleading, 3 Minor** (Minor findings unverified, as the review skill allows).

## Findings

### F1. Page text, Minor: wrong description of where $c_k$ sits

- **Location:** line 47, "| $c_k$ | $n-1$ | Super-diagonal: $c_k = a_{k,k+1}$ (element above $d_k$) |"
- **Now:** "element above $d_k$".
- **True:** $a_{k,k+1}$ is in row $k$, column $k+1$: to the right of $d_k$ and directly above $d_{k+1}$. The element directly above $d_k$ is $a_{k-1,k}=c_{k-1}$. The formula $c_k=a_{k,k+1}$ in the same cell is correct, and so are matrix (2) and system (3). The matching phrase for $a_k$ on line 46 ("element below $d_k$") is correct.
- **How the reviewer knows:** from the index definition and from matrix (2), line 54, where $c_1$ is at (1,2) and lies above $d_2$.
- **Fix:** "(element to the right of $d_k$, directly above $d_{k+1}$)".

### F2. Page text (markup), Minor: the last row of matrix (1) is one cell short

- **Location:** line 32, `0       & \cdots  & 0       & a_{n,n-1} & a_{n,n}`
- **Now:** rows on lines 28–31 have 6 cells, line 32 has 5 (awk count 6, 6, 6, 6, 5). KaTeX renders $a_{n,n}$ in column 5 and leaves the last column blank in the bottom row, so the diagonal entry appears off the diagonal, in a matrix that exists to show the diagonal structure. Matrix (2) on lines 54–59 is correct.
- **Fix:** `0 & \cdots & 0 & 0 & a_{n,n-1} & a_{n,n}`.

### F3. Fidelity, Minor: Mathews' worked examples dropped and replaced without explanation

- **Location:** lines 137–226 (Example 1 is a 4×4 system) and lines 78–79 (the storage callout cites $n=31$).
- **Now:** the page's only example is a 4×4 system, $b=(1,0,0,1)$. Mathews' four examples all use one system: a 31×31 $\mathrm{tridiag}(1,2,1)$ with $B=(1,2,\ldots,15,16,15,\ldots,2,1)^T$ (image gr_13), solved by full LinearSolve, by his TriDiagonal subroutine, by TridiagonalSolve and by $A^{-1}B$, in decimal and rational arithmetic, ending with the question of why one would not use $A^{-1}B$. The page drops all of this without saying why, and its "$n=31$" in the storage callout no longer refers to anything on the page.
- **True:** recomputed exactly with the page's algorithm, the archive example has $x=(0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0,7,0,6,0,5,0,4,0,3,0,2,0,1,0)^T$, residual exactly 0, $\det A=32$, matching Mathews' rational output (image gr_84). The 4×4 hand example is a reasonable teaching choice and its numbers are right.
- **Fix:** keep the 4×4 example; add a short Example 2 stating Mathews' 31×31 system and its exact integer solution, solved with the same algorithm, and tie the $n=31$ storage figures to it. Optionally one sentence on why $A^{-1}B$ is wasteful for tridiagonal $A$ (the inverse is dense).

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (whole page)

| # | Line | Claim | Verdict |
|---|---|---|---|
| 1 | 12–13 | Tridiagonal/banded systems arise in cubic splines, finite-difference BVPs, parabolic PDE solvers | confirmed |
| 2 | 14–15 | A sparse matrix has a large majority of zero entries | confirmed |
| 3 | 15–16 | Exploiting structure beats general GE in time and storage | confirmed (O(n) vs O(n³); 3n−2 vs n²) |
| 4 | 22–23 | Tridiagonal iff $a_{ij}=0$ whenever $\lvert i-j\rvert>1$ | confirmed |
| 5 | 25–35 | Matrix form (1) | content confirmed; markup wrong (F2) |
| 6 | 40 | Full storage wastes $n^2-3n+2$ zeros | confirmed (n = 31: 870, as Mathews) |
| 7 | 45 | $d_k=a_{k,k}$, length $n$ | confirmed |
| 8 | 46 | $a_k=a_{k+1,k}$, length $n-1$, "element below $d_k$" | confirmed |
| 9 | 47 | $c_k=a_{k,k+1}$, length $n-1$ | confirmed |
| 10 | 47 | "(element above $d_k$)" | wrong (F1) |
| 11 | 51–62 | Matrix (2) | confirmed |
| 12 | 66–73 | Row equations (3) | confirmed |
| 13 | 78 | Storage $3n-2$ vs $n^2$ | confirmed |
| 14 | 79 | $n=31$: 91 vs 961, about 9.5% | confirmed (9.469%). Mathews says 12.3%, which the reviewer could not reproduce from any count |
| 15 | 80–81 | $n=1000$: savings reach 99.7% | confirmed (99.7002%) |
| 16 | 85–97 | Theorem: strict inequalities in every row imply a unique solution | confirmed as a true theorem (see the note above) |
| 17 | 97 | "(The condition is diagonal dominance.)" | confirmed (strict row dominance) |
| 18 | 102–104 | Thomas algorithm = TDMA = LU specialised to tridiagonal, two passes | confirmed |
| 19 | 108–112 | $w_k=a_{k-1}/d_{k-1}$, $k=2..n$ | confirmed (run as written) |
| 20 | 117–121 | $d_k\leftarrow d_k-w_kc_{k-1}$, $b_k\leftarrow b_k-w_kb_{k-1}$ | confirmed (run as written; matches Mathews' subroutine, gr_55) |
| 21 | 124 | Result is upper-bidiagonal | confirmed |
| 22 | 126–132 | $x_n=b_n/d_n$, $x_k=(b_k-c_kx_{k+1})/d_k$ | confirmed (run as written) |
| 23 | 134 | $O(n)$ vs $O(n^3)$ | confirmed |
| 24 | 135 | No pivoting needed when diagonal dominance holds | confirmed |
| 25 | 137 | "Symmetric 4×4" | confirmed |
| 26 | 141–152 | Problem: $A=\mathrm{tridiag}(1,2,1)$, $b=(1,0,0,1)$ | confirmed |
| 27 | 154–155 | $d=(2,2,2,2)$, $a=c=(1,1,1)$, $b=(1,0,0,1)$ | confirmed |
| 28 | 161–165 | $k=2$: $w_2=1/2$, $d_2=3/2$, $b_2=-1/2$ | confirmed |
| 29 | 170–174 | $k=3$: $w_3=2/3$, $d_3=4/3$, $b_3=1/3$ | confirmed |
| 30 | 179–183 | $k=4$: $w_4=3/4$, $d_4=5/4$, $b_4=3/4$ | confirmed |
| 31 | 187–188 | $d'$, $b'$ after the sweep | confirmed |
| 32 | 193 | $x_4=3/5$ | confirmed |
| 33 | 197–198 | $x_3$: numerator $-4/15$, $x_3=-1/5$ | confirmed (on the real page; the copy's planted fraction was caught) |
| 34 | 202–203 | $x_2$: numerator $-3/10$, $x_2=-1/5$ | confirmed |
| 35 | 207–208 | $x_1$: numerator $6/5$, $x_1=3/5$ | confirmed |
| 36 | 214 | $x=(3/5,-1/5,-1/5,3/5)$ | confirmed (Thomas and sympy LUsolve agree) |
| 37 | 223–226 | Verification rows 1–4 | confirmed (both sides) |
| 38 | 232–233 | Cubic splines give a tridiagonal system | confirmed |
| 39 | 234–235 | $u''=f$ on a uniform grid gives a tridiagonal system of dimension = interior points | confirmed (Dirichlet BCs implicit) |
| 40 | 236–237 | Crank–Nicolson for the 1-D heat equation gives a tridiagonal system every step | confirmed |
| 41 | 239–240 | $n$ can be hundreds to thousands, so O(n) matters | confirmed (qualitative) |
| 42 | — | Fidelity: Mathews' examples carried over | not carried over (F3) |

## Checks

- **Example 1, recomputed from the problem statement** (sympy Rationals, the page's equations (4)–(6) run as written): every $w_k$, $d_k$, $b_k$, numerator and $x_k$ agrees with the page; the solution (3/5, −1/5, −1/5, 3/5) agrees with an independent `A.LUsolve`; $Ax=(1,0,0,1)$; $\det A=5$.
- **Algorithm run as written** on the 4×4 example and on Mathews' 31×31 system: exact residual 0 in both, so there is no index or sign slip.
- **Storage numbers:** n = 31: 91 stored of 961, 870 zeros, 9.469% stored; n = 1000: 2998 stored, 99.7002% saved.
- **Theorems:** see the note at the top.
- **Could not determine:** Mathews' decimal-arithmetic outputs (Mathematica round-off near the 14th decimal) were not reproduced; they are not quoted on the page.
