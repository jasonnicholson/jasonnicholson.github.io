# Rational Approximation — animation review (round 9)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. Every checkable claim on the page agrees with my independent computation and with the frames, and the script's minimax approximant matches Mathews' Mathematica `MiniMaxApproximation` coefficients to about 13 significant digits.

Observations that are not findings:
- Mathews reports *absolute* error for 1(a) (|f−r| ≤ 0.000367365, image `gr_30`). The page uses relative error for all three cases. This is a valid and consistent choice: it is the quantity minimax minimizes, and Mathews himself shows in 1(c) that `MiniMaxApproximation` minimizes relative error. The page never says Mathews used relative error for 1(a) and 1(b). The script's absolute errors still reproduce Mathews' numbers: 3.67364e-4 for 1(a) and 2.35941e-4 for 1(c), against Mathews' 0.000367365 and 0.000235941.
- The page leaves out Mathews' comparisons with the Taylor and Padé approximants. That is content the page does not have, not an error.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 8.2 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $R_{m,n}(x)=P_m(x)/Q_n(x)$, $Q_n\neq0$ | Standard definition. The script uses $P_2/Q_2$ with $Q=1+b_1x+b_2x^2$, and min Q on [-1,1] is 0.5818 or more for all three approximants (`instr.out`) | confirmed |
| D2 | "Mathews compares three constructions over a fixed interval: equally spaced nodes, Chebyshev nodes, and a MiniMax (MinMax) construction" | Archive Examples 1 and 2 each have parts (a), (b) and (c) on [-1,1] | confirmed |
| D3 | "For the MinMax procedure, the goal is to minimize the maximum relative error $\max|(f-R)/f|$" | Archive 1(c): "the MiniMax rational approximation is minimizing the 'relative error'". The script's Remez reference equation $P=f(1-s_iE)Q$ is relative-error equioscillation | confirmed |
| A1 | Animation uses $f(x)=e^x$ on $[-1,1]$, fixed $[2/2]$ form | Script lines 12, 14, 134 and the frame titles | confirmed |
| A2 | Order of frames: (1) equal nodes, (2) Chebyshev nodes, (3) minimax | `methods` array (lines 150–154); frame titles 1–3 | confirmed |
| A3 | Minimax "computed here by the Remez exchange algorithm" | Lines 57–131: the reference system is solved by Newton, then all 6 reference points are exchanged for the extrema of the error on each constant-sign interval, starting from the Chebyshev extrema. This is a genuine multi-point (second-algorithm) Remez exchange. It converges in 3 iterations with ripple spread 7e-16 | confirmed |
| A4 | "Julia source scripts ... are linked under each case" | `[Julia source](rationalapproxaa.jl)` sits under Case 1, and the file exists | confirmed |
| A5 | "No archived animation GIF is available for this topic" | `a2001/Animations` has no rational or minimax animation. `Interpolation/Pade` belongs to the Padé topic | confirmed |
| A6 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | Archive Example 1 is $R_{2,2}$ for $e^x$ on [-1,1] (`gr_9`, `gr_10`), and the equal-node coefficients match Mathews' (0.499831, 0.081612) | confirmed |
| A7 | Ex 2 = [4/4] $e^x$ (equal, Chebyshev, MiniMax); Ex 3, 4, 5 = [4/4] for $\cos(\pi x/2)$, $\tan x$, $\arctan x$ (equal, Chebyshev) on [-1,1] | Archive module text and images `gr_113`/`114`, `216`/`217`, `295`/`296`, `375`/`376` (`img/formulas.png`) | confirmed (inventory section, checked anyway) |
| C1 | Heading: "Rational $[2/2]$ for $e^x$ on $[-1,1]$: equal nodes, Chebyshev nodes, and MinMax" | Same as A1 and A2 | confirmed |
| C2 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | The relative residual at the nodes is at most 1.8e-16 for both (`instr.out`) | confirmed |
| C3 | Equal-node max relative error "about $1.59\times10^{-4}$" | Independent: 1.593661e-4. Script (1201-point grid): 1.593650e-4 | confirmed |
| C4 | Equal-node error "largest near $x\approx\pm0.82$" | Independent extrema at x = ±0.8244 (1.5937e-4 and 1.594e-4) | confirmed |
| C5 | Chebyshev max relative error $8.94\times10^{-5}$ | Independent: 8.941921e-5, at x = −1. Script: 8.941921e-5 | confirmed |
| C6 | Minimax max relative error $8.68\times10^{-5}$ | Independent direct solve: 8.6797864e-5. Script: E = 8.679786398606e-5 | confirmed |
| C7 | "smallest possible maximum relative error for this form" | Error equioscillates at 6 = m+n+2 points, and the approximant is nondegenerate: $a_2,b_2\neq0$, and the P roots (−3.063±1.696i) differ from the Q roots (3.063±1.696i). The alternation theorem therefore makes it the unique best approximation. The coefficients also match Mathematica's `MiniMaxApproximation` (archive `gr_89`) | confirmed |
| C8 | "about 3% below the Chebyshev value" | (8.9419−8.6798)/8.9419 = 2.93% | confirmed |
| C9 | "alternating sign at six points ($x=-1,\pm0.812,\pm0.312,1$)" | Independent: −1, −0.812304, −0.312415, 0.312415, 0.812304, 1. Script: the same to 6 digits. Signs alternate (−,+,−,+,−,+) at a level of 8.67979e-5 (`instr.out`) | confirmed |
| C10 | "the relative-error curve in the last frame is equal-ripple" | Frame 3: all six peaks of the absolute relative error sit at the same height, about 8.7e-5 | confirmed |
| G1 | Alt text: three frames | GIF has 3 frames | confirmed |
| G2 | Alt text: equal nodes max rel err 1.59e-4, Chebyshev 8.94e-5, minimax 8.68e-5, equal-ripple | As C3, C5, C6 and C10. Frame legends read 0.0001594, 8.94e-5 and 8.68e-5 | confirmed |
| G3 | Alt text: "each with function and relative-error panels" | Every frame has a top panel showing f and R and a bottom panel showing \|f−R\|/\|f\| | confirmed |
| G4 | Embed `rationalapproxaa.gif` is this case | It is produced by `rationalapproxaa.jl`, and the frame titles match the heading | confirmed |

### 3. Implementation checks: `rationalapproxaa.jl`

**It is the method it claims to be.**
- Interpolation (lines 24–37) solves the linearized conditions $P(x_i)=f(x_i)Q(x_i)$ with $Q(0)$ normalized to 1. This is Mathews' formulation.
- The equal nodes are −1, −0.5, 0, 0.5, 1, which are Mathews' nodes (archive `gr_15`/`gr_21`).
- The Chebyshev nodes are $\cos((2k-1)\pi/10)$ for k = 1..5. These are the standard Chebyshev zeros. Mathews' own 1(b) nodes could not be compared because those archive images are missing.
- Minimax uses a Remez exchange for relative error:
  - Step 1 solves the bilinear 6×6 reference system by Newton. The Jacobian column for E, $y s Q$, is the correct derivative of $-y(1-sE)Q$.
  - Step 2 takes one extremum of \|error\| per constant-sign interval, refined by golden-section search.
  - It is a legitimate variant: simultaneous exchange of all six points.

**The numbers are right.** The script's values set beside the independent ones:

| Quantity | Script | Independent (mpmath, 40 digits) or Mathews |
|---|---|---|
| c_eq (a0, a1, a2, b1, b2) | 1, 0.499831480449, 0.0816120384126, −0.499831480449, 0.0816120384126 | identical to 12 digits; Mathews 0.499831, 0.081612 |
| c_ch | 1, 0.499789375888, 0.0816032216119, −0.499789375888, 0.0816032216119 | identical to 12 digits |
| c_mm | 0.9999999962330653, 0.49978562382661, 0.08159269632523836, −0.499785625709263, 0.08159269663258942 | mpmath: 0.999999996233, 0.499785623827, 0.0815926963252, −0.499785625709, 0.0815926966326. Mathews/Mathematica: 0.999999996233065, 0.4997856238266049, 0.08159269632523609, −0.4997856257092684, 0.0815926966325922 |
| max rel err (equal, Chebyshev, minimax) | 1.59365e-4, 8.941921e-5, 8.679786e-5 | 1.593661e-4, 8.941921e-5, 8.679786e-5 |
| max abs err (equal, minimax) | 3.67364e-4, 2.35941e-4 | Mathews 0.000367365, 0.000235941 |
| alternation points | ±1, ±0.8123043, ±0.3124145 | ±1, ±0.812304291, ±0.312414594 |

Property checks:
- Both interpolants reproduce the data at their nodes (residual at most 2e-16).
- The minimax error equioscillates at six points, with a spread of 7e-16 relative to its level.
- The minimax R crosses f at exactly 5 points: −0.9521, −0.5924, 0, 0.5924, 0.9521. This matches the code comment on line 177.

The 1201-point grid used for the reported maxima underestimates the equal-node maximum by only 1e-9, which has no effect at the precision stated.

**Its reference values are right.** The reference is $f=e^x$ evaluated directly, so it needs no check. The minimax optimality claim rests on the alternation theorem (C7) and on agreement with an independent direct solve and with Mathematica.

**The picture shows what was computed.**
- I viewed frames 1, 2 and 3, which are all of them.
- The top panel plots f (blue) and R (green dashed) from the same coefficients. The red node markers sit at `xs_eq` and `xs_ch` for frames 1 and 2 and are omitted for minimax.
- The bottom panel plots \|f−R\|/\|f\|.
  - It touches zero at the nodes: −1, −0.5, 0, 0.5, 1 in frame 1 and ±0.951, ±0.588, 0 in frame 2.
  - In frame 3 it shows six equal peaks of about 8.7e-5.
- The axis limits (y from 0.2 to 3.0 on top, 0 to 2e-4 below) contain every plotted value: e^±1 lies between 0.368 and 2.718, and the largest error is 1.594e-4. Nothing is clamped or masked.
- The legend values are rounded with `digits=7` and match the computed maxima.

