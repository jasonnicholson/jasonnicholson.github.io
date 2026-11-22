# Derive Numerical Differentiation Formulae — animation review

Page: [`pages/numerical-methods/derive-numerical-differentiation-formulae/index.qmd`](../../pages/numerical-methods/derive-numerical-differentiation-formulae/index.qmd) · Scripts: `diffformaa.jl`, `diffformab.jl`, `diffformac.jl` · GIFs: 3

**Result:** 1 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 3 heading says "at $x_0=1$", but the animation has no $x_0$

- **Location:** index.qmd:36, `### Case 3 - second derivative formulas at $x_0=1$`
- **Now:** The heading gives the case's parameter as $x_0=1$.
- **True:** `diffformac.jl` has no `x0`. It evaluates `d2_3` and `d2_5` at 700 points across `xinner = range(2h, pi-2h, length=700)` (diffformac.jl:22) and plots them as curves against $f''$ over $[0,\pi]$. The frame title reads "Second-derivative formulas on [0, pi] | h = …", and the page's own Behavior paragraph (line 38) describes profiles over $[0,\pi]$. Nothing in the animation is evaluated at or marked at $x=1$.
- **Evidence:** I read diffformac.jl lines 14–29: the only spatial variables are `xtrue` and `xinner`. In committed frames `diffformac/frame_001.png` and `frame_011.png` there is no marker or annotation at x = 1.
- **Suggested fix:** Change the heading to `### Case 3 - second-derivative formulas on $[0,\pi]$`. Optionally also state the formulas, e.g. $f''(x)\approx \frac{f(x+h)-2f(x)+f(x-h)}{h^2}$ and $f''(x)\approx\frac{-f(x+2h)+16f(x+h)-30f(x)+16f(x-h)-f(x-2h)}{12h^2}$, to match Cases 1 and 2. Line 38 could also say that the stencil curves cover $[2h,\pi-2h]$, which is visible as a gap at both ends in the $h=0.35$ frame.

- **Independent check:** confirmed. Checker: Error is fair strictly, but impact is low because the text under the heading (line 38) and the alt text (line 42) correctly say 'over [0, π]'.

### F2 — Minor — Implementation — Error annotations rounded to a fixed number of decimals, so they show "0.0" or a wrong leading digit

- **Location:** diffformab.jl:61 (`round(abs(approx3 - exact); digits=6)`, `round(abs(approx5 - exact); digits=6)`), diffformac.jl:55 (`round(err3; digits=8)`, `round(err5; digits=8)`)
- **Now:** Julia prints the rounded values in scientific notation, so they look like 2-significant-figure numbers, but they were rounded to absolute decimals. In diffformab.gif:
  - h = 0.08 shows `|err5|≈1.0e-6`; the true value is 6.01e-7.
  - h = 0.005 shows `|err3|≈4.0e-6`; the true value is 4.24e-6.
  - h = 0.002 shows `|err3|≈1.0e-6`; the true value is 6.78e-7.
  - `|err5|≈0.0` in 6 of 11 frames (h = 0.05 … 0.002).

  In diffformac.gif:
  - h = 0.02 shows `max|error 5-point| ≈ 1.0e-8`; the true value is 1.37e-8.
  - `≈ 0.0` in 3 of 11 frames (h = 0.01, 0.005, 0.002).

  In Case 2 the green five-point line sits under the red tangent in every frame and cannot be seen, so the annotation is the only place the five-point accuracy appears. For more than half the animation it reads as an exact result, and the $h^4$ shrinkage the page talks about cannot be seen.
- **True:** |err5| at x0 = 1 is 9.21e-8, 1.20e-8, 2.36e-9, 1.48e-10, 9.23e-12 and 2.36e-13 for h = 0.05, 0.03, 0.02, 0.01, 0.005 and 0.002. These are nonzero and fall by a factor of about 16 per halving.
- **Evidence:** `julia inst_all.jl` prints both the annotation strings and the raw errors. For example, `h=0.08 err5=-6.008507e-07 annot |err5|≈1.0e-6` and `h=0.002 err3=6.777681e-07 annot |err3|≈1.0e-6`. `python3 -I indep_values.py` independently gives err5(0.08) = −6.00851e-7 and err3(0.002) = 6.77768e-7. Read in full-size frames `diffformab/frame_005.png` ("|err5|≈1.0e-6") and `frame_011.png` ("|err3|≈1.0e-6, |err5|≈0.0").
- **Suggested fix:** Format with significant figures instead of decimals. For example, add `using Printf` and use `@sprintf("%.2e", abs(approx5 - exact))` in diffformab.jl:61 and `@sprintf("%.2e", err5)` in diffformac.jl:55, likewise for err3.

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Implementation — Case 2 frame title is cut off, so the formula's divisor reads "/(12"

- **Location:** diffformab.jl:49 (`title="Five-point formula: f'(x0) ≈ [f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)]/(12h)"`) with `size=(760, 460)` at line 47
- **Now:** In all 11 frames the title runs off the right edge and ends at "…-f(x0+2h)]/(12". The closing "h)" is missing, so the formula shown is incomplete. The left edge is also tight: the "F" touches the border.
- **True:** The formula is $[f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)]/(12h)$, as the page heading at line 28 says.
- **Evidence:** Full-size frames `committed/diffformab/frame_001.png`, `frame_005.png` and `frame_011.png` all end at "/(12".
- **Suggested fix:** Add `titlefontsize=10`, or widen the figure (e.g. `size=(900, 460)`), or shorten the title to "Five-point formula, f'(x0)". Also consider adding "h = $(h)" to the title, as in Case 1.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `diffformaa.jl` | yes | 3.5 | diffformaa.gif |
| `diffformab.jl` | yes | 3.7 | diffformab.gif |
| `diffformac.jl` | yes | 3.3 | diffformac.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "central finite-difference formulas are derived from Taylor expansions and solved … as small linear systems" | `check_formulas.py`: solving the Taylor moment system $\sum_j c_j o_j^k = k!\,\delta_{kd}$ on offsets {−1,0,1} and {−2,…,2} gives exactly [−1/2, 0, 1/2], [1/12, −2/3, 0, 2/3, −1/12], [1, −2, 1] and [−1/12, 4/3, −5/2, 4/3, −1/12], which are the scripts' coefficients. (The scripts hard-code the formulas and do not solve systems themselves. The page does not claim they do.) | confirmed |
| 2 | 12 | "first- and second-derivative formulas together" | Cases 1–2 are first-derivative and Case 3 is second-derivative | confirmed |
| 3 | 14 | "For symmetric stencils, odd and even Taylor terms cancel … producing compact formulas with clear error orders" | sympy error series contain only even powers of h: D1_3: $f'''h^2/6+f^{(5)}h^4/120+…$; D1_5: $-f^{(5)}h^4/30-…$; D2_3: $f^{(4)}h^2/12+…$; D2_5: $-f^{(6)}h^4/90-…$ | confirmed |
| 4 | 14 | "three-point and five-point formulas … wider stencils can significantly improve accuracy for smooth functions" | err5 ≪ err3 at every h in Cases 2 and 3 (ratios 108–2.9e6 in Case 2, 25–3e5 in Case 3) | confirmed |
| 5 | 18 | test function "$f(x)=e^{-x}\sin(x)$" | `f(x) = exp(-x) * sin(x)` in all three scripts (line 8) | confirmed |
| 6 | 18 | "Each animation below visualizes one derived stencil formula" | Cases 2 and 3 each show two formulas (3- and 5-point). Loose wording only. | confirmed (wording loose, not a finding) |
| 7 | 20 | Case 1 formula $f'(x_0)\approx \frac{f(x_0+h)-f(x_0-h)}{2h}$ | diffformaa.jl:11 `d1_3`. sympy: exact for degree ≤ 2, not degree 3 (gives $h^2$) | confirmed |
| 8 | 22 | "symmetric three-point slope converges to the tangent slope as h decreases" | err3 at x0 = 1 falls monotonically from 6.14e-2 (h = 0.6) to 1.69e-7 (h = 0.001). The script and mpmath agree to all printed digits. | confirmed |
| 9 | 22 | "reflecting second-order accuracy" | halving ratios 4.00065 (0.1→0.05), 4.00003 (0.02→0.01), 4.00001 (0.01→0.005). err3 matches $f'''(1)h^2/6$ with f'''(1) = 1.01665 (e.g. 1.69442e-5 vs 1.69442e-5 at h = 0.01) | confirmed |
| 10 | 24, 26 | link `diffformaa.jl`, embed `diffformaa.gif` | manifest: diffformaa.gif is produced only by diffformaa.jl and is byte-identical | confirmed |
| 11 | 26 | alt: "three-point central stencil points and slope line converging to the tangent at x0 equals 1" | x0 = 1.0 (aa:13). Frames 1, 12 and the sheet show the 3 orange stencil points and a dashed line merging into the red tangent | confirmed |
| 12 | 28 | Case 2 formula $\frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}$ | diffformab.jl:12 `d1_5`. sympy: exact for degree ≤ 4, not degree 5 (gives $-4h^4$). Linear-solve derivation agrees | confirmed |
| 13 | 30 | "five-point stencil uses cancellation of lower-order truncation terms" | error series starts at $h^4$; the $h^2$ term cancels | confirmed |
| 14 | 30 | "its error drops faster than the three-point estimate for the same h" | at every one of the 11 h values, \|err5\| < \|err3\| (e.g. h = 0.35: 1.92e-4 vs 2.08e-2). err5 halving ratios 15.87, 15.995, 15.999 vs ≈ 4 for err3 | confirmed (but the GIF's own annotation shows err5 as "0.0" in 6 frames → F2) |
| 15 | 32, 34 | link `diffformab.jl`, embed `diffformab.gif` | manifest: byte-identical, produced only by diffformab.jl | confirmed |
| 16 | 34 | alt: "five-point stencil samples and comparison of three-point versus five-point slope estimates as h decreases" | 5 orange points at x0 ± h, x0 ± 2h. Dashed 3-point line visible in frames 1–3. The green 5-point line is drawn but hidden under the red tangent (sub-pixel difference) | confirmed |
| 17 | 36 | Case 3 heading "second derivative formulas at $x_0=1$" | the script has no x0. It plots profiles over [2h, π − 2h] | wrong (→ F1) |
| 18 | 38 | "compare $f''(x)$ against the three-point and five-point second-derivative stencils over $[0,\pi]$" | f'' is drawn on [0, π]. The stencil curves are drawn on [2h, π − 2h] (visible gap only at h = 0.35, 0.25). Script fpp = −2e^{−x}cos x matches sympy's f''. | confirmed (stencil curves stop 2h short of each end; see F1 suggestion) |
| 19 | 38 | "As h decreases, both improve" | max err3: 1.31e-2 → 4.30e-7, monotone. max err5: 5.16e-4 → 5.5e-11 (the script's double-precision value rises slightly to 5.9e-11 at h = 0.002 from roundoff, but the annotation shows 0.0 for both). Script and mpmath agree to ≥ 4 significant figures for h ≥ 0.005 | confirmed |
| 20 | 38 | "the five-point stencil stays noticeably closer because it cancels lower-order truncation terms" | max-error ratio err3/err5 = 25.3 at h = 0.35, rising to 3e5 at h = 0.002. Halving at x = 1: err5 ratio 16.03, err3 ratio 4.00. The difference is visible as separated curves only in frame 1; afterwards it shows only in the annotation numbers | confirmed |
| 21 | 40, 42 | link `diffformac.jl`, embed `diffformac.gif` | manifest: byte-identical, produced only by diffformac.jl | confirmed |
| 22 | 42 | alt: "second-derivative curves for the exact function, three-point stencil, and five-point stencil over 0 to pi as h decreases" | legend "f''(x)", "3-point d2", "5-point d2". xlims (0, π). h decreasing 0.35 → 0.002 | confirmed |
| 23 | 49 | Taylor expansion $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f'''+\cdots$ | standard. Used as the series basis in `check_formulas.py` | confirmed |
| 24 | 55 | $f'(x)=\frac{f(x+h)-f(x-h)}{2h}+O(h^2)$ | sympy leading term $f'''h^2/6$. Ratio 4 on halving | confirmed |
| 25 | 57 | $f''(x)=\frac{f(x+h)-2f(x)+f(x-h)}{h^2}+O(h^2)$ | sympy leading term $f^{(4)}h^2/12$. Exact for degree ≤ 3, not degree 4. Ratio 3.9999 on halving at x = 1 | confirmed |
| 26 | 60 | "Including $x\pm2h$ … yields five-point formulas with $O(h^4)$ truncation behavior" | D1_5 leading $-f^{(5)}h^4/30$, D2_5 leading $-f^{(6)}h^4/90$. Halving ratios ≈ 16.0 for both | confirmed |

## Implementation checks

### diffformaa.jl
- **Method:** the central three-point first-derivative formula `(f(x+h)-f(x-h))/(2h)` at x0 = 1. This is the method in the heading.
- **Numbers:** by property, sympy shows the stencil is exact on $1, x, x^2$, gives $h^2$ (not 0) on $x^3$, and has error $f'''h^2/6 + f^{(5)}h^4/120+\dots$. Values at x0 = 1, script (Julia) beside mpmath:

  | h | script | mpmath |
  |---|---|---|
  | 0.6 | −0.049353742675004 | −0.049353742675 |
  | 0.1 | −0.109098976847732 | −0.109098976848 |
  | 0.001 | −0.110793595864717 | −0.110793595865 |

  The other h agree as well. The errors match the leading term $f'''(1)h^2/6$ (f'''(1) = 1.0166520) to 4 or more significant figures for h ≤ 0.1. Halving ratios are 4.0007, 4.00003 and 4.00001.
- **Reference values:** `fp(x) = exp(-x)*(cos x - sin x)` equals sympy's derivative (difference simplifies to 0). fp(1) = −0.110793765306699 in both.
- **Picture:** I viewed frames 1 and 12 at full size and the contact sheet (all 12). The orange points are at x0 − h, x0 and x0 + h on the curve. The dashed "formula slope" line passes through (x0, f(x0)) with slope `approx`, parallel to the secant through the outer points, which is a valid way to show the central slope. The red tangent uses the exact slope. The annotations "approx = …, exact = −0.110794" match the printed values. The title h matches the hs list. ylims (−0.1, 0.55) contain the curve (max ≈ 0.322) and both lines over [0.1, 1.9]. No clamping. 12 frames = 12 h values.

### diffformab.jl
- **Method:** the central five-point first-derivative formula `(f(x-2h) - 8f(x-h) + 8f(x+h) - f(x+2h))/(12h)`, shown beside the three-point one, at x0 = 1. This is the method in the heading.
- **Numbers:** sympy shows the stencil is exact through degree 4, gives $-4h^4$ on $x^5$, and has error $-f^{(5)}h^4/30 - f^{(7)}h^6/252$. Linear-solve derivation gives the same coefficients. err5, script beside mpmath:

  | h | script | mpmath |
  |---|---|---|
  | 0.35 | −1.919266e-4 | −1.91927e-4 |
  | 0.08 | −6.008507e-7 | −6.00851e-7 |
  | 0.01 | −1.477073e-10 | −1.47709e-10 |
  | 0.002 | −2.160633e-13 | −2.36359e-13 |

  At h = 0.002 the script's double-precision value is roundoff-limited, which is irrelevant to the display. Halving ratios of err5 are 15.87, 15.995 and 15.999. |err5| < |err3| at all 11 h.
- **Reference values:** same `fp` as aa, verified.
- **Picture:** I viewed frames 1, 5 and 11 at full size and the contact sheet (all 11). The orange stencil points are at the 5 correct abscissae. The lines pass through (x0, f(x0)) with slopes approx3, approx5 and exact. The green five-point line is plotted before the red tangent and differs from it by at most 1.7e-4 in y over the ±0.9 span, so it is hidden in every frame. This is honest (they really coincide), but the five-point comparison then rests entirely on the annotation, which has the rounding defect in F2. The title is clipped (F3). 11 frames = 11 h values.

### diffformac.jl
- **Method:** the three-point `(f(x+h) - 2f(x) + f(x-h))/h^2` and five-point `(-f(x+2h) + 16f(x+h) - 30f(x) + 16f(x-h) - f(x-2h))/(12h^2)` second-derivative formulas, evaluated as curves on a 700-point grid over [2h, π − 2h]. There is no single x0 (F1).
- **Numbers:** sympy shows D2_3 is exact through degree 3 with error $f^{(4)}h^2/12+…$, and D2_5 is exact through degree 5 with error $-f^{(6)}h^4/90-…$. Linear-solve derivation gives [−1/12, 4/3, −5/2, 4/3, −1/12], which equals the script's [−1, 16, −30, 16, −1]/12. Max errors on the script's grid, script (Julia) beside mpmath:

  | h | script err3 | mpmath err3 | script err5 | mpmath err5 |
  |---|---|---|---|---|
  | 0.35 | 1.305742e-2 | 1.30574e-2 | 5.158306e-4 | 5.15831e-4 |
  | 0.08 | 6.874867e-4 | 6.87487e-4 | 3.063496e-6 | 3.0635e-6 |
  | 0.01 | 1.074644e-5 | 1.07464e-5 | 8.710541e-10 | 8.71114e-10 |

  At h = 0.002 the script's err5 is 5.89e-11, against an mpmath value of 1.42e-12, because of roundoff in double precision; the frame shows 0.0 for it anyway. At x = 1, halving ratios are err3 3.9987 and 3.99995, and err5 16.03 and 16.001.
- **Reference values:** `fpp(x) = -2exp(-x)cos x` equals sympy's f'' (difference simplifies to 0). Range on [0, π]: f''(0) = −2, max 0.13404 at 3π/4, f''(π) = 0.0864, all inside ylims (−2.1, 0.2).
- **Picture:** I viewed frames 1 and 11 at full size and the contact sheet. The black f'' curve spans [0, π]. The stencil curves start at 2h and end at π − 2h, which shows at h = 0.35 as curves beginning at x = 0.7. The dashed 3-point curve separates visibly from f'' only in frame 1 (max error 0.013 ≈ 2 px). Afterwards all three curves coincide, and the comparison is carried by the annotation (rounding defect, F2). The legend box (top right) does not hide any part of the curves that matters. 11 frames = 11 h values.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/derive-numerical-differentiation-formulae/`](evidence/derive-numerical-differentiation-formulae/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
