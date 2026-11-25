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

## Closing (batch 10 run, 2026-11-25)

**Pages built:** Householder Transformations, Hessenberg Factorization and Faddeev-Leverrier Method. Each was a skeleton and is now a complete flat text-only page written with `content-page` in Phase 1, with claim ledgers of 67–108 entries. Together they cover all of Mathews' worked examples (5, 9 and 3). The Householder and Hessenberg pages link to the QR method page's Householder-then-QR animation rather than repeating it. No index change was needed.

**Findings by round:**

| Round | Error | Misleading | Minor | Report |
|---|---|---|---|---|
| 1 | 1 (the checker graded it Minor) | 0 | 5 | `reviews/batch-10` |
| 2 | 0 | 1 | 0 | `reviews/batch-10-r2` |
| 3 | 0 | 0 | 0 | `reviews/batch-10-r3` |

Every finding was reproduced and fixed, and each fix was checked by a fresh checker who saw only the findings and the diff. The round-2 finding (Faddeev-Leverrier's n = 20 attribution) was confirmed by an independent check before fixing. Its fix rewrote the paragraph from a 320-trial experiment, and the fix check's 300 trials led to five ranges being widened. Nothing is open.

**What was fixed:** the Householder Corollary's hypotheses (nonzero tail, $\operatorname{sign}(0) = +1$), with two wording points; Hessenberg Example 8's digit count; Faddeev-Leverrier's floating-point table at n = 25 and 30 (the old values ignored the imaginary parts) and its description of Mathews' sign convention; and the n = 20 attribution, which now says that both the recursion and root sensitivity matter.

**Decisions taken for Jason (revisit if wanted):**
- Householder and Hessenberg: $\operatorname{sign}(0) = +1$ is adopted, as in Mathews' loop program, rather than Mathematica's `Sign[0] = 0`. His step subroutine fails on that case, and the pages say so with a small example.
- Householder: Mathews' Exercises 4 and 5 (the same 6×6 matrix) are combined as Example 4. Exercise 4's solution images are missing, so its steps are computed and the page says so.
- Hessenberg: the page says "orthogonal" where Mathews says "unitary" for real matrices, noting his term. A short Gaussian-elimination aside (not in Mathews) is added and checked.
- Faddeev-Leverrier: the floating-point experiment (n = 5–30, and the n = 20 decomposition) is new material, not Mathews'. The table is a single random draw, so its exact digits are seed-dependent, while every review found its orders of magnitude robust.

**Commits on `batch-10`:** Write Householder Transformations / Hessenberg Factorization / Faddeev-Leverrier Method page text; Add batch 10 review; Fix Householder Transformations; Fix Hessenberg Factorization; Fix Faddeev-Leverrier Method; Add batch 10 review, round 2; Fix Faddeev-Leverrier Method (round 2); Add batch 10 review, round 3; Mark batch 10 done.
