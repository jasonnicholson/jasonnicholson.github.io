# Fix record: newton-interpolation-polynomial

The scratch folder (S) is shared with the Lagrange fix:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/lagrange-polynomial-interpolation-and-approximation/fix/`
Scripts: `legacy_px.py`, `lib.jl` + `dump.jl`, `check.py`, `wider.jl`, and `expA/lagnewt_expA.jl`. Each is described in `fixes/lagrange-polynomial-interpolation-and-approximation.md`.

## Findings

### F1 — Minor (fidelity) — fixed (R2-A: follow Mathews on case parameters)
- **Reproduced.**
  - The script table had Cases 01 and 03 with window = nodes = (−1.6, 0.9), Case 02 with (−0.9, 1.6), and Case 07 with (−1.6, 0.9).
  - Archive windows (Lagrange.html formula images `Lagrange_gr_2/4/6/14`, viewed in `S/legacy_formulas.png`): 01: −1.6 ≤ x ≤ 1.5; 02: −1.5 ≤ x ≤ 1.6; 03: −1.6 ≤ x ≤ 1.5; 07: −1.6 ≤ x ≤ 1.5.
  - Legacy `Lagrangeaa.gif` (Case 01), extracted with giftools to `S/legacy_aa/` and measured with `/usr/bin/python3 -I legacy_px.py legacy_aa`:
    - The axis x = 0 is at column 325 and the green node-interval markers at columns 20 and 508.
    - Red nodes: frame 4 at 19.4, 263.5, 507.4; frame 6 at 19.4, 181.5, 344.5, 507.4; frame 12 at 19.4 … 507.4, evenly spaced.
    - Scaling by 0.9 ↔ 507.4 gives 202.7 px per unit, so the left node is at x = −1.508.
    - Mathews' Case 01 nodes are therefore on [−1.5, 0.9], and his window runs past the pole to 1.5. The finding holds for Case 01.
  - Case 07: the static Example 6 in both modules (`LagrangePolyMod_gr_377/378`, `NewtonPolyMod_gr_435/436`: 1/√(1−x) on [−1.5, 0.95]) links to "Animation 7" (`LagrangePolyMod_lnk_17`, `NewtonPolyMod_lnk_19`). Its code (`LagrangePolyMod_gr_379`) sets aa = −1.5 and bb = 0.95.
  - Cases 02 and 03: no legacy GIF exists. The windows are confirmed, and the node spans could not be read from the archive.
- **Change** (`lagnewt_animations_all.jl`, case table, both copies byte-identical):
  - 01: window (−1.6, 1.5), nodes (−1.5, 0.9). Both are Mathews' (measured).
  - 02: window (−1.5, 1.6) (Mathews'), nodes (−0.9, 1.5). The nodes are the mirror of 01, because f₀₂(x) = f₀₁(−x) and the windows are mirror images. This span is inferred.
  - 03: window (−1.6, 1.5) (Mathews'), nodes (−1.5, 0.9). The window and pole are the same as 01, so 01's node pattern is used. This span is inferred.
  - 07: window (−1.6, 1.5) (Mathews' animation index), nodes (−1.5, 0.95) (Mathews' Example 6, linked to animation 7).
  - A 4-line comment states the sources.
  - The Lagrange page headings and alt texts for 01, 02, 03 and 07 were updated to match (see its record).
  - This page's text needs no change. It names no intervals and sends readers to the Lagrange page. Its sentence "with nodes at both ends of the interval" still holds: `dump.jl` gives `trimmed=false` for all 29 cases.
- **Check.**
  - `julia wider.jl` printed `01 window (-1.6, 1.5) span (-1.5, 0.9)`, `02 window (-1.5, 1.6) span (-0.9, 1.5)`, `03 window (-1.6, 1.5) span (-1.5, 0.9)` and `07 window (-1.6, 1.5) span (-1.5, 0.95)`.
  - `check.py` (mpmath, 80 digits): node x deviation ≤ 1.08e-16, node y relative error ≤ 2.72e-16, and interpolant max relative error ≤ 1.55e-12 at all 1000 points × 10 degrees, with 0 sign errors in both barycentric forms.
  - The 02 node set is the exact mirror of 01's (max deviation 0).
  - Frames viewed (both folders' GIFs are byte-identical, so the views apply to both):
    - Contact sheets of all frames of 01, 02, 03 and 07, plus 01 frame 10 and 07 frame 1 at full size.
    - The nodes sit on f, and the interpolant passes through them.
    - The pole is visible in 01, 02 and 03. In 07, f stops at x = 1 and the interpolant continues to 1.5. (Superseded by "Round 2 after check" below.)

## Ledger of changed text
No text on this page changed. The changed text on the Lagrange page (Cases 01, 02, 03 and 07 headings and alt texts, and the line-21 case list) is ledgered in `fixes/lagrange-polynomial-interpolation-and-approximation.md`. The new script comment:

| Location | New text | Check | Confirmed |
|---|---|---|---|
| script l.23–26 comment | "Cases 01-03 and 07 use Mathews' plot windows, which run past the singularity of f at x = 1 (x = -1 in Case 02)." | Windows: archive `gr_2/4/6/14`. Singularities: 1/(1−x) and 1/(1−x)² have poles at 1, 1/(1+x) at −1, and 1/√(1−x) is singular at 1. All of these lie inside the windows. | yes |
| same | "Nodes: 01 as in his animation; 02 mirrors 01; 03 as 01; 07 as in his static example linked to animation 7." | Pixel measurement of `Lagrangeaa.gif` gives the left node at −1.508. The mirror deviation is 0. The span of 03 equals the span of 01. `LagrangePolyMod_lnk_17` "Solution 6 → Animation 7", and code `gr_379` has aa = −1.5, bb = 0.95. | yes |

## Scripts and GIFs
- **Script.** `lagnewt_animations_all.jl` was edited once in the Lagrange folder and copied here. `cmp` is silent, and both copies' md5 sums match.
- **Regenerated.** `julia lagnewt_animations_all.jl` was run here (exit 0). `git status -- pages/numerical-methods/newton-interpolation-polynomial` shows only `lagnewt01.gif`, `lagnewt02.gif`, `lagnewt03.gif`, `lagnewt07.gif` and `lagnewt_animations_all.jl` modified. The other 25 `lagnewt*.gif` files are byte-identical to the committed ones. `newtpolyaa.*` is untouched. All 29 `lagnewt*.gif` files are byte-identical to the Lagrange folder's copies.

## Legacy archive
Consulted:
- `a2001/Animations/Interpolation/Lagrange/`: the index, formula images, and `Lagrangeaa.gif`. The only other legacy GIFs are `Lagrangedd.gif` (04) and `Lagrangeii.gif` (09).
- `n2003/newtonpoly/NewtonPolyMod` (Examples 5–8, `gr_404–459`).
- `n2003/lagrangepoly/LagrangePolyMod` (Examples 5–7, `gr_346–389`, `lnk_17`).

The Lagrange round-2 review's row C01 claims the legacy GIF has nodes on [−1.6, 0.9]. The pixel measurement contradicts that and agrees with this page's reviewer ([−1.5, 0.9]).

## Notes
- **Spans for 02 and 03 are inferred.** R2-A says to follow Mathews. His windows for 02 and 03 are known, but his node spans are not, because the GIFs are missing. The spans used follow his measured Case 01 pattern (mirror for 02). If Jason prefers only archive-attested numbers, the alternative is to keep the windows and revert the 02/03 node spans to (−0.9, 1.6) and (−1.6, 0.9).
- **Case 07 nodes.** The span is (−1.5, 0.95), from the example linked to animation 7. The reviewer's other option, (−1.5, 0.9), was not used.
- **Pictures.** With the wider windows, the auto y-limits include the negative branch beyond the pole in 01 and 02 (computed ylims (−17.6, 17.0), `S/ylims.jl`). In Case 03 the y-limits are (−138.6, 592.5) because of the double pole. Mathews' Case 01 showed only y ≥ 0. Adding per-case y-limits would mean new code, so it was not done. (Superseded: per-case y-limits were added after the check; see N1–N3 below.)
- **Out of scope, not touched.** The reviewer's note about `newtpolyaa`, which is not Mathews' Example 1, and the page not mentioning clamping. Neither is a finding.

## Round 2 after check

The coordinator's check confirmed F1. It then raised N1 (Case 03 y-limits too large, which hid the degree-5 error), N2 (Cases 01–03 compressed, with the pole drawn as a vertical segment or a flat bar) and N3 (the Case 02 legend hid the curves near x = −1).

All three are fixed in the shared script, which was copied byte for byte from the Lagrange folder (`cmp` silent). The changes are:
- a per-case `pole` field: y-limits come from f on the node interval, and f is unclamped with a NaN at the pole;
- a per-case `legend` field: Case 02 uses `:topright`.

Regeneration and checks:
- The script was regenerated here (exit 0).
- `git status` here shows only `lagnewt01/02/03/07.gif` and the script.
- The other 25 GIFs are byte-identical to the committed ones, and all 29 match the Lagrange folder.
- Numbers from `S/r2check.jl`:
  - Case 03 y-limits are (−17.46, 112.58).
  - The degree-5 error of 2.71 is now about 9 px tall.
  - The Case 01 and 02 y-limits are (−1.65, 11.25).
  - The curves under the new Case 02 legend reach at most 4.0, below the legend's lower edge at y ≈ 9.2.

Full evidence, frames and the ledger are in `fixes/lagrange-polynomial-interpolation-and-approximation.md`, "Round 2 after check". This page's text needed no change: it does not describe clamping, windows or y-ranges.

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
