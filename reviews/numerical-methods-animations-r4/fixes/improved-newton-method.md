# Fix record: improved-newton-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/improved-newton-method/fix/` (`segments.jl`, `indep.py`, `frames_aa/`, `frames_ee/`).

## Findings

### F1 — Minor — fixed
- **Reproduced:** In all five scripts the per-step plot loop draws two segments of the same colour: `plot!([xn, xn1], [fn, 0.0])` (slanted) and `plot!([xn1, xn1], [0.0, fn1])` (vertical, with `fn1 = f(xn1)`), at `newtonimpaa.jl` 47/50, `newtonimpbb.jl` 53/56, `newtonimpcc.jl` 46/48, `newtonimpdd.jl` 51/53, `newtonimpee.jl` 47/49. `julia segments.jl` recreates each script's iterates and its drawn segments:
  ```
  aa: m=1 drawn slanted=10 vertical=10 max rel |slope - f'(xn)/m| = 1.69e-13
  bb: m=2 drawn slanted=3  vertical=3  max rel |slope - f'(xn)/m| = 3.65e-12
  cc: m=1 drawn slanted=12 vertical=12 max rel |slope - f'(xn)/m| = 3.19e-14
  dd: m=3 drawn slanted=3  vertical=3  max rel |slope - f'(xn)/m| = 1.15e-11
  ee: m=1 drawn slanted=5  vertical=5  max rel |slope - f'(xn)/m| = 1.22e-16
  ```
  (the larger relative differences in bb/dd come from dividing by the tiny last step xₙ₊₁ − xₙ; round-off). Independent sympy check (`/usr/bin/python3 indep.py`), step-0 slanted slope vs f'(x₀)/m: aa 2.0700/2.0700, bb 1.0350/1.0350, cc 0.91800/0.91800, dd 0.30600/0.30600, ee 0.33783784/0.33783784. Frames viewed: `frames_ee/frame_004.png` shows three vertical strokes (at x₁, x₂, x₃) alongside the slanted lines; `frames_aa/frame_003.png` shows the vertical strokes at x₁ and x₂. So every frame after the first has vertical lines, and the page's "each drawn line is the tangent" is literally false for them. Finding holds.
- **Change:** `index.qmd` lines 24–25 (Animations intro).
  - Before: "For standard Newton (Cases 1, 3, 5) each drawn line is the tangent at $x_n$; … At each iterate $x_n$, the line connecting $(x_n, f(x_n))$ to the next iterate's x-intercept traces the convergence path."
  - After: "For standard Newton (Cases 1, 3, 5) each slanted line is the tangent at $x_n$; for Method A (Cases 2, 4) it is the line of slope $f'(x_n)/m$. Each slanted line runs from $(x_n, f(x_n))$ to the next iterate's x-intercept $(x_{n+1}, 0)$, and each vertical line returns from $(x_{n+1}, 0)$ to the curve at $(x_{n+1}, f(x_{n+1}))$; together they trace the convergence path."
- **Check:** endpoints taken directly from the plot calls above (slanted: (xn, f(xn)) → (xn1, 0); vertical: (xn1, 0) → (xn1, f(xn1))); slopes per `segments.jl`/`indep.py` output above; vertical strokes confirmed in viewed frames. Text-only fix (D7), no script change, so no regeneration.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.24 | "each slanted line is the tangent at $x_n$" (Cases 1, 3, 5) | `julia segments.jl` → aa/cc/ee max rel slope − f'(xₙ) ≤ 1.7e-13; `indep.py` step-0 slopes 2.07, 0.918, 0.33783784 equal f'(x₀) | yes |
| index.qmd l.24 | "for Method A (Cases 2, 4) it is the line of slope $f'(x_n)/m$" (unchanged clause) | `segments.jl` → bb 3.7e-12, dd 1.1e-11 rel; `indep.py` 1.0350 = 2.07/2, 0.30600 = 0.918/3 | yes |
| index.qmd l.25 | slanted line runs from $(x_n, f(x_n))$ to $(x_{n+1}, 0)$ | plot calls aa:47, bb:53, cc:46, dd:51, ee:47 use `[xn, xn1], [fn, 0.0]` with fn = f(xn), xn1 = next iterate | yes |
| index.qmd l.25 | each vertical line returns from $(x_{n+1}, 0)$ to the curve at $(x_{n+1}, f(x_{n+1}))$ | plot calls aa:50, bb:56, cc:48, dd:53, ee:49 use `[xn1, xn1], [0.0, f(xn1)]`; one vertical per drawn slanted line (`segments.jl` counts 10/3/12/3/5); frames_ee/004, frames_aa/003 show them | yes |
| index.qmd l.25 | "together they trace the convergence path" | same as the sentence it replaces (review ledger row 10). In Case 5 the x₅→x₆ step is not drawn because x₆ = 8.71 lies outside xlims; the GIF legend already says "(out of range)" and the statement applies to the drawn lines | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (text-only fix).
- Frames viewed (committed GIFs, unchanged): `newtonimpaa.gif` frame 3, `newtonimpee.gif` frame 4, full size, to confirm the vertical strokes.
- `git status --short -- pages/numerical-methods/improved-newton-method` after the fix: ` M pages/numerical-methods/improved-newton-method/index.qmd` only.

## Legacy archive
Consulted. `n2003/newtonimproved/NewtonImprovedMod/` contains only the module's link pages (`Links/NewtonImprovedMod_lnk_1…6.html`: introduction, Method A/B derivations, Examples 1–3) and images; there is no top-level `NewtonImprovedMod.html` at the path the brief names. `a2001/Animations/RootFinding/` has a `NewtonMethod` folder but no Improved Newton animation. Nothing in the archive bears on how the vertical return strokes are described, so it did not affect this fix.

## Notes
- No decision ambiguity: D7 (change text to describe the animation) and D5 (fix reproducible Minor findings) settle it.
- In Cases 2 and 4 the final vertical stroke has invisible length (f(x₃) = 5.2e-20 in Case 2 and 1.7e-33 in Case 4, from `julia -e` on the factored f at the scripts' x₃); the sentence still holds for it.
- Pre-existing convention gaps: none noticed that a finding names; nothing added.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: The old sentences in `index.qmd` lines 24–25 said that "each drawn line" is the tangent or effective tangent, and they did not mention the vertical segments. Line 24 now says "each slanted line". The new line 25 says each slanted line runs from (x_n, f(x_n)) to (x_{n+1}, 0), and each vertical line returns from (x_{n+1}, 0) to (x_{n+1}, f(x_{n+1})).
- This matches the code in all five scripts. Each script draws `plot!([xn, xn1], [fn, 0.0])` and `plot!([xn1, xn1], [0.0, f(xn1)])` (aa 47/50, bb 53/56, cc 46/48, dd 51/53, ee 47/49). No vertical line is drawn at x_0, because frame 0 has an empty loop. So every vertical line starts at some x_{n+1}, as the text says.
- I checked the slopes with my own computation (mpmath, 50 digits, `check/slopes.py`). For every step of every case, the slope of the segment from (x_n, f(x_n)) to (x_{n+1}, 0) equals f'(x_n)/m to a relative error of 1e-46 or better. Here m = 1 for Cases 1, 3 and 5, so the line is the tangent. m = 2 for Case 2 and m = 3 for Case 4.
- I looked at frames at full size. In `newtonimpee.gif` frame 6 there are five slanted and five vertical strokes, and the verticals go up or down to the curve at x ≈ −1.41, 1.45, −1.55, 1.85 and −2.89. In `newtonimpaa.gif` frame 4 the vertical strokes from x ≈ 1.157 and 1.080 rise to the curve. The text matches what is shown.
- No script or GIF changed, so the pictures are the same as the ones the finding was raised against.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd 24 | "For standard Newton (Cases 1, 3, 5) each slanted line is the tangent at x_n" | Cases 1, 3, 5 use m = 1 (aa 27, cc 27, ee 27). Slope − f'(x_n) is at most 1e-46 relative at every step | True |
| index.qmd 24 | "for Method A (Cases 2, 4) it is the line of slope f'(x_n)/m" | bb m = 2, dd m = 3. Slope/(f'/m) − 1 is at most 1.5e-47 | True |
| index.qmd 25 | "Each slanted line runs from (x_n, f(x_n)) to the next iterate's x-intercept (x_{n+1}, 0)" | Code endpoints `[xn, xn1], [fn, 0.0]` in all five scripts. Seen in the frames | True |
| index.qmd 25 | "each vertical line returns from (x_{n+1}, 0) to the curve at (x_{n+1}, f(x_{n+1}))" | Code `[xn1, xn1], [0.0, f(xn1)]` in all five scripts. The verticals reach the curve in the frames, going up or down | True |
| index.qmd 25 | "together they trace the convergence path" | Descriptive. Consistent with the frames | True |

### New problems
None. Two things that are true but worth knowing:
- In Case 5 the scripts skip a step whose endpoint is outside the x-limits. The last step, to x_6 ≈ 8.71, is not drawn. The new sentences describe the lines that are drawn and do not claim one per step, so this is not a defect.
- In Cases 2 and 4 the last vertical strokes are shorter than a pixel. They are still drawn exactly as described.
This rests on the code reading, the high-precision slope check above, and the full-size frames.

### Reproducibility and conventions
- Only `index.qmd` changed in this page folder: 2 lines removed and 2 added, per `git diff --stat HEAD`. No `.jl` or `.gif` changed, so there was nothing to regenerate and the byte-identity check does not apply.
- The structure is unchanged. Description comes before Animations, each case has a source link and an embed, alt text is descriptive, and there are no code blocks.
- Other paths under `pages/numerical-methods/` are modified in the working tree. They belong to other pages' fixes in this round and are not part of this page's diff (`fix.diff` lists only this page's `index.qmd`).

**Final status:** committed
