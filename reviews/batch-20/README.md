# Batch 20 review — round 1

Scope: `batch=20` of `plans/numerical-methods-light-pass-plan.md` (differentiation and integration I), overview mode. Branch `batch-20` (stacked on `batch-19`). The reviewers worked on the pages' working-tree text before it was committed; the overview commits `1fdad29`…`cc63f76` contain exactly that text. Simpson's Rule, the pilot page, was done and approved before this batch.

**7 pages reviewed, none skipped. Findings: 0 Error, 1 Misleading, 4 Minor.** The Misleading finding was confirmed by an independent checker given only the allegation.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Richardson Extrapolation](richardson-extrapolation.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Derive Numerical Differentiation Formulae](derive-numerical-differentiation-formulae.md) | extend | overview | 0 / 0 | 0 | 1 | 1 | reviewed; F1 confirmed |
| [Riemann Sums](riemann-sums.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Midpoint Rule](midpoint-rule.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Trapezoidal Rule for Numerical Integration](trapezoidal-rule-for-numerical-integration.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Simpson's 3/8 Rule for Numerical Integration](simpsons-3-8-rule-for-numerical-integration.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Boole's Rule](booles-rule.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |

## The findings

- **Derive Formulae F1 (Misleading, Page text and Fidelity):** the stated derivation recipe (Taylor degree $n = 2$ or 4, "keeping the next Taylor term as the remainder") yields no remainder for the two $f''$ formulas, and Mathews expands to degree $n+2$ (4 and 6). The displayed formulas are right.
- **Derive Formulae F2 (Minor):** "halving $h$ divides their truncation errors by about 4 and 16" needs the remainder's derivative to be nonzero at $x_0$.
- **Midpoint F1:** "about half the trapezoidal error and of opposite sign" needs $f'(a) \ne f'(b)$.
- **Trapezoidal F1:** "Its sign follows $f''$" runs against the displayed convention $\int - T_n$; it is $T_n - I$ that has the sign of $f''$ (when $f''$ keeps one sign).
- **Boole F1:** "on the first frame ($n = 4$)" — the first frame shows $f$ alone; $n = 4$ is the first quadrature frame.

## Pattern

Two of the five are hypotheses a general statement leaves implicit (Derive F2, Midpoint F1); the rest are wording. Every number on all seven pages matched the reviewers' independent computations.

## Evidence and method

- Archive found and used. No script or GIF changed; frames of every embedded GIF were extracted.
- Calibration: one reviewer got a scratch copy of the Trapezoidal page with two planted errors in the new text (a tabulated error −0.01949 for −0.01919; and a claim that Case 1 keeps the $O(h^2)$ rate, dividing the error by close to 4 per halving, when the ratios are 2.7–3.2). It found both. It also flagged the sentence "Romberg Integration repeats that step on successive trapezoidal sums" as loose (Romberg's later columns use weights $4^k$); the real Trapezoidal reviewer accepted that sentence, so it is noted here for Jason rather than reported as a finding. The calibration report was discarded.
- Reviewers returned their reports as text; the director saved them unchanged.
- Mechanical checks found nothing.
