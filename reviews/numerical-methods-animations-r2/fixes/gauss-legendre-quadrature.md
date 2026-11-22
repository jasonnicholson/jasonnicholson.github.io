# Fix record: gauss-legendre-quadrature

Scratch folder (all evidence scripts and frame extractions):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/gauss-legendre-quadrature/fix/`
(`repro.jl`, `indep.py`, `checknew.jl` + `newfuncs.jl`, `cmp.jl`; frames in `legacy/`, `old/`, `new/`).

## Findings

### F1 — Minor — fixed
- Reproduced: `julia repro.jl` (instrumented copy of the committed computation). Ratio height/f(x_i) of the old midpoint-cell bars: n=2 1.0000 (both bars), n=3 end 0.9067 / interior 1.1476, n=6 0.8433–1.0400, n=18 end 0.8217, n=64 end 0.8190. Sum of old bar areas − I_n ≤ 4.4e-16 for every n. n=6: first bar height 1.6081 while f(x_1)=1.9070 at x_1=0.0675; n=18: last bar 0.8326 while f(x_18)=1.0132. So the finding holds, with one correction to its wording: "about 18% below in *every* frame" is true from roughly n=8 on (ratio 0.833 → 0.819); at n=2 the end bars are exact (ratio 1.000) and at n=3 they are 9.3% low.
- Legacy check: legacy frame 7 (n=6) viewed; bar edges at pixel x 77, 185, 325, 466, 574 → (px−25)/300 = 0.173, 0.533, 1.000, 1.470, 1.830; script's n=6 cumulative weights 0.1713, 0.5321, 1.0000, 1.4679, 1.8287. Legacy bars are width w_i, height f(x_i), red dot at (x_i, f(x_i)) (also seen in legacy frame 24, n=40). R2-A says follow Mathews for the Gauss-Legendre bars.
- Change: `gausslegendreaa.jl` `weighted_rectangles` now uses `bounds = a .+ [0.0; cumsum(weights)]`, `widths = copy(weights)`, `heights = f.(xnodes)` (was midpoint cells with height w_i f(x_i)/width_i). Added a red dot (scatter, markersize 3) at each (x_i, f(x_i)), drawn after the curve so it is visible. The existing node lines from 0 to f(x_i) are kept. Header comment gains "(bar i has width w_i and height f(x_i), so its area is w_i f(x_i))". `index.qmd`: Behavior first sentence and alt text describe the new bars.
- Check: `julia checknew.jl` (runs the edited script's own functions): heights == f(x_i) exactly, every node strictly inside its own cell, first edge = 0, for all 21 n: `true`; max |Σ area − I_n| = 0.0; max |last edge − 2| = 8.9e-16; max bar height 1.920 < ylim 2.1. Independent: `/usr/bin/python3 -I indep.py` with numpy `leggauss`: all 21 n separated (`all separated: True`, smallest margin 6.95e-4 at n=64). Frames 4 (n=2), 8 (n=6), 14 (n=18), 24 (n=64) viewed at full size: bar tops meet the curve at the red dots; n=6 edges visually at ≈0.17, 0.53, 1.0, 1.47, 1.83 like the legacy.

### F2 — Minor — fixed
- Reproduced: `julia repro.jl`: n=18 approx = 2.0164003524379037, `round(...; digits=6)` displays `2.0164`; true_int = 2.0162797061281728 displays `2.01628`. All other n display 6 decimals.
- Change: `gausslegendreaa.jl` adds `using Printf`; `"Approximation = $(round(approx; digits=6))"` → `@sprintf("Approximation = %.6f", approx)`; `"I = $(round(true_int; digits=6))"` → `@sprintf("I = %.6f", true_int)`.
- Check: `repro.jl` prints the `%.6f` strings for all 21 n (n=18 → 2.016400, others unchanged from the old display); numpy `leggauss` gives the same 6-decimal values for all 21 n (`indep.py`). New frame 14 reads "Approximation = 2.016400", frame 2 reads "I = 2.016280" (viewed).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Animations intro | "reference value $I\approx2.016280$" (was 2.01628, same value, now matches frame 2) | `repro.jl` → true_int 2.0162797061, `%.6f` = 2.016280; mpmath (x=u³) in `indep.py` → 2.0162797196 → 2.016280; new frame 2 viewed: "I = 2.016280" | yes |
| index.qmd Behavior | "Each shaded bar has width $w_i$ and height $f(x_i)$" | `checknew.jl` → widths = weights, heights == f.(x) exactly; on [0,2], (b−a)/2 = 1 so the [0,2] weights equal the Description's $w_i$ | yes |
| index.qmd Behavior | "marked by a red dot at the node $x_i$" | script scatter at (x_i, f(x_i)); frames 4, 8, 14, 24 viewed: dot on each bar's top edge | yes |
| index.qmd Behavior | "so its area is the term $w_i f(x_i)$ of the sum" | width × height = w_i f(x_i) by construction; `checknew.jl` → max |Σ area − I_n| = 0.0 | yes |
| index.qmd Behavior | "The bars are laid end to end across $[0,2]$" | `checknew.jl` → first edge = 0 exactly; max |last edge − 2| = 8.9e-16 (Σw_i = b−a) | yes |
| index.qmd Behavior | "each node lies inside its own bar" | `checknew.jl` → bd[i] < x_i < bd[i+1] for all i, all 21 n: true; `indep.py` (numpy) → `all separated: True` | yes |
| index.qmd alt text | "bars of width w_i and height f(x_i), with a red dot at each node, are recomputed …" | as the three Behavior rows above; rest of alt text unchanged | yes |
| gausslegendreaa.jl line 3 comment | "(bar i has width w_i and height f(x_i), so its area is w_i f(x_i))" | as above | yes |
| GIF label | "Approximation = %.6f" | `repro.jl` table of all 21 n; frames 4/8/14/24 read 1.154628 / 2.019465 / 2.016400 / 2.016282, matching | yes |
| GIF label | "I = %.6f" → 2.016280 | as row 1 | yes |

## Scripts and GIFs
- Script changed: `pages/numerical-methods/gauss-legendre-quadrature/gausslegendreaa.jl`. Regenerated in place: `gausslegendreaa.gif` (24 frames, as before).
- Frames viewed at full size: 2 (intro, "I = 2.016280"), 4 (n=2), 8 (n=6), 14 (n=18, "2.016400"), 24 (n=64). Checked: bars of width w_i ending on the curve at red dots, node lines inside their bars, labels with 6 decimals and right n, nothing clipped (max height 1.920 < 2.1).
- Intro frames 1 and 3 are not byte-identical to the committed ones (`cmp.jl`: max channel difference 42 on 8780 bytes). This is GIF palette quantization: the palette is built over the whole animation, and the new red dots change it. The content is the same curve and text. This is a single-case script, so no other cases are involved.
- `git status --short -- pages/numerical-methods/gauss-legendre-quadrature` after regeneration: `M gausslegendreaa.gif`, `M gausslegendreaa.jl`, `M index.qmd`. No other files.

## Legacy archive
Consulted. `a2001/Animations/Quadrature/GaussLegendre/GaussLegendreaa.gif` (24 frames) and `n2003/gaussianquad/GaussianQuadMod/Links/GaussianQuadMod_lnk_8.html` (Example 6 / Animation 1: Gauss-Legendre quadrature for the same integrand on [0,2]). The legacy bars have width w_i (cumulative-weight edges, checked at n=6 above), height f(x_i), and a red dot at each sample, with no vertical node lines. The fixed page follows that, and keeps its own node lines and its n sequence 2…64 (legacy uses 2, 4, …, 40). Legacy frame 24 (n=40) prints 2.016288, while the script computes 2.016288522 (`repro.jl`), which rounds to 2.016289 (numpy agrees). The legacy value looks truncated, and the page keeps the correctly rounded value.

## Notes
- F1's quantifier "in every frame" was slightly too strong: it does not hold at n=2 (ratio 1.000) or at n=3 (0.907). This does not change the fix.
- Pre-existing, not a finding and not touched: the small top-left label "Y = exp(-x) …" overlaps the y-tick "2.0" in every frame (it is also in the committed GIF).
- An independent resolution check was not run by this fixer. That is the director's step.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Script: `weighted_rectangles` now uses `bounds = a .+ [0; cumsum(weights)]`, `widths = weights`, `heights = f.(xnodes)`. The script adds a red dot (`scatter!`) at each $(x_i, f(x_i))$. The header comment now reads "(bar i has width w_i and height f(x_i), so its area is w_i f(x_i))", which is true, so the "legacy-style" claim is now accurate.
- Independent computation (`check/num.py`, numpy `leggauss` mapped to [0,2], where (b-a)/2 = 1 so the scaled and unscaled weights are the same):
  - For every n in `n_seq`, each node lies strictly inside its cumulative-weight cell, `allsep True`.
  - The last bound is 2 to within 1e-15 for every n, so the bars tile [0,2] exactly.
  - Bar heights are f(x_i) by construction, so height/f(x_i) = 1 everywhere. The 18% end-bar deficit is gone.
- Frames, viewed at full size:
  - Frame 4 (n=2): the bars are [0,1] and [1,2], each with a dot on its top edge at the curve.
  - Frame 8 (n=6): the bar edges sit at about 0.17, 0.53, 1.00, 1.47 and 1.83, which match the cumulative weights 0.171, 0.532, 1.000, 1.468 and 1.829 and the legacy pixel measurements given in the finding. Every dot sits on the curve and on its bar's top edge. The first bar now reaches 1.91 = f(0.0675).
  - Frame 14 (n=18): the last bar's top meets the curve at about 1.01.
  - Frame 24 (n=64): all dots lie on the curve.
- Page text: the Behavior paragraph and the alt text now describe width $w_i$, height $f(x_i)$ and the red dot. Both statements are true (see ledger).

### F2 — resolved
- The script now uses `@sprintf("Approximation = %.6f", approx)` and `@sprintf("I = %.6f", true_int)`.
- Frame 14 shows "Approximation = 2.016400". This matches the independent value 2.0164003524 at n=18.
- Frame 2 shows "I = 2.016280". The mpmath reference, computed with the substitution x = u^3 to remove the singularity, is I = 2.0162797196.
- On the contact sheet, every n-frame shows 6 decimals: 2.332149, 2.014623, 2.017912, 2.016729, 2.016457, 2.016365, 2.016308, 2.016292, 2.016286 and 2.016283. Each agrees with `num.py` to 6 decimals.
- The page's intro sentence was also changed from 2.01628 to 2.016280, so it is consistent with the frame.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| .jl line 3 comment | bar i has width w_i, height f(x_i), area w_i f(x_i) | The code matches the comment, and the bars sum to I_n. | true |
| .jl `weighted_rectangles` comment | each node x_i lies inside its own cell | `num.py`: strict separation for all 21 n | true |
| .jl dot comment | red dot at (x_i, f(x_i)) on the top edge | `scatter!` at `f.(sample_x)`, which equals the bar height. Seen in frames 4, 8, 14 and 24. | true |
| index.qmd Animations intro | I ≈ 2.016280 | mpmath 2.01627972 | true |
| Behavior | bar width w_i, height f(x_i), red dot at node x_i, area = term w_i f(x_i) | Code and frames. On [0,2] the scaled weights equal the [-1,1] weights in the Description, so the notation is consistent. | true |
| Behavior | bars laid end to end across [0,2] | Σw_i = 2 (last bound is 2 ± 1e-15 for all n) | true |
| Behavior | each node lies inside its own bar | `allsep True` for all n in n_seq | true |
| Behavior (same changed line) | estimate settles toward I ≈ 2.016280; decreases in every frame from n=6 on | `num.py` I_n sequence: 2.019465, 2.017912, …, 2.016282, strictly decreasing from n=6 | true |
| Behavior | n=64 gives 2.016282, about 1.9e-6 high | err = 1.864e-6 | true |
| Behavior | f'(x) ≈ (16/3) x^{-1/3} near 0 | d/dx of e^{-x} sin(8x^{2/3}) → (16/3) x^{-1/3} cos(·) e^{-x}, which tends to (16/3) x^{-1/3} as x → 0 | true |
| Behavior | error ratio 32→64 ≈ 9.8; tends to 2^{10/3} ≈ 10.08 | 9.841. 2^{10/3} = 10.079. The ratio from 16 to 32 is 9.65, so it is rising toward 10.08. | true |
| Behavior | smooth integrand error 4e-17 at n=16 | 50-digit mpmath Golub–Welsch rule vs the closed form: 4.17e-17 | true |
| Alt text | bars of width w_i and height f(x_i), red dot at each node, n 2→64, settles toward 2.016280, 2.016282 at 64 | as above, and seen in the frames | true |
| Frame 2 label | I = 2.016280 | mpmath | true |
| Frame labels | Approximation = %.6f for each n | `num.py` | true |

### New problems
None. This rests on the following checks:
- I viewed frames 2, 4, 8, 14 and 24 at full size, plus the contact sheet covering every second frame.
- I decoded the old and new intro frames 1 and 3. They differ only by palette requantisation: max channel difference 42, and only 2 pixels differ by more than 30.
- Frame 2 also differs where the label changed.
- All drawn elements are built from w_i, x_i and f(x_i).
- No label is clipped by the change.
- The "Y = exp(-x)…" label touching the y-axis at top left is unchanged from HEAD, so it is not new.
- At n=56 and n=64 the bar outlines are dense, but they were dense before as well.

### Reproducibility and conventions
- I ran a scratch copy of `gausslegendreaa.jl` with plain `julia`. The output GIF is byte-identical to the committed `gausslegendreaa.gif` (`cmp`). The committed file is real GIF data (630x480, 24 frames), not an LFS pointer.
- index.qmd conventions all hold:
  - Description comes before Animations.
  - It has one case, with a `[Julia source]` link and a GIF embed.
  - The alt text is descriptive.
  - It has no code blocks (no backtick fences).
- The page diff touches only its own folder: the .gif, .jl and index.qmd. Other modified files in the working tree belong to other pages' parallel fixes and to the untracked fix records under `reviews/numerical-methods-animations-r2/fixes/`. Nothing outside `pages/numerical-methods/` is modified apart from those untracked records. I cannot attribute any other-page change to this fixer.
- The fix follows R2-A ("Gauss-Legendre bars": follow Mathews), and it is mathematically correct.

**Final status:** committed
