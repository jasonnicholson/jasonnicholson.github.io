# Rational Approximation — animation review (round 6)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, misleading statement or minor defect in the implementation, the page text, or its fidelity to the archive.

Notes that are not findings (recorded so the clean result is auditable):
- Mathews plots the *absolute* error `f - r` in 1(a) and 1(b) and the relative error `1 - u/f` only in 1(c); the page and GIF use the relative error for all three. This is a consistent, valid choice that makes the three cases comparable, and the page says relative error throughout.
- Mathews' 1(a)–1(c) also compare against the degree-4 Maclaurin polynomial and the Padé approximant; the page omits these. That is absent content, not a defect.
- The error panel plots `|f-R|/|f|`, so the sign alternation stated in the Behavior paragraph is not visible in the frame; the page only claims the curve in the last frame is equal-ripple, which the |·| plot shows correctly.
- The Chebyshev-node solution images for Example 1(b) (`RationalApproxMod_gr_49`–`gr_86`) are missing from the archive, so the archive's Chebyshev coefficients could not be compared. The script's nodes are the zeros of T₅, the standard choice.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 7.7 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | $R_{m,n}(x)=P_m(x)/Q_n(x)$, $Q_n\neq0$ | Description | Script uses [2/2] form `(a0+a1x+a2x²)/(1+b1x+b2x²)`; min Q on [-1,1] = 0.5818 for all three approximants (no poles) | confirmed |
| 2 | Mathews compares equally spaced nodes, Chebyshev nodes and MiniMax over a fixed interval | Description | Archive Example 1(a)/(b)/(c) on [-1,1] | confirmed |
| 3 | MinMax goal is to minimize $\max\lvert (f-R)/f\rvert$ | Description | Archive 1(c): "the MiniMax rational approximation is minimizing the 'relative error'"; script's `solve_reference` levels `(f-R)/f = ±E` | confirmed |
| 4 | $f(x)=e^x$ on $[-1,1]$, fixed $[2/2]$ form | Animations intro | Script lines 12, 134, 14; archive formula images `R_{2,2}(x)`, `f[x]=e^x` | confirmed |
| 5 | Three stages: (1) equal nodes, (2) Chebyshev nodes, (3) minimax | intro | `methods` vector, lines 150–154; frames 1–3 titles | confirmed |
| 6 | Minimax computed by the Remez exchange algorithm | intro | `remez_minimax` (lines 115–131): levelled solve on 6-point reference + multi-point exchange to the extrema of each sign interval; converges in 3 iterations, ripple spread 7e-16 | confirmed |
| 7 | Animation reconstructed from Example 1 of Mathews' module | intro | Archive Ex. 1 = [2/2] for e^x on [-1,1], three methods; script's equal-node coefficients match archive 1(a) (see §3) | confirmed |
| 8 | No archived animation GIF for this topic | intro | `a2001/Animations/` has no rational/Padé/minimax entry | confirmed |
| 9 | Example 2: [4/4] for e^x on [-1,1], equal, Chebyshev, MiniMax | intro | Archive Ex. 2 text + formula images `R_{4,4}`, `e^x` | confirmed |
| 10 | Exercise 3 and Examples 4–5: [4/4] on [-1,1] for cos(πx/2), tan x, arctan x, equal and Chebyshev nodes | intro | Archive text + formula images gr_216/217, 295/296, 375/376 | confirmed |
| 11 | Heading: Rational [2/2] for e^x on [-1,1]: equal nodes, Chebyshev nodes, MinMax | Case 1 heading | Script parameters | confirmed |
| 12 | Both interpolants are exact at their nodes | Behavior | Independent relative residuals at nodes ≤ 2e-41 (mpmath); frames 1–2 show error zeros at the nodes (−1,−0.5,0,0.5,1 and ±0.951, ±0.588, 0) | confirmed |
| 13 | Equal-node max relative error ≈ $1.59\times10^{-4}$ | Behavior | Independent: 1.593661e-4; script: 1.593650e-4 (1201-pt grid) | confirmed |
| 14 | Largest near $x\approx\pm0.82$ | Behavior | Independent extrema at x = ±0.824427 with \|e\| = 1.59341e-4 / 1.59366e-4 | confirmed |
| 15 | Chebyshev max relative error $8.94\times10^{-5}$ | Behavior | Independent 8.941921e-5 (at x = −1); script 8.941921e-5 | confirmed |
| 16 | Minimax has the smallest possible max relative error for this form, $8.68\times10^{-5}$ | Behavior | Independent equioscillation solve E = 8.6797864e-5; script 8.6797864e-5; Mathematica MiniMaxApproximation coefficients from archive give 8.6797864e-5. Equioscillation at n+m+2 = 6 points with nondegenerate denominator ⇒ best approximation | confirmed |
| 17 | About 3% below the Chebyshev value | Behavior | (8.941921−8.679786)/8.941921 = 2.93% | confirmed |
| 18 | Error reaches this level with alternating sign at six points $x=-1,\pm0.812,\pm0.312,1$ | Behavior | Independent: −1, ±0.8123043, ±0.3124146, 1 with signs −,+,−,+,−,+ and \|e\| = 8.6797864e-5 at each; script `xr_mm` agrees to 6 digits | confirmed |
| 19 | Relative-error curve in the last frame is equal-ripple | Behavior | Frame 3 lower panel: six peaks at equal height ≈ 8.7e-5 | confirmed |
| 20 | `[Julia source](rationalapproxaa.jl)` is the script for this case | link | File exists, produces `rationalapproxaa.gif`; manifest: regenerated GIF byte-identical (md5 4052de20…) | confirmed |
| 21 | Embed `rationalapproxaa.gif` is this case | embed | Frames show [2/2] e^x on [-1,1] three methods | confirmed |
| 22 | Alt text: three frames | alt | GIF has 3 frames | confirmed |
| 23 | Alt text: equal-node max rel err 1.59e-4, Chebyshev 8.94e-5, minimax 8.68e-5 equal-ripple | alt | Frame legends: 0.0001594, 8.94e-5, 8.68e-5; values confirmed in rows 13, 15, 16 | confirmed |
| 24 | Alt text: each frame has function and relative-error panels | alt | Frames 1–3: upper panel f and R, lower panel \|f−R\|/\|f\| | confirmed |
| 25 | "Julia source scripts ... are linked under each case" | intro | One case, one link | confirmed |

### 3. Implementation checks — `rationalapproxaa.jl`

**Method is what it claims.**
- Stages 1–2: linearized rational interpolation `P(x_i) − y_i (b1 x_i + b2 x_i²) = y_i` on 5 nodes, solved directly (5×5). Since every node gives Q(x_i) ≠ 0 (min Q = 0.58), the linearized solution is a true interpolant. Equal nodes `range(-1,1,length=5)`; Chebyshev nodes `cos((2k−1)π/10)`, k = 1…5 (zeros of T₅). This matches Mathews' "set up the 5 equations and solve" procedure (archive 1(a) image).
- Stage 3: Remez exchange for the best *relative*-error [2/2] approximant. `solve_reference` solves `P(x_i) = f(x_i)(1 − s_i E) Q(x_i)` by Newton (Jacobian checked: ∂/∂b1 = −w x, ∂/∂b2 = −w x², ∂/∂E = y s Q, all correct). `error_extrema` takes the maximum |error| in each sign interval (golden-section refined), which is the standard multi-point exchange. Started from the Chebyshev extrema `cos(πk/5)`. It is the Remez second algorithm, as the page says.

**The numbers are right.** Script values (from `instr.jl`) beside independent mpmath values (from `indep.py`):

| Quantity | Script | Independent | Archive (Mathews) |
|---|---|---|---|
| equal: p0, p1, p2 | 1.0, 0.4998314804, 0.0816120384 | 1.0, 0.499831480449449, 0.0816120384126298 | 1, 0.499831, 0.081612 |
| equal: q1, q2 | −0.4998314804, 0.0816120384 | −0.499831480449449, 0.0816120384126298 | −0.499831, 0.081612 |
| equal: max rel err | 1.59365e-4 (x=0.825 on grid) | 1.593661e-4 at x=0.824427 | — (absolute error plotted) |
| Chebyshev: p1 / q1 / p2=q2 | 0.4997893759 / −0.4997893759 / 0.0816032216 | 0.499789375887513 / −… / 0.0816032216119462 | images missing |
| Chebyshev: max rel err | 8.941921e-5 (x=−1) | 8.941921e-5 (x=−1) | — |
| minimax: p0 | 0.9999999962330653 | 0.999999996233065 | 0.999999996233065 |
| minimax: p1 | 0.49978562382661 | 0.499785623826607 | 0.4997856238266049 |
| minimax: p2 | 0.08159269632523836 | 0.0815926963252367 | 0.08159269632523609 |
| minimax: q1 | −0.499785625709263 | −0.499785625709266 | −0.4997856257092684 |
| minimax: q2 | 0.08159269663258942 | 0.0815926966325911 | 0.08159269663259221 |
| minimax: E | 8.679786398606e-5 | 8.67978639860892e-5 | 8.6797864e-5 (computed from archive coeffs) |
| alternation points | −1, −0.8123043, −0.3124147, 0.3124143, 0.8123043, 1 | −1, ±0.8123042914, ±0.3124145944, 1 | plot shows extrema at ≈ ±0.8, ±0.3, ±1 |

The archive minimax coefficients come from Mathematica's `MiniMaxApproximation`, a third independent source; the script agrees with it to about 12 significant digits. Property checks: both interpolants reproduce the data at the nodes (residual < 2e-41); the minimax error equioscillates with alternating sign at 6 = m+n+2 points with equal magnitude to 1e-16 relative, so it is the unique best approximant (equioscillation theorem, defect 0 since q2 ≠ 0, p2 ≠ 0). De la Vallée Poussin bound is consistent: the Chebyshev interpolant's 6 alternating extrema have min magnitude 8.474e-5 ≤ E* = 8.680e-5 ≤ 8.942e-5.

**Reference values.** The reference is f(x) = exp(x) itself, evaluated exactly; no numerically computed reference. Max relative error is measured on a 1201-point grid; that grid underestimates the true maximum by < 1e-9 relative for the minimax and Chebyshev cases (maxima at the endpoints) and by 7e-6 relative for the equal-node case, far below the stated 3 significant digits.

**The picture shows what was computed.** Frames 1–3 (viewed in full) have the right titles ("Equally spaced nodes", "Chebyshev nodes", "Minimax (Remez)"), node markers at the correct abscissae (frame 1: −1, −0.5, 0, 0.5, 1; frame 2: ±0.951, ±0.588, 0; frame 3: none, correctly, as the minimax approximant has no interpolation nodes), legend values 0.0001594 / 8.94e-5 / 8.68e-5 matching the computed maxima, and relative-error curves whose zeros sit at the nodes and whose peaks match the computed extrema (frame 1 peaks ≈ 1.59e-4 at ±0.82 and ≈ 6.0e-5 at ±0.27; frame 2 peaks 8.94e-5 at ends, ≈ 8.76e-5, ≈ 8.47e-5; frame 3 six equal peaks ≈ 8.68e-5). Axis limits (y ∈ [0.2, 3] and [0, 2e-4]) contain all data; no clamping occurs (the `1e10` denominator guard is never reached since min Q = 0.58). The f and R curves in the upper panel are visually indistinguishable, which is accurate at errors of order 1e-4; the lower panel carries the comparison. The committed GIF is byte-identical to a fresh regeneration (manifest; md5 4052de20c8b7deda80ca11a78a719169 for both).

