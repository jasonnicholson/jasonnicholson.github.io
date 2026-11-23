# Newton-Cotes Integration — animation review (round 6)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

These are deliberately not findings:
- The on-frame annotations use `round(approx; digits=6)`, which drops trailing zeros. For example, the trapezoid frame at 49 points shows `2.01017` and the last Simpson 1/3 frame shows `2.01389`. The values are correct to the precision shown, so this is cosmetic.
- The trapezoidal GIF draws no red sample-point dots, while Mathews' trapezoid animation and the other three cases do. The alt text for case 1 does not claim dots, and nothing reads wrongly because of it.
- The frame sequences of cases 1, 3 and 4 differ from Mathews' in some intermediate counts. For example, Mathews' trapezoid frames include 51, 61, 71, 81 and 101 points, and the script's frames instead include 49, 57, 65, 73, 89 and 105. Both start and end at the same counts, and the page claims agreement only at shared counts. This changes pacing, not content.
- Mathews' module also has seven static worked examples (lnk_2 to lnk_8), with no animations. The page's four cases map one-to-one onto Mathews' four animations, so nothing animated is dropped.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 7.3 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.4 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 8.2 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 8.7 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Exact integral used throughout: I = 2.016279719617096327887… (mpmath, two independent quadratures agree to 40 digits).

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Newton-Cotes: interpolate f on equally spaced nodes, integrate the interpolant on each panel | All three plotting scripts fit a degree-m polynomial through the m+1 equispaced panel nodes. The integral of the drawn polynomial equals the rule sum to ≤1.4e-14 for every frame (`polyint=` column in `inst_out.txt`). | confirmed |
| D2 | Description | Trapezoidal / Simpson 1/3 / 3/8 / Boole have degree 1/2/3/4 (interpolant degree) | The scripts fit polynomials of degree 1/2/3/4, and the weights derived from the Lagrange basis are 1/2,1/2; 1/3,4/3,1/3; 3/8,9/8,9/8,3/8; 14/45,64/45,8/15,64/45,14/45. | confirmed |
| D3 | Description | T_n = h[½f(x0)+Σ_{i=1}^{n-1} f(x_i)+½f(x_n)] | Same as `trapezoid_sum` (aa.jl:18-22). Matches the independent composite sums to ≤3e-16. | confirmed |
| D4 | Description | S_n = h/3[f(x0)+f(xn)+4Σ_{k=1}^{n/2} f(x_{2k-1})+2Σ_{k=1}^{n/2-1} f(x_{2k})], even n | Same as `simpson_sum` (bb.jl:25-30). Matches the independent sums for all 20 n. | confirmed |
| D5 | Description | Animations increase point density over the full interval between frames | Every `n_seq` is strictly increasing, and every frame covers [0,2]. | confirmed |
| A1 | Animations intro | Each case uses f(x)=e^{-x}sin(8x^{2/3})+1 on [0,2] | Line 8–9 of each script. | confirmed |
| A2 | Animations intro | Each shows a different closed Newton-Cotes construction | The four scripts use rules of degree 1, 2, 3 and 4, all with endpoints as nodes. | confirmed |
| A3 | Animations intro | f'(x) ≈ (16/3)x^{-1/3} near 0, so f' is unbounded | The ratio of the numerical f' to (16/3)x^{-1/3} is 0.9943 at 1e-3, 0.999997 at 1e-6 and 0.999999997 at 1e-9. | confirmed |
| A4 | Animations intro | Textbook order does not hold. The measured error of all four shrinks like O(h^{5/3}) | The error ratios for n=1536→3072 are 3.172 (T), 3.175 (S13), 3.175 (S38) and 3.175 (Boole), against 2^{5/3}=3.1748. | confirmed |
| A5 | Animations intro | Halving h from 24 to 48 subintervals divides the error by about 3.14, 3.38, 3.55, 3.15 | The independent values are 3.14152, 3.38032, 3.54990 and 3.15132. | confirmed |
| A6 | Animations intro | The ratios tend to 2^{5/3}≈3.17 for each, instead of 4, 16, 16, 64 | See A4. Smooth-case orders 2, 4, 4, 6 follow from the degrees of precision 1, 3, 3, 5 (D-notes). | confirmed |
| A7 | Animations intro | At equal h the higher-degree rules gain only a constant factor over the trapezoidal rule | The ratio of trapezoid to Simpson 1/3 error is 3.25, 3.49, 3.56 … 3.62 for n=24…3072, which tends to a constant. | confirmed |
| C1 | Case 1 heading/link/embed | Composite trapezoidal → `newtoncotesaa.jl` / `.gif` | The script runs the composite trapezoid rule, and the GIF is byte-identical to the regenerated output (manifest). | confirmed |
| C1b | Case 1 Behavior | Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser | aa.jl:32-42 draws a straight top on every subinterval. Frames 2–25 show 2→121 points. | confirmed |
| C1c | Case 1 alt | Full-interval point density increases each frame, and the trapezoid approximation updates | 25 frames: f only, then n=1…120 (2→121 points), with the annotation updated each frame. | confirmed |
| C2 | Case 2 heading/link/embed | Composite Simpson 1/3 → `newtoncotesbb.jl` / `.gif` | Weights 1,4,2,…,4,1 times h/3. The drawn quadratics through 3 nodes integrate to the same sum. | confirmed |
| C2b | Case 2 Behavior | Pairs of subintervals are approximated by quadratics | bb.jl:40-54 runs panels i=0:2:n-2 with a 3-node quadratic, as the frames show. | confirmed |
| C2c | Case 2 Behavior | Visibly smoother top boundary than trapezoids | The frames show curved arcs in place of polygonal tops. This is a qualitative claim and the frames support it. | confirmed |
| C2d | Case 2 Behavior | Stops at 41 sample points, as Mathews' Simpson animation does | `n_seq` ends at 40 and the last frame reads "Sample Points = 41". The last Mathews Simpson frame reads 41 points, 2.013890. | confirmed |
| C2e | Case 2 Behavior | So its last frame is less accurate than the 121-point last frames of the other cases | The last-frame errors are 2.39e-3 for S13 (41 points), against 1.34e-3 (T), 4.69e-4 (S38) and 3.19e-4 (Boole), all at 121 points. | confirmed |
| C2f | Case 2 Behavior | At 41 points the error is 2.4e-3, against 8.3e-3 for the trapezoidal rule | The computed errors are −2.38968e-3 and −8.26282e-3. | confirmed |
| C2g | Case 2 alt | Opening frame shows only f. Density rises to 41 points. Red dots mark the sample points. Vertical red lines mark the boundaries of the pairs of subintervals. The piecewise quadratic area updates. | Frame 1 shows f only, and there are 21 frames in all. The dots are drawn at x_i for i=0..n (bb.jl:71-72) and the dividers at x_{2k} (bb.jl:57-60). Checked in frames 2, 4, 7 and 21. | confirmed |
| C3 | Case 3 heading/link/embed | Composite Simpson 3/8 → `newtoncotescc.jl` / `.gif` | Weights 1,3,3,2,…,3,3,1 times 3h/8, matching the independent weights 3/8,9/8,9/8,3/8 per panel. | confirmed |
| C3b | Case 3 Behavior | Triplets of subintervals are approximated by cubics | cc.jl:40-55 fits a cubic through 4 nodes. polyint equals the rule sum. | confirmed |
| C3c | Case 3 Behavior | A higher-degree piecewise fit but not a higher-order rule; both have degree of precision 3 | The independent monomial test gives a degree of precision of 3 for both. | confirmed |
| C3d | Case 3 Behavior | On this integrand its error at the same h is larger, about 1.25 times Simpson 1/3's as h shrinks | The ratio of S38 to S13 error is 1.334 (n=24), 1.270 (48), 1.258 (96), 1.255 (192) … 1.2542 (3072). | confirmed |
| C3e | Case 3 alt | Opening frame shows only f. Density rises to 121 points. The dots, the dividers at the boundaries of the triplets and the piecewise cubic area are drawn. | 25 frames, the last reading 121 points. Dividers at x_{3k} (cc.jl:58-61). Checked in the frames. | confirmed |
| C4 | Case 4 heading/link/embed | Composite Boole → `newtoncotesdd.jl` / `.gif` | Weights 2h/45·(7,32,12,32,7) = h·(14/45,64/45,8/15,64/45,14/45), matching the derived weights. | confirmed |
| C4b | Case 4 Behavior | Blocks of four subintervals use quartic interpolation | dd.jl:49-65 fits a 5-node quartic. polyint equals boole_sum. | confirmed |
| C4c | Case 4 Behavior | As density rises, the piecewise quartic envelope tracks the oscillations closely | At 5 points the quartic visibly departs from f (`first_data_frames.png`). From about 25 points on it is visually indistinguishable from f (sheet). | confirmed |
| C4d | Case 4 alt | Opening frame shows only f. Density rises to 121 points. The dots, the dividers at the boundaries of the blocks of four and the piecewise quartic area are drawn. | 25 frames, the last reading 121 points. Dividers at x_{4k}. Checked in the frames. | confirmed |
| L1 | Legacy note | Same rule, integrand and interval as Mathews' animation of that rule | The Mathews frames are labelled y = e^{-x} sin(8x^{2/3}) + 1 with x-axis 0–2. Each rule title matches. | confirmed |
| L2 | Legacy note | At every number of sample points the two share, the approximations agree to six decimals | Shared counts: 15 (T), 20 (S13), 17 (S38) and 20 (Boole). There are 0 mismatches (`legacy_cmp.py`). | confirmed |
| N1 | Derivation Notes | Interpolant degrees are 1, 2, 3, 4. Degrees of precision are 1, 3, 3, 5. The rules with even subintervals per panel gain one degree. | Independent symbolic test on monomials. | confirmed |
| N2 | Derivation Notes | For smooth f the composite errors are O(h^2), O(h^4), O(h^4), O(h^6) | This follows from N1. Composite coefficients from `sym.py`: −1/12·(b−a)h²f'', −1/180·(b−a)h⁴f⁽⁴⁾, −1/80·(b−a)h⁴f⁽⁴⁾, −2/945·(b−a)h⁶f⁽⁶⁾. | confirmed |
| N3 | Derivation Notes | Simpson 3/8 is not higher order. Its constant is 1/80 against 1/180 for Simpson 1/3. | `sym.py` gives −1/80 and −1/180. | confirmed |
| N4 | Derivation Notes | Very-high-degree rules on wide panels can become less robust | A general qualitative statement that the page does not quantify. It is not checkable against these scripts. | could not determine (not a numerical claim, so it is outside what the scripts can test) |
| W1 | Wiring | 4 source links and 4 embeds, each pointing at its own case | `index.qmd` lines 29/31, 37/39, 45/47, 53/55. The manifest shows each committed GIF byte-identical to its script's output. | confirmed |

---

### 3. Implementation checks

All four scripts use `f(x) = exp(-x)*sin(8*x^(2/3)) + 1` on [0,2]. For x ≥ 0, Julia's `x^(2/3)` gives the real cube root squared, and f(0)=1 is finite. All four GIFs are byte-identical to fresh regenerations from scratch copies (manifest).

### `newtoncotesaa.jl`: composite trapezoidal rule
- **Method.** `trapezoid_sum(n)` = h[½f(a)+Σf(x_i)+½f(b)], which is the composite trapezoidal rule. The `n==1` branch gives h(½f(a)+½f(b)).
- **Numbers.** All 24 frames match the independent mpmath sums to ≤3e-16. Some examples (script / independent): n=1 2.017924816215668 / 2.0179248162156685; n=40 2.008016894673292 / 2.0080168946732916; n=120 2.0149444646203434 / 2.0149444646203433.
- **Reference.** The page and script quote no exact value. Mine is I = 2.01627971961709633, from two independent quadratures (with and without the x=t³ substitution) that agree to 40 digits.
- **Picture.** Each subinterval is drawn as the polygon (x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l)), so its area is exactly that subinterval's term of the sum. The annotation "Sample Points = n+1" is correct, and frame 1 shows f only. I viewed frames 2, 4, 7, 10, 13, 16, 19, 22 and 25. There is no clamping or masking, and ylims (0, 2.1) contains f, whose maximum is about 1.92.

### `newtoncotesbb.jl`: composite Simpson 1/3
- **Method.** Composite Simpson 1/3: odd-index nodes weighted 4, interior even-index nodes weighted 2, all times h/3. The drawn panels are Vandermonde-fitted quadratics through (x_{2k}, x_{2k+1}, x_{2k+2}).
- **Numbers.** All 20 n match the independent sums. Examples: n=2 2.4912610172534464 / 2.4912610172534464; n=40 2.0138900411352303 / 2.0138900411352307. The exact integral of the drawn quadratics equals the rule sum to ≤1.5e-15, so the shaded area is the reported number.
- **Picture.** Dividers sit at x_{2k}, k=0..n/2, and dots at all x_i. First data frame: 3 points, a single parabola through (0,1), (1,1.3626) and (2,1.0179), annotated 2.491261. The last frame shows 41 points and 2.01389, the latter being 2.013890 rounded with the trailing zero dropped. xlims (−0.03, 2.03) keeps the end dots visible.

### `newtoncotescc.jl`: composite Simpson 3/8
- **Method.** Composite 3/8: interior nodes with i mod 3 ≠ 0 weighted 3, interior multiples of 3 weighted 2, all times 3h/8. Per panel this is 3h/8·(1,3,3,1), which matches the weights I derived from the Lagrange basis. The drawn cubics run through x_{3k}..x_{3k+3}.
- **Numbers.** All 24 n match. Examples: n=3 1.8842140994188474 / 1.8842140994188473; n=120 2.015810410863725 / 2.0158104108637248. polyint equals the rule sum to ≤4e-15.
- **Picture.** Dividers sit at x_{3k}. The first data frame (4 points) shows one cubic through 4 nodes. The last frame shows 121 points and 2.01581.

### `newtoncotesdd.jl`: composite Boole
- **Method.** Boole per block of 4 subintervals, 2h/45·(7,32,12,32,7). This equals the derived h·(14/45,64/45,8/15,64/45,14/45). Every n in `n_seq` is a multiple of 4.
- **Numbers.** All 24 n match. Examples: n=4 1.5531546827403782 / 1.5531546827403781; n=120 2.0159611788705827 / 2.0159611788705829. polyint equals boole_sum to ≤1.4e-14 (Vandermonde round-off).
- **Picture.** Dividers sit at x_{4k}. The first data frame (5 points) shows the quartic dipping to about 0.12 near x≈0.28, well below f, which is correct for the interpolant through (0,1), (0.5,0.42), (1,1.36), (1.5,0.81) and (2,1.02). The last frame shows 121 points and 2.015961.

### Error behaviour (independent; supports A4–A7, C2e–f, C3d)
| n | trap err | S13 err | S38 err | Boole err | S38/S13 |
|---|---|---|---|---|---|
| 24 | −1.91940e-2 | −5.91009e-3 | −7.88268e-3 | −4.63540e-3 | 1.334 |
| 48 | −6.10979e-3 | −1.74838e-3 | −2.22053e-3 | −1.47094e-3 | 1.270 |
| 96 | −1.93450e-3 | −5.42734e-4 | −6.82735e-4 | −4.62357e-4 | 1.258 |
| 768 | −6.08748e-5 | −1.68459e-5 | −2.11307e-5 | −1.44008e-5 | 1.2544 |
| 3072 | −6.05206e-6 | −1.67045e-6 | −2.09504e-6 | −1.42819e-6 | 1.2542 |

The 24→48 ratios are 3.1415, 3.3803, 3.5499 and 3.1513. The 1536→3072 ratios are 3.172, 3.175, 3.175 and 3.175, against 2^{5/3} = 3.1748.

