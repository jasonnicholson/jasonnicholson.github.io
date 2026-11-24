# Simpson's Rule for Numerical Integration — animation review (round 9)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None** (0 Error, 0 Misleading, 0 Minor).

Observations that I judged *not* to be findings:
- The on-frame value is printed with `round(approx; digits=6)` and Julia's default float printing, so trailing zeros are dropped: n=6 shows `1.84056`, n=24 `2.01037`, n=40 `2.01389`, n=72 `2.0154` (true 2.015399674 → 2.015400). The values are correct; only the displayed digit count varies. Cosmetic; if the owner wants uniform six decimals, use `@sprintf("%.6f", approx)` at `simpsonsaa.jl:65`.
- The intro says "Each animation below" although there is one animation. Wording only.
- The legacy GIF printed the formula `y = e^{-x} sin(8x^{2/3}) + 1` inside the frame and stopped at 41 sample points (n = 2..40); the new GIF names the function only on the page and continues to 109 points. Same function, same interval, same per-n values (see Section 3); the extension is not a loss of content.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 9.4 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "fitting a quadratic interpolant across each pair of subintervals" | `poly_coeffs` on (x0,x1,x2); nodal residual ≤ 2.6e-15 for every panel in every frame (`inst.jl`) | confirmed |
| D2 | $h=(b-a)/n$, even $n$, $S_n = \frac h3[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2} f(x_{2k-1}) + 2\sum_{k=1}^{n/2-1} f(x_{2k})]$ | Matches `simpson_sum` (odd i 1:2:n-1 weight 4, even i 2:2:n-2 weight 2); index ranges correct; independent mpmath implementation of the formula agrees to all printed digits | confirmed |
| D3 | "the method integrates cubics exactly" | Simpson n=4 on [0,2]: error for x^0..x^3 = 0 exactly, x^4 error 0.016667 ≠ 0 (`indep.py`) | confirmed |
| D4 | composite error for $C^4$ f is $O(h^4)$ | standard result; consistent with degree of precision 3 | confirmed |
| A1 | Interval [0,2], $y=e^{-x}\sin(8x^{2/3})+1$ | `simpsonsaa.jl:8-9` | confirmed |
| A2 | "After an opening frame showing only f" | frame_001: only magenta curve, no annotation; code `n=0` branch | confirmed |
| A3 | "each frame redraws the entire interval using a denser even partition" | n_seq = 2,4,…,20,24,…,48,56,64,72,84,96,108, all even, strictly increasing; panels span 0..2 in every frame | confirmed |
| A4 | "Red dots mark the sample points $x_i$" | `scatter!` at a+i·dx, i=0..n, red; frames 2,3,24 | confirmed |
| A5 | "vertical red lines mark the panel boundaries $x_{2k}$" | loop `i in 0:2:n`; frame_002 (n=2) has lines only at 0 and 2, frame_003 (n=4) adds x=1 | confirmed |
| A6 | Case heading: Composite Simpson's Rule, same f, [0,2] | script | confirmed |
| B1 | "Quadratic panels are rebuilt over the full interval as sample density increases" | frames | confirmed |
| B2 | "the approximation converges toward the true integral" | S_n − I: +0.475 (n=2), −0.404 (4), then monotonically increasing to −0.000446 (108) | confirmed |
| B3 | $\int_0^2 f\,dx \approx 2.016280$ | mpmath (40 digits, substitution x=t³ and a 40-piece split agree): 2.0162797196170963 | confirmed |
| B4 | "the last frame (109 sample points) gives 2.015834" | n=108: script 2.015834216, independent 2.015834216; frame_024 shows "Sample Points = 109", "Approximation = 2.015834" | confirmed |
| B5 | "about 0.00045 low" | S_108 − I = −0.000445504 | confirmed |
| B6 | "$f'$ unbounded at $x=0$ ($f'(x)\approx \frac{16}{3}x^{-1/3}$ near 0)" | mp.diff at x=1e-9: 5333.33332, (16/3)x^{-1/3} = 5333.33333 | confirmed |
| B7 | "the textbook error order, which assumes smooth f, does not hold" | measured ratios ≪ 16 (below) | confirmed |
| B8 | "error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | E(n)/E(2n): 12→24 4.235, 24→48 3.380, 48→96 3.221, 96→192 3.189, …, 3072→6144 3.1751; 2^{5/3}=3.1748 | confirmed |
| B9 | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | E24/E48 = −0.00591009/−0.00174838 = 3.3803 | confirmed |
| B10 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | ratios above → 3.1751; 2^{5/3}=3.1748 | confirmed |
| W1 | `[Julia source](simpsonsaa.jl)` | file exists, is the only script, produces simpsonsaa.gif | confirmed |
| W2 | embed `simpsonsaa.gif` | committed GIF byte-identical to regeneration from this script | confirmed |
| W3 | Alt text: opening frame only f; red dots = sample points; vertical red lines = panel boundaries; piecewise quadratic panels; "the global approximation" | frames 1, 2, 3, 24; "global approximation" = on-frame "Approximation = S_n" | confirmed |

### 3. Implementation checks — `simpsonsaa.jl`

**Method.** Composite Simpson's 1/3 rule, standard form, even n. Drawing uses the actual quadratic interpolant through (x_{2k}, x_{2k+1}, x_{2k+2}) via a Vandermonde solve; no neighbouring method substituted.

**Numbers.** Instrumented copy (`review/inst.jl`) printed `simpson_sum(n)` for every frame and, separately, the exact integral of the drawn quadratic panels; the two agree to ~1e-15 for every n, so the shaded area is exactly the number shown. Independent mpmath implementation (`review/indep.py`):

| n | pts | script | independent | error vs I |
|---|---|---|---|---|
| 2 | 3 | 2.491261 | 2.491261017 | +0.474981 |
| 4 | 5 | 1.611786 | 1.611786329 | −0.404493 |
| 8 | 9 | 1.941436 | 1.941436078 | −0.0748436 |
| 12 | 13 | 1.991249 | 1.991249238 | −0.0250305 |
| 16 | 17 | 2.003209 | 2.003209499 | −0.0130702 |
| 20 | 21 | 2.007942 | 2.007941739 | −0.00833798 |
| 24 | 25 | 2.01037 | 2.010369629 | −0.00591009 |
| 28 | 29 | 2.011814 | 2.011813593 | −0.00446613 |
| 36 | 37 | 2.013412 | 2.013412033 | −0.00286769 |
| 44 | 45 | 2.014251 | 2.014251009 | −0.00202871 |
| 48 | 49 | 2.014531 | 2.014531336 | −0.00174838 |
| 56 | 57 | 2.014934 | 2.014934350 | −0.00134537 |
| 72 | 73 | 2.0154 | 2.015399674 | −0.000880045 |
| 96 | 97 | 2.015737 | 2.015736986 | −0.000542734 |
| 108 | 109 | 2.015834 | 2.015834216 | −0.000445504 |

(All 23 values were compared; the rest match equally.) Property check: degree of precision exactly 3.

**Reference value.** No reference is drawn in the GIF; the page's 2.016280 was verified with mpmath at 40 digits by two independent quadratures (2.016279719617096…).

**Picture.** Frames 1, 2, 3, 24 and the 12-frame contact sheet inspected. Every on-frame "Sample Points" equals n+1 and every "Approximation" matches the computed S_n. Panel fills go to y=0 under the quadratic; panel boundary lines at x_{2k}; red dots at all x_i; magenta curve is the f in the code. Axis limits: y∈[0,2.1] contains f (range 0.357–1.920) and all panels (min panel value 0.357, max panel overshoot near x≈0.1 is below 2.0 in the frames); x∈[−0.03,2.03] keeps end dots unclipped. Annotation at (1.15, 1.74–1.88) does not overlap the curve (f ≤ 1.39 there). No clamping or NaN masking. 24 frames = opening frame + 23 values of n.

**Legacy fidelity.** Archive Simpsonaa.gif: same function, interval and colours; sample counts 3..41 (n = 2..40). Its printed values for n = 2, 6, 10, 14, 18, 22, 26, 28, 30, 34, 38, 40 match my recomputation exactly (`review/legacy_cmp.py`), and the new GIF's values for shared n (e.g. n=28 → 2.011814, n=40 → 2.013890) are identical. The new page extends the refinement to n=108 and adds the error-order discussion; nothing in the archive animation is dropped. The archive's Example 1 (m = 1, 2, 4, 8) belongs to the worked-example material, which the page lists as planned.

