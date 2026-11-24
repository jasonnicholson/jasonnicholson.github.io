# Boole's Rule — animation review (round 9)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every claim in the ledger below was checked against an independent computation or against the frames, and all of them hold.

Two observations that do not count as findings:
- The Animations intro says "Each animation below" although the page has only one case. This is wording only and misleads nobody.
- Legacy frame sequence: Mathews' GIF shows 5, 9, ..., 41, then 49, 57, ..., 121 sample points, with two or three opening frames. The new GIF shows 5, 9, ..., 65, then 73, ..., 121, with one opening frame. The function, interval, rule, end point (121) and every shared approximation value are the same, so a reader loses nothing.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 14.6 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | Script lines 29-36 and 48-64 use blocks i=0:4:n-4 with five nodes, and the drawn curve is the degree-4 Vandermonde interpolant | confirmed |
| 2 | $h=(b-a)/n$ with $n$ divisible by 4 | `dx=(b-a)/n`; n_seq contains only multiples of 4 | confirmed |
| 3 | $B_n=\frac{2h}{45}\sum(7,32,12,32,7)$ | sympy integration of the Lagrange basis on [0,4] gives 14/45, 64/45, 8/15, 64/45, 14/45 = (2/45)(7,32,12,32,7) (check.py) | confirmed |
| 4 | "exact for polynomials up to degree 5" | Boole with n=4 on [0,2]: error 0 for x^0..x^5 and 0.0476 for x^6 (check.py) | confirmed |
| 5 | Global error $O(h^6)$ for $f\in C^6$ | e^x on [0,2], n=4,8,16,32: error ratios 58.3, 62.5, 63.6, which tend to 64 (extra.py) | confirmed |
| 6 | "highest-order of the four closed Newton-Cotes rules on this site (trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole)" | The sibling pages for those rules exist; their orders are 2, 4, 4 and 6 | confirmed |
| 7 | "Closed rules with seven or more nodes per panel are exact to higher degree (the seven-node rule to degree 7)" | Exact closed Newton-Cotes weights: 6 nodes give degree 5, 7 nodes degree 7, 8 nodes degree 7 (extra.py) | confirmed |
| 8 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ (intro and heading) | Script lines 8-9 | confirmed |
| 9 | "After an opening frame showing only $f$" | frame_001 shows only the magenta curve (loop starts at n=0) | confirmed |
| 10 | "each frame recomputes ... over the full interval with a denser partition where $n$ remains a multiple of 4" | n_seq = 4..64 in steps of 4, then 72..120 in steps of 8, all on [0,2] | confirmed |
| 11 | "Red dots mark the sample points $x_i$" | Script lines 81-82; the frames show them | confirmed |
| 12 | "vertical red lines mark the panel boundaries $x_{4k}$" | Script lines 67-70 (i=0:4:n); frame_024 shows 31 lines for n=120 | confirmed |
| 13 | "Piecewise quartic panels are rebuilt at increasing density" | Frames 2, 3 and 24 show the quartic fills passing through the dots | confirmed |
| 14 | "the approximation increases from frame to frame" | All 23 values increase strictly (check.py) | confirmed |
| 15 | "staying below it" | All 23 values are below I (check.py) | confirmed |
| 16 | True integral ≈ 2.016280 | mpmath, after substituting x=t³ to remove the singularity: 2.0162797196170963; a split-interval quad agrees | confirmed |
| 17 | "the last frame (121 sample points) gives 2.015961" | Independent: 2.015961179. Script: 2.015961. Frame 24 annotation: 2.015961 | confirmed |
| 18 | "about $3.2\times10^{-4}$ low" | Error −3.18541e-4 | confirmed |
| 19 | $f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0, unbounded | mp.diff at x=1e-3, 1e-6, 1e-9 gives 53.03, 533.33, 5333.33, against the formula's 53.33, 533.33, 5333.33 | confirmed |
| 20 | "error shrinks like $O(h^{5/3})$ rather than $O(h^6)$" | Halving ratios 3.177, 3.179, ..., 3.182 for n up to 120, then 3.1796, 3.1774, 3.1761, 3.1755 for 120→1920 | confirmed |
| 21 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | (B60−I)/(B120−I) = 3.18196 | confirmed |
| 22 | "tending to $2^{5/3}\approx 3.17$, instead of $2^6=64$" | 2^{5/3} = 3.1748, and the ratios approach it | confirmed |
| 23 | Source link `boolesaa.jl` | The file exists and produces boolesaa.gif | confirmed |
| 24 | Embed `boolesaa.gif` is this case | Committed GIF is byte-identical to the regenerated one; title and function match | confirmed |
| 25 | Alt text: opening frame with f only, red dots, vertical red lines at panel boundaries, quartic panels, global approximation | Frames 1, 2 and 24 | confirmed |

### 3. Implementation checks: `boolesaa.jl`

**It is the method it claims to be.** `boole_sum` (lines 26-38) is the composite closed 5-point Newton-Cotes rule (Boole) with weights 2h/45·(7,32,12,32,7) over blocks [x_{4k}, x_{4k+4}]. These weights match the ones I derived independently by integrating the Lagrange basis exactly with sympy. The drawn panels are the degree-4 interpolants through the same five nodes (a Vandermonde solve). The integral of those interpolants is by construction the Boole panel value, so the shaded area and the quoted number describe the same thing.

**The numbers are right.** I ran an instrumented copy (`instr.jl`, which keeps only the function definitions and prints `boole_sum` for every n) and an independent mpmath implementation (`check.py`). They agree to all six printed decimals for all 23 frames:

| n | pts | script | independent | error |
|---|---|---|---|---|
| 4 | 5 | 1.553155 | 1.553154683 | −4.63e-1 |
| 8 | 9 | 1.963413 | 1.963412728 | −5.29e-2 |
| 12 | 13 | 2.001295 | 2.001295173 | −1.50e-2 |
| 16 | 17 | 2.007328 | 2.007327727 | −8.95e-3 |
| 20 | 21 | 2.010045 | 2.010045288 | −6.23e-3 |
| 24 | 25 | 2.011644 | 2.011644322 | −4.64e-3 |
| 28 | 29 | 2.01268 | 2.012680223 | −3.60e-3 |
| 32 | 33 | 2.013393 | 2.013392644 | −2.89e-3 |
| 36 | 37 | 2.013905 | 2.013904957 | −2.37e-3 |
| 40 | 41 | 2.014287 | 2.014286595 | −1.99e-3 |
| 44 | 45 | 2.014579 | 2.014579146 | −1.70e-3 |
| 48 | 49 | 2.014809 | 2.014808783 | −1.47e-3 |
| 52 | 53 | 2.014993 | 2.014992657 | −1.29e-3 |
| 56 | 57 | 2.015142 | 2.0151424 | −1.14e-3 |
| 60 | 61 | 2.015266 | 2.015266137 | −1.01e-3 |
| 64 | 65 | 2.01537 | 2.015369687 | −9.10e-4 |
| 72 | 73 | 2.015532 | 2.015532184 | −7.48e-4 |
| 80 | 81 | 2.015653 | 2.015652799 | −6.27e-4 |
| 88 | 89 | 2.015745 | 2.015745052 | −5.35e-4 |
| 96 | 97 | 2.015817 | 2.015817362 | −4.62e-4 |
| 104 | 105 | 2.015875 | 2.015875209 | −4.05e-4 |
| 112 | 113 | 2.015922 | 2.01592229 | −3.57e-4 |
| 120 | 121 | 2.015961 | 2.015961179 | −3.19e-4 |

Property checks: the rule has degree of precision exactly 5 (claim 4), and on the smooth e^x its error falls by about 64 per halving (claim 5). On this integrand the halving ratio tends to 2^{5/3} (claims 20-22). The approximation values shown in the frames (frames 2, 3, 6, 9, 11, 13, 15, 17, 19, 21, 23, 24 inspected) match the table. The legacy GIF shows the same values wherever the sample counts coincide (1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922).

**Its reference values are right.** The script draws no "exact" curve and quotes no reference value. The page's true integral 2.016280 is confirmed in claim 16 by two independent mpmath quadratures that agree to 30 digits.

**The picture shows what was computed.** Panel fills are built from the five node values of each block, and the vertical lines are drawn at x_{4k} up to f(x_{4k}). The dots are at x_i = a + i·dx. The title is generic ("Boole's Rule / Numerical Quadrature"), and the annotations report n+1 sample points and the rounded `boole_sum(n)`. Axis limits are y∈[0, 2.1] and x∈[−0.03, 2.03]. Over [0,2], f ranges over [0.357, 1.920], and the quartic interpolants range over [0.124, 1.380] at n=4, [0.317, 1.758] at n=12 and [0.357, 1.920] at n=120 (`range.py`). Nothing is clipped, and the deep dip of the n=4 quartic to 0.124 near x≈0.28 is visible in frame 2, as it is in Mathews' frame. The annotation block at x≈1.15, y≈1.74-1.88 sits above the curve there (f(1.15)≈1.2), so nothing is hidden. Frame count: 1 opening frame + 23 refinements = 24, which matches the manifest.

**Legacy fidelity.** Mathews uses the same function, interval, rule and end point (121 sample points), and his approximation values agree to six decimals at every shared sample count. Only the intermediate sample counts differ (see the observations above), which is not a finding.

