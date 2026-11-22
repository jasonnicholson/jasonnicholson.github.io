# Simpson's Rule for Numerical Integration — animation review (round 2)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: "each frame" claims do not hold for the first frame

- **Where:** `index.qmd` line 23, "Each frame redraws the entire interval using a denser even partition."; line 33, the alt text "...each frame updates piecewise quadratic panels and the global approximation".
- **Now:** Frame 1 of `simpsonsaa.gif` is a title frame. It shows only the magenta curve, with no panels, no partition and no approximation. This comes from `simpsonsaa.jl` line 33, `@animate for n in vcat(0, n_seq)`, together with the `if n > 0` guard on line 39. Frames 2 to 24 do what the page says.
- **True:** 23 of the 24 frames show a partition and an approximation. The first is a blank lead-in frame.
- **How I know:** I viewed `committed/simpsonsaa/frame_001.png` and `sheet.png`. In the frame hashes and the contact sheet, frame 1 is the only one with no annotation.
- **Fix:** Say "After an opening frame showing only $f$, each frame ...", or drop the `0` from `vcat(0, n_seq)`.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: the sample points and panel boundaries are not drawn, so the panels the page describes cannot be seen in most frames

- **Where:** `simpsonsaa.jl` lines 41-55 draw each parabolic panel only as a pink fill with a 0.8-pt red top edge. No sample-point markers and no panel dividers are drawn. On the page this affects line 29, "Quadratic panels are rebuilt over the full interval as sample density increases", and the alt text on line 33.
- **Now:** Every frame reports "Sample Points = N", but those points are never shown. From about 25 points onward (frame 12 and later) the parabolas lie on the curve to within the line width. Adjacent fills show only as faint stripes, so a viewer cannot see where one quadratic panel ends and the next begins, and cannot see the sample points being counted. Frame 24 (109 points) looks like a filled area under the curve.
- **Legacy:** The Mathews GIF, which the page credits as its source and which the authoring conventions treat as ground truth for geometry, draws a red dot at every sample point and a vertical red divider at every panel boundary $x_{2k}$, through to its last frame (41 points). It also prints $y=e^{-x}\sin(8x^{2/3})+1$ in the frame. The Julia GIF keeps the legacy function, interval, colours and approximation values. It drops these markers without giving a reason.
- **How I know:** I compared the frames side by side: `review/legacy41/frame_024.png` and `sheet.png` against `committed/simpsonsaa/frame_024.png` and `sheet.png`.
- **Fix:** Add `scatter!` at $x_i$, $i=0..n$, and thin vertical lines at $x_{2k}$, as the legacy diagram has.

No Error-level or Misleading findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 6.8 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Independent reference values come from `review/indep.py` (mpmath, 40 digits). The true integral was computed two ways: with the substitution $x=t^3$, which removes the singularity, and by direct adaptive quadrature on 40 sub-intervals. Both give $I = 2.016279719617096327887274$.

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | "fitting a quadratic interpolant across each pair of subintervals" | l.13 | Script lines 41-55 fit a quadratic through $x_{2k},x_{2k+1},x_{2k+2}$. The instrumented copy gives node residuals ≤ 2.6e-15 and a drawn-panel area equal to `simpson_sum(n)` within 2.7e-15 for every n | confirmed |
| 2 | $h=(b-a)/n$, even $n$ | l.13 | Script `dx=(b-a)/n`, n_seq all even | confirmed |
| 3 | $S_n=\frac h3[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2}f(x_{2k-1})+2\sum_{k=1}^{n/2-1}f(x_{2k})]$ | l.15 | The formula is the standard composite rule and matches script lines 26-31 (odd indices 1:2:n-1, even 2:2:n-2). The script's values equal my independent panel-by-panel $\frac h3(f_0+4f_1+f_2)$ sum to all digits | confirmed |
| 4 | "the method integrates cubics exactly" | l.18 | The script's rule with n=4 on [0,2] gives errors 0, 0, 0, 0 for $1,x,x^2,x^3$, and 1.67e-2 for $x^4$ and 8.33e-2 for $x^5$ (degree of precision exactly 3) | confirmed |
| 5 | composite error $O(h^4)$ for $f\in C^4$ | l.18 | Standard result, $-\frac{(b-a)h^4}{180}f^{(4)}(\xi)$; consistent with degree of precision 3 | confirmed |
| 6 | "typically much smaller than trapezoidal error at the same spacing" | l.18 | General qualitative statement, $O(h^4)$ vs $O(h^2)$ for smooth $f$ | confirmed (qualitative) |
| 7 | animation over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | l.22-23, heading l.27 | Script l.8-9: `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2`. Matches the legacy frame label | confirmed |
| 8 | "Each frame redraws the entire interval using a denser even partition" | l.23 | Frames 2-24 do (n = 2,4,...,108, strictly increasing, all even, each spanning [0,2]). Frame 1 has no partition | wrong for frame 1 (F1) |
| 9 | "Each animation below" / "Julia source scripts ... linked under each case" | l.22, 25 | One case, one link, one GIF | confirmed |
| 10 | Case 1, Composite Simpson's Rule | l.27 | The script runs the standard composite Simpson 1/3 rule | confirmed |
| 11 | "Quadratic panels are rebuilt over the full interval as sample density increases" | l.29 | Computationally true, since every frame refits all n/2 panels. Visually the panels cannot be told apart from frame ~12 on (F2) | confirmed (see F2) |
| 12 | "the approximation converges toward the true integral" | l.29 | Errors I−S: −0.475 (n=2), 0.404, 0.176, 0.0748, ... , 0.000446 (n=108). Increasing toward I from n=4 onward | confirmed |
| 13 | $\int_0^2 f\,dx \approx 2.016280$ | l.29 | 2.0162797196 | confirmed |
| 14 | "the last frame (109 sample points)" | l.29 | The last n is 108, so 109 points. Frame 24 reads "Sample Points = 109" | confirmed |
| 15 | last frame "gives 2.015834" | l.29 | Script 2.015834215997174; independent 2.015834216. Frame 24 reads 2.015834 | confirmed |
| 16 | "about 0.00045 low" | l.29 | I − S_108 = 0.000445504 | confirmed |
| 17 | "$x^{2/3}$ term makes $f'$ unbounded at $x=0$" | l.29 | $f'(x)=-e^{-x}\sin(8x^{2/3})+e^{-x}\cos(8x^{2/3})\cdot\frac{16}{3}x^{-1/3}$, which tends to ∞ as x→0⁺ | confirmed |
| 18 | "$f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0" | l.29 | Leading term of the expression above ($e^{-x}\cos(\cdot)\to1$) | confirmed |
| 19 | "textbook error order, which assumes smooth $f$, does not hold" | l.29 | The measured ratios below tend to 3.17, not 16 | confirmed |
| 20 | "measured error shrinks like $O(h^{5/3})$" | l.29 | Error ratios for each halving of h: 12→24: 4.235; 24→48: 3.380; 48→96: 3.221; 96→192: 3.189; ...; 12288→24576: 3.17487. $2^{5/3}=3.17480$. Leading singular term $8x^{2/3}$ gives local error $\propto h^{1+2/3}$ | confirmed |
| 21 | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | l.29 | e(24)/e(48) = 0.00591009/0.00174838 = 3.3803 | confirmed |
| 22 | "tending to $2^{5/3}\approx3.17$" | l.29 | 3.1748 → 3.17; ratios converge to 3.1749 | confirmed |
| 23 | "instead of 16" | l.29 | $2^4=16$ | confirmed |
| 24 | link `[Julia source](simpsonsaa.jl)` | l.31 | The file exists in the page folder and is the only script | confirmed |
| 25 | embed `simpsonsaa.gif` | l.33 | The file exists. Regeneration from a scratch copy of `simpsonsaa.jl` is byte-identical (manifest) | confirmed |
| 26 | alt: "Simpson's Rule animation over [0,2] with full-interval density refinement" | l.33 | Matches frames 2-24 | confirmed |
| 27 | alt: "each frame updates piecewise quadratic panels and the global approximation" | l.33 | Frame 1 has neither (F1). The panels are not visually distinct in late frames (F2) | wrong for frame 1 (F1) |

Frame annotations against computed values (all 23 non-blank frames; the GIF is byte-identical to the regenerated output, so the printed script values are the drawn ones). Frames 2..24 show n+1 = 3,5,7,9,11,13,15,17,19,21,25,29,33,37,41,45,49,57,65,73,85,97,109 and the approximations 2.491261, 1.611786, 1.84056, 1.941436, 1.976389, 1.991249, 1.998814, 2.003209, 2.006018, 2.007942, 2.01037, 2.011814, 2.012756, 2.013412, 2.01389, 2.014251, 2.014531, 2.014934, 2.015206, 2.0154, 2.015601, 2.015737, 2.015834. Each equals my independent value rounded to 6 decimals. Julia's `round` drops trailing zeros, so some frames show fewer digits (for example "2.0154" for 2.015400). That is cosmetic and not misleading. The values I checked visually in `sheet.png` and `frame_002/024.png` match the table.

---

### 3. Implementation checks: `simpsonsaa.jl`

**Method.** The script runs the standard composite Simpson 1/3 rule (`simpson_sum`, lines 26-31), with weights 1,4,2,4,...,2,4,1 and h/3. For the picture it fits a quadratic to each pair of subintervals by a 3×3 Vandermonde solve (lines 19-24, 41-55). This is not a neighbouring method or a variant, and it is the method described on line 15.

**Numbers.** I instrumented `review/simpsonsaa_instr.jl` and set its values beside the independent mpmath panel sum (`review/indep.py`):

| n | script `simpson_sum` | independent | match |
|---|---|---|---|
| 2 | 2.4912610172534464 | 2.491261017 | yes |
| 4 | 1.611786328647445 | 1.611786329 | yes |
| 6 | 1.8405602095615228 | 1.84056021 | yes |
| 10 | 1.9763885057788257 | 1.976388506 | yes |
| 24 | 2.010369629370005 | 2.010369629 | yes |
| 48 | 2.0145313361281936 | 2.014531336 | yes |
| 72 | 2.0153996741989433 | 2.015399674 | yes |
| 108 | 2.015834215997174 | 2.015834216 | yes |

All 23 values agree to the 10 digits printed. Property checks that do not depend on remembering the formula:
- **Degree of precision**, using the script's own weights (n=4 on [0,2]). Errors: 1 → 0, x → 0, x² → 0, x³ → 0, x⁴ → 1.67e-2, x⁵ → 8.33e-2. The precision is exactly 3.
- **Convergence rate** for this integrand: the error ratio under halving tends to 3.1749, which is $2^{5/3}$ (table in ledger #20).
- **Cross-check against the legacy output:** Mathews' frames show 2.491261 (3 pts), 1.840560 (7), 1.976389 (11), 1.998814 (15), 2.006018 (19) and 2.013890 (41). All of these equal the script's values.

**Reference values.** The script draws no reference curve or "exact" value. The page's reference $I\approx2.016280$ was verified two independent ways to 25 digits (2.0162797196...).

**Picture.**
- *Panels are built from the right quantities.* For every n, the area under the drawn quadratics, integrated exactly from the Vandermonde coefficients, equals `simpson_sum(n)` to ≤ 2.7e-15. The interpolants reproduce f at their three nodes to ≤ 2.6e-15. Each panel spans $[x_{2k},x_{2k+2}]$ for k = 0..n/2−1 and so covers [0,2] exactly.
- *Curve.* The magenta curve is `f.(xplot)` on 800 points, the same `f` as the computation.
- *Annotations.* "Sample Points = n+1" is right for n subintervals. "Approximation" is `simpson_sum(n)` rounded to 6 digits.
- *Display devices.* No clamping or masking. The axis limits are y ∈ [0, 2.1] and x ∈ [0, 2]. Panel extremes across all frames run from 0.349 to 1.976, and the curve from 0.357 to 1.920, so everything lies inside the window. The fill goes to y=0, which is the true baseline of the integral.
- *Frames.* 24 frames (1 blank + 23 values of n) at 2 fps.
- *Issues.* Frame 1 is blank (F1). There are no sample-point or panel-boundary markers (F2). Neither changes any number a viewer reads.

