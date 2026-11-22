# Boole's Rule — animation review (round 4)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by independent computation and by the frames; the implementation is composite Boole's rule, its numbers are right, its reference value is right, and the picture is built from the right quantities.

Not raised as findings (noted for completeness only):
- The annotation uses `round(approx; digits=6)` so values with a trailing zero print with five decimals (n=28 shows `2.01268`, n=64 shows `2.01537`; true 2.0126802, 2.0153697). Values are correct; purely cosmetic.
- "the highest-order closed Newton-Cotes rule in this set": "this set" is not defined on this page, but it is true for the section's closed Newton-Cotes pages (trapezoidal, Simpson 1/3, Simpson 3/8, Boole; see `newton-cotes-integration/index.qmd` line 13).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 9.4 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | Script lines 48-63 build a degree-4 interpolant through 5 nodes per block; `instr.jl` shows node residuals <= 5.5e-14 and integral of the drawn quartics equals `boole_sum(n)` to <= 1.5e-14 for all 23 n | confirmed |
| D2 | $h=(b-a)/n$, $n$ divisible by 4, $B_n=\frac{2h}{45}\sum(7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4})$ | Matches script line 35 exactly; formula verified by degree-of-precision test (D3) and by matching integral of the interpolants (D1) | confirmed |
| D3 | "exact for polynomials up to degree 5" | `instr.jl` on [0,2]: errors for x^0..x^5 <= 1.8e-15 (n=4 and 8); x^6 error 0.0476 (n=4), x^7 0.333 — degree of precision exactly 5 | confirmed |
| D4 | "for smooth f (six times continuously differentiable) has global error O(h^6)" | `instr.jl` on exp over [0,1]: error ratios on halving 62.46, 63.61, 63.89, 63.80 (-> 64) | confirmed |
| D5 | "highest-order closed Newton-Cotes rule in this set" | Section's closed N-C pages: trapezoid O(h^2), Simpson O(h^4), 3/8 O(h^4), Boole O(h^6) | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ (intro and Case 1 heading) | Script lines 8-9 | confirmed |
| A2 | "After an opening frame showing only f" | `vcat(0, n_seq)`; frame_001 shows only the magenta f; frames 2-24 distinct (frames.md5) | confirmed |
| A3 | "each frame recomputes the approximation over the full interval with a denser partition where n remains a multiple of 4" | n_seq = 4,8,...,64,72,...,120 all multiples of 4, strictly increasing; `boole_sum` spans [a,b] | confirmed |
| A4 | "Red dots mark the sample points x_i" | Script lines 81-82 scatter at a+i*dx, i=0..n; frames 2 and 24 show n+1 red dots | confirmed |
| A5 | "vertical red lines mark the panel boundaries x_{4k}" | Script lines 67-70 draw lines at i=0:4:n; frame_002 shows lines at 0 and 2 only (n=4), frame_024 31 lines (n=120) | confirmed |
| A6 | "Julia source scripts ... are linked under each case" / link `boolesaa.jl` | File exists; it is the script that produced the GIF (regen byte-identical, md5 9d760f8c...) | confirmed |
| C1 | "Piecewise quartic panels are rebuilt at increasing density" | Frames 2..24 | confirmed |
| C2 | "the approximation increases from frame to frame toward the true integral" | Independent values (below) strictly increase for all 23 n | confirmed |
| C3 | "staying below it" | All 23 errors I-B_n positive (0.463 down to 3.19e-4) | confirmed |
| C4 | "true integral $\int_0^2 f\,dx \approx 2.016280$" | mpmath (substitution x=t^3 and split-interval quad agree to 40 digits): 2.0162797196170963 | confirmed |
| C5 | "the last frame (121 sample points) gives 2.015961" | Independent B_120 = 2.015961179; frame_024 shows "Sample Points = 121", "Approximation = 2.015961" | confirmed |
| C6 | "about 3.2e-4 low" | I - B_120 = 3.18541e-4 | confirmed |
| C7 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | mpmath: f'(x)/(16/3 x^{-1/3}) = 0.99431, 0.9999972, 0.9999999975 at x=1e-3,1e-6,1e-9 | confirmed |
| C8 | "the measured error shrinks like O(h^{5/3}) rather than O(h^6)" | Halving ratios (n -> 2n): 8.76, 5.91, 3.10, 3.173, 3.182, 3.179, 3.177, 3.176, 3.1754, 3.1751 (n=4..2048) -> 2^{5/3} | confirmed |
| C9 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | (I-B_60)/(I-B_120) = 3.18196 | confirmed |
| C10 | "tending to $2^{5/3}\approx3.17$, instead of $2^6=64$" | 2^{5/3}=3.1748; ratios converge to it (C8) | confirmed |
| W1 | Alt text: "over [0,2] with full-interval density refinement: after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | Frames 1, 2, 24 and sheet; approximation annotation present on frames 2-24 | confirmed |
| W2 | Embed `boolesaa.gif` is this case | Only GIF; produced by `boolesaa.jl` with the heading's f and interval | confirmed |
| W3 | Counts: one case, one script, one GIF; frames = 1 opening + 23 refinements = 24 | manifest, frames.md5 | confirmed |

### 3. Implementation checks — `boolesaa.jl`

**Method it claims to be.** `boole_sum` (lines 26-38) is the standard composite closed Boole rule with weights (2h/45)(7,32,12,32,7) over blocks i=0:4:n-4. Degree-of-precision test gives exactly 5 (x^5 exact, x^6 not), and on a smooth integrand (exp on [0,1]) the error ratio on halving h is ~64, i.e. O(h^6). Not a neighbouring rule.

**Numbers.** Script values (from `instr.jl`, same code) vs independent mpmath (`indep.py`, 40 digits):

| n | pts | script | independent | I - B_n |
|---|---|---|---|---|
| 4 | 5 | 1.5531546827 | 1.553154683 | 4.631e-1 |
| 8 | 9 | 1.9634127276 | 1.963412728 | 5.287e-2 |
| 12 | 13 | 2.0012951727 | 2.001295173 | 1.498e-2 |
| 16 | 17 | 2.0073277270 | 2.007327727 | 8.952e-3 |
| 20 | 21 | 2.0100452875 | 2.010045288 | 6.234e-3 |
| 24 | 25 | 2.0116443222 | 2.011644322 | 4.635e-3 |
| 28 | 29 | 2.0126802231 | 2.012680223 | 3.600e-3 |
| 32 | 33 | 2.0133926437 | 2.013392644 | 2.887e-3 |
| 36 | 37 | 2.0139049570 | 2.013904957 | 2.375e-3 |
| 40 | 41 | 2.0142865946 | 2.014286595 | 1.993e-3 |
| 44 | 45 | 2.0145791464 | 2.014579146 | 1.701e-3 |
| 48 | 49 | 2.0148087832 | 2.014808783 | 1.471e-3 |
| 52 | 53 | 2.0149926569 | 2.014992657 | 1.287e-3 |
| 56 | 57 | 2.0151424002 | 2.015142400 | 1.137e-3 |
| 60 | 61 | 2.0152661372 | 2.015266137 | 1.014e-3 |
| 64 | 65 | 2.0153696865 | 2.015369687 | 9.100e-4 |
| 72 | 73 | 2.0155321836 | 2.015532184 | 7.475e-4 |
| 80 | 81 | 2.0156527993 | 2.015652799 | 6.269e-4 |
| 88 | 89 | 2.0157450522 | 2.015745052 | 5.347e-4 |
| 96 | 97 | 2.0158173622 | 2.015817362 | 4.624e-4 |
| 104 | 105 | 2.0158752086 | 2.015875209 | 4.045e-4 |
| 112 | 113 | 2.0159222896 | 2.015922290 | 3.574e-4 |
| 120 | 121 | 2.0159611789 | 2.015961179 | 3.185e-4 |

Agreement to all printed digits. Legacy Mathews GIF values at shared point counts (1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922, 2.015961) also match.

**Reference values.** The script draws no "exact" reference; the page's true integral 2.016280 was checked independently (2.01627971961709633, two independent mpmath quadratures agreeing to 40 digits, one after the substitution x=t^3 that removes the x^{2/3} singularity).

**Picture.** Viewed frames 1, 2, 24, the 12-frame contact sheet, and the legacy frames. Each pink region is the quartic interpolating the 5 block nodes (node residual <= 5.5e-14), and its area summed over blocks equals the annotated Boole value (difference <= 1.5e-14), so the shaded area is the quantity reported. Divider lines are at x_{4k} and end at f(x_{4k}) where the quartics meet f. Sample-point dots are at all x_i. "Sample Points = n+1" is correct. No clamping or masking; all quartics lie inside ylims (0, 2.1) (lowest dip ~0.12 at n=4, highest overshoot ~1.6 at n=8 visible in frames). Regenerated GIF is byte-identical to the committed one, and the scratch script is identical to the repo script.

**Fidelity to legacy.** Mathews' animation (`Booleaa.gif`, 24 frames: 3 identical opening frames, then point counts 5 ... 121) uses the same function, interval, panel dividers and dot convention; its values match. The page's frame sequence adds n=72, 88, 104 and uses one opening frame; the legacy GIF labels the function in-frame, the page states it in text. No departure that matters to a reader; no archive animation dropped (the archive has a single Boole animation).

