# Newton-Cotes Integration — animation review (round 8)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Items I examined and decided are not findings:
- In the last frames of cases 2 and 3 the annotation reads `2.01389` and `2.01581`, because Julia's `round(...; digits=6)` drops the trailing zero. The values are correct (2.013890041, 2.015810411). This is cosmetic.
- Case 1 draws no red sample-point dots, but the legacy trapezoid GIF does. The page claims no dots for case 1. This is cosmetic.
- The case 1 alt text does not mention the opening frame, which shows only f. That frame exists (n = 0 in `vcat(0, n_seq)`). The omission is harmless.
- `NewtonCotesMod.html` also has the static Examples 1 and 2. They are not animations, and the page does not claim them. This is content the page does not yet have.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 8.6 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.0 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 9.0 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 9.3 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Description | NC formulas interpolate f on equally spaced nodes and integrate the interpolant on each panel | confirmed | In bb/cc/dd the area under the drawn interpolant equals the rule value to within 1.5e-14 (instrumented `polyarea`) |
| 2 | Description | trapezoidal (degree 1), Simpson 1/3 (degree 2), 3/8 (degree 3), Boole (degree 4) | confirmed | Interpolant degrees in the code: 2, 3, 4 and 5 nodes per panel |
| 3 | Description | $T_n = h[\tfrac12 f_0+\sum f_i+\tfrac12 f_n]$ | confirmed | Matches `trapezoid_sum`, and my independent values agree |
| 4 | Description | $S_n=\tfrac h3[f_0+f_n+4\sum f_{2k-1}+2\sum f_{2k}]$, n even | confirmed | Matches `simpson_sum` (odd 1:2:n-1, even 2:2:n-2) |
| 5 | Description | "increasing point density over the full interval between frames" | confirmed | Frames |
| 6 | Intro | Each case uses $f=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | confirmed | Line 8 and `a,b` in all four scripts |
| 7 | Intro | Each case shows a different closed NC construction while density increases | confirmed | Scripts and frames |
| 8 | Intro | $f'$ is unbounded at 0, $f'\approx\tfrac{16}{3}x^{-1/3}$ | confirmed | $f'=-e^{-x}\sin(\cdot)+e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}$, which tends to $\tfrac{16}{3}x^{-1/3}$ |
| 9 | Intro | Measured error of all four rules is $O(h^{5/3})$ | confirmed | Error ratios at successive halvings tend to 3.168, 3.180, 3.182, 3.178 (n = 192→384) |
| 10 | Intro | Halving h from 24 to 48 subintervals divides the error by about 3.14, 3.38, 3.55, 3.15 | confirmed | 3.1415, 3.3803, 3.5499, 3.1513 |
| 11 | Intro | Ratios tend to $2^{5/3}\approx3.17$ | confirmed | $2^{5/3}=3.1748$, and the ratios in row 9 approach it |
| 12 | Intro | At equal h, the higher-degree rules gain only a constant factor | confirmed | All four errors scale as $h^{5/3}$. At n = 120 the errors are 1.34e-3, 3.73e-4, 4.69e-4, 3.19e-4 |
| 13 | Case 1 | Linear segments connect adjacent samples, and the trapezoids refine | confirmed | Frames, `plot!` shapes |
| 14 | Case 1 link/embed | `newtoncotesaa.jl` / `.gif` is the trapezoid case | confirmed | Title "Trapezoidal Rule". Committed GIF is byte-identical to regen |
| 15 | Case 1 alt | Density increases each frame, approximation updates | confirmed | 25 frames: opening frame, then 2…121 points |
| 16 | Case 2 | Pairs of subintervals are approximated by quadratics | confirmed | `poly_coeffs` on 3 nodes per panel. Nodal residual ≤ 2e-15 |
| 17 | Case 2 | Stops at 41 sample points, as Mathews' Simpson animation does | confirmed | `n_seq` ends at 40. Legacy Simpsonaa.gif ends at "Sample Points = 41" |
| 18 | Case 2 | Its last frame is less accurate than the 121-point last frames of the other cases | confirmed | 2.39e-3 against 1.34e-3, 4.69e-4, 3.19e-4 |
| 19 | Case 2 | Simpson error at 41 points is $2.4\times10^{-3}$ | confirmed | \|2.013890041 − 2.016279720\| = 2.3897e-3 |
| 20 | Case 2 | Trapezoid error at 41 points is $8.3\times10^{-3}$ | confirmed | \|2.008016895 − I\| = 8.2628e-3 |
| 21 | Case 2 | "visibly smoother top boundary than trapezoids" | confirmed | Frames (qualitative) |
| 22 | Case 2 alt | Opening frame shows only f. Density rises to 41 points. Red dots mark samples. Vertical red lines mark pair boundaries | confirmed | 21 frames. Dividers drawn at `0:2:n` only. Dots at all nodes |
| 23 | Case 2 link/embed | `newtoncotesbb` is Simpson 1/3 | confirmed | Title "Simpson's Rule", `simpson_sum` |
| 24 | Case 3 | Triplets of subintervals are approximated by cubics | confirmed | 4 nodes per panel. Nodal residual ≤ 1.3e-14 |
| 25 | Case 3 | Both 1/3 and 3/8 have degree of precision 3 | confirmed | Exact-rational moment test: both exact for $x^0..x^3$, not for $x^4$ |
| 26 | Case 3 | Error at the same h is about 1.25 times the Simpson 1/3 error as h shrinks | confirmed | Ratio 1.334 (n=24), 1.270 (48), 1.258 (96), 1.2553 (192), 1.2546 (384), 1.2544 (768) |
| 27 | Case 3 alt | Opening frame. Up to 121 points. Dots. Triplet-boundary lines | confirmed | 25 frames. `n_seq` ends at 120. Dividers at `0:3:n` |
| 28 | Case 3 link/embed | `newtoncotescc` is Simpson 3/8 | confirmed | Title and `simpson38_sum` |
| 29 | Case 4 | Blocks of four subintervals use quartic interpolation | confirmed | 5 nodes per panel. Nodal residual ≤ 5.5e-14 |
| 30 | Case 4 | The quartic envelope tracks the oscillations closely as density rises | confirmed | Frames from 13 points onward |
| 31 | Case 4 alt | Opening frame. Up to 121 points. Dots. Block-boundary lines | confirmed | 25 frames. Dividers at `0:4:n` |
| 32 | Case 4 link/embed | `newtoncotesdd` is Boole | confirmed | Title and `boole_sum` |
| 33 | Legacy note | Same rule, integrand and interval as Mathews' animation of each rule | confirmed | Legacy frame titles read $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], one GIF per rule |
| 34 | Legacy note | At every shared number of sample points, the approximations agree to six decimals | confirmed | All shared counts were compared (see §3): trap 15, S1/3 20, S3/8 16, Boole 20. All agree in every printed digit |
| 35 | Derivation | Interpolant degrees 1–4, degrees of precision 1, 3, 3, 5 | confirmed | Moment test (sympy weights, exact) |
| 36 | Derivation | Even-subinterval rules are exact one degree beyond their interpolant | confirmed | Same test |
| 37 | Derivation | Under smoothness $C^2,C^4,C^4,C^6$, errors are $O(h^2),O(h^4),O(h^4),O(h^6)$ | confirmed | Standard result, consistent with the degrees of precision |
| 38 | Derivation | Composite $\|E\|=\tfrac1{80}(b-a)h^4\|f^{(4)}\|$ (3/8) and $\tfrac1{180}(b-a)h^4\|f^{(4)}\|$ (1/3) | confirmed | Exact-rational test on $x^4$ over [0,1], n = 6, 12, 24: $E/(24h^4)=-1/80$ and $-1/180$ exactly |

### 3. Implementation checks

Reference integral: $I=\int_0^2 f = 2.0162797196170963279$. I computed it with mpmath at 40 digits after substituting $x=t^3$ to remove the singularity, and cross-checked it with a direct 40-subinterval mpmath quad (difference 5e-41).

Independent weights: I solved the moment equations exactly with sympy. They give [1/2,1/2], [1/3,4/3,1/3], [3/8,9/8,9/8,3/8] and [14/45,64/45,8/15,64/45,14/45]. The scripts use the same weights (Boole: 2h/45·(7,32,12,32,7)).

The scratch copies (`review/inst/nc{aa,bb,cc,dd}.jl`) stop before the `@animate` loop and print every `n_seq` value. The manifest reports the committed GIFs byte-identical to regenerated output, so these are the values in the frames.

### newtoncotesaa.jl (Composite trapezoidal)
- **Method:** composite trapezoidal, correct.
- **Numbers:** all 24 values agree with mpmath to about 1e-15. Examples: 2 pts 2.017924816 (both), 41 pts 2.008016895 (both), 121 pts 2.014944465 (both).
- **Reference values:** none drawn.
- **Picture:** trapezoids span [x_i, x_{i+1}] with heights f(x_i) and f(x_{i+1}). The label "Sample Points = n+1" is correct. The last frame reads 2.014944. Frames 2, 3, 6 and 25 were viewed.
- **Legacy, shared counts** (legacy = page): 2: 2.017925, 3: 2.372927, 5: 1.802071, 7: 1.855188, 9: 1.906595, 11: 1.937765, 13: 1.957234, 15: 1.970106, 17: 1.979056, 21: 1.990397, 25: 1.997086, 29: 2.001387, 33: 2.004331, 41: 2.008017, 121: 2.014944.

### newtoncotesbb.jl (Composite Simpson 1/3)
- **Method:** composite Simpson 1/3, correct.
- **Numbers:** all 20 values agree with mpmath. Examples: 3 pts 2.491261017, 41 pts 2.013890041.
- **Picture:** the area of the drawn quadratics equals `simpson_sum` to within 7e-16, and they pass through the nodes (residual ≤ 2e-15). Dividers are at even nodes only. With xlims (−0.03, 2.03) the end dots are not clipped. Frames viewed: 2, sheet, and 21.
- **Legacy, all 20 counts 3…41** agree, for example 7: 1.840560, 25: 2.010370, 41: 2.013890.

### newtoncotescc.jl (Composite Simpson 3/8)
- **Method:** composite 3/8, correct. Interior non-multiples of 3 get weight 3, multiples get weight 2, and the prefactor is 3h/8.
- **Numbers:** all 24 values agree with mpmath. Examples: 4 pts 1.884214099, 121 pts 2.015810411.
- **Picture:** the area under the cubics equals the rule value to within 3e-15, with nodal residual ≤ 1.3e-14. Dividers are at `0:3:n`.
- **Legacy, shared counts:** 4: 1.884214, 7: 1.790470, 10: 1.927234, 13: 1.976629, 16: 1.994094, 19: 2.001834, 25: 2.008397, 31: 2.011141, 37: 2.012595, 43: 2.013477, 49: 2.014059, 55: 2.014468, 61: 2.014767, 67: 2.014994, 73: 2.015170, 85: 2.015425, 121: 2.015810. All agree.

### newtoncotesdd.jl (Composite Boole)
- **Method:** composite Boole, correct.
- **Numbers:** all 24 values agree with mpmath. Examples: 5 pts 1.553154683, 121 pts 2.015961179.
- **Picture:** the area under the quartics equals the rule value to within 1.5e-14, with nodal residual ≤ 5.5e-14. Dividers are at `0:4:n`. In the 5-point frame the quartic dips to about 0.12, which stays inside ylims (0, 2.1). Nothing is clipped.
- **Legacy, all 20 legacy counts 5…121** agree, for example 9: 1.963413, 41: 2.014287, 117: 2.015943 (not in legacy), 121: 2.015961.

### Convergence data (independent, mpmath)
| rule | err(n=24) | err(n=48) | 24→48 | 48→96 | 96→192 | 192→384 |
|---|---|---|---|---|---|---|
| trap | −1.9194e-2 | −6.1098e-3 | 3.1415 | 3.1583 | 3.1647 | 3.1679 |
| S1/3 | −5.9101e-3 | −1.7484e-3 | 3.3803 | 3.2214 | 3.1887 | 3.1801 |
| S3/8 | −7.8827e-3 | −2.2205e-3 | 3.5499 | 3.2524 | 3.1953 | 3.1819 |
| Boole | −4.6354e-3 | −1.4709e-3 | 3.1513 | 3.1814 | 3.1805 | 3.1780 |

Commands: `python3 -I review/indep.py` (output in `review/indep.out`), `python3 -I review/errconst.py`, `julia review/inst/nc{aa,bb,cc,dd}.jl`. Legacy frame text was read from the crops in `review/l_*.png`.

