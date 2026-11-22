# Broyden's Method — animation review (round 5)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Final Case A residual is quoted to two digits at roundoff level (Page match, Minor)

- **Location:** `index.qmd`, Case A Behavior: “bring $\|\mathbf{F}\|$ down to $1.4\times10^{-15}$ at $\mathbf{X}^{(6)}$”; Case A alt text: “falling from 2.5e-1 to 1.4e-15 in six steps”; GIF `broydenaa.gif` frame 7 title “||F(X_6)|| = 1.36e-15”.
- **What is there now:** 1.4e-15 (the page) and 1.36e-15 (the GIF), taken from `norm(F(x,y))` evaluated in Float64.
- **What is true:** the exact residual at the script's own Float64 iterate X6 = (0.061770126338607456, 0.7244905153472168) is **1.57e-15**. The residual of the exact-arithmetic Broyden iterate X6 is **1.68e-15**. The value 1.36e-15 comes from rounding error in evaluating F (terms of size about 4, with eps ≈ 2.2e-16). It isn't a property of the iterate, so the second digit (and the third in the GIF title) carries no information. Mathews' Mathematica output gives the same Float64 value: ‖(−7.77e-16, 1.11e-15)‖ = 1.36e-15.
- **How I know:** `julia ex_aa.jl` printed `k=6 exact ||F(float iterate)|| = 1.5709e-15 float-evaluated = 1.3552e-15`. `python3 -I indep.py` (mpmath at 50 digits, same algorithm) printed `k=6 ... |F|=1.682752e-15`. For comparison, the Case B final value is stable: Float64 2.956e-14, exact at the Float64 iterate 2.972e-14, exact-arithmetic 3.17e-14. So the page's “3.0e-14” holds at the stated precision against the script's iterate.
- **Consequence:** small. A reader still concludes “machine precision”, and the “more than 1000 times in each of the last two steps” claim holds under all three values (5→6 ratio 1.6e5 in Float64, 1.4e5 exact at the iterate, 1.3e5 in exact arithmetic).
- **Suggested correction:** say “down to about $10^{-15}$ (machine precision) at $\mathbf{X}^{(6)}$” in the Behavior text and the alt text. Optionally, format the GIF's right-panel title with one significant figure, or label values below about 1e-14 as “≈ machine precision”. No change to the algorithm is needed.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 11.3 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 11.5 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton for systems: $J(X^{(k)})\Delta X = -F(X^{(k)})$, $X^{(k+1)} = X^{(k)}+\Delta X$; quadratic near a simple root; $n^2$ partials per step | Standard; matches Mathews' theorem (BroydenMethodMod.html) | confirmed |
| D2 | Finite-difference Jacobian $M_{ij}\approx (F_i(X+he_j)-F_i(X-he_j))/(2h)$, costing $2n^2$ extra (scalar) function evaluations | Mathews gr_72 shows the same central-difference matrix; gr_73 reads “2 n²” | confirmed |
| D3 | Secant condition $B_{k+1}s_k=y_k$ with $s_k=X^{(k+1)}-X^{(k)}$, $y_k=F(X^{(k+1)})-F(X^{(k)})$ | Script line 53–59 uses exactly these; `frob.py` secant residual 2.5e-16 / 6.5e-16 | confirmed |
| D4 | Rank-1 update $B_{k+1}=B_k+(y_k-B_ks_k)s_k^T/(s_k^Ts_k)$ is the Frobenius-closest matrix to $B_k$ satisfying the secant condition | `frob.py`: difference from the minimum-Frobenius-norm solution 5.6e-16 (n=2) and 1.0e-16 (n=4); rank of correction 1 | confirmed |
| D5 | Update costs $O(n^2)$; no function evaluations beyond $F(X^{(k+1)})$ | Outer product plus matrix-vector product; script evaluates F once per iteration | confirmed |
| D6 | Algorithm: Step 0 exact Jacobian $B_0=J(X^{(0)})$ and one Newton step; then for k≥1 evaluate F, update B with $s_{k-1}$, solve $B_k\Delta X=-F$, step | Script lines 43–64 do exactly this, in this order | confirmed |
| D7 | Converges superlinearly near a simple root, slower than quadratic | Exact-arithmetic error ratios $e_k/e_{k-1}$: A 0.023, 0.030, 0.025, 0.038, 7.7e-4, 7.5e-6; B 0.10, 0.089, 0.027, 0.095, 0.017, 8.3e-4, 2.0e-4 (trending to 0) | confirmed (consistent) |
| A1 | System $f_1=1-4x+2x^2-2y^3$, $f_2=-4+x^4+4y+4y^4$ | Script lines 16–17 and 78–79; Mathews gr_213/gr_660 | confirmed |
| A2 | Blue curve is $f_1=0$, red curve is $f_2=0$ | Script: Z1 blue, Z2 red. Frames: blue is the unbounded single-valued curve $y^3=(1-4x+2x^2)/2$ (passes (1, −0.794)); red is the closed curve | confirmed |
| A3 | Exactly two real solutions, near (0.062, 0.724) and (1.556, −0.576) | `indep.py`: resultant in y has degree 12 with 2 real roots; solutions (0.0617701263386074, 0.7244905153472166) and (1.5560974843220530, −0.5756507696188434) | confirmed |
| A4 | Both lie inside the plotted window | Window x∈[−1.75, 2.25], y∈[−1.5, 1.25]; the whole of $f_2=0$ fits too (|x|≤1.558, y∈[−1.22, 0.72]); frames show both intersections | confirmed |
| A5 | Each frame adds the next iterate, joined to earlier ones by a line | Script lines 84–98; frames 1→7 | confirmed |
| A6 | After the first (Newton) step the iterates are too close to the root to separate at this scale | Distance X1→root: A 1.1e-3, B 9.8e-3; plot scale ≈110 px/unit, so ≤1 px; frames confirm | confirmed |
| A7 | Right panel plots ‖F(X^(k))‖ on a log scale | Script line 102 (`yscale=:log10`), frames | confirmed |
| A8 | Starting points are Mathews' Example 8 standard-Broyden runs, whose printed iterates the animations reproduce | gr_676/gr_682 (“The Broyden's solution”) start at (0.1, 0.7) and (1.5, −0.5); every printed P_k matches the script's repr to ≤1e-16 (for example A P4 0.06177010919428845 vs 0.06177010919428844) | confirmed |
| A9 | Example 5 poses this system for Broyden; its archived copy lacks starting-point, result and graph images | lnk_7 references gr_213–241; only gr_213 (the system) exists | confirmed |
| A10 | Examples 1, 3, the Sherman–Morrison improved method (Example 8), and the 3-D/4-D exercises are not animated | Matches module contents; disclosed | confirmed |
| CA1 | Heading: Case A convergent, $X^{(0)}=(0.1, 0.7)$, root ≈ (0.062, 0.724) | Script line 26; root 0.061770, 0.724491 | confirmed |
| CA2 | First (Newton) step moves the iterate by about 0.05 | ‖X1−X0‖ = 0.0464 | confirmed |
| CA3 | ‖F‖ goes from 2.5e-1 to 7.8e-3 | 2.4843e-1, 7.7616e-3 | confirmed |
| CA4 | Following steps use the rank-1 formula with no new derivative evaluations | Script line 59; `Jac` called only at line 43 | confirmed |
| CA5 | ‖F‖ = 1.4e-15 at X^(6) | Float64 1.355e-15; exact at that iterate 1.571e-15; exact arithmetic 1.68e-15 | wrong at stated precision (roundoff level) — F1 |
| CA6 | From X^(0) to X^(4), ‖F‖ shrinks by between 24 and 43 times per step | Ratios 32.01, 24.55, 42.25, 25.67 | confirmed |
| CA7 | More than 1000 times over each of the last two steps | 1304, 1.65e5 | confirmed |
| CA8 | Alt: iterates close on (0.062, 0.724), only the first step large enough to see, ‖F‖ from 2.5e-1 to 1.4e-15 in six steps | 7 frames (X0..X6); see A6, CA5 | confirmed except the 1.4e-15 (F1) |
| CA9 | Link `broydenaa.jl` and embed `broydenaa.gif` are Case A | Script x0=(0.1, 0.7), writes broydenaa.gif; committed GIF byte-identical to regenerated (md5 0b31ab08…) | confirmed |
| CB1 | Heading: Case B convergent, $X^{(0)}=(1.5, −0.5)$, root ≈ (1.556, −0.576) | Script line 26; root 1.556097, −0.575651 | confirmed |
| CB2 | Converges to the lower-right solution | X7 = (1.5560974843220545, −0.5756507696188373) | confirmed |
| CB3 | ‖F‖ falls at every step from 7.3e-1 at X^(0) to 3.0e-14 at X^(7) | 7.315e-1, 1.051e-1, 1.109e-2, 5.231e-5, 1.056e-5, 1.921e-7, 1.603e-10, 2.956e-14 (exact at the iterate 2.972e-14), all decreasing | confirmed |
| CB4 | Only about a factor 5 from X^(3) to X^(4) | 4.953 | confirmed |
| CB5 | More than 1000 times in each of the last two steps | 1198, 5424 | confirmed |
| CB6 | A different initial guess finds a different root | A→(0.0618, 0.7245), B→(1.5561, −0.5757) | confirmed |
| CB7 | Alt: iterates close on (1.556, −0.576), only the first step visible, ‖F‖ falls at every step from 7.3e-1 to 3.0e-14 in seven steps | 8 frames (X0..X7); frames confirm | confirmed |
| CB8 | Link `broydenbb.jl` and embed `broydenbb.gif` are Case B | Script x0=(1.5, −0.5), writes broydenbb.gif; byte-identical to regenerated (md5 c8f0075d…) | confirmed |
| W1 | Page linked from the section index | `pages/numerical-methods/index.qmd:27` | confirmed |

---

### 3. Implementation checks

Both scripts are identical apart from the starting point, title string and output name (`diff` confirmed).

### `broydenaa.jl`

1. **Method.** Broyden's “good” method: exact Jacobian at X0, one Newton step, then the rank-1 update $B \leftarrow B + (y-Bs)s^T/(s^Ts)$ followed by solving $B\Delta X=-F$. This is the same variant as the Description and as Mathews' (non-Sherman–Morrison) theorem. The Jacobian (lines 20–23) matches sympy's `[[4x−4, −6y²],[4x³, 16y³+4]]`. Stops when ‖F(X_k)‖ < 1e-12 (reached after X6; the cap of 10 iterations is not hit).
2. **Numbers.** Script vs independent 50-digit mpmath Broyden (`indep.py`):

   | k | script x, y | independent x, y | script ‖F‖ |
   |---|---|---|---|
   | 0 | 0.1, 0.7 | 0.1, 0.7 | 2.4843e-1 |
   | 1 | 0.06103861644326676, 0.7252588370082448 | 0.061038616443266723, 0.72525883700824483 | 7.7616e-3 |
   | 2 | 0.06177915983442611, 0.7244597836716361 | 0.061779159834426122, 0.72445978367163603 | 3.1621e-4 |
   | 3 | 0.06177058906248765, 0.7244911570414898 | 0.061770589062487624, 0.72449115704148982 | 7.4833e-6 |
   | 4 | 0.06177010919428844, 0.7244904901876605 | 0.061770109194288446, 0.72449049018766058 | 2.9154e-7 |
   | 5 | 0.06177012632545587, 0.724490515327927 | 0.061770126325455893, 0.724490515327927 | 2.2354e-10 |
   | 6 | 0.061770126338607456, 0.7244905153472168 | 0.061770126338607473, 0.72449051534721676 | 1.355e-15 (exact 1.57e-15) |

   The values agree to about 1e-16. They also agree with Mathews' printed P0–P6 (gr_676).
3. **Reference values.** The root in the title and heading, (0.062, 0.724), is confirmed by the resultant computation: (0.06177012633860738, 0.7244905153472166). There are no other reference curves; the zero contours are drawn straight from F.
4. **Picture.** Frames 1, 2 and 7 were inspected, plus the contact sheet. Contour orientation is correct (Z indexed [y, x]; the blue curve passes (1, −0.794) as $f_1=0$ requires). The left title `X_k = (…)` shows the correct iterate with the correct index (X_6 = (0.0618, 0.7245)). The right panel plots residuals[0..k] against k, with the current point in red and title `||F(X_k)||`; every value lies within ylims 1e-16..1e1 and none is clamped. There are 7 frames for X0..X6. The only issue is the roundoff-level last residual (F1).

### `broydenbb.jl`

1. **Method.** Same code as `broydenaa.jl`; stops after X7.
2. **Numbers.**

   | k | script x, y | independent x, y | script ‖F‖ |
   |---|---|---|---|
   | 0 | 1.5, −0.5 | 1.5, −0.5 | 7.3154e-1 |
   | 1 | 1.5631443298969072, −0.5824742268041238 | 1.5631443298969072, −0.58247422680412371 | 1.0507e-1 |
   | 2 | 1.5553520368634492, −0.5751881059424518 | 1.5553520368634493, −0.57518810594245181 | 1.1090e-2 |
   | 3 | 1.5560954228565456, −0.5756271271156214 | 1.5560954228565456, −0.57562712711562125 | 5.2312e-5 |
   | 4 | 1.5560969549092851, −0.5756529705862952 | 1.5560969549092851, −0.57565297058629509 | 1.0562e-5 |
   | 5 | 1.5560974941407613, −0.5756507313269783 | 1.5560974941407613, −0.57565073132697842 | 1.9212e-7 |
   | 6 | 1.5560974843138242, −0.5756507696504695 | 1.5560974843138241, −0.57565076965046955 | 1.6032e-10 |
   | 7 | 1.5560974843220545, −0.5756507696188373 | 1.5560974843220547, −0.57565076961883714 | 2.956e-14 (exact 2.972e-14) |

   The values also match Mathews' printed P0–P7 (gr_682).
3. **Reference values.** The root (1.556, −0.576) is confirmed: (1.5560974843220530, −0.5756507696188434).
4. **Picture.** Frame 8 and the contact sheet of all 8 frames were inspected. X0 at (1.5, −0.5) is visible as a separate dot and later iterates sit on the intersection. Titles and indices are correct (X_7 = (1.5561, −0.5757), ||F(X_7)|| = 2.96e-14). The residual line shows the plateau from k=3 to k=4 that the page describes. There is no clamping and there are 8 frames.

### Reproducibility
Both committed GIFs are byte-identical to fresh runs of scratch copies (md5 0b31ab08… and c8f0075d…), as the manifest also reports.

### Legacy fidelity
The system is Mathews' (Examples 1, 3, 5 and 8 all use it). The starting points and iterates are those of the standard-Broyden comparison runs in Example 8 (gr_676, gr_682). Example 5's own starting points are unrecoverable because the images are missing, as the page says. Mathews' graph (gr_669) uses the opposite colours (closed curve blue) and a window of about [−1.5, 2]×[−1.2, 1]. The colour swap is labelled correctly on the page, so it is not a finding. The omitted examples and exercises are disclosed. There are no fidelity findings.

