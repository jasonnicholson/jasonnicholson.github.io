# Maclaurin and Taylor Series — animation review (round 9)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Fidelity, Minor: the maximum orders are far below the legacy animations, so several R = ∞ cases end with the polynomial still diverging over much of the window

- **Location:** `series_animations_all.jl` lines 24–56, the `n_terms` field (12 for M01–M08 and M10–M14, 11 for M09, 10 for M15–M18 and T01–T07, 8 for T08–T13). Also the page headings for M07, M08, M15, M16, M17, T06 and T07, which say nothing about this.
- **What is there now:** The final frame of each case is order 8–12. For functions the page's own Description says have R = ∞ (sin, cos, J0, the normal density, the normal CDF), the last frame shows the polynomial leaving the window over 35–60 % of the x-range. M18 is the only case where the page explains that this is a too-low order and not a finite radius.
- **What the legacy has:** Mathews' animations for the same 31 functions and windows run to much higher orders. The last frames read S24 for 1/(1−x), sqrt(x) and log(x); S35 for tan; S50 for 1/(1+x²); S30–S31 for Gamma and Y0; S19 and S18 for T06 sin and T07 cos. Frame counts are 26–42 for most cases. Those orders are just enough to converge across each chosen window, which is why the windows are what they are. A ±10.2 window for J0 only makes sense at about order 26.
- **How I know:** `review/coverage.py` uses mpmath Taylor coefficients. For each case it reports the fraction of 601 window points where |T_n − f| exceeds 1 % of the y-range at the page's final order, and the lowest order at which no such point remains:

  | case | page order | fraction of window off | order needed | legacy final order |
  |---|---|---|---|---|
  | M07 sin | 12 | 0.539 | 25 | ~26 (27 frames) |
  | M08 cos | 12 | 0.499 | 26 | ~26 (27 frames) |
  | M15 J0 | 10 | 0.559 | 26 | ~27 frames |
  | M16 J1 | 10 | 0.596 | 25 | ~25 frames |
  | M17 normal pdf | 10 | 0.426 | 26 | ~27 frames |
  | M18 normal cdf | 10 | 0.349 | 23 | ~26 frames |
  | T06 sin about π/4 | 10 | 0.408 | 18 | S19 |
  | T07 cos about π/3 | 10 | 0.419 | 17 | S18 |

  A reader of M15, for example, ends on a frame where the order-10 polynomial plunges off the bottom at |x| ≈ 6. Nothing next to that case says the series does converge there.
- **Suggested correction:** Either raise `n_terms` for the entire-function cases to roughly the orders in the "order needed" column (25–26 for M07, M08, M15–M17; 23 for M18; 18 for T06; 17 for T07). This matches Mathews and makes the windows meaningful. Or add one sentence to the Animations introduction saying that the animations stop at order 8–12, and that for the R = ∞ cases (M07, M08, M10–M12, M15–M18, T06, T07) the remaining mismatch at the window edges is a too-low order, not a limited radius. If orders are raised, consider skipping the frames that repeat the previous polynomial for even or odd functions. Otherwise the frame count roughly doubles.

No other findings. The implementation is correct in every case, and every heading, alt text, title and parameter agrees with the case table and the legacy archive.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `series_animations_all.jl` | 0 | 40.5 | 31 GIFs (series_m01.gif … series_t13.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (method statements)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "The series about x0 converges for \|x−x0\|<R and diverges for \|x−x0\|>R, where … R is the distance from x0 to the nearest singularity of f in the complex plane" | confirmed | Standard result for analytic f |
| D2 | arctan and 1/(1+x²) have singularities at ±i, so R=1 about 0 | confirmed | Poles or branch points at ±i |
| D3 | tanh has poles at ±iπ/2, so R=π/2 about 0 | confirmed | π/2 = 1.5708 (desc.py) |
| D4 | log(x) about 1 has R=1 because of the singularity at x=0 | confirmed | Also visible in T04: the order-10 curve leaves log beyond x≈2 |
| D5 | exp, sin, e^{−x²/2}, J0 and the normal CDF have R=∞ | confirmed | All are entire |
| D6 | The normal CDF's order-10 polynomial "pulls away from it beyond about \|x\|=2" | confirmed | \|T10−Φ\| = 0.0049 at 1.8, 0.0150 at 2.0, 0.0408 at 2.2, 0.154 at 2.5 (desc.py); the M18 last frame agrees |
| D7 | "at x=3 the order-10 value is 2.0006" | confirmed | T10(3) = 2.000575 (desc.py) |
| D8 | "the order-40 value is within 2×10⁻⁷ of the true 0.99865" | confirmed | T40(3) = 0.998649987; Φ(3) = 0.998650102; difference 1.15×10⁻⁷ |
| D9 | T_n(x)=Σ f^(k)(x0)/k! (x−x0)^k; Maclaurin is x0=0 | confirmed | The script's `partial_sum` evaluates exactly this with coefficients a_k = f^(k)(c)/k! |
| D10 | A composite rule exact for the constant and linear Taylor terms but not the quadratic is second-order; trapezoidal is an example | confirmed | Local error O(h³), global O(h²) |

### Video Animations section (text claims only)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | The headings' cases (exp about 0 and 1, sin about 0 and 0.5, tanh about 0 and 0.5, arctan about 0 and 0.5, 1/x about 0.5, 1/(x−1) about 0.75, sqrt(abs(x))·sign(x) about 0.5) are the MATLAB script's cases | confirmed | `taylor_series_animation_code.m` lists exactly these 11 cases |
| V2 | The embedded videos show those cases | could not determine | YouTube videos not viewable here; MATLAB not run (per brief) |
| V3 | sin has R=∞ | confirmed | Entire |
| V4 | tanh radius π/2≈1.571 about 0 and √(0.25+π²/4)≈1.648 about 0.5 | confirmed | 1.5708 and 1.64845 (desc.py) |
| V5 | arctan radius 1 about 0 and √1.25≈1.118 about 0.5 | confirmed | 1.11803 |
| V6 | sqrt(abs(x))·sign(x) is continuous, abs has a corner and sign jumps at 0, the derivative is infinite at 0, R=0.5 about 0.5, and the series cannot converge across 0 | confirmed | The function is sqrt(x) for x>0 with a branch point at 0 |
| V7 | exp about 0 has R=∞; higher orders converge more and more | confirmed | Entire |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | One order per frame | confirmed | Loop `for k in 0:n_terms`, one frame each; frame counts n+1 (13/12/11/9) match the manifest |
| A2 | One frame per second | confirmed | `fps=1`; `identify -format %T` gives 100 cs per frame (M01, M09, T13) |
| A3 | Current order blue | confirmed | `color=:steelblue`, label "current order" |
| A4 | From order 1 on, the previous order is drawn in gray | confirmed | `y_prev = sums[k]` for k≥1 (order k−1); at k=0 it equals the current curve and is hidden under it. The T08 and M15 sheets show gray = order k−1 |
| A5 | Target function magenta | confirmed | `color=:magenta` |
| A6 | The red dot marks (x0, f(x0)) | confirmed | `scatter!([case.c],[f(c)])`; visible at the right place in all 31 last frames |
| A7 | Parts of a polynomial outside the y-range are drawn along the top or bottom edge | confirmed | `clamp.(ys, ylims…)` (line 370); frames show edge runs (for example T01 and M07) |
| A8 | All 31 GIFs come from one Julia script, which is linked | confirmed | The manifest shows all 31 regenerated byte-identical from `series_animations_all.jl`; the link target exists |
| A9 | "Maclaurin Cases (18)" | confirmed | 18 rows m01–m18 |
| A10 | "Taylor Cases (13)" | confirmed | 13 rows t01–t13 |
| M01–M18, T01–T13 headings | Function, x0 and interval of each heading | confirmed, all 31 | Each matches the table row (lines 24–56) and the GIF title, and all 31 match Mathews' index exactly (legacy_formulas.png; T03's missing x0 image and T04's missing function image are settled by the legacy last frames: √x about 5, log x about 1; T10's missing interval matches [−0.2,5.2] visually). Detail: M07/M08 [−3π,3π]; M09 [−π,π]; M10 [−2,3]; M11 [−2,4]; M12 [−4,4]; M13 [−2,2]; M14 [−1.5,1.5]; M15/M16 [−10.2,10.2]; M17/M18 [−3,3]; M01–M06 [−1.5,1.5]; T01–T03 [0,10.5], x0=1,4,5; T04/T05 [−0.5,4.1], x0=1,2; T06 x0=π/4, [−7π/4,9π/4]; T07 x0=π/3, [−5π/3,7π/3]; T08–T10 [−0.2,5.2], x0=1,2,3; T11–T13 [0,22], x0=10,5,2 |
| Alt texts (31) | Each names the function and center | confirmed | Every alt text matches its heading and GIF |
| Embeds (31) | Each heading embeds `series_<id>.gif` for the same id | confirmed | Ids in headings and filenames agree, and each GIF's title shows the same id |

---

### 3. Implementation checks (`series_animations_all.jl`)

**It is the method it claims to be.** It is a truncated Taylor polynomial T_n(x)=Σ_{k≤n} a_k (x−c)^k, with a_k = f^(k)(c)/k! and the powers accumulated term by term (`partial_sum`, lines 334–343). The Maclaurin coefficients come from closed forms per case (lines 225–332). The Taylor coefficients come from a BigFloat routine (`taylor_coeffs_exact`) using binomial series, log, sin/cos cycles, the log-Gamma/Hurwitz-zeta expansion for Γ, and the derivative formula for Bessel Y. No approximation passes under the name.

**The numbers are right.** I instrumented a scratch copy (`review/instr.jl`) to dump every case's coefficient vector (`review/coeffs.tsv`). An independent check (`review/check_coeffs.py`) compares them with `mpmath.taylor` at 60 digits about the same Float64 center:

| case | max relative coefficient error vs mpmath | case | max relative error |
|---|---|---|---|
| m01–m04 | 0 | t01, t02 | 0 |
| m05 | 0 (abs 4e−63 on the zero terms) | t03 | 8.3e−17 |
| m06 | 5.6e−17 | t04, t05 | 5.6e−17 |
| m07 | 6.7e−17 | t06 | 9.5e−17 |
| m08 | 8.6e−17 | t07 | 9.3e−17 |
| m09 (hand-typed tan table through x¹¹) | 8.6e−17 | t08 Γ about 1 | 5.2e−17 |
| m10, m12 | 8.6e−17 | t09 Γ about 2 | 6.3e−17 |
| m11 (Re((−1+i)^k)/k!) | 6.7e−17 | t10 Γ about 3 | 9.3e−17 |
| m13, m14 | 5.6e−17 | t11 Y0 about 10 | 9.8e−17 |
| m15, m16 | 5.6e−17 | t12 Y0 about 5 | 9.2e−17 |
| m17, m18 | 1.3e−17 … 1.3e−16 | t13 Y0 about 2 | 5.8e−17 |

So every coefficient is correctly rounded to within one Float64 ulp. Because a_k = f^(k)(c)/k! is matched for every k up to n, each polynomial matches f's derivatives at c to the stated order. This is the property check the brief asks for.

**Reference values are right.** The magenta "true" curve is the function itself: Base `sin`, `cos`, `tan`, `exp`, `cosh`, `atan`, `asin`, `log`, `sqrt`, and SpecialFunctions `besselj`, `bessely`, `gamma`, `erf`. Each closure in lines 24–56 is the function in the heading. Domain errors (asin for |x|>1, log for x≤0, sqrt of negatives, bessely for x≤0) become NaN through `safe_eval`, so those parts are simply not drawn, which is correct. f(c) for the red dot comes from the same closure. In the frames it sits at the right height: 1 for M01–M05, M08, M10, M12, M15; 0.399 for M17; 0.5 for M18; √5=2.236 for T03; ln 2=0.693 for T05; 0.7071 for T06; 0.5 for T07; Γ(3)=2 for T10; Y0(10)=0.0557, Y0(5)=−0.3085 and Y0(2)=0.5104 for T11–T13.

**The picture shows what was computed.** I read the last frames of all 31 GIFs at legible size (`review/last_1..4.png`) and the full contact sheets of T08 and M15.
- Titles show family, id, the function label (for example `normal_pdf(x)`, `besselj(0,x)`, `gamma(x)`) and x0 rounded to 4 decimals (0.7854 = π/4, 1.0472 = π/3). All agree with the headings.
- The "order = k" annotation advances 0…n by one per frame, and the gray curve is order k−1.
- Poles are handled by `break_at_poles`, so no spurious vertical segments appear at x=1 (M01), x=−1 (M02), ±π/2 (M09) or x=0 (T08–T10).
- Polynomials are clamped to the y-limits, and the page discloses this (A7). I found no case where clamping changes the conclusion, because the page states no per-case value that clamping could hide.
- Cosmetic only, not a finding: the "order = k" label overlaps the "0" y-tick in some frames (T01–T03, T08–T10, M10). For even or odd functions, every other frame repeats the previous polynomial, so the gray and blue curves coincide on those frames. This is mathematically correct.

**Regeneration:** the manifest reports that all 31 GIFs regenerate byte-identical from a scratch copy of the script. I did not re-run the full render. My instrumented copy ran to completion and only dumped coefficients.

