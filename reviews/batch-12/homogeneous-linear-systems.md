# Review: Homogeneous Linear Systems (batch 12, text-only)

Page: `pages/numerical-methods/homogeneous-linear-systems.qmd` (318 lines). Module: `n2003/HomogenLinSystemMod.html` ("Homogeneous Linear Systems"), example folder `n2003/homogensystem/HomogenLinSystemMod/` (6 link pages). The reviewer consulted the archive (module text, all six link pages, problem images gr_28, gr_87, gr_200, gr_202, gr_204, gr_276, gr_372).

**Findings: 0 Error, 1 Misleading, 1 Minor.** The Misleading finding was confirmed by an independent check.

## Findings

### F1. Page text, Misleading: the Summary's "full rank" rule is false for non-square systems, including the page's own propane example

*Independent check: **confirmed** (Misleading). A fresh checker, given only the allegation, found the page's theorem is for $n\times n$ only, the Summary widens it ("or determinant in square cases"), and in the usual sense (rank = min(m, n)) the 3×4 propane matrix is full rank with null space spanned by $(1/4,5/4,3/4,1)$; line 317 ("Rank deficiency creates free variables") also fails for it, since it is not rank-deficient yet $x_4$ is free. Not an Error only because "full rank" can be read generously as rank = number of unknowns. Suggested fix: "$\operatorname{rank}(A)=n$ gives only the trivial solution; $\operatorname{rank}(A)<n$ gives $n-\operatorname{rank}(A)$ free variables", and note that fewer equations than unknowns always gives nontrivial solutions.*

- **Location:** lines 314–316: "Homogeneous systems are classified by rank (or determinant in square cases): 1. Full rank gives only the trivial solution."
- **Now:** a general rule, "full rank ⇒ only the trivial solution". The only theorem on the page (lines 51–66) is stated for $A\in\mathbb{R}^{n\times n}$; the Summary drops that restriction, and "(or determinant in square cases)" suggests the rank rule also covers non-square systems.
- **True:** only the trivial solution exists exactly when $\operatorname{rank}(A)$ equals the number of unknowns $n$ (full column rank). A wide matrix can have full rank and still have nontrivial solutions: the page's own propane matrix is 3×4 with rank 3 = min(3,4), yet its solution set is the one-parameter family $t(1/4,5/4,3/4,1)$.
- **How the reviewer knows:** sympy on `[[3,0,-1,0],[8,0,0,-2],[0,2,-2,-1]]`: rank 3, nullspace `[[1/4, 5/4, 3/4, 1]]`.
- **Fix:** "1. Rank equal to the number of unknowns ($\operatorname{rank}(A)=n$) gives only the trivial solution." Item 2 could read "Rank less than the number of unknowns creates free variables…".

### F2. Fidelity, Minor (unverified): Mathews' Example 4 (5×5, rank 3, two free variables) is dropped without comment

- **Location:** the page as a whole: Examples 1–3 plus the propane application correspond to Mathews' Examples 1, 2, 3 and 5.
- **Archive:** Example 4 (image gr_276; solution in `Links/HomogenLinSystemMod_lnk_5.html`) solves a 5×5 system ($x_1+2x_2+3x_3+4x_4+3x_5=0$, $3x_1+6x_2+18x_3+9x_4+9x_5=0$, …). The reviewer's computation: RREF rows (1,2,0,0,3), (0,0,1,0,0), (0,0,0,1,0), rank 3, det 0; free variables $x_2, x_5$; nullspace basis $(-2,1,0,0,0)$, $(-3,0,0,0,1)$. It is the archive's one case where a free variable sits between pivot columns.
- **Fix:** add it as an Example 4 with these values, or a one-line note that it is omitted.

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (whole page)

| # | Line | Claim | Verdict |
|---|---|---|---|
| 1 | 12–17 | Homogeneous system has form $A\mathbf{x}=\mathbf{0}$ | confirmed |
| 2 | 19 | $\mathbf{x}=\mathbf{0}$ always solves (1) | confirmed |
| 3 | 23–28 | RREF definition (four conditions) | confirmed (matches Mathews (i)–(iv)) |
| 4 | 33 | rank = number of nonzero rows of the RREF | confirmed |
| 5 | 36–40 | Augmented matrix $M=[A\mid\mathbf{0}]$ | confirmed |
| 6 | 43–47 | $\operatorname{rank}(A)=\operatorname{rank}(M)$ | confirmed (all 4 systems; true in general) |
| 7 | 51–59 | n×n: $\operatorname{rank}(A)=n \iff$ only $\mathbf{x}=\mathbf{0}$ | confirmed |
| 8 | 61–65 | n×n: $\operatorname{rank}(A)<n \iff$ infinitely many nontrivial solutions | confirmed (over ℝ) |
| 9 | 69–75 | Square: $\det A\ne0$ ⇒ trivial only; $\det A=0$ ⇒ infinitely many | confirmed |
| 10 | 80–84 | Algorithm: form $[A\mid0]$, RREF, pivot/free variables, parametric form, verify | confirmed (run as written on all 4 systems) |
| 11 | 90–96 | Ex 1 system | confirmed (gr_28) |
| 12 | 100–106 | Ex 1 matrix | confirmed |
| 13 | 108 | $\operatorname{RREF}(A)=I_3$ | confirmed |
| 14 | 113–116 | $x_1=x_2=x_3=0$ | confirmed |
| 15 | 123–125 | Verification rows | confirmed |
| 16 | 127 | $\det(A)=-1\ne0$ | confirmed |
| 17 | 129 | Ex 2 "One Free Variable" | confirmed (rank 2) |
| 18 | 133–139 | Ex 2 system | confirmed (gr_87) |
| 19 | 143–150 | RREF [[1,0,8],[0,1,−10],[0,0,0]] | confirmed |
| 20 | 154–168 | $x_1=-8t$, $x_2=10t$, $x_3=t$ | confirmed |
| 21 | 172–178 | $\mathbf{x}(t)=t(-8,10,1)^T$ | confirmed (sympy nullspace) |
| 22 | 184–186 | Verification rows | confirmed (both sides) |
| 23 | 188 | Ex 3 "Two Free Variables" | confirmed (rank 1) |
| 24 | 192–198 | Ex 3: three identical equations $4x_1+3x_2+2x_3=0$ | confirmed (gr_204; gr_200 is cropped to 2 rows) |
| 25 | 202–208 | RREF [[1,3/4,1/2],0,0] | confirmed |
| 26 | 214–225 | $x_1=-\tfrac34s-\tfrac12t$ | confirmed |
| 27 | 229–234 | $s(-3/4,1,0)+t(-1/2,0,1)$ | confirmed (sympy nullspace identical) |
| 28 | 240–242 | Verification rows | confirmed |
| 29 | 245 | rank < n ⇒ free variables; solution set a subspace through the origin | confirmed |
| 30 | 252–256 | Propane reaction | confirmed |
| 31 | 260–266 | Atom balances C, H, O | confirmed (gr_372) |
| 32 | 270–276 | $x_1=\tfrac14x_4$, $x_2=\tfrac54x_4$, $x_3=\tfrac34x_4$ | confirmed |
| 33 | 280–288 | $\mathbf{x}(t)=(t/4,5t/4,3t/4,t)$ | confirmed |
| 34 | 290–294 | $t=4$ gives the smallest positive integers (1,5,3,4) | confirmed |
| 35 | 298–302 | $\mathrm{C_3H_8}+5\mathrm{O_2}\to3\mathrm{CO_2}+4\mathrm{H_2O}$ | confirmed |
| 36 | 308–310 | Atom-count verification | confirmed |
| 37 | 314 | Classified by rank (or determinant in square cases) | confirmed as stated |
| 38 | 316 | "Full rank gives only the trivial solution" | wrong for non-square $A$ (F1) |
| 39 | 317 | Rank deficiency creates free variables and infinitely many solutions | confirmed (rank < number of unknowns) |
| 40 | 318 | RREF exposes the null-space basis; useful in chemical balancing | confirmed |
| 41 | — | Coverage of Mathews' Examples 1–5 | Example 4 dropped (F2) |

## Checks

All sympy exact arithmetic from the problem statements: Ex 1 RREF $I_3$, det −1, nullspace empty; Ex 2 RREF as on the page, rank 2, nullspace (−8,10,1); Ex 3 rank 1, nullspace (−3/4,1,0), (−1/2,0,1); propane RREF [[1,0,0,−1/4],[0,1,0,−5/4],[0,0,1,−3/4]], (1,5,3,4) at t = 4, atom counts 3/3, 8/8, 10/10. The page's five-step algorithm, run literally, reproduces all four solutions. Markup: every `\tag` inside `$$`, all macros valid KaTeX, tables and callouts well formed. No MATLAB output in this module; nothing left undetermined.
