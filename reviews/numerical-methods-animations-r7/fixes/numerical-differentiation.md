# Fix record: numerical-differentiation

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/numerical-differentiation/fix/`
(`dump_ab.jl`, `check_ab.py`, `ab_dump.csv`, frame folders `old/`, `new/`, `legacyD1/`).

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: viewed `NumericalDiffMod_gr_327.gif` (Example 14 code, linked from `NumericalDiffMod_lnk_18.html`, "Solution 14 ... Animation 5"). It defines `m = (f[X+H]-f[X-H])/(2H)`, `g[x_] = f[X] + m (x - X)` and `q[x_] = Fit[{{X-H,..},{X,..},{X+H,..}}, {1,x,x^2}, x]` and plots `{f, g, q}` on [0, 2.1] (magenta, blue, green). Its output graphic `gr_328` and the frames of legacy Animation 5 (`a2001/Animations/Derivative/CentralD2.1f/CentralD1faa.gif`, 38 frames, sheet in `legacyD1/sheet.png`) show the same three curves. Frame 1 of the committed `numdiffab.gif` (`old/frame_001.png`) shows only f, the chord, the true tangent and the markers. So the page's "Case 2 follows Examples 11 and 14" was only half true. The finding holds.
- Change (R7-B: add Example 14's parabola and centre line):
  - `numdiffab.jl`: after `tangent_y`, added `c2 = (yr - 2y0 + yl)/(2h^2)`, `parab_y = y0 + msec(x-x0) + c2(x-x0)^2` (the parabola through the three stencil points, written in Newton form about x0) and `centre_y = y0 + msec(x-x0)`; added two `plot!` calls: green solid "parabola through the 3 stencil points", purple dotted "line through (x0, f(x0)), secant slope". Nothing else changed (steps, window, title, other curves).
  - `index.qmd` Case 2 Behavior: appended "As in Example 14, each frame also draws the parabola through the three stencil points and the line through $(x_0,f(x_0))$ with the secant slope; that slope is the parabola's derivative at $x_0$, so the line touches the parabola there and runs parallel to the chord."
  - `index.qmd` Case 2 alt text: now names the parallel lines through the point at x0 collapsing to the tangent with the chords, and says the parabola through the three stencil points is drawn in each frame (it is not said to collapse to the tangent, since it does not).
  - Line 26 ("Case 2 follows Examples 11 and 14, the central difference at $x_0=1$") left as is; it is now true.
- Check: `julia dump_ab.jl` (instrumented copy of the drawing arrays) then `/usr/bin/python3 check_ab.py` (mpmath, 50 digits, parabola built independently by Lagrange interpolation). For all 12 steps: max |script parabola − Lagrange parabola| ≤ 5.3e-12 (h = 0.001; ≤ 1.2e-13 for the other steps); q′(x0) equals the central difference D3 to all printed digits (|q′(x0) − D3| displayed 0.0 at 50-digit precision); max |script centre line − (f(x0) + q′(x0)(x−x0))| ≤ 4.3e-15; chord minus centre line is a constant (spread ≤ 8.3e-17 over the 200 plot points), i.e. parallel, offset −7.8e-02 at h = 0.6 down to −2.0e-07 at h = 0.001. Parabola y-range over all frames 0.0488 to 0.3250, inside ylims (−0.1, 0.55), so nothing is clipped. Frames 1, 5 and 12 viewed at full size and the 12-frame sheet: parabola passes through all three markers, dotted line touches the parabola at x0 and is parallel to the dashed chord, legend does not cover any curve.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 2 Behavior | "As in Example 14, each frame also draws the parabola through the three stencil points and the line through (x0, f(x0)) with the secant slope" | `gr_327` code defines exactly q (Fit through the 3 points) and g = f[X] + m(x − X); script now plots both in every frame (12/12 frames in `new/sheet.png`) | yes |
| Case 2 Behavior | "that slope is the parabola's derivative at x0" | `check_ab.py` → |q′(x0) − D3| = 0.0 (50 digits) for all 12 h; algebraically q′(x0) = (yr − yl)/(2h) | yes |
| Case 2 Behavior | "so the line touches the parabola there" | line passes through (x0, f(x0)) = (x0, q(x0)) with slope q′(x0): tangent to q; `check_ab.py` max |centre − g| ≤ 1.5e-14; visible in frames 1–4 | yes |
| Case 2 Behavior | "and runs parallel to the chord" | `check_ab.py` → chord − centre spread ≤ 8.3e-17 (constant offset) for every h | yes |
| Case 2 alt text | "central secant lines ... and parallel lines through the point at x0, collapsing to the tangent line at x0 equals 1" | both slopes are D3 → f′(1): D3 from −0.049354 (h = 0.6) to −0.110794 (h = 0.001), f′(1) = −0.110793765306699 (`check_ab.py`); chord offset from centre line → −2.0e-07 | yes |
| Case 2 alt text | "with the parabola through the three stencil points drawn in each frame" | 12/12 frames show the green parabola (`new/sheet.png`) | yes |
| GIF legend | "parabola through the 3 stencil points" | `check_ab.py` max |parab − Lagrange q| ≤ 5.3e-12 | yes |
| GIF legend | "line through (x0, f(x0)), secant slope" | `centre_y = y0 .+ msec .* (line_x .- x0)`; `check_ab.py` | yes |

## Scripts and GIFs
- Script changed: `numdiffab.jl`. Regenerated with `julia numdiffab.jl` from the page folder → `numdiffab.gif` (12 frames, as before). `numdiffaa.jl`/`numdiffaa.gif` untouched and unchanged.
- Frames extracted to `new/` with the frame tool; viewed frames 1 (h = 0.6), 5 (h = 0.1), 12 (h = 0.001) at full size and the 12-frame sheet. Titles unchanged (secant slope and true value, same numbers as before). At h ≤ 0.07 the chord, centre line and tangent overlap at pixel scale, as expected.
- `git status --short -- pages/numerical-methods/numerical-differentiation` after regeneration: `M index.qmd`, `M numdiffab.gif`, `M numdiffab.jl`. Also present: untracked `index.html` and `index_files/`, timestamped 22:45:19, after my last regeneration (22:44:33); I did not run quarto, so another process rendered the page. They should not be committed.

## Legacy archive
Consulted. `NumericalDiffMod_lnk_18.html` (Example 14 / Animation 5), images `gr_327` (code), `gr_328` (graph), `gr_329` (printout: true f′[1.] = −0.110794, h = 0.5), and the legacy GIF `CentralD1faa.gif`. Example 14 draws f, the parabola q through the three points and the line g through (X, f(X)) with slope m, on [0, 2.1], with H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}; the sampled Animation 5 frames show h = 1.0, 0.8, 0.6, 0.4, 0.2, 0.08, 0.04, 0.008, 0.001. Example 14 does not draw the chord or the true tangent; those come from Example 11 / Animation 6, which the page also follows. Differences kept: the page's step list (from Animation 6, per the round-7 review's claim 34), its [0, π] window, and its drawing of the lines over x0 ± 0.9 rather than [0, 2.1]. None was raised as a finding.

## Notes
- Line 26 wording was not changed: after the script change it is accurate, and the smallest change was preferred (R7-D).
- Untracked `index.html` / `index_files/` in the page folder were not created by me (see above).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fixer chose option 2: `numdiffab.jl` now draws the Example 14 parabola through the three stencil points (green) and the line through (x0, f(x0)) with the central-difference slope (purple dotted). The chord and the true tangent are still drawn. So the line 26 claim "Case 2 follows Examples 11 and 14" (unchanged) is now true.
- Construction checked against legacy `NumericalDiffMod_gr_327.gif`: Mathematica builds `g[x] = f[X] + m (x - X)` and `q[x] = Fit[...3 points..., {1,x,x^2}]`. The script builds the same objects: `centre_y = y0 + msec (x-x0)`, and `parab_y = y0 + msec (x-x0) + c2 (x-x0)^2` with `c2 = (yr-2y0+yl)/(2h^2)`.
- By hand: p(x0±h) = y0 ± (yr-yl)/2 + (yr-2y0+yl)/2, which gives yr and yl. p(x0) = y0, and p'(x0) = msec.
- In mpmath at 40 digits (`check/chk.py`), I fitted the quadratic directly by solving the 3x3 Vandermonde system for all 12 h values. Its derivative at x0 minus msec is at most 3e-42, and its leading coefficient minus the script's c2 is at most 4e-42.
- Frames 1, 6 and 12 at full size: in frame 1 (h=0.6) the parabola passes through all three markers. The dotted line touches it at x0 and is visibly parallel to the dashed chord. As h shrinks, the chord, the centre line and the tangent merge, and the parabola tends to the osculating parabola. The middle marker now has a visible role.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.38 | "As in Example 14, each frame also draws the parabola through the three stencil points and the line through (x0,f(x0)) with the secant slope" | Matches the script (lines 40-43, 65-66), the frames and the legacy gr_327 construction | true |
| index.qmd l.38 | "that slope is the parabola's derivative at x0" | Algebra above, plus mpmath fit (diff ≤ 3e-42) | true |
| index.qmd l.38 | "so the line touches the parabola there and runs parallel to the chord" | Same slope msec and same point (x0,y0), so the line is tangent to the parabola. The chord has slope msec, so the two are parallel. Seen in frame 1 | true |
| index.qmd l.42 alt | "central secant lines through x0-h and x0+h, and parallel lines through the point at x0, collapsing to the tangent line at x0 = 1 ... parabola through the three stencil points drawn in each frame" | Matches frames 1, 6 and 12 | true |
| numdiffab.jl legend | "parabola through the 3 stencil points", "line through (x0, f(x0)), secant slope" | Matches what is drawn; legible at full size | true |
| GIF titles (unchanged code) | secant slope -0.049354 (h=0.6), -0.109963 (h=0.07), -0.110794 (h=0.001); true -0.110794 | mpmath: -0.049353743, -0.10996341, -0.1107936; f'(1) = -0.1107937653. Error ratio from h=0.01 to h=0.005 is 3.99, consistent with O(h^2) | true |

### New problems
None. This rests on:
- the algebraic and high-precision check of the parabola and the line;
- full-size frames 1, 6 and 12, where nothing that was right before is broken: f, the chord, the tangent, the markers and the title are unchanged, the legend does not cover the curves, and ylims clip nothing important;
- the wording check above.

### Reproducibility and conventions
- A scratch copy of `numdiffab.jl` regenerates `numdiffab.gif` byte-identically (`cmp` reports no difference). There are 12 frames, and the decoded frame md5s match.
- The page keeps its conventions: Description comes before Animations, each case has a Julia source link and a GIF embed, the alt text is descriptive, and there are no code blocks.
- The fix diff touches only `index.qmd`, `numdiffab.jl` and `numdiffab.gif` in the page folder. The untracked `index.html` and `index_files/` come from the owner's preview and were ignored.
- The owner-decisions README could not be read: the tool permission classifier denied access. This does not affect the verdict, because the fix applies the finding's own suggested correction 2.

**Final status:** committed
