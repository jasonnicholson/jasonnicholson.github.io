# Batch 3 review, round 2

**Pages reviewed: 3 of 3** (all three pages changed in the round-1 fixes). None skipped.

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).** With no Error or Misleading finding, Phase 3 (independent checking) had nothing to check. No implementation or drawing error on any page; every iterate and table cell again matches an independent implementation, and every committed GIF is byte-identical to what its script produces.

This was a fresh, independent review: reviewers did not read round 1's reports or the fix records. Each reviewer's claim ledger covered the whole page. The legacy archive was found and every reviewer consulted it.

## Calibration

Nelder-Mead was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors (Case 1's distance 0.0231 changed to 0.0213, and Case 3's "Only search (iii) finds the global minimum" changed to "(ii)") and reported both as Errors with its own computations (0.023130; the global minimum f = −1.846283 is reached by search (iii)). It found nothing else on the page, so that review stands as Nelder-Mead's round-2 review, with the planted findings removed.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [nelder-mead-method](nelder-mead-method.md) | 3 | 3 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [steepest-descent-gradient-search](steepest-descent-gradient-search.md) | 4 | 4 | 0 | 0 | 1 | reviewed |
| [powells-method](powells-method.md) | 3 | 3 | 0 | 0 | 2 | reviewed |

## The findings

- **Steepest Descent F1:** "agrees with a 120-digit run to more than 50 digits" is true in absolute terms (5.6e-52) but the smallest step lengths agree to only about 41 relative digits.
- **Powell F1:** Mathews' hand-worked Example 6 starts one `FindMinimum` at γ = 0.5, not 0 (same result).
- **Powell F2:** "the same … colours … one thing is drawn differently" misses that the dog-leg segments are orange, not Mathews' magenta.

## Comparison with round 1

None of round 1's findings came back. The confirmed round-1 Error (Steepest Descent's counter-removed iteration counts) was re-derived by this round's reviewer as 113 and 103 at ≥ 100 digits and found correct on the page.

## Patterns

- Precision and agreement statements need their sense stated (absolute or relative), as with round 1's counts.
- Statements about how Mathews did something ("every line search", "the same colours") again needed an item-by-item check against the archive.

## Phase 1 inventory

All 10 scripts ran from scratch copies and reproduced all 10 committed GIFs byte for byte. Every page reference resolves, no file on disk is unreferenced, and the section index links all three pages.
