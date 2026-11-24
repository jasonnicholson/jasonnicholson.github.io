# Rational Approximation — animation review (round 8)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Every numerical claim on the page matches my independent computation at the precision stated. The script implements a genuine rational Remez exchange. Its result equioscillates at m+n+2 = 6 points, which certifies it as the best approximation in this form. The page's description, wiring and archive summary are accurate.

Not reported as findings:
- Mathews plots the absolute error f − R for parts 1(a) and 1(b), and the relative error only for 1(c). The page plots the relative error for all three. That is a valid and consistently labelled formulation.
- Mathews' Taylor and Padé comparisons are not reproduced. That is content the page does not have, not an error.
- Frame 1's legend prints `0.0001594` while frames 2 and 3 print `8.94e-5` and `8.68e-5`. This is only a difference in number format.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rationalapproxaa.jl` | 0 | 8.8 | rationalapproxaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "R_{m,n}(x)=P_m(x)/Q_n(x), Q_n(x)≠0" | Standard definition. The script uses `(a0+a1x+a2x²)/(1+b1x+b2x²)`, and min Q on [-1,1] is 0.582 (equal nodes), 0.582 (Chebyshev) and >0 (minimax). | confirmed |
| D2 | "Mathews compares three constructions over a fixed interval: equally spaced nodes, Chebyshev nodes, and a MiniMax (MinMax) construction" | RationalApproxMod.html Examples 1 and 2 have parts (a) equal, (b) Chebyshev and (c) MiniMaxApproximation. | confirmed |
| D3 | "For the MinMax procedure, the goal is to minimize the maximum relative error max\|(f−R)/f\|" | Mathews lnk_4: "the MiniMax rational approximation is minimizing the 'relative error'". The script minimizes the relative error, and my LP bisection of the same objective gives the same level (see C6). | confirmed |
| A1 | "f(x)=e^x on [-1,1] with a fixed [2/2] rational form" | Script lines 12, 14 and 134. Archive gr_9 shows R_{2,2}(x) and gr_10 shows f[x]=e^x. | confirmed |
| A2 | Frame order "(1) equally spaced nodes, (2) Chebyshev nodes, and (3) the minimax" | `methods` array at lines 150–154. Frame titles 1–3 read "Equally spaced nodes", "Chebyshev nodes" and "Minimax (Remez)". | confirmed |
| A3 | Minimax "is computed here by the Remez exchange algorithm" | Lines 57–131 solve the 6-point reference system P = f(1−s_iE)Q by Newton's method, then exchange to the extrema of each sign interval, starting from the Chebyshev extrema. That is the rational Remez (multi-point exchange). | confirmed |
| A4 | "No archived animation GIF is available for this topic" | The a2001/Animations tree has no rational-approximation GIF. The only near match is Interpolation/Pade, which is a different module. | confirmed |
| A5 | "reconstructed from Example 1 of Mathews' Rational Approximation module" | Example 1 is R_{2,2} for e^x on [-1,1] with parts (a), (b) and (c). For equal nodes the script's coefficients are 1, 0.49983148, 0.08161204, −0.49983148, 0.08161204. Mathews gr_24 gives (1+0.499831x+0.081612x²)/(1−0.499831x+0.081612x²) with nodes {−1, −0.5, 0, 0.5, 1}. | confirmed |
| A6 | "Example 2, Exercise 3 and Examples 4–5 build [4/4] on [-1,1]: e^x (Example 2: equal, Chebyshev, MiniMax); cos(πx/2), tan x, arctan x (Exercise 3, Examples 4–5: equal and Chebyshev)" | Module text and images gr_113/114 (R_{4,4}, e^x), gr_216/217 (R_{4,4}, Cos[πx/2]), gr_295/296 (R_{4,4}, Tan), gr_375/376 (R_{4,4}, ArcTan). Only Example 2 has a part (c). | confirmed |
| A7 | "not animated here" | There is only one script and one GIF. | confirmed |
| C1 | Heading "Rational [2/2] for e^x on [-1,1]: equal nodes, Chebyshev nodes, and MinMax" | Script parameters and the three frames. | confirmed |
| C2 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | mpmath residual \|R−f\| at the nodes is 2.3e-41 (equal) and 4.6e-41 (Chebyshev). Frames 1 and 2 show relative-error zeros at the node x-values. | confirmed |
| C3 | Equal-node max relative error "about 1.59×10⁻⁴" | Independent value 1.593661e-4 (mpmath, refined extremum). The script's 1201-point grid gives 1.593650e-4. | confirmed |
| C4 | "largest near x≈±0.82" | The independent maximum is at x = 0.8244. Because R_eq(x)R_eq(−x) = 1 (b1 = −a1, b2 = a2, a0 = 1), the relative error at −x equals −e/(1−e), so the peak at −0.824 has the same size to O(e²). Frame 1 shows two equal peaks near ±0.82. | confirmed |
| C5 | Chebyshev max relative error "8.94×10⁻⁵" | Independent value 8.941921e-5, attained at x = −1. Script value 8.941921e-5. | confirmed |
| C6 | Minimax max relative error "8.68×10⁻⁵", "smallest possible ... for this form" | An independent mpmath Remez (40 digits, own code) gives E* = 8.67978639861e-5. Script value 8.67978639862e-5. A scipy LP bisection of min max\|P−fQ\|/(fQ) on a 4001-point grid gives 8.6776e-5, which agrees within LP tolerance. The equioscillation at 6 = m+n+2 points with a2, b2 ≠ 0 (no defect) certifies optimality. | confirmed |
| C7 | "about 3% below the Chebyshev value" | 1 − 8.67979e-5/8.94192e-5 = 2.93%. | confirmed |
| C8 | "reaches this level with alternating sign at six points (x=−1, ±0.812, ±0.312, 1)" | Independent extrema of the script's c_mm: −1 (−8.6798e-5), −0.81230 (+), −0.31241 (−), 0.31241 (+), 0.81230 (−), 1 (+). The script prints signs [−,+,−,+,−,+] and \|values\| equal to 1e-15. | confirmed |
| C9 | "the relative-error curve in the last frame is equal-ripple" | Frame 3 shows six \|error\| humps of equal height, about 8.7e-5. | confirmed |
| C10 | `[Julia source](rationalapproxaa.jl)` | The file exists and produces rationalapproxaa.gif (the regenerated GIF is byte-identical). | confirmed |
| C11 | Embed `rationalapproxaa.gif` | The file exists and is the Case 1 animation. | confirmed |
| C12 | Alt text: "three frames: equally spaced-node interpolation (max relative error 1.59e-4), Chebyshev-node interpolation (8.94e-5), and the minimax approximant from Remez exchange (8.68e-5, equal-ripple error), each with function and relative-error panels" | 3 frames. Legends read 0.0001594, 8.94e-5 and 8.68e-5. Each frame has an upper function panel and a lower \|f−R\|/\|f\| panel. | confirmed |
| C13 | Intro: "Julia source scripts ... are linked under each case" | There is one case and one link. | confirmed |

### 3. Implementation checks: `rationalapproxaa.jl`

**It is the method it claims to be.**
- *Interpolation (lines 24–37).* The script solves P(x_i) − y_i(b1x_i + b2x_i²) = y_i at 5 nodes. This linearized interpolation condition is the same as Mathews' "set of equations". The equal nodes are linspace(−1,1,5). The Chebyshev nodes are cos((2k−1)π/10), k = 1..5, that is ±0.951057, ±0.587785 and 0, which are the standard zeros of T5. I could not compare them with Mathews' own Chebyshev node list, because images gr_49–gr_86 are missing from the archive. The zeros of T5 are the standard choice.
- *Minimax (lines 57–131).* This is the rational Remez algorithm:
  - The reference system P(x_i) = f(x_i)(1 − s_iE)Q(x_i) uses the sign s_i = (−1)^i, with i 1-based in the code. It is solved by Newton's method.
  - The Jacobian columns [1, x, x², −w x, −w x², y s Q] are the correct partial derivatives.
  - The exchange takes the extremum of \|rel err\| on each constant-sign interval: a 20001-point grid, then golden-section refinement.
  - It converges in 3 iterations with a ripple spread of 7e-16.

**The numbers are right.**

| Quantity | Script | Independent (mpmath, 40 digits) |
|---|---|---|
| c_eq | [1, 0.499831480449, 0.081612038413, −0.499831480449, 0.081612038413] | [1, 0.4998314804, 0.08161203841, −0.4998314804, 0.08161203841] |
| c_ch | [1, 0.499789375888, 0.081603221612, −0.499789375888, 0.081603221612] | [1, 0.4997893759, 0.08160322161, −0.4997893759, 0.08160322161] |
| c_mm | [0.99999999623, 0.49978562383, 0.08159269633, −0.49978562571, 0.08159269663] | [0.999999996233, 0.499785623827, 0.0815926963252, −0.499785625709, 0.0815926966326] (own Remez) |
| max rel err, equal | 1.5936498e-4 (1201 grid) | 1.5936614e-4 at x = 0.8244 |
| max rel err, Chebyshev | 8.9419212e-5 | 8.9419212e-5 at x = −1 |
| E* | 8.679786398606e-5 | 8.67978639861e-5; LP on a 4001 grid gives 8.6776e-5 (within LP tolerance) |
| alternation points | −1, −0.812304, −0.312415, 0.312414, 0.812304, 1 | −1, −0.81230429, −0.31241459, 0.31241459, 0.81230429, 1 |

The property checks are:
- Both interpolants reproduce the data at their nodes, with residuals of about 1e-41.
- The minimax error equioscillates in sign at m+n+2 = 6 points with equal magnitude to 1e-15. By the equioscillation characterization of best rational approximation (non-degenerate: a2, b2 ≠ 0, Q > 0), this is the unique best approximation.

**Its reference values are right.** The reference is f = exp. There is no separate numerical reference to verify.

**The picture shows what was computed.**
- The upper panel plots exp and R on 700 points, with the nodes drawn as red markers at (x_i, e^{x_i}). The minimax frame correctly has no nodes.
- The lower panel plots \|(f−R)/f\| from the same coefficients.
- The y-limits [0, 2e-4] contain every curve: the largest value is 1.594e-4.
- The 1e10 clamp in `eval_rational` is never triggered, because min Q ≈ 0.58.
- The legend values come from `max_relative_error` on the 1201 grid and agree with the independent values to the printed digits.
- I checked frames 1, 2 and 3 (all frames). The zeros of the relative error sit at the nodes in frames 1 and 2. Frame 3 shows equal-height ripples with zeros near ±0.95, ±0.59 and 0, which are the five crossings mentioned in the code comment at line 177.

