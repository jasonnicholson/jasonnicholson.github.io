# Review: Hessenberg Factorization (batch 10, text-only)

Page: `pages/numerical-methods/hessenberg-factorization.qmd` (443 lines; text written in this batch). Module: `n2003/HessenbergMod.html` ("Hessenberg Matrix and Factorization"), example folder `n2003/hessenberg/HessenbergMod/` (10 link pages). The reviewer consulted the archive (module, all 10 link pages, the nine problem matrices gr_39, 49, 55, 79, 91, 103, 130, 142, 154, both programs gr_32 and gr_36, gr_5, and every surviving output image for Examples 2, 4, 6, 7, 9). The claim ledger covers the whole page.

**Findings: 0 Error, 0 Misleading, 1 Minor** (unverified, as the review skill allows for Minor findings).

## Findings

### F1. Page text, Minor: Example 8 overstates the size of the exact entries

- **Location:** line 376, "The exact entries are rational multiples of square roots of integers with up to 32 digits and are not shown."
- **True:** the exact $\mathbf H$ (sympy), with each entry in canonical form $(p/q)\sqrt r$, $r$ squarefree (checked by `factorint`), has radicands 3, 542, 1626, 17617818971, 52853456913, 9548857882282, 28646573646846: at most 14 digits. The largest integer anywhere in $\mathbf H$ has 16 digits (e.g. the denominator 1193607235285250 in $h_{34}$).
- **Fix:** "… square roots of integers with up to 14 digits (numerators and denominators up to 16 digits) …", or "The exact entries are long surds and are not shown."

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target; the `qr-method/` anchors used exist.

## Claim ledger (condensed; 128 entries)

Confirmed (one could not be determined; see below): the definitions and theorems (real and complex factorization, the symmetric case, similarity and $\mathbf w = \mathbf Q^\top\mathbf v$); the Householder algorithm in the QR page's notation (run as written on all nine examples), the description of Mathews' programs *Hessenberg1* and *Hessenberg* (gr_32, gr_36), the $x_1 = 0$ counterexample and the $\operatorname{sign}(0) = +1$ remedy, the complex version, the Gaussian-elimination aside (checked on Example 1), cost; Examples 1–9: every $\alpha$, $\mathbf v$, intermediate matrix, exact and decimal $\mathbf H$, $\mathbf Q$, characteristic polynomial (identical for $\mathbf A$ and $\mathbf H$, exactly), irreducibility, eigenvalues, the Example 3 eigenvectors and their dot products, Example 5's eigenvector, Example 6's splitting, Example 8's $p(-3) = -11$; agreement with every printed digit of Mathews' surviving outputs (Examples 2, 4, 6, 7, 9) and with LAPACK (`scipy.linalg.hessenberg`, within 8.9×10⁻¹⁵); the correction of Mathews' "some eigenvalues are complex" for Examples 4 and 6; links and anchors; markup.

Not confirmed: line 376 (F1). Could not determine: that Mathews computed Example 3 with his own programs (its output images are missing; the text names only Eigenvalues); and which eigenvalue he used in his Example 3 eigenvector comparison (the page uses $\lambda_1$, valid either way).

## Checks

`hess.py` (sympy exact) and `mp.py` (60-digit mpmath) run the page's steps literally on all seven distinct matrices; every printed value matches (details in the reviewer's report); `lap.py` compares with LAPACK. Fidelity: all nine of Mathews' problem matrices match the archive images; his per-example eigenvector asides for Examples 4–9 are not reproduced, which the reviewer did not count as a finding (the examples are present and Example 3 covers eigenvectors).
