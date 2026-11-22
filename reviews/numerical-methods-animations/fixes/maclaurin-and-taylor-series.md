# Fix record: maclaurin-and-taylor-series

Scratch folder with every script and output named below:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/maclaurin-and-taylor-series/fix/` (written `fix/` below).
Old state: `fix/reviewer/` (round-1 evidence scripts copied and re-run; `coeffs_dump.jl` dumps the HEAD script's coefficients), `fix/series_animations_all.HEAD.jl`, `fix/gifs_HEAD.sha1`.
New state: `fix/new/dump_new.jl` (loads the fixed repo script without rendering) → `fix/new/script_coeffs.txt`; the same independent reference (`check_coeffs.py`: sympy derivatives for elementary functions, `mpmath.taylor` at 50 digits for Γ and Bessel) and `agreement.py` re-run on it. Text checks in `fix/checks/`.

## Findings

### F1 — Error — fixed
- Reproduced: `cd fix/reviewer && julia coeffs_dump.jl && /usr/bin/python3 -I check_coeffs.py` (`check_coeffs.out`). Stencils exactly as in the finding (e.g. T01 [0.05, 1.95], T04 [−0.425, 2.425] with 21/25 finite points, T11 [3.4, 16.6]). Max relative coefficient error of the fit: T01 35.3 (k=8), T02 31.8, T03 4.09, T04 19.7, T05 9.60, T06 0.399, T07 0.399, T08 287 (k=5), T09 0.347, T10 0.174, T11 2.39, T12 0.960, T13 25.8. Plotted-curve difference (clamped, % of y-height), worst order: T01 100, T02 100, T03 5.8, T04 100, T05 100, T06 79.6, T07 79.5, T08 96.6, T09 4.7, T10 12.8, T11 46.4, T12 46.4, T13 100 — identical to the finding. The 18 Maclaurin cases: max error ≤ 2.09e-16 (exact). (The re-run fit differs from the round-1 dump by ≤ 1.4e-11 relative, BLAS rounding in the least-squares solve; irrelevant after the fix.)
- Change: `series_animations_all.jl` — the fitting routine `taylor_coeffs` (old lines 68–121) is deleted and replaced by the WP-A routine `taylor_coeffs_exact` with `_bernoulli_numbers`, `_hurwitz_zeta`, `_bessel_big` (new lines 68–208; identical to `patterns/wpa/coeff_routine.jl` lines 1–22 and 25–143, checked with `diff`, only its `using SpecialFunctions` line dropped because the script already loads it). New `taylor_family` table and `taylor_case_coeffs(case)` (lines 210–223): T01–T03 `:sqrt`, T04–T05 `:log`, T06 `:sin`, T07 `:cos`, T08–T10 `:gamma`, T11 `:besselj` ν=0, T12 `:besselj` ν=1, T13 `:bessely` ν=0; an unknown id raises an error. `render_case` calls `taylor_case_coeffs` for Taylor cases (line 350); the Maclaurin fallback that silently called the fit is now `error("no Maclaurin coefficients for case …")` (line 329). No package added.
- Check: `cd fix/new && julia dump_new.jl && /usr/bin/python3 -I check_coeffs.py` (`check_coeffs_new.out`): max relative coefficient error T01–T05, T08–T13 0.0 (equal to the reference rounded to Float64), T06 1.57e-16, T07 3.33e-16 (the reference uses exact π/4, π/3; the script uses the Float64 centre); plotted-curve difference 0.0% at every order of every Taylor case. `agreement.py` on the new coefficients (`agreement_new.out`): T04 order 10 within 1% of log x on [0.17, 2.02] (old fit reached 2.50); T11 order 8 on [6.12, 13.53], T12 order 8 on [1.27, 8.57] — the finding's "true" intervals. Maclaurin coefficients unchanged (function `maclaurin_coeffs` untouched; GIFs byte-identical, below).

### F2 — Error — fixed
- Reproduced: `/usr/bin/python3 -I fix/checks/f2_checks.py` (`f2_checks.out`). Root test |a_k|^(−1/k) near k=60: atan 1.070, 1/(1+x²) 1.000, tanh 1.5646 (π/2 = 1.5708) — finite radii for functions with no real singularity; for exp, sin, cos, e^(−x²/2), erf(x/√2), J0 the estimate grows from k≈30 to k≈60 (exp 12.4→23.6, e^(−x²/2) 3.58→4.91, erf 3.87→5.13, J0 12.8→24.1), as for an entire function. Normal CDF at x=3: order 10 → 2.0006, order 40 → err 1.15e-7. So the page's claims (asymptotes prevent convergence; polynomial-like growth gives global convergence) are false, as the finding says; the checker's addition (exp and cosh grow faster than any polynomial and converge everywhere) is consistent.
- Change: `index.qmd` line 12: the sentences from "It has similar properties to polynomials…" to "…($exp(x)$)." are replaced by the radius-of-convergence criterion with the arctan, 1/(1+x²), tanh, log examples, the list of entire examples, and one M18 sentence (text in the ledger). The first two sentences of the paragraph are kept.
- Check: see ledger rows 1–8.

### F3 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I fix/reviewer/gif_timing.py <page>/series_*.gif` (`checks/gif_timing.out`): every GIF has n_terms+1 frames (13 for M01–M08, M10–M14; 12 for M09; 11 for M15–M18 and T01–T07; 9 for T08–T13), every frame 1000 ms; script `fps = 1`, one `frame(anim, p)` per k in 0:n. No interpolated frames, so "smooth transition" is wrong.
- Change: `index.qmd` line 85 "Each animation shows a smooth transition between successive partial sums overlaid on the target function." → "Each animation steps through the Taylor polynomials one order per frame, one frame per second, showing the current order (blue) and, from order 1 on, the previous order (gray) over the target function (magenta); the red dot marks $(x_0, f(x_0))$. Parts of a polynomial outside the plotted $y$-range are drawn along the top or bottom edge." (D7: text changed to describe the animation.)
- Check: ledger rows 11–14; frames viewed.

### F4 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I fix/checks/f4_checks.py` (`f4_checks.out`): single trapezoid panel on [0,1] gives 1, 1/2, 1/2 for x⁰, x¹, x² (exact 1, 1/2, 1/3); composite trapezoid on eˣ over [0,1]: observed order 1.9998 (n 10→20), 2.0000 (20→40). So a rule second-order in the quadrature sense does not get the quadratic term right; the page's sentence is off by one in the quadrature sense the site uses ("Numerical Integration" = quadrature pages).
- Change: `index.qmd` line 23 "…a method is second-order accurate if it accurately estimates the Taylor series' constant, linear, and quadratic terms." → "…a composite rule that integrates the constant and linear Taylor terms exactly, but not the quadratic term, is second-order accurate; the trapezoidal rule is an example."
- Check: ledger rows 9–10. Cross-check of the general statement with two more rules: midpoint exact for x⁰, x¹, not x² → observed order 1.9997/1.9999; Simpson exact through x³, not x⁴ → order 3.9997/3.9999 (a rule exact through degree d but not d+1 is order d+1).

### F5 — Minor — fixed
- Reproduced: by definition a power series about x0 is Σ a_k (x−x0)^k; the Taylor series is the one with a_k = f^(k)(x0)/k! (the page's own formula, line 18). `/usr/bin/python3 -I fix/checks/f5_checks.py` (`f5_checks.out`): sympy's Taylor series of √x about 1 is a polynomial in (x−1); the Laurent series of 1/(x(1−x)) about 0 is 1/x + 1 + x + x² + …, lowest power −1. So listing "the Power series" as another series besides Taylor is wrong.
- Change: `index.qmd` line 25 "Other infinite series exist, such as the Laurent or the Power series. … Laurent, Power, and Padé approximant may be discussed on other Numerical Methods pages." → "A Taylor series is a special case of a power series. A related series is the Laurent series, which also allows negative powers of $(x-x_0)$. … Laurent series and Padé approximant may be discussed on other Numerical Methods pages." (Padé sentence unchanged.)
- Check: ledger rows 15–16.

## Ledger of changed text

| # | Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|---|
| 1 | index.qmd l.12 | "The series about $x_0$ converges for $\|x-x_0\|<R$ and diverges for $\|x-x_0\|>R$" | Cauchy–Hadamard (general theorem for power series). Numerical illustration `f2_checks.py`: atan (R=1) partial sums at x=0.9: N=21 0.735026, N=101 0.732815, N=201 0.732815 = atan(0.9); at x=1.1: N=21 1.018, N=101 82.3, N=201 566456 | yes |
| 2 | l.12 | "R is the distance from $x_0$ to the nearest singularity of $f$ in the complex plane" | General theorem (f analytic in the largest disc avoiding its singularities). Instances, `f2_checks.py`: atan, 1/(1+x²) root test → 1.07, 1.000 = \|±i\|; tanh → 1.5646 vs π/2 = 1.5708; log about 1: \|a_k/a_{k+1}\| = (k+1)/k → 1 = distance to 0 | yes |
| 3 | l.12 | "Asymptotes and growth rate on the real line do not decide it." | Rows 4–7: functions with horizontal asymptotes have R = 1, π/2 and ∞; exp (faster than any polynomial) has R = ∞, log (slower) has R = 1 about 1 | yes |
| 4 | l.12 | "$\arctan(x)$ and $1/(1+x^2)$ are smooth on the whole real line but have singularities at $\pm i$, so $R=1$ about 0" | `f2_checks.py`: roots of 1+z² = [−i, i]; atan′ = 1/(1+z²); root test → 1.07 (k=61), 1.000 (k=60) | yes |
| 5 | l.12 | "$\tanh(x)$ has poles at $\pm i\pi/2$, so $R=\pi/2$ about 0" | `f2_checks.py`: cosh(iπ/2) = −5e-52 (zero at 50 digits); zeros of cosh are iπ(k+½), nearest \|z\| = 1.5708; root test → 1.5646 (k=61), 1.5644 (k=59) | yes |
| 6 | l.12 | "$\log(x)$ about 1 has $R=1$ because of the singularity at $x=0$" | a_k = (−1)^(k+1)/k (routine `:log`, validated); ratio → 1 = \|1−0\|; T04 frames: order 10 follows log x only on [0.17, 2.02] (`agreement_new.out`) | yes |
| 7 | l.12 | "Functions with no singularities, such as $\exp(x)$, $\sin(x)$, $e^{-x^2/2}$, $J_0(x)$ and the normal CDF, have $R=\infty$, whether or not they have horizontal asymptotes" | All are entire (exp, sin, compositions of entire functions; erf(z) = (2/√π)∫₀^z e^(−t²)dt; J0 power series with infinite radius). `f2_checks.py` root test grows k≈30→60: exp 12.4→23.6, sin 12.4→23.6, e^(−x²/2) 3.58→4.91, erf(x/√2) 3.87→5.13, J0 12.8→24.1. Horizontal asymptotes: e^(−x²/2), J0 → 0; ncdf(−50) = 1e-545, ncdf(50) = 1.0 | yes |
| 8 | l.12 | "The normal CDF (M18 below) has two horizontal asymptotes like $\tanh(x)$, and its order-10 polynomial pulls away from it beyond about $\|x\|=2$, but only because order 10 is too low: at $x=3$ the order-10 value is 2.0006 and the order-40 value is within $2\times10^{-7}$ of the true 0.99865." | Asymptotes 0 and 1 (row 7). `checks/m18_window.out`: M18 order 10 (script coefficients) within 1% of the y-height on [−1.95, 1.95]; script order-10 sum at x=3 = 2.000575 (python on `new/script_coeffs.txt`), mpmath 2.000575082; order 40 err 1.15e-7 < 2e-7; Φ(3) = 0.998650102 → 0.99865. M18 frame 11 viewed: blue curve leaves the window near x≈2.4 (top) and x≈−2.4 (bottom) after separating from magenta around \|x\|≈2 | yes |
| 9 | l.23 | "a composite rule that integrates the constant and linear Taylor terms exactly, but not the quadratic term, is second-order accurate" | `f4_checks.py`: trapezoid exact for x⁰, x¹, not x² → order 1.9998, 2.0000; midpoint same exactness → 1.9997, 1.9999; Simpson (exact through x³) → 3.9997, 3.9999 | yes |
| 10 | l.23 | "the trapezoidal rule is an example" | `f4_checks.py`: trapezoid x⁰ 1 (exact), x¹ 1/2 (exact), x² 1/2 vs 1/3 (not exact); order 2.0 | yes |
| 11 | l.85 | "steps through the Taylor polynomials one order per frame, one frame per second" | `checks/gif_timing.out`: all 31 GIFs have n_terms+1 frames, all 1000 ms; script `fps = 1`, loop `for k in 0:case.n_terms` with one `frame` each; Taylor coefficients now exact (F1), Maclaurin exact (≤2.09e-16) | yes |
| 12 | l.85 | "the current order (blue) and, from order 1 on, the previous order (gray) over the target function (magenta)" | script lines 369–371: f `:magenta`, previous `:gray55`, current `:steelblue`; line 386 `y_prev = k == 0 ? sums[1] : sums[k]` (at order 0 the gray curve equals the blue one). Frames viewed (T01, T04, T08, T11, T13 sheets; T01 frame 11) | yes |
| 13 | l.85 | "the red dot marks $(x_0, f(x_0))$" | script line 374 `scatter!(p, [case.c], [yc]; color=:red)` with `yc = f(c)`; `checks/fc_check.out`: f(x0) finite and inside the y-window in all 31 cases | yes |
| 14 | l.85 | "Parts of a polynomial outside the plotted $y$-range are drawn along the top or bottom edge." | script line 353 `clamp.(ys, case.ylims[1], case.ylims[2])` and plot `ylims=case.ylims`; seen in T01 frame 11 (order 10 runs along the bottom edge from x≈2.8) and T11 order 2 (top edge) | yes |
| 15 | l.25 | "A Taylor series is a special case of a power series." | definition; page formula l.18 is Σ a_k (x−x0)^k; `f5_checks.py` sympy Taylor of √x about 1 is a polynomial in (x−1) | yes |
| 16 | l.25 | "A related series is the Laurent series, which also allows negative powers of $(x-x_0)$." / "Laurent series and Padé approximant may be discussed on other Numerical Methods pages." | `f5_checks.py`: Laurent of 1/(x(1−x)) about 0 = 1/x + 1 + x + x² + …, lowest power −1. Section index lists `pade-approximation/` and `laurent-series/` (`pages/numerical-methods/index.qmd` l.54–55) | yes |
| 17 | GIFs T01–T13, all frames | curves are now the true Taylor polynomials T_k | `check_coeffs_new.out`: plotted difference 0.0% at every order; coefficients equal to the reference | yes |

No headings, alt text or GIF titles changed: the headings "Taylor Cases (13)", T01–T13, the alt texts ("Taylor animation for … centered at …") and the GIF titles ("Taylor T0x: f(x) = …, x0 = …") were wrong only because the curves were not Taylor polynomials; they are now.

## Scripts and GIFs
- Script changed: `series_animations_all.jl` (F1 only). Run: `cd pages/numerical-methods/maclaurin-and-taylor-series && julia series_animations_all.jl` → "Generated 31 GIFs." (27 s).
- `git status -- pages/numerical-methods/maclaurin-and-taylor-series`: modified `index.qmd`, `series_animations_all.jl`, `series_t01.gif` … `series_t13.gif` (13 GIFs). `sha1sum -c fix/gifs_HEAD.sha1`: all 18 `series_m01`–`series_m18.gif` OK (byte-identical, as expected: Maclaurin path untouched), all 13 Taylor GIFs changed.
- Frames extracted with `giftools.jl` to `fix/frames/t01` … `t13`, `fix/frames/m18`. Viewed: contact sheets T01, T04, T08, T11, T13; full size T01 frame 11 (order 10), M18 frame 11. Checked: titles and "order = k" labels legible and matching the frame index; T04 follows log x up to x≈2 and turns away beyond it at every order, as the radius 1 requires (no more apparent convergence to 2.5); T13 order 1 is the tangent at (2, 0.5104) and higher orders separate from Y0 near x≈4 (radius 2); T11 order 8 tracks J0 between the extrema near 7 and 13.3, not to 3.8 and 16.5; T08 orders 6–8 do not turn down near x=4.5. The magenta, gray, blue and red elements are built from f, T_{k−1}, T_k and (x0, f(x0)).

## Legacy archive
Consulted. `n2003/TaylorPolyMod.html` (theory, two Maclaurin examples, formulas as images) links its animations to `a2001/Animations/Interpolation/Series/Series.html`: 18 Maclaurin and 13 Taylor animations. The 13 archived Taylor GIFs (`Taylor01/Tayloraa.gif` … `Taylor13/Taylormm.gif`) were extracted and viewed (`fix/archive/`, overview `first13.png`, sheets for Taylordd, Taylorhh, Taylorkk, Taylormm). They show true Taylor polynomials S_k with a "Convergence Intervals" ±0.01 tolerance bar, going to much higher orders (S24 for log about 1, S29 for Y0, S31 for Γ). Archive T01–T07 match the site's T01–T07 (√x about 1, 4, 5; log x about 1, 2; sin about π/4; cos about π/3). Archive T08–T13 differ from the site: archive has Γ about 1, 2, 3 and Y0 about 10, 5, 2; the site has Γ about 2, 3, 4, J0 about 10, J1 about 5 and Y0 about 2. No finding concerns the case list, so it is left as is (only T13 coincides). The archived Y0-about-2 and log-about-1 pictures behave as the fixed site GIFs do (separation near x=4 and x=2), which agrees with the exact coefficients. Nothing in the archive bears on F2–F5.

## Notes
- The "Video Animations" captions at l.49, 57, 65, first left unchanged here, were fixed in round 2 (below).
- Pre-existing presentation, no finding: the "order = k" label sits over the lowest y tick label in several GIFs (e.g. T01 "0"); the Γ curve in T08–T10 is drawn as a near-vertical line through the pole at x=0. Both unchanged. The clamping is now described in the text (F3 sentence) rather than changed.
- `taylor_series_animation_code.m` (MATLAB video script) not reviewed or touched.
- Outside the page: `laurent-series/laurent_animations_all.jl` still contains a fitting routine (noted by the Padé fixer too); not touched.
- The fit's re-run coefficients differ from the round-1 dump by up to 1.4e-11 relative (least-squares rounding); this did not affect reproducibility of the committed GIFs and is moot after the fix.

## Round 2 after check

The independent resolution check confirmed F1–F5 and raised two new Minor items.

### R2-1 — Minor — fixed: Video Animations captions used the F2 heuristic
- Reproduced: index.qmd l.49 "Sine behaves similarly to a polynomial locally, so the Taylor series converges."; l.57 "Tanh has two horizontal asymptotes. The Taylor series has a limited radius of convergence."; l.65 "arctan has two horizontal asymptotes similar to tanh. The radius of convergence is limited." The first gives a false reason (every smooth function is polynomial-like locally, e.g. 1/(1+x²) has R = 1), and the other two present the asymptotes as the cause. The F2 checks (`f2_checks.out`) and the radii below show the cause is the complex singularities.
- Change (index.qmd):
  - l.49 → "Sine has no singularities in the complex plane, so its Taylor series converges for every $x$; the radius of convergence is infinite."
  - l.57 → "Tanh has two horizontal asymptotes, but what limits the radius of convergence is its poles at $\pm i\pi/2$: the radius is $\pi/2\approx1.571$ about 0 and $\sqrt{0.25+\pi^2/4}\approx1.648$ about 0.5."
  - l.65 → "arctan also has two horizontal asymptotes; its radius of convergence is limited by its singularities at $\pm i$: 1 about 0 and $\sqrt{1.25}\approx1.118$ about 0.5."
- Check: `/usr/bin/python3 -I fix/checks/r2_video2.py` (`r2_video2.out`). It computes the Taylor coefficients by a 1024-point Cauchy integral at 60 digits and tests R = d by checking that |a_k|·d^k neither grows nor decays geometrically while |a_k|·(0.95d)^k decays and |a_k|·(1.05d)^k grows (k = 41, 81, 121):
  - tanh about 0, d = π/2 = 1.5708: 1.273, 1.273, 1.273 (0.95d: 0.155→0.00257; 1.05d: 9.41→466).
  - tanh about 0.5, d = √(0.25+π²/4) = 1.64845: 1.128, 1.202, 1.207 (0.95d → 0.00243; 1.05d → 442).
  - atan about 0, d = 1: 0.0244, 0.0124, 0.0083 (≈1/k; 0.95d → 1.7e-5; 1.05d → 3.03).
  - atan about 0.5, d = √1.25 = 1.11803: 0.0241, 0.0122, 0.0075 (0.95d → 1.5e-5; 1.05d → 2.73).
  - sin about 0 and about 0.5: |a_k|^(−1/k) = 8.68, 12.4, 16.1 and 8.73, 12.5, 16.2 at k = 21, 31, 41, growing as for an entire function.
  - The singularities themselves: cosh(iπ/2) = 2e-43 at 60 digits; 1 + i² = 0. tanh's next poles, ±3iπ/2, are farther away.
  - Rounding: π/2 = 1.5708 → 1.571; 1.64845 → 1.648; 1.11803 → 1.118. The tanh and arctan asymptotes are standard: tanh → ±1, arctan → ±π/2.
- Not checked: the YouTube videos were not viewed. The captions state the radii for the centres named in the headings ("about 0 and 0.5") and make no claim about what the videos show.

### R2-2 — Minor — fixed: internal label in script comment
- Change: `series_animations_all.jl` l.68 "# Exact Taylor coefficients, correctly rounded to Float64 (WP-A shared routine)." → "… (same routine as the Padé approximation page)." `grep -n "WP-A" series_animations_all.jl` now returns nothing. The routine is the same as the one in `pade-approximation/pade_animations_all.jl` (checked with `diff` in round 1).
- Check: `sha1sum *.gif > fix/gifs_round1.sha1` before the edit, then `julia series_animations_all.jl` → "Generated 31 GIFs.", then `sha1sum -c fix/gifs_round1.sha1` → 31 of 31 OK (all byte-identical). `git status --short -- pages/numerical-methods/maclaurin-and-taylor-series` lists the same 15 files as before (index.qmd, the script, series_t01–t13.gif).

### Round 2 ledger
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.49 | "Sine has no singularities in the complex plane, so its Taylor series converges for every $x$; the radius of convergence is infinite." | sin is entire. `r2_video2.out`: root test grows 8.7→12.4→16.1 (about 0) and 8.7→12.5→16.2 (about 0.5) | yes |
| index.qmd l.57 | "two horizontal asymptotes, but … poles at $\pm i\pi/2$" | cosh(iπ/2) = 2e-43 at 60 digits; tanh → ±1 | yes |
| index.qmd l.57 | "$\pi/2\approx1.571$ about 0" | |a_k|(π/2)^k = 1.273 at k = 41, 81, 121; 0.95/1.05 brackets decay/grow | yes |
| index.qmd l.57 | "$\sqrt{0.25+\pi^2/4}\approx1.648$ about 0.5" | d = 1.64845; |a_k|d^k = 1.128, 1.202, 1.207; brackets decay/grow | yes |
| index.qmd l.65 | "arctan also has two horizontal asymptotes; … singularities at $\pm i$" | 1 + i² = 0 (atan′ = 1/(1+z²)); arctan → ±π/2 | yes |
| index.qmd l.65 | "1 about 0 and $\sqrt{1.25}\approx1.118$ about 0.5" | |a_k|d^k ≈ 1/k for d = 1 and d = 1.11803; brackets decay/grow | yes |
| script l.68 | "(same routine as the Padé approximation page)" | round-1 `diff` against `pade_animations_all.jl` lines 71–211; 31/31 GIFs byte-identical after the edit | yes |

## Resolution check (independent checker, not shown this record)

Scratch work: `check/` (run/ = scratch copy of the script and its 31 GIFs; dump/ = coefficient dump; indep.py, mac.py, text_checks.py = independent mpmath checks; frames/ = extracted frames).

### Original findings

### F1 — resolved
- The least-squares `taylor_coeffs` routine is deleted (no call or definition remains); the Taylor cases now call `taylor_case_coeffs` → `taylor_coeffs_exact` (closed forms for sqrt/log/sin/cos, log-Gamma series with Hurwitz zeta for Gamma, the derivative-of-Bessel binomial sum for J0/J1/Y0), computed in 256-bit BigFloat and rounded once. The Maclaurin fallback to the old routine is replaced by `error(...)`.
- Coefficients: dumped all 13 Taylor cases' Float64 coefficients from a scratch copy of the script (`dump/coeffs.txt`) and compared with `mpmath.taylor` at 80 digits (independent: numerical high-precision differentiation of `mp.sqrt, mp.log, mp.sin, mp.cos, mp.gamma, mp.besselj, mp.bessely` about the same Float64 x0). All 13 cases: max relative error ≤ 9.5e-17, and every coefficient (128 of 128) equals the correctly rounded exact value. Values reproduce the "exact" column of the finding (e.g. T08 k=5 −2.6698e−4, T11 k=7 −4.8350e−6, T13 k=1 0.10703, k=4 +6.4313e−3).
- Maclaurin coefficients re-checked the same way: all 18 cases agree to ≤ 1.3e−16 relative.
- Frames: extracted and viewed all 13 Taylor GIFs (contact sheets, plus full-size frames of T04 order 10, T11 order 4, T13 order 1). The pictures now show true Taylor behaviour: T04 order 10 leaves log x at x≈2.0 (the radius edge) instead of hugging it to 2.5; T11 order 8 tracks J0 only on about [6, 13.5] (not to the extrema at 3.8/16.5); T12 order 8 about [1.3, 8.6]; T13 order 1 slope 0.107; T13 order 5 now turns upward to the right (a5 = +2.80e−3 > 0); T08 order 6 stays on Γ to x≈4.6; T01 agreement interval grows monotonically toward [0, 2]; T11/T12 order 7 now visibly differ from order 6. T03 and T09 change only slightly, as expected.
- Maclaurin GIFs unchanged: all 18 regenerated M-GIFs have the sha256 recorded in HEAD's LFS pointers; `git diff --quiet HEAD` is clean for all 18.

### F2 — resolved
- The false heuristic at `index.qmd:12` is gone. The replacement states the correct criterion (R = distance from x0 to nearest complex singularity; convergence inside, divergence outside), with correct examples. All numbers checked (see ledger): arctan, 1/(1+x²) → R=1; tanh → π/2; log about 1 → 1; exp, sin, e^{−x²/2}, J0, normal CDF entire; Φ order-10 at x=3 = 2.00058, order 40 err 1.15e−7 < 2e−7, true 0.998650; order-10 visibly leaves Φ around |x| 1.9–2.1 (also seen in the M18 last frame).
- Residual: the unchanged "Video Animations" captions still carry the same heuristic (lines 49, 57, 65); outside the finding's location, listed below as a new (pre-existing) problem.

### F3 — resolved
- New text at `index.qmd:85`. Checked against the GIFs: every one of the 31 GIFs has exactly one frame per order (n+1 frames) with every frame 1000 ms (PIL); script draws current order steelblue, previous order gray, f magenta, red dot at (x0, f(x0)); at order 0 the "previous" series equals the current one, so gray is first visible from order 1, as stated; partial sums are `clamp`ed to ylims, so off-range parts run along the top/bottom edge (visible in T01, T04, T06, T11, T13 frames).

### F4 — resolved
- New sentence: a composite rule exact for constant and linear terms but not quadratic is second-order; trapezoidal is an example. Checked: single trapezoid panel on [0,1] gives 1, 0.5, 0.5 for 1, x, x² (exact 1, 0.5, 1/3), so it is exact through degree 1 only; composite trapezoid on e^x over [0,1] error ratios under halving 3.9995, 3.99988, 3.99997 → order 2. General statement: panel exact through degree 1 gives local error O(h³), composite O(h²). True.

### F5 — resolved
- "A Taylor series is a special case of a power series. A related series is the Laurent series, which also allows negative powers of (x−x0)." Both true by definition; the "Power series" item is no longer listed as an alternative. The page `laurent-series/` exists, so "may be discussed on other pages" is fine.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:12 | converges for \|x−x0\|<R, diverges for \|x−x0\|>R, R = distance to nearest complex singularity | Cauchy–Hadamard / standard theorem for analytic f | true |
| index.qmd:12 | "Asymptotes and growth rate on the real line do not decide it" | M10/M15–M18 (asymptotes, entire), exp/cosh (super-polynomial growth, entire) | true |
| index.qmd:12 | arctan, 1/(1+x²): singularities ±i, R=1 about 0 | root test at k≈60: 1.0697, 1.000 (→1); 1+z² = 0 at ±i | true |
| index.qmd:12 | tanh poles ±iπ/2, R=π/2 | cosh(iπ/2)=0; root test at k=61: 1.5646 → 1.5708 | true |
| index.qmd:12 | log about 1, R=1 (singularity at 0) | a_k=(−1)^{k+1}/k, root test 1.027 at k=199 → 1 | true |
| index.qmd:12 | exp, sin, e^{−x²/2}, J0, normal CDF have R=∞ | all entire | true |
| index.qmd:12 | M18 has two horizontal asymptotes like tanh | Φ→0, 1 | true |
| index.qmd:12 | order-10 polynomial pulls away beyond about \|x\|=2 | \|P10−Φ\| first exceeds 0.01 at x=1.925, 0.03 at 2.137; M18 frame 11 | true |
| index.qmd:12 | order-10 value at x=3 is 2.0006 | mpmath: 2.000575 | true |
| index.qmd:12 | order-40 within 2×10⁻⁷ of true 0.99865 | order 40: 0.9986499866, err 1.15e−7; Φ(3)=0.998650102 | true |
| index.qmd:23 | composite rule exact for const+linear, not quadratic → second order; trapezoid example | panel moments; halving ratios 3.9995→4 | true |
| index.qmd:25 | Taylor series special case of power series; Laurent allows negative powers | definitions | true |
| index.qmd:85 | one order per frame, one frame per second | 31/31 GIFs: n+1 frames, all 1000 ms | true |
| index.qmd:85 | current blue, previous gray from order 1 on, f magenta, red dot (x0,f(x0)) | script lines 369–375, 385–387; frames | true |
| index.qmd:85 | off-range parts drawn along top/bottom edge | `clamp.(…, ylims)` line 353; frames | true |
| script:68–222 | exact-coefficient routine and its formula comments (binomial, log, sin/cos cycle, log-Gamma with l_1=ψ(c), l_m=(−1)^m ζ(m,c)/m, Bessel derivative sum, Z_{−m}=(−1)^m Z_m, J_m(−x)=(−1)^m J_m(x)) | formulas correct; outputs match mpmath to correct rounding for all 13 cases | true |
| script:90–93 | Euler–Maclaurin tail bound ((s+120)/(2πA))² < 0.04 | s≤8, A≥116: (128/(2π·116))² = 0.031 | true (and outputs verified anyway) |
| script:329 | Maclaurin fallback → error | never reached (all 18 ids handled; run completes) | fine |
| GIF titles / headings / alt text | unchanged ("Taylor T0x", "Taylor Cases (13)") | now accurate since curves are true Taylor polynomials | true |

### New problems

1. **Minor — Page match (pre-existing, outside F2's location): the Video Animations captions still state the asymptote/"behaves like a polynomial" heuristic that the new Description rejects.**
   - Location: `index.qmd:49` "Sine behaves similarly to a polynomial locally, so the Taylor series converges." (the "so" is the false causal reasoning: log x also behaves like a polynomial locally yet has finite R); `index.qmd:57` "Tanh has two horizontal asymptotes. The Taylor series has a limited radius of convergence."; `index.qmd:65` "arctan has two horizontal asymptotes similar to tanh. The radius of convergence is limited."
   - Evidence: each limited-radius fact is true (R=π/2, R=1), but placing it right after "has two horizontal asymptotes" implies the cause the Description now explicitly denies; Φ (M18) has the same two asymptotes and R=∞. Suggested: "sin is entire, so R=∞"; "tanh has poles at ±iπ/2, so R=π/2"; "arctan has branch points at ±i, so R=1".
2. **Minor — cosmetic: opaque internal label in public script comment.** `series_animations_all.jl:68` "(WP-A shared routine)" refers to an internal work-package name that means nothing to a site reader. Harmless.

No problem found in the regenerated GIFs: titles and "order = k" labels legible and unchanged in layout; nothing that was right before is broken (Maclaurin GIFs byte-identical to HEAD).

### Reproducibility and conventions

- Ran a scratch copy of `series_animations_all.jl` (global env, 25 s): all 31 output GIFs byte-identical to the working-tree GIFs (`cmp`). The 18 Maclaurin outputs also match HEAD's LFS oids.
- Conventions: Description (line 10) before Animations (line 83); source link to `series_animations_all.jl` present; 31 image embeds, one per case, alt text unchanged and descriptive; no code blocks.
- Files changed in this page folder: index.qmd, series_animations_all.jl, series_t01–t13.gif only. The working tree also has changes in other pages and in `pages/numerical-methods/index.qmd` (links for Milne-Simpson/Predictor-Corrector/Shooting pages); none touch this page and they appear to belong to other pages' fixes, not to this one (fix.diff lists only this folder).

### Re-check

After the fixer's second pass (updated fix.diff).

- **New problem 1 (Video Animations captions): resolved.**
  - `index.qmd:49` "Sine has no singularities in the complex plane, so its Taylor series converges for every x; the radius of convergence is infinite." sin is entire, so this is true. Root test about 0.5 gives |a_k|^(−1/k) = 27–31 at k=70–80 and still growing, as for R=∞.
  - `index.qmd:57`: the tanh poles are at i(π/2+kπ), so the nearest to 0 and to 0.5 are ±iπ/2. R = π/2 = 1.5708 (shown as ≈1.571, correct) about 0, and √(0.25+π²/4) = 1.6485 (≈1.648, correct) about 0.5. Root test about 0.5 at k=70–80 gives 1.644–1.696, consistent.
  - `index.qmd:65`: the branch points of arctan are at ±i. R = 1 about 0, and √(0.25+1) = √1.25 = 1.1180 about 0.5. Root test about 0.5 gives 1.18–1.23 at k=70–80. That matches R·k^{1/k} ≈ 1.118·1.06 for coefficients ~1/(k R^k), so it is consistent.
  - The asymptotes are now explicitly said not to be the cause, which agrees with the Description.
- **New problem 2 (script comment label): resolved.** Line 68 now reads "(same routine as the Padé approximation page)". `pages/numerical-methods/pade-approximation/pade_animations_all.jl` exists and defines `taylor_coeffs_exact`. The only difference from the script copy verified in the first check is this comment line.
- **F1–F5: still resolved.** The only text changes since the first check are the three captions and the comment above. The Description, the F4/F5 sentences and the Animations sentence are unchanged. The coefficient code is unchanged, so the coefficient check (128/128 correctly rounded) still applies.
- **Reproducibility:** a fresh scratch copy of the current script reproduces all 31 GIFs byte for byte (`cmp`, 31/31). The page folder still has only the same 15 changed files.
- **Anything new:** none found. Nothing else in the diff changed, and the captions name no centres other than 0 and 0.5.

**Final status:** committed
