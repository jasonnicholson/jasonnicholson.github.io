# Numerical Differentiation — animation review (round 2)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 3 Minor**.

## Findings

### Finding 1: Case 2 legend shows "f" instead of the function (Implementation / picture, Minor)

- **Location:** `numdiffab.jl` line 46, `label="f(x) = e^{-x} sin(x)"`.
- **What is there now:** in every frame of `numdiffab.gif` the legend entry for the black curve reads only **"f"**. See `committed/numdiffab/frame_001.png`. The function is not named anywhere in the GIF.
- **What is true instead:** the code means the legend to read `f(x) = e^{-x} sin(x)`. The GR backend cuts off a plain-string label that contains `^{...}`.
- **How I know:** `julia review/labeltest.jl` plots three series labelled `"f(x) = e^{-x} sin(x)"`, `"f(x) = e^(-x) sin(x)"` and `"g(x) = sin(x)"`. In `review/labeltest.png` the first label renders as "f" and the other two render in full.
- **Correction:** use `label="f(x) = e^(-x) sin(x)"` or `"f(x) = exp(-x) sin(x)"`, or a `LaTeXStrings` `L"f(x)=e^{-x}\sin x"`. The Case 1 labels (`"f'(x)"`, `"D3(x,h)"`) render correctly and need no change.
- **Why only Minor:** the picture does not show what the code intends, and the identifying label is lost. Nothing false is displayed, though, and the page text names the function.

- **Independent check:** not run (Minor finding, unverified)

### Finding 2: Case 1 "max error" covers [h, π−h], not [0, π] (Page match / picture, Minor)

- **Location:** `numdiffaa.jl` line 22 (`xint = range(xlims[1] + h, xlims[2] - h, length=700)`), line 26 (`maxerr` taken over `xint`) and line 44 (title `"Three-Point Central Difference on [0, pi]\nh = …, max error ≈ …"`). Page heading: "Case 1 - central derivative profile, $D_3(x,h)$ on $[0,\pi]$".
- **What is there now:** the title says "on [0, pi]" and gives a "max error". That error, and the blue D3 curve itself, cover only [h, π−h]. $f$ is defined everywhere, so nothing requires the restriction. At h = 0.5 the blue curve visibly starts at x = 0.5 (frame 1). The quoted maximum, 6.81e-02 at x = 0.5, is not the maximum over [0, π].
- **What is true instead:** the maximum of |D3 − f′| over [0, π] is at x = 0 (Mathews makes the same point in Example 3(b)). Its values:

  | h | title (over [h, π−h]) | true max over [0, π] | h²/3 = h²·max\|f‴\|/6 |
  |---|---|---|---|
  | 0.5 | 6.81e-02 | 8.13e-02 | 8.33e-02 |
  | 0.3 | 2.77e-02 | 2.97e-02 | 3.00e-02 |
  | 0.2 | 1.28e-02 | 1.33e-02 | 1.33e-02 |
  | 0.1 | 3.30e-03 | 3.33e-03 | 3.33e-03 |
  | ≤0.07 | agrees to 3 significant figures | | |

- **How I know:** `python3 -I review/indep.py` (last block) and the instrumented `julia review/aa_instr.jl`. The latter prints `AA h=0.5 maxerr=0.06806543365013332 at x=0.5 xint=[0.5,2.641592653589793]`, so every maximum falls at the left end of the truncated window.
- **Correction:** evaluate D3 on the full `xfull` grid. Then the curve spans [0, π], the error is the true maximum, and the first frames show the h²/3 law cleanly. The alternative is a title that reads "max error on [h, π−h]".
- **Why only Minor:** the difference is 16% at h = 0.5, 7% at h = 0.3, and under 1% from h = 0.1 down. The conclusion about the convergence rate does not change.

- **Independent check:** not run (Minor finding, unverified)

### Finding 3: archive cases dropped without mention (Fidelity, Minor)

- **Location:** `index.qmd` Animations section (lines 22–40). It has only two central-difference cases.
- **What is there now:** the page animates only the three-point central first-derivative formula. Nothing says the rest of the archive module was left out.
- **What the archive has:** the module's animation page `a2001/Animations/Derivative/Derivative.html` has, all for $f(x)=e^{-x}\sin x$ at $x_0=1$:
  - Forward Difference O(h¹) and O(h²)
  - Backward Difference O(h¹) and O(h²)
  - two Central Difference O(h²) variants: one with the interpolating parabola and the tangent-at-x0 line, one with the chord

  The module text also covers the three-point central **second**-derivative formula (Project II, Examples 5–8) and forward/backward/central formulas for f′ and f″ (Examples 9–17). The page's Case 2 matches the archive's chord variant: same f, x0 = 1, and the same values at the shared steps (h = 0.6: −0.049354; h = 0.4: −0.083592; h = 0.001: −0.110794).
- **Correction:** add cases for the forward and backward difference formulas at x0 = 1 (O(h) and O(h²)). At the least, the page should say that it covers only the central first-derivative formula.
- **Note:** this sits on the line between "an archive case silently dropped", which the brief counts as fidelity, and "content the page does not yet have", which it does not count. I report it as Minor so the owner can decide.

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.0 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 8.5 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `numdiffaa.gif` | 12 | byte-identical | numdiffaa |
| `numdiffab.gif` | 12 | byte-identical | numdiffab |

### Page references

- Scripts linked: `numdiffaa.jl`, `numdiffab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "In the Mathews examples for this module, the test function is $f(x)=e^{-x}\sin(x)$" | Archive image `NumericalDiffMod_gr_27.gif`: `f[x] = e^-x Sin[x]`. The script also uses `f(x) = exp(-x) * sin(x)` | confirmed |
| D2 | "on $[0,\pi]$" | Archive `gr_30`: M3 = max over 0≤x≤π; Example 2(c) plots over [0, π] (`gr_49`, `gr_51`) | confirmed |
| D3 | "with representative steps $h=0.1,0.01,0.001$" | Archive `gr_45`: "h = 0.1, 0.01, 0.001" (Example 2(a)) | confirmed |
| D4 | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ | `central3` in numdiffaa.jl line 12 and msec in numdiffab.jl line 34 are exactly this formula | confirmed |
| D5 | "truncation error $O(h^2)$ when $f$ is sufficiently smooth" | err/h² → f‴(1)/6 = 0.169442 at x = 1 (indep.py: 0.1723 at h=1 → 0.169442 at h ≤ 0.01); max-error/h² → 1/3 = f‴(0)/6 on [0, π] | confirmed |
| D6 | "eventually roundoff and cancellation can limit accuracy" | A general statement; the page does not claim the animation shows it. Neither GIF reaches that regime: at h = 0.001 roundoff ~ε/h ≈ 1e-13, far below truncation of 1.7e-7 to 3.3e-7. True as stated | confirmed (as general statement) |
| D7 | Derivation: $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f^{(3)}(\xi_\pm)$ leads to an error ∝ h² | Taylor with Lagrange remainder is correct. Subtracting gives D3 − f′ = (h²/12)(f‴(ξ₊)+f‴(ξ₋)) = (h²/6)f‴(ξ) | confirmed |
| A1 | Intro: each animation shows finite-difference derivative behaviour for $e^{-x}\sin x$ "on legacy interval settings from the source module" | Both scripts use x ∈ [0, π], matching the archive | confirmed |
| C1-1 | Heading: "central derivative profile, $D_3(x,h)$ on $[0,\pi]$" | f′ is drawn on [0, π]; D3 is drawn on [h, π−h] only (line 22) | confirmed with caveat (see Finding 2) |
| C1-2 | Behavior: "The numerical derivative curve approaches $f'(x)$ as h shrinks" | Max error falls monotonically, 6.81e-2 → 3.33e-7, over h = 0.5 → 0.001 (instrumented run and indep.py agree) | confirmed |
| C1-3 | Behavior: "consistent with second-order truncation error for the central stencil" | maxerr/h² = 0.272, 0.307, 0.321, 0.330, …, 0.3333 → f‴(0)/6 = 1/3. Each halving (0.1→0.05, 0.01→0.005) gives a ratio of 3.97 and 4.00 | confirmed |
| C1-4 | Source link `numdiffaa.jl`; embed `numdiffaa.gif` | The files exist; the script writes numdiffaa.gif; the committed GIF is byte-identical to the regenerated one | confirmed |
| C1-5 | Alt text: "comparing the three-point central derivative approximation against the true derivative over 0 to pi as h decreases" | Frames: black f′ and blue D3; h decreases 0.5 → 0.001 across 12 frames | confirmed |
| C1-6 | Frame titles: h and max error values (all 12) | Instrumented values equal indep.py values over [h, π−h] to every digit shown (e.g. 6.807e-02, 3.299e-03, 3.333e-05, 3.333e-07) | confirmed (numbers); see Finding 2 for the interval |
| C2-1 | Heading: "secant to tangent at $x_0=1$, $h\to0$" | numdiffab.jl `x0 = 1.0`; hs = 0.6 … 0.001 | confirmed |
| C2-2 | Behavior: slope of the symmetric secant $(f(x_0+h)-f(x_0-h))/(2h)$ "converges to the tangent slope $f'(x_0)$ as the stencil contracts" | D3 at x = 1: −0.049354, −0.083592, −0.100189, −0.106979, −0.109099, −0.109963, −0.110370, −0.110641, −0.110726, −0.110777, −0.110790, −0.110794, monotone towards f′(1) = −0.1107937653 | confirmed |
| C2-3 | Source link `numdiffab.jl`; embed `numdiffab.gif` | The files exist and are correct; GIF byte-identical | confirmed |
| C2-4 | Alt text: "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line at x0 equals 1 for f(x)=e^{-x} sin x" | Secant built through (x0−h, f(x0−h)). The instrumented run checks it reaches f(x0+h): `secant_at_xr == yr` in every frame. The tangent is drawn through (1, f(1)) with slope f′(1). Orange markers at x0−h, x0, x0+h | confirmed |
| C2-5 | Frame titles: "secant slope ≈ …, true = −0.110794" (12 frames) | All 12 secant values match indep.py to 6 decimals; true value −0.1107937653 rounds to −0.110794 | confirmed |
| C2-6 | Frame legend: "f(x) = e^{-x} sin(x)" (code intent) | Renders as "f" | wrong (Finding 1) |
| W1 | Number of cases: 2, with 2 scripts and 2 GIFs | Manifest and directory listing | confirmed |

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)

- **Is it the method it claims to be?** Yes. `central3(x,h) = (f(x+h) - f(x-h))/(2h)` is the three-point central first-derivative formula. It is not a one-sided or a five-point variant.
- **Are the numbers right?** Yes. The instrumented copy (`aa_instr.jl`) gives the same maximum errors as an independent mpmath evaluation over the same 700-point grid on [h, π−h]:

  | h | script maxerr | independent | at x |
  |---|---|---|---|
  | 0.5 | 0.068065 | 6.807e-02 | 0.5 |
  | 0.1 | 0.0032995 | 3.299e-03 | 0.1 |
  | 0.01 | 3.33297e-05 | 3.333e-05 | 0.01 |
  | 0.001 | 3.33333e-07 | 3.333e-07 | 0.001 |

  The property check holds: maxerr/h² → f‴(0)/6 = 1/3, with f‴ = 2√2 e^{−x} sin(x+π/4) from sympy, and halving h divides the error by about 4.
- **Is the reference right?** Yes. The script's `fp(x) = exp(-x)(cos x − sin x)`, minus the sympy derivative of e^{−x} sin x, simplifies to 0.
- **Does the picture show what was computed?** Yes:
  - The black curve is f′ on [0, π] and the blue curve is D3 on [h, π−h].
  - Titles show the correct h and the computed max error.
  - ylims (−1, 1.1) contain both curves: f′ ranges from 1 at x = 0 down to about −0.208.
  - There is no clamping or masking. All 12 frames are present.

  From h = 0.1 on, the two curves are indistinguishable at this scale (error < 3.3e-3, under one pixel). The convergence there is visible only through the title numbers. That is not false, so I do not report it. The interval and label issue is Finding 2.

### `numdiffab.jl` (Case 2)

- **Is it the method it claims to be?** Yes. `msec = (yr - yl)/(2h)` with yl = f(x0−h) and yr = f(x0+h) is the central difference. It is drawn as the chord through the two outer stencil points, the same as the archive's "CentralD2.2f" variant.
- **Are the numbers right?** Yes. Script against independent (mpmath, 40 digits):

  | h | script msec | independent D3 | err/h² |
  |---|---|---|---|
  | 0.6 | −0.04935374267500 | −0.04935374268 | 0.17067 |
  | 0.4 | −0.08359181012485 | −0.08359181012 | 0.17001 |
  | 0.25 | −0.10018941138993 | −0.1001894114 | 0.16967 |
  | 0.15 | −0.10697945995888 | −0.10697946 | 0.16953 |
  | 0.1 | −0.10909897684773 | −0.1090989768 | 0.16948 |
  | 0.07 | −0.10996341095255 | −0.109963411 | 0.16946 |
  | 0.05 | −0.11037013724894 | −0.1103701372 | 0.16945 |
  | 0.03 | −0.11064126452006 | −0.1106412645 | 0.16945 |
  | 0.02 | −0.11072598791772 | −0.1107259879 | 0.16944 |
  | 0.01 | −0.11077682107024 | −0.1107768211 | 0.16944 |
  | 0.005 | −0.11078952925451 | −0.1107895293 | 0.16944 |
  | 0.001 | −0.11079359586472 | −0.1107935959 | 0.16944 |

  err/h² → f‴(1)/6 = 0.169442, which is the O(h²) property. The values also match the archive's own animation at the shared steps (h = 0.6, 0.4, 0.001).
- **Is the reference right?** Yes. mtan = −0.11079376530670 = f′(1) = e^{−1}(cos 1 − sin 1), and independent mpmath gives −0.110793765307.
- **Does the picture show what was computed?** Yes, apart from the legend label (Finding 1):
  - The secant passes through both outer stencil points: the instrumented run gives `secant_at_xr == yr` in all frames.
  - The tangent goes through (1, f(1)) = (1, 0.309560) with the true slope.
  - The stencil markers sit at the correct points.
  - The `continue` guard (line 26) never fires, since x0 ± 0.6 lies inside [0, π], so all 12 frames are drawn.
  - ylims (−0.1, 0.55) contain the curve (max ≈ 0.322 at x = π/4) and both lines over [0.1, 1.9].

### Legacy archive

I consulted the archive, which confirms the function, interval and step sizes. Case 1 corresponds to Example 2(c), which plots D1[x, 0.01] against f′ on [0, π]. Case 2 corresponds to Example 2(a), f′(1) with h = 0.1, 0.01, 0.001, and to the Central O(h²) animation. The cases not carried over are in Finding 3.

