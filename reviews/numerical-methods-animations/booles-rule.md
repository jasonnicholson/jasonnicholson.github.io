# Boole's Rule — animation review

Page: [`pages/numerical-methods/booles-rule/index.qmd`](../../pages/numerical-methods/booles-rule/index.qmd) · Scripts: `boolesaa.jl` · GIFs: 1

**Result:** 1 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Behavior paragraph claims sixth-order, rapid convergence; the computed sequence converges at order 5/3

- **Location:** index.qmd:28, "**Behavior:** Piecewise quartic panels are rebuilt at increasing density, and the approximation converges rapidly with sixth-order global accuracy."
- **Now:** The page tells the reader that this animation shows sixth-order (O(h^6)) convergence and that it is rapid.
- **True:** The integrand f(x) = 1 + e^{-x} sin(8 x^{2/3}) is not smooth at x = 0: near 0, f(x) ≈ 1 + 8 x^{2/3}, so f'(x) ~ (16/3) x^{-1/3} is unbounded. The O(h^6) error bound needs f in C^6[a,b], so it does not apply here. The endpoint singularity sets the observed rate: the error shrinks by about 3.18 ≈ 2^{5/3} each time h is halved (order about 1.667), not by 2^6 = 64. Convergence is slow. The exact integral is 2.016279719617…, and the final frame (121 sample points) shows 2.015961, which is still off by 3.2e-4 and correct to only 3 significant decimals. The frames from 33 to 121 points move only in the 3rd–4th decimal (2.013393 → 2.015961).
- **Evidence:** `/usr/bin/python3 -I reviewer/indep.py`. Reference integral (mpmath, after substituting x = t^3 to remove the singularity, cross-checked by direct split quadrature): I = 2.016279719617096327887274. Composite Boole errors on the page's f: n=8: −5.29e-2; n=16: −8.95e-3; n=32: −2.89e-3; n=64: −9.10e-4; n=128: −2.86e-4; n=256: −9.00e-5; n=512: −2.83e-5; n=1024: −8.91e-6. Halving ratios are 3.10, 3.17, 3.18, 3.18, 3.18, 3.18, and log2 of the ratio settles at 1.667. For contrast, the same rule on the smooth f(x) = e^{-x} sin(8x) + 1 gives ratios of 88.4, 69.3, 65.3 → 64, which is sixth order. So the rule is implemented correctly, and the claim fails because of the integrand.
- **Suggested fix:** Replace the sentence with something like: "Piecewise quartic panels are rebuilt at increasing density. Because f contains x^{2/3}, whose derivative is unbounded at x = 0, the O(h^6) rate for smooth integrands does not apply here: the error falls only like h^{5/3} (about a factor of 3.2 per halving of h), and at 121 sample points the approximation 2.015961 is still 3.2×10⁻⁴ below the exact value 2.0162797." An alternative is to change the integrand to a smooth one if the page is meant to show sixth-order convergence.

- **Independent check:** confirmed. Checker measured order 1.62–1.67 for n=16..120 and exactly 5/3 at n=4096; a smooth control function gives order 6.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `boolesaa.jl` | yes | 3.7 | boolesaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | Script lines 48–63: one degree-4 Vandermonde interpolant per block of 5 nodes. Weights derived from scratch match the rule (claim 3). | confirmed |
| 2 | 12 | "spacing h=(b-a)/n with n divisible by 4" | Script: dx=(b-a)/n, and every n in n_seq is a multiple of 4 | confirmed |
| 3 | 14 | B_n = (2h/45) Σ (7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4}) | sympy solved the 5 moment equations on nodes 0..4 over [0,4]: weights [14/45, 64/45, 8/15, 64/45, 14/45] = (2/45)[7,32,12,32,7]. Script line 35 uses the same weights. | confirmed |
| 4 | 17 | "exact for polynomials up to degree 5" | sympy on a generic [a,b]: error is 0 for degrees 0–5. Degree 6 gives error −(a−b)^7/2688 ≠ 0. | confirmed |
| 5 | 17 | "global error O(h^6) on smooth functions" | Smooth test e^{-x}sin(8x)+1: halving ratios 88.4, 69.3, 65.3 → 64 | confirmed (the claim is about smooth f; see F1 for this page's f) |
| 6 | 17 | "the highest-order closed Newton-Cotes rule in this set" | The section's quadrature pages cover trapezoidal, Simpson 1/3, Simpson 3/8 and Boole. The newton-cotes-integration page lists Boole (degree 4) as its highest. | confirmed |
| 7 | 21–22 | f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2] | Script line 8: `exp(-x)*sin(8*x^(2/3)) + 1`, a,b = 0,2. Plotted curve matches. | confirmed |
| 8 | 22 | "Each frame recomputes the approximation over the full interval with a denser partition where n remains a multiple of 4" | n_seq = 4,8,…,64,72,…,120, all multiples of 4, each over [0,2]. Frame 1 is a blank n=0 title frame (curve only), which is harmless. | confirmed |
| 9 | 26 | Case heading: "Composite Boole's Rule, f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2]" | Same as #7 | confirmed |
| 10 | 28 | "Piecewise quartic panels are rebuilt at increasing density" | Frames 2, 3, 24 and the contact sheet. Instrumented panels reproduce f at the nodes (residual ≤ 7e-14) and agree with an independent Lagrange form (≤ 7e-14). | confirmed |
| 11 | 28 | "the approximation converges rapidly with sixth-order global accuracy" | Observed order 1.667 (ratio 3.18 per halving). Final-frame error 3.2e-4. | wrong (→ F1) |
| 12 | 30 | "[Julia source](boolesaa.jl)" | File exists. Manifest shows it produces boolesaa.gif. | confirmed |
| 13 | 32 | Embed boolesaa.gif. Alt: "Boole's Rule animation over [0,2] with full-interval density refinement: each frame updates piecewise quartic panels and the global approximation" | The GIF is byte-identical to the script's output (manifest). It shows [0,2] refinement with quartic panels and the approximation. | confirmed |

## Implementation checks

### boolesaa.jl
- **Method:** This is composite Boole's rule (closed 5-point Newton–Cotes), with weights (2h/45)[7,32,12,32,7] summed over blocks of 4 subintervals (lines 26–38). It is not a neighbouring method. The weights were checked by property, independently of any remembered table: sympy solved the moment equations for 5 equally spaced nodes and recovered exactly these weights. The rule is exact through degree 5, and degree 6 fails with error −(b−a)^7/2688. A composite test on a smooth function shows error ratio → 64 = 2^6 on halving h (88.4, 69.3, 65.3).
- **Numbers:** The script's `boole_sum` values (reviewer/instr.jl) agree with my independent mpmath implementation (reviewer/indep.py) to ~1e-10 for every n in n_seq. Examples (script / independent / shown in frame): n=4: 1.5531546827 / 1.553154683 / 1.553155; n=8: 1.9634127276 / 1.963412728 / 1.963413; n=16: 2.0073277270 / 2.007327727 / 2.007328; n=64: 2.0153696865 / 2.015369687 / "2.01537" (Julia drops the trailing 0 of 2.015370, which is correct); n=120: 2.0159611789 / 2.015961179 / 2.015961. "Sample Points = n+1" is correct for a closed composite rule.
- **Reference values:** The script draws no reference integral. I computed I = 2.016279719617096327887274 independently with mpmath, using the substitution x = t^3, which makes the integrand smooth. Direct quadrature split into 40 subintervals gave the same value to 25 digits. On this f the errors decay like h^{5/3} (see F1).
- **Picture:** I viewed the contact sheet and full-size frames 2 (n=4), 3 (n=8) and 24 (n=120). Each red/pink panel is the quartic through x0..x4 = a+4k·dx … a+(4k+4)·dx. Instrumented checks for every frame: node residual ≤ 6.6e-14, and agreement with an independent Lagrange evaluation ≤ 7.3e-14. At n=8 the visible panel junction falls at x=1.0, as expected for nodes 0, 0.25, …, 1. The panels are filled to y=0, so the shaded area is the integral the rule computes. The magenta curve is the stated f. Panel ranges (min 0.124 at n=4, max 1.920) and f's range (0.357–1.920) lie inside ylims (0, 2.1), so nothing is clipped. Titles and annotations match the computed quantities. Frame 1 is an intentional blank frame at n=0 (24 frames = 1 + 23 values of n).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/booles-rule/`](evidence/booles-rule/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
