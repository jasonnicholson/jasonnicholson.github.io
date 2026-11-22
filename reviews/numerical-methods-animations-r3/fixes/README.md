# Fix run — numerical-methods animations (round 3)

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r3`. Nothing was pushed.

## Headline

- **All round-3 findings are fixed except Muller's two, which you parked (R3-C).** 31 pages are committed:
  - the 23 pages with findings, other than Muller;
  - the 8 pages whose only change is the R3-D move of the "not animated here" sentence.
- **Findings:** 31 in total.
  - 29 are `fixed`: 3 Misleading and 26 Minor.
  - 2 are `deferred`: Muller F1 and F2.
  - None is `not reproduced`, and none failed its check.
- **Every page went through an independent resolution check.** The checker saw the findings and the diff, but not the fixer's record. It recomputed every changed number and sentence, looked at the regenerated frames, and reproduced every changed GIF byte for byte from a scratch copy.
  - Three pages went back to their fixer once and then passed:
    - **Laurent:** the new sentence said case 06 does not show divergence, but it does for x < 0.
    - **Runge-Kutta:** "the cause is stability" is false for m = 12–18. There the upturn is one step's own truncation error, not amplified earlier error.
    - **Aitken/Neville:** the same exact-degree wording as F1 was in the Case 1 Behavior sentence.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **The legacy Mathews archive was used on every page** that has a Fidelity finding or a "not animated" sentence. Each fix record says what it showed.

## How your round-3 decisions were applied

- **R3-A (Madsen-Reid, `fz0 = fz1`).** All three scripts store P′ at the previous iterate. That is the one departure from `newton_real`, and the page says so in one sentence citing Madsen & Reid's test (2.9).
  - The x₀ = −0.7 example in §1 now takes 5 steps, with stages 1, 2, 1, 1, 1. It used to take 21.
  - §1 again says the convergence to a multiple root is quadratic, scoped to while the iteration stays in Stage 1. It also says that near a double root the stage test is borderline.
  - Cases 1–3 are unchanged, and their GIFs are byte-identical.
  - No factor-2 margin and no Stage-2 |f| check were added.
- **R3-B (Fidelity findings).** Of the ten, nine are fixed and Muller F2 is parked:
  - **Catenary:** the exploration numbers are corrected, and Exploration 1 is added to the "not animated" list.
  - **Least-Squares Polynomials:** Example 8 is added to the list.
  - **Improved Newton:** the caveats in Examples 1–2 are added to the list.
  - **Hermite:** Case 2 now uses Mathews' Example 1 data, and the eˣ curve is gone.
  - **Fixed-Point:** Cases 2 and 3 now start at 4.0, as Mathews does, and the window is widened to [0, 4.2].
  - **Chebyshev:** Case 07 now uses Mathews' interval, [−1.5, 0.95].
  - **Derive:** the "legacy test function" wording is removed.
  - **Cubic Splines:** see the second item under "For you to decide or revisit".
- **R3-C (Muller).** The page is untouched, and F1 and F2 are marked `deferred` in the worklist.
- **R3-D (placement).** On all 17 pages that have a "not animated here" sentence, it now sits in the Animations introduction, before Case 1.

## For you to decide or revisit

- **Padé: your MATLAB sentence.** The finding only asked for it to be made parseable ("fail at times … fails"). The fixer ran MATLAB R2026a and could not reproduce a failure below total order 20. So the sentence now states what was measured: `pade` is very slow for some entries. [1/15], [1/16] and [1/17] for eˣ took about 7, 31 and 134 s, and the checker re-measured 7.2, 31.0 and 138.0 s. If you have seen it actually fail, possibly in another release, put that back.
- **Cubic Splines keeps sin x.** It does not switch to Mathews' 7-point data table; it gives a one-sentence reason instead: with a closed form, each frame can report the max error. The checker judged this consistent with R2-A, because Mathews' module has no animated case. Say if you would rather follow his data.
- **Hermite Case 2 changed its example.** It is now Mathews' Example 1, two points with given slopes, instead of eˣ on [0, 1]. The picture is different from before.
- **Madsen-Reid's double root.** The page now says the stage test is borderline at a double root. Vestermark's 2026 factor-2 margin would remove that. It was not added, per R3-A.

## Found but not changed

These are pre-existing and are not round-3 findings:

- **Monte Carlo π:** the intro says "Each animation below" and "these animations" for a single animation (Minor).
- **Pages without a `## Description` section,** noted again by checkers: Catenary, Runge-Kutta, Fixed-Point and Tangent Parabola, among others.

## Method notes

- **Briefs:** each fixer brief carried:
  - the page's findings, verbatim;
  - the R2 and R3 decisions, plus D1, D2, D5 and D7 where they applied;
  - the archive location;
  - the lessons from rounds 1 and 2, including that text added by a fix is where the next round's findings come from;
  - the full Fix standard.
- **Madsen-Reid:** the brief also carried the quotes from Madsen & Reid (AERE-R 7986). It gave a compiled copy of the 2002 C++, with and without the one-line change, as a second implementation to compare against. That copy is kept in scratch and is not in the repository.
- **Pilot:** Madsen-Reid, Euler and Catenary went first. Catenary's record was read before the rest were launched.
- **Note pattern:** the "no numbers" rule in the note pattern was clarified mid-run. Example numbers are fine; computed values are not.

## Commits (24, oldest first)

`d1f1b93` (R3-D move on eight pages) `c6db113 fed6830 bbf4592 f4379e2 2f7bc55 34af384 b9aac61 d57b8ea 316b88a b82cbcf f59a9f3 5a66272 d7d580f 1cc0013 fefc062 4782d75 33ca12c b0b2b57 25a9966` (WP-B: Lagrange and Newton) `5061856 4fd6bc8 8732a4a`. This README and the Muller rows of the worklist are in the last commit.

Decisions R3-A to R3-D are recorded in `28216df`. The round-3 report is `300fc16`.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r4`.
