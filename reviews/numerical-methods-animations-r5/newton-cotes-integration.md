# Newton-Cotes Integration — animation review (round 5)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. Each script runs the rule it names, and its displayed numbers are right to the six decimals shown.

Observations that are not findings (recorded so the clean result can be trusted, not as requested changes):

- `newtoncotesaa.jl` draws no sample-point dots. The other three scripts draw them, and so does Mathews' trapezoidal GIF. The page makes no claim about dots for Case 1, and the trapezoid vertices are visible as line corners, so nothing is misleading.
- The annotations use `round(approx; digits=6)`, which drops trailing zeros. Examples: "2.01389" (bb, 41 points, true 2.0138900), "2.01581" (cc, 121), "2.01017" (aa, 49), "2.01037" (bb, 25). The values are correct. This is cosmetic only.
- Mathews' module has 7 worked examples (exercises with other integrands, and degree-of-precision proofs). These are not animations, and the page's Animations section covers all four of Mathews' Newton-Cotes animations (Trapezoidal, Simpson, Simpson 3/8, Boole). No animated case is dropped.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 8.3 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.4 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 9.3 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 8.3 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Values marked "mine" come from `indep.out`. Values marked "script" come from `inst_*.out`.

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Newton-Cotes formulas interpolate f on equally spaced nodes and integrate the interpolating polynomial on each panel | bb/cc/dd fit the polynomial through 3/4/5 equally spaced nodes per panel (`poly_coeffs`). The rule weights I derived by integrating the Lagrange basis equal the coded weights. | confirmed |
| 2 | Description | Trapezoidal (degree 1), Simpson 1/3 (degree 2), 3/8 (degree 3), Boole (degree 4) | These are interpolant degrees, and the Derivation Notes say so explicitly. The scripts fit degrees 1/2/3/4. | confirmed |
| 3 | Description | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$ | Matches `trapezoid_sum` (aa:18-22). My values with weights [1/2,1/2] agree with the script to all printed digits. | confirmed |
| 4 | Description | $S_n = \tfrac h3[f(x_0)+f(x_n)+4\sum f(x_{2k-1})+2\sum_{k=1}^{n/2-1} f(x_{2k})]$, n even | Matches `simpson_sum` (bb:25-30), with odd indices 1:2:n-1 and even indices 2:2:n-2. Agrees with my Lagrange-derived [1/3,4/3,1/3]. | confirmed |
| 5 | Description | Animations increase point density over the full interval between frames | Every `n_seq` is strictly increasing over the whole of [0,2] (aa 1→120, bb 2→40, cc 3→120, dd 4→120) | confirmed |
| 6 | Animations intro | Each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | Line 8 of every script; `a, b = 0.0, 2.0`. The magenta curve in the frames matches (max 1.92, min 0.357 by sampling). | confirmed |
| 7 | intro | Each case shows a different closed Newton-Cotes construction | Trap, S1/3, S3/8, Boole, all using endpoints of each panel | confirmed |
| 8 | intro | Sample density increases frame by frame | Strictly increasing `n_seq` in all four scripts. The frame annotations read 2…121, 3…41, 4…121 and 5…121. | confirmed |
| 9 | intro | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | mpmath: f'(1e-9) = 5333.33332, (16/3)(1e-9)^{-1/3} = 5333.33333 | confirmed |
| 10 | intro | Textbook order does not hold. Measured error of all four shrinks like $O(h^{5/3})$, not $h^2,h^4,h^4,h^6$ | Halving ratios at fine h: trap 3.1720, S1/3 3.1754, S3/8 3.1755, Boole 3.1752 (n 1536→3072), against 2^{5/3} = 3.1748 | confirmed |
| 11 | intro | Halving h from 24 to 48 subintervals divides the error by about 3.14, 3.38, 3.55, 3.15 | Mine: 3.14152, 3.38032, 3.54990, 3.15132 | confirmed |
| 12 | intro | These ratios tend to $2^{5/3}\approx3.17$ for each | See #10 | confirmed |
| 13 | intro | At equal h the higher-degree rules gain only a constant factor over trapezoidal | All four have the same asymptotic ratio 3.17. Error ratios to trapezoidal settle, e.g. S3/8/S1/3 → 1.254 (#22). | confirmed |
| 14 | Case 1 heading/link/embed | Composite trapezoidal: `newtoncotesaa.jl`, `newtoncotesaa.gif` | Script title "Trapezoidal Rule". The GIF is byte-identical to a fresh run (manifest). | confirmed |
| 15 | Case 1 Behavior | Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser | aa:38-41 draws a shape from (xl,0) to (xr,f(xr)) and (xl,f(xl)). The frames show this, refining from 2 to 121 points. | confirmed |
| 16 | Case 1 alt | Full-interval point density increases each frame, and the trapezoid approximation updates | 25 frames: an opening f-only frame, then 24 refinements, each with an updated "Approximation" | confirmed |
| 17 | Case 2 heading/link/embed | Composite Simpson 1/3: `newtoncotesbb.jl` / `.gif` | Correct wiring. The GIF matches a fresh run. | confirmed |
| 18 | Case 2 Behavior | Pairs of subintervals are approximated by quadratics, giving a smoother top boundary than trapezoids | bb:40-54 fits a degree-2 polynomial on [x_{2k}, x_{2k+2}]. The frames show curved panel tops through the 3 red dots. | confirmed |
| 19 | Case 2 Behavior | Stops at 41 sample points, as Mathews' Simpson animation does | `n_seq` ends at 40, and the last frame reads "Sample Points = 41". Mathews' Simpsonaa.gif ends at "Sample Points = 41". | confirmed |
| 20 | Case 2 Behavior | Its last frame is less accurate than the 121-point last frames of the other cases | Errors: S1/3 at 41 points 2.390e-3. At 121 points: trap 1.335e-3, S3/8 4.69e-4, Boole 3.19e-4. | confirmed |
| 21 | Case 2 Behavior | At 41 points its error (2.4e-3) is smaller than the trapezoidal rule's (8.3e-3) | Mine: S1/3 2.38968e-3, trap 8.26282e-3 | confirmed |
| 22 | Case 2 alt | Opening frame shows only f. Density rises each frame to 41 points. Red dots mark sample points. Vertical red lines mark pair boundaries. The piecewise quadratic area updates. | frame_001 is f only. 21 frames. Dots at all n+1 nodes (bb:71-72). Dividers at x_{2k} (bb:57-60), visible in the frames. | confirmed |
| 23 | Case 3 heading/link/embed | Composite Simpson 3/8: `newtoncotescc.jl` / `.gif` | Correct | confirmed |
| 24 | Case 3 Behavior | Triplets of subintervals approximated by cubics | cc:40-55 fits a cubic on [x_{3k}, x_{3k+3}] | confirmed |
| 25 | Case 3 Behavior | Higher-degree fit, but both have degree of precision 3 | Degree-of-precision probe on the script's own `simpson38_sum` and `simpson_sum`: exact for x^0..x^3, error 0.1185 and 0.2667 for x^4 (n=3 and n=2) | confirmed |
| 26 | Case 3 Behavior | On this integrand the 3/8 error at the same h is larger, about 1.25 times the 1/3 error as h shrinks | Ratio E38/E13 at n = 24, 48, 96, 192, 768, 3072: 1.334, 1.270, 1.258, 1.255, 1.2544, 1.2542 | confirmed |
| 27 | Case 3 alt | Opening f-only frame. Up to 121 points. Dots at sample points. Lines at triplet boundaries. Cubic area updates. | frame_001 is f only. The last frame reads "Sample Points = 121". Dividers at x_{3k} (cc:58-61). | confirmed |
| 28 | Case 4 heading/link/embed | Composite Boole: `newtoncotesdd.jl` / `.gif` | Correct | confirmed |
| 29 | Case 4 Behavior | Blocks of four subintervals use quartic interpolation | dd:49-65 fits a degree-4 polynomial on [x_{4k}, x_{4k+4}]. The `boole_sum` weights (2h/45)(7,32,12,32,7) equal the Lagrange-derived [14/45, 64/45, 8/15, 64/45, 14/45]. | confirmed |
| 30 | Case 4 Behavior | As density rises, the quartic envelope tracks the oscillations closely | Frames from 25 points on: the red envelope is indistinguishable from the magenta curve. Boole error falls from 0.463 (5 pts) to 3.2e-4 (121 pts). | confirmed |
| 31 | Case 4 alt | Opening f-only frame. Up to 121 points. Dots. Lines at block boundaries. Quartic area updates. | frame_001 is f only. Last frame "121". Dividers at x_{4k} (dd:68-71). | confirmed |
| 32 | Legacy note | Each case uses the same rule, integrand and interval as Mathews' animation of that rule | All four Mathews GIFs are titled $y=e^{-x}\sin(8x^{2/3})+1$, with x-axis 0..2 and the same rule names | confirmed |
| 33 | Legacy note | At every number of sample points the two share, the approximations agree to six decimals | Compared every shared count. Trap: 15 shared (2,3,5,…,41,121). S1/3: all 20 (3..41). S3/8: 17 shared (4,7,10,13,16,19,25,31,37,43,49,55,61,67,73,85,121). Boole: 20 shared (5..41 step 4, 49..121 step 8). All agree to 6 decimals, e.g. S3/8 at 121: 2.015810 vs 2.015810; Boole at 121: 2.015961 vs 2.015961. | confirmed |
| 34 | Derivation | Degrees of precision are 1, 3, 3, 5. The even-panel rules gain one degree. | Probe on the script routines: trap fails at x^2, S1/3 at x^4, S3/8 at x^4, Boole at x^6 (exact through x^5 to 2e-15) | confirmed |
| 35 | Derivation | For smooth f ($C^2,C^4,C^4,C^6$) the composite errors are $O(h^2),O(h^4),O(h^4),O(h^6)$ | Standard theory, consistent with the degrees of precision in #34 | confirmed |
| 36 | Derivation | Composite $\lvert E\rvert = \tfrac1{80}(b-a)h^4\lvert f^{(4)}\rvert$ (3/8) and $\tfrac1{180}(b-a)h^4\lvert f^{(4)}\rvert$ (1/3) | sympy: single-panel error for x^4 (h=1) is -4/15 (1/3) and -9/10 (3/8). Dividing by 4! = 24 and by the panel length gives 1/180 and 1/80. | confirmed |
| 37 | Derivation | Rules of very high degree on wide panels can become less robust | A general qualitative statement, not checkable against this page's computations | not applicable (qualitative) |

### 3. Implementation checks

Reference integral (used for every error above): substituting $x=u^3$ removes the singularity, and the integral becomes $\int_0^{2^{1/3}} (e^{-u^3}\sin 8u^2 + 1)\,3u^2\,du$. Both this form and direct `mp.quad` on 40 subintervals give **I = 2.016279719617096327887…**. The scripts draw no exact reference, so this value is used only for my error claims.

### `newtoncotesaa.jl` — composite trapezoidal
- **Is the method it claims:** yes. `trapezoid_sum` is $h[\tfrac12 f_0+\sum f_i+\tfrac12 f_n]$. The probe gives exact results for x^0 and x^1, and error 1.3333 for x^2 at n=1, so the degree of precision is 1.
- **Numbers:** every frame's value matches my independent computation to about 1e-15. Examples (script / mine): n=1 2.017924816215668 / 2.0179248162156685; n=24 1.9970856958540892 / 1.9970856958540893; n=120 2.0149444646203434 / 2.0149444646203433.
- **Reference values:** none drawn.
- **Picture:** trapezoids span from (x_i,0) to (x_i,f(x_i)) and (x_{i+1},f(x_{i+1})). Annotations read Sample Points = n+1 and the computed approximation, both checked against the frames (e.g. frame 2: "2", "2.017925"; last frame: "121", "2.014944"). The axes (0..2, 0..2.1) contain f (range 0.357..1.920). 25 frames.

### `newtoncotesbb.jl` — composite Simpson 1/3
- **Method:** `simpson_sum` matches the page's $S_n$. The probe gives exact results for x^0..x^3, and errors 0.2667 for x^4 at n=2 and 0.01667 at n=4 (ratio 16, as expected for h^4). The degree of precision is 3.
- **Numbers:** n=2 2.4912610172534464 (both). n=40: script 2.0138900411352303, mine 2.0138900411352307. All 20 frames agree to about 1e-15.
- **Picture:** each panel's quadratic comes from a Vandermonde solve through its 3 nodes and passes through the red dots (checked in frames 2, 6 and 21). Dividers fall at x_{2k}. The interpolant extremes over all frames lie in [0.41, 1.97], so nothing is clipped by ylims (0, 2.1). 21 frames.

### `newtoncotescc.jl` — composite Simpson 3/8
- **Method:** `simpson38_sum` uses weight 3 on non-multiples of 3, 2 on interior multiples of 3, 1 on the ends, times 3h/8. This is the composite of the Lagrange-derived [3/8, 9/8, 9/8, 3/8]. The probe gives exact results for x^0..x^3 (within 4e-16), and errors 0.1185 and 0.00741 for x^4 (ratio 16). The degree of precision is 3.
- **Numbers:** n=3 1.8842140994188474 / …473. n=120 2.015810410863725 / 2.0158104108637248. All 24 frames agree to about 1e-15.
- **Picture:** the cubics pass through 4 dots per panel. Dividers fall at x_{3k}. Interpolant extremes lie in [0.28, 1.38] for the coarse frames and are never clipped. 25 frames.

### `newtoncotesdd.jl` — composite Boole
- **Method:** the coded weights (2h/45)(7,32,12,32,7) equal the Lagrange-derived [14/45, 64/45, 8/15, 64/45, 14/45]·h. The probe gives exact results for x^0..x^5 (within 2e-15), and errors 0.04762 and 7.44e-4 for x^6 (ratio 64, as expected for h^6). The degree of precision is 5.
- **Numbers:** n=4 1.5531546827403782 / …781. n=120 2.0159611788705827 / …829. All 24 frames agree.
- **Picture:** the quartics pass through 5 dots per panel. The 5-point frame's quartic dips to 0.124 near x ≈ 0.28, still above the axis. Dividers fall at x_{4k}. 25 frames.

### Rendering
The manifest reports each committed GIF byte-identical to a fresh scratch run, so the frames reflect the current code.

### Legacy comparison (Mathews `a2001/Animations/Quadrature`)
Mathews' four GIFs use the same integrand, interval and rules. His point sequences differ in part. For example, his trapezoidal GIF uses 51, 61, 71, 81 and 101 points, which the script does not. The script uses 4, 6, 8, 49, 57, 65, 73, 89 and 105, which Mathews does not. At every shared count, his six-decimal values equal the scripts' (claim #33). His Simpson 1/3 animation stops at 41 points, as the page says.

