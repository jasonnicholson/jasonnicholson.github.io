# Rational Approximation — animation review

Page: [`pages/numerical-methods/rational-approximation/index.qmd`](../../pages/numerical-methods/rational-approximation/index.qmd) · Scripts: `rationalapproxaa.jl` · GIFs: 1

**Result:** 0 error, 2 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Implementation — The "MinMax" approximant is not the minimax approximant; the search stalls at 8.846e-5 while the true minimax relative error is 8.680e-5

- **Location:** `rationalapproxaa.jl:55-84` (`minmax_search`), `:100` (call), `:105` (label "MinMax relative-error search"). Shown in frame 3 (title "… — MinMax relative-error search", legend "max rel err = 8.85e-5"). Page `index.qmd:18` ("a MiniMax (MinMax) construction"), `:26`, `:30`, `:32-33`.
- **Now:** The coordinate search starts from the Chebyshev interpolant and moves one coefficient at a time. It stops after 65 sweeps because the step falls below 1e-8 (not because of the iteration cap). It is stuck at a kink of the nonsmooth max-objective. Two coefficients never move at all: a0 = 1.0 and b1 = −0.49978937588751265 are identical to the Chebyshev values. The result has max relative error 8.8459e-5, with signed extrema −8.846, +8.846, −8.441, +8.441, −8.846, +8.844 (×1e-5) at x = −1, −0.810, −0.310, 0.310, 0.810, 1. Because the ripples are unequal, there is no equioscillation.
- **True:** The relative-error minimax [2/2] approximant of e^x on [−1,1] equioscillates at 6 points (−1, ±0.81230, ±0.31241, 1), all at level 8.67979e-5. Its coefficients are a = (0.999999996, 0.499785624, 0.081592696), b = (−0.499785626, 0.081592697). The script's result is 1.9% above the optimum. It recovers only about 28% of the possible improvement over the Chebyshev interpolant (8.942e-5 → 8.846e-5, where 8.680e-5 is attainable).
- **Evidence:** `julia instr.jl` gives the extrema above. `julia stall.jl` prints `search ended: iters=65 max step=8.17e-9` and, when the Remez coefficients are evaluated on the script's own 1201-point grid, `8.679786398678114e-5`. `python3 remez.py` converges in 4 exchanges to `levelled E = 8.67978639861e-5`, and the max over a 4001-point grid equals E to 12 digits.
- **Suggested fix:** Replace the coordinate search with a Remez exchange for relative error. At 6 reference points, solve P(x_i) = f(x_i)(1 − (−1)^i E) Q(x_i) for (a0,a1,a2,b1,b2,E), move the reference to the extrema of the error, and repeat; starting from the Chebyshev extrema, it converges in about 4 iterations. Alternatively, solve the minimax problem as a linear program for fixed E with bisection on E. Then the third frame will show an equal-ripple error curve at 8.68e-5. If the crude search is kept, the frame title and page should say it is an approximate, non-converged search and should not report its result as the MinMax error.

- **Independent check:** confirmed with correction. Severity changed from Error to Misleading. Checker (own mpmath Remez): true minimax E*=8.680e-5; the script's step reaches 8.846e-5 with unequal peaks (8.85 vs 8.44 ×1e-5). Correction: it is still slightly flatter than the Chebyshev-node approximant (8.94e-5), so the page's 'flatter, more uniform' is narrowly true; the problem is presenting it as the minimax approximant. Downgraded from Error to Misleading by the director on that basis.

### F2 — Misleading — Implementation (picture) — Relative-error panel's y-range (0 to 0.01) is about 60–115× the errors, so the error profiles the page discusses are invisible

- **Location:** `rationalapproxaa.jl:130` (`ylims=(0.0, 0.01)`). The lower panel in all 3 frames.
- **Now:** The relative errors are at most 1.59e-4 (frame 1) and 8.9e-5 (frames 2 and 3), so the purple curve fills at most 1.6% of the panel height and looks like a flat line on the axis in every frame (checked in frames 1 and 3 at full size). The page's Behavior paragraph (`index.qmd:32-33`) says the frames show the max error "can differ significantly" and that MinMax produces "a flatter, more uniform relative-error profile". A viewer can see neither: the three error panels look the same.
- **True:** The profiles do differ. Equal nodes give ripples of 1.59e-4 near ±0.82 and 6.0e-5 near ±0.27. Chebyshev gives 8.47–8.94e-5. True minimax gives a level 8.68e-5.
- **Evidence:** `instr.out` (extrema listed under F1). Frames `committed/rationalapproxaa/frame_001.png` and `frame_003.png`.
- **Suggested fix:** Use `ylims=(0, 2e-4)` (or 1.7e-4) for all frames, so the 1.59e-4 equal-node curve fits and the Chebyshev and minimax ripples are visible at about half height. Optionally plot the signed error with a horizontal reference line at ±E to make the equioscillation visible.

- **Independent check:** confirmed.

### F3 — Minor — Implementation (picture) — Frame 3 marks the Chebyshev nodes as "nodes" although the MinMax approximant does not interpolate there

- **Location:** `rationalapproxaa.jl:105` (passes `xs_ch, ys_ch` for the MinMax case) and `:128` (`scatter!(… label="nodes")`).
- **Now:** Frame 3 shows red "nodes" at the 5 Chebyshev nodes, which implies the MinMax curve interpolates there. The script's search result misses f at those points by relative errors of 6–9e-7. A minimax approximant has no prescribed nodes; it crosses f at its own 5 error zeros, which lie between the alternation points.
- **True:** The marked points are carried over from frame 2 and are not data for this construction. The mismatch is invisible at this scale, so the consequence is small, but the label is wrong.
- **Evidence:** `instr.out`: `mm rel err at plotted nodes: [9.30e-7, 6.25e-7, 0.0, 6.10e-7, 9.35e-7]`.
- **Suggested fix:** In frame 3, either omit the node markers or plot the approximant's zero-error crossings (or the alternation points) under a correct label, such as "equioscillation points".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `rationalapproxaa.jl` | yes | 3.0 | rationalapproxaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 14-16 | "R_{m,n}(x)=P_m(x)/Q_n(x), Q_n(x)≠0" | Script uses (a0+a1x+a2x²)/(1+b1x+b2x²) (l.14-22); the denominator is positive on [−1,1] for all three (min 0.5818) | confirmed |
| 2 | 18 | three constructions: "interpolation with equally spaced nodes, interpolation with Chebyshev nodes, and a MiniMax (MinMax) construction" | The code has these three (l.88-100), but the third is not a converged minimax approximant | confirmed for 1–2; wrong for 3 (→ F1) |
| 3 | 18 | MinMax construction "spreads error more uniformly" | True minimax is exactly equal-ripple. The script's result is barely more uniform than Chebyshev (min/max extremum ratio 0.954 vs 0.948) | wrong as computed (→ F1) |
| 4 | 18-22 | MinMax goal is to reduce max over [a,b] of \|(f−R)/f\| | The objective is the relative error on a 1201-point grid (l.39-53) | confirmed |
| 5 | 26 | f(x)=e^x on [−1,1] | l.12, l.87 | confirmed |
| 6 | 26, 30 | "fixed [2/2] rational form" | l.14, 5 coefficients | confirmed |
| 7 | 26 | order: "(1) equally spaced nodes, (2) Chebyshev nodes, and (3) a MinMax-style relative-error optimization" | `methods` l.102-106; frame titles 1–3 | confirmed |
| 8 | 26 | step (3) is a "MinMax-style relative-error optimization" | It is an optimization that reduces the max error, but stops 1.9% above the minimax value | confirmed only in the narrow sense; result is not minimax (→ F1) |
| 9 | 32 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | Node relative errors ≤1.8e-16 (instr.out). Independent mpmath interpolants agree with the script's coefficients to 15 digits | confirmed |
| 10 | 32 | "the maximum relative error over the interval can differ significantly" | Equal 1.5937e-4 vs Chebyshev 8.942e-5 (factor 1.78); the independent mpmath values are the same | confirmed (numbers); not visible in the error panel (→ F2) |
| 11 | 32-33 | "The MinMax-style step then adjusts coefficients to reduce max \|(f−R)/f\|" | 8.942e-5 → 8.846e-5 | confirmed (reduction is 1.1%; optimum is 8.680e-5, → F1) |
| 12 | 33 | "producing a flatter, more uniform relative-error profile across [−1,1]" | Script's extrema 8.441–8.846e-5 vs Chebyshev 8.474–8.942e-5. The interior ripples got smaller, not more equal to the others. There is no equal ripple, and none of this is visible in the frames | wrong / not shown (→ F1, F2) |
| 13 | 35 | link "Julia source" → rationalapproxaa.jl | File exists and produces the GIF byte-for-byte (manifest) | confirmed |
| 14 | 37 | Alt text: "Rational [2/2] approximation workflow for exp(x) on [-1,1]: equally spaced-node interpolation, Chebyshev-node interpolation, and MinMax-style relative-error optimization, with function and relative-error panels." | 3 frames in this order, each with a function panel and a relative-error panel | confirmed (the relative-error panel is unreadable, → F2) |
| 15 | 37 | embed rationalapproxaa.gif | Committed GIF, 3 frames, identical to the script output | confirmed |
| 16 | frame legends | "max rel err = 0.0001594" (f1), 8.85e-5 (f3) | Independent: 1.5937e-4 (equal), 8.942e-5 (Cheb). Script's f3 value 8.846e-5 is correct for its own coefficients but is not the minimax error 8.680e-5 | confirmed as computed; f3 value misrepresented as MinMax (→ F1) |

## Implementation checks

### rationalapproxaa.jl
- **Method:** Linearized rational interpolation, solving a0+a1x+a2x² − y(b1x+b2x²) = y at 5 nodes (a square 5×5 solve), at equally spaced nodes −1:0.5:1 and at Chebyshev first-kind nodes cos((2k−1)π/10). That part is the stated method. The third construction is a compass/coordinate search on the max relative error over a 1201-point grid. It is not Remez and does not reach the minimax (F1). It is not Padé, and the page does not claim Padé.
- **Numbers (script vs independent mpmath, `remez.py`):**
  - Equal nodes: script a=(1, 0.499831480449449, 0.0816120384126299), b=(−0.499831480449449, 0.0816120384126298); mpmath gives the same to 15 digits. Max relative error: script 1.59365e-4 (1201 grid) / 1.593661e-4 (fine grid); mpmath 1.593661e-4.
  - Chebyshev nodes: script a=(1, 0.499789375887513, 0.0816032216119461), b=(−0.499789375887513, 0.0816032216119461); mpmath gives the same to 15 digits. Max relative error 8.941921e-5 for both.
  - MinMax: script a=(1.0, 0.4997904636, 0.0816037623), b=(−0.4997893759, 0.0816032537), max relative error 8.84586e-5 with unequal extrema. Remez (independent): a=(0.999999996, 0.499785624, 0.081592696), b=(−0.499785626, 0.081592697), E = 8.67978639861e-5 with exact equioscillation at 6 points. The script's own `max_relative_error` gives 8.6798e-5 for the Remez coefficients, so the gap is not caused by the grid.
  - Defining properties: both interpolants reproduce f at their nodes (residual ≤1.8e-16). The minimax property (6-point equioscillation, since 2+2+2=6 and there is no defect) holds for the Remez result and fails for the script's result.
- **Reference values:** The only reference is f = exp, evaluated exactly. The "max rel err" values in the legends are correct for the coefficients each frame uses.
- **Picture:** I viewed full-size frames 1 and 3 and checked the contact sheet. The top panels draw exp(x) and R(x) from the right coefficients, with nodes at the right places in frames 1 and 2. Frame 3 marks nodes that do not belong to the construction (F3). The title and legend values match the computed quantities. The y-range of the relative-error panel is 0–0.01, so all error curves are flattened onto the axis (F2). The y-range of the top panel, 0.2–3.0, contains e^x on [−1,1] (0.368–2.718), and nothing is clamped. There are 3 frames, one per construction, at 1 fps.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/rational-approximation/`](evidence/rational-approximation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
