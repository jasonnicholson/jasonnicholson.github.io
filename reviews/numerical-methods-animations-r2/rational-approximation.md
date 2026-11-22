# Rational Approximation — animation review (round 2)

Page: `pages/numerical-methods/rational-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Examples 2 to 5 of the Mathews module are dropped without a note

- **Location:** `index.qmd` lines 24 to 36 (Animations section, a single "Case 1"). Line 18 says "Mathews compares three constructions over a fixed interval".
- **What is there now:** one case, Mathews' Example 1 ($e^x$, $R_{2,2}$, $[-1,1]$, equal nodes / Chebyshev nodes / MiniMax).
- **What the archive has:** five examples on $[-1,1]$. Ex. 1 is $e^x$ with $R_{2,2}$ (gr_9 and gr_10). Ex. 2 is $e^x$ with $R_{4,4}$ (gr_113 and gr_114, with "9 coefficients" in lnk_5), using equal nodes, Chebyshev nodes and MiniMax. Ex. 3 is $\cos(\pi x/2)$ (gr_217). Ex. 4 is $\tan x$ (gr_296). Ex. 5 is $\arctan x$ (gr_376). Examples 3 to 5 each use equal and Chebyshev nodes.
- **How I know:** `sed 's/<[^>]*>//g' RationalApproxMod.html` lists the five examples. I viewed the function images named above.
- **Why only Minor:** the page claims nothing false. It describes only the $e^x$ $[2/2]$ workflow, and it presents that workflow correctly. A reader loses Mathews' higher-order ($[4/4]$) comparison and the non-exponential examples (the $\tan x$ case near its poles is the most instructive). Nothing on the page tells the reader those exist.
- **Suggested correction:** either add cases (the $[4/4]$ $e^x$ case is the cheapest, since the same script with $m=n=4$ and a 10-point Remez reference covers it), or add one sentence after line 26 saying the page animates Mathews' Example 1 only and that the module also treats $R_{4,4}$ for $e^x$ and $\cos(\pi x/2)$, $\tan x$, $\arctan x$.

No other findings.

Non-findings I considered and rejected:
- **Absolute vs. relative error.** Mathews reports the interpolants' errors as absolute error ($|e|\le 0.000367365$ for equal nodes, gr_30). The page reports relative error for all three. That is a valid and consistent choice, and the page labels it everywhere. My independent max absolute error for equal nodes is 3.6736475e-4, which agrees with Mathews.
- **The error panel plots $|f-R|/|f|$, not the signed error.** So the "alternating sign" stated in the text cannot be seen in the frame, but the equal-ripple heights can. The text states the sign alternation as a fact, not as something the frame shows, and the fact is true (see the ledger).

- **Independent check:** not run (Minor finding, unverified)


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

| # | Page text (quoted) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description: "$R_{m,n}(x)=P_m(x)/Q_n(x),\ Q_n(x)\neq0$" | Script form `(a0+a1x+a2x^2)/(1+b1x+b2x^2)`. Independent min of $Q$ on $[-1,1]$ is 0.5818 (eq), 0.5818 (cheb) and 0.5818 (minimax), so it is never zero. | confirmed |
| 2 | "Mathews compares three constructions over a fixed interval: interpolation with equally spaced nodes, interpolation with Chebyshev nodes, and a MiniMax (MinMax) construction" | Archive Example 1 (a), (b), (c) on $[-1,1]$. | confirmed |
| 3 | "For the MinMax procedure, the goal is to minimize the maximum relative error $\max|(f-R)/f|$" | Archive lnk_4: "the MiniMax rational approximation is minimizing the 'relative error'". The script's Remez solves $P=f(1-s_iE)Q$, which is the weighted (relative) equioscillation system. | confirmed |
| 4 | "$f(x)=e^x$ on $[-1,1]$ with a fixed $[2/2]$ rational form" | Script line 12 `f(x)=exp(x)`, `a,b=-1,1`, 5 coefficients; archive gr_10 and gr_13. | confirmed |
| 5 | "(1) equally spaced nodes, (2) Chebyshev nodes, and (3) the minimax (MinMax) approximant" (order of frames) | Frames 1, 2, 3 titles: "Equally spaced nodes", "Chebyshev nodes", "Minimax (Remez)". | confirmed |
| 6 | "computed here by the Remez exchange algorithm" | Script lines 57 to 131: a 6-point reference, Newton solve of the levelled system, a full exchange to the 6 extrema of the error on each sign interval, iterated to a ripple spread of 7e-16. This is the multi-point (second) Remez algorithm for weighted rational approximation. | confirmed |
| 7 | "Julia source scripts … are linked under each case" / `[Julia source](rationalapproxaa.jl)` | The file exists and is the script that produces the embedded GIF. Regenerated GIF is byte-identical to the committed one (manifest). | confirmed |
| 8 | Heading: "Rational $[2/2]$ for $e^x$ on $[-1,1]$: equal nodes, Chebyshev nodes, and MinMax" | As 4 and 5. | confirmed |
| 9 | "Equally spaced interpolation and Chebyshev interpolation are both exact at their nodes" | Script residuals at nodes are ≤4.4e-16 (eq) and ≤4.4e-16 (cheb). Independent residuals are ≤5e-41. Frames 1 and 2 show error zeros at −1, −.5, 0, .5, 1 and at ±0.951, ±0.588, 0. | confirmed |
| 10 | Equal nodes max rel error "about $1.59\times10^{-4}$" | Independent value is 1.593661e-4. Script value is 1.5936498e-4. | confirmed |
| 11 | Equal nodes "largest near $x\approx\pm0.82$" | Independent local maxima at $x=\pm0.824427$ (1.5934e-4 and 1.5937e-4). Script grid argmax is 0.825. | confirmed |
| 12 | Chebyshev max rel error "$8.94\times10^{-5}$" | Independent value is 8.941921e-5, at $x=-1$. Script value is 8.9419212e-5. | confirmed |
| 13 | Minimax max rel error "$8.68\times10^{-5}$" | Independent Remez gives $E^*=8.67978639861\times10^{-5}$. Script gives 8.679786398606e-5. | confirmed |
| 14 | "smallest possible maximum relative error for this form" | The error equioscillates at 6 = m+n+2 points with defect 0 ($a_2,b_2\ne0$) and $Q>0$, so by the alternation theorem it is the best approximation. De la Vallée Poussin check from the Chebyshev interpolant's 6 alternating extrema gives $8.474\times10^{-5}\le E^*\le 8.942\times10^{-5}$, which is consistent. The coefficients also equal Mathews' `MiniMaxApproximation` output (gr_89): 0.999999996233065, 0.4997856238266, 0.0815926963252, −0.4997856257093, 0.0815926966326. | confirmed |
| 15 | "about 3% below the Chebyshev value" | (8.94192−8.67979)/8.94192 = 2.93%. | confirmed |
| 16 | "alternating sign at six points ($x=-1,\pm0.812,\pm0.312,1$)" | Independent points are −1, ∓0.8123043, ∓0.3124146, 1. Signed errors −,+,−,+,−,+, each of magnitude 8.67978639861e-5. Script points are −1, −0.8123043, −0.3124147, 0.3124143, 0.8123043, 1, with signs −,+,−,+,−,+. | confirmed |
| 17 | "the relative-error curve in the last frame is equal-ripple" | Frame 3: six peaks of equal height ≈8.7e-5, including the endpoints. | confirmed |
| 18 | Alt text: "in three frames" | frames.md5 lists 3 frames. | confirmed |
| 19 | Alt text: "equally spaced-node interpolation (max relative error 1.59e-4), Chebyshev-node interpolation (8.94e-5), and the minimax approximant from Remez exchange (8.68e-5, equal-ripple error)" | Frame legends read 0.0001594, 8.94e-5 and 8.68e-5. Values as in 10, 12 and 13. | confirmed |
| 20 | Alt text: "each with function and relative-error panels" | All 3 frames have a top panel ($f$ and $R$) and a bottom panel ($|f-R|/|f|$). | confirmed |
| 21 | Embed `rationalapproxaa.gif` is this case | It is produced by `rationalapproxaa.jl`, and the titles match the heading. | confirmed |
| 22 | Chebyshev nodes are the Chebyshev nodes Mathews used | Script uses the zeros of $T_5$ ($\pm0.9511, \pm0.5878, 0$), which is the standard choice. Archive images for 1(b) (gr_49 to gr_86) are missing, so I could not compare. | could not determine (archive incomplete); the standard choice is correct |

### 3. Implementation checks: `rationalapproxaa.jl`

**It is the method it claims to be.**
- Frames 1 and 2 use linearized rational interpolation: $P(x_i)-f(x_i)Q(x_i)=0$ with $Q(0)=1$, 5×5 solve (lines 24 to 37). This is the same construction as Mathews' "Form the set of equations to solve".
- Frame 3 uses Remez exchange for the minimax relative-error approximant (lines 57 to 131):
  - The reference system $P(x_i)=f(x_i)(1-s_iE)Q(x_i)$ is solved by Newton. I checked the Jacobian by hand: $\partial F/\partial b_k=-w x^k$ and $\partial F/\partial E = y\,s\,Q$, both correct.
  - The exchange takes one extremum per sign interval of the error, located on a 20001-point grid and refined by golden-section search.
  - The start is the $T_5$ extrema $\cos(\pi(5-k)/5)$, as the comment says.
  - This is a legitimate multi-point Remez for weighted rational approximation.

**The numbers are right.** Script values (instrumented copy) beside the independent mpmath (40 digits) values:

| Quantity | Script | Independent |
|---|---|---|
| eq coeffs a0..b2 | 1.0, 0.499831480449449, 0.0816120384126299, −0.499831480449449, 0.0816120384126298 | 1.0, 0.499831480449, 0.0816120384126, −0.499831480449, 0.0816120384126 |
| Mathews eq coeffs (gr_24) | n/a | 1., 0.499831, 0.081612 (numerator); 1, −0.499831, 0.081612 (denominator) |
| cheb coeffs | 1.0, 0.499789375887513, 0.0816032216119461, −0.499789375887513, 0.0816032216119461 | 1.0, 0.499789375888, 0.0816032216119, −0.499789375888, 0.0816032216119 |
| minimax coeffs | 0.9999999962330653, 0.49978562382661, 0.08159269632523836, −0.499785625709263, 0.08159269663258942 | 0.999999996233065, 0.499785623826607, 0.0815926963252367, −0.499785625709266, 0.0815926966325911 |
| max rel err eq | 1.5936498e-4 (1201-pt grid) | 1.593661413e-4 at $x=0.82443$ |
| max rel err cheb | 8.941921150e-5 | 8.94192115e-5 at $x=-1$ |
| minimax $E$ | 8.679786398606e-5 | 8.67978639861e-5 |
| alternation points | −1, −0.81230427, −0.31241468, 0.31241432, 0.81230432, 1 | −1, −0.8123042914, −0.3124145944, 0.3124145944, 0.8123042914, 1 |
| signed errors at alt. points | −,+,−,+,−,+, all 8.6797864e-5 | −,+,−,+,−,+, all 8.67978639861e-5 |

Property checks:
- The interpolants reproduce the data at the nodes (residuals ~1e-16).
- The minimax error equioscillates at m+n+2 = 6 points with $Q>0$, which certifies optimality.
- Both interpolants show the symmetry $P(x)=Q(-x)$ that follows from $e^{-x}=1/e^x$.

The script's printed alternation points differ from the true ones by up to 3e-7 (golden-section on a flat extremum). That has no effect on anything displayed or quoted.

**Its reference values are right.** The reference curve is $e^x$ itself, evaluated directly. The "true" minimax value the page quotes (8.68e-5) was checked independently and against Mathews' Mathematica output.

**The picture shows what was computed.** I viewed frames 1, 2 and 3 (all frames).
- Top panels show $e^x$ (blue) and $R$ (green dashed) over $[-1,1]$. The red node markers sit at the script's nodes (eq: −1, −.5, 0, .5, 1; cheb: ±0.951, ±0.588, 0) and on the curve. Frame 3 has no node markers, by design (line 177).
- Bottom panels show $|f-R|/|f|$ with ylims $[0, 2\times10^{-4}]$. Every curve fits inside, since the largest is 1.594e-4, so nothing is clipped.
- The error zeros sit at the nodes in frames 1 and 2. Frame 3 shows six equal peaks, including the endpoints.
- Legend values come from `max_relative_error` on a 1201-point grid and agree with the independent maxima to the 4 digits shown (frame 1 shows "0.0001594", and the true value 1.59366e-4 rounds to 0.0001594).
- The title function "exp(x)" matches the code.
- The committed GIF is byte-identical to the regenerated one (manifest), so the frames reflect the current script.

