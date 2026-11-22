# Maclaurin and Taylor Series — animation review (round 3)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Outside the review scope (not counted)

- F1: Page match (Video Animations section text), Minor: abs is called discontinuous — excluded: concerns the "Video Animations" section, which this review leaves out of scope; reported here for information only.

## Reviewer's notes (not findings)


**Counts:** Error 0, Misleading 0, Minor 1.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 39.4 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (lines 12–25)

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | The series converges for \|x−x0\|<R and diverges for \|x−x0\|>R, with R the distance from x0 to the nearest complex singularity. | Standard result for analytic f. | Confirmed |
| D2 | arctan and 1/(1+x²) have singularities at ±i, so R = 1 about 0. | Poles/branch points at ±i. The M05 and M13 frames diverge past \|x\|=1. | Confirmed |
| D3 | tanh has poles at ±iπ/2, so R = π/2 about 0. | cosh(iπ/2) = −5e−52 in mpmath. | Confirmed |
| D4 | log(x) about 1 has R = 1 (singularity at 0). | Standard. The T04 frames diverge past x = 2. | Confirmed |
| D5 | exp, sin, e^{−x²/2}, J0 and the normal CDF have R = ∞. | All are entire. | Confirmed |
| D6 | The normal CDF (M18) order-10 polynomial "pulls away beyond about \|x\|=2". | T10(x) − Φ(x) = 7.0e−4 at 1.5, 3.6e−3 at 1.75, 0.0150 at 2, 0.0516 at 2.25, 0.154 at 2.5. The M18 last frame shows separation near x ≈ 1.9. | Confirmed |
| D7 | At x = 3 the order-10 value is 2.0006. | 2.000575 | Confirmed |
| D8 | The order-40 value is within 2×10⁻⁷ of the true 0.99865. | T40(3) = 0.998649987, Φ(3) = 0.998650102, difference 1.15e−7 | Confirmed |
| D9 | $T_n(x)=\sum_{k=0}^n f^{(k)}(x_0)/k!\,(x-x_0)^k$ | This is exactly what `partial_sum` evaluates, with coefficients a_k = f^(k)(c)/k! (checked below). | Confirmed |
| D10 | Maclaurin is the special case x0 = 0. | Standard. All M rows have c = 0. | Confirmed |
| D11 | A composite rule exact for the constant and linear terms but not the quadratic is second-order; trapezoidal is an example. | Local error O(h³), global error O(h²). | Confirmed |
| D12 | Laurent series allow negative powers; Padé is a ratio of polynomials. | Standard. | Confirmed |

### Video Animations section (lines 33–81)

The videos themselves are on YouTube and could not be checked. I checked the mathematical statements and the headings against `taylor_series_animation_code.m`.

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| V1 | Headings: exp about 0 and 1; sin about 0 and 0.5; tanh about 0 and 0.5; arctan about 0 and 0.5; 1/x about 0.5; 1/(x−1) about 0.75; sqrt(abs(x))*sign(x) about 0.5. | The MATLAB script defines exactly these 11 cases. | Confirmed (videos not viewed) |
| V2 | exp about 0 has infinite radius of convergence. | Entire function. | Confirmed |
| V3 | Sine has no complex singularities, so its radius is infinite. | Entire function. | Confirmed |
| V4 | The tanh radius is π/2 ≈ 1.571 about 0 and √(0.25+π²/4) ≈ 1.648 about 0.5. | 1.5707963 and 1.6484542 | Confirmed |
| V5 | The arctan radius is 1 about 0 and √1.25 ≈ 1.118 about 0.5. | 1.118034 | Confirmed |
| V6 | "two discontinuous functions, abs and sign" and "discontinuities of sign and abs" | abs is continuous. | **Wrong** (F1) |
| V7 | "The Taylor series cannot converge across x=0" (about 0.5). | Singularity at 0 gives R = 0.5. | Confirmed |

### Animations section, general

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | One order per frame. | The loop runs `k in 0:n_terms` and annotates "order = k". Frame counts are n+1: 13/12/11/9, matching n = 12/11/10/8. | Confirmed |
| A2 | One frame per second. | `fps = 1`. `identify -format %T` gives a delay of 100 cs on every frame (checked m01 and t13). | Confirmed |
| A3 | Current order blue, previous order gray from order 1 on, target magenta. | `:steelblue`, `:gray55` and `:magenta`. At k = 0, gray equals blue and is hidden. At k ≥ 1, gray is `sums[k]` (order k−1). The T08 and M01 sheets show the k−1 polynomial in gray. | Confirmed |
| A4 | The red dot marks (x0, f(x0)). | `scatter!([c],[f(c)])`. Seen at the right place in all 31 final frames, e.g. T13 at (2, 0.510) and T06 at (0.785, 0.707). | Confirmed |
| A5 | Polynomial parts outside the y-range are drawn along the top or bottom edge. | `clamp.(ys, ylims...)` on the partial sums. Visible as edge-hugging blue segments, e.g. M13, T13. | Confirmed |
| A6 | All 31 GIFs come from one Julia script. | 31 rows, 31 GIFs, byte-identical on regeneration. | Confirmed |
| A7 | Source link `series_animations_all.jl` | The file exists and is the generator. | Confirmed |
| A8 | "Maclaurin Cases (18)" and "Taylor Cases (13)" | 18 M rows and 13 T rows. | Confirmed |

### Per-case rows

For each row: the heading's function, x0 and interval; the script row (`f`, `c`, `xlims`); the GIF title, read for all 31 in `titles_all.png`; the alt text; and the embed file. **All five agree for all 31 rows.**

| Case | Heading f, x0, interval | Script f / c / xlims | GIF title | Alt text and embed | Verdict |
|---|---|---|---|---|---|
| M01 | 1/(1−x), 0, [−1.5,1.5] | 1/(1-x), 0, (−1.5,1.5) | "Maclaurin M01: f(x) = 1/(1-x), x0 = 0.0" | 1/(1−x) at 0; series_m01.gif | Confirmed |
| M02 | 1/(1+x), 0, [−1.5,1.5] | same | "…1/(1+x)…" | ok; m02 | Confirmed |
| M03 | 1/(1−x)², 0, [−1.5,1.5] | same | "…1/(1-x)^2…" | ok; m03 | Confirmed |
| M04 | 1/√(1−x), 0, [−1.5,1.5] | same | "…1/sqrt(1-x)…" | ok; m04 | Confirmed |
| M05 | 1/(1+x²), 0, [−1.5,1.5] | same | "…1/(1+x^2)…" | ok; m05 | Confirmed |
| M06 | log(1+x), 0, [−1.5,1.5] | same | "…log(1+x)…" | ok; m06 | Confirmed |
| M07 | sin, 0, [−3π,3π] | sin, 0, (−3π,3π) | "…sin(x)…" | ok; m07 | Confirmed |
| M08 | cos, 0, [−3π,3π] | same | "…cos(x)…" | ok; m08 | Confirmed |
| M09 | tan, 0, [−π,π] | same | "…tan(x)…" | ok; m09 | Confirmed |
| M10 | eˣ, 0, [−2,3] | same | "…exp(x)…" | ok; m10 | Confirmed |
| M11 | e^{−x}cos x, 0, [−2,4] | same | "…exp(-x)*cos(x)…" | ok; m11 | Confirmed |
| M12 | cosh, 0, [−4,4] | same | "…cosh(x)…" | ok; m12 | Confirmed |
| M13 | arctan, 0, [−2,2] | same | "…atan(x)…" | ok; m13 | Confirmed |
| M14 | arcsin, 0, [−1.5,1.5] | same | "…asin(x)…" | ok; m14 | Confirmed |
| M15 | J0, 0, [−10.2,10.2] | besselj(0,·) | "…besselj(0,x)…" | ok; m15 | Confirmed |
| M16 | J1, 0, [−10.2,10.2] | besselj(1,·) | "…besselj(1,x)…" | ok; m16 | Confirmed |
| M17 | (2π)^{−1/2}e^{−x²/2}, 0, [−3,3] | same | "…normal_pdf(x)…" | ok; m17 | Confirmed |
| M18 | ½+½erf(x/√2), 0, [−3,3] | same | "…normal_cdf(x)…" | ok; m18 | Confirmed |
| T01 | √x, 1, [0,10.5] | same | "Taylor T01: f(x) = sqrt(x), x0 = 1.0" | ok; t01 | Confirmed |
| T02 | √x, 4, [0,10.5] | same | "…x0 = 4.0" | ok; t02 | Confirmed |
| T03 | √x, 5, [0,10.5] | same | "…x0 = 5.0" | ok; t03 | Confirmed |
| T04 | log x, 1, [−0.5,4.1] | same | "…log(x), x0 = 1.0" | ok; t04 | Confirmed |
| T05 | log x, 2, [−0.5,4.1] | same | "…x0 = 2.0" | ok; t05 | Confirmed |
| T06 | sin, π/4, [−7π/4,9π/4] | same | "…sin(x), x0 = 0.7854" | ok; t06 | Confirmed |
| T07 | cos, π/3, [−5π/3,7π/3] | same | "…cos(x), x0 = 1.0472" | ok; t07 | Confirmed |
| T08 | Γ, 1, [−0.2,5.2] | same | "…gamma(x), x0 = 1.0" | ok; t08 | Confirmed |
| T09 | Γ, 2, [−0.2,5.2] | same | "…x0 = 2.0" | ok; t09 | Confirmed |
| T10 | Γ, 3, [−0.2,5.2] | same | "…x0 = 3.0" | ok; t10 | Confirmed |
| T11 | Y0, 10, [0,22] | bessely(0,·) | "…bessely(0,x), x0 = 10.0" | ok; t11 | Confirmed |
| T12 | Y0, 5, [0,22] | same | "…x0 = 5.0" | ok; t12 | Confirmed |
| T13 | Y0, 2, [0,22] | same | "…x0 = 2.0" | ok; t13 | Confirmed |

---

### 3. Implementation checks: `series_animations_all.jl`

### It is the method it claims to be
- `partial_sum` evaluates the truncated Taylor polynomial $\sum_{k=0}^n a_k (x-c)^k$.
- For the Maclaurin rows, the coefficients come from hard-coded closed forms in `maclaurin_coeffs`.
- For the Taylor rows, `taylor_coeffs_exact` computes the coefficients in 256-bit BigFloat and rounds them to Float64:
  - √x: binomial series.
  - log: (−1)^{k−1}/(k c^k).
  - sin and cos: a 4-cycle.
  - Γ: exponentiates the log-Γ series, with digamma for the first term and Hurwitz ζ for the rest.
  - Y0: the derivative identity $Z^{(k)}=2^{-k}\sum_j(-1)^j\binom kj Z_{\nu-k+2j}$.
- Every frame k shows exactly the degree-k Taylor polynomial. This is the method named on the page.

### The numbers are right
`dump.jl` dumps all 31 coefficient vectors. `check_coeffs.py` compares each against `mpmath.taylor(f, c, n)` (numerical high-precision derivatives divided by k!, 60 digits). This check is independent of every closed form in the script.

| Rows | Max relative coefficient error |
|---|---|
| M01–M04, T01, T02 | 0 (exact) |
| All others | ≤ 1.32e−16, i.e. Float64 rounding |

Examples of the highest coefficient, script value vs. reference:
- M09 a11 = 0.00886323553 vs 0.00886323553 (tan, 1382/155925)
- T08 a8 = 0.9981056938 vs 0.9981056938 (Γ about 1)
- T11 a8 = −7.795502897e−7 vs −7.795502897e−7 (Y0 about 10)
- T13 a0 = Y0(2) = −0.000291… vs the same, as a8; a0 matched too

The full table is in the output of `python3 -I review/check_coeffs.py review/coeffs.tsv`.

Because every coefficient a_k = f^(k)(c)/k! is correct through order n, each polynomial matches f's derivatives at c to order n. This is the property check for series approximations.

`check_sums.py` compares the plotted partial sums at sampled x (every 50th of the 900 plot points, all 31 cases) with the mpmath polynomial. The maximum relative difference is 6.3e−15. For f(x) itself, the maximum relative difference against mpmath is 1.5e−16.

### Reference values are right
The "true" curve is `case.f` evaluated with Base and SpecialFunctions (`besselj`, `bessely`, `gamma`, `erf`). It agrees with mpmath to 1.5e−16 relative, above.
- M18: Julia's `0.5+0.5erf(x/√2)` matches `mp.ncdf`.
- M17: matches the normal pdf.
- Where f is undefined (log for x ≤ −1 or x ≤ 0, asin for |x| > 1), `safe_eval` returns NaN and the curve is simply absent, which is correct.

### The picture shows what was computed
I viewed the title strips of all 31 GIFs (`review/titles_all.png`), the final frame of all 31 (`review/last_m1.png`, `last_m2.png`, `last_t.png`), and the full contact sheets of M01 and T08.
- Titles show the correct function label, case id and x0 (rounded to 4 decimals: π/4 → 0.7854, π/3 → 1.0472).
- The order annotation equals the frame's polynomial degree.
- In T08, order 1 is a line with slope Γ′(1) = −γ ≈ −0.577 through (1, 1), as computed.
- The gray curve is the previous order. The red dot is at (c, f(c)).

Display devices:
- **Clamping partial sums to the y-limits.** This is disclosed in the page introduction and does not mislead. Clamped stretches lie on the frame edge and are not labelled as values.
- **`break_at_poles`.** It inserts a NaN gap where f jumps across both y-limits: at the poles in M01, M02 and M09, and at T08–T10's pole at 0. No spurious vertical lines appear.
- **No pole sampled exactly.** On the 900-point grids, x = 1 (M01), x = −1 (M02) and x = 0 (T08–T10) fall at non-integer indices (749.17, 149.83 and 33.3), so no sample sits on a pole.
- **Γ leaving the window.** In T08 and T09, Γ(x) leaves the top of the window (y = 30) for x > ~5.13 (Γ(5.2) ≈ 32.6). This only clips the target curve at the far right edge and does not affect any conclusion.
- **Annotation overlap.** The "order = k" annotation slightly overlaps the "0" y-tick label in some T cases. This is cosmetic and still readable.
- **Convergence regions.** Each convergence region visible in the frames agrees with its radius of convergence. The polynomials track f inside |x−c| < R and depart outside it, e.g. T01 (R = 1), T13 (R = 2), M05/M13 (R = 1), M14 (R = 1).
- **Entire functions.** The departures in the entire-function cases (M07, M08, M15–M18, T06, T07, T11, T12) come from the finite order, not from divergence. The page does not claim otherwise.

### Fidelity to the legacy archive
All 31 cases match the Mathews animation set `a2001/Animations/Interpolation/Series/Series.html` in function, center and interval.
- Matched from the formula images and HTML text: M01–M18; T01, T02; T04 and T05 (log, x0 = 1 and 2, [−0.5, 4.1]); T06 (sin, π/4, [−7π/4, 9π/4]); T07 (cos, π/3, [−5π/3, 7π/3]); T08–T10 (Γ about 1, 2, 3, [−0.2, 5.2]); T11–T13 (Y0 about 10, 5, 2, [0, 22]).
- T03: x0 = 5 is confirmed from the legacy GIF frame, because its formula image is missing.
- T10: its interval image (`series_gr_85`) is missing; [−0.2, 5.2] is presumed from T08 and T09.

The legacy animations run to higher orders (26–42 frames, e.g. S₂₄ for T03) and overlay a "convergence interval" tolerance bar. The page uses orders 8–12 and has no tolerance bar. That is a presentation choice and content the page does not have, so it is not a finding: the page makes no claim about orders or tolerance intervals.

No fidelity findings.

