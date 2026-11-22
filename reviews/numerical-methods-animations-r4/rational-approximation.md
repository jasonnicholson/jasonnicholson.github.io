# Rational Approximation — animation review (round 4)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames. The implementation is the method it claims to be, and its numbers agree with an independent solution to 9–12 significant digits.

Observations that are not findings:
- The error panel plots |relative error|, so the sign alternation the Behavior paragraph mentions is not visible in the frame. The panel's y-label is `|f-R|/|f|`, and the page claims only that the curve is equal-ripple, which it visibly is. This does not mislead.
- The legend formats the first error as `0.0001594` and the others as `8.94e-5` / `8.68e-5` (Julia `round` with 7 digits). The values are consistent with the page. This is cosmetic only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 7.5 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "Rational approximation represents a function by a quotient of polynomials, R_{m,n}=P_m/Q_n, Q_n≠0" | Description | Script uses P degree 2 / Q degree 2 with Q(0)=1 normalisation (line 14–22); min Q on [-1,1] for minimax = 0.582 > 0 | confirmed |
| D2 | "Mathews compares three constructions over a fixed interval: interpolation with equally spaced nodes, interpolation with Chebyshev nodes, and a MiniMax (MinMax) construction" | Description | Archive Example 1 (a)(b)(c), Example 2 (a)(b)(c) | confirmed |
| D3 | "For the MinMax procedure, the goal is to minimize the maximum relative error max|(f−R)/f|" | Description | Archive lnk_4: "the MiniMax rational approximation is minimizing the 'relative error'"; script's Remez imposes (f−R)/f = s_i E (line 57–70) | confirmed |
| A1 | f(x)=e^x on [-1,1] | Intro | script line 12, 134 | confirmed |
| A2 | "fixed [2/2] rational form" | Intro | script line 14 (5 coefficients a0,a1,a2,b1,b2) | confirmed |
| A3 | Order: (1) equal nodes, (2) Chebyshev nodes, (3) minimax | Intro | `methods` list line 150–154; frames 1–3 titles | confirmed |
| A4 | minimax "minimizes the maximum relative error and is computed here by the Remez exchange algorithm" | Intro | Code is a rational Remez exchange (Newton solve of the 6-point reference system, multi-point exchange of extrema); result equioscillates at 6 = m+n+2 points with equal |error| (signed values ±8.6797864e-5), which by the alternation theorem certifies it as the best approximation in relative error | confirmed |
| A5 | "No archived animation GIF is available for this topic" | Intro | No rational/minimax match under `a2001/Animations` or anywhere in `a2001` (grep) | confirmed |
| A6 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | Intro | Archive Example 1: R_{2,2}(x), f=e^x, [-1,1] (images gr_9, gr_10) | confirmed |
| A7 | Example 2, Exercise 3, Examples 4–5 build [4/4] on [-1,1] for e^x (Ex 2, equal/Chebyshev/MiniMax) and cos(πx/2), tan x, arctan x (Ex 3, 4, 5, equal and Chebyshev) | Intro | Archive images gr_113/114 (R_{4,4}, e^x), gr_216/217 (R_{4,4}, Cos[π/2 x]), gr_295/296 (R_{4,4}, Tan), gr_375/376 (R_{4,4}, ArcTan); Ex 3–5 list only (a)(b) | confirmed |
| C1 | Heading: "Rational [2/2] for e^x on [-1,1]: equal nodes, Chebyshev nodes, and MinMax" | Case 1 heading | script; frame titles | confirmed |
| C2 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | Behavior | Max residual at nodes 2e-41 (equal), 5e-41 (Chebyshev) in mpmath; error panel touches zero at the nodes in frames 1 and 2 | confirmed |
| C3 | Equal nodes max relative error "about 1.59×10⁻⁴" | Behavior | independent 1.593661e-4; script 1.593650e-4 (1201-pt grid) | confirmed |
| C4 | "(largest near x≈±0.82)" | Behavior | independent peaks at x=±0.82443 (1.59341e-4 left, 1.59366e-4 right) | confirmed |
| C5 | Chebyshev max relative error "8.94×10⁻⁵" | Behavior | independent 8.941921e-5 (attained at x=−1); script 8.941921e-5 | confirmed |
| C6 | Minimax has "the smallest possible maximum relative error for this form, 8.68×10⁻⁵" | Behavior | independent equioscillation solve E = 8.67978639861e-5; script 8.67978639861e-5; Mathematica MiniMaxApproximation coefficients from archive (gr_89) give 8.6797864e-5 | confirmed |
| C7 | "about 3% below the Chebyshev value" | Behavior | (8.941921−8.679786)/8.941921 = 2.93% | confirmed |
| C8 | "reaches this level with alternating sign at six points (x=−1, ±0.812, ±0.312, 1)" | Behavior | independent extrema −1, ±0.8123043, ±0.3124146, 1; signs −,+,−,+,−,+; script ±0.81230(43), ±0.3124147/0.3124143 | confirmed |
| C9 | "the relative-error curve in the last frame is equal-ripple" | Behavior | frame 3: six equal-height peaks of |rel err| at ≈8.68e-5 | confirmed |
| C10 | Link `[Julia source](rationalapproxaa.jl)` | Case 1 | file exists, is the script that produces this GIF | confirmed |
| C11 | Embed `rationalapproxaa.gif` | Case 1 | committed GIF md5 4052de20… identical to scratch regeneration | confirmed |
| C12 | Alt text: "three frames" | alt | GIF has 3 frames (manifest; frames 001–003) | confirmed |
| C13 | Alt text: equal nodes 1.59e-4, Chebyshev 8.94e-5, minimax "from Remez exchange (8.68e-5, equal-ripple error)" | alt | as C3, C5, C6, C9; frame legends show 0.0001594, 8.94e-5, 8.68e-5 | confirmed |
| C14 | Alt text: "each with function and relative-error panels" | alt | frames 1–3 each have top panel f and R, bottom panel |f−R|/|f| | confirmed |
| F1 | Fidelity: Example 1 equal-node interpolant | archive lnk_2 | Mathews coefficients ±0.499831, 0.081612 and max |abs err| 0.000367365 (gr_30); script 0.4998315, 0.0816120; independent max abs err 3.673647e-4 | confirmed |
| F2 | Fidelity: Example 1 minimax | archive lnk_4 | Mathews u(x) = (0.999999996233065 + 0.4997856238266049x + 0.0815926963252360x²)/(1 − 0.4997856257092684x + 0.0815926966325922x²); script c_mm = [0.9999999962330653, 0.49978562382661, 0.08159269632523836, −0.499785625709263, 0.08159269663258942]: agree to ≥10 digits. Mathews: "extrema occur at six points" | confirmed |
| F3 | Fidelity: Example 1 Chebyshev nodes | archive lnk_3 | Solution images missing from the archive; script uses zeros of T₅ (±0.951057, ±0.587785, 0) | could not determine (Mathews' node choice not in archive); the script's choice is standard |

### 3. Implementation checks — `rationalapproxaa.jl`

**Runs / reproduces.** Exit 0 in 7.5 s; regenerated GIF byte-identical to committed (md5 4052de20c8b7deda80ca11a78a719169 both).

**It is the method it claims to be.**
- Interpolation (lines 24–37): linearised conditions P(x_i) − y_i(b1 x_i + b2 x_i²) = y_i, giving a 5×5 system for the 5 unknowns. With Q(x_i) ≠ 0 this is exactly rational interpolation at the 5 nodes. Equal nodes are `range(-1,1,length=5)`. Chebyshev nodes are cos((2k−1)π/10), k=1..5, the zeros of T₅.
- Minimax (lines 57–131): a rational Remez exchange for relative error. Step 1 solves P(x_i) = f(x_i)(1 − s_i E)Q(x_i) at 6 reference points by Newton's method. I checked the Jacobian against the partial derivatives: ∂/∂a = [1,x,x²], ∂/∂b = −w[x,x²], ∂/∂E = y s Q. Step 2 takes the extremum of |rel err| on each interval of constant sign (a multi-point exchange) and refines it by golden-section search. The initial reference is the 6 Chebyshev extrema. The convergence test is the ripple spread relative to the level. This is a legitimate variant: the nonlinear reference system is solved by Newton's method rather than by the linearised or eigenvalue formulation. The page says only "Remez exchange", which is accurate.

**The numbers are right.** Script values (from `run.out` and `inst.jl`) are set beside independent mpmath values (`indep.py`, which does not use Remez):

| Quantity | Script | Independent |
|---|---|---|
| equal coeffs (a0,a1,a2,b1,b2) | 1.0, 0.49983148045, 0.08161203841, −0.49983148045, 0.08161203841 | 1.0, 0.4998314804, 0.08161203841, −0.4998314804, 0.08161203841 |
| equal max rel err | 1.5936498e-4 | 1.5936614e-4 (at x=0.82443) |
| Chebyshev coeffs | 1.0, 0.49978937589, 0.08160322161, −0.49978937589, 0.08160322161 | 1.0, 0.4997893759, 0.08160322161, −0.4997893759, 0.08160322161 |
| Chebyshev max rel err | 8.9419212e-5 | 8.9419212e-5 (at x=−1) |
| minimax coeffs | 0.9999999962331, 0.4997856238266, 0.0815926963252, −0.4997856257093, 0.0815926966326 | 0.999999996233, 0.499785623827, 0.0815926963252, −0.499785625709, 0.0815926966326 |
| minimax E | 8.679786398606e-5 | 8.67978639861e-5 |
| alternation points | −1, −0.8123043, −0.3124147, 0.3124143, 0.8123043, 1 | −1, −0.81230429, −0.31241459, 0.31241459, 0.81230429, 1 |
| signed rel err there | −,+,−,+,−,+ all 8.6797864e-5 | same |

Remez converged in 3 iterations, with ripple spread 7e-16. The script's 1201-point grid underestimates the equal-node maximum only in the 6th significant digit, which does not affect any stated value.

**Reference values.** The only reference is f = exp, evaluated directly, so nothing needs separate verification. The minimax result is certified by the alternation property: 6 = 2+2+2 points of equal |error| with alternating sign, and the approximant is non-degenerate (b2 ≠ 0, a2 ≠ 0). It also matches the Mathematica MiniMaxApproximation output recorded in the archive to 10 digits.

**The picture shows what was computed.** I checked frames 1–3 (all frames) against the plotting code:
- The top panel draws f in blue and R in dashed green over 700 points. The red node markers are the actual interpolation nodes (frame 1: −1, −0.5, 0, 0.5, 1; frame 2: ±0.951, ±0.588, 0). Frame 3 has no markers, which is correct for minimax.
- The bottom panel shows |f−R|/|f|. It has zeros at the nodes in frames 1–2, and its peaks are at ±0.82 (1.59e-4) in frame 1, at the endpoints (8.94e-5) in frame 2, and six equal peaks at 8.68e-5 in frame 3.
- The y-limit of 2e-4 contains every curve, so nothing is clipped. The denominator safeguard (|den|<1e-10) is never triggered: min Q = 0.58.
- The titles and the function name match the code. Each legend value is `max_relative_error` of that frame's coefficients.

