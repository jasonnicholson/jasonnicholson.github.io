# Fix record: newton-raphson-method

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/newton-raphson-method/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:**
  - `julia inst_ff.jl` (scratch) gives iterates `[1.4, -1.4136186488037423, 1.4501293146283372, -1.5506259756377534, 1.84705408415019, -2.8935623931424104, 8.710325846983183]`. Only x₆ lies outside `xlims = (-4, 5)` (`inwin=false` for index 6 only).
  - `/usr/bin/python3 -I indep.py` (mpmath, 40 digits, `mp.diff` derivative) gives `['1.4', '-1.413618649', '1.450129315', '-1.550625976', '1.847054084', '-2.893562393', '8.710325847']`. It agrees with the script.
  - The tangent line at x₅ meets x = 5 at y = −0.39586506892575024 (Julia) and −0.3958650689 (mpmath). That point is inside the window, so the step can be drawn.
  - In the committed GIF (`before/frame_007.png`), frame 7 has no segment from x₅ toward x₆. The guard `xlims[1] <= xn <= xlims[2] && xlims[1] <= xn1 <= xlims[2]` skips it. Only the legend changes from frame 6 ("x₍6₎ = 8.71 (out of range)").
- **Change:** `newtonff.jl`, lines 46–53. The guard now tests only xₙ. The tangent segment `[xn, xn1] → [fn, 0]` is always drawn and is clipped at the window edge by the fixed `xlims`. The vertical drop to (xₙ₊₁, f(xₙ₊₁)) is drawn only when xₙ₊₁ is in the window. The out-of-range legend label (true value 8.71) is unchanged. No arrow or annotation was added (smallest change).
- **Check:**
  - The regenerated `after/frame_007.png` shows a new blue segment from (−2.894, −1.238) to the right edge.
  - The plot frame spans rows 36.5 (y = 1.8) to 545 (y = −1.8), and y = 0 is at row 291. At column 626 (the right edge) the segment's pixel is at row 347, which gives y = −(347−291)/141.25 = −0.396. This matches the computed −0.3959.
  - Frames 1–6 are logically unchanged. For frame ≤ 5 every xₖ₊₁ (k ≤ 5) is in the window, so the same draw calls run. Their decoded pixels differ only by GIF palette re-quantisation: 1.7k–2.9k of 384k pixels, mean difference about 0.01, at most 10 pixels above 0.1 (`pixdiff.py`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `newtonff.jl` comment | "tangent segment; if x_{n+1} is off-window, xlims clips it at the edge" | frame 7 pixel check above: the segment ends at the right frame edge (max blue column 628), at y ≈ −0.396 = computed tangent value at x = 5 | yes |
| `index.qmd` | no change | The Case 6 Behavior ("escape toward larger \|x\|") and alt text still describe the animation, now including the drawn sixth step: \|xₖ\| for k = 1…6 = 1.414, 1.450, 1.551, 1.847, 2.894, 8.710 (`inst_ff.jl`). The values grow at every step. | yes |
| GIF legend frame 7 | "x₍6₎ = 8.71 (out of range)" (unchanged) | x₆ = 8.710325847 (mpmath) | yes |

## Scripts and GIFs

- Script changed: `newtonff.jl`. GIF regenerated: `newtonff.gif` (7 frames, as before), using `julia newtonff.jl` from the page folder.
- Frames viewed: the contact sheet `after/sheet.png` (all 7 frames) and `after/frame_007.png` at full size. Checked: the last tangent starts at the x₅ point on the curve and is clipped at x = 5. The vertical drops for x₁…x₅ are unchanged. The legend shows the correct values with the correct index, and the title is unchanged.
- `git status --short -- pages/numerical-methods/newton-raphson-method` → ` M newtonff.gif`, ` M newtonff.jl` (only these files).

## Legacy archive

Consulted.
- `n2003/newtonsmethod/Newton'sMethodMod/Links/Newton'sMethodMod_lnk_9.html` is Example 8, "NON Convergence, Divergent Oscillation", Animation 6.
- The legacy GIF `a2001/Animations/RootFinding/NewtonMethod/Newtonff.gif` (23 frames, scratch `legacy_ff/sheet.png`) shows the matching final frame, "p₆ = 8.71033". In that frame Mathews draws the last tangent from (p₅, f(p₅)) and lets it run off the right edge of the window.
- The fixed page now does the same. The archive's p₁…p₆ values agree with the computed iterates to the digits shown.

## Notes

- None of decisions R2-A to R2-D apply to this page. The reviewer found no fidelity departures.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (code): in `newtonff.jl` the guard on the tangent segment is now `xlims[1] <= xn <= xlims[2]` only. The segment `[xn, xn1] -> [fn, 0]` is drawn whenever x_n is in the window, and Plots clips it at the axis limits. The vertical drop at x_{n+1} still needs x_{n+1} in the window, which is right because there is nothing to draw off-window. The other frames are unaffected: x0..x5 are all in [-4, 5], so frames 0–5 take the same code path as before.
- Evidence (math, mpmath at 30 digits): the iterates from x0 = 1.4 are 1.4, -1.4136186488, 1.45012931463, -1.55062597564, 1.84705408415, -2.89356239314, 8.71032584698. f(x5) = -1.2380514. The tangent at x5 meets x = 5 at y = f(x5)(x6 - 5)/(x6 - x5) = -0.39586507.
- Evidence (frames): new frame 7 at full size shows a steelblue segment from the marker point (-2.894, -1.238) to the right edge at y ≈ -0.40, read against the y-grid (between -0.5 and 0). The legend reads "x₍6₎ = 8.71 (out of range)", which is correct. The pre-fix frame 7 (from the HEAD LFS blob) was missing this segment. Per-frame pixel diffs between old and new: frames 1–6 differ in 8–36 pixels each by more than 30 RGB units. These are scattered and come from GIF palette quantization, with no element change. Frame 7 differs in 1209 pixels, spanning x 137–628, which is the new segment.
- The optional arrow or annotation at the edge was not added, and no red marker is drawn for x6. That is acceptable: the finding's core request (draw the escaping tangent, clipped) is met, and the legend gives the value of x6.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `newtonff.jl` new comment | "tangent segment; if x_{n+1} is off-window, xlims clips it at the edge" | Frame 7 shows the segment clipped exactly at x = 5, y ≈ -0.396 (computed -0.39587) | true |
| `index.qmd` | no change | — | — |
| GIF legend frame 7 (unchanged text) | "x₍6₎ = 8.71 (out of range)" | x6 = 8.71032584698 | true |
| GIF legend frames 0–5 (unchanged) | 1.4, …, -1.5506 (frame 3), -2.8936 (frame 5) | match the mpmath iterates to 4 dp | true |
| Case 6 Behavior (unchanged; it is consistent with the new picture) | "x_c ≈ 1.3917"; "escape toward larger \|x\|" | x_c (root of 2x = atan(x)(1+x²)) = 1.3917452; \|x_n\| grows 1.41, 1.45, 1.55, 1.85, 2.89, 8.71 | true |

### New problems
None. This rests on the following:
- The code change affects only frame 7, because no earlier x_{n+1} is off-window.
- The new segment is built from the right quantities (x5, f(x5), x6) and is clipped at the correct edge value.
- The frames are otherwise unchanged apart from palette noise.
- No text on the page changed.

### Reproducibility and conventions
- Reproducibility: I ran a scratch copy of `newtonff.jl` with `julia newtonff.jl`. Its output `newtonff.gif` is byte-identical to the working-tree GIF (`cmp` reports identical), and the decoded framemd5 files are identical too. The GIF has 7 frames at 640x600.
- Only `newtonff.jl` and `newtonff.gif` changed in the page folder. Outside `pages/numerical-methods/`, the only change for this page is the untracked fix record `reviews/numerical-methods-animations-r2/fixes/newton-raphson-method.md`, which is expected. The other untracked files belong to other pages' parallel fixes.
- Conventions: every case (1–6) has a `[Julia source]` link and a GIF embed with descriptive alt text, and there are no code blocks. Pre-existing gap, not caused by this fix: the page has no `## Description` section before `## Animations`, which `.github/agents/animation-page.agent.md` lines 12 and 205 require. The intro under `## Animations` serves as a description. `index.qmd` was not touched in this fix.

**Final status:** committed
