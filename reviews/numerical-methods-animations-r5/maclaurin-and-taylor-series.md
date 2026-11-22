# Maclaurin and Taylor Series — animation review (round 5)

Page: `pages/numerical-methods/maclaurin-and-taylor-series/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F2: Page match (alt text), Minor: M03 alt text reads as a different function
- **Location:** `index.qmd` line 104: `![Maclaurin animation for one over one minus x squared in the denominator, centered at zero.](series_m03.gif)`
- **What is there:** "one over one minus x squared". Spoken that way, it conventionally means 1/(1−x²). The page itself uses that convention one case later, where M05's alt text says "one over one plus x squared" for 1/(1+x²).
- **What is true:** M03 is 1/(1−x)². The heading (line 102), the script (line 26, `x -> 1 / (1 - x)^2`) and the GIF title ("1/(1-x)^2") all agree on this.
- **Suggested correction:** "Maclaurin animation for one over the square of one minus x, centered at zero."

No implementation findings and no fidelity findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Outside the review scope (not counted)

- F1: Page match (Video Animations section), Error: "abs" is called discontinuous — excluded: the passage is in the 'Video Animations' section, which the review brief puts out of scope (recorded, not counted; same item as rounds 3 and 4).

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
| D1 | Series about x0 converges for \|x−x0\|<R, diverges for \|x−x0\|>R; R = distance to nearest complex singularity | confirmed | Standard theorem for analytic f |
| D2 | arctan(x) and 1/(1+x²) have singularities at ±i, so R=1 about 0 | confirmed | Poles/branch points at ±i |
| D3 | tanh(x) has poles at ±iπ/2, so R=π/2 about 0 | confirmed | cosh(z)=0 at z=±iπ/2 |
| D4 | log(x) about 1 has R=1 (singularity at 0) | confirmed | |
| D5 | exp, sin, e^{−x²/2}, J0, normal CDF have R=∞ | confirmed | All entire |
| D6 | Normal CDF (M18) order-10 polynomial pulls away beyond about \|x\|=2 | confirmed | T10−Φ: 7.0e-4 at 1.5, 4.9e-3 at 1.8, 1.50e-2 at 2.0, 4.1e-2 at 2.2, 0.154 at 2.5 (`indep.py`) |
| D7 | At x=3 the order-10 value is 2.0006 | confirmed | Script `partial_sum` gives 2.000575081929585; mpmath gives 2.00057508193 |
| D8 | Order-40 value within 2×10⁻⁷ of the true 0.99865 | confirmed | Φ(3)=0.998650101968, T40(3)=0.998649986603, \|diff\|=1.15e-7 |
| D9 | T_n(x)=Σ f^(k)(x0)/k! (x−x0)^k | confirmed | The script implements exactly this (coefficients a_k=f^(k)(c)/k!, `partial_sum`) |
| D10 | Maclaurin = special case x0=0 | confirmed | |
| D11 | A composite rule exact for constant and linear terms but not quadratic is second-order; trapezoid is an example | confirmed | Trapezoid on 3x+1 gives err 0; on x² err 1/6; composite exp on [0,1] error ratios 3.9992, 3.9998 when n doubles |

### Video Animations section (checked although it is outside the GIF section)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | Sine has no singularities, so R infinite | confirmed | |
| V2 | tanh: R=π/2≈1.571 about 0, √(0.25+π²/4)≈1.648 about 0.5 | confirmed | 1.5708, 1.64845 |
| V3 | arctan: R=1 about 0, √1.25≈1.118 about 0.5 | confirmed | 1.11803 |
| V4 | abs and sign are "two discontinuous functions"; "discontinuities of sign and abs" | **wrong** | F1 |
| V5 | Series about 0.5 for sqrt(\|x\|)sign(x) cannot converge across x=0 | confirmed | Branch point at 0 gives R=0.5 |

### Animations: introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | One order per frame | confirmed | Loop `for k in 0:case.n_terms` draws T_k; frame labels "order = 0…n" in every contact sheet |
| A2 | One frame per second | confirmed | `fps = 1`; every frame of all 31 committed GIFs has duration 1000 ms (PIL) |
| A3 | Current order drawn blue | confirmed | `color=:steelblue`, label "current order"; frames |
| A4 | Previous order (gray) from order 1 on | confirmed | At k=0, y_prev = y_cur, so the gray is hidden under the blue. For k≥1 the gray is T_{k−1}; frames show it |
| A5 | Target function magenta | confirmed | `color=:magenta`; frames |
| A6 | Red dot marks (x0, f(x0)) | confirmed | `scatter!([case.c],[yc])`, yc=f(c); dot at the right place in all 31 sheets (e.g. Y0(10)=0.05567, Y0(5)=−0.3085, Γ(3)=2) |
| A7 | Polynomial parts outside the y-range are drawn along the top or bottom edge | confirmed | `clamp.(ys, ylims...)` (line 370); flat edge segments visible, e.g. M01, M07, T08 |
| A8 | All 31 GIFs generated by one Julia script | confirmed | Manifest: one script writes 31 GIFs, all byte-identical to committed |
| A9 | Source link `series_animations_all.jl` | confirmed | File exists and is the generator |
| A10 | "Maclaurin Cases (18)" | confirmed | 18 headings and 18 rows m01–m18 |
| A11 | "Taylor Cases (13)" | confirmed | 13 headings and 13 rows t01–t13 |

### Animations: per case (heading parameters, embed wiring, GIF title, alt text)
For every row, I checked the heading's f, x0 and interval against the case table (`series_animations_all.jl` lines 24–56), the embed filename against the case id, the GIF title against the full-resolution title strip (`review/titles.png`), and the plotted x-range against the frames.

| Case | Heading f, x0, interval | Script row | GIF title | Embed | Alt text | Verdict |
|---|---|---|---|---|---|---|
| M01 | 1/(1−x), 0, [−1.5,1.5] | same | "1/(1-x), x0 = 0.0" | series_m01.gif | ok | confirmed |
| M02 | 1/(1+x), 0, [−1.5,1.5] | same | "1/(1+x)" | m02 | ok | confirmed |
| M03 | 1/(1−x)², 0, [−1.5,1.5] | same | "1/(1-x)^2" | m03 | ambiguous (F2) | heading/GIF confirmed; alt **wrong-ish** (Minor) |
| M04 | 1/√(1−x), 0, [−1.5,1.5] | same | "1/sqrt(1-x)" | m04 | ok | confirmed |
| M05 | 1/(1+x²), 0, [−1.5,1.5] | same | "1/(1+x^2)" | m05 | ok | confirmed |
| M06 | log(1+x), 0, [−1.5,1.5] | same | "log(1+x)" | m06 | ok | confirmed |
| M07 | sin x, 0, [−3π,3π] | same | "sin(x)" | m07 | ok | confirmed |
| M08 | cos x, 0, [−3π,3π] | same | "cos(x)" | m08 | ok | confirmed |
| M09 | tan x, 0, [−π,π] | same | "tan(x)" | m09 | ok | confirmed |
| M10 | e^x, 0, [−2,3] | same | "exp(x)" | m10 | ok | confirmed |
| M11 | e^{−x}cos x, 0, [−2,4] | same | "exp(-x)*cos(x)" | m11 | ok | confirmed |
| M12 | cosh x, 0, [−4,4] | same | "cosh(x)" | m12 | ok | confirmed |
| M13 | arctan x, 0, [−2,2] | same | "atan(x)" | m13 | ok | confirmed |
| M14 | arcsin x, 0, [−1.5,1.5] | same | "asin(x)" | m14 | ok | confirmed |
| M15 | J0, 0, [−10.2,10.2] | same | "besselj(0,x)" | m15 | ok | confirmed |
| M16 | J1, 0, [−10.2,10.2] | same | "besselj(1,x)" | m16 | ok | confirmed |
| M17 | (1/√2π)e^{−x²/2}, 0, [−3,3] | same | "normal_pdf(x)" | m17 | ok | confirmed |
| M18 | ½+½erf(x/√2), 0, [−3,3] | same | "normal_cdf(x)" | m18 | ok | confirmed |
| T01 | √x, 1, [0,10.5] | same | "sqrt(x), x0 = 1.0" | t01 | ok | confirmed |
| T02 | √x, 4, [0,10.5] | same | "x0 = 4.0" | t02 | ok | confirmed |
| T03 | √x, 5, [0,10.5] | same | "x0 = 5.0" | t03 | ok | confirmed |
| T04 | log x, 1, [−0.5,4.1] | same | "log(x), x0 = 1.0" | t04 | ok | confirmed |
| T05 | log x, 2, [−0.5,4.1] | same | "x0 = 2.0" | t05 | ok | confirmed |
| T06 | sin x, π/4, [−7π/4,9π/4] | same | "x0 = 0.7854" (=π/4) | t06 | ok | confirmed |
| T07 | cos x, π/3, [−5π/3,7π/3] | same | "x0 = 1.0472" (=π/3) | t07 | ok | confirmed |
| T08 | Γ, 1, [−0.2,5.2] | same | "gamma(x), x0 = 1.0" | t08 | ok | confirmed |
| T09 | Γ, 2, [−0.2,5.2] | same | "x0 = 2.0" | t09 | ok | confirmed |
| T10 | Γ, 3, [−0.2,5.2] | same | "x0 = 3.0" | t10 | ok | confirmed |
| T11 | Y0, 10, [0,22] | same | "bessely(0,x), x0 = 10.0" | t11 | ok | confirmed |
| T12 | Y0, 5, [0,22] | same | "x0 = 5.0" | t12 | ok | confirmed |
| T13 | Y0, 2, [0,22] | same | "x0 = 2.0" | t13 | ok | confirmed |

The page makes no per-case behaviour claims (there are no "Behavior" paragraphs), so there is nothing further per case to check.

---

### 3. Implementation checks: `series_animations_all.jl`

**Is it the method it claims to be?** Yes. Each frame draws the degree-k truncated Taylor polynomial T_k(x)=Σ_{j≤k} a_j (x−c)^j with a_j=f^(j)(c)/j!, for k=0..n. The Maclaurin rows use hand-coded closed forms (lines 225–332). The Taylor rows use `taylor_coeffs_exact`, which computes in 256-bit BigFloat and rounds once. That routine uses binomial series for √x, the log series, sin/cos cycles, a log-Gamma expansion through digamma and Hurwitz zeta, and the Bessel derivative identity Z^(k)=2^{−k}Σ(−1)^j C(k,j) Z_{ν−k+2j}. I checked each of these formulas against standard identities, and the numbers below confirm them independently.

**Are the numbers right?**
- *Coefficients.* An instrumented copy (`review/inst.jl`, which is the original script up to line 412, without the render loop, plus a dump) wrote all 31 coefficient vectors to `review/julia_coeffs.tsv`. An independent computation (`review/indep.py`) uses `mpmath.taylor` at 60 digits on the true function, about the same Float64 centre. It does not depend on any coefficient formula. Result: the largest relative difference over every coefficient of every case is **1.32e-16**, which is about 1 ulp. For example, the last coefficients set side by side, script vs mpmath: M09 a11 8.863235529902e-03 / 8.863235529902e-03; T08 a8 9.981056937831e-01 / same; T11 a8 −7.795502897412e-07 / same; T13 a8 −2.913447427981e-04 / same; M04 a12 1.611802577972e-01 / same.
- *Partial sums actually plotted.* `review/inst2.jl` dumped `partial_sum` at 11 x-values per case for every order k. `review/cmp_psums.py` re-evaluated them from the mpmath coefficients. The largest relative difference is **1.3e-14**, the worst being T06 and M08, which come from cancellation in Float64 at large \|x−c\|. Visually negligible.
- *Frame/order indexing.* Frame k+1 shows T_k labelled "order = k", with gray T_{k−1}. Frame counts are n+1: 13 for n=12, 12 for M09 (n=11), 11 for n=10, 9 for n=8. These match the manifest.

**Are the reference values right?** The magenta curve is `safe_eval(case.f, x)` with standard library functions: `besselj`, `bessely`, `gamma`, `erf` and others. `review/inst3.jl` and `review/cmp_f.py` compare f at 129 points per case with mpmath. The largest relative difference is **2.3e-16**, and NaN appears in exactly the same places (log, sqrt and asin outside their real domains, and Y0 at 0). The f(c) values used for the red dot are correct: Y0(10)=0.0556712, Y0(5)=−0.3085176, Y0(2)=0.5103757, Γ(3)=2, √5=2.2360680.

**Does the picture show what was computed?** I checked the contact sheets of all 31 GIFs (`review/pair_*.png`) and read every title at full resolution (`review/titles.png`).
- Titles name the right function and centre for every row.
- Spot checks of plotted values agree with computation. M01 order 2 at x=±1.5 gives 4.75 and 1.75. M18 order 10 leaves the top (1.1) at about x≈2.55 and the bottom symmetrically.
- The magenta curves have the right shapes and extrema: J0 minimum −0.40 at ±3.83, J1 maximum 0.58 at 1.84, Y0 maximum 0.52 at about 2.2.
- `break_at_poles` stops a vertical line being drawn through the poles of tan (±π/2), 1/(1∓x) (±1) and Γ (0). No spurious vertical segments appear in M01, M02, M09 or T08–T10.
- Clamping of polynomials to the y-limits is disclosed on the page (A7) and does not hide the feature being shown. In every case the convergence region near x0 and the divergence past the radius are visible within the window.
- The committed GIFs are byte-identical to a fresh scratch run (manifest).

**Legacy fidelity.** The page's 31 cases correspond one to one with Mathews' "Animations for Taylor & Maclaurin Series" (`a2001/Animations/Interpolation/Series/Series.html`): the same functions, centres and intervals, in the same order (`review/legacy_formulas.png`). Three of the legacy formula images are missing. I recovered those parameters from the legacy animations: T03 has its red dot at x0=5 (`review/legacy_Taylor03_last.png`), T04 is log(x) about 1, and T10 is Γ about 3 on about [−0.2,5.2]. Mathews ran to higher orders (S24, S30) with a tolerance band. The page stops at orders 8–12. That is a parameter choice the page does not contradict, so I do not report it as a finding.

