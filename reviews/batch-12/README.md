# Batch 12 review, round 1 (text-only)

Scope: `batch=12` of `plans/numerical-methods-animation-plan.md`, the five structure-of-linear-systems pages, reviewed in text-only mode on 2026-11-25. All five pages were reviewed; none was skipped.

- **Archive:** found at `/home/jason/Desktop/math-fullerton/baseline/mathews/`; every reviewer consulted its topic's module and example pages.
- **Environment:** `/usr/bin/python3` (numpy, scipy, sympy, mpmath). No MATLAB, no quarto.
- **Calibration:** the pilot (Tri-Diagonal Matrices) was reviewed on a scratch copy with two planted errors (a wrong intermediate fraction; a false strict-dominance sentence). The reviewer found both; they are removed from the report. The other four reviewers got the same brief.
- **Independent check:** every Error and Misleading finding was given, as an allegation only, to a fresh checker. All were **confirmed**; none refuted or unresolved. On Inverse Matrix the checker graded the Taylor sentence of F1 Misleading (the polynomial itself Error); on Iterative Refinement it graded F2 Misleading (borderline Error), kept at Error here because the page states the inequality generally and the checker found it false in general. Minor findings are reported unverified.

## Totals

**7 Error, 5 Misleading, 10 Minor.**

Most serious:
1. **Inverse Matrix:** the least-squares polynomial for $\cos x$ is wrong (it is the Taylor polynomial's coefficients, with two terms dropped; 46 times the true error); $c_1 = \cos 0$ is claimed exactly; double precision is said to fail for $H_5$ (it loses ~6 digits, coefficient errors ~10⁻¹²) and the exact inverse is said to give exact rational coefficients.
2. **Iterative Refinement:** six numbers of Example 2 are mis-copied from Mathews' output, so $x^{(1)}$ no longer has the reported residual; the error inequality is presented as a theorem with mixed norms; the page never says residuals need higher precision, and drops Mathews' caveat that more iterations do not help.
3. **Row Reduced Echelon Form:** Example 2 calls an echelon form "RREF" (true last row $[0\,0\,0\mid1]$); the algorithm has no rule for a column without a pivot, which two of its three examples need.
4. **Homogeneous Linear Systems:** the Summary's "full rank gives only the trivial solution" is false for the page's own 3×4 propane example.

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [inverse-matrix](inverse-matrix.md) | — | — | 4 | 2 | 2 | reviewed |
| [tri-diagonal-matrices](tri-diagonal-matrices.md) | — | — | 0 | 0 | 3 | reviewed (calibration pilot) |
| [row-reduced-echelon-form](row-reduced-echelon-form.md) | — | — | 1 | 1 | 2 | reviewed |
| [homogeneous-linear-systems](homogeneous-linear-systems.md) | — | — | 0 | 1 | 1 | reviewed |
| [iterative-refinement](iterative-refinement.md) | — | — | 2 | 1 | 2 | reviewed |

Fidelity findings: Inverse F8; Tri-Diagonal F3; RREF F3, F4; Homogeneous F2; Iterative Refinement F3 (Misleading), F4.

## Patterns

- **Numerical-precision claims nobody measured** (Inverse Matrix's "double precision fails", Iterative Refinement's bound): the page asserts what floating point does instead of computing it.
- **Summary or algorithm statements wider than what the page proves** (Homogeneous's "full rank", RREF's algorithm, Inverse Matrix's LU comparison).
- **Mathews' examples dropped silently** on four of five pages, including the ones that demonstrate the module's warning (the chopped Hilbert matrix, $H_6$–$H_{10}$, the middle-column free variable).
