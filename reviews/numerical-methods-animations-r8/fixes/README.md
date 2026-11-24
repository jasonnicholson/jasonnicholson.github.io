# Fix run — numerical-methods animations (round 8)

Run of 2026-11-24 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r8`. Nothing was pushed.

## Headline

- **Round-8 findings:** 3, made up of 0 Error, 1 Misleading and 2 Minor.
  - **2 are fixed**, on 3 pages. Both fixes are a change to one sentence, and no script or GIF changed.
  - **1 is deferred** under your earlier decision: Maclaurin F1 (order cutoff, R6-D). The Maclaurin page is unchanged.
  - None was `not reproduced` and none is `open`. Both fixers reproduced their finding before changing anything.
- **Each fix passed an independent resolution check at the first attempt.** The checkers saw the findings and the diff, but not the fixer's record.
- **The scripts are unchanged, and their GIFs still reproduce byte for byte** on this machine (checked for the three pages at the start of the run).
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.

| Severity | Findings | Fixed | Deferred |
|---|---|---|---|
| Error | 0 | 0 | 0 |
| Misleading | 1 | 0 | 1 |
| Minor | 2 | 2 | 0 |

## What changed

- **[Adams-Bashforth-Moulton](adams-bashforth-moulton-method.md) F1.** "(though that is still 2.6 times the exact value)" now reads "(though $y(5)$ is still 2.6 times the exact value)". At $m=12$, $y(5)=0.0214088$ is 2.64 times the exact value 0.0081199. The error is 1.64 times the exact value.
- **[Newton Interpolation](newton-interpolation-polynomial.md) F1.** One sentence was added at the end of the Animations introduction. It says that only Mathews' animations for Cases 01 and 04 survive, and that they went to degree 25 and degree 20. It also says they drew a yellow "Tolerance ±0.05" bar over an interval on which the interpolant is within 0.05 of $f$, while these frames stop at degree 15 with no bar.
  - Under R8-B, the **Lagrange page has the same sentence**, because it shows the same animations from the same script. Both pages are covered by one fix record.
  - The fixer counted the node markers in the legacy frames, which settles that Mathews' subscript $n$ in $S_n$ is the degree. It also measured the bar's ends against a high-precision interpolant: they match the set where $|S_n - f| < 0.05$ to within a few pixels.
  - Case 04's animation ends at $S_{20}$. The round-8 Lagrange reviewer's note gave $S_{19}$, which is wrong.

## For you to decide or revisit

- **R8-A and R8-B are the director's defaults**, recorded in the fix plan. Each fix took the review's smallest correct option (R7-D): text only, with no higher degrees and no drawn band.
  - If you would rather have the animations go to Mathews' degrees or draw the band, that is a script change to `lagnewt_animations_all.jl` and both pages' 58 GIFs.
  - Adding the sentence to the Lagrange page goes slightly beyond the finding, which named only Newton. It is one sentence and easy to drop.
- **Maclaurin F1** stays deferred under R6-D. This round's review rated it Misleading, where earlier rounds called it Minor.
- **Not in scope:** the review's "Noted by reviewers, not counted" items were left alone.
- **Stray files:** the untracked `index_files/` from an earlier `quarto preview` is still in `pages/numerical-methods/numerical-differentiation/`. It was not staged.
- **The round-7 and round-8 review reports are not committed.** Their page reports and READMEs are untracked. This folder's `fixes/` and `fix-plan/` are committed.

## Process notes

- **No MATLAB.** Every fixer and checker brief this round said not to run MATLAB, and none did.
- **Pilot:** with only two fixes, both pages were run straight through. Both records showed the finding reproduced and every number in the new text computed, so neither went back.
- **The legacy archive was found and used.** The two surviving animations are `Lagrangeaa.gif` (Case 01) and `Lagrangedd.gif` (Case 04) under `a2001/Animations/Interpolation/Lagrange/`. `Lagrange09/Lagrangeii.gif` is an HTML page, not a GIF.

## Commits (4, oldest first)

`5f578b4` (decisions R8-A and R8-B), `d17dc76` (Adams-Bashforth-Moulton), `658445a` (Lagrange and Newton Interpolation). This README is in a separate commit after these.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r9`.
