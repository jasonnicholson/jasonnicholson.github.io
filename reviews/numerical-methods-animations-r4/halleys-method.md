# Halley's Method — animation review (round 4)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Case 2 frame annotation reads "x₂ = -2.0", which contradicts the page's "Halley [first reaches −2 exactly] at x₃"
- **Kind:** Page match (display of a computed value)
- **Severity:** Minor
- **Location:** `halleysba.jl` lines 86–87, `text("x$(SUB[frame+1]) = $(round(x_cur; digits=8))", …)`. This appears in the 3rd frame of `halleysba.gif` (frame_003.png), at the bottom right.
- **What is there now:** The annotation shows `x₂ = -2.0` with an equals sign. `round(…; digits=8)` gives `-2.0`, and Julia prints that without trailing zeros, so the 8-decimal precision is not visible. The page says: "in double precision Newton first reaches $-2$ exactly at $x_5$, Halley at $x_3$."
- **What is true:** In double precision, x₂ = -2.0000000029138016 (error -2.91e-9). The first iterate exactly equal to -2.0 is x₃. Rounded to 8 decimals, -2.00000000 is correct. The display "-2.0" next to "=" reads as exact, though, and that disagrees with the page text a few lines above the GIF.
- **How I know:** `julia review/halleysba_instr.jl` prints `x2 = -2.0000000029138016   err = -2.913801644410796e-9` and `x3 = -2.0   err = 0.0`. An independent Python double-precision run (`indep.py`) prints `'-2.0000000029138016'` for x₂ and gives "Halley at k= 3".
- **Suggested correction:** Print the annotation with a fixed number of decimals so that trailing zeros show, for example `@sprintf("%.10f", x_cur)` (shows -2.0000000029), or change `=` to `≈`. Either keeps the frame consistent with the page's "x₃" statement. Case 1b already prints 10 digits and does not have this problem at x₂.

No other findings. The fidelity check found no departure: all three cases match Mathews' Examples 1(a), 1(b) and 2(b), with the same function, starting value and number of terms. The dropped Example 2(a) is disclosed on the page.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 6.1 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 8.6 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 6.4 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (method formulas and algorithm)
| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Halley "fits an osculating hyperbola … $y=\frac{a+b(x-x_n)}{1+c(x-x_n)}$ that matches $f,f',f''$ at $x_n$, and takes its x-intercept as $x_{n+1}$" | Confirmed | sympy solves for a, b, c from the three matching conditions. The root of the numerator equals $-2ff'/(2f'^2-ff'')$; the difference simplifies to 0. |
| D2 | Taylor-parabola root gives a different iteration ("Halley's irrational method") | Confirmed (the different iteration). Name accepted as standard terminology. | For f=x²−2, x₀=2, the parabola root is 1.41421356… (exact for a quadratic) and the hyperbola root is 1.428571, so the two iterations differ. |
| D3 | Cubic convergence at simple roots; digits roughly triple vs double for Newton | Confirmed | Series of g(e): the e¹ and e² coefficients are 0 and the e³ coefficient is nonzero (sympy). The observed digit counts are below. |
| D4 | Iteration formula $x_{n+1}=x_n-\frac{2ff'}{2f'^2-ff''}$ | Confirmed | Identical to the hyperbola root (D1). Scripts ab and ba line 32 use exactly this form. |
| D5 | Equivalent "Newton-correction" form | Confirmed | sympy difference of the two forms = 0 |
| D6 | The correction factor is ≈1 near a simple root | Confirmed | f→0 while f′≠0, so $ff''/(2f'^2)\to0$ |
| D7 | $C=\left|\frac{f'''}{6f'}-\frac{f''^2}{4f'^2}\right|$ | Confirmed | sympy e³ coefficient = $(f''^2/4 - f'f'''/6)/f'^2$, which equals the page's expression up to sign inside the absolute value. Case 1: C=1/8. Observed e₂/e₁³ = 3.644e-7/0.014358³ ≈ 0.123. |
| D8 | At a multiple root (m≥2) the method reverts to linear convergence | Confirmed | Halley on (x+2)(x−1)² near x=1: error ratios 0.352, 0.340, 0.3356, … → 1/3 (linear) |
| D9 | Three evaluations per step (f, f′, f″) vs two for Newton | Confirmed | Definition |
| D10 | log2/log3 ≈ 0.63; $3^{1/3}\approx1.442$; $2^{1/2}\approx1.414$ | Confirmed | mpmath: 0.63093, 1.44225, 1.41421 |
| D11 | √2 from x₀=2 to 20,000 digits: Halley 10 iterations vs Newton 15 | Confirmed | `sqrt2_20000.py` at dps 20010: Newton 15, Halley 10 |
| D12 | "…but takes about as long or slightly longer" | Confirmed (implementation-dependent) | mpmath (python backend), best of 5 runs: Newton 15 iterations 0.052 s, Halley 10 iterations 0.063 s |

### Animations section (introduction)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Case 1a shows Newton tangent construction alone, tangent blue dashed | Confirmed | aa.jl l.52 `steelblue, ls=:dash`; frames show no hyperbola |
| A2 | Cases 1b/2: current iterate xₙ marked on the curve | Confirmed | red dot at (x_cur, f(x_cur)), ab l.71 / ba l.71; frames |
| A3 | Tangent (blue dotted) shows where Newton would jump next | Confirmed | ab l.64, ba l.65 `ls=:dot`; the blue diamond is at x_cur − f/f′ |
| A4 | Osculating hyperbola (orange dashed) crosses the x-axis at the Halley iterate | Confirmed | `darkorange, ls=:dash`. Instrumented root(H) equals xs[n+1] bit-for-bit in every frame. H matches f, f′ and f″ at xₙ (finite differences agree to 1e-7). |
| A5 | Cubic rather than quadratic convergence at simple roots | Confirmed | D3, and the per-case data below |
| A6 | Julia scripts linked under each case | Confirmed | links present |
| A7 | Cases 1a, 1b, 2 follow Mathews Examples 1(a), 1(b), 2(b) | Confirmed | Archive: Ex 1 is f=x²−2, p₀=2 (Newton in 1a, Halley in 1b). Ex 2 is f=x³−3x+2, root −2, p₀=−2.2 (2a Newton, 2b Halley). |
| A8 | Example 2(a) applies Newton to the Case 2 function from the same starting value and is not animated | Confirmed | archive `gr_177`/`gr_178`: p₀ = −2.2 for both parts; the 2(a) output shows −2.0222… |
| A9 | Case 2's blue diamond shows only the Newton step from the current Halley iterate | Confirmed | ba l.78 `x_newton = x_cur - fv/fpv` with x_cur a Halley iterate |

### Case 1a
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1a-1 | f(x)=x²−2, x₀=2 (heading) | Confirmed | aa l.10, l.13; title in frames |
| 1a-2 | Tangent at each iterate hits the x-axis at the next iterate | Confirmed | aa l.49/28; orange diamond at x_next |
| 1a-3 | Converges quadratically to √2 ≈ 1.41421 | Confirmed | errors 0.0858, 2.45e-3, 2.12e-6, 1.59e-12, 9.0e-25 (mpmath); e_{n+1}/e_n² → 1/(2√2)=0.354 |
| 1a-4 | Roughly doubling correct digits | Confirmed | digits 1.07, 2.61, 5.67, 11.8, 24.0, 48.5 |
| 1a-5 | x₁=1.5, x₂≈1.4167, x₃≈1.4142 | Confirmed | 1.5, 1.416667, 1.414216 |
| 1a-6 | Alt text: each frame advances one tangent-line step, converging quadratically to √2 | Confirmed | 7 frames x₀…x₆, one tangent per frame |
| 1a-7 | Wiring: link `halleysaa.jl`, embed `halleysaa.gif` | Confirmed | script writes halleysaa.gif; manifest byte-identical |

### Case 1b
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1b-1 | f(x)=x²−2, x₀=2 | Confirmed | ab l.10–14 |
| 1b-2 | Uses f′ and f″ to correct the Newton step | Confirmed | ab l.32 |
| 1b-3 | Orange diamond marks the Halley iterate; blue diamond marks Newton | Confirmed | ab l.82–87; frame_001 legend "Newton ≈ 1.5", "Halley ≈ 1.428571" |
| 1b-4 | x₁ ≈ 1.42857 (vs Newton's 1.5) | Confirmed | 10/7 = 1.4285714 (script and mpmath) |
| 1b-5 | Digits roughly triple: about 1.8, 6.4, 20 after steps 1–3 (extended precision) | Confirmed | mpmath: 1.843, 6.438, 20.22 (then 61.6, 185.6) |
| 1b-6 | Asymptotic error is governed by \|g‴(x*)\|/3!, not \|g″(x*)\|/2! | Confirmed | g′(x*)=g″(x*)=0 by the series in D3; g‴/6 = 1/8 matches the observed 0.123 |
| 1b-7 | Alt text: hyperbola whose x-intercept is the Halley iterate, alongside the Newton tangent, both next iterates on the x-axis, converging to √2 | Confirmed | frames 1–4 |
| 1b-8 | Wiring | Confirmed | `halleysab.jl` → `halleysab.gif` |

### Case 2
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 2-1 | f(x)=x³−3x+2, x₀=−2.2 | Confirmed | ba l.10, l.14 |
| 2-2 | f=(x+2)(x−1)²: simple root −2, double root 1 | Confirmed | expand: x³−3x+2 |
| 2-3 | Halley converges cubically | Confirmed | errors 2.06e-3, 2.91e-9, 8.25e-27, 1.87e-79; e_{n+1}/e_n³ → C = 1/3 (2.914e-9/2.062e-3³ ≈ 0.332) |
| 2-4 | Halley x₁ ≈ −2.002, Newton x₁ ≈ −2.022 | Confirmed | −2.0020619, −2.0222222 |
| 2-5 | Newton errors ≈ 2.2e-2, 3.2e-4, 6.9e-8, 3.2e-15 after steps 1–4 (extended precision) | Confirmed | mpmath 2.222e-2, 3.221e-4, 6.913e-8, 3.186e-15 |
| 2-6 | Halley errors ≈ 2.1e-3, 2.9e-9, 8.2e-27 after steps 1–3 | Confirmed | 2.062e-3, 2.914e-9, 8.246e-27 |
| 2-7 | Double precision: Newton first reaches −2 exactly at x₅, Halley at x₃ | Confirmed, but the GIF annotation at x₂ reads "−2.0" (F1) | Julia script and an independent Python double run: Newton x₄ = −2.000000000000003, x₅ = −2.0; Halley x₂ = −2.0000000029, x₃ = −2.0 |
| 2-8 | Neither first step overshoots; both stay left of the root | Confirmed | −2.0222 < −2 and −2.00206 < −2 |
| 2-9 | Halley's first step lands within 0.0021 of the root | Confirmed | 0.0020619 |
| 2-10 | The two first-step markers are about 0.02 apart and overlap; the legend gives the values | Confirmed | separation 0.02016. In frame_001 the blue diamond is hidden under the orange one. Legend: −2.02222 / −2.002062. |
| 2-11 | Alt text: hyperbola and tangent, both next iterates marked, cubic convergence to the simple root −2 | Confirmed | frames |
| 2-12 | Wiring | Confirmed | `halleysba.jl` → `halleysba.gif` |

---

### 3. Implementation checks

### `halleysaa.jl` (Case 1a, Newton baseline)
- **Method:** Plain Newton-Raphson, x − f/f′ (l.28), which is what the page says Case 1a is.
- **Numbers:** Script versus mpmath, to the shown digits: x₁ 1.5 / 1.5; x₂ 1.4166666666666667 / 1.41666666667; x₃ 1.4142156862745099 / 1.41421568627; x₄ 1.4142135623746899 (err 1.59e-12) / err 1.595e-12. They agree.
- **Reference values:** √2 is exact (Julia `sqrt(2.0)` and mpmath agree).
- **Picture:** The tangent at x_cur uses slope fp(x_cur) and passes through (x_cur, f(x_cur)). Its x-intercept is the orange diamond. The title matches the code's f. In frame_001 the legend reads "x₁ ≈ 1.5" and the annotation "x₀ = 2.0", both correct. Frames 5–7 are visually identical because the iterates have converged; that is acceptable. No clamping is used.

### `halleysab.jl` (Case 1b, Halley on x²−2)
- **Method:** Halley's rational iteration (l.32), the same form as the page's first formula. It is not Halley's irrational method, the Chebyshev method or another neighbouring iteration. Checks: the per-step root(H) equals xs[n+1] exactly, and the Newton-correction form in `indep.py` gives the same iterates.
- **Numbers:** Script versus mpmath: x₁ 1.4285714285714286 / 1.42857142857; x₂ 1.4142139267767408 (err 3.644e-7) / err 3.644e-7; x₃ err −2.2e-16 (double floor) / 6.05e-21.
- **Hyperbola construction:** b₁ = −f″/(2f′), a₁ = f′ + f·b₁. sympy confirms these equal the solved c and b (difference 0). In the instrumented run, H(xₙ)−f = 0, H′−f′ ~3e-9 and H″−f″ ~1e-7 (finite-difference noise).
- **Display device:** The NaN mask beyond the pole is used, but here the pole is at 3xₙ (6.0, 4.29, 4.24), outside the window x ∈ [1, 2.6], so the full branch through xₙ is drawn and nothing is masked.
- **Picture:** Frame 1 shows the Halley diamond at 1.428571, the Newton diamond at 1.5 and the red dot at (2, 2). The legend values in frames 2–4 (Newton ≈ 1.41429, then 1.41421; Halley ≈ 1.414214) match the computed values. The 10-digit annotations match x₁…x₄.

### `halleysba.jl` (Case 2, Halley on x³−3x+2)
- **Method:** The same Halley rational iteration (l.32).
- **Numbers:** Script versus independent Python double and mpmath: x₁ −2.002061855670103 / −2.0020618556701; x₂ −2.0000000029138016 / −2.0000000029138; x₃ = −2.0 exactly (double); Newton-from-x₀ in the legend −2.022222222222222 / −2.0222222222222. root(H) equals xs[n+1] exactly at every step.
- **Reference values:** The simple root −2 is exact, since f(−2) = −8+6+2 = 0.
- **Display devices:**
  - The tangent is clamped to ylims (l.64). The clamped portions lie exactly on the top and bottom borders of the plot box at y = 8 and y = −5, and the zoom in `review/ba_clamp_zoom.png` shows them indistinguishable from the frame, so the clamp is not misleading.
  - The hyperbola pole is at −3.945 (frame 1) and −3.5 later, left of xlims = −3, so the drawn branch (d > 0) covers the whole window. It leaves through the top of the plot naturally and is not clamped.
  - The first-step markers overlap, which the page states.
- **Picture:** The red dot is at (−2.2, f(−2.2) = −2.048). The legend in frame 1 reads −2.02222 / −2.002062, which is correct. Frames 3–6 are visually identical after convergence, which is acceptable. The only issue is the "x₂ = −2.0" annotation in frame 3 (F1).

### Fidelity to the archive
The page uses the same functions, starting values and iteration counts as the archive: 7 terms for 1(a), 5 for 1(b), n = 5 for 2(b). The archive's 2(a) value x₁ = −2.0222… matches the page's Newton x₁. The one archive example that is not animated, 2(a), is disclosed on the page. There are no fidelity findings.

