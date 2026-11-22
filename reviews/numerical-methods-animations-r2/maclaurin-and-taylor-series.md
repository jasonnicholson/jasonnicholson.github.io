# Maclaurin and Taylor Series — animation review (round 2)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 4 Minor**.

## Findings

### F1. Fidelity, Minor: M10 swaps Mathews' $e^x$ for $e^{-x^2/2}$ and so repeats M17
- **Location:** `series_animations_all.jl` line 33 (`SeriesCase("m10", …, raw"e^{-x^2/2}", "exp(-x^2/2)", x -> exp(-x^2 / 2), 0.0, (-2.0, 3.0), (-1.0, 1.2), 12)`) and lines 280–284 (coefficients). In `index.qmd`: heading `### M10 - $f(x)=e^{-x^2/2}$, $x_0=0$, $x\in[-2,3]$` and the alt text "Maclaurin animation for exponential of negative x squared over two centered at zero."
- **Now:** M10 is $e^{-x^2/2}$ on $[-2,3]$.
- **Legacy:** Mathews' Maclaurin animation 10 is $f(x)=e^x$, $x_0=0$, $-2\le x\le 3$. The index formula image and the title of the legacy animated GIF (`a2001/Animations/Interpolation/Series/Maclaurin10/Maclaurinjj.gif`, "y = f[x] = e^x") both say so. The page gives no reason for the change. The page kept the asymmetric interval $[-2,3]$, which suits $e^x$ but is odd for an even function. That suggests a substitution rather than a deliberate choice. The result is that M10 and M17 ($\frac{1}{\sqrt{2\pi}}e^{-x^2/2}$ on $[-3,3]$) show the same curve up to a constant factor, and the most basic Maclaurin example, $e^x$, is missing from the GIF set. It appears only in the Video section. The authoring conventions (`.github/agents/animation-page.agent.md`, lines 11 and 14) say to treat the legacy GIFs as ground truth and never to guess parameters.
- **Evidence:** `review/legacy_montage.png` (row Maclaurin10), `review/legacy/legacy_sel.png` (top-left panel).
- **Fix:** Make M10 `x -> exp(x)` on `(-2.0, 3.0)`, with coefficients `a[k+1] = 1/factorial(k)` and ylims of about `(-1.0, 21.0)` ($e^3\approx20.09$). Change the heading to `$f(x)=e^{x}$` and the alt text to "exponential of x". The Description sentence listing $e^{-x^2/2}$ among the entire functions can stay, because M17 still illustrates it, or it can be changed to $e^x$.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: T08–T10 move the Gamma centres from Mathews' 1, 2, 3 to 2, 3, 4
- **Location:** `series_animations_all.jl` lines 51–53 (`c = 2.0, 3.0, 4.0`). In `index.qmd`: headings `T08 … $x_0=2$`, `T09 … $x_0=3$`, `T10 … $x_0=4$` and the matching alt texts.
- **Legacy:** Mathews' Taylor animations 8, 9 and 10 are $\Gamma(x)$ about $x_0=1$, $2$ and $3$ on $[-0.2,5.2]$. The index formula images say "x0 = 1", "x0 = 2" and "x0 = 3". The last frames of `Taylorhh.gif`, `Taylorii.gif` and `Taylorjj.gif` show the red centre dot at x = 1, 2 and 3, with convergence intervals (0,2), (0,4) and (0,6). The page gives no reason for the change. The routine handles $c=1$ without trouble (`taylor_coeffs_exact` accepts any $c>0$). The teaching point, that the radius equals the distance to the pole at 0, survives, but with different numbers. Mathews' $x_0=1$ case has the smallest radius ($R=1$) and is the most instructive of the three.
- **Fix:** Set `c` to `1.0, 2.0, 3.0` for t08, t09 and t10, update the three headings and alt texts, and regenerate. Check the ylims afterwards. Γ about 1 at order 8 leaves the window quickly, which is expected.

- **Independent check:** not run (Minor finding, unverified)

### F3. Fidelity, Minor: T11 and T12 swap Mathews' $Y_0$ about 10 and about 5 for $J_0$ about 10 and $J_1$ about 5
- **Location:** `series_animations_all.jl` lines 54–55 and 216 (`"t11" => (:besselj, 0), "t12" => (:besselj, 1)`). In `index.qmd`: headings `T11 - $f(x)=J_0(x)$, $x_0=10$` and `T12 - $f(x)=J_1(x)$, $x_0=5$` and their alt texts.
- **Legacy:** Mathews' Taylor animations 11, 12 and 13 all use $Y_0(x)$ on $[0,22]$, about $x_0=10$, $5$ and $2$. The index formula images all read "Y0[x] = BesselY[0, x]". The legacy GIF titles `Taylorkk.gif` and `Taylorll.gif` read "y = f[x] = Y0(x)", and their convergence intervals end at about 20 and 10, that is at $2x_0$. Together the three cases show the radius equal to the distance to the logarithmic singularity at 0 ($R=10, 5, 2$). The page keeps only T13 ($Y_0$ about 2) and replaces the other two with entire functions ($R=\infty$), so the trio no longer demonstrates that point. The page gives no reason for the change.
- **Fix:** Make t11 and t12 `x -> bessely(0, x)` with `taylor_family` `(:bessely, 0)`, centres 10.0 and 5.0, on `(0.0, 22.0)`. Update the headings to `$f(x)=Y_0(x)$` and the alt texts to "Bessel Y zero centered at ten/five". The `_bessel_big` routine already supports `:bessely` for $c>0$.

- **Independent check:** not run (Minor finding, unverified)

### F4. Implementation (picture), Minor: the target function is drawn as a connected line through its poles
- **Location:** `series_animations_all.jl` lines 348 and 369. `ytrue` is not masked near singularities and is plotted as one connected series.
- **Now:** Where consecutive plot samples straddle a pole, the magenta "f(x)" line joins a huge positive value to a huge negative one. That draws a full-height vertical magenta segment at the pole, which the legend labels as part of f(x). It appears in M01 (x = 1), M02 (x = −1), M09 (x = ±π/2) and T08–T10 (x = 0). See for example `committed/series_m01/frame_013.png` and `committed/series_m09/sheet.png`.
- **How I know:** I evaluated f at the two plot-grid points on either side of each pole (900-point grid, as in the script):
  - M01: f(0.99944) = 1798.0 and f(1.00278) = −359.6.
  - M02: −359.6 / 1798.0 around x = −1.
  - M09: tan(1.56905) = 572.3 and tan(1.57604) = −190.8.
  - T08: Γ(−0.00178) = −562.5 and Γ(0.00423) = 236.0.

  Each pair is joined by a segment crossing the whole y-window. The segment sits at the pole, so it reads like an asymptote marker. That is why I rate this Minor rather than Misleading. Still, it is not part of the graph of f, and the page does not mention it. The page's note on clamping covers only the polynomials.
- **Fix:** Before plotting, set `ytrue` to `NaN` at samples where consecutive values change sign with magnitude beyond the y-limits. A simpler option is to set `ytrue[i] = NaN` where `abs(ytrue[i]) > 10 * maximum(abs.(case.ylims))`, or to insert explicit NaN points at the known poles (1, −1, ±π/2, 0). Alternatively, add a sentence to the Animations introduction saying that the vertical magenta lines mark poles.

- **Independent check:** not run (Minor finding, unverified)


## Outside the review scope (not counted)

- F5. Page match (Video Animations section), Minor: "abs" is called discontinuous — excluded: concerns the Video Animations section, which is outside this review's scope; recorded for information only

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 34.5 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `series_m01.gif` | 13 | byte-identical | series_animations_all |
| `series_m02.gif` | 13 | byte-identical | series_animations_all |
| `series_m03.gif` | 13 | byte-identical | series_animations_all |
| `series_m04.gif` | 13 | byte-identical | series_animations_all |
| `series_m05.gif` | 13 | byte-identical | series_animations_all |
| `series_m06.gif` | 13 | byte-identical | series_animations_all |
| `series_m07.gif` | 13 | byte-identical | series_animations_all |
| `series_m08.gif` | 13 | byte-identical | series_animations_all |
| `series_m09.gif` | 12 | byte-identical | series_animations_all |
| `series_m10.gif` | 13 | byte-identical | series_animations_all |
| `series_m11.gif` | 13 | byte-identical | series_animations_all |
| `series_m12.gif` | 13 | byte-identical | series_animations_all |
| `series_m13.gif` | 13 | byte-identical | series_animations_all |
| `series_m14.gif` | 13 | byte-identical | series_animations_all |
| `series_m15.gif` | 11 | byte-identical | series_animations_all |
| `series_m16.gif` | 11 | byte-identical | series_animations_all |
| `series_m17.gif` | 11 | byte-identical | series_animations_all |
| `series_m18.gif` | 11 | byte-identical | series_animations_all |
| `series_t01.gif` | 11 | byte-identical | series_animations_all |
| `series_t02.gif` | 11 | byte-identical | series_animations_all |
| `series_t03.gif` | 11 | byte-identical | series_animations_all |
| `series_t04.gif` | 11 | byte-identical | series_animations_all |
| `series_t05.gif` | 11 | byte-identical | series_animations_all |
| `series_t06.gif` | 11 | byte-identical | series_animations_all |
| `series_t07.gif` | 11 | byte-identical | series_animations_all |
| `series_t08.gif` | 9 | byte-identical | series_animations_all |
| `series_t09.gif` | 9 | byte-identical | series_animations_all |
| `series_t10.gif` | 9 | byte-identical | series_animations_all |
| `series_t11.gif` | 9 | byte-identical | series_animations_all |
| `series_t12.gif` | 9 | byte-identical | series_animations_all |
| `series_t13.gif` | 9 | byte-identical | series_animations_all |

### Page references

- Scripts linked: `series_animations_all.jl`
- GIFs embedded: 31
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description (formulas and checkable statements)
| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Series about $x_0$ converges for $|x-x_0|<R$, diverges for $>R$, with $R$ = distance to nearest complex singularity | Confirmed | Standard theorem for analytic f (Cauchy–Hadamard plus analytic continuation) |
| D2 | arctan and $1/(1+x^2)$ have singularities at $\pm i$, so $R=1$ about 0 | Confirmed | Poles/branch points at ±i |
| D3 | tanh has poles at $\pm i\pi/2$, $R=\pi/2$ about 0 | Confirmed | cosh(iπ/2)=0 |
| D4 | log(x) about 1 has $R=1$ | Confirmed | Singularity at 0 |
| D5 | exp, sin, $e^{-x^2/2}$, $J_0$, normal CDF have $R=\infty$ | Confirmed | All entire |
| D6 | Normal CDF order-10 polynomial pulls away beyond about $|x|=2$ | Confirmed | Script values: x=1.5 gap 7.0e-4; x=1.8 gap 4.9e-3; x=2.0 poly 0.99224 vs f 0.97725 (gap 0.015); x=2.2 gap 0.041; x=2.5 gap 0.154. Visible separation in `series_m18/frame_011.png` starts near 2 |
| D7 | At x=3 the order-10 value is 2.0006 | Confirmed | Script 2.000575081929585; mpmath 2.00057508192958528 |
| D8 | Order-40 value within $2\times10^{-7}$ of the true 0.99865 | Confirmed | mpmath: Φ(3)=0.998650101968; T₄₀(3)=0.998649986603, error −1.154e-7 (Float64 sum gives the same) |
| D9 | $T_n(x)=\sum_{k=0}^n f^{(k)}(x_0)/k!\,(x-x_0)^k$; Maclaurin is $x_0=0$ | Confirmed | Script `partial_sum` evaluates exactly this with coefficients $f^{(k)}(c)/k!$ (verified, section 3) |
| D10 | A composite rule exact for the constant and linear but not the quadratic terms is second-order; trapezoidal is an example | Confirmed | Composite trapezoid on ∫₀¹eˣ: errors 2.237e-3, 5.593e-4, 1.398e-4, 3.496e-5 for n=8,16,32,64 (ratio 4.0) |
| D11 | Taylor series is a special case of a power series; Laurent allows negative powers | Confirmed | Definitions |

### Video Animations section (checked although outside the named scope)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | exp about 0 has infinite radius | Confirmed | Entire |
| V2 | Sine has no singularities; infinite radius | Confirmed | Entire |
| V3 | tanh radius π/2≈1.571 about 0, √(0.25+π²/4)≈1.648 about 0.5 | Confirmed | mpmath 1.64845 |
| V4 | arctan radius 1 about 0, √1.25≈1.118 about 0.5 | Confirmed | mpmath 1.11803 |
| V5 | "two discontinuous functions, abs and sign" | **Wrong** | F5 |
| V6 | Taylor series of $\sqrt{|x|}\operatorname{sign}(x)$ about 0.5 cannot converge across x=0 | Confirmed | Non-analytic at 0, so R=0.5 |
| V7 | Videos generated by `taylor_series_animation_code.m` | Confirmed (file present, cases exp/tanh/atan/1/x/1/(x−1)/sin match the headings); video contents not viewable here | grep of the .m file |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Steps through Taylor polynomials one order per frame | Confirmed | Loop `for k in 0:n_terms`; frame label "order = k"; frame counts n+1 (13/12/11/9) match the manifest |
| A2 | One frame per second | Confirmed | `fps = 1`; PIL frame duration 1000 ms in all 31 GIFs |
| A3 | Current order blue | Confirmed | `color=:steelblue` |
| A4 | Previous order gray, from order 1 on | Confirmed | `y_prev = sums[k]`; at order 0 gray equals blue and is hidden |
| A5 | Target function magenta | Confirmed | `color=:magenta` (see F4 for pole segments) |
| A6 | Red dot marks $(x_0,f(x_0))$ | Confirmed | `scatter!([case.c],[f(c)])`; visible at the right place in all sheets |
| A7 | Polynomial parts outside the y-range drawn along the top or bottom edge | Confirmed | `clamp.` at line 353; visible in the frames |
| A8 | All 31 GIFs from one Julia script; link `series_animations_all.jl` | Confirmed | Manifest: 31 byte-identical regenerations |
| A9 | Maclaurin Cases (18), Taylor Cases (13) | Confirmed | 18 m-rows and 13 t-rows |

### Case headings, embeds, GIF titles (every row)
Each heading was checked against the script row (function, $x_0$, xlims), the embed filename, the GIF title read from the sheets, and the alt text.

| Case | Heading f, $x_0$, interval | Script row | GIF title | Embed | Alt text | Verdict |
|---|---|---|---|---|---|---|
| M01 | 1/(1−x), 0, [−1.5,1.5] | same | "Maclaurin M01: f(x) = 1/(1-x), x0 = 0.0" | series_m01.gif | ok | Confirmed |
| M02 | 1/(1+x), 0, [−1.5,1.5] | same | M02 1/(1+x) | m02 | ok | Confirmed |
| M03 | 1/(1−x)², 0, [−1.5,1.5] | same | M03 1/(1-x)^2 | m03 | wording "one over one minus x squared in the denominator" is clumsy but means (1−x)² | Confirmed |
| M04 | 1/√(1−x), 0, [−1.5,1.5] | same | M04 1/sqrt(1-x) | m04 | ok | Confirmed |
| M05 | 1/(1+x²), 0, [−1.5,1.5] | same | M05 | m05 | ok | Confirmed |
| M06 | log(1+x), 0, [−1.5,1.5] | same | M06 | m06 | ok | Confirmed |
| M07 | sin, 0, [−3π,3π] | same | M07 | m07 | ok | Confirmed |
| M08 | cos, 0, [−3π,3π] | same | M08 | m08 | ok | Confirmed |
| M09 | tan, 0, [−π,π] | same | M09 | m09 | ok | Confirmed (F4 artefact) |
| M10 | $e^{-x^2/2}$, 0, [−2,3] | same | M10 exp(-x^2/2) | m10 | ok | Confirmed for internal consistency; **Fidelity F1** |
| M11 | $e^{-x}\cos x$, 0, [−2,4] | same | M11 | m11 | ok | Confirmed |
| M12 | cosh, 0, [−4,4] | same | M12 | m12 | ok | Confirmed |
| M13 | arctan, 0, [−2,2] | same | M13 atan(x) | m13 | ok | Confirmed |
| M14 | arcsin, 0, [−1.5,1.5] | same | M14 asin(x) | m14 | ok | Confirmed |
| M15 | $J_0$, 0, [−10.2,10.2] | same | M15 besselj(0,x) | m15 | ok | Confirmed |
| M16 | $J_1$, 0, [−10.2,10.2] | same | M16 besselj(1,x) | m16 | ok | Confirmed |
| M17 | normal pdf, 0, [−3,3] | same | M17 normal_pdf(x) | m17 | ok | Confirmed |
| M18 | ½+½erf(x/√2), 0, [−3,3] | same | M18 normal_cdf(x) | m18 | ok | Confirmed |
| T01 | √x, 1, [0,10.5] | same | T01 sqrt(x), x0 = 1.0 | t01 | ok | Confirmed |
| T02 | √x, 4, [0,10.5] | same | T02 x0 = 4.0 | t02 | ok | Confirmed |
| T03 | √x, 5, [0,10.5] | same | T03 x0 = 5.0 | t03 | ok | Confirmed (legacy GIF also x0 = 5) |
| T04 | log x, 1, [−0.5,4.1] | same | T04 | t04 | ok | Confirmed |
| T05 | log x, 2, [−0.5,4.1] | same | T05 | t05 | ok | Confirmed |
| T06 | sin, π/4, [−7π/4,9π/4] | same | T06 x0 = 0.7854 | t06 | ok | Confirmed |
| T07 | cos, π/3, [−5π/3,7π/3] | same | T07 x0 = 1.0472 | t07 | ok | Confirmed |
| T08 | Γ, 2, [−0.2,5.2] | same | T08 gamma(x), x0 = 2.0 | t08 | ok | Confirmed internally; **Fidelity F2** (Mathews x0 = 1) |
| T09 | Γ, 3, [−0.2,5.2] | same | T09 x0 = 3.0 | t09 | ok | Confirmed internally; **F2** (Mathews 2) |
| T10 | Γ, 4, [−0.2,5.2] | same | T10 x0 = 4.0 | t10 | ok | Confirmed internally; **F2** (Mathews 3) |
| T11 | $J_0$, 10, [0,22] | same | T11 besselj(0,x), x0 = 10.0 | t11 | ok | Confirmed internally; **Fidelity F3** (Mathews Y₀) |
| T12 | $J_1$, 5, [0,22] | same | T12 besselj(1,x), x0 = 5.0 | t12 | ok | Confirmed internally; **F3** (Mathews Y₀) |
| T13 | $Y_0$, 2, [0,22] | same | T13 bessely(0,x), x0 = 2.0 | t13 | ok | Confirmed |

Legacy cases not listed above (M01–M09, M11–M18, T01–T07, T13) match Mathews' function, centre and interval. M18 is Mathews' "½+½Erf(x/√2)" on [−3,3].

---

### 3. Implementation checks (`series_animations_all.jl`)

**It is the method it claims to be.** Each frame draws the degree-k Taylor polynomial $T_k(x)=\sum_{j\le k}a_j(x-c)^j$ (`partial_sum`, lines 335–344), for k = 0..n. The Maclaurin coefficients are closed forms per case (lines 225–333). The Taylor coefficients come from `taylor_coeffs_exact` (lines 146–208), which is exact in 256-bit BigFloat:
- binomial series for √x;
- $(-1)^{k-1}/(k c^k)$ for log;
- the sin/cos derivative cycle;
- Γ via $\log\Gamma(c+z)=\log\Gamma(c)+\psi(c)z+\sum_{m\ge2}(-1)^m\zeta(m,c)z^m/m$, exponentiated with the recurrence $k g_k=\sum_j j\,l_j g_{k-j}$;
- Bessel $J$/$Y$ via $Z^{(k)}_\nu=2^{-k}\sum_j(-1)^j\binom{k}{j}Z_{\nu-k+2j}$.

These are correct identities. None of it is a fitted or approximate substitute.

**The numbers are right.** I instrumented a scratch copy (`review/coeffs_dump.jl`, which strips the plotting) to dump every case's coefficient vector to `review/coeffs.tsv`. I compared those vectors independently (`review/indep.py`). Maclaurin cases used `sympy.series` of the symbolic function, including besselj, erf, tan and asin. Taylor cases used `mpmath.taylor` at 60 digits on mpmath's own sqrt, log, sin, cos, gamma, besselj and bessely, which does not depend on the script's formulas. The result is the maximum relative coefficient error per case:

| m01–m05 | m06 | m07 | m08 | m09 | m10 | m11 | m12 | m13 | m14 | m15 | m16 | m17 | m18 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 5.6e-17 | 6.7e-17 | 8.6e-17 | 8.6e-17 | 5.6e-17 | 6.7e-17 | 8.6e-17 | 5.6e-17 | 5.6e-17 | 5.6e-17 | 5.6e-17 | 1.3e-16 | 1.3e-16 |

| t01 | t02 | t03 | t04 | t05 | t06 | t07 | t08 | t09 | t10 | t11 | t12 | t13 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 0 | 8.3e-17 | 5.6e-17 | 5.6e-17 | 9.5e-17 | 9.3e-17 | 6.4e-17 | 9.3e-17 | 6.6e-17 | 8.1e-17 | 9.5e-17 | 5.8e-17 |

The worst case is 1.32e-16, which is Float64 rounding. Matching all coefficients is the same as $T_n$ matching $f^{(k)}(x_0)$ for k ≤ n, the property check the review standard names. I also spot-checked evaluated partial sums against independent mpmath polynomials (`review/fvals.jl`):

| Case, x | Script $T_n$ | Independent $T_n$ |
|---|---|---|
| m09, 1.4 | 4.41143263360075 | 4.41143263360075 |
| m15, 8 | −23.8177777777778 | −23.8177777777778 |
| m18, 2 | 0.992239893066741 | 0.992239893066741 |
| t06, −5 | −4.29511849243889 | −4.29511849243889 |
| t08, 5.2 | 42.2471968078914 | 42.2471968078914 |
| t08, 0.5 | 1.62476834094003 | 1.62476834094003 |
| t11, 4 | −2.43044952675234 | −2.43044952675234 |
| t11, 16 | −3.62340706373968 | −3.62340706373967 |
| t13, 0.5 | −0.427974789380034 | −0.427974789380034 |
| t13, 6 | −12.676877648731 | −12.676877648731 |

**Reference values (the magenta f).** These are Julia Base and SpecialFunctions functions. I compared them with mpmath at the same points, and all agree to 15 digits:
- Γ(5.2) = 32.5780960503314 vs 32.5780960503313;
- Γ(0.5) = 1.77245385090552;
- Y₀(0.5) = −0.444518733506707;
- Y₀(6) = −0.288194683981579;
- J₀(4) = −0.397149809863847;
- J₀(16) = −0.174899073983629;
- J₀(8) = 0.171650807137554;
- tan(1.4) = 5.79788371548289;
- Φ(2) = 0.977249868051821.

Out-of-domain samples (√ or log of a negative, asin with |x|>1, Y₀(0)) become NaN through `safe_eval` and are correctly left blank.

**The picture shows what was computed.** I read the contact sheets of all 31 GIFs, and M01 frame 13 at full size.
- Titles show the right ID, function label and $x_0$ (rounded to 4 digits) in every case.
- The "order = k" label matches the loop index.
- The gray curve is order k−1 and the blue curve is order k.
- The red dot is at $(c,f(c))$.
- Axis ranges match the table.
- Frame counts are n+1 (13, 12 for M09, 11, 9), with 1000 ms per frame.
- Clamping of polynomials to the y-limits is disclosed on the page and does not hide any claimed feature. The M18 value 2.0006 at x=3 lies off-window but is stated numerically in the text.

The one display problem is the unmasked pole join in the magenta curve (F4). Committed GIFs are byte-identical to a scratch regeneration (manifest), so the frames reflect the current code.

**Not findings (noted for completeness):** in some frames the "order = k" annotation overlaps the y-tick label or a curve, which is cosmetic. The legend lists "previous order" at order 0, when the gray curve is hidden under blue. For odd or even functions, alternate frames add a zero term, so blue equals gray in those frames. That is correct behaviour.

