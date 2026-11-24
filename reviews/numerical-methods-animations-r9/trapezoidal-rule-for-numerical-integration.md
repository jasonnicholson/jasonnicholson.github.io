# Trapezoidal Rule for Numerical Integration — animation review (round 9)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Things I looked at and decided were not findings:
- The intro says "Each animation below" although there is only one animation. It also says "Each new frame recomputes … with a denser partition", but frame 1 shows the curve alone with no partition. The Behavior paragraph refers to "the first partition frame" correctly, so a reader is not misled. Both are wording only.
- The GIF does not print the integrand, although Mathews' GIF did. The page heading and the intro state it, so this is cosmetic.
- The partition sequence differs from Mathews' (his frames include 51, 71 and 101 sample points; this GIF uses 49, 57, 73, 97 and 121), and the GIF has no node markers. Neither difference matters to a reader.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 10.3 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Script lines 18-22 implement exactly this. Agrees with an independent mpmath sum to about 1e-15 for all 23 n | confirmed |
| D2 | Replaces $f$ on each subinterval by the chord between neighbouring nodes | Plot lines 32-42 draw chords $(x_l,f(x_l))$–$(x_r,f(x_r))$. The summed drawn trapezoid areas equal `trapezoid_sum` (n=3: 1.8990708457296055 vs 1.899070845729605; n=120: 2.014944464620341 vs 2.0149444646203434) | confirmed |
| D3 | For $C^2$ $f$, $T_n-I=O(h^2)$ | The script routine on $x^2$ over [0,2] gives error 0.08333 at n=4 and 0.020833 at n=8, ratio 4.000. It is exact for 1 and $x$ | confirmed |
| A1 | Diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8-9 | confirmed |
| A2 | Heading: Composite Trapezoidal Rule, $f$, $[0,2]$ | Script: same f, a=0, b=2, composite rule | confirmed |
| A3 | Each frame recomputes on the full interval with a denser partition | Every frame from n=1 on uses a uniform partition of [0,2], and n strictly increases. Frame 1 has no partition (see Section 1) | confirmed (wording nit only) |
| A4 | Trapezoids become narrower as the sample points increase | Frames 2-24, n = 1…120 | confirmed |
| B1 | $\int_0^2 f\,dx \approx 2.016280$ | mpmath quad, split at singular points: 2.0162797196170963. The substitution $x=t^3$ gives the same value | confirmed |
| B2 | Last frame has 121 sample points and gives 2.014944 | n=120, T=2.0149444646; frame 24 reads "Sample Points = 121, Approximation = 2.014944" | confirmed |
| B3 | "about 0.0013 low" | T−I = −0.00133525 | confirmed |
| B4 | First partition frame has 2 sample points and gives 2.017925 | T_1 = 2.0179248162; frame 2 reads the same | confirmed |
| B5 | Close only by coincidence: the areas above and below the chord almost cancel | T_1−I = +0.001645. The curve crosses the chord three times (frame 2), and T_2 is already off by 0.36, so this is cancellation and not accuracy | confirmed |
| B6 | With 2 subintervals the error jumps to about +0.36 | T_2−I = +0.356647 | confirmed |
| B7 | From 4 subintervals (5 sample points) on, its size shrinks at every frame | \|err\| for n=3,4,5,6,7,8,10,…,120: 0.117, 0.214, 0.194, 0.161, 0.132, 0.110, 0.0785, 0.0590, 0.0462, 0.0372, 0.0307, 0.0259, 0.0192, 0.0149, 0.0119, 0.00826, 0.00611, 0.00473, 0.00312, 0.00193, 0.00134. This decreases strictly from n=4 on, and n=3→4 grows, so "from 4 on" is the right starting point | confirmed |
| B8 | $f'$ is unbounded at 0, with $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ | mpmath diff at x=1e-6 gives 533.3318 against $\tfrac{16}{3}x^{-1/3}$ = 533.3333 | confirmed |
| B9 | The textbook order does not hold, and the error shrinks like $O(h^{5/3})$ | Error ratios when halving h: 3.1415 (24→48), 3.1583, 3.1647, 3.1679, 3.1698, 3.1711, 3.1720, 3.1726 (3072→6144). These tend to $2^{5/3}=3.1748$. The theory agrees: a term $\sim x^{2/3}$ at the endpoint gives $O(h^{1+2/3})$ | confirmed |
| B10 | Halving h divides it by about 3.14 (from 24 to 48 subintervals) | 0.019194/0.0061098 = 3.14152 | confirmed |
| B11 | It tends to $2^{5/3}\approx3.17$ instead of 4 | 3.1748, see B9 | confirmed |
| W1 | `[Julia source](trapezoidalaa.jl)` | The file exists and produces trapezoidalaa.gif | confirmed |
| W2 | Embed `trapezoidalaa.gif` | The committed GIF is byte-identical to the regenerated output of trapezoidalaa.jl | confirmed |
| W3 | Alt text: "over [0,2] with full-interval density refinement: each frame uses a denser partition and updates the global approximation" | Matches frames 2-24. Frame 1 is curve-only (wording nit, same as A3) | confirmed |
| C1 | Count: one case | One script, one GIF | confirmed |

Annotation values in frames: I read 2, 3, 5, 7, 9, 13, 17, 21, 29, 41, 57, 97 and 121 sample points on the contact sheet and on frames 2, 3 and 24. Each value equals `round(T_n, digits=6)` from the instrumented run and the mpmath value.

### 3. Implementation checks: `trapezoidalaa.jl`

- **Method.** It is the uniform-step composite trapezoidal rule (lines 18-22), with the n=1 case handled by an empty interior sum. This is the same variant the Description gives.
- **Numbers.** The instrumented copy of the routine (`instr.jl`) and an independent 30-digit mpmath sum (`check.py`) agree for every n in the sequence, for example n=2: 2.372926966994002 vs 2.372926967; n=24: 1.9970856958540892 vs 1.997085696; n=120: 2.0149444646203434 vs 2.014944465. In the property check, the verbatim routine is exact for 1 and $x$ and has error ratio 4.000 on $x^2$ under halving, so it has degree of precision 1 and order 2.
- **Reference values.** The script draws no reference. The page's integral 2.016280 was verified two ways, by direct quad with breakpoints and by the $x=t^3$ substitution, which removes the singularity: both give 2.01627971961709632788727.
- **Picture.** Each trapezoid is built from $(x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l))$, the correct vertices. The curve is the same f on 800 points. The y-limits (0, 2.1) contain the full range of f (min 0.3572, max 1.9198 at x≈0.080), so nothing is clamped. The annotations at (1.15, 1.88/1.74) sit above the curve there, so nothing is hidden. "Sample Points = n+1" is the correct node count. The frames are 1 curve-only frame plus 23 partitions, 24 in all, which matches the GIF frame count.

### Legacy fidelity

Mathews' animation uses the same integrand $e^{-x}\sin(8x^{2/3})+1$ on [0,2], the same refinement-by-density idea, and the same opening frames (curve only, then 2 sample points giving 2.017925, then 5 points giving 1.802071). His frame values for points that appear in both sequences (9, 13, 17, 25, 33) agree with this script's to six decimals. The differences are the partition sequence and the missing on-plot formula and node dots, and none of them changes what the reader learns. No fidelity findings.

