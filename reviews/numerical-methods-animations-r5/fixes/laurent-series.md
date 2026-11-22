# Fix record: laurent-series

The round-5 review counted no findings. Decision R5-F tells this page to fix the review's uncounted item (the f curve joined across the poles), so it is recorded here as F1.

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/laurent-series/fix/`

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - `julia repro.jl` rebuilds the script's 900-point grid for each window. No grid point falls on a pole, and every sample is finite, so `safe_eval` produces no NaN.
  - **Case 12** (tan, window [−π, π], y ∈ [−10, 10]): the segment across −π/2 runs from x = −1.57604, tan = 190.77 to x = −1.56905, tan = −572.32. The segment across +π/2 is its mirror image, from 572.32 to −190.77. Each jump is 763.1 against a window height of 20.
  - **Cases 22–24** (Γ, window [−0.2, 5.2]): the segment across 0 runs from x = −0.0017798, Γ = −562.45 to x = 0.0042269, Γ = 236.01. The jump is 798.5 against a window height of 45 or 55.
  - The review's "|tan| ≈ 285" is not the exact pair of values, but the defect is the same.
  - `poles_check.py` (numpy/mpmath, independent) finds exactly these three sign-changing segments larger than the window height, and no others.
  - Frame `before12/frame_008.png` shows the solid magenta vertical lines at x = ±π/2. Frames `before22..24` show the line at x ≈ 0.
- **Change:** `laurent_animations_all.jl`.
  - Added a `poles::Vector{Float64}` field to `LaurentCase`, plus a 7-argument outer constructor that defaults it to `Float64[]`. All other case lines are unchanged.
  - Case 12 is given `[-pi / 2, pi / 2]`. Cases 22, 23 and 24 are given `[0.0]`.
  - In `render_case`, the f curve is now drawn on `xf = sort(vcat(xplot, case.poles))`, with `ytrue = NaN` at each pole. Before, it was drawn on `xplot` with `safe_eval` everywhere. This is the same pattern as Lagrange Case 14 in `lagnewt_animations_all.jl`.
  - The blue Taylor curve still uses `xplot`. The script comment explains the NaN break.
- **Check:**
  - **Regeneration:** after the fix, `julia laurent_animations_all.jl` changed only `laurent12.gif` and `laurent22.gif`–`laurent24.gif`. The `md5sum` of all 27 GIFs before and after (`before_md5.txt` and `after_md5.txt`) is identical for the other 23.
  - **Pixel diff:** `pixdiff.py` compares old and new frames, all 8 frames of each changed GIF, counting a pixel as changed when a channel differs by more than 80.
    - In Case 12, the only changed pixels are in pixel columns 217–219 and 531–533. These are the columns of x = −π/2 and +π/2, about 2500 px per frame: two lines about 3 px wide spanning the plot height.
    - In Cases 22–24, the only changed pixels are in columns 85–87, at x = 0, about 1190 px per frame.
    - Smaller differences elsewhere come only from GIF palette requantization.
  - **Visual:** `after12/frame_008.png`, `after22/frame_001.png` and `after24/frame_008.png` show no vertical line. Every branch of tan and Γ still leaves the window toward ±∞ near its pole.
  - **Only poles in the windows:** tan has poles in (−π, π) only at ±π/2, and Γ has a pole in (−0.2, 5.2) only at 0 (`poles_check.py`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| script, struct comment | "poles of f inside the window (empty if none)" | `poles_check.py` → tan: ±1.5707963267948966 in (−π, π); Γ: [0] in (−0.2, 5.2). `julia allcases.jl` (all 27 cases on the original grid, counting finite sign-changing segments whose jump exceeds the window height) → only case 12 (2 segments, at ±π/2) and cases 22–24 (1 segment, at 0). The other cases have none: where their f has a branch point in the window (cases 04–07, 17 and 25–27), `safe_eval` already returns NaN on the non-real side (150, 98, 98, 150, 300 and 1 NaN samples), so no join is drawn | yes |
| script, case 12 | poles `[-pi / 2, pi / 2]` | as above | yes |
| script, cases 22–24 | poles `[0.0]` | as above | yes |
| script, render_case comment | "f gets a NaN point at each pole, so its curve breaks there instead of drawing a segment across the pole from one branch to the other." | new frames show the break; `pixdiff.py` shows the only changes are at the pole columns | yes |
| index.qmd | no change | `grep -n -i -E "vertical\|asymptot\|line" index.qmd` → no text mentions the vertical lines; alt text for cases 12 and 22–24 is generic ("Laurent-series truncation animation for case NN.") | n/a |

## Scripts and GIFs
- **Script changed:** `pages/numerical-methods/laurent-series/laurent_animations_all.jl`.
- **GIFs regenerated:** `laurent12.gif`, `laurent22.gif`, `laurent23.gif` and `laurent24.gif`, with 8 frames each, as before. The other 23 GIFs are byte-identical; their md5 sums match.
- **Frames viewed:**
  - Case 12, frame 8: the f curve is broken at ±π/2, the Taylor N = 8 curve is unchanged, and the legend and title are unchanged.
  - Case 22, frame 1: the f curve is broken at 0.
  - Case 24, frame 8: the f curve is broken at 0.
  - The pixel diff covers all 8 frames of each of the four GIFs.
- **The old GIFs** for cases 23 and 24 were taken from HEAD with `git cat-file --filters`; the files are Git LFS. Their md5 sums match the pre-run working-copy sums.
- **`git status --short -- pages/numerical-methods/laurent-series`:**
  ```
   M laurent12.gif
   M laurent22.gif
   M laurent23.gif
   M laurent24.gif
   M laurent_animations_all.jl
  ```

## Legacy archive
Consulted only to confirm that no Laurent topic exists.
- The n2003 listing has `taylorpoly`, `taylorde`, `fourierseries` and Frobenius pages, but no Laurent module.
- A grep for "laurent" finds only the Frobenius pages and bibliography link pages.
- The fix is a plotting correction, so the archive has no bearing on it.

## Notes
- R5-F supersedes R4-D's "leave" for the Laurent pole lines; this record applies R5-F.
- The Padé page's Cases 22–27 (finite spikes, R5-C) are a different page and were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
(Decision R5-F: f curve joined straight across the poles of tan (Case 12) and Γ (Cases 22–24).)
- Reproduced on the pre-fix GIFs (HEAD, via `git lfs smudge`). Old frames 1, 4 and 8 of laurent12 show a solid magenta vertical line spanning the window at x = ±π/2. Old laurent22 frame 1 shows the same line at x = 0. On the 900-point grid the samples next to the poles are tan = +190.8 and −572.3 (at −π/2) and +572.3 and −190.8 (at +π/2), and Γ = −562.5 and +236.0 (at 0), so the old curve joined values of opposite sign.
- Fix (`laurent_animations_all.jl`): a new `poles` field (`[-π/2, π/2]` for Case 12, `[0.0]` for 22–24, empty otherwise through a 7-argument outer constructor). The f curve is now drawn on `xf = sort(vcat(xplot, poles))`, with NaN at each pole. The blue Taylor curve still uses `xplot`, so it is unchanged.
- Independent check (`check/jumps.jl`, which loads the script's case table and `safe_eval`):
  - Case 12: 902 points with NaN exactly at ±1.5707963267948966. Case 22–24: 901 points with NaN at 0.0. Each NaN sits between the two opposite-sign neighbours listed above.
  - After the fix, in all 27 cases no remaining pair of consecutive finite samples changes sign with |Δy| larger than the window height. The remaining large same-sign steps (tan and Γ near the poles, 1/√(1−x) near 1) lie on monotone branches outside the window.
  - Poles inside the windows, checked mathematically: tan on (−π, π) has poles only at ±π/2. Γ on (−0.2, 5.2) has a pole only at 0 (the next is −1, outside the window). No other case has a pole inside its window: the singularities of log, √, 1/√(1−x) and asin are branch points with NaN on the far side, and Y₀'s singularity at 0 is a log singularity at the window edge (NaN). So the pole lists are complete.
- Frames: I looked at new frames 1, 4 and 8 of laurent12, frames 1 and 8 of laurent22, frame 4 of laurent23 and frame 8 of laurent24 at full size.
  - There is no vertical line at the poles.
  - Each branch runs off the window correctly. tan reaches ±10 at x ≈ ±1.47 and ±1.67 (atan 10 = 1.4711). Γ on (−0.2, 0) runs from −5.82 down past −10 near x ≈ −0.11 (Γ(−0.1) = −10.69). Γ rises to 35 just right of 0.
  - A thresholded pixel diff of old against new (all 8 frames of each of the 4 GIFs; difference > 60 in any channel) is confined to the pole columns: px 217–219 and 531–533 for Case 12, and px 85–87 for Cases 22–24, rows 32–471, the full plot height. Plus one stray pixel at col 273 in laurent22 frame 4, which is palette dithering. The small-tolerance differences elsewhere are GIF palette requantisation. Blue curve, labels, titles, legend and the x₀ marker are unchanged.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| script, struct | `poles::Vector{Float64}  # poles of f inside the window (empty if none)` | The field holds exactly the poles of f inside each window (see F1). Empty for every other case. | True |
| script, outer constructor | 7-arg `LaurentCase(...)` → `Float64[]` | 23 cases use it. Their GIFs are byte-identical to HEAD. | Correct |
| script, Case 12 | `[-pi / 2, pi / 2]` | Poles of tan in (−π, π) | True |
| script, Cases 22–24 | `[0.0]` | Poles of Γ in (−0.2, 5.2) | True |
| script, render_case comment | "f gets a NaN point at each pole, so its curve breaks there instead of drawing a segment across the pole from one branch to the other." | NaN inserted at the pole, and the frames show the break | True |
| script, kept comment | "Values are not clamped … a curve that leaves the window is drawn leaving it" | Still true. Branches exit through the top and bottom edges, not along them. | True |
| script, `plot!(pplot, xf, ytrue; …)` | f is plotted on `xf`, with matching lengths (902 or 901 vs 900) | The run completes, and the frames are correct | Correct |
| index.qmd | (unchanged) | No sentence or alt text mentions vertical lines, asymptote lines or the joins (grep for vertical, asymptot, line). The only pole sentence is about the Laurent series in the annulus, which the fix does not affect. | Nothing to change |

### New problems
None.
- This rests on four checks:
  - the pixel diff above: only the pole columns change;
  - the full-size frames of all four regenerated GIFs;
  - the scan of all 27 cases for remaining sign-change joins;
  - byte-identity of the 23 untouched GIFs with HEAD.
- Not new: the alt text is generic ("Laurent-series truncation animation for case NN.") for every case. It is pre-existing and not touched by this fix, so I did not count it.

### Reproducibility and conventions
- I ran `julia laurent_animations_all.jl` from a scratch copy (`check/run/`). All 27 output GIFs are byte-identical (`cmp`) to the working-tree GIFs in the page folder.
- Against HEAD (SHA-256 of the working-tree files vs the LFS pointer oids):
  - only laurent12, laurent22, laurent23 and laurent24 differ;
  - laurent01–11, 13–21 and 25–27 are byte-identical to HEAD.
- Decoded frame hashes: all 8 frames of each of the 4 changed GIFs differ from HEAD, as expected, since the pole line ran through every frame. The frame count is unchanged (8).
- Conventions: Description comes before Animations. There is one source link (all cases come from one script) and one embed per case. There are no code blocks. index.qmd is unchanged.
- Files outside the page folder: the fix diff touches only `pages/numerical-methods/laurent-series/` (script and the 4 GIFs). The shared scripts (Padé, `lagnewt_animations_all.jl`) are unmodified. The other modified paths in `git status` (broyden, muller, secant, nonlinear-systems, neville) belong to other pages' fixes and are not part of this diff.

**Final status:** committed
