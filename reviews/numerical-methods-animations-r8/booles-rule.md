# Boole's Rule — animation review (round 8)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames, and the script implements composite Boole's rule correctly.

Things I noticed but do not count as findings:
- The on-frame annotation uses `round(approx; digits=6)`, so two frames show five decimals because the sixth is a trailing zero ("2.01268" for n=28 and "2.01537" for n=64). The value is correct; Mathews' GIF printed "2.012680". This is cosmetic.
- The introduction says "Each animation below" although there is only one case. This is wording only.
- Unlike Mathews' frames, the GIF does not print the function formula. The page states the function in the introduction and in the case heading, so nothing is misleading.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 8.1 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Composite Boole applies "a quartic interpolant on each block of four subintervals (five nodes)" with $h=(b-a)/n$ and $n$ divisible by 4 | script lines 26-38 and 48-64; every n in `n_seq` is a multiple of 4 | confirmed |
| D2 | $B_n=\frac{2h}{45}\sum(7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4})$ | I integrated the Lagrange basis on nodes 0..4 in sympy and got weights 14/45, 64/45, 8/15, 64/45, 14/45 (times h), which equal (2/45)·[7,32,12,32,7]. The script uses the same formula (line 35) | confirmed |
| D3 | "exact for polynomials up to degree 5" | sympy check with these weights: exact for degrees 0 through 5, not exact for degree 6 (error −128/21 on [0,4]) | confirmed |
| D4 | global error $O(h^6)$ for $f\in C^6$ | follows from degree of precision 5 (D3) and the standard composite argument | confirmed |
| D5 | Boole is the "highest-order of the four closed Newton-Cotes rules on this site (trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole)" | the orders are 2, 4, 4 and 6. The sibling pages trapezoidal, Simpson 1/3, Simpson 3/8 and newton-cotes-integration exist | confirmed |
| D6 | "Closed rules with seven or more nodes per panel are exact to higher degree (the seven-node rule to degree 7)" | sympy: the 7-node closed rule is exact through degree 7 and not degree 8. The 6-node rule is exact only to degree 5, so "seven or more" is the right threshold | confirmed |
| A1 | The integrand is $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | script line 8: `exp(-x)*sin(8*x^(2/3))+1`, with a, b = 0, 2 | confirmed |
| A2 | "After an opening frame showing only $f$" | `vcat(0, n_seq)`, n=0 branch; frame_001 shows only the magenta curve | confirmed |
| A3 | "each frame recomputes the approximation over the full interval with a denser partition where $n$ remains a multiple of 4" | n_seq = 4,8,…,64,72,…,120, strictly increasing and all multiples of 4; `boole_sum` is computed over [0,2] for each n | confirmed |
| A4 | "Red dots mark the sample points $x_i$" | lines 80-83; frames show red dots at all n+1 nodes | confirmed |
| A5 | "vertical red lines mark the panel boundaries $x_{4k}$" | lines 66-70 (`for i in 0:4:n`). Frame 2 (n=4) has lines only at 0 and 2, and frame 24 has 31 lines | confirmed |
| C1 | Heading: Composite Boole's Rule, same $f$, $[0,2]$ | as A1 and D2 | confirmed |
| C2 | "Piecewise quartic panels are rebuilt at increasing density" | lines 55-63 build a degree-4 Vandermonde interpolant per block. The node residual is 3.2e-14 (n=8, inst.jl) | confirmed |
| C3 | "the approximation increases from frame to frame" | all 23 values increase monotonically (table in section 3) | confirmed |
| C4 | "toward the true integral $\int_0^2 f\,dx\approx 2.016280$" | mpmath with substitution x=t³: 2.0162797196170963…, and adaptive quad on [0,0.1,0.5,1,2] gives the same digits | confirmed |
| C5 | "staying below it" | I−B_n > 0 for all 23 n, from 0.463 at n=4 to 3.185e-4 at n=120 | confirmed |
| C6 | "the last frame (121 sample points) gives 2.015961" | the script and my computation both give 2.0159611789, and frame_024 reads "Sample Points = 121", "Approximation = 2.015961" | confirmed |
| C7 | "about $3.2\times10^{-4}$ low" | 2.0162797196 − 2.0159611789 = 3.1854e-4 | confirmed |
| C8 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | d/dx sin(8x^{2/3}) = cos(·)·(16/3)x^{-1/3}, and e^{-x}→1 and cos→1 as x→0 | confirmed |
| C9 | "measured error shrinks like $O(h^{5/3})$ rather than $O(h^6)$" | error ratios on halving h: 3.1725 (32→64), 3.1820 (60→120), 3.1796 (120→240), 3.1774, 3.1761, 3.1755 (960→1920) | confirmed |
| C10 | "halving $h$ divides it by about 3.18 (from 60 to 120 subintervals)" | 3.18196 | confirmed |
| C11 | "tending to $2^{5/3}\approx 3.17$, instead of $2^6=64$" | 2^{5/3}=3.1748, and the ratios approach it from above (C9) | confirmed |
| W1 | `[Julia source](boolesaa.jl)` is the script for this case | the file exists and produces `boolesaa.gif` (line 86) | confirmed |
| W2 | The embed `boolesaa.gif` is this case's animation | the manifest shows the regenerated GIF is byte-identical to the committed one, and its frames match C6 | confirmed |
| W3 | Alt text: "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | frames 1, 2, 12 and 24 viewed. The approximation appears as on-frame text | confirmed |
| F1 | Fidelity: same example as Mathews | Mathews' GIF uses $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2] with the same per-frame values (1.553155, 2.001295, …, 2.015961 at 121 points) and the same red dots, panel lines and pink fill | confirmed |

### 3. Implementation checks: `boolesaa.jl`

**It is the method it claims to be.** `boole_sum` (lines 26-38) is the composite closed 5-point Newton-Cotes rule (Boole) with weights (2h/45)[7,32,12,32,7] on consecutive blocks of four subintervals. I derived the weights independently from Lagrange basis integrals in sympy and they match. The drawn panels are the exact quartic interpolants through each block's five nodes (Vandermonde solve, node residual 3.2e-14). Since Boole's rule is by construction the integral of that interpolant, the pink area equals the printed approximation.

**The numbers are right.** Script values (inst.jl) beside my independent mpmath computation (check.py), with the true error I − B_n:

| n | pts | script `boole_sum` | independent | I − B_n |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827 | 1.553154683 | 0.46313 |
| 8 | 9 | 1.9634127276 | 1.963412728 | 0.052867 |
| 12 | 13 | 2.0012951727 | 2.001295173 | 0.014985 |
| 16 | 17 | 2.0073277270 | 2.007327727 | 0.008952 |
| 20 | 21 | 2.0100452875 | 2.010045288 | 0.0062344 |
| 24 | 25 | 2.0116443222 | 2.011644322 | 0.0046354 |
| 28 | 29 | 2.0126802231 | 2.012680223 | 0.0035995 |
| 32 | 33 | 2.0133926437 | 2.013392644 | 0.0028871 |
| 36 | 37 | 2.0139049570 | 2.013904957 | 0.0023748 |
| 40 | 41 | 2.0142865946 | 2.014286595 | 0.0019931 |
| 44 | 45 | 2.0145791464 | 2.014579146 | 0.0017006 |
| 48 | 49 | 2.0148087832 | 2.014808783 | 0.0014709 |
| 52 | 53 | 2.0149926569 | 2.014992657 | 0.0012871 |
| 56 | 57 | 2.0151424002 | 2.015142400 | 0.0011373 |
| 60 | 61 | 2.0152661372 | 2.015266137 | 0.0010136 |
| 64 | 65 | 2.0153696865 | 2.015369687 | 0.00091003 |
| 72 | 73 | 2.0155321836 | 2.015532184 | 0.00074754 |
| 80 | 81 | 2.0156527993 | 2.015652799 | 0.00062692 |
| 88 | 89 | 2.0157450522 | 2.015745052 | 0.00053467 |
| 96 | 97 | 2.0158173622 | 2.015817362 | 0.00046236 |
| 104 | 105 | 2.0158752086 | 2.015875209 | 0.00040451 |
| 112 | 113 | 2.0159222896 | 2.015922290 | 0.00035743 |
| 120 | 121 | 2.0159611789 | 2.015961179 | 0.00031854 |

The degree-of-precision property holds: the weights are exact through degree 5 and fail at degree 6.

**Its reference values are right.** The script draws no exact curve. The page's true integral 2.016280 is confirmed by two independent mpmath quadratures (the x=t³ substitution removes the singular derivative), which agree to 30 digits: 2.01627971961709632788727442192.

**The picture shows what was computed.** I viewed the contact sheet and frames 1, 2 and 24. Frame 1 shows f only. In frame 2 (n=4) the single quartic passes through the 5 red nodes and dips to about 0.12, which is inside the window (ylims 0 to 2.1, so nothing is clipped). The f maximum of about 1.92 is also inside. The panel lines sit at x_{4k}. The annotations "Sample Points = n+1" and "Approximation = …" match the table above in every frame I checked (9→1.963413, 17→2.007328, 25→2.011644, …, 121→2.015961). The axis limits keep everything visible, and there is no clamping or masking.

