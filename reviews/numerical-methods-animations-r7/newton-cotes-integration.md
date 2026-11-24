# Newton-Cotes Integration — animation review (round 7)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None: 0 Error, 0 Misleading, 0 Minor.**

Every checkable claim in the ledger was confirmed by a computation or frame inspection of my own.

Examined and deliberately not reported, because none changes what a reader concludes:

- `round(approx; digits=6)` drops trailing zeros, so some frames read `2.01389`, `2.01017`, `2.01037` or `2.01581` where Mathews prints six decimals (`2.013890`). The values are correct.
- Case 1 draws no red sample-point dots, while Mathews' trapezoidal GIF and Cases 2-4 do. Every node is still marked by a trapezoid edge, and the page does not claim dots for Case 1.
- The page's sample-count sequences differ from Mathews' at some frames (Case 1 has 49, 57, 65, 73, 89, 105 where Mathews has 51, 61, 71, 81, 101). The opening is 1 frame of `f` alone against Mathews' 3. The page claims agreement only at the counts the two share, and that claim holds. Rule, integrand, interval and final count match in every case.
- "(degree 1)...(degree 4)" in the Description means interpolant degree. The surrounding sentence is about the interpolating polynomial, and Derivation Notes separates it explicitly from degree of precision.
- The largest gap between the Boole interpolant and `f` in the last frame (0.045) is confined to the first panel, next to the $x^{2/3}$ singularity. Outside it the gap is $2\times10^{-5}$. "Tracks oscillations closely" stands.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 8.3 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 8.1 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 9.4 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 8.6 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtoncotesaa.gif` | 25 | byte-identical | newtoncotesaa |
| `newtoncotesbb.gif` | 21 | byte-identical | newtoncotesbb |
| `newtoncotescc.gif` | 25 | byte-identical | newtoncotescc |
| `newtoncotesdd.gif` | 25 | byte-identical | newtoncotesdd |

### Page references

- Scripts linked: `newtoncotesaa.jl`, `newtoncotesbb.jl`, `newtoncotescc.jl`, `newtoncotesdd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Reference value used throughout: $I=\int_0^2 f\,dx = 2.016279719617096$, computed by mpmath at 40 digits in two ways that agree to $5\times10^{-41}$: with the substitution $x=t^3$, which removes the singularity, and directly on a graded partition.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton-Cotes interpolates on equally spaced nodes and integrates the interpolant on each panel | Weights derived by integrating Lagrange basis polynomials symbolically reproduce the scripts' rules; each script's drawn interpolant integrates to its rule value (max difference below $10^{-12}$) | confirmed |
| D2 | Trapezoidal degree 1, Simpson 1/3 degree 2, 3/8 degree 3, Boole degree 4 (interpolant) | 2, 3, 4, 5 nodes per panel in code; fits are `poly_coeffs` on those nodes | confirmed |
| D3 | $T_n$ formula | Page formula evaluated at $n=40$ minus the rule from derived weights: 0.0 | confirmed |
| D4 | $S_n$ formula for even $n$ | Same check at $n=40$: 0.0 | confirmed |
| D5 | Animations increase point density over the full interval between frames | Sample counts strictly increasing in all 4 GIFs (read from frames); each frame spans $[0,2]$ | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Each case uses $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Line 8-9 of all four scripts | confirmed |
| A2 | Each shows a different closed Newton-Cotes construction with density rising frame by frame | Code and frames; endpoints are nodes | confirmed |
| A3 | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ | sympy: $\lim_{x\to0^+} x^{1/3}f'(x)=16/3$ | confirmed |
| A4 | Textbook order does not hold; all four errors shrink like $O(h^{5/3})$ | Ratios at $n=12\cdot2^{13}$: 3.1741, 3.1748, 3.1748, 3.1748; $2^{5/3}=3.1748$. Closed-form leading term $8\zeta(-2/3)\,c\,h^{5/3}$ matches at $n=3072$ (see below) | confirmed |
| A5 | 24 to 48 subintervals divides error by about 3.14, 3.38, 3.55, 3.15 | 3.14152, 3.38032, 3.54990, 3.15132 | confirmed |
| A6 | Ratios tend to $2^{5/3}\approx3.17$ for each | As A4 | confirmed |
| A7 | Instead of 4, 16, 16, 64 | Smooth control $e^x$ on $[0,2]$, $n=48\to96$: 3.99991, 15.9975, 15.995, 63.9563 | confirmed |
| A8 | At equal $h$ higher-degree rules gain only a constant factor over trapezoidal | Asymptotic error factors relative to trapezoidal: Simpson $(4-2^{5/3})/3=0.27507$, 3/8 $(9-3^{5/3})/8=0.34497$, Boole $(64-20\cdot2^{5/3}+4^{5/3})/45=0.23519$. Measured at $n=3072$: errors $-1.67045, -2.09504, -1.42819\times10^{-6}$; predicted $-1.67016, -2.0946, -1.42801\times10^{-6}$ | confirmed |

### Case 1: Trapezoidal

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Linear segments connect adjacent sample points, creating trapezoids | Lines 32-42; frames | confirmed |
| C1.2 | Trapezoids refine as nodes get denser | 2 to 121 sample points across 24 frames | confirmed |
| C1.3 | Alt: density increases each frame, approximation updates | OCR of all 24 annotated frames matches independent values | confirmed |
| C1.4 | Link and embed are the trapezoidal case | `newtoncotesaa.jl`, `.gif`; title "Trapezoidal Rule" | confirmed |

### Case 2: Simpson 1/3

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Pairs of subintervals approximated by quadratics | Lines 40-54 | confirmed |
| C2.2 | Visibly smoother top boundary than trapezoids | Frames: kinks only at panel joints | confirmed |
| C2.3 | Stops at 41 sample points | Last $n=40$; frame 21 reads 41 | confirmed |
| C2.4 | Mathews' Simpson animation also stops at 41 | Legacy maximum read across frames: 41 | confirmed |
| C2.5 | Last frame less accurate than the 121-point last frames of the others | $\lvert E\rvert$: Simpson-41 $2.390\times10^{-3}$; T-121 $1.335\times10^{-3}$, 3/8-121 $4.693\times10^{-4}$, Boole-121 $3.185\times10^{-4}$ | confirmed |
| C2.6 | At 41 points error $2.4\times10^{-3}$ | $2.3897\times10^{-3}$ | confirmed |
| C2.7 | Trapezoidal error at 41 points $8.3\times10^{-3}$, larger than Simpson's | $8.2628\times10^{-3}$ | confirmed |
| C2.8 | Alt: opening frame shows only $f$ | Frame 1 | confirmed |
| C2.9 | Alt: red dots mark sample points | Lines 70-73 ($n+1$ nodes); frames | confirmed |
| C2.10 | Alt: vertical red lines mark boundaries of pairs | Lines 57-60 (`0:2:n`); frames | confirmed |
| C2.11 | Alt: piecewise quadratic area updates | Drawn area equals rule value, max difference below $10^{-12}$ | confirmed |
| C2.12 | Link and embed are the Simpson 1/3 case | `newtoncotesbb.jl`, `.gif`; title "Simpson's Rule" | confirmed |

### Case 3: Simpson 3/8

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Triplets of subintervals approximated by cubics | Lines 40-55 | confirmed |
| C3.2 | Higher-degree piecewise fit than Simpson 1/3 but not higher order; both degree of precision 3 | Composite on $x^d$, $n=12$: both exact through $d=3$ (residual below $10^{-40}$), both fail at $d=4$ ($4.63\times10^{-4}$ and $2.06\times10^{-4}$) | confirmed |
| C3.3 | Error at the same $h$ is larger | Ratio above 1 at all 20 multiples of 6 from 6 to 120 (range 1.257 to 1.584) | confirmed |
| C3.4 | About 1.25 times Simpson 1/3's error as $h$ shrinks | Measured 1.25416 at $n=6144$; closed-form limit 1.25413 | confirmed |
| C3.5 | Alt: opening frame, density up to 121 sample points | Frame 1; last frame reads 121 | confirmed |
| C3.6 | Alt: dots, boundaries of triplets, piecewise cubic area | Lines 57-73; frames; drawn area equals rule value | confirmed |
| C3.7 | Link and embed are the 3/8 case | `newtoncotescc.jl`, `.gif` | confirmed |

### Case 4: Boole

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Blocks of four subintervals use quartic interpolation | Lines 49-65 | confirmed |
| C4.2 | As density rises, the envelope tracks oscillations closely | Max gap to $f$ outside the first panel: $n=8$ 0.01255, 24 0.00144, 48 $1.1\times10^{-4}$, 120 $2\times10^{-5}$; frame 25 | confirmed |
| C4.3 | Alt: opening frame, density up to 121 sample points | Frame 1; last frame reads 121 | confirmed |
| C4.4 | Alt: dots, boundaries of blocks of four, piecewise quartic area | Lines 68-84; frames; drawn area equals rule value | confirmed |
| C4.5 | Link and embed are the Boole case | `newtoncotesdd.jl`, `.gif` | confirmed |

### Legacy note and Derivation Notes

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| L1 | Each case uses the same rule, integrand and interval as Mathews' animation | Legacy titles and axes: $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$; the rule named in each | confirmed |
| L2 | At every shared sample count the approximations agree to six decimals | Printed values compared at all shared counts: 15 (T), 20 (Simpson), 17 (3/8), 20 (Boole), **72 in total, 0 differences** | confirmed |
| N1 | Interpolant degrees 1, 2, 3, 4; degrees of precision 1, 3, 3, 5 | Composite exactness on $x^d$, $d=0..7$: first failures at $d=$ 2, 4, 4, 6 | confirmed |
| N2 | Even-subinterval rules are exact one degree beyond their interpolant | Simpson 1/3 and Boole in N1 | confirmed |
| N3 | Smooth-$f$ composite orders 2, 4, 4, 6 | Ratios in A7 | confirmed |
| N4 | 3/8 is not higher order than 1/3 | N1, N3 | confirmed |
| N5 | Composite constants $\tfrac1{80}$ (3/8) and $\tfrac1{180}$ (1/3) | Exact rational arithmetic on $x^4$, $[0,2]$, $n=12$: $E=1/2160$ and $1/4860$, each equal to $(b-a)h^4\cdot24/C$ | confirmed |
| N6 | Very high-degree rules on wide panels can become less robust | Closed N-C normalized weights: all positive through degree 6; degree 8 min $-0.160$, $\sum\lvert w\rvert=1.45$; degree 10 $3.06$; degree 12 $7.53$ | confirmed |

### 3. Implementation checks

For all four scripts:

- **Regeneration:** the manifest reports each committed GIF byte-identical to a scratch run, so frames show what the current code produces.
- **Frames:** 25, 21, 25, 25 in `aa`, `bb`, `cc`, `dd`, equal to `1 + length(n_seq)`; all decoded frames are distinct.
- **Reference values:** no script draws an exact solution or quotes a true integral, so no script reference needed checking. The page's error figures were checked against $I$ above.
- **Display devices:** none affects the reading. No clamping or masking. Every drawn interpolant lies in $[0.1236, 1.9760]$, inside `ylims = (0, 2.1)`.

| Script | Method it runs | Frames (n) | max \|script - independent\| | max \|drawn area - script\| | Max node residual | Drawn y range |
|---|---|---|---|---|---|---|
| `newtoncotesaa.jl` | Composite trapezoidal | 24 | $4.74\times10^{-13}$ | below $10^{-12}$ | exact by construction | 0.3572 to 1.9191 |
| `newtoncotesbb.jl` | Composite Simpson 1/3 | 20 | $4.77\times10^{-13}$ | below $10^{-12}$ | $2.0\times10^{-15}$ | 0.3489 to 1.9760 |
| `newtoncotescc.jl` | Composite Simpson 3/8 | 24 | $4.69\times10^{-13}$ | below $10^{-12}$ | $1.3\times10^{-14}$ | 0.2011 to 1.9396 |
| `newtoncotesdd.jl` | Composite Boole | 24 | $4.78\times10^{-13}$ | below $10^{-12}$ | $5.5\times10^{-14}$ | 0.1236 to 1.9306 |

The independent computation does not reuse any script code or remembered coefficient table: weights come from symbolic integration of Lagrange basis polynomials (`indep.py`), giving 1/2, 1/2; 1/3, 4/3, 1/3; 3/8, 9/8, 9/8, 3/8; and 14/45, 64/45, 8/15, 64/45, 14/45 (times $h$). Values are evaluated at 40 digits.

Selected values, script against independent:

| Script | $n$ | Points | Script | Independent |
|---|---|---|---|---|
| aa | 1 | 2 | 2.017924816216 | 2.017924816216 |
| aa | 24 | 25 | 1.997085695854 | 1.997085695854 |
| aa | 40 | 41 | 2.008016894673 | 2.008016894673 |
| aa | 120 | 121 | 2.014944464620 | 2.014944464620 |
| bb | 2 | 3 | 2.491261017253 | 2.491261017253 |
| bb | 24 | 25 | 2.010369629370 | 2.010369629370 |
| bb | 40 | 41 | 2.013890041135 | 2.013890041135 |
| cc | 3 | 4 | 1.884214099419 | 1.884214099419 |
| cc | 24 | 25 | 2.008397041547 | 2.008397041547 |
| cc | 120 | 121 | 2.015810410864 | 2.015810410864 |
| dd | 4 | 5 | 1.553154682740 | 1.553154682740 |
| dd | 24 | 25 | 2.011644322159 | 2.011644322159 |
| dd | 120 | 121 | 2.015961178871 | 2.015961178871 |

**Picture checks.** I viewed all four contact sheets, frame 2 of each GIF, and the last Boole frame in full size, plus legacy final frames. Panels are built from the right nodes: trapezoid edges at adjacent nodes; quadratics, cubics and quartics through 3, 4 and 5 nodes; dividers at every 2nd, 3rd and 4th node; markers at all $n+1$ nodes in Cases 2-4. OCR of the annotation in every non-opening frame (92 frames across the four GIFs) read the sample count and approximation, and each matched the independent rule value at that count within rounding of the sixth decimal.

**Could not determine:** nothing on this page.

