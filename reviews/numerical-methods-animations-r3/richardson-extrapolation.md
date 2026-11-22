# Richardson Extrapolation — animation review (round 3)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Case 1 approximations and max-error annotation cover [h, pi-h], while the title and alt text say [0, pi] (Page match / implementation display, Minor)

- **Location:** `richexaa.jl` line 21 (`xint = range(xlims[1] + h, xlims[2] - h, length=700)`), lines 27-28 (max errors over `xint`), line 45 (title `"Richardson Extrapolation on [0, pi] | h = $(h)"`), line 54 (annotation `max|error D3| ≈ ... max|error D5| ≈ ...`); `index.qmd` line 40 alt text "...derivative curves against the true derivative over 0 to pi for decreasing h."
- **What is there now:** the D3 and D5 curves are drawn, and their max errors computed, only on [h, pi-h], so that every stencil point stays inside [0, pi]. Only f' is drawn over the whole [0, pi]. The page and the title do not say so. At h = 0.5 (frame 1) the two approximation curves are missing from 32% of the window (x < 0.5 and x > 2.64), which is visible in `committed/richexaa/frame_001.png`. The annotated "max|error|" is the maximum over the drawn sub-interval, not over [0, pi].
- **What is true:** the annotated numbers are correct for [h, pi-h]. Over [0, pi] the maxima are larger, mostly in the early frames, because the error peaks at the left end:

  | h | annotated D3 (on [h, pi-h]) | D3 on [0, pi] | annotated D5 | D5 on [0, pi] |
  |---|---|---|---|---|
  | 0.5 | 6.81e-02 | 8.13e-02 | 1.32e-04 | 5.29e-04 |
  | 0.32 | 3.12e-02 | 3.38e-02 | 4.08e-05 | 8.79e-05 |
  | 0.2 | 1.28e-02 | 1.33e-02 | 8.56e-06 | 1.34e-05 |
  | 0.01 | 3.33e-05 | 3.33e-05 | 8.17e-11 | 8.33e-11 |

  Evidence: `julia inst_a.jl` (script's grid values, all maxima at x = h) and `/usr/bin/python3 -I full.py` (20001-point grid on [0, pi]).
- **Consequence:** small. The cropping is a legitimate choice, and no conclusion in the page depends on it: the ratio D3/D5 is still about 150 or more in every frame. A reader comparing the annotation with the title would take it as the max over [0, pi], though, and in frame 1 the D5 value is low by a factor of 4.
- **Suggested correction:** either label the annotation domain (for example `max over [h, π-h]: |error D3| ≈ ...`) and add a sentence to the Case 1 text that the approximations are drawn on [h, pi-h] so the stencil stays in [0, pi]; or evaluate D3/D5 on the full [0, pi] (f is defined outside it), which makes the title and alt text literally true.

No other findings. Everything else was checked and confirmed (ledger and checks below).

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Count: Error 0, Misleading 0, Minor 1.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.3 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 6.6 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Claims are in the page's own words, with the verdict and the evidence for each.

### Description

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| D1 | "Richardson extrapolation combines two finite-difference estimates with different step sizes so that the leading truncation term cancels." | Confirmed | sympy series: D5 − f' has zero h^0..h^3 coefficients; the h^2 term of D3 (f'''/6) cancels. |
| D2 | "In the legacy module, this is presented as a refinement of the central three-point derivative for f(x)=e^{-x}sin(x) over [0,π]." | Confirmed | Legacy images gr_34/gr_139/gr_172 give f[x] = e^-x Sin[x]; Example 2(b)/3 use the interval [0, π] (gr_60), and the module's Richardson theorem relates D_five to D_three (gr_22). |
| D3 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | Confirmed | Same as the legacy gr_4 and the scripts' `d3` (line 12 / 11). |
| D4 | $D_5(x,h)=\frac{4D_3(x,h/2)-D_3(x,h)}{3}$ is the Richardson-improved estimate | Confirmed | Same as the scripts' `d5` (line 13 / 12). The legacy writes it as D_five(x,h) = (4D_three(x,h) − D_three(x,2h))/3 (gr_22), which is the same formula with h relabelled. The page discloses the relabelling (A2). |
| D5 | "upgrades the local truncation behavior from O(h^2) to O(h^4) for smooth functions" | Confirmed | sympy: D3 − f' = f'''h²/6 + O(h⁴); D5 − f' = −f⁽⁵⁾h⁴/480 + O(h⁶). Measured slopes in Case 2: 2.000 and 3.99–4.00. |
| D6 | Derivation Notes: if D3 = f' + C2 h² + C4 h⁴ + …, then (4D3(x,h/2) − D3(x,h))/3 = f' + O(h⁴) "because the C2 h² contribution cancels exactly" | Confirmed | 4·C2(h/2)² − C2h² = 0; sympy series check, `indep.py`. |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation below compares the base central difference with Richardson extrapolation for the legacy test function and interval." | Confirmed | Both scripts use f = e^{-x} sin x. Case 1 uses [0, π] (see F1 for the drawn sub-interval). Case 2 uses x0 = 1, a point of that interval and the legacy Example 7/8 point. |
| A2 | "Case 2 plots the error of the estimate in the legacy module's Example 8: D5(x,h) is that example's five-point formula for f′ with spacing h/2" | Confirmed | sympy: (4D3(x,h/2) − D3(x,h))/3 ≡ [f(x−2k) − 8f(x−k) + 8f(x+k) − f(x+2k)]/(12k) with k = h/2 (`indep.py`: True). Legacy Example 8 (gr_174) computes exactly this five-point formula at X = 1.0. |
| A3 | "...evaluated here over a different list of step sizes." | Confirmed | Legacy H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01} as spacing (gr_174). Script spacing h/2 = {0.25, 0.16, 0.1, 0.06, 0.04, 0.025, 0.015, 0.01, 0.005, 0.003, 0.0015, 0.00075}. The lists differ. |
| A4 | "Examples 9–10, which use five-point central-difference formulas to approximate the second and third derivatives at the same point, are not animated here" | Confirmed | Legacy gr_193/194 and gr_214/215 give f''[1.0] and f'''[1.0]. Code images gr_195/gr_216 use the stencil X±H, X±2H with (−f₋₂+16f₋₁−30f₀+16f₁−f₂)/(12H²) and (−f₋₂+2f₋₁−2f₁+f₂)/(2H³). No script animates these. |
| A5 | "...neither are the pictures that Examples 8–10 draw: the five stencil points with a line, parabola or cubic through the centre point." | Confirmed | Legacy code: Example 8 g = f(X)+d1(x−X) (line); Example 9 adds the d2/2 (x−X)² term (parabola); Example 10 is a cubic. All are drawn with five points (graphs gr_175, gr_196, gr_217). |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: "profile comparison, D3(x,h) vs. D5(x,h)" | Confirmed | Frames show f', D3 (dashed) and D5 (solid) as functions of x. |
| C1.2 | "Both approximations converge as h shrinks" | Confirmed | max error of D3: 6.81e-2 → 3.33e-5; of D5: 1.32e-4 → 8.17e-11. Both decrease monotonically over the 9 frames (`inst_a.jl`, mpmath agrees to all printed digits). |
| C1.3 | "...but the Richardson curve tracks f′(x) much more closely because the dominant h² error term is canceled." | Confirmed | Error ratio D3/D5 rises from 515 (h = 0.5) to 4.1e5 (h = 0.01). In frames 1–3 the dashed D3 is visibly off and D5 is on f'. Reason confirmed by series (D5, D6). |
| C1.4 | Wiring: `[Julia source](richexaa.jl)` and `richexaa.gif` | Confirmed | The script is the D3/D5 profile on [0, π]. The GIF is byte-identical to its regeneration. |
| C1.5 | Alt: "Animation comparing D3 and Richardson D5 derivative curves against the true derivative over 0 to pi for decreasing h." | Confirmed with caveat | h decreases 0.5 → 0.01. f' is drawn over [0, π], but D3 and D5 only over [h, π−h] (F1). |
| C1.6 | Frame title "Richardson Extrapolation on [0, pi] \| h = …" and annotation "max\|error D3\| ≈ …, max\|error D5\| ≈ …" | Values confirmed; domain see F1 | All 9 annotated pairs equal the mpmath values on the script's 700-point grid, e.g. h=0.5: 6.80654e-2 / 1.32144e-4 (annotated 6.81e-02 / 1.32e-04); h=0.01: 3.33297e-5 / 8.16755e-11 (annotated 3.33e-05 / 8.17e-11). |
| C1.7 | Legend "D5(x,h) = (4D3(x,h/2)-D3(x,h))/3" | Confirmed | Matches the code and the Description. |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: "pointwise convergence at x0=1 on log-log axes" | Confirmed | `x0 = 1.0`, `xaxis=:log, yaxis=:log`. The frames show log-log axes. |
| C2.2 | "The error slope for the three-point formula follows approximately O(h²)" | Confirmed | Successive slopes 2.007, 2.003, 2.001, then 2.000 for every remaining pair. e3/h² → 0.16944 = \|f'''(1)\|/6 (mpmath 0.169442). |
| C2.3 | "...while Richardson extrapolation follows approximately O(h⁴) before roundoff effects appear." | Confirmed | Slopes 3.905, 3.963, 3.986, 3.995, 3.998, 3.999, 4.000, 3.999, 3.987 down to h = 0.006. e5/h⁴ → 0.000923 = \|f⁽⁵⁾(1)\|/480 (mpmath 0.00092328). At h = 0.003 the float error is 4.26e-14 against an exact truncation error of 7.48e-14, and at h = 0.0015 it is 1.29e-14 against 4.67e-15: roundoff takes over. This shows in the last two frames, where the orange points leave the O(h⁴) guide (`committed/richexab/frame_012.png`). |
| C2.4 | Wiring: `[Julia source](richexab.jl)` and `richexab.gif` | Confirmed | The script is the pointwise error at x0 = 1. The GIF is byte-identical to its regeneration. |
| C2.5 | Alt: "Animation of log-log error curves versus h at x0 equals 1 showing second-order and fourth-order convergence trends." | Confirmed | As C2.2 and C2.3. Dashed and dotted guides of slopes 2 and 4. |
| C2.6 | Legend "\|D3(1,h)-f'(1)\|", "\|D5(1,h)-f'(1)\|", "O(h^2) guide", "O(h^4) guide" | Confirmed | Guides are c2·h² and c4·h⁴ anchored at the h = 0.5 data points (c2 = 0.17031, c4 = 8.60e-4). Frame 1 has one point, so the guides are degenerate there and invisible. This is cosmetic. |

### 3. Implementation checks

### `richexaa.jl` (Case 1)

- **Is it the method claimed?** Yes. `d3` is the central three-point difference. `d5` is one Richardson step on it with step ratio 2, which is algebraically identical to the five-point central formula with spacing h/2 (sympy check `indep.py`: True). This is the standard first-level Richardson extrapolation and not a different method.
- **Are the numbers right?** Yes. The instrumented copy (`inst_a.jl`) and the independent mpmath (50-digit) computation on the same 700-point grid agree:

  | h | script max e3 | mpmath max e3 | script max e5 | mpmath max e5 |
  |---|---|---|---|---|
  | 0.5 | 6.806543e-02 | 6.80654e-02 | 1.321437e-04 | 1.32144e-04 |
  | 0.32 | 3.116181e-02 | 3.11618e-02 | 4.075897e-05 | 4.0759e-05 |
  | 0.2 | 1.283335e-02 | 1.28333e-02 | 8.560666e-06 | 8.56067e-06 |
  | 0.12 | 4.730887e-03 | 4.73089e-03 | 1.339567e-06 | 1.33957e-06 |
  | 0.08 | 2.119238e-03 | 2.11924e-03 | 2.890315e-07 | 2.89031e-07 |
  | 0.05 | 8.311305e-04 | 8.31131e-04 | 4.701289e-08 | 4.70129e-08 |
  | 0.03 | 2.997100e-04 | 2.99710e-04 | 6.351436e-09 | 6.35144e-09 |
  | 0.02 | 1.332756e-04 | 1.33276e-04 | 1.280565e-09 | 1.28057e-09 |
  | 0.01 | 3.332970e-05 | 3.33297e-05 | 8.167544e-11 | 8.16755e-11 |

- **Is the reference right?** Yes. `fp(x) = exp(-x)(cos x − sin x)` equals sympy's d/dx[e^{-x} sin x] (difference simplifies to 0). Range on [0, π] is [−0.2079, 1.0], inside ylims (−1.0, 1.1).
- **Does the picture show what was computed?** Yes, except for the domain labelling in F1. Frames 1, 2, 5 and 9 were inspected. The black f' is over [0, π], the dashed D3 and orange D5 are over [h, π−h], and the annotation values equal the computed ones. Nothing is clamped or masked. There are 9 frames, one per h. From h ≈ 0.12 on, all three curves overlap at plot resolution and the annotation carries the comparison, which is expected and not misleading.

### `richexab.jl` (Case 2)

- **Is it the method claimed?** Yes. It uses the same `d3`/`d5` as Case 1, evaluated at x0 = 1.
- **Are the numbers right?** Yes. Script values (`inst_b.jl`) against exact truncation errors (mpmath 50 digits):

  | h | script e3 | exact e3 | script e5 | exact e5 |
  |---|---|---|---|---|
  | 0.5 | 4.257869e-02 | 4.257869e-02 | 5.375918e-05 | 5.375918e-05 |
  | 0.2 | 6.783537e-03 | 6.783537e-03 | 1.461109e-06 | 1.461109e-06 |
  | 0.05 | 4.236281e-04 | 4.236281e-04 | 5.766570e-09 | 5.766569e-09 |
  | 0.01 | 1.694424e-05 | 1.694424e-05 | 9.238929e-12 | 9.232562e-12 |
  | 0.006 | 6.099917e-06 | 6.099917e-06 | 1.205230e-12 | 1.196561e-12 |
  | 0.003 | 1.524978e-06 | 1.524978e-06 | 4.259093e-14 | 7.478561e-14 |
  | 0.0015 | 3.812445e-07 | 3.812445e-07 | 1.292022e-14 | 4.674109e-15 |

  The two columns agree until double-precision roundoff (about 18·eps·|f|/(6h) ≈ 3e-14 at h = 0.003) dominates the D5 error at the last two step sizes. This is the effect the page describes. Order check: e3/h² is constant at 0.16944 (= |f'''(1)|/6), and e5/h⁴ approaches 0.000923 (= |f⁽⁵⁾(1)|/480) and is constant to h = 0.006.
- **Is the reference right?** Yes. fp(1) = −0.110793765306699 (script) against −0.11079376530669925782 (mpmath). The legacy Example 8 prints f'[1.] = −0.110793765.
- **Does the picture show what was computed?** Yes. Frames 1, 5, 9, 11 and 12 were inspected. Each frame k plots the first k (h, error) pairs on log-log axes with guides over [min h, max h]. In the final frame the D3 points lie on the slope-2 guide and the D5 points on the slope-4 guide down to h = 0.006, with a visible departure at h = 0.003 and h = 0.0015. The axes autoscale every frame, so early frames show fractional-decade tick labels (10^-0.2, 10^-0.50). This is cosmetic and does not change any conclusion. There are 12 frames, one per h.

### Fidelity to the legacy archive

- Function, interval and evaluation point (e^{-x} sin x, [0, π], x = 1) match the legacy.
- The legacy's D_five(x,h) has spacing h. The page's D5(x,h) has spacing h/2. The page says so explicitly (A2), so this is not a finding.
- The step-size list differs from Example 8's. The page says so (A3).
- The page states that Examples 9–10 and the Example 8–10 stencil pictures are omitted (A4, A5). Examples 1–7 are exercises (bounds, tables, proofs) rather than animation scenarios. Example 2(b) (plot D_five over [0, π] against f') is what Case 1 animates, and Example 7 (Richardson at x = 1) is what Case 2 generalises.
- No fidelity findings.

