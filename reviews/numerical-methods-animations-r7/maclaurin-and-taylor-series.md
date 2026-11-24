# Maclaurin and Taylor Series — animation review (round 7)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: final orders are far below Mathews', so many GIFs never show the convergence the archive animations were built to show

- **Location:** `series_animations_all.jl`, the `n_terms` field (last value) of the case table, lines 24-56. Most affected: M07, M08 (lines 30-31), M15-M18 (lines 38-41), T06, T07 (lines 49-50), T11 (line 54).
- **What is there now:** the animations stop at order 8 to 12.
- **What the archive does:** Mathews' animations are titled "Convergence Intervals" and run to S18 to S31 for the cases below. For the entire functions, the last frame matches the function across the whole plotted window.
- **Why it matters:** in these cases the last frame shows the polynomial leaving the function over roughly 36% to 73% of the window, although the series converges everywhere there (or, for T11, across most of it). The page explains this for M18 only ("only because order 10 is too low"). Its Description does state $R=\infty$ for sin, $e^{-x^2/2}$, $J_0$ and the normal CDF, which is why this is Minor rather than Misleading.
- **Evidence:** `review/orders.py`, independent mpmath Taylor coefficients at 70 digits, 501-point grid. The interval is the contiguous stretch around $x_0$ where $|T_n-f|\le 0.01$, the same tolerance Mathews displays on most frames. Mathews' order was read from his final frame.

| Case | Page order | ±0.01 interval (share of window) | Mathews order | ±0.01 interval (share of window) |
|---|---|---|---|---|
| M07 sin | 12 | [-4.00, 4.00] (42%) | 27 | [-9.42, 9.42] (100%) |
| M08 cos | 12 | [-4.37, 4.37] (46%) | 28 | [-9.42, 9.42] (100%) |
| M15 $J_0$ | 10 | [-4.08, 4.08] (40%) | 30 | [-10.20, 10.20] (100%) |
| M16 $J_1$ | 10 | [-3.71, 3.71] (36%) | 29 | [-10.20, 10.20] (100%) |
| M17 normal pdf | 10 | [-1.82, 1.82] (61%) | 30 | [-3, 3] (100%) |
| M18 normal CDF | 10 | [-1.92, 1.92] (64%) | 29 | [-3, 3] (100%) |
| T06 sin about π/4 | 10 | [-2.48, 4.23] (53%) | 19 | [-5.50, 7.07] (100%) |
| T07 cos about π/3 | 10 | [-2.30, 4.29] (52%) | 18 | [-5.24, 7.28] (100%) |
| T11 $Y_0$ about 10 | 8 | [7.08, 12.98] (27%) | 30 | [0.92, 19.98] (87%) |

For cases limited by a finite radius the gap is small and the order does not change the message: M13 44% vs 49%, M14 59% vs 64%, T01 19% vs 19%, T02 71% vs 76%, T03 87% vs 95%, T12 31% vs 43%, T13 14% vs 17%.

- **Suggested correction:** raise `n_terms` to Mathews' orders for the nine cases in the table (27, 28, 30, 29, 30, 29, 19, 18, 30). Alternatively, keep the orders and add one sentence to the Animations introduction saying the low final order, not the series, is why the entire-function cases leave the curve at the window's edges.
- **Caution if the orders are raised:** the Maclaurin branches use `Int` factorials and would break.
  - `factorial(k)` throws `OverflowError` at k = 21 (M07, M08, and M10, M11, M12 if raised). `factorial(2m)` in M14 (line 302) throws the same way at m = 11.
  - `factorial(m)^2` in M15 (line 307) **wraps silently** from m = 13, which is order 26 for $J_0$: Julia returns `factorial(13)^2 = 1882299896213536768`; the true value is `38775788043632640000`. That would draw a wrong polynomial with no error.
  - Using `factorial(big(k))` in these branches, as `taylor_coeffs_exact` already does, avoids both failures.
  - At the current orders none of this is reached and all coefficients are right.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 40.2 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **C** confirmed, **W** wrong, **?** could not determine.

### Description (index.qmd lines 12-25)

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Series about $x_0$ converges for $\lvert x-x_0\rvert<R$, diverges for $>R$, $R$ = distance to nearest complex singularity | C | Standard for $f$ analytic at $x_0$, which holds for every case on the page |
| 2 | 12 | $\arctan$, $1/(1+x^2)$ smooth on the real line, singular at $\pm i$, $R=1$ about 0 | C | Coefficients $\pm1/k$ and $\pm1$; root test on arctan at order 400 gives 1.015, tending to 1 |
| 3 | 12 | $\tanh$ poles at $\pm i\pi/2$, $R=\pi/2$ about 0 | C | Recurrence from $y'=1-y^2$, root test at order 400: 1.5698 vs 1.5708 |
| 4 | 12 | $\log x$ about 1 has $R=1$ | C | Coefficients $(-1)^{k-1}/k$ |
| 5 | 12 | exp, sin, $e^{-x^2/2}$, $J_0$, normal CDF have $R=\infty$ | C | All entire |
| 6 | 12 | Normal CDF has two horizontal asymptotes | C | Limits 0 and 1 |
| 7 | 12 | Order-10 polynomial pulls away beyond about $\lvert x\rvert=2$ | C | Error 0.0037 at 1.75, 0.015 at 2, 0.154 at 2.5; ±0.01 interval is [-1.92, 1.92] |
| 8 | 12 | At $x=3$ the order-10 value is 2.0006 | C | 2.00057508 |
| 9 | 12 | Order-40 value within $2\times10^{-7}$ of the true value | C | Error $-1.154\times10^{-7}$ |
| 10 | 12 | True value 0.99865 | C | $\Phi(3)=0.998650102$ |
| 11 | 18 | Formula for $T_n(x)$ | C | Script's coefficients match it (section 3) |
| 12 | 21 | Maclaurin is the case $x_0=0$ | C | Definition |
| 13 | 21 | Series may converge locally but fail globally near singularities | C | M01-M06, T01, T04 frames |
| 14 | 23 | Composite rule exact for constant and linear terms only is second-order; trapezoid is an example | C | Error ratios on halving: 3.9995, 3.9999, 4.0000 |
| 15 | 25 | Taylor is a special power series; Laurent allows negative powers; Padé is a ratio of polynomials | C | Definitions |

### Video Animations (lines 35-81)

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 16 | 35-37 | MATLAB script link resolves and covers the video cases | C | File exists; its 11 cases are the 11 embedded videos |
| 17 | 35 | The videos were generated by that script | ? | Script not run and videos not watched; titles and parameters are consistent |
| 18 | 39-81 | Each video sits under the right heading | C | YouTube oEmbed titles for all 11 IDs match their headings, in order |
| 19 | 41 | exp about 0 has infinite radius; higher orders approach exp | C | Entire |
| 20 | 49 | Sine has no complex singularities; $R=\infty$ | C | Entire |
| 21 | 57 | tanh radius $\pi/2\approx1.571$ about 0 | C | 1.570796 |
| 22 | 57 | tanh radius $\sqrt{0.25+\pi^2/4}\approx1.648$ about 0.5 | C | 1.648454; root test 1.6477 |
| 23 | 65 | arctan radius 1 about 0, $\sqrt{1.25}\approx1.118$ about 0.5 | C | 1.118034; root test 1.135 at order 400, tending down to it |
| 24 | 79 | abs has a corner, sign jumps, the composite is continuous | C | Direct |
| 25 | 79 | Infinite derivative at 0 | C | $f'=1/(2\sqrt{\lvert x\rvert})$ |
| 26 | 79 | Taylor series about 0.5 has radius 0.5 | C | Coefficient ratio tends to 2 exactly; root test 0.513 at order 400 |
| 27 | 79 | Series cannot converge across $x=0$ | C | At $x=-0.1$ partial sums reach $-3\times10^{12}$ by order 200 |

### Animations introduction (lines 85-89)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 28 | One order per frame | C | Frames = `n_terms`+1 for all 31 GIFs |
| 29 | One frame per second | C | Every frame of every GIF has a 1000 ms delay |
| 30 | Current order is blue | C | Pixel check below |
| 31 | From order 1 on, previous order is gray | C | Lines 402-405; at order 0 gray lies exactly under blue |
| 32 | Target function is magenta | C | Line 386, frames |
| 33 | Red dot marks $(x_0,f(x_0))$ | C | 356 of 356 frames within 3 px |
| 34 | Parts outside the $y$-range are drawn along the top or bottom edge | C | Line 370; pixel check used the clamped values |
| 35 | All 31 GIFs come from one Julia script; link is correct | C | Manifest: 31 of 31 byte-identical on regeneration |
| 36 | Counts: 18 Maclaurin, 13 Taylor | C | Table and headings |

### Case rows (lines 94-218)

Each row was checked for: heading function, $x_0$ and interval against the table (parsed, 0 mismatches); embed points at that case's GIF; GIF title (read from frames); alt text; coefficients; target values; and the Mathews row.

| Case | Function | $x_0$ | Interval | Frames | Heading = table = title = alt = GIF | Mathews row |
|---|---|---|---|---|---|---|
| M01 | $1/(1-x)$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M02 | $1/(1+x)$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M03 | $1/(1-x)^2$ | 0 | [-1.5, 1.5] | 13 | C | C (index row; the archive GIF is missing) |
| M04 | $1/\sqrt{1-x}$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M05 | $1/(1+x^2)$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M06 | $\log(1+x)$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M07 | $\sin x$ | 0 | [-3π, 3π] | 13 | C | C |
| M08 | $\cos x$ | 0 | [-3π, 3π] | 13 | C | C |
| M09 | $\tan x$ | 0 | [-π, π] | 12 | C | C |
| M10 | $e^x$ | 0 | [-2, 3] | 13 | C | C |
| M11 | $e^{-x}\cos x$ | 0 | [-2, 4] | 13 | C | C |
| M12 | $\cosh x$ | 0 | [-4, 4] | 13 | C | C |
| M13 | $\arctan x$ | 0 | [-2, 2] | 13 | C | C |
| M14 | $\arcsin x$ | 0 | [-1.5, 1.5] | 13 | C | C |
| M15 | $J_0$ | 0 | [-10.2, 10.2] | 11 | C | C |
| M16 | $J_1$ | 0 | [-10.2, 10.2] | 11 | C | C |
| M17 | normal pdf | 0 | [-3, 3] | 11 | C | C |
| M18 | normal CDF | 0 | [-3, 3] | 11 | C | C |
| T01 | $\sqrt x$ | 1 | [0, 10.5] | 11 | C | C |
| T02 | $\sqrt x$ | 4 | [0, 10.5] | 11 | C | C |
| T03 | $\sqrt x$ | 5 | [0, 10.5] | 11 | C | C ($x_0$ image missing; legacy frame and Example 6 give 5) |
| T04 | $\log x$ | 1 | [-0.5, 4.1] | 11 | C | C (function image missing; legacy frame gives log) |
| T05 | $\log x$ | 2 | [-0.5, 4.1] | 11 | C | C |
| T06 | $\sin x$ | π/4 | [-7π/4, 9π/4] | 11 | C | C |
| T07 | $\cos x$ | π/3 | [-5π/3, 7π/3] | 11 | C | C |
| T08 | $\Gamma$ | 1 | [-0.2, 5.2] | 9 | C | C |
| T09 | $\Gamma$ | 2 | [-0.2, 5.2] | 9 | C | C |
| T10 | $\Gamma$ | 3 | [-0.2, 5.2] | 9 | C | Function and $x_0$ C; interval **?** (image missing; the legacy frame's axis is consistent but its exact bounds cannot be read) |
| T11 | $Y_0$ | 10 | [0, 22] | 9 | C | C |
| T12 | $Y_0$ | 5 | [0, 22] | 9 | C | C |
| T13 | $Y_0$ | 2 | [0, 22] | 9 | C | C |

Archive coverage: all 31 animation cases are on the page. The 19 worked examples use the same functions, except Example 3, $-\log(1-x)$, and Example 5, the unnormalized $e^{-x^2/2}$. Neither is in Mathews' own animation set (the set has $\log(1+x)$ and the normalized density), so neither is a dropped case.

---

### 3. Implementation checks

One script, `series_animations_all.jl`. Instrumented copy: `review/inst.jl`, which dumps coefficients and sampled partial sums without rendering.

### It is the method it claims to be
`partial_sum` (lines 334-343) evaluates $\sum_{j\le n} a_j (x-c)^j$. Maclaurin coefficients come from closed forms per case. Taylor coefficients come from `taylor_coeffs_exact` in 256-bit BigFloat. No variant is involved.

### The numbers are right

| Check (`review/indep.py`, `review/radius.py`) | Script vs independent |
|---|---|
| All 31 rows, every coefficient vs `mpmath.taylor` at 80 digits | Worst relative difference $1.32\times10^{-16}$ (rounding) |
| 16 Maclaurin rows vs `sympy.series` (all but $J_0$, $J_1$) | Worst relative difference $1.32\times10^{-16}$ |
| 13 Taylor rows: "correctly rounded to Float64" (comment, line 68) | 131 of 131 coefficients equal the correctly rounded value |
| Gamma, functional equation: $a^{(2)}_k=a^{(1)}_k+a^{(1)}_{k-1}$ | Max residual $8.5\times10^{-17}$ |
| Gamma: $a^{(3)}_k=2a^{(2)}_k+a^{(2)}_{k-1}$ | Max residual $1.1\times10^{-16}$ |
| $Y_0$, Bessel ODE recurrence $c(k+2)(k+1)a_{k+2}+(k+1)^2a_{k+1}+ca_k+a_{k-1}=0$ | Max residual: T11 $2.7\times10^{-16}$, T12 $2.2\times10^{-16}$, T13 $1.1\times10^{-16}$ |
| Partial sums at 3204 (case, order, x) samples | 0 mismatches |

The comment that this is the same routine as the Padé page is true: the code from `_bernoulli_numbers` through `taylor_coeffs_exact` has the same MD5 in both scripts (`8e2c51328f7126331a448e0e9bb371fa`).

### The reference values are right
The magenta target was compared with mpmath at the same 3204 samples: 0 mismatches, including NaN exactly where $f$ is undefined on the real line (M04 for $x>1$, M06 for $x<-1$, M14 for $\lvert x\rvert>1$, T04 and T05 for $x\le0$).

### The picture shows what was computed
- **Regeneration:** all 31 GIFs are byte-identical to a scratch run (manifest).
- **Blue curve, pixel check** (`review/pixels.py`, all 356 frames, 60 columns per frame): of 21101 column samples containing blue, 21043 lie within 3 px of the independently evaluated, clamped $T_k$. The other 58 are explained by occlusion: 20 under the red dot and 38 under the legend box. None is unexplained.
- **Red dot:** correct in 356 of 356 frames.
- **Order label and previous curve:** the label is `k`, the blue curve is `sums[k+1]` (order k) and gray is `sums[k]` (order k-1), per lines 402-405.
- **Frames viewed:** first, middle and last frame of all 31 cases. Titles are correct in every case.
- **Poles:** no false vertical segments at the poles of M01, M02, M09 or T08-T10. `break_at_poles` works at this sampling.
- **Display devices:** clamping is disclosed on the page (claim 34). The axis limits do not hide any feature the page discusses. The final order is the one display choice with a consequence, reported as F1.

### Not checked
- The MATLAB script was read, and its Taylor loop is correct by inspection, but it was not run.
- The 11 YouTube videos were not watched; only their titles were checked.

