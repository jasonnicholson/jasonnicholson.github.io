# Fix record: chebyshev-approximation-polynomial

Scratch folder (all commands below run from it):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/chebyshev-approximation-polynomial/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:** `julia repro.jl` (loads the committed script's own definitions, `repro.out`) and `python3 indep.py` (independent route: Chebyshev coefficients and scipy functions, `indep.out`). Both give, at n = 16 on the plotting grid:
  - case 04: P(2.1021) = 1.5156 (f = 1.4499); P(2.2072) = 2.6948 (f = 1.4857); P(2.5015) = 213.5168 (f = 1.5816)
  - case 24: P(2.1027) = -3.1524 (f = 1.0479); P(2.2000) = -64.9009 (f = 1.1018)
  - case 29: P(5.0210) = 1.0304 (f = -0.3116)

  The committed frames drew no interval marker. The finding holds.
- **Correction to the finding's case list:** the finding lists 01–07, 09–11, 14, 19, 24–29 as wider than their interval. Case 08 is too (window ±1.5, interval [-1, 1]), making 19 such cases. The other 10 (12, 13, 15–18, 20–23) have window = interval.
- **Change:**
  - `chebyshev_animations_all.jl`, `render_case`: added `vline!(pplot, collect(span); color=:green, ls=:dash, lw=1.5, label="interval ends")`; `legend_columns` 3 → 4 so the legend stays on one row.
  - Same function: where an interval endpoint coincides with the window edge (cases 01, 04–06 on the left; 12, 13, 15–18, 20–23 on both sides), the axis limit extends 1.5% of the window width past it (`xview`). The curves are still computed and drawn on the original grid, and the y-limits are unchanged.
  - `index.qmd`, Animations introduction: added one sentence (see ledger).
- **Check:** `python3 check.py` (`check.out`) measures the green lines in the pixels of all 294 frames of the 29 GIFs: each frame has exactly two, within 0.46 px of the interval endpoints mapped through the axis.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd`, Animations intro | "Green dashed vertical lines mark the ends of the approximation interval" | `check.py` → 294 frames, 2 lines each, worst offset 0.46 px from the interval ends | yes |
| `index.qmd`, Animations intro | "outside them the blue curve is extrapolation" | Interpolant is built only from nodes inside [a, b]; `check.py` → drawn outside the interval in 19 cases | yes |
| `index.qmd`, Animations intro | "and can leave the frame" | `check.py` (independent coefficient route against the script's y-limits) → at the largest n it leaves the y-window outside the interval in 18 of those 19 cases, all but 06. "Can", not "does": case 06 stays in frame at n = 16 | yes |
| GIF legend, all frames | "interval ends" | Same line check as row 1; label read in full-size frames of cases 01, 04, 08, 12, 14, 19, 24, 29 | yes |
| Script comment | "drawn as green lines, as in the Mathews animations" | `legacy_green.out` → all 12 legacy Chebyshev GIFs have 2 green vertical lines in the last frame | yes |
| Script comment | "A line on the edge of the plotting window would be clipped and lie on the frame" | `edge_test.jl`, `edge_test.out` → unpadded line covers 1 pixel column at each edge (66, 747); padded covers 2 (75–76, 737–738). My first wording, "hidden", was wrong and was replaced | yes |

## Scripts and GIFs

- **Script changed:** `chebyshev_animations_all.jl`. **GIFs regenerated:** all 29, as the brief expects. Frame counts are unchanged (10 each, 14 for case 08).
- **Frames viewed at full size:** case 01 frame 1; case 04 last; case 08 last; case 12 last; case 14 frame 1; case 19 frame 6; case 24 last; case 29 frame 5. Last frames of all 29 viewed on one contact sheet (`all/all_last.png`). Checked: lines at the interval ends, including cases where the window equals the interval; legend on one row and legible; titles unchanged; nodes inside the lines.
- The final comment-only edit was followed by a rerun: all 29 GIFs are byte-identical to the previous run (`sha256sum -c gif_before.sha256`).
- **git status of the page folder after regeneration:** 31 modified (29 GIFs, `chebyshev_animations_all.jl`, `index.qmd`), nothing added or deleted.

## Legacy archive

Consulted. `a2001/Animations/Interpolation/Chebyshev/` holds 12 animated Chebyshev GIFs (aaa, bb, bbb, cc, ccc, dd, ff, jj, ll, oo, xx, zz). The last frame of each has two green vertical lines (`legacy_green.out`), and the case 24 sheet (`legacy/xx/sheet.png`) shows them at the interval ends 0.05 and 2. The page's lines are dashed so they read against the grid; Mathews' are solid. His tolerance band and shaded convergence regions are not added, because the finding does not ask for them.

## Notes

- The new sentence does not say the blue curve stays in frame inside the interval, because it does not always: at low n it leaves the y-window inside the interval in cases 08 (n = 3), 12 (n = 8), 13 (n = 5, 6), 22 (n = 3), 23 (n = 2) and 27 (n = 8) (`repro.out`). At the largest n it stays in frame inside the interval in all 29 cases.
- The finding's "expected to diverge" was not used: case 06 stays in frame at n = 16, so "can leave the frame" is the wording the runs support.
- Other pages show uncommitted changes in `git status` (for example `laurent-series`). They are not from this fix and were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence, lines: every frame of all 29 GIFs (294 frames) was decoded. Each frame has exactly two green dashed vertical lines inside the plot box. Their pixel columns were compared with the positions computed from each case's stated interval and x-axis limits. Largest deviation over all cases and frames: 0.63 px.
- Evidence, cases whose window equals the interval (12, 13, 15, 16, 17, 18, 20, 21, 22, 23) and cases sharing one endpoint with the window (01, 04, 05, 06): the line is drawn inside the frame, because the axis is widened by 1.5% of the window on that side. It does not lie on the border. Lines were measured at the correct x in these cases too.
- Evidence, stated intervals: the interval in each case's alt text was parsed and compared with the interval the script uses: 29 of 29 agree. Frame titles are generated from the same interval and were read on first, middle and last frames.
- Evidence, text: the added sentence says the lines mark the interval ends and that the blue curve outside them is extrapolation and can leave the frame. All nodes lie inside the interval (no case uses the script's trim fallback, at any n). In 18 of the 19 cases whose window is wider than the interval, the interpolant leaves the frame outside the interval for at least one n (the exception is case 06). So "can" is accurate.
- Fidelity: the legacy frame Chebyshevxx.gif (case 24) shows vertical green lines at about 0.05 and 2, as the code comment says.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd, Animations intro | "Green dashed vertical lines mark the ends of the approximation interval" | Pixel positions against intervals, all 29 cases, all frames, max deviation 0.63 px | True |
| index.qmd, Animations intro | "outside them the blue curve is extrapolation" | All nodes inside interval for every case and n; no trim fallback used | True |
| index.qmd, Animations intro | "and can leave the frame" | Leaves the frame outside the interval in 18 cases | True |
| Script, legend | "interval ends", 4 legend columns | Read in full-size frames (04, 12, 15, 24); not clipped | Correct |
| Script, comment | Green lines "as in the Mathews animations" | Legacy Chebyshevxx frame | True |
| Script, comment | Axis, not the curves, extends past an endpoint on the window edge | `xplot` unchanged; `xview` used only for `xlims`; padded on exactly the 14 cases with a shared endpoint | True |

### New problems
None. This rests on the following:
- First, middle and last frames of all 29 cases viewed (half scale), and full-size frames of 04, 12, 15 and 24.
- For the 15 cases with an unchanged axis, old and new frames were compared inside the plot box. Away from the green lines, at most 22 pixels per frame differ, consistent with GIF palette changes. Frame counts are unchanged in all 29 cases.

Noted, not defects:
- At low n the interpolant also leaves the frame inside the interval in a few cases: 08 (n=3), 12 (n=8), 13 (n=5, 6), 22 (n=3), 23 (n=2), 27 (n=8). The new sentence does not claim otherwise. At the final n of every case no curve leaves the frame inside the interval.
- The finding's "largest error at n = 16 is 0.65, in case 25" is the maximum on the 1000-point plotting grid (0.648, at x = 0.081). On a 4001-point grid over the interval the maximum is 1.10, at the endpoint x = 0.05. This number is not on the page.

### Reproducibility and conventions
- Script run unmodified from a scratch copy: all 29 GIFs byte-identical to the working-tree GIFs.
- Page keeps Description before Animations, one source link (single script for all cases), 29 headings and 29 embeds with descriptive alt text, no code blocks.
- fix.diff touches only the page folder (31 files: 29 GIFs, script, index.qmd). Other pages show uncommitted changes in the working tree (for example laurent-series), but they are not part of this fix.

**Final status:** committed
