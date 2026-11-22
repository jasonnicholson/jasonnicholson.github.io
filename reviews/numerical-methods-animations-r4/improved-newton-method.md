# Improved Newton Method — animation review (round 4)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match, Minor: "each drawn line is the tangent" leaves out the vertical segments

- **Location:** `index.qmd` lines 24–25: "For standard Newton (Cases 1, 3, 5) each drawn line is the tangent at $x_n$; for Method A (Cases 2, 4) it is the line of slope $f'(x_n)/m$. At each iterate $x_n$, the line connecting $(x_n, f(x_n))$ to the next iterate's x-intercept traces the convergence path."
- **What is there:** Every script draws two segments per step, in the same colour. One is the tangent or effective-tangent segment from (xₙ, f(xₙ)) to (xₙ₊₁, 0). The other is a vertical segment from (xₙ₊₁, 0) up or down to (xₙ₊₁, f(xₙ₊₁)): `newtonimpaa.jl` 50, `newtonimpbb.jl` 56, `newtonimpcc.jl` 48, `newtonimpdd.jl` 53, `newtonimpee.jl` 49. Those vertical lines are clearly visible, for example in every frame of `newtonimpee.gif` after the first. Read literally, the page says that every drawn line is a tangent or a line of slope f'/m.
- **What is true:** The sloped segments are exactly what the page says. `slopes.jl` gives a slope equal to f'(xₙ)/m to about 1e-15 relative for every case; for example Case 2 step 0 has slope 1.0350 against f'(1.3)/2 = 1.0350, and Case 4 step 0 has 0.306 against 0.918/3 = 0.306. The vertical segments are the usual "return to the curve" strokes and are not described anywhere.
- **Correction:** Say "each slanted line is the tangent at $x_n$ … and each vertical line returns from $(x_{n+1},0)$ to the curve at $(x_{n+1}, f(x_{n+1}))$."

No other findings. Every numerical, behavioural, wiring and archive claim checked out; see the ledger.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Totals: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 6.5 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 6.5 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 6.8 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 6.0 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 6.6 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonimpaa.gif` | 11 | byte-identical | newtonimpaa |
| `newtonimpbb.gif` | 4 | byte-identical | newtonimpbb |
| `newtonimpcc.gif` | 13 | byte-identical | newtonimpcc |
| `newtonimpdd.gif` | 4 | byte-identical | newtonimpdd |
| `newtonimpee.gif` | 7 | byte-identical | newtonimpee |

### Page references

- Scripts linked: `newtonimpaa.jl`, `newtonimpbb.jl`, `newtonimpcc.jl`, `newtonimpdd.jl`, `newtonimpee.jl`
- GIFs embedded: 5
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Descr. l.12 | Newton, when it converges, is quadratic at a simple root and only linear at a root of multiplicity m ≥ 2 | Standard theory; matches the computed ratios in Cases 1 and 3 (rows 13, 22) | confirmed |
| 2 | l.13 | Mathews compares three improvements for multiple roots | Archive: Methods A, B and the "new Method C" | confirmed |
| 3 | l.15 | Method A: $x_{n+1}=x_n-m f/f'$ | Archive formula (8)/(9); scripts bb and dd, line 31 | confirmed |
| 4 | l.16 | Method B is Newton on u = f/f' and equals $x - ff'/(f'^2-ff'')$; u has a simple root where f has a multiple one | Algebra: u' = (f'²−ff'')/f'², so u/u' is the stated quotient; u = (x−p)g/(mg+(x−p)g') | confirmed |
| 5 | l.17 | Method C: compute $x_{n,m}$ from m = 1, increase m while $\|f(x_{n,m+1})\|<\|f(x_{n,m})\|$, take the last such point | Archive gr_115: Δx = f/f', p1 = p0−Δx, p2 = p0−2Δx, j = 3, while \|y2\|<\|y1\| advance; keep p1 | confirmed |
| 6 | l.19 | Started close enough to a multiple root, A and B converge quadratically | Archive theorems; Cases 2 and 4 computed (rows 17, 27) | confirmed |
| 7 | l.19 | The animations show standard Newton and Method A; Case 5 also discusses B and C | Scripts: aa, cc, ee are Newton and bb, dd are Method A; Case 5 text discusses B and C | confirmed |
| 8 | l.23 | Cases 1–4 have a multiple root at x = 1; Case 5 is arctan with a simple root at 0 | sympy factor: (x−1)²(x+2), (x−1)³(x+2) | confirmed |
| 9 | l.24 | Standard Newton: the drawn line is the tangent at xₙ; Method A: the line has slope f'(xₙ)/m | `slopes.jl`: slopes match to round-off; but vertical segments are drawn too (F1) | confirmed for the sloped lines; wording incomplete (F1) |
| 10 | l.25 | The line from (xₙ, f(xₙ)) to the next iterate's x-intercept traces the path | Plot code lines 47/53/51/46/47 | confirmed |
| 11 | l.26 | Newton degrades to linear at multiple roots; A restores quadratic by multiplying the step by m | Rows 13, 17, 22, 27 | confirmed |
| 12 | l.30–31 | Cases 1–4 follow Examples 1 and 2. Example 3 (quadruple root), the B and C iterations, and the caveats are not animated. The Ex.1 caveat plots rounding noise in the expanded f near the double root; the Ex.2 caveat runs A with m = 2 at the triple root, which converges only linearly | Archive: Ex.1/Ex.2 functions and p0 = 1.3 match; gr_193 = (x−1)⁴(x+2) (checked by expansion); gr_158 plots the expanded f on [0.99999999, 1.00000001] ("multiples of machine epsilon"); gr_178/189 use m = 2 and give a slow table. Independent run with m = 2: error ratios 0.353, 0.341, 0.336, 0.334, 0.3336, 0.3334 → 1/3, which is linear | confirmed |
| 13 | Case 1 heading | Standard Newton, linear, double root, f = x³−3x+2, x₀ = 1.3 | `newtonimpaa.jl` l.11, 15 | confirmed |
| 14 | Case 1 | f = (x−1)²(x+2), double root at 1 | sympy factor | confirmed |
| 15 | Case 1 | "Each step only halves the error rather than squaring it … creeps slowly … over many steps" | Exact error ratios 0.5217, 0.5121, 0.5064, 0.5033, 0.5017, 0.5009, 0.5004, 0.5002, 0.5001, 0.50005; x₁₀ = 1.000321 | confirmed |
| 16 | Case 1 alt | Slow linear convergence from 1.3 toward the double root at 1 | Frames 1–11: labels 1.3 … 1.000321 | confirmed |
| 17 | Case 2 heading/behaviour | Method A, m = 2, quadratic, same f and x₀ | `newtonimpbb.jl` l.14, 18, 20, 31. Exact iterates 1.3, 1.0130434783, 1.0000281717, 1.0000000001323; e_k/e_{k−1}² = 0.145, 0.166, 0.1667 (steady, so quadratic) | confirmed |
| 18 | Case 2 | "same function, same starting point, completely different speed" | Script bb uses the factored form of the same polynomial (identical mathematically; expanded and factored differ by ≤ 2.5e-16 at 0.7, 1.3, 1.7). x₀ = 1.3 in both | confirmed |
| 19 | Case 2 alt | Quadratic convergence to x = 1 "in just a few steps" | 4 frames; labels 1.3, 1.013043, 1.000028, 1.0 | confirmed |
| 20 | Case 3 heading | Standard Newton, triple root, f = x⁴−x³−3x²+5x−2, x₀ = 1.3 | `newtonimpcc.jl` l.11, 15 | confirmed |
| 21 | Case 3 | f = (x−1)³(x+2) | sympy factor | confirmed |
| 22 | Case 3 | The asymptotic error constant is (m−1)/m = 2/3; each step cuts the error by 1/3; slower than the double root | Exact ratios 0.6765, 0.6736, …, 0.6669, 0.6668 → 2/3; x₁₂ = 1.002423 against Case 1's x₁₀ = 1.000321 | confirmed |
| 23 | Case 3 alt | Very slow linear convergence from 1.3 toward the triple root | Frames: labels 1.3 … 1.002423 (13 frames) | confirmed |
| 24 | Case 4 heading/behaviour | Method A, m = 3, quadratic at the triple root | `newtonimpdd.jl` l.14–15, 18, 20, 31. e_k/e_{k−1}² = 0.098, 0.1107, 0.1111 | confirmed |
| 25 | Case 4 | The animated iterates are 1.3, 1.008824, 1.000009, then x₃ within 10⁻¹¹ of the root, labelled 1.0 | Exact: 1.3, 1.0088235294, 1.0000086167, 1.0000000000082497 (error 8.25e-12 < 1e-11). Script: 1.0000000000082498. GIF labels: 1.3, 1.008824, 1.000009, 1.0 | confirmed |
| 26 | Case 4 | Knowing m gives quadratic convergence whatever the root order | Cases 2 and 4 | confirmed |
| 27 | Case 4 alt | Quadratic convergence from 1.3 to the triple root | 4 frames as above | confirmed |
| 28 | Case 5 heading | Standard Newton diverges, f = arctan x, x₀ = 1.4 | `newtonimpee.jl` l.11, 15; iterates 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103 | confirmed |
| 29 | Case 5 | Simple root at 0 | arctan'(0) = 1 ≠ 0 | confirmed |
| 30 | Case 5 | Converges only when \|x₀\| < x_c ≈ 1.3917; 1.4 is just outside | mpmath root of 2x = (1+x²)atan x: x_c = 1.39174520027 | confirmed |
| 31 | Case 5 | Each step overshoots further; the iterates escape toward ±∞ | \|xₙ\| = 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103 (strictly increasing, alternating sign) | confirmed |
| 32 | Case 5 | Method A with m = 1 is standard Newton and does not fix this | Identity | confirmed |
| 33 | Case 5 | u = (1+x²)arctan x; u is increasing and convex for x > 0 | sympy: f/f' − u = 0; u' = 1+2x·atan x > 0; u'' = 2(x+(1+x²)atan x)/(1+x²) > 0 for x > 0 | confirmed |
| 34 | Case 5 | Method B iterates decrease monotonically: 0.6316, 0.1712, 0.00625, 3.25×10⁻⁷, … | mpmath formula (10): 0.631573, 0.171166, 0.00624689, 3.25005e-7, 4.58e-20 | confirmed |
| 35 | Case 5 | Method C: x_{1,1} ≈ −1.41, x_{1,2} ≈ −4.23 with larger \|f\|, so C keeps m = 1 every step and diverges exactly as Newton | Mathews' algorithm in `indep.py`: step 0 trials −1.41362 (\|f\| = 0.9551) and −4.22724 (\|f\| = 1.3385), so it keeps −1.4136. Every one of 6 steps keeps j = 1 and reproduces the Newton sequence exactly. General argument: for \|x\| > x_c the Newton point lies on the far side and the m = 2 point lies farther out on the same side, where \|atan\| is larger | confirmed |
| 36 | Case 5 | Methods A and C do not repair a global-convergence failure | Rows 32, 35 | confirmed |
| 37 | Case 5 alt | Divergent oscillation from 1.4, just outside the critical radius | Row 31; frames show alternating sides with growing spread | confirmed |
| 38 | Wiring | Each "[Julia source]" link and each embed points at that case's script and GIF (aa → Case 1, bb → 2, cc → 3, dd → 4, ee → 5) | index.qmd l.39/41, 49/51, 59/61, 69/71, 84/86; the script parameters match each heading; the manifest says each GIF is byte-identical to its script's output | confirmed |
| 39 | Intro l.28 | Julia sources linked under each case | 5 links | confirmed |

---

### 3. Implementation checks

### `newtonimpaa.jl`: standard Newton, f = x³−3x+2, x₀ = 1.3, 10 steps

- **Method:** `xs[i+1] = xs[i] - f/fp` is plain Newton-Raphson. fp = 3x²−3 agrees with the central difference at 0.7, 1.3 and 1.7 (−1.53, 2.07, 5.67).
- **Numbers, script against exact rationals:** x₁ 1.1565217391304348 / 1.15652173913043478; x₅ 1.0102496959724938 / 1.01024969597249446; x₁₀ 1.0003213616712867 / 1.00032136167120003. The largest difference is 8.7e-14 (cancellation in the expanded form, far below the 6-digit labels). The values also agree with Mathews' Example 1 table (gr_130) to the 15 digits printed there. Error ratios tend to 1/2.
- **Reference:** the root x = 1 is exact by factoring.
- **Picture:** 11 frames, labels x₍0₎ … x₍10₎ matching the iterates rounded to 6 digits. The sloped segment's slope equals f'(xₙ) (2.0700, 1.01263, 0.50020). The vertical segments end on the curve. All iterates and f values lie inside xlims (0.6, 1.8) and ylims (−0.1, 1.3). No clamping. Only the curve above y = 1.3 is clipped, which is harmless.

### `newtonimpbb.jl`: Method A, m = 2, same f and x₀, 3 steps

- **Method:** `xs[i] - m*f/fp` with m = 2 is Method A (archive formula (9)). Factored f = (x−1)²(x+2) and fp = 3(x−1)(x+1) agree with the derivative (central difference matches).
- **Numbers:** script 1.0130434782608697, 1.0000281716593107, 1.000000000132272; exact 1.01304347826086957, 1.00000281716593107…, i.e. 1.0000281716593107334, and 1.0000000001322718682. They agree to all digits printed. Mathews' table gives x₃ = 1.0000000001359235. His value is off in the 11th digit because he iterated the expanded polynomial; the script is right.
- **Comments verified:** expanded f(1+1.3e-10) = 0.0 against true 5.07e-20 ✓; "x3 is within 1.4e-10" (1.32e-10) ✓; a 4th step gives x₄ = 1.0 exactly and then 0/0 ✓ (Julia: 0.0/0.0).
- **Picture:** 4 frames with labels 1.3, 1.013043, 1.000028, 1.0. The sloped segment's slope is 1.0350 = f'(1.3)/2 ✓.

### `newtonimpcc.jl`: standard Newton, f = x⁴−x³−3x²+5x−2, x₀ = 1.3, 12 steps

- **Method:** plain Newton. fp = 4x³−3x²−6x+5 matches the central difference.
- **Numbers:** script x₁ 1.2029411764705882, x₆ 1.0274800683263425, x₁₂ 1.0024225476442639; exact 1.20294117647058824, 1.02748006832633937, 1.00242254764131469. The largest difference is 2.9e-12, and the 6-digit labels are unaffected. Error ratios tend to 2/3.
- **Reference:** the root is 1 (factor).
- **Picture:** 13 frames, labels correct to 6 digits, and every segment's slope equals f'(xₙ). Everything lies inside xlims (0.5, 1.6) and ylims (−0.05, 0.5).

### `newtonimpdd.jl`: Method A, m = 3, same quartic, 3 steps

- **Method:** Method A with m = 3. Factored f = (x−1)³(x+2) and fp = (x−1)²(4x+5) are correct (central difference at 0.7, 1.3, 1.7 gives 0.702, 0.918, 5.782).
- **Numbers:** script 1.0088235294117647, 1.0000086167279412, 1.0000000000082498; exact 1.0088235294117647059, 1.0000086167279411765, 1.0000000000082497462 ✓. e/e² tends to 1/9. Mathews' x₂ = 1.000008616730388 is off in the 12th digit (expanded form); the script is right.
- **Comments verified:** expanded f(1+6.4e-7) = −8.88e-16 against true 7.86e-19 ✓; x₃ within 1e-11 ✓; a 4th step gives exactly 1.0 and then 0/0 ✓.
- **Picture:** 4 frames with labels 1.3, 1.008824, 1.000009, 1.0. The step-0 slope is 0.306 = 0.918/3 ✓.

### `newtonimpee.jl`: standard Newton, f = arctan x, x₀ = 1.4, 6 steps

- **Method:** plain Newton with fp = 1/(1+x²).
- **Numbers:** script and mpmath agree to all printed digits: −1.4136186488, 1.45012931463, −1.55062597564, 1.84705408415, −2.89356239314, 8.71032584698.
- **Reference:** x_c = 1.39174520027 (mpmath). The script header's "~1.3917" is right.
- **Picture:** 7 frames. The labels for x₀ to x₅ are rounded to 4 digits and correct. x₆ = 8.71 lies outside xlims (−4, 5). It is not clamped: the marker is omitted, the legend reads "x₍6₎ = 8.71 (out of range)", and the segment from x₅ to x₆ is skipped. That is honest labelling, not a clamped value shown as real. All the drawn segment slopes equal f'(xₙ) (0.33784, 0.33352, 0.32228). The final frame shows the alternating, widening pattern the page describes.

### Not determined

Nothing material. I did not check the visual layout of every intermediate Case 1 and Case 3 frame pixel by pixel. I viewed the contact sheets, which cover every frame of aa, bb, dd and ee and 7 of the 13 frames of cc, plus the last frame of aa at full size, and the labels I could read all match the computed values.

