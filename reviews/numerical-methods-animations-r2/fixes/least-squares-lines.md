# Fix record: least-squares-lines

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/least-squares-lines/fix/`
(called `$F` below). Files: `indep.py` / `indep.out` (exact rationals plus numpy lstsq), `inst_aa.jl` / `inst_ac.jl` and their `.out` files (the scripts' own fit functions, instrumented), `measure.py` (pixel measurement of the residual segments per frame), `committed/` and `new/` (extracted frames and `measure_*.txt`), and `exp/` (the trial scripts and GIFs).

## Findings

### F1 — Misleading — fixed (script fix, both GIFs regenerated, text reworded)
- **Reproduced.** I extracted the committed frames with `giftools.jl` and ran `/usr/bin/python3 $F/measure.py committed/lslinea{a,c} {aa,ac} steelblue`. This counts pixels within ±30 of steelblue (70,130,180) inside the plot box. It also maps each data point's column, using the plot box detected from the frame (25.63 px per y-unit for Case 1, 26.62 for Case 3), and counts the pixel rows holding segment colour in that column.
  - The totals per frame match the review exactly. Case 1: 0, 2, 7, 18, 29, 53, 53. Case 3: 0, 1, 3, 17, 21, 33, 32, 31.
  - Case 3, frame 8: 0 or 1 visible rows at x = 1, 2, 7, 8, although the x = 1 residual is 0.461 (12.3 px). The remaining stubs are 5 to 10 rows.
  - Case 1, frame 7: 0 or 1 rows at x = −1, 0, 1. The x = 4 and x = 5 stubs are 20 and 16 rows.
  - I viewed `committed/lslineac/frame_008.png` at native size: no residual is discernible. The finding holds as corrected by the independent check: residuals are mostly invisible, and Case 3 is almost entirely invisible.
- **Change.** I made the residuals visible, which is the review's first option. The text then describes the new picture.
  - `lslineaa.jl` line 42 and `lslineac.jl` line 31: the "points used" markers go from `ms=6` to `ms=4, msw=0`. This is the same size as the grey "all data" markers, with no black outline.
  - `lslineaa.jl` line 51 and `lslineac.jl` line 37: the residual segments go from `color=:steelblue, lw=1.2` to `color=:navy, lw=2.5`.
  - Nothing else changed in the scripts: no data, fit, limits, figure size or annotation changes.
  - `index.qmd`: line 22 (Animations intro), the Case 1 alt text (line 30) and the Case 3 alt text (line 46) were reworded. See the ledger.
- **Check.** I regenerated both GIFs in place and ran the same measurement on the new frames with the navy colour. Navy pixels per frame:
  - Case 1: 6, 43, 64, 71, 91, 126, 129.
  - Case 3: 3, 38, 46, 69, 75, 95, 104, 129.

  Per segment, every nonzero residual now shows navy rows, and the length tracks the residual.
  - Case 1, frame 7: x = 4 (0.786, 20.1 px) gives 22 rows, x = 5 gives 17 rows, x = 1 (0.036) gives 2 rows.
  - Case 3, frame 8: x = 1 (0.461) gives 14 rows and x = 2 (0.078) gives 4 rows.

  I viewed full-size frames `new/lslineaa/frame_001, 004, 007` and `new/lslineac/frame_001, 004, 008`, plus 4× crops `zoom_aa6.png` and `zoom_ac8.png`. The segments are visible dark-blue ticks from each red point to the line. In the crops the segment is drawn over the marker, so even the 0.036 and 0.078 residuals show as a dark speck. Frame 1 of each case has zero residuals: 2 points on their own line in Case 1, 1 point through the origin in Case 3.

### F2 — Minor — fixed (text)
- **Reproduced.** `/usr/bin/python3 -I $F/indep.py` gives the exact fits a_k = 2, 8/5, 23/14, 47/30, 87/55, 141/91, 109/70, 157/102, which are 2.0, 1.6, 1.64286, 1.56667, 1.58182, 1.54945, 1.55714, 1.53922.
  - The steps are −0.4, +0.0429, −0.0762, +0.0152, −0.0324, +0.0077, −0.0179. The signs alternate and the last step is not small.
  - `julia $F/inst_ac.jl` (the script's own `fit_through_origin`) gives the same values, ending at 1.5392156862745099.

  So "settles near" is not supported, and the finding holds.
- **Change.** `index.qmd` line 42: "The coefficient settles near $a \approx 1.5392$ for the legacy dataset." → "With all eight points of the legacy dataset the fit is $a = 157/102 \approx 1.5392$; as points are added the coefficient zig-zags downward from 2."
- **Check.** In `indep.out`:
  - The step signs alternate −, +, −, … (True).
  - The local highs at k = 1, 3, 5, 7 (2, 1.64286, 1.58182, 1.55714) and the local lows at k = 2, 4, 6, 8 (1.6, 1.56667, 1.54945, 1.53922) both decrease strictly (True, True).
  - a_1 = 2 exactly, and a_8 = 157/102 = 1.5392156… is below every earlier a_k (True).

  The frame annotations ("a = 2.0" in frame 1, "a = 1.56667" in frame 4, "a = 1.53922" in frame 8) agree.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.22 | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | Scripts draw `plot!([x_i,x_i],[y_i, fit(x_i)]; color=:navy)` for every point used. Navy = RGB (0,0,128). Segments seen in the new frames (F1 Check) | yes |
| index.qmd l.22 | "so you can see the distances whose squares the least-squares criterion adds up" | Both fits minimise Σ(y_i − fit(x_i))² over the vertical residuals. The scripts' closed forms equal numpy lstsq at every k (`indep.py` asserts, to 1e-12) | yes |
| index.qmd l.22 | "the largest residual in any frame is about 0.79 in Case 1" | `indep.out`: Case 1 max \|r\| over k = 2..8 is 11/14 = 0.785714 (k = 7, point x = 4). `inst_aa.out`: 0.7857142857142865 | yes |
| index.qmd l.22 | "…and 0.46 in Case 3" | `indep.out`: Case 3 max \|r\| over k = 1..8 is 47/102 = 0.460784 (k = 8). `inst_ac.out`: 0.4607843137254901 | yes |
| index.qmd l.22 | "These data lie close to their lines … so the segments are short" | 0.79 is 20.1 px at 25.63 px/unit and 0.46 is 12.3 px at 26.62 px/unit, in 345-px-tall plot boxes (`measure_*.txt`) | yes |
| index.qmd l.22 | "some are barely visible" | Smallest nonzero residuals are 0.036 (Case 1, 2 navy rows) and 0.071 (Case 3, 4 rows) (`indep.out`, `new/measure_*.txt`). 4× crops show these as a dark speck on the marker | yes |
| index.qmd l.30 (Case 1 alt) | "…with each vertical residual drawn as a short dark blue segment from the point to the line." | As in the l.22 rows; frames `new/lslineaa/frame_001/004/007` viewed | yes |
| index.qmd l.42 (Case 3) | "With all eight points of the legacy dataset the fit is $a = 157/102 \approx 1.5392$" | `indep.out`: a_8 = 157/102 = 1.5392156862745099. `inst_ac.out` gives the same. The data are identical to the archive's Example 4 points (round-2 review C3.3) | yes |
| index.qmd l.42 | "as points are added the coefficient zig-zags downward from 2" | `indep.out`: a_1 = 2; the step signs alternate; local highs and local lows both strictly decrease; a_8 is below all earlier a_k | yes |
| index.qmd l.46 (Case 3 alt) | "…as points are added, with each vertical residual drawn as a short dark blue segment from the point to the line." | Frames `new/lslineac/frame_001/004/008` viewed. Points are added one per frame, k = 1..8 | yes |
| lslineaa.jl l.42, lslineac.jl l.31 | `ms=4, msw=0` | Style only. Red markers are now the size of the grey ones and no longer cover the segments (F1 Check) | yes |
| lslineaa.jl l.51, lslineac.jl l.37 | `color=:navy, lw=2.5` | Style only (F1 Check) | yes |

No other text or number on the page changed. The frame annotations (a, b, RSS) are untouched and their code is unchanged.

## Scripts and GIFs
- **Scripts changed:** `lslineaa.jl` and `lslineac.jl`, two style arguments each (diff above).
- **GIFs regenerated:** `lslineaa.gif` (7 frames) and `lslineac.gif` (8 frames). Each was made with `cd pages/numerical-methods/least-squares-lines && julia <script>.jl`. Both are byte-identical to the trial GIFs `exp/v1_aa.gif` and `exp/v1_ac.gif` (md5 1467e8fe… and 966a2d5f…).
- **Not regenerated:** `lslineab.jl` / `lslinead.jl` (separate scripts, unchanged) and their GIFs.
- **Frames viewed:**
  - At full size: `new/lslineaa` frames 1, 4 and 7, and `new/lslineac` frames 1, 4 and 8. I checked that each segment runs from its red point to the fitted line and that the annotations read a = −1.0 / 9.0 / RSS 0.0, a = −1.6 / 8.6 / 0.4 and a = −1.6071 / 8.6429 / 1.3929 (Case 1), and 2.0 / 0.0, 1.56667 / 0.3667 and 1.53922 / 0.6863 (Case 3). The legends and titles are unchanged.
  - 4× crops: `zoom_aa6.png` and `zoom_ac8.png`.
- **`git status --short --untracked-files=all pages/numerical-methods/least-squares-lines` after regeneration:** M index.qmd, M lslineaa.gif, M lslineaa.jl, M lslineac.gif, M lslineac.jl. No other files. The quarto render attempt (`-o /dev/null`) failed on the output option and left no files in the folder; the director's full-section render covers rendering.

## Legacy archive
Consulted: `n2003/LeastSqLineMod.html` (stripped text) and its graph images `gr_53` (Example 1) and `gr_135` (Example 4). There is no least-squares animation under `a2001/Animations/` (`find … -iname '*least*' -o '*lsq*' -o '*regress*'` returned nothing).
- Mathews' graphs show only the data points (red dots) and the fitted line (green). They draw no residual segments, so the residuals on this page are the site's own addition and there is nothing in the archive to follow for F1.
- Example 4's data and result (157/102) match the page.
- No R2-A item applies: the page covers all five archive examples (round-2 review, "Fidelity").

## Notes
- The fitted line in Case 1 still overprints the left end of the annotation text, crossing the minus sign of "a = −…". The round-2 reviewer noted this but did not count it as a finding, so I did not touch it.
- Nothing outside the page folder was changed apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Script change (both `lslineaa.jl`, `lslineac.jl`): red "points used" markers reduced from `ms=6` to `ms=4, msw=0`; residual segments changed from `steelblue, lw=1.2` to `navy, lw=2.5`, still drawn after the markers (on top). Segment endpoints unchanged: `(x_i, y_i)` to `(x_i, a x_i + b)` (Case 1) and `(x_i, y_i)` to `(x_i, a x_i)` (Case 3), which are the vertical residuals.
- Frames viewed at full size (new frame 1, middle, last of each; contact sheets of all frames; old frame 7 of Case 1 for comparison). Case 1: residuals at x = 0, 2, 4, 5 are clearly readable as dark blue bars in the last frames (x = 4 and x = 5 longest), and x = -1, 0, 2, 3 are visible in middle frames. Case 3: every non-zero residual shows as a short dark tick above/below its marker at native size (previously essentially invisible).
- Navy pixel count per segment column (RGB R,G<60, 90<B<170), new GIFs: Case 1 frames 1-7 total 6, 43, 64, 76, 94, 138, 141 px; last frame column lengths 8, 11, 2, 13, 7, 22, 18, 2 px. Case 3 frames 1-8 total 4, 38, 47, 71, 81, 102, 111, 135 px; last frame column lengths 14, 4, 12, 6, 9, 8, 8, 10 px. (Old review: steelblue counts 0-53 px, Case 3 stubs <= 10 px and hidden.)
- Text: line 22 no longer promises a fully visible geometric picture; it now says the segments are short and some barely visible, which matches the frames (Case 3 stubs are short; zero/near-zero residuals such as Case 1 x = 1, x = 6 are just a few px). Both alt texts now describe "a short dark blue segment from the point to the line", which is what is drawn.

### F2 — resolved
- "settles near" removed. New text: "With all eight points of the legacy dataset the fit is a = 157/102 ≈ 1.5392; as points are added the coefficient zig-zags downward from 2."
- Exact rational computation (`check/indep.py`, fractions): a_k = 2, 8/5, 23/14, 47/30, 87/55, 141/91, 109/70, 157/102 = 2, 1.6, 1.64286, 1.56667, 1.58182, 1.54945, 1.55714, 1.53922. Steps alternate in sign (−, +, −, +, −, +, −) with net decline: "zig-zags downward from 2" is true. 157/102 = 1.539216 rounds to 1.5392. GIF annotation in the last frame reads a = 1.53922, consistent.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.22 | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | Script: `color=:navy`, endpoints (x_i,y_i)-(x_i,ŷ_i); frames show dark blue vertical bars | true |
| index.qmd l.22 | "the distances whose squares the least-squares criterion adds up" | RSS = Σ(y_i − ŷ_i)², the vertical residuals drawn | true |
| index.qmd l.22 | "largest residual in any frame is about 0.79 in Case 1" | exact max over k=2..8: 0.785714 (k=7,8, at x=4) | true |
| index.qmd l.22 | "0.46 in Case 3" | exact max over k=1..8: 0.460784 (k=8) | true |
| index.qmd l.22 | "segments are short and some are barely visible" | pixel lengths 2-22 px; zero residuals (Case 1 k=2, x=6 at k=8; Case 3 k=1) only 1-2 px | true |
| index.qmd l.30 (Case 1 alt) | "each vertical residual drawn as a short dark blue segment from the point to the line" | frames | true |
| index.qmd l.42 | "a = 157/102 ≈ 1.5392" | Σxy/Σx² = 314/204 = 157/102 = 1.539216 | true |
| index.qmd l.42 | "zig-zags downward from 2" | sequence above | true |
| index.qmd l.46 (Case 3 alt) | "constrained least-squares fit through the origin for y equals a times x as points are added, with each vertical residual drawn as a short dark blue segment" | frames | true |
| lslineaa.jl / lslineac.jl | marker and segment styling only | fits, RSS, annotations unchanged (frame annotations match exact values: Case 1 k=8 a=-1.6071, b=8.6429, RSS=1.3929; Case 3 k=8 a=1.53922, RSS=0.6863) | fine |

### New problems
None. Rests on: exact recomputation of every number added, full-size inspection of first/middle/last frames and full contact sheets of both regenerated GIFs, and comparison with the pre-fix frames (fits, annotation text, legend, axes unchanged; only marker size and residual styling differ). Pre-existing cosmetic note, not introduced by this fix: in Case 1 the green fit line passes through the start of the top-left annotation ("a = -1.6071 ...") in late frames; the old GIF has the same overlap.

### Reproducibility and conventions
- Both changed scripts run from scratch copies (`check/run/`) produce GIFs byte-identical to the committed ones: lslineaa.gif sha256 cfddce6d…a11d7, lslineac.gif sha256 d0278c1b…602f8.
- Pre-fix GIFs obtained via `git show HEAD:… | git lfs smudge` (read only).
- index.qmd keeps Description before Animations, one Julia source link and one GIF embed per case (4 cases), descriptive alt text, no code blocks.
- fix.diff touches only files inside the page folder. The working tree has other modified pages under pages/numerical-methods/ from parallel fixers; outside pages/numerical-methods/ only untracked fix records under reviews/numerical-methods-animations-r2/fixes/ exist (expected process records), and nothing attributable to this fix lies outside the page folder.

**Final status:** committed
