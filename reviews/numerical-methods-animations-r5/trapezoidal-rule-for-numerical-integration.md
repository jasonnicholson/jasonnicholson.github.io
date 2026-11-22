# Trapezoidal Rule for Numerical Integration — animation review (round 5)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Every numerical and behavioural claim on the page was reproduced to the stated precision by an independent computation, the script implements the composite trapezoidal rule exactly as written in the Description, the drawn trapezoids use the right node heights, and the animation matches the legacy example (same function, interval, final sample count and final value).

Observations that are deliberately not findings (cosmetic, do not mislead):
- The GIF title is "Trapezoidal Rule / Numerical Quadrature" with no formula for f; the legacy GIF printed `y = e^{-x} sin(8x^{2/3}) + 1` on the plot. The page heading and intro state the function, so nothing is contradicted.
- `round(approx; digits=6)` drops trailing zeros, so two frames show five decimals ("1.98554" for n=18, "2.01017" for n=48). Both values are correct to the shown digits.
- The frame sequence differs from the legacy one (the page adds 3, 4, 6, 7, 8, ... sample-point frames; the legacy jumped 2, 5, 9, 13, 17, 25, 33, 51, 71, 101, ..., 121). Endpoints agree; the extra n=2 frame is what the page's "error jumps to +0.36" sentence discusses.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 11.9 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Composite rule: $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Script lines 18-22 implement exactly this (dx=(b-a)/n, half end weights, interior sum; n=1 has empty interior). | confirmed |
| D2 | Description | Replaces f on each subinterval by a line segment between neighbouring nodes | Plot draws shape (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) per subinterval; area = dx(f(xl)+f(xr))/2, which summed equals D1. | confirmed |
| D3 | Description | For $C^2$ f, $T_n - I = O(h^2)$ | `exact.jl`: x^2 error 0.083333 (n=4) → 0.020833 (n=8), ratio 4.000; x^3 ratio 4.0; e^x errors 0.13255, 0.03324, 0.00832 (ratio ≈4). | confirmed |
| A1 | Intro | Diagram over [0,2] for $y=e^{-x}\sin(8x^{2/3})+1$ | Script line 8-9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2`; frames x-axis 0..2. | confirmed |
| A2 | Intro | Each new frame recomputes the approximation on the full interval with a denser partition | n_seq strictly increasing 1..120; every frame partitions all of [0,2] (frames 2-24). Frame 1 is the curve only (no partition), consistent with "first partition frame" below. | confirmed |
| A3 | Intro | Julia source linked under each case | One case, link `trapezoidalaa.jl` present. | confirmed |
| C1 | Case 1 heading | Composite Trapezoidal Rule, f as A1, on [0,2] | Same as A1/D1. | confirmed |
| C2 | Behavior | Trapezoids become narrower as sample points increase | Frames 2→24: 2 to 121 sample points. | confirmed |
| C3 | Behavior | Converges toward $\int_0^2 f \approx 2.016280$ | mpmath, substitution x=t^3 (removes x^{2/3} singularity) gives I = 2.0162797196170963; cross-check with 40-panel direct quad identical to 20 digits. Rounds to 2.016280. | confirmed |
| C4 | Behavior | Last frame: 121 sample points, 2.014944 | Script n=120: T=2.0149444646203434, shown 2.014944; independent 2.014944465; frame_024 reads "Sample Points = 121 / Approximation = 2.014944". | confirmed |
| C5 | Behavior | About 0.0013 low | T_120 − I = −0.00133525. | confirmed |
| C6 | Behavior | Approach not steady at first | Errors n=1..4: +0.00165, +0.3566, −0.1172, −0.2142. | confirmed |
| C7 | Behavior | First partition frame: 2 sample points, 2.017925 | Script n=1: 2.017924816..., shown 2.017925; independent 2.017924816; frame_002 reads the same. | confirmed |
| C8 | Behavior | n=1 close only by coincidence: areas above and below the chord almost cancel | `cancel.py`: chord from f(0)=1 to f(2)=1.017925 crosses f at x=0.2458, 0.6981, 1.2705; area of f above chord 0.280272, below 0.281917, net −0.0016451 (= I − T_1). | confirmed |
| C9 | Behavior | With 2 subintervals the error jumps to about +0.36 | T_2 = 2.372927, error +0.356647. Frame_003 shows 3 points, 2.372927. | confirmed |
| C10 | Behavior | From 4 subintervals (5 sample points) on, its size shrinks at every frame | |error| over n=4,5,6,7,8,10,...,120: 0.2142, 0.1944, 0.1611, 0.1323, 0.1097, 0.0785, 0.0590, 0.0462, 0.0372, 0.0307, 0.0259, 0.0192, 0.0149, 0.0119, 0.00826, 0.00611, 0.00473, 0.00312, 0.00193, 0.00134: strictly decreasing. (n=3→4 grows, 0.117→0.214, which the "from 4 on" wording correctly excludes.) | confirmed |
| C11 | Behavior | $x^{2/3}$ makes f' unbounded at 0, $f'(x)\approx \tfrac{16}{3}x^{-1/3}$ | mpmath diff: f'(1e-3)=53.03 vs 53.33; f'(1e-6)=533.332 vs 533.333. | confirmed |
| C12 | Behavior | Textbook order assumes smooth f and does not hold here | f' unbounded on [0,2], so f ∉ C^2[0,2]; measured ratio ≠ 4 (C14). | confirmed |
| C13 | Behavior | Error shrinks like $O(h^{5/3})$ rather than $O(h^2)$ | Halving ratios (n→2n): 12→24 3.076, 24→48 3.1415, 48→96 3.158, 96→192 3.165, 384→768 3.170, 1536→3072 3.172, 3072→6144 3.1726 → 2^{5/3}=3.1748. Consistent with the generalized Euler-Maclaurin term for an x^{2/3} endpoint singularity (h^{1+2/3}). | confirmed |
| C14 | Behavior | Halving h divides it by about 3.14 (24 to 48 subintervals), tending to $2^{5/3}\approx 3.17$, instead of 4 | Ratio 24→48 = 3.14152; 2^{5/3}=3.1748. Both n=24 and n=48 are frames in the GIF. | confirmed |
| W1 | Link | `[Julia source](trapezoidalaa.jl)` is this case's script | Only script in folder; produces this GIF. | confirmed |
| W2 | Embed | `trapezoidalaa.gif` is this case's animation | Regenerated from the script byte-identical (manifest). | confirmed |
| W3 | Alt text | Animation over [0,2] with full-interval density refinement; each frame uses a denser partition and updates the global approximation | Frames 2-24 as in A2; each shows the new global T_n. | confirmed |
| F1 | Fidelity | Example is Mathews' trapezoidal animation | Legacy GIF: same f (label "y = e^{-x} sin(8x^{2/3})+1"), domain [0,2], 2 points 2.017925, 5 points 1.802071, 9 points 1.906595, 13 points 1.957234, 17 points 1.979056, 25 points 1.997086, 33 points 2.004331, final 121 points 2.014944: all equal to the new script's values. The legacy module lists one trapezoidal animation; none is dropped. | confirmed |

### 3. Implementation checks — `trapezoidalaa.jl`

**Is the method it claims.** `trapezoid_sum(n)` is the composite trapezoidal rule with n equal subintervals on [a,b]=[0,2], end weights 1/2, interior weights 1, times h. Not a variant. Running the function verbatim on polynomials (`inst/exact.jl`): constants and x integrate exactly (error 0.0 at n=4 and n=8); x^2 and x^3 do not (errors 0.08333 and 0.25 at n=4), confirming degree of precision 1; errors fall by 4.000 on halving for smooth integrands (x^2, x^3, e^x), confirming order 2.

**Numbers are right.** Script output (instrumented copy) vs independent mpmath:

| n | pts | script T_n | independent T_n | shown | error vs I |
|---|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816 | 2.017925 | +0.0016451 |
| 2 | 3 | 2.372926966994002 | 2.372926967 | 2.372927 | +0.356647 |
| 3 | 4 | 1.899070845729605 | 1.899070846 | 1.899071 | −0.117209 |
| 4 | 5 | 1.8020714882340843 | 1.802071488 | 1.802071 | −0.214208 |
| 8 | 9 | 1.9065949303145524 | 1.90659493 | 1.906595 | −0.109685 |
| 16 | 17 | 1.97905585678816 | 1.979055857 | 1.979056 | −0.0372239 |
| 24 | 25 | 1.9970856958540892 | 1.997085696 | 1.997086 | −0.019194 |
| 48 | 49 | 2.0101699260596675 | 2.010169926 | 2.01017 | −0.00610979 |
| 96 | 97 | 2.0143452207227672 | 2.014345221 | 2.014345 | −0.0019345 |
| 120 | 121 | 2.0149444646203434 | 2.014944465 | 2.014944 | −0.00133525 |

All 23 n values agree to at least 9 significant digits (full list in `indep.py` and `trap_inst.jl` output reproduced in the ledger rows).

**Reference values.** The script draws no reference value. The page's reference integral 2.016280 was verified as above (two independent mpmath quadratures agree to 20 digits; the first removes the endpoint singularity by x=t^3).

**Picture shows what was computed.** Each subinterval is drawn as the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) plus the chord from (xl,f(xl)) to (xr,f(xr)), so trapezoid tops sit on the curve at the nodes (checked visually in frames 2, 3, 20, 24 and the contact sheet). Labels: "Sample Points = n+1" is the node count; "Approximation" is `trapezoid_sum(n)` for the same n used to draw. Frame k (k≥2) shows n_seq[k−1]: frame 3 = 3 points, frame 20 = 49 points, frame 24 = 121 points, all matching. Axis limits (0..2, 0..2.1) contain the whole curve (max f = 1.91975). The 800-point curve shows the steep rise at x=0 adequately. No clamping or masking is used. 24 frames: 1 curve-only frame plus 23 partitions.

