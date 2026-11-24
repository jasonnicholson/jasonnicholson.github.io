# Accelerated & Modified Newton-Raphson — animation review (round 8)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the scripts agrees with an independent 40-digit computation and with the frames. Sections 2 and 3 give the evidence.

Things I looked at and decided were not findings:
- In Case 1 the y-window runs to 1.0 while f(x0) = 0.128, so the construction fills only the bottom ~13 % of the plot, and after x4 the steps can't be seen. The page says this explicitly ("only the first few steps can be told apart … the remaining halvings show only in the legend value"), so a reader is not misled.
- In Cases 2 and 3 the double-precision iterates stall at about 1 + 4e-12 and 1 + 8e-12 from x3 on. The exact Case 3 x3 is 0.999999999994543, which sits on the other side of 1. Because of the stall, the last one or two frames repeat "x = 1.0". The page claims only "x3 equals 1 to six decimals", which is true, so this is not a finding.
- The legend subscript renders as "x₍12₎". This is cosmetic and readable.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 5.8 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 7.0 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 6.0 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words, abridged) | Evidence | Verdict |
|---|---|---|---|
| D1 | Standard N-R is quadratic at simple roots, linear at multiple roots because f'(x*) = 0 | Case 1 error ratios → 0.5000 (table below) | confirmed |
| D2 | Method A: x_{n+1} = x_n − m f/f'; restores quadratic rate; needs m | bb code line 29; e_{n+1}/e_n² = 0.152, 0.166, 0.1667 → constant 1/6 | confirmed |
| D3 | h = f/f' has a simple root at a root of f of multiplicity m | f = (x−1)²(x+2), h = (x−1)(x+2)/(3(x+1)), h(1)=0, h'(1)=1/2 ≠ 0 | confirmed |
| D4 | Method B formula x − f f'/(f'² − f f'') is Newton on h | h' = (f'² − f f'')/f'², so h/h' = f f'/(f'² − f f''); numerically, mpmath Newton on h gives the same iterates as the formula (0.994152046783626, 0.999994277965015, …) | confirmed |
| D5 | Method B converges quadratically without m | e_{n+1}/e_n² = −0.146, −0.167, −0.1667 | confirmed |
| D6 | Both need f smooth and x0 close enough | standard hypothesis | confirmed |
| I1 | Three animations, one method each, same double root | three scripts, all f = x³−3x+2, x0 = 1.2 | confirmed |
| I2 | Line from curve at x_n to axis intercept gives x_{n+1} | aa:47, bb:49, cc:64 draw (x_n, y_n)→(x_{n+1}, 0) | confirmed |
| I3 | Cases 1 and 3: line is the tangent to the plotted curve | drawn slope / derivative = 1.000000 for every k (aa: vs f'; cc: vs numerical h') | confirmed |
| I4 | Case 2: half the tangent slope | drawn slope / f'(x_n) = 0.500000 for k = 0, 1, 2 | confirmed |
| I5 | Cases 1, 2 plot f; Case 3 plots h | aa:40, bb:42 plot f; cc:56 plots h; legends and frames agree | confirmed |
| I6 | Cases reproduce Mathews Examples 1(b), 2, 4 at the double root of the same cubic | archive: 1(b) p=1, p0=1.2; Ex 2 f=x³−3x+2, p=1, p0=1.2; Ex 4 same, p0=1.2 | confirmed |
| I7 | Ex 1(a) is standard N-R at the simple root of the cubic | archive: p = −2, p0 = −2.4 | confirmed |
| I8 | Ex 3 / Ex 5 are accelerated / modified at a double and a triple root of a fifth-degree polynomial | archive f = x⁵−8x⁴+25x³−38x²+28x−8 = (x−1)²(x−2)³ (expanded by hand) | confirmed |
| I9 | Ex 6 applies all three methods at a root of higher multiplicity | archive f = −x⁷+8x⁶−…+2; sympy factor: −(x−2)(x−1)⁶ → multiplicity 6 | confirmed |
| C1-h | Case 1 heading: standard N-R, linear, f = x³−3x+2, x0 = 1.2 | aa:11, 15, 27 | confirmed |
| C1-a | f = (x−1)²(x+2), double root x* = 1 | sympy/expansion | confirmed |
| C1-b | Asymptotic error constant (m−1)/m = 1/2, each step only halves the error | ratios 0.515, 0.508, 0.504, … 0.500009 | confirmed |
| C1-c | Near root f ≈ 3(x−1)²; tangent meets axis between x_n and x*, about halfway | (x+2)→3 at x=1; iterates decrease monotonically, all > 1 | confirmed |
| C1-d | Each step covers just under half the remaining distance | e_{n+1}/e_n > 0.5 every step, so the fraction covered is < 0.5 | confirmed |
| C1-e | Iterates 1.2, 1.10303, 1.052356, 1.026401 | mpmath 1.1030303, 1.0523564, 1.0264008; script identical | confirmed |
| C1-f | After 12 steps x12 = 1.000052, about 5.2e-5 from root | 1.0000520156 | confirmed |
| C1-g | From x5 on the iterate is < 0.007 from the root, and its marker covers the root | e5 = 0.00664; crops of frames 5 and 6 show the x4 marker still offset and the x5 marker on the root | confirmed |
| C1-alt | 12 iterations; marker covers root from x5 | 13 frames (x0..x12) | confirmed |
| C2-h | Case 2 heading: Method A, m = 2, quadratic, same f, x0 = 1.2 | bb:16-18 | confirmed |
| C2-a | Orange line from (x_n, f(x_n)), not the tangent, slope f'/2, meets axis twice as far as Newton | color :darkorange; slope ratio 0.5 | confirmed |
| C2-b | Quadratic: abs(e_{n+1}) ≈ C·e_n² | C → 1/6 | confirmed |
| C2-c | x1 = 1.006061, x2 = 1.000006, x3 equals 1 to six decimals | mpmath 1.00606060606, 1.00000610333, 1+6.2e-12; script 1.0060606060606054, 1.0000061033293672, 1+3.6e-12; legend in frames shows 1.006061, 1.000006, 1.0 | confirmed |
| C2-alt | Half-slope orange lines, steps twice Newton, x3 = 1 to six decimals | as above | confirmed |
| C3-h | Case 3 heading: Method B, quadratic, same f, x0 = 1.2 | cc:14-16, 31 | confirmed |
| C3-a | Formula implements Newton on h using f, f', f'' | cc:22-28, D4 | confirmed |
| C3-b | Plot h = (x−1)(x+2)/(3(x+1)), tangents dashed | cc:19 (equal to f/f' for x ≠ ±1; checked h_plot = f/fp at the iterates); cc:64 ls=:dash | confirmed |
| C3-c | h nearly straight; first tangent lies almost on the curve | max gap between tangent and h on [x1, x0] = 0.0029 (y-range 1.0 over ~540 px, about 1.6 px) | confirmed |
| C3-d | x1 = 0.994152, just left of the root | 0.994152046783626 | confirmed |
| C3-e | Overshoot and later steps too small to see at this scale | 0.0058 in a 1.5-wide window ≈ 2 px; frame 2 crop | confirmed |
| C3-f | x2 = 0.999994; x3 equals 1 to six decimals | 0.999994277965; x3 = 1 − 5.5e-12 (exact), 1 + 8.4e-12 (script float) | confirmed |
| C3-alt | Dashed tangent from x0 lies almost on curve, x1 = 0.994152, x3 = 1 to six decimals | as above | confirmed |
| W1 | Case 1 link/embed = accnewtonaa.jl/.gif (standard Newton) | qmd lines 37, 39; script line 27 | confirmed |
| W2 | Case 2 link/embed = accnewtonbb.jl/.gif (accelerated) | qmd 45, 47; bb:29 | confirmed |
| W3 | Case 3 link/embed = accnewtoncc.jl/.gif (modified) | qmd 55, 57; cc:43 | confirmed |
| S1 | cc header comment: x2 = 0.999994, x3 equals 1 to six decimals | as C3-f | confirmed |

### 3. Implementation checks

Independent reference: mpmath at 40 digits, iterating each formula from x0 = 1.2, plus Newton on h with numerically differentiated h. Script values come from instrumented copies that print `xs` and the drawn slopes.

### accnewtonaa.jl (standard Newton)
- **Method:** x − f/f' (line 27). Plain Newton-Raphson, as labelled.
- **Numbers:**

| n | script | mpmath | e_n/e_{n−1} |
|---|---|---|---|
| 1 | 1.1030303030303028 | 1.1030303030303 | 0.515 |
| 2 | 1.052356417197916 | 1.05235641719792 | 0.508 |
| 3 | 1.0264008140553686 | 1.02640081405537 | 0.504 |
| 5 | 1.0066434177726777 | 1.00664341777268 | 0.501 |
| 12 | 1.0000520156500807 | 1.00005201564977 | 0.500009 |

The ratio tends to (m−1)/m = 1/2, which is linear convergence as expected for a double root.
- **Reference values:** the root x* = 1 is exact, since f = (x−1)²(x+2).
- **Picture:** each segment runs from (x_n, f(x_n)) to (x_{n+1}, 0), and its slope equals f'(x_n) to 1e-12 relative, so it is the tangent. The vertical drop goes to f(x_{n+1}). Legend values in frames 1, 3, 5, 7, 9, 11 and 13 (x0, x2, …, x12) match the table. The title function matches the code. 13 frames.

### accnewtonbb.jl (accelerated, m = 2)
- **Method:** x − m f/f' with m = 2 (line 29), which is Mathews' accelerated Newton-Raphson.
- **Numbers:** script 1.0060606060606054, 1.0000061033293672, 1.0000000000036071 (then a floating-point stall). mpmath 1.00606060606061, 1.00000610332937, 1.00000000000621. They agree to well beyond the displayed six decimals. e_{n+1}/e_n² = 0.1515, 0.1662, 0.1667, so the rate is quadratic.
- **Reference:** x* = 1, exact.
- **Picture:** the orange segment slope divided by f'(x_n) is 0.5000000 for k = 0, 1, 2, which matches the page's "half the tangent slope". The legend values are 1.2, 1.006061, 1.000006, 1.0, 1.0, 1.0. Six frames. Frames 4 to 6 add no visible step because of the float stall, and the page claims nothing about them.

### accnewtoncc.jl (modified, Method B)
- **Method:** x − f f'/(f'² − f f'') (lines 22 to 28), which is Mathews' modified Newton-Raphson. It is the same as Newton on h = f/f': the mpmath Newton-on-h iterates equal the formula's iterates to 15 digits.
- **Numbers:** script 0.9941520467836247, 0.9999942779650373, 1.0000000000083733. mpmath 0.994152046783626, 0.999994277965015, 0.999999999994543. They agree to the displayed precision, and the x3 difference is at the 1e-11 rounding floor. e_{n+1}/e_n² = −0.146, −0.167, −0.1667, so the rate is quadratic.
- **Reference:** x* = 1. The plotted h_plot = (x−1)(x+2)/(3(x+1)) agrees with f/f' at every iterate (for example 0.0969697 against 0.0969697 at x0). Its only pole is at x = −1, outside the window [0.5, 2].
- **Picture:** the dashed segment from (x_n, h(x_n)) to (x_{n+1}, 0) has a slope / h'(x_n) of 1.0000000, 1.0000000 and 0.999998 (the last at the float floor), so it is the tangent to the plotted h. The legend values are 1.2, 0.994152, 0.999994, 1.0, 1.0. Five frames.

### Legacy fidelity
Examples 1(b), 2 and 4 in the archive all use f = x³ − 3x + 2, p = 1 and p0 = 1.2. The three cases match them. The examples that are not animated (1(a), 3, 5, 6) are named on the page and described correctly. Mathews graphs f for Example 4, whereas Case 3 graphs h. The page states and explains this choice, so it is not a fidelity issue.

