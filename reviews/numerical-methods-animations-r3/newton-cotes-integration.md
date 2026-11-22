# Newton-Cotes Integration — animation review (round 3)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match, Minor — Simpson composite formula has no summation limits

- **Location:** `index.qmd` line 17: `$S_n = \tfrac{h}{3}[f(x_0)+f(x_n)+4\sum f(x_{2k-1})+2\sum f(x_{2k})]$`.
- **What is there:** the two sums carry no index range, while the trapezoidal formula on the line above (line 16) gives explicit limits `\sum_{i=1}^{n-1}`.
- **What is true:** the even-node sum must run over interior even nodes only, $k=1,\dots,n/2-1$ (it must exclude $x_0$ and $x_n$, which are already counted once); the odd-node sum runs $k=1,\dots,n/2$. Read with the natural range $k=0,\dots,n/2$ for $\sum f(x_{2k})$, the formula double-counts the endpoints. The script (`newtoncotesbb.jl` lines 27–29: `1:2:n-1` and `2:2:n-2`) uses the correct ranges, so this is only an incomplete statement on the page, not a computational error.
- **How I know:** reading the formula against the script; the script's sum was confirmed exact for $x^0..x^3$ on $[0,2]$ with $n=6$ (see Section 3).
- **Correction:** write `4\sum_{k=1}^{n/2} f(x_{2k-1}) + 2\sum_{k=1}^{n/2-1} f(x_{2k})`, and state that $n$ is even.

No other findings. Items examined and judged not to be findings:
- The frame labels print `round(approx; digits=6)`, so a value whose sixth decimal is 0 is shown with five decimals (e.g. "2.01017" at 49 points, "2.01389" at 41, "1.79047" at 7, "2.01581" at 121). The values are correct; this is cosmetic.
- The trapezoidal GIF has no red sample-point dots, unlike the other three and unlike Mathews' trapezoidal GIF. The page does not claim dots for Case 1 (its alt text does not mention them), so this is not a mismatch.
- The new GIFs do not print the integrand in the frame, as Mathews' did; the page states the integrand in the Animations introduction.
- The sample-count sequences differ from Mathews' (e.g. Mathews' trapezoidal goes 2,3,5,7,9,…,51,61,71,81,101,121; the page's goes 2,3,4,…,9,11,…,105,121). The page claims agreement only "at every number of sample points the two share", which holds.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 8.1 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.7 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 8.7 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

Independent reference: $I=\int_0^2 \big(e^{-x}\sin(8x^{2/3})+1\big)dx = 2.016279719617096\ldots$ (mpmath, substitution $x=t^3$, which makes the integrand smooth; agrees to 30 digits with direct tanh-sinh quadrature on 8 subintervals).

| # | Claim (page wording) | Where | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Newton-Cotes "interpolating $f$ on equally spaced nodes and integrating the interpolating polynomial on each panel" | Description | Scripts interpolate per panel (Vandermonde) and the rule sum equals the exact integral of the drawn interpolants to ≤1.5e-14 (Sec. 3) | confirmed |
| 2 | Trapezoidal (degree 1), Simpson 1/3 (degree 2), 3/8 (degree 3), Boole (degree 4) — interpolant degrees | Description | 2,3,4,5 nodes per panel in scripts | confirmed |
| 3 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$ | Description | matches `trapezoid_sum` and weights 1/2,1/2 derived from moment equations | confirmed |
| 4 | $S_n = \tfrac h3[f(x_0)+f(x_n)+4\sum f(x_{2k-1})+2\sum f(x_{2k})]$ | Description | weights correct (1/3,4/3,1/3 derived); summation limits missing | confirmed with caveat — F1 |
| 5 | "animations … follow the legacy style by increasing point density over the full interval between frames" | Description | `n_seq` strictly increasing in all four scripts; frames confirm | confirmed |
| 6 | Each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Animations intro | line 8–9 of every script | confirmed |
| 7 | "shows a different closed Newton-Cotes construction" | intro | trapezoid, Simpson 1/3, 3/8, Boole, all with endpoints as nodes | confirmed |
| 8 | "sample density increases frame by frame" | intro | `n_seq` strictly increasing; frames | confirmed |
| 9 | $x^{2/3}$ makes $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | intro | $f'=-e^{-x}\sin(\cdot)+e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}$ → $\tfrac{16}{3}x^{-1/3}$ as $x\to0$ | confirmed |
| 10 | Measured error of all four rules shrinks like $O(h^{5/3})$ | intro | error ratios on halving tend to 3.1735, 3.1749, 3.1749, 3.1749 at n=12288→24576; $2^{5/3}=3.17480$ | confirmed |
| 11 | Halving 24→48 divides error by about 3.14, 3.38, 3.55, 3.15 | intro | computed 3.1415, 3.3803, 3.5499, 3.1513 | confirmed |
| 12 | "tending to $2^{5/3}\approx3.17$ for each, instead of 4, 16, 16 and 64" | intro | as #10; 3.17480 | confirmed |
| 13 | "higher-degree rules gain only a constant factor over the trapezoidal rule here" | intro | at n=48: errors 6.11e-3, 1.75e-3, 2.22e-3, 1.47e-3; ratios to trapezoid settle to constants as h shrinks | confirmed |
| 14 | Case 1 heading: Composite Trapezoidal Rule; link `newtoncotesaa.jl`, embed `newtoncotesaa.gif` | Case 1 | script implements composite trapezoid; GIF title "Trapezoidal Rule"; committed GIF byte-identical to regeneration | confirmed |
| 15 | "Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser" | Case 1 Behavior | lines 32–41; frames | confirmed |
| 16 | Alt: "over [0,2]: full-interval point density increases each frame and trapezoid approximation updates" | Case 1 alt | frames 2–25: SP 2→121, label updates | confirmed |
| 17 | Case 2 heading: Composite Simpson's Rule (1/3); link/embed `bb` | Case 2 | script implements composite Simpson 1/3; GIF title "Simpson's Rule" | confirmed |
| 18 | "Pairs of subintervals are approximated by quadratics" | Case 2 Behavior | lines 40–53 (3-point fits per pair) | confirmed |
| 19 | "visibly smoother top boundary than trapezoids" | Case 2 Behavior | piecewise quadratic vs piecewise linear in frames | confirmed |
| 20 | "stops at 41 sample points, as Mathews' Simpson's rule animation does" | Case 2 | last `n_seq`=40 → SP=41; legacy Simpsonaa.gif last label SP=41 | confirmed |
| 21 | "its last frame is less accurate than the 121-point last frames of the other cases" | Case 2 | errors: Simpson@41 2.39e-3; trap@121 1.34e-3; 3/8@121 4.69e-4; Boole@121 3.19e-4 | confirmed |
| 22 | "at 41 points its error ($2.4\times10^{-3}$) is smaller than the trapezoidal rule's ($8.3\times10^{-3}$)" | Case 2 | 2.390e-3 and 8.263e-3 | confirmed |
| 23 | Alt: "after an opening frame showing only f, density increases each frame up to 41 sample points" | Case 2 alt | frame 1 f only; 21 frames; last SP=41 | confirmed |
| 24 | Alt: "red dots mark the sample points, vertical red lines mark the boundaries of the pairs of subintervals, piecewise quadratic area approximation updates" | Case 2 alt | lines 57–59, 71–72; frames (e.g. SP=5: lines at 0,1,2; dots at 0,.5,1,1.5,2) | confirmed |
| 25 | Case 3 heading: Composite Simpson's 3/8 Rule; link/embed `cc` | Case 3 | script implements composite 3/8; GIF title "Simpson's 3/8 Rule" | confirmed |
| 26 | "Triplets of subintervals are approximated by cubics" | Case 3 Behavior | lines 40–54 | confirmed |
| 27 | "not a higher-order rule: both have degree of precision 3" | Case 3 | script routines exact for $x^0..x^3$, not $x^4$ (Sec. 3) | confirmed |
| 28 | "error at the same h is larger, about 1.25 times Simpson's 1/3 error as h shrinks" | Case 3 | E38/E13 = 1.334 (n=24), 1.270 (48), 1.258 (96), 1.2546 (384), 1.2541 (98304) | confirmed |
| 29 | Alt: "opening frame showing only f, node density increases each frame up to 121 sample points; red dots…, vertical red lines … triplets …, piecewise cubic area" | Case 3 alt | 25 frames, last SP=121; lines at $x_{3k}$; frames | confirmed |
| 30 | Case 4 heading: Composite Boole's Rule; link/embed `dd` | Case 4 | weights 7,32,12,32,7 × 2h/45 = derived 14/45,64/45,8/15,64/45,14/45 (h=1) | confirmed |
| 31 | "Blocks of four subintervals use quartic interpolation" | Case 4 Behavior | lines 49–64 | confirmed |
| 32 | "As density rises, the piecewise quartic envelope tracks oscillations closely" | Case 4 Behavior | frames from SP≈25 on: interpolant visually on top of f; error falls 4.6e-1 → 3.2e-4 | confirmed |
| 33 | Alt: "opening frame…, up to 121 sample points; red dots…, vertical red lines … blocks of four …, piecewise quartic area" | Case 4 alt | 25 frames, last SP=121; lines at $x_{4k}$ | confirmed |
| 34 | Legacy note: "each case uses the same rule, integrand and interval as Mathews' animation of that rule" | Legacy note | legacy frames show $y=e^{-x}\sin(8x^{2/3})+1$, [0,2], titles Trapezoidal/Simpson's/Simpson's 3/8/Boole's | confirmed |
| 35 | Legacy note: "at every number of sample points the two share, the approximations agree to six decimals" | Legacy note | compared all shared counts: trap 15 shared (2,3,5,7,9,11,13,15,17,21,25,29,33,41,121), Simpson 20 (3..41), 3/8 17 (4,7,10,13,16,19,25,31,37,43,49,55,61,67,73,85,121), Boole 20 (5,9,…,41,49,…,121); every one agrees to all 6 printed decimals | confirmed |
| 36 | Degrees of precision 1, 3, 3, 5 | Derivation Notes | exact-rational moment test on panel weights and script routines (Sec. 3) | confirmed |
| 37 | Even-subinterval rules exact one degree beyond their interpolant | Derivation Notes | Simpson 1/3 (deg 2 → DOP 3), Boole (deg 4 → DOP 5) | confirmed |
| 38 | Smooth-f composite errors $O(h^2),O(h^4),O(h^4),O(h^6)$ for $C^2,C^4,C^4,C^6$ | Derivation Notes | follows from DOP; standard | confirmed |
| 39 | Composite error constants $\tfrac1{80}(b-a)h^4|f^{(4)}|$ (3/8) vs $\tfrac1{180}(b-a)h^4|f^{(4)}|$ (1/3) | Derivation Notes | with $f=x^4$, $[0,2]$, $h=1/3$: predicted rel. errors $2\cdot24/(80\cdot81\cdot6.4)=1.1574\times10^{-3}$ and $2\cdot24/(180\cdot81\cdot6.4)=5.144\times10^{-4}$; script routines give 1.1574074e-3 and 5.144033e-4 | confirmed |
| 40 | "Rules of very high degree on wide panels can become less robust" | Derivation Notes | general qualitative statement, not tied to this page's computations | not checked (qualitative) |
| 41 | Counts: 4 cases; frames 25/21/25/25 (implicit via "up to 41/121") | throughout | manifest frame counts; `length(n_seq)+1` = 25, 21, 25, 25 | confirmed |

---

### 3. Implementation checks

Independent computation: `review/indep.py` (mpmath, 30 digits). Closed Newton-Cotes weights were derived from the moment equations in exact rational arithmetic, not from memory: m=1 → [1/2, 1/2]; m=2 → [1/3, 4/3, 1/3]; m=3 → [3/8, 9/8, 9/8, 3/8]; m=4 → [14/45, 64/45, 8/15, 64/45, 14/45]. Exact-rational degree-of-precision test on [0,m]: 1, 3, 3, 5. Output: `review/indep.out`.

Script instrumentation: `review/inst/nc{aa,bb,cc,dd}.jl` (each script's definitions, animation loop removed, printing every approximation in `n_seq` to 10 decimals; and for the interpolant-drawing scripts, the exact integral of every drawn Vandermonde interpolant and its residual at the nodes). Degree-of-precision runs of the scripts' own routines: `review/inst/dop_*.jl`. Output: `review/inst/run.out`.

### `newtoncotesaa.jl` — composite trapezoidal
- **Method:** `trapezoid_sum` is the composite trapezoidal rule; drawn trapezoids use $f$ at both subinterval ends. Confirmed.
- **Numbers:** all 24 values agree with the independent computation to all 10 printed decimals, e.g. SP=2 2.0179248162 / 2.0179248162; SP=41 2.0080168947 / 2.0080168947; SP=121 2.0149444646 / 2.0149444646. Total area of drawn trapezoids equals `trapezoid_sum(n)` to 1e-12 for all n. Script routine on $x^k$, n=6: exact for k=0,1; rel. error 1.39e-2 at k=2 (DOP 1).
- **Reference values:** none drawn; the page's error figures use my independent $I$.
- **Picture:** first frame f only; frame 2 (SP=2) one trapezoid from (0,1) to (2,1.0179); frame 3 (SP=3) apex at $x=1$ on $f(1)=1.36$; last frame SP=121, label 2.014944 = computed. Axis window (0..2, 0..2.1) contains $f$ (max ≈1.92) and every trapezoid. Title and labels correct.

### `newtoncotesbb.jl` — composite Simpson 1/3
- **Method:** `simpson_sum` uses weights 1,4,2,…,4,1 × h/3 with odd range `1:2:n-1`, even range `2:2:n-2`. Composite Simpson 1/3. Confirmed.
- **Numbers:** all 20 values agree to 10 decimals, e.g. SP=3 2.4912610173 / 2.4912610173; SP=41 2.0138900411 / 2.0138900411. Exact integral of drawn quadratics equals the rule sum to 6.7e-16; interpolants reproduce data at nodes to 2.0e-15. Script routine on $x^k$: exact (≤2.2e-16) for k=0..3, 5.14e-4 at k=4 (DOP 3).
- **Reference values:** none drawn.
- **Picture:** SP=3 single parabola through (0,1),(1,1.36),(2,1.018), peak ≈1.37, inside window; SP=5 two parabolas with divider at x=1; dots at all nodes; last frame SP=41, label "2.01389" = 2.013890 (trailing zero dropped). Correct.

### `newtoncotescc.jl` — composite Simpson 3/8
- **Method:** `simpson38_sum` weights 1,3,3,2,3,3,…,1 × 3h/8 (non-multiples of 3 get 3, interior multiples of 3 get 2). Composite 3/8 rule. Confirmed.
- **Numbers:** all 24 values agree to 10 decimals, e.g. SP=4 1.8842140994 / 1.8842140994; SP=121 2.0158104109 / 2.0158104109. Drawn cubics integrate to the rule sum within 2.7e-15; node residual 1.3e-14. Routine on $x^k$: exact for k=0..3, 1.157e-3 at k=4 (DOP 3; equals the 1/80 constant prediction).
- **Reference values:** none drawn.
- **Picture:** SP=4 one cubic through 4 nodes; SP=7 two cubics with divider at x=1; SP=10 cubic undershoots to ≈0.28 near x=0.5, inside window; last frame SP=121, label "2.01581" = 2.015810. Correct.

### `newtoncotesdd.jl` — composite Boole
- **Method:** `boole_sum` applies 2h/45·(7,32,12,32,7) per block of four. Equals derived weights. Composite Boole. Confirmed.
- **Numbers:** all 24 values agree to 10 decimals, e.g. SP=5 1.5531546827 / 1.5531546827; SP=117 2.0159426294 / 2.0159426294; SP=121 2.0159611789 / 2.0159611789. Drawn quartics integrate to the rule sum within 1.5e-14; node residual 5.5e-14. Routine on $x^k$ (n=8): exact for k=0..5, 4.07e-5 at k=6 (DOP 5).
- **Reference values:** none drawn.
- **Picture:** SP=5 one quartic dipping to ≈0.12 near x=0.28 (inside ylims 0..2.1, so not clipped); SP=9 two quartics overshooting to ≈1.6 near x=0.9, inside window; dividers at $x_{4k}$; last frame SP=121, label 2.015961 = computed. Correct.

### Regeneration
Per the manifest, all four committed GIFs are byte-identical to fresh scratch runs, so the frames reviewed are what the current scripts produce.

### Legacy comparison (fidelity)
Mathews' four a2001 animations use the same integrand, interval and rules as Cases 1–4. Every "Approximation" label in the legacy frames at a sample count the page also uses matches the page's script value to six decimals (values listed against claim #35; full lists in `review/legacy_*_text.png` and `review/indep.out`). Mathews' Simpson 1/3 animation stops at 41 points, as the page says. No archive animation is dropped. The static Examples 1–7 of the module are not animated, but the page does not claim to cover them. No fidelity findings.

