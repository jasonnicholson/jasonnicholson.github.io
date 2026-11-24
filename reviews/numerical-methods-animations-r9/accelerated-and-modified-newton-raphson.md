# Accelerated & Modified Newton-Raphson — animation review (round 9)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. Every checkable claim on the page agrees with my own computation and with the frames. The evidence is below.

Observation only, not a finding: in Float64, f(x) evaluates to exactly 0 once |x − 1| ≈ 4e-12, because x³ − 3x + 2 cancels catastrophically there. So the Case 2 iteration stalls at x₃ = 1 + 3.6e-12 (exact x₃ = 1 + 6.2e-12), and the Case 3 iteration stalls at x₃ = 1 + 8.4e-12 (exact x₃ = 1 − 5.5e-12). As a result, frames 5–6 of `accnewtonbb.gif` and frame 5 of `accnewtoncc.gif` repeat the previous frame. Their legends ("x₄ = 1.0", "x₅ = 1.0") are still correct to the six decimals displayed, and the page makes no claim about those frames, so a viewer is not misled.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 13.0 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 13.3 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 10.7 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard NR is quadratic at simple roots, linear at multiple roots because f'(x*) = 0 | Case 1 ratios e_{n+1}/e_n → 0.500009 (linear); theory | confirmed |
| D2 | Description | Method A: x_{n+1} = x_n − m f/f' | `accnewtonbb.jl:29` is exactly this, with m = 2 | confirmed |
| D3 | Description | h = f/f' has a simple root at a root of f of multiplicity m | sympy: h = (x−1)(x+2)/(3(x+1)); h'(1) = 1/3 ≠ 0 | confirmed |
| D4 | Description | Newton on h equals x − f f'/(f'² − f f'') | sympy: (x − h/h') − formula simplifies to 0 | confirmed |
| D5 | Description | Methods A and B converge quadratically | e_{n+1}/e_n² → 0.166667 (A) and −0.166667 (B), constant | confirmed |
| A1 | Intro | Three animations, one method each, all at the same double root | three scripts, all f = x³−3x+2, x₀ = 1.2, root 1 | confirmed |
| A2 | Intro | Line from the curve at x_n to the axis intercept gives x_{n+1} | aa:47, bb:49, cc:64 all draw (x_n, y(x_n)) → (x_{n+1}, 0) | confirmed |
| A3 | Intro | Cases 1 and 3: the line is the tangent to the plotted curve | Case 1 slope = f/(f/f') = f'; Case 3 at x₀: line slope 0.4710744 = h'(1.2) 0.4710744 | confirmed |
| A4 | Intro | Case 2 line has half the tangent slope | slope at x₀: 0.66 vs f'(1.2)/2 = 0.66 | confirmed |
| A5 | Intro | Cases 1 and 2 plot f; Case 3 plots h | aa:40, bb:42 plot f; cc:56 plots h_plot | confirmed |
| A6 | Intro | The cases reproduce Mathews Examples 1(b), 2 and 4 at the double root of the same cubic | archive: 1(b), 2 and 4 all use f = x³−3x+2, p = 1, p₀ = 1.2 | confirmed |
| A7 | Intro | Ex 1(a) is standard NR at the simple root of that cubic | archive: p = −2, p₀ = −2.4 | confirmed |
| A8 | Intro | Ex 3 and Ex 5 are at a double and a triple root of a fifth-degree polynomial | archive f = x⁵−8x⁴+25x³−38x²+28x−8 = (x−1)²(x−2)³ (sympy). Mathews' own text calls it "cubic"; the page is right | confirmed |
| A9 | Intro | Ex 6 uses the standard, accelerated and modified methods at a root of higher multiplicity | archive f = −(x−2)(x−1)⁶; 6(a), (b), (c) are those three methods | confirmed |
| 1a | Case 1 heading | Standard NR, linear, f = x³−3x+2, x₀ = 1.2 | aa:11, 15, 27 | confirmed |
| 1b | Case 1 | f = (x−1)²(x+2), double root at 1 | sympy factor | confirmed |
| 1c | Case 1 | Asymptotic error constant (m−1)/m = 1/2 | computed ratios 0.515, 0.508, …, 0.500009 | confirmed |
| 1d | Case 1 | Near the root f ≈ 3(x−1)², tangent meets the axis between x_n and x* | f''(1)/2 = 3; all x_{n+1} lie in (1, x_n) | confirmed |
| 1e | Case 1 | Sequence 1.2, 1.10303, 1.052356, 1.026401 | mpmath 1.1030303, 1.0523564, 1.0264008; script identical | confirmed |
| 1f | Case 1 | "just under half the remaining distance" per step | fractions covered 0.485, 0.492, 0.496 | confirmed |
| 1g | Case 1 | After 12 steps x₁₂ = 1.000052, about 5.2e-5 from the root | x₁₂ = 1.0000520156; e = 5.20e-5; Mathews table p₁₂ = 1.0000520156 | confirmed |
| 1h | Case 1 | From x₅ on, the iterate is < 0.007 from the root and its marker covers the root | e₅ = 0.006643 (e₄ = 0.0133); frame_006 shows the marker over x = 1 | confirmed |
| 1i | Case 1 | Remaining halvings show only in the legend value | frames 7–13 differ visually only in the legend | confirmed |
| 1j | Case 1 alt | Slow linear convergence over 12 iterations | n_iters = 12, 13 frames | confirmed |
| 2a | Case 2 heading | Method A, m = 2, f, x₀ = 1.2 | bb:16–18 | confirmed |
| 2b | Case 2 | Orange line from (x_n, f(x_n)), slope f'(x_n)/2, meets the axis twice as far as Newton | bb:49 `:darkorange`; slope 0.66 = f'(1.2)/2; step 0.19394 = 2 × Newton step 0.09697 | confirmed |
| 2c | Case 2 | \|e_{n+1}\| ≈ C\|e_n\|² | e_{n+1}/e_n² = 0.1515, 0.1662, 0.16667 | confirmed |
| 2d | Case 2 | x₁ = 1.006061, x₂ = 1.000006, x₃ = 1 to six decimals | mpmath 1.0060606, 1.0000061, 1 + 6.2e-12; script 1.0060606, 1.0000061, 1 + 3.6e-12; legend frames 2–4 match | confirmed |
| 2e | Case 2 alt | x₃ equals 1 to six decimals | as 2d | confirmed |
| 3a | Case 3 heading | Method B, f, x₀ = 1.2 | cc:14–16, 22–28, 31 | confirmed |
| 3b | Case 3 | The formula implements Newton on h using f, f', f'' | sympy (D4); mpmath Newton-on-h iterates equal the script's to all printed digits | confirmed |
| 3c | Case 3 | Plots h = (x−1)(x+2)/(3(x+1)) with dashed tangents | sympy: equals f/f'; cc:64 `ls=:dash` | confirmed |
| 3d | Case 3 | h nearly straight; first tangent lies almost on the curve | max \|tangent − h\| on [x₁, x₀] = 0.0029 (y-range 1.0); frame_002 | confirmed |
| 3e | Case 3 | x₁ = 0.994152, just left of the root | 0.99415205 (mpmath and script); Mathews p₁ = 0.994152046783626 | confirmed |
| 3f | Case 3 | Overshoot and later steps too small to see; read from the legend | frames 2–5: the marker sits on x = 1 | confirmed |
| 3g | Case 3 | x₂ = 0.999994; x₃ = 1 to six decimals | 0.99999428; 1 − 5.5e-12 (script 1 + 8.4e-12); legend matches | confirmed |
| 3h | Case 3 alt | Dashed tangent from x₀ = 1.2 to x₁ = 0.994152, just left of 1; quadratic; no m needed | as above | confirmed |
| W1 | Wiring | Case 1 → accnewtonaa.jl/.gif, Case 2 → accnewtonbb, Case 3 → accnewtoncc | index.qmd:37–57; script contents match their headings | confirmed |
| F1 | Fidelity | Example functions, roots and starting values match Mathews | as A6–A9 | confirmed |

### 3. Implementation checks

### `accnewtonaa.jl` (standard Newton)
- **Method:** x − f/f' with f' = 3x² − 3 (line 27). This is plain Newton.
- **Numbers:** the script's Float64 iterates agree with 50-digit mpmath to every printed digit: x₁…x₁₂ = 1.1030303, 1.0523564, 1.0264008, 1.0132577, 1.0066434, 1.0033254, 1.0016636, 1.0008320, 1.0004161, 1.0002081, 1.0001040, 1.0000520. They also match Mathews' table (gr_106). The ratio e_{n+1}/e_n → 0.500009, which confirms linear convergence with constant 1/2.
- **Reference:** the root x = 1 is double. f(1) = 0, f'(1) = 0, and the factorisation is (x−1)²(x+2).
- **Picture:** each line runs from (x_n, f(x_n)) to (x_{n+1}, 0), so its slope is f'(x_n): the true tangent. Vertical drop lines are at x_{n+1}. The legend indices follow the frame (frame k shows x_k). Axes [0.7, 1.8] × [−0.05, 1] contain x₀ and the root. No clamping.

### `accnewtonbb.jl` (accelerated, m = 2)
- **Method:** x − 2f/f' (line 29). This is Method A as described.
- **Numbers:** script 1.2, 1.0060606, 1.0000061, 1 + 3.6e-12, then stalled. mpmath 1.2, 1.0060606, 1.0000061, 1 + 6.2e-12, 1 + 6.4e-24. Mathews' table (gr_157) gives the same values to x₃ = 1.00000000000621. e_{n+1}/e_n² → 1/6, which confirms quadratic convergence. The script's x₃ differs from the exact value only at 1e-12 (roundoff in f), invisible in the 6-decimal legend.
- **Reference:** the root is 1, as above.
- **Picture:** the orange segment's slope equals f'(x_n)/2, as stated. Frames 5–6 repeat frame 4 because of the Float64 stall (see Observation). Their legends are still correct to six decimals.

### `accnewtoncc.jl` (modified, Method B)
- **Method:** x − f f'/(f'² − f f'') with f'' = 6x (lines 22–28). sympy shows this is identical to Newton on h = f/f'. This is Method B as described.
- **Numbers:** script 1.2, 0.99415205, 0.99999428, 1 + 8.4e-12, then stalled. mpmath, computing Newton on h with numerical derivatives: 1.2, 0.99415205, 0.99999428, 1 − 5.46e-12, 1 − 5.0e-24. Mathews' table (gr_273) agrees to x₃ = 0.999999999994543. e_{n+1}/e_n² → −1/6 (quadratic). The script's x₃ has the wrong sign of error at the 1e-12 level because of Float64 cancellation in f. This is invisible at the displayed precision, and the page does not state the side for x₃.
- **Reference:** `h_plot` = (x−1)(x+2)/(3(x+1)) equals f/f' exactly (sympy) and is regular at x = 1. Its pole at x = −1 lies outside the window [0.5, 2].
- **Picture:** each dashed line runs from (x_n, h(x_n)) to (x_{n+1}, 0). At x₀ its slope is 0.4710744 = h'(1.2), so it is the tangent to the plotted h. The line lies within 0.003 of the curve, as the page says. Frame 5 repeats frame 4 (Float64 stall). Its legend reads 1.0, which is correct.

