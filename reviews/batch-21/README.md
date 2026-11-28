# Batch 21 review — round 1

Scope: `batch=21` of `plans/numerical-methods-light-pass-plan.md` (integration II), overview mode. Branch `batch-21` (stacked on `batch-20`). The reviewers worked on the pages' working-tree text before it was committed; the overview commits `1360dff`…`8649c50` contain exactly that text (it was saved before any fix and committed from the saved copies).

**7 pages reviewed, none skipped. Findings: 0 Error, 0 Misleading, 3 Minor.** No finding needed the independent check. The fixer reproduced each one before changing anything.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Newton-Cotes Integration](newton-cotes-integration.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Romberg Integration](romberg-integration.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Adaptive Simpson's Rule](adaptive-simpsons-rule.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Gauss-Legendre Quadrature](gauss-legendre-quadrature.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Cubic Spline Quadrature](cubic-spline-quadrature.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Monte Carlo Pi](monte-carlo-pi.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [2D Trapezoidal and Simpson Rules](2d-trapezoidal-and-simpson-rules.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |

## The Minor findings

- **Newton-Cotes F1:** "Nearly all of that error comes from the panel at $x=0$" also reads as covering the trapezoidal rule, where the share is 71%; it is over 99% only for Simpson 3/8 and Boole.
- **Cubic Spline Quadrature F1:** "In the frames below, each halving $h$" was ungrammatical, and the errors are in the table, not the frames.
- **Monte Carlo Pi F1:** "the first four frames" — frame 1 shows no points; n = 100…6400 are frames 2–5.

## Pattern

All three are wording; every number on all seven pages matched the reviewers' independent computations. Optional, noted by the 2D reviewer: its table's n = 16 trapezoidal error −0.004482 is truncated (−0.00448254 rounds to −0.004483).

## Evidence and method

- Archive found and used. No script or GIF changed; frames of every embedded GIF were extracted.
- Calibration: one reviewer got a scratch copy of the Romberg page with two planted errors in the new text (halving ratios "3.46 to 3.50" for 3.16 to 3.20; and a claim that $R_{8,8}$ keeps its column's high order and is about $10^6$ times closer to $I$ than $R_{8,1}$, when it is 4.4 times). It found both. That report was discarded and the real page reviewed afresh.
- Reviewers returned their reports as text; the director saved them unchanged.
- Mechanical checks found nothing.

## Batch close-out (director)

- **Pages built:** seven overview Descriptions with claim ledgers (all *extend*). No script or GIF changed. Final prose counts: Newton-Cotes 391, Romberg 329, Adaptive Simpson 400, Gauss-Legendre 354, Cubic Spline Quadrature 370, Monte Carlo Pi 400, 2D rules 385.
- **Findings:** round 1 only (0 Error, 0 Misleading, 3 Minor). All three were reproduced and fixed by one fixer with a ledger, and confirmed by a separate checker who saw only the findings and the fix-only diffs. No round 2 was needed.
- **Open:** nothing (the 2D table's truncated last digit is optional and was left).
- **Commits:** `1360dff`…`8649c50` overviews; the review commit; three fix commits; the close-out commit.
