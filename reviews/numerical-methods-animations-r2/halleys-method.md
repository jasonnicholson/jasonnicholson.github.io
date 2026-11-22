# Halley's Method — animation review (round 2)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Page match (method description) — Minor
**Location:** `index.qmd` line 24: "The bracketed factor is a multiplicative correction to the Newton step. When $f''$ is small relative to $f'$, the denominator is close to 1 and Halley reduces to Newton-Raphson."

**What is there now:** The formula on line 22 has no bracketed factor. The only brackets are around $f'(x_n)$ in $[f'(x_n)]^2$. The correction factor is the fraction $1/(1 - f f''/(2f'^2))$. The wording comes from Mathews, whose formula (gr_58) does put this factor in parentheses with exponent $-1$. The page restyled the formula but kept the wording. The stated condition is also incomplete. The denominator is close to 1 when $|f\,f''| \ll 2 f'^2$, so the size of $f$ matters as much as the ratio $f''/f'$. In particular the factor tends to 1 as $x_n$ approaches a simple root, whatever $f''$ is.

**Evidence:** Case 2 at $x_0=-2.2$: $f''/f' = -13.2/11.52 \approx -1.15$, so $f''$ is not small relative to $f'$, yet $f f''/(2f'^2) = 27.0336/265.4208 = 0.102$ and the factor is 1.113. At $x_1 = -2.00206$ the instrumented run shows Newton −2.0000028 and Halley −2.0000000029 from the same point, so the factor is almost exactly 1 once $f$ is small. The same pattern shows in frame 2 of halleysab: Newton 1.41429 vs Halley 1.414214.

**Suggested correction:** "The second factor, $1/\bigl(1 - f f''/(2f'^2)\bigr)$, is a multiplicative correction to the Newton step. When $|f(x_n) f''(x_n)|$ is small compared with $2[f'(x_n)]^2$, which always happens close to a simple root, this factor is close to 1 and the Halley step nearly coincides with the Newton step."

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity — Minor
**Location:** `index.qmd`, Case 2 (lines 64–70), and the set of cases.

**What is there now:** Mathews has two examples, each in two parts: (a) Newton-Raphson and (b) Halley. The parts are Ex 1, $x^2-2$ with $p_0=2$, and Ex 2, $x^3-3x+2$ with $p_0=-2.2$ (gr_61, gr_63, gr_64, gr_175, gr_177, gr_178; lnk_2 to lnk_5). The page keeps 1(a) as Case 1a, 1(b) as Case 1b, and 2(b) as Case 2. Example 2(a), the Newton-Raphson sequence on $x^3-3x+2$, is dropped without comment. Case 2 marks only a one-step "Newton from the current Halley iterate" comparison. A reader therefore never sees Newton's own iterate sequence for Example 2, and the Case 2 sentence "demonstrating that Halley requires fewer iterations to attain high precision" rests on a comparison the page does not show.

**Evidence:** Both sequences from `indep.py` (120 digits):
- Newton from −2.2: errors 0.2, 2.22e-2, 3.22e-4, 6.91e-8, 3.19e-15, 6.8e-30.
- Halley from −2.2: errors 0.2, 2.06e-3, 2.91e-9, 8.2e-27.

The claim is true: Halley reaches double precision at $x_3$ and Newton at $x_5$. Only its demonstration is missing.

**Suggested correction:** Either add a Case 2a (Newton on $x^3-3x+2$, $x_0=-2.2$), mirroring 1a and 1b, or state in Case 2 that Mathews' Newton part 2(a) is folded into the blue comparison marker. In that case, give Newton's sequence error values in the Behavior paragraph, for example "Newton needs 5 steps to reach machine precision, Halley 3".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 6.0 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 6.4 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 6.1 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `halleysaa.gif` | 7 | byte-identical | halleysaa |
| `halleysab.gif` | 5 | byte-identical | halleysab |
| `halleysba.gif` | 6 | byte-identical | halleysba |

### Page references

- Scripts linked: `halleysaa.jl`, `halleysab.jl`, `halleysba.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Desc. l.12 | Halley "fits an osculating hyperbola … $y=\frac{a+b(x-x_n)}{1+c(x-x_n)}$ that matches $f,f',f''$ at $x_n$, and takes its $x$-intercept as $x_{n+1}$" | `hyper.py`: H−f, H'−f', H''−f'' are all exactly 0 at $x_0$ for both functions. Zero of H is 10/7 (Case 1) and −971/485 (Case 2), equal to the Halley iterate exactly | confirmed |
| D2 | Desc. l.12 | Root of Taylor parabola gives a different iteration (irrational method) | Case 2: parabola root −1.999098 vs Halley −2.002062 | confirmed |
| D3 | Desc. l.12 | cubic convergence at simple roots; digits roughly triple vs double for Newton | indep.py digits: Halley 1.84, 6.44, 20.2, 61.6; Newton 1.07, 2.61, 5.67, 11.8, 24.0 | confirmed |
| D4 | l.18 | $x_{n+1}=x_n-\frac{2ff'}{2f'^2-ff''}$ | Standard Halley formula. Reproduces Mathews' closed form $(x^3+6x)/(3x^2+2)$ for $x^2-2$ (sympy difference 0; Mathews gr_59 with a=2) | confirmed |
| D5 | l.22 | Equivalent form $\frac{f}{f'}\cdot\frac{1}{1-ff''/(2f'^2)}$ | Algebra: multiply numerator and denominator by $2f'^2$ | confirmed |
| D6 | l.24 | "The bracketed factor is a multiplicative correction…" | No bracketed factor in the displayed formula | wrong (F1) |
| D7 | l.24 | "When $f''$ is small relative to $f'$, the denominator is close to 1" | The condition is $\lvert ff''\rvert \ll 2f'^2$. The factor → 1 near any simple root (see F1) | wrong / incomplete (F1) |
| D8 | l.28–30 | Simple root → order 3, $\lvert e_{n+1}\rvert\approx C\lvert e_n\rvert^3$ | ratios $e_{n+1}/e_n^3$: Case 1 → 0.0714, 0.1231, 0.12499995, 0.125; Case 2 → 0.2577, 0.3324, 0.33333 | confirmed |
| D9 | l.34 | $C=\lvert f'''/(6f') - f''^2/(4f'^2)\rvert$ | sympy series of the Halley map: $e^3(a_2^2-a_1a_3)/a_1^2$, the same magnitude as the page formula. Predicts C=1/8 (Case 1) and C=1/3 (Case 2), matching the observed ratios | confirmed |
| D10 | l.36 | Multiple root (m≥2) → linear convergence | Halley on the double root x=1 of $x^3-3x+2$ from 1.5: ratio $e_{n+1}/e_n$ → 0.3333 (= (m−1)/(m+1)) | confirmed |
| D11 | l.40 | Three evaluations ($f,f',f''$) per step vs two for Newton | By definition; the scripts evaluate exactly these | confirmed |
| D12 | l.40 | For high precision (e.g. √2 to hundreds of digits) Halley's cubic rate makes it "significantly faster overall" | This is a cost claim, not computed. For √2, $f''$ is constant, and the per-step cost is about one extra multiply for a 1.58× larger gain in digits per step, so the claim is plausible. It was not benchmarked | could not determine (no benchmark run; plausible) |
| A1 | Intro l.44 | Case 1a shows Newton tangent construction alone, tangent blue dashed | halleysaa.jl l.52 `:steelblue, ls=:dash`; frames show only the tangent | confirmed |
| A2 | Intro l.44 | Cases 1b and 2: current iterate marked on the curve | Red dot at $(x_n,f(x_n))$ in all frames (halleysab l.71, halleysba l.71) | confirmed |
| A3 | Intro l.44 | Tangent (blue dotted) shows where Newton would jump next | `:steelblue, ls=:dot`. Blue diamond at $x_n - f/f'$ | confirmed |
| A4 | Intro l.44 | Osculating hyperbola (orange dashed) crosses the x-axis at Halley iterate $x_{n+1}$ | `:darkorange, ls=:dash`; zero = Halley iterate exactly (D1); frames show the orange curve through the orange diamond | confirmed |
| A5 | Intro l.44 | cubic rather than quadratic at simple roots | D3, D8 | confirmed |
| A6 | l.46 | Julia source linked under each case | three `[Julia source]` links, one per case | confirmed |
| 1a-1 | Heading l.48 | Newton-Raphson, $f=x^2-2$, $x_0=2$ | halleysaa.jl l.10, 13, 28. GIF title matches | confirmed |
| 1a-2 | l.50 | Tangent at each iterate hits the x-axis at the next iterate | l.49 and l.65: orange diamond at the tangent zero, equal to xs[frame+2] (instrumented run: newton = next on every row) | confirmed |
| 1a-3 | l.50 | Converges quadratically to $\sqrt2\approx1.41421$ | ratio $e_{n+1}/e_n^2$ → $1/(2\sqrt2)$ (digits 1.07, 2.61, 5.67, 11.8, 24.0) | confirmed |
| 1a-4 | l.50 | $x_1=1.5$, $x_2\approx1.4167$, $x_3\approx1.4142$ | 1.5, 1.41666667, 1.41421569 (script and mpmath agree) | confirmed |
| 1a-5 | l.50 | "roughly doubling the number of correct digits per step" | see 1a-3 | confirmed |
| 1a-6 | alt l.54 | "Each frame advances one tangent-line step … converging quadratically to √2" | 7 frames, x0…x6, one tangent per frame | confirmed |
| 1a-7 | wiring | link halleysaa.jl, embed halleysaa.gif | the manifest reports the committed GIF byte-identical to the regenerated one | confirmed |
| 1b-1 | Heading l.56 | Halley, $f=x^2-2$, $x_0=2$ | halleysab.jl l.10–14, 32 | confirmed |
| 1b-2 | l.58 | Halley uses $f'$ and $f''$ to correct the Newton step | l.32 | confirmed |
| 1b-3 | l.58 | Orange diamond = Halley iterate; blue diamond = where Newton would land | l.82–87; frame 1 legend: Newton ≈ 1.5, Halley ≈ 1.428571 | confirmed |
| 1b-4 | l.58 | $x_1\approx1.42857$ vs Newton's 1.5 | 10/7 = 1.4285714 | confirmed |
| 1b-5 | l.58 | Digits roughly triple; about 1.8, 6.4 and 20 after steps 1–3 in extended precision | mpmath at 120 digits: 1.843, 6.438, 20.22 | confirmed |
| 1b-6 | l.58 | $\lvert g'''(x^*)\rvert/3!$ governs, not $\lvert g''(x^*)\rvert/2!$ | sympy: g'(√2)=0, g''(√2)=0, g'''(√2)/6 = 1/8 (the observed ratio). For Newton, g''/2 = √2/4 ≠ 0 | confirmed |
| 1b-7 | alt l.62 | Hyperbola whose x-intercept is the Halley iterate, the Newton tangent, both next iterates marked | frames 1–4 show both diamonds; frame 5 (final) has none, which is expected | confirmed |
| 1b-8 | wiring | halleysab.jl / halleysab.gif | byte-identical regen; title matches | confirmed |
| 2-1 | Heading l.64 | Halley, $f=x^3-3x+2$, $x_0=-2.2$ | halleysba.jl l.10–14 | confirmed |
| 2-2 | l.66 | $f=(x+2)(x-1)^2$: simple root −2, double root 1 | expansion: $(x+2)(x^2-2x+1) = x^3-3x+2$. f'(−2)=9≠0, f'(1)=0, f''(1)=6≠0 | confirmed |
| 2-3 | l.66 | $x_0=-2.2$ is near the simple root; Halley converges cubically | errors 0.2 → 2.06e-3 → 2.91e-9 → 8.2e-27; ratios → 1/3 | confirmed |
| 2-4 | l.66 | Halley $x_1\approx-2.002$ | −2.0020618557 (= −971/485) | confirmed |
| 2-5 | l.66 | Newton $x_1\approx-2.022$ | −2.0222222 | confirmed |
| 2-6 | l.66 | "Halley requires fewer iterations to attain high precision" | to double precision: Halley 3 steps, Newton 5 (mpmath errors in F2). True, but the page does not show it (F2) | confirmed (see F2) |
| 2-7 | l.66 | Neither first step overshoots; both stay left of the root | −2.0222 < −2 and −2.00206 < −2 | confirmed |
| 2-8 | l.66 | Halley lands within 0.0021 | 0.0020619 | confirmed |
| 2-9 | l.66 | The markers are about 0.02 apart and overlap at this scale; the legend gives values | 0.02016 apart ≈ 2.3 px at 5.5 units over ~630 px. In frame 1 the orange diamond (ms 6) hides the blue one (ms 5). Legend: −2.02222 / −2.002062 | confirmed |
| 2-10 | alt l.70 | Hyperbola, tangent, both next iterates marked, cubic convergence to −2 | frames 1–5 show both markers; the final frame shows none | confirmed |
| 2-11 | wiring | halleysba.jl / halleysba.gif | byte-identical regen; title matches | confirmed |
| F-1 | archive | Example functions and starting values follow Mathews | Ex1 $x^2-2$, $p_0=2$ (1a Newton, 1b Halley); Ex2 $x^3-3x+2$, $p_0=-2.2$. Mathews computes 7 Newton terms and 5 Halley terms; the scripts do 6 and 4 iterations, which also gives 7 and 5 terms | confirmed |
| F-2 | archive | All archive cases present | Ex 2(a) Newton missing (F2) | wrong (F2) |

---

### 3. Implementation checks

### `halleysaa.jl` — Newton-Raphson on $x^2-2$, $x_0=2$
- **Method:** plain Newton, $x - f/f'$ (l.28), with $f'=2x$ correct. This case is meant to be Newton (the baseline), and it is.
- **Numbers:** script (Float64) vs mpmath (120 digits):
  - x1 1.5 / 1.5
  - x2 1.4166666666666667 / 1.41666666666666666667
  - x3 1.4142156862745099 / 1.41421568627450980392
  - x4 1.4142135623746899 / 1.41421356237468991063
  - x5, x6 1.4142135623730951, 1.414213562373095 / √2 to 1e-24

  Agreement is to Float64 rounding. The x5→x6 change is a 1-ulp oscillation, invisible at the 8 digits annotated.
- **Reference:** √2 is the true root (f(√2)=0), and the page's quoted values are correct.
- **Picture:** tangent `f_cur + fp_cur*(x-x_cur)` at the current iterate with the correct slope. Orange diamond at the tangent zero, which equals the next iterate. Red dot on the curve; the dotted drop is correct. Legend subscripts: "tangent at x_k" with k = frame, and the next iterate is "x_{k+1}". The annotation "x_k = …" is correct for every frame checked (frames 1–7 via the contact sheet, frame 1 full size). No clamping. Window [1, 2.6] × [−2.5, 4.5] contains every iterate.

### `halleysab.jl` — Halley on $x^2-2$, $x_0=2$
- **Method:** rational Halley, $x - 2ff'/(2f'^2 - ff'')$ (l.32), with $f''=2$. This matches the page formula D4 and is the method named. It is not the irrational (parabola) variant.
- **Numbers:** script vs mpmath:
  - x1 1.4285714285714286 / 10/7
  - x2 1.4142139267767408 / 1.41421392677674085
  - x3 1.414213562373095 / √2 (err 6e-21)
  - x4 1.4142135623730951

  Comparison Newton steps from x0 and x1: 1.5 and 1.4142857142857144, both correct.
- **Reference:** √2. The page's extended-precision digit counts were checked separately at 120 digits (1b-5).
- **Picture:** hyperbola coefficients $b_1=-f''/(2f')$, $a_1=f'+f b_1$. The exact check in `hyper.py` gives a curve that matches f, f', f'' and has its zero at 10/7, so the drawn curve really is the osculating hyperbola, and its x-intercept really is the Halley iterate. The pole for x0 is at x=6, outside the window. Branch masking (d>0) only removes the far branch. The tangent is correct. In frames 1–4 the Newton and Halley diamonds sit at the computed values. Legend values match the instrumented output. Annotations x0…x4 are correct.

### `halleysba.jl` — Halley on $x^3-3x+2$, $x_0=-2.2$
- **Method:** same rational Halley update (l.32), with $f'=3x^2-3$ and $f''=6x$, both correct.
- **Numbers:** script vs mpmath:
  - x1 −2.002061855670103 / −2.00206185567010309
  - x2 −2.0000000029138016 / −2.00000000291380177
  - x3…x5 −2.0 / −2 + 8e-27

  Comparison Newton steps: −2.022222222222222 and −2.0000028283342526, both match mpmath.
- **Reference:** the root −2 is exact (factorisation, 2-2).
- **Picture:** for x0 the hyperbola has its pole at −217/55 ≈ −3.945, left of the window, so the branch through x0 spans the whole window. It matches f to second order and has its zero at −971/485 (`hyper.py`). The tangent is drawn with `clamp.(…, ylims)` (l.64). Where the tangent leaves the window, the clamped segments run along the bottom border (x < −2.56) and top border (x > −1.11). Zooming frame 1 (`ba_f1_edges.png`) shows they coincide with the axis frame and are barely visible. They change no conclusion, so this is not a finding. In frame 1 the orange Halley diamond covers the blue Newton diamond, as the page says. Frames 3–6 are identical apart from labels, because $x_2$ already rounds to −2.0 at 8 digits. Legend values in frames 2–5 show "−2.0" for both, which is correct at the 5 and 6 digits shown. Annotations x0…x5 are correct.

### Verification notes
- All three committed GIFs are byte-identical to fresh scratch regenerations (manifest). My instrumented copies reproduced the same iterates.
- Not determined: the cost-efficiency sentence D12, because no benchmark was run.

