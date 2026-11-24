# Trapezoidal Rule for Numerical Integration — animation review (round 8)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Considered and not raised:
- Intro says "Each animation below shows..." (plural) while there is one case. Wording only; nothing a reader would conclude wrongly.
- Intro says "Each new frame recomputes the approximation ... with a denser partition"; frame 1 is the curve alone (n = 0, no approximation). The Behavior paragraph explicitly refers to "the first partition frame", so this does not mislead.
- Legacy GIF uses a different partition sequence (ends at 101 sample points, 2.014472) than the page (ends at 121, 2.014944). Same function, interval, style and frame count (24); the different sequence does not change what the reader learns. Not a fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 10.2 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description: $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Script `trapezoid_sum` (l.18-22) is exactly this; script routine reproduces mpmath implementation at all 23 n | confirmed |
| 2 | "For smooth f (C^2 on [a,b]) the global truncation error is second order, O(h^2)" | Script routine on e^x over [0,2]: error ratio n=8→16 = 3.9969 (≈4); on x^2, n=4: error 0.083333 = (b-a)h^2 f''/12 | confirmed |
| 3 | Intro/heading: f(x)=e^{-x} sin(8x^{2/3})+1 on [0,2] | Script l.8-9; matches legacy GIF title | confirmed |
| 4 | "Each new frame recomputes the approximation on the full interval with a denser partition" | n_seq strictly increasing (l.11-12); each frame calls trapezoid_sum(n) on [a,b]; frame 1 is n=0 curve only | confirmed |
| 5 | "trapezoids across the entire interval become narrower" | frames: partitions refine over whole [0,2] | confirmed |
| 6 | True integral ≈ 2.016280 | mpmath quad (two independent splittings incl. x=t^3 substitution): 2.0162797196 | confirmed |
| 7 | Last frame 121 sample points gives 2.014944 | n=120: script 2.014944, mpmath 2.0149444650; frame_024 shows "Sample Points = 121 / Approximation = 2.014944" | confirmed |
| 8 | "about 0.0013 low" | error −0.00133525 | confirmed |
| 9 | First partition frame: 2 sample points, 2.017925 | n=1: 2.0179248162; frame_002 shows same | confirmed |
| 10 | Close only by coincidence: areas above/below chord f(0)→f(2) nearly cancel | error +0.001645; frame_002 shows chord from 1.0 to 1.0179 with the curve well above and below it | confirmed |
| 11 | "With 2 subintervals the error jumps to about +0.36" | n=2: T=2.372927, error +0.356647 | confirmed |
| 12 | "from 4 subintervals (5 sample points) on its size shrinks at every frame" | \|error\| for n=4,5,6,7,8,10,...,120: 0.2142, 0.1944, 0.1611, 0.1323, 0.1097, 0.0785, 0.0590, 0.0462, 0.0372, 0.0307, 0.0259, 0.0192, 0.0149, 0.0119, 0.00826, 0.00611, 0.00473, 0.00312, 0.00193, 0.00134 — strictly decreasing; n=3 (0.117) < n=4 (0.214), so "from 4" is the right start | confirmed |
| 13 | f' unbounded at 0, f'(x) ≈ (16/3) x^{-1/3} near 0 | d/dx sin(8x^{2/3}) = cos(8x^{2/3})·(16/3)x^{-1/3}; e^{-x}, cos → 1 as x→0 | confirmed |
| 14 | Textbook order does not hold; error shrinks like O(h^{5/3}) | Endpoint x^{2/3} singularity gives O(h^{1+2/3}); measured ratios on halving: 3.1415 (24→48), 3.1583, 3.1647, 3.1679, 3.1698, 3.1711, 3.1720, 3.1726 (3072→6144) → 2^{5/3}=3.1748 | confirmed |
| 15 | "halving h divides it by about 3.14 (from 24 to 48 subintervals)" | 3.1415 | confirmed |
| 16 | "tending to 2^{5/3} ≈ 3.17, instead of 4" | 2^{5/3}=3.1748; sequence above approaches it | confirmed |
| 17 | Source link `trapezoidalaa.jl` | file exists, is the script for this case | confirmed |
| 18 | Embed `trapezoidalaa.gif` is this case | byte-identical to regeneration of trapezoidalaa.jl | confirmed |
| 19 | Alt text: over [0,2], full-interval density refinement, each frame denser partition, updates the global approximation | frames 2–24 | confirmed |
| 20 | Frame annotation "Sample Points = n+1" | n subintervals → n+1 nodes | confirmed |

### 3. Implementation checks — `trapezoidalaa.jl`

**Method.** `trapezoid_sum(n)` (l.18-22) is the composite trapezoidal rule with equal spacing, endpoints weighted ½; n=1 handled (interior sum 0). Not a neighbouring method.

**Numbers.** Instrumented copy (`review/instr.jl`, extracting l.8-22 and printing) vs independent mpmath (30 digits, `review/check.py`); all 23 values agree to the 6 decimals displayed:

| n | script | mpmath |
|---|---|---|
| 1 | 2.017925 | 2.017924816 |
| 2 | 2.372927 | 2.372926967 |
| 4 | 1.802071 | 1.802071488 |
| 8 | 1.906595 | 1.906594930 |
| 24 | 1.997086 | 1.997085696 |
| 48 | 2.01017 | 2.010169926 |
| 96 | 2.014345 | 2.014345221 |
| 120 | 2.014944 | 2.014944465 |

(Full list in check.py output; all agree.) Property checks with the script's own routine: exact for 1 and x (error 0.0), x^2 with n=4 error 0.0833333 = h^2(b-a)f''/12 (degree of precision 1); e^x error ratio on halving 3.9969 (order 2 for smooth f).

**Reference values.** The script draws no reference; the page's 2.016280 was checked by mpmath quad with two independent decompositions (direct with breakpoints, and t^3 substitution removing the singularity), both 2.01627971961709632788.

**Picture.** Each trapezoid is the shape (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) with chord f(xl)→f(xr) (l.32-41) — correct nodes and heights. Curve drawn from the same f. ylims (0, 2.1) contain the curve (max ≈ 1.917 near x ≈ 0.087); no clamping or masking. Annotations at y=1.74–1.88, x≈1.15 sit above the curve there (f(1.15) < 1.4), legible in frames 2 and 24. 24 frames = blank curve + 23 partitions. Frames 2, 3–12 (contact sheet) and 24 inspected; annotations match computed values.

**Legacy.** Mathews' animation uses the same f, interval and visual (pink trapezoids, magenta curve), 24 frames, sample-point sequence 2,5,9,13,17,25,33,51,71,101,... with final 2.014472. Page's 2.017925 (2 pts), 1.802071 (5), 1.906595 (9), 1.957234 (13), 1.979056 (17), 1.997086 (25), 2.004331 (33) all match legacy frame values. Different later sequence is not a finding.

