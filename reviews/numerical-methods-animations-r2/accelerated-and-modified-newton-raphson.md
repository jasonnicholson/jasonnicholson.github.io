# Accelerated & Modified Newton-Raphson — animation review (round 2)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 3 Minor**.

## Findings

### F1 — Page match / picture, Minor: Case 1 shows its "slow linear convergence" only in the legend; frames 6–13 are visually unchanged
- **Location:** `accnewtonaa.jl` lines 18–19 (`xlims = (0.7, 1.8)`, `ylims = (-0.05, 1.0)`), together with page Case 1 text: "Each step covers just under half the remaining distance (1.2, 1.10303, 1.052356, 1.026401, …), so after 12 steps $x_{12} = 1.000052$ …" and alt text "slow linear convergence from x₀=1.2 toward the double root at x=1 over 12 iterations".
- **Now:** The window is 1.1 wide in x and 1.05 tall in y over a plot area of about 561 × 508 px, so 1 px ≈ 0.00196 in x and 0.0021 in y. The iterate's distance from the root on screen is 102, 53, 27, 13.5, 6.8, 3.4, 1.7, 0.85, … px for k = 0, 1, 2, …. The marker (ms=6) covers the root from about k = 5 on. f(x_k) drops below 1 px from k = 3 on, so every tangent segment after the third lies on the x-axis. In the contact sheet, frames x₆, x₈, x₁₀ and x₁₂ look the same apart from the legend number.
- **True instead:** The halving the page describes runs through all 12 steps (error ratio 0.515, 0.508, 0.504, …, 0.500009), but only the first four or five steps can be seen. After that a viewer sees the dot sitting on the root for 8 frames. The only sign that convergence is "still about 5.2×10⁻⁵ from the root" is the legend value.
- **How I know:** `python3 -I vis.py` printed `case1 k=… err_px=…` (102.00, 52.55, 26.70, 13.46, 6.76, 3.39, 1.70, 0.85, 0.42, 0.21, 0.11, 0.05, 0.03) and `f_px` (61.93, 15.94, 4.05, 1.02, 0.26, …). I also viewed `committed/accnewtonaa/sheet.png` and frames 002 and 013.
- **Suggested correction:** Make the convergence visible. One way is a second panel or inset showing |x_n − 1| on a log scale against n, where the constant-slope line is the linear rate. Another is to zoom the window as the iterates shrink. At the least, add a sentence saying the later steps are below plot resolution and are read from the legend.

- **Independent check:** not run (Minor finding, unverified)

### F2 — Page match / picture, Minor: Case 3's "tangent lines" cannot be told apart from the curve h(x)
- **Location:** `accnewtoncc.jl` lines 34–35 (window `(0.5, 2.0) × (-0.4, 0.6)`), lines 56 and 63 (green lw=2 curve, steelblue lw=1.5 tangent), and page Case 3: "The animation plots $h(x)=…$ and shows the tangent lines converging to $x = 1$". Alt text: "Modified Newton-Raphson (Method B) tangent-line animation on h(x)…".
- **Now:** h is nearly linear on [0.994, 1.2]. The first tangent, from x₀ = 1.2 to x₁ = 0.994152, is never more than 1.49 px from the curve along its whole length, so it shows only as a slight colour change on the curve. The second and third steps are 2.2 px and 0.002 px long. The overshoot to the left of the root (x₁ = 0.994152 < 1), the one qualitative difference from Cases 1 and 2, is 2 px on screen and cannot be seen.
- **True instead:** The construction is correct: each drawn slope equals h′(x_n) to 9 digits (0.471074380 vs 0.471074380, 0.500978950 vs 0.500978950). But a reader looking for "tangent lines converging" sees a red dot jump from (1.2, 0.098) onto the root in one frame and then stay there for frames 3 to 5.
- **How I know:** `python3 -I vis.py` printed `case3 k=0 … max |line-h| = 0.00293 = 1.49 px`, `k=1 … 0.0015 px; segment length 2.18 px`, `k=2 … segment length 0.002 px`. I also viewed `committed/accnewtoncc/sheet.png` and `frame_002.png`.
- **Suggested correction:** Either draw the tangent so that it stands out (extend it past the axis, use a contrasting dashed style, mark (x_{n+1}, 0) with its own marker) and change the text to say the tangent nearly coincides with h because h is almost linear near its simple root, or add a zoomed inset around x = 1 that shows the overshoot to x₁ = 0.994152.

- **Independent check:** not run (Minor finding, unverified)

### F3 — Fidelity, Minor: archive Examples 1(a), 3, 5 and 6 are left out without comment, including every case with multiplicity other than 2
- **Location:** page Animations section, intro: "Each animation below shows a Newton-style line diagram for three methods applied to the same double root."
- **Now:** The page reproduces archive Example 1(b) as Case 1, Example 2 as Case 2 and Example 4 as Case 3. The function, p₀ = 1.2 and p = 1 match in all three, and so do the iterates: Mathews gives 1.00606, 1.00001 and 0.994152, 0.999994. The archive also has:
  - Example 1(a): Newton at the simple root p = −2 from p₀ = −2.4, showing quadratic convergence.
  - Examples 3 and 5: accelerated and modified Newton on f(x) = x⁵ − 8x⁴ + 25x³ − 38x² + 28x − 8 = (x−1)²(x−2)³, which has a double root at 1 and a triple root at 2.
  - Example 6(a–c): standard, accelerated and modified Newton on f(x) = −x⁷ + 8x⁶ − 27x⁵ + 50x⁴ − 55x³ + 36x² − 13x + 2 = −(x−2)(x−1)⁶, which has a root of order 6 at x = 1.

  The page never mentions them.
- **Why it matters:** The Description says Method A "requires knowing $m$ in advance" and that Method B "converges quadratically, without knowing $m$". Every case on the page has m = 2, so neither claim is ever shown for another multiplicity. The archive's Examples 3, 5 and 6 are the ones that do this. These are static worked examples, not legacy animations, so this is a coverage gap and not a wrong animation.
- **How I know:** I read `NewtonAccelerateMod.html` as text and viewed formula images gr_30–35, 118–120, 158–160, 233–235, 274–276 and 334–337 (montages `archive_formulas.png` and `ex6.png`). The factorizations come from `sympy.factor`: `(x - 2)**3*(x - 1)**2` and `-(x - 2)*(x - 1)**6`.
- **Suggested correction:** Add a case using one of the higher-multiplicity examples, for example Example 3/5's triple root at x = 2 with Method A at m = 3 against Method B. Otherwise, state in the Animations intro that the page shows only the double-root examples (Mathews Examples 1(b), 2 and 4).

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 5.5 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 5.4 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 5.5 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Where | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard NR converges quadratically at simple roots but degrades to linear at multiple roots, because f′(x*) = 0 there | Standard theory; Case 1 ratio → 0.500009 (indep.py) | confirmed |
| D2 | Description | Method A: $x_{n+1} = x_n - m f/f'$ | Matches `accnewtonbb.jl` l.29 and Mathews' Theorem/g[x] (ex2.png gr_131) | confirmed |
| D3 | Description | Method A recovers the quadratic rate and requires m | Case 2: \|e₂\|/e₁² = 0.16616, \|e₃\|/e₂² = 0.16667 → 1/6 | confirmed |
| D4 | Description | If f has a root of multiplicity m, h = f/f′ has a simple root | h = (x−1)(x+2)/(3(x+1)), h(1) = 0, h′(1) = 1/2 ≠ 0 (sympy, vis.py) | confirmed |
| D5 | Description | Newton on h gives $x - ff'/(f'^2 - ff'')$ | sympy: `simplify(newton_h - mb) == 0` → True | confirmed |
| D6 | Description | Method B converges quadratically without knowing m | Case 3 ratio \|e_{n+1}\|/e_n² → 0.16667 | confirmed |
| D7 | Description | Both need f smooth and x₀ close enough | Standard local-convergence hypothesis | confirmed |
| I1 | Animations intro | Newton-style line diagram for three methods applied to the same double root | All three scripts use f = x³−3x+2, x₀ = 1.2, root 1 | confirmed |
| I2 | Intro | The line from the curve at x_n to the x-axis intercept traces x_{n+1} | Scripts l.47/49/63 draw (x_n, y_n)→(x_{n+1}, 0) | confirmed |
| I3 | Intro | In Cases 1 and 3 that line is the tangent to the plotted curve | Drawn slope / f′ = 1.000000 (Case 1); drawn slope = h′ to 9 digits (Case 3) | confirmed (but see F2 on visibility) |
| I4 | Intro | In Case 2 it has half the tangent slope | Drawn slope 0.66 vs f′(1.2) = 1.32, ratio 0.5 | confirmed |
| I5 | Intro | Cases 1, 2 plot f; Case 3 plots h | Script l.40, l.42, l.56; frames | confirmed |
| I6 | Intro | Julia source scripts linked under each case | Links present; manifest confirms | confirmed |
| C1a | Case 1 heading | Standard NR, linear convergence, f = x³−3x+2, x₀ = 1.2 | `accnewtonaa.jl` l.11, 15, 27; ratios → 0.5 | confirmed |
| C1b | Case 1 | f = (x−1)²(x+2), double root at 1 | sympy factor | confirmed |
| C1c | Case 1 | Asymptotic error constant (m−1)/m = 1/2; each step only halves the error | Ratios 0.515, 0.508, 0.504, …, 0.500009 | confirmed |
| C1d | Case 1 | Near the root f ≈ 3(x−1)² | sympy series: `3*(x - 1)**2 + O((x-1)**3)` | confirmed |
| C1e | Case 1 | Tangent meets the axis between x_n and x*, about halfway | All x_{n+1} ∈ (1, x_n), ratio ≈ 0.5 | confirmed |
| C1f | Case 1 | Each step covers just under half the remaining distance | Ratio e_{n+1}/e_n > 0.5 at every step, so the step is < half | confirmed |
| C1g | Case 1 | Iterates 1.2, 1.10303, 1.052356, 1.026401 | mpmath: 1.10303030, 1.05235642, 1.02640081; Julia identical | confirmed |
| C1h | Case 1 | x₁₂ = 1.000052, about 5.2×10⁻⁵ from the root | mpmath 1.0000520156; Julia 1.0000520157 | confirmed |
| C1i | Case 1 alt | Slow linear convergence over 12 iterations | n_iters = 12, 13 frames (x₀…x₁₂) | confirmed (visibility: F1) |
| C1j | Case 1 wiring | Link `accnewtonaa.jl`, embed `accnewtonaa.gif` | Standard-Newton script; GIF byte-identical to regen | confirmed |
| C2a | Case 2 heading | Accelerated NR, m = 2, quadratic, same f and x₀ | `accnewtonbb.jl` l.16, 18, 29 | confirmed |
| C2b | Case 2 | Orange line from (x_n, f(x_n)) has slope f′/2 and meets the axis twice as far from x_n as the Newton tangent | `:darkorange`; slope ratio 0.5 | confirmed |
| C2c | Case 2 | $\|e_{n+1}\| \approx C\|e_n\|^2$ | C → 0.16667 | confirmed |
| C2d | Case 2 | x₁ = 1.006061 | mpmath 1.0060606061; Julia same; Mathews 1.00606 | confirmed |
| C2e | Case 2 | x₂ = 1.000006 | mpmath 1.0000061033; Julia same | confirmed |
| C2f | Case 2 | x₃ equals 1 to six decimals | mpmath 1+6.2e−12; Julia 1+3.6e−12 (rounding, f(x₃) evaluates to 0.0) | confirmed |
| C2g | Case 2 alt | Orange lines with half tangent slope; x₃ = 1 to six decimals | Frames 002–006; legend "x₍3₎ = 1.0" | confirmed |
| C2h | Case 2 wiring | `accnewtonbb.jl` / `accnewtonbb.gif` | Correct script; byte-identical | confirmed |
| C3a | Case 3 heading | Modified NR (Method B), quadratic, same f and x₀ | `accnewtoncc.jl` l.22–28, 31 | confirmed |
| C3b | Case 3 | At a double root of f, h has a simple root, so Newton on h is quadratic | h′(1) = 1/2; C → 0.16667 | confirmed |
| C3c | Case 3 | Displayed formula implements Newton on h using f, f′, f″ | sympy identity; script l.26–27 | confirmed |
| C3d | Case 3 | Animation plots h(x) = (x−1)(x+2)/(3(x+1)) | sympy `factor(f/f')` gives the same; script l.19, 56 | confirmed |
| C3e | Case 3 | Shows the tangent lines converging to x = 1 | Lines are tangents (slope = h′) but lie within 1.5 px of the curve | confirmed numerically; visually weak (F2) |
| C3f | Case 3 | x₁ = 0.994152 | mpmath 0.99415204678; Julia same; Mathews 0.994152 | confirmed |
| C3g | Case 3 | x₂ = 0.999994 | mpmath 0.99999427797 | confirmed |
| C3h | Case 3 | x₃ equals 1 to six decimals, as in Case 2 | mpmath 1−5.5e−12; Julia 1+8.4e−12 | confirmed |
| C3i | Case 3 | Does not require knowing m | Script uses no m | confirmed |
| C3j | Case 3 alt | Tangent-line animation on h; x₃ = 1 to six decimals, without knowing m | Frames; legend "x₍3₎ = 1.0" | confirmed |
| C3k | Case 3 wiring | `accnewtoncc.jl` / `accnewtoncc.gif` | Correct script; byte-identical | confirmed |
| W1 | Frames | Title strings name the function and method used in the code | aa: "Standard Newton: f(x) = x³−3x+2 (double root at x=1)"; bb: "Accelerated Newton (m=2)…"; cc: "Modified Newton (Method B): h(x) = f(x)/f'(x)" | confirmed |

---

### 3. Implementation checks

General: the manifest shows each scratch regeneration is byte-identical to the committed GIF (13, 6 and 5 frames). I instrumented copies (`inst_aa.jl`, `inst_bb.jl`, `inst_cc.jl`, made by inserting a print loop before `@animate` and exiting) to print every iterate in Float64. `indep.py` reran all three iterations independently at 40-digit precision with mpmath, and used sympy for the factorization, h(x), the Method-B identity and the series.

### `accnewtonaa.jl` — standard Newton
- **Method:** `xs[i+1] = xs[i] - f/fp` with f = x³−3x+2 and fp = 3x²−3. This is plain Newton–Raphson, as the heading says.
- **Numbers:**

  | k | script (Float64) | independent (mpmath) | e_{k}/e_{k−1} |
  |---|---|---|---|
  | 1 | 1.1030303030303028 | 1.10303030303030 | 0.515152 |
  | 2 | 1.052356417197916 | 1.05235641719792 | 0.508165 |
  | 3 | 1.0264008140553686 | 1.02640081405537 | 0.504252 |
  | 6 | 1.0033253746264617 | 1.00332537462646 | 0.500552 |
  | 12 | 1.0000520156500807 | 1.00005201564977 | 0.500009 |

  Agreement to about 12 significant digits. The linear rate tends to 1/2 = (m−1)/m.
- **Reference values:** The root x = 1 is exact. (x−1)²(x+2) was confirmed by sympy.
- **Picture:** The segment from (x_n, f(x_n)) to (x_{n+1}, 0) has slope f(x₀)/(x₀−x₁) = 1.32 = f′(1.2), so it is the true tangent. The vertical drop to the curve is at x_{n+1}. The legend's index and value match the iterate (frame 13: "x₍12₎ = 1.000052"). Nothing is clamped or masked. Visibility of late iterates: see F1.

### `accnewtonbb.jl` — accelerated Newton, m = 2
- **Method:** `xs[i+1] = xs[i] - m*f/fp` with m = 2. This is Mathews' accelerated Newton-Raphson (Theorem "Acceleration of Newton-Raphson Iteration"; his g[x] = x − 2 f/f′, archive gr_131).
- **Numbers:**

  | k | script | mpmath | \|e_k\|/e_{k−1}² | Mathews |
  |---|---|---|---|---|
  | 1 | 1.0060606060606054 | 1.00606060606061 | 0.151515 | 1.00606060606061 |
  | 2 | 1.0000061033293672 | 1.00000610332937 | 0.166163 | 1.0000061033293 |
  | 3 | 1.0000000000036071 | 1.00000000000621 | 0.166666 | 1.0000000000036 (Float) |
  | 4, 5 | 1.0000000000036071 (stalls: f(x₃) evaluates to 0.0) | 1 + 6.4e−24 | — | Mathews' Float run jumps to 1.0000205 at p₄ |

  The script's x₃ differs from exact arithmetic at the 1e−12 level because x³−3x+2 cancels catastrophically near a double root. That is far below the 6 decimals shown, and the script stalls rather than wandering off. The page makes no claim about x₄ or x₅.
- **Reference values:** Root x = 1, exact.
- **Picture:** The drawn slope is 0.66 = f′(1.2)/2, as the page says. Frames 4–6 are identical apart from the legend index ("x₍3₎/x₍4₎/x₍5₎ = 1.0"), which is consistent with the stalled iteration and with "x₃ equals 1 to six decimals".

### `accnewtoncc.jl` — modified Newton (Method B)
- **Method:** `x - f*fp/(fp^2 - f*fpp)`, with fpp = 6x correct. sympy confirms this is identical to x − h/h′ for h = f/f′, which is Mathews' modified Newton-Raphson (archive gr_244–247, g[x] = (2+4x)/(3+2x+x²)). As an extra check, I evaluated (2+4x)/(3+2x+x²) at 1.2 and got 6.8/6.84 = 0.994152, the same as the script's x₁.
- **Numbers:**

  | k | script | mpmath | \|e_k\|/e_{k−1}² | Mathews |
  |---|---|---|---|---|
  | 1 | 0.9941520467836247 | 0.994152046783626 | 0.146199 | 0.994152046783626 |
  | 2 | 0.9999942779650373 | 0.999994277965015 | 0.167318 | 0.999994277965015 |
  | 3 | 1.0000000000083733 | 0.999999999994543 | 0.166667 | 0.999999999994543 |
  | 4 | 1.0000000000083733 (stalls) | 1 − 5.0e−24 | — | 1.0 |

  The Float64 x₃ is on the other side of 1 from the exact value, with |error| ≈ 1e−11. This is rounding noise from cancellation in f and is invisible at six decimals.
- **Reference values:** `h_plot(x) = (x−1)(x+2)/(3(x+1))` equals f/f′ for x ≠ ±1 (sympy `factor`). The pole at −1 is outside the window [0.5, 2] and the singularity at 1 is removable, so the plotted curve is exactly h.
- **Picture:** The drawn line runs from (x_n, h(x_n)) to (x_{n+1}, 0). Its slope equals h′(x_n): 0.471074380 vs 0.471074380 and 0.500978950 vs 0.500978950. At k = 2 it is 0.4999997 vs 0.5000010, a difference caused by Float64 noise in x₃ and invisible on screen. The title and legend are correct. Visibility: see F2.

### Things checked and not reported
- The legend uses Unicode subscript parentheses ("x₍1₎"). They render small but legibly, so this is cosmetic.
- The y-window [−0.05, 1.0] in Cases 1 and 2 leaves most of the plot empty above f(1.2) = 0.128. That is cosmetic apart from the resolution effect described in F1.
- Archive fidelity of the three cases that are shown: functions, starting values and iterates all match Mathews Examples 1(b), 2 and 4.

