# Fix record: chebyshev-approximation-polynomial

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/chebyshev-approximation-polynomial/fix/`

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced:
  - Legacy text: `chebyshevpoly/ChebyshevPolyMod/Links/ChebyshevPolyMod_lnk_15.html` (Example 7 / Animation 7) shows formula image `gr_499` = "f[x] = 1/√(1−x)" and `gr_500` = "[-1.5, 0.95]" (both viewed). The a2001 animation index row 7 (`Interpolation/Chebyshev/Chebyshev.html`, `Lagrange_gr_13`/`gr_14`) gives y = 1/√(1−x) over −1.6 ≤ x ≤ 1.5, which is the page's plotting window. Spot-checked the reviewer's pattern claim on the tan example: code image `gr_593` sets `aa = -1.45; bb = 1.45`, equal to the text interval.
  - Script before the fix: case 07 nodes on (−1.6, 0.9).
  - Independent error check: `python3 -I indep.py` (mpmath, 50 digits, barycentric interpolant at Chebyshev nodes, max |p−f| on 4001 points of [a,b]) → [−1.6, 0.9]: 0.2511 (n=6), 0.003214 (n=16); [−1.5, 0.95]: 0.7681 (n=6), 0.03156 (n=16). This matches the reviewer's figures. The ratio at n=16 is about 9.8.
- Change:
  - `chebyshev_animations_all.jl` line 34: `(-1.6, 1.5), (-1.6, 0.9)` → `(-1.6, 1.5), (-1.5, 0.95)`. The plotting window is unchanged.
  - `index.qmd` Case 07 alt text: `interval [-1.6, 0.9]` → `interval [-1.5, 0.95]`.
  - `cheby07.gif` regenerated.
- Check:
  - Instrumented copy (`instr.jl`, which runs the script's own `resolved_span`/`chebyshev_nodes`/`barycentric_eval` for case 07 only) → `span=(-1.5, 0.95)`. Its max errors equal the mpmath values to 4 significant figures for every n: n=2 2.726 … n=6 0.7681 … n=16 0.03156 (`instr.out`, `indep.out`).
  - All frame titles read "interval [-1.5, 0.95]", with n = 2…16 and degree ≤ n−1.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` Case 07 alt text | "f(x)=1/sqrt(1-x), interval [-1.5, 0.95]." | `instr.jl` → `07 span=(-1.5, 0.95)`; legacy `gr_500` reads "[-1.5, 0.95]" | yes |
| `cheby07.gif` title (generated) | "Chebyshev Case 07: f(x) = 1/sqrt(1-x) / interval [-1.5, 0.95], n = k nodes, degree ≤ k−1" | read in full-size frames 001 and 010 and on the contact sheet (all 10 frames) | yes |
| script row 07 | `(-1.5, 0.95)` | as above | yes |

No other sentence, heading or number on the page was changed. The page has no Behavior text for case 07, so no convergence claim was added.

## Scripts and GIFs
- Script changed: `chebyshev_animations_all.jl` (one table row). I regenerated all 29 GIFs with `julia chebyshev_animations_all.jl` from the page folder.
- md5 before and after (`before.md5`, `after.md5`): only `cheby07.gif` changed. The other 28 GIFs are byte-identical.
- Frames viewed (`frames07/`: frame_001, frame_010 at full size, plus the contact sheet of all 10):
  - the nodes (red) lie on f (magenta);
  - the leftmost node is near −1.5 and the rightmost is at x ≈ 0.944, where f = 4.23, inside the y-window (top ≈ 4.7);
  - the interpolant (blue) is visibly off f near x=1 at n=2…8 and lies on top of it at n=16;
  - the titles show the correct interval, n and degree bound.
- `git status --short -- pages/numerical-methods/chebyshev-approximation-polynomial` after regeneration: `M cheby07.gif`, `M chebyshev_animations_all.jl`, `M index.qmd`.

## Legacy archive
I consulted the archive:
- **n2003 Example 7:** 1/√(1−x) on [−1.5, 0.95]. Its code image `gr_501` is missing.
- **a2001 index row 7:** window −1.6 ≤ x ≤ 1.5, matching the page.
- **Animation GIF:** Mathews' animation GIF for case 7 is not in the archive. `Chebyshev07/` contains only `Chebyshevgg.html`, and there is no `gifs/` content, so Mathews' frames could not be compared.

The page now follows Mathews' interval. This is also mathematically sound: f is finite on [−1.5, 0.95] because 0.95 < 1.

## Notes
- This follows the R2-A/R3-B rule (follow Mathews for a parameter of an existing case). No "not animated here" sentence exists on this page, so R3-D did not apply.
- The reviewer noted dead code (`xs_lo`/`y_lo`/`xs_hi`/`y_hi` in `render_case`). It is not a finding, so I left it alone.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence:
  - Script row for case 07 now reads `with_span("07", "1/sqrt(1-x)", ..., (-1.6, 1.5), (-1.5, 0.95))`; the plotting window [-1.6, 1.5] is unchanged, the node interval is now [-1.5, 0.95].
  - Legacy check: `ChebyshevPolyMod_lnk_15.html` (Example 7 / Animation 7) uses formula image `ChebyshevPolyMod_gr_500.gif`. I upscaled it and it reads "[-1.5, 0.95]". The new interval matches Mathews. This also follows fix-plan decision R2-A ("Follow Mathews" when the departure is a parameter such as the interval). No legacy Chebyshev07 GIF survives (`a2001/Animations/Interpolation/Chebyshev/Chebyshev07/` has only the HTML), so there is no picture to compare against.
  - The `index.qmd` caption/alt text now reads `f(x)=1/sqrt(1-x), interval [-1.5, 0.95].`, which matches the script and the GIF title.
  - I computed the Chebyshev nodes and the max interpolation error independently in mpmath (40 digits, barycentric form, 4001-point grid on the interval). On [-1.5, 0.95]: n=2 nodes at -1.1412 and 0.5912; n=6 error 0.768; n=16 error 0.0316 and largest node 0.94410 (f = 4.2296). On the old [-1.6, 0.9]: n=6 error 0.251, n=16 error 0.0032. This reproduces the finding's numbers. All nodes satisfy x < 0.95 < 1, so f is finite at every node, and `chebyshev_nodes` takes attempt 0 (no trimming). The plotted nodes are therefore exactly the mapped Chebyshev roots on [-1.5, 0.95].
  - GIF frames 1, 5 and 10 (n=2, 6, 16) at full size: the title reads "interval [-1.5, 0.95], n = 2/6/16 nodes, degree ≤ 1/5/15". The n=2 nodes sit at about -1.14 and 0.59 (y ≈ 0.69, 1.56). At n=6 the rightmost node is at about 0.91 (y ≈ 3.30). At n=16 the rightmost node is at about 0.944 (y ≈ 4.23), the leftmost at about -1.495, and the interpolant overlays f across the interval. All of these agree with my computation.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `chebyshev_animations_all.jl` line 34 | node span `(-1.5, 0.95)` | Matches Mathews Example 7 (gr_500 reads [-1.5, 0.95]); f = (1-x)^(-1/2) is finite on the whole span (max 1/sqrt(0.05) = 4.472) | correct |
| `chebyshev_animations_all.jl` line 34 | plotting window `(-1.6, 1.5)` (unchanged) | Still the legacy window per the finding | correct |
| `index.qmd` Case 07 alt text | "f(x)=1/sqrt(1-x), interval [-1.5, 0.95]." | Same as the script span and the GIF title (`fmt_num` gives "-1.5", "0.95") | correct |
| `cheby07.gif` title (regenerated) | "interval [-1.5, 0.95], n = k nodes, degree ≤ k-1" for k = 2,3,4,5,6,8,10,12,14,16 | 10 frames, matching `node_count_sequence(15)` and the Animations intro sentence | correct |

### New problems
None. This rests on:
- the single-row script change, which touches only case 07's data and no shared code;
- the regeneration reproducing all 29 GIFs byte for byte, so no other case changed;
- my independent node and error computation matching the plotted nodes;
- a full-size look at the first, middle and last frames. The y-window (about 0.2 to 4.7) contains f over the whole interval, including f(0.95) = 4.47. The f curve rises out of the frame toward the branch point at x = 1 and is absent for x > 1, where f is not real. The legend and title are legible.

The Animations intro ("steps through 2, ..., 16 Chebyshev nodes") remains true for case 07.

### Reproducibility and conventions
- I ran a scratch copy of `chebyshev_animations_all.jl` in `check/run/` and it generated 29 GIFs. Every committed/working-tree GIF in the page folder, all 29, is byte-identical to its regenerated counterpart. The SHA-256 of `cheby07.gif` is 67d65d96...0cec9 in both, which matches the new LFS pointer oid in the diff. The pre-fix GIF (smudged from the HEAD LFS pointer, 95568 bytes) also has 10 frames, and its interval differs as expected.
- Conventions hold: Description comes before Animations, there is one Julia source link for all cases (the page's established pattern), each case has its own embed with descriptive alt text, and there are no code blocks.
- Outside the page folder: the fix diff covers only the three page files. The working tree also has changes on other numerical-methods pages and untracked `reviews/.../fixes/*.md` records. Those belong to other pages' fixers, and nothing in this page's diff touches them.

**Final status:** committed
