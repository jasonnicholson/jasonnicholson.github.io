# Trapezoidal Rule for Numerical Integration — animation review (round 3)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the GIF agreed with independent computation at the precision stated. Details are in the ledger and the implementation checks below.

Observations that I decided are not findings:
- The Behavior paragraph goes from "With 2 subintervals the error jumps to about +0.36" to "from 4 subintervals (5 sample points) on its size shrinks at every frame". It does not mention the 3-subinterval frame, where the error is -0.117, smaller in size than the -0.214 at 4 subintervals. Each sentence is true, and "The approach is not steady at first" covers the non-monotone start, so a reader is not misled.
- The refinement sequence differs from the legacy GIF. Legacy uses n = 1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 after three intro frames. The page uses n = 1,2,3,4,5,6,7,8,10,12,...,96,120 after one intro frame. The function, interval, end state (121 points, 2.014944) and the look are the same. This does not matter to a reader.
- The GIF title does not state the function, unlike the legacy GIF. The page heading and intro state it, and it is cosmetic.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 10.5 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Description | Standard composite rule. It is what `trapezoid_sum` (l.18-22) computes. | confirmed |
| 2 | For $C^2$ $f$, $T_n - I = O(h^2)$ | Description | Script routine on cos over [0,2]: err n=10 -3.0330e-3, n=20 -7.5787e-4, ratio 4.002. On x^2: err h^2/3 exactly (n=10: 0.013333). | confirmed |
| 3 | Animation over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Intro, Case heading | Script l.8-9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2`. Frame x-axis 0..2. Matches the legacy GIF label $y=e^{-x}\sin(8x^{2/3})+1$. | confirmed |
| 4 | "Each new frame recomputes the approximation on the full interval with a denser partition" | Intro | Frames 2-24 use n strictly increasing 1→120 over all of [0,2]. Frame 1 is curve-only (intro). | confirmed |
| 5 | Case heading "Composite Trapezoidal Rule" | Case 1 | The code is the composite trapezoidal rule (see section 3). | confirmed |
| 6 | "As the number of sample points increases, trapezoids ... become narrower, and the approximation converges toward the true integral" | Behavior | T_n sequence (check.py) ends at -0.001335 error. The error shrinks monotonically from n=4 on. | confirmed |
| 7 | $\int_0^2 f\,dx \approx 2.016280$ | Behavior | mpmath quad 2.0162797196170963 (also via the substitution x=t^3: same to 40 digits). scipy 2.01627971962. | confirmed |
| 8 | Last frame: 121 sample points, 2.014944 | Behavior | n=120: T=2.0149444646 (script and mpmath agree). frame_024 shows "Sample Points = 121", "Approximation = 2.014944". | confirmed |
| 9 | "about 0.0013 low" | Behavior | T_120 - I = -0.00133525 | confirmed |
| 10 | First partition frame: 2 sample points, 2.017925 | Behavior | n=1: T=2.0179248162. frame_002 shows the same. | confirmed |
| 11 | That value is close only because the areas above and below the chord from f(0) to f(2) almost cancel | Behavior | chord.py: the curve crosses the chord at x≈0.2458, 0.6981, 1.2705. Area above is 0.280272, area below is 0.281917, net -0.001645 (= I - T_1). | confirmed |
| 12 | "With 2 subintervals the error jumps to about +0.36" | Behavior | T_2 - I = +0.356647 | confirmed |
| 13 | "from 4 subintervals (5 sample points) on its size shrinks at every frame" | Behavior | abs errors for n=4,5,6,7,8,10,...,120: 0.2142, 0.1944, 0.1611, 0.1323, 0.1097, 0.0785, 0.0590, 0.0462, 0.0372, 0.0307, 0.0259, 0.0192, 0.0149, 0.0119, 0.00826, 0.00611, 0.00473, 0.00312, 0.00193, 0.00134. All decreasing. | confirmed |
| 14 | "The approach is not steady at first" | Behavior | Errors n=1..4: +0.0016, +0.3566, -0.1172, -0.2142 | confirmed |
| 15 | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | Behavior | Analytic: $f' = -e^{-x}\sin(\cdot) + e^{-x}\cos(8x^{2/3})\tfrac{16}{3}x^{-1/3}$. Numerically $f'(x)/(\tfrac{16}{3}x^{-1/3})$ = 0.9943, 0.999997, 0.9999999975 at x=1e-3, 1e-6, 1e-9. | confirmed |
| 16 | Textbook order (smooth f) does not hold for this integrand | Behavior | f'' is not bounded on [0,2] (it behaves like x^{-4/3}), so the $C^2$ hypothesis fails. | confirmed |
| 17 | Measured error is $O(h^{5/3})$, not $O(h^2)$ | Behavior | Halving ratios n→2n: 24: 3.1415, 48: 3.1583, 96: 3.1647, 192: 3.1679, 384: 3.1698, 768: 3.1711, 1536: 3.1720, tending to 3.1748. Also, the generalized Euler-Maclaurin leading term for the $8x^{2/3}$ singularity, $8\,\zeta(-2/3)\,h^{5/3}$, gives about -6.07e-6 at n=3072. The computed error is -6.05e-6. | confirmed |
| 18 | "halving h divides it by about 3.14 (from 24 to 48 subintervals)" | Behavior | err(24)/err(48) = -0.0191940/-0.00610979 = 3.1415 | confirmed |
| 19 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | Behavior | $2^{5/3}$ = 3.1748. Ratios approach it (row 17). | confirmed |
| 20 | Source link `trapezoidalaa.jl` | Case 1 | File exists and is the only script. It produces `trapezoidalaa.gif`, and the regeneration is byte-identical. | confirmed |
| 21 | Embed `trapezoidalaa.gif` and alt text "...over [0,2] with full-interval density refinement: each frame uses a denser partition and updates the global approximation" | Case 1 | The GIF is this case. The alt text matches frames 2-24. Frame 1 is an intro frame without a partition, which is trivial. | confirmed |

Not stated on the page, so nothing to check: frame count (24), colour meanings, fps.

### 3. Implementation checks: `trapezoidalaa.jl`

**Method.** `trapezoid_sum(n)` (l.18-22) computes `dx*(0.5 f(a) + Σ_{i=1}^{n-1} f(a+i dx) + 0.5 f(b))` with `dx=(b-a)/n`. This is the composite trapezoidal rule with n equal subintervals, not a neighbouring method. Property checks on the script's own routine (poly.jl):
- The constant 1 and 3x+2 are integrated exactly, with error 0.0 for n = 1, 3, 10, 20 (degree of precision ≥ 1).
- x^2 is not exact: errors 1.3333, 0.14815, 0.013333, 0.0033333 for n = 1, 3, 10, 20. That equals h^2(b-a)f''/12 = h^2/3 exactly, so the degree of precision is exactly 1.
- For cos, the error ratio from n=10 to n=20 is 4.002, which is second order for smooth f.

**Numbers.** The instrumented copy (`trap_instr.jl`) and the independent mpmath sums (`check.py`) agree to all printed digits for all 23 partitions:

| n | pts | script T_n | mpmath T_n | error vs I |
|---|---|---|---|---|
| 1 | 2 | 2.017924816215668 | 2.017924816 | +0.0016451 |
| 2 | 3 | 2.372926966994002 | 2.372926967 | +0.356647 |
| 3 | 4 | 1.899070845729605 | 1.899070846 | -0.117209 |
| 4 | 5 | 1.8020714882340843 | 1.802071488 | -0.214208 |
| 5 | 6 | 1.8218929032849702 | 1.821892903 | -0.194387 |
| 6 | 7 | 1.8551878686035432 | 1.855187869 | -0.161092 |
| 7 | 8 | 1.8839823691917106 | 1.883982369 | -0.132297 |
| 8 | 9 | 1.9065949303145524 | 1.90659493 | -0.109685 |
| 10 | 11 | 1.9377646051553619 | 1.937764605 | -0.0785151 |
| 12 | 13 | 1.9572338953063426 | 1.957233895 | -0.0590458 |
| 14 | 15 | 1.9701061971651 | 1.970106197 | -0.0461735 |
| 16 | 17 | 1.97905585678816 | 1.979055857 | -0.0372239 |
| 18 | 19 | 1.9855398147974592 | 1.985539815 | -0.0307399 |
| 20 | 21 | 1.9903974552874741 | 1.990397455 | -0.0258823 |
| 24 | 25 | 1.9970856958540892 | 1.997085696 | -0.019194 |
| 28 | 29 | 2.0013867439910684 | 2.001386744 | -0.014893 |
| 32 | 33 | 2.0043311120844143 | 2.004331112 | -0.0119486 |
| 40 | 41 | 2.008016894673292 | 2.008016895 | -0.00826282 |
| 48 | 49 | 2.0101699260596675 | 2.010169926 | -0.00610979 |
| 56 | 57 | 2.0115474483164135 | 2.011547448 | -0.00473227 |
| 72 | 73 | 2.0131607502791513 | 2.01316075 | -0.00311897 |
| 96 | 97 | 2.0143452207227672 | 2.014345221 | -0.0019345 |
| 120 | 121 | 2.0149444646203434 | 2.014944465 | -0.00133525 |

There is a further cross-check from the legacy GIF annotations. Values the page's sequence shares with it are identical: n=1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 120. The legacy-only values (n=50: 2.010570, 60: 2.012059, 70: 2.013011, 80: 2.013661, 100: 2.014472) agree with the progression, so the integrand is the same.

**Reference values.** The script draws no reference value. The page's reference integral is 2.016280. Independent values are 2.0162797196170963 (mpmath adaptive quad with breakpoints near 0), the same to 40 digits via the substitution x=t^3, which removes the singularity, and 2.0162797196174 from scipy quad. Confirmed.

**Picture.** I viewed frames 1, 2, 3 and 24 individually and the contact sheet (frames 1, 3, 5, 7, 9, 13, 17, 21, 29, 41, 57, 97 sample points).
- Each trapezoid is the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)), with the chord drawn between the node values. In the frames, the chords meet the magenta curve at the nodes. For example, n=2 is visible at x=0, 1, 2 in frame_003, and the single chord from (0,1) to (2,1.0179) is in frame_002.
- The label "Sample Points = n+1" is correct, and "Approximation" is T_n rounded to 6 digits. All annotations seen match the table above.
- The axis limits y∈[0,2.1] contain the whole curve (f ranges from 0.3572 to 1.9198 on [0,2]), and x∈[0,2] is the full interval. No clamping or masking. The annotations at y=1.74-1.88, x≈1.15 do not overlap the curve there (f ≤ 1.32 for x ≥ 1).
- There are 24 frames: 1 intro frame and 23 partitions.
- The committed GIF is byte-identical to a fresh scratch run (manifest), so these frames are what the current script produces.

