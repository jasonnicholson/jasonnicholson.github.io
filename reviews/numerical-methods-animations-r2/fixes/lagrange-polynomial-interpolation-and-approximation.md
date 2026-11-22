# Fix record: lagrange-polynomial-interpolation-and-approximation

Scratch folder for every check below (S):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/lagrange-polynomial-interpolation-and-approximation/fix/`

- `lib.jl`: the edited script up to `render_case`, without Plots. `dump.jl` includes it.
- `dump.jl` (`julia dump.jl`) prints, for each case, the window, the node span, whether any node set was trimmed, and the x-runs of the 1000-point plot grid where f is finite (NaN marks where it is not drawn). For Cases 01, 02, 03 and 07 it also writes `dump.tsv`: every node set, plus the first-form and second-form interpolant at all 1000 plot points for all 10 degrees.
- `check.py` (`/usr/bin/python3 -I check.py dump.tsv`) is the independent mpmath check, at 80 digits.
- `wider.jl` lists the cases whose window is wider than their node span.

This page shares `lagnewt_animations_all.jl` with Newton Interpolation (WP-B). The Newton page's finding F1 (fidelity of the node intervals) changed this page's Cases 01, 02, 03 and 07. That change is recorded here as well as in `fixes/newton-interpolation-polynomial.md`.

## Findings

### F1 — Minor — fixed
- **Reproduced.** `julia dump.jl` gave the x-runs where f is finite (drawn) on each case's plot grid:
  - Case 19 (arcsin): `[-0.9985, 0.9985]` in the window (−1.5, 1.5). So f is drawn only on its domain [−1, 1], and the curve ends at the nodes ±1, about 0.0015 short.
  - Case 09 and Case 10 (ln x): `[0.0019, 4.1000]` in the window (−0.5, 4.1).
  - Case 11 (ln(1+x)): `[-0.9985, 1.5000]` in the window (−1.5, 1.5).
  - Viewed `S/repo19/frame_006.png` (committed `lagnewt19.gif`, degree 7). The magenta f ends at the nodes x = ±1, and the blue interpolant runs on to ±1.5.
  - The finding holds. The alt texts for 09, 10, 11 and 19 overstate where f is drawn, and the line-21 sentence wrongly includes Case 19 among the cases where f is drawn beyond [a, b].
- **Change.** In `index.qmd` line 21, the sentence now reads: "Where the plot window is wider than $[a, b]$ (Cases 01–11, 14, 19 and 24–29), the interpolant beyond the nodes is extrapolation. In Case 19, $\arcsin x$ is undefined outside $[-1, 1]$, so there only the interpolant is drawn." The case list now also contains 01, 02, 03 and 07, because their windows were widened (see the next section). In the alt texts:
  - Cases 09 and 10: "drawn with f on [−0.5, 4.1]" became "in the window [−0.5, 4.1], with f drawn for x > 0, where it is defined".
  - Case 11: "drawn with f on [−1.5, 1.5]" became "in the window [−1.5, 1.5], with f drawn for x > −1, where it is defined".
  - Case 19: "drawn with f on [−1.5, 1.5]" became "in the window [−1.5, 1.5], with f drawn on [−1, 1] (its whole domain)".
- **Check.** See the ledger. The finite runs are listed above. `julia wider.jl` prints `window wider than node span: 01 02 03 04 05 06 07 08 09 10 11 14 19 24 25 26 27 28 29`.

### (From the Newton page's F1, which applies to this page through the shared script) — node intervals of Cases 01, 02, 03 and 07 — fixed
- **Change.** In the script table, the Case 01 window and nodes went from (−1.6, 0.9) and (−1.6, 0.9) to (−1.6, 1.5) and (−1.5, 0.9); Case 02 from (−0.9, 1.6) and (−0.9, 1.6) to (−1.5, 1.6) and (−0.9, 1.5); Case 03 from (−1.6, 0.9) and (−1.6, 0.9) to (−1.6, 1.5) and (−1.5, 0.9); Case 07 from (−1.6, 0.9) and (−1.6, 0.9) to (−1.6, 1.5) and (−1.5, 0.95). The headings and alt texts of Cases 01, 02, 03 and 07 were updated to match. The evidence and the reasoning are in `fixes/newton-interpolation-polynomial.md`, F1.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.21 | "Where the plot window is wider than $[a, b]$ (Cases 01–11, 14, 19 and 24–29)" | `julia wider.jl` → `01 02 03 04 05 06 07 08 09 10 11 14 19 24 25 26 27 28 29` (exactly this list) | yes |
| l.21 | "the interpolant beyond the nodes is extrapolation" | Every node set lies in its span. In `dump.jl`, `trimmed=false` for all 29 cases, and the first and last node equal the span ends. Outside the span the interpolant is evaluated at points that are not nodes. | yes |
| l.21 | "In Case 19, $\arcsin x$ is undefined outside $[-1, 1]$, so there only the interpolant is drawn." | Real arcsin has domain [−1, 1], and Julia `asin(1.2)` throws a DomainError, which `safe_eval` turns into NaN. `dump.jl` gives the f finite run for Case 19 as `[-0.9985, 0.9985]`. Frame `repo19/frame_006.png` shows it. | yes |
| Case 01 heading | nodes on $[-1.5, 0.9]$ | `wider.jl` → `01 window (-1.6, 1.5) span (-1.5, 0.9)`. `check.py`: node x deviates from −1.5 + 2.4i/(n−1) by at most 1.08e-16. | yes |
| Case 01 alt | "nodes on [−1.5, 0.9] … in the window [−1.6, 1.5], which includes the pole of f at x = 1" | Same as the row above. 1/(1−x) has its pole at 1 ∈ [−1.6, 1.5]. Frame `expA/fr01/frame_010.png` shows the pole. | yes |
| Case 02 heading and alt | nodes on [−0.9, 1.5]; window [−1.5, 1.6]; pole at x = −1 | `wider.jl` → `02 window (-1.5, 1.6) span (-0.9, 1.5)`. The pole of 1/(1+x) is at −1. `check.py` node x deviation is 1.08e-16. | yes |
| Case 03 heading and alt | nodes on [−1.5, 0.9]; window [−1.6, 1.5]; pole at x = 1 | `wider.jl` → `03 window (-1.6, 1.5) span (-1.5, 0.9)`. The (double) pole of 1/(1−x)² is at 1. | yes |
| Case 07 heading and alt | nodes on [−1.5, 0.95]; window [−1.6, 1.5]; "f drawn for x < 1, where it is defined" | `wider.jl` → `07 window (-1.6, 1.5) span (-1.5, 0.95)`. `dump.jl` gives the f finite run `[-1.6000, 0.9973]`, the last grid point below 1. At x = 1 we have 1/0 = Inf → NaN, and for x > 1 a DomainError → NaN. | yes |
| Case 09 and 10 alt | "in the window [−0.5, 4.1], with f drawn for x > 0, where it is defined" | Both xlims are (−0.5, 4.1). `dump.jl` gives the finite run `[0.0019, 4.1000]`, the first grid point > 0. | yes |
| Case 11 alt | "in the window [−1.5, 1.5], with f drawn for x > −1, where it is defined" | xlims (−1.5, 1.5). Finite run `[-0.9985, 1.5000]`, the first grid point > −1. | yes |
| Case 19 alt | "in the window [−1.5, 1.5], with f drawn on [−1, 1] (its whole domain)" | Finite run `[-0.9985, 0.9985]`. The nodes at ±1 are drawn as markers, and the 0.0015 gap is less than one pixel (3 units across about 690 px). | yes |
| l.12 (unchanged; rechecked because the cases changed) | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | For the new 01, 02, 03 and 07, `check.py` finds 0 second-form sign errors and 0 first-form sign errors, so the statement still holds and no new case should be added to it. | yes |
| l.25 (unchanged; rechecked) | degrees 1…15, clamping to the window edge | `n_nodes_seq` is unchanged. In the new frames the f and interpolant curves are clamped at the top and bottom edges, for example at the pole in `expA/fr01/frame_010.png`. | yes |

Independent accuracy of the regenerated cases (`check.py`, mpmath Newton divided differences on the script's float data, compared at all 1000 plot points × 10 degrees):

| Case | node x dev | node y rel | max rel. interpolant error | sign errors (1st / 2nd form) |
|---|---|---|---|---|
| 01 | 1.08e-16 | 1.54e-16 | 1.55e-12 | 0 / 0 |
| 02 | 1.08e-16 | 1.54e-16 | 1.36e-12 | 0 / 0 |
| 03 | 1.08e-16 | 2.72e-16 | 1.73e-13 | 0 / 0 |
| 07 | 9.29e-17 | 1.45e-16 | 8.22e-13 | 0 / 0 |

## Scripts and GIFs
- **Script changed.** `lagnewt_animations_all.jl`: the table rows for 01, 02, 03 and 07, plus a 4-line comment. Copied byte for byte to `../newton-interpolation-polynomial/` (`cmp` silent; both copies are identical).
- **Regenerated.** `julia lagnewt_animations_all.jl` was run in both folders (exit 0 each). `git status` shows only `lagnewt01/02/03/07.gif`, the script and `index.qmd` modified in this folder. The other 25 GIFs are byte-identical to the committed ones. All 29 GIFs are byte-identical between the two folders (`cmp` loop, no output). The four changed GIFs are byte-identical to the scratch experiment `S/expA/` (`cmp`).
- **Frames viewed.**
  - Contact sheets of all 10 frames of 01, 02, 03 and 07 (`S/expA/fr*/sheet.png`).
  - Full size: 01 frame 10, 07 frame 1, committed 03 frame 5, and committed 19 frame 6.
  - The titles read "Interpolation Case NN: f(x) = …, degree d" with d = 1…15.
  - The red nodes start at x = −1.5 (01, 03, 07) or −0.9 (02) and end at 0.9, 0.95 or 1.5.
  - The interpolant passes through every node.
  - The pole is visible in 01, 02 and 03, where f is clamped to the top and bottom edges and joined by a vertical line at the pole, as in Case 14. (Superseded by "Round 2 after check" below.)
  - In 07, f stops at x → 1 and only the interpolant continues to 1.5.
  - In Case 03 the y-limits are (−138.6, 592.5) (`S/ylims.jl`), because f has a double pole inside the window. The nodes and curves are legible, but the left part is flat at this scale. (Superseded: see N1 below.)

## Legacy archive
Consulted: `a2001/Animations/Interpolation/Lagrange/` (Lagrange.html, Images, Lagrange01/Lagrangeaa.gif), and n2003 LagrangePolyMod and NewtonPolyMod.
- **Window formula images.**
  - Case 01: −1.6 ≤ x ≤ 1.5 (`Lagrange_gr_2`).
  - Case 02: −1.5 ≤ x ≤ 1.6 (`gr_4`).
  - Case 03: −1.6 ≤ x ≤ 1.5 (`gr_6`).
  - Case 07: −1.6 ≤ x ≤ 1.5 (`gr_14`).
  - Case 19: −1.5 ≤ x ≤ 1.5 (`gr_38`).
  - The montage is `S/legacy_formulas.png`.
- **`Lagrangeaa.gif` (Case 01)**, 34 frames (`S/legacy_aa/`). Pixel measurement with `S/legacy_px.py`:
  - The y-axis (x = 0) is at column 325 and the green markers at columns 20 and 508.
  - Frame 6 ("S 3") has nodes at columns 19.4, 181.5, 344.5 and 507.4, with equal spacing of 162.7 px.
  - With 0.9 ↔ 507.4, the scale is 202.7 px per unit, so the first node is at (19.4 − 325)/202.7 = −1.508. Mathews' nodes are therefore on [−1.5, 0.9] (−1.6 would be at column 1).
  - Note that the round-2 Lagrange review's row C01 ("legacy GIF shows nodes on [−1.6, 0.9]") is wrong. The Newton review's reading is right.
- **No legacy GIFs for 02, 03 and 07.** The static Example 6 in both modules (`LagrangePolyMod_lnk_17` "Solution 6 → Animation 7", code image `gr_379`) uses 1/√(1−x) with nodes from aa = −1.5 to bb = 0.95. That is the source of the Case 07 span.
- **Inferred spans.** 02 = mirror of 01: f₀₂(x) = f₀₁(−x) and the windows are mirrors, and the node sets and values mirror exactly (max deviation 0). 03 = same window and pole as 01. Both spans are inferred from the Case 01 pattern, not read from an archive image.
- **Case 19 / F1.** The archive's window ±1.5 is kept. F1 was about the page's wording only.

## Notes
- The window numbers in the alt texts are the script's `xlims`, where the curves are evaluated. The drawn axis adds a 2% pad on each side so that end nodes are drawn whole. This is unchanged, and the earlier alt texts used the same convention.
- Case 04–06, 08, 14 and 24–29 alt texts still say "drawn with f on [window]". f is finite across those windows except at single points or poles (Γ at 0, Y₀ at 0), which the round-2 reviewer judged not material. They were left unchanged.
- The legacy degree range (up to S₂₅) and the ±0.05 "Convergence Regions" band are not reproduced. Neither the reviewers nor the round-2 decisions ask for them, and they were not added.

## Round 2 after check

The coordinator's independent check confirmed F1 and the interval change. It reported three new problems caused by the wider windows. All three are fixed by one script change, made once in this folder and copied byte for byte to `../newton-interpolation-polynomial/` (`cmp` silent).

**Script change** (`lagnewt_animations_all.jl`):
- `InterpCase` has two new fields: `pole` (NaN if none) and `legend`. `with_span` takes the keywords `pole=NaN, legend=:topleft`, and `auto_span` passes `NaN, :topleft`.
- Case 01 has `pole=1.0`, Case 02 has `pole=-1.0, legend=:topright`, and Case 03 has `pole=1.0`.
- In `render_case`, when `pole` is set:
  - The f-part of the y-limits is `robust_ylims` of f on the node interval (1000 points) instead of on the whole window. The node-value inclusion and the 12% margin are unchanged.
  - f is drawn unclamped on the plot grid plus one extra point at the pole, set to NaN. The line therefore breaks at the pole and runs off the window, where Plots clips it.
  - The interpolant is still clamped, as before.
- `legend=case.legend` replaces the literal `:topleft`. Every other case takes the old code path with the same values, and Case 07 has no pole set.

**Regeneration.** `julia lagnewt_animations_all.jl` was run in both folders (exit 0 each).
- `git status`: in each folder only `lagnewt01/02/03/07.gif`, the script and (here) `index.qmd` are modified.
- The other 25 GIFs are byte-identical to the committed ones. `lagnewt07.gif` is byte-identical to the earlier round's `S/expA/lagnewt07.gif`.
- All 29 GIFs are identical across the two folders.
- 01, 02 and 03 equal the scratch run `S/expB/` byte for byte. That scratch run also rendered Case 14 and matched the committed GIF, which confirms the new code path leaves non-pole cases untouched.

### N1 — Misleading — fixed
- **Reproduced.** The previous GIF had Case 03 y-limits of (−138.6, 592.5) (`S/ylims.jl`, recorded above).
- **Check.** `julia r2check.jl` (in S) gives:
  - Case 03 y-limits are now `(-17.455924559634422, 112.58456334567518)`.
  - Degree 5 (nodes −1.5, −1.02, −0.54, −0.06, 0.42, 0.9): max |P−f| on [−1.5, 0.42] is 2.7118 on a 20001-point grid, where f lies in [0.16, 2.97]. This agrees with the coordinator's 2.71.
  - Frame `S/expB/fr03/frame_005.png`: the y-ticks 0 and 100 sit at rows ≈ 414 and ≈ 73, which is 3.41 px per unit. The error is therefore about 9 px, compared with about 1.6 px before, and the wiggle at x ≈ −1.35 to y ≈ 3 is clearly visible.

### N2 — Minor — fixed
- **Check.**
  - `r2check.jl` gives the Case 01 and 02 y-limits as `(-1.646365969427396, 11.247824925295795)`, the same as the pre-round-2 GIFs, which had (−1.65, 11.25).
  - Beyond the pole, f lies in [−2497.5, −2.0] on the grid for both cases, entirely below the window.
  - Frames `S/expB/fr01/frame_010.png` and `S/expB/fr02/frame_001.png` show no vertical magenta segment at the pole.
  - Case 03 (`S/expB/fr03/sheet.png`) shows two separate magenta branches rising off the top on either side of x = 1. There is no flat f bar along the top edge.
  - A flat blue segment along the top edge remains wherever the interpolant leaves the window. That is the stated clamping convention, which applies to the interpolant.

### N3 — Minor — fixed
- **Check.**
  - In `S/expB/fr02/frame_001.png` the legend is at the top right, and its box spans x ≈ 0.89–1.5 and y ≈ 9.2–11.
  - `r2check.jl` gives the largest value of f or of any frame's interpolant over x ≥ 0.6 as 3.997, well below the legend's lower edge.
  - The contact sheet `S/expB/fr02/sheet.png` shows nothing under the legend in any frame. The top-left region near the pole is now clear.

### Ledger (round 2 after check)

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.25 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge, except $f$ in Cases 01–03, which runs off the window and is broken at its pole." | Script: only cases with `pole` set (01, 02, 03) draw f unclamped with NaN at the pole. Other cases still use `ytrue_clip`, and the interpolant is always clamped. Frames are as above. | yes |
| Case 01 alt | "…which includes the pole of f at x = 1; beyond the pole f ≤ −2, below the window." | `r2check.jl`: f beyond the pole lies in [−2497.5, −2.0], and the y-limits' lower end is −1.646. Analytically, x ∈ (1, 1.5] gives 1/(1−x) ≤ −2. | yes |
| Case 02 alt | "…which includes the pole of f at x = −1; beyond the pole f ≤ −2, below the window." | Same as Case 01, mirrored: x ∈ [−1.5, −1) gives 1/(1+x) ≤ −2, and the y-limits' lower end is −1.646. | yes |
| Case 03 alt (unchanged) | "window [−1.6, 1.5], which includes the pole of f at x = 1" | Still true. Both branches are visible in the frames. | yes |
| script comment | "For 01-03 (pole given) the y-limits come from f on the node interval, and f is broken at the pole and left to run off the window." | Code as described above. | yes |

## Resolution check (independent checker, not shown this record)

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/lagrange-polynomial-interpolation-and-approximation/check/`
(`run/` = regenerated GIFs, `new/NN/` and `old/NN/` = frames of committed and pre-fix GIFs, `legacy/aa/` = frames of Mathews' `Lagrangeaa.gif`, `ylims.py`, `interp.py`, `crop*.png`).

### Original findings

### Lagrange page F1 (Case 19 listed as "f drawn on a wider interval"; alt texts overstate where f is drawn) — resolved
- Line 21 now says "Where the plot window is wider than [a, b] (Cases 01–11, 14, 19 and 24–29), the interpolant beyond the nodes is extrapolation. In Case 19, arcsin x is undefined outside [−1, 1], so there only the interpolant is drawn." I checked the list against the case table in the script. The window is strictly wider than the node span for 01–11, 14, 19 and 24–29. Cases 12, 13, 15–18 and 20–23 are `auto_span` with f finite on the whole window, so the nodes span the whole window. The list is exact. The Case 19 sentence matches the frames: in `new/19/frame_010.png` the magenta curve stops at x = ±1 and the blue curve runs on to the window edges.
- Alt texts: Case 19 now reads "in the window [−1.5, 1.5], with f drawn on [−1, 1] (its whole domain)". Cases 09 and 10 read "with f drawn for x > 0", Case 11 "for x > −1", and Case 07 "for x < 1". Each is true. In Julia, `log` of a negative number and `sqrt` of a negative number throw `DomainError`, and `log(0)` and 1/√0 give ±Inf. `safe_eval` turns all of these into NaN, so they are not drawn. The frames agree: `new/09/sheet.png`, `new/11/frame_010.png` and `new/07/frame_005.png`.

### Newton page F1 (node interval for Cases 01, 02, 03 and 07 differs from Mathews') — resolved
- Case 01: the script now uses nodes on [−1.5, 0.9] and window [−1.6, 1.5]. In the legacy `Lagrangeaa.gif`, frame 7 ("S 3", `legacy/aa/frame_007.png`) has its nodes at pixel x = 20, 182, 344 and 508. The axis ticks −1.5 and 1.5 sit at px 18 and 628, so the nodes are at x = −1.49, −0.69, 0.10 and 0.91, which is [−1.5, 0.9]. The new degree-3 frame (`new/01/frame_003.png`) has its nodes at −1.5, −0.7, 0.1 and 0.9. That is the same set.
- Windows: Mathews' index formula images give −1.6 ≤ x ≤ 1.5 for Cases 1, 3 and 7 (`Lagrange_gr_2/6/14.gif`) and −1.5 ≤ x ≤ 1.6 for Case 2 (`Lagrange_gr_4.gif`). The script's `xlims` match all four.
- Case 07: nodes are on [−1.5, 0.95]. Two legacy sources support this. In `NewtonPolyMod_gr_435/436`, Example 6 is 1/√(1−x) on [−1.5, 0.95], and its solution page `NewtonPolyMod_lnk_19.html` links to `Lagrange07/Lagrangegg.html` ("Animation 7"), so the script comment's claim holds. The Lagrange-module solution `LagrangePolyMod_lnk_17.html` (also linked to Lagrange07) plots three nodes at −1.5, about −0.28 and 0.95 (`LagrangePolyMod_gr_380.gif`), which also fits [−1.5, 0.95].
- Cases 02 and 03: the archive has no legacy GIF and no node interval for these cases. The `Lagrange02`/`Lagrange03` folders hold only HTML, and the index row shows only the plot window. The fix uses the mirror of 01 for 02 ([−0.9, 1.5]) and the same nodes as 01 for 03. The original finding suggested exactly this, and it is consistent with Mathews' windows.
- The Newton page still points readers to the Lagrange page for the intervals, and the Lagrange headings were updated. Both script copies are byte-identical (`cmp`).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Lagrange index.qmd l.21 | "plot window is wider than [a, b] (Cases 01–11, 14, 19 and 24–29)" | Compared `xlims` and the resolved span for all 29 cases in the script. auto_span cases have f finite on the whole window, so span = window | true |
| l.21 | "the interpolant beyond the nodes is extrapolation" | Definition | true |
| l.21 | "In Case 19, arcsin x is undefined outside [−1, 1], so there only the interpolant is drawn" | `asin` throws DomainError for \|x\|>1, which becomes NaN; frames confirm | true |
| l.29 heading | Case 01 nodes on [−1.5, 0.9] | Script span (−1.5, 0.9); f finite at both ends (0.4, 10.0), so no trimming; frame nodes read −1.5…0.9 | true |
| l.31 alt | window [−1.6, 1.5], pole at x = 1 | xlims (−1.6, 1.5); 1/(1−x) has its pole at 1 | true |
| l.33 heading | Case 02 nodes on [−0.9, 1.5] | Script; f(−0.9) = 10, f(1.5) = 0.4; frame shows nodes at −0.9 and 1.5 | true |
| l.35 alt | window [−1.5, 1.6], pole at x = −1 | xlims (−1.5, 1.6) | true |
| l.37 heading | Case 03 nodes on [−1.5, 0.9] | Script; f(−1.5) = 0.16, f(0.9) = 100 | true |
| l.39 alt | window [−1.6, 1.5], pole at x = 1 | xlims | true |
| heading Case 07 | nodes on [−1.5, 0.95] | Script; f(0.95) = 4.4721 (node visible at 4.47 in frames) | true |
| alt Case 07 | window [−1.6, 1.5], f drawn for x < 1 | sqrt of a negative throws DomainError; 1/0 is Inf; both become NaN | true |
| alt 09, 10 | window [−0.5, 4.1], f drawn for x > 0 | xlims; log domain | true |
| alt 11 | window [−1.5, 1.5], f drawn for x > −1 | xlims; log(1+x) domain | true |
| alt 19 | window [−1.5, 1.5], f drawn on [−1, 1] (its whole domain) | xlims; asin domain | true |
| script l.23–26 comment | "Mathews' plot windows … 01 as in his animation; 02 mirrors 01; 03 as 01; 07 as in his static example linked to animation 7" | Legacy index images, Lagrangeaa frame 7, NewtonPolyMod Example 6 → link to Lagrange07 | true |
| script case table | 01/02/03/07 xlims and spans | as above | true |

Numerical correctness of the regenerated frames: `interp.py` compares the script's float64 first-form barycentric evaluation with a 60-digit mpmath Lagrange evaluation. It uses the same nodes, all 10 node counts and 143 points across each new window, including the extrapolation up to the window edge. The maximum relative error is 9e-13 (Cases 01, 02, 03, 07). The y-limits from `ylims.py` match the frames' axes: 01 and 02 (−17.6, 17.0), 03 (−138.6, 592.5), 07 (−0.32, 4.99).

### New problems

### N1 — Misleading (readability), Case 03 (`lagnewt03.gif`, both folders)
The window now contains the double pole at x = 1. `robust_ylims` takes the 97th percentile of f over the whole window, so the y-range grows from (−17.3, 112.6) before the fix to (−138.6, 592.5) now, which is 0.60 px per unit instead of 3.39. As a result the interpolation behaviour on most of the node interval cannot be seen. At degree 5 the interpolant's largest error on [−1.5, 0.42] is 2.71, about 15 times f's values there (0.16–2.0), but it is drawn as 1.6 px. Before the fix it was 9.3 px. In every frame, all nodes except the last two or three sit on what looks like the line y = 0, so the frames suggest an essentially exact fit there (`new/03/frame_005.png` compared with `old/03/frame_005.png`). Mathews' own Case-01 animation clips y to roughly the nodes' range (0..10), not to the far side of the pole. Suggested fix: compute `ylims_f` from f on the node span, or from the node values, instead of the whole window.

### N2 — Minor (readability and plot artifact), Cases 01 and 02, and the pole drawing in 01–03
- For the same reason as N1, Cases 01 and 02 now use y ∈ (−17.6, 17.0) where before it was (−1.65, 11.25), which is 2.7 times more compressed. About half the plot height shows only the branch of f beyond the pole. At degree 5 the error on [−1.5, 0.42] in Case 01 (0.185) is drawn as 2.4 px, against 6.4 px before. The plot is still readable at low degree, but its detail is reduced.
- Because f is clamped to the y-limits and drawn as a connected line, the pole is drawn as part of the magenta f curve. In 01 and 02 it appears as a full-height vertical segment at x = ±1 plus a flat run along the top edge. In 03 it appears as a flat bar along the top between about 0.96 and 1.04 (`new/01/frame_001.png`, `new/02/frame_001.png`, `new/03/frame_001.png`). Page line 25 explains edge-hugging, but not a vertical join across a pole.

### N3 — Minor (readability), Case 02 legend overlap
The legend sits at the top left, and in Case 02 that is where the pole and the steep branch of f are. In every frame it hides f and the interpolant for y ≈ 11–16 just to the right of x = −1, and part of the pole artifact (`crop02_1.png`, `crop02_10.png`). The node at (−0.9, 10) stays visible. Suggested fix: put the legend at `:topright` for Case 02.

No other new problems. This rests on viewing full-size frames 1, 3 or 5, and 10 of cases 01, 02, 03 and 07, plus frames of 09, 11 and 19, and on the computations above.

### Reproducibility and conventions
- I ran the script from a scratch copy (`run/`, exit 0, "Generated 29 GIFs."). All 29 output GIFs are byte-identical (`cmp`) to the committed GIFs in **both** folders, including the four that changed (01, 02, 03, 07). The two script copies are byte-identical, and so are the 01, 02, 03 and 07 GIFs in the two folders.
- Both pages: Description comes before Animations. Each has a source link, 29 `### Case` headings, 29 GIF embeds and no code fences. Alt texts are descriptive. The Newton page's index.qmd is unchanged, and its pointer to the Lagrange page for the intervals now leads to correct headings.
- The fix diff touches only the two page folders. Other modified paths in `git status` belong to other pages' work packages and fix records, not to this fix.

### Re-check

This round checks the fixer's changes for N1–N3 against the updated `fix.diff`. Re-check files are in the same scratch folder: `run2/` holds the regenerated GIFs, `new2/NN/` the frames of the committed GIFs, and `ylims2.py` the limit computations.

### What changed
- The script has two new `InterpCase` fields, `pole` and `legend`. Cases 01, 02 and 03 set `pole` = 1, −1 and 1; Case 02 also sets `legend=:topright`.
- When a case has a pole, `ylims_f` is computed from f at 1000 points on the node span, not on the whole window.
- In those cases f is plotted unclamped, on `xplot` plus the pole itself, with NaN at the pole. The interpolant is still clamped.
- Page line 25 now ends "…drawn along the window's top or bottom edge, except f in Cases 01–03, which runs off the window and is broken at its pole."
- The alt texts for 01 and 02 now end "beyond the pole f ≤ −2, below the window." Nothing else changed beyond what the first check covered.

### Recomputed numbers (`ylims2.py`, which replicates `robust_ylims` and the node-value extension)
| Case | y-limits | px per unit | degree-5 max error away from the pole end | drawn size | f beyond the pole |
|---|---|---|---|---|---|
| 01 | (−1.646, 11.248) | 34.1 | 0.185 on [−1.5, 0.42] | 6.3 px | f ∈ [−2497.5, −2.0] on (1, 1.5] |
| 02 | (−1.646, 11.248) | 34.1 | 0.185 on [−0.42, 1.5] | 6.3 px | f ∈ [−2497.5, −2.0] on [−1.5, −1) |
| 03 | (−17.456, 112.585) | 3.38 | 2.712 on [−1.5, 0.42] | 9.2 px | f ∈ [4, 6.2e6] |
| 07 | (−0.319, 4.985) | unchanged | — | — | — |

- The coordinator gave (−17.5, 112.6) for Case 03; I confirm it. The limits are back to their pre-fix scale (before the fix: 01 (−1.65, 11.25), 03 (−17.3, 112.6)).
- "Beyond the pole f ≤ −2, below the window": 1/(1−x) on (1, 1.5] has its supremum −2 at x = 1.5, and 1/(1+x) on [−1.5, −1) has its supremum −2 at x = −1.5. The bottom of the window is −1.646 > −2, so f on that branch is never drawn. True for both alt texts.
- In Case 03, f beyond the pole is positive (from +∞ down to 4) and is drawn. Its alt text makes no claim about that branch, so it is not contradicted.

### Every frame of 01–03 at full size (`new2/01..03/frame_001..010.png`)
- **Case 01.** f rises off the top just before x = 1, and nothing is drawn of f beyond the pole. There is no vertical segment and no flat f bar. The interpolant runs along the top edge past about 0.95–1.2, depending on the degree, as line 25 says. The nodes are at −1.5…0.9, and the legend (top left) covers no curve in any frame. The interpolant's wiggles are visible at degrees 2–5.
- **Case 02.** The legend is now at the top right, where both curves are below y ≈ 1. Nothing is covered in any of the 10 frames. f breaks at −1, and its other branch is below the window. The interpolant runs along the top edge on the left, which line 25 covers.
- **Case 03.** Both branches of f run off the top, with a clear gap around x = 1, and the right branch comes back down to 4 at x = 1.5. No flat f bar is drawn. The degree-5 wiggle can be seen clearly: overshoot to about 3 near x = −1.35 and about −1.5 near x = 0.2. Degrees 2–4 show swings of up to about ±12, and every node is distinguishable. The legend covers no curve.

### Page text checks
- Line 25 is exactly true. Code paths: the interpolant is always `clamp.(…)`; f uses `ytrue_clip` (clamped) in every case except those with a pole, which are exactly 01–03 (no other case sets `pole`). In 01–03 f is unclamped and NaN at the pole. The x-axis is the window plus 2% on each side, so no curve leaves the plot sideways.
- The alt texts for 01, 02 and 03 are true, as shown above. The alt texts for 07, 09, 10, 11 and 19 and line 21 are unchanged since the first check and still true.

### Reproducibility and scope
- The two script copies are byte-identical (`cmp`).
- I regenerated from a scratch copy (`run2/`, exit 0). All 29 GIFs are byte-identical to the committed GIFs in **both** folders.
- Against HEAD~ (through `git lfs smudge`; HEAD~ and HEAD are identical for both folders), only 01, 02, 03 and 07 differ, in both folders. The other 25 are byte-identical to HEAD~.
- The Case 07 output is byte-identical to the one from the first check.
- Conventions are unchanged: no code fences, 29 headings and 29 embeds per page, and the diff touches only the two page folders.

### Verdicts
- Lagrange F1: resolved (unchanged since the first check).
- Newton F1: resolved (unchanged since the first check).
- N1: resolved. The Case 03 limits are (−17.5, 112.6), and the degree-5 error is drawn at 9.2 px.
- N2: resolved. The 01 and 02 limits are (−1.65, 11.25); f is broken at the pole, with no vertical segment and no flat f bar; line 25 is updated and true.
- N3: resolved. The Case 02 legend is at the top right and covers no curve in any frame.
- New problems: none. This rests on all 30 frames of 01–03 viewed at full size, the recomputed limits, the code-path check of line 25, and byte-identical regeneration.

**Final status:** committed
