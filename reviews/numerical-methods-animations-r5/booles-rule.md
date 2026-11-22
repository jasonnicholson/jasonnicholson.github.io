# Boole's Rule — animation review (round 5)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed against independent computation and the frames.

Observations that I judged not to be findings (listed so the owner can see they were considered):

- The on-frame approximation is formatted with `round(approx; digits=6)`, which drops trailing zeros: frame 8 shows `2.01268` (true 2.0126802) and frame 17 shows `2.01537` (true 2.0153697). Both are correct to the digits shown; cosmetic only.
- The GIF has no on-frame label of $f$ (Mathews' GIF shows `y = e^{-x} sin(8x^{2/3}) + 1`). The page text and case heading state $f$, so nothing is misleading.
- The refinement sequence differs slightly from Mathews' (script: n = 4..64 step 4, then 72..120 step 8, one opening frame; Mathews: n = 4..40 step 4, then 48..120 step 8, three opening frames and n=4 held for two frames). The page makes no claim about the sequence, and start/end and every shared n agree; not a fidelity issue that matters to a reader.
- "the highest-order closed Newton-Cotes rule in this set" — "this set" is not defined on this page, but in the site's integration section (and the sibling `newton-cotes-integration` page) the closed Newton-Cotes rules are trapezoidal, Simpson 1/3, Simpson 3/8 and Boole (orders 2, 4, 4, 6), so the claim is true.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 9.7 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `boolesaa.gif` | 24 | byte-identical | boolesaa |

### Page references

- Scripts linked: `boolesaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | "applies a quartic interpolant on each block of four subintervals (five nodes)" | Script `poly_coeffs` on 5 nodes per block; integral of the drawn quartics equals `boole_sum` to 1.5e-14 for every n (instr.jl) | confirmed |
| D2 | Description | $h=(b-a)/n$, $n$ divisible by 4 | script `dx=(b-a)/n`, all n in `n_seq` multiples of 4 | confirmed |
| D3 | Description | $B_n=\frac{2h}{45}\sum_{k=0}^{n/4-1}(7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4})$ | Weights derived by solving the 5-node moment equations in sympy: [14/45, 64/45, 8/15, 64/45, 14/45] = (2/45)[7,32,12,32,7]; script line 35 uses exactly this; loop `0:4:n-4` = k=0..n/4-1 | confirmed |
| D4 | Description | "exact for polynomials up to degree 5" | Composite rule on [0,2], n=4 and 8: error 0 (≤2e-40) for x^0..x^5; x^6 error 0.0476 (n=4), 7.4e-4 (n=8) | confirmed (degree of precision exactly 5) |
| D5 | Description | for $C^6$ $f$, global error $O(h^6)$ | Follows from D4 (standard composite NC error $-\frac{2(b-a)}{945}h^6 f^{(6)}$); x^6 error ratio n=4→8 = 0.047619/0.00074405 = 64.0 = 2^6 | confirmed |
| D6 | Description | "highest-order closed Newton-Cotes rule in this set" | Site's closed NC rules: trapezoid O(h²), Simpson 1/3 O(h⁴), 3/8 O(h⁴), Boole O(h⁶) | confirmed |
| A1 | Animations intro | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | script line 8–9 | confirmed |
| A2 | Animations intro | "After an opening frame showing only $f$" | frame_001: only magenta curve, no dots/panels/text; code `vcat(0,n_seq)` with `n>0` guards | confirmed |
| A3 | Animations intro | "each frame recomputes the approximation over the full interval with a denser partition where $n$ remains a multiple of 4" | n_seq strictly increasing, all multiples of 4; `boole_sum(n)` over [a,b] each frame | confirmed |
| A4 | Animations intro | "Red dots mark the sample points $x_i$" | script lines 81–82 scatter at $a+i\,dx$, i=0..n; frames 2, 8, 24 show n+1 red dots on the curve | confirmed |
| A5 | Animations intro | "vertical red lines mark the panel boundaries $x_{4k}$" | script lines 67–69, i in 0:4:n; frame_002 (n=4) lines at 0 and 2 only; frame_008 (n=28) 8 lines at multiples of 2/7 | confirmed |
| A6 | Animations intro | "Each animation below" / "scripts ... linked under each case" | one case, one link, one embed | confirmed |
| C1 | Case heading | Composite Boole's rule, same f, [0,2] | script | confirmed |
| C2 | Behavior | "Piecewise quartic panels are rebuilt at increasing density" | frames 2–24, pink quartic fills; quartics reproduce nodes (max residual 5.5e-14) | confirmed |
| C3 | Behavior | "the approximation increases from frame to frame" | all 23 values strictly increasing (indep.py: 1.553155, 1.963413, … , 2.015961) | confirmed |
| C4 | Behavior | true integral "≈ 2.016280" | mpmath, two ways (x=t³ substitution; direct split quad): 2.0162797196170963 | confirmed |
| C5 | Behavior | "staying below it" | every frame's B_n < I (error from 0.463 down to 3.19e-4, all positive) | confirmed |
| C6 | Behavior | "last frame (121 sample points)" | last n=120 → 121 points; frame_024 shows "Sample Points = 121" | confirmed |
| C7 | Behavior | last frame "gives 2.015961" | script 2.0159611788705827, mine 2.015961179; frame_024 shows 2.015961 | confirmed |
| C8 | Behavior | "about $3.2\times10^{-4}$ low" | I − B_120 = 3.18541e-4 | confirmed |
| C9 | Behavior | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | mpmath diff at x=1e-6: 533.3318 vs 533.3333; at 1e-9: 5333.3333 vs 5333.3333 | confirmed |
| C10 | Behavior | error shrinks like $O(h^{5/3})$ not $O(h^6)$ | error ratios on halving: 3.18196 (60→120), 3.17962, 3.17737, 3.17611, 3.17546, 3.17513, 3.17497, 3.17488 (7680→15360) → 2^{5/3}=3.17480 | confirmed |
| C11 | Behavior | "halving $h$ divides it by about 3.18 (from 60 to 120 subintervals)" | 3.18196 | confirmed |
| C12 | Behavior | "tending to $2^{5/3}\approx 3.17$" | 3.1748 (see C10) | confirmed |
| C13 | Behavior | "instead of $2^6=64$" | arithmetic; 64 is the smooth-f ratio (see D5) | confirmed |
| W1 | Link | `[Julia source](boolesaa.jl)` is this case | file exists, is the Boole script for this f | confirmed |
| W2 | Embed | `boolesaa.gif` is produced by `boolesaa.jl` | regen md5 9d760f8c… identical to committed; script identical to regen copy | confirmed |
| W3 | Alt text | opening frame only f; red dots = sample points; vertical red lines = panel boundaries; piecewise quartic panels; global approximation shown | frames 1, 2, 8, 24 (annotation "Approximation = …") | confirmed |
| F1 | Fidelity | function/interval/endpoint = Mathews' animation | Mathews' Booleaa.gif: same f on [0,2], ends at 121 points, 2.015961; at shared n his values (1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014287, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922, 2.015961) equal mine to 6 decimals | confirmed |

### 3. Implementation checks — `boolesaa.jl`

**It is the method it claims to be.** Composite closed Newton-Cotes 5-point (Boole) rule, blocks of four subintervals, weights (2h/45)(7,32,12,32,7) (line 35), summed over i = 0:4:n-4. Weights verified by deriving them independently from moment equations (sympy, exact rationals), not from memory. Degree of precision measured as exactly 5 (D4).

**The numbers are right.** `instr.jl` (lines 1–38 of the script with Plots removed, plus print loop) vs independent mpmath `indep.py`:

| n | pts | script `boole_sum` | independent | frame text |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827403782 | 1.553154683 | 1.553155 |
| 8 | 9 | 1.9634127276098594 | 1.963412728 | 1.963413 |
| 16 | 17 | 2.0073277270307845 | 2.007327727 | 2.007328 |
| 28 | 29 | 2.0126802231404017 | 2.012680223 | 2.01268 |
| 48 | 49 | 2.0148087832454062 | 2.014808783 | 2.014809 |
| 64 | 65 | 2.0153696865415838 | 2.015369687 | 2.01537 |
| 96 | 97 | 2.0158173622426188 | 2.015817362 | 2.015817 |
| 112 | 113 | 2.0159222895927464 | 2.01592229 | 2.015922 |
| 120 | 121 | 2.0159611788705827 | 2.015961179 | 2.015961 |

All 23 n values agree to the 10 digits printed (full list in indep.py / instr.jl output). Frame texts checked on frames 2, 3, 5, 7, 8, 9, …, 23, 24 (contact sheet plus individual frames).

**Reference values.** The script draws no reference; the page's true integral 2.016280 was verified by mpmath quad with the singularity removed (x = t³) and by direct split quad, both 2.0162797196170963 at 40-digit precision.

**The picture shows what was computed.** Each pink panel is the interpolating quartic through the block's 5 nodes (node residual ≤ 5.5e-14), and its exact integral equals the Boole panel sum (≤ 1.5e-14), so the shaded area is the quantity reported. Dividers at x_{4k} from 0 to f(x_{4k}); dots at all x_i on f. Axis limits x∈[-0.03,2.03], y∈[0,2.1] contain the whole curve (max f ≈ 1.92) and all panels (n=4 quartic min ≈ 0.12 > 0). Title "Boole's Rule / Numerical Quadrature"; "Sample Points = n+1" correct for every frame. 24 frames = 1 opening + 23 values of n. GIF regenerates byte-identically.

