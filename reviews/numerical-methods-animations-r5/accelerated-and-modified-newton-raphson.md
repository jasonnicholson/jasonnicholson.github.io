# Accelerated & Modified Newton-Raphson — animation review (round 5)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page is confirmed by my own computation and by the frames. Every script runs the method it names, with correct numbers and correct drawing.

Observations below the threshold for a finding (no action needed):

- `accnewtonbb.jl`: in Float64, `f(x3)` evaluates to exactly `0.0`, so x3 = x4 = x5 = 1.0000000000036071, and frames 5 and 6 differ from frame 4 only in the legend index. The exact x3 is 1 + 6.21e-12, so the difference comes from Float64 rounding. Every value is 1.0 at the six digits displayed, and the page says nothing about x4 or x5.
- `accnewtoncc.jl`: the Float64 x3 is 1 + 8.37e-12, but in exact arithmetic it is 1 − 5.46e-12 (the opposite side of the root). This is Float64 rounding, it is invisible at the six digits shown, and the page claims only that "x₃ equals 1 to six decimals", which is true.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 6.8 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 6.7 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 6.1 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `accnewtonaa.gif` | 13 | byte-identical | accnewtonaa |
| `accnewtonbb.gif` | 6 | byte-identical | accnewtonbb |
| `accnewtoncc.gif` | 5 | byte-identical | accnewtoncc |

### Page references

- Scripts linked: `accnewtonaa.jl`, `accnewtonbb.jl`, `accnewtoncc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard N-R is quadratic at simple roots and linear at multiple roots because $f'(x^*)=0$ | Std. ratios e_{n+1}/e_n → 0.500009 (indep.py) | confirmed |
| D2 | Description | Method A: $x_{n+1}=x_n-m f/f'$, restores quadratic, needs $m$ | e_{n+1}/e_n² → 0.16667 (indep.py); matches Mathews gr_131 | confirmed |
| D3 | Description | $h=f/f'$ has a simple root at a root of $f$ of multiplicity $m$ | sympy: h = (x−1)(x+2)/(3(x+1)), simple zero at 1 | confirmed |
| D4 | Description | Method B formula $x - ff'/(f'^2-ff'')$ is Newton applied to $h$ | sympy: `simplify((x-h/h') - formulaB) == 0` → True | confirmed |
| D5 | Description | Method B quadratic without knowing $m$ | e_{n+1}/e_n² → −0.16667 | confirmed |
| I1 | Intro | Newton-style line diagram, three methods on the same double root | all three scripts use f = x³−3x+2, x0=1.2, root 1 | confirmed |
| I2 | Intro | In Cases 1 and 3 the line is the tangent to the plotted curve | Case 1 draws (x_n,f(x_n))→(x_{n+1},0), Newton on f; Case 3 drawn slope 0.4710744 = h'(1.2) 0.4710744 | confirmed |
| I3 | Intro | In Case 2 the line has half the tangent slope | drawn slope f(x0)/(x0−x1) = 0.66 = f'(1.2)/2 = 0.66 | confirmed |
| I4 | Intro | Cases 1 and 2 plot f; Case 3 plots h | scripts lines 40/42 plot f; cc line 56 plots h_plot; frames | confirmed |
| I5 | Intro | Cases reproduce Mathews Examples 1(b), 2, 4 at the double root of the same cubic | archive gr_31/34/35, gr_118/119/120, gr_233/234/235: f=x³−3x+2, p=1, p0=1.2 | confirmed |
| I6 | Intro | Ex. 1(a) is standard N-R at the simple root of the cubic | lnk_2; gr_32 p=−2, gr_33 p0=−2.4 | confirmed |
| I7 | Intro | Ex. 3 and 5 are accelerated and modified methods at a double and a triple root of a fifth-degree polynomial | gr_158/159/160: x⁵−8x⁴+25x³−38x²+28x−8 = (x−1)²(x−2)³ (sympy) | confirmed (the archive text calls it a "cubic", but the page is right) |
| I8 | Intro | Ex. 6 is standard, accelerated and modified methods at a root of higher multiplicity | gr_334: −x⁷+8x⁶−…+2 = −(x−2)(x−1)⁶, p=1 | confirmed |
| C1-h | Case 1 heading | Standard N-R, linear, f=x³−3x+2, x0=1.2 | accnewtonaa.jl lines 11, 15, 27 | confirmed |
| C1-a | Case 1 | f=(x−1)²(x+2), double root at 1 | sympy factor | confirmed |
| C1-b | Case 1 | Asymptotic error constant (m−1)/m = 1/2; each step halves the error | ratios 0.515, 0.508, 0.504, … 0.500009 | confirmed |
| C1-c | Case 1 | Near the root f ≈ 3(x−1)², so the tangent meets the axis between x_n and x*, about halfway | all iterates > 1 and decreasing; ratio ≈ 0.5 | confirmed |
| C1-d | Case 1 | Each step covers just under half the remaining distance: 1.2, 1.10303, 1.052356, 1.026401 | exact 1.2, 1.1030303, 1.0523564, 1.0264008; covered fraction 1−0.515 = 0.485 < 0.5 | confirmed |
| C1-e | Case 1 | After 12 steps x12 = 1.000052, about 5.2e-5 from the root | exact 1.0000520156; script 1.0000520156500807; frame 13 legend "1.000052" | confirmed |
| C1-f | Case 1 | From x5 on the iterate is < 0.007 from the root and its marker covers the root | e5 = 0.006643 (e4 = 0.01326). Pixels: x=1 is at px ≈ 220; x4 marker fill spans 223–231 (root not covered), x5 marker fill spans 219–227 (covered) | confirmed |
| C1-g | Case 1 alt | 12 iterations; from x5 the marker covers the root; progress shows only in the legend | 13 frames (x0..x12); frames 6–13 | confirmed |
| C2-h | Case 2 heading | Accelerated, m=2, quadratic, same f and x0 | accnewtonbb.jl lines 12, 16, 18, 29 | confirmed |
| C2-a | Case 2 | Orange line from (x_n, f(x_n)) has slope f'(x_n)/2 and meets the axis twice as far as the Newton tangent | slope 0.66 = f'(1.2)/2; step = 2× Newton step by construction; frames show orange line | confirmed |
| C2-b | Case 2 | x1 = 1.006061, x2 = 1.000006, x3 equals 1 to six decimals | exact 1.0060606, 1.0000061, 1+6.2e-12; script 1.0060606060606054, 1.0000061033293672, 1.0000000000036071; legends match | confirmed |
| C2-c | Case 2 | \|e_{n+1}\| ≈ C\|e_n\|² | e_{n+1}/e_n²: 0.1515, 0.1662, 0.16667 | confirmed |
| C2-d | Case 2 alt | orange half-slope lines; x₃ equal to 1 to six decimals | frames 2–6 | confirmed |
| C3-h | Case 3 heading | Modified (Method B), quadratic, same f and x0 | accnewtoncc.jl lines 14–16, 22–28, 31 | confirmed |
| C3-a | Case 3 | The formula implements Newton on h using f, f', f'' | sympy identity (D4) | confirmed |
| C3-b | Case 3 | The animation plots h = (x−1)(x+2)/(3(x+1)) with dashed tangents | cc line 19, 56, 64 (`ls=:dash`); frames | confirmed |
| C3-c | Case 3 | h is nearly straight; the first tangent lies almost on the curve | max \|h − tangent\| on [x1, x0] = 0.0029 against a y-range of 1.0 | confirmed |
| C3-d | Case 3 | x1 = 0.994152, just left of the root | exact 0.99415205; script 0.9941520467836247 | confirmed |
| C3-e | Case 3 | The overshoot and later steps are too small to see | x1 marker at px 253 vs root ≈ 255 (≈2 px); frames 2–5 look identical | confirmed |
| C3-f | Case 3 | x2 = 0.999994; x3 equals 1 to six decimals | exact 0.99999428, 1−5.5e-12; script 0.9999942779650373, 1.0000000000083733 | confirmed |
| C3-g | Case 3 alt | x₁=0.994152, just left of x=1; quadratic; x₃ equals 1 to six decimals; no m needed | as above | confirmed |
| W1 | Wiring | Case 1 → accnewtonaa.jl/.gif; Case 2 → bb; Case 3 → cc | links/embeds lines 37/39, 45/47, 55/57; GIF titles "Standard Newton", "Accelerated Newton (m=2)", "Modified Newton (Method B)" | confirmed |
| W2 | Wiring | Committed GIFs are what the scripts produce | md5 of instrumented-copy GIFs equals the committed ones (f97c6e63…, bd370e3f…, a54627af…) | confirmed |

### 3. Implementation checks

Independent computation: `review/indep.py` (sympy and mpmath at 40 digits). Script values: instrumented copies `review/inst/accnewton{aa,bb,cc}.jl` (appended a `println` of `xs`). Their GIFs are byte-identical to the committed ones, so the instrumentation changed nothing.

### accnewtonaa.jl (standard Newton)
- **Method:** `xs[i+1] = xs[i] - f/fp` is plain Newton-Raphson. f' = 3x²−3 is correct.
- **Numbers:**

| n | script | independent (mpmath) |
|---|---|---|
| 1 | 1.1030303030303028 | 1.10303030303030 |
| 2 | 1.052356417197916 | 1.05235641719792 |
| 3 | 1.0264008140553686 | 1.02640081405537 |
| 5 | 1.0066434177726777 | 1.00664341777268 |
| 12 | 1.0000520156500807 | 1.00005201564977 |

  Error ratios go 0.515 → 0.500009, which is linear with constant 1/2 = (m−1)/m for m=2.
- **Reference values:** the root x*=1 has multiplicity 2 (sympy factor). The title states "double root at x=1".
- **Picture:** each segment runs from (x_n, f(x_n)) to (x_{n+1}, 0), which is the tangent because x_{n+1} is the Newton intercept, followed by a vertical drop to f(x_{n+1}). The marker sits at (x_n, f(x_n)) and the legend reads x₍n₎ with the right index and value. Nothing is clamped, the axes 0.7–1.8 × −0.05–1.0 contain every iterate, and there are 13 frames.

### accnewtonbb.jl (accelerated, m=2)
- **Method:** `xs[i] - m*f/fp` with m=2 is the accelerated N-R of Mathews' theorem (gr_131 `x - 2 f/f'`).
- **Numbers:** script 1.0060606060606054, 1.0000061033293672, 1.0000000000036071. Independent values 1.00606060606061, 1.00000610332937, 1+6.21e-12. e_{n+1}/e_n² → 0.16667, so the convergence is quadratic. From x3 on, the Float64 iterate stagnates because f(x3) rounds to 0. This is harmless (see the observations under Findings).
- **Reference values:** root 1 and m=2 are correct.
- **Picture:** the orange segment runs from (x_n, f(x_n)) to (x_{n+1}, 0). Its slope is f'(x_n)/2 (0.66 at x0), as the page says, and the vertical drop and marker are correct. There are 6 frames, and the legend values match the script values.

### accnewtoncc.jl (modified, Method B)
- **Method:** `x - f*fp/(fp^2 - f*fpp)` with f''=6x. sympy confirms this is identical to Newton applied to h=f/f' and to Mathews' gr_244/246 form.
- **Numbers:** script 0.9941520467836247, 0.9999942779650373, 1.0000000000083733. Independent values 0.994152046783626, 0.999994277965015, 1−5.46e-12. e_{n+1}/e_n² → −0.16667, so the convergence is quadratic. The sign of the x3 error differs from the exact value because of Float64 rounding, which is invisible at the six digits shown.
- **Reference values:** `h_plot = (x−1)(x+2)/(3(x+1))` equals f/f' (sympy factor), away from the removable point x=1 and the pole x=−1. The pole is outside the axes [0.5, 2.0].
- **Picture:** the dashed segment runs from (x_n, h(x_n)) to (x_{n+1}, 0), with slope 0.4710744 = h'(1.2). It is the tangent to the plotted h, and it deviates from h by at most 0.0029 on [x1, x0]. The marker is at (x_n, h(x_n)), and there are 5 frames whose legends match the script.

### Fidelity to Mathews
Cases 1–3 use exactly the function, root and starting value of Examples 1(b), 2 and 4 (f = x³−3x+2, p=1, p0=1.2). The page names the omitted examples 1(a), 3, 5 and 6 and describes them correctly. I checked their functions and multiplicities independently (quintic (x−1)²(x−2)³; septic −(x−2)(x−1)⁶). Case 3 plots h where Mathews plots f, which is a stated and valid presentation choice. No fidelity findings.

