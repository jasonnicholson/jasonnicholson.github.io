# Batch 6 review, round 2

**Pages reviewed: 3 of 3** (all pages changed in the round-1 fixes: Projectile Motion, Logistic Curve, Earthquake Model). None skipped.

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).** With no Error or Misleading finding, there was nothing for independent checking, and no further round is required. No implementation or drawing error on any page; every GIF is byte-identical to what its script produces.

This was a fresh, independent review: reviewers did not read round 1's reports or the fix records, and did not compare a page with any other copy of it. Each reviewer's claim ledger covered the whole page, and every reviewer consulted the legacy archive. The pages were reviewed from the working tree in their round-1-fixed state (saved, and committed as the "Fix … (batch 6 review)" commits).

## Calibration

Earthquake Model was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors in Case 1 (the second floor's amplitude 0.3884 ft changed to 0.3844, and "moves with floors 5 and 6 and against floors 1 to 4" swapped) and reported both as Errors from its own computations. It found nothing else, so that review stands as Earthquake's round-2 review.

## The findings

- **Projectile Motion F1 (fidelity):** "Mathews' comparison plot" — he has two (Examples 3 and 4), neither with all four drag laws.
- **Logistic Curve F1:** the Case 3 alt text calls every solution below 800 S-shaped; those from 400 and 600 are concave down throughout the window.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [earthquake-model](earthquake-model.md) | 4 | 4 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [projectile-motion](projectile-motion.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [logistic-curve](logistic-curve.md) | 3 | 3 | 0 | 0 | 1 | reviewed |

## Comparison with round 1

None of round 1's findings came back. Each reviewer independently confirmed the round-1 corrections now on the page: Millikan's drops in the linear regime and the Example 7 end-point wording (Projectile); the Hessian-eigenvector wording and |r| (Logistic); the residual bound 9e−6, the fixed-coordinate wording at ω = 6, and the bisection comment (Earthquake).
