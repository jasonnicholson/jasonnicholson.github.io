# Maclaurin and Taylor Series — animation review (round 4)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Outside the review scope (not counted)

- F1: The page says abs is discontinuous (page match, Minor) — excluded: the passage is in the 'Video Animations' section, which the review brief puts out of scope (recorded, not counted).

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 40.7 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| D1 | Series about x0 converges for \|x−x0\|<R and diverges for \|x−x0\|>R; R is the distance to the nearest complex singularity | confirmed | Standard theorem for analytic functions |
| D2 | arctan(x) and 1/(1+x²) have singularities at ±i, so R=1 about 0 | confirmed | Poles or branch points at ±i |
| D3 | tanh has poles at ±iπ/2, so R=π/2 about 0 | confirmed | cosh(z)=0 at z=±iπ/2 |
| D4 | log(x) about 1 has R=1 | confirmed | Singularity at 0 |
| D5 | exp, sin, e^{−x²/2}, J0 and the normal CDF have R=∞ | confirmed | All are entire (erf is entire) |
| D6 | M18's order-10 polynomial pulls away beyond about \|x\|=2 | confirmed | Order-10 error is 7.0e-4 at 1.5, 4.9e-3 at 1.8, 1.50e-2 at 2.0, 4.08e-2 at 2.2 and 0.154 at 2.5. Frames for order 10 of M18 show the same. |
| D7 | At x=3 the order-10 value is 2.0006 | confirmed | mpmath gives 2.00057508 |
| D8 | The order-40 value is within 2×10⁻⁷ of the true 0.99865 | confirmed | Error is −1.154e-7. True value is 0.998650102. |
| D9 | T_n(x)=Σ f^(k)(x0)/k! (x−x0)^k, and Maclaurin means x0=0 | confirmed | Definition. The script's coefficients equal f^(k)(x0)/k! (section 3). |
| D10 | A composite rule that is exact for the constant and linear terms but not the quadratic is second-order, and the trapezoid rule is an example | confirmed | One trapezoid panel is exact for 1 and x but gives 0.5 instead of 1/3 for x². Composite trapezoid on e^x over [0,1] reduces the error by a factor of 3.9992, 3.9998 and 3.99995 per halving. |
| D11 | A Laurent series also allows negative powers | confirmed | Definition |

### Video Animations section (outside the GIF scope, checked for completeness)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | The videos come from `taylor_series_animation_code.m` | confirmed | The file exists and the link resolves. The script makes exactly the 11 videos named in the headings: exp about 0 and 1, sin about 0 and 0.5, tanh about 0 and 0.5, arctan about 0 and 0.5, 1/x about 0.5, 1/(x−1) about 0.75, sqrt(abs(x))*sign(x) about 0.5. |
| V2 | The exp series about 0 has infinite radius | confirmed | exp is entire |
| V3 | Sine has no singularities, so the radius is infinite | confirmed | sin is entire |
| V4 | Radius of tanh is π/2≈1.571 about 0 and √(0.25+π²/4)≈1.648 about 0.5 | confirmed | 1.5708 and 1.64845 |
| V5 | Radius of arctan is 1 about 0 and √1.25≈1.118 about 0.5 | confirmed | 1.11803 |
| V6 | abs and sign are "discontinuous functions" / "the discontinuities of sign and abs" | **wrong** | F1 |
| V7 | Infinite derivative of sqrt at 0; the series cannot converge across x=0 | confirmed | Branch point at 0 gives R=0.5 about 0.5 |
| V8 | Each YouTube embed shows the case under its heading | could not determine | The videos are external and I did not fetch them |

### Animations section: introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | One order per frame | confirmed | Frames for orders 0..n. The "order = k" label is drawn with sums[k+1]. Frame counts are n+1 for every GIF: 13 for M01–M08 and M10–M14 (n=12), 12 for M09 (n=11), 11 for M15–M18 and T01–T07 (n=10), 9 for T08–T13 (n=8). |
| A2 | One frame per second | confirmed | `fps=1`. Every frame of all 31 GIFs has a duration of 1000 ms (read with PIL). |
| A3 | Current order is blue | confirmed | `color=:steelblue` in the code, and visible in the frames |
| A4 | From order 1 on, the previous order is gray | confirmed | `y_prev = sums[k]` is order k−1 for k≥1. At order 0 the code draws the gray line equal to order 0, hidden under the blue. The legend still lists "previous order" there, but nothing incorrect is visible. |
| A5 | The target function is magenta | confirmed | Code and frames |
| A6 | The red dot marks (x0, f(x0)) | confirmed | `scatter!([case.c],[f(c)])`. The dot's y equals mpmath f(c) to 1e-14 for all 31 cases. |
| A7 | Parts of a polynomial outside the y-range are drawn along the top or bottom edge | confirmed | `clamp.(ys, ylims...)`. Visible as edge-hugging blue segments, for example M01, M05, T01. |
| A8 | All 31 GIFs come from one Julia script | confirmed | The manifest shows a regeneration from a scratch copy that is byte-identical for all 31 GIFs |
| A9 | The link "Julia source for all cases" points at `series_animations_all.jl` | confirmed | The file exists next to the page |
| A10 | "Maclaurin Cases (18)" and "Taylor Cases (13)" | confirmed | 18 m-rows and 13 t-rows, with 18 and 13 headings and embeds |

### Animations section: per case (heading, embed, alt text, GIF title)

For every row I checked these against each other: the heading's function, x0 and interval, the case-table row (`f`, `c`, `xlims`), the GIF filename in the embed, the alt text, and the title in the GIF frames. I read the titles on the contact sheets of all 31 GIFs.

| Case | Heading f, x0, interval | Table row | GIF title | Embed / alt | Verdict |
|---|---|---|---|---|---|
| M01 | 1/(1−x), 0, [−1.5,1.5] | same | "Maclaurin M01: f(x) = 1/(1-x), x0 = 0.0" | series_m01.gif / matches | confirmed |
| M02 | 1/(1+x), 0, [−1.5,1.5] | same | M02 1/(1+x) | m02 / matches | confirmed |
| M03 | 1/(1−x)², 0, [−1.5,1.5] | same | M03 1/(1-x)^2 | m03 / matches | confirmed |
| M04 | 1/√(1−x), 0, [−1.5,1.5] | same | M04 1/sqrt(1-x) | m04 / matches | confirmed |
| M05 | 1/(1+x²), 0, [−1.5,1.5] | same | M05 1/(1+x^2) | m05 / matches | confirmed |
| M06 | log(1+x), 0, [−1.5,1.5] | same | M06 log(1+x) | m06 / matches | confirmed |
| M07 | sin x, 0, [−3π,3π] | same | M07 sin(x) | m07 / matches | confirmed |
| M08 | cos x, 0, [−3π,3π] | same | M08 cos(x) | m08 / matches | confirmed |
| M09 | tan x, 0, [−π,π] | same | M09 tan(x) | m09 / matches | confirmed |
| M10 | eˣ, 0, [−2,3] | same | M10 exp(x) | m10 / matches | confirmed |
| M11 | e^{−x}cos x, 0, [−2,4] | same | M11 exp(-x)*cos(x) | m11 / matches | confirmed |
| M12 | cosh x, 0, [−4,4] | same | M12 cosh(x) | m12 / matches | confirmed |
| M13 | arctan x, 0, [−2,2] | same | M13 atan(x) | m13 / matches | confirmed |
| M14 | arcsin x, 0, [−1.5,1.5] | same | M14 asin(x) | m14 / matches | confirmed |
| M15 | J0, 0, [−10.2,10.2] | same | M15 besselj(0,x) | m15 / matches | confirmed |
| M16 | J1, 0, [−10.2,10.2] | same | M16 besselj(1,x) | m16 / matches | confirmed |
| M17 | (1/√(2π))e^{−x²/2}, 0, [−3,3] | same | M17 normal_pdf(x) | m17 / "normal density" | confirmed |
| M18 | ½+½erf(x/√2), 0, [−3,3] | same | M18 normal_cdf(x) | m18 / "normal CDF" | confirmed |
| T01 | √x, 1, [0,10.5] | same | T01 sqrt(x), x0 = 1.0 | t01 / matches | confirmed |
| T02 | √x, 4, [0,10.5] | same | x0 = 4.0 | t02 / matches | confirmed |
| T03 | √x, 5, [0,10.5] | same | x0 = 5.0 | t03 / matches | confirmed |
| T04 | log x, 1, [−0.5,4.1] | same | T04 log(x), x0 = 1.0 | t04 / matches | confirmed |
| T05 | log x, 2, [−0.5,4.1] | same | x0 = 2.0 | t05 / matches | confirmed |
| T06 | sin x, π/4, [−7π/4,9π/4] | same | T06 sin(x), x0 = 0.7854 | t06 / matches | confirmed |
| T07 | cos x, π/3, [−5π/3,7π/3] | same | T07 cos(x), x0 = 1.0472 | t07 / matches | confirmed |
| T08 | Γ, 1, [−0.2,5.2] | same | T08 gamma(x), x0 = 1.0 | t08 / matches | confirmed |
| T09 | Γ, 2, [−0.2,5.2] | same | x0 = 2.0 | t09 / matches | confirmed |
| T10 | Γ, 3, [−0.2,5.2] | same | x0 = 3.0 | t10 / matches | confirmed |
| T11 | Y0, 10, [0,22] | same | T11 bessely(0,x), x0 = 10.0 | t11 / matches | confirmed |
| T12 | Y0, 5, [0,22] | same | x0 = 5.0 | t12 / matches | confirmed |
| T13 | Y0, 2, [0,22] | same | x0 = 2.0 | t13 / matches | confirmed |

The page makes no per-case behaviour claims (there are no "Behavior" paragraphs), so there was nothing further to check per case.

### Fidelity to the legacy archive

| Item | Verdict | Evidence |
|---|---|---|
| Case count (18 Maclaurin, 13 Taylor) | confirmed | Series.html lists Maclaurin 1–18 and Taylor 1–13 |
| Function, center and interval of every case | confirmed | `review/legacy_formulas.png` is a montage of Mathews' formula images, one row per case. All 31 rows agree with the page and the table. Three formula images are missing from the archive: T03 center, T04 function, T10 interval. For T03, the legacy GIF frame shows its red center line at x=5. For T04, the index text says "natural logarithm function" and the legacy frame title reads log(x). For T10, the legacy frame shows a window similar to T08/T09, but I could not read the exact limits. |
| Presentation | observation, not a finding | The legacy GIFs (`review/legacy_frames.png`) go up to orders of about 24–38. They also mark the convergence interval with green lines and show a ±tolerance bar. The new GIFs stop at order 8–12 and have neither device. The page claims none of this, and the review standard excludes "content the page does not yet have", so I have not raised it. One case I checked: T03 (√x about 5, R=5), where the window reaches 10.5 > 10. The divergence there is slight at any order: the error at x=10.5 is −0.026 at n=10, −0.027 at n=24 and −0.059 at n=40. Stopping at order 10 therefore does not hide a feature a viewer would otherwise see. |

---

### 3. Implementation checks: `series_animations_all.jl`

**It is the method it claims to be.** The script draws truncated Taylor polynomials T_k(x) = Σ_{j≤k} a_j (x−c)^j for k = 0..n, with a_j = f^(j)(c)/j!. There are two sources of coefficients:
- Maclaurin rows use hand-coded closed forms (`maclaurin_coeffs`, lines 225–332): geometric, binomial, the tan series to x¹¹, exp, the Re((−1+i)^k)/k! form for e^{−x}cos x, cosh, arctan, arcsin, J0, J1, the normal pdf, and the normal cdf.
- Taylor rows use `taylor_coeffs_exact` (lines 146–208) in 256-bit BigFloat. It uses the binomial formula for √x, the closed form for log, the cyclic derivatives of sin and cos, log-Gamma via digamma and Hurwitz ζ followed by exponentiation for Γ, and the derivative identity Z_ν^(k) = 2^{−k} Σ (−1)^j C(k,j) Z_{ν−k+2j} for Y0.

All of these are correct formulations of Taylor coefficients. `partial_sum` (lines 334–343) evaluates the sum term by term.

**The numbers are right.** I instrumented a scratch copy (`review/coeffs.jl` → `review/coeffs.txt`) to print every case's coefficient vector. I compared each one against `mpmath.taylor(f, c, n)` at 60 digits, which differentiates the actual function numerically at high precision and so does not depend on remembered formulas (`review/indep.py`):

| Case | n | max abs diff | max rel diff |
|---|---|---|---|
| m01–m04 | 12 | 0 | 0 |
| m05 | 12 | 3.7e-63 | 0 |
| m06, m07, m08, m10, m11, m12, m13, m14 | 12 | ≤1.9e-17 | ≤8.6e-17 |
| m09 | 11 | 1.9e-17 | 8.6e-17 |
| m15, m16 | 10 | ≤1.5e-19 | 5.6e-17 |
| m17, m18 | 10 | 2.5e-17 | 1.3e-16 |
| t01, t02 | 10 | 0 | 0 |
| t03–t07 | 10 | ≤1.1e-16 | ≤9.5e-17 |
| t08, t09, t10 (Γ) | 8 | ≤5.3e-17 | ≤9.3e-17 |
| t11, t12, t13 (Y0) | 8 | ≤2.9e-17 | ≤9.8e-17 |

Every coefficient of every case agrees with mpmath to within Float64 rounding. Examples:
- t08 a1 = −0.5772156649015329 (−γ) and a2 = 0.98905599532797 (γ²/2 + π²/12).
- t11 a0 = Y0(10) = 0.0556711672835994.
- m09 a11 = 1382/155925 = 0.0088632355299022.

That covers the derivative-matching property at x0 to the full drawn order. I also instrumented `partial_sum` itself (`review/sums.jl`). At 7 points across each window, for order 1 and for the maximum order, its values match the mpmath polynomial with a worst relative difference of 2.4e-15 across all 31 cases.

**Its reference values are right.** The "true" curve is `case.f` evaluated in Float64 through Base and SpecialFunctions (`besselj`, `bessely`, `gamma`, `erf`). Each `case.f` is the heading's function, which I checked row by row. The red-dot value f(c) matches mpmath to 1e-14 for every case. Points outside the domain (log of a negative, √ of a negative, asin with |x|>1, Y0(0), Γ near 0) become NaN through `safe_eval` and are left undrawn, which is correct.

**The picture shows what was computed.**
- In frame k the blue curve is order k (`sums[k+1]`) and the gray curve is order k−1, with label "order = k". I checked this against the frame sequence in all 31 contact sheets. In the even-order frames of odd functions (M07, M13, M16, M18, M14, M09) and the odd-order frames of even functions (M05, M08, M12, M15, M17), gray and blue coincide. That is correct, because the added term is zero.
- `break_at_poles` breaks the magenta line where samples jump from above one y-limit to below the other. It removes the false vertical lines at the poles of M01 (x=1), M02 (x=−1), M09 (±π/2) and T08–T10 (x=0, where Γ jumps from −∞ to +∞), and the frames show no such lines. For M03, both sides of x=1 go to +∞, so the joining segment lies entirely above the plot and is invisible.
- Clamping of polynomials to the y-limits is disclosed on the page (A7). It does not change any conclusion, because no numeric value is shown for a clamped curve.
- Titles report the correct id, function and x0, with π/4 shown as 0.7854 and π/3 as 1.0472. The windows match the headings. Nothing the page discusses falls outside a window. The one numeric claim tied to a GIF is D6 (M18 departs beyond about |x|=2), and the order-10 frame of M18 shows it.
- Regeneration from a scratch copy is byte-identical for all 31 GIFs (manifest), so the frames I inspected are what the script produces.

