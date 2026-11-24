# Fix record: chebyshev-approximation-polynomial

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/chebyshev-approximation-polynomial/fix/` (below: `$S`).

## Findings

### F1 — Minor — fixed
- Reproduced: `$S/instr.jl` is the script's definitions (lines 1-200) plus a loop that, for every case and frame, evaluates the unclamped interpolant on the script's own 1000-point plot grid, keeps the points inside the approximation interval, and compares them with the script's own `window_ylims`. `cd $S && julia instr.jl` (output `$S/f1_current.out`) lists exactly the review's seven frames, with the same counts and ranges:
  - 08 n=3 (24/666, excess 6.4%)
  - 12 n=8 (78/1000, 8.8%)
  - 13 n=5 (4/1000, 1.1%)
  - 13 n=6 (90/1000, 10.2%)
  - 22 n=3 (62/1000, 12.1%)
  - 23 n=2 (54/1000, 2.8%)
  - 27 n=8 (2/886, 9.3%)

  No other case or frame has an in-interval point off the frame. Viewed by eye: `cheby13.gif` frame 5 (n = 6), where the blue curve leaves the bottom around x = 0; and `cheby27.gif` frame 6 (n = 8), where it leaves the bottom just right of x = 0.5.
- Change: `index.qmd` line 22. Before: "Green dashed vertical lines mark the ends of the approximation interval; outside them the blue curve is extrapolation and can leave the frame." After: "Green dashed vertical lines mark the ends of the approximation interval. Outside them the blue curve is extrapolation and can leave the frame; with 8 or fewer nodes its overshoot can also leave the frame inside the interval (cases 08, 12, 13, 22, 23 and 27)." This is the text-only option, under R7-D and D7. The review's word "briefly" was dropped, and "at low $n$" was replaced by the computed bound: the n values involved are 2, 3, 5, 6 and 8.
- Check: `julia instr.jl new` (`$S/f1_new.out`) repeats the scan with Case 26 on [0.05, 5]. It gives the same seven frames, so the F2 change adds no case to the list. Every listed n is ≤ 8, and every listed case appears in the output.

### F2 — Minor — fixed
- Reproduced:
  - **Index text.** The legacy index text (`a2001/Animations/Interpolation/Chebyshev/Chebyshev.html`) says "[0.5, 5]" for Case 26, and "[0.05, 2]" and "[0.05, 4]" for Cases 24 and 25.
  - **Legacy GIF.** `Chebyshev26/Chebyshevzz.gif` (37 frames, extracted to `$S/legacy26/`) has a final frame titled S25[x] with 26 red nodes. Its leftmost three nodes sit at y ≈ 17.8, 10.5 and 5.7, and its left interval line is next to the y-axis.
  - **Independent check.** `/usr/bin/python3 -I $S/f2_check.py` (mpmath, 40 digits) computes the smallest 26-point Chebyshev nodes on each interval:
    - on [0.05, 5]: 0.054516, 0.090541, 0.16207, where Γ = 17.818, 10.55, 5.7332. These match the legacy dots.
    - on [0.5, 5]: 0.50411, 0.53686, 0.60188, where Γ = 1.7583, 1.654, 1.4849. These do not match.

  So the legacy animation uses [0.05, 5], as the review says.
- Change:
  - `chebyshev_animations_all.jl` line 53: `(0.5, 5.0)` → `(0.05, 5.0)`.
  - `index.qmd` line 128 caption: "interval [0.5, 5]" → "interval [0.05, 5]".
  - Regenerated `cheby26.gif`.
- Check:
  - **Well behaved.** `f2_check.py` shows that Γ on [0.05, 5] (4001 points) is finite and positive throughout. Its minimum is 0.88560 at x ≈ 1.462, and its endpoint values are 19.470 and 24.0.
  - **Max error.** The max interpolation error on [0.05, 5] falls from 19.8 (n = 2) to 1.61 (n = 16). At n = 6 it is 11.07, matching the review's 1.107e+01, and at n = 16 it is 1.61, matching 1.610e+00.
  - **Script nodes.** `julia $S/nodes26.jl` loads the edited script's definitions. It gives span = (0.05, 5.0), and for every n in 2…16 the script's nodes equal the mapped-root formula exactly (maxdiff = 0.0), so the endpoint-trim fallback does not fire. At n = 16 the smallest node is 0.06192, with Γ = 15.6312.
  - **Frames.** Frames 1, 5 and 10 of the new GIF were viewed. The titles read "interval [0.05, 5], n = 2 / 6 / 16 nodes", the left green line is at 0.05, the nodes lie on f, and at n = 16 the first node is at about (0.06, 15.6).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.22 | "Outside them the blue curve is extrapolation and can leave the frame" (kept, re-punctuated) | Seen in `cheby27.gif` frame 6: the curve leaves the top for x > 20 | yes |
| index.qmd l.22 | "with 8 or fewer nodes its overshoot can also leave the frame inside the interval" | `julia instr.jl` → off-frame in-interval frames only at n ∈ {2, 3, 5, 6, 8} | yes |
| index.qmd l.22 | "(cases 08, 12, 13, 22, 23 and 27)" | `julia instr.jl` and `julia instr.jl new` → exactly these six cases | yes |
| index.qmd l.128 | "interval [0.05, 5]" | `nodes26.jl` → span = (0.05, 5.0); GIF titles read "interval [0.05, 5]" | yes |
| script l.53 | `(0.05, 5.0)` | legacy GIF node heights 17.8/10.5/5.7 vs mpmath Γ at the [0.05, 5] nodes 17.818/10.55/5.7332 | yes |
| cheby26.gif titles | "interval [0.05, 5], n = … nodes, degree ≤ n−1" | frames 1, 5 and 10 viewed | yes |

## Scripts and GIFs
- Script changed: `chebyshev_animations_all.jl` (one row). Regenerated with `julia chebyshev_animations_all.jl` from the page folder, which produced all 29 GIFs.
- `git status --short` of the page folder after regeneration: `M cheby26.gif`, `M chebyshev_animations_all.jl`, `M index.qmd`. The other 28 GIFs are byte-identical.
- Frames viewed:
  - `cheby26.gif` frames 1, 5 and 10;
  - `cheby13.gif` frame 5;
  - `cheby27.gif` frame 6;
  - the legacy `Chebyshevzz.gif` frame 37.

## Legacy archive
Consulted.
- The index text (`a2001/Animations/Interpolation/Chebyshev/Chebyshev.html`) gives Case 26 as [0.5, 5].
- The legacy GIF `Chebyshev26/Chebyshevzz.gif` uses [0.05, 5]: its 26 node heights match Γ at the Chebyshev nodes of [0.05, 5] and not those of [0.5, 5].
- The page now follows the animation, under R7-B and R2-A. The function is well behaved on [0.05, 5] (Γ is finite and positive; its pole at 0 lies outside the interval), so following Mathews does not make the page wrong.
- `n2003/chebyshevpoly/` holds only `ChebyshevPolyMod/` (images and links, no `ChebyshevPolyMod.html` at the path named in the brief) and was not needed.

## Notes
- The review's robustness note (not a finding) still applies and was not acted on. The gamma pole at x = 0 in Cases 24-26 is not in `poles`, and the curve breaks there only because the 1000-point grid lands on 0.0. The plot window of Case 26 is unchanged, so the grid is unchanged, and the new frames show the break correctly.
- The page has no per-case Behavior paragraphs (captions only). This is a pre-existing convention gap, not a finding, so nothing was added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `index.qmd` line 22 now says the blue curve leaves the frame outside the interval, and that "with 8 or fewer nodes its overshoot can also leave the frame inside the interval (cases 08, 12, 13, 22, 23 and 27)". I loaded the current script's functions without rendering (`check/instr/instr.jl`, output `check/instr/instr.out`). For every case and every n, I evaluated the unclamped interpolant on the 1000-point plotting grid inside the approximation interval and compared it with `window_ylims`. Off-frame in-interval frames: 08 n=3, 12 n=8, 13 n=5, 13 n=6, 22 n=3, 23 n=2 and 27 n=8. That is exactly cases {08, 12, 13, 22, 23, 27}, and the largest such n is 8, so "8 or fewer nodes" is true. Every number matches the review table. The new Case 26 on [0.05, 5] has no in-interval off-frame frame: its y-window is [-12.25, 32.02] and Γ(0.05) = 19.47, so the list is still complete after the F2 change. The script was not changed for F1, and the finding offered a text-only fix, so no GIF needed regenerating.

### F2 — resolved
- Evidence: the script row is now `(0.05, 5.0)`, and the caption on line 128 says `interval [0.05, 5]`. This follows owner decision R7-B ("Case 26 uses [0.05, 5]"). The regenerated `cheby26.gif` titles read "interval [0.05, 5]" on all 10 frames, and the left green line sits at x ≈ 0.05. The node abscissas match the Chebyshev formula on [0.05, 5]: n=2 gives 0.7749 and 4.2751, and n=16 has min 0.0619 and max 4.9881, both as drawn. The node values sit on Γ, for example Γ(0.0619) ≈ 15.6 in the last frame. My max interpolation errors on [0.05, 5] are 1.107e1 (n=6) and 1.610 (n=16), which match the finding's table for the legacy interval.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.22 | "Green dashed vertical lines mark the ends of the approximation interval." | vline! at `span` in the script; seen in the frames | true |
| index.qmd l.22 | "Outside them the blue curve is extrapolation and can leave the frame" | unchanged meaning; the curve is clamped to a band one window-height beyond the frame | true |
| index.qmd l.22 | "with 8 or fewer nodes" | max n among in-interval off-frame frames = 8 (cases 12 and 27) | true |
| index.qmd l.22 | "(cases 08, 12, 13, 22, 23 and 27)" | full scan of all 29 cases and all n with the current script | true, complete |
| index.qmd l.128 | "interval [0.05, 5]" | script span (0.05, 5.0); GIF title | true |
| script l.53 | `(0.05, 5.0)` | matches the owner decision and the legacy GIF measurement in the finding | true |

### New problems
None. This rests on: the full in-interval off-frame scan (Case 26 adds no entry); the first, middle and last full-size frames of the new `cheby26.gif` plus the contact sheet of all 10 frames, where titles, nodes, green lines, legend and the pole break at x = 0 are correct and there is no spurious vertical join (the same as the pre-fix GIF, which I fetched through `git lfs smudge`); and the y-window, which is unchanged from the pre-fix GIF ([-12.25, 32.02]), so nothing else in the frame moved.

### Reproducibility and conventions
- I ran a scratch copy of `chebyshev_animations_all.jl`. All 29 GIFs are byte-identical to the page's GIFs, including `cheby26.gif` (sha256 0b58afac…, matching the LFS pointer oid in the diff).
- Conventions are kept: Description comes before Animations, there is one source link, there are 29 embeds (one per case) with descriptive alt text, and there are no code blocks.
- Per the diff, the fix touches only three files, all in the page folder: `cheby26.gif`, `chebyshev_animations_all.jl` and `index.qmd`. Other modified paths in the working tree belong to other pages' fixes this round and are not part of this page's diff.

**Final status:** committed
