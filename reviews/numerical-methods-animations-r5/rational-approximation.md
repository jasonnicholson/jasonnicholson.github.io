# Rational Approximation — animation review (round 5)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading, Minor or Fidelity finding. Every checkable claim on the page agrees with my own computation and with the frames (ledger below).

Things I looked at and decided were not findings:
- Mathews reports **absolute** error `|f - r|` for 1(a)/(b) (for example `|e(x)| <= 0.000367365` for equal nodes, image `gr_30`). The page reports **relative** error for all three cases. The page says plainly that it uses relative error (the Description formula, the y-axis label `|f-R|/|f|`, and the Behavior text), and relative error is the quantity Mathews' 1(c) MiniMax minimises (lnk_4: "the MiniMax rational approximation is minimizing the 'relative error'"). Using it throughout is a consistent and valid choice. It does not change any conclusion a reader would draw.
- Mathews plots over [-2,2]. The animation plots over [-1,1], the approximation interval. This is a display choice.
- The top panel shows f and R as visually indistinguishable. The error panel is where the comparison is made, and it is readable: all three curves sit inside the fixed y-limits [0, 2e-4]. The maximum is 1.594e-4.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 8.6 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "Rational approximation represents a function by a quotient of polynomials, R_{m,n}(x)=P_m(x)/Q_n(x), Q_n(x)≠0" | Script form `(a0+a1x+a2x^2)/(1+b1x+b2x^2)` (l.14–22). Minimum denominator on [-1,1] is 0.5818 (equal nodes) and 0.5818 (Chebyshev), so it never vanishes | confirmed |
| D2 | "Mathews compares three constructions over a fixed interval: interpolation with equally spaced nodes, interpolation with Chebyshev nodes, and a MiniMax (MinMax) construction" | Archive Examples 1 and 2, parts (a)/(b)/(c) | confirmed |
| D3 | MinMax goal: "minimize the maximum relative error max |(f-R)/f|" | Script `relative_error` (l.55) and the Remez reference equations `P = f(1 - s E) Q` (l.57–72) are relative-error equioscillation. Archive lnk_4 states the same | confirmed |
| A1 | "f(x)=e^x on [-1,1] with a fixed [2/2] rational form" | l.12, l.134, l.14. Archive gr_9/gr_10: R_{2,2}, f=e^x, [-1,1] | confirmed |
| A2 | "(1) equally spaced nodes, (2) Chebyshev nodes, and (3) the minimax (MinMax) approximant" | `methods` l.150–154. The frame titles read "Equally spaced nodes", "Chebyshev nodes" and "Minimax (Remez)" | confirmed |
| A3 | "…which minimizes the maximum relative error and is computed here by the Remez exchange algorithm" | l.115–131: Newton solve on a 6-point reference, then exchange to the 6 sign-interval extrema, iterated until the ripple spread is below 1e-10 relative. This is genuine Remez. The result equioscillates at 6 = 2+2+2 points with no defect, which by the characterization theorem makes it the best approximation | confirmed |
| A4 | "Julia source scripts that generated these animations are linked under each case" | `[Julia source](rationalapproxaa.jl)` under Case 1. The file exists. The scratch run reproduces the committed GIF byte-for-byte (manifest) | confirmed |
| A5 | "No archived animation GIF is available for this topic" | `ls a2001/Animations | grep -iE 'rat|pade|minimax|cheb'` matches only "Quadrature" | confirmed |
| A6 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | Archive Example 1 = R_{2,2} for e^x on [-1,1], with (a) equal, (b) Chebyshev and (c) MiniMax | confirmed |
| A7 | "Example 2 … [4/4] … e^x (equally spaced, Chebyshev, MiniMax)" | Archive gr_113/114 show R_{4,4}, e^x. Mod page lists 2(a)/(b)/(c) | confirmed |
| A8 | "Exercise 3 and Examples 4–5 … cos(πx/2), tan x, arctan x … equally spaced and Chebyshev nodes" | Archive gr_216/217 cos(π x/2), gr_295/296 tan x, gr_375/376 arctan x, all R_{4,4}. Each has parts (a)/(b) only | confirmed |
| A9 | Case heading: "Rational [2/2] for e^x on [-1,1]: equal nodes, Chebyshev nodes, and MinMax" | Script parameters and the three frames | confirmed |
| B1 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | Script node relative residuals are at most 1.8e-16. mpmath residual is 1e-41 | confirmed |
| B2 | Equal-node max relative error "about 1.59×10^-4" | Script 1.59365e-4. mpmath 1.593661e-4 | confirmed |
| B3 | "(largest near x≈±0.82)" | mpmath extrema at x = ±0.824427 (values +1.59341e-4 and -1.59366e-4). Visible in frame 1 | confirmed |
| B4 | Chebyshev max relative error "8.94×10^-5" | Script 8.941921e-5. mpmath 8.941921e-5, attained at x=-1 | confirmed |
| B5 | Minimax "has the smallest possible maximum relative error for this form, 8.68×10^-5" | Script E = 8.6797864e-5. Independent mpmath simultaneous solve gives 8.67978639861e-5, and the dense 1e6-point max of the script's approximant is 8.6797864e-5. Mathews' own Mathematica MiniMax coefficients (archive gr_88), evaluated in mpmath, give 8.679786399e-5. Optimality follows from equioscillation at 6 points | confirmed |
| B6 | "about 3% below the Chebyshev value" | (8.941921-8.679786)/8.941921 = 2.93% | confirmed |
| B7 | "alternating sign at six points (x=-1, ±0.812, ±0.312, 1)" | mpmath: -1, ±0.81230429, ±0.31241459, 1, with signs -,+,-,+,-,+. Script: -1, -0.8123043, -0.3124147, 0.3124143, 0.8123043, 1 | confirmed |
| B8 | "the relative-error curve in the last frame is equal-ripple" | Frame 3: six equal-height lobes of |rel| at about 8.7e-5 | confirmed |
| G1 | Alt text: "three frames" | 3 frames (manifest, `committed/rationalapproxaa/`) | confirmed |
| G2 | Alt: "equally spaced-node interpolation (max relative error 1.59e-4)" | Frame 1 legend "max rel err = 0.0001594" | confirmed |
| G3 | Alt: "Chebyshev-node interpolation (8.94e-5)" | Frame 2 legend "8.94e-5" | confirmed |
| G4 | Alt: "minimax approximant from Remez exchange (8.68e-5, equal-ripple error)" | Frame 3 title "Minimax (Remez)", legend "8.68e-5", equal-ripple panel | confirmed |
| G5 | Alt: "each with function and relative-error panels" | Every frame has a top f/R panel and a bottom |f-R|/|f| panel | confirmed |
| W1 | Embed `rationalapproxaa.gif` is this case | Frames show e^x, [2/2], [-1,1] and the three constructions | confirmed |

### 3. Implementation checks: `rationalapproxaa.jl`

**It is the method it claims to be.**
- The interpolation step (l.24–37) is the linearized rational-interpolation system `p(x_i) - f(x_i)(q1 x_i + q2 x_i^2) = f(x_i)` with q0 = 1, five equations in five unknowns. This is Mathews' formulation. The script's equal-node coefficients `[1.0, 0.4998315, 0.0816120, -0.4998315, 0.0816120]` match Mathews' printed `r[x] = (1 + 0.499831x + 0.081612x^2)/(1 - 0.499831x + 0.081612x^2)` (archive gr_25).
- Equal nodes are `range(-1,1,length=5)`, matching Mathews' `a + i(b-a)/(m+n)`, i = 0..4. The Chebyshev nodes are `cos((2k-1)π/10)`, k = 1..5, which are the standard 5 Chebyshev zeros on [-1,1].
- The minimax step (l.57–131) is a genuine Remez exchange for weighted (relative) error. The reference system is bilinear and is solved by Newton's method. I checked the Jacobian (l.71): it is the correct derivative of F with respect to (a0,a1,a2,b1,b2,E). The exchange takes one extremum per constant-sign interval, refined by golden-section search, and the script stops with an error unless there are exactly 6. Convergence (run.out): ripple spread 3.45e-8, then 7.5e-14, then 7.1e-16.

**The numbers are right.** I wrote an independent mpmath (40-digit) computation in `review/indep.py`. It does its own interpolation solve, locates extrema by roots of the derivative, and finds the minimax approximant by a different method: one simultaneous `findroot` on 10 unknowns (5 coefficients, E, and 4 interior alternation points), with no exchange loop.

| Quantity | Script (`instr.jl` / run.out) | Independent (mpmath) |
|---|---|---|
| c_eq | 1, 0.499831480449, 0.0816120384126, -0.499831480449, 0.0816120384126 | identical to 12 digits |
| c_ch | 1, 0.499789375888, 0.0816032216119, -0.499789375888, 0.0816032216119 | identical to 12 digits |
| max rel err, equal | 1.5936498e-4 (1201-pt grid) | 1.5936614e-4 (true max at x=0.824427) |
| max rel err, Chebyshev | 8.941921e-5 | 8.941921e-5 |
| c_mm | 0.9999999962330653, 0.49978562382661, 0.08159269632523836, -0.499785625709263, 0.08159269663258942 | 0.999999996233065, 0.499785623826607, 0.0815926963252367, -0.499785625709266, 0.0815926966325911 |
| E (minimax) | 8.679786398606e-5 | 8.67978639861e-5 |
| alternation points | -1, -0.81230427, -0.31241468, 0.31241432, 0.81230432, 1 | -1, -0.8123042914, -0.3124145944, 0.3124145944, 0.8123042914, 1 |

Mathews' Mathematica `MiniMaxApproximation` coefficients (archive gr_88) differ from the script's by at most 2e-15. Property checks also pass: the interpolants reproduce the data at the nodes (residual at most 1.8e-16), and the minimax error equioscillates in sign at 6 points with equal magnitude to 1e-15. A dense evaluation on 10^6 points gives a maximum of 8.6797864e-5, so there is no hidden larger extremum.

**Its reference values are right.** f = exp is evaluated directly, with no numerically computed reference. The "max rel err" values use a 1201-point grid. For equal nodes this underestimates the true maximum by 1.2e-9, which is invisible at the 4 displayed digits.

**The picture shows what was computed.** I viewed all 3 frames.
- Frame 1: nodes at -1, -0.5, 0, 0.5, 1. The error is zero at the nodes, with lobes peaking at about 1.59e-4 near ±0.82. The legend reads 0.0001594.
- Frame 2: nodes at ±0.951, ±0.588 and 0. The error is zero at those nodes and the legend reads 8.94e-5.
- Frame 3: no nodes, as the code intends (l.177). Six equal lobes at about 8.68e-5, and the legend reads 8.68e-5.
- Titles name the correct function, form and interval.
- Display devices: the denominator clamp in `eval_rational` is never triggered, since the minimum denominator is about 0.58. The y-limits [0, 2e-4] contain every curve. No NaN masking is used.
- The committed GIF is byte-identical to a fresh scratch run (manifest).

