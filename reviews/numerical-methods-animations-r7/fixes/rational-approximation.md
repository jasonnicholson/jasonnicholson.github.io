# Fix record: rational-approximation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/rational-approximation/fix/` (`inst.jl`, `zeros.py`, `frames/`).

## Findings

### F1 — Minor — fixed
- Reproduced: the comment at `rationalapproxaa.jl:177` said "the minimax approximant has no interpolation nodes". In fact the minimax R crosses f at five points.
  - `julia inst.jl`: this is an instrumented copy of the script, truncated before plotting. It scans f − R for the script's own `c_mm` on a 200001-point grid and bisects each sign change. The output was `n=5 [-0.9521113094754408, -0.592386592980418, -8.785882548061309e-6, 0.5924006265479047, 0.9521060522159344]`.
  - `/usr/bin/python3 -I zeros.py`: this is an independent mpmath run at 40 digits, using Mathews' printed minimax coefficients. It found `5 ['-0.9521113095', '-0.592386593', '-8.785883315e-6', '0.5924006265', '0.9521060522']` with a max residual of 1.15e-41.
  - Each zero lies between adjacent alternation points from the script's output: −1, ∓0.8123, ∓0.3124, 1. For example, −0.952 lies in (−1, −0.812) and −8.8e-6 lies in (−0.312, 0.312).
  - The zeros are not prescribed in advance. The exchange produces them, because the script passes `Float64[]` as the minimax node list.
- Change: `rationalapproxaa.jl:177`, comment only.
  - Before: `# the minimax approximant has no interpolation nodes`
  - After: `# minimax has no prescribed nodes: its five crossings of f come out of the exchange`
- Check:
  - Regenerated with `julia rationalapproxaa.jl`. The md5 was `4052de20c8b7deda80ca11a78a719169` both before and after, so the GIF is byte-identical.
  - In frame 3 at full size, the lower panel touches zero at about ±0.95, ±0.59 and 0, which is five crossings and agrees with the computed zeros.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `rationalapproxaa.jl:177` comment | "minimax has no prescribed nodes" | The script builds the minimax entry with `Float64[]` nodes, and the Remez exchange sets its reference points. Source lines 117–131 and 154. | yes |
| same | "its five crossings of f" | `julia inst.jl` → n=5 sign changes of f−R on [−1,1]. `python3 -I zeros.py` → 5 roots, residual 1.15e-41 | yes |
| same | "come out of the exchange" | The crossings are not inputs. They result from the equioscillation solve and the exchange, with one zero between each pair of the 6 alternation points (listed above). | yes |

`index.qmd` was not changed.

## Scripts and GIFs
- Script changed: `rationalapproxaa.jl` (comment only).
- GIF regenerated: `rationalapproxaa.gif`. It is byte-identical to the committed file, with md5 `4052de20c8b7deda80ca11a78a719169`.
- Frames: extracted all 3 with giftools and viewed frame 3 at full size. It shows the title "Minimax (Remez)", the legend "max rel err = 8.68e-5", an equal-ripple lower panel and five zero touches.
- `git status --short -- pages/numerical-methods/rational-approximation`: ` M pages/numerical-methods/rational-approximation/rationalapproxaa.jl` only.

## Legacy archive
- Consulted `n2003/rationalapprox/RationalApproxMod/Links/RationalApproxMod_lnk_4.html` (Solution 1(c)). It reads: "The nodes are selected in an iterative process so that the maximum of the absolute value of the relative error is minimum, and the extrema occur at six points in this example."
- This agrees with the new comment, and the six extrema match the script's six alternation points.
- `lnk_7` has the same sentence with "ten points", for the [4/4] example, which is not animated here.

## Notes
- There was no page text to change. The page makes no claim about minimax nodes.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff changes only `rationalapproxaa.jl:177`. The comment now reads `# minimax has no prescribed nodes: its five crossings of f come out of the exchange`. The old false claim ("has no interpolation nodes") is gone.
- I checked the new claim on the script's own minimax coefficients. I ran a scratch copy with an appended check that scans a 200001-point grid for sign changes of (f-R)/f and bisects each one. It finds exactly 5 zeros on [-1,1]: -0.95211131, -0.59238659, -8.7859e-6, 0.59240063, 0.95210605. Each lies strictly between adjacent alternation points (-1, ±0.81230, ±0.31241, 1). The minimum denominator on [-1,1] is 0.58 > 0, so no pole causes a spurious crossing. These crossings are not prescribed: the Remez step solves for equal-ripple at the reference points (`solve_reference`) and imposes no interpolation conditions. "Come out of the exchange" is therefore accurate.
- Frame 3 at full size shows the five zeros of the relative-error curve at these x positions and no node markers. This is consistent with the code and the comment.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| rationalapproxaa.jl:177 comment | "minimax has no prescribed nodes" | Remez reference solve imposes equal-ripple, not interpolation; no node set is passed (`Float64[]`) | correct |
| rationalapproxaa.jl:177 comment | "its five crossings of f" | 5 sign changes of f-R on [-1,1], bisected to full precision, denominator positive | correct |
| rationalapproxaa.jl:177 comment | "come out of the exchange" | zeros interleave the 6 alternation points that the exchange produced | correct |

### New problems
None. This rests on three things. The only change is a single comment line, with no code, page text, or GIF changes. The comment's content was verified numerically. The regenerated GIF is byte-identical to the committed one.

### Reproducibility and conventions
- I ran a scratch copy of `rationalapproxaa.jl` (with a checker block appended after `gif()`). Its output GIF is byte-identical (`cmp`) to the committed `rationalapproxaa.gif`. Printed errors: equal 1.59e-4 (not shown in tail), Chebyshev 8.9419e-5, minimax 8.6798e-5. Alternation points: -1, ±0.8123, ±0.3124, 1. All match the page text.
- index.qmd is unchanged. It still has Description before Animations, a source link and an embed for the single case, descriptive alt text, and no code blocks.
- The fix diff touches only `pages/numerical-methods/rational-approximation/rationalapproxaa.jl`. Nothing outside the page folder is attributed to this fix.

**Final status:** committed
