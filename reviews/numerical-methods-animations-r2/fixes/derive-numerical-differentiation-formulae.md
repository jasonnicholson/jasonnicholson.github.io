# Fix record: derive-numerical-differentiation-formulae

Scratch folder (all evidence scripts and frames): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/derive-numerical-differentiation-formulae/fix/` (below: `$S`).
- `$S/instr.jl`: Julia replica of the scripts' formulas; prints Case 2 err3/err5 and the line-end gaps 0.9·err, and the Case 3 window maxima and argmax.
- `$S/indep.py`: independent Python check (numpy Float64 replica plus an mpmath 40-digit truncation-only maximum, and a sympy check of f'').
- `$S/pix.py`: counts dark-green (0,100,0) and crimson (220,20,60) pixels per frame, inside and outside the legend box (x > 520, y < 130).
- `$S/scale.py`: finds the grid-line rows to get the pixel scale of Case 2.
- `$S/orig/`: copies of the committed scripts and GIFs before the fix. `$S/frames_*_orig`, `$S/frames_*_new`: extracted frames, sheets, framemd5.

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I $S/pix.py $S/frames_ab_orig` on the committed `diffformab.gif`. All 11 frames have 47 green pixels, all inside the legend, and 0 outside it. Crimson pixels outside the legend number 589–608. `julia $S/instr.jl`: |err5| = 1.919e-4 at h = 0.35 and decreases in every later frame down to 2.161e-13. The largest vertical gap between the five-point line and the tangent at the segment ends (x0 ± 0.9) is 0.9·|err5| = 1.727e-4 y-units.
- Change: `diffformab.jl` lines 56–60. The true tangent is now drawn before the two estimate lines, with lw 2 → 5. The dashed three-point line is drawn next and the green five-point line last (lw 2, unchanged), so the green line is visible lying on the red tangent. A 2-line comment explains why. The legend order is now f(x), five-point stencil, true tangent, three-point estimate, five-point estimate. `index.qmd` Case 2: one sentence added to Behavior, and the alt text was rewritten to say what is actually visible (see ledger).
- Check: `pix.py` on the regenerated GIF gives 546–607 green pixels outside the legend in every frame (frame 1: 546, frame 11: 603). Crimson pixels outside the legend number 564–747 in every frame, so both lines are visible. Frames 1, 4 and 11 were viewed at full size, and the contact sheet for all 11. The green line runs along the centre of the red band, and the dashed blue line separates from it visibly at h = 0.35 and 0.25.

### F2 — Minor — fixed
- Reproduced: `julia $S/instr.jl` (Case 3 section). The window is [2h, π−2h], e.g. [0.7000, 2.4416] at h = 0.35. The five-point argmax is the left window end x = 2h for every h from 0.35 to 0.005, and the interior x = 0.7840 at h = 0.002. Frame 1 of the committed GIF shows the stencil curves starting at x = 0.70, while the title said "on [0, pi]".
- Change: chose the text-and-title fix, not re-evaluating the stencils on [0, π]. It is the smaller change, and it leaves the page's verified numbers (5.5e-11 → 5.9e-11) and the rounding explanation valid. Changes:
  - `diffformac.jl` line 47, title "Second-derivative formulas on [0, pi]" → "Second-derivative formulas on [2h, pi-2h]".
  - `index.qmd`: the Case 3 heading `$[0,\pi]$` → `$[2h,\pi-2h]$`.
  - Behavior first sentence: "over [0,π]" → "on [2h,π−2h], where both stencils use only points in [0,π]; the maximum errors in each frame are taken over this window".
  - The alt text now says that the exact curve is on 0 to pi and the stencil curves are on 2h to pi minus 2h.
- Check: the regenerated frames 1 and 11 were viewed at full size. The title reads "Second-derivative formulas on [2h, pi-2h] | h = 0.35" (and "h = 0.002") and fits the frame. The annotation values are unchanged (1.31e-02 / 5.16e-04; 4.30e-07 / 5.89e-11). Only the title changed: the frame md5s differ in all 11 frames, as expected.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 2 Behavior, new sentence | "the green five-point line already lies on the red true tangent at h=0.35" | `pix.py $S/frames_ab_new` → green outside legend 546 in frame 1, and the line is visible on the red band in the full-size frame 1 | yes |
| same | "the two lines differ by about 0.1 pixel at their ends" | `instr.jl` → gap5 = 0.9·err5 = 1.727e-4 at h = 0.35. `scale.py` → grid rows 56, 116, 176, 236, 296, 356 for y = 0.5…0.0, i.e. 600 px per unit. 1.727e-4 × 600 = 0.104 px | yes |
| same | "the size of the five-point error is read from the \|err5\| value printed in each frame" | All 11 frames print "\|err5\|≈…" (contact sheet). Values 1.92e-04 … 2.16e-13 match `instr.jl` and the review's mpmath table | yes |
| index.qmd Case 2 alt text | "dashed three-point slope line approaching the true tangent" | `instr.jl` → gap3 strictly decreasing over the 11 frames, 1.873e-2 → 6.100e-7 | yes |
| same | "five-point slope line lying on the true tangent in every frame" | gap5 is largest at h = 0.35 (0.104 px) and decreasing after. Green is visible outside the legend in all 11 frames (546–607 px) | yes |
| same | "with both errors printed" | annotation "\|err3\|≈…, \|err5\|≈…" in every frame (sheet) | yes |
| diffformab.jl comment | "differ by at most \|err5\| = 1.92e-4" (slope difference) | `instr.jl` → max err5 = 1.919e-4 at h = 0.35 | yes |
| index.qmd Case 3 heading | "second-derivative formulas on $[2h,\pi-2h]$" | `diffformac.jl` `xinner = range(2h, pi-2h)`; `instr.jl` windows [0.7000, 2.4416] … [0.0040, 3.1376] | yes |
| index.qmd Case 3 Behavior | "on $[2h,\pi-2h]$, where both stencils use only points in $[0,\pi]$" | The widest stencil point is x ± 2h; for x ∈ [2h, π−2h], x − 2h ≥ 0 and x + 2h ≤ π | yes |
| same | "the maximum errors in each frame are taken over this window" | `err3`/`err5` = `maximum` over `xinner` (script lines 29–30). `indep.py` reproduces them on the same 700-point grid: 1.306e-2/5.158e-4 (h = 0.35) … 4.299e-7/5.892e-11 (h = 0.002) | yes |
| same (unchanged numbers kept) | "From h=0.35 to h=0.005 both maximum errors shrink … five-point stays closer in every frame … rises from 5.5e-11 to 5.9e-11 … rounding" | `indep.py` → err3 and err5 are strictly decreasing to h = 0.005, and err5 < err3 is True in all 11 frames. err5: 5.516e-11 (h = 0.005) → 5.892e-11 (h = 0.002). mpmath truncation-only at h = 0.002 = 1.42e-12 ≪ 5.89e-11 | yes |
| index.qmd Case 3 alt text | "exact curve on 0 to pi and the stencil curves on 2h to pi minus 2h" | script: `xtrue = range(0, pi)`, `xinner = range(2h, pi-2h)`. Frame 1 shows the curves starting at 0.70 | yes |
| diffformac.jl title | "Second-derivative formulas on [2h, pi-2h]  \|  h = $(h)" | Same as the heading. Full-size frames 1 and 11 show the title fully inside the frame | yes |

## Scripts and GIFs
- Scripts changed: `diffformab.jl` (draw order and tangent width) and `diffformac.jl` (title). `diffformaa.jl` is untouched.
- GIFs regenerated in place with `julia diffformab.jl` and `julia diffformac.jl`. Each has 11 frames, as before.
- Frames viewed:
  - diffformab: 1, 4 and 11 at full size, plus the sheet of all 11. Checked the green line on the tangent, the dashed three-point line, the legend entries and that the annotation values match `instr.jl`.
  - diffformac: 1 and 11 at full size, plus the sheet. Checked that the title fits, the annotation values are unchanged, and the curves start at 2h.
- `git status --short -- pages/numerical-methods/derive-numerical-differentiation-formulae` after regeneration: `M diffformab.gif`, `M diffformab.jl`, `M diffformac.gif`, `M diffformac.jl`, `M index.qmd`. `diffformaa.gif` is unchanged.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NumericalDiffFormulaeMod.html` (the `differentiationformulae/` folder holds only its Images/Links). The module is a symbolic derivation, solving the Taylor "linear system" with Mathematica's Solve for f′ and f″ in parallel. It has no animation and no numerical test function, so it fixes no parameter or picture element relevant to F1 or F2. No R2-A change applies.

## Notes
- F2: I chose the brief's first option (state the window) over re-evaluating the stencils on all of [0, π], because it is the smaller change and keeps the verified numbers valid.
- The review's independent-check lines were "not run" for both findings, so both were reproduced here first (see above).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `diffformab.jl` now draws the crimson tangent first at lw=5, then the dashed three-point line, then the dark-green five-point line (lw=2) last. Pixel count of dark-green (RGB about (0,100,0)) in the decoded frames: the pre-fix GIF has 47 green pixels per frame, all inside the legend (x>520, y<130), and 0 outside it, in all 11 frames (this reproduces the finding). The fixed GIF still has 47 in the legend and 546–607 green pixels outside the legend in every one of the 11 frames. Frames 1, 6 and 11 at full size show a green stripe running along the middle of the thicker red tangent, with the dashed blue line visibly off it in frame 1. With tolerance, the only pixel changes from old to new are in the line region (rows 74–233, cols 84–717), which includes the legend swatch. The page also adds a sentence saying the green line already lies on the tangent at h=0.35 and that the five-point error is read from the printed |err5|. That sentence is checked below.

### F2 — resolved
- Evidence: The heading, Behavior text, alt text and GIF title now all say [2h, π−2h], matching `xinner = range(2h, pi-2h)`. The text now says the maxima are taken over this window. The title in the regenerated frames reads "Second-derivative formulas on [2h, pi-2h] | h = …" (frames 1, 6 and 11 viewed). The black f'' curve still spans [0, π]. The stencil curves start at 0.70 in frame 1, and the alt text describes exactly that split. The added claim "both stencils use only points in [0,π]" holds: the stencil span x−2h…x+2h over the window is exactly [0, π] for every h. With tolerance, the GIF's only change outside palette jitter is in the title rows (0 differing pixels below row 28). The existing numbers (5.5e-11 → 5.9e-11) are moving-window values, and the text now says that is the quantity, so they are consistent (see ledger).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 2 Behavior | "green five-point line already lies on the red true tangent at h=0.35" | The slopes differ by 1.919e-4 at h=0.35 (numpy; mpmath confirms f'). Over half-length 0.9 that is an end offset of 1.727e-4 y-units. Gridlines are 60 px per 0.1, so 600 px/unit. | True |
| index.qmd Case 2 Behavior | "differ by about 0.1 pixel at their ends" | 1.727e-4 × 600 = 0.104 px | True |
| index.qmd Case 2 Behavior | "size of the five-point error is read from the \|err5\| value printed in each frame" | The annotation prints \|err5\| in every frame: 1.92e-04 … 2.16e-13, matching independent values 1.919e-4 … 2.137e-13 | True |
| index.qmd Case 2 alt | "dashed three-point slope line approaching the true tangent" | \|err3\| falls monotonically from 2.08e-2 to 6.78e-7. The end offset falls from 1.87e-2 (about 11 px) to sub-pixel. | True |
| index.qmd Case 2 alt | "five-point slope line lying on the true tangent in every frame ... with both errors printed" | The largest offset is 0.10 px at h=0.35. Green is visible on the tangent in all 11 frames. Both errors are annotated. | True |
| index.qmd Case 3 heading | "second-derivative formulas on $[2h,\pi-2h]$" | Matches `xinner` | True |
| index.qmd Case 3 Behavior | "on $[2h,\pi-2h]$, where both stencils use only points in $[0,\pi]$" | min(x−2h)=0 and max(x+2h)=π | True |
| index.qmd Case 3 Behavior | "maximum errors in each frame are taken over this window" | The script computes err3 and err5 as maxima over `xinner`. Independent values: err3 1.306e-2 … 4.299e-7, err5 5.158e-4 … 5.892e-11, matching the GIF annotations (1.31e-02/5.16e-04, 2.69e-04/5.00e-07, 4.30e-07/5.89e-11) | True |
| index.qmd Case 3 Behavior (unchanged numbers, context) | "both maximum errors shrink" from h=0.35 to 0.005; five-point closer in every frame; at h=0.002 err5 rises 5.5e-11 → 5.9e-11 because of rounding | Both errors are monotone over the first 10 h values, and err5<err3 in all frames. Moving-window err5 is 5.516e-11 → 5.892e-11. At 40 digits (mpmath) the truncation-only err5 is 5.5e-11 at h=0.005 and 1.4e-12 at h=0.002, so rounding dominates at 0.002. | True |
| index.qmd Case 3 alt | "exact curve on 0 to pi and the stencil curves on 2h to pi minus 2h" | `xtrue` = [0,π] and `xinner` = [2h,π−2h]. Frame 1 shows the stencil curves starting at 0.70. | True |
| diffformac.jl title | "Second-derivative formulas on [2h, pi-2h] \| h = $(h)" | Matches the computed window. Legible in the full-size frames. | True |
| diffformab.jl comment | "the two slopes differ by at most \|err5\| = 1.92e-4" | The maximum over hs is 1.919e-4 at h=0.35 | True |
| diffformab.jl draw order / lw | tangent lw=5 first, l3 dashed, l5 green last | The green line is visible. The stencil markers sit under the lines (same order as before) and remain visible. | OK |

### New problems
None. This rests on the following:
- full-size frames 1, 6 and 11 of both changed GIFs;
- tolerance diffs against the pre-fix GIFs, showing changes confined to the intended regions (ab: the line region and legend swatch; ac: the title only);
- independent recomputation of every number shown or stated, with numpy for the float values and mpmath for f', f'' and the truncation-only error.

### Reproducibility and conventions
- Both changed scripts were run from scratch copies (`check/run/`). `diffformab.gif` and `diffformac.gif` are byte-identical (`cmp`) to the committed working-tree GIFs.
- The page keeps the conventions:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - All alt texts are descriptive.
  - There are no code blocks.
- The fix diff for this page touches only files in `pages/numerical-methods/derive-numerical-differentiation-formulae/`: the two .jl scripts, the two .gif files and index.qmd. Other modified paths in the working tree belong to other pages' concurrent fixes and to the review fix records, not to this page's diff.

**Final status:** committed
