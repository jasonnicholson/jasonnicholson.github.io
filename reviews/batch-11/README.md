# Batch 11 review, round 1 (text-only)

Scope: `batch=11` of `plans/numerical-methods-animation-plan.md`, the five elimination and factorization pages, reviewed in text-only mode on 2026-11-25. All five pages were reviewed; none was skipped.

- **Archive:** found at `/home/jason/Desktop/math-fullerton/baseline/mathews/`; every reviewer consulted its topic's module and example pages.
- **Environment:** `/usr/bin/python3` (numpy, scipy, sympy, mpmath). No Julia was needed. No MATLAB, no quarto.
- **Calibration:** the pilot (LU Factorization) was reviewed on a scratch copy with two planted errors (a decimal wrong in its third significant digit; a false behaviour sentence). The reviewer found both; they are removed from the report. The other four reviewers got the same brief.
- **Independent check:** every Error and Misleading finding was given, as an allegation only, to a fresh checker. All were **confirmed**; none refuted or unresolved. Minor findings are reported unverified.

## Totals

**6 Error, 5 Misleading, 14 Minor** (one Error is the inventory finding of broken markup on the Cholesky page).

Most serious:
1. **Triangular Systems:** Example 1(b)'s $x_1$ is wrong (1181/252 for 1027/252, decimal 4.687 for 4.075); Example 1(a) Step 4 has a sign slip; the reason given for the Newton system being lower-triangular is false.
2. **Pivoting Methods:** scaled partial pivoting is said to choose row 4 when the ratios pick row 3; the Hilbert error "bound" is a rule-of-thumb estimate with mixed norms; the page says pivoting strategy matters for ill-conditioning, and that the module's Hilbert test is n = 5 (there are six, n = 5–10, with a different winning strategy each time).
3. **Cholesky, Doolittle and Crout:** nine lines lost `\t` of `\tag`/`\tfrac` (not six as the plan said; lines 76–78 too), and the "$A = D - L - U$ splitting" sentence is false and unrelated to the factorizations.
4. **LU Factorization** and **Gauss-Jordan:** each turns Mathews' pivoting lesson into a no-pivoting one (LU's PA = LU example uses P = I where partial pivoting swaps rows; Gauss-Jordan's failing example is a zero original (1,1) entry, not Mathews' zero pivot arising mid-elimination from a nonzero diagonal).

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [triangular-systems-and-back-substitution](triangular-systems-and-back-substitution.md) | — | — | 3 | 0 | 2 | reviewed |
| [gauss-jordan-elimination-and-pivoting](gauss-jordan-elimination-and-pivoting.md) | — | — | 0 | 1 | 4 | reviewed |
| [lu-factorization](lu-factorization.md) | — | — | 0 | 1 | 3 | reviewed (calibration pilot) |
| [cholesky-doolittle-and-crout-factorizations](cholesky-doolittle-and-crout-factorizations.md) | — | — | 2 | 0 | 4 | reviewed (1 Error is inventory) |
| [pivoting-methods](pivoting-methods.md) | — | — | 1 | 3 | 1 | reviewed |

Fidelity findings (for Jason to decide as a group): LU F1 (Misleading), F3; Gauss-Jordan F1 (Misleading), F2, F3; Triangular F4; Cholesky F4, F5; Pivoting F4 (Misleading).

## Patterns

- **Archive examples dropped without a word** on every page (Mathews' 4×4 LU cases, Gauss-Jordan Examples 4–6, Cholesky 2(b)–4, Pivoting's other Hilbert sizes). Where the dropped example is the one that teaches the module's point, the omission became Misleading.
- **Correct results with a wrong reason or a wrong label** (the Newton triangularity reason, the D − L − U sentence, the scaled-pivoting row).
- **Error estimates presented as theorems,** with the condition number's norm unstated and mixed with a 2-norm. The same pattern appears on Iterative Refinement (batch 12).

## Closing (batch 11 run, 2026-11-25)

**Pages:** Triangular Systems and Back Substitution, Gauss-Jordan Elimination and Pivoting, LU Factorization, Cholesky Doolittle and Crout Factorizations, Pivoting Methods. All stay flat text-only pages; none needed text written (no skeletons).

**Findings by round:**

| Round | Error | Misleading | Minor | Report |
|---|---|---|---|---|
| 1 | 6 (1 inventory: the nine lost `\t`s on Cholesky) | 5 | 14 | `reviews/batch-11` |
| 2 | 0 | 0 | 2 | `reviews/batch-11-r2` |

Every round-1 Error and Misleading finding was confirmed by an independent check before fixing. Every finding of both rounds was fixed. Each fix was checked by a fresh checker who saw the findings and the diff but not the fixer's reasoning; all were resolved. Fix-checks raised three new Minor points, which were fixed before committing and covered by round 2: Cholesky's verification lead-in, Gauss-Jordan's tie-breaking rule, and Pivoting's rerun winners, which depend on the order of floating-point operations. Nothing is open.

**What was fixed (main items):** Back Substitution's wrong $x_1$ in Example 1(b), a sign slip and a false triangularity reason; Pivoting's scaled-pivoting row, its error "bound" (now a labelled rule-of-thumb estimate with consistent norms), the false claim that pivoting cures ill-conditioning, and the Hilbert tests n = 6–10; Cholesky's broken markup and false $D - L - U$ sentence, plus entry recurrences, the SPD theorem and Examples 2(b)–(c); LU's Example 3, redone with real partial pivoting; Gauss-Jordan's account of Mathews' failure case (a zero pivot arising mid-elimination), plus his inverse and interpolation examples.

**Decisions taken for Jason (revisit if wanted):**
- Back Substitution: Example 1 now uses Mathews' matrix (row 2 = (0, −2, 7, −4)), not the page's original. Round 1 had kept the page's matrix with a disclosure; round 2 asked for the original.
- LU: Mathews' 4×4 Examples 2 and 5 are left out with a sentence.
- Gauss-Jordan: the page's own Example 2 is kept, with its solution now stated, and Mathews' failure case added as Worked Example 3. Worked Example 5 (the quintic) does not show its six 6×7 intermediate matrices, and says so.
- Pivoting: Mathews' second 5×5 system is left out with a sentence. The n = 6–10 Hilbert results are a prose paragraph quoting his winners beside a double-precision rerun.
- Cholesky: Examples 3 and 4 (least squares) are left out with a sentence. The Cholesky factor is written only as $R^\top R$.

**Commits on `batch-11`:** Add batch 11 review; Fix Triangular Systems and Back Substitution; Fix LU Factorization; Fix Cholesky, Doolittle and Crout Factorizations; Fix Gauss-Jordan Elimination and Pivoting; Fix Pivoting Methods; Add batch 11 review, round 2; Fix Cholesky (round 2); Fix Triangular Systems (round 2); Mark batch 11 done.

**Note for the skills:** `review-animations` tells the director to check for control characters with `grep -nP '[\x07-\x0d]'`. On this machine `grep` is ugrep 7.8.4, where that class also matches the newline and so flags every line. The manifests for this run used `[\x07-\x09\x0b-\x0d]`, which is correct. The skill's command should be changed the same way.
