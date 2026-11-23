# Fix run — numerical-methods animations (round 6)

Run of 2026-11-23 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r6`. Nothing was pushed.

## Headline

- **Round-6 findings:** there were 8, all Minor.
  - **6 are fixed**, across 6 pages.
  - **2 are deferred** at your decision: Accelerated Newton F1 (R6-C) and Maclaurin F1 (R6-D).
  - None was `not reproduced`, and none is `open`.
- **The Laurent page is rebuilt** at your decision (R6-B). This was not a counted round-6 finding.
- **7 pages are committed**, one commit each, plus one comment-only follow-up on Padé.
- **Every page went through an independent resolution check.** Each checker saw the findings and the diff, but not the fixer's record.
  - B-Splines, Accelerated Newton, Chebyshev, Tangent Parabola and Padé passed the first time.
  - Muller and Laurent went back to their fixers for wording. See "Process notes".
- **Every committed GIF on the 7 pages reproduces byte for byte** from a scratch copy of its script.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **The section now has 261 GIFs**, down from 280. The Laurent page went from 27 to 8.

## How your round-6 decisions were applied

- **R6-A (Muller).** Case 3 now zooms each frame on the current points, marks the axis crossing with an open red circle, and has an inset showing the step. The step shrinks from 0.13 to 5.5 × 10⁻⁵ over the nine frames. Cases 1 and 2 are unchanged.
- **R6-B (Laurent).** The 27 all-Taylor cases and the "Laurent = Taylor" legend are gone. The page has 8 cases, all about 0:

  | Case | Function | Region | What it shows |
  |---|---|---|---|
  | 01 | sin(x)/x | all x | Reduces to Taylor (removable singularity) |
  | 02 | 1/(1+x²) | \|x\| < 1 | Reduces to Taylor |
  | 03 | sin(x)/x³ | 0 < \|x\| | Vertical asymptote |
  | 04 | (x²+1)/(x²−1) | \|x\| > 1 | Horizontal asymptote |
  | 05 | 4/((x−1)(x+3)) | \|x\| < 1 | Same function, disk: Taylor |
  | 06 | 4/((x−1)(x+3)) | 1 < \|x\| < 3 | Same function, annulus: both kinds of power |
  | 07 | 4/((x−1)(x+3)) | \|x\| > 3 | Same function, exterior: negative powers only |
  | 08 | e^(1/x) | 0 < \|x\| | Infinitely many negative powers, both asymptotes |

  - Each frame shades the region of convergence and draws the asymptotes.
  - Cases 03, 04 and 06–08 add a Taylor polynomial with the same number of terms, so the reader sees it fail where the Laurent sum holds.
  - The examples are the page's own. The page says so, and says that Mathews' module (Complex Analysis §7.3) has no animations. His formula images are missing from the local archive, so no function is attributed to him.
- **R6-C (Accelerated Newton).** F1 is deferred, and Case 1 is unchanged. F2 is fixed: the intro now says one method per animation.
- **R6-D (Maclaurin).** F1 is deferred. The page is unchanged.
- **R6-E (the other Minor findings).**
  - **Padé:** off-scale approximants now leave the frame instead of running along its edge. The clamp moved to one y-span beyond the axes. All 27 GIFs changed. The pole lines are as they were (R5-C).
  - **Chebyshev:** green dashed lines mark the interval ends in all 29 GIFs, as in Mathews' animations. The intro says the curve outside them is extrapolation.
  - **B-Splines:** the disclosure paragraph now gives the reason for the page's own examples.
  - **Tangent Parabola:** the hold frames draw T₂ once, with one legend entry.

## For you to decide or revisit

- **Muller Cases 1 and 2 still say the inset "magnifies" the step or vertex.** In Case 2's frame 1 the inset is actually a reduced view (0.47× in x, 0.52× in y). Case 1 was not measured. Case 3 was corrected to "shows". The other two are outside R6-A, so they are unchanged.
- **Two pages have no `## Description` section:** Muller and Tangent Parabola. This predates the run, and no finding covers it.
- **Two findings stay deferred:** Accelerated Newton F1 and Maclaurin F1. The next review will report them again unless its brief says they are decided.

## Process notes

- **Muller went back once.** The checker found that "magnifies" was false for Case 3's frame 1. The text and two script comments now say "shows".
- **Laurent went back once, then took one director edit.**
  - The checker's first pass raised three wording problems, which the fixer corrected.
  - The second pass raised one more: the Case 07 alt text said the polynomial leaves the curve "just past" x = 9, when it leaves before 9.
  - To stay within the two-round limit, the director made that one-word change after recomputing the values (at x = 9, T₁₁ = −0.0833 against f = 0.0417). **That word did not get a third independent check.**
- **Tangent Parabola went back once, before its check.** The director's brief asked for identical pixels in frames 1–17, and the fixer added about 15 lines of GIF palette code to achieve it. The requirement was too strict, so the code was removed. The rendered frames 1–17 are identical. The encoded GIF frames are re-dithered.
- **Padé comment.** After the Laurent rebuild, a Padé script comment wrongly said the Laurent page shares its coefficient routine. It was corrected in a separate commit.

## Commits (8, oldest first)

`37ccae3 248408e a59256f c49ba08 e32f530 20ca25f 65ee2b3 84a056d`. This README is in a separate commit after these.

The round-6 report is `cec4b1b`. Decisions R6-A to R6-E are in `73a2e02`.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r7`.
