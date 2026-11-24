# Fix record: bezier-curves

## Findings
### F1 — Minor — fixed
- Reproduced: independent closed-form (Bernstein) check, not the script's logs:
  `/usr/bin/python3 -I scratchpad/r7fix/bezier-curves/fix/check_f1.py` (40 frames t = k/39, interior frames 2–39, curve sampled at 400,001 points then refined by bounded minimisation) →
  `L1 114 min 0.0006 median 0.3042 max 0.7549`, `L2 76 min 0.0006 median 0.0911 max 0.6743`, `red 38 min 0.0000 median 0.0000 max 0.0000`;
  frame 20 (t = 0.4872): level-1 distances 0.257, 0.256, 0.235; level-2 0.094, 0.088 (review said 0.236 for the third level-1 point; the difference is rounding of the nearest-point search). Only the red point lies on the curve, so the alt text's "level-1 orange, level-2 green, and the resulting red point trace" is wrong.
- Change: `index.qmd` line 35, Case 1 alt text: "…: level-1 orange, level-2 green, and the resulting red point trace the smooth blue curve from P0 to P3" → "…: level-1 orange and level-2 green points locate the red point, which traces the smooth blue curve from P0 to P3" (the review's suggested wording). Text only; no script or GIF change (R7-D, D7: the animation is correct).
- Check: `git diff -- pages/numerical-methods/bezier-curves` shows the single alt-text line changed; `git status --short` lists only `index.qmd`.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.35 alt | "level-1 orange and level-2 green points" | `bezieraa.jl` l.59–60 colour `:orange` for L1, l.64–65 `:green` for L2 | yes |
| index.qmd l.35 alt | "locate the red point" | `bezieraa.jl` l.35–37: L2 built from L1, L3 = (1−t)L2[1] + tL2[2]; red marker is L3 (l.68) | yes |
| index.qmd l.35 alt | "which traces the smooth blue curve from P0 to P3" | check_f1.py: red-point distance to the Bernstein curve 0.0000 (max) over frames 2–39; script l.47–50 trace drawn `:steelblue`; review claim #27 (B(0)=(2,2), B(1)=(4,1), min\|B'\| = 2.168) unchanged | yes |
| index.qmd l.35 alt | unchanged prefix (Example 3, control points) | archive `BezierCurveMod.nb` l.2681–2692: Example 3 points {2,2},{4,1},{1,1.5} (and P2 (3.5,0) per review #22) match script l.11 | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (text-only fix).
- git status of the page folder: ` M pages/numerical-methods/bezier-curves/index.qmd` only.

## Legacy archive
Consulted: `n2003/bezier/BezierCurveMod.nb` Example 3 (lines 2681 onward) — control points agree with the page and script. The archive has no animation for this topic (as the page already says); it does not bear on the alt-text wording.

## Notes
- No ambiguity: the finding offered a single suggested correction, used verbatim.
- Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/bezier-curves/fix/check_f1.py`.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The alt text at `index.qmd` line 35 now reads "level-1 orange and level-2 green points locate the red point, which traces the smooth blue curve from P0 to P3". Only the red point is the subject of "traces".
- Independent computation (`check/chk.py`, Bernstein form sampled at 400,001 points, interior frames 2-39 of `range(0,1,length=40)`): level-1 points are 0.0006 / 0.3042 / 0.7549 (min / median / max) from the curve, and level-2 points are 0.0006 / 0.0911 / 0.6743. So both sets are generally off the curve. The red de Casteljau point matches B(t) to 0.0, and B(0)=(2,2), B(1)=(4,1), which are P0 and P3.
- "Locate": the red point lies on the level-2 segment in every frame (max |cross| = 2.8e-16), and the level-2 points come from the level-1 points. So the level-1 and level-2 points do determine the red point.
- GIF (unchanged, 40 frames, frames 20 and 40 viewed at full size): the level-1 points are orange, the level-2 points are green, the curve point is red, and the curve is blue ("steelblue"). The blue curve is drawn up to the red point and ends at P3 = (4,1) in the last frame. The control points (2,2), (1,1.5), (3.5,0), (4,1) match `bezieraa.jl` line 11.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:35 alt | "cubic Bezier curve of Mathews' Example 3" | Script header and title say Example 3; cubic, 4 control points | OK (unchanged part) |
| index.qmd:35 alt | control points (2,2),(1,1.5),(3.5,0),(4,1) | `bezieraa.jl` line 11; GIF frames | OK |
| index.qmd:35 alt | "level-1 orange and level-2 green points" | Script colors :orange and :green; GIF legend | OK |
| index.qmd:35 alt | "locate the red point" | Red point lies on the level-2 segment (cross product about 1e-16) and comes from the levels | OK |
| index.qmd:35 alt | "which traces the smooth blue curve" | Red point minus B(t) = 0; curve drawn in steelblue | OK |
| index.qmd:35 alt | "from P0 to P3" | B(0) = P0, B(1) = P3; last frame shows the red point at (4,1) | OK |

### New problems
None. This rests on the following:
- The diff is a single alt-text line.
- Every claim in that line was checked by computation above and against frames 20 and 40.
- No script or GIF changed, so nothing in the pictures could have regressed.

### Reproducibility and conventions
- No script or GIF changed (`git status` of the page folder lists only `index.qmd`, 1 line), so there was nothing to regenerate.
- The page keeps the conventions:
  - Description comes before Animations.
  - Each of the 2 cases has a source link and an embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Nothing outside the page folder was changed by this page's fix (the diff is limited to `index.qmd`). Other pages show working-tree changes from this round's other fixes, which are outside this check's scope.

**Final status:** committed
