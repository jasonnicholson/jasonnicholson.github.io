# Simpson's Rule for Numerical Integration — animation review

Page: [`pages/numerical-methods/simpsons-rule-for-numerical-integration/index.qmd`](../../pages/numerical-methods/simpsons-rule-for-numerical-integration/index.qmd) · Scripts: `simpsonsaa.jl` · GIFs: 1

**Result:** 1 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — "fourth-order global accuracy" is false for this integrand; the measured order is 5/3

- **Location:** `index.qmd:29`: "the approximation converges rapidly with fourth-order global accuracy."
- **Now:** The Behavior paragraph says the animated case converges at fourth order.
- **True:** The integrand $f(x)=e^{-x}\sin(8x^{2/3})+1$ is not smooth at $x=0$. Near 0, $f(x)\approx 1+8x^{2/3}$, so $f'$ is unbounded there. That caps composite Simpson at $O(h^{5/3})$. When $h$ is halved the error falls by about 3.18 ($2^{5/3}=3.175$), not 16. Across the frames the GIF shows, the ratio is 4.8 to 3.2 (observed order 2.3 to 1.7). It is never near 16. Convergence is also not "rapid": at the last frame (109 sample points) the shown approximation 2.015834 is still off by $4.5\times10^{-4}$ from the true 2.0162797, so it is already wrong in the fourth significant digit. The Description's statement (line 18), "O(h^4) for smooth functions", is correct as a general fact, but this integrand does not satisfy its hypothesis.
- **Evidence:** `reviewer/reference.py` (mpmath, 40 digits). Reference $I = 2.016279719617096327887274$, the same by three routes: tanh-sinh on [0,2], 40 subintervals, and the substitution $x=t^3$ that removes the non-smoothness. Halving ratios $E(n)/E(2n)$: n=4→8 5.40; 8→16 5.73; 16→32 3.71; 32→64 3.28; 64→128 3.20; 256→512 3.179; 4096→8192 3.175 (log2 = 1.667). Ratios from frames that are in the GIF: 12→24 4.24; 24→48 3.38; 48→96 3.22. Smooth control in `reviewer/trap_compare.py`: Simpson on $e^{-x}\sin(8x)+1$ gives ratios 17.4, 16.3, 16.1. So the routine itself is fourth order, and the degradation comes from the integrand. Errors at the frames: n=20 −8.34e-3, n=48 −1.75e-3, n=108 −4.46e-4.
- **Suggested fix:** Replace the sentence with something like: "…and the approximation converges, but only at about $O(h^{5/3})$, because $x^{2/3}$ makes $f$ non-smooth at $x=0$. Simpson's $O(h^4)$ rate needs a smooth integrand. Even with 109 points the result 2.015834 differs from the true value 2.016280 by about $4.5\times10^{-4}$." Alternatively, switch the animation to a smooth integrand if the intent is to show fourth-order convergence.

- **Independent check:** confirmed. Checker: order → 5/3 (≈1.8 over the animation's n=12..108); 4.0 on a smooth control.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `simpsonsaa.jl` | yes | 3.6 | simpsonsaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | "Composite Simpson's rule approximates $\int_a^b f$ by fitting a quadratic interpolant across each pair of subintervals" | Script lines 41–55 build one parabola per pair $[x_{2k},x_{2k+2}]$. The drawn parabolas reproduce $f$ at all three nodes (max residual 2.6e-15), and the sum of their exact integrals equals `simpson_sum(n)` (max diff 2.7e-15) for every n (`reviewer/script_values.jl`) | confirmed |
| 2 | 13 | "With $h=(b-a)/n$ and even $n$" | `dx=(b-a)/n`; every n in `n_seq` is even | confirmed |
| 3 | 15 | $S_n=\frac h3[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2}f(x_{2k-1})+2\sum_{k=1}^{n/2-1}f(x_{2k})]$ | Formula checked by property: exact for $x^0..x^3$ on [0,2] (n=2, 6; errors 0 and 9e-16), not exact for $x^4$ (err 0.2667 at n=2 = $2\cdot24\cdot h^4/180$; 0.003292 at n=6). Script lines 28–30 implement the same index sets. An independent panel-wise $(h/3)[1,4,1]$ sum in mpmath matches the script to ≤6e-16 at all 23 n | confirmed |
| 4 | 18 | "the method integrates cubics exactly" | $x^3$: S=4.0, exact 4; $x^4$ not exact (above) | confirmed |
| 5 | 18 | "composite error for smooth functions is $O(h^4)$" | Smooth control $e^{-x}\sin(8x)+1$: halving ratios 17.4, 16.3, 16.1 | confirmed (as a general statement; see F1 for this integrand) |
| 6 | 18 | "typically much smaller than trapezoidal error at the same spacing" | General statement for smooth f. For this integrand Simpson's error is about 3.1–3.6× smaller than trapezoid at n=20, 48, 108, 1024 (`trap_compare.py`) | confirmed (general claim; not contradicted) |
| 7 | 22–23 | "the Simpson's rule diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$" | Script line 8 `f(x)=exp(-x)*sin(8*x^(2/3))+1`, line 9 `a,b=0,2` | confirmed |
| 8 | 23 | "Each frame redraws the entire interval using a denser even partition" | Each frame draws panels over all of [0,2]. `n_seq` strictly increases through 2…108, all even. Frame 1 is n=0 (curve only, no panels), which is an intro frame | confirmed |
| 9 | 22 | "Each animation below" (plural) | Only one animation on the page | confirmed in substance (wording only; not a finding) |
| 10 | 27 | Case 1 heading: Composite Simpson's Rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | Same as #7; method composite Simpson (#3) | confirmed |
| 11 | 29 | "Quadratic panels are rebuilt over the full interval as sample density increases" | Frames 2, 5, 9, 13, 24 viewed. Panels are rebuilt each frame with more points (Sample Points 3 → 109) | confirmed |
| 12 | 29 | "the approximation converges rapidly" | Errors −0.40 (n=4) … −4.46e-4 (n=108). It converges, but slowly: about 4 significant digits at 109 points | wrong (→ F1) |
| 13 | 29 | "with fourth-order global accuracy" | Measured order about 1.7 in the shown range, 5/3 asymptotically | wrong (→ F1) |
| 14 | 31 | "[Julia source](simpsonsaa.jl)" | File exists. The manifest shows it is the sole producer of simpsonsaa.gif and the output is byte-identical | confirmed |
| 15 | 33 | Embed `simpsonsaa.gif`; alt: "full-interval density refinement: each frame updates piecewise quadratic panels and the global approximation" | Embed path correct. Frames show updated panels and an "Approximation = …" annotation each frame | confirmed |

## Implementation checks

### simpsonsaa.jl
- **Method:** Standard composite Simpson's 1/3 rule. Odd interior nodes get weight 4, even interior nodes weight 2, endpoints weight 1, all times $h/3$ (lines 26–31). The drawn panels are the quadratic interpolants on each pair of subintervals, obtained by solving a 3×3 Vandermonde system (lines 19–24, 41–55). The drawing and the number are consistent: the exact integral of the drawn parabolas equals `simpson_sum(n)` to 2.7e-15.
- **Numbers (script vs independent mpmath panel-wise Simpson; error vs I = 2.0162797196):**

  | n | points | script S | independent S | S − I |
  |---|---|---|---|---|
  | 2 | 3 | 2.4912610172534464 | 2.491261017253446 | +0.474981 |
  | 4 | 5 | 1.611786328647445 | 1.611786328647445 | −0.404493 |
  | 8 | 9 | 1.9414360776747084 | 1.941436077674709 | −0.0748436 |
  | 12 | 13 | 1.991249237540609 | 1.991249237540609 | −0.0250305 |
  | 20 | 21 | 2.0079417386648446 | 2.007941738664845 | −0.00833798 |
  | 36 | 37 | 2.0134120330938727 | 2.013412033093873 | −0.00286769 |
  | 48 | 49 | 2.0145313361281936 | 2.014531336128194 | −0.00174838 |
  | 72 | 73 | 2.0153996741989433 | 2.015399674198944 | −0.000880045 |
  | 108 | 109 | 2.015834215997174 | 2.015834215997174 | −0.000445504 |

  All 23 values agree to ≤6.3e-16 (full table in `reviewer/reference.py` output). Weight property check (`reviewer/script_values.jl`, the script's formula applied to $x^k$ on [0,2]): exact for k=0..3, not exact for k=4 (err 0.26667 at n=2, 0.0032922 at n=6; the ratio of 81 for a tripled n matches $h^4$) or k=5.
- **Reference values:** The script draws or prints no exact integral, so no reference value appears in the GIF or on the page. I computed I = 2.016279719617096327887274 independently by three mpmath routes that agree to all 25 printed digits (`reviewer/reference.py`).
- **Picture:** I viewed the contact sheet and full-size frames 2 (n=2) and 24 (n=108). Frame 2's parabola passes through (0,1), (1, f(1)≈1.364) and (2, f(2)≈1.018), the correct three nodes. Node interpolation was verified numerically for every panel of every frame (max residual 2.6e-15). "Sample Points = n+1" is correct (3, 5, …, 109). The "Approximation" annotation is `simpson_sum(n)` rounded to 6 decimals, and it matches the computed values in every frame I read (e.g. 2.491261, 1.611786, 2.015834). The title "Simpson's Rule / Numerical Quadrature" names no function, so no mismatch is possible. The magenta curve is the same `f`. Clipping: the drawn parabolas span 0.349–1.976 and f spans 0.357–1.920, both inside ylims (0, 2.1), so nothing is clipped (`reviewer/panel_extremes.jl`). Frame count 24 = intro frame (n=0) + 23 partitions. Display rounding drops trailing zeros (e.g. "2.0154" at n=72, "1.84056" at n=6). That is cosmetic and not misleading. The GIF shows no true value or error, so a viewer cannot judge the convergence rate from the frames. The only rate claim is the page text in F1.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/simpsons-rule-for-numerical-integration/`](evidence/simpsons-rule-for-numerical-integration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
