# Fix record: rational-approximation

Scratch folder with all evidence scripts and frame extractions:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/rational-approximation/fix/`

- `orig_instr.jl` and `orig_stall.jl` are the round-1 reviewer's instrumented copies of the original script (plotting removed). Their output is in `orig_instr.out`.
- `remez_mp.py` is the reviewer's independent mpmath Remez (40 digits), with output in `remez_mp.out`. Run it with `/usr/bin/python3 -I`.
- `lp_check.py` is my own independent check: scipy `linprog` feasibility with bisection on E over a 4001-point grid.
- `new_instr.jl` is the fixed script's computation copied verbatim (plotting removed) plus diagnostics. Its output is in `new_instr.out`.
- `committed/` and `new/` hold the frames of the old and new GIFs. `trial/` holds a scratch run of the fixed script.

## Findings

### F1 — Misleading — fixed
- Reproduced: `julia orig_instr.jl` gives a max relative error of 8.845862e-5 for the coordinate search result, with signed extrema −8.8459, +8.8459, −8.4411, +8.4410, −8.8456 and +8.8437 (×1e-5) at x = −1, −0.810, −0.310, 0.310, 0.810 and 1. These are not equal, so there is no equioscillation. The search leaves a0 = 1.0 and b1 = −0.49978937588751265 unchanged from the Chebyshev interpolant. `julia orig_stall.jl` prints `search ended: iters=65 max step=8.17e-9`, and evaluating the true minimax coefficients on the script's own grid gives 8.679786398678114e-5. Three independent sources agree on the true minimax:
  - `python3 -I remez_mp.py` converges in 4 iterations to a levelled E = 8.67978639861e-5, at reference points −1, ±0.8123042914, ±0.3124145944 and 1.
  - `python3 -I lp_check.py` gives E* = 8.6776e-5, which agrees to 3 significant figures. The small gap comes from the LP solver's absolute feasibility tolerance of about 1e-7.
  - The Mathews archive's Mathematica `MiniMaxApproximation` coefficients agree with the mpmath ones to 15 digits (see Legacy archive).
  The checker's correction holds: the search result is narrowly flatter than the Chebyshev interpolant (8.846e-5 against 8.942e-5), but it is not the minimax approximant.
- Change: in `rationalapproxaa.jl`, `minmax_search` (the coordinate search) is replaced by a Remez exchange for relative error, made of three functions:
  - `solve_reference` uses Newton's method to solve P(x_i) = f(x_i)(1 − s_i E) Q(x_i) at 6 reference points.
  - `error_extrema` finds the largest |error| on each sign interval of a 20001-point grid and refines it by golden-section search.
  - `remez_minimax` starts from the Chebyshev extrema cos(kπ/5) and stops when the ripple spread is below 1e-10·max.

  Other script changes:
  - The call is now `c_mm, E_mm, xr_mm = remez_minimax(...)`, and the script prints E and the alternation points.
  - Frame 3 title: "MinMax relative-error search" → "Minimax (Remez)".
  - Header comment: (3) "MinMax-style relative-error optimization" → "the minimax relative-error approximant, computed by Remez exchange".

  Changes in index.qmd:
  - :18 "reduce the maximum relative error" → "minimize …".
  - :26 item (3) now reads "the minimax (MinMax) approximant, which minimizes the maximum relative error and is computed here by the Remez exchange algorithm".
  - The Behavior paragraph and the alt text were rewritten (see Ledger).
- Check: the script prints Remez iterations 1, 2 and 3 with |E| = 8.67786e-5, 8.6797864e-5 and 8.679786398606e-5, and ripple spreads of 3.5e-8, 7.5e-14 and 7.1e-16. The alternation points are [−1, −0.81230427, −0.31241468, 0.31241432, 0.81230432, 1]. The coefficients are a = (0.9999999962330653, 0.49978562382661, 0.08159269632523836) and b = (−0.499785625709263, 0.08159269663258942), which match mpmath and Mathematica to 12 or more digits. `new_instr.jl` on a 200001-point grid gives a max |e| of 8.679786e-05 and signed extrema −8.6798, +8.6798, −8.6798, +8.6798, −8.6798, +8.6798 (×1e-5) at x = −1, −0.8123, −0.31241, 0.31241, 0.8123 and 1. The denominator minimum is 0.581807, so Q > 0 on the interval. The new frame 3 legend reads "max rel err = 8.68e-5".

### F2 — Misleading — fixed
- Reproduced: committed frame 3 (`committed/frame_003.png`) shows the error curve flat on the axis of a 0 to 0.010 panel. The largest errors are 1.59e-4, 8.94e-5 and 8.85e-5 (`orig_instr.out`), which is at most 1.6% of the panel height.
- Change: `rationalapproxaa.jl` lower panel `ylims=(0.0, 0.01)` → `ylims=(0.0, 2.0e-4)`.
- Check: the curves now fill 0.797 (equal nodes), 0.447 (Chebyshev) and 0.434 (minimax) of the panel height (`new_instr.out`, "panel fill"). Full-size new frames:
  - `new/frame_001.png`: the equal-node humps are about 1.6e-4 near ±0.82 and about 6e-5 near ±0.27, with zeros at the nodes −1, −0.5, 0, 0.5 and 1.
  - `new/frame_002.png`: the Chebyshev humps are unequal (endpoints at about 8.9e-5, interior at about 8.5e-5), with zeros at the 5 nodes.
  - `new/frame_003.png`: six equal extrema at about 8.7e-5 (both endpoints and four interior humps).
  Nothing is clipped, because the largest value, 1.594e-4, is below 2e-4.

### F3 — Minor — fixed
- Reproduced: `orig_instr.out` gives `mm rel err at plotted nodes: [9.30e-7, 6.25e-7, 0.0, 6.10e-7, 9.35e-7]`, so the search result does not interpolate at the Chebyshev nodes that frame 3 marks as "nodes" (`committed/frame_003.png` shows the red markers and the "nodes" legend entry). With the true minimax approximant, the Remez result is not built from nodes either.
- Change: in `rationalapproxaa.jl`, the minimax case passes empty node arrays (`Float64[], Float64[]`), and the `scatter!` of nodes is wrapped in `if !isempty(xn)`, with the comment "the minimax approximant has no interpolation nodes". This is the smaller of the two options in the finding: the alternation points were not added as new plot elements.
- Check: `new/frame_003.png` has no markers and no "nodes" legend entry. Frames 1 and 2 still show their 5 nodes. The node relative errors there are ≤1.83e-16 (equal nodes) and ≤1.72e-16 (Chebyshev) (`new_instr.out`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:18 | "the goal is to **minimize** the maximum relative error" | Remez result equioscillates at 6 = 2+2+2 points (`new_instr.out`); LP bisection over all coefficients gives the same level to 3 s.f. (`lp_check.py` → 8.6776e-5) | yes |
| index.qmd:18 (kept) | "MiniMax (MinMax) construction that spreads error more uniformly" | minimax extrema all ±8.6798e-5 vs Chebyshev 8.47–8.94e-5, equal nodes 6.0e-5–1.59e-4 (`new_instr.out`, `orig_instr.out`) | yes |
| index.qmd:26 | "(3) the minimax (MinMax) approximant, which minimizes the maximum relative error and is computed here by the Remez exchange algorithm" | script now calls `remez_minimax`; converges in 3 iterations (script stdout) | yes |
| index.qmd Behavior | "both exact at their nodes" (kept) | `new_instr.out` → node rel errors ≤1.83e-16 (eq), ≤1.72e-16 (ch) | yes |
| index.qmd Behavior | about 1.59×10⁻⁴ for equal nodes | `new_instr.out` → 1.593661e-04 (200001 grid); script 1201-grid 1.59365e-4; mpmath `remez_mp.out` 1.593661223e-4 | yes |
| index.qmd Behavior | largest near x ≈ ±0.82 | `orig_instr.out` (same coefficients, unchanged code) → extrema +1.5934e-4 at −0.82443, −1.5937e-4 at +0.82443; next largest 6.0e-5 at ±0.27286 | yes |
| index.qmd Behavior | 8.94×10⁻⁵ for Chebyshev nodes | `new_instr.out` → 8.941921e-05; mpmath 8.94192115e-5 | yes |
| index.qmd Behavior | minimax has the smallest possible maximum relative error for this form, 8.68×10⁻⁵ | script E = 8.679786398606e-5; mpmath Remez 8.67978639861e-5; LP 8.6776e-5; equioscillation at 6 points (alternation theorem) | yes |
| index.qmd Behavior | about 3% below the Chebyshev value | `python3 -c` → 1 − 8.6797864e-5/8.9419212e-5 = 0.0293 | yes |
| index.qmd Behavior | error reaches this level with alternating sign at six points | `new_instr.out` → signed extrema −,+,−,+,−,+ all 8.6798e-5 | yes |
| index.qmd Behavior | x = −1, ±0.812, ±0.312, 1 | script → −0.81230427, −0.31241468, 0.31241432, 0.81230432; mpmath ±0.8123042914, ±0.3124145944 | yes |
| index.qmd Behavior | "relative-error curve in the last frame is equal-ripple" | `new/frame_003.png` viewed: six equal extrema at ≈8.7e-5 | yes |
| index.qmd alt | "max relative error 1.59e-4", "(8.94e-5)", "(8.68e-5, equal-ripple error)" | as above; frame legends read 0.0001594, 8.94e-5, 8.68e-5 (`new_instr.out` "legend values"; frames viewed) | yes |
| index.qmd alt | "minimax approximant from Remez exchange", "in three frames" | script; `giftools.jl` → "3 frames" | yes |
| rationalapproxaa.jl header | "(3) the minimax relative-error approximant, computed by Remez exchange." | script code | yes |
| rationalapproxaa.jl frame 3 title | "Rational [2/2] for exp(x) on [-1,1] — Minimax (Remez)" | `new/frame_003.png`: fits inside frame | yes |
| rationalapproxaa.jl frame 3 legend | "R(x), max rel err = 8.68e-5" (computed, not typed) | `round(8.6798e-5; digits=7)` = 8.68e-5 (`new_instr.out`) | yes |
| rationalapproxaa.jl comments | "s_i = (-1)^i" | loop uses `s = iseven(i) ? 1 : -1` for i = 1..6 → (−1)^i | yes |
| rationalapproxaa.jl comment | "the minimax approximant has no interpolation nodes" | definition (Remez; no node constraints in `solve_reference`) | yes |

## Scripts and GIFs
- Script changed: `rationalapproxaa.jl` (Remez exchange replaces the coordinate search; the error-panel ylims are now 0 to 2e-4; the minimax frame has no node markers; the frame 3 title and header comment were updated; the script prints E and the alternation points).
- GIF regenerated: `rationalapproxaa.gif`, 3 frames. A second run in `trial/` gave a byte-identical GIF (md5 4052de20c8b7deda80ca11a78a719169), so the output is deterministic.
- Frames viewed at full size: `new/frame_001.png`, `frame_002.png` and `frame_003.png`. I checked:
  - the curves are built from the coefficients the script prints;
  - the legends read 0.0001594, 8.94e-5 and 8.68e-5;
  - frames 1 and 2 show their nodes at −1, −0.5, 0, 0.5, 1 and ±0.951, ±0.588, 0, and frame 3 shows no nodes;
  - the lower panel shows each profile with nothing clipped;
  - the frame 3 title fits.
- `git status --short -- pages/numerical-methods/rational-approximation` after regeneration shows:
  ```
   M pages/numerical-methods/rational-approximation/index.qmd
   M pages/numerical-methods/rational-approximation/rationalapproxaa.gif
   M pages/numerical-methods/rational-approximation/rationalapproxaa.jl
  ```

## Legacy archive
I consulted `RationalApproxMod.html` and its `Links/RationalApproxMod_lnk_2/3/4.html`:
- Example 1 is the [2/2] rational approximation of e^x on [−1,1], in three parts: (a) equally spaced nodes, (b) Chebyshev nodes, (c) Mathematica's `MiniMaxApproximation` (image `gr_88`: `MiniMaxApproximation[f[x], {x, {-1, 1}, n, m}]` with n = m = 2).
- `gr_89` gives u(x) = (0.999999996233065 + 0.4997856238266049x + 0.08159269632523609x²)/(1 − 0.4997856257092684x + 0.08159269663259221x²). This matches the fixed script's coefficients to 12 or more digits.
- `gr_111` plots 1 − u/f, which equioscillates at about ±8.7e-5 and starts negative at x = −1, as the fixed script's signed error does.
- Mathews' text says the error "extrema occur at six points in this example", which agrees with the 6 alternation points computed here.

So the fixed animation now matches what Example 1(c) was meant to show. One difference: Mathews used Mathematica's built-in procedure, while the script uses its own Remez exchange (no new package dependency). Both give the same approximant. The Chebyshev-nodes solution (lnk_3) references images that are not in the archive (`gr_51`, `gr_63` missing), so I could not compare part (b) visually. The script's Chebyshev nodes cos((2k−1)π/10) are the standard first-kind nodes, and the review confirmed the interpolant against mpmath.

## Notes
- D7 does not decide this case, because the round-1 finding says the animation itself misleads: frame 3 presented a non-converged search as the MinMax approximant. So the script was fixed and the text was made to match it.
- The node-detection helper `error_extrema` assumes the error has no exact zeros on the grid. This holds for the minimax iterates (the error at x = 0 is 1 − a0 ≈ 3.8e-9), and the script raises an error if it does not find exactly 6 alternation points. It is not used for the interpolants.
- The legend format `round(max_rel; digits=7)` was left as it is. It shows 0.0001594, 8.94e-5 and 8.68e-5, all of which are correct at the precision shown.
- The heading "Case 1 — … equal nodes, Chebyshev nodes, and MinMax" was kept, and it is consistent with the new frame 3.
- Nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The coordinate search (`minmax_search`) is gone. In its place is a Remez exchange for relative error: Newton solve of P(x_i) = f(x_i)(1 − s_i E) Q(x_i) at 6 reference points, then exchange to the extrema of each sign segment, started from the Chebyshev extrema. The frame title is now "Minimax (Remez)".
- Scratch run output: Remez converges in 3 iterations to E = 8.679786398606e-5 at x = [−1, −0.8123043, −0.3124147, 0.3124143, 0.8123043, 1]. The max over the script's 1201-point grid is 8.679786398623e-5.
- Independent check (`check/myremez.py`, mpmath at 40 digits; my own reference solve uses a linear 5×5 solve plus a root-find in E, not the script's Newton): E* = 8.67978639861e-5. Coefficients a = (0.999999996233, 0.499785623827, 0.0815926963252), b = (−0.499785625709, 0.0815926966326). Signed errors at the alternation points: −, +, −, +, −, + all at 8.6797864e-5, at x = −1, ±0.81230429, ±0.31241459, 1. The max over a 4001-point grid equals E* to 12 digits. Six alternation points = m+n+2 with Q > 0 (min Q = 0.582), so by the alternation theorem this is the unique best approximation. The script's result matches it.
- The page no longer presents a non-converged search as the minimax: Description now says "minimize", and the Animations and Behavior text names the minimax approximant and Remez.

### F2 — resolved
- `ylims=(0.0, 2.0e-4)`. In frame 1 the equal-node peaks of 1.59e-4 near ±0.82 sit at about 80% of the panel height, and the 6.0e-5 inner ripples are visible. Frame 2 shows unequal Chebyshev ripples (8.94e-5 at the ends, 8.76e-5 and 8.47e-5 inside). Frame 3 shows six equal peaks at 8.68e-5. The three panels are now clearly different, as the page says.

### F3 — resolved
- Frame 3 passes empty node arrays, and `scatter!` is skipped when `xn` is empty, so frame 3 has no "nodes" markers and no "nodes" legend entry (checked at full size). Frames 1 and 2 still show their true interpolation nodes.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:18 | "the goal is to minimize the maximum relative error" | Definition of minimax | correct |
| index.qmd:26 | "(3) the minimax (MinMax) approximant, which minimizes the maximum relative error and is computed here by the Remez exchange algorithm" | Script code is a Remez exchange; result = independent E* | correct |
| index.qmd:32 | "exact at their nodes" | Interpolation; zeros of error at nodes in frames 1–2 | correct |
| index.qmd:32 | equal nodes "about 1.59×10⁻⁴" | mpmath 1.59366e-4; script 1.5936e-4 | correct |
| index.qmd:32 | "largest near x ≈ ±0.82" | Extrema at ±0.8244 | correct |
| index.qmd:32 | Chebyshev "8.94×10⁻⁵" | mpmath 8.94192e-5 | correct |
| index.qmd:32 | minimax "smallest possible … 8.68×10⁻⁵" | E* = 8.67979e-5; uniqueness and optimality from 6-point alternation | correct |
| index.qmd:32 | "about 3% below the Chebyshev value" | (8.94192−8.67979)/8.94192 = 2.93% | correct |
| index.qmd:32 | "alternating sign at six points (x = −1, ±0.812, ±0.312, 1)" | Signed errors −,+,−,+,−,+ at −1, ±0.81230, ±0.31241, 1 | correct |
| index.qmd:32 | "relative-error curve in the last frame is equal-ripple" | Frame 3: six equal |e| peaks at 8.68e-5 | correct (the panel plots |e|, so the sign alternation is stated in the text rather than shown; the text says nothing false about the plot) |
| index.qmd:36 alt | 1.59e-4, 8.94e-5, 8.68e-5, "equal-ripple", "three frames", "function and relative-error panels" | As above; GIF has 3 frames with 2 panels each | correct |
| jl:6 comment | "minimax relative-error approximant, computed by Remez exchange" | Code | correct |
| jl:57-58 comments | Reference equations, s_i = (−1)^i, "bilinear in b and E" | Matches F/J in code (Jacobian columns verified by hand: ∂/∂b1 = −w x, ∂/∂b2 = −w x², ∂/∂E = y s Q) | correct |
| jl:84-85 comments | "extremum of |relative error| on each interval of constant sign … golden-section" | Code | correct |
| jl:153 title | "Minimax (Remez)" | Frame 3 title | correct |
| jl:176 legend (frame 3) | "max rel err = 8.68e-5" | E* | correct |
| jl:177 comment | "the minimax approximant has no interpolation nodes" | It crosses f at 5 points, but they are not prescribed nodes | acceptable |
| jl:181 | ylims (0, 2e-4) | Fits 1.594e-4 | correct |

### New problems
None. This rests on: independent high-precision Remez agreeing with the script to 10+ digits; the alternation-theorem optimality check; full-size inspection of all 3 frames (titles, legends, ylim, absence of nodes in frame 3; frames 1 and 2 unchanged in content apart from the y-range); and re-checking every changed number. Remark, not a problem: the alternation points the script prints are symmetric only to about 4e-7 (−0.3124147 vs 0.3124143) because the golden-section search refines within one coarse grid cell. This has no effect on E (the ripple spread is 7e-16) or on the plot.

### Reproducibility and conventions
- Ran a scratch copy of `rationalapproxaa.jl` (11 s): its output GIF has sha256 9260bb11…14f6a, identical to the committed GIF and to the LFS oid in the diff. The decoded frame md5s also match (3 frames).
- Conventions: Description comes before Animations, there is one source link and one embed for the single case, the alt text is descriptive with the key numbers, there are no code blocks, and the section index (pages/numerical-methods/index.qmd:66) still links the page.
- The fix diff touches only the three files in the page folder. The working tree has many other modified files under pages/numerical-methods/ belonging to other pages on this branch. None of them are part of this page's diff.

**Final status:** committed
