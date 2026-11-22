# Fix record: mullers-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/mullers-method/fix/`
(`check.py` = independent mpmath check at 50 digits; `disc9.jl` = float64 discriminants of every step; `exp/` = trial scripts and GIFs; `committed/` and `new/` = extracted frames before and after).

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I check.py` (mpmath Muller from 0.8, 0.9, 1.0 for f = sin(x²−2)(x²−2)). Frame 1: `q3=1.25431599`, old drawn range `[0.6,1.2]`, `q3_in_old=False`; frames 2–9 `q3_in_old=True`. Committed `committed/mullersbb/frame_001.png` shows the dashed curve ending near (1.2, 0.2), above the axis.
- Change: `mullersbb.jl` lines 76–81. Before: `xpara = range(min(q0,q1,q2) - 0.2, max(q0,q1,q2) + 0.2, ...)` and the parabola clamped to `ylims`. After: `q3 = muller_step(q0, q1, q2, f)` in the frame loop, `xpara = range(min(q0,q1,q2,q3) - 0.2, max(q0,q1,q2,q3) + 0.2, ...)`, and the `clamp.` on the parabola removed so the axes clip it. The clamp was removed because the extended range takes the parabola well below the bottom limit (frame 1 minimum −0.835 vs ylim −0.2), and a clamped curve would draw a false flat dashed segment along the bottom border. Same change in `mullerscc.jl` lines 77–82 for consistency, as the finding suggests.
- Check: `check.py` with the new range gives `q3_in_new=True` for all 9 frames of both cases (bb frame 1 new range [0.6, 1.4543]). The per-frame call `muller_step` now also runs a 9th step on the frame-9 triple; `julia disc9.jl` shows its float64 discriminant is positive in both cases (bb 3.13e−9, cc 1.65e−7), so the script's negative-discriminant `error` cannot fire; both scripts ran to completion. In `new/mullersbb/frame_001.png` the dashed parabola now crosses the axis at x ≈ 1.25 and is clipped at the bottom border at x ≈ 1.306 with no flat segment; in `frame_002.png` it crosses at 1.322 and is clipped at the border at x ≈ 1.400, again with no flat segment (crossing and exit points from `numpy.roots` of the fitted parabola, P = 0 and P = −0.2).

### F2 — Minor — fixed
- Reproduced: `committed/mullerscc/frame_002.png` and `frame_005.png`: with ylims (−12, 20) the parabola is a stub a few pixels tall and its crossing is hard to see; flat magenta segments along the top border at both ends come from `clamp.(f.(xplot), ...)` (f(±2.5) = 55.45 > 20, `check.py`). Correction to the review's numbers (not on the page): f(1.3) = 1.18411 and f(1.4) = 1.03834, not 1.236 and 1.081 (`check.py`, "f at start"); f(1.5) = 0.703125 is right.
- Change: `mullerscc.jl` lines 16–17: `xlims = (-2.5, 2.5)`, `ylims = (-12.0, 20.0)` → `xlims = (0.9, 2.1)`, `ylims = (-0.5, 1.5)`; line 75: `clamp.` on f removed (the axes clip it, since f leaves the window on [0.9, 0.9422] and [1.934, 2.1], `check.py`). The finding's first suggested window was used; no inset or panel was added.
- Check: `check.py` — all three starting points (y = 1.184, 1.038, 0.703) and every next iterate q3 ∈ [1.6276, 1.7320] lie inside the new window; the vertical scale is 16× larger (32 → 2 units on the same axis height). Frames viewed in `new/mullerscc/`: frame 1 shows the parabola through the three points crossing the axis at 1.6276 and leaving the bottom border at x ≈ 1.696 (`numpy.roots`, P = −0.5); frame 4 shows three distinct points (1.6276, 1.6743, 1.7035) and the crossing at 1.720; frame 9 shows the parabola touching the axis at the root. No flat segments at the borders. The three points still merge in the last frames (frame 7 triple spans 1.7275–1.7317, about 0.004 in x, a few pixels), which is the convergence itself and not a scale problem. Legend (top left) overlaps nothing in any frame.

## Ledger of changed text
`index.qmd` was not changed: no page sentence describes the window, the drawn range or the clamping, and the intro's "the next iterate is found where the parabola crosses the x-axis" is now visible in every frame of Cases 2 and 3.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `mullersbb.jl` comment l.76–77 | "drawn far enough to include its axis crossing (the next iterate); the plot window clips it at the axis limits" | `check.py` → q3_in_new=True all 9 frames; frames 1–2 viewed: curve cut at border, no flat segment | yes |
| `mullerscc.jl` l.16 | `xlims = (0.9, 2.1)` | `check.py` → all iterates and q3 in [1.3, 1.7321] ⊂ (0.9, 2.1) | yes |
| `mullerscc.jl` l.17 | `ylims = (-0.5, 1.5)` and comment "window around the double root; the axes clip f and the parabolas" | `check.py` → |f| at all drawn points ≤ 1.18411 < 1.5; crossing y = 0 in range; f outside window only on [0.9, 0.9422] and [1.934, 2.1]; frames 1, 4, 9 viewed: clipped, no flat segments | yes |
| `mullerscc.jl` comment l.77–78 | same comment as bb | `check.py` → q3_in_new=True all 9 frames | yes |
| GIF legend labels (bb, cc) | p₂ values unchanged by the fix, e.g. 1.25432 (bb fr2), 1.70349 (cc fr4), 1.73199 (cc fr9) | `disc9.jl` iterates 1.2543159902744359, 1.7034875047036455, 1.7319877986383865 round to these at 5 digits | yes |

## Scripts and GIFs
- Scripts changed: `mullersbb.jl`, `mullerscc.jl`. `mullersaa.jl` untouched.
- GIFs regenerated in place: `mullersbb.gif`, `mullerscc.gif` (9 frames each); both byte-identical to the scratch trial renders in `exp/`. `mullersaa.gif` not regenerated and unchanged.
- Frames viewed at full size: bb 1, 2; cc 1, 4, 9; contact sheets of all frames for both. Checked: parabola passes through the three points, reaches the axis crossing that gives the next iterate, is clipped (not flattened) at the window edges, legend p₂ matches the computed iterate.
- `git status --short -- pages/numerical-methods/mullers-method` after regeneration:
  ```
   M pages/numerical-methods/mullers-method/mullersbb.gif
   M pages/numerical-methods/mullers-method/mullersbb.jl
   M pages/numerical-methods/mullers-method/mullerscc.gif
   M pages/numerical-methods/mullers-method/mullerscc.jl
  ```

## Legacy archive
Consulted: `n2003/MullersMethodMod.html` and `mullersmethod/MullersMethodMod/Links/MullersMethodMod_lnk_2..4.html` (Examples 1–3, Newton vs Muller at a multiple root; Example 3 says "near x = 2"). There is no Muller animation in `a2001/Animations/RootFinding/` (only Bisection, FixedPoint, Newton, RegulaFalsi, Secant). Example 3's graph and Muller starting values are not recoverable: the module's images stop at `gr_144`, so Mathews' plot window for Example 3 could not be compared. Neither fix changes a function, root or starting value, so no fidelity question arises; Case 2 still reproduces Mathews' table (iterates unchanged, `disc9.jl`).

## Notes
- The page has no `## Description` section, which the page conventions require (`animation-page.agent.md` line 12). No finding names it, so it was not added.
- The round-2 review quotes f(1.3) = 1.236 and f(1.4) = 1.081 for Case 3; the correct values are 1.18411 and 1.03834. The error is in the review only, not on the page.
- The extended drawn range changes the parabola in every frame of both GIFs (the range now always reaches the next iterate), not just bb frame 1.

## Resolution check (independent checker, not shown this record)

Scope of the fix (from `git status`/`git diff HEAD` of the page folder): `mullersbb.jl`, `mullersbb.gif`, `mullerscc.jl`, `mullerscc.gif`. `index.qmd` and `mullersaa.*` are byte-identical to HEAD.

Independent computation: `check/geom.py` (mpmath, 50 digits). It fits the parabola through each triple by solving the 3x3 Vandermonde system, takes the polynomial root nearest p2, and asserts the root is real. It then reproduces the scripts' drawn x-range `[min(q0,q1,q2,q3)-0.2, max(...)+0.2]` and reports which part of the parabola falls inside the axis window.

### Original findings

### F1 — resolved
- Evidence: `mullersbb.jl` lines 78–79 now compute `q3 = muller_step(q0,q1,q2,f)` and draw the parabola over `[min(q0,q1,q2,q3)-0.2, max(q0,q1,q2,q3)+0.2]`.
- Frame 1 (triple 0.8, 0.9, 1.0): q3 = 1.25431599 (mp), drawn range [0.6000, 1.4543], P(q3) = 0 to 1e-50. The visible part of the parabola spans y from -0.193 to 1.666, so it crosses the axis inside the window.
- Viewed at full size: `new_mullersbb/frame_001.png` shows the dashed parabola crossing y = 0 at about x = 1.25 and continuing to the bottom border. The pre-fix `pre_mullersbb/frame_001.png` stops at about (1.2, 0.2).
- Frames 2–9: q3 lies inside the drawn range every time (geom.py).
- The same change was made in `mullerscc.jl` (lines 79–80), as suggested.
- The `clamp.` on the parabola was removed in both scripts, so the curve is now clipped by the axes. In bb frame 3 the parabola dips to about -0.12 and is drawn correctly, with no flat clamp segment (`frame_003.png`).

### F2 — resolved
- Evidence: `mullerscc.jl` now uses `xlims = (0.9, 2.1)` and `ylims = (-0.5, 1.5)`, as suggested. The `clamp.` on f has been dropped.
- Starting values f(1.3) = 1.184, f(1.4) = 1.038 and f(1.5) = 0.7031 all fit within the window. (The original finding's 1.236 and 1.081 were slightly off, which doesn't matter here.)
- The maximum of f in the window is about 1.19 near x = 1.29, so the hump is fully visible. f leaves the window only near x = 0.9 (f = -0.91) and x ≥ 1.93, where the axes clip it.
- Frames viewed at full size: 1, 2, 5 and 9, plus the contact sheet.
  - Frame 1: the parabola crosses the axis at about 1.63, matching q3 = 1.62764691.
  - Frame 2: the crossing is at about 1.674.
  - The parabola, its crossing and all three points are clearly readable. The points are 20–80 px apart in y through frame 5.
  - The points merge only from frame 7 on, when their spread is ≤ 0.011 in x and ≤ 0.0035 in y. That is inherent to convergence.
- No flat magenta segments remain at the borders. Clipping at the top and bottom borders renders cleanly.
- The legend (top left) does not overlap the curve or the parabolas in any frame.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd | (no change) | diff vs HEAD empty | n/a |
| mullersbb.jl l.76–77 comment | "drawn far enough to include its axis crossing (the next iterate); the plot window clips it at the axis limits" | q3 ∈ drawn range in all 8 drawn steps; clamp removed, so the axes clip | true |
| mullerscc.jl l.16 | `xlims = (0.9, 2.1)` | contains all iterates (1.3…1.73199) and root √3 = 1.7320508 | ok |
| mullerscc.jl l.17 | `ylims = (-0.5, 1.5)` + comment "window around the double root; the axes clip f and the parabolas" | all f(p_k) ∈ [0, 1.184]; crossing visible in every frame; clipping seen in frames | true |
| mullerscc.jl l.77–78 comment | same as bb | q3 ∈ drawn range in all frames (geom.py) | true |
| GIF legend labels, bb | p₂ = 1.0, 1.25432, 1.3223, 1.3689, 1.39706, 1.40841, 1.4127, 1.41392, 1.41417 | mp iterates 1.254316, 1.322299, 1.368897, 1.397059, 1.408413, 1.412696, 1.413924, 1.414174 rounded to 5 dp | all match |
| GIF legend labels, cc | p₂ = 1.5, 1.62765, 1.67427, 1.70349, 1.72005, 1.7275, 1.73063, 1.7317, 1.73199 | mp iterates 1.627647, 1.674268, 1.703488, 1.720047, 1.727501, 1.730631, 1.731704, 1.731988 rounded to 5 dp | all match |

The discriminant is positive at every step for both cases (mp roots are real), so the scripts' `error` branch is never reached. Iterates converge to √2 and √3.

### New problems
None. This rests on the following:
- Full-size views of frames 1, 3, 5 and 9 (bb) and frames 1, 2, 5 and 9 (cc), plus both contact sheets.
- Independent mp computation of every triple, q3 and drawn range.
- Label values checked against mp iterates.
- The page text is unchanged and still agrees with the new pictures: Case 3 alt text, "starting from p₂ = 1.5", and convergence to √3.

Note (pre-existing, not introduced by this fix): `index.qmd` has no `## Description` section before `## Animations`, which the convention file (`.github/agents/animation-page.agent.md` lines 12, 205) requires. It was already missing at HEAD.

### Reproducibility and conventions
- Both changed scripts were run from scratch copies (`check/run/`). Output sha256:
  - `mullersbb.gif` 0c5a7cb4…30a4
  - `mullerscc.gif` f66203eb…aa65
- These are byte-identical to the working-tree GIFs and match the LFS oids in the diff. Decoded frame md5s are also identical (9 frames each).
- Conventions:
  - Each case still has a source link and a GIF embed.
  - Alt text is descriptive.
  - There are no code blocks.
  - The Description section is missing, as noted above (pre-existing).
- Files changed by this fix: only the 4 files in the page folder. Other modified files elsewhere in the working tree belong to other pages' parallel fixes and are not part of this page's diff.

**Final status:** committed
