# Fix record: bezier-curves

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/bezier-curves/fix/`

- `dump_orig.jl`: the original trace logic of both scripts (`idx_end = min(frame_idx * div(n_curve, n_frames), n_curve)` over a 300-sample backdrop) with no plotting; prints trace end, red point and gap per frame, and lists the frames where the trace is ahead of or behind the point.
- `indep_orig.py`: independent check of the original rule in exact rationals (Bernstein form; frame k draws to t = (7k−1)/299, red point at t = (k−1)/39). Run `/usr/bin/python3 -I indep_orig.py`.
- `dump_new.jl`: loads the **fixed** scripts' own source with the Plots calls stubbed out, records each frame's trace array and red point; output in `dump_new.txt`.
- `indep_new.py`: independent Bernstein-form check of the new rule.
- `legend_check.py`: pixel check on every frame of the new GIFs (axes right edge vs legend box left edge).
- `text_check.py`: sympy check of the unchanged page claims (endpoints, inflection).
- `orig/`, `orig_frames_aa/`, `orig_frames_bb/`: committed GIFs (via `git show HEAD:… | git lfs smudge`) and their frames. `frames_aa/`, `frames_bb/`: frames and contact sheets of the regenerated GIFs.

## Findings

### F1 — Error — fixed
- Reproduced: `julia dump_orig.jl` → frame k draws samples 1..7k of 300. Both cases: the trace is ahead of the red point in frames 1–9, equal at frame 10 (t = 0.2308) and behind in frames 11–40. Last frame: the trace ends at t = 0.9331 (sample 280). Gaps: aa frames 1/10/20/30/39/40 = 0.133/0.000/0.100/0.222/0.405/0.431, with the trace ending at (3.787, 0.374) while the red point is at (4, 0). bb gaps = 0.116/0.000/0.133/0.221/0.315/0.354, with the trace ending at (3.949, 1.650) and the red point at (4, 2). `indep_orig.py` gives the same numbers in exact rationals. The checker's correction holds: the curve is ahead in frames 1–9 and lags from frame 11. One correction to the checker: the `bezierbb.jl` line was 45, not 123 (the file has 68 lines). Visually confirmed in `orig_frames_bb/frame_040.png`: the blue curve stops short of (4, 2).
- Change: in `bezieraa.jl` (old lines 51–56) and `bezierbb.jl` (old lines 45–49), the `idx_end` slice of the precomputed backdrop became `tt = range(0.0, t, length=max(2, round(Int, 1 + t * (n_curve - 1))))`, followed by `trace = [decasteljau_point(P, s) for s in tt]` and plotting `trace`. The backdrop arrays `t_curve`, `curve_pts`, `curve_x` and `curve_y` were now unused, so they were removed. In `bezieraa.jl` the comment "Pre-compute full Bézier curve for backdrop" (no backdrop was ever drawn) was replaced by a comment on `n_curve`. Titles, labels, axis limits, frame count and fps are unchanged.
- Check: `julia dump_new.jl` (runs the fixed scripts' own code) → in both cases, over all 40 frames, max |trace end − red point| = 0.0 and max |trace start − P0| = 0.0. Frame 40 trace end = red = (4.0000, 0.0000) = P3 for aa and (4.0000, 2.0000) = P3 for bb. Sample counts are 2, 70, 147, 223, 292 and 300 at frames 1, 10, 20, 30, 39 and 40. `indep_new.py` → max gap 0 for both cases, with B(1) = (4, 0) and (4, 2). I viewed `frames_aa/frame_001.png` (t = 0, no trace, red at P0), `frame_020.png` (trace ends under the red point at t = 0.49) and `frame_040.png` (the curve reaches P3), and `frames_bb/frame_039.png` and `frame_040.png` (the curve reaches the red point at (4, 2)).

### F2 — Misleading — fixed
- Reproduced: in `orig_frames_aa/frame_020.png` the legend box (top right, inside the axes) covers P2 = (3, 2) and the dashed polygon near it. In `orig_frames_bb/frame_040.png` the legend covers P3 = (4, 2), and no red point is visible at t = 1.0. Because `legend=:topright` was inside the axes in both scripts, and the axis limits and control points are the same in every frame, the covered control point is covered in all 40 frames.
- Change: in `bezieraa.jl` (line 48 → 43) and `bezierbb.jl` (line 42 → 39), `legend=:topright` → `legend=:outerright`. This is a one-word change. The axis limits and figure size (700×550) are unchanged.
- Check: `/usr/bin/python3 -I legend_check.py frames_aa frames_bb` → in all 40 frames of each GIF the axes' right edge is at pixel column 490 and the legend box's left edge at column 511, so the legend lies entirely outside the plot area. Full-size frames show all four control points in every inspected frame (aa 001/020/040, bb 039/040, bb contact sheet). The red point at P3 = (4, 2) is visible in bb frame 40, and both titles fit inside the frame, including "Bézier Curve (S-shape) — de Casteljau  (t = 0.97)".

## Ledger of changed text

`index.qmd` is unchanged. Changed text is limited to script comments and one plot option.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| bezieraa.jl:13, bezierbb.jl:20 (comment) | "Number of samples on the full curve t ∈ [0,1] (the trace up to t uses a proportional share)" | `julia dump_new.jl` → nsamp = 300 at t = 1, 147 at t = 0.4872, 70 at t = 0.2308 (= round(1 + 299t)) | yes |
| bezieraa.jl:46, bezierbb.jl:42 (comment) | "Curve traced so far: B(s) for s in [0, t], ending exactly at the red point" | `dump_new.jl` → max \|trace end − red\| = 0.0 and max \|trace start − P0\| = 0.0 over 40 frames, both scripts; `indep_new.py` → max gap 0 | yes |
| bezieraa.jl:43, bezierbb.jl:39 | `legend=:outerright` | `legend_check.py` → legend left edge 511 > axes right edge 490 in all 40 frames of both GIFs | yes |
| index.qmd:22, 28, 32 (unchanged; previously contradicted by the GIF) | "draws the full curve"; "traces … from $P_0$ to $P_3$" | `dump_new.jl` → frame 40 trace end = P3 in both cases; `text_check.py` → B(0) = (0,0), B(1) = (4,0) / (4,2) | yes |
| index.qmd:36, 40 (unchanged) | Case 2 "has an inflection point", "inflecting near the center" | `text_check.py` → bb: x′y″ − y′x″ = 144(2t − 1), root t = 1/2, sign −1 at t = 1/4 and +1 at 3/4, B(1/2) = (2, 1), the centre of the control box [0,4]×[0,2]; aa: −72(t² − t + 1), no real root (no inflection) | yes |

## Scripts and GIFs
- Scripts changed: `bezieraa.jl` and `bezierbb.jl` (trace rule, removal of the unused backdrop arrays, legend position).
- GIFs regenerated: `cd pages/numerical-methods/bezier-curves && julia bezieraa.jl && julia bezierbb.jl`. Each has 40 frames at fps 8, as before.
- Frames viewed at full size: aa 001, 020, 040; bb 039, 040; the bb contact sheet (t = 0, 0.1, …, 0.92). Checked in them:
  - The blue trace ends under the red point.
  - The level-1 (orange) and level-2 (green) points sit on their segments.
  - All four black control points are visible.
  - The legend is outside the axes.
  - The t value in the title matches the frame (t = (k−1)/39 rounded to 2 decimals: frame 20 shows 0.49 and 0.4872 rounds to 0.49; frame 39 shows 0.97 and 0.9744 rounds to 0.97).
- `git status --short -- pages/numerical-methods/bezier-curves` after regeneration: `M bezieraa.gif`, `M bezieraa.jl`, `M bezierbb.gif`, `M bezierbb.jl`. These are the expected files, and `index.qmd` is unchanged.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/BezierCurveMod.html` (text) and its links. The graph-sized images `BezierCurveMod_gr_94.gif` (Mathematica code) and `_gr_95.gif` (plot) were viewed.

Mathews' module builds the cubic Bézier curve from the Hermite / "clamped cubic" viewpoint and then with Bernstein polynomials (Examples 1–6). His plots are static: a blue curve with the red handle lines P0–P1 and P2–P3. There is no de Casteljau construction and no animation, and his example points (for example, `_gr_95` plots red points at about (1, 1.5), (2, 2), (4, 1) and (3.5, 0), read off the plot) differ from the site's two cases. The site's page is therefore its own treatment. Nothing in the archive bears on F1 or F2, and no fix was changed because of it.

## Notes
- The loop variable `frame_idx` is now unused in both scripts. It is left in place (harmless) to keep the diff minimal.
- At t = 0 (frame 1) the trace is a zero-length two-point line, so nothing blue is drawn but the "Bézier curve" legend entry stays. This matches the original, where frame 1 also had the legend entry.
- With `:outerright` the plot area is narrower (axes right edge at x-pixel 490 of 700), so the x scale is compressed relative to y. Shapes stay recognisable, and no claim on the page depends on the aspect ratio.
- The round-1 note that `bezierbb.jl`'s line was "123" is wrong; it was line 45.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Both scripts now build the trace inside the loop as `tt = range(0.0, t, length=max(2, round(Int, 1 + t*(n_curve-1))))`, `trace = decasteljau_point.(P, tt)` (bezieraa.jl:47-50, bezierbb.jl:43-46). The precomputed 300-sample backdrop and the `idx_end = 7k` indexing are gone. Julia ranges end exactly at `t`, so the last trace point is B(t).
- My own computation (`check/dump.jl`) reruns the loop logic for all 40 frames of both cases. It compares the trace end with the red point L3, which is computed independently by the explicit level-1/2/3 lerps. The result is max |trace_end − red| = 0.0 in both cases. Frame 40 ends at (4, 0) in aa and (4, 2) in bb, so B(1) = P3. Frame 39 (t = 0.9744) ends at (3.9211, 0.1499) in aa and (3.9922, 1.8539) in bb, which equals the red point. Every trace sample was also checked against the Bernstein form Σ C(3,i)(1−t)^{3−i} t^i P_i, with max deviation 8.9e-16.
- Sample spacing stays at about 1/299 in t in every frame: from 9 points at t = 0.026 up to 300 at t = 1.
- Frames: in full-size `new_aa/frame_020.png` (t = 0.49) and `new_bb/frame_020.png`, the blue curve ends exactly under the red point. In `new_aa/frame_040.png` and `new_bb/frame_040.png` the curve reaches P3, where the red point sits. In `new_bb/frame_039.png` the curve ends at the red point near (3.99, 1.85). The contact sheet shows the trace and the point in step in every panel. The page claims (index.qmd lines 22, 28, 32) now match the GIFs.

### F2 — resolved
- Evidence: Both scripts changed `legend=:topright` to `legend=:outerright`. In every frame I inspected (aa 001/020/040, bb 001/020/039/040 and the bb contact sheet), the legend box sits entirely outside the axes frame. The frame's right edge is at about x_px 490 and the legend starts at about 510.
- Case 1: P2 = (3, 2) is visible in every frame, along with the dashed polygon edge through it and the orange level-1 segment near it.
- Case 2: P3 = (4, 2) is visible in every frame. In frame 39 the red point at (3.99, 1.85) is visible, as are the upper level-1 and level-2 points. In frame 40 the red point is visible at (4, 2) on top of P3.
- Axis limits are unchanged (aa x [−0.2, 4.2], y [−0.4, 2.5]; bb x [−0.3, 4.3], y [−0.3, 2.3]), so all four control points stay inside the plot area.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| bezieraa.jl:13, bezierbb.jl:20 (comment) | "Number of samples on the full curve t ∈ [0,1] (the trace up to t uses a proportional share)" | n = round(1 + t·299): 300 samples at t = 1, 147 at t = 0.487, 9 at t = 0.026, a constant spacing of about 1/299 | true |
| bezieraa.jl:14, bezierbb.jl:21 | `n_curve = 300` | unchanged value, now used only for density | fine |
| bezieraa.jl:46, bezierbb.jl:42 (comment) | "Curve traced so far: B(s) for s in [0, t], ending exactly at the red point" | max gap is 0.0 over all 80 frames, and the range endpoint is exactly t | true |
| bezieraa.jl:43, bezierbb.jl:39 | `legend=:outerright` | legend lies outside the axes in all inspected frames and covers no data | true |
| Labels / titles | unchanged ("Bézier curve", "control polygon", "control points P₀–P₃", "level 1", "level 2", "point on curve"; titles with t rounded to 2 d.p.) | title and legend text legible at full size; t values in titles (0.0, 0.49, 0.97, 1.0) match t_anim | true |
| index.qmd | no change | `git diff HEAD` is empty for index.qmd | n/a |

### New problems
None. This rests on the following:
- Full-size inspection of the first, middle and last frames of both GIFs (plus bb frame 39) and the bb contact sheet.
- Every element is built from the right quantities: control points, dashed polygon, level-1 orange (3 points / 2 segments), level-2 green (2 points / 1 segment), red L3, and the trace ending at L3.
- Titles and legend are legible and the plots are not clipped.
- At t = 0 the trace has two coincident points at the origin and draws nothing visible. This is harmless and correct, since the traced curve is empty at t = 0.

The only visual side effect is that the plot area is narrower because the legend moved outside. Nothing that was right before is broken: all 40 frames differ from the pre-fix frames, as the layout change requires, and the content is otherwise the same. The loop variable `frame_idx` is now unused, which is cosmetic and not reported.

### Reproducibility and conventions
- I copied both scripts to `check/run/` and ran them with plain `julia` (about 9.7 s each). `cmp` shows both outputs are byte-identical to the committed GIFs. sha256 values: aa a08736c3…cebd40 and bb e73f0551…40268f, which match the LFS oids in the diff. The decoded frame md5 values also match.
- I extracted the pre-fix GIFs read-only via `git show HEAD:… | git lfs smudge` for comparison.
- Conventions: index.qmd is unchanged. It still has Description before Animations, a `[Julia source]` link and a GIF embed per case, and descriptive alt text. It has no code blocks (0 fences), and the section index still links the page (pages/numerical-methods/index.qmd:64).
- Within this fix, only the four files in the page folder changed. The working tree also has other modified pages and untracked `reviews/numerical-methods-animations/fixes/*.md` (including `bezier-curves.md`). These are other pages' fixes on the shared branch and workflow notes, not changes to this page.

**Final status:** committed
