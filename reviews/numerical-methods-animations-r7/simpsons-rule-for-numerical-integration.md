# Simpson's Rule for Numerical Integration — animation review (round 7)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0. Misleading: 0. Minor: 0. Fidelity: 0.

Considered and deliberately not reported:

- Four annotations drop a trailing zero because `round(x; digits=6)` is printed directly: `1.84056`, `2.01037`, `2.01389`, `2.0154` (frames 4, 12, 16, 21). Each value is correct to six decimals. This is cosmetic and misleads nobody.
- "Each animation below" and "these animations" are plural on a page with one animation. This is template wording and states nothing false.
- The sample-point sequence differs from the legacy GIF: the page runs 3 to 109 points, the legacy GIF 3 to 41 by twos (with 3 repeated). The function, interval, frame count (24) and diagram are the same, and the page states its own final count. The longer sequence shows more of the convergence, so a reader loses nothing.
- The legacy frames print the formula on the plot and the new frames do not. The page states the function in the introduction and in the case heading.
- The local convergence order in the coarse frames is higher than 5/3 (n = 4 to 8 gives a ratio of 5.40). The page's rate claim is explicitly the 24-to-48 ratio "tending to" the limit, and both of those are right.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 8.7 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpsonsaa.gif` | 24 | byte-identical | simpsonsaa |

### Page references

- Scripts linked: `simpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Composite Simpson "fit[s] a quadratic interpolant across each pair of subintervals" | Script lines 41-55 fit through x0, x1, x2 of each pair; the exact integral of those drawn quadratics equals `simpson_sum` to 2.7e-15 for all 23 n | confirmed |
| 2 | $h=(b-a)/n$, even $n$ | Line 27; all 23 n even | confirmed |
| 3 | $S_n=\frac h3[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2}f(x_{2k-1})+2\sum_{k=1}^{n/2-1}f(x_{2k})]$ | Same index sets as lines 28-30; independent mpmath evaluation of this formula agrees with the script to 4.4e-16 | confirmed |
| 4 | "the method integrates cubics exactly" | Script's rule on $x^0..x^3$, n = 2, 4, 8: error 0.0; on $x^4$: 0.2667, 0.01667, 0.00104 (not exact, ratio 16) | confirmed |
| 5 | Composite error for smooth $f$ ($C^4$) is $O(h^4)$ | $e^x$ on [0,2], halving ratios 15.65, 15.91, 15.98, 15.99, 16.00 | confirmed |
| 6 | "typically much smaller than trapezoidal error at the same spacing" (smooth $f$) | $e^x$: trapezoid/Simpson error ratio 62 at n=4, 15362 at n=64 | confirmed |
| 7 | Diagram is over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Lines 8-9; legacy Example 11 code and frames give the same | confirmed |
| 8 | "After an opening frame showing only $f$" | Frame 1 shows only the magenta curve; `n=0` branch | confirmed |
| 9 | "each frame redraws the entire interval using a denser even partition" | Panels span 0..n-2 for each n; sequence strictly increasing and even (checked); frames 2-24 | confirmed |
| 10 | "Red dots mark the sample points $x_i$" | Lines 72-73, $i=0..n$; frames | confirmed |
| 11 | "vertical red lines mark the panel boundaries $x_{2k}$" | Lines 58-61, `0:2:n`; frames show dots between dividers | confirmed |
| 12 | Scripts "linked under each case" | One case, one link; pandoc output has `href="simpsonsaa.jl"` | confirmed |
| 13 | Case 1 heading: composite Simpson, this $f$, $[0,2]$ | Script lines 8-9, 26-31 | confirmed |
| 14 | "Quadratic panels are rebuilt over the full interval as sample density increases" | Lines 41-55 inside the frame loop; frames | confirmed |
| 15 | "converges toward the true integral" | \|error\| strictly decreases across all 23 frames (0.475 to 0.000446) | confirmed |
| 16 | $\int_0^2 f\,dx\approx 2.016280$ | 2.01627971961709..., by mpmath two ways (substitution $x=t^3$ and direct graded quad, agreeing to 40 digits) | confirmed |
| 17 | "the last frame (109 sample points) gives 2.015834" | n=108: 2.015834216; frame 24 shows 109 and 2.015834 | confirmed |
| 18 | "about 0.00045 low" | $S_{108}-I=-0.000445504$ | confirmed |
| 19 | $f'$ unbounded at 0 from the $x^{2/3}$ term | $f'=-e^{-x}\sin(8x^{2/3})+\tfrac{16}{3}e^{-x}\cos(8x^{2/3})x^{-1/3}$ (sympy) | confirmed |
| 20 | $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | sympy limit of the ratio = 1; ratio 0.908, 0.9996, 0.999997 at $x=10^{-2},10^{-4},10^{-6}$ | confirmed |
| 21 | Textbook error order "does not hold for this integrand" | Halving ratios tend to 3.17, not 16 | confirmed |
| 22 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | Observed order to 24576: 1.6667; $E/h^{5/3}$ = -0.34152241 at n=24576 vs the predicted constant $8\zeta(-2/3)(4-2^{5/3})/3=-0.34151508$ | confirmed |
| 23 | "halving $h$ divides it by about 3.38 (from 24 to 48 subintervals)" | $E_{24}/E_{48}=3.38032$ (-0.00591009 / -0.00174838) | confirmed |
| 24 | "tending to $2^{5/3}\approx 3.17$" | $2^{5/3}=3.17480$; ratios 3.380, 3.221 (48 to 96), 3.189 (96 to 192), ..., 3.17484 (24576 to 49152) | confirmed |
| 25 | "instead of 16" | Rule's smooth-$f$ ratio is 16 (claim 5) | confirmed |
| 26 | Alt text: opening frame, red-dot samples, vertical panel boundaries, piecewise quadratic panels, global approximation | Frames 1-24; annotation is the full-interval `simpson_sum` | confirmed |
| 27 | Source link and embed point at this case | `simpsonsaa.jl` writes `simpsonsaa.gif`; committed GIF byte-identical to a fresh scratch run (`cmp`); pandoc and quarto parse the image and link | confirmed |
| 28 | Page reachable from the section index | `pages/numerical-methods/index.qmd:101` | confirmed |

Nothing was left at "could not determine".

### 3. Implementation checks: `simpsonsaa.jl`

**It is the method it claims to be.** `simpson_sum` (lines 26-31) is the standard composite Simpson 1/3 rule with weights 1, 4, 2, ..., 4, 1. Degree of precision is exactly 3 on the script's own rule structure (ledger 4).

**The numbers are right.** Script (instrumented copy `review/instr.jl`) against independent 40-digit evaluation (`review/indep.py`); maximum difference over all 23 n is 4.4e-16.

| n | Points | Script | Independent | Error vs $I$ |
|---|---|---|---|---|
| 2 | 3 | 2.4912610173 | 2.491261017 | +0.474981 |
| 4 | 5 | 1.6117863286 | 1.611786329 | -0.404493 |
| 8 | 9 | 1.9414360777 | 1.941436078 | -0.0748436 |
| 16 | 17 | 2.0032094989 | 2.003209499 | -0.0130702 |
| 24 | 25 | 2.0103696294 | 2.010369629 | -0.00591009 |
| 48 | 49 | 2.0145313361 | 2.014531336 | -0.00174838 |
| 72 | 73 | 2.0153996742 | 2.015399674 | -0.000880045 |
| 108 | 109 | 2.0158342160 | 2.015834216 | -0.000445504 |

The legacy result table (Mathews, 20 values, `M` = 1..60, images `gr_191`-`gr_210`) equals $S_{2M}$ from my computation in every printed digit, for example 2.491261, 1.611786, 1.84056, 2.0154, 2.015906. The legacy GIF annotations read the same way (3, 5, ..., 41 points).

**Reference values are right.** The script draws no exact curve other than $f$ itself. The page's quoted integral 2.016280 is confirmed (ledger 16). The asymptotic constant from the generalized Euler-Maclaurin expansion, $8\zeta(-2/3)(4-2^{5/3})/3=-0.34151508$, matches the measured $E/h^{5/3}$ (-0.34369576, -0.34175414, -0.34154443, -0.34152241 at n = 108, 768, 6144, 24576). This is an independent confirmation of both the $h^{5/3}$ order and the negative sign of the error.

**The picture shows what was computed.**

- All 24 frames were viewed. Each annotation matches the computed value for its n.
- The drawn parabolas pass through the three nodes of each panel. The sum of their exact areas equals the displayed approximation to 2.7e-15, so the shaded region is the number printed.
- Axis limits do not distort anything: over all frames and all panels the quadratics stay within [0.349, 1.976], and $f$ within [0.3572, 1.9198], inside `ylims = (0, 2.1)`. Nothing is clipped, and no panel goes negative, so the fill from 0 is the true area.
- The annotation block (y = 1.74 to 1.88, centred at x = 1.15) sits above the curve, which is at most about 1.39 in that region.
- No clamping or NaN masking is used.
- The GIF has 24 frames: one opening frame plus 23 values of n.

