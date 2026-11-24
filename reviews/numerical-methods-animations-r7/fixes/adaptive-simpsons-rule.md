# Fix record: adaptive-simpsons-rule

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/adaptive-simpsons-rule/fix/` (`indep.py`/`indep.out`, `counts.py`/`counts.out`, `inst.jl`/`inst.out`, `cmpframes.py`/`cmpframes.out`, `oldframes/`, `newframes/`, `legacy/`).

## Findings

### F1 — Minor — fixed
- Reproduced: `python3 -I indep.py .../AdaptiveQuadMod_lnk_8.html` parses Mathews' 20 node sets and simulates the script's order with exact dyadic nodes and a 40-digit test. With the old order ("leftmost first") set 5 (11 points) splits [0, 1/2], gives 2.008051 and does not match Mathews; the other 19 sets match. Mathews' set 5 (0.625, 0.875 added) sums to 1.935128. His table image `gr_189` reads 1.935128 (`gr_188` 1.941436, `gr_190` 2.001744), and the legacy animation `AdaptQuadaa.gif` shows "Sample Points = 11, Approximation = 1.935128" with the [1/2, 1] split.
- Decision R7-B: reproduce Mathews' order at that stage if every other stage stays the same. Simulation with [1/2, 1] given priority among equal-width failing panels: all 20 node sets match Mathews (`matches Mathews nodes: True` for sets 1–20). Sets 6–20 are unchanged from the old run, because the test on a panel depends only on the panel and its depth.
- Change:
  - `adaptivesimpsonsaa.jl` l.24–37: added `first_panel = (0.5, 1.0)` and a middle sort key so that panel goes first among failing panels of its width; comment explains it follows Mathews' Example 7 trace.
  - `index.qmd` l.27: "(leftmost first)" → "(leftmost first, except that $[1/2,1]$ is split before $[0,1/2]$, as in Mathews' trace)".
- Check: instrumented copy `inst.jl` (the script's own refinement and `simpson_nonuniform`) prints set 5 = 11 pts, split [1/2, 1], 1.935128; set 6 = 13 pts, split [0, 1/2], 2.001744; all 20 approximations equal Mathews' 20 values to six decimals (Simpson on his node sets: 2.491261 … 2.016252). New frames 6 and 7 viewed at full size: "Split [1/2, 1]", 11 points, 1.935128, blue markers at 0.625 and 0.875; "Split [0, 1/2]", 13 points, 2.001744, blue markers at 0.125 and 0.375.

### F2 — Minor — fixed
- Reproduced: `indep.py` runs Mathews' recursive `Adapt` with every f evaluation recorded: 20 leaves, 81 distinct evaluation points (351 calls), value 2.01627260396. `counts.py`: the frame loop tests 39 panels, which sample 81 distinct points; leaf nodes + leaf quarter-points = 81; composite nodes = 41.
- Change: `index.qmd` l.33, "Refinement stops when all 20 panels (41 points) pass the test; $[1.5,2]$ is never split, while 19 of the 41 points lie in $[0,1/8]$." → "Refinement stops when all 20 panels pass the test. The 41 points drawn are the nodes of the composite rule; the test also evaluates each panel's two quarter-points, so reaching this partition samples $f$ at 81 distinct points. $[1.5,2]$ is never split, while 19 of the 41 nodes lie in $[0,1/8]$."
- Alt text ("ends with 41 points") and the GIF label "Sample Points = 41" left as they are: both describe the drawn points, which is what the alt text and label are about, and the label is Mathews' own (R7-D, smallest correct change).
- Check: `counts.out` — panels 20, nodes 41, nodes in [0, 1/8] 19, [3/2, 2] never split, distinct f points 81.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.27 | "$[1/2,1]$ is split before $[0,1/2]$, as in Mathews' trace" | `inst.out` sets 5, 6 → split [1/2,1] then [0,1/2]; `indep.out` all 20 sets match Mathews' `lnk_8` node list; legacy GIF frame shows 11 pts / 1.935128 | yes |
| index.qmd l.27 | "leftmost first" otherwise | `inst.out` all other splits in width-then-left order | yes |
| index.qmd l.33 | 20 panels | `counts.out` → panels 20 | yes |
| index.qmd l.33 | 41 points drawn = composite-rule nodes | `counts.out` → nodes 41; GIF frame 21 "Sample Points = 41" | yes |
| index.qmd l.33 | test evaluates each panel's two quarter-points | script l.20 `accepted` computes S(p,m), S(m,q) → f at (3p+q)/4, (p+3q)/4 | yes |
| index.qmd l.33 | 81 distinct points | `indep.out` recursive Adapt → 81; `counts.out` frame loop → 81 | yes |
| index.qmd l.33 | [1.5,2] never split | `counts.out` → False | yes |
| index.qmd l.33 | 19 of the 41 nodes in [0,1/8] | `counts.out` → 19 (endpoint 1/8 included) | yes |
| index.qmd l.33 (unchanged, rechecked) | last seven frames split [0,1/16] … [0,1/1024] | `counts.out` splits of frames 15–21 | yes |
| index.qmd l.33 (unchanged, rechecked) | 2.016252, 2.016280, 2.016273 | `indep.out` → 2.01625176116, 2.0162797196171, 2.01627260396 | yes |
| GIF frame 6 label | Sample Points = 11, Approximation = 1.935128, Split [1/2, 1] | `inst.out` set 5; frame_006.png viewed | yes |
| GIF frame 7 label | Sample Points = 13, Approximation = 2.001744, Split [0, 1/2] | `inst.out` set 6; frame_007.png viewed | yes |

## Scripts and GIFs
- Script changed: `adaptivesimpsonsaa.jl` (split order at one stage). GIF regenerated: `adaptivesimpsonsaa.gif` (21 frames, as before).
- Frame comparison against the committed GIF (`cmpframes.py`, old GIF via `git show | git lfs smudge`): frames 6 and 7 changed in content (13261 and 611 pixels differ by > 24); every other frame differs only by palette quantization (9–62 pixels, since the GIF palette is shared across frames). Frame hashes all changed for the same reason.
- Frames viewed full size: 6, 7, 21 (Sample Points = 41, Approximation = 2.016252, Split [0, 1/1024]); contact sheet of the legacy GIF.
- `git status --short -- pages/numerical-methods/adaptive-simpsons-rule`: `M adaptivesimpsonsaa.gif`, `M adaptivesimpsonsaa.jl`, `M index.qmd`.

## Legacy archive
Consulted. `n2003/adaptivequad/AdaptiveQuadMod/Links/AdaptiveQuadMod_lnk_8.html` (Example 7, `Adapt[0,2,0.001]`) lists 20 node sets; table images `gr_185`–`gr_204` give the sums (188–190 read directly: 1.941436, 1.935128, 2.001744); `a2001/Animations/Quadrature/AdaptQuad/AdaptQuadaa.gif` shows the same 11-point stage. Mathews splits [1/2, 1] before [0, 1/2]; the page now follows him at that step and reproduces all 20 of his node sets and values. Mathews also labels the composite-rule nodes "Sample Points", which the GIF keeps; the page text now says the test samples 81 distinct points.

## Notes
- The split order is a presentation choice only; both orders reach the same final partition (verified: sets 6–20 identical).
- No convention gaps noted beyond the existing "(Planned)" stubs, which were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Parsed all 20 node sets from Mathews' `AdaptiveQuadMod_lnk_8.html` (`check/mathews_sets.txt`) and dumped the script's 20 node sets, split panels and composite sums from a scratch copy (`check/dump.jl` -> `check/script_sets.txt`). `check/cmp.py`: all 20 node sets match (counts 3,5,...,41, values to Mathews' 6-digit printing).
- Script split order: [0,2], [0,1], [1,2], [1/2,1], [0,1/2], [1,3/2], [0,1/4], [1/4,1/2], [1/2,3/4], [3/4,1], [0,1/8], [1/8,1/4], then [0,1/16] down to [0,1/1024]. An independent replay (`check/indep.py`) confirms every Mathews step is a split of a currently failing panel of the widest failing width, and that the final 20 panels all pass.
- Script sums per stage: 2.491261, 1.611786, 1.909633, 1.941436, **1.935128**, 2.001744, 2.003302, 2.012445, 2.013092, 2.012906, 2.012774, 2.015124, 2.015195, 2.015920, 2.016148, 2.016219, 2.016242, 2.016249, 2.016251, 2.016252. These match the 20 values in Mathews' table (`gr_185`-`gr_204`, viewed as `check/table.png`) digit for digit.
- Final result is unchanged: the final partition is the same 20 panels; composite = 2.0162517612 (2.016252), recursive S(a,m)+S(m,b) = 2.0162726040 (2.016273), integral (mpmath, 30 digits) = 2.0162797196, error = -2.80e-5.
- The tie-break `first_panel = (0.5, 1.0)` affects only the one step where the width-1/2 failing panels are [0,1/2], [1/2,1], [1,3/2]. No other stage changes.
- Frame 6 now shows "Sample Points = 11, Approximation = 1.935128, Split [1/2, 1]", with blue points at 0.625 and 0.875. Frame 7 shows "Split [0, 1/2]", 2.001744, with blue points at 0.125 and 0.375. Page line 27 states the exception.

### F2 — resolved
- Evidence: Line 33 now says that the 41 drawn points are the composite-rule nodes and that the test also evaluates each panel's two quarter-points, so f is sampled at 81 distinct points. Independent count: the 41 final nodes plus the 40 quarter-points of the 20 final panels give 81 distinct points. Every intermediate panel's quarter-points are nodes of its children, so 81 is the full evaluation set.
- The GIF label "Sample Points = 41" and the alt text "ends with 41 points" are unchanged. Both now read correctly as drawn nodes, given the clarified text, and the label matches Mathews' "sample points" column. This is acceptable.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.27 | "leftmost first, except that [1/2,1] is split before [0,1/2], as in Mathews' trace" | script split sequence vs Mathews' node sets (all 20 match) | correct |
| index.qmd l.33 | "all 20 panels pass the test" | final partition has 20 panels, none failing | correct |
| index.qmd l.33 | "41 points drawn are the nodes of the composite rule" | final node set has 41 points | correct |
| index.qmd l.33 | "81 distinct points" | 41 + 40 quarter-points = 81 distinct | correct |
| index.qmd l.33 | "[1.5,2] is never split" | not in any split list | correct |
| index.qmd l.33 | "19 of the 41 nodes lie in [0,1/8]" | count of x <= 0.125 is 19 | correct |
| index.qmd l.33 (unchanged) | last seven splits [0,1/16]..[0,1/1024]; last five at most 1/64 wide; 2.016252, 2.016280, -2.8e-5, 2.016273 | split list; mpmath integral | correct |
| adaptivesimpsonsaa.jl l.27-29 | comment "following it at that one step reproduces all 20 of his node sets" | cmp.py | correct |
| adaptivesimpsonsaa.jl l.37-39 | sort key (width desc, first_panel tie-break, left endpoint) | produces Mathews' order | correct |
| GIF frame 6 / 7 | 11 pts, 1.935128, Split [1/2,1] / 13 pts, 2.001744, Split [0,1/2] | viewed at full size; matches table | correct |

### New problems
None. This rests on the following:
- All 20 stages match Mathews' nodes and values.
- The final value is unchanged.
- Frames 1, 6, 7, 11 and 21 were viewed at full size.
- A pixel diff against the pre-fix GIF shows real changes only in frames 6 and 7 (the swapped split order). Every other frame differs only at palette/antialias level: at most 13 pixels per frame with a channel-sum difference above 60.

### Reproducibility and conventions
- The scratch run of the script produced a GIF byte-identical to the committed one (sha256 0984c206...df6, which matches the LFS oid).
- The page keeps its conventions: Description comes before Animations, there is a source link and an embed, the alt text is descriptive, and there are no code blocks.
- Only the three page files are modified. The untracked `pages/numerical-methods/numerical-differentiation/index_files/` was already present at session start and is outside this page.

**Final status:** committed
