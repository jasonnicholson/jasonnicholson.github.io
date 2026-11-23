# Boole's Rule — animation review (round 6)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. The script implements composite Boole's rule correctly. Its reference value and quoted error figures are right to the precision given, and the drawing shows what was computed.

Items I looked at and decided were not findings:
- The annotation for n=64 reads `Approximation = 2.01537`. `round(...; digits=6)` drops the trailing zero of 2.015370, which is still the correct value. This is cosmetic.
- Mathews' GIF has three opening frames showing only f, shows the 5-point frame twice, and uses 20 distinct n values. The page's GIF has one opening frame and 23 n values (it adds n=40/44/52/56/60). The legacy frames also print the formula of f on the plot. The page makes no claim about the legacy frame sequence. The function, the interval, the 5-to-121 point range and the approximations at every shared n are the same: 1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922 and 2.015961 appear in both. So this is not a Fidelity finding.
- The intro says "Each animation below" although there is only one animation. That is wording, not a factual error.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 7.5 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Where | Evidence | Verdict |
|---|---|---|---|---|
| 1 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | Description | Script fits a degree-4 polynomial through 5 nodes per block (`poly_coeffs`, 5×5 Vandermonde). The integral of that interpolant equals the Boole panel sum to 1.3e-14 (inst.jl) | confirmed |
| 2 | $h=(b-a)/n$, $n$ divisible by 4, $B_n=\frac{2h}{45}\sum(7,32,12,32,7)$ | Description | sympy moment equations on nodes 0..4 give weights 14/45, 64/45, 8/15, 64/45, 14/45 = (2/45)(7,32,12,32,7). Script line 35 uses the same formula, and every n in `n_seq` is a multiple of 4 | confirmed |
| 3 | "exact for polynomials up to degree 5" | Description | sympy: exact for x^0..x^5, not x^6, x^7. Script's formula on [0,2], n=8: error 0 (≤4.4e-16) for k=0..5, 7.44e-4 for k=6 | confirmed |
| 4 | "for smooth f (six times continuously differentiable …) has global error O(h^6)" | Description | f=e^x on [0,2]: error ratios on halving h are 62.46, 63.61, 63.90, 63.98, tending to 64 | confirmed |
| 5 | "highest-order closed Newton-Cotes rule in this set" | Description | The section index lists trapezoidal (O(h^2)), Simpson 1/3 (O(h^4)), Simpson 3/8 (O(h^4)) and Boole (O(h^6)) as the closed Newton-Cotes rules | confirmed |
| 6 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | intro, heading | Script line 8 `exp(-x)*sin(8*x^(2/3))+1`, line 9 `a,b=0,2`. Same as Mathews' frame label | confirmed |
| 7 | "After an opening frame showing only f" | intro, alt | frame_001 shows only the magenta curve. Loop starts at `n=0`. All 24 frame hashes are distinct, so there is exactly one opening frame | confirmed |
| 8 | "each frame recomputes the approximation over the full interval with a denser partition where n remains a multiple of 4" | intro | n_seq = 4,8,…,64,72,…,120 is strictly increasing, all multiples of 4. `boole_sum(n)` covers [0,2] each frame | confirmed |
| 9 | "Red dots mark the sample points x_i" | intro, alt | Lines 81-82 scatter `a+i*dx`, i=0..n, in red. Frames 2 and 24 show 5 and 121 dots | confirmed |
| 10 | "vertical red lines mark the panel boundaries x_{4k}" | intro, alt | Lines 67-69 draw lines at i=0:4:n. Frames: n=8 has a line at 1.0, n=24 at multiples of 1/3, n=32 at multiples of 0.25 | confirmed |
| 11 | "Piecewise quartic panels are rebuilt at increasing density" | Behavior | Frames 2→24. The interpolant passes through its nodes (max residual 5.5e-14) | confirmed |
| 12 | "the approximation increases from frame to frame toward the true integral" | Behavior | All 22 successive differences are positive (indep.py "incr" on every row) | confirmed |
| 13 | "$\int_0^2 f\,dx \approx 2.016280$" | Behavior | mpmath, 30 digits, with substitution x=t^3 to remove the endpoint singularity: 2.0162797196170963. A direct split quad agrees to all digits | confirmed |
| 14 | "staying below it" | Behavior | I − B_n > 0 for all 23 n (0.463 down to 3.19e-4) | confirmed |
| 15 | "the last frame (121 sample points) gives 2.015961" | Behavior | Script prints 2.0159611788705827. Independent value 2.01596117887. frame_024 shows 121 / 2.015961 | confirmed |
| 16 | "about 3.2×10^-4 low" | Behavior | I − B_120 = 3.18541e-4 | confirmed |
| 17 | "$f'$ unbounded at x=0 ($f'(x)\approx\frac{16}{3}x^{-1/3}$)" | Behavior | Ratio f'(x)/(16/3 x^{-1/3}) = 0.9943, 0.999997 and 0.9999999975 at x=1e-3, 1e-6, 1e-9 | confirmed |
| 18 | "error shrinks like O(h^{5/3}) rather than O(h^6)" | Behavior | Ratios for n→2n: 3.1820 (60→120), 3.1796, 3.1774, 3.1761, 3.1755, 3.1751 (1920→3840) | confirmed |
| 19 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | Behavior | 1.013585e-3 / 3.18541e-4 = 3.18196. Both n=60 and n=120 are frames of the GIF | confirmed |
| 20 | "tending to 2^{5/3}≈3.17 … instead of 2^6=64" | Behavior | 2^{5/3}=3.174802. The ratios decrease monotonically toward it (row 18) | confirmed |
| 21 | Alt text: "…each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | alt | Frames 2-24 show all four elements. The "global approximation" is the annotated number | confirmed |
| 22 | Link `[Julia source](boolesaa.jl)` and embed `boolesaa.gif` belong to this case | wiring | Script writes `joinpath(@__DIR__,"boolesaa.gif")`. The regenerated GIF is byte-identical to the committed one (md5 9d760f8c…) | confirmed |
| 23 | Annotations per frame ("Sample Points = n+1", "Approximation = …") | frames | Every value visible in the contact sheet and in frames 2 and 24 matches `round(boole_sum(n),6)` from inst.jl and the independent values from indep.py (table in §3) | confirmed |

### 3. Implementation checks — `boolesaa.jl`

**It is the method it claims to be.** `boole_sum` (lines 26-38) is the textbook composite closed 5-point Newton-Cotes (Boole) rule, applied over non-overlapping blocks i=0,4,…,n−4. I did not rely on memory for the weights. I derived them by solving the moment equations in sympy (indep.py): the result is (2h/45)(7,32,12,32,7). I also confirmed the degree of precision of the script's own formula: exact through x^5, not x^6.

**The numbers are right.** Script (inst.jl, Float64) against the independent mpmath computation (indep.py, 30 digits):

| n | points | script `boole_sum` | independent | I − B_n |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827403782 | 1.55315468274 | 0.463125 |
| 8 | 9 | 1.9634127276098594 | 1.96341272761 | 0.052867 |
| 12 | 13 | 2.0012951727392143 | 2.00129517274 | 0.0149845 |
| 16 | 17 | 2.0073277270307845 | 2.00732772703 | 0.00895199 |
| 20 | 21 | 2.0100452875239125 | 2.01004528752 | 0.00623443 |
| 24 | 25 | 2.011644322158631 | 2.01164432216 | 0.0046354 |
| 28 | 29 | 2.0126802231404017 | 2.01268022314 | 0.0035995 |
| 32 | 33 | 2.0133926437323075 | 2.01339264373 | 0.00288708 |
| 36 | 37 | 2.0139049569845215 | 2.01390495698 | 0.00237476 |
| 40 | 41 | 2.0142865946332567 | 2.01428659463 | 0.00199312 |
| 44 | 45 | 2.0145791464395617 | 2.01457914644 | 0.00170057 |
| 48 | 49 | 2.0148087832454062 | 2.01480878325 | 0.00147094 |
| 52 | 53 | 2.0149926568950725 | 2.0149926569 | 0.00128706 |
| 56 | 57 | 2.015142400213204 | 2.01514240021 | 0.00113732 |
| 60 | 61 | 2.0152661371926204 | 2.01526613719 | 0.00101358 |
| 64 | 65 | 2.0153696865415838 | 2.01536968654 | 0.000910033 |
| 72 | 73 | 2.0155321836059485 | 2.01553218361 | 0.000747536 |
| 80 | 81 | 2.0156527992888287 | 2.01565279929 | 0.00062692 |
| 88 | 89 | 2.0157450522467233 | 2.01574505225 | 0.000534667 |
| 96 | 97 | 2.0158173622426188 | 2.01581736224 | 0.000462357 |
| 104 | 105 | 2.015875208647758 | 2.01587520865 | 0.000404511 |
| 112 | 113 | 2.0159222895927464 | 2.01592228959 | 0.00035743 |
| 120 | 121 | 2.0159611788705827 | 2.01596117887 | 0.000318541 |

Commands: `julia inst.jl` and `/usr/bin/python3 -I indep.py`, both in the review folder.

**Reference values are right.** The page's true integral 2.016280 is checked against I = 2.01627971961709632788727442192 (mpmath quad of f(t^3)·3t^2 on [0, 2^{1/3}], which has a smooth integrand; a direct 19-piece quad of f agrees to all 30 digits). The script draws no reference curve. Its only "reference" is f itself, plotted in magenta on 800 points.

**The picture shows what was computed.**
- Each pink region is the fill under the degree-4 interpolant of the block's five nodes. Max node residual is 5.5e-14 and |∫interpolant − Boole panel| ≤ 1.3e-14, so the shaded area equals the annotated B_n.
- Over all frames the interpolants range from 0.124 (n=4) to 1.93, and f ranges over [0.357, 1.920]. Both lie inside ylims (0, 2.1), so nothing is clipped. xlims (−0.03, 2.03) shows both end nodes.
- Block dividers sit at x_{4k} (checked visually at n=8, 24, 32 and in the final frame), and dots sit at every x_i.
- The title "Boole's Rule / Numerical Quadrature" is accurate. The annotations report n+1 sample points and B_n rounded to 6 decimals, matching the table above.
- The committed GIF has 24 frames, all distinct, and is byte-identical to the scratch regeneration (manifest; md5 checked).
- No clamping, NaN masking or other display device is used.

