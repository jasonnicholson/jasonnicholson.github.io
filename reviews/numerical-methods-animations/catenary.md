# Catenary — animation review

Page: [`pages/numerical-methods/catenary/index.qmd`](../../pages/numerical-methods/catenary/index.qmd) · Scripts: `catenaryaa.jl` · GIFs: 1

**Result:** 0 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — Small-$c$ behaviour sentence misdescribes which curve is lower and where they separate

- **Location:** index.qmd:18, "For small $c$ (slack cable), the catenary hangs deeper and the parabola diverges noticeably at the endpoints."
- **Now:** Placed next to "the parabola", the sentence reads as a comparison between the two curves. It says the catenary sits deeper (lower) than the parabola and that the two separate at the endpoints $x=\pm4$.
- **True:** (a) The catenary is never below the parabola. $c\cosh(x/c)-\bigl(c+x^2/(2c)\bigr)=x^4/(24c^3)+x^6/(720c^5)+\dots\ge 0$, because every term is non-negative, so the catenary lies on or above the parabola everywhere. For small $c$ it rises much more steeply than the parabola (frame 1: it is the narrow inner curve). "Hangs deeper" is true only in a different sense: the sag over the fixed span $[-4,4]$, $c(\cosh(4/c)-1)$, is 744.74 at $c=0.5$ against 2.17 at $c=4$. The frames cannot show that, because it is far outside the $y\le 12$ window. (b) The separation is not "at the endpoints". At $c=0.5$ the gap reaches 0.05 already at $|x|=0.61$. The catenary leaves the top of the window at $|x|=1.94$ and the parabola at $|x|=3.39$, so neither curve reaches $x=\pm4$ on screen. At the endpoints themselves the catenary is at 745.24 and the parabola at 16.5, both off-plot. The visible divergence covers most of the window.
- **Evidence:** `reviewer/indep.py` (`/usr/bin/python3 -I indep.py`). It uses sympy to get catenary − parabola $=x^4(30c^2+x^2)/(720c^5)+O(x^8)$ and mpmath to get the per-$c$ table: cat(4), par(4), the window exit points, and the $|x|$ where the gap reaches 0.05. On the script's own 500-point grid, min(cat − par) over all 25 frames is $2.7\times10^{-12}\ge0$. `reviewer/catenaryaa_instr.jl` (`julia catenaryaa_instr.jl`) reproduces ycat[end]=745.2396 and ypar[end]=16.5 for frame 1. Frame 1 (`committed/catenaryaa/frame_001.png`) shows the solid catenary inside and above the dashed parabola for every $x\ne0$.
- **Suggested fix:** Replace it with something like: "For small $c$ (slack cable) the catenary climbs much more steeply than the parabola. The parabola always lies below the catenary, and the gap $\approx x^4/(24c^3)$ becomes visible well inside the window (at $c=0.5$ already for $|x|\gtrsim0.6$)."

- **Independent check:** confirmed with correction. Checker: catenary − parabola = x⁴/(24c³)+… > 0, so the catenary is never below the parabola; at c=0.5 they separate visibly at |x|≈0.7–2. Correction: both curves leave the window before x=±4 only for c<0.71 (frames 1–2); for c up to ≈1.41 (frames 1–7) only the catenary does.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `catenaryaa.jl` | yes | 3.7 | catenaryaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "the catenary $y = c\cosh(x/c)$" | script l.13 `c .* cosh.(x ./ c)`; sympy: satisfies $y''=\sqrt{1+y'^2}/c$ (residual 0) | confirmed |
| 2 | 12 | "its parabolic approximation $y = x^2/(2c) + c$" | script l.14 `x .^ 2 ./ (2c) .+ c` | confirmed |
| 3 | 12 | "as the sag parameter $c$ increases from 0.5 to 4" | script l.9 `range(0.5, 4.0, length=25)`; frame titles c = 0.5 … 4.0, increasing | confirmed |
| 4 | 12 | "The catenary is the curve formed by a flexible cable hanging under gravity" | catenary ODE $y''=\sqrt{1+y'^2}/c$ satisfied exactly (sympy) | confirmed |
| 5 | 12 | "the parabola is the first two terms of its Maclaurin series" | sympy series: $c + x^2/(2c) + x^4/(24c^3)+\dots$; the first two (nonzero) terms are the parabola | confirmed |
| 6 | 14 | "Julia source scripts that generated these animations are linked under each case." | l.20 links catenaryaa.jl; manifest: it produces catenaryaa.gif byte-identically | confirmed |
| 7 | 16 | Heading "Catenary vs parabola approximation as $c$ varies" | both curves plotted for each of 25 $c$ values | confirmed |
| 8 | 18 | "For large $c$ (nearly taut cable)" | span sag $c(\cosh(4/c)-1)$ = 2.17 at c=4 vs 744.7 at c=0.5: large $c$ = small sag | confirmed |
| 9 | 18 | "the two curves are nearly indistinguishable near $x=0$" (large $c$) | c=4: gap < 0.05 for $\lvert x\rvert<2.95$, gap 0.172 (2.8%) at $x=\pm4$; frame 25 | confirmed. This is true near $x=0$ for every $c$; for large $c$ it holds over most of the window. |
| 10 | 18 | "For small $c$ (slack cable)" | span sag 744.7 at c=0.5 | confirmed |
| 11 | 18 | "the catenary hangs deeper" | catenary ≥ parabola everywhere (series terms all ≥ 0; grid min gap 2.7e-12) | wrong as a comparison with the parabola (→ F1) |
| 12 | 18 | "the parabola diverges noticeably at the endpoints" | c=0.5: gap visible from $\lvert x\rvert≈0.6$; both curves leave the window before $x=\pm4$ (1.94, 3.39) | wrong (→ F1) |
| 13 | 18 | "The lowest point is always at $(0, c)$." | $y'(0)=0$, $y''=\cosh(x/c)/c>0$, $y(0)=c$ for both curves; script marker at `[0.0],[c]` (l.28); grid minimum ycat matches c to 6e-5 (grid has no x=0 point) | confirmed |
| 14 | 22 | Alt text: "Catenary y=c cosh(x/c) compared with its parabolic approximation y=x^2/(2c)+c as c sweeps from 0.5 to 4" | as #1–#3 | confirmed |
| 15 | 22 | Alt text: "the two curves nearly coincide near the apex for large c" | as #9 ("apex" here means the lowest point) | confirmed |
| 16 | 20/22 | Wiring: link `catenaryaa.jl`, embed `catenaryaa.gif` | manifest: script produces that GIF, byte-identical | confirmed |

## Implementation checks

### catenaryaa.jl
- **Method:** No iterative numerical method. It evaluates $c\cosh(x/c)$ and its two-term Maclaurin truncation $c+x^2/(2c)$ on a 500-point grid over $[-4,4]$ for 25 values of $c$ in $[0.5,4]$, which is what the page says.
- **Numbers:** The script's values (instrumented copy `reviewer/catenaryaa_instr.jl`) agree with independent mpmath values (`reviewer/indep.py`) to all printed digits. At $x=4$: c=0.5: 745.2396 / 16.5 (both); c=1.375: 12.6463 / 7.1932 (both); c=2.25: 6.8464 / 5.8056 (both); c=4: 6.1723 / 6.0000 (both). On every frame min(cat − par) ≥ 0, which matches the analytic $x^4/(24c^3)+\dots\ge0$. The 25 $c$ values are $0.5+k\cdot0.14583$, $k=0..24$.
- **Reference values:** The truncation was checked against the sympy Maclaurin series $c+x^2/(2c)+x^4/(24c^3)+x^6/(720c^5)+\dots$: the parabola is exactly the first two nonzero terms. The catenary satisfies the hanging-cable ODE (sympy residual 0). The vertex $(0,c)$ is correct for both curves.
- **Picture:** I looked at the contact sheet, plus frames 1 (c=0.5) and 25 (c=4.0) at full size. The solid steel-blue line is the catenary and the dashed tomato line is the parabola, matching the legend. The black diamond sits at $(0,c)$ and moves up with $c$. The frame-title $c$ matches `round(c,2)` (1.375 is shown as 1.38 and 3.125 as 3.12, both normal ties-to-even rounding). The fixed window $y\in[0,12]$ cuts off both curves for small $c$ (frames 1–7 for the catenary, which exits at $|x|<4$ until $c≈1.52$). That is a readable display choice, but it is why the page's phrase "at the endpoints" (F1) does not describe what is visible. There is no clamping or NaN masking.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/catenary/`](evidence/catenary/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
