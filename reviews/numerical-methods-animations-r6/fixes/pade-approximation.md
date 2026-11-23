# Fix record: pade-approximation

Scratch folder (all scripts and evidence): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/pade-approximation/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced.** `julia repro.jl` (unclamped approximant on the script's 900-point grid): 524 of 1614 frames have more than 10 % of the x-range outside the y-limits, in 26 of 27 cases (case 24 has none above 10 %, but it does have clamped points). These match the review. All 27 cases have at least one clamped point. The old clamp produced 185,129 grid segments lying flat on the top or bottom limit.
- **Independent check of the review's examples** (`/usr/bin/python3 examples.py`, mpmath Taylor polynomials, same grid):
  - Case 01 [9/0] is above the window from x = 2.873 to 10.5 (review: 2.9 to 10.5).
  - Case 22 [5/0] is below the window from x = 2.791 to 5.2 (review: 2.8 to 5.2).
  - Case 22 [8/0] is above the window from x = 2.647 to 5.2.
  - Case 08 [9/0] is above from x = 5.399 to 3π and below from −3π to −5.399 on the grid. The exact crossing of y = ±1.5 is x = ±5.3785 (`brentq`). The review's "≈ 5.5" and "≈ −5.2" are loose, and the polynomial is odd, so the two stretches are symmetric. Its largest |y| on the interval is 795.87 at ±3π, so "≈ 10²" in the review is nearer 8 × 10². Neither figure is on the page.
- **Change.** `pade_animations_all.jl`, `render_case`:
  - Before: `ypad = clamp.(ypad, case.ylims[1], case.ylims[2])`
  - After: `yspan = case.ylims[2] - case.ylims[1]` and `ypad = clamp.(ypad, case.ylims[1] - yspan, case.ylims[2] + yspan)`, with a two-line comment.
  - This is the review's second option. It was chosen over the NaN mask because a mask would remove or alter the lines drawn across an approximant's own poles, which R5-C says to leave. `ytrue` is untouched, so the target's pole lines stay.
- **Check.**
  - Flat segments on the frame edge: 185,129 before, 0 after (`repro.jl`).
  - Pole lines: for every segment of every frame, the part visible inside the window spans the same y-range before and after (largest change 0.000e+00). Full-height segments: 527 before, 527 after, and equal in each of the 27 cases, so no new full-height line appears and none is lost (`repro.jl`, `repro_out.txt`).
  - Exact PNG renders of all 1614 frames from the same plot code with each clamp (`renderpair.jl`, `cmp_png.py`, `final_check.py`): 882 frames change. The 732 frames with no off-scale value are pixel-identical. Zero pixels differ outside the plot box (title, ticks, axis labels). Zero pixels differ inside the legend, measured 3 px in from its border, in all 1614 frames. Within those 3 px of the border, 1,517 pixels differ over all frames. The two frames with differences just inside the border line (06 f47, 27 f39) have a pole line running alongside it; the rest were not traced individually.
  - Before/after sheets viewed for cases 01, 02, 12 and 22–27 (`before_after_a.png`, `before_after_b.png`): same poles, same labels, no line along the edge.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `pade_animations_all.jl`, comment above the clamp | "Limit off-scale values to one y-span beyond the axes, not to the axes" | Code directly below it: `clamp.(ypad, ylims[1] - yspan, ylims[2] + yspan)` | yes |
| same comment | "so the curve leaves the frame instead of running along its edge" | `repro.jl` → flat edge segments 185,129 → 0; frames viewed (08 f55, 01 f55, 22 f21 and f45, 12 f45) | yes |
| `index.qmd` | No change. No sentence describes the old edge behaviour: `grep -i "edge\|clamp\|clip\|border\|off-scale\|saturat\|level"` → 0 matches | grep | yes |
| GIF titles, legends | No change | `cmp_png.py`, `final_check.py` → 0 differing pixels outside the plot box and inside the legend | yes |

## Scripts and GIFs

- **Script changed:** `pade_animations_all.jl` (4 lines added, 1 removed).
- **GIFs regenerated:** all 27, `pade01.gif` to `pade27.gif`. Every case has at least one frame with an off-scale value, so no GIF stays byte-identical. Frame counts are unchanged (66 or 45). The global palette differs in all 27 GIFs (`pal.py`), so decoded GIF frames differ slightly even where the plot did not change; the exact PNG comparison above is the one to rely on.
- **Frames viewed at full size from the new GIFs:** pade08 f55 ([9/0]), pade01 f55 ([9/0]), pade22 f21 ([5/0]) and f45 ([8/0]), pade12 f45 ([8/0]). In each, the approximant leaves through the top or bottom of the frame with no line along the edge, and the magenta pole lines are as before.
- **git status of the page folder after regeneration:** 28 modified files (27 GIFs and `pade_animations_all.jl`). `index.qmd` unchanged. No stray files.

## Legacy archive

Consulted: `n2003/PadeApproximationMod.html` and `a2001/Animations/Interpolation/Pade/` (`Pade08/Padehh.gif`, 20 frames, viewed as a contact sheet; `Pade12/Padell.gif` extracted). Mathews' sin(x) animation lets the approximant run out of the top and bottom of the window and does not draw it along the edge, which is what the page now does. His animations show diagonal [n/n] entries with a tolerance bar; the page does not, and this fix does not change that.

## Notes

- R5-C applied: poles are treated as before, and `ytrue` has no pole mask.
- Round 4 set the lower y-limit of Cases 01 and 02 to −0.5 so the clamped curve would lie on the unlabelled frame edge rather than on y = 0. That reason no longer applies, but the limits were left alone because no finding asks to change them.
- The conventions call for a Behavior paragraph per case; this page has none. Pre-existing and not named by a finding, so not added.
- A line across a pole still joins the same two neighbouring grid points, so its position in the window can move by less than one grid step (1/899 of the plot width).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Change: `ypad` is now clamped to `[lo - span, hi + span]` instead of `[lo, hi]`. This is the review's second suggested option.
- Off-scale frames: recomputing all 27 cases from the script's own functions gives 1614 frames, 524 of them with more than 10 % of samples off-scale. This matches the finding's count, and case 24 is again the only case with none.
- In-window values: 0 in-window samples are altered by the new clamp. Every clamped sample lies one full span outside the axes, so it cannot be drawn inside the frame. Only the connecting segment to the neighbouring sample enters the frame, and the exit point stays within one sample interval (under 0.7 px).
- Pixels: the longest steel-blue run hugging the top or bottom edge (right 55 % of the top edge, to avoid the legend) falls from 471 px (case 01), 311 px (case 22), 233 px (case 11) and 82 px (case 08) to at most 19 px in any frame of any case.
- Residual runs: the three largest checked (case 13 frame 2, case 01 frame 2, case 21 frame 8) are the true approximant crossing the limit at a shallow angle. For example, case 01 [0/1] has y from -0.499 to -0.478 for x in 7.008 to 7.183.
- Frames viewed: first, middle, last and worst-edge frames, before and after, for cases 01, 02, 08, 12 and 22–27. Flat runs along the frame edge are gone in all of them.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `pade_animations_all.jl` comment, line 475 | "Limit off-scale values to one y-span beyond the axes, not to the axes" | Matches the code: `clamp.(ypad, lo - yspan, hi + yspan)` | True |
| `pade_animations_all.jl` comment, line 476 | "so the curve leaves the frame instead of running along its edge" | Edge-run measurement above | True |
| `index.qmd` | No change | `git diff` is empty; the page has no wording about clamping, clipping or edges | n/a |
| Titles and legend labels | No code change | Same strings in the script; full-size frame and sheets read correctly | Unchanged |

### New problems

None. This rests on:
- Pole lines (R5-C): the set of sample-to-sample segments spanning the whole y-window is identical before and after in all 1614 frames (527 segments each, 0 frames differ). This also follows from the clamp: a segment spans the window under one clamp exactly when it does under the other.
- Pixels: 0 frames in any of the 27 GIFs show a full-height blue column that was not present within 3 px before the fix.
- Every frame differs slightly from its pre-fix version, including the 732 frames with no off-scale sample, and text pixels outside the plot differ by at most 21 dark pixels per frame. This is consistent with GIF palette re-quantization. It was inferred rather than isolated; the title, label and tick code is unchanged and the frames read the same.

### Reproducibility and conventions

- A scratch copy of `pade_animations_all.jl` regenerated all 27 GIFs. All 27 are byte-identical to the working-tree GIFs.
- Pre-fix GIFs are Git LFS objects, so they were read with `git cat-file --filters`; plain `git show` returns only the pointer.
- The fix diff was read with `git diff HEAD`. `fix.diff` was not used.
- Page folder changes: `pade_animations_all.jl` and the 27 GIFs only. `index.qmd` and `pade_animation_code.m` are unchanged.
- Conventions: Description comes before Animations, 27 GIF embeds, source links present, 0 code blocks.
- Other working-tree changes exist outside this page folder (the Laurent page and review fix records). They were not read and cannot be attributed to this fix from the diff.
- MATLAB and quarto were not run. No repository file was modified.

**Final status:** committed
