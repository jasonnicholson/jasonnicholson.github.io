# Numerical Differentiation — animation review

Page: [`pages/numerical-methods/numerical-differentiation/index.qmd`](../../pages/numerical-methods/numerical-differentiation/index.qmd) · Scripts: `numdiffaa.jl`, `numdiffab.jl` · GIFs: 2

**Result:** 1 error, 1 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — numdiffaa titles are clipped, so frames 9–12 show false error values ("3.3", "8.0", "1.0", "0")

- **Location:** `numdiffaa.jl:40` (`size=(760, 460)`) together with `numdiffaa.jl:42` (the title string). The effect is seen in committed frames `numdiffaa/frame_009.png` to `frame_012.png`.
- **Now:** The title is too wide for the 760 px canvas, and its right end is cut off in every frame. In frames 1–8 only trailing digits are lost: "≈ 0.068" for 0.068065, and "≈ 0.00…" for frames 6–8. In frames 9–11 the exponent is lost. Frame 9 shows "max error ≈ 3.3" (true value 3.3e-5), frame 10 shows "≈ 8.0" (true 8.0e-6), and frame 11 shows "≈ 1.0" (true 1.0e-6). Frame 12 shows "≈ 0".
- **True:** The max errors are 3.33e-5, 8.33e-6, 1.33e-6 and 3.33e-7, so they keep falling like h^2/3. A viewer of the GIF instead sees the error jump from about 0.0003 to "3.3" and "8.0", which contradicts the page's claim (line 28) that the approximation converges with second-order error. After h = 0.1 the two curves cannot be told apart, so the title is the only part of the frame that shows how the error behaves, and in the last four frames it shows the wrong thing.
- **Evidence:** I read `frame_009.png`, `frame_010.png`, `frame_011.png` and `frame_012.png` at full size. Their visible titles end at "max error ≈ 3.3", "≈ 8.0", "≈ 1.0" and "≈ 0". `julia title_check.jl` prints the full strings, which end in "3.3e-5", "8.0e-6", "1.0e-6" and "0.0".
- **Suggested fix:** Make the title fit. Options are a two-line title (for example `"Three-Point Central Difference on [0, π]\nh = $(h),  max error = $(@sprintf("%.2e", maxerr))"`), a `titlefontsize` around 10, or a wider canvas. Scientific formatting also fixes F3.

- **Independent check:** confirmed with correction. Checker: frames 9–11 show '3.3', '8.0', '1.0' for 3.3e-5, 8.3e-6, 1.3e-6, after '0.000' in frame 8. Correction: frame 12's '0' comes from round(...; digits=6) turning 3.3e-7 into 0.0, not from the cut-off; a fix needs significant-figure formatting as well as a title that fits.

### F2 — Misleading — Implementation / Page match — the dashed "central secant" in numdiffab is not the secant through the stencil points

- **Location:** `numdiffab.jl:37` `secant_y = y0 .+ msec .* (line_x .- x0)` and legend `numdiffab.jl:58` "central secant slope". On the page, the alt text at index.qmd:40 says "central secant lines collapsing to the tangent line at x0 equals 1", and the Behavior text at index.qmd:36 says "The slope from the symmetric secant …".
- **Now:** The dashed line has the slope of the central secant, but it is pinned at (x0, f(x0)). It does not pass through the two outer stencil points (x0±h, f(x0±h)) that are drawn as orange markers. In frame 1 (h = 0.6) the orange points at x = 0.4 and x = 1.6 sit clearly below the dashed line, about 0.08 off on a y-axis that spans 0.65. The line through them is the chord the page calls the "secant".
- **True:** The real secant through (x0−h, f(x0−h)) and (x0+h, f(x0+h)) passes through x0 at height (f(x0−h)+f(x0+h))/2. That is f(x0) + h²f''(x0)/2 + O(h⁴), not f(x0). The two lines are parallel but offset vertically by −0.0781 (h = 0.6), −0.0331 (h = 0.4), −0.0126 (h = 0.25) and −0.0045 (h = 0.15). A viewer sees a "secant" that does not go through its own stencil points, while the page calls it the secant.
- **Evidence:** `julia ab_values.jl`, column "secant-line offset at x0". In frame_001.png the orange markers at (0.4, 0.261) and (1.6, 0.202) are off the dashed line, which runs from about 0.354 to 0.265. The slope itself is correct: msec = −0.0493537 at h = 0.6, which matches my hand computation (f(1.6) − f(0.4))/1.2.
- **Suggested fix:** Draw the actual chord, `secant_y = yl .+ msec .* (line_x .- xl)`, so it passes through both outer stencil points. If the parallel, tangent-anchored line is wanted for comparing slopes, keep it but label it "line through (x0, f(x0)) with central-difference slope", and add the true chord through the stencil points.

- **Independent check:** confirmed. Checker: the line misses both outer stencil points by ≈(h²/2)|f''(x0)| = 0.078 at h=0.6, clearly visible in frames 1–3.

### F3 — Minor — Implementation — `round(maxerr; digits=6)` reports 1.33e-6 as "1.0e-6" and 3.33e-7 as "0.0"

- **Location:** `numdiffaa.jl:42`, `$(round(maxerr; digits=6))`.
- **Now:** Rounding to six decimal places loses the small errors. Even with the full title visible, the last frames would read "8.0e-6" (true 8.33e-6), "1.0e-6" (true 1.33e-6) and "0.0" (true 3.33e-7). "0.0" suggests the approximation became exact, and the 8.0 → 1.0 → 0.0 sequence does not show the h² ratio the page claims.
- **True:** The max errors are 8.3331e-6, 1.3333e-6 and 3.3333e-7, and maxerr/h² equals 0.33332, 0.33333 and 0.33333.
- **Evidence:** `julia aa_values.jl` (and `title_check.jl`).
- **Suggested fix:** Use significant-figure formatting, for example `@sprintf("%.3e", maxerr)` or `round(maxerr; sigdigits=3)`.

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — numdiffab title is clipped, so the "true" slope is cut short

- **Location:** `numdiffab.jl:53` (`size=(760, 460)`) together with `numdiffab.jl:55`.
- **Now:** The end of the title is cut off in every frame. Frame 1 shows "true = -0.11079" and frame 12 shows "true = -0.1107", while the secant value next to it is printed in full (for example "secant ≈ -0.110794" in frame 12). The visible digits are a correct prefix of −0.110794, so nothing shown is false. But the final frame compares "-0.110794" with "-0.1107", which looks like a mismatch in the 4th decimal when the two values actually agree to 6 decimals.
- **True:** f'(1) = e⁻¹(cos 1 − sin 1) = −0.110793765306699, and the script's string is "true = -0.110794".
- **Evidence:** I read frame_001.png and frame_012.png at full size. `julia title_check.jl` prints the full strings.
- **Suggested fix:** Use a two-line title or a smaller `titlefontsize`, as in F1.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `numdiffaa.jl` | yes | 3.5 | numdiffaa.gif |
| `numdiffab.jl` | yes | 3.5 | numdiffab.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "the test function is $f(x)=e^{-x}\sin(x)$ on $[0,\pi]$" | numdiffaa.jl:8,15 and numdiffab.jl:8,14 use exactly this f and x-range | confirmed (the attribution to Mathews is not checked) |
| 2 | 12 | "representative steps $h=0.1,0.01,0.001$" | numdiffaa `hs` includes 0.1, 0.01 and 0.001 among 12 values; numdiffab includes 0.1, 0.01 and 0.001 among 12 | confirmed (the scripts use more steps than these three; whether Mathews used these is not checked) |
| 3 | 16–18 | $D_3(x,h) = \frac{f(x+h)-f(x-h)}{2h}$ approximates $f'(x)$ | sympy (`indep.py`): D3 is exact for 1, x and x², and gives error h² for x³, so the degree of precision is 2 | confirmed |
| 4 | 20 | "truncation error $O(h^2)$ when $f$ is sufficiently smooth" | sympy series: D3f − f' = (h²/6) f'''(x) + O(h⁴), with coefficient/f''' = 1/6 exactly. mpmath at x=1 with h halved 0.4→0.003125 gives error ratios 4.010, 4.003, 4.001, …, 4.000 (p = 2.000) | confirmed |
| 5 | 20 | "As $h$ decreases, truncation error improves, but eventually roundoff and cancellation can limit accuracy." | float64 sweep at x=1 (`indep.py`): the error is 1.69e-3, 1.69e-5, 1.69e-7, 1.69e-9 and 1.67e-11 for h = 1e-1 … 1e-5, has its minimum of about 1.7e-11 to 3.3e-11 for h between 1e-5 and 1e-7, then rises to 5.2e-10 (1e-8), 2.6e-8 (1e-9), 1.1e-7 (1e-10), 9.4e-7 (1e-11) and 6.5e-6 (1e-12). The model optimum (3ε\|f\|/\|f'''\|)^{1/3} is 5.9e-6. The animations stop at h = 1e-3, where roundoff (about 1e-13) is invisible, and the page does not claim they show roundoff | confirmed |
| 6 | 24 | "Each animation below shows finite-difference derivative behavior for $f(x)=e^{-x}\sin(x)$" | Both scripts use this f. The numdiffab legend renders only as "f" (see the checks), but the function is right | confirmed ("legacy interval settings from the source module" is attribution and not checked) |
| 7 | 26 | Case 1 heading: "central derivative profile, $D_3(x,h)$ on $[0,\pi]$" | numdiffaa.jl:11 is the central formula. D3 is drawn on [h, π−h] ⊂ [0, π] and f' on [0, π] | confirmed |
| 8 | 28 | "The numerical derivative curve approaches $f'(x)$ as $h$ shrinks" | `aa_values.jl`: max error 0.0681, 0.0277, 0.0128, 3.30e-3, … down to 3.33e-7 for h = 0.5 … 0.001, decreasing in every step. The frames show the gap closing | confirmed |
| 9 | 28 | "consistent with second-order truncation error for the central stencil" | maxerr/h² = 0.272, 0.307, 0.321, 0.330, …, 0.333333, which tends to \|f'''(0)\|/6 = 2/6 = 1/3, since the max error sits at x = h, next to x = 0 where \|f'''\| peaks at 2. The computation is consistent. However, the GIF's only error readout is clipped and shows false values in frames 9–12 | confirmed for the computation; the animation does not show it (→ F1, F3) |
| 10 | 30 | Case 1 link "[Julia source](numdiffaa.jl)" | the file exists and produces numdiffaa.gif, which is byte-identical to the committed GIF (manifest) | confirmed |
| 11 | 32 | Alt: "Animation comparing the three-point central derivative approximation against the true derivative over 0 to pi as h decreases." | frames 1–12: black f'(x) and blue D3(x,h) on [0, π], with h going 0.5 → 0.001 | confirmed |
| 12 | 34 | Case 2 heading: "secant to tangent at $x_0=1$, $h \to 0$" | numdiffab.jl:11 sets x0 = 1.0, and hs decreases from 0.6 to 0.001 | confirmed |
| 13 | 36 | "The slope from the symmetric secant $(f(x_0+h)-f(x_0-h))/(2h)$" | numdiffab.jl:33 computes exactly this. I checked the values independently (h = 0.6 gives −0.0493537) | confirmed for the slope; the line drawn as "the secant" is not the secant chord (→ F2) |
| 14 | 36 | "converges to the tangent slope $f'(x_0)$ as the stencil contracts" | `ab_values.jl`: error 6.14e-2, 2.72e-2, 1.06e-2, 3.81e-3, 1.69e-3, …, 1.69e-5 (h=0.01), 1.69e-7 (h=0.001). The h=0.1 → 0.01 ratio is 100, so second order. f'(1) = −0.110793765 independently (mpmath, and mp.diff agrees) | confirmed |
| 15 | 38 | Case 2 link "[Julia source](numdiffab.jl)" | the file exists and produces numdiffab.gif, byte-identical to the committed GIF | confirmed |
| 16 | 40 | Alt: "central secant lines collapsing to the tangent line at x0 equals 1 for f of x equals e to the minus x times sine x" | The dashed line converges to the tangent (frames 9–12 overlap). But the dashed line is the tangent-anchored line with the secant's slope, not the secant through the stencil points | wrong in part (→ F2) |
| 17 | 46–48 | $f(x\pm h) = f(x) \pm h f'(x) + \frac{h^2}{2}f''(x) \pm \frac{h^3}{6}f^{(3)}(\xi_\pm)$ | This is Taylor's theorem with the Lagrange remainder of order 3. The signs are right: (±h)³ = ±h³ | confirmed |
| 18 | 50 | "which leads to the central three-point first-derivative rule with error proportional to $h^2$" | Subtracting gives D3 − f' = (h²/12)(f'''(ξ+) + f'''(ξ−)) = (h²/6) f'''(ξ). sympy's leading coefficient is 1/6 | confirmed |

## Implementation checks

### numdiffaa.jl
- **Method:** The three-point central difference (f(x+h) − f(x−h))/(2h) (line 11). This is the method in the title, the heading and the Description. The true derivative fp(x) = e^{-x}(cos x − sin x) (line 9) is correct: sympy gives f' = √2 e^{-x} cos(x+π/4), and the difference simplifies to 0.
- **Numbers:** These are the max \|D3 − f'\| values over 700 points in [h, π−h]. Script values (`aa_values.jl`) are shown beside independent reasoning: the error is about (h²/6)\|f'''(ξ)\|, the max is at x = h, and f'''(0) = 2 (sympy), so the max error should be about h²/3.

  | h | script maxerr | h²/3 | ratio maxerr/h² |
  |---|---|---|---|
  | 0.5 | 6.8065e-2 | 8.333e-2 | 0.2723 |
  | 0.1 | 3.2995e-3 | 3.333e-3 | 0.32995 |
  | 0.01 | 3.3330e-5 | 3.333e-5 | 0.333297 |
  | 0.001 | 3.3333e-7 | 3.333e-7 | 0.333333 |

  At large h the ratio falls below 1/3 because f''' is evaluated at ξ inside [0, 2h], where \|f'''\| < 2. The values agree with the second-order theory. At x = 1, high-precision halving gives an observed order p of 2.0036, 2.0009, 2.0002, … → 2.0000.
- **Reference values:** fp is exact (checked with sympy). No numeric reference is used.
- **Picture:** I looked at the contact sheet and at frames 1, 7, 9, 10, 11 and 12 full size. Black f' is drawn on [0, π] and blue D3 on [h, π−h]. In frame 1 there is a visible gap near x = 0.5, which is the largest error, consistent with the max at x = h. By frame 4 (h = 0.1) the curves overlap. The y-limits (−1, 1.1) contain both curves, and there is no clamping. Problem: the title is clipped on the right in all 12 frames, and in frames 9–12 the clipping turns 3.3e-5, 8.0e-6, 1.0e-6 and 0.0 into "3.3", "8.0", "1.0" and "0" (F1). The six-decimal rounding also distorts the small values (F3). There are 12 frames, one per h, and none is skipped.

### numdiffab.jl
- **Method:** Central difference slope msec = (f(x0+h) − f(x0−h))/(2h) at x0 = 1 (line 33). This matches the method on the page. The `continue` guard (line 25) never fires, because x0 ± 0.6 lies inside [0, π], so all 12 h values produce frames.
- **Numbers:** Script value (`ab_values.jl`) beside the independent value. f'(1) = −0.1107937653 (script) and −0.110793765306699 (mpmath; mp.diff agrees). The errors msec − f'(1) are 6.144e-2 (0.6), 2.720e-2 (0.4), 1.060e-2 (0.25), 1.695e-3 (0.1), 1.694e-5 (0.01) and 1.694e-7 (0.001). They match the independent high-precision errors at x=1 from `indep.py` (1.6948e-3 at h=0.1, 6.78e-3 at h=0.2, …). The leading term (h²/6) f'''(1) = (h²/6)(1.016652) gives 1.6944e-3 at h = 0.1, which agrees.
- **Reference values:** The tangent slope fp(1) is exact.
- **Picture:** I looked at the contact sheet and at frames 1 and 12 full size. The red tangent passes through (1, f(1)) = (1, 0.3096) with slope −0.1108, which is correct. The orange stencil points sit at x0−h, x0 and x0+h on the curve, which is correct. The dashed "central secant slope" line has the correct slope but is anchored at (x0, f(x0)), not at the stencil points, so it misses the outer orange points at large h (F2). The title is clipped, so "true = …" loses digits (F4). The legend label "f(x) = e^{-x} sin(x)" renders as just "f" in the GR output. That is cosmetic: the page names the function, and nothing false is shown, so it is not raised as a finding. The y-limits (−0.1, 0.55) contain every drawn line, and there is no clamping.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/numerical-differentiation/`](evidence/numerical-differentiation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
