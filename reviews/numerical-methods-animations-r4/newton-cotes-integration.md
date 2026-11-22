# Newton-Cotes Integration — animation review (round 4)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames. The implementations compute the named rules correctly.

These observations do not reach the finding threshold and are recorded only for completeness:
- The frame annotations use `round(approx; digits=6)`, which drops trailing zeros. Some frames therefore show 5 decimals ("2.01017", "1.79047", "2.01389", "2.01581", "2.01037", "2.01537"). The values are correct, so this is cosmetic.
- The trapezoidal GIF draws no red sample-point dots, while the other three GIFs and the legacy trapezoidal GIF do. The page never claims dots for Case 1, so this is cosmetic.
- The legacy GIFs show the formula of f in the frame and use somewhat different sample-count sequences. For example, the legacy trapezoidal sequence includes 51, 61, 71, 81 and 101 points, and the page's does not. Neither difference matters to a reader: the page states f in the text, and every count the two share agrees (see L20).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 9.0 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.0 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 8.6 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 8.4 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtoncotesaa.gif` | 25 | byte-identical | newtoncotesaa |
| `newtoncotesbb.gif` | 21 | byte-identical | newtoncotesbb |
| `newtoncotescc.gif` | 25 | byte-identical | newtoncotescc |
| `newtoncotesdd.gif` | 25 | byte-identical | newtoncotesdd |

### Page references

- Scripts linked: `newtoncotesaa.jl`, `newtoncotesbb.jl`, `newtoncotescc.jl`, `newtoncotesdd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | NC formulas interpolate f on equally spaced nodes and integrate the interpolant per panel | Scripts use nodes `a+i*dx`. The area under each drawn Vandermonde interpolant equals the rule's value to ≤1.5e-14 in every frame (`check.out`) | confirmed |
| D2 | Description | trapezoidal (degree 1), Simpson 1/3 (degree 2), 3/8 (degree 3), Boole (degree 4) | These are the interpolant degrees: 2, 3, 4 and 5 nodes per panel in the scripts | confirmed |
| D3 | Description | $T_n = h[\tfrac12 f_0+\sum f_i+\tfrac12 f_n]$ | The formula is standard, and `trapezoid_sum` implements it exactly | confirmed |
| D4 | Description | $S_n=\tfrac h3[f_0+f_n+4\sum f_{2k-1}+2\sum f_{2k}]$, n even | `simpson_sum` implements it. The sympy-derived weights are [1/3, 4/3, 1/3]·h | confirmed |
| D5 | Description | animations increase point density over the full interval between frames | The n_seq values are monotone increasing, and every frame covers [0,2] | confirmed |
| A1 | Animations intro | each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | Line 8–9 of all four scripts | confirmed |
| A2 | intro | each case shows a different closed NC construction | The scripts use 1-, 2-, 3- and 4-subinterval closed panels | confirmed |
| A3 | intro | $f'$ unbounded at 0, $f'\approx\tfrac{16}{3}x^{-1/3}$ | $f'=-e^{-x}\sin(\cdot)+e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}\to\tfrac{16}{3}x^{-1/3}$ | confirmed |
| A4 | intro | measured error of all four rules shrinks like $O(h^{5/3})$ | Ratios for n=1536→3072: 3.1720, 3.1754, 3.1755, 3.1752. $2^{5/3}=3.1748$ (`indep.out`) | confirmed |
| A5 | intro | halving 24→48 divides error by about 3.14, 3.38, 3.55, 3.15 | Computed 3.1415, 3.3803, 3.5499, 3.1513 | confirmed |
| A6 | intro | tending to $2^{5/3}\approx3.17$ for each | See A4; 3.1748 | confirmed |
| A7 | intro | instead of 4, 16, 16, 64 | These follow from the smooth orders 2, 4, 4, 6 (D-notes) | confirmed |
| A8 | intro | at equal h the higher-degree rules gain only a constant factor over the trapezoid | Error ratio to the trapezoid at n=24/48/96/384/1536: Simpson 0.308/0.286/0.281/0.277/0.276; 3/8 0.411/0.363/0.353/0.348/0.347; Boole 0.242/0.241/0.239/0.237/0.236. All approach constants | confirmed |
| C1-1 | Case 1 heading | Composite Trapezoidal Rule | `trapezoid_sum` is the composite trapezoid. It is exact for x^0 and x^1 and not for x^2 (err 0.333 at n=2) | confirmed |
| C1-2 | Case 1 Behavior | linear segments connect adjacent sample points; trapezoids refine as nodes get denser | Frames 2–25: a straight segment `[xl,xr]` with heights f(xl), f(xr), and n increases from 1 to 120 | confirmed |
| C1-3 | Case 1 alt | full-interval point density increases each frame and trapezoid approximation updates | Frames show 2→121 sample points and the label updates. The values match independent ones (see Impl.) | confirmed |
| C1-4 | Case 1 wiring | link `newtoncotesaa.jl`, embed `newtoncotesaa.gif` | The script writes `newtoncotesaa.gif`, and its title reads "Trapezoidal Rule". Byte-identical to the regenerated GIF | confirmed |
| C2-1 | Case 2 heading | Composite Simpson's Rule (1/3) | `simpson_sum` is exact through x^3 and not x^4 (err 1.667e-2 at n=4) | confirmed |
| C2-2 | Behavior | pairs of subintervals approximated by quadratics | The interpolant is fitted through 3 nodes `x0,x0+dx,x0+2dx`, stepping `i in 0:2:n-2` | confirmed |
| C2-3 | Behavior | visibly smoother top boundary than trapezoids | Frames (e.g. 5, 9, 13 points) show curved arcs against the straight trapezoid chords | confirmed |
| C2-4 | Behavior | stops at 41 sample points, as Mathews' Simpson animation does | The script's last n is 40 (41 points), and the last frame reads "Sample Points = 41". The legacy last frame also reads 41 | confirmed |
| C2-5 | Behavior | its last frame is less accurate than the 121-point last frames of the other cases | Errors: Simpson at 41 points 2.39e-3; trapezoid at 121 points 1.34e-3; 3/8 4.69e-4; Boole 3.19e-4 | confirmed |
| C2-6 | Behavior | at 41 points error 2.4e-3, smaller than trapezoid's 8.3e-3 | 2.3897e-3 and 8.2628e-3 | confirmed |
| C2-7 | Case 2 alt | opening frame shows only f; density increases each frame up to 41 points; red dots = sample points; vertical red lines = boundaries of the pairs; piecewise quadratic updates | Frame 1 shows only f. There are 21 frames (1 + 20 values of n). The dots are drawn at `a+i*dx`, and the dividers at `i in 0:2:n` (verified in frames 2, 3, 21) | confirmed |
| C2-8 | wiring | `newtoncotesbb.jl` / `.gif` | Correct file and title, and the GIF is byte-identical | confirmed |
| C3-1 | Case 3 heading | Composite Simpson's 3/8 Rule | `simpson38_sum` uses weights 3h/8·[1,3,3,2,…,3,3,1]. Sympy derives [3/8, 9/8, 9/8, 3/8]·h. Exact through x^3, not x^4 (err 7.407e-3 at n=6) | confirmed |
| C3-2 | Behavior | triplets of subintervals approximated by cubics | 4-node fit, stepping `i in 0:3:n-3` | confirmed |
| C3-3 | Behavior | higher-degree fit but not higher-order; both have degree of precision 3 | Sympy DOP = 3 for both. The script tests agree | confirmed |
| C3-4 | Behavior | error at same h larger, about 1.25 × Simpson 1/3 as h shrinks | E38/E13 = 1.270 (n=48), 1.258 (96), 1.2546 (384), 1.2542 (3072) | confirmed |
| C3-5 | alt | opening frame only f; up to 121 points; dots; dividers at triplet boundaries; piecewise cubic | There are 25 frames, and the last reads "Sample Points = 121". Dividers at `0:3:n` (frame 3 shows a divider at x=1 for n=6) | confirmed |
| C3-6 | wiring | `newtoncotescc.jl` / `.gif` | Correct, and the GIF is byte-identical | confirmed |
| C4-1 | Case 4 heading | Composite Boole's Rule | `boole_sum` uses weights 2h/45·[7,32,12,32,7]. Sympy derives [14/45, 64/45, 8/15, 64/45, 14/45]·h, which is the same. Exact through x^5, not x^6 (err 7.44e-4 at n=8) | confirmed |
| C4-2 | Behavior | blocks of four subintervals use quartic interpolation | 5-node fit, stepping `0:4:n-4` | confirmed |
| C4-3 | Behavior | as density rises, the piecewise quartic envelope tracks oscillations closely | At 5 and 9 points the frames show clear deviation. From 25 points on, the curve is visually on top of f, and the error falls from 4.6e-1 to 3.2e-4 | confirmed |
| C4-4 | alt | opening frame only f; up to 121 points; dots; dividers at the block boundaries; piecewise quartic | There are 25 frames, and the last reads 121. Dividers at `0:4:n` | confirmed |
| C4-5 | wiring | `newtoncotesdd.jl` / `.gif` | Correct, and the GIF is byte-identical | confirmed |
| L1 | Legacy note | each case uses the same rule, integrand and interval as Mathews' animation | The legacy frames show $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], titled Trapezoidal, Simpson's, Simpson's 3/8 and Boole's | confirmed |
| L2 | Legacy note | at every shared number of sample points, the approximations agree to six decimals | I read all legacy labels. There are 15 shared counts for the trapezoid (2, 3, 5, 7, 9, 11, 13, 15, 17, 21, 25, 29, 33, 41, 121), 20 for Simpson (3…41), 17 for 3/8 (4, 7, 10, 13, 16, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 85, 121) and 20 for Boole (5…41 by 4, 49…121 by 8). Each legacy value equals the script's value rounded to 6 decimals, e.g. trapezoid 121 → 2.014944, 3/8 121 → 2.015810, Boole 121 → 2.015961, Simpson 41 → 2.013890 | confirmed |
| N1 | Derivation Notes | interpolant degrees 1, 2, 3, 4; degrees of precision 1, 3, 3, 5 | Sympy exactness on monomials gives DOP 1, 3, 3, 5, and the script tests agree | confirmed |
| N2 | Notes | the even-subinterval rules (Simpson 1/3, Boole) gain one degree | 2 and 4 subintervals give DOP 3 and 5, against interpolant degrees 2 and 4 | confirmed |
| N3 | Notes | smooth errors $O(h^2), O(h^4), O(h^4), O(h^6)$ | Standard; this follows from N1 | confirmed |
| N4 | Notes | 3/8 constant $\tfrac1{80}(b-a)h^4|f^{(4)}|$ vs Simpson $\tfrac1{180}(b-a)h^4|f^{(4)}|$ | Checked with f=x^4 (f⁗=24) on [0,2]. Simpson n=4, h=1/2: predicted 2·(1/16)·24/180 = 1.6667e-2, script error 1.667e-2. 3/8 n=6, h=1/3: predicted 2·(1/81)·24/80 = 7.407e-3, script error 7.407e-3 | confirmed |
| N5 | Notes | rules of very high degree on wide panels can become less robust | The closed NC weights for m=8 (sympy) include negative values (−3712/14175, −3632/2835), which is the usual source of the non-robustness | confirmed |

### 3. Implementation checks

Common to all four scripts: the integrand is `exp(-x)*sin(8*x^(2/3))+1` with a=0, b=2. Julia's `x^(2/3)` for x=0.0 gives 0.0, so f(0)=1, which agrees with mpmath.

**Reference value.** None of the scripts draws an "exact" value. The page's error statements rest on $I$. I computed $I = 2.0162797196170963279$ in two ways: (a) by substituting $x=t^3$, which makes the integrand smooth, and (b) by direct mpmath quadrature split at 0.01, 0.1, 0.5 and 1. The two agree to 20 digits.

### `newtoncotesaa.jl` (composite trapezoid)
- **Method:** this is the standard composite trapezoid with uniform spacing. It is exact for degree ≤1 and has error 0.333 for x^2 at n=2.
- **Numbers:** the script's values for all 24 n match my independent mpmath values to rounding (max |diff| 5e-7, which is the precision I printed to). Examples, script vs independent: n=1: 2.0179248 vs 2.017925; n=40: 2.0080169 vs 2.008017; n=120: 2.0149445 vs 2.014944.
- **Reference:** none drawn.
- **Picture:** each trapezoid is a shape with vertices `(xl,0),(xr,0),(xr,f(xr)),(xl,f(xl))`, which is correct. The labels "Sample Points = n+1" and "Approximation" match the computed values (frames 2–25 checked on the contact sheet and in `early.png`). xlims (0,2) and ylims (0,2.1) contain all data, since f's max on the grid is 1.9198. There are 25 frames: 1 with only f, then 24.

### `newtoncotesbb.jl` (composite Simpson 1/3)
- **Method:** this is composite Simpson 1/3. The weights agree with the sympy derivation [1/3, 4/3, 1/3]. It is exact for degree ≤3 and not for 4.
- **Numbers:** all 20 frame values match the independent ones, e.g. n=40: script 2.0138900 vs 2.013890, and the error 2.390e-3 matches the page.
- **Picture:** the piecewise quadratic comes from a Vandermonde solve through the 3 panel nodes. Integrating that drawn interpolant exactly reproduces `simpson_sum` to 6.7e-16 in every frame, so the shaded area is the reported approximation. The dividers are at x_{2k}, and the dots are at all nodes. Over all frames the interpolants lie within 0.349 to 1.976, inside ylims (0, 2.1), so nothing is clipped. There are 21 frames, and the last reads 41.

### `newtoncotescc.jl` (composite Simpson 3/8)
- **Method:** this is composite 3/8. The weight pattern 3h/8·[1,3,3,2,3,3,…,1] agrees with the sympy [3/8, 9/8, 9/8, 3/8]·h. It is exact for degree ≤3 and not for 4 (err 7.407e-3, which agrees with the h⁴/80 constant).
- **Numbers:** all 24 values match the independent ones, e.g. n=120: script 2.0158104 vs 2.015810.
- **Picture:** the drawn cubic interpolants integrate to `simpson38_sum` within 2.7e-15. Their range over all frames is 0.201 to 1.940, so nothing is clipped. Dividers at x_{3k}. There are 25 frames, and the last reads 121.

### `newtoncotesdd.jl` (composite Boole)
- **Method:** this is composite Boole. The weights 2h/45·[7,32,12,32,7] equal the sympy [14, 64, 24, 64, 14]·h/45. It is exact for degree ≤5 and not for 6.
- **Numbers:** all 24 values match the independent ones, e.g. n=4: 1.5531547 vs 1.553155; n=120: 2.0159612 vs 2.015961.
- **Picture:** the drawn quartic interpolants integrate to `boole_sum` within 1.5e-14. Their range over all frames is 0.124 to 1.931, so nothing is clipped. Dividers at x_{4k}. There are 25 frames, and the last reads 121.

### Error-rate claims (page intro and Case 3)
These are from `indep.out` and are independent of the scripts. The script values agree with them, as shown above.

| rule | ratio n 24→48 | page | ratio n 1536→3072 |
|---|---|---|---|
| trapezoid | 3.1415 | 3.14 | 3.1720 |
| Simpson 1/3 | 3.3803 | 3.38 | 3.1754 |
| Simpson 3/8 | 3.5499 | 3.55 | 3.1755 |
| Boole | 3.1513 | 3.15 | 3.1752 |

$2^{5/3}=3.1748$. The ratio E(3/8)/E(1/3) at equal n tends to 1.2542, and the page says "about 1.25".

Nothing was left undetermined.

