# Fix record: chebyshev-approximation-polynomial

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/chebyshev-approximation-polynomial/fix/` (below: `$S`).

Evidence scripts:
- `$S/dump.jl <script> <prefix>`: includes the script's own definitions (without the render loop) and prints, for each case:
  - the resolved span, the node sequence, the y-limits and the title interval;
  - for each frame, whether the trim fallback in `chebyshev_nodes` fired, which nodes fall outside the window, and the largest error on the span (with its location and whether it is visible).
  - It also writes every node and value to `<prefix>_nodes.tsv`. Run against `orig_script.jl` (the committed script) gives `orig_dump.txt` and `orig_nodes.tsv`; run against `new_script.jl` (the fixed script) gives `new_dump.txt` and `new_nodes.tsv`.
- `$S/indep.py <nodes.tsv> [orig]`: the independent check (numpy/scipy). It recomputes the Chebyshev nodes and f at those nodes for every case and frame and compares them with the script's. It also fits the Chebyshev coefficients of each interpolant (`chebfit`, degree n−1) to find its actual degree. Run with `/usr/bin/python3 -I`.
- `$S/fspan_check.jl new_script.jl`: checks that f over each approximation interval (200001 points) lies inside the new y-window. Output: `fspan_check.out`.
- `$S/titlefit.py <dir>`: measures, in every extracted frame, the pixel extent of the title above the plot box. Output for the new frames: `titlefit_after.txt`.
- `$S/titlestrip.jl`: stacks title strips from several frames. `before_titles_19_20_21.png` is built from committed frames.
- `$S/before/cNN/`, `$S/after/cNN/`: frames of the committed and the regenerated GIFs (giftools).
- `$S/archive/`: legacy formula images converted to PNG, and frames of the legacy animations 04 and 29.

## Findings

### F1 — Error — fixed
- **Reproduced.** `orig_dump.txt` shows `seq=[2, 3, 4, 5, 6, 8, 10, 12, 14, 16]` for 28 cases and `seq=[2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32]` for case 08. giftools gives 10 frames for every committed GIF except cheby08, which has 14. So the node count, and with it the degree, does not go up by one per frame after n = 6.
- **Change.** index.qmd:22 "Each animation increases polynomial degree one step at a time for a fixed function and approximation interval." → "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes (case 08 continues to 20, 24, 28 and 32) for a fixed function and approximation interval. With $n$ nodes the interpolant has degree at most $n-1$; for an even function on a symmetric interval and even $n$ it is at most $n-2$." The second sentence is shared with F4. Following D7, the text was changed and the animation was not.
- **Check.** `new_dump.txt` gives the same sequences, and the regenerated GIFs have 10 frames each (14 for cheby08). The new frame titles read "n = 2 nodes" through "n = 16 nodes". Viewed: `after/c24/sheet.png` (n = 2, 3, 4, 5, 6, 8, 10, 12, 14, 16) and `after/c08/frame_001.png` (n = 2).

### F2 — Error — fixed
- **Reproduced.**
  - `orig_dump.txt`: `CASE 19 has_span=false … span=(-0.9993178717598908, 0.9993178717598908) title_interval=[-0.999, 0.999]`.
  - The committed titles read "interval [-0.999, 0.999]" (`before_titles_19_20_21.png`).
  - `indep.py orig` reproduces the case-19 nodes from that span (max deviation 1.7e-15 over all cases).
  - So [-1.5, 1.5] is only the plot x-range.
- **The round-1 suggestion would not have worked.** Its suggested fix (`with_span(..., (-1.0, 1.0))` alone) would not change the interval. `resolved_span` intersected the explicit span with `finite_support`, so `max(-1.0, -0.99932)` would still give ±0.99932. The cause is that intersection.
  - For every other `with_span` case the intersection did nothing. In `orig_dump.txt`, span equals node_span for cases 01-11, 14 and 24-29.
- **Change.**
  - `chebyshev_animations_all.jl`, case 19: `auto_span(...)` → `with_span("19", "asin(x)", x -> asin(x), (-1.5, 1.5), (-1.0, 1.0))`.
  - `resolved_span` now returns an explicit span as given, with a comment. Only `auto_span` cases fall back to `finite_support`. `chebyshev_nodes` still checks that f is finite at every node.
  - index.qmd:100 alt text: "interval [-1.5, 1.5]" → "interval [-1, 1]".
- **Check.**
  - **Case 19.** `new_dump.txt`: `CASE 19 has_span=true node_span=(-1.0, 1.0) … span=(-1.0, 1.0) title_interval=[-1, 1]`, `trimmed=false` for every frame, and every f(node) is finite. `indep.py new_nodes.tsv` (span (-1, 1)) gives a max deviation of 1.7e-15. asin(±1) = ±1.5707963 is finite (`fspan_check.out`).
  - **Other cases unchanged.** `grep -v '^19' new_nodes.tsv | cmp - <(grep -v '^19' orig_nodes.tsv)` → identical. The only node lines that differ are case 19's 80 lines (2+3+…+16 = 80).
  - **Frame.** `after/c19/frame_010.png` reads "interval [-1, 1], n = 16 nodes, degree ≤ 15".

### F3 — Error — fixed (with the checker's correction)
- **Reproduced.** `before_titles_19_20_21.png` (committed frames):
  - Case 19, frames 8 and 10, end "degree 1" (the true degrees are 11 and 15).
  - Case 20, frames 1 and 10, end at "degree" with no readable digit; frame 10 shows only a sliver.
  - Case 21, frames 1 and 10, end at "degree".
  - `titlefit.py before` → max right title pixel 759 for a 760-px frame.
  - This matches the corrected finding: case 20 shows no degree at all, not a wrong one.
- **Change.**
  - The title is wrapped onto two lines: `"Chebyshev Case $(id): f(x) = $(label)\ninterval [a, b], n = $(n_nodes) nodes, degree ≤ $(n_nodes - 1)"`.
  - `top_margin=3Plots.mm` was added so that the second line clears the plot box. A first regeneration without it showed the second line touching the box (case 19, frame 10).
- **Check.**
  - `titlefit.py after` → over all 294 frames of the 29 GIFs, the title spans columns 38 to 673 of 760. The rightmost case is c13 (673).
  - The minimum gap of 1 px belongs to case 16, where the y tick label "2" sits at the box top. That is not the title; see `after/c16/frame_010.png`.
  - Viewed at full size: c19 f10, c20 f10, c16 f10, c03 f10, c08 f1 and c09 f3. Every one has a fully legible two-line title ending in the correct n and degree bound.

### F4 — Minor — fixed
- **Reproduced.** `indep.py orig_nodes.tsv orig` fits Chebyshev coefficients to each interpolant:
  - **Even f (cases 08, 13, 17, 20, 22).** Every even n gives actual degree n−2 (for example, case 08: 1→0, 3→2, …, 31→30).
  - **Odd f, or odd plus a constant (cases 12, 14, 18, 19, 21, 23).** Labels 2 and 4 are actually degrees 1 and 3.
  - **Case 15.** 15→13 is a tolerance artefact: the top coefficient is about 1e-11 relative, as the finding says.
- **Change.**
  - The frame label is now "n = N nodes, degree ≤ N−1" (in the F3 title).
  - index.qmd:22 has the sentence quoted under F1.
  - index.qmd:56 alt text "up to order 31" → "up to 32 nodes". "Order 31" overstated the degree in the same way, since the 32-node interpolant has degree 30.
- **Check.**
  - **Degree bound.** In `indep.py new_nodes.tsv`, every frame of every case has actual degree ≤ n−1.
  - **Even functions.** Cases 08, 13, 17, 20 and 22 have actual degree n−2 at every even n. All five are even functions on symmetric intervals ([-1,1], [-3π,3π], [-4,4], [-10.2,10.2], [-3,3]). In general the interpolant of an even f at symmetric nodes is even by uniqueness, so for even n its degree is at most n−2.
  - **Frames.** `after/c08/frame_001.png` shows a flat line titled "n = 2 nodes, degree ≤ 1".

### F5 — Minor — fixed
- **Reproduced.**
  - **Off-window nodes.** `orig_dump.txt` lists nodes outside the window in cases 01, 02, 03, 04, 05, 06, 07, 09, 10, 11 and 16. Examples: case 03 at n=16 `[(0.846, 42.26), (0.894, 88.97)]`; case 01 at n=16 `[(0.894, 9.43)]`.
  - **Case 03 error.** At n=16 the largest error is `maxerr=1.434 at x=0.9000 f=100 … visible=false max_visible_err=0.6581`, matching the finding. The window top is 37.50.
  - **Flat edges.** The committed `before/c03/frame_010.png` shows f and the interpolant running flat along the top edge.
  - **The trim fallback never fires** (`trimmed=true` count: 0).
- **Change** (`chebyshev_animations_all.jl`):
  - **New `window_ylims`.** It takes the existing quantile window (`robust_ylims`, unchanged) and widens it only where needed, so that the range of f over the approximation interval (2001 points), plus 5% padding, lies inside it.
  - **Clamping.** f and the interpolant are no longer clamped to the window edges. They are clamped only to a band one window-height beyond the limits, so a curve that leaves the window runs off the frame instead of along its edge. The comment above the limits explains this.
  - **ylims changes.** ylims changed only for cases 01-07, 09-11, 15-17, 19 and 27-29; the others keep their window (diff of the `ylims=` fields between `orig_dump.txt` and `new_dump.txt`).
  - **Not done.** No new drawing elements were added.
- **Check.**
  - **Nodes.** `new_dump.txt` has 0 off-window nodes in any frame of any case.
  - **f on the span.** `fspan_check.out`: f over the span lies inside the window for all 29 cases (for example, case 03 f ∈ [0.148, 100.0], window [-5.09, 105.24]).
  - **Largest error.** It is now visible in every frame except two, where the interpolant (not f) overshoots the window: case 13 at n=6 (p = −1.344 at x = 0) and case 23 at n=2 (p = −0.183 at x = −3). Both appear as the curve leaving the frame.
  - **Frames.** `after/c03/frame_010.png` shows the nodes at y ≈ 42 and 89 and f reaching 100 at x = 0.9. `after/c09/frame_003.png` and `after/c24/sheet.png` show f and the interpolant leaving the frame steeply, not running along the edges.

### F6 — Minor — fixed
- **Reproduced.** In `orig_dump.txt`, cases 04, 05 and 06 share xlims (0, 10.5) and ylims (0.156, 3.587). Cases 27, 28 and 29 share xlims (0, 22) and ylims (-0.465, 0.618). The script (lines 27-29, 50-52) has nothing that singles out 04 or 29, so "(expanded)" describes nothing in the GIFs.
  - The archive explains the word. Mathews' animation index lists nodes in [0, 2] for 04 and in [0.5, 4] for 29, while the site uses [0, 4] and [0.5, 6]. "(expanded)" probably recorded that the node interval was widened from the legacy example; see Legacy archive below.
- **Change.** "(expanded)" was deleted from the index.qmd:40 and index.qmd:140 alt texts.
- **Check.** `grep -n expanded index.qmd` → no match. The intervals [0, 4] and [0.5, 6] match `new_dump.txt` (`title_interval=[0, 4]`, `[0.5, 6]`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:22 | "steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `julia dump.jl new_script.jl $S/new` → `seq=[2, 3, 4, 5, 6, 8, 10, 12, 14, 16]` for the 28 cases other than 08; giftools: 10 frames each | yes |
| index.qmd:22 | "(case 08 continues to 20, 24, 28 and 32)" | same → case 08 `seq=[…, 16, 20, 24, 28, 32]`; giftools: 14 frames | yes |
| index.qmd:22 | "for a fixed function and approximation interval" | unchanged wording. The span and f are fixed per case in `render_case`, and the title interval is constant within each GIF. | yes |
| index.qmd:22 | "With $n$ nodes the interpolant has degree at most $n-1$" | `/usr/bin/python3 -I indep.py new_nodes.tsv` → actual (chebfit) degree ≤ n−1 for every frame | yes |
| index.qmd:22 | "for an even function on a symmetric interval and even $n$ it is at most $n-2$" | same → cases 08, 13, 17, 20, 22 (even f on [-1,1], [-3π,3π], [-4,4], [-10.2,10.2], [-3,3]): actual = n−2 at every even n. General reason: the interpolant is even by uniqueness. | yes |
| index.qmd:40 alt | "f(x)=sqrt(x), interval [0, 4]." | `new_dump.txt` → `CASE 04 … span=(0.0, 4.0) title_interval=[0, 4]` | yes |
| index.qmd:56 alt | "…interval [-1, 1], up to 32 nodes." | `new_dump.txt` → case 08 seq ends at 32; span (-1.0, 1.0). `after/c08` last frame title "n = 32 nodes, degree ≤ 31" (giftools 14 frames) | yes |
| index.qmd:100 alt | "f(x)=asin(x), interval [-1, 1]." | `new_dump.txt` → `CASE 19 … span=(-1.0, 1.0) title_interval=[-1, 1]`; viewed `after/c19/frame_010.png` | yes |
| index.qmd:140 alt | "f(x)=bessely(0,x), interval [0.5, 6]." | `new_dump.txt` → `CASE 29 … span=(0.5, 6.0) title_interval=[0.5, 6]` | yes |
| GIF titles (all 29) | line 1 "Chebyshev Case NN: f(x) = …"; line 2 "interval [a, b], n = N nodes, degree ≤ N−1" | The node count N is `length(xs)` per frame (`new_nodes.tsv` rows per (case, n)). The degree bound is checked by `indep.py` as above. The interval comes from `fmt_num(span)` (`title_interval=` in `new_dump.txt`). `titlefit.py after` → title columns 38-673 of 760 in all 294 frames. | yes |
| script: `resolved_span` comment | "An explicit node interval is used as given (chebyshev_nodes checks that f is finite at every node); only cases without one fall back to the finite support" | Code: `case.has_span && return case.node_span`. `chebyshev_nodes` rejects non-finite node values (`all(isfinite, ys)`). `new_dump.txt`: span = node_span for every `with_span` case. | yes |
| script: `window_ylims` comment | "Widen the quantile window so that f over the whole approximation interval, and therefore every node, lies inside it." | `fspan_check.out` → 0 cases with f outside the window on the span. `new_dump.txt` → 0 off-window nodes. | yes |
| script: `render_case` comment | "Curves are clamped only to a band one window-height beyond the limits, so where they leave the window they run off the frame instead of along its edge." | Code: `band = (lo − h, hi + h)`, h = hi − lo. Viewed `after/c09/frame_003.png` and `after/c24/sheet.png`: the curves exit through the frame with no flat run along an edge. | yes |
| script: case 19 | `with_span(..., (-1.5, 1.5), (-1.0, 1.0))` | see F2 | yes |

## Scripts and GIFs
- **Script changed:** `chebyshev_animations_all.jl`, as follows.
  - Case 19 uses `with_span` with (-1, 1).
  - `resolved_span` uses explicit spans as given.
  - New `window_ylims`.
  - Curves are clamped to the band, not to the window.
  - The title is two lines and carries "n = N nodes, degree ≤ N−1".
  - `top_margin=3Plots.mm` was added.
- **GIFs.** All 29 GIFs were regenerated with `julia chebyshev_animations_all.jl` from the page folder, which printed "Generated 29 GIFs.". All 29 change, as expected, because the title of every frame changed. The node data of cases other than 19 are identical to before (`cmp` above).
- **Frames viewed (full size):**
  - c19 frame 10: the title, interval [-1, 1], and nodes inside (-1, 1).
  - c16 frame 10: the title, and the left end f(−2) = −3.075 inside the window.
  - c03 frame 10: the nodes at 42 and 89 are visible, and f reaches 100.
  - c08 frame 1: the flat line, "degree ≤ 1".
  - c08 frame 14: "n = 32 nodes, degree ≤ 31", with all 32 nodes inside the window.
  - c09 frame 3: f leaves the frame toward the singularity.
  - c20 frame 10: the full title.
- **Frames viewed (contact sheet):** c24, which shows the n progression and the curves leaving the frame.
- **git status of the page folder after regeneration:** `M` for cheby01.gif … cheby29.gif, chebyshev_animations_all.jl and index.qmd (31 files). No untracked files.

## Legacy archive
- **Consulted.** The archive pages read were:
  - `n2003/ChebyshevPolyMod.html` and its links `lnk_12`–`lnk_27`, which only hyperlink to the animations;
  - the animation index `a2001/Animations/Interpolation/Chebyshev/Chebyshev.html`, with formula images `Images/Lagrange_gr_N.gif` (odd N = f, even N = plot range).
- **Missing GIFs.** Legacy GIFs exist for only 12 of the 29 cases. Those for 01, 05, 07-09, 11, 13, 14, 16-23 and 25 are missing; 19 among them.
- **What it shows:**
  - **Case 19.** f = ArcSin[x] with "-1.5 ≤ x ≤ 1.5" (`gr_37`, `gr_38`). In the archive that range is the plot range, not the node interval; for example, case 04's range is "0 ≤ x ≤ 10.5" (`gr_8`) with "nodes in [0, 2]". No node interval is given for 19 and its GIF is missing. The fixed page uses [-1, 1], the domain of asin, which is finite at ±1.
  - **Cases 04 and 29.** The index lists nodes in [0, 2] (case 04) and [0.5, 4] (case 29). The legacy GIFs agree: Chebyshevdd.gif has its node bracket at x = 2, and Chebyshevccc.gif at x ≈ 4 (`$S/archive/a04/sheet.png`, `a29/sheet.png`). The site uses [0, 4] and [0.5, 6]. That is the likely source of "(expanded)". The site's intervals are mathematically valid, so they were kept. Restoring Mathews' intervals is Jason's call.
  - **Degree sequence.** Mathews' animations step one degree at a time (S₂, S₃, …, S₆ in 04; S₂ … S₇ in 29) and stop at low degree. The site skips degrees after 5 and goes to 15. Under D7 the page text now describes the site's sequence; the animation was not changed.

## Notes
- **D7.** "Each animation … one step at a time" was resolved by changing the text. The round-1 alternative was to change `node_count_sequence` to `2:max_order+1`. That would give 15 frames (31 for case 08) and match Mathews' one-step progression. It is a possible later choice, not a correction.
- **Two interpolant overshoots.** With the new window, two frames still have their largest error outside the window, because the interpolant overshoots: case 13 at n=6 and case 23 at n=2. f and all nodes are visible in every frame, so this was left as is.
- **Pre-existing, not touched:**
  - `render_case` computes `xs_lo/y_lo/xs_hi/y_hi`, which are never used.
  - In late frames the magenta f is fully covered by the interpolant (drawing order).
  - The page has no Behavior paragraphs per case; this is a convention gap and was not added.

## Resolution check (independent checker, not shown this record)

Work files: `check/analyze.jl` (per-case old vs new span, y-window, nodes outside the window, max error), `check/deg.py` (actual degree of the interpolants), `check/frames/chebyNN/` (all frames of all 29 GIFs), `check/strips/{first,last}_{A,B}.png` (title strips of the first and last frame of every case), `check/grid/{mid,last}_{A,B}.png` (frame 5 and the last frame of every case), `check/run/` (regenerated GIFs).

### Original findings

### F1 — resolved
- Evidence: index.qmd:22 now says the animations step through 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes, and case 08 continues to 20, 24, 28, 32. `node_count_sequence` (unchanged) returns exactly those values: `analyze.jl` prints `seq=[2,…,16]` for 28 cases and `[2,…,16,20,24,28,32]` for case 08. The GIFs have 10 frames each and 14 for cheby08. The frame titles read n = 2 … 16 (and n = 32 in the last frame of cheby08), as the title strips show. The page no longer claims a one-step progression.

### F2 — resolved
- Evidence: case 19 is now `with_span(..., (-1.5,1.5), (-1.0,1.0))`. `resolved_span` returns an explicit span unchanged, so the span is exactly (-1, 1): `analyze.jl` prints `spanNew=(-1,1) CHANGED`, and case 19 is the only case whose span changed. No trimming retry happens in any case (`trims=[]` for all 29), so every node lies on the stated interval. asin is finite at ±1 (asin(±1) = ±π/2), and the first-kind nodes are interior anyway. The alt text says [-1, 1], and every frame title of cheby19 reads "interval [-1, 1]" (I read frames 1 and 10 at full size). At n=2 the nodes are ±0.7071 with y = ±0.785 = asin(√2/2), which is correct.

### F3 — resolved
- Evidence: the title now has two lines ("Chebyshev Case NN: f(x) = …" / "interval [a, b], n = N nodes, degree ≤ N−1"), with `top_margin=3mm`. In the title strips of the first and last frames of all 29 cases, both lines are centred, complete and legible. That includes case 19 ("n = 16 nodes, degree ≤ 15"), case 20 ("[-10.2, 10.2], n = 16 nodes, degree ≤ 15"), case 21 and the widest title, cases 12 and 13 ("interval [-9.425, 9.425], n = 16 nodes, degree ≤ 15"). No text is clipped on either side.

### F4 — resolved
- Evidence: frames are now labelled "n = N nodes, degree ≤ N−1", which is true for every frame. The page adds: "With n nodes the interpolant has degree at most n−1; for an even function on a symmetric interval and even n it is at most n−2." `deg.py` interpolates at the script's nodes in the Chebyshev basis. For cases 08, 13, 17, 20 and 22, the top coefficient c_{n−1} relative to max|c| is at most 3.5e-15 for every even n, and it is O(1) for n = 3 and 5. That confirms the sentence. The symmetric spans are exact: (-1,1), ±9.42478 (from a symmetric grid), (-4,4), (-10.2,10.2) and (-3,3). The flat line in cheby08 frame 1 is now titled "degree ≤ 1", which is accurate.

### F5 — resolved
- Evidence: the new `window_ylims` widens the quantile window to cover the extrema of f over the approximation interval plus a 5 % pad. Curves are clamped to a band one window-height beyond the limits, so they leave the frame rather than run along its edge. `analyze.jl`, all 29 cases, every frame: no node lies outside the window (`offnodes=0`), and f on the span (20001 points) never leaves the window (`fout=false`). Case 03: the window is now (-5.09, 105.2), versus (-4.71, 37.5) before. The last-frame nodes (0.846, 42.3) and (0.894, 89.0) are visible in the full-size frame 10. The largest error at degree ≤ 15 (1.43 at x = 0.9, where f = 100) now lies inside the window. Cases 01, 02, 07, 09, 10, 11 and 16 were also widened (for example 01: top 6.51 → 10.52; 09: bottom −2.67 → −4.20). In the mid and last frames of those cases, f and the interpolant now leave the frame at its edge instead of running flat along it.

### F6 — resolved
- Evidence: "(expanded)" is removed from the alt text of cases 04 and 29. The remaining text ("interval [0, 4]", "interval [0.5, 6]") matches the spans (0,4) and (0.5,6) and the frame titles.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:22 | "steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `node_count_sequence(15)` = that list; 10 frames per GIF; titles n=2…16 | true |
| index.qmd:22 | "(case 08 continues to 20, 24, 28 and 32)" | `node_count_sequence(31)` appends 20,24,28,32; cheby08 has 14 frames, last title n = 32 | true |
| index.qmd:22 | "for a fixed function and approximation interval" | span and f are fixed per case; the title interval is identical in all frames | true |
| index.qmd:22 | "With n nodes the interpolant has degree at most n−1" | n-point interpolation; the Chebyshev-basis fit has n coefficients | true |
| index.qmd:22 | "even function on a symmetric interval and even n … at most n−2" | `deg.py`: c_{n−1} ≈ 1e-15 relative for every even n in cases 08, 13, 17, 20, 22; nonzero for odd n | true |
| index.qmd:40 | "Case 04 … sqrt(x), interval [0, 4]." | span (0,4); title "[0, 4]" | true |
| index.qmd:56 | "Case 08 … interval [-1, 1], up to 32 nodes." | span (-1,1); last frame n = 32 | true |
| index.qmd:100 | "Case 19 … asin(x), interval [-1, 1]." | span exactly (-1,1); titles "[-1, 1]" | true |
| index.qmd:140 | "Case 29 … bessely(0,x), interval [0.5, 6]." | span (0.5,6); title "[0.5, 6]" | true |
| script:225 (frame title) | "interval [a, b], n = N nodes, degree ≤ N−1" | a, b from `fmt_num(span)`, matching the computed spans for all 29 cases; N matches the node count drawn (markers counted in frames 1, 5 and last of several cases) | true |
| script:75-77 (comment) | "chebyshev_nodes checks that f is finite at every node" | true; no case triggers the trim retry, so title intervals are exact | true |
| script:154-155 (comment) | "f over the whole approximation interval, and therefore every node, lies inside it" | `fout=false`, `offnodes=0` for all cases | true |

### New problems

None. This rests on four checks:
- The span change affects only case 19 (`analyze.jl`: 28 cases `same`).
- No case uses the trim fallback.
- I viewed frames 1, 5 and the last at reduced size for all 29 cases, and frames 1/10 of cases 19 and 03, frame 14 of case 08 and frame 1 of case 23 at full size. Every drawn element checks out: f, the barycentric interpolant through the drawn nodes, and node y = f(node x).
- Titles are legible in every first and last frame.

Pre-existing artefacts that the fix leaves unchanged, and which are not findings here:
- Case 14 draws a vertical magenta segment across tan's poles at ±π/2.
- Endpoint node markers in cases whose x-limits equal the span (01, 02, 03, 07) sit partly on the frame edge.

### Reproducibility and conventions

- The copied script ran in `check/run/` (41 s). All 29 regenerated GIFs are byte-identical to the working-tree GIFs (`cmp`). The working-tree SHA-256 values match the new LFS oids in the diff (for example cheby01 `c5f13c7b…`, cheby19 `f8fa46bf…`).
- The page keeps its conventions: `## Description` comes before `## Animations`, there is one source link (a single table-driven script for all cases), 29 embeds with descriptive alt text, and no code blocks.
- Files outside the page folder: the fix diff touches only the page folder. The working tree also has changes in other pages under `pages/numerical-methods/`, including `pages/numerical-methods/index.qmd` (links for Milne-Simpson, Predictor-Corrector and Shooting Methods), plus untracked `reviews/numerical-methods-animations/fixes/*.md` notes. These belong to the other page fixes running in the same tree; none of them refers to this page. The section index still links `chebyshev-approximation-polynomial/`.

**Final status:** committed
