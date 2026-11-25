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
