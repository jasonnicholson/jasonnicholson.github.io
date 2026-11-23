# Halley's Method — animation review (round 6)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.** Every checkable claim in the page agrees with my own computation and with the frames. All three scripts run the method they are labelled with and compute correct values. The sections below give the evidence.

Considered and rejected as findings:
- `halleysba.jl` line 65 clamps the tangent to `ylims`, which in principle draws flat segments along y = −5 and y = 8. I cropped and enlarged frame 1 (`review/ba1_top.png`, `review/ba1_bot.png`): those segments fall exactly on the plot-box border and cannot be seen. This is not misleading.
- In Cases 1b and 2 the legend labels say "Newton xₙ₊₁" and "Halley xₙ₊₁" without a specific index, while the corner annotation gives the specific xₖ. The values are correct for the current frame. This is not misleading.
- In Case 2, frame 2 labels the Newton step from x₁ as "≈ −2.0". The true value is −2.0000028, which correctly rounds to −2.0 at the 5 decimals used.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 6.1 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 8.1 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 7.0 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description ¶1 | Halley fits an osculating hyperbola y=(a+b(x−xₙ))/(1+c(x−xₙ)) matching f, f′, f″ at xₙ, and its x-intercept is xₙ₊₁ | Series expansion of H=(f+a₁t)/(1+b₁t) gives H′(0)=a₁−fb₁, H″(0)/2=−b₁(a₁−fb₁). With b₁=−f″/(2f′) and a₁=f′+fb₁ these match f′ and f″, and the root t=−f/a₁=−2ff′/(2f′²−ff″). Numerically (instrumented scripts) H(xₙ)−f=0, H′−f′≈1e−8, H″−f″≈1e−8 (finite-difference noise), H(xₙ₊₁)≤4e−16 | confirmed |
| D2 | Description ¶1 | The Taylor-parabola root gives a different iteration (Halley's irrational method) | standard; that iteration involves a square root and is not the rational formula | confirmed |
| D3 | Description ¶1 | Cubic convergence at simple roots; digits roughly triple vs double for Newton | Case 1b digits 0.23→1.84→6.44→20.2→61.6; Case 2 log-ratio 3.18, 3.06 | confirmed |
| D4 | Iteration Formula | xₙ₊₁ = xₙ − 2ff′/(2f′² − ff″) | matches scripts (ab l.32, ba l.33) and the archive's h[x] (gr_243) | confirmed |
| D5 | Iteration Formula | Equivalent form xₙ − (f/f′)·1/(1 − ff″/(2f′²)) | algebraic identity; identical to Mathews' h[x] | confirmed |
| D6 | ¶ after formula | The correction factor is near 1 when \|ff″\| ≪ 2f′², which always happens close to a simple root | f→0 and f′≠0 there | confirmed |
| D7 | Convergence | \|eₙ₊₁\| ≈ C\|eₙ\|³ with C = \|f‴/(6f′) − f″²/(4f′²)\| | sympy series of eₙ₊₁ gives e³·(f″²/4 − f′f‴/6)/f′², which equals the page's C in absolute value. Numerical check: x²−2 gives C=1/8, and e₄/e₃³ = 2.7662e−62/(6.0486e−21)³ = 0.1250. (x+2)(x−1)² at −2 gives C=\|6/54 − 144/324\|=1/3, and e₄/e₃³ = 1.8692e−79/(8.2463e−27)³ = 0.3333 | confirmed |
| D8 | Convergence | At a multiple root of order m≥2 the method is linear | sympy limit of eₙ₊₁/eₙ = 1/3 (m=2) and 1/2 (m=3), i.e. (m−1)/(m+1) | confirmed |
| D9 | Trade-offs | 3 evaluations per step vs 2 for Newton | f, f′, f″ vs f, f′ | confirmed |
| D10 | Trade-offs | log2/log3 ≈ 0.63; 3^{1/3} ≈ 1.442; 2^{1/2} ≈ 1.414 | 0.63093, 1.44225, 1.41421 | confirmed |
| D11 | Trade-offs | √2 from x₀=2 to 20,000 digits: Halley 10 iterations vs Newton 15; about as long or slightly longer | `eff.py` (mpmath, dps 20050, stop at \|x−√2\|<1e−20000): Newton 15 iterations in 0.048–0.049 s, Halley 10 iterations in 0.051–0.053 s, over 3 runs | confirmed |
| A1 | Animations intro | Case 1a shows Newton tangent construction alone, tangent blue dashed | `halleysaa.jl` l.52 steelblue `:dash`; frames show it | confirmed |
| A2 | Animations intro | Cases 1b and 2: xₙ marked on curve, tangent blue dotted, osculating hyperbola orange dashed crossing the axis at the Halley xₙ₊₁ | ab l.59–74, ba l.60–75; H(xₙ₊₁)≈1e−16; in the frames the orange curve passes through the orange diamond | confirmed |
| A3 | Animations intro | Cases follow Mathews Examples 1(a), 1(b), 2(b); 2(a) (Newton, same function and start) not animated; Case 2's blue diamond is only the Newton step from the current Halley iterate | archive: Ex 1 f=x²−2, p₀=2; Ex 2 f=x³−3x+2, root −2, p₀=−2.2 for both (a) and (b). ba l.79 x_newton = x_cur − f/f′ | confirmed |
| 1a-P | Case 1a heading | f=x²−2, x₀=2, Newton | aa l.10–13, l.28 | confirmed |
| 1a-B1 | Case 1a Behavior | converges quadratically to √2 ≈ 1.41421, digits roughly double | digits 0.23, 1.07, 2.61, 5.67, 11.8, 24.1, 48.5 | confirmed |
| 1a-B2 | Case 1a Behavior | x₁=1.5, x₂≈1.4167, x₃≈1.4142 | exact: 3/2, 1.416667, 1.4142157; script identical | confirmed |
| 1a-Alt | Case 1a alt | each frame advances one tangent step, converging quadratically to √2 | 7 frames, x₀…x₆, one tangent each | confirmed |
| 1b-P | Case 1b heading | Halley, f=x²−2, x₀=2 | ab l.10–15, l.32 | confirmed |
| 1b-B1 | Case 1b Behavior | orange diamond = Halley iterate, blue diamond = Newton landing point | ab l.82–87; frame 1 shows blue at 1.5 and orange at 1.42857 | confirmed |
| 1b-B2 | Case 1b Behavior | Halley x₁ ≈ 1.42857 vs Newton x₁ = 1.5 | exact 10/7 = 1.4285714; Newton 3/2 | confirmed |
| 1b-B3 | Case 1b Behavior | accurate digits ≈ 1.8, 6.4, 20 after steps 1–3 (extended precision) | 1.843, 6.438, 20.22 | confirmed |
| 1b-B4 | Case 1b Behavior | \|g‴(x*)\|/3! governs the error rather than \|g″(x*)\|/2! | For Halley g′(x*)=g″(x*)=0, and the leading error coefficient is the e³ term (D7) | confirmed |
| 1b-Alt | Case 1b alt | hyperbola whose x-intercept is the Halley iterate, alongside the Newton tangent, both next iterates marked | frames 1–4; H(xₙ₊₁)≈1e−16 | confirmed |
| 2-P | Case 2 heading | Halley, f=x³−3x+2, x₀=−2.2 | ba l.11–15 | confirmed |
| 2-B1 | Case 2 Behavior | f=(x+2)(x−1)²: simple root −2, double root 1 | expansion: x³−3x+2 | confirmed |
| 2-B2 | Case 2 Behavior | Halley x₁ ≈ −2.002; Newton x₁ ≈ −2.022 | −2.0020619, −2.0222222 | confirmed |
| 2-B3 | Case 2 Behavior | Newton errors ≈ 2.2e−2, 3.2e−4, 6.9e−8, 3.2e−15 (steps 1–4) | 2.2222e−2, 3.2206e−4, 6.9127e−8, 3.1857e−15 | confirmed |
| 2-B4 | Case 2 Behavior | Halley errors ≈ 2.1e−3, 2.9e−9, 8.2e−27 (steps 1–3) | 2.0619e−3, 2.9138e−9, 8.2463e−27 | confirmed |
| 2-B5 | Case 2 Behavior | in double precision Newton first hits −2 exactly at x₅, Halley at x₃ | Float64: Newton x₄=−2.000000000000003, x₅=−2.0; Halley x₂=−2.0000000029138, x₃=−2.0 | confirmed |
| 2-B6 | Case 2 Behavior | neither first step overshoots; both stay left of the root; Halley within 0.0021 | −2.0222 and −2.00206 are both < −2; \|e₁\|=0.00206 | confirmed |
| 2-B7 | Case 2 Behavior | first-step markers ≈ 0.02 apart and overlap; legend gives values | separation 0.02016; in frame 1 the orange diamond covers the blue one; legend reads −2.02222 / −2.002062 | confirmed |
| 2-Alt | Case 2 alt | hyperbola and tangent, both next iterates marked, cubic convergence to −2 | frames 1–6; iterates as above | confirmed |
| W1 | Wiring | Case 1a → halleysaa.jl/.gif, 1b → halleysab, 2 → halleysba | the index.qmd links match the scripts' parameters and titles; the manifest shows committed GIFs byte-identical to regenerated ones | confirmed |
| F1 | Fidelity | functions, starting values and method per case match Mathews | archive images gr_61/62 (x²−2, √2, p₀=2), gr_175–178 (x³−3x+2, −2, p₀=−2.2), gr_243 (Halley h[x]) | confirmed |

### 3. Implementation checks

### `halleysaa.jl` (Case 1a, Newton baseline)
- **Method:** plain Newton xₙ₊₁ = xₙ − f/f′ (l.28). The page labels it as the Newton baseline, so the label is correct.
- **Numbers:** script iterates [2.0, 1.5, 1.4166666666666667, 1.4142156862745099, 1.4142135623746899, 1.4142135623730951, 1.414213562373095]. My exact rational Newton gives 3/2, 17/12, 577/408, … = 1.5, 1.41666666666667, 1.41421568627451, 1.41421356237469, 1.4142135623731… The two agree to double precision. x₆ is one ulp below x₅, which is ordinary rounding at the root.
- **Reference:** √2. The page does not draw a separate reference curve.
- **Picture:** the tangent at x_cur has slope fp(x_cur), and its zero is marked as the orange diamond at x_next. Legend and annotation indices match the frame (x₀…x₆). The final frame correctly has no "next" marker. The window [1, 2.6] contains every iterate.

### `halleysab.jl` (Case 1b, Halley on x²−2)
- **Method:** rational Halley iteration (l.32), the same formula as the page's Description and as Mathews' h[x]. It is not Halley's irrational method, and not Chebyshev's method.
- **Numbers:** script [2.0, 1.4285714285714286, 1.4142139267767408, 1.414213562373095, 1.4142135623730951]. Exact: 10/7, 1970/1393 = 1.41421392677674, then 1.4142135623731 (error 6.05e−21). They agree. Newton-from-current comparison values: script 1.5, 1.41428571, 1.41421356, 1.41421356; independent 1.5, 1.4142857142857144, 1.414213562373142, 1.4142135623730951. They agree.
- **Osculating hyperbola:** b₁=−f″/(2f′), a₁=f′+fb₁ (l.55–56). Analytically matches f, f′, f″ (D1). Instrumented values: H′−f′ ≈ 1e−8, H″−f″ ≈ 5e−9 to 2e−8 (finite-difference error), H(xₙ₊₁) ≤ 2.5e−16. The pole is at x = 6.0, 4.29, 4.24, 4.24, outside the window [1, 2.6], so the NaN mask never removes any visible part of the drawn branch.
- **Picture:** in frame 1 the orange dashed curve passes through the orange diamond at 1.42857 and the blue dotted tangent hits the blue diamond at 1.5. Later frames collapse onto √2. The corner annotation xₖ uses the correct index.

### `halleysba.jl` (Case 2, Halley on x³−3x+2)
- **Method:** same rational Halley formula (l.33).
- **Numbers:** script [−2.2, −2.002061855670103, −2.0000000029138016, −2.0, −2.0, −2.0]. Exact rational: −2.0020618556701 (e=−2.0619e−3), −2.0000000029138 (e=−2.9138e−9), −2 − 8.2463e−27. They agree. Newton-from-current values: script −2.02222222, −2.00000283, −2.0, …; independent −2.02222222222, −2.00000282833, −2.0. They agree.
- **Reference:** the root −2 is exact, since f(−2) = −8+6+2 = 0 and f′(−2) = 9 ≠ 0.
- **Hyperbola:** instrumented H(xₙ)−f=0, H′−f′ ≈ 1.6e−7, H″−f″ ≈ −2.1e−7 (finite-difference error at h=2e−4), H(xₙ₊₁) ≤ 4e−16. The pole is at −3.95 and then −3.50, left of the window's x=−3, so the drawn branch spans the whole window.
- **Picture:** the tangent is clamped to ylims (l.65), but the clamped segments lie on the box border and cannot be seen (enlarged crops). The double root at 1 and the local max at −1 (f=4) are visible in the window. The Newton and Halley first-step diamonds overlap as the page says. Annotation values match the computed xₖ to 10 decimals.

### Order and rate evidence (independent, extended precision)
- Case 1a Newton digits: 0.23, 1.07, 2.61, 5.67, 11.80, 24.05, 48.54. This is quadratic.
- Case 1b Halley digits: 0.23, 1.84, 6.44, 20.22, 61.56 (ratios 3.49, 3.14, 3.04). The asymptotic constant is 0.1250, which equals the predicted 1/8.
- Case 2 Halley: log-ratios 3.18, 3.06. The asymptotic constant is 0.3333, which equals the predicted 1/3.

