# Fix record: lagrange-polynomial-interpolation-and-approximation

Scratch folder (all scripts and outputs, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/lagrange-polynomial-interpolation-and-approximation/fix/`

- `defs_orig.jl` / `defs_new.jl`: the shared script before / after the fix, with its final render loop removed, so its own `cases`, `safe_eval`, `robust_ylims`, `equal_nodes` can be called without writing GIFs.
- `repro_f1.jl`: recomputes the y-limits exactly as `render_case` does and scans the clamped f of every case for edge-to-edge jumps.
- `indep_tan.py`: independent mpmath check of tan on the 1000-point plot grid.
- `check_new.jl`: y-limits and NaN break points of the pole cases after the fix.
- `committed14/`, `new14/`: frames and contact sheets of the committed and regenerated `lagnewt14.gif`.

This page shares `lagnewt_animations_all.jl` with `newton-interpolation-polynomial` (WP-B). Both copies were changed identically and remain byte-identical (`cmp` → no output). The Newton page's finding is recorded in `fixes/newton-interpolation-polynomial.md`.

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - `julia repro_f1.jl` (original script definitions) printed, for Case 14 only, `edge-to-edge jump between x=-1.5755134328813678 and -1.569223958099406; f = 211.9928118273756, -635.9826284721628` and `between x=1.569223958099406 and 1.5755134328813678; f = 635.9826284721628, -211.9928118273756`, with `ylims = (-27.791560875265176, 27.791560875265176)`. No other case without a pole has an edge-to-edge jump of the clamped f. No grid point equals ±π/2 (`any grid x == ±pi/2: false`).
  - `python3 -I indep_tan.py` (mpmath tan on `linspace(-π, π, 1000)`): the same two sign changes, with the pole inside each pair of samples; |tan x| > 27.79 only within 0.0360 of ±π/2 (grid step 0.00629).
  - Committed frame `committed14/frame_004.png`: full-height vertical magenta segments at x ≈ ±π/2.
- **Change:**
  - `lagnewt_animations_all.jl` (both copies): field `pole::Float64` (NaN if none) → `poles::Vector{Float64}` (empty if none); `with_span(...; pole=NaN)` → `poles=Float64[]`; `auto_span` passes `Float64[]`; Cases 01/03 `pole=1.0` → `poles=[1.0]`, Case 02 `pole=-1.0` → `poles=[-1.0]`; Case 14 row gains `poles=[-pi/2, pi/2]`; `has_pole = !isempty(case.poles)`; the break inserts a NaN point at each pole (`xf = sort(vcat(xplot, case.poles))`, `x in case.poles ? NaN : …`). The case-table comment now says "For 01-03 and 14 (poles given) … f is broken at each pole and left to run off the window."
  - `index.qmd` l.25: "except $f$ in Cases 01–03, which runs off the window and is broken at its pole." → "except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles."
  - `index.qmd` Case 14 alt text: "…drawn with f on [−π, π]." → "…drawn with f on [−π, π] and broken at its poles x = ±π/2."
- **Check:**
  - Case 14 now takes the pole branch, whose y-limits come from f on the node interval rather than the window. `repro_f1.jl` computed both before the change: window-based ylims_f = (−13.92, 13.57), span-based ylims_f = (−14.42, 14.36). Both are inside the node-value range (±22.4125), so the final y-limits are (−27.791560875265176, 27.791560875265176) either way. `julia check_new.jl` (fixed script) confirms ylims for Case 14 unchanged, NaN at x = −1.5707963267948966 and 1.5707963267948966, neighbours 211.99 / −635.98 and 635.98 / −211.99 (unclamped, so they run off the window). Cases 01–03 give the same y-limits and break points as before.
  - Regeneration: only `lagnewt14.gif` changed (md5 10a68184… → 2e665fca…); the other 28 GIFs are byte-identical (`md5_before.txt` vs `md5_after.txt`).
  - Frames `new14/frame_001.png`, `frame_004.png`, `frame_010.png` at full size and `new14/sheet.png` (all 10): f is broken at ±π/2 in every frame and leaves through the top and bottom edges; no vertical connector. Axes, titles ("degree 1" … "degree 15"), nodes and interpolant are as before (frame_004 compared with `committed14/frame_004.png`: only the two vertical segments are gone).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.25 | "except $f$ in Cases 01–03 and 14, which runs off the window" | Script: `has_pole` true exactly for 01, 02, 03, 14 (`check_new.jl` lists those four); in that branch f is drawn unclamped, so off-window parts are not drawn along the edge. Values beside the poles exceed the y-limits: Case 14 211.99, 635.98 vs 27.79; Case 01 370.0 vs 11.25 (`check_new.jl`) | yes |
| index.qmd l.25 | "is broken at each of its poles" | `check_new.jl` → NaN inserted at x = 1 (01, 03), −1 (02), ±1.5707963267948966 (14); 01–03 have one pole each in their windows, tan has exactly two in [−π, π] (π/2 + kπ, k = −1, 0). Frames `new14/frame_001..010` show the breaks | yes |
| index.qmd Case 14 alt | "drawn with f on [−π, π] and broken at its poles x = ±π/2" | Script row 14: xlims (−π, π), poles [−π/2, π/2]; frames as above | yes |
| script comment l.29–30 | "For 01-03 and 14 (poles given) the y-limits come from f on the node interval, and f is broken at each pole and left to run off the window." | Code: `has_pole` branch uses `robust_ylims` over `span` and unclamped f with NaN at `case.poles` | yes |

## Scripts and GIFs
- Script changed: `lagnewt_animations_all.jl` (copied byte-identically to the Newton page).
- Regenerated in place with `julia lagnewt_animations_all.jl` (37 s). Only `lagnewt14.gif` changed. The Newton page's copy was regenerated there too and gives the same 29 md5s; every `lagnewtNN.gif` is byte-identical across the two pages.
- Frames viewed: new Case 14 frames 1, 4 and 10 at full size and the full contact sheet; committed frame 4 for comparison.
- `git status --short -- pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation` →
  ` M …/index.qmd`, ` M …/lagnewt14.gif`, ` M …/lagnewt_animations_all.jl`.

## Legacy archive
Consulted. `a2001/Animations/Interpolation/Lagrange/Lagrange.html` lists the 29 cases (the case table was already checked against it by the reviewer). The Case 14 page `Lagrange14/Lagrangenn.html` references `Lagrangenn.gif`, which is not in the archive, so Mathews' own drawing of tan near its poles cannot be compared. The fix is a plotting correction (f has no values between the window limits at ±π/2) and does not depend on the archive.

## Notes
- The reviewer offered a second option, NaN wherever consecutive clamped f values jump edge to edge. I used the explicit pole list (the reviewer's first option) because it matches the existing Case 01–03 mechanism and leaves the other 28 GIFs byte-identical.
- Cases 24–26 (Γ at 0) still break only because a grid sample lands on x = 0.0 exactly (reviewer's note). They are correct as drawn and no finding names them, so they were not given an explicit pole.
- The Newton page embeds the same `lagnewt14.gif` and makes no statement about how curves leaving the window are drawn, so no Newton text needed changing for this fix.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (script): `InterpCase.pole::Float64` became `poles::Vector{Float64}`; Case 14 now passes `poles=[-pi/2, pi/2]`. In `render_case`, `xf = sort(vcat(xplot, case.poles))` and `yf` is NaN exactly at the inserted pole abscissae and unclamped `tan` elsewhere. Checked in a scratch run (`ylims_check.jl`): NaN points land at x = ±1.5707963267948966, and they sit between the straddling samples the finding named: (−1.57551, 211.99) | (−1.56922, −635.98) and (1.56922, 635.98) | (1.57551, −211.99). So the line no longer joins the +edge to the −edge across either pole. Cases 01–03 now pass `poles=[1.0]` / `[-1.0]`, which is the same logic as before, and their GIFs are byte-identical to HEAD.
- Side effect checked: with `has_pole` now true for Case 14, `ylims_f` comes from `tan` on the node interval [−3, 3] (≈ (−14.42, 14.36)) instead of on [−π, π] (≈ (−13.92, 13.57)). The final y-limits are set by the node values (max |tan(node)| = 22.41), so they are ±27.7916 both before and after. The window is unchanged.
- Evidence (GIF): I extracted all 10 frames of the pre-fix (HEAD, via `git lfs smudge`) and the new `lagnewt14.gif`, and viewed frames 1, 5 and 10 at full size. The pre-fix frames show the full-height vertical magenta segments at x ≈ ±π/2. The new frames show tan x as separate branches, each running off the top or bottom of the window, with no vertical segment. A pixel diff (threshold > 60) puts all real changes in image columns 220–260 and 560–580, which are the two pole locations. Lower-level differences elsewhere are GIF palette quantization. The interpolant, nodes, title, legend and axes are unchanged.
- Evidence (text): the Animations intro now reads "…except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles." That matches the frames: f in Case 14 leaves the window only within 0.033 of ±π/2 and is broken at both poles. The blue interpolant is still clamped to the edges, as the sentence says.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.25 | "except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles" | Script: `poles` is non-empty exactly for 01, 02, 03 and 14. f is unclamped with NaN at each pole (frames viewed). Cases 01–03 have one pole each, and "each of its poles" still reads correctly there. | correct |
| index.qmd l.87 alt text | "drawn with f on [−π, π] and broken at its poles x = ±π/2" | Window `xlims=(-pi, pi)`. The tan poles in (−π, π) are exactly ±π/2. Breaks are visible in all 10 frames. | correct |
| script l.17, 21–23 | `poles::Vector{Float64}`, `poles=Float64[]` defaults | Cases without poles behave as before: all 28 other GIFs regenerate byte-identical to HEAD. | correct |
| script l.30–31 comment | "For 01-03 and 14 (poles given) the y-limits come from f on the node interval, and f is broken at each pole…" | Matches the code (l.181–183, 196–201). | correct |
| script l.32–34 | `poles=[1.0]`, `[-1.0]`, `[1.0]` | Poles of 1/(1−x), 1/(1+x), 1/(1−x)²: x = 1, −1, 1. | correct |
| script l.47 | `poles=[-pi/2, pi/2]` | The poles of tan in [−π, π] are ±π/2. None are missed: the next poles, ±3π/2, lie outside the window. | correct |
| script l.180, 199–200 | `has_pole = !isempty(...)`; `x in case.poles` | The exact-equality membership test works because the same Float64 values are inserted into `xf`. NaN positions were confirmed. | correct |

### New problems
None. This rests on:
- the regenerated GIF reproduces byte-for-byte;
- the y-limits are unchanged (±27.7916, computed);
- the pixel diff is confined to the pole columns;
- frames 1, 5 and 10 were viewed at full size;
- the other 28 GIFs are byte-identical to HEAD.

### Reproducibility and conventions
- I ran a scratch copy of `lagnewt_animations_all.jl` with `julia lagnewt_animations_all.jl`. All 29 output GIFs are byte-identical to the working-tree GIFs in this folder, including the new `lagnewt14.gif` (sha256 96244afb…). Only `lagnewt14.gif` differs from HEAD (git status).
- `lagnewt_animations_all.jl` is byte-identical (`cmp`) to the copy in `newton-interpolation-polynomial/`. All 29 `lagnewt*.gif` files are pairwise identical across the two folders (sha256), including `lagnewt14.gif`.
- Conventions:
  - Description precedes Animations.
  - There is a source link for all cases, and 29 `### Case` headings, each with an embed and descriptive alt text.
  - There are no code blocks.
- Files changed in this folder: index.qmd, lagnewt14.gif and lagnewt_animations_all.jl. The only other change for this fix is the shared-script twin in `newton-interpolation-polynomial/`. Other modified files in the working tree (laurent-series, pade-approximation, richardson-extrapolation, runge-kutta-method) belong to other pages' fixes and are not part of this diff.

**Final status:** committed
