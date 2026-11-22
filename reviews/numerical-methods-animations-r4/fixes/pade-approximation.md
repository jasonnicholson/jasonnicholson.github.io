# Fix record: pade-approximation

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/pade-approximation/fix/`

## Findings

### F1 — Minor — fixed
- **Reproduced:** I made an instrumented copy of the script (`pade_lib.jl` = the script's first 497 lines, everything except the render loop) and `clamp_runs.jl`. That file evaluates each frame's p/q on the script's 900-point grid *before* the clamp and reports the longest run of points below the lower y-limit. Command: `julia clamp_runs.jl 1 2 3`.
  - **Case 01, ylims (0, 3.5):** 19 of 66 frames have a run below 0, so the drawn curve runs along y = 0. This includes all 9 frames the review names, for example [4/0], where 560 points (62 % of the window) lie below 0 from x = 3.971, with a minimum of −270.1. It also includes 10 frames where the curve reaches y = 0 by crossing a pole and is then drawn at 0: [0/1] 71 %, [0/3] 76 %, [0/5] 77 %, [0/7] 78 %, [0/9] 79 %, [1/4] 46 %, [1/6] 59 %, [1/8] 65 %, [2/7] 36 % and [2/5] 4 %.
  - **Case 02, same window (0, 3.5):** the same defect, after a pole, in [0/3] (3.8 %), [0/5] (9.9 %), [0/7] (13.0 %) and [0/9] (14.9 %). The [0/7] and [0/9] runs are 117 and 134 points long, above the review's 90-point threshold. The review says Case 01 is the only case affected. That is true only of runs that do not follow a pole.
  - **Case 03:** no values below 0.
  - **Independent check:** in `indep.py`, sympy builds the exact Padé from exact Taylor coefficients of √x and solves the Toeplitz system itself. Case 01 [4/0] is −5.0 at x = 5 and −270.11 at x = 10.5, matching the review. Every frame checked has true values far below 0, for example [10/0] min −4.942e7 and [8/0] min −7.693e5, rather than values near 0.
- **Change:** `pade_animations_all.jl` lines 24–25, the ylims of Case 01 and Case 02: `(0.0, 3.5)` → `(-0.5, 3.5)`. This is the review's fallback suggestion, chosen as the smallest change: one table entry per case, no change to the drawing code, and the other 25 GIFs are untouched. The clamped part now runs along the bottom frame edge at y = −0.5, as in the other cases with arbitrary borders. The curve visibly crosses y = 0 and does not look like it settles there. True values between −0.5 and 0 are now drawn where they are, for example the [0/3] tail (−0.07 … −0.004) and the [0/1] tail (−0.267 at x = 10.5).
- **Check:**
  - **Clamp runs after the fix:** `julia clamp_runs_new.jl 1 2 3` (the same tool on the edited script) shows the clamped runs now sit at y = −0.5. The first x where each approximant drops below −0.5 matches sympy (`indep.py`) to the grid. Examples, with sympy's value first and the script's grid point second:
    - [4/0]: 4.1346 vs 4.135;
    - [10/0]: 2.8148 vs 2.815;
    - [8/2]: 8.3626 vs 8.363;
    - [0/1]: 3.0017 vs 3.002;
    - Case 02 [0/9]: 8.9466 vs 8.947.
  - **Frames viewed at full size** (new `pade01.gif` frames 2, 7, 15 and 66; new `pade02.gif` frame 46; contact sheet of `pade02.gif`): each curve crosses the y = 0 gridline and either leaves through the bottom frame edge or follows it, then comes back up where its true value is above −0.5. Pole strokes are still drawn. The y = 0 tick and gridline are visible above the bottom edge. Titles, legends and the red (x0, f(x0)) marker are unchanged. Both GIFs still have 66 frames.

## Ledger of changed text

No text in `index.qmd`, and no alt text, title or label, was added or changed. Every sentence on the page is independent of the y-window, and none mentions it. The only changed values are the two script ylims.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `pade_animations_all.jl` l.24 (Case 01) | ylims `(-0.5, 3.5)` | `julia clamp_runs_new.jl 1` → every clamped run is at −0.5, and none sits on y = 0. Frames 2, 7, 15 and 66 were viewed. | yes |
| `pade_animations_all.jl` l.25 (Case 02) | ylims `(-0.5, 3.5)` | `julia clamp_runs_new.jl 2` → the runs in [0/3], [0/5], [0/7] and [0/9] are at −0.5. Frame 46 and the contact sheet were viewed. | yes |

## Scripts and GIFs
- **Script changed:** `pade_animations_all.jl`, Case 01 and Case 02 ylims only.
- **Regenerated:** `julia pade_animations_all.jl` was run from the page folder. It took 90 s and printed "Generated 27 GIFs."
- **git status of the page folder afterwards:** ` M pade01.gif`, ` M pade02.gif`, ` M pade_animations_all.jl`. The other 25 GIFs came out byte-identical, as expected for the unchanged cases.
- **Frames:** extracted with `giftools.jl` into `new_pade01/` and `new_pade02/` in the scratch folder. The frames checked are listed under F1.

## Legacy archive
I consulted `a2001/Animations/Interpolation/Pade/Pade01/Padeaa.gif` (20 frames) and its HTML. Mathews shows √x about 1 on roughly [0, 10.5] × [0, 3.3], stepping through the diagonal S₁,₁ … S₈,₈ with a ±0.001 tolerance band. His diagonal approximants never go below 0, so his window starting at y = 0 hid nothing. The page's animation also shows off-diagonal entries ([m/0] Taylor polynomials, [0/n] and others), which do go negative. The lower limit of −0.5 is needed for those. The difference from Mathews is only the y-window, and the function, centre and x-interval are unchanged.

## Notes
- **Scope:** the review's finding names Case 01 only. I extended the fix to Case 02 because the same window hides the same kind of run there: after a pole, up to 15 % of the window is drawn at y = 0. Case 03 shares the window but never goes below 0, so I left it unchanged. As a result its y-window, (0, 3.5), now differs from Cases 01 and 02. If Jason prefers identical windows for the three √x cases, changing line 26 the same way is safe, but it would regenerate `pade03.gif` with no correctness gain.
- **Clamping itself** (line 475) is unchanged. In the other cases the borders are arbitrary levels, and the review accepted that those read as off-scale.
- **Convention gaps:** none relevant. The page has a Description before its Animations section.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved

- **What changed.** The only change is to the y-limits of Cases 01 and 02 in `pade_animations_all.jl`, from `(0.0, 3.5)` to `(-0.5, 3.5)`. The clamp at line 475 (`ypad = clamp.(ypad, ylims...)`) is still there. The finding's own suggestion names this as an acceptable fallback ("at least give Case 01 a lower limit below 0, such as (-0.5, 3.5)").
- **Computation** (`check/ana/runs.jl`, which uses the script's own `p` and `q` on its 900-point grid). In Case 01 the same 9 frames still leave through the bottom and are clamped for at least 90 grid points: [2/0], [4/0], [5/1], [6/0], [7/1], [8/0], [8/2], [9/1] and [10/0]. They are now clamped to y = -0.5, the frame's lower edge, and no longer to y = 0. The pole frames [0/1], [1/4], [1/6] and [2/7] also hit the edge briefly. Every clamped value is genuinely below -0.5. The largest value in any clamped run is -0.5005, and the most negative is -4.9e7.
- **Independent check** (`check/ana/indep.py`, mpmath `pade` on the exact binomial Taylor coefficients of sqrt about 1, 50 digits). [4/0] is -5.0 at x = 5 and -270.11 at x = 10.5, and drops below -0.5 from x = 4.13. [10/0] is -4.94e7 at x = 10.5 and drops below -0.5 from x = 2.81. [9/1] is -11566 at x = 10.5. All of these match the script.
- **Can a viewer still mistake the clamped run for a real value?** I looked at full-size frames 15 ([4/0]) and 66 ([10/0]) of the new `pade01.gif`, and a 4x zoom of the bottom edge.
  - The curve now visibly crosses the labelled y = 0 gridline and keeps falling until it meets the box frame.
  - The clamped run merges with the black frame line. Because the line sits on the clip boundary, only about half its width shows, so it looks like a blue tint on the frame border, not a separate curve.
  - The lower edge, -0.5, has no tick label; the lowest label is 0.
  - The approximant therefore no longer looks as if it "falls to 0 and stays there". It reads as leaving through the bottom of the plot. This is the same treatment the reviewer accepted as clearly off-chart for the ±1.5 and -10 edges in the other cases.
  - What remains: the run along the border is still drawn. A viewer who read the frame line as a data line could at most take it for "about -0.5". That is not a meaningful value for sqrt and is not labelled. Setting out-of-window values to NaN, the reviewer's first suggestion, would remove even that. I do not count it as a defect, because the fix follows the finding's stated minimum and matches the clamp-to-frame convention used by all 27 cases.
- **Case 02.** Its limits were changed in the same way. That was needed: under the old (0, 3.5) window, its [0/7] and [0/9] frames would have run along y = 0 for 117 and 96 grid points, where the true values are -0.63 to -452.7 and -0.51 to -244.5. The original review missed these. They now sit on the -0.5 frame edge.
- **Case 03.** It keeps (0, 3.5). I computed every frame, and none goes below 0 anywhere on the grid. It is also the only remaining case whose lower limit is exactly 0. So it has no instance of the problem.
- **Case 01 [0/3].** Its true values of -0.07 to -0.004 are now drawn at their true height, just below the 0 gridline. Before the fix they were clamped to 0.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `pade_animations_all.jl` line 24, Case 01 | ylims `(-0.5, 3.5)` | The window contains sqrt on [0, 10.5], which runs from 0 to 3.24, with room to spare. The lower edge is below 0, so a diverging approximant visibly passes 0 before it is clamped. Every clamped value is below -0.5 (max -0.5005). | correct |
| `pade_animations_all.jl` line 25, Case 02 | ylims `(-0.5, 3.5)` | Same as Case 01. This also fixes the [0/7] and [0/9] runs on y = 0 described under F1. | correct |
| `index.qmd` | none | The diff leaves `index.qmd` unchanged (`git diff --quiet HEAD`). No page text or alt text mentions the y-range, so nothing needs updating. | n/a |

### New problems

None. This rests on the following checks:

- I viewed frames 1, 15, 33 and 66 of the new `pade01.gif` and frames 29 and 66 of the new `pade02.gif` at full size.
  - The titles and legends are legible and unchanged.
  - The legend (top left) does not cover the curves.
  - The red center marker is at (1, 1) and (4, 2).
  - The y ticks now read 0, 1, 2 and 3 (they were 0.0, 0.5, …, 3.5); they are legible and correct.
  - The vertical segments at poles (for example [0/7] near x = 9.15) still run from frame edge to frame edge, as before.
- The Padé computation is untouched. Only the plot window changed.

### Reproducibility and conventions

- **Reproducibility.** I ran a scratch copy of `pade_animations_all.jl` (`check/run/`). All 27 output GIFs, including the changed `pade01.gif` and `pade02.gif`, are byte-identical to the working-tree files.
- **Conventions.**
  - Description (line 10) comes before Animations (line 84).
  - There is one general source link plus a source link and an embed for each of the 27 cases.
  - The alt text is descriptive and unchanged.
  - The page has no code blocks.
- **Scope.** The fix diff touches only `pade_animations_all.jl`, `pade01.gif` and `pade02.gif` in the page folder. The working tree also has changes in `brents-method/`, `halleys-method/` and `runge-kutta-method/`. They are not part of this page's diff; I assume they belong to other pages' fixes in this round.

**Final status:** committed
