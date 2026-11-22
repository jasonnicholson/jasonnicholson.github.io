# The Tangent Parabola — animation review

Page: [`pages/numerical-methods/the-tangent-parabola/index.qmd`](../../pages/numerical-methods/the-tangent-parabola/index.qmd) · Scripts: `tangparabaa.jl` · GIFs: 1

**Result:** 0 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

None. This rests on the following: an instrumented copy of the script (`reviewer/dump.jl`) and an independent sympy/numpy computation (`reviewer/indep.py`) agree on all 18 secant parabolas to 12 digits. sympy shows that the drawn T₂ matches f, f′ and f″ at x₀ = π/4 exactly, and that the secant-parabola coefficients tend to T₂'s coefficients as h → 0. Frames 1, 18 and 23 match the code, and every claim on the page checks out.

(Cosmetic, not a finding: in the 5 hold frames, 19–23, the legend lists "Tangent parabola T₂(x)" twice, because the dashed curve is T₂ drawn over the dotted T₂. It does not mislead.)

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `tangparabaa.jl` | yes | 3.5 | tangparabaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "**secant parabola** (degree-2 Newton polynomial through $x_0 - h$, $x_0$, $x_0 + h$)" | tangparabaa.jl:21-30 builds the divided differences f[x1,x2], f[x2,x3], f[x1,x2,x3] on nodes x0−h, x0, x0+h, then the Newton form y1 + d01(x−x1) + d012(x−x1)(x−x2). Node residual ≤ 1.2e-16 for all h (dump.jl). Coefficients agree with an independent sympy Lagrange interpolant to 12 digits (indep.py). | confirmed |
| 2 | 12 | "**tangent parabola** (degree-2 Taylor polynomial at $x_0$)" | tangparabaa.jl:18 T2. sympy: T2 − f, (T2 − f)′ and (T2 − f)″ are all 0 at x0. T2‴ = 0 ≠ f‴(x0) = √2/2, so T2 has exactly order 2. Script coefficients (0.70710678, −0.70710678, −0.35355339) = (√2/2, −√2/2, −√2/4). | confirmed |
| 3 | 12 | "converging to the tangent parabola … as $h \to 0$" | sympy: secant coefficients about x0 are (√2/2, −√2·sin h/(2h), √2(cos h−1)/(2h²)). Their limits are (√2/2, −√2/2, −√2/4) = T2. The deviations are √2h²/12 and √2h²/48, so O(h²). The max deviation on the plot window falls from 0.232 (h=1) to 2.43e-5 (h=0.01) and shrinks by about h² at each step. | confirmed |
| 4 | 12, 16 | "$f(x) = \cos(x)$ centered at $x_0 = \pi/4$" | tangparabaa.jl:10, 14. The frame legend reads "f(x) = cos(x)", and the x₀ line sits at 0.785. | confirmed |
| 5 | 18 | "For large $h$ the secant parabola is determined by three well-separated points" | Frame 1 (h=1.0): nodes at x = −0.215, 0.785, 1.785, and the red dashed curve passes through all three. | confirmed |
| 6 | 18 | "As $h \to 0$ all three nodes collapse to $x_0$, and the secant parabola approaches the Taylor polynomial $T_2(x) = f(x_0) + f'(x_0)(x-x_0) + \tfrac{1}{2}f''(x_0)(x-x_0)^2$" | The formula matches the script and is the correct T₂. Nodes x0±h with h → 0.01 cluster at x0 in frame 18. The convergence is shown under #3. | confirmed |
| 7 | 18 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | sympy limit, as under #3 (it holds for any C² f with symmetric nodes; the page's f is cos). | confirmed |
| 8 | 20 | link `tangparabaa.jl` | The file exists and is the script that produces tangparabaa.gif (manifest: byte-identical regen). | confirmed |
| 9 | 22 | embed `tangparabaa.gif` | The file exists and is produced by tangparabaa.jl. | confirmed |
| 10 | 22 | alt: "Secant parabola (red dashed) through three nodes" | Colour :tomato, linestyle :dash, passing through the 3 scatter nodes (frames 1 and 18). | confirmed |
| 11 | 22 | alt: "tangent parabola (green dotted, Taylor degree-2)" | :darkgreen, :dot, T2 (frames 1, 18, 23). | confirmed |
| 12 | 22 | alt: "as h shrinks from 1.0 to near 0" | h runs on a log scale from 1.0 to 0.01 over 18 frames (titles read "h = 1.0" … "h = 0.01"), then 5 frames show T₂ itself (h=0). | confirmed |
| 13 | 22 | alt: "for cos(x) at x0=pi/4" | As #4. | confirmed |

## Implementation checks

### tangparabaa.jl
- Method: the degree-2 Newton divided-difference interpolant on the symmetric nodes x0−h, x0, x0+h is the "secant parabola". The second-order Taylor polynomial at x0, built from the analytic derivatives −sin and −cos, is the "tangent parabola". This is the construction the page describes. No variant or substitution is involved.
- Numbers: script coefficients about x0 (c0, c1, c2) next to the independent sympy closed form, which is evaluated numerically:
  - h=1.0: script (0.707106781187, −0.595009839529, −0.325055356816); sympy (0.707106781187, −0.595009839529, −0.325055356816)
  - h=0.338386: script (…, −0.693689315172, −0.350192612093); sympy (…, −0.693689315172, −0.350192612093)
  - h=0.087333: script (…, −0.706208274996, −0.353328735489); sympy (…, −0.706208274996, −0.353328735489)
  - h=0.01: script (…, −0.707094996132, −0.353550444325); sympy (…, −0.707094996132, −0.353550444325)
  - All 18 h values agree to all 12 printed digits. The max |P_h − T2| on the 500-point plot grid is identical in both: 0.2323, 0.1377, …, 4.18e-5, 2.43e-5. Cancellation in d012 at h=0.01 is about eps/h² ≈ 2e-12, which is negligible.
  - Commands: `cd reviewer && julia dump.jl`; `/usr/bin/python3 reviewer/indep.py`.
- Reference values: T2 is checked by property (sympy): it matches f, f′ and f″ at x0 = π/4 and differs from f at the third derivative. It is also checked as the h → 0 limit of the interpolant, with error O(h²) (c1: √2h²/12, c2: √2h²/48).
- Picture: I looked at the contact sheet (12 frames) and the full-size frames 1, 18 and 23. Frame 1: the 3 nodes are at x0±1 and x0 on the cos curve, the red dashed parabola passes through them, the green dotted T2 is tangent to cos at x0 with the same curvature, the gray x₀ line is at 0.785, and the title and legend read h = 1.0. Frame 18: h = 0.01, the nodes are clustered at x0, and the red and green curves coincide. Frames 19–23 show title "Tangent Parabola (T₂ — Taylor degree 2 at x₀)" with T₂ drawn twice (dashed and dotted, both labelled T₂). There are 23 frames in all, 18 secant and 5 hold. No clamping or masking is used. The window [x0−1.5, x0+1.5] × [−0.5, 1.3] contains every node and the region of interest, and the curves leaving the bottom of the window below y = −0.5 at x > 1.9 does not affect any conclusion. A note on pacing, not a finding: by about h ≈ 0.2 (frame 7) the secant and tangent parabolas differ by under 0.01, roughly 2 px, so the second half of the sweep mostly shows the nodes merging.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/the-tangent-parabola/`](evidence/the-tangent-parabola/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
