# Batch 1 review, round 1 (2026-11-24)

**4 of 4 pages reviewed. 0 Error, 0 Misleading, 17 Minor.** All Minor findings are unverified: the review skill sends only Error and Misleading findings to an independent check, and this round had none.

Scope: batch 1 of `plans/numerical-methods-animation-plan.md`. The pages are Fibonacci Search, Milne-Simpson's Method, Fourier series and Monte Carlo Integration. All four were built in this batch, both their text (content-page) and their animations (animation-page).

Because the text is new too, every reviewer's claim ledger covered the **whole page**: worked examples, tables, theorems and implementation notes as well as the Animations section. Together the ledgers hold about 400 entries, each checked against the reviewer's own computation (exact rationals, sympy, mpmath, scipy, numpy) or the frames. The legacy Mathews archive was found and consulted for all four pages.

## What to look at first

None of the findings is a false number or a false behaviour claim at the precision a reader would use. The most useful ones are:

1. **Fourier series M2.** The Animations introduction says "the excess [of max S_m over sup f] is the Gibbs overshoot". For Case 2 (x−π) that excess is 0.44 at m = 25, while the Case 2 text quotes 0.56, measured from the line.
2. **Fourier series M4.** The text on the two lost discrete-series animations contradicts itself: it names their functions, then says they "cannot be read". The archive's image sizes indicate they were |x−π| and x−π.
3. **Monte Carlo F3.** The Example 14 repeat study (88.7% and 90.9%) reproduces only by continuing the Example 3 study's random stream. A fresh generator with the stated seed gives 87.9% and 90.8%.
4. **Rounding slips** that a reader could check and find wrong in the last digit:
   - Monte Carlo F1: 9.828e-4 should be 9.827e-4.
   - Monte Carlo F2: 88.0% and 90.6% should be 87.9% and 90.7%.
   - Milne-Simpson F1: 4.85e-6 and 8.55e-8 should be 4.84e-6 and 8.54e-8.

## Pages

| Page | Scripts | GIFs | Errors | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [fibonacci-search](fibonacci-search.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [milne-simpsons-method](milne-simpsons-method.md) | 2 | 2 | 0 | 0 | 3 | reviewed (calibration page) |
| [fourier-series](fourier-series.md) | 8 | 8 | 0 | 0 | 8 | reviewed by two reviewers, split by half |
| [monte-carlo-integration](monte-carlo-integration.md) | 2 | 2 | 0 | 0 | 5 | reviewed |
| **Total** | **15** | **15** | **0** | **0** | **17** | |

Fidelity findings, which Jason decides as a group:
- **Milne-Simpson F3:** Mathews' Example 8 also overlays both step sizes.
- **Fourier series M4:** the lost discrete-series animations.

## How the round was run

- **Evidence.** The director's own script built it in the session scratchpad:
  - an inventory of each page's scripts, GIFs and references;
  - a regeneration of every script from a scratch copy, with byte comparison;
  - frames, contact sheets and frame hashes of every committed GIF.

  The committed GIFs are real image data in LFS. Plots 1.41.2 and SpecialFunctions 2.7.2 load, and two of the pages also need the standard library's `Random` and `LinearAlgebra`. **All 15 GIFs regenerate byte-identically.** Every file is referenced by its page, no reference is missing, and the section index links all four pages. There are no inventory findings.
- **Calibration.** Two errors were planted in a scratch copy of the Milne-Simpson page: a reference value wrong in the third significant figure, and "dies out monotonically" for a sequence that zigzags. The reviewer found both and reported them as Errors with computed evidence. The planted errors are not in this report. That review stands for the real page, because the copy differed only in the two planted lines, and the reviewer's own numbers confirm the real text of both.
- **Reviewers.** One per page, except Fourier series, which has eight GIFs and seven worked examples and was split into its continuous and discrete halves.
- **Independent check.** Not needed: there were no Error or Misleading findings.
- **Rules.** No MATLAB and no quarto were run. Reviewers changed nothing in the repository; they returned their reports as text and the director wrote these files.

## Patterns

- **Double rounding.** Four findings round a value that was already rounded: Milne-Simpson F1 (two values), Monte Carlo F1 and F2. The authoring ledgers recorded these numbers at more digits than the page and then rounded them again.
- **Sentences that are true of most cases but not all.** Examples are "adds one degree per frame" (false for the odd-m cases), "the excess is the Gibbs overshoot" (true only as m→∞) and "his largest error" (the largest ratio, not the largest error). The Accuracy standard's rule on quantifiers applies to descriptive sentences as well as numbers.
- **Rounding-level residuals quoted as specific values.** See Fourier M5. Such a value depends on how it is evaluated and cannot be reproduced reliably.

The nine earlier review rounds, of the first 53 pages, were not read, and these findings were not compared with them.

<!-- The batch director appends a closing section here in Phase 5 of run-animation-batch. -->
