# Simpson's 3/8 Rule for Numerical Integration — animation review (round 8)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

I found no Error, Misleading or Minor finding. Every checkable claim on the page agrees with independent computation and with the frames (ledger below).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 8.6 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Composite Simpson's 3/8 rule applies cubic interpolation on blocks of three subintervals" | Script fits a cubic through 4 equally spaced nodes per block of 3 subintervals (lines 40-55); exact integral of those cubics equals `simpson38_sum` to <=4e-15 for all 23 n (`instr.jl`) | confirmed |
| D2 | $h=(b-a)/n$, $n$ divisible by 3 | Script `dx=(b-a)/n`; every n in `n_seq` is a multiple of 3 | confirmed |
| D3 | Formula $\frac{3h}{8}[f_0+f_n+3\sum_{i\not\equiv0}f_i+2\sum_{i\equiv0,0<i<n}f_i]$ | Script lines 25-30 implement exactly these weights; routine is exact for degree <=3 (errors <=4.4e-16) and not degree 4 (n=3 err 0.118519 = (3/80)(2/3)^5·24) (`deg.jl`) | confirmed |
| D4 | For C^4 f, $S_n - I = O(h^4)$ | Script routine on e^x over [0,2]: halving ratios 14.85, 15.69, 15.92, 15.98 -> 16 (`deg.jl`); same in mpmath | confirmed |
| A1 | Interval $[0,2]$, $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8-9 | confirmed |
| A2 | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3" | n_seq 3,6,...,120 strictly increasing, all multiples of 3; each frame partitions all of [0,2]. (Frame 1 shows f only, as the alt text says.) | confirmed |
| A3 | "Red dots mark the sample points $x_i$" | Script lines 71-73 scatter x_i, i=0..n; frames 2, 24 show n+1 red dots | confirmed |
| A4 | "vertical red lines mark the panel boundaries $x_{3k}$" | Script lines 58-61, i in 0:3:n; frame 2 (n=3) lines at x=0 and 2 only; frame 3 (n=6) at 0,1,2 | confirmed |
| A5 | Case heading: Composite 3/8 rule, same f, [0,2] | Script | confirmed |
| A6 | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Lines 40-55; frames | confirmed |
| A7 | "Every approximation shown lies below the true integral" | Errors S-I for all 23 n are negative (from -0.225809 to -0.000469309) | confirmed |
| A8 | $\int_0^2 f\,dx \approx 2.016280$ | mpmath 2.0162797196170963 (two independent quadratures, one via smoothing substitution x=t^3) | confirmed |
| A9 | "The error grows from 4 to 7 sample points, then shrinks at every later frame" | abs err: n=3 0.132066, n=6 0.225809, then 0.0890457, 0.0396505, ... strictly decreasing to 0.000469309 at n=120 | confirmed |
| A10 | "the last frame (121 sample points) gives 2.01581, about 0.00047 low" | n=120: 2.015810410863725; err -0.000469309; frame 24 shows "Sample Points = 121", "Approximation = 2.01581" | confirmed |
| A11 | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | mpmath: f'(1e-9)·x^{1/3} = 5.33333332 vs 16/3 | confirmed |
| A12 | Error shrinks like $O(h^{5/3})$, not $O(h^4)$ | Halving ratios 30->60 3.396, 60->120 3.224, 120->240 3.189, ..., 3840->7680 3.1751 -> 2^{5/3}=3.1748 | confirmed |
| A13 | "halving h divides it by about 3.22 (from 60 to 120 subintervals), tending to $2^{5/3}\approx 3.17$, instead of 16" | 3.2238; limit 3.1748 | confirmed |
| A14 | Source link `simpson38aa.jl`, embed `simpson38aa.gif` | Both exist; script writes that GIF; committed GIF byte-identical to regeneration | confirmed |
| A15 | Alt text: opening frame showing only f, then sample dots, panel boundary lines, piecewise cubic panels and global approximation | Frame 1 f only; frames 2-24 show dots, lines, pink cubic panels, and "Approximation = ..." annotation | confirmed |
| L1 | Legacy note: reconstructs Mathews' `Simpsonaa.gif`, same integrand and interval | Legacy GIF label "y = e^{-x} sin(8x^{2/3})+1", x-axis 0..2 | confirmed |
| L2 | "ends at the same 121-point approximation, 2.015810" | Legacy frame 24: "Sample Points = 121 ... Approximation = 2.015810"; computed 2.0158104 | confirmed |
| L3 | "steps through a different sequence of intermediate n" | Legacy shows e.g. 10, 16, 85, 106 sample points; script uses 7, 13, 19, ... (both end at 121) | confirmed |

### 3. Implementation checks: `simpson38aa.jl`

**Method.** Composite Simpson's 3/8 rule: weights 1,3,3,2,3,3,2,...,3,3,1 times 3h/8 (lines 25-30). Not Simpson 1/3 or a mixed rule. The drawn panels are true cubic interpolants through the four nodes of each block (Vandermonde solve, lines 18-21), and the exact area under the drawn cubics equals the quadrature value to rounding (max |diff| 4e-15), so the picture and the number are the same object.

**Numbers.** Script values (`instr.jl`) vs independent mpmath (`check.py`) agree to all printed digits for all 23 n, e.g. n=3 1.8842140994 / 1.884214099; n=60 2.0147667416 / 2.014766742; n=120 2.0158104109 / 2.015810411. Property checks on the script's own routine: exact for x^0..x^3, not x^4; fourth-order on smooth e^x (ratios -> 16).

**Reference values.** The script draws no reference value. The page's true integral 2.016280 is confirmed by two independent 40-digit quadratures (2.016279719617096).

**Picture.** Frames 1, 2, 3, the contact sheet (frames ~every 2) and 24 viewed. Frame 1: f only. Frame 2 (n=3): one cubic through 4 dots, boundary lines at 0 and 2, "Sample Points = 4", "Approximation = 1.884214" (matches). Later frames' annotations match the computed values at 6 decimals (e.g. 1.79047, 1.976629, 2.001834, 2.008397, ..., 2.01572, 2.01581; `round` drops trailing zeros). Axis limits [-0.03,2.03]x[0,2.1] contain f's whole range (max ~1.92, min ~0.36); no clamping or masking. 24 frames = 1 blank + 23 n values.

**Legacy fidelity.** The archive's single animation (Simpson38/Simpsonaa.gif) is the one reconstructed; same integrand, interval, final n and final value. The archive's worked examples (Examples 1-5) are not animations and so not expected here. No fidelity departure that matters to a reader.

