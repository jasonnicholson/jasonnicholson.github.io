# Batch 19 review — round 1

Scope: `batch=19` of `plans/numerical-methods-light-pass-plan.md` (interpolation II and curve fitting), overview mode. Branch `batch-19` (stacked on `batch-18`). The reviewers worked on the pages' working-tree text before it was committed; the overview commits `f4d4306`…`ceab030` contain exactly that text.

**9 pages reviewed, none skipped. Findings: 0 Error, 0 Misleading, 3 Minor.** No finding needed the independent check. The fixer reproduced each Minor finding before changing anything.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Cubic Splines](cubic-splines.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [B-Splines](b-splines.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Bézier Curves](bezier-curves.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Chebyshev Approximation Polynomial](chebyshev-approximation-polynomial.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Rational Approximation](rational-approximation.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Legendre Polynomials](legendre-polynomials.md) | write | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Catenary](catenary.md) | write | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Least Squares Lines](least-squares-lines.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Least Squares Polynomials](least-squares-polynomials.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |

## The Minor findings

- **B-Splines F1:** the curve's domain and the partition of unity are stated on the closed interval $[t_k, t_{n+1}]$, but the page's own half-open definition of $N_{i,1}$ makes both fail at $t = t_{n+1}$ (the writer had flagged this tension in Phase 1).
- **Rational Approximation F1:** the normalisation $Q_n(0) = 1$ loses no generality only when $Q_n(0) \ne 0$, which holds on any interval containing 0 (all of this page's cases).
- **Legendre F1:** "the orthogonal polynomials of $[-1,1]$" suggests a unique family; the weight is 1.

## Pattern

All three are precision in a definition or hypothesis; every number on all nine pages matched the reviewers' independent computations.

## Evidence and method

- Archive found and used. No script or GIF changed; frames of every embedded GIF were extracted.
- Calibration: one reviewer got a scratch copy of the Least Squares Lines page with two planted errors in the new text (a residual sum of squares 0.6963 for 0.6863; and a claim that each added point lowers the minimum, when Case 1's minimum rises from 0 to 39/28). It found both. That report was discarded and the real page reviewed afresh.
- Reviewers returned their reports as text; the director saved them unchanged.
- Mechanical checks found nothing.
- Noted by the Least Squares Polynomials reviewer, outside this batch's diff and not determined: the unchanged Animations introduction's description of Mathews' Example 6 graph.

## Batch close-out (director)

- **Pages built:** nine overview Descriptions with claim ledgers (seven *extend*, two *write*). No script or GIF changed. Final prose counts: Cubic Splines 393, B-Splines 397, Bézier 398, Chebyshev 386, Rational 383, Legendre 395, Catenary 392, LS Lines 395, LS Polynomials 398.
- **Findings:** round 1 only (0 Error, 0 Misleading, 3 Minor). All three were reproduced and fixed by one fixer with a ledger, and confirmed by a separate checker who saw only the findings and the diffs. The checker raised one new Minor on the Rational fix ("where $Q_n$ cannot vanish" read against line 50); it went back to the fixer once and was reworded to tie the condition to the definition's requirement. No round 2 was needed.
- **Open:** nothing.
- **Commits:** `f4d4306`…`ceab030` overviews; `f0b9dbb` review; `3931c34`, `3605f93` and the Rational fix commit; the close-out commit.
