# Rational Approximation — animation review (round 3)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. Every numerical claim on the page matches my independent computation at the precision it is stated to. The method is the one the page names. The three frames show what the script computed.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 7.4 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rationalapproxaa.gif` | 3 | byte-identical | rationalapproxaa |

### Page references

- Scripts linked: `rationalapproxaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | $R_{m,n}=P_m/Q_n$, $Q_n\neq0$ | Script uses $P_2/Q_2$ with $Q=1+b_1x+b_2x^2$. Over [-1,1], min Q is 0.5818 for all three fits, and Q has complex roots $3.06\pm1.70i$ | confirmed |
| 2 | Description | Mathews compares equally spaced nodes, Chebyshev nodes, and MiniMax over a fixed interval | Archive Examples 1 and 2 have parts (a), (b), (c) exactly so, on [-1,1] | confirmed |
| 3 | Description | MinMax minimizes $\max\lvert(f-R)/f\rvert$ | Archive lnk_4: "the MiniMax rational approximation is minimizing the 'relative error.'" The script's Remez targets relative error | confirmed |
| 4 | Animations intro | $f(x)=e^x$ on $[-1,1]$, fixed $[2/2]$ form | Script lines 12, 14, 134. Archive gr_9 shows $R_{2,2}$ and gr_10 shows $f=e^x$ | confirmed |
| 5 | Animations intro | Order: (1) equal nodes, (2) Chebyshev nodes, (3) minimax | `methods` array, lines 150–154. Frame titles 1/2/3 match | confirmed |
| 6 | Animations intro | Minimax "computed here by the Remez exchange algorithm" | `remez_minimax`: Newton solve of the 6-point levelled reference system, then exchange to the extrema of each sign interval. This is a standard multi-point Remez for rational relative error | confirmed |
| 7 | Line 30 | No archived animation GIF exists for this topic | No rational-approximation files under `a2001/Animations/`. No GIF of height ≥ 100 in the module is animated | confirmed |
| 8 | Line 30 | Reconstructed from Example 1 | Example 1 is $R_{2,2}$ for $e^x$ on [-1,1] with (a), (b), (c) | confirmed |
| 9 | Line 31 | Example 2: $[4/4]$, $e^x$, equal, Chebyshev and MiniMax | gr_113 shows $R_{4,4}$, gr_114 shows $e^x$. The module text lists parts 2(a), 2(b) and 2(c) MiniMax | confirmed |
| 10 | Line 31 | Exercise 3 / Examples 4–5: $[4/4]$ for $\cos(\pi x/2)$, $\tan x$, $\arctan x$, equal and Chebyshev only | gr_216/217, gr_295/296 and gr_375/376 show $R_{4,4}$ and those functions. Each has only parts (a) and (b) | confirmed |
| 11 | Line 31 | These are not animated here | One script and one GIF, both for Example 1 | confirmed |
| 12 | Heading | Case 1: Rational $[2/2]$ for $e^x$ on $[-1,1]$: equal, Chebyshev, MinMax | Matches the script and the frame titles | confirmed |
| 13 | Behavior | Both interpolants are exact at their nodes | mpmath residuals at the nodes are ≤ 2e-41 for both. Q is nonzero at the nodes, so there are no unattainable points | confirmed |
| 14 | Behavior | Equal-node max rel. error about $1.59\times10^{-4}$ | Independent: 1.5936614e-4. Script grid: 1.5936498e-4 | confirmed |
| 15 | Behavior | Equal-node error largest near $x\approx\pm0.82$ | Independent peaks at $x=\pm0.82442661$ (1.59341e-4 and 1.59366e-4). The interior peaks at ±0.2729 are only 6.0e-5 | confirmed |
| 16 | Behavior | Chebyshev max rel. error $8.94\times10^{-5}$ | Independent: 8.9419212e-5, reached at $x=-1$. Script: 8.941921e-5 | confirmed |
| 17 | Behavior | Minimax max rel. error $8.68\times10^{-5}$, the smallest possible for this form | Independent Remez: $E=8.67978639860892\times10^{-5}$. Script: 8.679786398606e-5. Optimality follows from the equioscillation theorem: there are 6 = 2+2+2 alternation points, $p_2,q_2\neq0$ (defect 0), and Q has no zero in [-1,1] | confirmed |
| 18 | Behavior | Minimax is about 3% below Chebyshev | (8.94192 − 8.67979)/8.94192 = 2.93% | confirmed |
| 19 | Behavior | Alternating sign at six points $x=-1,\pm0.812,\pm0.312,1$ | Independent: −1, ∓0.8123042914, ∓0.3124145944, 1, with signed errors −,+,−,+,−,+ each 8.679786399e-5. Script: ±0.81230432, ±0.3124145 (golden-section agreement to 3e-7) | confirmed |
| 20 | Behavior | The relative-error curve in the last frame is equal-ripple | Frame 3: all six peaks of the plotted $\lvert f-R\rvert/\lvert f\rvert$ sit at the same height, about 8.7e-5 | confirmed |
| 21 | Link | [Julia source](rationalapproxaa.jl) is this case's script | Present in the folder. It produces `rationalapproxaa.gif` | confirmed |
| 22 | Embed | `rationalapproxaa.gif` is this case | It is produced by `rationalapproxaa.jl`, byte-identical on regeneration | confirmed |
| 23 | Alt text | Three frames | The GIF has 3 frames | confirmed |
| 24 | Alt text | Max rel. errors 1.59e-4, 8.94e-5, 8.68e-5; minimax from Remez; equal-ripple | See rows 14, 16, 17 and 20. The frame legends read 0.0001594, 8.94e-5 and 8.68e-5 | confirmed |
| 25 | Alt text | Each frame has function and relative-error panels | All 3 frames have a top panel (f, R, nodes) and a bottom panel ($\lvert f-R\rvert/\lvert f\rvert$) | confirmed |

The frame content is consistent with the page. The titles name the correct construction, and the red node markers sit at {−1, −0.5, 0, 0.5, 1} in frame 1 and at {±0.9511, ±0.5878, 0} in frame 2. Frame 3 has no node markers. The y-ranges (0.2–3.0 in the top panel, 0–2e-4 in the bottom panel) contain all of the data: exp ranges over [0.368, 2.718] and the largest error is 1.594e-4.

### 3. Implementation checks: `rationalapproxaa.jl`

**It is the method it claims to be.**
- Frames 1 and 2 use linearized rational interpolation, $P(x_i)-f(x_i)(b_1x_i+b_2x_i^2)=f(x_i)$, with 5 conditions for 5 unknowns. This is the construction in Mathews' Example 1(a) and 1(b) (archive gr_13: $R=(p_0+p_1x+p_2x^2)/(1+q_1x+q_2x^2)$).
- The equally spaced nodes are `range(-1,1,length=5)`. The Chebyshev nodes are $\cos((2k-1)\pi/10)$ for k = 1..5, the zeros of $T_5$.
- Frame 3 uses a Remez exchange for minimax relative error:
  - The starting reference is the 6 extrema of $T_5$.
  - Each step solves $P(x_i)=f(x_i)(1-s_iE)Q(x_i)$ by Newton's method. The sign convention $s_i=(-1)^i$ with 1-based i is used consistently.
  - The exchange takes the extremum of |error| on each constant-sign interval of a 20001-point grid, refined by golden-section search.
  - It stops when the ripple spread falls below 1e-10·max.
- This is a standard Remez variant for rational functions. The page does not describe a different variant. Mathews used Mathematica's `MiniMaxApproximation`, which targets the same relative-error minimax approximant, and the page says plainly that its own approximant is computed by Remez.

**The numbers are right.** Script values from the instrumented copy, against the independent mpmath values:

| Quantity | Script | Independent (mpmath, 40 digits) |
|---|---|---|
| c_eq (a0,a1,a2,b1,b2) | 1.0, 0.499831480449, 0.0816120384126, −0.499831480449, 0.0816120384126 | 1.0, 0.499831480449, 0.0816120384126, −0.499831480449, 0.0816120384126 |
| c_ch | 1.0, 0.499789375888, 0.0816032216119, −0.499789375888, 0.0816032216119 | identical to 12 digits |
| c_mm | 0.999999996233065, 0.49978562382661, 0.0815926963252, −0.499785625709263, 0.0815926966326 | 0.999999996233065, 0.499785623826607, 0.0815926963252367, −0.499785625709266, 0.0815926966325911 |
| max rel err, equal | 1.5936498e-4 (1201-point grid) | 1.5936614e-4 (true peak at x = 0.82443) |
| max rel err, Chebyshev | 8.9419212e-5 | 8.9419212e-5 |
| minimax E | 8.679786398606e-5 | 8.67978639860892e-5 |
| alternation points | −1, −0.81230427, −0.31241468, 0.31241432, 0.81230432, 1 | −1, ∓0.8123042914, ∓0.3124145944, 1 |
| signed error at reference | −,+,−,+,−,+ × 8.6797864e-5 | −,+,−,+,−,+ × 8.679786399e-5 |

Property checks:
- The interpolation residual at the nodes is ≤ 2e-41.
- The minimax error equioscillates at n+m+2 = 6 points with equal magnitude.
- The script's own Remez iterates settle to the same E (ripple spread 7e-16 by iteration 3).
- The denominator has no zeros in [-1,1] (min Q ≈ 0.5818), so the `abs(den)<1e-10` clamp in `eval_rational` is never triggered.

**Reference values.** The reference function is `exp` itself, evaluated in Float64. No numerically computed "exact" values are involved.

**The picture shows what was computed.**
- The top panel draws `f` and `R` built from the same coefficient vector `c` that the legend's error figure uses (`max_relative_error(c, x_grid, f_grid)`). The node markers are `xs`/`ys` for the matching method.
- The bottom panel is $\lvert f-R\rvert/\lvert f\rvert$ on 700 points, as the y-label states.
- No masking or clamping is in effect.
- There are 3 frames, one per method, at fps=1.
- The frames show the equal-node peaks near ±0.82 (frame 1), the endpoint-dominated Chebyshev error (frame 2), and the six equal peaks (frame 3), matching the computed values.

**Fidelity note (not a finding).** Mathews' Example 1(a)/(b) solution pages plot the absolute error $f-R$ (archive gr_29, peak about −3.7e-4 near x = 0.85). The page and GIF use relative error for all three frames, which matches the quantity MiniMax minimizes, and label it as relative error throughout. A reader is not misled by this.

