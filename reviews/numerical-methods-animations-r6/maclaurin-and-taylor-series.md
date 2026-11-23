# Maclaurin and Taylor Series — animation review (round 6)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the GIFs stop at orders 8 to 12, so for most entire-function cases the final frame fits well under the full window that Mathews chose

- **Location:** `series_animations_all.jl` lines 24–56, the `n_terms` column (12 for M01–M08 and M10–M14, 11 for M09, 10 for M15–M18 and T01–T07, 8 for T08–T13).
- **What is there now:** each GIF ends at order `n_terms`. Mathews' animations for the same 31 cases, with the same functions, centres and windows, run to much higher orders, and their titles read "Convergence Intervals":
  - Legacy frame counts: 26–42 per case.
  - The last labels I read: M15 J0 reaches `S30`, T11 Y0 about 10 reaches `S29`, T10 Γ about 3 reaches `S29`, T04 log about 1 reaches `S24`, T03 √x about 5 reaches `S22`.
  - In the legacy final frames the polynomial covers the window, up to the radius of convergence where that is finite.
- **What is true instead:** I measured where the page's final-order polynomial stays within 0.01 of f, and the order at which it would cover the window (to within 2% of the window width). The command was `python3 -I review/cover.py`, with coefficients from `mpmath.taylor(..., method='quad')`.

  | Case | Final order | |T_n − f| < 0.01 on | Share of window | Order needed to cover window |
  |---|---|---|---|---|
  | M07 sin, [−3π, 3π] | 12 | [−4.00, 4.00] | 42% | 25 |
  | M08 cos, [−3π, 3π] | 12 | [−4.37, 4.37] | 46% | 26 |
  | M11 e^{−x}cos x, [−2, 4] | 12 | [−2.00, 2.90] | 82% | 16 |
  | M15 J0, [−10.2, 10.2] | 10 | [−4.10, 4.10] | 40% | 26 |
  | M16 J1, [−10.2, 10.2] | 10 | [−3.72, 3.72] | 36% | 25 |
  | M17 normal pdf, [−3, 3] | 10 | [−1.83, 1.83] | 61% | 24 |
  | M18 normal CDF, [−3, 3] | 10 | [−1.92, 1.92] | 64% | 21 |
  | T06 sin about π/4 | 10 | [−2.49, 4.25] | 54% | 18 |
  | T07 cos about π/3 | 10 | [−2.30, 4.30] | 52% | 18 |
  | T11 Y0 about 10, [0, 22], R = 10 | 8 | [7.05, 12.99] | 27% (about 30% of the convergence interval (0, 20)) | 20 to cover [2, 18] = c ± 0.8R |
  | T12 Y0 about 5, [0, 22], R = 5 | 8 | [1.36, 8.24] | 31% | 10 to cover [1, 9] = c ± 0.8R |

  T13 (Y0 about 2, R = 2) was not finished when I wrote this, and it is not material: its whole convergence interval (0, 4) is small. M10 (exp) and M12 (cosh) already cover their windows at order 12. In the legacy T11 GIF at `S29`, the polynomial follows Y0 from about 1 to 19, which shows the convergence interval (0, 20). The page's T11 final frame fits only [7.05, 12.99].

  All of these functions are entire except Y0, whose series about c has R = c. So the region where the final frame visibly fails is not a limit of the series. It is only the order cut-off.
- **Why it is only Minor:** the page never claims that the GIFs show convergence across the window. The Description states R = ∞ for sin, J0, e^{−x²/2} and the normal CDF, and it explains the M18 pull-away as "only because order 10 is too low" (I verified that claim). A reader who watches M15 or M16 (or T11, with its convergence interval (0, 20)), though, sees the series peel away at |x| ≈ 4 in a window Mathews sized to show it converging through three oscillations. Nothing on the page says the same explanation applies there.
- **Suggested correction:** do one of the following.
  - Raise `n_terms` for these rows to roughly the orders in the last column (or about 30, as in Mathews). For orders above 11 or 12, M09's hard-coded tan table and the Float64 `factorial(k)` calls (exact only up to k = 20) would need extending; `taylor_coeffs_exact` already handles any order.
  - Or add one sentence to the Animations introduction, for example: "Orders stop at 8–12, so for entire functions such as sin, cos, J0, J1 and the normal pdf/CDF the last frame still departs from f near the window edges; higher orders would cover the whole window."

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Summary: 0 Error, 0 Misleading, 1 Minor.**

I found no computational error and no mismatch between the page and the animations. Every coefficient, every case-table row, every heading, every alt text, every GIF title and every number in the Description checks out against my own computations (see sections 2 and 3). The only finding is a fidelity point about how far the orders go.



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

### Description (method statements and numbers)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "the radius of convergence R is the distance from x0 to the nearest singularity of f in the complex plane" | Confirmed | Standard result for analytic f. Every R below is consistent with it. |
| D2 | "arctan(x) and 1/(1+x^2) … singularities at ±i, so R=1 about 0" | Confirmed | Poles/branch points at ±i. M05/M13 final frames diverge at \|x\| = 1. |
| D3 | "tanh(x) has poles at ±iπ/2, so R=π/2 about 0" | Confirmed | Zeros of cosh at iπ/2 + ikπ. |
| D4 | "log(x) about 1 has R=1 because of the singularity at x=0" | Confirmed | T04 frames diverge beyond x = 2. |
| D5 | "exp(x), sin(x), e^{-x²/2}, J0(x) and the normal CDF, have R=∞" | Confirmed | All are entire. Coverage at increasing orders (F1 table) reaches the full window. |
| D6 | "The normal CDF (M18 below) has two horizontal asymptotes like tanh(x)" | Confirmed | Limits 0 and 1. |
| D7 | "its order-10 polynomial pulls away from it beyond about \|x\|=2" | Confirmed | T10 − Φ = 0.0049 at 1.8, 0.0150 at 2.0, 0.041 at 2.2 (symmetric in sign; `review/desc.py`). |
| D8 | "at x=3 the order-10 value is 2.0006" | Confirmed | T10(3) = 2.000575… |
| D9 | "the order-40 value is within 2×10⁻⁷ of the true 0.99865" | Confirmed | Φ(3) = 0.9986501020; T40(3) − Φ(3) = −1.154×10⁻⁷. |
| D10 | Formula T_n(x) = Σ f^(k)(x0)/k! (x−x0)^k | Confirmed | The script evaluates exactly this polynomial (`partial_sum`, lines 334–343) with the coefficients verified in section 3. |
| D11 | "The Maclaurin polynomial is the special case x0=0" | Confirmed | All M rows have c = 0.0. |
| D12 | "a composite rule that integrates the constant and linear Taylor terms exactly, but not the quadratic term, is second-order accurate; the trapezoidal rule is an example" | Confirmed | Composite trapezoid on ∫₀¹eˣ: errors drop by a factor of 3.9992, 3.9998, 3.99995 per halving of h. |
| D13 | "Laurent series … also allows negative powers"; "Padé approximant … ratio of two polynomials" | Confirmed | Definitions. |

### Video Animations section (outside the Animations section; checked where checkable)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | "The videos are generated by a MATLAB script: taylor_series_animation_code.m" | Confirmed (script side) | The `.m` file has exactly the 11 cases named in the headings: exp about 0 and 1, sin about 0 and 0.5, tanh about 0 and 0.5, arctan about 0 and 0.5, 1/x about 0.5, 1/(x−1) about 0.75, sqrt(abs(x))·sign(x) about 0.5. |
| V2 | The YouTube videos show those cases | Could not determine | The videos are external; I did not view them. |
| V3 | "radius is π/2≈1.571 about 0 and √(0.25+π²/4)≈1.648 about 0.5" (tanh) | Confirmed | 1.570796, 1.648454. |
| V4 | arctan: "1 about 0 and √1.25≈1.118 about 0.5" | Confirmed | 1.118034. |
| V5 | sqrt(abs(x))·sign(x): "the composite itself is continuous"; "infinite derivative at x=0"; "Taylor series about 0.5 has radius 0.5" | Confirmed | Equals √x for x > 0 and −√(−x) for x < 0, with derivative 1/(2√\|x\|) → ∞. Branch point at 0, distance 0.5. |
| V6 | exp "has an infinite radius of convergence"; sine "radius of convergence is infinite" | Confirmed | Both are entire. |

### Animations section, general

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "steps through the Taylor polynomials one order per frame" | Confirmed | Loop over k = 0..n_terms (line 402); each frame is labelled "order = k"; frame counts = n_terms + 1 (13/12/11/9, matching the manifest). |
| A2 | "one frame per second" | Confirmed | `fps = 1`. The GIF frame duration is 1000 ms in all 31 files (PIL check). |
| A3 | "current order (blue)" | Confirmed | `:steelblue`, label "current order". |
| A4 | "from order 1 on, the previous order (gray)" | Confirmed | `y_prev = sums[k]` for k ≥ 1. At order 0 it is set equal to the current curve, so no separate gray curve is visible (T08 sheet, frame 1). |
| A5 | "over the target function (magenta)" | Confirmed | `:magenta`, label "f(x)". |
| A6 | "the red dot marks (x0, f(x0))" | Confirmed | `scatter!([case.c],[f(c)])`. Dots sit at (0, 1) for M01, (2, Y0(2) = 0.510) for T13, (5, −0.309) for T12, (10, 0.056) for T11. |
| A7 | "Parts of a polynomial outside the plotted y-range are drawn along the top or bottom edge" | Confirmed | `clamp.` at line 370. This is visible as edge-hugging blue in M01, T08 (orders 3, 5, 7), M15, etc. The disclosure is accurate. |
| A8 | "All 31 GIFs on this page are generated by one Julia script" with link `series_animations_all.jl` | Confirmed | 31 rows; the manifest shows byte-identical regeneration; the link target exists. |
| A9 | "Maclaurin Cases (18)", "Taylor Cases (13)" | Confirmed | 18 M rows and 13 T rows; 18 and 13 embeds. |

### Per-case headings, alt text, embeds, GIF titles

For every row I checked the following:

- The heading's f, x0 and interval against the script row (function, `c`, `xlims`).
- The embed against the GIF filename.
- The GIF title text in the last-frame montages (`review/mac_last_a.png`, `mac_last_b.png`, `tay_last_a.png`, `tay_last_b.png`), and in full-size frames for T08.
- The alt text.
- The archive table (`review/archive/table.png`).

**Verdict for every row: confirmed.**

| Case | Heading (f, x0, interval) | Script row | GIF title | Archive |
|---|---|---|---|---|
| M01 | 1/(1−x), 0, [−1.5, 1.5] | same | "Maclaurin M01: f(x) = 1/(1-x), x0 = 0.0" | same |
| M02 | 1/(1+x), 0, [−1.5, 1.5] | same | "…M02: 1/(1+x)…" | same |
| M03 | 1/(1−x)², 0, [−1.5, 1.5] | same | "…1/(1-x)^2…" | same |
| M04 | 1/√(1−x), 0, [−1.5, 1.5] | same | "…1/sqrt(1-x)…" | same |
| M05 | 1/(1+x²), 0, [−1.5, 1.5] | same | "…1/(1+x^2)…" | same |
| M06 | log(1+x), 0, [−1.5, 1.5] | same | "…log(1+x)…" | same |
| M07 | sin, 0, [−3π, 3π] | same | "…sin(x)…" | same |
| M08 | cos, 0, [−3π, 3π] | same | "…cos(x)…" | same |
| M09 | tan, 0, [−π, π] | same | "…tan(x)…" | same |
| M10 | eˣ, 0, [−2, 3] | same | "…exp(x)…" | same |
| M11 | e^{−x}cos x, 0, [−2, 4] | same | "…exp(-x)*cos(x)…" | same (Cos[x]e^{−x}) |
| M12 | cosh, 0, [−4, 4] | same | "…cosh(x)…" | same |
| M13 | arctan, 0, [−2, 2] | same | "…atan(x)…" | same |
| M14 | arcsin, 0, [−1.5, 1.5] | same | "…asin(x)…" | same |
| M15 | J0, 0, [−10.2, 10.2] | same | "…besselj(0,x)…" | same |
| M16 | J1, 0, [−10.2, 10.2] | same | "…besselj(1,x)…" | same |
| M17 | (1/√(2π))e^{−x²/2}, 0, [−3, 3] | same | "…normal_pdf(x)…" | same |
| M18 | ½ + ½ erf(x/√2), 0, [−3, 3] | same | "…normal_cdf(x)…" | same |
| T01 | √x, 1, [0, 10.5] | same | "Taylor T01: f(x) = sqrt(x), x0 = 1.0" | same |
| T02 | √x, 4, [0, 10.5] | same | "…x0 = 4.0" | same |
| T03 | √x, 5, [0, 10.5] | same | "…x0 = 5.0" | same (archive centre image missing; the legacy GIF shows the red line at x = 5) |
| T04 | log x, 1, [−0.5, 4.1] | same | "…log(x), x0 = 1.0" | same (archive function image missing; the legacy GIF title reads log(x)) |
| T05 | log x, 2, [−0.5, 4.1] | same | "…x0 = 2.0" | same |
| T06 | sin, π/4, [−7π/4, 9π/4] | same | "…x0 = 0.7854" | same |
| T07 | cos, π/3, [−5π/3, 7π/3] | same | "…x0 = 1.0472" | same |
| T08 | Γ, 1, [−0.2, 5.2] | same | "…gamma(x), x0 = 1.0" | same |
| T09 | Γ, 2, [−0.2, 5.2] | same | "…x0 = 2.0" | same |
| T10 | Γ, 3, [−0.2, 5.2] | same | "…x0 = 3.0" | same (archive interval image missing; the legacy GIF axis runs about 0 to 5.2) |
| T11 | Y0, 10, [0, 22] | same | "…bessely(0,x), x0 = 10.0" | same |
| T12 | Y0, 5, [0, 22] | same | "…x0 = 5.0" | same |
| T13 | Y0, 2, [0, 22] | same | "…x0 = 2.0" | same |

All 31 alt texts name the right function and centre ("one over one minus x centered at zero" … "Bessel Y zero centered at two"): confirmed. All 31 embeds point at the GIF whose title carries the matching case id: confirmed.

The page makes no per-case behaviour claims (there are no "Behavior" paragraphs), so there are no behaviour entries to check.

### Fidelity (archive)

| # | Item | Verdict |
|---|---|---|
| L1 | Same 18 Maclaurin and 13 Taylor cases, same functions, centres and windows, in the same order | Confirmed |
| L2 | No archive case dropped | Confirmed |
| L3 | Orders shown: Mathews goes to about 22–30, the page to 8–12 | Departure, reported as F1 |
| L4 | Mathews' green "tolerance ±0.01" convergence-interval bar is not reproduced | Not a finding (content the page does not have) |

### 3. Implementation checks (single script `series_animations_all.jl`)

**It is the method claimed.** The script builds Taylor coefficients a_k = f^(k)(c)/k! and evaluates the truncated power series Σ a_k (x−c)^k for k = 0..n (`partial_sum`, lines 334–343). That is exactly the degree-n Taylor/Maclaurin polynomial in the Description. There is no hidden variant: no economisation, no Padé, no re-expansion.

- Maclaurin coefficients come from hand-written closed forms (`maclaurin_coeffs`, lines 225–332).
- Taylor coefficients come from `taylor_coeffs_exact` (lines 146–208). It works in 256-bit BigFloat and rounds each coefficient once:
  - binomial series for √x
  - closed form for log
  - cyclic derivatives for sin/cos
  - exp-of-log-Gamma recurrence with digamma and Hurwitz zeta for Γ
  - the derivative identity Z_ν^(k) = 2^{−k} Σ (−1)^j C(k,j) Z_{ν−k+2j} for Y0

**The numbers are right.**

- I instrumented a scratch copy (`review/instr.jl`: the script's lines 1–412 plus a dump; no GIFs written). It dumped all 31 coefficient vectors (`review/coeffs.tsv`).
- I compared them against `mpmath.taylor(f, c, n)` at 80 digits (`review/indep.py`). That routine is numerical high-precision differentiation of the function itself, so it does not depend on remembering any series formula.
- Worst relative error per case:

  | Cases | Worst relative error |
  |---|---|
  | m01–m05, t01, t02 | 0 |
  | m06 | 5.6e-17 |
  | m07 | 6.7e-17 |
  | m08 | 8.6e-17 |
  | m09 (tan through x¹¹) | 8.6e-17 |
  | m10 | 8.6e-17 |
  | m11 | 6.7e-17 |
  | m12 | 8.6e-17 |
  | m13, m14 | 5.6e-17 |
  | m15, m16 | 5.6e-17 |
  | m17, m18 | 1.3e-16 |
  | t03 | 8.3e-17 |
  | t04, t05 | 5.6e-17 |
  | t06 | 9.5e-17 |
  | t07 | 9.3e-17 |
  | t08 (Γ about 1) | 5.2e-17 |
  | t09 | 6.4e-17 |
  | t10 | 9.3e-17 |
  | t11 (Y0 about 10) | 9.8e-17 |
  | t12 | 9.2e-17 |
  | t13 | 5.8e-17 |
  | **Overall worst** | **1.32e-16** |

  Every coefficient is correct to about 1 ulp, and the zero odd/even coefficients are exactly 0.
- Sample last coefficients, script against reference:

  | Case | Script | Reference |
  |---|---|---|
  | m09 a11 | 0.00886323553 | 0.00886323553 |
  | t08 a8 | 0.9981056938 | 0.9981056938 |
  | t11 a8 | −7.795502897e-07 | −7.795502897e-07 |
  | t13 a8 | −2.913447428e-4 | −2.913447428e-4 |

  This is the "matches the function's derivatives at the expansion point to the stated order" property check from the review standard, done for all 31 cases.
- `partial_sum` against a 50-digit evaluation of the same coefficients at the window ends and at c + 0.3 for every case: maximum relative difference 1.5e-15 (`review/desc.py`).

**Reference values are right.** The "true" curve is `case.f`, with Julia `sqrt`, `log`, `sin`, `tan`, `atan`, `asin`, `erf`, `besselj`, `bessely` and `gamma`. Each lambda is the function named in the heading (lines 24–56).

- Domain errors (√ and log of negatives, asin for \|x\| > 1, Y0(0) = −∞) become NaN through `safe_eval`, so those parts are simply not drawn. That is correct.
- The f(c) values behind the red dot were checked by eye against known values (Γ(1) = 1, Y0(2) = 0.5104, Y0(5) = −0.3085, Y0(10) = 0.0557).
- The mpmath reference reproduces `case.f` at every probe point in `review/psums.tsv` (it is the same function).

**The picture shows what was computed.**

I looked at the last frames of all 31 GIFs and the full contact sheet of T08 (orders 0–8).

- The order-0 frame is the constant f(c).
- The order-1 frame for T08 is the tangent line with slope Γ′(1) = −γ ≈ −0.577: it reaches y ≈ −1.4 at x = 5.2, as in the frame.
- Each frame's blue curve is the gray of the next frame.
- The "order = k" label matches the loop index.
- Titles carry the right case id, function and x0 (to 4 decimals: π/4 shows as 0.7854 and π/3 as 1.0472).

Display devices:

- **Clamping** of polynomials to `ylims` (line 370) is disclosed on the page (A7).
- **`break_at_poles`** inserts a gap where f jumps from above to below the y-window. That removes the false vertical segments for tan at ±π/2 (M09), for Γ at 0 (T08–T10), and for 1/(1±x) at x = ∓1 (M01/M02). For M03, both sides of the pole run off the top, so no break is needed, and none is drawn.
- **Γ on (−0.2, 0)** is below −5.8, so it lies entirely below the y-window, and its absence from the plot is correct.
- **Axis windows** contain every feature the page mentions: the poles, the R = 1 boundaries, the M18 |x| ≈ 2 departure.

The only display-related point is the order range, discussed in F1.

