# Accelerated & Modified Newton-Raphson — animation review (round 3)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.** Every checkable claim on the page agrees with the computations I ran independently and with the frames. The implementations are the methods they are named as, and the reference values are correct.

The following points came up during checking. None of them is a finding:

- **Float64 stagnation.** In Float64, `f(x)=x^3-3x+2` evaluates to exactly `0.0` at x₃ in Case 2 (x₃ = 1+3.6e-12) and in Case 3 (x₃ = 1+8.4e-12). From that point the iteration stalls, so the Case 2 frames for x₄ and x₅ and the Case 3 frame for x₄ repeat x₃. The exact values are x₃ = 1+6.2e-12 in Case 2 and 1−5.5e-12 in Case 3, and x₄ is about 1e-23 from the root. All of them display as `1.0` at six decimals, which matches the page. The page makes no claim about x₄ or x₅, so nothing it says is affected.
- **Dropped examples.** The page does not animate Mathews' Examples 1(a), 3, 5 and 6, but it says so explicitly and describes each one correctly, so the omission is not silent.
- **Iteration count in Case 1.** Case 1 shows 12 iterations where Mathews' table shows 24. The behaviour is the same and the page states 12 consistently.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 5.4 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 7.9 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard NR converges quadratically at simple roots but degrades to linear at multiple roots, because f'(x*)=0 there | Case 1 error ratios computed below tend to 0.5 | confirmed |
| D2 | Description | Method A: x_{n+1} = x_n − m f/f'; recovers the quadratic rate; requires m | accnewtonbb.jl line 29 uses this formula; e_{n+1}/e_n² → 0.1667 (constant) | confirmed |
| D3 | Description | If f has a root of multiplicity m, h=f/f' has a simple root there | f=(x−p)^m q ⇒ h=(x−p)q/(mq+(x−p)q'), simple root; for this f, h=(x−1)(x+2)/(3(x+1)) with h'(1)=0.5≠0 (mpmath) | confirmed |
| D4 | Description | Newton on h gives x − f f'/(f'² − f f'') | Algebra: h' = (f'²−ff'')/f'², so h/h' = ff'/(f'²−ff''). Numerically, x0 − h(x0)/h'(x0) (mpmath numerical h') = 0.99415204678362573099… = the formula's x1 to 40 digits. Matches Mathews gr_228 after simplification. | confirmed |
| D5 | Description | Method B converges quadratically without knowing m | Case 3 e_{n+1}/e_n² → −0.1667 | confirmed |
| A1 | Animations intro | Three methods applied to the same double root | All three scripts use f=x³−3x+2, x0=1.2; double root at 1 (sympy factor: (x−1)²(x+2)) | confirmed |
| A2 | Animations intro | In Cases 1 and 3 the line is the tangent to the plotted curve; in Case 2 it has half the tangent slope | Case 1 line from (xn,f(xn)) to (xn−f/f',0) has slope f'(xn). Case 3 line on h ends at xn−h/h' (D4), so it is tangent to h. Case 2 slope is f'/2 (A8). | confirmed |
| A3 | Animations intro | Cases 1, 2 plot f; Case 3 plots h | Scripts: lines 40, 42 and 56; frame titles and legends | confirmed |
| C1-1 | Case 1 heading | Standard NR, linear convergence, f=x³−3x+2, x0=1.2 | accnewtonaa.jl lines 11, 15 and 27 | confirmed |
| C1-2 | Case 1 | f=(x−1)²(x+2), double root at x*=1 | sympy factor | confirmed |
| C1-3 | Case 1 | Asymptotic error constant (m−1)/m = 1/2; each step only halves the error | mpmath ratios e_{n+1}/e_n: 0.515152, 0.508165, 0.504252, …, 0.500009 at n=12 | confirmed |
| C1-4 | Case 1 | Near the root f ≈ 3(x−1)² | (x+2)→3 at x=1 | confirmed |
| C1-5 | Case 1 | Tangent meets the axis between x_n and x*, about halfway (x_{n+1}−1 ≈ (x_n−1)/2) | All iterates >1 and decreasing; ratios ≈0.5 | confirmed |
| C1-6 | Case 1 | Each step covers just under half the remaining distance | Fraction covered = 1−ratio = 0.4848, 0.4918, 0.4957, … (<0.5) | confirmed |
| C1-7 | Case 1 | Iterates 1.2, 1.10303, 1.052356, 1.026401 | mpmath: 1.2, 1.10303030303, 1.0523564172, 1.02640081406; legends in frames 1–4 read the same | confirmed |
| C1-8 | Case 1 | After 12 steps x12 = 1.000052, about 5.2×10⁻⁵ from the root | mpmath x12 = 1.00005201565, e = 5.20156e-5; frame 13 legend `x₍12₎ = 1.000052` | confirmed |
| C1-9 | Case 1 | From x5 on the iterate is less than 0.007 from the root | x5−1 = 0.0066434 (x4−1 = 0.013258) | confirmed |
| C1-10 | Case 1 | From x5 on its marker covers the root; the remaining halvings show only in the legend | Pixel measurement: gridlines at x=1.00 → col 220 and 1.25 → col 347 (508 px per unit). Red marker fill spans cols 223–231 for x4 (does not cover 220) and 219–227 for x5 (covers it). | confirmed |
| C1-11 | Case 1 alt text | Slow linear convergence from x₀=1.2 over 12 iterations; from x₅ on the marker covers the root | n_iters=12, 13 frames; C1-10 | confirmed |
| C2-1 | Case 2 heading | Method A, m=2, quadratic, same f and x0=1.2 | accnewtonbb.jl lines 12, 16, 18 and 29 | confirmed |
| C2-2 | Case 2 | Enlarges each Newton step by m | Line 29 | confirmed |
| C2-3 | Case 2 | Orange line from (x_n,f(x_n)) is not the tangent; slope f'(x_n)/2; meets the axis twice as far as Newton | Line 49 draws (xn,f(xn))→(xn−2f/f',0); slope = f/(2f/f') = f'/2 | confirmed |
| C2-4 | Case 2 | Restores quadratic convergence \|e_{n+1}\| ≈ C\|e_n\|² | mpmath e_{n+1}/e_n² = 0.1515, 0.1662, 0.16667, 0.16667 (Mathews gr_157 gives the same) | confirmed |
| C2-5 | Case 2 | x1 = 1.006061, x2 = 1.000006, x3 equals 1 to six decimals | mpmath 1.00606060606, 1.00000610333, 1+6.2e-12. Float64 legends: 1.006061, 1.000006, 1.0 | confirmed |
| C2-6 | Case 2 | Requires knowing m | Script hardcodes m=2 | confirmed |
| C2-7 | Case 2 alt text | Orange lines with half the tangent slope, steps twice the Newton step; quadratic; x₃ equal to 1 to six decimals | Frames 2–6 show orange lines; C2-3 and C2-5 | confirmed |
| C3-1 | Case 3 heading | Method B, quadratic, same f, x0=1.2 | accnewtoncc.jl lines 14–16, 22–28 and 31 | confirmed |
| C3-2 | Case 3 | h has a simple root at a double root of f, so Newton on h is quadratic | D3 and D5 | confirmed |
| C3-3 | Case 3 | Iteration formula x − ff'/(f'²−ff''), implements Newton on h using f, f', f'' | Line 27; D4 | confirmed |
| C3-4 | Case 3 | Animation plots h(x) = (x−1)(x+2)/(3(x+1)) | Line 19. mpmath f/f' − h = 0 at x=0.3 and x=1.7. The pole at −1 is outside xlims (0.5, 2). | confirmed |
| C3-5 | Case 3 | Tangent lines dashed | Line 64: black `ls=:dash`. Frame 2 shows a dashed segment along the curve. | confirmed |
| C3-6 | Case 3 | h nearly straight between root and x0; first tangent lies almost on the curve | h'(1)=0.5, h'(1.2)=0.4711; frame 2 shows the dashed line hugging the curve | confirmed |
| C3-7 | Case 3 | One step to x1 = 0.994152, just left of the root | mpmath 0.994152046784; Float64 legend 0.994152 | confirmed |
| C3-8 | Case 3 | At this scale the overshoot and later steps are too small to see | \|x1−1\| = 0.0058 over a 1.5-wide axis (about 2 px); frames 2–5 visually identical apart from the legend | confirmed |
| C3-9 | Case 3 | x2 = 0.999994; x3 equals 1 to six decimals | mpmath 0.999994277965, 1−5.5e-12 (Mathews gr_273 gives the same); legends 0.999994, 1.0 | confirmed |
| C3-10 | Case 3 | Does not require knowing m | No m in the script | confirmed |
| C3-11 | Case 3 alt text | Dashed tangent from x₀ lies almost on the curve, one step to x₁=0.994152 just left of x=1; x₃ equal to 1 to six decimals | C3-5 to C3-9 | confirmed |
| W1 | Wiring | Case 1 → accnewtonaa.jl/.gif; Case 2 → accnewtonbb; Case 3 → accnewtoncc | index.qmd lines 34/36, 42/44 and 52/54; script contents match the headings; committed GIFs are byte-identical to the regenerated ones (manifest) | confirmed |
| F1 | Closing paragraph | The three cases reproduce Mathews Examples 1(b), 2 and 4 | Archive gr_31/34/35 (Ex 1b: f=x³−3x+2, p=1, p0=1.2), gr_118–120 (Ex 2) and gr_233–235 (Ex 4) | confirmed |
| F2 | Closing paragraph | Ex 1(a) is standard NR at the simple root of the cubic | gr_32/33: p=−2, p0=−2.4 | confirmed |
| F3 | Closing paragraph | Ex 3 (accelerated) and Ex 5 (modified) are at a double and a triple root of a fifth-degree polynomial | gr_160/276: x⁵−8x⁴+25x³−38x²+28x−8 = (x−1)²(x−2)³ (sympy). The archive text calls it a "cubic"; the page is right. | confirmed |
| F4 | Closing paragraph | Ex 6: standard, accelerated and modified methods at a root of higher multiplicity | gr_334: −(x−2)(x−1)⁶ (sympy), root p=1 of multiplicity 6 | confirmed |

### 3. Implementation checks

### accnewtonaa.jl (standard Newton, Case 1)
- **Method:** line 27 is plain Newton, `x − f/f'`, with `fp = 3x²−3` as the correct derivative.
- **Numbers:** Float64 (`inst.jl`) against mpmath at 40 digits (`indep.py`). The two agree to at least 1e-14 for every iterate:

| n | script (Float64) | independent | Mathews gr_106 |
|---|---|---|---|
| 0 | 1.2 | 1.2 | 1.2 |
| 1 | 1.1030303030303028 | 1.10303030303 | 1.10303030303030 |
| 2 | 1.052356417197916 | 1.0523564172 | 1.05235641719792 |
| 4 | 1.0132577338719062 | 1.01325773387 | 1.01325773387191 |
| 5 | 1.0066434177726777 | 1.00664341777 | 1.00664341777268 |
| 12 | 1.0000520156500807 | 1.00005201565 | 1.00005201564977 |

  The ratio e_{n+1}/e_n tends to 0.500009, which is linear convergence with constant 1/2 as the property requires.
- **Reference values:** the root x*=1 and its double multiplicity are confirmed by sympy factorization.
- **Picture:** each segment runs from (xn, f(xn)) to (xn+1, 0), which is the tangent because xn+1 is the Newton step, and a vertical line drops back to the curve. The marker sits at (x_frame, f(x_frame)) and the legend index equals the frame index, so frame k shows x_k. The title's function matches the code. Axis limits contain everything the page discusses. There is no clamping or masking. I checked frames 1, 5, 6 and 13 and the contact sheet.

### accnewtonbb.jl (accelerated Newton, m=2, Case 2)
- **Method:** line 29 is `x − m f/f'` with m=2, the accelerated Newton-Raphson of Mathews gr_114.
- **Numbers:** script against independent computation: x1 = 1.0060606060606054 vs 1.00606060606; x2 = 1.0000061033293672 vs 1.00000610333; x3 = 1+3.6e-12 vs 1+6.2e-12. The difference at x3 is Float64 cancellation in f near the double root. It is invisible at the six displayed decimals. At x3, f evaluates to 0.0 in Float64, so x4 and x5 repeat x3, where the exact values are about 1e-23 from the root. They display as 1.0, which is right to the stated precision. The quadratic property holds: e_{n+1}/e_n² = 0.1515, 0.1662, 0.16667, which matches Mathews gr_157.
- **Reference:** x*=1, as above.
- **Picture:** the orange segment from (xn,f(xn)) to (xn+1,0) has slope f'(xn)/2, as the page states. The vertical drop lines are correct, and the legend and marker indices match. I checked all 6 frames on the contact sheet.

### accnewtoncc.jl (modified Newton, Method B, Case 3)
- **Method:** lines 22–28 implement x − ff'/(f'²−ff'') with `fpp = 6x`, which is correct. This is Newton applied to h=f/f' (D4) and equals Mathews' gr_228 after simplification.
- **Numbers:** script against independent computation: x1 = 0.9941520467836247 vs 0.994152046784; x2 = 0.9999942779650373 vs 0.999994277965; x3 = 1+8.4e-12 vs 1−5.5e-12 (Float64 cancellation, invisible at six decimals). x4 stalls for the same reason as in Case 2. The quadratic property holds: e_{n+1}/e_n² = −0.146, −0.1673, −0.16667, which matches Mathews gr_273.
- **Reference:** the plotted `h_plot` equals f/f' away from x=±1 (mpmath difference 0 at two test points) and takes the removable-singularity value 0 at x=1. The pole at x=−1 is outside the plot window.
- **Picture:** the curve is h, and the dashed black segment from (xn,h(xn)) to (xn+1,0) is the tangent to h because xn+1 = xn − h/h' (checked to 40 digits for n=0). The steelblue vertical drops are present but sub-pixel after the first step, which the page acknowledges. The marker is plotted on h at x_frame, and the legend index matches. I checked frame 2 at full size and all 5 frames on the contact sheet.

### Regeneration
All three scratch copies ran cleanly and reproduce the committed GIFs byte for byte (manifest).

