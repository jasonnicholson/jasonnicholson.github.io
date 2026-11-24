# Newton-Cotes Integration — animation review (round 9)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. I found no implementation error, no page mismatch and no fidelity departure that matters to a reader.

Observations that I judged **not** to be findings (listed so the owner can see they were considered):

- `round(approx; digits=6)` drops trailing zeros, so some frames show five decimals: "2.01017" (n=48, trapezoidal), "2.01037" (n=24, Simpson), "2.01389" (n=40, Simpson), "2.01581" (n=120, 3/8), "2.01268" and "2.01537" (Boole). The values are right, and Mathews prints "2.010370" and so on. This is cosmetic and does not mislead.
- The trapezoidal GIF draws no red sample-point dots, although Mathews' does. The page does not claim that it does: Case 1's alt text and Behavior mention no dots.
- The trapezoidal sequence is not monotone in its early frames. n=1 gives 2.017925 (error 1.6e-3) and n=2 gives 2.372927 (error 0.357). The page makes no claim of monotone improvement, and Mathews' animation shows the same values.
- The sample-point sequences differ from Mathews' in places. For example, the page's trapezoidal sequence has 4, 6, 8, 49, 57, ... points where Mathews has 51, 61, 71, 81, 101. The page claims agreement only "at every number of sample points the two share", and that claim holds.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 8.8 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 7.9 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 9.0 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 8.6 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Reference integral: I = ∫₀² (e^{-x} sin(8x^{2/3}) + 1) dx = **2.0162797196170963**. I got this three ways that agree: mpmath with the substitution x=t³ (40 digits), mpmath tanh-sinh on 20 subintervals, and scipy `quad` with the substitution (2.0162797196170965).

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton-Cotes "interpolating f on equally spaced nodes and integrating the interpolating polynomial on each panel" | All 4 scripts use uniform nodes. bb/cc/dd draw the Vandermonde interpolant per panel, which reproduces the nodes to ≤5e-14. The drawn area equals the rule value to 6 decimals in every frame (`inst.out`). | confirmed |
| D2 | trapezoidal (degree 1), Simpson 1/3 (2), 3/8 (3), Boole (4) | These are the interpolant degrees per panel. The panels have 2, 3, 4 and 5 nodes in the code. | confirmed |
| D3 | T_n = h[½f(x₀)+Σf(xᵢ)+½f(xₙ)] | Matches `trapezoid_sum`. The weights I derived symbolically (sympy, integrating the Lagrange basis) are [1/2, 1/2]. | confirmed |
| D4 | S_n = h/3[f₀+fₙ+4Σf(x_{2k-1})+2Σf(x_{2k})], n even | Matches `simpson_sum`. The derived weights are [1/3, 4/3, 1/3]. | confirmed |
| D5 | "follow the legacy style by increasing point density over the full interval between frames" | The `n_seq` arrays increase, and every frame covers [0,2]. This matches Mathews' GIFs. | confirmed |
| A1 | "Each case uses f(x)=e^{-x}sin(8x^{2/3})+1 on [0,2]" | Line 8–9 of all four scripts. Mathews' frames are labelled y = e^{-x} sin(8x^{2/3})+1 on [0,2]. | confirmed |
| A2 | "shows a different closed Newton-Cotes construction while sample density increases frame by frame" | Four rules, all closed, with increasing n. | confirmed |
| A3 | "f'(x)≈(16/3)x^{-1/3} near 0", f' unbounded | d/dx[e^{-x}sin(8x^{2/3})] = e^{-x}[(16/3)x^{-1/3}cos(8x^{2/3}) − sin(8x^{2/3})] → (16/3)x^{-1/3} as x→0 | confirmed |
| A4 | "measured error of all four rules shrinks like O(h^{5/3})" | Successive-halving ratios at 768→1536 are 3.171, 3.176, 3.176 and 3.176, against 2^{5/3}=3.1748 | confirmed |
| A5 | "halving h (from 24 to 48 subintervals) divides it by about 3.14, 3.38, 3.55 and 3.15" | Computed: 3.14152, 3.38032, 3.54990, 3.15132 | confirmed |
| A6 | "tending to 2^{5/3}≈3.17 for each, instead of 4, 16, 16 and 64" | 2^{5/3}=3.1748. The table of ratios in A4 converges to it. | confirmed |
| A7 | "at equal h the higher-degree rules gain only a constant factor over the trapezoidal rule" | Error ratios at fixed n stay bounded. At n=120: trap/3/8 = 1.335e-3/4.69e-4 = 2.8 and trap/Boole = 4.2. At n=48: trap/Simpson = 3.5. | confirmed |
| C1a | Case 1: "Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser" | Code lines 38–41 build each trapezoid from f(xl) and f(xr). The frames show this. | confirmed |
| C1b | Case 1 alt: "full-interval point density increases each frame and trapezoid approximation updates" | 25 frames: f alone, then n=1..120. The annotation updates each frame. | confirmed |
| C1c | Case 1 wiring: link and embed point to `newtoncotesaa.jl`/`.gif`, which is the trapezoidal rule | GIF title "Trapezoidal Rule". The committed GIF is byte-identical to the regenerated one (manifest). | confirmed |
| C2a | Case 2: "Pairs of subintervals are approximated by quadratics" | Lines 40–54 fit a 3-node quadratic over [x_{2k}, x_{2k+2}] | confirmed |
| C2b | "visibly smoother top boundary than trapezoids" | Compared frames of the two sheets at matching point counts | confirmed |
| C2c | "stops at 41 sample points, as Mathews' Simpson's rule animation does" | n_seq ends at 40. Mathews' last frame reads "Sample Points = 41, Approximation = 2.013890". | confirmed |
| C2d | "its last frame is less accurate than the 121-point last frames of the other cases" | Simpson at 41 points: error 2.39e-3. At 121 points: trapezoidal 1.335e-3, 3/8 4.69e-4, Boole 3.19e-4. | confirmed |
| C2e | "at 41 points its error (2.4×10⁻³) is smaller than the trapezoidal rule's (8.3×10⁻³)" | Simpson n=40: −2.390e-3. Trapezoidal n=40: −8.263e-3. | confirmed |
| C2f | Alt: "after an opening frame showing only f, density increases each frame up to 41 sample points; red dots mark the sample points, vertical red lines mark the boundaries of the pairs of subintervals, and the piecewise quadratic area approximation updates" | Frame 1 shows f only, and the GIF has 21 frames. `scatter!` draws the dots at all xᵢ, and the dividers sit at x_{2k} (lines 57–60). I checked these in the frames. | confirmed |
| C2g | Wiring: `newtoncotesbb.jl`/`.gif` is Simpson 1/3 | GIF title "Simpson's Rule", and the code is 1/3 | confirmed |
| C3a | Case 3: "Triplets of subintervals are approximated by cubics" | Lines 40–55 fit a 4-node cubic over [x_{3k}, x_{3k+3}] | confirmed |
| C3b | "not a higher-order rule: both have degree of precision 3" | I applied the script's own `simpson38_sum` and `simpson_sum` to x^p. Both are exact through p=3 (error ≤4e-16) and fail at p=4. | confirmed |
| C3c | "its error at the same h is larger, about 1.25 times Simpson's 1/3 error as h shrinks" | Ratio E₃/₈/E₁/₃ at n=48, 96, 192, 384, 768 and 1536: 1.270, 1.258, 1.255, 1.2546, 1.2544, 1.2542 | confirmed |
| C3d | Alt: "...up to 121 sample points; red dots ..., vertical red lines mark the boundaries of the triplets ..., piecewise cubic" | n_seq ends at 120, the dividers sit at x_{3k}, and the frames match | confirmed |
| C3e | Wiring: `newtoncotescc` is 3/8 | GIF title "Simpson's 3/8 Rule" | confirmed |
| C4a | Case 4: "Blocks of four subintervals use quartic interpolation" | Lines 49–65 fit a 5-node quartic | confirmed |
| C4b | "As density rises, the piecewise quartic envelope tracks oscillations closely" | Frames from 25 points onward show the interpolant indistinguishable from f | confirmed |
| C4c | Alt: "...up to 121 sample points; red dots...; vertical red lines mark the boundaries of the blocks of four...; piecewise quartic" | n_seq ends at 120, the dividers sit at x_{4k}, and frame 1 shows f only | confirmed |
| C4d | Wiring: `newtoncotesdd` is Boole | GIF title "Boole's Rule". The derived weights (2h/45)[7, 32, 12, 32, 7] = h[14/45, 64/45, 8/15, 64/45, 14/45] match. | confirmed |
| L1 | "each case uses the same rule, integrand and interval as Mathews' animation of that rule" | I compared the frames of all four legacy GIFs | confirmed |
| L2 | "at every number of sample points the two share, the approximations agree to six decimals" | I read every legacy frame. Trapezoidal shares 15 counts (2, 3, 5, 7, 9, 11, 13, 15, 17, 21, 25, 29, 33, 41, 121), Simpson 20 (3..41), 3/8 17 and Boole 20. All of them agree to six decimals. For example, Boole at 29 points: legacy 2.012680, page 2.01268 (2.0126802231). | confirmed |
| P1 | Degrees of precision 1, 3, 3, 5; "rules with an even number of subintervals per panel ... are exact for one degree more" | The script rules applied to x^p on [0,2] first fail at p=2, 4, 4 and 6 (`dop_*.jl`) | confirmed |
| P2 | For smooth f, errors O(h²), O(h⁴), O(h⁴), O(h⁶), with C², C⁴, C⁴, C⁶ | These are the standard composite results. They agree with P1 and P3. | confirmed |
| P3 | Composite error constants: 3/8 has (b−a)h⁴f⁽⁴⁾/80, Simpson 1/3 has (b−a)h⁴f⁽⁴⁾/180 | For f=x⁴ (f⁽⁴⁾=24) on [0,2], Simpson with n=4 (h=1/2) predicts 2·(1/16)·24/180 = 0.016667, and the script gives 0.016667. The 3/8 rule with n=6 (h=1/3) predicts 2·(1/81)·24/80 = 0.0074074, and the script gives 0.0074074. | confirmed |
| P4 | "Rules of very high degree on wide panels can become less robust" | A qualitative statement with nothing specific to check | could not determine (not quantitative) |

### 3. Implementation checks

Instrumented copies are `review/inst_{aa,bb,cc,dd}.jl` (they print every frame's approximation and check the drawn interpolant) and `review/dop_{aa,bb,cc,dd}.jl` (degree-of-precision test with the script's own sum function). The independent computation is `review/indep.py`: mpmath at 40 digits, with Newton-Cotes weights derived in sympy by integrating Lagrange basis polynomials, so it does not depend on remembered coefficient tables.

### newtoncotesaa.jl (composite trapezoidal)
- **Method:** The code is the composite trapezoidal rule h[½f₀ + Σ interior + ½fₙ]. The drawing uses straight segments between f(xᵢ) and f(xᵢ₊₁).
- **Numbers:** All 24 frames match my independent mpmath values to every printed digit. Selected values (script / independent): n=1: 2.017925 / 2.01792481622; n=40: 2.008017 / 2.00801689467; n=48: 2.0101699261 / 2.01016992606; n=120: 2.0149444646 / 2.01494446462.
- **Exactness property:** The script's rule is exact for 1 and x, and has error 1/3 for x² (n=2), so its degree of precision is 1.
- **Reference values:** The script draws no reference value. The page's error figures use I=2.01627971961710, which three methods agree on.
- **Picture:** Frame 1 shows f only, and frames 2–25 show n=1..120. The trapezoids use the right heights. f stays within [0.36, 1.93], inside ylims (0, 2.1), and nothing is clipped. The annotation reports n+1 sample points correctly.

### newtoncotesbb.jl (composite Simpson 1/3)
- **Method:** The code is composite Simpson 1/3, with weights 1, 4, 2, ..., 4, 1 times h/3. It is applied only for even n, and all of `n_seq` is even.
- **Numbers:** All 20 frames match. Selected values (script / independent): n=2: 2.4912610173 / 2.49126101725; n=24: 2.0103696294 / 2.01036962937; n=40: 2.0138900411 / 2.01389004114.
- **Exactness property:** Errors for x⁰..x³ are 0, and for x⁴ the error is 0.016667 at n=4. That gives degree of precision 3, and the error matches the 1/180 constant.
- **Picture:** The interpolant passes through the nodes (max residual 2e-15). The area under the drawn quadratics matches the rule value to 6 decimals in every frame. The interpolant minimum (0.35–1.0) is above 0 and its maximum (1.976) is below 2.1, so the fill to 0 is faithful and nothing is clipped. The dividers at x_{2k} have height f(x_{2k}), and the dots sit at all nodes.

### newtoncotescc.jl (composite Simpson 3/8)
- **Method:** The code is composite 3/8, with weights 3h/8·[1, 3, 3, 2, 3, 3, ..., 1] and the 2s at multiples of 3. All of `n_seq` is divisible by 3.
- **Numbers:** All 24 frames match. Selected values (script / independent): n=6: 1.7904704813 / 1.7904704813; n=48: 2.0140591847 / 2.01405918472; n=120: 2.0158104109 / 2.01581041086.
- **Exactness property:** The rule is exact through x³ and has error 0.0074074 for x⁴ at n=6, which matches the 1/80 constant.
- **Picture:** The cubic interpolant matches the nodes to 1e-14, and the drawn area equals the rule value. The interpolant ranges from 0.20 to 1.94, so there is no clipping. The dividers sit at x_{3k}.

### newtoncotesdd.jl (composite Boole)
- **Method:** The code is composite Boole, (2h/45)[7, 32, 12, 32, 7] per block of 4. All of `n_seq` is divisible by 4, including 116.
- **Numbers:** All 24 frames match. Selected values (script / independent): n=4: 1.5531546827 / 1.55315468274; n=24: 2.0116443222 / 2.01164432216; n=120: 2.0159611789 / 2.01596117887.
- **Exactness property:** The rule is exact through x⁵ (error ≤4e-16) and has error 7.4e-4 for x⁶ at n=8, so its degree of precision is 5.
- **Picture:** The quartic interpolant matches the nodes to 5e-14, and the drawn area equals the rule value. The interpolant ranges from 0.12 to 1.93, so there is no clipping. The dividers sit at x_{4k}.

### Convergence-rate evidence (for A4–A7, C3c)
Errors (approximation − I), from `review/indep.py`:

| n | trapezoidal | Simpson 1/3 | Simpson 3/8 | Boole |
|---|---|---|---|---|
| 24 | −1.919e-2 | −5.910e-3 | −7.883e-3 | −4.635e-3 |
| 48 | −6.110e-3 | −1.748e-3 | −2.221e-3 | −1.471e-3 |
| 96 | −1.934e-3 | −5.427e-4 | −6.827e-4 | −4.624e-4 |
| 768 | −6.087e-5 | −1.685e-5 | −2.113e-5 | −1.440e-5 |

Ratios from 24 to 48 are 3.1415, 3.3803, 3.5499 and 3.1513. From 768 to 1536 they are 3.1711, 3.1759, 3.1762 and 3.1756, tending to 2^{5/3} = 3.1748.

