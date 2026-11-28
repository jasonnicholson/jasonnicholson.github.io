# Batch 20 review — round 2

Scope: the four batch 20 pages changed by the round 1 fixes (Derive Numerical Differentiation Formulae, Midpoint Rule, Trapezoidal Rule, Boole's Rule), overview mode, reviewed at commit `7ec4da8`. Each reviewer was fresh, was told not to read `reviews/`, and reviewed the page's whole batch diff against `main`.

**4 pages reviewed. Findings: 0 Error, 0 Misleading, 1 Minor.** This round meets the stopping condition, so there is no round 3. The Minor finding was fixed and independently checked.

| Page | Error | Misleading | Minor |
|---|---|---|---|
| [Derive Numerical Differentiation Formulae](derive-numerical-differentiation-formulae.md) | 0 | 0 | 1 |
| [Midpoint Rule](midpoint-rule.md) | 0 | 0 | 0 |
| [Trapezoidal Rule for Numerical Integration](trapezoidal-rule-for-numerical-integration.md) | 0 | 0 | 0 |
| [Boole's Rule](booles-rule.md) | 0 | 0 | 0 |

- **Derive F1 (Minor):** Case 3's quoted errors are maxima over the plotted window $[2h,\pi-2h]$, not errors at one point; the sentence now says "largest".
- Round 1's Misleading finding (the derivation recipe's expansion degree) did not come back; the round 2 reviewer confirmed the new degrees against Mathews' module images.

## Method

The reviewer brief is unchanged from round 1 (calibrated in each of batches 16–22), so this re-review was not separately calibrated. The Derive reviewer disclosed that a repository-wide `grep` for inbound links printed four lines from files under `reviews/batch-20/`; it did not open those files and says nothing in its report relies on them. Its findings are independent of round 1's (it raised a different point). Reviewers returned their reports as text; the director saved them unchanged.
