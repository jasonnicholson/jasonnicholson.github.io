# Fix run — numerical-methods animations (round 5)

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations-r5`. Nothing was pushed.

## Headline

- **Round-5 findings:** there were 9, all Minor.
  - **7 are fixed**, across 7 pages.
  - **2 are deferred** at your decision: Padé (R5-C) and Fixed-Point (R5-E).
  - None was `not reproduced`, and none is `open`.
- **Two items you asked for under R5-F are also fixed.** Neither was a counted round-5 finding:
  - the Maclaurin "Video Animations" sentence on `abs`;
  - the Laurent pole lines.
- **8 pages are committed**, one commit each.
- **Every page went through an independent resolution check, and every check passed the first time.** No page went back to its fixer. Each checker:
  - saw the findings and the diff, but not the fixer's record;
  - recomputed every changed number;
  - looked at the regenerated frames.
- **Every committed GIF reproduces byte for byte** from a scratch copy of its script, on all 8 pages.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes with no errors or warnings.

## How your round-5 decisions were applied

- **R5-A (Muller Case 2 window).** `mullersbb.gif` now zooms each frame on the current three points, as Case 1 does since R4-A.
  - **Beyond the literal decision:** two additions, both modelled on Case 1's vertex inset. On a zoomed frame the step to the next iterate can still be too small to see, and these make it visible.
    - An open red circle marks where the parabola crosses the axis, which is the next p₂.
    - An inset magnifies that step. The step shrinks from 0.25 to 3.6 × 10⁻⁵ over the 9 frames.
  - `mullersaa.gif` and `mullerscc.gif` are unchanged.
- **R5-B (Secant Case 3).**
  - The run now stops at p₈, at 7 frames. The three guard-filled frames are gone.
  - The last label reads "p8 = 0 (double-precision result)".
  - The page adds one sentence explaining the zero. At p₆ and p₇ the computed arctan(x) equals x, so the secant passes through the origin. In exact arithmetic p₈ ≈ −7.6 × 10⁻⁴⁸.
- **R5-C (Padé poles).** No change. The finding is marked `deferred — owner decision (R5-C)`.
- **R5-D (Aitken/Neville).** The cos x case is kept. A new Case 2 animates Mathews' Example 3: eˣ at the nodes 1 + i/4 for i = 0…5, evaluated at x̂ = 1.8.
  - This adds a new script and GIF, `nevillebb.jl` and `nevillebb.gif`.
  - The tableau matches Mathews' printed one. It ends at 6.049643, against e^1.8 = 6.049647.
  - The checker recomputed the full 6×6 tableau at 40 digits from the Lagrange form.
  - The archive sentence in the Animations introduction now says which of Examples 1–7 is animated.
- **R5-E (Fixed-Point order).** No change. The finding is marked `deferred — owner decision (R5-E)`.
- **R5-F, Maclaurin.** The Video Animations sentence now says three things:
  - `abs` is continuous with a corner at 0;
  - `sign` jumps at 0;
  - the composite is continuous, and its sqrt gives an infinite derivative at 0, so the Taylor series about 0.5 has radius 0.5.

  Nothing else in Video Animations was touched.
- **R5-F, Laurent.** The curve now breaks at the poles in Cases 12 and 22–24 instead of drawing a vertical line through them.
  - Only those four GIFs changed.
  - The other 23 GIFs are byte-identical.
- **The other Minor findings** were fixed as reported:
  - **Runge-Kutta-Fehlberg:** the h_max = 0.25 cap is added to the step-size rule.
  - **Nonlinear Systems:** fixed-point iteration is described as linear when 0 < ρ < 1 and superlinear when ρ = 0.
  - **Broyden:** the final Case A residual is now "about 10⁻¹⁵ (machine precision)", both on the page and in the `broydenaa.gif` title.
  - **Maclaurin:** the M03 alt text now reads "one over the square of one minus x".

## For you to decide or revisit

- **Muller Case 2 inset and crossing marker.** They go beyond "tighten the window", for the reason given above. Say if you would rather have the zoom alone.
- **Two findings stay deferred:**
  - **Padé:** the poles in Cases 22–27 are drawn as finite spikes.
  - **Fixed-Point:** the order of Cases 4 and 5 is swapped relative to Mathews.

  The next review will report them again unless its brief says they are decided.

## Process note

- **Stray render output removed from the Muller commit.** The Muller commit first picked up a stray Quarto render, `index.html` and `index_files/`, from inside the page folder. The commit had not been pushed, so it was rebuilt without those files, and the Laurent commit was rebuilt on top of it. The stray files were then deleted.

## Commits (8, oldest first)

`020b97e c01edbe 7d9a8d5 bcb5af5 a3a7d1c abe0b81 d47f238 2f4fc2a`. This README and the final worklist statuses are in a separate commit after these.

The round-5 report is `580e299`. Decisions R5-A to R5-F are in `8039616`.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r6`.
