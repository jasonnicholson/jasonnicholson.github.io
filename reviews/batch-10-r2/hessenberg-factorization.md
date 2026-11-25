# Review round 2: Hessenberg Factorization (batch 10, text-only)

Page: `pages/numerical-methods/hessenberg-factorization.qmd` (after the round-1 fix). Module: `n2003/HessenbergMod.html`. The reviewer consulted the archive (module, all 10 link pages, programs gr_32 and gr_36, the problem matrices, and the surviving printouts for Examples 2, 4, 6, 7, 9) and did not read earlier rounds' reports. The claim ledger covers the whole page.

**Calibration page.** This was the round's pilot, reviewed on a scratch copy with two planted errors (Example 9's step-2 $\alpha$ wrong in its third significant digit; a false sentence that the QR iteration on Example 5's real $\mathbf H$ converges to a triangular matrix with the complex pair on its diagonal). The reviewer found both; they are removed. The planted sentence added two lines near line 275 of the copy.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

## Inventory (mechanical checks, rerun after the fix)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 120 entries)

Confirmed, every one apart from the two planted claims: definitions, both theorems, the symmetric case, similarity and eigenvector relation (2); the algorithm (run as written on all seven distinct matrices and the $x_1 = 0$ matrix) and its properties; the description of Mathews' programs; the $\operatorname{Sign}[0]$ failure and remedy; the complex case; the Gaussian-elimination aside; costs; agreement with LAPACK (within 8.9×10⁻¹⁵, same signs) and with every printed Mathews digit; Examples 1–9 in full (every $\alpha$, $\mathbf x$, $\mathbf v$, intermediate matrix, exact and decimal $\mathbf H$, $\mathbf Q$, characteristic polynomial, irreducibility, eigenvalues, eigenvectors and dot products, 60-digit residuals, splitting, $p(-3) = -11$); the corrected Example 8 size statement (largest radicand 14 digits, largest denominator 16 digits); the summary and links; markup.

## Checks

`hh.py` (the page's algorithm in exact sympy), `ex*.py`, `qr5.py` (unshifted QR on Example 5's $\mathbf H$, used to refute the planted sentence); `scipy.linalg.hessenberg` cross-check. Nothing undetermined.
