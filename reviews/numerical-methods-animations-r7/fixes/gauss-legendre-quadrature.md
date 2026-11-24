# Fix record: gauss-legendre-quadrature

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/gauss-legendre-quadrature/fix/` (written as `$S` below). Frames: `old/` (committed GIF before the fix), `new/` (regenerated GIF), `legacy/` (Mathews' GIF).

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - Viewed `$S/old/frame_004.png` ($n=2$) at full size. Red stems at $x\approx0.42$ and $x\approx1.58$ run from the axis to the dots, in the same red as the bar outlines, and split each bar into two apparent cells.
  - `python3 -I $S/scan.py $S/old/frame_005.png` (red runs on the row at 90% of image height) gives px `[37, 102, 198, 327, 456, 552]`: the left axis plus five interior lines. Of these, only 198 and 456 are bar edges, as the review reported. In frame 4 my colour threshold catches only `[37, 327, 495]`, so the stem at px≈159 is anti-aliased below the threshold. It is clearly visible in the full-size frame.
  - `python3 -I $S/geom.py` (SciPy `roots_legendre`) for $n=3$: bounds $(0, 0.5556, 1.4444, 2)$, nodes $(0.2254, 1, 1.7746)$, apparent cells $(0.2254, 0.3302, 0.4444, 0.4444, 0.3302, 0.2254)$. For $n=2$ the apparent cells are $(0.4226, 0.5774, 0.5774, 0.4226)$ against true widths $(1, 1)$. Every node lies strictly inside its bar for both $n$ (`inside True`).
- **Change:** `gausslegendreaa.jl`. Deleted the node-stem loop (old lines 89-91, plus one blank line): `for i in eachindex(x_nodes) plot!([x_nodes[i], x_nodes[i]], [0.0, f(x_nodes[i])]; color=:red, lw=0.6) end` → removed. Regenerated `gausslegendreaa.gif`. `index.qmd` is unchanged because it never mentioned the stems. Its sentence "Each shaded bar has width $w_i$ … each node lies inside its own bar" now matches what the picture shows. This is the review's first option, as R7-D directs.
- **Check:**
  - `python3 -I $S/scan.py $S/new/frame_004.png $S/new/frame_005.png` → `[37, 327]` and `[37, 198, 456]`. Only the axis and the true bar edges remain.
  - Viewed new frames 5 ($n=3$) and 24 ($n=64$) at full size, plus the contact sheet `$S/new/sheet.png`. Each bar is a single cell with its dot on the top edge, inside the bar, and the labels are legible.
  - No number changed. The diff removes plotting lines only. `python3 -I $S/textcheck.py $S` shows 0 changed pixels (threshold 40) in the title/label band (rows 0-159, cols 250-529) across all 24 frames. It also recomputes all 21 labels with SciPy nodes: 1.154628, 2.332149, 2.106664, 2.014623, 2.019465, 2.017912, 2.017086, 2.016729, 2.016553, 2.016457, 2.016400, 2.016365, 2.016327, 2.016308, 2.016298, 2.016292, 2.016289, 2.016286, 2.016285, 2.016283, 2.016282. These are identical to the review's frame-label column.
  - `python3 -I $S/pixdiff.py $S`: intro frames 1-3 change by at most 39 per channel and have 0 pixels above 40. This is GIF palette requantisation (the palette is built from all frames), not a content change. Frames 4-24 change only where the stems were. The few hits at rows 164-169 inside the label columns are stem tops near the hump of $f$, below the text.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| — | No text, heading, alt text, title or label was added or changed. | `git diff -- pages/numerical-methods/gauss-legendre-quadrature/index.qmd` → empty. GIF labels: `textcheck.py` → 0 changed pixels in the label band; 21 recomputed labels match. | yes |

## Scripts and GIFs
- Script changed: `gausslegendreaa.jl` (stem loop removed). GIF regenerated: `gausslegendreaa.gif`, 24 frames as before.
- Frames viewed: new 5 and 24 at full size, the contact sheet, and new 4 and 5 by pixel scan. Checked: bars built from the cumulative weights, one cell per node, each dot at $(x_i, f(x_i))$ inside its bar, titles and labels unchanged.
- `git status --short -- pages/numerical-methods/gauss-legendre-quadrature` after regeneration:
  ```
   M pages/numerical-methods/gauss-legendre-quadrature/gausslegendreaa.gif
   M pages/numerical-methods/gauss-legendre-quadrature/gausslegendreaa.jl
  ```

## Legacy archive
Consulted `a2001/Animations/Quadrature/GaussLegendre/GaussLegendreaa.gif` (24 frames, extracted to `$S/legacy/`). Legacy frame 5 ($n=2$, "Approximation = 1.154628") draws the two bars and the red dots with no vertical stems, so the fixed page now matches the archive drawing. Its 1.154628 equals the page's $n=2$ label, recomputed above.

## Notes
- The stated scope was this one finding, with no ambiguity under R7-D.
- I noticed no convention gaps that need action.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The diff deletes the stem loop (old lines 89-91, `plot!([x_i,x_i],[0,f(x_i)]; color=:red, lw=0.6)`), as the finding suggested. Nothing else in the script or page changed.
- Pixel scan at 90% of image height (`check/scan.py`), counting red outline runs (R>200, G<120, B<120): old frames have about 2n-1 lines (n=2: 3, n=3: 6, n=16: 24, n=64: 95). New frames have n lines, which is the left edge plus the n-1 interior bar boundaries (n=2: 3 old to 2 new; n=3: 6 to 3; n=16: 24 to 16; n=64: 95 to 61, where some adjacent edges merge into one run near the ends because the bars are narrow there).
- n=3 new frame: lines at px 37, 198 and 456. Bar bounds are 0, 0.5556, 1.4444 and 2, mapped onto the axis at px 37 to 617, which matches. The old stems at px 102, 327 and 552 (nodes 0.2254, 1.0, 1.7746) are the only places where old and new frame 5 differ by more than 40 in value. All other differences are at most 39, which is GIF palette requantization.
- Visual check of frames 1, 5, 13 and 24 at full size: each node shows only as a red dot on the top edge of its own bar, and the node lies inside that bar. The page sentence in index.qmd line 35 ("each node lies inside its own bar") now matches the picture. This also matches the archive drawing, which has bars and dots and no stems.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| (none) | No page text, alt text, title or label changed. The only script change is the deleted stem loop. | Labels shown in the regenerated GIF were recomputed independently with numpy leggauss on [0,2]: n=3 gives 2.332149, n=16 gives 2.016457, n=64 gives 2.016282. The scipy quad reference is 2.0162797. | All agree |

### New problems
None. This rests on three checks. First, the old and new frames differ only at the removed stem columns, apart from palette noise of 39 or less. Second, the intro frames 1-3 are unchanged except for that palette noise. Third, the numeric labels are unchanged and verified, and the alt text and Behavior text never mentioned the stems.

### Reproducibility and conventions
- I ran a scratch copy of gausslegendreaa.jl. Its output GIF has sha256 bf4e590d…a948, which is byte-identical to the working-tree GIF and matches the new LFS oid in the diff. The GIF has 24 frames.
- index.qmd is unchanged, so the conventions still hold: Description comes before Animations, the case has a Julia source link and an embed with descriptive alt text, and there are no code blocks. Within this page folder, only gausslegendreaa.jl and gausslegendreaa.gif changed. Other modified paths in the repo belong to other pages and are not part of this fix's diff.

**Final status:** committed
