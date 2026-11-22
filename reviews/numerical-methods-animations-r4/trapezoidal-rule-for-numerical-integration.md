# Trapezoidal Rule for Numerical Integration — animation review (round 4)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with independent computation (to the precision stated), the script implements the composite trapezoidal rule correctly, and the frames show what is computed.

Observations deliberately not raised as findings (cosmetic, do not mislead):
- The on-frame value uses `round(approx; digits=6)`, which drops trailing zeros (n=18 shows `1.98554`, n=48 shows `2.01017`). Values are correct.
- The alt text says "each frame uses a denser partition"; frame 1 is the bare curve with no partition (an intro frame). Harmless.
- The GIF does not print the function on the frame (the legacy one did); the page states the function in the intro and heading, and it matches the code.
- The sequence of n differs from the legacy one in a few middle frames (page: 48, 56, 72, 96 subintervals; legacy shows 50, 70, 100 subintervals). Function, interval, first and last frames, and shared frames' values match the legacy exactly. Not a departure that matters to a reader.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 9.8 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `trapezoidalaa.gif` | 24 | byte-identical | trapezoidalaa |

### Page references

- Scripts linked: `trapezoidalaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Composite trapezoidal rule replaces f on each subinterval by a line segment between neighbouring nodes | script lines 18-22, 32-41 | confirmed |
| D2 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | `trapezoid_sum` is exactly this; independent mpmath T(n) agrees to all printed digits | confirmed |
| D3 | For $f\in C^2[a,b]$, $T_n - I = O(h^2)$ | own routine on $e^x$ on [0,1]: errors 1.4317e-3, 3.5796e-4, 8.9493e-5 for n=10,20,40 (ratio 4.00); $x^2$ on [0,2], n=4: error 0.08333 = $(b-a)h^2 f''/12$ | confirmed |
| A1 | Diagram over [0,2] for $y=e^{-x}\sin(8x^{2/3})+1$ | script line 8-9, xlims (0,2) | confirmed |
| A2 | Each new frame recomputes on the full interval with a denser partition | n_seq strictly increasing; whole-interval sum each frame; frames 2-24 | confirmed (frame 1 is a curve-only intro) |
| A3 | Julia source linked under the case | `[Julia source](trapezoidalaa.jl)` exists, produces `trapezoidalaa.gif` | confirmed |
| C1 | Heading: Composite Trapezoidal Rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | code line 8-9 | confirmed |
| B1 | Converges toward true integral $\approx 2.016280$ | mpmath, substitution $x=t^3$: I = 2.0162797196170963; plain adaptive quad with 40 subintervals agrees to 30 digits | confirmed |
| B2 | Last frame 121 sample points gives 2.014944 | script n=120: 2.0149444646; mpmath 2.014944465; frame_024 shows "Sample Points = 121", "Approximation = 2.014944" | confirmed |
| B3 | ... about 0.0013 low | error -0.00133525 | confirmed |
| B4 | First partition frame: 2 sample points, 2.017925 | 2.0179248162; frame_002 | confirmed |
| B5 | Close only by coincidence: areas above/below chord almost cancel | chord crosses f at x=0.24576, 0.69813, 1.2705; area above chord 0.28027, below -0.28192, net -0.001645 (=I-T_1) | confirmed |
| B6 | With 2 subintervals the error jumps to about +0.36 | T_2 = 2.372927, error +0.356647 | confirmed |
| B7 | From 4 subintervals (5 sample points) on, error size shrinks at every frame | |e|: n=4 0.214208, 5 0.194387, 6 0.161092, 7 0.132297, 8 0.109685, 10 0.0785151, 12 0.0590458, 14 0.0461735, 16 0.0372239, 18 0.0307399, 20 0.0258823, 24 0.019194, 28 0.014893, 32 0.0119486, 40 0.00826282, 48 0.00610979, 56 0.00473227, 72 0.00311897, 96 0.0019345, 120 0.00133525 (strictly decreasing); n=3 0.117209 < n=4, so "from 4" is the right start | confirmed |
| B8 | $f'$ unbounded at 0, $f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0 | analytic: $f' = e^{-x}[\tfrac{16}{3}x^{-1/3}\cos(8x^{2/3}) - \sin(8x^{2/3})]$; numeric at x=1e-6: 533.3318 vs 533.3333 | confirmed |
| B9 | Textbook order (smooth f) does not hold here | f not C^1 at 0 | confirmed |
| B10 | Error shrinks like $O(h^{5/3})$ | ratios e(n)/e(2n): n=12 3.0763, 24 3.1415, 48 3.1583, 96 3.1647, 192 3.1679, 384 3.1698, 768 3.1711, 1536 3.1720 -> 2^{5/3}=3.17480 (consistent with endpoint $x^{2/3}$ singularity, error ~ $h^{1+2/3}$) | confirmed |
| B11 | Halving h divides it by about 3.14 (24 to 48 subintervals) | 0.019194/0.00610979 = 3.1415 | confirmed |
| B12 | ... tending to $2^{5/3}\approx 3.17$, instead of 4 | see B10 | confirmed |
| G1 | Alt text: over [0,2], full-interval density refinement, each frame denser partition, updates global approximation | frames 2-24 | confirmed (frame 1 intro has no partition; trivial) |
| G2 | Embed points at `trapezoidalaa.gif`, the output of the linked script | manifest: byte-identical regen | confirmed |
| W1 | One case, one script, one GIF | page folder listing | confirmed |

All on-frame "Approximation" values checked against the instrumented script output for frames 2, 3, 5, 7, 9, 13, 17, 21, 29, 41, 57, 97, 121 sample points (contact sheet and frames 2, 3, 24): all match.

### 3. Implementation checks — `trapezoidalaa.jl`

**Is the method it claims.** `trapezoid_sum(n)` is the composite trapezoidal rule with uniform h=(b-a)/n, endpoint weights h/2, interior weights h (n=1 handled by empty interior). Drawing: each panel is the quadrilateral (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) plus the chord — the trapezoids whose areas sum to T_n.

**Numbers right.** Instrumented copy (`review/instr.jl`, lines 1-22 of the script plus print loop) vs independent mpmath (`review/indep.py`, 30 digits):

| n | sample pts | script | independent | error vs I |
|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816 | +0.0016451 |
| 2 | 3 | 2.372926966994002 | 2.372926967 | +0.356647 |
| 3 | 4 | 1.899070845729605 | 1.899070846 | -0.117209 |
| 4 | 5 | 1.8020714882340843 | 1.802071488 | -0.214208 |
| 8 | 9 | 1.9065949303145524 | 1.90659493 | -0.109685 |
| 24 | 25 | 1.9970856958540892 | 1.997085696 | -0.019194 |
| 48 | 49 | 2.0101699260596675 | 2.010169926 | -0.00610979 |
| 120 | 121 | 2.0149444646203434 | 2.014944465 | -0.00133525 |

(all 23 values agree; full list in `instr.jl` output / `indep.py` output). Property checks with the same routine: linear 3x+2 on [0,2], n=1 gives 10.0 exactly; x^2 on [0,2], n=4 gives 2.75 vs 8/3 (error 0.0833 = predicted); e^x error ratio 4.00 on halving.

**Reference values right.** The script draws no reference; the page's I ≈ 2.016280 is checked in B1 by two independent quadratures (singularity removed by x=t^3, and subdivided adaptive), agreeing to 30 digits: 2.01627971961709632788727442192.

**Picture shows what was computed.** Frames 2, 3, 24 and the contact sheet inspected: panels have corners at f evaluated at the nodes; chords drawn between consecutive nodes; curve f drawn with 800 points; "Sample Points = n+1" and "Approximation" match the computation. y-range (0, 2.1) contains f (max ≈ 1.92 near x≈0.08, min of f ≥ 1-e^{-x} ≥ 0); no clamping or masking. 24 frames = 1 intro + 23 partitions. Annotations sit at x≈0.8-1.5, y≈1.74-1.88, clear of the curve (f ≤ 1.39 there).

**Legacy fidelity.** Legacy animation: same function $e^{-x}\sin(8x^{2/3})+1$ on [0,2], 24 frames, last frame "Sample Points = 121, Approximation = 2.014944", shared frames (2, 5, 9, 13, 17, 25, 33 points) show identical values to the page's GIF. No fidelity finding.

