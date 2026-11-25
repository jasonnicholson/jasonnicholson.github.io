# Review: Householder Transformations (batch 10, text-only)

Page: `pages/numerical-methods/householder-transformations.qmd` (323 lines; text written in this batch). Module: `n2003/HouseholderMod.html` ("Householder Transformation Method"), example folder `n2003/householder/HouseholderMod/` (6 link pages). The reviewer consulted the archive (module, all 6 link pages, problem matrices gr_94, 152, 170, 201, the step subroutine gr_140, the loop program gr_196–200, printouts gr_124, 136, 145–151, 164, 169, 202–204). Exercise 4's solution images (gr_171–192) are missing, as the page says. The claim ledger covers the whole page; no wrong number was found anywhere.

**Findings: 1 Error, 0 Misleading, 2 Minor.** The Error finding was confirmed by an independent check, which graded it Minor because the Caution box covers both cases; it is reported here at the reviewer's grade, with both views.

## Findings

### F1. Page text, Error: the Corollary is missing a hypothesis it needs

*Independent check: **confirmed**, graded **Minor** by the checker ("at most low-end Misleading"). Tests: $\mathbf X = (4,0,3,4)$, $k = 1$ with $\operatorname{sign}(0) = 0$ gives $S = R = 0$ and no $\mathbf W$; with $\operatorname{sign}(0) = +1$, $S = 5$, $R = 5\sqrt2$, $\mathbf P\mathbf X = (4,-5,0,0)$. $\mathbf X = (4,0,0,0)$ gives $R = 0$ under any convention, so the zero-tail case is a real missing hypothesis, not only a convention; the box uses $\operatorname{sign}$ before the page says what $\operatorname{sign}(0)$ is. The Caution box and the implementation notes give the right conditions, and no example hits either case, so a reader working through the section is not misled.*

- **Location:** lines 46–63, the Corollary box: "Let $\mathbf{X} = (x_1,\ldots,x_n)^T$ and let $k$ be an integer with $1 \le k \le n-2$. Define $S = \operatorname{sign}(x_{k+1})\sqrt{\cdots}$, $R = \sqrt{2(x_{k+1}+S)S}$ … Then $\mathbf{P}_k$ is symmetric and orthogonal and $\mathbf{P}_k\mathbf{X} = (x_1,\ldots,x_k,-S,0,\ldots,0)^T$."
- **True:** if $x_{k+1} = 0$ and the tail is nonzero, $\operatorname{sign}$ as Mathematica defines it (line 74) gives $S = 0$, $R = 0$, and $\mathbf W_k$ is $0/0$; if $x_{k+1} = \cdots = x_n = 0$, then $\mathbf X = \mathbf Y$, violating the Theorem's own hypothesis $\mathbf X \ne \mathbf Y$, and again $R = 0$. The Corollary holds only when $(x_{k+1},\ldots,x_n) \ne \mathbf 0$ and $\operatorname{sign}(0)$ is taken as $\pm1$. The Caution box (lines 70–75) covers both cases, which mitigates it, but the boxed statement read alone is false.
- **Fix:** add to the Corollary: "Assume $(x_{k+1},\ldots,x_n) \neq \mathbf{0}$, and take $\operatorname{sign}(0) = +1$" (optionally "if the tail is zero, set $\mathbf P_k = \mathbf I$").

### F2. Page text, Minor (unverified): what $\mathbf{P}_k$ leaves unchanged is overstated

- **Location:** line 66, "…$\mathbf{P}_k$ … leaves the first $k$ rows and columns of anything it multiplies unchanged."
- **True:** $\mathbf P_k\mathbf A$ keeps the first $k$ rows, $\mathbf A\mathbf P_k$ the first $k$ columns, and $\mathbf P_k\mathbf A\mathbf P_k$ only the leading $k\times k$ block; column $k$ is exactly what $\mathbf P_k\mathbf A_{k-1}\mathbf P_k$ changes (Example 1, $k = 1$: column 1 goes from $(4,2,2,1)$ to $(4,-3,0,0)$).
- **Fix:** "…leaves the first $k$ components of any vector unchanged, so $\mathbf{P}_k\mathbf{A}$ keeps the first $k$ rows of $\mathbf{A}$, $\mathbf{A}\mathbf{P}_k$ keeps the first $k$ columns, and $\mathbf{P}_k\mathbf{A}\mathbf{P}_k$ keeps the leading $k\times k$ block."

### F3. Page text, Minor (unverified): "+1" is required only as a convention

- **Location:** line 74 ("If $x_{k+1}=0$, the sign must be taken as $+1$") and line 321.
- **True:** any nonzero sign works when $x_{k+1} = 0$: then $(x_{k+1}+S)S = S^2 = \lVert\mathbf x\rVert^2 > 0$ and there is nothing to cancel. What matters is that the sign is not 0; $+1$ is the convention (Mathews' loop test `A1[[k+1,k]] < 0`).
- **Fix:** "the sign must not be taken as $0$; take $+1$ (any $\pm1$ works, since there is nothing to cancel)."

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target; the three `qr-method/` anchors exist in the built site.

## Claim ledger (condensed; 86 entries)

Confirmed, apart from the three findings: the introduction (exactly $n-2$ steps; comparison with Jacobi; the QR page's matching example; Hessenberg form for nonsymmetric matrices; all of Mathews' examples covered); the Theorem with $\mathbf X \ne \mathbf Y$ (which Mathews omits and which is needed) and its proof; the geometry; the notation mapping to the QR page ($\alpha = -S$, $\mathbf v = R\mathbf W_k$); the Caution (sign choice, the $(1, 10^{-8})$ cancellation demo, Mathews' `Sign` and loop test, none of his examples hits the bad case); Householder's method, the $n = 5$ zero patterns, invariants and eigenvector recovery; the cheap-application theorem (6)–(7) with its symmetry hypothesis and proof, operation counts, the three-step algorithm (run as written on Examples 1, 3, 4); Examples 1–4 in full (every $S$, $R$, $\mathbf W$, $\mathbf V$, $c$, $\mathbf Q$, intermediate matrix and $\mathbf H$, exact and decimal; characteristic polynomials, sums of squares, traces, eigenvalues; agreement with Mathews' printouts to ten digits; 50-digit invariants for Example 4; double-precision noise below 1.1×10⁻¹⁵; the loop program within 5.3×10⁻¹⁵; eigenvector residual 4.4×10⁻¹⁵); implementation notes; markup.

Not confirmed: the Corollary as stated (F1); line 66's wording (F2); the "+1" requirement (F3). Could not determine: "the later entries have no short closed form" (a judgement, harmless). The noise and residual figures depend on the implementation; the page's values are reproduced by the reviewer's implementation.

## Checks

`hh.py` (sympy exact, Examples 1 and 3), `hh4.py` (mpmath 50 digits and numpy double, Example 4, the step algorithm and the loop program), `noise.py` (double-precision noise and the Caution example). Every value matches the page (tables in the reviewer's report).
