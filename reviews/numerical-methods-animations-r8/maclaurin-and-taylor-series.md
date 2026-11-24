# Maclaurin and Taylor Series — animation review (round 8)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1 — Fidelity, Misleading: truncation orders far too low to show what the cases (and the Description) are about

- **Location:** `series_animations_all.jl` lines 24–56, last field `n_terms` of every `SeriesCase` (12 for M01–M14 except M09 = 11; 10 for M15–M18 and T01–T07; 8 for T08–T13). Affects the GIFs embedded under headings M07, M08, M15, M16, M17, T06, T07, T09–T13 most visibly (index.qmd lines 118–124, 150–164, 188–194, 200–218).
- **What is there now:** every animation stops at degree 8–12. The legacy animations for the same 31 cases go to degree ≈ 19–30 (final frames read S₂₇ for sin, S₃₀ for J₀, S₂₉ for J₁, S₃₀ for the normal pdf, S₂₉ for the CDF, S₁₉ for sin about π/4, S₃₀ for Y₀ about 10 and 2, S₂₂ for √x about 5, S₂₉ for Γ about 3), and they were titled "Convergence Intervals": the last frame shows the polynomial matching f over the whole convergence interval inside the window. The page's last frames instead show the polynomial leaving f over a large part of the window, for functions the Description itself says have R = ∞:

  | Case | final order | where final T_n is within 0.01 of f | window / convergence interval in window | order needed for 0.01 on that interval |
  |---|---|---|---|---|
  | M07 sin | 12 | [−4.00, 4.00] | [−9.42, 9.42] (R=∞) | 27 |
  | M08 cos | 12 | [−4.37, 4.37] | [−9.42, 9.42] (R=∞) | 26 |
  | M15 J₀ | 10 | [−4.11, 4.11] | [−10.2, 10.2] (R=∞) | 26 |
  | M16 J₁ | 10 | [−3.72, 3.72] | [−10.2, 10.2] (R=∞) | 27 |
  | M17 normal pdf | 10 | [−1.83, 1.83] | [−3, 3] (R=∞) | 26 |
  | M18 normal CDF | 10 | [−1.92, 1.92] | [−3, 3] (R=∞) | 23 |
  | T06 sin, x₀=π/4 | 10 | [−2.49, 4.25] | [−5.50, 7.07] (R=∞) | 19 |
  | T07 cos, x₀=π/3 | 10 | [−2.30, 4.30] | [−5.24, 7.33] (R=∞) | 19 |
  | T09 Γ, x₀=2 | 8 | [0.82, 3.39] | (0, 4) (R=2) | 59 for [0.2, 3.8] |
  | T10 Γ, x₀=3 | 8 | [1.44, 4.44] | (0, 5.2] (R=3) | 55 for [0.3, 5.2] |
  | T11 Y₀, x₀=10 | 8 | [7.05, 12.99] | (0, 20) (R=10) | (legacy used 30) |
  | T12 Y₀, x₀=5 | 8 | [1.36, 8.25] | (0, 10) (R=5) | — |
  | T13 Y₀, x₀=2 | 8 | [0.57, 3.72] | (0, 4) (R=2) | — |

  (Needed orders are ≈ the legacy orders, which confirms that is what Mathews chose them for.)
- **Why it misleads:** the Description (line 12) teaches that R is set by the nearest complex singularity and that sin, e^{−x²/2}, J₀ and the normal CDF have R = ∞, and it explains away the visible departure only for M18 ("only because order 10 is too low"). M07, M08, M15, M16, M17, T06 and T07 carry no such note, and their last frames show the polynomial shooting off over half the window — exactly the picture a reader would take as "the series fails out there". For T11–T13 the legacy point (Y₀ about x₀ converges on (0, 2x₀)) cannot be seen at all: at order 8 the T11 polynomial matches only on [7.05, 12.99] of (0, 20), so the radius-of-convergence behaviour these three cases were chosen to compare is invisible.
- **How I know:** coefficients dumped by an instrumented copy of the script (`review/coeffs_dump.jl` → `julia_coeffs.tsv`), bands and needed orders computed with numpy/scipy f-values and mpmath Taylor coefficients (`/usr/bin/python3 -I review/coverage2.py review/julia_coeffs.tsv`, output in `review/coverage2.out`; Y₀ bands from an inline numpy run). Legacy orders read from the final frames of the legacy GIFs (`review/legacy_last.png`, `review/legacy_Taylorcc/`, `review/legacy_Taylorjj/`); legacy GIF frame counts 26–42 versus 9–13 here.
- **Suggested correction:** raise `n_terms` to roughly the legacy orders (M07/M08/M15–M18 ≈ 26–30, T06/T07 ≈ 20, T01–T05 ≈ 20–30, T08–T13 ≈ 30), keeping one order per frame or stepping by 2 for the even/odd-only series to keep the frame count reasonable; or, if the low orders are kept deliberately, add a sentence to the Animations introduction saying that the last frame is far from the convergence limit and that for M07–M08, M15–M18, T06–T07 the series converges on the whole window.

No other findings.

- **Independent check:** confirmed with correction. True for M07, M08, M15, M16, M17, T06 and T07: the final frames show the polynomial leaving f over about 40–60% of the window, although these functions are entire, and degree 30 matches f to within 0.01 across every one of those windows. True for T11 (degree 8 agrees only on (7, 13) of the convergence interval (0, 20)) and partly for T12. Overstated for T09, T10 and T13: at degree 8, T09 and T13 already roughly outline their interval (0, 4), and T10's interval end x = 6 lies outside the plotted window. The page never states R for the Γ and Y₀ cases, so for T09–T13 this is about what the animation can show, not a contradiction of the text.


## Reviewer's notes (not findings)


Counts: Error 0, Misleading 1, Minor 0.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 40.6 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Animations section (index.qmd lines 83–218) and the formula/claim parts of the Description and video section.

| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| 1 | "Each animation steps through the Taylor polynomials one order per frame" | confirmed | loop `for k in 0:case.n_terms` (l. 402); frames = n_terms+1 for all 31 (13/12/11/9 per manifest) |
| 2 | "one frame per second" | confirmed | `fps = 1`; every frame of all 31 GIFs has duration 1000 ms (PIL) |
| 3 | "current order (blue)" | confirmed | `color=:steelblue`, label "current order" |
| 4 | "from order 1 on, the previous order (gray)" | confirmed | `y_prev = k == 0 ? sums[1] : sums[k]` (order 0 draws gray identical to blue, hidden beneath) |
| 5 | "over the target function (magenta)" | confirmed | `color=:magenta` |
| 6 | "the red dot marks (x₀, f(x₀))" | confirmed | `scatter!([case.c],[f(c)])`; f(c) printed equals a₀ for all 31 cases |
| 7 | "Parts of a polynomial outside the plotted y-range are drawn along the top or bottom edge" | confirmed | `clamp.(ys, ylims...)` l. 370; seen e.g. T01, T11 last frames |
| 8 | "All 31 GIFs … generated by one Julia script" | confirmed | manifest: one script produces all 31, byte-identical |
| 9 | "Maclaurin Cases (18)", "Taylor Cases (13)" | confirmed | 18 m-rows, 13 t-rows; 18+13 headings |
| 10–40 | Each heading M01–M18, T01–T13: f, x₀, interval | confirmed (all 31) | each row's f, c, xlims matches its heading (π/4 = 0.7854, π/3 = 1.0472 in titles); GIF titles show the same f and x₀ (all 31 last frames read); every row also matches the legacy formula/center/interval (legacy_formulas.png; the three missing legacy images checked against the legacy GIFs: T03 x₀=5, T04 log x, T10 interval −0.2..5.2) |
| 41 | Wiring: each heading embeds `series_<id>.gif` of that case; alt text names the right function and centre | confirmed | index.qmd lines 96–218 sequential m01…t13; alt texts all match |
| 42 | Source link `series_animations_all.jl` | confirmed | file exists, is the producing script |
| 43 | Description: T_n(x)=Σ f^(k)(x₀)/k! (x−x₀)^k; Maclaurin = x₀=0 | confirmed | script evaluates Σ a_k (x−c)^k with a_k = f^(k)(c)/k! (verified numerically, §3) |
| 44 | R = distance to nearest complex singularity; arctan and 1/(1+x²): R=1 about 0 | confirmed | poles/branch points at ±i |
| 45 | tanh: poles ±iπ/2, R=π/2 about 0 | confirmed | |
| 46 | log(x) about 1: R=1 | confirmed | |
| 47 | exp, sin, e^{−x²/2}, J₀, normal CDF have R=∞ | confirmed | entire functions |
| 48 | Normal CDF order-10 "pulls away … beyond about \|x\|=2" | confirmed | |T₁₀−Φ| exceeds 0.01 at x=1.92, 0.05 at 2.24 |
| 49 | "at x=3 the order-10 value is 2.0006" | confirmed | 2.000575 (script coefficients, partial_sum) |
| 50 | "order-40 value is within 2×10⁻⁷ of the true 0.99865" | confirmed | T₄₀(3)=0.99864999, Φ(3)=0.99865010, diff 1.15×10⁻⁷ |
| 51 | Composite rule exact for constant and linear but not quadratic terms is second order; trapezoidal is an example | confirmed | local O(h³), global O(h²) |
| 52 | Video section: tanh about 0.5 R=√(0.25+π²/4)≈1.648 | confirmed | 1.6485 |
| 53 | Video section: arctan R=1 about 0, √1.25≈1.118 about 0.5 | confirmed | |
| 54 | Video section: √|x|·sign(x) continuous, infinite derivative at 0, R=0.5 about 0.5 | confirmed | branch point at 0 |
| 55 | (implicit, Description vs animations) the animations illustrate convergence for R=∞ functions | wrong / misleading for M07, M08, M15–M17, T06, T07 | see F1 |

### 3. Implementation checks — `series_animations_all.jl`

**It is the method it claims to be.** Plots truncated Taylor polynomials T_k(x)=Σ_{j≤k} a_j (x−c)^j, k=0..n, with a_j the Taylor coefficients about c. Maclaurin coefficients from closed forms per case (l. 225–332); Taylor coefficients from `taylor_coeffs_exact` in 256-bit BigFloat (binomial series, log series, exp/sin/cos cycles, log-Gamma via digamma/Hurwitz zeta, Bessel derivative identity). `partial_sum` is a correct power-sum evaluation.

**The numbers are right.** Instrumented copy dumped all 31 coefficient vectors; compared with `mpmath.taylor` (60 digits, numerical differentiation of the true f, independent of any remembered formula): worst relative coefficient error over all cases and orders = 1.3×10⁻¹⁶ (i.e. correct rounding). Sample last coefficients, script vs mpmath: M09 a₁₁ 0.0088632355 / 0.0088632355; M11 a₁₂ −1.3361124e−7 / −1.3361124e−7; T08 a₈ 0.99810569 / 0.99810569; T11 a₈ −7.7955029e−7 / −7.7955029e−7; T13 a₈ −2.9134474e−4 / −2.9134474e−4. This is the "matches derivatives at the expansion point to the stated order" property, checked for every row. Visual spot check: T11 order-1 line has slope ≈ −0.25 = Y₀′(10) = −Y₁(10) = −0.249.

**Reference values.** The magenta curve is the library function itself (Base `sin`, `tan`, `atan`, `asin`, SpecialFunctions `besselj`, `bessely`, `gamma`, `erf`); f(c) equals a₀ in every case. Domain errors (√ of negative, log of non-positive, asin outside [−1,1]) become NaN and are not drawn; `break_at_poles` prevents vertical lines through the poles of tan, 1/(1±x), Γ. Correct.

**The picture shows what was computed.** All 31 last frames and the T11 full contact sheet inspected: title shows the row's f and x₀; "order = k" annotation matches the frame index; gray is order k−1; clamping draws runaway polynomials along the frame edges as the page says. Axis windows match the headings. The only issue is the low final order (F1).

