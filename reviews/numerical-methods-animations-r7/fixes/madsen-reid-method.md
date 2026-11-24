# Fix record: madsen-reid-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/madsen-reid-method/fix/` (`greenscan.py`, `runs.py`, `pixdiff.py`, `raw_old/`, `raw_new/`, `trace/trace.jl`, `before/`, `after/`).

## Findings

### F1 — Misleading — fixed
- **Reproduced:** extracted the committed `madsreidab.gif` with `giftools.jl` into `fix/before/`, then ran `python3 -I greenscan.py before/frame_00{1..6}.png`. This finds the densest seagreen row in each frame. The thick green axis bar spans columns 129–627 (frame_003, x2), 73–627 (frame_004), 95–628 (frame_005) and 109–628 (frame_006). These are the review's numbers: in frames 004–006 the bar runs the full plot width, past the current step's ends. The cause is `madsreidab.jl` line 223, which redraws every earlier step's `lw=3` axis segment in every frame. Step 1's segment (2.8 to 0.4) and step 2's (0.743 to 1.086) cover the zoom windows.
- **Change:** `madsreidab.jl` lines 221–226. Before: `xt[k] != xn1 && plot!([xt[k], xn1], [0.0, 0.0]; color=col, lw=3, label="")`. After: `(frame < 2 || k == frame) && xt[k] != xn1 && plot!(...)`, which is the review's suggested line, plus a two-line comment. Older axis segments are now drawn only in the unzoomed frames 0–1. Tangents and landing verticals are unchanged. Regenerated `madsreidab.gif`. `index.qmd` is unchanged, because its sentence ("the tangent reaching the axis halfway along the step, then the second Δx along the axis") is now what the frames show.
- **Check:**
  - **Bar extent.** `python3 -I runs.py after/frame_00{3..6}.png` with box-spine detection measures the contiguous axis bar.
    - frame_003: columns 346–563, which is 0.387 of the plot width.
    - frame_004: columns 143–351 (0.376).
    - frame_005: columns 163–362 (0.375).
    - frame_006: columns 175–369 (0.375).
    - Expected: half a step in a window 1.3 steps wide, 0.5/1.3 = 0.385, less the few pixels under the red marker at the left end.
  - **Newton point is the step midpoint.** `julia trace/trace.jl` (the script's solver plus a print loop) gives (newton − x_{k+1})/(x_k − x_{k+1}) = 0.500000 for steps 2–5, all with k=2. Step 1 gives 0.666667 (k=3), which is unzoomed and keeps its bar.
  - **Visual check.** Viewed frame_003 and frame_006 at full size. The bar runs from the tangent's foot (0.743 in frame_003; 1.000000115 in frame_006) to the red marker at the new iterate, and nothing extends beyond.
  - **Unzoomed frames unchanged.** Instrumented copies of the HEAD script and the new script copied Plots' pre-GIF PNG frames out (`raw_old/`, `raw_new/`). Frames 000001 and 000002 are byte-identical (`cmp`). Frames 3–6 differ in 851–1016 pixels, only along the axis band.
    - In the GIF itself, every decoded frame's framemd5 changes, including frames 1–2 (5,401 and 6,037 pixels, max channel difference 49).
    - This is palette requantization only. Plots/ffmpeg build one palette from all frames, so the colours shift when the content of frames 3–6 changes. The rendered pixels of frames 1–2 are identical, as the PNG comparison shows.
  - **Same script, same GIF.** The `raw_old` GIF is byte-identical to the committed GIF, and the `raw_new` GIF is byte-identical to the regenerated repo GIF.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `madsreidab.jl` comment, lines 222–223 | "zoomed frames draw only the current step's axis part, so older steps' thick segments do not cover the window" | `runs.py` on the new frames: bar covers 0.375–0.387 of the plot width (expected 0.385); frames 001–002 raw PNGs are byte-identical to HEAD | yes |
| `index.qmd` | no change | The existing sentence at line 57 now matches: `trace.jl` gives a midpoint ratio of 0.500000 for zoomed steps 2–5, and the bar runs from the Newton point to x_{k+1} | yes |

No GIF title, label or alt text changed. The frame count is still 6.

## Scripts and GIFs
- **Script changed:** `madsreidab.jl`. **GIF regenerated:** `madsreidab.gif`. `madsreidaa` and `madsreidac` were not touched.
- **Frames viewed:**
  - Contact sheet and full-size frame_003 and frame_006.
  - Labels are unchanged: "x2 = 1.0857142857 (Stage 1)" and "x5 = 0.99999999952 (Stage 1)".
  - The legend is unchanged, and the axis bar is limited to the current step's second Δx.
- `git status --short -- pages/numerical-methods/madsen-reid-method`:
  ```
   M pages/numerical-methods/madsen-reid-method/madsreidab.gif
   M pages/numerical-methods/madsen-reid-method/madsreidab.jl
  ```

## Legacy archive
Consulted by grep. `grep -rli madsen` over `n2003/` finds only unrelated pages: an Auburn course URL containing "nmadsen" in Pivoting/NewtonSearch/LinearProgramming bibliography links. "Reid" matches only bibliography pages. Mathews has no Madsen-Reid topic, and the page follows `newton_real` under R2-C/R3-A. Nothing in the archive bears on this fix.

## Notes
- The GIF's palette is shared across frames, so "unzoomed frames keep identical pixels" holds for the rendered frames (raw PNGs byte-identical) but not for the decoded GIF frames. Those shift by up to 49 levels in about 5–6k pixels from requantization. This cannot be avoided without changing how Plots writes GIFs, so it was left as is.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `madsreidab.jl:225-226` now draws the thick axis segment only when `frame < 2 || k == frame`, so the zoomed frames (frame >= 2) draw only the current step's segment [x_{k+1}, x_k - Δx]. The older tangents and verticals are still drawn, which is correct.
- I re-ran the iteration from a scratch copy: x1 = 0.4 (k=3), x2 = 1.0857142857, x3 = 1.0011741683, x4 = 1.0000002296, x5 = 0.99999999952 (k=2 each, all Stage 1). The Newton points are 2.8, 0.742857, 1.043440, ...
- Pixel scan of the longest green run on the axis row (row 429) in the new committed GIF, against the columns predicted from the window formula (15% margins):

  | Frame | Iterate | Predicted bar (px) | Observed run (px) | Fraction of plot width |
  |---|---|---|---|---|
  | `frame_003` | x2 | 347 to 563 | 345 to 563 | 0.389 |
  | `frame_004` | x3 | 136 to 350 | 143 to 351 | 0.376 |
  | `frame_005` | x4 | 157 to 362 | 163 to 362 | 0.375 |
  | `frame_006` | x5 | about 170 to 369 | 175 to 369 | |

  The ideal fraction is 0.5/1.3 = 0.385. In the old GIF the bar ran edge to edge (or from 0.4 to the right spine). The few-pixel offset at the left end is the red marker covering the bar.
- Visual check at full size of frames 003 to 006: the tangent meets the axis at the Newton point, about halfway along the step. The thick green bar then runs only to the red marker. So index.qmd:57 ("the tangent reaching the axis halfway along the step, then the second Δx along the axis") is now true. Labels and the legend are unchanged and legible.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| madsreidab.jl:222-223 (comment) | "zoomed frames draw only the current step's axis part, so older steps' thick segments do not cover the window" | Matches the condition `frame < 2 \|\| k == frame` (the zoom starts at frame 2, line 197) and the frames | true |
| madsreidab.jl:225-226 | drawing condition | Old steps' bars are dropped only when frame >= 2; unzoomed frames are unchanged (below) | correct |
| index.qmd | no change | Line 57 is now true of the GIF (F1 evidence) | ok |

### New problems
None. This rests on:
- The unzoomed frames 0 and 1 are unchanged. Rendered straight to PNG (no GIF quantization), the old and new scripts give byte-identical images for these frames (000001.png, 000002.png). In the GIFs their decoded hashes differ only through palette re-dithering: max channel difference 49, and no pixel differs by more than 100. The owner's decision allows this.
- The zoomed frames differ only by the removed old bars (frames viewed at full size).
- The iterates and the printed trace are the same as before. The fix touches only drawing.

### Reproducibility and conventions
- The scratch copy of `madsreidab.jl`, run with plain `julia`, produced a GIF byte-identical to the committed `madsreidab.gif` (sha256 4c8333d7…). Its decoded frame hashes also match.
- index.qmd is untouched. Description comes before Animations, each case has a source link and an embed, the alt text is descriptive, and there are no code blocks.
- The page's diff touches only `madsreidab.jl` and `madsreidab.gif`, both in the page folder. The other working-tree changes belong to other pages' fixes and are not part of this page's diff.

**Final status:** committed
