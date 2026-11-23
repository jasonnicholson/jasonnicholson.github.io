# Adaptive Simpson's Rule — animation review (round 6)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation, the instrumented script output, the frames, and the legacy archive. The evidence follows.

Observations that I judged **not** to be findings:
- The first GIF frame shows only the curve, and the single panel $[0,2]$ appears in frame 2. The intro sentence "Starting from the single panel $[0,2]$" is still accurate in substance.
- The page splits panels in breadth-first order (widest failing panel first, leftmost first). Mathews' Example 7 trace uses a different order, so his intermediate approximations (for example his 5th value, 1.935128) differ from the page's frame-by-frame values. The page states its own order explicitly. The final partition (41 points, finest panel $[0,1/2048]$) and the final value 2.016252 are identical to Mathews', so the order difference does not matter to a reader.
- "the finest is $[0,1/2048]$": $[1/2048,1/1024]$ has the same width. This is just wording.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 7.7 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adaptivesimpsonsaa.gif` | 21 | byte-identical | adaptivesimpsonsaa |

### Page references

- Scripts linked: `adaptivesimpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | script l.15 is identical. `props.jl`: S exact for $x^2$ and $x^3$ on [0,2] (err 0). For $x^4$ the error is 0.26667, which equals $(b-a)^5\cdot 24/2880$. | confirmed |
| D2 | refinement compares $S(a,b)$ with $S(a,m)+S(m,b)$ | script l.20 | confirmed |
| D3 | acceptance $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$, "the acceptance test of Mathews' routine" | script l.20. Mathews `Adapt` (gr_2.png) uses `Abs[Sab-Sac-Scb] < tol` | confirmed |
| D4 | whole interval starts with $\varepsilon$, each half gets half the tolerance | script l.28, l.37. Mathews passes `tol/2` | confirmed |
| D5 | 15ε variant accepts 9 subintervals, finest $[0,1/32]$ | `indep.py` fac=15: 9 panels, finest 1/32, panel list ends at [0,1/32] | confirmed |
| D6 | the ε test accepts 20 subintervals, finest $[0,1/2048]$ | `indep.py` fac=1: 20 panels, finest 1/2048 | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ | script l.9–12. Frame annotation "tol = 0.001". Mathews Ex. 7 uses the same f, interval and `Adapt[0,2,0.001]` | confirmed |
| A2 | each frame splits the widest failing panel (leftmost first) | script l.34. The instrumented split order is [0,2],[0,1],[1,2],[0,1/2],[1/2,1],[1,3/2],[0,1/4],…, so it goes level by level | confirmed |
| A3 | new sample points marked in blue | script l.119 draws the quarter-points of the split panel, which are the new midpoints. Visible in frames 3–21 | confirmed |
| A4 | "Approximation" = composite Simpson sum of $S(a,b)$ over the panels drawn | `simpson_nonuniform` sums (h/3)(f0+4f1+f2) over each panel's (p,m,q). This equals the sum of S(p,q). The values match `indep.py` (see §3) | confirmed |
| A5 | "Each animation below…" and "Julia source scripts…linked under each case" | there is 1 case and 1 link | confirmed (wording is plural for a single case) |
| C1 | heading: Case 1, f, $[0,2]$, $\varepsilon=10^{-3}$ | same as A1 | confirmed |
| C2 | refinement stops when all 20 panels (41 points) pass | instrumented: final frame has 41 points. `indep.py`: 20 panels, 41 points. Frame 21 shows "Sample Points = 41" | confirmed |
| C3 | $[1.5,2]$ is never split | `indep.py`: (3/2,2) is an accepted panel. Final nodes in [1.5,2] are 3/2, 7/4, 2. No split of [3/2,2] appears in the sequence | confirmed |
| C4 | 19 of the 41 points lie in $[0,1/8]$ | `indep.py`: 19 (inclusive of 0 and 1/8) | confirmed |
| C5 | last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ | instrumented: frames 15–21 split [0,1/16], [0,1/32], [0,1/64], [0,1/128], [0,1/256], [0,1/512], [0,1/1024] | confirmed |
| C6 | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | sympy: $\lim_{x\to0^+} x^{1/3}f'(x)=16/3$ | confirmed |
| C7 | panels split in the last five frames are at most 1/64 wide, under 5 pixels | Frames 17–21 split [0,1/64]…[0,1/1024]. Measured plot box from x=39 to x=618 px, so 579 px for 2 units and 1/64 is 4.52 px | confirmed |
| C8 | the blue label names each split | frames 3–21 show "Split [p, q]" in blue. The last frame reads "Split [0, 1/1024]" | confirmed |
| C9 | final estimate 2.016252 | instrumented 2.01625176. `indep.py` sum S = 2.01625176116. Mathews' table ends at 2.016252 | confirmed |
| C10 | integral 2.016280 | mpmath quad with breakpoints = 2.0162797196171. The substitution $x=u^3$ (smooth integrand) gives the identical result | confirmed |
| C11 | difference $-2.8\times10^{-5}$ | 2.01625176 − 2.01627972 = −2.796e-5 | confirmed |
| C12 | $\sum [S(a,m)+S(m,b)]$ over the same panels = 2.016273 | `indep.py`: 2.01627260396 | confirmed |
| G1 | alt text: one failing panel split per frame, sample points and panel boundaries drawn, new points in blue | frames; script l.100–121. Panel boundaries are drawn at `xs[1:2:end]`, which are the panel endpoints | confirmed |
| G2 | alt text: ends with 41 points, 19 in $[0,1/8]$ | C2, C4 | confirmed |
| G3 | alt text: piecewise quadratic approximation and integral estimate update each frame | the pink quadratics are interpolants through (p,m,q). The fit residual at the nodes is 0.0. The Approximation text changes every frame | confirmed |
| W1 | `[Julia source](adaptivesimpsonsaa.jl)` and embed `adaptivesimpsonsaa.gif` are this case | the script writes `adaptivesimpsonsaa.gif`. A regenerated copy is byte-identical to the committed GIF (md5 a7a3e0ae…) | confirmed |
| W2 | frame count | 21 = 1 curve-only frame + 20 partitions (19 splits) | confirmed (the page states no explicit count) |
| F1 | Fidelity: Mathews Example 7 (same f, [0,2], tol 0.001, 41-point final node set, 2.016252) | `mathews_ex7.png`, lnk_8 node list. Mathews' last node set equals the script's final nodes. The final value matches | confirmed (only the split order differs, and the page explains it) |

### 3. Implementation checks — `adaptivesimpsonsaa.jl`

**Method.** The script runs adaptive Simpson quadrature with Mathews' acceptance test $|S_{left}+S_{right}-S_{whole}|<t$ and halves the tolerance per level. It is a non-recursive scheduling of the recursion: acceptance depends only on the panel and its depth, so the final accepted partition does not depend on the order of splits. My recursive implementation (`indep.py`) produces exactly the same 20 panels. The displayed "Approximation" is $\sum S(a,b)$ over the current panels, as in Mathews' animation table. It is not the $\sum(S_{left}+S_{right})$ that the recursive routine returns, and the page says so explicitly (C12).

**Numbers.** I instrumented a scratch copy (`inst.jl`) and compared its output with an independent mpmath recursion using exact rational endpoints (`indep.py`) and with Mathews' table:

| frame | split | points | script | Mathews (same count, different order) |
|---|---|---|---|---|
| 2 | – | 3 | 2.49126102 | 2.491261 |
| 3 | [0,2] | 5 | 1.61178633 | 1.611786 |
| 4 | [0,1] | 7 | 1.90963319 | 1.909633 |
| 5 | [1,2] | 9 | 1.94143608 | 1.941436 |
| 13 | [0,1/8] | 25 | 2.01512435 | 2.015124 |
| 15 | [0,1/16] | 29 | 2.01592031 | 2.015920 |
| 17 | [0,1/64] | 33 | 2.01621925 | 2.016219 |
| 21 | [0,1/1024] | 41 | 2.01625176 | 2.016252 |

Final: script 2.01625176 vs independent 2.01625176116. Rows where both orders have the same partition agree to all six of Mathews' digits.

Property checks (`props.jl`, which uses the script's own `simpson`, `adaptive_node_sets` and `simpson_nonuniform`):
- S is exact for $x^2$ and $x^3$ on [0,2] and not for $x^4$ (error 0.26667, which is the theoretical value). So the degree of precision is 3.
- Adaptive run on $\int_0^1\sqrt{x}\,dx$ with tol 1e-4: 17 panels, composite value 0.66662, error −4.7e-5. This is consistent with a working routine on a problem with a known answer.

**Reference values.** The page's "integral 2.016280" is $\int_0^2 f = 2.0162797196$. I computed it two ways in mpmath at 30 digits: adaptive quad with breakpoints near the $x^{2/3}$ singularity, and the substitution $x=u^3$, which removes the singularity. Both agree to all digits shown. The script itself draws no reference curve or value.

**Picture.** I viewed frames 1, 2, 21 and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21).
- Each pink region is the quadratic interpolant through (p, m, q) of a panel. The fit residual at the nodes is 0, so its area is S(p,q).
- The red verticals are at the panel endpoints.
- The blue dots are the two new midpoints of the split panel.
- The blue label shows the split interval as an exact dyadic fraction.
- The title, the annotations (points, approximation, tol) and the plotted function match the code.
- The axes [0,2]×[0,2.1] contain the whole curve, with max f ≈ 1.92.
- No clamping or masking is used.
- The regenerated GIF is byte-identical to the committed one.

