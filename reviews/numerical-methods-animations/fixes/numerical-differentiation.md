# Fix record: numerical-differentiation

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/numerical-differentiation/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

- `values.jl` (`julia values.jl` → `$FIX/values.out`): instrumented copy of the computations of both scripts, no plotting. Prints the old and new title numbers, the drawn line's miss at the stencil points before and after the fix.
- `indep.py` (`/usr/bin/python3 -I indep.py` → `$FIX/indep.out`): independent check with mpmath at 40 digits and sympy derivatives.
- `title_strings.jl` (`julia title_strings.jl` → `$FIX/title_strings.out`): the exact title strings the fixed scripts build.
- Frames: `$FIX/orig_aa`, `$FIX/orig_ab` (committed GIFs before the fix), `$FIX/new_aa`, `$FIX/new_ab` (regenerated), `$FIX/legacy_c1`, `$FIX/legacy_c2` (Mathews' animations). `$FIX/trial/` holds a scratch trial of the top margin.

## Findings

### F1 — Error — fixed

- **Reproduced:**
  - Full-size committed frames `$FIX/orig_aa/frame_010.png` and `frame_012.png`: the titles end at "max error ≈ 8.0" and "max error ≈ 0"; the right end of the title is cut off.
  - `values.jl`: the strings drawn were `round(maxerr; digits=6)` = 3.3e-5, 8.0e-6, 1.0e-6, 0.0 for h = 0.01, 0.005, 0.002, 0.001; the true max errors are 3.332970e-05, 8.333105e-06, 1.333327e-06, 3.333330e-07.
  - `indep.py` (mpmath, same 700-point grid on [h, π−h]) agrees: 3.33297e-5, 8.33311e-6, 1.33333e-6, 3.33333e-7. The maximum is at x = h in every frame, maxerr/h² → 0.333333, and the max error decreases in every frame.
  - The checker's correction holds: frame 12's "0" comes from `round(3.33e-7; digits=6) = 0.0`, not only from clipping. Both causes were fixed.
- **Change:** `numdiffaa.jl`
  - added `using Printf` (standard library);
  - title `"Three-Point Central Difference on [0, pi]  |  h = $(h)  |  max error ≈ $(round(maxerr; digits=6))"` → two lines, `"Three-Point Central Difference on [0, pi]\nh = $(h),  max error ≈ $(@sprintf("%.2e", maxerr))"`;
  - added `top_margin=3Plots.mm` so the second title line does not touch the plot frame (without it the line sat on the top border; checked in a scratch trial).
- **Check:** regenerated `numdiffaa.gif`; full-size `new_aa/frame_001.png`, `frame_009.png`, `frame_012.png` and the contact sheet show the whole title. The 12 titles read 6.81e-02, 2.77e-02, 1.28e-02, 3.30e-03, 1.63e-03, 8.31e-04, 3.00e-04, 1.33e-04, 3.33e-05, 8.33e-06, 1.33e-06, 3.33e-07, which equals `title_strings.out` and the mpmath values rounded to 3 significant figures (`indep.out`).

### F2 — Misleading — fixed

- **Reproduced:**
  - `values.jl`: the old dashed line `y0 + msec(x − x0)` misses both outer stencil points by +0.07814 (h = 0.6), +0.03311 (0.4), +0.01262 (0.25), +0.00450 (0.15).
  - `indep.py`: (f(x0−h)+f(x0+h))/2 − f(x0) = −0.07814, −0.03311, −0.01262, −0.004498 for the same h; f''(1)/2 = −0.19877, so the gap is ≈ h²f''(x0)/2.
  - Committed `orig_ab/frame_001.png`: the orange points at x = 0.4 and 1.6 sit below the dashed line.
- **Change:** `numdiffab.jl`
  - `secant_y = y0 .+ msec .* (line_x .- x0)` → `secant_y = yl .+ msec .* (line_x .- xl)`, with a comment. This is the chord through (x0−h, f(x0−h)) and (x0+h, f(x0+h)). Its slope is unchanged: (yr−yl)/(2h).
  - Legend `"central secant slope"` → `"central secant (chord through x0 ± h)"`.
  - `index.qmd:40` alt text: "central secant lines collapsing to the tangent line …" → "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line …".
  - The Behavior sentence (index.qmd:36) is unchanged. It speaks of the slope of the symmetric secant, which is now exactly what is drawn, and its claim is confirmed (ledger).
- **Check:**
  - `values.jl`: the new line misses the stencil points by 0 (≤ 2.8e-17) in every frame.
  - `new_ab/frame_001.png` and `frame_002.png` at full size: the dashed line passes through both outer orange points.
  - `frame_011.png`, `frame_012.png`: the chord and tangent coincide at plot resolution.
  - `indep.py`: chord minus tangent at the ends of the drawn window x0 ± 0.9 is (−0.133, −0.0228) at h = 0.6 and shrinks in every frame to (−3.51e-7, −4.63e-8) at h = 0.001. A linear difference is largest at an end of the window, so the chord approaches the tangent line over the whole drawn segment.

### F3 — Minor — fixed

- **Reproduced:** `values.jl`: `round(maxerr; digits=6)` gives "8.0e-6", "1.0e-6", "0.0" for true 8.333105e-06, 1.333327e-06, 3.333330e-07; maxerr/h² = 0.33332, 0.33333, 0.33333.
- **Change:** same title edit as F1: `@sprintf("%.2e", maxerr)`.
- **Check:** frames 10–12 read 8.33e-06, 1.33e-06, 3.33e-07 (`new_aa/sheet.png`, `frame_012.png`). These are the mpmath values to 3 significant figures (`indep.out`), so the ratio of about 4 per halving of h is visible: 3.33e-05 → 8.33e-06 for h = 0.01 → 0.005.

### F4 — Minor — fixed

- **Reproduced:** committed `orig_ab/frame_001.png` ends "true = -0.11079" and `frame_012.png` ends "true = -0.1107" (clipped). The full value is f'(1) = −0.110793765306699 (`indep.py`, `values.jl`).
- **Change:** `numdiffab.jl`
  - The title is now two lines: `"Derivative at x0 = 1,  h = $(h)\nsecant slope ≈ …,  true = …"`, with `top_margin=3Plots.mm`.
  - Both numbers use `@sprintf("%.6f", …)` (added `using Printf`). The old `round(…; digits=6)` printed "-0.11037" (h = 0.05) and "-0.11079" (h = 0.005) because it drops the trailing zero. Those values were correct, but with the full title visible, "-0.11079" next to "true = -0.110794" looked like a 5-decimal number.
- **Check:** `title_strings.out` and `new_ab/sheet.png` show all 12 titles in full. The slopes are −0.049354, −0.083592, −0.100189, −0.106979, −0.109099, −0.109963, −0.110370, −0.110641, −0.110726, −0.110777, −0.110790, −0.110794 and true = −0.110794; all equal the mpmath values rounded to 6 decimals (`indep.out`, column round6). Full-size `frame_011.png`: "secant slope ≈ -0.110790, true = -0.110794".

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| numdiffaa.jl title, line 1 | "Three-Point Central Difference on [0, pi]" | Unchanged wording, moved to its own line. The script plots `central3` = (f(x+h)−f(x−h))/(2h) on [0, π] | yes |
| numdiffaa.jl title, line 2 | "h = $(h),  max error ≈ %.2e" → 6.81e-02 … 3.33e-07 (12 values above) | `title_strings.jl` → the 12 strings. `indep.py` (mpmath, same grid) → 0.0680654, 0.0276667, 0.0128333, 0.00329947, 0.001625, 0.000831131, 0.00029971, 0.000133276, 3.33297e-5, 8.33311e-6, 1.33333e-6, 3.33333e-7. Each rounds to the shown value | yes |
| numdiffab.jl title, line 1 | "Derivative at x0 = 1,  h = $(h)" | x0 = 1.0 and the 12 h values are from the script's `hs`. No frame is skipped: x0 ± 0.6 lies inside [0, π] | yes |
| numdiffab.jl title, line 2 | "secant slope ≈ %.6f" → −0.049354 … −0.110794 | `indep.py` → slope −0.0493537427, −0.0835918101, −0.100189411, −0.10697946, −0.109098977, −0.109963411, −0.110370137, −0.110641265, −0.110725988, −0.110776821, −0.110789529, −0.110793596. Each rounds to the shown value (`title_strings.out`) | yes |
| numdiffab.jl title, line 2 | "true = -0.110794" | `indep.py` → f'(1) = −0.110793765306699; sympy f' = √2 e^{−x} cos(x+π/4) | yes |
| numdiffab.jl legend | "central secant (chord through x0 ± h)" | `values.jl` → drawn line misses (x0−h, f(x0−h)) and (x0+h, f(x0+h)) by 0 and ≤ 2.8e-17 in all 12 frames; slope = msec | yes |
| numdiffab.jl comment | "chord through (x0-h, f(x0-h)) and (x0+h, f(x0+h))" | same as the row above | yes |
| index.qmd:40 alt text | "central secant lines through the points at x0 minus h and x0 plus h" | same as the legend row; frames 1–4 of `new_ab` show the dashed line through both outer orange points | yes |
| index.qmd:40 alt text | "collapsing to the tangent line at x0 equals 1" (wording kept, now about the chord) | `indep.py` → the chord's gap to the tangent at the window ends decreases in every frame: from (−0.133, −0.0228) at h = 0.6 to (−3.51e-7, −4.63e-8) at h = 0.001. Its gap at x0 is −0.07814 → −1.988e-7 | yes |
| index.qmd:36 (unchanged, rechecked) | "slope from the symmetric secant … converges to the tangent slope f'(x0)" | `values.jl` → slope − f'(1) = +6.144e-2, +2.720e-2, …, +4.236e-6, +1.694e-7: decreasing in every frame | yes |
| index.qmd:28 (unchanged, rechecked) | "approaches f'(x) as h shrinks, consistent with second-order truncation error" | `indep.py` → max error decreases in every frame, and maxerr/h² = 0.272, 0.307, …, 0.333333 → 1/3 = f'''(0)/6 (sympy f'''(0) = 2) | yes |

## Scripts and GIFs

- **Scripts changed:** `numdiffaa.jl` and `numdiffab.jl`. Both now use `using Printf` (standard library); no package was added. The `@__DIR__` output paths are unchanged.
- **GIFs regenerated:** `numdiffaa.gif` and `numdiffab.gif`, by `julia numdiffaa.jl` and `julia numdiffab.jl` in the page folder. Each has 12 frames.
- **Frames viewed at full size:**
  - `new_aa`: frames 1, 9 and 12, plus the sheet. The titles are complete and clear of the frame, the numbers are as in the ledger, and D3 approaches f' visibly in frames 1–3.
  - `new_ab`: frames 1, 2, 11 and 12, plus the sheet. The chord passes through both outer stencil points, the titles are complete and the chord merges with the tangent.
- **Byte check:** the regenerated `numdiffaa.gif` is byte-identical to the scratch trial `$FIX/trial/t1.gif`, made from the same code (`cmp`).
- `git status --short -- pages/numerical-methods/numerical-differentiation` →

  ```
   M pages/numerical-methods/numerical-differentiation/index.qmd
   M pages/numerical-methods/numerical-differentiation/numdiffaa.gif
   M pages/numerical-methods/numerical-differentiation/numdiffaa.jl
   M pages/numerical-methods/numerical-differentiation/numdiffab.gif
   M pages/numerical-methods/numerical-differentiation/numdiffab.jl
  ```

  These are the expected files only.

## Legacy archive

Consulted.

- **`n2003/NumericalDiffMod.html`** uses the same f(x) = e^{−x} sin x. The three-point central rule has the remainder −h²f'''(c)/6.
  - Example 2 uses step sizes h = 0.1, 0.01, 0.001.
  - Example 4 (`Links/NumericalDiffMod_lnk_7.html`) tabulates the error bound EB1[h] = h²/3 for h = 0.08, 0.04, 0.02, 0.01, with values 0.0021333, 0.0005333, 0.0001333, 0.0000333.
  - That agrees with our computation: max |f'''| on the interval is f'''(0) = 2 (sympy), so the bound is h²/3, and the measured maxerr/h² → 0.333333.
- **Animations** (`a2001/Animations/Derivative/`, frames in `$FIX/legacy_c1`, `$FIX/legacy_c2`). Mathews has two central-difference animations at x0 = 1, with h = 1.0, 0.8, 0.6, 0.4, 0.2, 0.08, 0.04, 0.008, 0.001.
  - Module 1 (`CentralD2.1f/CentralD1faa.gif`) draws the line through (1, f(1)) with the central-difference slope, together with the interpolating parabola through the three points. That line is the parabola's tangent at x0.
  - Module 2 (`CentralD2.2f/CentralDfaa.gif`) draws the chord through the two outer points.
  - The repo's original drawing was Module 1's line without the parabola, labelled "secant". The fix follows Module 2: the actual chord, which matches the page's word "secant".
  - Mathews' labels f'[1] ≈ −0.049354 (h = 0.6) and −0.083592 (h = 0.4) agree with our computed slopes (`indep.out`).
- No difference between the archive and the fixed page needed resolving.

## Notes

- Not a finding, not touched: in `numdiffab.gif` the legend entry for the label "f(x) = e^{-x} sin(x)" renders only as "f". The round-1 checker also noted this, in an aside in `evidence/numerical-differentiation/verify.md`. It was present before this fix and is unchanged.
- The page's Description already states "representative steps h = 0.1, 0.01, 0.001" from Mathews' Example 2; the animation uses a longer list of h, which includes those three. No change.
- `top_margin=3Plots.mm` was added beyond the suggested fix. Without it, the second title line touched the top border of the plot (checked in the first regeneration, before the margin was added).

## Resolution check (independent checker, not shown this record)

Work files: `check/vals.py` (mpmath, 40 digits), `check/run/` (scratch copies of both scripts and their output), `check/frames_numdiffaa/`, `check/frames_numdiffab/` (new GIF frames), `check/old_*.gif` and `check/oldframes_numdiffab/` (HEAD GIFs via `git lfs smudge`, for before/after).

### Original findings

### F1 — resolved
- The title is now two lines (`"Three-Point Central Difference on [0, pi]\nh = $(h),  max error ≈ $(@sprintf("%.2e", maxerr))"`) with `top_margin=3Plots.mm`. I read frames 1, 10 and 12 at full size and all 12 on the contact sheet. Both title lines are fully visible in every frame, with nothing cut off on either side.
- The visible values are 6.81e-02, 2.77e-02, 1.28e-02, 3.30e-03, 1.63e-03, 8.31e-04, 3.00e-04, 1.33e-04, 3.33e-05, 8.33e-06, 1.33e-06 and 3.33e-07. I recomputed each one independently in 40-digit mpmath on the same 700-point grid over [h, π−h], and every one matches to the printed 3 significant figures. maxerr/h² goes 0.272, 0.307, 0.321, 0.330, …, 0.33333, so it is O(h²) with constant → |f'''(0)|/6 = 1/3. The sequence on screen now falls steadily, as the page's second-order claim says. The false "3.3", "8.0", "1.0" and "0" values are gone, and the checker's correction (the "0" came from rounding) is covered by the %.2e format.

### F2 — resolved
- `secant_y = yl .+ msec .* (line_x .- xl)` is the line through (x0−h, f(x0−h)) with slope (f(x0+h)−f(x0−h))/(2h). At x0+h it equals yl + msec·2h = yr exactly. My mpmath check gives a residual of 0 at x0+h for every h.
- Frame 1 (h = 0.6), full size: both outer orange markers, at (0.4, 0.261) and (1.6, 0.202), now sit on the dashed line. Before the fix (HEAD frame 1) the line passed through (1, 0.310) and missed both of them.
- At x0 the chord sits below f(x0) by −0.0781, −0.0331, −0.0126, −0.0045, −0.0020, …, −2.0e-7 (≈ h²f''(1)/2). This matches the offsets in the finding, and it shrinks to 0, so the chord visibly collapses onto the tangent (frames 4–6 nearly coincide, frames 7–12 are indistinguishable).
- The legend now reads "central secant (chord through x0 ± h)", and the alt text (index.qmd:40) says "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line". Both are true of what is drawn.

### F3 — resolved
- `round(maxerr; digits=6)` is replaced by `@sprintf("%.2e", maxerr)`. The last four frames show 3.33e-05, 8.33e-06, 1.33e-06 and 3.33e-07, against true values of 3.333e-5, 8.333e-6, 1.333e-6 and 3.333e-7. There is no "0.0" any more, and the h² ratio can be read off the titles (8.33e-6 → 1.33e-6 for h 0.005 → 0.002 is a ratio of 6.25 = 2.5²).

### F4 — resolved
- The title is now two lines: "Derivative at x0 = 1,  h = …" / "secant slope ≈ %.6f,  true = %.6f". Both lines are fully visible in frames 1, 6 and 12 at full size and in all 12 on the sheet. "true = -0.110794" is shown in full. That is the correct 6-decimal rounding of f'(1) = e⁻¹(cos 1 − sin 1) = −0.110793765306699, which I checked against mpmath numerical differentiation. All 12 secant slopes on screen (−0.049354, −0.083592, −0.100189, −0.106979, −0.109099, −0.109963, −0.110370, −0.110641, −0.110726, −0.110777, −0.110790, −0.110794) match my mpmath values. The final frame now reads −0.110794 against −0.110794, which agrees with the true error (≈1.7e-7).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| numdiffaa.jl:44 title line 1 | "Three-Point Central Difference on [0, pi]" | Unchanged wording; formula (f(x+h)−f(x−h))/(2h) is the three-point central difference | correct |
| numdiffaa.jl:44 title line 2 | "h = $(h),  max error ≈ %.2e" (12 values listed under F1) | 40-digit recompute on same grid; all 12 match at 3 s.f. | correct |
| numdiffaa.jl:43 | `top_margin=3Plots.mm` | Frames: two-line title fits, not clipped | correct |
| numdiffab.jl:89 | chord through (xl,yl) with slope msec | Residual at (xr,yr) = 0; frame 1 markers on the line | correct |
| numdiffab.jl:89 comment | "chord through (x0-h, f(x0-h)) and (x0+h, f(x0+h))" | Same as above | correct |
| numdiffab.jl:108 title line 1 | "Derivative at x0 = 1,  h = …" | x0 = 1.0 in script; h values match hs | correct |
| numdiffab.jl:108 title line 2 | "secant slope ≈ %.6f" (12 values) | mpmath (f(1+h)−f(1−h))/(2h); all 12 match | correct |
| numdiffab.jl:108 title line 2 | "true = -0.110794" | e⁻¹(cos1−sin1) = −0.1107937653 | correct |
| numdiffab.jl:111 legend | "central secant (chord through x0 ± h)" | The drawn line is exactly that chord | correct |
| index.qmd:40 alt text | "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line at x0 equals 1 for f of x equals e to the minus x times sine x" | Chord passes through both outer points; slope → f'(1), offset at x0 ~ h²f''/2 → 0; f and x0 match script | correct |
| numdiffaa.jl:6, numdiffab.jl:57 | `using Printf` | Required for @sprintf; scripts run cleanly | correct |

### New problems

None introduced by the fix. This rests on:
- full-size reading of the first, middle and last frames of both GIFs and of all 12 frames on the contact sheets;
- 40-digit recomputation of every number on screen;
- checking that nothing previously correct changed. Curves, the tangent line, stencil points, axes, limits, the frame count (12 and 12) and the legend positions are all unchanged.

The two-line titles do not overlap the plot area or the legend.

Pre-existing observation, not caused by the fix and not in the original findings (for the record only): the numdiffab legend entry for the curve renders as just "f", although the script label is "f(x) = e^{-x} sin(x)". GR appears to truncate it. The HEAD GIF shows the same "f". It is not false, only terse.

### Reproducibility and conventions

- Both changed scripts ran from scratch copies in `check/run/`. Output SHA-256 values: numdiffaa.gif d24b20d4…b332 and numdiffab.gif a89daf1b…76b1. These are byte-identical to the committed (working-tree) GIFs and match the LFS pointer oids in the diff.
- index.qmd still has Description before Animations, one "[Julia source]" link and one GIF embed per case (2 cases), descriptive alt text on both embeds, and no code blocks.
- The page diff touches only files inside `pages/numerical-methods/numerical-differentiation/`. The working tree also has modifications in other page folders (other pages' fixes on this branch) and an untracked `reviews/numerical-methods-animations/fixes/numerical-differentiation.md` (a workflow note, not site content). Nothing outside the page folder belongs to this page's fix.

**Final status:** committed
