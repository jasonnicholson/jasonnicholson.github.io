# Trapezoidal Rule for Numerical Integration — animation review (round 6)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every value in the frames agreed with independent computation. No Error, Misleading or Minor findings.

Observations deliberately not raised as findings (cosmetic, not misleading):
- `trapezoidalaa.jl:46` uses `round(approx; digits=6)`, which drops trailing zeros, so two frames show five decimals (`Approximation = 1.98554` for n=18, true 1.985539815; `Approximation = 2.01017` for n=48, true 2.010169926). Both are still correct to the displayed precision. `@sprintf("%.6f", approx)` would make them uniform if wanted.
- The intro says "Each animation below" although there is one animation, and frame 1 is a blank curve-only frame (n=0) rather than a partition. Neither changes what a reader concludes.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 9.6 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | Composite trapezoidal rule replaces f on each subinterval by a line segment between neighbouring nodes | Script draws/sums chord trapezoids per subinterval (lines 31-42, 18-22) | confirmed |
| D2 | Description | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Matches `trapezoid_sum` exactly (dx=(b-a)/n, half-weighted endpoints) | confirmed |
| D3 | Description | For $f\in C^2[a,b]$ the global error is $O(h^2)$ | Script routine on $\int_0^2\sin$: error ratio on halving 4.0031, 4.0008, 4.0002 (`order.jl`); on $x^2$ with n=4 error 0.08333 = $(b-a)h^2 f''/12$ | confirmed |
| A1 | Animations intro | Diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8-9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0.0,2.0` | confirmed |
| A2 | Animations intro | Each new frame recomputes on the full interval with a denser partition | n sequence 1,2,3,4,5,6,7,8,10,...,120 strictly increasing; every frame partitions all of [0,2] (frames viewed). Frame 1 is an n=0 curve-only frame | confirmed |
| A3 | Intro | Julia source linked under each case | `[Julia source](trapezoidalaa.jl)` present under Case 1 | confirmed |
| C1 | Case 1 heading | Composite trapezoidal rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Script lines 8-9, 18-22 | confirmed |
| C2 | Behavior | Trapezoids across the entire interval become narrower as sample points increase | Frames 2-24, n increasing | confirmed |
| C3 | Behavior | Approximation converges toward $\int_0^2 f\approx 2.016280$ | mpmath quad (30 digits) 2.0162797196171; cross-checked with substitution $x=t^3$: identical. Rounds to 2.016280 | confirmed |
| C4 | Behavior | Last frame (121 sample points) gives 2.014944 | Script: 2.0149444646 (n=120, 121 points); mpmath 2.014944465; frame_024 shows "Sample Points = 121 / Approximation = 2.014944" | confirmed |
| C5 | Behavior | ...about 0.0013 low | error −0.00133525 | confirmed |
| C6 | Behavior | The approach is not steady at first | errors +0.0016, +0.357, −0.117, −0.214, ... | confirmed |
| C7 | Behavior | First partition frame: 2 sample points, 2.017925 | n=1: 2.0179248162; frame_002 shows "Sample Points = 2 / Approximation = 2.017925" | confirmed |
| C8 | Behavior | Close only by coincidence: areas above and below the chord from f(0) to f(2) almost cancel | `cancel.py`: chord crossings at x=0.24576, 0.69813, 1.27046; area above chord 0.28027, below 0.28192, net −0.001645 (= T1 − I exactly) | confirmed |
| C9 | Behavior | With 2 subintervals the error jumps to about +0.36 | n=2: T=2.372927, error +0.356647 | confirmed |
| C10 | Behavior | From 4 subintervals (5 sample points) on, its size shrinks at every frame | |error| for n=4,5,6,7,8,10,12,14,16,18,20,24,28,32,40,48,56,72,96,120: 0.2142, 0.1944, 0.1611, 0.1323, 0.1097, 0.0785, 0.0590, 0.0462, 0.0372, 0.0307, 0.0259, 0.0192, 0.0149, 0.0119, 0.00826, 0.00611, 0.00473, 0.00312, 0.00193, 0.00134 — strictly decreasing. (Not true from n=3: 0.117 → 0.214, consistent with the page's "from 4") | confirmed |
| C11 | Behavior | $x^{2/3}$ makes $f'$ unbounded at 0; $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | mpmath: $f'(10^{-9})\cdot 10^{-3}$ = 5.3333333 vs 16/3 | confirmed |
| C12 | Behavior | Textbook $O(h^2)$ does not hold; measured error shrinks like $O(h^{5/3})$ | Halving ratios: 20→40 3.132, 24→48 3.142, 40→80 3.156, 60→120 3.161, 120→240 3.166, 1000→2000 3.171, 10000→20000 3.173, approaching $2^{5/3}=3.1748$; consistent with leading singular term $x^{2/3}$ giving $h^{1+2/3}$ | confirmed |
| C13 | Behavior | Halving h divides error by about 3.14 (24 → 48 subintervals) | 0.019194/0.0061098 = 3.1415 | confirmed |
| C14 | Behavior | Tending to $2^{5/3}\approx 3.17$, instead of 4 | $2^{5/3}=3.1748$; ratios above approach it | confirmed |
| W1 | Wiring | Source link `trapezoidalaa.jl` is the case's script | File exists; it produces `trapezoidalaa.gif` (line 52) | confirmed |
| W2 | Wiring | Embed `trapezoidalaa.gif` is that script's output | Manifest: regen byte-identical to committed GIF | confirmed |
| W3 | Alt text | Animation over [0,2] with full-interval density refinement; each frame uses a denser partition and updates the global approximation | Frames 2-24; each annotation equals script's value for that n (spot-checked 12 frames on contact sheet + frames 2, 3, 24) | confirmed |

### 3. Implementation checks — `trapezoidalaa.jl`

**Is the method it claims to be.** `trapezoid_sum(n)` (lines 18-22) is the standard composite trapezoidal rule with equal spacing dx=(b−a)/n, endpoint weights 1/2, interior weights 1. Not a midpoint/Riemann variant. The drawing (lines 31-42) builds each trapezoid from (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) — the same nodes the sum uses.

**Numbers are right.** Instrumented copy (`review/instr.jl`, lines 8-22 of the script verbatim plus a print loop) vs independent mpmath sum (`review/indep.py`, 30 digits):

| n | pts | script | independent | error vs I |
|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816 | +0.0016451 |
| 2 | 3 | 2.372926966994002 | 2.372926967 | +0.356647 |
| 3 | 4 | 1.899070845729605 | 1.899070846 | −0.117209 |
| 4 | 5 | 1.8020714882340843 | 1.802071488 | −0.214208 |
| 8 | 9 | 1.9065949303145524 | 1.906594930 | −0.109685 |
| 16 | 17 | 1.97905585678816 | 1.979055857 | −0.0372239 |
| 24 | 25 | 1.9970856958540892 | 1.997085696 | −0.019194 |
| 48 | 49 | 2.0101699260596675 | 2.010169926 | −0.00610979 |
| 96 | 97 | 2.0143452207227672 | 2.014345221 | −0.0019345 |
| 120 | 121 | 2.0149444646203434 | 2.014944465 | −0.00133525 |

All 23 values agree to ≥ 9 digits (full table in `instr.jl`/`indep.py` output). Property checks on the script's own routine (`order.jl`, `instr.jl`): linear integrand $3x+1$ on [0,2] exact (8.0); $x^2$ with n=4 gives 2.75 vs 8/3, error 0.08333 = $(b-a)h^2f''/12$ (degree of precision 1, not 2); smooth $\sin$ on [0,2] error ratios 4.003, 4.001, 4.000 on halving (order 2).

**Reference values.** The script draws no reference value. The page's reference $\int_0^2 f = 2.016280$ was verified with mpmath adaptive quadrature split near the singular point and, independently, via the substitution $x=t^3$ that removes the singularity: both 2.01627971961709632788727442192.

**Picture shows what was computed.** Frames 1, 2, 3, 24 viewed individually; contact sheet (frames 1,3,5,7,9,13,17,21,29,41,57,97 sample points) viewed. Frame 1: curve only. Frame 2: single chord from (0,1) to (2,1.0179), shaded trapezoid, annotation 2.017925. Frame 3: chords to (1, f(1)≈1.36) — matches f(1)=e^{-1}sin 8+1=1.364. Each annotation's "Sample Points" equals n+1 and "Approximation" equals the script's value for that n. Magenta curve is f on 800 points; ylims (0, 2.1) contain the full range of f (max 1.9198, min ≈0.36), so no clipping. f(0)=1 is evaluated correctly (0.0^(2/3)=0). Frame count 24 = one blank + 23 partitions. Nothing misleading.

### Legacy archive (fidelity)

Consulted `n2003/TrapezoidalRuleMod.html` (theorem, composite rule, remainder, two worked examples with m=1,2,4,8,16 and m=50..800 — worked examples, not animations; the page lists a worked example as planned, so out of scope) and the legacy animation `a2001/Animations/Quadrature/Trapezoidal/Trapezoidalaa.gif` (24 frames, extracted to `review/legacy/frames/`). The legacy animation uses the same function $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], with sample points 2,3,5,7,9,11,13,15,17,21,25,29,33,41,51,61,71,81,101,121 (two title frames, n=1 shown twice). Its displayed values (2.017925, 1.802071, 1.906595, 1.957234, 1.979056, 1.997086, 2.004331) match the new script's for the same n. The new GIF uses a slightly different n sequence (adds odd n=3,5,7 and 18; uses 48,56,72,96 instead of 50,60,70,80,100) with the same end point of 121 sample points, omits the on-plot formula label and node dots. None of these differences changes what a reader learns; no Fidelity finding.

