# Derive Numerical Differentiation Formulae — animation review (round 2)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Case 2: the green "five-point estimate" line is never visible; the true tangent covers it in every frame
- **Kind:** Implementation (picture shows what was computed) / page match
- **Severity:** Minor
- **Location:** `diffformab.jl` lines 56-57 (`plot!(line_x, l5; color=:darkgreen, ...)` followed by `plot!(line_x, lt; color=:crimson, ...)`). Page alt text: "Animation showing five-point stencil samples and comparison of three-point versus five-point slope estimates as h decreases."
- **What is there now:** The five-point line is drawn first and the crimson tangent is drawn on top of it. The two slopes differ by at most 1.92e-4 (h = 0.35), which is about 0.1 px over the drawn segment, so the tangent hides the green line completely. The legend still lists "five-point estimate" in green, but a viewer sees no green line in any frame. What the viewer can actually compare is the dashed three-point line (visible in frames 1-3 only) against the red tangent. The five-point estimate shows up only in the `|err5|` annotation.
- **How I know:** I counted dark-green pixels (RGB near (0,100,0)) in committed frames 1, 2, 3 and 11 of `diffformab.gif`. Each frame has 47 green pixels, all inside the legend box (x > 520, y < 130), and 0 outside it. The instrumented run gives |err5| = 1.92e-4 at h = 0.35, and the axis scale is about 0.65 y-units over about 380 px.
- **Suggested correction:** Draw the true tangent first (or thinner, or dotted) and the five-point line last, so the green line is visible lying on the tangent. Alternatively, add a sentence saying the five-point line coincides with the tangent at plotting resolution from the first frame on, so the comparison is carried by the |err3|/|err5| annotation.

- **Independent check:** not run (Minor finding, unverified)

### F2. Case 3: "over [0, π]" claims, but the stencil curves and the reported maximum errors cover only [2h, π−2h]
- **Kind:** Page match (and frame title)
- **Severity:** Minor
- **Location:** `index.qmd` line 36, heading "second-derivative formulas on $[0,\pi]$". Line 38: "compare $f''(x)$ against the three-point and five-point second-derivative stencils over $[0,\pi]$". Line 42, alt text: "over 0 to pi". `diffformac.jl` line 47, title "Second-derivative formulas on [0, pi]". Lines 23 and 29-30: `xinner = range(2h, pi-2h)`, and `err3`/`err5` are maxima over `xinner`.
- **What is there now:** The 3-point and 5-point curves are drawn only on [2h, π−2h], which is [0.70, 2.44] at h = 0.35 (frame 1 shows the curves stopping well inside the axes). The "max|error|" annotations are maxima over this same moving window, not over [0, π]. For the five-point stencil the maximum sits at the left end x = 2h in every frame from h = 0.35 to h = 0.005 (argmax5 = 0.70, 0.50, 0.36, ... 0.010). So the reported number depends partly on where the window starts.
- **What is true instead:** The page's qualitative claims still hold on a fixed window. Over [0.7, π−0.7], err3 and err5 both fall from h = 0.35 to h = 0.005, err5 < err3 throughout, and err5 rises at h = 0.002 (2.68e-11 → 6.07e-11). The defect is that the domain is stated wrongly and the annotation's quantity is described imprecisely.
- **How I know:** `julia review/instr.jl` (section C) prints argmax locations and the fixed-window errors. The frames show the curves' extent.
- **Suggested correction:** Say "on $[2h,\pi-2h]$ (where both stencils fit inside $[0,\pi]$)" in the Behavior text and the alt text. Change the GIF title to e.g. "Second-derivative formulas, x in [2h, pi−2h]". Alternatively, evaluate the stencils on all of [0, π], since f is defined outside the interval, so the stated domain becomes true.

No other findings. Every numerical claim on the page agrees with independent computation (see ledger).

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Total: 0 Error, 0 Misleading, 2 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 6.8 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 7.1 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 7.5 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description ¶1 | Central finite-difference formulas are derived from Taylor expansions and solved in parallel as small linear systems | This matches the archive's method (gr_35, gr_128: Solve on the Taylor equations). The scripts hard-code the resulting coefficients, which I verified independently (row 5). | Confirmed (describes the derivation; the scripts apply its result) |
| 2 | Description ¶1 | Legacy module emphasizes deriving first- and second-derivative formulas together | Archive text: "parallel development of the formulas" for f' and f'' | Confirmed |
| 3 | Description ¶2 | Symmetric stencils: odd/even Taylor terms cancel, giving compact formulas with clear error orders | sympy series of each stencil applied to e^{ax}: error series contain only even powers of h | Confirmed |
| 4 | Description ¶2 | Three-point and five-point formulas show wider stencils improve accuracy for smooth f | err5 << err3 at every h in Cases 2 and 3 | Confirmed |
| 5 | Case 1 heading | f'(x0) ≈ (f(x0+h) − f(x0−h))/(2h) | `d1_3` (aa line 11) is exactly this. sympy: exact through degree 2 and not 3, leading error h²f'''/6 | Confirmed |
| 6 | Case 1 alt text | Stencil points and slope line converge to the tangent at x0 = 1 | `x0 = 1.0`. Frames: points x0±h shrink toward x0, dashed line merges with the red tangent by h ≈ 0.1 | Confirmed |
| 7 | Case 1 Behavior | Three-point slope converges to the tangent slope as h decreases | approx: −0.04935 (h = 0.6) → −0.1107936 (h = 0.001); exact f'(1) = −0.110793765306699 (mpmath) | Confirmed |
| 8 | Case 1 Behavior | ...reflecting second-order accuracy | err/h² = 0.17067, 0.17001, ..., 0.16944 (constant), = \|f'''(1)\|/6 = 0.16945 | Confirmed |
| 9 | Case 1 wiring | Link diffformaa.jl, embed diffformaa.gif | The script is the three-point f' case; the GIF is its byte-identical output | Confirmed |
| 10 | Case 2 heading | f'(x0) ≈ [f(x0−2h) − 8f(x0−h) + 8f(x0+h) − f(x0+2h)]/(12h) | `d1_5` (ab line 13) is exactly this. sympy: exact through degree 4 and not 5, error −h⁴f⁽⁵⁾/30; it matches archive gr_193 | Confirmed |
| 11 | Case 2 Behavior | Five-point uses cancellation of lower-order truncation terms | h² term absent from the d1_5 error series | Confirmed |
| 12 | Case 2 Behavior | Its error drops faster than the three-point estimate for the same h | err5 < err3 at all 11 h values (e.g. h = 0.35: 1.92e-4 vs 2.08e-2; h = 0.01: 1.48e-10 vs 1.69e-5). err5/h⁴ ≈ 0.0148 (= \|f⁽⁵⁾(1)\|/30 = 0.01478), so it falls as h⁴ against h² | Confirmed |
| 13 | Case 2 alt text | Shows five-point stencil samples | Five orange points at x0 + {−2,−1,0,1,2}h in the frames | Confirmed |
| 14 | Case 2 alt text | ...and comparison of three-point versus five-point slope estimates as h decreases | The five-point line is never visible (F1). The comparison exists only in the annotation | Wrong in part (F1, Minor) |
| 15 | Case 2 wiring | diffformab.jl / diffformab.gif | Correct case | Confirmed |
| 16 | Case 3 heading / Behavior / alt | "on [0,π]" / "over [0,π]" | Curves and maxima are over [2h, π−2h] | Wrong (F2, Minor) |
| 17 | Case 3 Behavior | Compares f''(x) against the three-point and five-point second-derivative stencils | fpp = −2e^{−x}cos x (sympy diff check: 0). d2_3 is standard; d2_5 = (−f₂ + 16f₁ − 30f₀ + 16f₋₁ − f₋₂)/(12h²). sympy: exact through degree 5 and not 6, error −h⁴f⁽⁶⁾/90; it matches archive gr_193 | Confirmed |
| 18 | Case 3 Behavior | From h = 0.35 to h = 0.005 both maximum errors shrink | Script err3: 1.31e-2, 6.69e-3, 3.47e-3, 1.55e-3, 6.87e-4, 2.69e-4, 9.67e-5, 4.30e-5, 1.07e-5, 2.69e-6. err5: 5.16e-4, 1.86e-4, 6.11e-5, 1.41e-5, 3.06e-6, 5.00e-7, 6.77e-8, 1.37e-8, 8.71e-10, 5.52e-11. Both are monotone decreasing, and the mpmath truncation-only values agree to 3 s.f. | Confirmed |
| 19 | Case 3 Behavior | Five-point stays closer in every frame | err5 < err3 in all 11 frames, including h = 0.002 (5.89e-11 vs 4.30e-7) | Confirmed |
| 20 | Case 3 Behavior | ...because it cancels lower-order truncation terms | See row 17 | Confirmed |
| 21 | Case 3 Behavior | At h = 0.002 five-point max error rises from 5.5e-11 to 5.9e-11 | Script: 5.52e-11 → 5.89e-11 | Confirmed |
| 22 | Case 3 Behavior | ...because floating-point rounding now outweighs its truncation error | Truncation-only max error at h = 0.002 (mpmath, 40 digits) is 1.42e-12, against 5.89e-11 computed in Float64. The argmax also moves from the window edge (x = 2h, the truncation peak) to the interior x = 0.784. At h = 0.005 truncation-only is 5.50e-11 ≈ the computed 5.52e-11 | Confirmed |
| 23 | Case 3 alt text | Compares second-derivative curves for the exact function, 3-point and 5-point stencils as h decreases | Frames show black f'', dashed blue 3-point and green 5-point curves; h is in the title | Confirmed (domain wording: F2) |
| 24 | Case 3 wiring | diffformac.jl / diffformac.gif | Correct case | Confirmed |
| 25 | Animations intro | "Each animation below visualizes one derived stencil formula" | Case 1 shows one formula. Case 2 shows two (3-point and 5-point f'), and Case 3 shows two second-derivative formulas | Confirmed loosely (each case is centred on one family; not worth a finding) |
| 26 | Animations intro | "using the legacy test function f(x) = e^{−x} sin(x)" | All three scripts use `f(x) = exp(-x)*sin(x)`. The function is the test function of the sibling legacy module NumericalDiffMod (gr_27). It is not from this topic's module, which has no test function | Confirmed (function correct; provenance is attribution, not reviewed further) |
| 27 | Derivation Notes | Taylor expansion f(x±h) = f ± hf' + h²/2 f'' ± h³/6 f''' + ⋯ | Standard; agrees with archive gr_35 | Confirmed |
| 28 | Derivation Notes | f' = central difference + O(h²) | sympy: leading term h²f'''/6 | Confirmed |
| 29 | Derivation Notes | f'' = (f(x+h) − 2f(x) + f(x−h))/h² + O(h²) | sympy: leading term h²f⁽⁴⁾/12 | Confirmed |
| 30 | Derivation Notes | Including x±2h yields five-point formulas with O(h⁴) truncation for smooth f | True for the f' and f'' five-point formulas the page uses (−h⁴f⁽⁵⁾/30, −h⁴f⁽⁶⁾/90). The five-point f''' and f'''' formulas in the archive (gr_193) are only O(h²). The page discusses only f' and f'', so the sentence reads in that context | Confirmed for the page's scope |

---

### 3. Implementation checks

### `diffformaa.jl`: three-point central first derivative at x0 = 1
- **Method:** `d1_3(x,h) = (f(x+h) − f(x−h))/(2h)` is the standard three-point central formula. A sympy polynomial-exactness check gives exact through degree 2 and not degree 3, with error series h²a³/6 + h⁴a⁵/120 + ⋯ for f = e^{ax}. The f(x0) term has coefficient 0, as expected.
- **Numbers (script Float64 vs independent mpmath, 40 digits):**

  | h | script approx | mpmath approx | \|err\| | err/h² |
  |---|---|---|---|---|
  | 0.6 | −0.0493537427 | −0.04935374268 | 6.144e-2 | 0.17067 |
  | 0.25 | −0.1001894114 | −0.1001894114 | 1.060e-2 | 0.16967 |
  | 0.05 | −0.1103701372 | −0.1103701372 | 4.236e-4 | 0.16945 |
  | 0.001 | −0.1107935959 | −0.1107935959 | 1.694e-7 | 0.16944 |

  All 12 h values agree to every printed digit.
- **Reference:** `fp(x) = e^{−x}(cos x − sin x)`; the sympy symbolic difference from d/dx f is 0. fp(1) = −0.110793765306699 (mpmath numeric diff agrees).
- **Picture:** The black curve is f on [0, π]. The dashed "formula slope" line passes through (x0, f(x0)) with slope `approx`; it is parallel to the secant through x0±h, as the legend says. The red tangent has slope fp(1). The orange points are at x0−h, x0, x0+h. The annotation shows approx/exact rounded to 6 digits, which matches the table. Lines stay within ylims (−0.1, 0.55); nothing is clamped. From h ≈ 0.1 on, the frames are visually identical apart from the text. That is expected for a second-order method and is not misleading. 12 frames, 12 h values.

### `diffformab.jl`: five-point vs three-point first derivative at x0 = 1
- **Method:** `d1_5` coefficients (1, −8, 0, 8, −1)/(12h). sympy shows it is exact through degree 4 and not 5, with error −h⁴a⁵/30 − h⁶a⁷/252. Coefficients match archive gr_193.
- **Numbers:**

  | h | err3 script | err3 mpmath | err5 script | err5 mpmath |
  |---|---|---|---|---|
  | 0.35 | 2.08e-2 | 2.08e-2 | 1.92e-4 | 1.92e-4 |
  | 0.12 | 2.44e-3 | 2.44e-3 | 3.02e-6 | 3.02e-6 |
  | 0.02 | 6.78e-5 | 6.78e-5 | 2.36e-9 | 2.36e-9 |
  | 0.005 | 4.24e-6 | 4.24e-6 | 9.24e-12 | 9.23e-12 |
  | 0.002 | 6.78e-7 | 6.78e-7 | 2.16e-13 | 2.36e-13 |

  err5/h⁴ → 0.01478 = |f⁽⁵⁾(1)|/30, confirming fourth order. At h = 0.002 the Float64 error (2.16e-13) departs from the exact truncation error (2.36e-13) because of rounding. The frame honestly shows the computed value, and the page makes no claim about it.
- **Reference:** Same fp as above, verified.
- **Picture:** Five stencil points are placed correctly. The three-point (dashed) and five-point (green) lines are drawn through (x0, f(x0)) with the computed slopes, and the tangent has slope fp(1). The green line is entirely hidden under the tangent (F1). The annotation's |err3| and |err5| match the table. 11 frames, 11 h values.

### `diffformac.jl`: second-derivative profiles
- **Method:** `d2_3` is the standard 3-point formula, exact through degree 3 with error h²a⁴/12. `d2_5` uses coefficients (−1, 16, −30, 16, −1)/(12h²), exact through degree 5 and not 6, with error −h⁴a⁶/90. Coefficients match archive gr_193.
- **Reference:** `fpp(x) = −2e^{−x}cos x`; the sympy difference from f'' is 0.
- **Numbers:** The script's max errors on its grid (700 points on [2h, π−2h]) match the mpmath truncation-only max errors to 3 significant figures for every h from 0.35 to 0.005 (table in ledger row 18). At h = 0.002 the script gives 5.89e-11 against a truncation-only value of 1.42e-12; the difference is Float64 rounding, which bears out the page's explanation. The argmax of the 5-point error is the left window edge x = 2h for h ≥ 0.005 and the interior x = 0.784 at h = 0.002. The 3-point argmax is near x ≈ 0.785 = π/4, where the leading term h²|f⁽⁴⁾|/12 peaks (f⁽⁴⁾ = −4e^{−x} sin x, and |f⁽⁴⁾| has its maximum at π/4).
- **Picture:** The black f'' curve spans [0, π]. The stencil curves span [2h, π−2h] only (F2). ylims (−2.1, 0.2) contain f'' (range −2 to 0.134) and both stencil curves (max 0.1341 at h = 0.35); nothing is clipped. The title's h and the annotation values match the computation. 11 frames, 11 h values.

### Not determined / not checked
- Nothing material was left undetermined. I did not check the prose claims about history and attribution, by instruction.

