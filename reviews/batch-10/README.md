# Batch 10 review, round 1 (text-only)

Scope: `batch=10` of `plans/numerical-methods-animation-plan.md`, the three eigenvalue-support pages whose text was written in Phase 1 of this batch run (Householder Transformations, Hessenberg Factorization, Faddeev-Leverrier Method), reviewed in text-only mode on 2026-11-25. Because the text is new, every reviewer's claim ledger covers the whole page. All three pages were reviewed; none was skipped.

- **Archive:** found at `/home/jason/Desktop/math-fullerton/baseline/mathews/`; every reviewer consulted its topic's module, example pages and output images.
- **Environment:** `/usr/bin/python3` (numpy, scipy, sympy, mpmath). No MATLAB, no quarto.
- **Calibration:** the pilot (Faddeev-Leverrier) was reviewed on a scratch copy with two planted errors (a wrong $p_2$ in Example 2; a false sentence calling Example 1's matrix symmetric). The reviewer found both; they are removed from the report.
- **Independent check:** the one Error finding (Householder F1) was given, as an allegation only, to a fresh checker, who confirmed it but graded it Minor. Minor findings are reported unverified.

## Totals

**1 Error, 0 Misleading, 5 Minor.** No wrong number was found on any of the three pages: every worked example, intermediate matrix and printed Mathews value checked out, in exact or 50–60-digit arithmetic.

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [householder-transformations](householder-transformations.md) | — | — | 1 | 0 | 2 | reviewed |
| [hessenberg-factorization](hessenberg-factorization.md) | — | — | 0 | 0 | 1 | reviewed |
| [faddeev-leverrier-method](faddeev-leverrier-method.md) | — | — | 0 | 0 | 2 | reviewed (calibration pilot) |

The findings: the Householder Corollary omits its nonzero-tail and $\operatorname{sign}(0)$ hypotheses (stated only in the Caution box below it), and two wording points; Hessenberg overstates the digit count of Example 8's exact entries (32 for 14); Faddeev-Leverrier's floating-point table drops the imaginary parts in two cells (1.4 and 3.2 should be 3.3 and 7.0) and misdescribes Mathews' sign convention. Fidelity: Faddeev F2.

## Pattern

The pages written under the content-page Accuracy standard with a claim ledger (67–108 entries each) came through with no wrong worked-example number, against 5–7 Errors per batch on the older pages of batches 11–13. The remaining findings are in statements around the computations: a hypothesis left to a nearby caution, an approximate size claim, and one table built with a lossy comparison.
