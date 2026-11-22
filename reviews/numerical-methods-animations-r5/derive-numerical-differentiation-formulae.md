# Derive Numerical Differentiation Formulae — animation review (round 5)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors: 0. Misleading: 0. Minor: 0.

Observations that I judged not to be findings (listed so the owner can see they were considered):

- Case 1: the dashed "formula slope" line is drawn through $(x_0, f(x_0))$ with the secant's slope, not through the two outer stencil points. The legend says "formula slope", which is exactly what it is, and the page never calls it a secant. Not misleading.
- Case 3: from frame 2 on (h ≤ 0.25) the three curves coincide to the pixel (largest 3-point error 6.7e-3 ≈ 1.1 px at ~169 px per y-unit), so the comparison "five-point stays closer" is visible only in the printed maximum errors. The page attributes the comparison to "the maximum errors in each frame", so nothing is claimed that the picture contradicts.
- Case 3: the legend box covers the curves for roughly x in [2.45, 3.0] near y ≈ 0.1. Neither error maximum is there (3-point maximum at x ≈ 0.785, 5-point at x = 2h), so nothing the page discusses is hidden.
- Case 2: at h = 0.002 the printed |err5| ≈ 2.16e-13 is the real float64 error; truncation alone gives 2.36e-13, so rounding already affects the second digit. The page makes no claim about this frame's value.
- Case 1 annotation prints `-0.11079` at h = 0.005 because `round(...; digits=6)` drops a trailing zero (true value -0.1107895). Cosmetic.
- Fidelity: the Mathews module also covers forward and backward difference formulas and higher-order central formulas. The page covers central formulas only, and the module has no numerical example to drop. That is content the page does not have yet, not a departure. The page's statement that the legacy module "derives the formulas symbolically and has no numerical example" is accurate (see ledger).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 7.1 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 8.3 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 10.3 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `diffformaa.gif` | 12 | byte-identical | diffformaa |
| `diffformab.gif` | 11 | byte-identical | diffformab |
| `diffformac.gif` | 11 | byte-identical | diffformac |

### Page references

- Scripts linked: `diffformaa.jl`, `diffformab.jl`, `diffformac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description ¶1 | "central finite-difference formulas are derived from Taylor expansions and solved in parallel as small linear systems" | Archive: "parallel development of the formulas. It requires the solution of a 'linear system'"; gr_128 shows the four Taylor equations solved for f', f'', f''', f⁽⁴⁾. My `indep.py` derives the same stencils that way. | confirmed |
| D2 | Description ¶1 | "The legacy module emphasizes deriving first- and second-derivative formulas together rather than treating each formula as an isolated trick." | Archive text: traditional derivations "are done independently as if there was no connection ... This new approach gives a parallel development". | confirmed |
| D3 | Description ¶2 | "For symmetric stencils, odd and even Taylor terms cancel in predictable ways, producing compact formulas with clear error orders." | `indep.py`: all central stencils have only even powers of h in the error (h², h⁴). | confirmed |
| D4 | Description ¶2 | "three-point and five-point formulas explain why wider stencils can significantly improve accuracy for smooth functions" | Case 2 / Case 3 numbers: err5 is 100× to 3×10⁶ smaller than err3 at the same h. | confirmed |
| A1 | Animations intro | All animations use $f(x)=e^{-x}\sin(x)$ | `f(x) = exp(-x) * sin(x)` in all three scripts (line 8/9/9). | confirmed |
| A2 | Animations intro | "Case 1 shows the three-point first-derivative formula, and Cases 2 and 3 compare the three-point and five-point stencils for the first and the second derivative" | Case 2 script plots both `d1_3` and `d1_5`; Case 3 plots `d2_3` and `d2_5`. | confirmed |
| A3 | Animations intro | "The legacy module derives the formulas symbolically and has no numerical example" | Main page and lnk_1..3 contain only Mathematica derivations and subroutines (CentralDiff, ForwardDiff); no function, no h, no numbers. Graph-sized images are code/output listings. | confirmed |
| C1-1 | Case 1 heading | $f'(x_0) \approx \frac{f(x_0+h)-f(x_0-h)}{2h}$ | `d1_3` (aa.jl:11) is exactly this; `indep.py` derives coefficients [-1/2, 1/2]. | confirmed |
| C1-2 | Case 1 Behavior | "converges to the tangent slope as h decreases" | Script approx: -0.04935 (h=0.6) → -0.1107936 (h=0.001); exact f'(1) = -0.1107937653. Error decreases monotonically over all 12 frames. | confirmed |
| C1-3 | Case 1 Behavior | "reflecting second-order accuracy" | err/h² = 0.17067 (h=0.6) … 0.169442 (h=0.001) → f'''(1)/6 = 0.1694420 (mpmath). | confirmed |
| C1-4 | Case 1 alt text | "three-point central stencil points and slope line converging to the tangent at x0 equals 1" | x0 = 1.0 (aa.jl:13); frames show orange points at x0−h, x0, x0+h, dashed line converging onto red tangent (frames 1, 5, 12 viewed). | confirmed |
| C1-5 | Case 1 wiring | link `diffformaa.jl`, embed `diffformaa.gif` | Script writes `diffformaa.gif`; committed GIF byte-identical to regenerated one (manifest); 12 frames = 12 values of h. | confirmed |
| C2-1 | Case 2 heading | $f'(x_0) \approx \frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}$ | `d1_5` (ab.jl:13) is exactly this; `indep.py` derives [1/12, -2/3, 2/3, -1/12] = [1,-8,8,-1]/12. | confirmed |
| C2-2 | Case 2 Behavior | "its error drops faster than the three-point estimate for the same h" | err5/h⁴ → 0.014772 = |f⁽⁵⁾(1)|/30 (fourth order) vs err3/h² → 0.16944 (second order); err5 < err3 at every h (e.g. 1.92e-4 vs 2.08e-2 at h=0.35). | confirmed |
| C2-3 | Case 2 Behavior | "the green five-point line already lies on the red true tangent at h=0.35" | Frame 1: green line visible inside the wider red line along its whole length. | confirmed |
| C2-4 | Case 2 Behavior | "where the two lines differ by about 0.1 pixel at their ends" | Plot box rows 26–416.5 for y-range 0.65 → 600.8 px per y-unit; end offset = 1.919e-4 × 0.9 × 600.8 = 0.104 px. | confirmed |
| C2-5 | Case 2 Behavior | "the size of the five-point error is read from the |err5| value printed in each frame" | Annotation (ab.jl:61–70) prints |err3| and |err5| each frame; printed values match mpmath to 3 sig. figs. for h ≥ 0.005 (table in §3). | confirmed |
| C2-6 | Case 2 alt text | "five-point stencil samples, the dashed three-point slope line approaching the true tangent, and the five-point slope line lying on the true tangent in every frame as h decreases, with both errors printed" | All 11 frames viewed on contact sheet + frames 1 and 11: five orange points; dashed blue converges; green on red throughout; both errors printed. | confirmed |
| C2-7 | Case 2 wiring | link `diffformab.jl`, embed `diffformab.gif` | Byte-identical regeneration; 11 frames = 11 values of h. | confirmed |
| C3-1 | Case 3 heading | "Second-derivative formulas on [2h, π−2h]" | `xinner = range(2h, π−2h, length=700)` (ac.jl:23); instrumented endpoints e.g. 0.7, 2.4416 at h=0.35. | confirmed |
| C3-2 | Case 3 Behavior | compares $f''(x)$ against three-point and five-point second-derivative stencils | `fpp = -2e^{-x}cos x` = sympy f''; `d2_3` = [1,-2,1]/h², `d2_5` = [-1,16,-30,16,-1]/(12h²) = derived [-1/12, 4/3, -5/2, 4/3, -1/12]. | confirmed |
| C3-3 | Case 3 Behavior | "where both stencils use only points in [0,π]" | 5-point at x=2h uses x−2h = 0; at π−2h uses π. 3-point needs only [h, π−h]. | confirmed |
| C3-4 | Case 3 Behavior | "the maximum errors in each frame are taken over this window" | `err3/err5 = maximum(abs.(… fpp.(xinner)))` over the 700-point window (ac.jl:29–30). Sampled max equals a 4001-point dense max to 4 sig. figs. at every h (mpmath). | confirmed |
| C3-5 | Case 3 Behavior | "From h=0.35 to h=0.005 both maximum errors shrink" | err3: 1.31e-2 → 2.69e-6, monotone; err5: 5.16e-4 → 5.52e-11, monotone (script and mpmath agree). | confirmed |
| C3-6 | Case 3 Behavior | "the five-point stencil stays closer in every frame" | err5 < err3 in all 11 frames (smallest ratio 25 at h=0.35). | confirmed |
| C3-7 | Case 3 Behavior | "because it cancels lower-order truncation terms" | Derived leading errors: h²/12·f⁽⁴⁾ (3-pt) vs −h⁴/90·f⁽⁶⁾ (5-pt). | confirmed |
| C3-8 | Case 3 Behavior | "At h=0.002 the five-point maximum error rises slightly, from 5.5×10⁻¹¹ to 5.9×10⁻¹¹" | Script: 5.516e-11 (h=0.005) → 5.892e-11 (h=0.002). | confirmed |
| C3-9 | Case 3 Behavior | "because floating-point rounding now outweighs its truncation error" | mpmath truncation-only max at h=0.002 = 1.42e-12, ≈ 40× smaller than the float64 5.89e-11; its location moves from the window edge x=2h (truncation-dominated, h ≤ 0.005) to an interior point x ≈ 0.784 (noise). At h=0.005 truncation-only 5.50e-11 ≈ float 5.52e-11. | confirmed |
| C3-10 | Case 3 alt text | "exact curve on 0 to pi and the stencil curves on 2h to pi minus 2h" | `xtrue` on [0,π], `xinner` on [2h,π−2h]; frame 1 shows stencil curves starting at x=0.7. | confirmed |
| C3-11 | Case 3 wiring | link `diffformac.jl`, embed `diffformac.gif` | Byte-identical regeneration; 11 frames = 11 values of h. | confirmed |
| N1 | Derivation Notes | $f(x\pm h)=f \pm hf' + \frac{h^2}{2}f'' \pm \frac{h^3}{6}f''' + \cdots$ | Taylor series; signs and factorials correct. | confirmed |
| N2 | Derivation Notes | $f'(x)=\frac{f(x+h)-f(x-h)}{2h}+O(h^2)$ | `indep.py`: order h², lead 1/6·f'''. | confirmed |
| N3 | Derivation Notes | $f''(x)=\frac{f(x+h)-2f(x)+f(x-h)}{h^2}+O(h^2)$ | `indep.py`: order h², lead 1/12·f⁽⁴⁾. | confirmed |
| N4 | Derivation Notes | five-point formulas for f′ and f″ have $O(h^4)$ truncation error | `indep.py`: order h⁴ for both. | confirmed |
| N5 | Derivation Notes | "the five-point formulas for f‴ and f⁽⁴⁾ are only O(h²)" | `indep.py`: f‴ stencil [-1/2,1,0,-1,1/2]/h³ order h²; f⁽⁴⁾ stencil [1,-4,6,-4,1]/h⁴ order h². Archive says the same. | confirmed |
| W1 | Section index | page linked from the numerical-methods index | `pages/numerical-methods/index.qmd:93`. | confirmed |

### 3. Implementation checks

### `diffformaa.jl` (Case 1)

- **Method:** `d1_3(x,h) = (f(x+h) − f(x−h))/(2h)`, the three-point central first-derivative formula, the one named in the heading. Coefficients match an independent solve of the Taylor moment system ([-1/2, 1/2], error h²/6·f‴).
- **Numbers:** script (instrumented, float64) vs mpmath (50 digits):

| h | script approx | mpmath approx | |err| | err/h² |
|---|---|---|---|---|
| 0.6 | -0.0493537427 | -0.049353742675 | 6.144e-2 | 0.17067 |
| 0.25 | -0.1001894114 | -0.10018941139 | 1.060e-2 | 0.16967 |
| 0.1 | -0.1090989768 | -0.109098976848 | 1.695e-3 | 0.16948 |
| 0.03 | -0.1106412645 | -0.11064126452 | 1.525e-4 | 0.16944 |
| 0.005 | -0.1107895293 | -0.110789529255 | 4.236e-6 | 0.16944 |
| 0.001 | -0.1107935959 | -0.110793595865 | 1.694e-7 | 0.16944 |

All 12 agree to ≥ 10 digits; err/h² → f‴(1)/6 = 0.1694420, i.e. order 2.
- **Reference:** `fp(x) = e^{-x}(cos x − sin x)` equals sympy's f′ = √2 e^{-x} cos(x+π/4); f′(1) = -0.11079376530669926 (mpmath) vs script -0.11079376530669924.
- **Picture:** frames 1, 5, 12 and the contact sheet viewed. Orange points at (x0∓h, f), (x0, f(x0)) with correct coordinates (e.g. h=0.6: (0.4, 0.2610), (1.6, 0.2018)); dashed line through (x0, f(x0)) with slope `approx`; red tangent with slope `fp(x0)`; title h and annotation values match the instrumented values. Axis limits contain everything; no clamping. 12 frames for 12 h values.

### `diffformab.jl` (Case 2)

- **Method:** `d1_5` = [f(x−2h) − 8f(x−h) + 8f(x+h) − f(x+2h)]/(12h), the five-point central first-derivative formula; independently derived coefficients [1/12, −2/3, 2/3, −1/12], error −h⁴/30·f⁽⁵⁾. `d1_3` as in Case 1.
- **Numbers:** printed errors vs mpmath:

| h | script |err3| | mpmath |err3| | script |err5| | mpmath |err5| | mpmath err5/h⁴ |
|---|---|---|---|---|---|
| 0.35 | 2.08e-02 | 2.081e-2 | 1.92e-04 | 1.919e-4 | 0.01279 |
| 0.18 | 5.49e-03 | 5.494e-3 | 1.50e-05 | 1.496e-5 | 0.01425 |
| 0.08 | 1.08e-03 | 1.085e-3 | 6.01e-07 | 6.009e-7 | 0.01467 |
| 0.03 | 1.53e-04 | 1.525e-4 | 1.20e-08 | 1.195e-8 | 0.01476 |
| 0.01 | 1.69e-05 | 1.694e-5 | 1.48e-10 | 1.477e-10 | 0.01477 |
| 0.005 | 4.24e-06 | 4.236e-6 | 9.24e-12 | 9.233e-12 | 0.01477 |
| 0.002 | 6.78e-07 | 6.778e-7 | 2.16e-13 | 2.364e-13 | 0.01477 |

err5/h⁴ → |f⁽⁵⁾(1)|/30 = 0.0147725: order 4. At h=0.002 float rounding (~2e-14) shifts the printed |err5|; the printed value is the true error of the float64 computation.
- **Reference:** same `fp` as Case 1, verified.
- **Picture:** stencil points `xs = x0 + [−2,−1,0,1,2]h` (instrumented: h=0.35 → 0.30, 0.65, 1.0, 1.35, 1.70; frame 1 shows these). Three lines through (x0, f(x0)) with slopes approx3, approx5, exact. Tangent drawn wider (lw 5) and first so the green five-point line is visible on it. Pixel scale 600.8 px/y-unit, so the five-point/tangent offset is 0.10 px at the line ends at h=0.35 and smaller afterwards; the script comment's bound "|err5| = 1.92e-4" is the largest |err5| across frames. 11 frames for 11 h values.

### `diffformac.jl` (Case 3)

- **Method:** `d2_3` = [f(x+h) − 2f(x) + f(x−h)]/h² and `d2_5` = [−f(x+2h) + 16f(x+h) − 30f(x) + 16f(x−h) − f(x−2h)]/(12h²), the three- and five-point central second-derivative formulas; match independently derived [1,−2,1] (error h²/12·f⁽⁴⁾) and [−1/12, 4/3, −5/2, 4/3, −1/12] (error −h⁴/90·f⁽⁶⁾).
- **Numbers:** max errors over the 700-point window, script (float64) vs mpmath on the same grid:

| h | script err3 | mpmath err3 | script err5 | mpmath err5 (truncation only) |
|---|---|---|---|---|
| 0.35 | 1.31e-02 | 1.306e-2 | 5.16e-04 | 5.158e-4 |
| 0.12 | 1.55e-03 | 1.546e-3 | 1.41e-05 | 1.409e-5 |
| 0.05 | 2.69e-04 | 2.686e-4 | 5.00e-07 | 5.002e-7 |
| 0.02 | 4.30e-05 | 4.299e-5 | 1.37e-08 | 1.365e-8 |
| 0.01 | 1.07e-05 | 1.075e-5 | 8.71e-10 | 8.711e-10 |
| 0.005 | 2.69e-06 | 2.687e-6 | 5.52e-11 | 5.50e-11 |
| 0.002 | 4.30e-07 | 4.299e-7 | 5.89e-11 | 1.417e-12 |

All 11 h agree except err5 at h=0.002, where the float64 value is rounding-dominated, as the page says. A 4001-point dense grid gives the same maxima to 4 significant figures, so the 700-point sampling does not understate them. err5 ratio h=0.01→0.005: 15.8 ≈ 2⁴; err3 ratio: 4.0 ≈ 2².
- **Reference:** `fpp = −2e^{-x}cos x` equals sympy's f″; plotted on [0, π] with 900 points (min −2.0 at x=0, max 0.13404, both inside ylims (−2.1, 0.2)).
- **Picture:** frames 1, 11 and the contact sheet viewed. Black exact curve on [0,π]; stencil curves start at x=2h (0.7 in frame 1) and end at π−2h; title h and annotation values match the instrumented values. ylims contain every curve (instrumented min of the stencil curves ≥ −1.992, max ≤ 0.1340). No clamping or masking. 11 frames for 11 h values.

### Regeneration

Per the manifest, scratch copies of all three unchanged scripts exit 0 and reproduce the committed GIFs byte-for-byte, so the frames reviewed are what the current scripts produce.

