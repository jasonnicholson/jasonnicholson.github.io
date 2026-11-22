# Newton-Raphson Method — animation review (round 2)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Implementation (picture) — Minor — Case 6 final, most divergent step is not drawn

- **Location:** `newtonff.jl` lines 46–50 (the `if xlims[1] <= xn <= xlims[2] && xlims[1] <= xn1 <= xlims[2]` guard), with `xlims = (-4.0, 5.0)` at line 18. Seen in `committed/newtonff/frame_007.png`.
- **What is there now:** the last step goes from x₅ = −2.8936 to x₆ = 8.7103. Because x₆ lies outside the window, the whole tangent segment is skipped, even though it starts inside the window at (−2.894, −1.238) and crosses most of the plot. The red marker is also dropped. So the last frame (frame 7) is identical to frame 6 apart from the legend text "x₆ = 8.71 (out of range)". The step that shows the escape most clearly, a jump of more than 11 units in x, is never shown. The step-to-step growth a viewer can actually see stops at |x| ≈ 2.9.
- **What is true:** x₆ = 8.710325847 (script and mpmath agree to all printed digits). The tangent line at x₅ crosses the right edge x = 5 at y = f(x₅)·(8.7103 − 5)/(8.7103 + 2.8936) ≈ −1.2381·0.3197 ≈ −0.396, so that line is visible inside the window.
- **How I know:** `julia review/inst_ff.jl` → `..., -2.8935623931424104, 8.710325846983183`; `python3 review/indep.py` → `ff [... '-2.893562393', '8.710325847']`; I inspected the frame visually.
- **Suggested correction:** draw the tangent segment from (x₅, f(x₅)) toward (x₆, 0) and let Plots clip it at the window edge. Remove the "both endpoints visible" guard, or replace it with a guard on xn only, since `xlims` already clips the line. Optionally draw an arrow or annotation at the right edge reading "x₆ = 8.71 →". Widening `xlims` to about (−4, 10) would also work, but it squeezes the earlier steps.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 5.4 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.0 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.1 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.4 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.6 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 6.6 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonaa.gif` | 6 | byte-identical | newtonaa |
| `newtonbb.gif` | 13 | byte-identical | newtonbb |
| `newtoncc.gif` | 9 | byte-identical | newtoncc |
| `newtondd.gif` | 11 | byte-identical | newtondd |
| `newtonee.gif` | 7 | byte-identical | newtonee |
| `newtonff.gif` | 7 | byte-identical | newtonff |

### Page references

- Scripts linked: `newtonaa.jl`, `newtonbb.jl`, `newtoncc.jl`, `newtondd.jl`, `newtonee.jl`, `newtonff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "At each iterate x_n, a tangent line to f(x) is drawn; its x-intercept gives x_{n+1} = x_n − f(x_n)/f'(x_n)" | All six scripts compute `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])` and draw the segment from (xₙ, f(xₙ)) to (xₙ₊₁, 0), which by construction lies on the tangent line. The hand derivatives match `mp.diff` (iterates agree, below) | confirmed |
| 2 | Intro | "The sequence of tangent lines traces the convergence (or divergence)" | Frames accumulate all previous steps (loop `for k in 1:frame`) | confirmed |
| 3 | Case 1 heading | f(x)=3eˣ−4cos x, x₀=1.0 | newtonaa.jl l.10, 14; title in frames | confirmed |
| 4 | Case 1 heading | "Quadratic convergence" | errors 0.745, 0.225, 3.09e−2, 7.27e−4, 4.19e−7, 1.39e−13; e_{n+1}/e_n² → 0.61, 0.76, 0.79, 0.79 (constant) | confirmed |
| 5 | Case 1 | "single positive root, x* ≈ 0.2549" | mpmath root 0.254850059029. f' = 3eˣ+4 sin x > 0 for x > 0 (sin x > 0 on (0,π); 3eˣ > 4 beyond), so the positive root is unique | confirmed |
| 6 | Case 1 | "infinitely many negative roots, outside the plotted window" | roots at −1.3812, −4.7191, …, approaching zeros of cos x as eˣ→0; window is [0, 1.5] | confirmed |
| 7 | Case 1 | "convex side … each tangent line lands between the root and the previous iterate … decrease monotonically" | f'' = 3eˣ+4cos x > 0 on [0,1] (7.0, 8.46, 10.32); f(x₀) > 0; iterates strictly decreasing and all > x* | confirmed |
| 8 | Case 1 | "(1, 0.4798, 0.2857, 0.2556, 0.254850, …)" | 1, 0.4797520, 0.2857384, 0.2555769, 0.2548505 | confirmed |
| 9 | Case 1 | "number of correct digits roughly doubles each step" | error digits ≈ 1.5, 3.1, 6.4, 12.9 | confirmed |
| 10 | Case 1 alt | "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | frames 1–6 | confirmed |
| 11 | Case 2 heading | f(x)=(1−5x)², x₀=1.0 | newtonbb.jl l.11, 15; Mathews: 1−10x+25x², p₀=1.0 (identical) | confirmed |
| 12 | Case 2 | "double root at x* = 0.2"; "f'(x*) = 0" | f(0.2)=0, f'(0.2)=−10(1−1)=0 | confirmed |
| 13 | Case 2 | "degrades to linear convergence — each step roughly halves the error" | iterates 1, .6, .4, .3, .25, .225, …, 0.2001953; error exactly halves (0.8, 0.4, 0.2, …) | confirmed |
| 14 | Case 2 alt | "slow linear convergence to the double root at x=0.2" | 12 steps, final 0.20020 (legend) | confirmed |
| 15 | Case 3 heading | f=arctan x, x₀=1.35, "Convergent near inflection point" | newtoncc.jl l.11, 15. Inflection of arctan is at 0, which is the root. Heading is loose but not false | confirmed |
| 16 | Case 3 | "only root is x* = 0" | arctan is strictly increasing | confirmed |
| 17 | Case 3 / 6 | "converges only when \|x₀\| < x_c ≈ 1.3917" | x_c solves 2x = (1+x²)arctan x: 1.3917452003. `xc.py`: x₀ = 1.39, 1.3917 → 0; 1.3918, 1.392 → diverge | confirmed |
| 18 | Case 3 | "just inside the convergence radius" | 1.35 < 1.3917 | confirmed |
| 19 | Case 3 | "converges but requires several oscillating steps before settling in" | 1.35, −1.2841, 1.1241, −0.7859, 0.2916, −0.01625, 2.86e−6, −1.56e−17: signs alternate, \|x\| decreases | confirmed |
| 20 | Case 3 alt | "convergent case starting just inside the critical radius at x₀=1.35" | as above | confirmed |
| 21 | Case 4 heading | f=x³−x+3, x₀=0.0, "Cycling (non-convergence)" | newtondd.jl l.12, 16 | confirmed |
| 22 | Case 4 | "one real root, x* ≈ −1.6717" | mpmath −1.6716998817. Discriminant of x³−x+3 is −4(−1)³−27·9 = 4−243 < 0, so it has one real root | confirmed |
| 23 | Case 4 | "the curve crosses the axis at the left of the window" | window [−2, 3.5]; crossing visible near −1.67 in all frames | confirmed |
| 24 | Case 4 | "drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | Limit cycle after 400 iterations: 0.0074461, 3.0004983, 1.9618967, 1.1475016. Multiplier ∏g'(cᵢ) = 0.2325 < 1 (attracting). Script iterates approach it: x₄=0.00658, x₈=0.00726 | confirmed |
| 25 | Case 4 | "never approach the root" | iterates stay in [0.0066, 3.0005], root at −1.67 | confirmed |
| 26 | Case 4 alt | "settle into a 4-cycle near 0.0074, 3.0005, 1.9619 and 1.1475 and never reach the real root at x≈−1.6717" | as above | confirmed |
| 27 | Case 5 heading | f=x e^{−x}, x₀=2.0, "Divergence to infinity" | newtonee.jl l.11, 15 | confirmed |
| 28 | Case 5 | "only root is x* = 0"; "maximum of f at x = 1" | e^{−x} > 0; f' = (1−x)e^{−x} is zero only at 1, and changes sign from + to − there | confirmed |
| 29 | Case 5 | "f > 0 and f'(x) = (1−x)e^{−x} < 0 … x_{n+1} = x_n²/(x_n − 1) > x_n" | x − x/(1−x) = x²/(x−1) (algebra); for x > 1, x²/(x−1) − x = x/(x−1) > 0 | confirmed |
| 30 | Case 5 | "(2, 4, 5.33, 6.56, …, 10.02 after six steps)" | 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 | confirmed |
| 31 | Case 5 | "f(x_n) → 0" | f(10.0188) = 4.5e−4, decreasing | confirmed |
| 32 | Case 5 alt | "each tangent line meets the axis further right … toward +∞" | frames 1–7; all iterates inside [0, 11] and drawn | confirmed |
| 33 | Case 6 heading | f=arctan x, x₀=1.4, "Divergent" | newtonff.jl l.11, 15 | confirmed |
| 34 | Case 6 | "just outside the critical convergence radius x_c ≈ 1.3917" | 1.4 > 1.39175 | confirmed |
| 35 | Case 6 | "do not converge … escape toward larger \|x\|" | 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103 (Mathews continues −103.2, 16540.6, …) | confirmed |
| 36 | Case 6 alt | "divergent case starting just outside the critical radius at x₀=1.4" | as above. The last step is not drawn (F1) | confirmed (see F1 for the drawing) |
| 37 | Wiring | Each case links `newtonXX.jl` and embeds `newtonXX.gif` with the heading's function and x₀ | aa→Case 1, bb→2, cc→3, dd→4, ee→5, ff→6. Script parameters match headings, and GIF titles match functions | confirmed |
| 38 | Counts | 6 cases | 6 scripts, 6 GIFs; frames 6/13/9/11/7/7 = n_iters+1 | confirmed |
| 39 | Frames | legend values "xₙ = …" | Every label matches `round(xs[n+1], digits=5 or 4)` (instrumented output). Case 3 shows "x₆ = 0.0", "x₇ = −0.0", "x₈ = 0.0": rounding of 2.86e−6 and −1.56e−17, and x₈ = 0.0 exactly in Float64. Cosmetic only, not a finding | confirmed |

Description section: the page has no separate Description. The only formula is the intro's update formula (ledger row 1).

---

### 3. Implementation checks

All six scripts share one structure: a plain Newton loop `xs[i+1] = xs[i] - f(xs[i])/fp(xs[i])` with hand-coded derivatives, then a tangent-line diagram. In every frame, a segment runs from (xₙ, f(xₙ)) to (xₙ₊₁, 0) and is followed by a vertical drop to (xₙ₊₁, f(xₙ₊₁)).

**Method identity (all scripts):** unmodified Newton-Raphson, with no damping or safeguard. That matches the title and the intro formula. The hand derivatives are correct: 3eˣ+4 sin x; −10(1−5x); 1/(1+x²); 3x²−1; (1−x)e^{−x}. I confirmed this indirectly, because the independent iteration uses numerical differentiation (`mp.diff`) and gives the same iterates.

**Numbers: script (Float64, instrumented copy) vs independent (mpmath 40 digits, numeric derivative):**

| Case | Script iterates | Independent iterates | Agreement |
|---|---|---|---|
| aa | 1.0, 0.47975201560571856, 0.28573835913112816, 0.2555769004716556, 0.2548504777343278, 0.25485005902898933 | 1.0, 0.4797520156, 0.2857383591, 0.2555769005, 0.2548504777, 0.254850059 | all digits shown |
| bb | 1.0, 0.6, 0.4, 0.3, 0.25, 0.225, 0.2125, 0.20625, 0.203125, 0.2015625, 0.20078125, 0.200390625, 0.2001953125 | same | exact |
| cc | 1.35, −1.2840911496, 1.1241231065, −0.7858718810, 0.2915539774, −0.0162510014, 2.861054894e−6, −1.5613e−17, 0.0 | 1.35, −1.28409115, 1.124123106, −0.785871881, 0.2915539774, −0.01625100144, 2.861054894e−6, −1.5613e−17, 2.5e−51 | agree. The last two differ only at Float64 underflow level |
| dd | 0.0, 3.0, 1.9615384615, 1.1471759614, 0.0065793715, 3.0003890741, 1.9618181757, 1.1474302285, 0.0072562476, 3.0004731888, 1.9618786464 | 0.0, 3.0, 1.961538462, 1.147175961, 0.006579371481, 3.000389074, 1.961818176, 1.147430228, 0.007256247552, 3.000473189, 1.961878646 | all digits shown |
| ee | 2, 4, 5.333333, 6.564103, 7.743826, 8.892110, 10.018819 | 2, 4, 5.333333333, 6.564102564, 7.743826066, 8.892109843, 10.01881867 | all digits shown |
| ff | 1.4, −1.4136186488, 1.4501293146, −1.5506259756, 1.8470540842, −2.8935623931, 8.7103258470 | 1.4, −1.413618649, 1.450129315, −1.550625976, 1.847054084, −2.893562393, 8.710325847 | all digits shown; also matches Mathews' printed table (p₁…p₆) to 13+ digits |

Property checks: case aa, e_{n+1}/e_n² tends to a constant (about 0.79), so the convergence is quadratic. Case bb, e_{n+1}/e_n = 0.5 exactly (linear, as the theory for a double root predicts: (m−1)/m = 1/2). Case cc, the final approach is cubic, as expected since f''(0)=0: 0.01625³·(2/3) = 2.86e−6, which is x₆. Case dd, the cycle multiplier is 0.2325, so the cycle is attracting.

**Reference values:** none of the scripts plots a separate "true root". The roots and constants quoted on the page were checked independently: 0.2548500590, 0.2, 0, −1.6716998817, x_c = 1.3917452003, and the 4-cycle values (ledger rows 5, 12, 17, 22, 24).

**Picture:**
- aa: window [0,1.5]×[−2,10] holds all iterates and f(x₀)=6.0. Tangent and drop segments are correct (frames 1–6 viewed). Pass.
- bb: window [0,1.5]×[−0.5,18] holds f(1)=16. The first tangent runs from (1,16) to (0.6,0), slope 40 = f'(1). Pass.
- cc: window [−3,2.5]×[−1.8,1.8] holds all iterates (max \|x\| = 1.35), so the guard never hides a step. Pass.
- dd: `clamp` to [−4,30] is never active (max f on the iterates is f(3.0005) ≈ 27.01; f(−2) = −3). The x-guard is never triggered. The real root is visible. Pass.
- ee: window [0,11] holds all iterates up to 10.019. The "→ ∞" legend branch is never reached. The tiny late tangents are readable. Pass.
- ff: window [−4,5]. Steps 1–5 are drawn correctly. Step 6 (x₅ → x₆ = 8.71) is suppressed because of the both-endpoints guard; see **F1**. The legend reports the true value 8.71 "(out of range)", so nothing false is shown. The defect is that the decisive step is missing.

**Fidelity (Mathews archive):** the archive's six animated examples (Examples 3–8: Fast Convergence; Slow Convergence; Convergence, Oscillation; NON Convergence, Cycling; NON Convergence, Diverging to Infinity; NON Convergence, Divergent Oscillation) match the page's six cases one for one: 3Exp[x]−4Cos[x], p₀=1.0; 1−10x+25x², p₀=1.0; ArcTan[x], p₀=1.35; x³−x+3, p₀=0.0; x e^{−x}, p₀=2.0; ArcTan[x], p₀=1.4. The a2001 animation index also lists exactly 6 Newton animations. Examples 1–2 (cubic-polynomial root finding, no animation) are not animation cases. Plot windows differ from Mathews, for example the wider window in Case 4 that shows the real root, but this changes nothing a reader would conclude. No fidelity findings.

