# Batch 10 review, round 2 (text-only)

Scope: the three batch 10 pages, all changed by the round-1 fixes, re-reviewed independently on 2026-11-25 with a whole-page claim ledger. Reviewers did not read `reviews/` or any fix ledger before their reports were final.

- **Calibration:** the pilot (Hessenberg Factorization) was reviewed on a scratch copy with two planted errors (Example 9's step-2 $\alpha$; a false claim that the QR iteration on Example 5's real $\mathbf H$ converges to a triangular matrix with the complex pair on its diagonal). Both were found and removed.
- **Independent check:** the one Misleading finding was confirmed by a fresh checker given only the allegation.

## Totals

**0 Error, 1 Misleading, 0 Minor.** The round does not yet meet the stopping rule; Faddeev-Leverrier goes to a fix and a third round.

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [householder-transformations](householder-transformations.md) | — | — | 0 | 0 | 0 | reviewed |
| [hessenberg-factorization](hessenberg-factorization.md) | — | — | 0 | 0 | 0 | reviewed (calibration pilot) |
| [faddeev-leverrier-method](faddeev-leverrier-method.md) | — | — | 0 | 1 | 0 | reviewed |

## Comparison with round 1

None of round 1's six findings came back. The new finding is in a sentence round 1 confirmed numerically: its 0.14 and 2×10⁻¹⁴ are right, but round 2 tested the inference drawn from them and found it unsupported.
