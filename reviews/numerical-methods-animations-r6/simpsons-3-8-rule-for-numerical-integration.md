# Simpson's 3/8 Rule for Numerical Integration — animation review (round 6)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page agrees with the computed values and the frames. Section 2 records each claim and its verdict.

Two observations that I judged not to be findings:
- The introduction says "Each animation below …" although there is only one animation, and "Each frame recomputes the approximation …" although frame 1 shows only $f$. The alt text states plainly that the GIF opens with an $f$-only frame, so no reader is misled.
- The on-plot label uses `round(approx; digits=6)`, so trailing zeros are dropped (e.g. "1.79047" for 1.790470, "2.01581" for 2.015810). The values are right to the precision shown.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 10.1 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Reference values come from `indep.py`, with the true integral $I = 2.0162797196170963…$ (computed with mpmath quad after substituting $x=t^3$ to remove the endpoint singularity, and cross-checked by a 39-subinterval quad that agrees to all 40 digits).

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | "Composite Simpson's 3/8 rule applies cubic interpolation on blocks of three subintervals" | Script fits a cubic through 4 nodes per 3-subinterval block (lines 40–55). The integral of each panel cubic, summed, equals `simpson38_sum(n)` to ≤ 8.4e-15 for every n (`inst.jl` PANELINT). An independent Lagrange-cubic integral in `indep.py` agrees to ≤ 1.4e-40 | confirmed |
| D2 | Description | $h=(b-a)/n$, $n$ divisible by 3; weights $\tfrac{3h}{8}[f_0+f_n+3\sum_{i\not\equiv0} f_i+2\sum_{i\equiv0,0<i<n} f_i]$ | Standard composite 3/8 weights. The script's line 27–29 implement exactly this. Degree-of-precision test with the script's formula: errors for $x^0..x^3$ on [0,2] ≤ 4.4e-16 with n=3 and n=6; $x^4$ errors 0.118519 (n=3) and 0.0074074 (n=6), ratio 16.0 | confirmed |
| D3 | Description | For $f\in C^4$, "$S^{3/8}_n - I = O(h^4)$" | Exactness through degree 3 and failure at degree 4 with an error ratio of 16 under halving (D2) is the $O(h^4)$ behaviour | confirmed |
| D4 | Description | "can be viewed as a higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Interpretive wording. Piecewise cubic panels confirmed (D1); nothing further is checkable | confirmed (descriptive) |
| A1 | Animations intro | Interval $[0,2]$, $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9 | confirmed |
| A2 | Animations intro | "each frame recomputes the approximation across the full interval with a denser partition where $n$ remains a multiple of 3" | `n_seq` = 3,6,…,36,42,48,54,60,66,72,81,90,99,108,120: all multiples of 3 and strictly increasing. Each frame calls `simpson38_sum(n)` over [a,b]. Frame 1 has n=0 (f only), which the alt text discloses | confirmed |
| A3 | Animations intro | "Red dots mark the sample points $x_i$" | Script lines 72–73 scatter $(x_i,f(x_i))$, i=0..n, in red. Frames 2 and 24 show n+1 red dots on the curve | confirmed |
| A4 | Animations intro | "vertical red lines mark the panel boundaries $x_{3k}$" | Script lines 58–61, i in 0:3:n. In the frames: lines at 0,1,2 for n=6; at 0,0.5,…,2 for n=12; at multiples of 1/3 for n=18 | confirmed |
| A5 | Animations intro | "Julia source scripts … are linked under each case" | `[Julia source](simpson38aa.jl)` present | confirmed |
| C1 | Case 1 heading | Composite 3/8 rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Script lines 8–9, 25–30 | confirmed |
| B1 | Behavior | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | See D1 and A2. Frames show the panel cubics redrawn per n | confirmed |
| B2 | Behavior | "Every approximation shown lies below the true integral … $\approx 2.016280$" | $I$ = 2.01627972 rounds to 2.016280. All 23 errors are negative, from −0.225809 to −0.000469309 | confirmed |
| B3 | Behavior | "The error grows from 4 to 7 sample points" | \|err\| 0.132066 (n=3) → 0.225809 (n=6) | confirmed |
| B4 | Behavior | "then shrinks at every later frame" | \|err\| sequence after n=6: 0.0890457, 0.0396505, 0.0221853, 0.0144459, 0.0103455, 0.00788268, 0.00626732, 0.0051386, 0.00431199, 0.00368448, 0.00280291, 0.00222053, 0.00181218, 0.00151298, 0.00128619, 0.00110959, 0.000909132, 0.000761106, 0.000648292, 0.000560094, 0.000469309: strictly decreasing | confirmed |
| B5 | Behavior | "the last frame (121 sample points) gives 2.01581, about 0.00047 low" | n=120: script 2.015810410863725, independent 2.015810411. Error −0.000469309. Frame 24 label: "Sample Points = 121", "Approximation = 2.01581" | confirmed |
| B6 | Behavior | "$f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | `deriv.py`: $f'(x)/(\tfrac{16}{3}x^{-1/3})$ = 0.9999972, 0.999999997, 0.999999999997 at x = 1e-6, 1e-9, 1e-12 | confirmed |
| B7 | Behavior | "the textbook error order, which assumes smooth $f$, does not hold for this integrand" | Measured ratios under halving are ≈3.2, not 16 (B8) | confirmed |
| B8 | Behavior | "error shrinks like $O(h^{5/3})$ … halving $h$ divides it by about 3.22 (from 60 to 120 subintervals), tending to $2^{5/3}\approx3.17$, instead of 16" | err(60)/err(120) = 3.22384. Further ratios: 15→30 4.31738, 30→60 3.39635, 120→240 3.18902, 240→480 3.18013, 480→960 3.17715, 960→1920 3.17592, 1920→3840 3.17535, approaching $2^{5/3}$ = 3.174802 | confirmed |
| W1 | Link | `simpson38aa.jl` is the script for this case | The script draws this function and interval with the 3/8 rule | confirmed |
| W2 | Embed | `simpson38aa.gif` is produced by that script | The manifest records a byte-identical scratch regeneration | confirmed |
| T1 | Alt text | "Simpson's 3/8 Rule animation over [0,2] with full-interval density refinement" | A2 | confirmed |
| T2 | Alt text | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise cubic panels and the global approximation" | Frame 1 shows only the magenta curve. Frames 2–24 show dots, divider lines, filled pink cubic panels, and the "Approximation = …" label | confirmed |
| L1 | Legacy note | "reconstructs Mathews' archived animation `Simpsonaa.gif`" | The archive GIF is the only animation linked from `Simpson38RuleMod.html` (via `Simpson38/Simpson.html`) | confirmed |
| L2 | Legacy note | "same integrand and interval" | Legacy frames are labelled $y=e^{-x}\sin(8x^{2/3})+1$, x-axis 0..2 | confirmed |
| L3 | Legacy note | "ends at the same 121-point approximation, 2.015810" | Legacy frame 24: "Sample Points = 121", "Approximation = 2.015810". Independent value 2.0158104 | confirmed |
| L4 | Legacy note | "steps through a different sequence of intermediate $n$" | Legacy sample-point counts include 4, 10, 16, 25, 37, 49, 61, 73, 85, 106, 121 (n = 3, 9, 15, 24, …, 84, 105, 120) and two opening frames. The page uses n = 3, 6, 9, … with one opening frame. Legacy values agree with my computation where n coincides: 1.884214, 1.927234, 1.994094, 2.008397, 2.012595, 2.014059, 2.014767, 2.015170 | confirmed |

The GIF's title ("Simpson's 3/8 Rule / Numerical Quadrature") and on-plot labels contradict nothing on the page. The 23 labelled approximations all match the independent values to 6 decimals (table in section 3).

### 3. Implementation checks — `simpson38aa.jl`

**It is the method it claims to be.** `simpson38_sum` (lines 25–30) is the composite Simpson's 3/8 rule: weights 1, 3, 3, 2, 3, 3, 2, …, 3, 3, 1 times $3h/8$, the same variant as the Description's formula. This does not rest on my memory of the weights. Applied to monomials on [0,2], the script's formula is exact for degrees 0–3 (errors ≤ 4.4e-16 for n=3 and n=6) and fails at degree 4 with an error ratio of 16.0 under halving: degree of precision 3, order 4. The integral of the drawn panel cubics (Vandermonde solve, lines 18–23) equals the 3/8 sum to ≤ 8.4e-15 for every n, so the shaded area is the reported approximation. The drawn cubics interpolate the data: the maximum node residual is 1.3e-14.

**The numbers are right.** Script (instrumented `inst.jl`) beside independent (`indep.py`, mpmath 40 digits):

| n | pts | script | independent | error vs I |
|---|---|---|---|---|
| 3 | 4 | 1.8842140994188474 | 1.884214099 | −0.132066 |
| 6 | 7 | 1.790470481304736 | 1.790470481 | −0.225809 |
| 9 | 10 | 1.9272339711446245 | 1.927233971 | −0.0890457 |
| 12 | 13 | 1.976629196190375 | 1.976629196 | −0.0396505 |
| 15 | 16 | 1.9940944247919974 | 1.994094425 | −0.0221853 |
| 18 | 19 | 2.001833808071699 | 2.001833808 | −0.0144459 |
| 21 | 22 | 2.005934192958429 | 2.005934193 | −0.0103455 |
| 24 | 25 | 2.008397041546531 | 2.008397042 | −0.00788268 |
| 27 | 28 | 2.0100124027891093 | 2.010012403 | −0.00626732 |
| 30 | 31 | 2.0111411216067023 | 2.011141122 | −0.0051386 |
| 33 | 34 | 2.0119677265662554 | 2.011967727 | −0.00431199 |
| 36 | 37 | 2.0125952389214476 | 2.012595239 | −0.00368448 |
| 42 | 43 | 2.0134768107053778 | 2.013476811 | −0.00280291 |
| 48 | 49 | 2.014059184718606 | 2.014059185 | −0.00222053 |
| 54 | 55 | 2.0144675377251207 | 2.014467538 | −0.00181218 |
| 60 | 61 | 2.0147667415686947 | 2.014766742 | −0.00151298 |
| 66 | 67 | 2.0149935291633914 | 2.014993529 | −0.00128619 |
| 72 | 73 | 2.015170132082283 | 2.015170132 | −0.00110959 |
| 81 | 82 | 2.0153705880411943 | 2.015370588 | −0.000909132 |
| 90 | 91 | 2.015518613868462 | 2.015518614 | −0.000761106 |
| 99 | 100 | 2.0156314275265914 | 2.015631428 | −0.000648292 |
| 108 | 109 | 2.0157196260763444 | 2.015719626 | −0.000560094 |
| 120 | 121 | 2.015810410863725 | 2.015810411 | −0.000469309 |

**Its reference values are right.** The script draws no exact-integral reference. The page's $I\approx2.016280$ was checked in B2: $I$ = 2.016279719617096…, from two independent mpmath quadratures that agree to 40 digits.

**The picture shows what was computed.** I viewed the contact sheet (frames 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23) and frames 2 and 24 at full size.
- Frame 1: $f$ only, no label.
- Frame 2 (n=3): one cubic through the 4 red nodes at 0, 2/3, 4/3, 2, with divider lines at 0 and 2. Label "Sample Points = 4, Approximation = 1.884214".
- Frame 24 (n=120): 121 dots, 41 dividers. Label "121 / 2.01581".
- Every labelled value on the contact sheet matches the table above.
- Divider lines run from 0 to $f(x_{3k})$, which is where the panel cubic sits at a boundary node.
- Display limits are y ∈ [0, 2.1] and x ∈ [−0.03, 2.03]. Across all frames the drawn cubics range over [0.2011, 1.9395] (`range.py`) and $\max f$ = 1.9198, so nothing is clipped. The fill to y=0 is the true area baseline because the axis starts at 0.
- No NaN masking or clamping is used. $x^{2/3}$ is evaluated only for x ≥ 0.
- 24 frames = 1 opening frame + 23 values of n, matching the code.

**Legacy fidelity.** The page keeps Mathews' function, interval, colour scheme (magenta $f$, red nodes, red panel dividers, pink fill) and final 121-point value. It discloses the different intermediate n sequence. The legacy module's 12 worked-example links belong to the "Worked Example (Planned)" section, which is outside this review's scope. No fidelity finding.

