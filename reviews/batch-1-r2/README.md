# Batch 1 review, round 2 (2026-11-24)

**4 of 4 pages reviewed. 0 Error, 0 Misleading, 5 Minor.** All Minor findings are unverified: only Error and Misleading findings go to an independent check, and this round had none. **This round meets the stop condition of `run-animation-batch` Phase 4: no Error or Misleading findings.**

Round 2 is a fresh, independent review of all four batch-1 pages after the round-1 fixes. No reviewer read round 1. As in round 1, every reviewer's claim ledger covered the whole page.

## Pages

| Page | Scripts | GIFs | Errors | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [fibonacci-search](fibonacci-search.md) | 3 | 3 | 0 | 0 | 0 | reviewed |
| [milne-simpsons-method](milne-simpsons-method.md) | 2 | 2 | 0 | 0 | 1 | reviewed |
| [fourier-series](fourier-series.md) | 8 | 8 | 0 | 0 | 4 | reviewed by two reviewers, split by half |
| [monte-carlo-integration](monte-carlo-integration.md) | 2 | 2 | 0 | 0 | 0 | reviewed (calibration page) |
| **Total** | **15** | **15** | **0** | **0** | **5** | |

## The five Minor findings

1. **Milne-Simpson F1:** computed values $y_5$ and $y_{10}$ are written as $y(0.5)$ and $y(1)$, the notation for the exact solution.
2. **Fourier S1:** "the overshoot does not shrink as m grows" is false for the step function, whose overshoot shrinks toward its limit. It should say "does not tend to zero".
3. **Fourier S2:** "1 + 0.0895 × 2 = 1.17898" does not compute as written. It needs the unrounded constant or "≈".
4. **Fourier D1:** Mathews' FFT list is quoted as "3.14159, 1.30273, 0, …, 0, 1.30273". The elision hides the nonzero 0.174533 and 0.0935319.
5. **Fourier D2:** the Description calls the coefficient sums "the real and imaginary parts of the DFT" without the factor 2/n and the sign of b_j. Equation (10) has both.

There are no fidelity findings, apart from the quotation in D1.

## How the round was run

- **Evidence.** The same preparation script as round 1. **All 15 GIFs regenerate byte-identically.** Every file is referenced by its page and no reference is missing. There are no inventory findings.
- **Calibration.** It ran on Monte Carlo Integration this time, a different page from round 1. Two errors were planted in a scratch copy: an estimate wrong in the third significant figure ("5.672" for 5.692), and "fall more steeply" where the computation shows "less steeply". The reviewer found both and reported them as Errors with computed evidence. They are not in this report. The copy differed only in those two lines, and the reviewer's numbers confirm the real text there.
- **A disagreement settled by computation.** The discrete Fourier reviewer queried the page's 3.70189 for max S₂₅ of x−|x−π|. The continuous reviewer and the director both computed 3.7018934, so the page is right.
- **Rules.** No MATLAB and no quarto were run. Reviewers changed nothing in the repository. The only new path is this folder.

## Patterns

- The round-1 classes recur in milder form. There is no rounding slip this time, but there are sentences that are true in general and loose in one place ("does not shrink"), and notation that blurs computed and exact values.
- Every round-1 finding stayed fixed. The round-1 reports were read only after this round's findings were final.

<!-- The batch director appends a closing section in Phase 5 of run-animation-batch. -->
