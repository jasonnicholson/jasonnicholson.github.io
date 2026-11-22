# Simpson's Rule for Numerical Integration — animation review (round 3)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding on this page.

Items I looked at and decided not to raise (recorded so the owner knows they were considered):
- The introduction says "Each animation below shows ..." although the page has only one animation. The sentence is not false and nothing on the page depends on it. It is wording, not a finding.
- In the n = 72 frame the annotation reads `Approximation = 2.0154` rather than `2.015400`. `round(approx; digits=6)` gives 2.0154 and Julia drops the trailing zeros. The value is correct to the six digits shown (2.01539967 rounds to 2.015400). This is cosmetic only.
- The legacy GIF runs n = 2, 4, ..., 40 (3 to 41 sample points). The new GIF continues to n = 108 with larger jumps. It uses the same function, the same interval and the same rule, and its overlapping values match (see below). The departure does not change what a reader learns, so it is not a Fidelity finding.



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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Composite Simpson's rule approximates the integral "by fitting a quadratic interpolant across each pair of subintervals" | The script fits a degree-2 Vandermonde interpolant through (x_{2k}, x_{2k+1}, x_{2k+2}). The residual at the nodes is ≤ 2.6e-15 for every n. The exact area under the drawn panels equals `simpson_sum(n)` to ≤ 2.7e-15 for every n (`instr.jl`) | confirmed |
| D2 | Description | h = (b−a)/n, n even | Script `dx = (b-a)/n`. Every n in `n_seq` is even | confirmed |
| D3 | Description | S_n = h/3 [f(x0)+f(xn) + 4 Σ_{k=1}^{n/2} f(x_{2k−1}) + 2 Σ_{k=1}^{n/2−1} f(x_{2k})] | The formula is correct. The script uses odd i = 1:2:n−1 with weight 4 and even i = 2:2:n−2 with weight 2, which is the same formula. The script's values agree with an independent mpmath implementation to all printed digits for all 23 n | confirmed |
| D4 | Description | "the method integrates cubics exactly" | The script's formula with f = x^p, n = 4 on [0,2] gives errors 0, 0, 0, 0 for p = 0..3, 0.016667 for p = 4 and 0.083333 for p = 5 (`instr.jl`) | confirmed |
| D5 | Description | composite error O(h^4) for f ∈ C^4[a,b], typically much smaller than trapezoidal error | This is the standard result and is consistent with degree of precision 3. Stated as theory | confirmed |
| A1 | Intro | Diagram over [0,2] for y = e^{−x} sin(8x^{2/3}) + 1 | Script lines 8–9: `f(x) = exp(-x)*sin(8*x^(2/3)) + 1`, `a, b = 0.0, 2.0` | confirmed |
| A2 | Intro | "After an opening frame showing only f" | `vcat(0, n_seq)`: for n = 0 only the magenta curve is drawn. Frame 1 shows only the curve | confirmed |
| A3 | Intro | "each frame redraws the entire interval using a denser even partition" | `n_seq` = 2, 4, …, 20, 24, …, 48, 56, 64, 72, 84, 96, 108 is strictly increasing and all even. Each frame draws panels over all of [0,2] (frames 2–24) | confirmed |
| A4 | Intro | "Red dots mark the sample points x_i" | Script lines 72–73 draw `scatter!` at x_i = a + i·dx, i = 0..n, in red. The frames show n+1 red dots | confirmed |
| A5 | Intro | "vertical red lines mark the panel boundaries x_{2k}" | Script lines 58–61 draw lines at i = 0:2:n from 0 to f(x_i). The frames show lines only at every other dot (for example, the n = 4 frame has lines at 0, 1 and 2) | confirmed |
| A6 | Intro | "Each animation below ..." (plural) | There is one animation. The wording is harmless | confirmed (wording note only) |
| C1 | Case heading | Composite Simpson's Rule, f = e^{−x} sin(8x^{2/3}) + 1 on [0,2] | Same as A1 and D3 | confirmed |
| C2 | Behavior | "Quadratic panels are rebuilt over the full interval as sample density increases" | Same as A3 | confirmed |
| C3 | Behavior | "the approximation converges toward the true integral" | The errors S_n − I are +0.475 (n=2), −0.404 (4), −0.176 (6), …, −0.00054 (96), −0.000446 (108). They are monotone toward 0 from n = 4 on | confirmed |
| C4 | Behavior | ∫_0^2 f dx ≈ 2.016280 | mpmath after the substitution x = t³ gives 2.0162797196170963…, and a split-interval tanh-sinh quadrature gives the same value. 2.016280 is correct to 6 decimals | confirmed |
| C5 | Behavior | "the last frame (109 sample points)" | The last n is 108, so there are 109 points. The frame 24 annotation reads "Sample Points = 109" | confirmed |
| C6 | Behavior | last frame "gives 2.015834" | Script 2.015834215997…, independent 2.015834216. Frame 24 shows 2.015834 | confirmed |
| C7 | Behavior | "about 0.00045 low" | S_108 − I = −0.000445504 | confirmed |
| C8 | Behavior | x^{2/3} makes f′ unbounded at 0, f′(x) ≈ (16/3) x^{−1/3} near 0 | Analytically f′ = −e^{−x}sin(8x^{2/3}) + e^{−x}cos(8x^{2/3})·(16/3)x^{−1/3}. Numerically f′(1e−9)·(1e−9)^{1/3} = 5.33333332 vs 16/3 = 5.3333333 | confirmed |
| C9 | Behavior | the textbook order does not hold. The error shrinks like O(h^{5/3}) rather than O(h^4) | Error ratios on halving: 12→24: 4.235, 24→48: 3.380, 48→96: 3.221, 96→192: 3.189, 192→384: 3.180, …, 6144→12288: 3.1749. This tends to 2^{5/3} = 3.1748, consistent with the h^{1+2/3} endpoint-singularity term | confirmed |
| C10 | Behavior | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | Error ratio 0.00591009 / 0.00174838 = 3.3803 | confirmed |
| C11 | Behavior | "tending to 2^{5/3} ≈ 3.17, instead of 16" | 2^{5/3} = 3.1748, so 3.17 is correct to its stated precision. 16 = 2^4 is right for an O(h^4) method | confirmed |
| W1 | Link | `[Julia source](simpsonsaa.jl)` | The file exists and is the script that produces the embedded GIF (manifest: regenerated byte-identical) | confirmed |
| W2 | Embed | `![...](simpsonsaa.gif)` | The file exists and has 24 frames: 1 opening frame + 23 values of n | confirmed |
| W3 | Alt text | "Simpson's Rule animation over [0,2] with full-interval density refinement" | Same as A3 | confirmed |
| W4 | Alt text | "after an opening frame showing only f" | Same as A2 | confirmed |
| W5 | Alt text | "sample points as red dots, the panel boundaries as vertical red lines" | Same as A4 and A5 | confirmed |
| W6 | Alt text | "the piecewise quadratic panels and the global approximation" | Pink-filled quadratic panels with red outline. The annotation "Approximation = S_n" is the composite value over the whole interval | confirmed |

### 3. Implementation checks: `simpsonsaa.jl`

**Is it the method it claims to be?** Yes. `simpson_sum(n)` is the standard composite Simpson 1/3 rule with endpoint weight 1, odd-node weight 4 and interior-even-node weight 2, times h/3. The drawn geometry is the true Simpson interpolant: one quadratic through three consecutive equally spaced nodes per panel. The exact integral of the drawn panels equals `simpson_sum(n)` to rounding (max |diff| 2.7e-15 over all n), so the picture and the number describe the same object. There is no variant issue.

**Are the numbers right?** Yes. The script's `simpson_sum` (from `instr.jl`), the independent mpmath sum (from `indep.py`) and the annotation in the frames agree:

| n | points | script | independent | frame |
|---|---|---|---|---|
| 2 | 3 | 2.491261 | 2.491261017 | 2.491261 |
| 4 | 5 | 1.611786 | 1.611786329 | 1.611786 |
| 8 | 9 | 1.941436 | 1.941436078 | 1.941436 |
| 12 | 13 | 1.991249 | 1.991249238 | 1.991249 |
| 16 | 17 | 2.003209 | 2.003209499 | 2.003209 |
| 20 | 21 | 2.007942 | 2.007941739 | 2.007942 |
| 28 | 29 | 2.011814 | 2.011813593 | 2.011814 |
| 36 | 37 | 2.013412 | 2.013412033 | 2.013412 |
| 44 | 45 | 2.014251 | 2.014251009 | 2.014251 |
| 56 | 57 | 2.014934 | 2.014934350 | 2.014934 |
| 72 | 73 | 2.0154 | 2.015399674 | 2.0154 |
| 96 | 97 | 2.015737 | 2.015736986 | 2.015737 |
| 108 | 109 | 2.015834 | 2.015834216 | 2.015834 |

The other n values (6, 10, 14, 18, 24, 32, 40, 48, 64, 84) also agree to every printed digit (full list in the `indep.py` and `instr.jl` outputs). Property checks:
- The degree of precision is exactly 3: the error is 0 for x^0..x^3 and nonzero for x^4 and x^5.
- Each panel quadratic reproduces its three data points to ≤ 2.6e-15.
- The convergence rate tends to 2^{5/3}, as expected for this singular integrand. This independently confirms the page's analysis.

**Is the reference value right?** The script draws no reference value. The page's quoted integral 2.016280 was checked to 30 digits in two ways (C4).

**Does the picture show what was computed?** Yes. I checked frames 1, 2 and 24 at full size, plus the 12-frame contact sheet (frames at n = 4, 8, 12, 16, 20, 28, 36, 44, 56, 72, 96):
- Panels are quadratics through the red sample points.
- Divider lines are at x_{2k} only and run from the axis up to f(x_{2k}).
- The magenta curve is f, plotted at 800 points.
- The annotation values and point counts match the table above.
- The axis limits do not clip anything. The y-range is [0, 2.1]. The panels reach at most 1.976 (n = 32) and at least 0.349 (n = 16), and f lies in [0.3572, 1.9198] (`range.py`). The x-limits [−0.03, 2.03] include both endpoint dots.
- The annotation block at y ≈ 1.74–1.88 near x ≈ 0.8–1.5 does not cover the curve, whose maximum there is about 1.38.
- There is no NaN masking. The script has no clamping, and the frame count is as stated.

**Legacy fidelity.** The Mathews animation (`a2001/Animations/Quadrature/Simpson/Simpsonaa.gif`, linked from `simpsonsrulemod.html`) uses the same function y = e^{−x} sin(8x^{2/3}) + 1 on [0,2], the same red dots, the same panel dividers at x_{2k} and the same pink fill. It runs n = 2..40 in steps of 2 after two opening frames. Its displayed values (2.491261, 1.840560, 1.976389, 1.998814, 2.006018, 2.009329, 2.011175, 2.012331, 2.013112, 2.013669, 2.013890) all match my independent sums for the corresponding n (`leg.py`). The new page keeps the example and extends the refinement. The module's "Example 1" (Simpson with m = 1, 2, 4, 8) is a worked example, not an animation case. The page lists its Worked Example as planned, so the omission is content the page does not yet have, not a dropped case.

