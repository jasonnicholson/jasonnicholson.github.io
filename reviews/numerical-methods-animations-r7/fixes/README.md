# Fix run — numerical-methods animations (round 7)

Run of 2026-11-23 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r7`. Nothing was pushed.

## Headline

- **Round-7 findings:** 60, made up of 1 Error, 15 Misleading and 44 Minor.
  - **58 are fixed**, on 36 pages.
  - **2 are deferred** under your earlier decisions: Maclaurin F1 (order cutoff, R6-D) and Padé F1 (pole spikes, R5-C). The Maclaurin page is unchanged.
  - None was `not reproduced`, and none is `open`. Every fixer reproduced its findings before changing anything, including the 44 unverified Minor ones.
- **Every page went through an independent resolution check.** Each checker saw the findings and the diff, but not the fixer's record. All passed, three after one return to the fixer (see "Process notes").
- **35 commits cover the 36 pages.** Lagrange and Newton Interpolation share a script and were committed together. One more commit records decisions R7-A to R7-D.
- **Every changed script was re-run from a scratch copy, and its GIFs reproduce byte for byte.**
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **53 GIFs changed**, 23 in each interpolation folder and one on each of seven other pages. The section still has 261 GIFs.

| Severity | Findings | Fixed | Deferred |
|---|---|---|---|
| Error | 1 | 1 | 0 |
| Misleading | 15 | 15 | 0 |
| Minor | 44 | 42 | 2 |

## Script and GIF changes

All other fixes are text only. Three code-comment fixes (Broyden, Fixed-Point, Rational) changed a script comment, and their GIFs regenerate byte-identical.

| Page | Change | GIFs |
|---|---|---|
| Catenary | Mathews' form $y = c\cosh(x/c) - c$ and his parabola $x^2/(2c)$ (R7-B) | 1 |
| Lagrange and Newton Interpolation | Clamp moved to one y-span beyond the axes, so no false flat tops and no runs along the frame edge (R7-C). Cases 18 and 20 use Mathews' nodes on [−2, 2] and [−10, 10] | 23 in each folder |
| Chebyshev | Case 26 on [0.05, 5], as in Mathews' animation | 1 |
| Adaptive Simpson | Splits [1/2, 1] before [0, 1/2] at the 11-point stage, as Mathews did. All 20 stages match his trace, and the final value is unchanged | 1 |
| Numerical Differentiation | Case 2 draws Example 14's parabola and its line at the secant slope | 1 |
| Gauss-Legendre | Node stems removed, as in Mathews' drawing | 1 |
| B-Splines | Legend moved outside the axes, so the running sum is visible | 1 |
| Madsen-Reid | Zoomed frames of Case 2 draw only the current step's axis segment | 1 |

## For you to decide or revisit

- **The director's defaults under "Fix all" (R7-A to R7-D in the fix plan).**
  - Catenary now follows Mathews' formula in the script, GIF and text, instead of the review's text-only alternative.
  - The Fidelity fixes listed above follow Mathews.
  - Maclaurin F1 and Padé F1 stayed deferred. If "all" was meant to include them, they are the remaining work.
- **Madsen-Reid:** the unzoomed frames render to identical PNGs, but the GIF encoder re-dithers them, because one palette is shared across frames. They look the same.
- **Halley:** the page now says the second formula takes "about twice" as long as the first. This is a timing and depends on the machine. The fixer measured 2.1 to 2.2 times Newton, the checker 1.98 to 2.17, and the review 1.8 to 1.9.
- **Not in scope this round:** the review's "Noted by reviewers, not counted" items were left alone. They include the Laurent Case 06 alt text and the Numerical Differentiation Formulae Case 1 dashed line.
- **Pages without a `## Description` section** (Bisection, Catenary and others) are unchanged, because no finding names them.
- **Stray files:** a `quarto preview` running in your terminal wrote `index_files/` into `pages/numerical-methods/numerical-differentiation/` during the run. They are untracked and were not staged.
- **The round-7 review report is not committed.** Its page reports and README are untracked. This folder's `fixes/` and `fix-plan/` are committed.

## Process notes

- **Improved Newton went back once, at the director's request.** The fixer's notes flagged two general sentences with the same imprecision as F3. They now also say "at least quadratic", and both entered the ledger before the check.
- **Euler went back once.** The checker found the findings resolved, but one new sentence read as three equal clauses. It was reworded with an explicit "so", and the checker confirmed it.
- **Taylor ODE went back once.** The checker asked for one term, "the shaded region", in place of a mix of "band" and "shaded region", and for "each run". Fixed and confirmed.
- **Pilot:** Improved Newton, Lagrange and Newton Interpolation, Taylor ODE, Catenary and Euler. Their records showed each finding reproduced and every changed sentence computed, so the rest were launched without changing the brief.
- **The legacy archive was found and used** on every page with a Fidelity finding, and consulted elsewhere as each record notes. The Newton-Raphson module is at `n2003/Newton'sMethodMod.html`, not at the path given in that brief.

## Commits (36, oldest first)

`665c807` (decisions R7-A to R7-D), then the pages: `86b2475 7bd64c2 acfa96a 6645dd2 ff4f1bb b2887a7 53c5c30 c59c367 eee6304 cf8387b c88ef04 1246916 edb394a d6483fd ffb9b9d 280b273 06cd803 7a12d40 8e6836e ccd4377 5b06add 39fc473 fe5f566 81bfd84 21f61ff da7b095 2433b76 5fef4b3 47eff16 185af2e 6eb49ea 4a1c041 a132917 4777b0b e0fc135`. This README is in a separate commit after these.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r8`.
