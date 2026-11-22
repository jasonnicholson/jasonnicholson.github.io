# Derive Numerical Differentiation Formulae — animation review (round 4)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the Derivation Notes say five-point formulas are O(h^4) without saying which derivatives

- **Location:** `index.qmd` line 60: "Including $x\pm2h$ adds degrees of freedom and yields five-point formulas with $O(h^4)$ truncation behavior for smooth $f$."
- **What is there:** a general statement that the five-point formulas are O(h^4).
- **What is true:** the five-point central formulas are O(h^4) only for f' and f''. On the same five points, the formulas for f''' and f'''' are only O(h^2). The legacy module derives all four together and points this out as "one of the many surprises in the theory of numerical analysis". A reader who takes the sentence at face value comes away with the wrong rule.
- **How I know:** `indep.py` solves the Taylor moment system for the offsets {-2,-1,0,1,2}:
  - f': weights [1/12, -2/3, 0, 2/3, -1/12], order h^4, leading term -1/30 f^(5)
  - f'': weights [-1/12, 4/3, -5/2, 4/3, -1/12], order h^4, leading term -1/90 f^(6)
  - f''': weights [-1/2, 1, 0, -1, 1/2], **order h^2**, leading term 1/4 f^(5)
  - f'''': weights [1, -4, 6, -4, 1], **order h^2**, leading term 1/6 f^(6)

  The legacy image gr_198 shows the same result: f''' has a "-1/4 h^2 f^(5)[c]" remainder and f'''' has "-1/6 h^2 f^(6)[c]".
- **Correction:** "...yields five-point formulas for $f'$ and $f''$ with $O(h^4)$ truncation error for smooth $f$ (the five-point formulas for $f'''$ and $f^{(4)}$ are only $O(h^2)$)."

No other findings. I found no Error and nothing Misleading.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 7.1 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 8.9 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 9.4 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Where | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description ¶1 | central finite-difference formulas are "derived from Taylor expansions and solved in parallel as small linear systems" | The legacy module does exactly this. `indep.py` reproduces it: solving the moment system gives the script's weights. | confirmed |
| 2 | Description ¶1 | "The legacy module emphasizes deriving first- and second-derivative formulas together" | Legacy text: "parallel development of the formulas for [f'] and [f'']". The five-point section also covers f''' and f''''. | confirmed |
| 3 | Description ¶2 | for symmetric stencils, terms cancel and give "compact formulas with clear error orders" | The central weights are antisymmetric for odd-order derivatives and symmetric for even-order ones, and the orders come out even (see F1). | confirmed |
| 4 | Description ¶2 | "three-point and five-point formulas explain why wider stencils can significantly improve accuracy" | Case 2 and 3 numbers: at h=0.002, err5 is 2.2e-13 against err3 6.8e-7. | confirmed |
| 5 | Animations intro | every animation uses $f(x)=e^{-x}\sin x$ | Line 8 or 9 of each script: `f(x) = exp(-x) * sin(x)` | confirmed |
| 6 | Animations intro | Case 1 shows the three-point first-derivative formula | `diffformaa.jl` line 11 | confirmed |
| 7 | Animations intro | Cases 2 and 3 compare the 3-point and 5-point stencils for f' and f'' respectively | `diffformab.jl` lines 12–13 and `diffformac.jl` lines 12–13 | confirmed |
| 8 | Animations intro | "The legacy module derives the formulas symbolically and has no numerical example" | Archive text and every graph-sized image: Mathematica code and formula output only | confirmed |
| 9 | Case 1 heading | $f'(x_0)\approx\frac{f(x_0+h)-f(x_0-h)}{2h}$ | `d1_3` in the script is the same expression. sympy gives weights [-1/2, 0, 1/2]/h. | confirmed |
| 10 | Case 1 (alt) | $x_0 = 1$ | `x0 = 1.0` | confirmed |
| 11 | Case 1 Behavior | "symmetric three-point slope converges to the tangent slope as h decreases" | The error falls monotonically: 6.144e-2, 2.720e-2, … 1.694e-7 over h = 0.6 … 0.001 (Julia and mpmath agree) | confirmed |
| 12 | Case 1 Behavior | "reflecting second-order accuracy" | err/h² = 0.17067, 0.17001, 0.16967, … 0.169442, which tends to f'''(1)/6 = 0.169442 | confirmed |
| 13 | Case 1 alt | the GIF shows "three-point central stencil points and slope line converging to the tangent at x0 equals 1" | Frames 1–12 show orange points at x0−h, x0, x0+h, and the dashed line merges into the red tangent | confirmed |
| 14 | Case 1 wiring | the link and embed are `diffformaa.jl` and `diffformaa.gif` | The script writes `diffformaa.gif`. The committed GIF is byte-identical to the regenerated one. | confirmed |
| 15 | Case 2 heading | $f'(x_0)\approx\frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}$ | `d1_5` is the same expression. sympy weights: [1/12, -2/3, 0, 2/3, -1/12]. | confirmed |
| 16 | Case 2 Behavior | "its error drops faster than the three-point estimate for the same h" | For every h, err5 < err3. err5/h⁴ tends to -0.014772 = -f^(5)(1)/30, and err3/h² tends to 0.1694. | confirmed |
| 17 | Case 2 Behavior | "the green five-point line already lies on the red true tangent at h=0.35" | Frame 1: the green line lies on the thick red line | confirmed |
| 18 | Case 2 Behavior | the lines "differ by about 0.1 pixel at their ends" at h=0.35 | max\|l5−lt\| = 1.7273e-4 y-units (instrumented run). The plot box runs from pixel row 26 to row 417 for 0.65 units, which is 601.5 px/unit. That makes the gap **0.104 px**. | confirmed |
| 19 | Case 2 Behavior | the five-point error is "read from the \|err5\| value printed in each frame" | Every frame shows `\|err5\|≈`: 1.92e-04, 5.38e-05, 1.50e-05, 3.02e-06, 6.01e-07, 9.21e-08, 1.20e-08, 2.36e-09, 1.48e-10, 9.24e-12, 2.16e-13. mpmath gives 1.919e-4, 5.376e-5, 1.496e-5, 3.015e-6, 6.009e-7, 9.208e-8, 1.195e-8, 2.363e-9, 1.477e-10, 9.233e-12, 2.364e-13. The last value differs only because of rounding. | confirmed |
| 20 | Case 2 alt | "five-point stencil samples, the dashed three-point slope line approaching the true tangent, and the five-point slope line lying on the true tangent in every frame…, with both errors printed" | All 11 frames show this | confirmed |
| 21 | Case 2 wiring | the link and embed are `diffformab.jl` and `diffformab.gif` | Byte-identical to the regenerated GIF | confirmed |
| 22 | Case 3 heading / Behavior | the stencil curves are on $[2h,\pi-2h]$ | `xinner = range(2h, pi-2h)`. The instrumented run printed matching endpoints for every h. | confirmed |
| 23 | Case 3 Behavior | "both stencils use only points in $[0,\pi]$" | The instrumented run printed a minimum stencil abscissa of 0.0 and a maximum of 3.14159… for every h | confirmed |
| 24 | Case 3 Behavior | "the maximum errors in each frame are taken over this window" | `err3` and `err5` are maxima over `xinner`, which includes both endpoints. The maximum sits at x=2h for h ≥ 0.005. | confirmed |
| 25 | Case 3 Behavior | "From h=0.35 to h=0.005 both maximum errors shrink" | err3: 1.306e-2 → 2.687e-6, monotone. err5: 5.158e-4 → 5.516e-11, monotone. These are the Julia values; mpmath on the same grid gives 1.306e-2 → 2.687e-6 and 5.158e-4 → 5.500e-11. | confirmed |
| 26 | Case 3 Behavior | "the five-point stencil stays closer in every frame" | err5 < err3 in all 11 frames. With mpmath I also checked pointwise on the 700-point grid for h = 0.35, 0.25, 0.12, 0.05, 0.01 and 0.002, and |e5| < |e3| held at every point. | confirmed |
| 27 | Case 3 Behavior | "At h=0.002 the five-point maximum error rises slightly, from 5.5e-11 to 5.9e-11" | Julia: 5.516e-11 at h=0.005 and 5.892e-11 at h=0.002. The frames print 5.52e-11 and 5.89e-11. | confirmed |
| 28 | Case 3 Behavior | the rise happens "because floating-point rounding now outweighs its truncation error" | The truncation-only maximum (mpmath) is 5.500e-11 at h=0.005 and 1.417e-12 at h=0.002. The double-precision 5.89e-11 at h=0.002 is therefore about 40 times the truncation error, so it is rounding. Its location also moves off the endpoint, to x≈0.784. | confirmed |
| 29 | Case 3 alt | "exact curve on 0 to pi and the stencil curves on 2h to pi minus 2h" | `xtrue` runs from 0 to π. `xinner` is as in row 22. Frame 1 shows the stencil curves starting at x=0.7. | confirmed |
| 30 | Case 3 wiring | the link and embed are `diffformac.jl` and `diffformac.gif` | Byte-identical to the regenerated GIF | confirmed |
| 31 | Derivation Notes | $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f'''+\cdots$ | Standard Taylor series. The signs and factorials are correct. | confirmed |
| 32 | Derivation Notes | $f'=\frac{f(x+h)-f(x-h)}{2h}+O(h^2)$ and $f''=\frac{f(x+h)-2f(x)+f(x-h)}{h^2}+O(h^2)$ | sympy: weights [-1/2, 0, 1/2] with leading term h²/6 f''', and [1, -2, 1] with leading term h²/12 f'''' | confirmed |
| 33 | Derivation Notes | the five-point formulas have $O(h^4)$ truncation | True for f' and f'' (sympy, and the Case 2 and 3 error ratios). False for the five-point f''' and f'''' formulas, which are O(h^2). | wrong as a general statement (F1) |

---

### 3. Implementation checks

### `diffformaa.jl`: three-point f' at x0=1
- **Method:** `d1_3(x,h) = (f(x+h)-f(x-h))/(2h)` is the centred three-point formula. The weights match the ones sympy derived from the moment system.
- **Numbers:** the Julia values from the instrumented run agree with the 50-digit mpmath values to all printed digits. For h=0.6, approx is -0.0493537427 in both. For h=0.001, Julia gives -0.1107935959 and mpmath -0.1107935959. The full table is in `indep.out` and `diffformaa.out`. err/h² tends to 0.169442 = f'''(1)/6, so the method is second order.
- **Reference:** `fp(x) = e^{-x}(cos x − sin x)`. sympy confirms it equals d/dx(e^{-x} sin x). fp(1) = -0.110793765307.
- **Picture:** the orange points are at (x0∓h, f(x0∓h)) and (x0, f(x0)); the printed `xl`/`xr` match. The red tangent passes through (1, 0.30956) with slope fp(1). The dashed "formula slope" line passes through (x0, f(x0)) with the computed slope. It is parallel to the secant through the outer points, not that secant itself; the legend says "formula slope", so this is a valid depiction. The title shows the current h. The annotation shows approx and exact to 6 digits, which matches the computed values. All lines stay inside ylims (-0.1, 0.55); the line extrema are in the 0.21–0.41 range. The legend does not cover any element. There are 12 frames, one per h.

### `diffformab.jl`: five-point f' at x0=1
- **Method:** `d1_5` = (f(x−2h) − 8f(x−h) + 8f(x+h) − f(x+2h))/(12h). Its weights match sympy's derived set, with leading error −h⁴/30 f^(5).
- **Numbers:** err3 and err5 agree with mpmath at every h (table in row 19 of the ledger). err5/h⁴ tends to −0.0147725, and −f^(5)(1)/30 = −0.0147725, so the method is fourth order. At h=0.002 the double-precision err5 is 2.16e-13 against 2.36e-13 in exact arithmetic. The page makes no claim about that last value.
- **Reference:** the same fp as in Case 1, confirmed.
- **Picture:** the five stencil points are drawn at the printed `xs`, for example [0.3, 0.65, 1, 1.35, 1.7] at h=0.35. The thick red tangent is drawn first and the green five-point line last; the green line lies on the red one in every frame. The dashed blue three-point line visibly differs at h=0.35 and 0.25 and merges into the tangent later. The annotation shows h, |err3| and |err5| correctly. The code comment at line 56 ("differ by at most |err5| = 1.92e-4") is correct. There are 11 frames.

### `diffformac.jl`: three-point and five-point f'' profiles
- **Method:** `d2_3` = (f(x+h) − 2f(x) + f(x−h))/h². `d2_5` = (−f(x+2h) + 16f(x+h) − 30f(x) + 16f(x−h) − f(x−2h))/(12h²). Both match the sympy-derived weights, with orders h² and h⁴.
- **Numbers:** on the script's own 700-point grid, the Julia max errors match mpmath for every h down to 0.005; values are in ledger rows 25–28. At h=0.002, err5 is set by rounding (5.89e-11 against a truncation of 1.42e-12), as the page says.
- **Reference:** `fpp(x) = −2e^{-x}cos x`. sympy confirms it equals the second derivative of e^{-x} sin x. The plotted range is −2 to 0.134, inside ylims (−2.1, 0.2).
- **Picture:** the black f'' curve spans [0, π]. The blue dashed and green curves span [2h, π−2h]; at h=0.35 they start visibly at x=0.7. In frame 1 the legend's top edge lies along the flat top of the curves (x≈2.45–3.04). I cropped and checked the frames (`review/c3_legend_001.png` and `review/c3_legend_003.png`). The curves are drawn over the legend border and their right ends stay visible, so nothing the page discusses is hidden. After frame 1 the three curves cannot be told apart, but the page directs the reader to the printed maxima, which are correct. There are 11 frames.

### Wiring and regeneration
All three scripts run cleanly from scratch copies (exit 0), and each regenerated GIF is byte-identical to the committed one (manifest). The page links and embeds the matching script and GIF for each case.

