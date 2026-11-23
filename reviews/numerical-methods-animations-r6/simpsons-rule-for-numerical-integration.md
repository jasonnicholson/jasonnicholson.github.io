# Simpson's Rule for Numerical Integration — animation review (round 6)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every value drawn in the GIF agrees with an independent computation.

Observation, not a finding (cosmetic, not misleading): the frame annotation uses `round(approx; digits=6)` and Julia drops trailing zeros, so four frames show fewer than six decimals: n=6 "1.84056", n=24 "2.01037", n=40 "2.01389", n=72 "2.0154". All are correct values (1.840560, 2.010370, 2.013890, 2.015400). If uniform display is wanted, use `@sprintf("%.6f", approx)` (the legacy GIF shows "1.840560", "2.013890").



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 8.4 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpsonsaa.gif` | 24 | byte-identical | simpsonsaa |

### Page references

- Scripts linked: `simpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Composite Simpson's rule approximates ∫_a^b f by fitting a quadratic interpolant across each pair of subintervals" | Script fits a quadratic through (x_{2k},x_{2k+1},x_{2k+2}); instr.jl: exact area of drawn quadratics equals `simpson_sum` to ≤4e-15 for every n | confirmed |
| D2 | h=(b−a)/n, even n, S_n = h/3[f(x0)+f(xn)+4Σ_{k=1}^{n/2} f(x_{2k−1})+2Σ_{k=1}^{n/2−1} f(x_{2k})] | Formula correct (checked against degree-of-precision test below); script `simpson_sum` implements exactly this (odd i weight 4, even interior weight 2) | confirmed |
| D3 | "the method integrates cubics exactly" | indep.py, n=4 on [0,2]: error for x^0..x^3 = 0; x^4 error 0.016667, x^5 0.083333 | confirmed |
| D4 | composite error for smooth f (C^4) is O(h^4) | Follows from D3 / standard remainder −(b−a)h^4 f^(4)(ξ)/180 | confirmed |
| A1 | "shows the Simpson's rule diagram over [0,2] for y=e^{−x}sin(8x^{2/3})+1" | Script line 8–9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2` | confirmed |
| A2 | "After an opening frame showing only f" | frame_001: only magenta f, no annotations; code `vcat(0,n_seq)` with `n>0` guards | confirmed |
| A3 | "each frame redraws the entire interval using a denser even partition" | n_seq = 2,4,…,20,24,…,48,56,64,72,84,96,108: all even, strictly increasing; panels span 0..2 each frame | confirmed |
| A4 | "Red dots mark the sample points x_i" | Lines 70–74 scatter x_i=a+i·dx, i=0..n, red; frames show n+1 dots | confirmed |
| A5 | "vertical red lines mark the panel boundaries x_{2k}" | Lines 58–61 draw lines at i=0:2:n from 0 to f(x_i); frame_002 (n=2) has lines at 0 and 2 only, frame n=4 adds x=1 | confirmed |
| A6 | "Julia source scripts … are linked under each case" | `[Julia source](simpsonsaa.jl)` exists in folder | confirmed |
| C1 | Case heading: Composite Simpson's Rule, f(x)=e^{−x}sin(8x^{2/3})+1 on [0,2] | Same as A1 | confirmed |
| C2 | "Quadratic panels are rebuilt over the full interval as sample density increases" | Same as A3; frames viewed (1,2,24 and contact sheet) | confirmed |
| C3 | "converges toward the true integral" | Errors (I−S): n=2 −0.475, n=4 +0.404, then positive and decreasing every frame to 4.455e−4 at n=108 | confirmed (convergence is not monotone at n=2→4; page does not claim monotone) |
| C4 | ∫_0^2 f ≈ 2.016280 | mpmath (dps 40), two ways: substitution x=t^3 and direct split quad: 2.01627971961709633 | confirmed |
| C5 | "the last frame (109 sample points)" | last n=108 → 109 points; frame_024 reads "Sample Points = 109" | confirmed |
| C6 | last frame "gives 2.015834" | script 2.015834215997174; indep 2.015834216; frame_024 reads 2.015834 | confirmed |
| C7 | "about 0.00045 low" | I−S_108 = 4.45504e−4 (positive ⇒ approximation low) | confirmed |
| C8 | "f' unbounded at x=0 (f'(x)≈16/3 x^{−1/3} near 0)" | mpmath f'(x)/(16/3 x^{−1/3}) = 0.9999972 at 1e−6, 1.0000000 at 1e−9 | confirmed |
| C9 | "textbook error order … does not hold for this integrand"; "error shrinks like O(h^{5/3}) rather than O(h^4)" | Halving ratios tend to 2^{5/3}: see C11 | confirmed |
| C10 | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | e(24)/e(48) = 0.00591009/0.00174838 = 3.38032 | confirmed |
| C11 | "tending to 2^{5/3}≈3.17, instead of 16" | ratios 48→96 3.2214, 96→192 3.1887, 384→768 3.1772, 6144→12288 3.1749; 2^{5/3}=3.1748 | confirmed |
| I1 | Alt text: opening frame only f; sample points red dots; panel boundaries vertical red lines; piecewise quadratic panels; global approximation | frames 1, 2, 24 and contact sheet; annotation "Approximation = …" is the composite S_n | confirmed |
| W1 | Embed `simpsonsaa.gif` is this case | Committed GIF md5 4a1d9d52… identical to regen of unchanged script; manifest: byte-identical, 24 frames | confirmed |
| W2 | Page linked from section index | `pages/numerical-methods/index.qmd` line 101 | confirmed |
| F1 | (in frames) every "Approximation = …" annotation | All 23 values from instr.jl equal indep.py to ≥9 digits (table below); GIF is byte-identical to the run that printed them | confirmed |
| F2 | (in frames) "Sample Points = n+1" | Code `$(n + 1)`; matches dot count in frames viewed | confirmed |

### 3. Implementation checks — `simpsonsaa.jl`

**Is the method claimed.** `simpson_sum(n)` is the standard composite Simpson 1/3 rule (weights 1,4,2,4,…,2,4,1 times h/3). The drawn panels are the actual quadratic interpolants of each pair of subintervals (Vandermonde solve, interpolation residual ≤ 2.6e−15 at the nodes), and their exact area equals `simpson_sum(n)` to ≤ 4e−15 for every n, so the shaded area is the quantity reported.

**Numbers.** Script (instr.jl) vs independent mpmath composite Simpson (indep.py); error = I − S with I = 2.0162797196170963:

| n | pts | script S_n | indep S_n | error |
|---|---|---|---|---|
| 2 | 3 | 2.4912610173 | 2.491261017 | −0.474981 |
| 4 | 5 | 1.6117863286 | 1.611786329 | 0.404493 |
| 6 | 7 | 1.8405602096 | 1.84056021 | 0.17572 |
| 8 | 9 | 1.9414360777 | 1.941436078 | 0.0748436 |
| 10 | 11 | 1.9763885058 | 1.976388506 | 0.0398912 |
| 12 | 13 | 1.9912492375 | 1.991249238 | 0.0250305 |
| 14 | 15 | 1.9988141398 | 1.99881414 | 0.0174656 |
| 16 | 17 | 2.0032094989 | 2.003209499 | 0.0130702 |
| 18 | 19 | 2.0060181747 | 2.006018175 | 0.0102615 |
| 20 | 21 | 2.0079417387 | 2.007941739 | 0.00833798 |
| 24 | 25 | 2.0103696294 | 2.010369629 | 0.00591009 |
| 28 | 29 | 2.0118135929 | 2.011813593 | 0.00446613 |
| 32 | 33 | 2.0127561972 | 2.012756197 | 0.00352352 |
| 36 | 37 | 2.0134120331 | 2.013412033 | 0.00286769 |
| 40 | 41 | 2.0138900411 | 2.013890041 | 0.00238968 |
| 44 | 45 | 2.0142510088 | 2.014251009 | 0.00202871 |
| 48 | 49 | 2.0145313361 | 2.014531336 | 0.00174838 |
| 56 | 57 | 2.0149343498 | 2.01493435 | 0.00134537 |
| 64 | 65 | 2.0152063435 | 2.015206343 | 0.00107338 |
| 72 | 73 | 2.0153996742 | 2.015399674 | 0.000880045 |
| 84 | 85 | 2.0156006459 | 2.015600646 | 0.000679074 |
| 96 | 97 | 2.0157369856 | 2.015736986 | 0.000542734 |
| 108 | 109 | 2.0158342160 | 2.015834216 | 0.000445504 |

Property checks independent of remembered formulas: degree of precision exactly 3 (x^0..x^3 exact, x^4 not); halving-ratio of the error tends to 3.1749 ≈ 2^{5/3} (expected for an x^{2/3} endpoint singularity, Simpson error ~ h^{1+2/3}), not 16.

**Reference values.** The page's "true integral" 2.016280 was verified by two independent mpmath quadratures (singularity removed by x=t^3, and direct subdivided quad), agreeing to 20 digits: 2.0162797196170963279. The script itself draws no reference value.

**Picture.** Frames 1, 2, 24 and the 12-frame contact sheet viewed against the code: opening frame is f only; each later frame shows quadratic panels (pink fill, red outline) through the correct three nodes, vertical lines at x_{2k} of height f(x_{2k}), red dots at all x_i, magenta f on top of panels and dots on top. Title "Simpson's Rule / Numerical Quadrature" (no function or index to mislabel). Axis limits x∈[−0.03,2.03], y∈[0,2.1]: clip.jl shows all panel values lie in [0.349, 1.976] and f in [0.357, 1.920], so nothing is clipped; the annotations at (1.15, 1.88/1.74) sit above the curve (f(1.15)=1.19) and above every panel. Frame count 24 = 1 opening + 23 partitions. GIF regenerated byte-identically.

### Legacy fidelity

Mathews' `Simpsonaa.gif` (24 frames) uses the same function y=e^{−x}sin(8x^{2/3})+1 on [0,2], the same drawing (pink parabolic panels, red dots, red panel dividers, "Sample Points"/"Approximation" text), with n = 2,4,…,40 (3 to 41 sample points). Its displayed values match this script's at the same n (e.g. n=2 2.491261, n=6 1.840560, n=10 1.976389, n=14 1.998814, n=18 2.006018, n=40 2.013890). The new page extends refinement to n=108 and adds a correct convergence-rate discussion; the legacy function label drawn inside the plot is not reproduced but the page text states the function. The module's numbered Examples 1–6 are worked text examples with other integrands, not animations; their absence falls under "content the page does not yet have". No fidelity finding.

