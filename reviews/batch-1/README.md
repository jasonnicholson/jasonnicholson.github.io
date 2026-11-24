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

## Batch closing (run-animation-batch, 2026-11-24)

**Built:** four pages, each with new text (content-page) and animations (animation-page): 15 scripts and 15 GIFs. Every GIF regenerates byte for byte from its script.

| Page | Animations |
|---|---|
| Fibonacci Search | 3: Mathews' Example 2 at his worked tolerance (n = 12); a rebuild of his animation (n = 32, inferred from its 30 steps); Example 1 with the e-split (new) |
| Milne-Simpson's Method | 2: a rebuild of his m-sweep for y′ = 1 − t∛y with 21 values of m (all of his printed y(5) values reproduced, with the real cube root); a new weak-stability error plot for y′ = 30 − 5y |
| Fourier series | 8: rebuilds of all five Fourier-series animations (only one GIF survived) and the three surviving discrete-series animations |
| Monte Carlo Integration | 2 new: Example 3's running estimate, and Example 14's Monte Carlo against the midpoint rule in 5-D |

### Findings by round

| Round | Error | Misleading | Minor | Outcome |
|---|---|---|---|---|
| 1 (`reviews/batch-1`) | 0 | 0 | 17 | all 17 reproduced and fixed, plus one more rounding slip the fixer found (Milne e₂: 2.90e-6 should be 2.89e-6); each fix independently checked |
| 2 (`reviews/batch-1-r2`) | 0 | 0 | 5 | all 5 reproduced and fixed, plus three more computed-vs-exact labels in the Milne Example 3 table and one in Example 4; each fix independently checked |

- **Stop condition.** Round 2 had no Error or Misleading findings. That is the stop condition of Phase 4.
- **Independent checks.** Every fix was checked by a separate subagent that saw only the finding and the diff, never the fixer's reasoning. Each checker confirmed its fixes resolved. Four wording nits the checkers raised were sent back to the same fixer, tightened, and then confirmed by the director:
  - Fourier: "even-degree terms";
  - Fourier: "same layout";
  - Fourier: the D2 sentence;
  - Monte Carlo: the coordinate-order sentence.
- **Calibration.** Each round's review was calibrated with two planted errors: Milne-Simpson in round 1, Monte Carlo in round 2. Both rounds' reviewers caught both.

**Open:** nothing. No finding was left unfixed or deferred.

### Decisions taken for Jason to revisit

1. **The Fourier module overlap.** `fft-and-trigonometric-polynomials/` is a skeleton folder page, outside the plan, and it uses the same Mathews module (`FourierSeriesMod`). Following the plan, the Fourier series page covers both the series and the discrete/FFT material and all of the module's animations. If the FFT page is written later, it should link to these rather than duplicate them, or the discrete cases (6–8) could move there.
2. **Lost discrete-series animations FFT1 and FFT2.** They were not rebuilt, and the page says why. The archive's index layout indicates they used |x−π| and x−π; rebuilding them would be two more scripts like Cases 6–8.
3. **Monte Carlo Example 14 repeat study.** I kept the figures (88.7% and 90.9%) and stated the random stream they came from, which continues the Example 3 study's generator, instead of rerunning it from a fresh seed. A fresh seed would give 87.9% and 90.8%.
4. **Fibonacci Case 3 split frame.** The two points overlap at the plotted scale. I added a note to the text rather than re-zooming the frame.
5. **No round 3.** Round 2 met the stop condition. Its five Minor findings were small text edits, each checked independently, so no third review round was run.
6. **The plan's count.** The plan said "4 of 9" Fourier animations survive. The module actually links 10, of which 4 survive. The plan row now says so.

### Process notes

- Subagents cannot write report files in this environment, so reviewers returned their reports as text and the director wrote these files.
- Legacy GIFs decode with duplicated frames under ffmpeg: 507 decoded frames for 31 distinct in `Fibonacciaa.gif`. Count distinct frames from `frames.md5`. Every brief said so.
- Nothing was pushed, and nothing was merged into `main`.
- No MATLAB was run anywhere.
- The global Julia environment was not changed.
- The whole section renders without errors (`quarto render pages/numerical-methods/`).

### Commits on `batch-1` (oldest first)

1. Write Monte Carlo Integration page text (batch 1)
2. Write Fibonacci Search page text (batch 1)
3. Write Fourier series page text (batch 1)
4. Write Milne-Simpson's Method page text (batch 1)
5. Add Fibonacci Search animations (batch 1)
6. Add Monte Carlo Integration animations (batch 1)
7. Add Milne-Simpson's Method animations (batch 1)
8. Add Fourier series animations (batch 1)
9. Add batch 1 review
10. Fix Fibonacci Search (batch 1 review)
11. Fix Milne-Simpson's Method (batch 1 review)
12. Fix Monte Carlo Integration (batch 1 review)
13. Fix Fourier series (batch 1 review)
14. Add batch 1 review round 2
15. Fix Milne-Simpson's Method (batch 1 review round 2)
16. Fix Fourier series (batch 1 review round 2)
17. Mark batch 1 done in the plan and close the batch README (this commit)

