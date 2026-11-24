# Riemann Sums — animation review (round 7)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None: 0 Error, 0 Misleading, 0 Minor.**

Every number stated on the page agrees with an independent computation at its stated precision, and every behaviour claim agrees with the computed sequence.


#### Examined and deliberately not raised

These are recorded so the owner can overrule them.

1. **Variable decimals in the Case 1 and 2 labels.** `riemannaa.jl:41` and `riemannbb.jl:41` use `round(approx; digits=6)`, which drops trailing zeros. The frames show `2.0` (L, n=1), `1.79759` (L, n=4), `1.8522` (L, n=6), `1.95574` (L, n=12), `2.03585` (R, n=1) and `2.01341` (R, n=72). Cases 3 and 4 use `%.6f`. Each value is correct, so this is cosmetic under the brief's standard.
2. **n=1 is accidentally close.** L(1) = 2.000000 has error -0.0163 and R(1) = 2.035850 has error +0.0196. Only n >= 28 (left) and n >= 24 (right) are closer. The page's "settles toward the true integral" remains true: from n=4 on, both sums increase and the absolute error shrinks at every frame. Saying more would be a teaching suggestion.
3. **The first frame has no sum.** Each GIF opens with the curve alone (n=0), so "every frame's sum" and "each frame increases" strictly apply to frames 2 to 25. Mathews' GIFs also open on the bare curve. No reader is misled.
4. **Different n sequence from Mathews.** The archive's tables use M = {1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120}. The page uses 1 to 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120. The function, interval, four cases and pattern (density across the full interval) are the same. The added n=3, 5 and 7 are what expose the non-monotone steps the page discusses.
5. **No red sample-point dots.** Mathews marks each sample point; the page does not. The sampled corner of each bar is still visibly on the curve in Cases 1 and 2. This is a presentation choice.
6. **Lower and upper values differ from Mathews in the sixth decimal, and the page is the correct one.** Mathews takes extrema over a 1201-point grid (`gr_229`), which biases the lower sum up and the upper sum down. My reproduction of his grid method gives his displayed values exactly; the true values are the page's.

| Quantity | Mathews (archive frame) | My reproduction of his grid | True value | Page |
|---|---|---|---|---|
| Lower, n=1 | 0.714411 | 0.714411 | 0.714407 | not quoted; script agrees with true |
| Lower, n=4 | 1.192005 | 1.192005 | 1.192004 | 1.192004 |
| Lower, n=8 | 1.601562 | 1.601562 | 1.601561 | script agrees with true |
| Upper, n=4 | 2.843070 | 2.843070 | 2.843078 | script agrees with true |
| Upper, n=8 | 2.427094 | 2.427094 | 2.427098 | 2.427098 |

7. **Archive examples not on this page.** Examples 14 and 15 (midpoint, trapezoidal) have their own pages on this site, `midpoint-rule/` and `trapezoidal-rule-for-numerical-integration/`, both using the same function. The archive's Riemann animation index (`a2001/Animations/Riemann/Riemann.html`) lists exactly the four cases this page has. Examples 1 to 9 are static worked exercises with no animation.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.9 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 12.0 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 9.3 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 6.9 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `riemannaa.gif` | 25 | byte-identical | riemannaa |
| `riemannbb.gif` | 25 | byte-identical | riemannbb |
| `riemanncc.gif` | 25 | byte-identical | riemanncc |
| `riemanndd.gif` | 25 | byte-identical | riemanndd |

### Page references

- Scripts linked: `riemannaa.jl`, `riemannbb.jl`, `riemanncc.jl`, `riemanndd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

"Indep" means `review/indep.py` (mpmath and numpy, written without reference to the scripts' routines).

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "partitioning $[a,b]$ into $n$ subintervals", $\Delta x=(b-a)/n$ | Confirmed | All four scripts use `dx = (b - a) / n` |
| D2 | "the approximation converges to the true integral" | Confirmed | f is continuous on [0,2]. Errors at n=120: L -0.001485, R -0.001186, lower -0.037329, upper +0.034671 |
| D3 | nodes $x_i=a+i\Delta x$ | Confirmed | `riemannaa.jl:18,31`, `riemannbb.jl:18,31`, `riemanncc.jl:45,59`, `riemanndd.jl:45,59` |
| D4 | $L_n=\sum_{i=0}^{n-1} f(x_i)\Delta x$ | Confirmed | `riemannaa.jl:18`; 24 values match Indep |
| D5 | $R_n=\sum_{i=1}^{n} f(x_i)\Delta x$ | Confirmed | `riemannbb.jl:18`; 24 values match Indep |
| D6 | "bounds from interval minima/maxima" | Confirmed | `riemanncc.jl:41`, `riemanndd.jl:41`; brute-force extrema agree |
| D7 | "The legacy Mathews animations increase sampling density over the entire interval between frames" | Confirmed | Archive GIF frames (`review/legacy/*/sheet.png`) |
| D8 | "The animations below follow that same pattern" | Confirmed | `n_seq` strictly increases; each frame redraws all bars on [0,2] |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Interval $[0,2]$ | Confirmed | `a, b = 0.0, 2.0` in all scripts; frame x axes |
| A2 | $y=e^{-x}\sin(8x^{2/3})+1$ | Confirmed | Line 8 (aa, bb), line 9 (cc, dd); same as Mathews `gr_178` |
| A3 | "the number of subintervals $n$ increases across the full interval" | Confirmed | `n_seq` has 24 strictly increasing values, 1 to 120 |
| A4 | "not by sweeping left-to-right" | Confirmed | Every frame draws all n bars in one pass |
| A5 | "Julia source scripts that generated these animations are linked under each case" | Confirmed | `index.qmd:30,38,46,54`; scratch runs are byte-identical to all 4 committed GIFs (`cmp`) |

### Case 1: Left

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: Left Riemann Sum, stated function | Confirmed | `riemannaa.jl:8,18,22`; frame title |
| C1.2 | "height ... taken at the **left endpoint**" | Confirmed | `riemannaa.jl:33` `h = f(xl)`; 145 bars measured in pixels, worst deviation 0.0029 |
| C1.3 | "the approximation settles toward the true integral" | Confirmed | 2.000000, 2.363965, 1.893096, 1.797590, then rises every frame to 2.014795; absolute error shrinks every frame from n=4 |
| C1.4 | Link `riemannaa.jl`; embed `riemannaa.gif` | Confirmed | `index.qmd:30,32`; GIF title "Left Riemann Sum" |
| C1.5 | Alt: "over [0,2]", "increases partition density", "updates the left-endpoint area estimate" | Confirmed | Frames 2 to 25 |

### Case 2: Right

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: Right Riemann Sum, stated function | Confirmed | `riemannbb.jl:8,18,22`; frame title |
| C2.2 | "height is taken at the **right endpoint**" | Confirmed | `riemannbb.jl:33` `h = f(xr)`; 147 bars measured, worst deviation 0.0029 |
| C2.3 | "endpoint choice shifts the approximation at finite $n$" | Confirmed | $R_n-L_n=\Delta x\,(f(2)-f(0))=0.035850/n$ for all 24 n (worst deviation 4.9e-16); R > L in every frame |
| C2.4 | Link `riemannbb.jl`; embed `riemannbb.gif` | Confirmed | `index.qmd:38,40`; GIF title "Right Riemann Sum" |
| C2.5 | Alt: "over [0,2]", "increases partition density", "updates the right-endpoint area estimate" | Confirmed | Frames 2 to 25 |

### Case 3: Lower

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Heading: Lower Riemann Sum, stated function | Confirmed | `riemanncc.jl:9,41,50`; frame title |
| C3.2 | "uses the **minimum of $f$ on its subinterval**" | Confirmed | Endpoints plus interior critical points; brute-force minima agree to 3.9e-8 across all n; 142 bars measured, worst deviation 0.0029 |
| C3.3 | "every frame's sum is a lower bound" | Confirmed | lower <= I for all 24 n |
| C3.4 | $I\approx 2.016280$ | Confirmed | I = 2.0162797196171 by two mpmath quadratures (substitution $x=t^3$, and direct with breakpoints) |
| C3.5 | "The sums approach $I$ as $n$ grows" | Confirmed | 0.714407 to 1.978951 |
| C3.6 | "not monotonically" | Confirmed | Exactly one decrease in the sequence, n=3 to n=4 |
| C3.7 | "1.374576 at $n=3$" | Confirmed | Indep 1.374576; brute force 1.374576; frame label |
| C3.8 | "1.192004 at $n=4$" | Confirmed | Indep 1.192004; brute force 1.192004; `frame_005.png` |
| C3.9 | "the $n=4$ partition is not a refinement of the $n=3$ one" | Confirmed | 3 does not divide 4. Across all 106 pairs in `n_seq` where one n divides the other, none violates refinement monotonicity |
| C3.10 | Link `riemanncc.jl`; embed `riemanncc.gif` | Confirmed | `index.qmd:46,48`; GIF title "Lower Riemann Sum" |
| C3.11 | Alt: "increases the number of subintervals", "minimum of f" | Confirmed | Frames 2 to 25; code |

### Case 4: Upper

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C4.1 | Heading: Upper Riemann Sum, stated function | Confirmed | `riemanndd.jl:9,41,50`; frame title |
| C4.2 | "uses the **maximum of $f$ on its subinterval**" | Confirmed | Brute-force maxima agree to 3.9e-8 across all n; 149 bars measured, worst deviation 0.0029 |
| C4.3 | "every frame's sum is an upper bound" | Confirmed | upper >= I for all 24 n |
| C4.4 | "squeeze the exact value as $n\to\infty$" | Confirmed | Gap upper - lower falls from 3.125105 (n=1) to 0.072000 (n=120); f is continuous |
| C4.5 | "at $n=120$, $1.978951 \le I \le 2.050951$" | Confirmed | Indep and brute force give 1.978951 and 2.050951; I = 2.016280 lies between |
| C4.6 | "not monotonically along this sequence" | Confirmed | Upper has exactly one rise, n=7 to n=8; lower has exactly one fall, n=3 to n=4 |
| C4.7 | "2.418035 at $n=7$" | Confirmed | Indep and brute force; `frame_008.png` |
| C4.8 | "2.427098 at $n=8$" | Confirmed | Indep and brute force; `frame_009.png` |
| C4.9 | Link `riemanndd.jl`; embed `riemanndd.gif` | Confirmed | `index.qmd:54,56`; GIF title "Upper Riemann Sum" |
| C4.10 | Alt: "increases the number of subintervals", "maximum of f" | Confirmed | Frames 2 to 25; code |

No claim was left undetermined.

### 3. Implementation checks

### Shared reference values

- **Integral.** I = 2.0162797196171 from two independent mpmath quadratures that agree to all 15 printed digits. One removes the $x^{2/3}$ singularity with $x=t^3$; the other integrates directly with breakpoints.
- **Critical points of f.** I solved $(16/3)\cos(8t^2)-t\sin(8t^2)=0$ in $t=x^{1/3}$ on a 2,000,001-point grid with `brentq`. The script's list agrees in all printed digits.

| Critical point (x) | f(x) | Type |
|---|---|---|
| 0.08038355 | 1.91975595 | maximum |
| 0.43198196 | 0.35720369 | minimum |
| 0.93920525 | 1.38450998 | maximum |
| 1.56447550 | 0.79558861 | minimum |

- **Derivative in the scripts.** SymPy reduces `fp - dF/dx` to 0 for the formula at `riemanncc.jl:20` and `riemanndd.jl:20`.

### Script output against the independent computation

I stripped the plotting from scratch copies (`review/inst/raa.jl`, `rbb.jl`, `rcc.jl`, `rdd.jl`) and compared all 96 printed values (4 sums at 24 values of n) with `indep.py`. **The worst absolute difference is 4.97e-07, which is rounding of the printed sixth decimal.** The full table:

| n | L (script = indep) | R | Lower | Upper |
|---|---|---|---|---|
| 1 | 2.000000 | 2.035850 | 0.714407 | 3.839512 |
| 2 | 2.363965 | 2.381889 | 1.152792 | 3.283721 |
| 3 | 1.893096 | 1.905046 | 1.374576 | 2.881460 |
| 4 | 1.797590 | 1.806553 | 1.192004 | 2.843078 |
| 5 | 1.818308 | 1.825478 | 1.376314 | 2.677884 |
| 6 | 1.852200 | 1.858175 | 1.448476 | 2.508600 |
| 7 | 1.881422 | 1.886543 | 1.541768 | 2.418035 |
| 8 | 1.904354 | 1.908836 | 1.601561 | 2.427098 |
| 10 | 1.935972 | 1.939557 | 1.629124 | 2.365760 |
| 12 | 1.955740 | 1.958728 | 1.660983 | 2.304236 |
| 14 | 1.968826 | 1.971387 | 1.694682 | 2.278697 |
| 16 | 1.977936 | 1.980176 | 1.726233 | 2.240918 |
| 20 | 1.989501 | 1.991294 | 1.777849 | 2.204395 |
| 24 | 1.996339 | 1.997833 | 1.817359 | 2.176725 |
| 28 | 2.000747 | 2.002027 | 1.847553 | 2.155682 |
| 32 | 2.003771 | 2.004891 | 1.870891 | 2.139327 |
| 40 | 2.007569 | 2.008465 | 1.901302 | 2.115753 |
| 48 | 2.009796 | 2.010543 | 1.920267 | 2.099989 |
| 56 | 2.011227 | 2.011868 | 1.934631 | 2.088695 |
| 64 | 2.012207 | 2.012768 | 1.945355 | 2.079985 |
| 72 | 2.012912 | 2.013410 | 1.953170 | 2.073098 |
| 88 | 2.013841 | 2.014248 | 1.965125 | 2.063145 |
| 104 | 2.014414 | 2.014758 | 1.973057 | 2.056105 |
| 120 | 2.014795 | 2.015094 | 1.978951 | 2.050951 |

Formula-independent checks:

- lower <= L, R <= upper at all 24 n.
- lower <= I <= upper at all 24 n.
- $R_n-L_n=\Delta x\,(f(2)-f(0))$ to 4.9e-16.
- Across all 106 refinement pairs in `n_seq`, the lower sum never falls and the upper sum never rises.
- Brute-force extrema (40,001 points per subinterval, no critical-point logic) agree with the critical-point method to 3.93e-08 at all 24 n.

### `riemannaa.jl` (Left)

- **Method:** left endpoint rule, `sum(f(a + i*dx) for i in 0:n-1)`. Correct.
- **Numbers:** 24 of 24 match.
- **Reference:** none drawn. The function is the stated one.
- **Picture:** bar height `f(xl)`. Measured in frames 2 to 17 (n=1 to 32): 145 bars clear of the curve, worst deviation 0.0029 against a pixel size of 0.0050. Viewed frames 1, 2 and the 9-frame sheet including n=120. Label n and value are those computed. y limits (0, 2.1) contain the curve (range 0.357 to 1.920). No clamping or masking.

### `riemannbb.jl` (Right)

- **Method:** right endpoint rule, `i in 1:n`, `h = f(xr)`. Correct.
- **Numbers:** 24 of 24 match.
- **Reference:** none drawn.
- **Picture:** 147 bars measured, worst deviation 0.0029. Viewed frame 2 and the sheet. The `2.03585` label at n=1 is the true 2.035850.

### `riemanncc.jl` (Lower)

- **Method:** true lower Darboux sum. The minimum on each subinterval is taken over both endpoints and any critical point strictly inside. Valid because f is continuous, with $f'$ unbounded only at $x=0$, which is an endpoint. The search grid starts at $x=10^{-4}$, and no critical point lies below it (the first is 0.0804).
- **Numbers:** 24 of 24 match; brute force agrees.
- **Reference:** the stated $I$ is correct.
- **Picture:** 142 bars measured, worst deviation 0.0029. Bars visibly stay under the curve. Viewed `frame_005.png` (n=4, 1.192004) and the sheet (n=3, 1.374576; n=120, 1.978951).

### `riemanndd.jl` (Upper)

- **Method:** true upper Darboux sum, built the same way with the maximum.
- **Numbers:** 24 of 24 match; brute force agrees.
- **Reference:** the stated bracket at n=120 is correct.
- **Picture:** 149 bars measured, worst deviation 0.0029. Viewed `frame_008.png` (n=7, 2.418035), `frame_009.png` (n=8, 2.427098) and the sheet (n=120, 2.050951).

### Limits of the checks

- **Pixel measurement.** It covers frames 2 to 17 (n=1 to 32) of each GIF and only bars whose top is at least 0.05 away from the curve: 583 of 768 bars. The other 185 are bars whose top nearly coincides with the curve, where the curve's own pixels defeat the detector. Those bars are drawn by the same line of code, and the frames were inspected visually.
- **Frame labels.** I read labels directly in the 9 sheet frames per GIF plus the individual frames named above, not in all 100 frames by eye. The remaining labels follow from the code, whose values were checked in full, and from the byte-identical regeneration of all 4 GIFs (`cmp`).

