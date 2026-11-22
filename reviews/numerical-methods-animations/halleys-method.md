# Halley's Method — animation review

Page: [`pages/numerical-methods/halleys-method/index.qmd`](../../pages/numerical-methods/halleys-method/index.qmd) · Scripts: `halleysaa.jl`, `halleysab.jl`, `halleysba.jl` · GIFs: 3

**Result:** 3 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Description says Halley's iterate is the root of the osculating Taylor parabola; it is not

- **Location:** index.qmd:12, "Halley's method fits an osculating (second-order Taylor) parabola and finds the root of that parabola nearest to the current point."
- **Now:** The geometric description says the root of the parabola $P(x)=f+f'(x-x_n)+\tfrac12 f''(x-x_n)^2$ is the next iterate. The formula on lines 18 and 22, and both scripts, use the rational Halley formula $x_n - 2ff'/(2f'^2-ff'')$.
- **True:** The root of the Taylor parabola is a different method: Halley's "irrational" method, also called the Euler/Cauchy method, $x_n - 2f/(f' \pm \sqrt{f'^2-2ff''})$. The rational formula that the page gives and the scripts run is the zero of the osculating hyperbola (the [1/1] Padé approximant) $H(t)=(f+a_1t)/(1+b_1t)$, with $t=x-x_n$, $b_1=-f''/(2f')$ and $a_1=f'+f\,b_1$. Equivalently, it is the parabola equation with one factor of $(x-x_n)$ in the quadratic term replaced by the Newton step. The two methods agree to third order but give different iterates.
- **Evidence:** `indep.py`:
  - $f=x^2-2$ at $x_0=2$: the Taylor-parabola roots are ±1.41421356237310, and the parabola is identically $f$ (`parabola - f identically zero? True`). The Halley iterate is 1.42857142857143, and the hyperbola root is 1.42857142857143.
  - $f=x^3-3x+2$ at $x_0=-2.2$: the Taylor-parabola roots are −1.99909849505702 and −0.655446959488435. The Halley iterate is −2.00206185567010, and the hyperbola root is −2.00206185567010.
  - The hyperbola matches the Taylor parabola through $O(t^2)$ in both cases (sympy: `True`).
- **Suggested fix:** Replace the sentence with: "Halley's method fits an osculating hyperbola, a rational function $y=(a+b(x-x_n))/(1+c(x-x_n))$ that matches $f$, $f'$ and $f''$ at $x_n$, and takes its $x$-intercept as $x_{n+1}$. Taking instead the root of the second-order Taylor parabola gives a related cubically convergent method (Halley's irrational method)." Alternatively, keep the parabola and say that Halley's formula comes from approximating the parabola's root by substituting the Newton step into the quadratic term.

- **Independent check:** confirmed.

### F2 — Error — Implementation — The animations present the Taylor parabola as Halley's construction, but the Halley iterate is not its intercept (in Case 1b the parabola coincides with f)

- **Location:**
  - halleysab.jl:53–56 (parabola) and :81 (comment "Mark Halley x-intercept (lower root of parabola, nearer to actual root)").
  - halleysba.jl:53–56.
  - index.qmd:44, "the osculatory (second-order Taylor) parabola (orange dashed) shows Halley's improved correction".
  - Alt texts at index.qmd:62 and :70, "Each frame shows the osculatory parabola alongside the Newton tangent …".
- **Now:** The parabola is built correctly from f, f′ and f″ at the current iterate. Both scripts then mark the Halley iterate in the same orange colour and call it the parabola's intercept, although it is not. Case 1b ($f=x^2-2$): the Taylor parabola of a quadratic is the quadratic itself, so the orange dashed curve lies exactly on the magenta curve in every frame (frames 1, 2 and 5 inspected). Its x-intercept is exactly √2, yet the orange diamond and its legend say "Halley xₙ₊₁ ≈ 1.428571". A reader who follows the drawn construction concludes that Halley lands on √2 in one step, which contradicts the legend. Case 2: the parabola's intercept is −1.99910, which is on the far side of the root, while the Halley diamond is at −2.00206. On screen the gap is under 1 px, so the picture appears to confirm the false construction.
- **True:** The point the animation marks as Halley's step is the zero of the osculating hyperbola $H$ (see F1), not the zero of the drawn parabola.
- **Evidence:** `indep.py` (numbers in F1). `halleysab_instr.jl` prints the iterates [2.0, 1.4285714285714286, 1.4142139267767408, 1.414213562373095, …], which match `indep.py` to all printed digits. Frames: `committed/halleysab/frame_001.png` (orange dashes overlay magenta), `reviewer/ab_f1_zoom.png`.
- **Suggested fix:** In both scripts, draw the osculating hyperbola instead of (or in addition to) the parabola, using `b1 = -fppv/(2fpv); a1 = fpv + fv*b1; hyper(x) = (fv + a1*(x-x_cur))/(1 + b1*(x-x_cur))`, and label it "osculating hyperbola". Its zero equals `xs[frame+2]` exactly. Its pole, at $x_n+2f'/f''$, falls outside the plotted window for every iterate on this page: x=6 and 4.29 for Case 1b frames 1–2, and x≈−3.95 and −3.5 for Case 2. NaN-mask it anyway. Fix the comment on line 81 of halleysab.jl. Update index.qmd:44 and the alt texts at :62 and :70 to name the hyperbola.

- **Independent check:** confirmed with correction. Checker: the mismatch between the drawn parabola's crossing and the Halley marker is visible only in Case 1b frame 1 (≈0.014 in x, a few pixels); in Case 2 it is sub-pixel. The construction drawn is still the wrong one in both.

### F3 — Error — Page match — Case 2 says the parabola "visibly corrects the Newton overshoot"; Newton does not overshoot and nothing is visibly corrected

- **Location:** index.qmd:66, "The orange dashed parabola visibly corrects the Newton overshoot."
- **Now:** The page claims that Newton overshoots and that the parabola visibly corrects it.
- **True:**
  - Newton does not overshoot. From $x_0=-2.2$ the Newton step lands at $x_1=-2.022222$, still left of the root −2 on the same side as $x_0$, so it falls short. The Halley step, at −2.002062, also stays on that side.
  - The drawn parabola's own intercept, −1.99910, is the one point that does overshoot (F2).
  - Nothing is visible. On the 5.5-unit-wide axis, the Newton diamond (−2.0222) and the Halley diamond (−2.0021) are about 2 px apart. In frame 1 the larger orange diamond fully covers the blue Newton diamond, so the "blue diamond shows where Newton would land" device (described in Case 1b, line 58) cannot be seen in Case 2.
- **Evidence:** `halleysba_instr.jl` prints the Newton step from x=−2.2 as −2.022222222222222 and the Halley step as −2.002061855670103. `indep.py` gives the parabola roots as −1.99909849505702 and −0.655…. `reviewer/ba_f1_zoom.png` shows only the red x₀ diamond and the orange diamond; no blue diamond is visible.
- **Suggested fix:** Delete the sentence, or replace it with: "Newton's step falls short at −2.022; Halley's step lands at −2.002, already within 0.0021 of the root." If the comparison should be visible, add an inset or zoom near x=−2. A narrower xlims, for example (−2.3, −1.9), for the first frame would also work.

- **Independent check:** confirmed.

### F4 — Minor — Page match — Animations intro describes all three animations as tangent + parabola with a "blue dotted" tangent; Case 1a has no parabola and a dashed tangent

- **Location:** index.qmd:44, "Each animation below illustrates the tangent-line and osculatory-parabola construction … the tangent line (blue dotted) …"
- **Now:** halleysaa.jl:52 draws the tangent with `ls=:dash` and draws no parabola. Case 1a is Newton only.
- **True:** Only Cases 1b and 2 show a parabola, and in those the tangent is dotted (`ls=:dot`). In Case 1a the tangent is dashed (frames 1 and 2 inspected).
- **Evidence:** halleysaa.jl:52; `committed/halleysaa/sheet.png`, `frame_002.png`.
- **Suggested fix:** Write "Cases 1b and 2 illustrate …; Case 1a shows the Newton tangent construction alone (blue dashed) as a baseline."

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — Case 1b cites $g'''(x^*)$ and $g''(x^*)$ without defining g

- **Location:** index.qmd:58, "because $|g'''(x^*)| / 3!$ governs the asymptotic error rather than $|g''(x^*)| / 2!$."
- **Now:** g appears nowhere else on the page.
- **True:** If g is the iteration map $x_{n+1}=g(x_n)$, the statement is correct. For Halley, $g'(x^*)=g''(x^*)=0$ and $g'''(x^*)/6=1/8$ for $x^2-2$, which matches C from line 34. For Newton, $g''(x^*)/2=\sqrt2/4$.
- **Evidence:** `gderivs.py` gives Halley $g=x(x^2+6)/(3x^2+2)$, g′ and g″ at √2 equal to [0, 0], g‴/6 = 1/8, and Newton g″/2 = √2/4.
- **Suggested fix:** Add "where $g$ is the iteration map, $x_{n+1}=g(x_n)$", or write the rate as $|e_{n+1}|\approx C|e_n|^3$ with C from the Convergence section.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `halleysaa.jl` | yes | 3.3 | halleysaa.gif |
| `halleysab.jl` | yes | 3.2 | halleysab.gif |
| `halleysba.jl` | yes | 3.1 | halleysba.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "extends Newton-Raphson by incorporating the second derivative $f''$" | formula on line 18 and scripts use f, f′, f″ | confirmed |
| 2 | 12 | "fits an osculating (second-order Taylor) parabola and finds the root of that parabola nearest to the current point" | indep.py: parabola root ≠ Halley iterate (1.41421 vs 1.42857; −1.99910 vs −2.00206) | wrong (→ F1) |
| 3 | 12 | "cubic convergence at simple roots — the number of accurate digits roughly triples each iteration, compared to doubling for Newton-Raphson" | indep.py empirical order: Halley 2.85, 2.9986, 3.0, 3.0; Newton 1.85, 1.98, 2.0 | confirmed |
| 4 | 18 | $x_{n+1}=x_n-\frac{2ff'}{2f'^2-ff''}$ | standard Halley; sympy error series $e^3(c_2^2-c_1c_3)/c_1^2$ (cubic) | confirmed |
| 5 | 22 | Equivalent form $x_n-\frac{f}{f'}\cdot\frac{1}{1-ff''/(2f'^2)}$ | algebra: multiply numerator and denominator of line 18 by $1/(2f'^2)$ | confirmed |
| 6 | 24 | "When $f''$ is small relative to $f'$, the denominator is close to 1 and Halley reduces to Newton-Raphson" | the denominator is $1-ff''/(2f'^2)$, which → 1 when $ff''/f'^2$ is small | confirmed |
| 7 | 30 | $\lvert e_{n+1}\rvert\approx C\lvert e_n\rvert^3$ | indep.py: $e_k/e_{k-1}^3$ → 0.125 (x²−2) and 0.33333 (cubic) | confirmed |
| 8 | 34 | $C=\lvert f'''/(6f')-f''^2/(4f'^2)\rvert$ | sympy general expansion: $e_{n+1}=e^3(c_2^2-c_1c_3)/c_1^2$, which equals the page formula up to sign; numerically C=1/8 and 1/3 match the observed ratios | confirmed |
| 9 | 36 | "At a multiple root of order m ≥ 2 … reverts to linear convergence" | sympy for a double root: $e_{n+1}/e_n\to1/3$ (linear) | confirmed |
| 10 | 40 | "three function evaluations — f, f′, f″ — versus two for Newton-Raphson" | per step: Halley evaluates f, f′, f″; Newton evaluates f, f′ | confirmed |
| 11 | 40 | "for high-precision arithmetic (e.g., √2 to hundreds of digits), Halley's cubic rate makes it significantly faster overall" | a cost claim; no benchmark was run | could not determine (performance claim; depends on the arithmetic cost model) |
| 12 | 44 | "Each animation below illustrates the tangent-line and osculatory-parabola construction" | Case 1a (halleysaa) has no parabola | wrong (→ F4) |
| 13 | 44 | "the current iterate $x_n$ is marked on the curve" | red dot at (x_cur, f(x_cur)) in all scripts; frames checked | confirmed |
| 14 | 44 | "the tangent line (blue dotted) shows where Newton's method would jump next" | dotted in 1b and 2; dashed in 1a (halleysaa.jl:52) | wrong (→ F4), minor |
| 15 | 44 | "the osculatory … parabola (orange dashed) shows Halley's improved correction" | the parabola's intercept is not the Halley iterate; in 1b it coincides with f | wrong (→ F2) |
| 16 | 48 | Case 1a: Newton-Raphson, $f=x^2-2$, $x_0=2$ | halleysaa.jl:10–13, 28; title in frames | confirmed |
| 17 | 50 | "converges quadratically to $x^*=\sqrt2\approx1.41421$" | √2 = 1.414213562…; Newton order → 2.0 | confirmed |
| 18 | 50 | "$x_1=1.5$, $x_2\approx1.4167$, $x_3\approx1.4142$" | script: 1.5, 1.4166666666666667, 1.4142156862745099; indep identical | confirmed |
| 19 | 52/54 | Case 1a link and embed → halleysaa.jl / halleysaa.gif | manifest: halleysaa.gif produced by halleysaa.jl, byte-identical | confirmed |
| 20 | 54 | Alt text: "Each frame advances one tangent-line step … converging quadratically to √2" | 7 frames, one Newton step each (sheet) | confirmed |
| 21 | 56 | Case 1b: Halley, $f=x^2-2$, $x_0=2$ | halleysab.jl:10–15, 32 | confirmed |
| 22 | 58 | "The orange diamond marks the Halley iterate; the blue diamond shows where Newton would land" | halleysab.jl:78–83 colours; frame 1 shows the blue diamond at 1.5 and the orange at 1.4286 | confirmed |
| 23 | 58 | "Halley achieves $x_1\approx1.42857$ in one step (vs Newton's $x_1=1.5$)" | 10/7 = 1.4285714; Newton 1.5 | confirmed |
| 24 | 58 | "tripling accurate digits each iteration" | errors 0.586 → 1.44e−2 → 3.64e−7 → 6.05e−21 | confirmed |
| 25 | 58 | "because $\lvert g'''(x^*)\rvert/3!$ governs … rather than $\lvert g''(x^*)\rvert/2!$" | gderivs.py: g′ = g″ = 0, g‴/6 = 1/8; but g is undefined on the page | confirmed as math; g undefined (→ F5) |
| 26 | 60/62 | Case 1b link and embed → halleysab.jl / halleysab.gif | manifest: byte-identical | confirmed |
| 27 | 62 | Alt text: "the osculatory parabola alongside the Newton tangent, with both next iterates marked on the x-axis" | both iterates marked (frames 1–4), but the parabola coincides with f and is not Halley's construction | wrong (→ F2) |
| 28 | 64 | Case 2: Halley, $f=x^3-3x+2$, $x_0=-2.2$ | halleysba.jl:10–14, 32 | confirmed |
| 29 | 66 | "$=(x+2)(x-1)^2$ has a simple root at −2 and a double root at 1" | sympy factor: (x−1)²(x+2) | confirmed |
| 30 | 66 | "Halley converges cubically" (to −2) | order 2.944, 2.9998, 3.0; ratio → 1/3 = C | confirmed |
| 31 | 66 | "first Halley step reaches $x_1\approx-2.002$" | −2.002061855670103 (script), −2.0020618556701031 (indep) | confirmed |
| 32 | 66 | "Newton only reaches $x_1\approx-2.022$" | −2.022222222222222 | confirmed |
| 33 | 66 | "Halley requires fewer iterations to attain high precision at simple roots" | after 3 steps, Halley error 8.2e−27 vs Newton 6.9e−8 | confirmed |
| 34 | 66 | "The orange dashed parabola visibly corrects the Newton overshoot" | Newton does not overshoot; the diamonds are about 2 px apart; the blue diamond is hidden | wrong (→ F3) |
| 35 | 68/70 | Case 2 link and embed → halleysba.jl / halleysba.gif | manifest: byte-identical | confirmed |
| 36 | 70 | Alt text: "osculatory parabola and tangent line, with Halley and Newton next iterates compared on the x-axis, demonstrating cubic convergence to the simple root x = −2" | convergence to −2 confirmed; the parabola is not Halley's construction (F2); in frame 1 the Newton marker is hidden (F3) | wrong (→ F2, F3) |

## Implementation checks

### halleysaa.jl
- **Method:** Plain Newton–Raphson, `xs[i] - f/fp` (line 28). The page labels it as a Newton baseline, so this is correct.
- **Derivatives:** f′ = 2x matches sympy.
- **Numbers:**

  | k | script | independent (mpmath, 400 digits) |
  |---|---|---|
  | 1 | 1.5 | 1.5 |
  | 2 | 1.4166666666666667 | 1.4166666666666667 |
  | 3 | 1.4142156862745099 | 1.4142156862745098 (last-digit Float64 rounding) |
  | 4 | 1.4142135623746899 | 1.4142135623746899 |
  | 5–6 | 1.414213562373095x | √2 |

  The empirical order is 1.85, 1.98, 2.00, 2.0.
- **Reference values:** The page cites √2 ≈ 1.41421, which is correct. No reference curve is drawn.
- **Picture:** Frames 1 and 2 checked full size, the rest via the contact sheet.
  - The tangent is drawn at x_cur with slope f′(x_cur).
  - The orange diamond is at the tangent's zero, labelled x_{k+1} with the correct subscript and value.
  - The annotation x_k is correct.
  - Frames 4–7 are visually identical (converged), which is acceptable.
  - Nothing is clamped.

### halleysab.jl
- **Method:** Rational Halley (line 32), which matches page line 18.
- **Derivatives:** f′ = 2x and f″ = 2 match sympy.
- **Numbers:**

  | k | script | independent |
  |---|---|---|
  | 1 | 1.4285714285714286 | 10/7 = 1.4285714285714286 |
  | 2 | 1.4142139267767408 | 1.4142139267767408 |
  | 3 | 1.414213562373095 | √2 (error 6.05e−21) |

  - The empirical order is 2.85, 2.9986, 3.0, 3.0.
  - $e_k/e_{k-1}^3$ → 0.125, matching C = 1/8 from line 34 and g‴/6 = 1/8 from gderivs.py.
  - The Newton comparison steps printed by the script are 1.5 and 1.4142857142857144, which are correct.
- **Reference values:** Halley's map for x²−2 in closed form is $x(x^2+6)/(3x^2+2)$, which is consistent.
- **Picture:** Frames 1, 2 and 5 checked full size, plus a zoom of frame 1.
  - The tangent and the parabola are both built from f, f′ and f″ at x_cur, correctly.
  - The parabola is identical to f, so the orange dashed curve hides under the magenta one, and its intercept is √2, not the marked Halley point (F2).
  - The legend labels use the generic "xₙ₊₁"; the annotation index x_k is correct.
  - The blue (Newton) and orange (Halley) diamonds are distinguishable in frame 1 (1.5 vs 1.4286). In later frames they overlap, as expected at convergence.

### halleysba.jl
- **Method:** Rational Halley (line 32).
- **Derivatives:** f′ = 3x²−3 and f″ = 6x match sympy.
- **Numbers:**

  | k | script | independent |
  |---|---|---|
  | 1 | −2.002061855670103 | −2.0020618556701031 |
  | 2 | −2.0000000029138016 | −2.0000000029138018 (Float64 rounding) |
  | 3+ | −2.0 | error 8.2e−27 |

  - The empirical order is 2.944, 2.9998, 3.0.
  - $e_k/e_{k-1}^3$ → 0.33333, matching C = 1/3 from line 34 (f′(−2)=9, f″(−2)=−12, f‴=6).
  - The Newton comparison step from −2.2 is −2.022222…, which is correct.
- **Reference values:** The roots −2 (simple) and 1 (double) are confirmed by sympy factorisation.
- **Picture:** Frame 1 checked full size, plus a zoom, and the remaining frames via the contact sheet.
  - The parabola and tangent are evaluated at x_cur with the correct coefficients.
  - The parabola's zero (−1.99910) differs from the marked Halley point (−2.00206) by under 1 px, so the false construction looks right (F2).
  - The Newton diamond is hidden under the Halley diamond in frame 1 (F3).
  - Display device: `clamp.` on the parabola and tangent (lines 55 and 60) produces flat segments drawn along the bottom border (parabola, x < −2.45 and x > −0.2) and the top border (tangent). They sit on the frame edge and do not change any conclusion, so they are not reported as a finding; NaN-masking would be cleaner.
  - Frames 3–6 are static at −2.0 after convergence, which is acceptable.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/halleys-method/`](evidence/halleys-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
