# Fix run — numerical-methods animations (round 4)

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r4`. Nothing was pushed.

## Headline

- **All 23 round-4 findings are fixed, across 19 pages.** Each page was independently checked and committed.
  - 1 Misleading and 22 Minor findings were fixed.
  - None was `not reproduced`, `deferred` or `open`.
- **Every page went through an independent resolution check.** The checker saw the findings and the diff, but not the fixer's record. It recomputed every changed number and sentence, looked at the regenerated frames, and reproduced every changed GIF byte for byte from a scratch copy.
  - Muller went back to its fixer once. A script comment had an off-by-one frame count, and the GIF was unaffected.
- **Changed GIFs:**
  - `mullersaa`
  - `pade01` and `pade02`
  - `halleysba`
  - `brentsaa` and `brentsbb`
  - `lagnewt14`, in both WP-B folders

  All other changes are to text or comments.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.
- **The legacy Mathews archive was used on every page with a Fidelity finding.**

## How your round-4 decisions were applied

- **R4-A (Muller F1, tighten the window):** Case 1 now zooms each frame on the current three points.
  - **Beyond the literal decision:**
    - The fixer added an inset that magnifies the vertex and prints its true height, from 8.0e-1 down to 5.4e-13. The zoom alone could not show the gap above the axis.
    - The fixer cut the run from 9 frames to 8. A ninth vertex would sit about 1e-17 above the axis, below the rounding error of f.
  - The checker found both changes justified and every label true.
- **R4-B (Muller F2):** Case 1 now has one sentence on Mathews' rule, p₃ = p₂ − 2f(p₂)/b, and his iterates 1.1091, 1.4944, 1.0558, 0.9965, …. The checker reproduced the iterates from a literal transcription of his subroutine. The page keeps its own rule.
- **R4-C (Aitken-Steffensen F1):** the Case 2 error now names its reference:
  - 6.7 × 10⁻¹⁶ (three units in the last place) against the double-precision √2, which is what the panel plots;
  - 5.7 × 10⁻¹⁶ against the exact √2.

## Notable fixes

- **Runge-Kutta (the Misleading finding):** the page now says that the upturning runs, m = 12–52, evaluate f at negative RK4 stage values, where y^{1/3} is not smooth.
  - It also says the real-cube-root convention sets the size of the upturn. A run with ∛max(y, 0) shows this: y(5) at m = 20 drops from 0.289 to 0.0054.
  - It does not claim the negative stages start every upturn, or explain m = 56, per the checker's correction.
  - The checker confirmed the convention: the real cube root reproduces all 9 of Mathews' printed y(5) values to 7 digits.
- **Taylor:** the never-reproduced "sign(y)|y|^{k/3}" explanation is removed. The page now says only what is verifiable.
- **Runge-Kutta-Fehlberg:** the page now says why Case 1 differs from Mathews' Example 1. The fixer found the review's explanation, a different acceptance rule, to be wrong. The real causes, each confirmed by the checker by changing only that one parameter:
  - his first step h₀ = 0.25 sets the error, which the problem magnifies about 1.1 × 10⁴ times;
  - his h_min = 0.001 sets the count of 120 points.
- **Padé:** off-scale approximants in Cases 01 and 02 now run along the unlabelled bottom edge of the frame (y = −0.5) instead of along the x-axis.
- **"Not animated here" lists:** these are now complete on Aitken/Neville, Numerical Differentiation and Richardson. Each was checked against every example in the module.

## For you to decide or revisit

- **Newton Interpolation F2:** the divided-differences case keeps its own cos x example with nodes kπ/3 on [0, 2π]. One computed sentence now explains how it differs from Mathews' Example 1 (nodes k/5 on [0, 1]) and why. Under R2-A you could instead switch the case to Mathews' nodes.
- **Newton Interpolation, beyond F1:** besides the requested function and interval in each case heading, the page now carries the same "degree 1 and degree 2 frames coincide" notes as the Lagrange page, for Cases 14, 18, 19, 21 and 23. No finding asked for these; they were added to match the reused alt text. The checker verified each note.
- **Not done:** the pole lines in Laurent Cases 12 and 22–24 are still drawn. You didn't answer that question, and no finding covered them.

## Commits (18, oldest first)

`97ec020 9983832 3ec245b ea7bd83 dab6baf bbbdd41 f1b2324 d54d1c7 c4b5c80 a89ffcb c4e2995 f242ca4 ef953ae 9ee23bd cc752da 6b8fbc2 dbe55f3 2b8b623` (WP-B: Lagrange and Newton). This README is in a separate commit after these.

The round-4 report is `525b1b2`. Decisions R4-A to R4-C are in `0a59cda`.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r5`.
