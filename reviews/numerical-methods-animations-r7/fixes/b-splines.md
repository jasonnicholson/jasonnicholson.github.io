# Fix record: b-splines

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/b-splines/fix/` (`before.gif`, `before_frames/`, `after_frames/`, `sumvis.py`).

## Findings
### F1 — Minor — fixed
- Reproduced: I extracted the committed `bsplinebb.gif` (md5 `114574b771b2c3c78d46b7ce6f4aecab`, 7 frames) with `giftools.jl` and looked at frames 6 and 7 at full size. The opaque `:topright` legend covers the dashed running sum: in frame 7 it hides the y = 1 line from about t ≈ 2.6 to the right edge of the legend, and in frame 6 it hides the place near t = 3 where the sum starts to fall below 1. `python3 -I sumvis.py before_frames` computes the running sum on its own with SciPy `BSpline.basis_element` on the knots (0,0,0,0,1,2,3,4,4,4,4); the full sum ranges from 0.9999999999999997 to 1.0000000000000002. The script maps each of 2000 samples to the frame's plot box (x 56–738, y 30–454) and looks for a dark pixel within ±3 px. The longest uncovered run is 0.028 in t for frames 1–4, which is the dash gap. It is 0.040 for frame 5, 0.338 for frame 6 and 0.748 for frame 7. My pixel method breaks the review's single hidden interval into pieces where legend text lies within ±3 px of the line. It confirms the finding, but it is not a measurement of the review's exact interval.
- Change: `bsplinebb.jl` line 45, `legend=:topright` → `legend=:outerright`. I regenerated `bsplinebb.gif`. The page text is unchanged because nothing on the page refers to the legend.
- Check: I ran `sumvis.py` on `after_frames`. The plot box is x 56–495, y 30–454. The longest uncovered run is 0.044 to 0.054 in t in every frame (m = 1…7), which is the dash gap at the narrower width (about 5–6 px). No stretch of the sum is hidden. The legend's dark pixels lie at x 517–738, entirely to the right of the plot box edge at x = 495. The title's dark pixels span x 52–499 of the 750 px frame, so the title is not clipped. All 7 frames are distinct (7 unique framemd5 hashes). Viewed at full size, frame 1 shows N₁ with the sum on top of it, frame 6 shows the sum leaving 1 near t = 3, and frame 7 shows the y = 1 line across the whole of [0, 4].

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `bsplinebb.jl` line 45 | `legend=:outerright` (no text or number change) | `sumvis.py after_frames` → no hidden run longer than a dash gap; legend dark pixels x 517–738, plot box ends at x 495 | yes |
| `index.qmd` | no change | `grep -n -i legend index.qmd` → no hits. The alt text "running sum shown in black approaches 1 as all functions are added" still matches the new frames | yes |

## Scripts and GIFs
- Script changed: `bsplinebb.jl`, one keyword. `bsplinebb.gif` was regenerated with `julia bsplinebb.jl` from the page folder; the new md5 is `ec23cd73509857662ada2fbc388bfd1a`. `bsplineaa.gif` was not regenerated and is unchanged (md5 `51909b96132f233e8e9cac0db4c773ca`).
- I viewed frames 1, 6 and 7 at full size and checked every frame with `sumvis.py`. The running sum is visible in each frame, the title carries the right m, and the legend lists N₁…N_m plus the sum.
- Plot width: the plot box shrinks from 682 px to 439 px, and its height stays 424 px. The curves, their peaks and the place where the sum leaves 1 in frame 6 all remain clear. I kept the frame size at 750×500 to match `bsplineaa.gif` and to keep the change minimal (R7-D). If Jason prefers the old plot width, `size=(950, 500)` would restore it, at the cost of smaller text when the page scales the GIF down.
- `git status --short -- pages/numerical-methods/b-splines` → `M bsplinebb.gif`, `M bsplinebb.jl` only.

## Legacy archive
Present. `n2003/bsplines/` holds `B-SplinesMod`, `B-SplinesProg` and `Spline`. The round-7 review established that the module has no B-spline animation. The only spline animation under `a2001/Animations` is `Quadrature/Spline/Splineaa.gif`, which belongs to cubic-spline quadrature, not to this page. This fix is a legend placement, and the archive has nothing to say about it. I did not need it beyond confirming that.

## Notes
- The y-axis label `N_{i,4}(t)` is shown literally, and the legend mixes `N₁,₄` with `N_7,₄` (review §2.3, not a finding). I left both untouched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `bsplinebb.jl` line 45 now `legend=:outerright` (the only text change in the diff). The regenerated `bsplinebb.gif` (7 frames, extracted with giftools.jl) shows the legend in the right margin outside the axes box (axes span roughly x 57 to 495 px; legend at roughly x 518 to 738 px) in every frame. Frames 1, 4, 6 and 7 were viewed at full size: in frame 7 the dashed line y = 1 is visible across the whole domain [0, 4]; in frame 6 the sum is visibly 1 up to t = 3 and then falls to 0 at t = 4, so the point where it leaves 1 is visible. Independent check with scipy BSpline.basis_element on knots (0,0,0,0,1,2,3,4,4,4,4) over the script's 500-point grid: the full sum lies in [0.9999999999999997, 1.0000000000000002]; the six-function sum first drops below 1 at the first grid point after t = 3 (t = 3.006), which matches frame 6.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| bsplinebb.jl line 45 | `legend=:outerright` | Frames show the legend outside the plot area; nothing in the axes is covered | Correct |

No sentence, heading, alt text, title or label changed in index.qmd (not in the diff).

### New problems
None. This rests on: a one-token diff; full-size inspection of frames 1, 4, 6 and 7 (legend fully legible, all 7 entries plus the sum entry visible in frame 7, nothing clipped, curves and the sum unchanged in shape: N_{4,4} peaks at 2/3 at t = 2, end functions reach 1 at t = 0 and t = 4); and the partition-of-unity check above. The plot area is narrower than before because the legend now takes the right margin, but all features stay readable. The title mixes "N₁,₄" and "N_7,₄", and the legend shows "N_1,₄" with a literal underscore. Both were there before and were not caused by this fix.

### Reproducibility and conventions
- Ran a scratch copy of `bsplinebb.jl` with `julia`: the output GIF has sha256 8a42a609...10a17, which is byte-identical to the GIF on disk and matches the LFS oid in the diff.
- index.qmd is unchanged and still follows the conventions: Description comes before Animations, each case has a source link and an embed, alt text is descriptive, and there are no code blocks.
- `git status` of the page folder lists only bsplinebb.gif and bsplinebb.jl. The other modified files in the working tree belong to other pages' fixes or are untracked review files, and none of them come from this page's diff.

**Final status:** committed
