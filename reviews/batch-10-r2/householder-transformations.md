# Review round 2: Householder Transformations (batch 10, text-only)

Page: `pages/numerical-methods/householder-transformations.qmd` (323 lines after the round-1 fix). Module: `n2003/HouseholderMod.html`. The reviewer consulted the archive (module, all 6 link pages, the step subroutine gr_140, the loop program gr_196–200, the printouts gr_100–136, 141–151, 152–169, 201–204) and did not read earlier rounds' reports. The claim ledger covers the whole page.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

Fidelity: all five of Mathews' cases are present with his matrices. The page departs from the archive in three places, each to be correct: the Theorem's $\mathbf X \ne \mathbf Y$ hypothesis, the mirror-hyperplane geometry (Mathews: "reflect through the line whose direction is Z"), and $P_{n-2}$ where Mathews has the typo $P_{n-1}$.

## Inventory (mechanical checks, rerun after the fix)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 80 entries)

Confirmed, every one: the introduction and QR-page links and anchors; the Theorem and proof; the Corollary with its new hypotheses (nonzero tail, $\operatorname{sign}(0) = +1$) and the $\mathbf X \ne \mathbf Y$ argument; the corrected statement of what $\mathbf P_k$ preserves; the notation mapping; the Caution (sign choice, the $(1, 10^{-8})$ demonstration, "any ±1 works", Mathews' `Sign` and loop test, the skip rule); Householder's method and zero patterns; the cheap-application theorem, proof and counts; the algorithm (run as written in double and 50-digit arithmetic); Examples 1–4 in full (every $S$, $R$, $\mathbf W$, $\mathbf V$, $c$, $\mathbf Q$, $2\mathbf W\mathbf Q^\top$, intermediate matrix and $\mathbf H$, exact and decimal; characteristic polynomials, sums of squares, traces, eigenvalues; agreement with every printed Mathews digit; noise below 1.1×10⁻¹⁵; the loop program within 5.3×10⁻¹⁵; off-band entries below 6×10⁻⁵¹ at 50 digits; eigenvector residual 4.4×10⁻¹⁵, reproducible though implementation-dependent); implementation notes; markup.

## Checks

`ex1.py` (sympy exact), `ex3.py`/`cmp.py`/`ex4.py` (mpmath 50 digits; 144 and 75 matrix entries compared, 0 mismatches), `dbl.py` (double-precision step algorithm and a line-for-line translation of Mathews' loop program), `ev.py`. Nothing undetermined beyond the noted implementation dependence of the double-precision residuals.
