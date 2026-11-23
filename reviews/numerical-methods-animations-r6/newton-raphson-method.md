# Newton-Raphson Method — animation review (round 6)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Every numerical value the page states, every behaviour claim and every case's wiring checked out against an independent 40–50-digit mpmath computation and against the frames (details below). I also looked at some things and decided they were not findings:

- `newtoncc.gif` frames 6–8 label the iterate as `0.0`, `-0.0`, `0.0`. The true values are 2.86e-6, -1.56e-17 and 0 (Float64 underflow; the exact value is 2.5e-51). That is `round(…; digits=5)`: the display is correct to the stated 5 decimals, so this is cosmetic and changes no conclusion.
- `newtonff.gif`'s last frame: x₆ = 8.71 is outside xlims (-4, 5). The tangent segment is clipped at the frame edge, and the legend reads "x₍6₎ = 8.71 (out of range)" with the true value. This is honest; it is not a clamped value posing as the real one.
- `newtondd.jl` clamps y to ylims, but no plotted value exceeds them (max f = 27.012 < 30), so the clamp never fires.
- Case 4's window (-2, 3.5) is wider than the legacy plot (0 to 3). The script header says this is to show the real root. That is a justified departure, not a fidelity issue.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 5.8 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 7.4 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.8 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.3 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.2 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 7.3 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Abbreviations: "mp" = independent mpmath Newton run (`indep.py`, derivative via `mp.diff`, not the script's `fp`); "jl" = instrumented script copy (`inst_*.jl`); "fr" = committed frames.

### Introduction
| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | "At each iterate $x_n$, a tangent line to $f(x)$ is drawn; its x-intercept gives $x_{n+1} = x_n - f(x_n)/f'(x_n)$" | All six scripts use `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`. The drawn segment runs from (xₙ, f(xₙ)) to (xₙ₊₁, 0), so its slope is f(xₙ)/(xₙ−xₙ₊₁) = f′(xₙ) by construction. All `fp` functions are correct: script iterates equal mp iterates computed with numerical derivatives. In the frames the segments are tangent to the curve. | confirmed |
| I2 | "The sequence of tangent lines traces the convergence (or divergence) toward a root" | fr: all six | confirmed |
| I3 | Julia source scripts linked under each case | 6 links, each to the right script (see wiring rows) | confirmed |

### Case 1: `newtonaa`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | Heading: f(x) = 3eˣ − 4cos(x), x₀ = 1.0 | `newtonaa.jl` L10, L14; title in frames; legacy Example 3 / Newtonaa.gif uses the same f and p₀ = 1 | confirmed |
| 1b | "Quadratic convergence" | mp errors 0.745, 0.225, 0.0309, 7.27e-4, 4.19e-7, 1.39e-13; eₙ₊₁/eₙ² → 0.7933 = f″/(2f′) at the root (theory 0.7933) | confirmed |
| 1c | "a single positive root, x* ≈ 0.2549" | mp root 0.254850059028850; f′ > 0 for x > 0, so the positive root is unique | confirmed |
| 1d | "infinitely many negative roots, outside the plotted window" | mp roots -1.38121, -4.71908, -7.85369, -10.99559, …; xlims = (0, 1.5) | confirmed |
| 1e | x₀ "on the convex side … each tangent line lands between the root and the previous iterate, so the iterates decrease monotonically" | f″ = 3eˣ+4cos x > 0 on [x*, 1]; iterates strictly decreasing and all > x* (mp, jl) | confirmed |
| 1f | iterates "(1, 0.4798, 0.2857, 0.2556, 0.254850, …)" | mp/jl: 1, 0.479752, 0.285738, 0.255577, 0.2548505 | confirmed |
| 1g | "number of correct digits roughly doubles each step" | -log10 of the errors: 0.13, 0.65, 1.51, 3.14, 6.38, 12.86 | confirmed |
| 1h | Alt text: "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | as above; fr: final label x₍5₎ = 0.25485 | confirmed |
| 1i | Wiring: link `newtonaa.jl`, embed `newtonaa.gif` | page L23, L25; manifest: GIF byte-identical to regen of `newtonaa.jl` | confirmed |

### Case 2: `newtonbb`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | Heading: f(x) = (1−5x)², x₀ = 1.0 | L11, L15; legacy Example 4 formula image: 1 − 10x + 25x² = 0, p₀ = 1.0 | confirmed |
| 2b | "A double root at x* = 0.2" | f = 25(x−0.2)² | confirmed |
| 2c | "f′(x*) = 0 … degrades to linear convergence" | error ratios (mp) exactly 0.5 for all 12 steps | confirmed |
| 2d | "each step roughly halves the error" | ratio exactly 1/2; iterates 1, 0.6, 0.4, 0.3, 0.25, 0.225, … 0.2001953125 | confirmed |
| 2e | Alt text: "slow linear convergence to the double root at x=0.2" | fr: final label x₍12₎ = 0.2002 | confirmed |
| 2f | Wiring | page L31, L33; manifest byte-identical | confirmed |

### Case 3: `newtoncc`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | Heading: f(x) = arctan(x), x₀ = 1.35, "Convergent" | L11, L15; legacy Example 5 formula image: ArcTan[x] = 0, p₀ = 1.35 | confirmed |
| 3b | "near inflection point" | arctan's inflection point is x = 0 (the root); defensible label | confirmed |
| 3c | "The only root is x* = 0" | arctan is strictly increasing | confirmed |
| 3d | "converges only when \|x₀\| < x_c ≈ 1.3917" | x_c solves 2x = (1+x²)arctan x: mp 1.39174520027; \|N(x)\| < \|x\| on a 999-point grid of (0, x_c) and \|N(x)\| > \|x\| on 1999 points of (x_c, 3x_c); N(x_c) = −x_c (2-cycle) | confirmed |
| 3e | "x₀ = 1.35 (just inside the convergence radius)" | 1.35 < 1.39175 | confirmed |
| 3f | "converges but requires several oscillating steps before settling in" | mp/jl: 1.35, −1.28409, 1.12412, −0.78587, 0.29155, −0.01625, 2.86e-6, −1.56e-17, ~0; the sign alternates every step | confirmed |
| 3g | Alt text: "convergent case starting just inside the critical radius at x₀=1.35" | as above | confirmed |
| 3h | Wiring | page L40, L42; manifest byte-identical | confirmed |

### Case 4: `newtondd`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 4a | Heading: f(x) = x³ − x + 3, x₀ = 0.0, "Cycling (non-convergence)" | L12, L16; legacy Newtondd.gif: same f, p₀ = 0 | confirmed |
| 4b | "f has one real root, x* ≈ −1.6717" | discriminant −4p³−27q² = −239 < 0, so one real root; mp −1.67169988 | confirmed |
| 4c | "where the curve crosses the axis at the left of the window" | xlims (−2, 3.5); fr: the crossing is visible near −1.67 | confirmed |
| 4d | "drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | mp fixed point of N⁴: 0.0074461 → 3.0004983 → 1.9618967 → 1.1475016; cycle multiplier ∏N′ = 0.2325 < 1, so attracting; distance to the cycle shrinks 8.7e-4 → 1.9e-4 per lap (ratio ≈ 0.22) | confirmed |
| 4e | "never approach the root" | jl iterates: 0, 3, 1.96154, 1.14718, 0.00658, 3.00039, 1.96182, 1.14743, 0.00726, 3.00047, 1.96188 | confirmed |
| 4f | Alt text: "settle into a 4-cycle near 0.0074, 3.0005, 1.9619 and 1.1475 and never reach the real root at x≈−1.6717" | as above; fr labels x₍8₎ = 0.0073, x₍9₎ = 3.0005, x₍10₎ = 1.9619 | confirmed |
| 4g | Wiring | page L49, L51; manifest byte-identical | confirmed |

### Case 5: `newtonee`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 5a | Heading: f(x) = xe^{−x}, x₀ = 2.0, "Divergence to infinity" | L11, L15; legacy Newtonee.gif: same f, p₀ = 2 | confirmed |
| 5b | "only root is x* = 0" | xe^{−x} = 0 only at x = 0 | confirmed |
| 5c | "x₀ = 2 lies beyond the maximum of f at x = 1" | f′(1) = 0, f″(1) < 0 | confirmed |
| 5d | "there f > 0 and f′(x) = (1−x)e^{−x} < 0" | true for x > 1; the script's `fp` matches | confirmed |
| 5e | "x_{n+1} = x_n²/(x_n − 1) > x_n" | closed form equals the Newton step to 8 significant figures for every step (`props.py`); x² > x(x−1) for x > 1 | confirmed |
| 5f | "(2, 4, 5.33, 6.56, …, 10.02 after six steps)" | mp/jl: 2, 4, 5.33333, 6.56410, 7.74383, 8.89211, 10.01882; n_iters = 6 | confirmed |
| 5g | "while f(x_n) → 0" | f: 0.271, 0.0733, 0.0257, 0.00926, 0.00336, 0.00122, 0.000446 | confirmed |
| 5h | Alt text: "each tangent line meets the axis further right, and the iterates move away from the root at x=0 toward +∞" | fr: all 6 tangents visible in xlims (0, 11), each landing further right | confirmed |
| 5i | Wiring | page L58, L60; manifest byte-identical | confirmed |

### Case 6: `newtonff`
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 6a | Heading: f(x) = arctan(x), x₀ = 1.4, "Divergent" | L11, L15; legacy Newtonff.gif: tan⁻¹(x), p₀ = 1.4 | confirmed |
| 6b | "just outside the critical convergence radius x_c ≈ 1.3917" | 1.4 > 1.391745 | confirmed |
| 6c | "do not converge to the root; they escape toward larger \|x\|" | mp/jl: 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033; \|x\| strictly increasing | confirmed |
| 6d | Alt text: "divergent case starting just outside the critical radius at x₀=1.4" | as above | confirmed |
| 6e | Wiring | page L67, L69; manifest byte-identical | confirmed |

### Counts and fidelity
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1 | Six cases, each with one script and one GIF | 6 headings, 6 links, 6 embeds; manifest finds no inventory issues | confirmed |
| F1 | Cases correspond to Mathews' Animations 1–6 (Examples 3–8) | the legacy function/p₀ for all six matches (formula images for 4 and 5; GIF frames for 1, 4, 5, 6); legacy iterate printouts match mp (e.g. legacy p₆ = 0.254850059028850; dd p₈ = 0.00726; ee p₆ = 10.01880; ff p₆ = 8.71033). No legacy case is dropped. | confirmed |

The page has no Description section with formulas beyond the intro formula (I1), so there are no further method-description claims to check.

---

### 3. Implementation checks

All six scripts are the same plain Newton-Raphson loop, `x ← x − f(x)/fp(x)`, with no safeguards, damping or variants. That is the method the title names.

| Script | Method | `fp` correct | Script iterates (jl) vs independent mp | Reference values | Picture |
|---|---|---|---|---|---|
| newtonaa | plain Newton | 3eˣ+4 sin x ✓ | jl 1, 0.47975201560571856, 0.28573835913112816, 0.2555769004716556, 0.2548504777343278, 0.25485005902898933; mp 1, 0.479752015606, 0.285738359131, 0.255576900472, 0.254850477734, 0.254850059029. Agree to every printed digit. | page root 0.2549 vs mp 0.25485005903 ✓ | fr 1, 3, 6: tangents tangent to the curve, vertical drops at xₙ₊₁, red dot at (xₙ, f(xₙ)), label index = frame = iterate index ✓ |
| newtonbb | plain Newton | −10(1−5x) ✓ | jl and mp identical: 1, 0.6, 0.4, 0.3, …, 0.2001953125 (exact binary halving) | x* = 0.2 exact ✓ | fr 1, 3, 13 ✓ |
| newtoncc | plain Newton | 1/(1+x²) ✓ | jl 1.35, −1.2840911496, 1.1241231065, −0.7858718810, 0.2915539774, −0.0162510014, 2.8610549e-6, −1.5613e-17, 0.0; mp identical to 10 digits (mp x₈ = 2.5e-51, Float64 underflow to 0) | x_c = 1.39174520027 (mp, solves 2x = (1+x²)atan x) ✓ | fr 1, 4, 9: all iterates inside xlims (−3, 2.5), so the visibility guard never hides anything ✓ |
| newtondd | plain Newton | 3x²−1 ✓ | jl 0, 3, 1.9615384615, 1.1471759614, 0.0065793715, 3.0003890741, 1.9618181757, 1.1474302285, 0.0072562476, 3.0004731888, 1.9618786464; mp identical to 10 digits | root −1.67169988 ✓; 4-cycle 0.0074461/3.0004983/1.9618967/1.1475016, multiplier 0.2325 ✓ | fr 1, 6, 11: the clamp never fires (max f 27.01 < 30); the root crossing is visible ✓ |
| newtonee | plain Newton | (1−x)e^{−x} ✓ | jl 2, 4, 5.333333, 6.564103, 7.743826, 8.892110, 10.018819; mp identical; matches the closed form x²/(x−1) | root 0 ✓ | fr 1, 4, 7: every iterate within xlims (0, 11), so the "→ ∞" fallback label is never used ✓ |
| newtonff | plain Newton | 1/(1+x²) ✓ | jl 1.4, −1.4136186488, 1.4501293146, −1.5506259756, 1.8470540842, −2.8935623931, 8.7103258470; mp identical to 10 digits | x_c ✓ | fr 1, 5, 7: x₆ = 8.71 is off-window, its tangent is clipped at the edge, and the legend gives the true value with "(out of range)" ✓ |

Commands run:
- `julia inst_<s>.jl` for s ∈ {aa…ff}: script copies with `println(xs); println(f.(xs)); exit()` inserted before the animation block.
- `/usr/bin/python3 -I indep.py`: mpmath Newton runs at dps = 50 with `mp.diff` derivatives, plus roots, x_c, the 4-cycle and its multiplier.
- `/usr/bin/python3 -I props.py`: arctan contraction/expansion on either side of x_c, the quadratic-rate constant for Case 1, the error-halving ratio for Case 2, the discriminant for Case 4, and the closed form for Case 5.
- `giftools.jl` on the legacy Newton{aa,dd,ee,ff}.gif, then visual comparison.
- I viewed the contact sheets of all six committed GIFs, which cover every frame.

Nothing was left undetermined.

