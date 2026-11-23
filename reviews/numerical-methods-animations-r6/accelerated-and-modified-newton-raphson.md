# Accelerated & Modified Newton-Raphson — animation review (round 6)

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Implementation (display), Minor — Case 1 window hides the slow convergence the case is about
- **Where:** `accnewtonaa.jl` lines 18–19 (`xlims = (0.7, 1.8)`, `ylims = (-0.05, 1.0)`); same window in `accnewtonbb.jl` lines 20–21.
- **What is there now:** The largest function value any step uses is f(x0) = 0.128, so all the Newton geometry fits in the bottom ~17% of a plot that runs up to y = 1.0. The x-window is 1.1 wide (about 508 px per unit in a 640-px frame), so the steps from x2 = 1.052 onward start at f ≤ 0.0084 (about 4 px above the axis) and are less than 27 px apart horizontally. The frames confirm this: from frame 3 on, the steelblue tangents and drops are a thin sliver hugging the axis next to the root. From frame 6 (x5) the red marker covers the root and nothing visibly changes for the rest of the animation (frames 6–13), apart from the legend number.
- **Why it matters:** Case 1 is meant to show *slow, linear* convergence: each step roughly halves the error. At this scale, after the first two steps the viewer sees the iterate sitting on the root, which looks like fast convergence. The page does say so ("At the scale of the plot only the first few steps can be told apart … the remaining halvings show only in the legend value"), so the page is not wrong. But that sentence is there to explain away a window choice, not because a readable view is impossible.
- **How I know:** Instrumented copy `review/inst_aa.jl` printed f(x_n) = 0.128, 0.0329, 0.00837, 0.00211, 0.00053, … and x_n − 1 = 0.2, 0.103, 0.0524, 0.0264, 0.0133, 0.00664, …. I read frames `committed/accnewtonaa/frame_002.png` and `frame_013.png` and the contact sheet.
- **Suggested correction:** Zoom Case 1 to roughly `xlims = (0.97, 1.22)` and `ylims = (-0.005, 0.14)`. In that window x0…x5 are 15–100 px apart, so about six halvings are visible. Then shorten the "only the first few steps can be told apart" sentence to match. Optionally add an inset or a log-error panel. Case 2 can keep its window.

- **Independent check:** not run (Minor finding, unverified)

### F2 — Page match, Minor — Intro says each animation shows three methods
- **Where:** index.qmd line 26: "Each animation below shows a Newton-style line diagram for three methods applied to the same double root."
- **What is there now:** Each GIF shows exactly one method: standard, accelerated or modified.
- **What is true:** The three animations *together* cover three methods. Read literally, the sentence says every GIF compares all three.
- **How I know:** Script source (a single iteration rule per script) and the contact sheets for all three GIFs.
- **Suggested correction:** "The three animations below show a Newton-style line diagram for three methods, one per animation, applied to the same double root."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `accnewtonaa.jl` | 0 | 5.5 | accnewtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtonbb.jl` | 0 | 6.8 | accnewtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `accnewtoncc.jl` | 0 | 6.6 | accnewtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Independent values come from `review/indep.py` (mpmath, 40 digits) unless noted. Script values come from `review/inst_*.jl` (Float64).

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Standard N-R converges quadratically at simple roots and degrades to linear at multiple roots because f'(x*) = 0 | Case 1 error ratios → 0.500009; Case 2/3 quadratic | confirmed |
| D2 | Description | Method A: x_{n+1} = x_n − m f/f' | matches `accnewtonbb.jl` l.29 | confirmed |
| D3 | Description | Method A "recovers the quadratic rate; requires knowing m" | e_{n+1}/e_n² → 0.166667 (= f'''/(6·…) constant 1/6) | confirmed |
| D4 | Description | If f has a root of multiplicity m, h = f/f' has a simple root there | sympy: h = (x−1)(x+2)/(3(x+1)), h(1) = 0, h'(1) = 1/2 ≠ 0 | confirmed |
| D5 | Description | Newton on h gives x − f f'/(f'² − f f'') | Newton on h (mpmath diff) and the formula give identical iterates 1.2, 0.994152046783626, 0.999994277965015, … ; matches `accnewtoncc.jl` l.22–28 | confirmed |
| D6 | Description | Method B converges quadratically without knowing m | e_{n+1}/e_n² → −0.166667 | confirmed |
| I1 | Intro l.26 | "Each animation … for three methods" | each GIF shows one method | wrong (F2, Minor) |
| I2 | Intro | Line from the curve at x_n to its x-axis intercept gives x_{n+1} | plotting code draws (x_n, y_n)→(x_{n+1}, 0) in all three scripts; frames agree | confirmed |
| I3 | Intro | Cases 1 and 3: the line is the tangent to the plotted curve | Case 1 slope 0.128/0.09697 = 1.32 = f'(1.2); Case 3 slope 0.4710743802 = h'(1.2) | confirmed |
| I4 | Intro | Case 2 line has half the tangent slope | slope 0.66 = f'(1.2)/2 | confirmed |
| I5 | Intro | Cases 1 and 2 plot f; Case 3 plots h, which has a simple root where f has a double root | scripts l.40/l.42 plot f; cc l.56 plots h_plot; D4 | confirmed |
| I6 | Intro | Julia sources linked under each case | three links present, files exist | confirmed |
| I7 | Intro | Cases reproduce Mathews Examples 1(b), 2 and 4, all at the double root of the same cubic | archive: Ex 1(b) f = x³−3x+2, p = 1, p0 = 1.2; Ex 2 accelerated, same f, p0; Ex 4 modified, same f, p0 (images gr_31–35, 118–120, 233–235) | confirmed |
| I8 | Intro | Ex 1(a) = standard N-R at the simple root of the cubic | archive: p = −2, p0 = −2.4, "Fast Convergence" | confirmed |
| I9 | Intro | Ex 3 / Ex 5 = accelerated / modified at a double and a triple root of a fifth-degree polynomial | archive gr_160/276: x⁵−8x⁴+25x³−38x²+28x−8; sympy factor (x−1)²(x−2)³ (Mathews' text says "cubic", which is wrong; the page is right) | confirmed |
| I10 | Intro | Ex 6 = standard, accelerated, modified at a root of higher multiplicity | archive gr_334: −x⁷+8x⁶−…+2; sympy −(x−2)(x−1)⁶; root multiplicity 6 | confirmed |
| C1a | Case 1 heading | Standard N-R, linear convergence, f = x³−3x+2, x0 = 1.2 | `accnewtonaa.jl` l.11, 15, l.27 plain Newton | confirmed |
| C1b | Case 1 | f = (x−1)²(x+2), double root at x* = 1 | sympy | confirmed |
| C1c | Case 1 | asymptotic error constant (m−1)/m = 1/2; each step halves the error | ratios 0.515, 0.508, 0.504, … → 0.500009 | confirmed |
| C1d | Case 1 | near the root f ≈ 3(x−1)² | (x+2) → 3 at x = 1 | confirmed |
| C1e | Case 1 | tangent meets the axis between x_n and x*, about halfway | all x_n > 1, decreasing; ratios ≈ 0.5 | confirmed |
| C1f | Case 1 | each step covers just under half the remaining distance | fraction covered = 1 − ratio = 0.485, 0.492, 0.496, … < 0.5 | confirmed |
| C1g | Case 1 | iterates 1.2, 1.10303, 1.052356, 1.026401 | indep 1.10303030, 1.05235642, 1.02640081; script identical | confirmed |
| C1h | Case 1 | after 12 steps x12 = 1.000052, about 5.2×10⁻⁵ from the root | indep 1.0000520156; err 5.20156e-5; script 1.0000520156500807; legend in frame 13 "1.000052" | confirmed |
| C1i | Case 1 | 12 steps | n_iters = 12; 13 frames (x0…x12) | confirmed |
| C1j | Case 1 | from x5 on the iterate is < 0.007 from the root and its marker covers the root | x5 − 1 = 0.006643; ≈3.4 px offset at ~508 px/unit, marker radius ≈ 6–7 px; frames 6–13 show the marker on the root | confirmed |
| C1k | Case 1 | only the first few steps can be told apart; later halvings show only in the legend | frames 3–13 | confirmed (see F1) |
| C1l | Case 1 alt | slow linear convergence from x0 = 1.2 to x = 1 over 12 iterations; from x5 the marker covers the root | as above | confirmed |
| C2a | Case 2 heading | Accelerated (Method A, m = 2), quadratic, same f, x0 = 1.2 | `accnewtonbb.jl` l.18, l.29; multiplicity 2 from sympy | confirmed |
| C2b | Case 2 | orange line from (x_n, f(x_n)) is not the tangent; slope f'(x_n)/2; meets the axis twice as far as the Newton tangent | slope 0.66 vs f'(1.2) = 1.32; Newton step 0.09697 vs accelerated 0.19394; frame 2 orange line | confirmed |
| C2c | Case 2 | restores quadratic convergence, \|e_{n+1}\| ≈ C\|e_n\|² | C: 0.1515, 0.16616, 0.16667 (matches Mathews' table gr_157) | confirmed |
| C2d | Case 2 | x1 = 1.006061, x2 = 1.000006, x3 equals 1 to six decimals | indep 1.00606060606, 1.00000610333, 1.00000000000621; script 1.0060606060606054, 1.0000061033293672, 1.0000000000036071; legends "1.006061", "1.000006", "1.0" | confirmed |
| C2e | Case 2 alt | orange lines with half the tangent slope; steps twice the Newton step; x3 equal to 1 to six decimals | as above | confirmed |
| C3a | Case 3 heading | Modified (Method B), quadratic, same f, x0 = 1.2 | `accnewtoncc.jl` l.22–28, l.31 | confirmed |
| C3b | Case 3 | h = f/f' has a simple root at a double root of f | D4 | confirmed |
| C3c | Case 3 | the iteration formula implements Newton on h using f, f', f'' | D5 | confirmed |
| C3d | Case 3 | the animation plots h = (x−1)(x+2)/(3(x+1)), tangent lines dashed | sympy simplification matches `h_plot`; black dashed lines in the frames | confirmed |
| C3e | Case 3 | h nearly straight between root and x0; first tangent lies almost on the curve; x1 = 0.994152, just left of the root | indep x1 = 0.994152046784; tangent root 0.0058 from h's root; frame 2 | confirmed |
| C3f | Case 3 | at this scale the overshoot and later steps are too small to see | 0.0058 over a 1.5-wide window ≈ 2 px; frames 2–5 | confirmed |
| C3g | Case 3 | x2 = 0.999994; x3 equals 1 to six decimals | indep 0.999994277965, 0.999999999994543; script 0.9999942779650373, 1.0000000000083733 (legend "1.0") | confirmed |
| C3h | Case 3 alt | dashed tangent from x0 lies almost on the curve, x1 = 0.994152 just left of x = 1; x3 = 1 to six decimals | as above | confirmed |
| W1 | Wiring | Case 1 → accnewtonaa.jl / .gif; Case 2 → bb; Case 3 → cc | file contents match each case; manifest: regenerated GIFs byte-identical to committed | confirmed |
| W2 | Counts | 13 / 6 / 5 frames (x0…x_n) | manifest frame counts 13, 6, 5 = n_iters+1 | confirmed (page states 12 steps for Case 1 only) |

---

### 3. Implementation checks

### `accnewtonaa.jl` — standard Newton on f = x³ − 3x + 2 from 1.2
1. **Method:** l.27 `xs[i+1] = xs[i] - f/fp` is plain Newton. f' = 3x² − 3 is correct.
2. **Numbers:** Script (Float64) and independent (mpmath) agree to every printed digit:

   | n | script | independent |
   |---|---|---|
   | 1 | 1.1030303030303028 | 1.10303030303030 |
   | 2 | 1.052356417197916 | 1.05235641719792 |
   | 3 | 1.0264008140553686 | 1.02640081405537 |
   | 5 | 1.0066434177726777 | 1.00664341777268 |
   | 12 | 1.0000520156500807 | 1.00005201564977 |

   Error ratios go to 0.5 = (m−1)/m, the known rate. The values also agree with Mathews' table (archive gr_106/gr_111: p12 = 1.00005201564977).
3. **Reference values:** The root x = 1 is double (sympy factor (x−1)²(x+2)). The title "(double root at x=1)" is correct.
4. **Picture:** Each segment runs from (x_n, f(x_n)) to (x_{n+1}, 0), with slope f'(x_n) (checked for n = 0: 1.32). The vertical drop runs from (x_{n+1}, 0) to (x_{n+1}, f(x_{n+1})). The marker sits at (x_n, f(x_n)), and the legend index and value match the frame (frame k+1 shows x_k). There is no clamping or masking. Concern: the window (F1).

### `accnewtonbb.jl` — accelerated Newton, m = 2
1. **Method:** l.29 `x - m*f/fp` with m = 2 is the accelerated Newton-Raphson of Mathews' theorem. m = 2 is the correct multiplicity.
2. **Numbers:** script 1.0060606060606054, 1.0000061033293672, 1.0000000000036071; independent 1.00606060606061, 1.00000610332937, 1.00000000000621. The x3 values differ at 1e-12, which is Float64 cancellation in f near a double root (attainable accuracy ~√eps). This is far below the 6 decimals displayed. After x3, f evaluates to exactly 0.0 in Float64, so x4 = x5 = x3 (no NaN). Those frames show "1.0", which is correct to 6 decimals. Quadratic constants 0.1515, 0.1662, 0.16667 match the theory (1/6) and Mathews' gr_157.
3. **Reference values:** root x = 1 (as above).
4. **Picture:** The orange segment runs from (x_n, f(x_n)) to (x_{n+1}, 0), with slope f'(x_n)/2 (0.66 at x0). The comment on l.48 is accurate. Legend values in frames 1–6 are 1.2, 1.006061, 1.000006, 1.0, 1.0, 1.0. These are correct.

### `accnewtoncc.jl` — modified Newton (Newton on h = f/f')
1. **Method:** l.22–28 use x − f f'/(f'² − f f''), with f'' = 6x correct. This is algebraically Newton on h: I ran Newton on h directly with numerical h' in mpmath and the iterates agree to 15 digits.
2. **Numbers:** script 0.9941520467836247, 0.9999942779650373, 1.0000000000083733; independent 0.994152046783626, 0.999994277965015, 0.999999999994543. The Float64 x3 lands on the other side of 1 at 1e-11, from cancellation in f. This is invisible at 6 decimals, and the page does not claim a side for x3. Quadratic constants −0.1462, −0.1673, −0.16667 match Mathews' gr_273 table.
3. **Reference values:** `h_plot` = (x−1)(x+2)/(3(x+1)) equals f/f' (sympy). The pole at x = −1 lies outside the window [0.5, 2], and the removable 0/0 at x = 1 is avoided by using the simplified form.
4. **Picture:** The dashed segment runs from (x_n, h(x_n)) to (x_{n+1}, 0), with slope 0.47107 = h'(1.2), so it is the tangent to h. The steelblue drop runs to h(x_{n+1}). The marker sits on h, and the legends match the computed iterates. No issues.

### Regeneration
Per the manifest, scratch runs of all three unchanged scripts reproduce the committed GIFs byte-for-byte (13, 6 and 5 frames).

### Fidelity to the legacy archive
The page's three cases match Mathews Examples 1(b), 2 and 4 exactly: function, root and p0 = 1.2. The iterates match Mathews' tables to every digit shown. The page correctly lists the omitted examples, and its "fifth-degree" description of Examples 3 and 5 fixes a slip in Mathews' text ("cubic"). Mathews' 1(b) runs 25 iterations against the page's 12; that does not affect any claim. No fidelity findings.

