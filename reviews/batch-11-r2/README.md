# Batch 11 review, round 2 (text-only)

Scope: the five batch 11 pages, all changed by the round-1 fixes, re-reviewed independently on 2026-11-25. Reviewers did not read `reviews/` or any fix ledger before their reports were final. All five pages were reviewed.

- **Calibration:** the pilot (Gauss-Jordan) was reviewed on a scratch copy with two planted errors (a determinant wrong in its third significant digit; a false claim that Algorithm I succeeds because $\det A \ne 0$). Both were found and removed.
- **Independent check:** no Error or Misleading findings this round, so none was needed. Minor findings are reported unverified.

## Totals

**0 Error, 0 Misleading, 2 Minor.** The round meets the stopping rule (no Error or Misleading findings).

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [triangular-systems-and-back-substitution](triangular-systems-and-back-substitution.md) | — | — | 0 | 0 | 1 | reviewed |
| [gauss-jordan-elimination-and-pivoting](gauss-jordan-elimination-and-pivoting.md) | — | — | 0 | 0 | 0 | reviewed (calibration pilot) |
| [lu-factorization](lu-factorization.md) | — | — | 0 | 0 | 0 | reviewed |
| [cholesky-doolittle-and-crout-factorizations](cholesky-doolittle-and-crout-factorizations.md) | — | — | 0 | 0 | 1 | reviewed |
| [pivoting-methods](pivoting-methods.md) | — | — | 0 | 0 | 0 | reviewed |

The two Minor findings (Back Substitution's Example 1 departing from Mathews' matrix; Cholesky's "One valid … factor") were both fixed and independently checked after this round (see `reviews/batch-11/README.md`, closing section).

## Comparison with round 1

None of round 1's 25 findings came back. Back Substitution's F1 here revisits round 1's F4: round 1 kept the page's own matrix and disclosed the difference, and this round asked for a reason or the original. The fix restores Mathews' matrix.
