# Batch 13 review, round 1 (text-only)

Scope: `batch=13` of `plans/numerical-methods-animation-plan.md`, the four applications and polynomial pages, reviewed in text-only mode on 2026-11-25. All four pages were reviewed; none was skipped.

- **Archive:** found at `/home/jason/Desktop/math-fullerton/baseline/mathews/`; every reviewer consulted its topic's module and example pages.
- **Environment:** `/usr/bin/python3` (numpy, scipy, sympy, mpmath). No MATLAB, no quarto.
- **Calibration:** the pilot (Leontief Model) was reviewed on a scratch copy with two planted errors (a result wrong in its third significant digit; a false column-sum and spectral-radius sentence). The reviewer found both; they are removed from the report. The other three reviewers got the same brief.
- **Independent check:** every Error and Misleading finding was given, as an allegation only, to a fresh checker. All were **confirmed**; none refuted or unresolved. Minor findings are reported unverified.

## Totals

**4 Error, 2 Misleading, 9 Minor.**

Most serious:
1. **Horner's Method:** the derivative is said to equal $b_1$ (it is $d_0 = q(c)$), with a false justification, and the worked example implies $p'(2) = 1$ (it is 27) without ever stating the value.
2. **Conic Fit:** the classification rule omits nondegeneracy (counterexamples for Δ < 0 and Δ = 0), and legacy Example 11, a pair of intersecting lines (Mathews says so), is labelled "Hyperbola".
3. **Leontief Model:** the closed-model theorem calls any nonzero null vector feasible; feasibility needs nonnegativity (a nonnegative $A$ with $\det(I-A)=0$ can have no nonnegative null vector at all).
4. **Kirchoff's Law:** system (5)'s signs follow loop orientations the page never states, so a reader would take them for typos.

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [kirchoffs-law](kirchoffs-law.md) | — | — | 0 | 1 | 4 | reviewed |
| [leontief-model](leontief-model.md) | — | — | 1 | 0 | 1 | reviewed (calibration pilot) |
| [horners-method](horners-method.md) | — | — | 2 | 0 | 2 | reviewed |
| [conic-fit](conic-fit.md) | — | — | 1 | 1 | 2 | reviewed |

Fidelity findings: Kirchoff F1 (Misleading), F4; Leontief F2; Horner F4; Conic F2 (Misleading), F4.

## Patterns

- **Theorems stated without a hypothesis they need** (Leontief nonnegativity, Conic nondegeneracy).
- **Derivations asserted, not computed:** Horner's derivative identity would have failed on the page's own example; the example was never finished.
- **Archive examples dropped,** including the one negative loop current (Kirchoff) and the derivative example (Horner) whose absence let the Horner error stand.

## Closing (batch 13 run, 2026-11-25)

**Pages:** Kirchhoff's Law (file name `kirchoffs-law.qmd`), Leontief Model, Horner's Method, Conic Fit (all flat text-only pages; none were skeletons).

**Findings by round:**

| Round | Error | Misleading | Minor | Report |
|---|---|---|---|---|
| 1 | 4 | 2 | 9 | `reviews/batch-13` |
| 2 | 0 | 0 | 2 | `reviews/batch-13-r2` |

Every round-1 Error and Misleading finding was confirmed by an independent check. Every finding of both rounds was fixed, and each fix was checked by a fresh checker who did not see the fixer's reasoning. The Conic Fit round-2 fix check raised one wording point ("five distinct points"), which was fixed. Nothing is open.

**What was fixed (main items):** Horner's false derivative identity $p'(c) = b_1$ and an unfinished derivative example ($p'(2) = 27$); Conic Fit's classification rule, which lacked a nondegeneracy hypothesis, and its legacy Example 11, now correctly a pair of intersecting lines, plus a non-circular uniqueness theorem; Leontief's feasibility theorem, which lacked nonnegativity, plus Mathews' iteration methods; Kirchhoff's unexplained signs in system (5), now explained through loop orientations and a sign rule, plus Mathews' negative-current example.

**Decisions taken for Jason (revisit if wanted):**
- Kirchhoff's Law: the name is now spelled "Kirchhoff" in the title, the body and the section index's link text. The file name and URL (`kirchoffs-law`) are unchanged.
- Kirchhoff's Law: Mathews' Example 6 is added. His Examples 2 and 4, which re-solve networks 1 and 2 with other values, are left out with a sentence.
- Horner's Method: Mathews' quintic and its values $P(3) = 17$, $P'(3) = 25$ are stated in one sentence. His Newton–Horner, comparison, higher-derivative and deflation examples are left out, and the page says so.
- Leontief Model: a "Solving by Iteration" section is added. Mathews' Example 2 power iteration and his alternative demand vector aside are not mentioned.
- Conic Fit: legacy Examples 2 and 3 (vertical and horizontal lines) are added as a subsection.

**Commits on `batch-13`:** Add batch 13 review; Fix Horner's Method; Fix Conic Fit; Fix Kirchhoff's Law (with the index link text); Fix Leontief Model; Add batch 13 review, round 2; Fix Conic Fit (round 2); Mark batch 13 done.
