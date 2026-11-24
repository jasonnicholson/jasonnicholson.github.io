# Newton-Raphson Method — animation review (round 9)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation / display: `newtoncc.gif` legend prints `x₍6₎ = 0.0` and `x₍7₎ = -0.0` (Minor)

- **Location:** `newtoncc.jl` lines 57–58 and 60–61, `label="x₍$(frame)₎ = $(round(x_cur; digits=5))"`. It shows up in committed frames 7, 8 and 9 of `newtoncc.gif`.
- **Now:** frame 7 reads `x₍6₎ = 0.0`, frame 8 reads `x₍7₎ = -0.0` (confirmed in the crop `review/cc_f8_legend.png`) and frame 9 reads `x₍8₎ = 0.0`.
- **True:** x6 = 2.861054894e-6, x7 = −1.561293e-17 and x8 = 0.0 in Float64 (mpmath gives 2.5373e-51). The instrumented Julia run gives `labels: [... -0.01625, 0.0, -0.0, 0.0]`.
- **Why it matters (slightly):** rounding to 5 decimals is legitimate. Still, `x₆ = 0.0` suggests the root was reached exactly at step 6, and a printed `-0.0` is a floating-point artifact on a teaching graphic. It does not change any conclusion the page draws.
- **Suggested correction:** for this script, format the label in significant figures, for example `@sprintf("%.5g", x_cur)` (gives `2.8611e-06`, `-1.5613e-17`), or replace `round(...)` with `round(x_cur; sigdigits=5)` and add `+ 0.0` to remove the negative zero.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 6.8 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 7.4 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.7 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.8 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.8 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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
| 1 | Intro | "At each iterate $x_n$, a tangent line to $f(x)$ is drawn; its x-intercept gives $x_{n+1} = x_n - f(x_n)/f'(x_n)$" | All six scripts use `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`. The drawn segment runs from (x_n, f(x_n)) to (x_{n+1}, 0), and since x_{n+1} is the x-intercept of the tangent, that segment lies on the tangent line. Frames agree. | confirmed |
| 2 | Intro | Tangent lines show "converge to a root, fall into a cycle, or diverge" | Cases 1–3 converge, Case 4 cycles, Cases 5–6 diverge (see below) | confirmed |
| 3 | Intro | "Julia source scripts ... are linked under each case" | 6 links, one per case | confirmed |
| 4 | Case 1 heading | $f(x)=3e^x-4\cos x$, $x_0=1.0$, quadratic convergence | `newtonaa.jl` l.10, l.14. Errors 0.745, 0.225, 0.0309, 7.27e-4, 4.19e-7, 1.39e-13 (mpmath). Ratio e_{n+1}/e_n² tends to ≈0.79. | confirmed |
| 5 | Case 1 | "single positive root, $x^*\approx 0.2549$" | mpmath findroot gives 0.25485005903. The sign scan on [−20, 20] finds positive sign changes only at 0.2548. | confirmed |
| 6 | Case 1 | "infinitely many negative roots, outside the plotted window" | sign changes at −1.381, −4.719, −7.854, −10.996, …; as x→−∞, f ≈ −4cos x. The window is x∈[0, 1.5]. | confirmed |
| 7 | Case 1 | at $x_0=1$, $f>0$ and $f''>0$ | f(1)=5.9936, f''(1)=10.32, and f''>0 on [x*, 1] (7.73 at 0.25) | confirmed |
| 8 | Case 1 | "iterates decrease monotonically ... (1, 0.4798, 0.2857, 0.2556, 0.254850, …)" | Julia: 1.0, 0.479752, 0.285738, 0.255577, 0.2548505, 0.2548501 (mpmath identical) | confirmed |
| 9 | Case 1 | "number of correct digits roughly doubles each step" | correct digits ≈ 0.1, 0.6, 1.5, 3.1, 6.4, 12.9 | confirmed |
| 10 | Case 1 alt | "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | frames 1–6, last legend `x₍5₎ = 0.25485` | confirmed |
| 11 | Case 2 heading | $f(x)=(1-5x)^2$, $x_0=1.0$, linear convergence | `newtonbb.jl` l.11, l.15. fp = −10(1−5x) is correct. | confirmed |
| 12 | Case 2 | "double root at $x^*=0.2$", "$f'(x^*)=0$" | f(0.2)=0, f'(0.2)=0, f''=50≠0 | confirmed |
| 13 | Case 2 | "each step roughly halves the error" | errors 0.8, 0.4, 0.2, …, 1.953e-4: exactly halved (x_{n+1}−0.2 = (x_n−0.2)/2 analytically) | confirmed |
| 14 | Case 2 alt | "slow linear convergence to the double root at x=0.2" | 12 steps, final `x₍12₎ = 0.2002` | confirmed |
| 15 | Case 3 heading | $f=\arctan x$, $x_0=1.35$, convergence with oscillation | `newtoncc.jl` l.11, l.15. Iterates alternate in sign: 1.35, −1.28409, 1.12412, −0.78587, 0.29155, −0.01625, 2.86e-6, … | confirmed |
| 16 | Case 3 | "only root is $x^*=0$" | arctan is strictly increasing with arctan 0 = 0 | confirmed |
| 17 | Case 3 / 6 | converges only when $|x_0|<x_c\approx 1.3917$ | solved 2x = (1+x²)arctan x: x_c = 1.3917452003. Newton map for an odd increasing f: |g(x)|<|x| iff |x|<x_c. | confirmed |
| 18 | Case 3 | x0=1.35 "just inside", "converges but requires several oscillating steps" | |x_n| decreases slowly for 4 steps (1.35→1.28→1.12→0.79→0.29) and then converges fast | confirmed |
| 19 | Case 3 alt | "convergent case starting just inside the critical radius at x₀=1.35" | frames | confirmed |
| 20 | Case 4 heading | $f=x^3-x+3$, $x_0=0$, cycling / non-convergence | `newtondd.jl` l.12, l.16 | confirmed |
| 21 | Case 4 | one real root $x^*\approx-1.6717$ | mpmath polyroots: −1.6716998817 plus a complex pair 0.8358 ± 1.0469i | confirmed |
| 22 | Case 4 | root lies "at the left of the window" | xlims (−2, 3.5). The crossing is visible near −1.67 in every frame. | confirmed |
| 23 | Case 4 | "attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | after 200 iterations from 0: 0.0074461, 3.0004983, 1.9618967, 1.1475016. Cycle multiplier ∏g'(c_i) = 0.2325 (<1, attracting). The order matches g(0.0074)≈3.0005. | confirmed |
| 24 | Case 4 | "never approach the root" | the iterates stay in [0.0066, 3.0005]. The root is at −1.67. | confirmed |
| 25 | Case 4 alt | 4-cycle near 0.0074, 3.0005, 1.9619, 1.1475 | last frames show `x₍8₎ = 0.0073`, `x₍9₎ = 3.0005`, `x₍10₎ = 1.9619` (approaching the cycle) | confirmed |
| 26 | Case 5 heading | $f=xe^{-x}$, $x_0=2.0$, divergence to infinity | `newtonee.jl` l.11, l.15 | confirmed |
| 27 | Case 5 | only root 0, maximum of f at x=1 | f'=(1−x)e^{−x}, zero only at 1. xe^{−x}=0 only at 0. | confirmed |
| 28 | Case 5 | $x_{n+1}=x_n^2/(x_n-1) > x_n$ | algebra: x − x/(1−x) = x²/(x−1), and this exceeds x iff x>0 (for x>1). Numerically 4 = 2²/1, 5.333 = 16/3. | confirmed |
| 29 | Case 5 | "(2, 4, 5.33, 6.56, …, 10.02 after six steps)" | 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 | confirmed |
| 30 | Case 5 | "$f(x_n)\to 0$" | 0.2707, 0.0733, 0.0257, 0.00926, 0.00336, 0.00122, 4.46e-4 | confirmed |
| 31 | Case 5 alt | each tangent meets the axis further right | frames 1–7. x6 = 10.02 lies inside xlims (0, 11). | confirmed |
| 32 | Case 6 heading | $f=\arctan x$, $x_0=1.4$, divergent | `newtonff.jl` l.11, l.15 | confirmed |
| 33 | Case 6 | 1.4 "just outside" $x_c\approx1.3917$ | 1.4 > 1.39175 | confirmed |
| 34 | Case 6 | "do not converge ... escape toward larger |x|" | |x_n|: 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103 (alternating sign) | confirmed |
| 35 | Case 6 alt | "divergent case starting just outside the critical radius" | the last frame labels `x₍6₎ = 8.71 (out of range)`, which is honest because the label shows the real value | confirmed |
| 36 | Wiring | Each case links and embeds its own script and GIF (aa..ff in order) | index.qmd l.23/25, 31/33, 40/42, 49/51, 58/60, 67/69. The function and x0 in each script match its heading. GIF titles show the matching f. | confirmed |
| 37 | Fidelity | Cases correspond to Mathews Examples 3–8 | archive formula images (above) | confirmed |

There is no separate Description section on the page. The only method formula is the update rule in the intro (ledger #1).

---

### 3. Implementation checks

All six scripts implement plain Newton-Raphson, x_{n+1} = x_n − f(x_n)/f'(x_n), with an analytic derivative and a fixed iteration count. None has a safeguard, damping or a hybrid step, so the method matches the page title.

Analytic derivatives were checked against mpmath numerical differentiation, because the independent iteration uses `mp.diff` and its iterates match the scripts' to every printed digit:
- aa: 3eˣ + 4 sin x ✓
- bb: −10(1−5x) ✓
- cc/ff: 1/(1+x²) ✓
- dd: 3x²−1 ✓
- ee: (1−x)e^{−x} ✓

Script iterates (Julia, from instrumented copies) set beside the independent values (mpmath, 40 digits):

| Script | Julia iterates | mpmath iterates | Agreement |
|---|---|---|---|
| newtonaa | 1.0, 0.47975201560572, 0.28573835913113, 0.25557690047166, 0.25485047773433, 0.25485005902899 | 1.0, 0.479752015606, 0.285738359131, 0.255576900472, 0.254850477734, 0.254850059029 | all digits |
| newtonbb | 1.0, 0.6, 0.4, 0.3, 0.25, 0.225, …, 0.2001953125 | identical (exact dyadic) | exact |
| newtoncc | 1.35, −1.28409114963, 1.12412310647, −0.78587188100, 0.29155397739, −0.01625100144, 2.8610549e-6, −1.5613e-17, 0.0 | same; last value 2.537e-51 (Float64 underflows the cube of 1.56e-17 to 0) | yes |
| newtondd | 0, 3, 1.96153846, 1.14717596, 0.00657937, 3.00038907, 1.96181818, 1.14743023, 0.00725625, 3.00047319, 1.96187865 | identical to 9+ digits | yes |
| newtonee | 2, 4, 5.33333, 6.56410, 7.74383, 8.89211, 10.01882 | identical | yes |
| newtonff | 1.4, −1.41361865, 1.45012931, −1.55062598, 1.84705408, −2.89356239, 8.71032585 | identical | yes |

**Reference values.** The scripts draw no separate reference curve or root. The roots quoted on the page (0.2549, 0.2, 0, −1.6717, 0) and the critical radius 1.3917 were each verified independently (ledger #5, 12, 16, 17, 21, 27).

**Picture checks**, from contact sheets of all frames:
- **aa:** 6 frames (x0..x5). The tangents run from the curve point to the axis, with a vertical drop to the next curve point. The red marker sits at (x_n, f(x_n)) and the legend values match the iterates. The window [0, 1.5]×[−2, 10] contains every point (f(1)=5.99).
- **bb:** 13 frames. f(1)=16 is within ylim 18 and all segments are visible. The legend reaches `x₍12₎ = 0.2002`.
- **cc:** 9 frames, and all iterates lie within [−3, 2.5], so the visibility guard never hides a segment. The legend uses 5 decimals, which gives F1 (`0.0`, `-0.0`).
- **dd:** 11 frames. `clamp` never activates, because the largest f(x_n) is 27.012, below ylim 30. All iterates are inside [−2, 3.5]. The real root crossing is visible.
- **ee:** 7 frames. All iterates are ≤ 10.02 < 11, so the "→ ∞" fallback label is never used. The peak 0.368 is inside ylim 0.42.
- **ff:** 7 frames. The last tangent from (−2.894, −1.238) toward 8.71 is clipped at x=5 by the axis limits, and its slope is correct (1/(1+2.894²)=0.1067). The out-of-window iterate is labelled with its true value, `8.71 (out of range)`, not a clamped position.

Frame counts equal n_iters+1 for every script, which matches the manifest (6, 13, 9, 11, 7, 7).

Script header comments were checked and agree with the computation:
- bb: "rate 1/2 per step" ✓
- cc: "just below the divergence threshold" ✓
- dd: the 4-cycle values ✓
- ee: "diverge to +infinity from x0 > 1" ✓
- ff: "oscillates with growing amplitude" ✓

