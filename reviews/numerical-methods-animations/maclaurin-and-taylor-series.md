# Maclaurin and Taylor Series — animation review

Page: [`pages/numerical-methods/maclaurin-and-taylor-series/index.qmd`](../../pages/numerical-methods/maclaurin-and-taylor-series/index.qmd) · Scripts: `series_animations_all.jl` · GIFs: 31

**Result:** 2 error, 0 misleading, 3 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — None of the 13 "Taylor" cases (T01–T13) uses Taylor coefficients: they come from a least-squares polynomial fit over a wide stencil, and many are wrong in sign and magnitude

- **Location:** `series_animations_all.jl:68-121` (`taylor_coeffs`), called for every Taylor case at line 248. The page's formula at `index.qmd:17-19` ($T_n(x)=\sum f^{(k)}(x_0)(x-x_0)^k/k!$), the headings at `index.qmd:166-218` ("Taylor Cases (13)", T01–T13), and every T-GIF title ("Taylor T0x: …").
- **Now:** For each Taylor case the script samples f at 2q+1 equally spaced points x0 + h·(−q..q) (q = max(n+2, 8), h = min(0.03·plot width, 0.95·room to the nearer plot edge/q)) and fits a degree-n polynomial to them by least squares (`A \ yy`, line 114). The comment at lines 69-70 says so ("Fit a local polynomial around c using nearby sample points"). The stencils are wide, often reaching nearly to the singularity that sets the radius of convergence, and for T04 beyond it:

  | case | stencil | radius of convergence / singularity |
  |---|---|---|
  | T01 √x, x0=1 | [0.05, 1.95] | 1 (x=0): stencil spans 95% of the radius |
  | T02 √x, x0=4 | [0.22, 7.78] | 4 |
  | T03 √x, x0=5 | [1.22, 8.78] | 5 |
  | T04 log x, x0=1 | [−0.425, 2.425] (21 finite points; the 4 negative ones are dropped) | 1: right half of stencil goes past x=2, outside the disc |
  | T05 log x, x0=2 | [0.344, 3.656] | 2 |
  | T06 sin, x0=π/4 | [−3.74, 5.31] | ∞ |
  | T07 cos, x0=π/3 | [−3.48, 5.57] | ∞ |
  | T08 Γ, x0=2 | [0.38, 3.62] | 2 (pole at 0) |
  | T09 Γ, x0=3 | [1.38, 4.62] | 3 |
  | T10 Γ, x0=4 | [2.86, 5.14] | 4 |
  | T11 J0, x0=10 | [3.4, 16.6] | ∞ |
  | T12 J1, x0=5 | [0.25, 9.75] | ∞ |
  | T13 Y0, x0=2 | [0.10, 3.90] | 2 (log singularity at 0) |

  The higher-degree terms of f on that window alias into the fitted coefficients. The frame labelled "order = k" is then the degree-k truncation of this degree-n fit. It is neither the Taylor polynomial T_k nor a degree-k fit.
- **True:** The Taylor coefficients f^(k)(x0)/k!. Script coefficients beside the exact ones (selection; all coefficients are listed in `check_coeffs.py` output):

  | case | k | script | exact | note |
  |---|---|---|---|---|
  | T01 | 3 | 0.03346 | 0.06250 | |
  | T01 | 4 | +0.02237 | −0.03906 | wrong sign |
  | T01 | 8 | +0.4484 | −0.01309 | wrong sign, 35× too big |
  | T02 | 4 | +1.157e−4 | −3.052e−4 | wrong sign |
  | T02 | 8 | +1.229e−5 | −3.995e−7 | wrong sign, 32× too big |
  | T03 | 7 | −2.93e−7 | +4.61e−7 | wrong sign |
  | T04 | 0 | −0.00288 | 0 (log 1) | |
  | T04 | 2 | −0.3576 | −0.5 | |
  | T04 | 6 | +2.282 | −0.1667 | wrong sign |
  | T05 | 7 | −5.18e−3 | +1.116e−3 | wrong sign |
  | T06 | 9 | 1.171e−6 | 1.949e−6 | 40% off |
  | T07 | 9 | −1.435e−6 | −2.387e−6 | 40% off |
  | T08 | 3 | 0.01755 | 0.08158 | |
  | T08 | 5 | +0.07647 | −2.670e−4 | wrong sign, 287× too big |
  | T08 | 6 | −0.0456 | +0.01115 | wrong sign |
  | T09 | 7 | 7.18e−3 | 5.45e−3 | 32% off |
  | T10 | 7 | 4.51e−2 | 3.84e−2 | 17% off |
  | T11 | 0 | −0.24013 | −0.24594 (J0(10)) | |
  | T11 | 5 | −6.61e−5 | +4.75e−5 | wrong sign |
  | T11 | 7 | +7.1e−8 | −4.83e−6 | wrong sign |
  | T12 | 7 | −6.8e−8 | −1.71e−6 | 96% off |
  | T13 | 1 | 0.08926 | 0.10703 (−Y1(2)) | 17% off |
  | T13 | 4 | −0.05135 | +0.006431 | wrong sign, 8× |
  | T13 | 8 | −7.80e−3 | −2.91e−4 | 27× |

  The 18 Maclaurin cases use closed-form coefficients and are exact (see Implementation checks). The fallback to `taylor_coeffs` at line 227 is never reached for them.
- **Effect on the GIFs** (`check_coeffs.py`, second table: the largest difference between the script's clamped partial sum and the true Taylor polynomial, clamped the same way, as a % of the y-axis height; 100% means the two leave the plot in opposite directions):
  T01 100% (orders 4, 7, 8) · T02 100% (order 7) · T03 5.8% · T04 100% (orders 6–8) · T05 100% (order 8) · T06 79.6% (order 10) · T07 79.5% (order 10) · T08 96.6% (order 6) · T09 4.7% · T10 12.8% (order 8) · T11 46.4% (order 8) · T12 46.4% (order 8) · T13 100% (orders 3–6).
  So the error is plainly visible in 10 of 13 GIFs (T03 and T09 are within a few pixels; T10 differs only at order 8 near x≈0.85). The overlays in `reviewer/compare_t01_t07.png` and `reviewer/compare_t08_t13.png` show this directly. Specific misleading pictures:
  - **Convergence is not shown.** True Taylor polynomials agree with f over a growing interval as the order rises (inside the radius). The script's sums do not: in T01 the 1% agreement interval is [0.26, 3.15] at order 3, [0.05, 1.72] at order 5 and [0.29, 1.90] at order 6. In T04 it is [0.58, 2.00] at order 2, then [0.39, 1.54] at order 4 and [0.48, 1.64] at order 5 (`agreement.py`). The order-to-order sequence a viewer watches is not the Taylor sequence.
  - **T04, log x about 1, appears to converge past the radius.** At order 10 the script's curve lies on log x out to x≈2.50. The true T10 leaves it at x≈2.02, as it must, since the radius is 1. T02 at order 3 hugs √x all the way to x=10.5, past the radius edge at 8 (true T3: to 7.74).
  - **T11/T12 (Bessel, entire):** the order-8 curve tracks J0 on [3.23, 16.71] and J1 on [0.00, 10.25]. The true T8 tracks only [6.12, 13.53] and [1.27, 8.57]. The GIF overstates the accuracy of a degree-8 Taylor polynomial by roughly a factor of two in reach. Also, T11/T12 order 7 is nearly identical to order 6, because the fitted 7th coefficients are about 0 (7e−8 and −7e−8 against −4.8e−6 and −1.7e−6).
  - **Opposite divergence direction:** T01 order 7 and T13 order 5 diverge downward where the true polynomials diverge upward; T08 orders 6–7 turn down near x=4.5 where the true T6, T7 do not (true T6 within 1% out to x=4.64).
  - Even the low orders are off: T13's tangent line (order 1) has slope 0.0893 instead of Y0′(2) = −Y1(2) = 0.1070, and T11's order-0 line sits at −0.2401 instead of J0(10)=−0.2459 (small on screen, but not the Taylor polynomial).
- **Evidence:** `cd reviewer && julia coeffs_dump.jl` (stencils printed above, coefficients to `script_coeffs.txt`); `/usr/bin/python3 -I check_coeffs.py` (coefficient table and curve differences); `/usr/bin/python3 -I agreement.py` (agreement intervals); `julia compare_exact.jl` (overlay PNGs). Committed frames inspected: `series_t04`, `series_t08`, `series_t11`, `series_t13` contact sheets and `series_t01/frame_011.png`; they show the fitted (wrong) curves, e.g. T04 order 10 hugging log x to ≈2.5 and T11 order 8 reaching the J0 extrema at x≈3.8 and x≈16.5.
- **Suggested fix:** Replace `taylor_coeffs` with exact Taylor coefficients. All 13 functions have simple closed forms or recurrences:
  - √x about c: binomial(1/2, k)·c^(1/2−k).
  - log x about c: a0 = log c, a_k = (−1)^(k+1)/(k·c^k).
  - sin/cos about c: a_k = sin(c + kπ/2)/k! (resp. cos(c + kπ/2)/k!).
  - J_ν about c: J_ν^(k)(c) = 2^(−k) Σ_{j=0..k} (−1)^j C(k,j) J_{ν−k+2j}(c), and likewise for Y_ν (use J_{−m} = (−1)^m J_m, Y_{−m} = (−1)^m Y_m). Divide by k!.
  - Γ about c: exponentiate the series log Γ(c+t) = log Γ(c) + Σ_{k≥1} ψ^{(k−1)}(c) t^k/k! (`SpecialFunctions.polygamma`), or use TaylorSeries.jl.

  Then delete the fitting routine, so that the Taylor cases implement the formula the page shows at lines 17-19. If fitting is kept for any reason, the headings and titles must stop calling the curves Taylor polynomials, but the exact route is simple and is what the page teaches.

- **Independent check:** confirmed with correction. Checker (exact mpmath coefficients): 8 of 13 Taylor cases have coefficients of the wrong sign; higher-order coefficients are off by up to 287×. All 13 Taylor GIFs visibly differ from the true Taylor polynomials, 11 badly (T03 and T09 only slightly). Correction: the 'appears to converge beyond the radius' effect clearly holds only for T04 (order 10 gives 0.880 at x=2.4 vs log 0.876, where the true polynomial gives −0.741); in T01, T02, T08 and T13 the fitted polynomials diverge faster than the true ones beyond the radius.

### F2 — Error — Page match — The Description's convergence heuristic ("asymptotes" and "behaves like a polynomial") is false, and five cases on this same page contradict it

- **Location:** `index.qmd:12`: "It has similar properties to polynomials, such as not having horizontal or vertical asymptotes. This is helpful for understanding when the Taylor series converges or doesn't converge. For functions that are infinitely differentiable but have asymptotes ($arctan(x)$, rational functions, $tanh(x)$), the Taylor series will converge locally but not globally. For functions that do not behave like polynomials (grows slower or faster) but are infinitely differentiable, the Taylor series can converge locally but not globally ($log(x)$). The Taylor series will converge globally for functions that behave like polynomials ($exp(x)$)."
- **Now:** The page says a convergent Taylor series cannot have horizontal asymptotes, that having asymptotes is what limits convergence, and that growth unlike a polynomial's limits convergence while polynomial-like growth (exp) gives global convergence.
- **True:** The radius of convergence about x0 is the distance to the nearest singularity of f in the complex plane. Real-axis asymptotes and growth rate do not determine it.
  - Entire functions with horizontal asymptotes have Maclaurin series that converge for every x: e^{−x²/2} (M10), the normal density (M17), the normal CDF ½+½erf(x/√2) (M18, which has two horizontal asymptotes exactly like tanh and arctan), and J0, J1 (M15, M16, which decay to 0).
  - arctan, tanh and 1/(1+x²) are smooth on the whole real line. Their radii are limited by complex singularities: ±i for arctan and 1/(1+x²) (radius 1), ±iπ/2 for tanh (radius π/2).
  - exp grows faster than every polynomial, which by the page's own previous sentence ("grows slower or faster") would put it in the "can fail" class, yet its series converges everywhere.
  - log's radius about 1 is 1 because of the singularity at 0, not because of slow growth.

  The page's own GIFs make the false reading tempting. At the displayed order 10, M18 visibly runs off at |x|>2, and M10 at order 12 gives 4.68 at x=3 (true 0.0111). Both converge there with more terms.
- **Evidence:** `/usr/bin/python3 -I reviewer/desc_checks.py`:
  - Normal-CDF Maclaurin partial sums at x=3 (true Φ(3)=0.998650101968): order 10 → 2.0006, order 20 → 0.95995, order 30 → 0.998796, order 40 → 0.99864999 (err 1.2e−7), order 60 → err 2.6e−15. At x=10 the order-400 partial sum is 1.0 = Φ(10).
  - e^{−x²/2} at x=3: order 12 → 4.679, order 60 → 0.01110899654 (exact).
  - Root-test |a_k|^(−1/k) near k=60: tanh 1.564 (→ π/2=1.5708); arctan 1.07 (→1); 1/(1+x²) 1.000. For erf, e^{−x²/2} and exp it keeps growing (≈5, ≈4.9 and ≈23 and rising), as for an entire function.
- **Suggested fix:** Replace the heuristic with the correct criterion, for example: "The series about x0 converges for |x−x0| < R, where R is the distance from x0 to the nearest singularity of f in the complex plane. arctan(x) and 1/(1+x²) have singularities at ±i, so R=1 about 0, even though both are smooth on the real line; tanh(x) has poles at ±iπ/2, so R=π/2; log(x) about 1 has R=1 because of x=0. Functions with no singularities anywhere (exp, sin, cos, e^{−x²/2}, erf, J0) have R=∞, whether or not they have horizontal asymptotes." Optionally note that M10/M17/M18 converge on the whole window at higher order than shown.

- **Independent check:** confirmed. Checker: M10, M11, M15–M18 have horizontal asymptotes and converge everywhere; cosh (M12) and exp grow faster than any polynomial and also converge everywhere.

### F3 — Minor — Page match — "smooth transition between successive partial sums" does not describe the GIFs

- **Location:** `index.qmd:85`: "Each animation shows a smooth transition between successive partial sums overlaid on the target function."
- **Now:** Each GIF has exactly one frame per order (n+1 frames: 13, 12 for M09, 11 for T01–T07, 9 for T08–T13), each held for 1000 ms. The previous order is drawn in gray and the current order in blue (script lines 253-254, 283-287). There are no interpolated in-between frames.
- **True:** The animation steps discretely, one order per second, with the previous order kept as a gray reference.
- **Evidence:** `/usr/bin/python3 -I reviewer/gif_timing.py <repo>/series_m01.gif …`: "series_m01.gif 13 frames, durations(ms)= [1000]", "series_m09.gif 12 frames", "series_t13.gif 9 frames". The `nframes` files for all 31 GIFs agree with n_terms+1.
- **Suggested fix:** "Each animation steps through the partial sums one order per frame, showing the current order (blue) and the previous order (gray) over the target function (magenta); the red dot marks (x0, f(x0))."

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Page match — Order-of-accuracy example is off by one under the site's meaning of "numerical integration"

- **Location:** `index.qmd:23`: "For instance, in numerical integration, a method is second-order accurate if it accurately estimates the Taylor series' constant, linear, and quadratic terms."
- **Now:** Second order is equated with exactness through the quadratic term.
- **True:** On this site "Numerical Integration" is the quadrature section (Trapezoidal, Simpson, …; `pages/numerical-methods/index.qmd:95-109`). For quadrature, the composite error is O(h^{d+1}) for a rule exact through degree d, so second order corresponds to exactness for constant and linear terms only. The trapezoidal rule is second order and is not exact for x². A rule exact through quadratics is at least third order (Simpson's is fourth). The sentence is correct for ODE time-stepping ("numerical integration" of an ODE: matching y(t+h)'s Taylor terms through h² gives second order), so this may only be a wording issue.
- **Evidence:** `reviewer/desc_checks.py`: a single trapezoid panel on [0,1] gives 1, 0.5, 0.5 for x⁰, x¹, x² (exact 1, 0.5, 0.3333); composite trapezoid on e^x has error ratio err(10)/err(20) = 3.9995, i.e. order 2.0.
- **Suggested fix:** Either "in numerical solution of ODEs, a method is second-order accurate if its step reproduces the solution's Taylor series through the h² term", or, for quadrature, "a composite rule is second-order accurate if it integrates the constant and linear Taylor terms exactly (e.g. the trapezoidal rule)".

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — "Other infinite series exist, such as the Laurent or the Power series"

- **Location:** `index.qmd:25`.
- **Now:** Power series are listed as an alternative to Taylor series.
- **True:** A Taylor series is a power series: the power series whose coefficients are f^(k)(x0)/k!. Laurent series generalize power series to negative powers.
- **Evidence:** This follows from the definition, and the page's own formula at line 18 is a power series in (x−x0).
- **Suggested fix:** "Related series include the Laurent series (which allows negative powers) and Fourier series; Padé approximants…", or say "Taylor series are a special case of power series".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `series_animations_all.jl` | yes | 20.7 | 31 GIFs |

Committed GIFs byte-identical to their regenerated output: **31 of 31**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Taylor Series is an infinite sum of monomial terms." | definition | confirmed |
| 2 | 12 | "It has similar properties to polynomials, such as not having horizontal or vertical asymptotes." | e^{−x²/2}, normal CDF: entire, series = f everywhere, horizontal asymptotes (desc_checks.py) | wrong (→ F2) |
| 3 | 12 | "For functions that are infinitely differentiable but have asymptotes (arctan, rational functions, tanh), the Taylor series will converge locally but not globally." | radii arctan 1, tanh π/2 are correct, but the cause is complex singularities; M10/M15–M18 have asymptotes and converge globally | wrong as stated (→ F2) |
| 4 | 12 | "functions that do not behave like polynomials (grows slower or faster) … can converge locally but not globally (log(x))" | log's radius is set by x=0; exp grows faster yet R=∞ | wrong (→ F2) |
| 5 | 12 | "The Taylor series will converge globally for functions that behave like polynomials (exp(x))." | exp: R=∞ is true; the stated reason is not | conclusion confirmed, reasoning wrong (→ F2) |
| 6 | 15-19 | degree-n Taylor polynomial $T_n(x)=\sum_{k=0}^{n} f^{(k)}(x_0)(x-x_0)^k/k!$ | formula correct; implemented exactly for M01–M18 (closed forms), not for T01–T13 (LSQ fit) | formula confirmed; script does not implement it for Taylor cases (→ F1) |
| 7 | 21 | "The Maclaurin polynomial is the special case $x_0=0$." | definition; all M cases have c=0.0 | confirmed |
| 8 | 21 | "Near singularities or non-smooth points, series may converge locally but fail globally." | e.g. M01, M06, T01, T04 | confirmed |
| 9 | 23 | "in numerical integration, a method is second-order accurate if it accurately estimates the Taylor series' constant, linear, and quadratic terms" | trapezoid: order 2, exact only through linear (desc_checks.py); correct under ODE meaning | wrong under the site's quadrature meaning (→ F4) |
| 10 | 25 | "Other infinite series exist, such as the Laurent or the Power series." | a Taylor series is a power series | wrong (→ F5) |
| 11 | 25 | "Padé approximant is very similar to a truncated Taylor series but is instead a ratio of two polynomials." | definition | confirmed |
| 12 | 85 | "Each animation shows a smooth transition between successive partial sums" | one frame per order, 1000 ms each (gif_timing.py) | wrong (→ F3) |
| 13 | 85 | "…overlaid on the target function." | magenta f(x) in every frame | confirmed |
| 14 | 87 | "All 31 GIFs on this page are generated by one Julia script" | manifest: all 31 produced by series_animations_all.jl, byte-identical | confirmed |
| 15 | 89 | link "series_animations_all.jl" | file exists, is the producer | confirmed |
| 16 | 92 | "Maclaurin Cases (18)" | 18 m-rows in table, 18 GIFs | confirmed |
| 17 | 166 | "Taylor Cases (13)" | 13 t-rows, 13 GIFs; but the curves are not Taylor polynomials | count confirmed; content wrong (→ F1) |
| 18 | 94-96 | M01 $1/(1-x)$, $x_0=0$, $[-1.5,1.5]$; alt "one over one minus x centered at zero"; series_m01.gif | script row 24 matches; title "Maclaurin M01: f(x) = 1/(1-x), x0 = 0.0"; coeffs exact (all 1) | confirmed |
| 19 | 98-100 | M02 $1/(1+x)$, 0, $[-1.5,1.5]$ | row 25; title matches; coeffs exact | confirmed |
| 20 | 102-104 | M03 $1/(1-x)^2$, 0, $[-1.5,1.5]$; alt "one over one minus x squared in the denominator" | row 26; title "1/(1-x)^2"; coeffs k+1 exact (alt wording is ambiguous but the heading is exact) | confirmed |
| 21 | 106-108 | M04 $1/\sqrt{1-x}$, 0, $[-1.5,1.5]$ | row 27; title matches; coeffs C(2k,k)/4^k exact | confirmed |
| 22 | 110-112 | M05 $1/(1+x^2)$, 0, $[-1.5,1.5]$ | row 28; title matches; coeffs exact | confirmed |
| 23 | 114-116 | M06 $\log(1+x)$, 0, $[-1.5,1.5]$ | row 29; title matches; coeffs exact | confirmed |
| 24 | 118-120 | M07 $\sin x$, 0, $[-3\pi,3\pi]$ | row 30 (±9.4248); title matches; coeffs exact | confirmed |
| 25 | 122-124 | M08 $\cos x$, 0, $[-3\pi,3\pi]$ | row 31; title matches; coeffs exact | confirmed |
| 26 | 126-128 | M09 $\tan x$, 0, $[-\pi,\pi]$ | row 32 (order 11); title matches; 1, 1/3, 2/15, 17/315, 62/2835, 1382/155925 exact | confirmed |
| 27 | 130-132 | M10 $e^{-x^2/2}$, 0, $[-2,3]$ | row 33; title "exp(-x^2/2)"; coeffs exact | confirmed |
| 28 | 134-136 | M11 $e^{-x}\cos x$, 0, $[-2,4]$ | row 34; title matches; Re((−1+i)^k)/k! exact | confirmed |
| 29 | 138-140 | M12 $\cosh x$, 0, $[-4,4]$ | row 35; title matches; coeffs exact | confirmed |
| 30 | 142-144 | M13 $\arctan x$, 0, $[-2,2]$ | row 36; title "atan(x)"; coeffs exact | confirmed |
| 31 | 146-148 | M14 $\arcsin x$, 0, $[-1.5,1.5]$ | row 37; title "asin(x)"; coeffs exact | confirmed |
| 32 | 150-152 | M15 $J_0(x)$, 0, $[-10.2,10.2]$ | row 38; title "besselj(0,x)"; coeffs match mpmath.taylor exactly | confirmed |
| 33 | 154-156 | M16 $J_1(x)$, 0, $[-10.2,10.2]$ | row 39; title "besselj(1,x)"; coeffs match mpmath exactly | confirmed |
| 34 | 158-160 | M17 $\frac{1}{\sqrt{2\pi}}e^{-x^2/2}$, 0, $[-3,3]$; alt "normal density" | row 40; title "normal_pdf(x)"; coeffs match (rel 2e−16) | confirmed |
| 35 | 162-164 | M18 $\frac12+\frac12\mathrm{erf}(x/\sqrt2)$, 0, $[-3,3]$; alt "normal CDF" | row 41; title "normal_cdf(x)"; coeffs match (rel 2e−16) | confirmed |
| 36 | 168-170 | T01 $\sqrt x$, $x_0=1$, $[0,10.5]$ | row 44 and title "sqrt(x), x0 = 1.0" match; curves are not Taylor polynomials (100% axis-height discrepancy) | parameters confirmed; content wrong (→ F1) |
| 37 | 172-174 | T02 $\sqrt x$, 4, $[0,10.5]$ | row 45, title match; 100% discrepancy at order 7 | parameters confirmed; content wrong (→ F1) |
| 38 | 176-178 | T03 $\sqrt x$, 5, $[0,10.5]$ | row 46, title match; coefficients wrong from k=3 (sign at k=7), but curves within 5.8% of axis height | parameters confirmed; content wrong but nearly invisible (→ F1) |
| 39 | 180-182 | T04 $\log x$, 1, $[-0.5,4.1]$ | row 47, title match; 100% discrepancy, false agreement to x≈2.5 | parameters confirmed; content wrong (→ F1) |
| 40 | 184-186 | T05 $\log x$, 2, $[-0.5,4.1]$ | row 48, title match; 100% discrepancy at order 8 | parameters confirmed; content wrong (→ F1) |
| 41 | 188-190 | T06 $\sin x$, $\pi/4$, $[-7\pi/4,9\pi/4]$ | row 49 (−5.4978, 7.0686), title "x0 = 0.7854"; 79.6% at order 10 | parameters confirmed; content wrong (→ F1) |
| 42 | 192-194 | T07 $\cos x$, $\pi/3$, $[-5\pi/3,7\pi/3]$ | row 50 (−5.2360, 7.3304), title "x0 = 1.0472"; 79.5% at order 10 | parameters confirmed; content wrong (→ F1) |
| 43 | 196-198 | T08 $\Gamma(x)$, 2, $[-0.2,5.2]$ | row 51, title "gamma(x), x0 = 2.0"; a5 wrong sign ×287; 96.6% | parameters confirmed; content wrong (→ F1) |
| 44 | 200-202 | T09 $\Gamma(x)$, 3, $[-0.2,5.2]$ | row 52, title match; a7, a8 32–35% off, curves within 4.7% | parameters confirmed; content wrong but nearly invisible (→ F1) |
| 45 | 204-206 | T10 $\Gamma(x)$, 4, $[-0.2,5.2]$ | row 53, title match; a7 17% off, 12.8% at order 8 | parameters confirmed; content wrong (→ F1) |
| 46 | 208-210 | T11 $J_0(x)$, 10, $[0,22]$ | row 54, title "besselj(0,x), x0 = 10.0"; order 8 tracks [3.2,16.7] vs true [6.1,13.5] | parameters confirmed; content wrong (→ F1) |
| 47 | 212-214 | T12 $J_1(x)$, 5, $[0,22]$ | row 55, title match; order 8 tracks [0,10.25] vs true [1.27,8.57] | parameters confirmed; content wrong (→ F1) |
| 48 | 216-218 | T13 $Y_0(x)$, 2, $[0,22]$ | row 56, title "bessely(0,x), x0 = 2.0"; a1 17% off, a4 wrong sign; 100% at orders 3–6 | parameters confirmed; content wrong (→ F1) |
| 49 | 96-218 | each embed points at series_<id>.gif of the same id as its heading | manifest page_local_references; titles of all 31 last frames read in `titles_0.png`, `titles_1.png` | confirmed |

## Implementation checks

### series_animations_all.jl
- **Method:**
  - *Maclaurin (M01–M18):* `maclaurin_coeffs` returns hard-coded closed-form Maclaurin coefficients for every id (lines 127-225), and `partial_sum` evaluates Σ a_k (x−c)^k by Horner-like accumulation (lines 233-242). This is the Taylor-polynomial method the page describes.
  - *Taylor (T01–T13):* line 248 calls `taylor_coeffs`, a least-squares polynomial fit to 2q+1 samples (lines 68-121). This is not the Taylor method (F1). No autodiff, recurrence or closed form is used for any Taylor case. The fallback branch (zero coefficients if fewer than n+1 finite samples) is not triggered: finite samples are 21–25 in every case.
- **Numbers:**
  - *Maclaurin:* script coefficients against sympy exact derivatives (elementary) and `mpmath.taylor` at 50 digits (J0, J1): maximum relative difference 0 for M01–M16 and 2.1e−16 for M17/M18, through the full order of each GIF (12, 11 for M09, 10 for M15–M18).
  - *Taylor:* see the F1 table. Maximum relative coefficient error per case: T01 35 (k=8), T02 32 (k=8), T03 4.1 (k=10), T04 19.7 (k=9), T05 9.6 (k=10), T06 0.40 (k=9), T07 0.40 (k=9), T08 287 (k=5), T09 0.35 (k=8), T10 0.17 (k=7), T11 2.4 (k=5), T12 0.96 (k=7), T13 25.8 (k=8).
  - Reference values used for the exact side: Γ(2)=1, Γ'(2)=0.42278433510 (=1−γ), Γ(3)=2, Γ(4)=6, Γ'(4)/1!=7.5367060106; J0(10)=−0.24593576445, J0'(10)=−J1(10)=−0.043472746169; J1(5)=−0.32757913759; Y0(2)=0.51037567265, Y0'(2)=−Y1(2)=0.10703243154 (all mpmath, 50 digits).
- **Reference values:** The "true" curve is f evaluated directly (`safe_eval`, lines 59-66, 246) with Base/SpecialFunctions (`gamma`, `besselj`, `bessely`, `erf`), which is accurate to plotting precision. Out-of-domain points (log of negatives, sqrt of negatives in M04, asin |x|>1, Y0(0)) become NaN and leave gaps, as intended. The red dot is at (c, f(c)), which is correct, so in the Taylor GIFs the order-0 line does not always pass exactly through it (T11: −0.2401 vs −0.2459, below one pixel).
- **Picture:**
  - *Titles:* the title line of the last full-size frame of all 31 GIFs (`reviewer/titles_0.png`, `titles_1.png`) reads "<Family> <ID>: f(x) = <formula>, x0 = <c>", and every one matches its table row and page heading (π/4 and π/3 shown as 0.7854 and 1.0472).
  - *Frames viewed:* contact sheets for M05, M09, M18, T04, T08, T11, T13, and full frame `series_t01/frame_011.png`. Legend: magenta f(x), gray previous order, blue current order, with an "order = k" label at the lower left. In some frames that label overlaps the y-tick "0"; it remains readable.
  - *Axes and frames:* x-limits match the headings. Frame count is n+1 at 1 s per frame.
  - *Clamping:* partial sums are clamped to the y-limits (line 251), so divergent tails run along the top or bottom border. This is the authoring brief's habit and does not mislead about values here, since no value is labelled.
  - *Poles:* f is not masked at poles. tan in M09 shows vertical magenta lines at ±π/2, and Γ in T08–T10 shows one at x=0, where the line connects the two sides of the pole. They read as asymptote markers and do not change any conclusion, so they are not reported as findings.
  - *Plotted sums:* the Maclaurin GIFs draw the correct partial sums. The Taylor GIFs draw the fitted sums described in F1, which differ visibly from the Taylor polynomials in 10 of 13 cases (overlay evidence: `reviewer/compare_t01_t07.png`, `reviewer/compare_t08_t13.png`).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/maclaurin-and-taylor-series/`](evidence/maclaurin-and-taylor-series/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
