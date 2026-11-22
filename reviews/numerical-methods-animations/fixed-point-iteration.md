# Fixed Point Iteration — animation review

Page: [`pages/numerical-methods/fixed-point-iteration/index.qmd`](../../pages/numerical-methods/fixed-point-iteration/index.qmd) · Scripts: `fixpointaa.jl`, `fixpointbb.jl`, `fixpointcc.jl`, `fixpointdd.jl`, `fixpointee.jl`, `fixpointff.jl` · GIFs: 6

**Result:** 4 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Case 6 GIF shows clamped iterates labelled as real values, and draws a 0↔4 bounce that does not exist

- **Location:** `fixpointff.jl:20-26` (`xs[i+1] = clamp(val, xlims[1], xlims[2])`), together with the label at `fixpointff.jl:62-63`. Visible in `fixpointff.gif` frames 5–11.
- **Now:** From x₄ on, the script stores the clamped value and keeps iterating from it. The legend shows `x_4 = 0.0`, `x_5 = 4.0`, `x_6 = 0.0`, `x_7 = 4.0`, `x_8 = 0.0`, `x_9 = 4.0`, `x_10 = 0.0`. The red marker jumps between the corners (0,0) and (4,4). The cobweb segments after step 3 run along the frame edges. A viewer would read this as a 2-cycle {0, 4}, or as values pinned at the window edge.
- **True:** The real orbit is x₄ = −0.57644, x₅ = 4.20515, x₆ = −2.52340, x₇ = 3.66982, x₈ = −1.20180, x₉ = 4.23982, x₁₀ = −2.61393. None of the labelled values from x₄ onward is correct. {0, 4} is not a cycle: g(0) = 4 but g(4) = −2. The only 2-cycles of g are {−2, 4} and the fixed points. The true orbit stays bounded and converges to an attracting 4-cycle {4.24996, −2.64052, 3.57717, −0.98762}. Its multiplier is ∏g' = −0.0305, so the cycle is stable.
- **Evidence:** `julia reviewer/print_iterates.jl` gives the script's xs: `1.5, 2.6875, 0.8506, 3.3938, 0.0, 4.0, 0.0, 4.0, 0.0, 4.0, 0.0`. The geometry check reports that segments 4, 6, 8 and 10 are not on the curve: they reach y = 0 where g(xv) = −0.576 or −2.0. `python3 -I reviewer/independent.py` gives the unclamped values listed above. `python3 -I reviewer/ff_longrun.py` gives min/max over 400 steps of −2.6405 and 4.2500, |x₄₀₀ − x₃₉₆| = 0, the 4-cycle and multiplier above, and g(g(x)) = x roots {−8, −2, 2, 4}.
- **Suggested fix:** Remove the clamp (`xs[i+1] = val`) and set `xlims = ylims = (-3.5, 4.5)`. The whole true orbit, [−2.6405, 4.2500], then fits on screen. Optionally raise `n_iters` to about 16. A trial copy, `reviewer/fixpointff_fixed.jl`, renders cleanly: the last frame shows the outward spiral settling onto the 4-cycle, labelled `x_16 = -0.9891`.

- **Independent check:** confirmed.

### F2 — Error — Implementation — Case 5 GIF parks the iterate at x = 4.0 for six frames and labels it as the real value

- **Location:** `fixpointee.jl:21-26` (clamp), with the label at `fixpointee.jl:63-64`. Visible in `fixpointee.gif` frames 4–9.
- **Now:** The legend reads `x_3 = 4.0`, `x_4 = 4.0`, …, `x_8 = 4.0`. The red marker sits still at (4,4) for six of the nine frames. That looks like the iteration has stalled or converged at x = 4, and so it contradicts the page's "diverges". The cobweb's third vertical segment stops at y = 4, although g(3.3838) = 4.5544.
- **True:** x₃ = 4.5544, x₄ = 7.4628, x₅ = 17.655, x₆ = 86.752, x₇ = 1924.8, x₈ = 927212. The iterates grow without bound and do not repeat.
- **Evidence:** `julia reviewer/print_iterates.jl` gives xs = `2.5, 2.8125, 3.3838, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0`, and segments 3–8 are not on the curve (g(xv) = 4.5544 and 6.0 where the drawn y is 4.0). `python3 -I reviewer/independent.py` gives the unclamped values above.
- **Suggested fix:** Remove the clamp so the axis clips the path naturally, and stop the animation once the iterate leaves the window. For example, set `n_iters = 3` and make the last frame show `x_3 = 4.5544 (off-scale)`. Alternatively widen the window to (0, 8) and use `n_iters = 4` (x₄ = 7.46). Do not label clamped values.

- **Independent check:** confirmed.

### F3 — Error — Page match — Case 4 says g is "tangent to y = x at x* = 2 from below"

- **Location:** index.qmd:48, "The curve $g(x) = \tfrac{x^2}{4} + \tfrac{x}{2}$ is tangent to $y = x$ at $x^* = 2$ from below."
- **Now:** The page says the curve is tangent to the diagonal.
- **True:** Tangency would require g'(2) = 1. In fact g'(2) = 3/2, so the curve crosses y = x at x = 2. It lies below y = x on (0, 2) and above it for x > 2. The very next sentence on the page states g'(2) = 3/2, which contradicts "tangent". The frames show the magenta curve crossing the green line at (2, 2).
- **Evidence:** `python3 -I reviewer/independent.py` gives g(2) = 2 and g'(2) = 3/2 for case dd. `committed/fixpointdd/frame_009.png` shows the crossing.
- **Suggested fix:** "The curve crosses $y = x$ at $x^* = 2$ (and again at $x = 0$); it lies below the diagonal for $0 < x < 2$."

- **Independent check:** confirmed.

### F4 — Error — Page match — Case 4 is headed "Divergent", but the iteration converges to the other fixed point x = 0

- **Location:** index.qmd:46, "### Case 4 — Divergent, …, $x_0 = 1.5$". Also the script comments at `fixpointdd.jl:3` ("Divergent case") and `fixpointdd.jl:12` ("diverges quickly off-scale").
- **Now:** The case is called divergent. The behaviour text (line 49) says only that the staircase "walks away from the fixed point toward the left". The page never mentions that g has a second fixed point at x = 0.
- **True:** The iteration is repelled from x* = 2, but it converges monotonically to x = 0. That fixed point is attracting, since g'(0) = 1/2: the iterates halve each step, with x₄₀/x₃₉ = 0.5000. The GIF itself ends at `x_8 = 0.0684`, heading visibly into the origin. No iterate leaves the window, so the clamp never fires and "diverges quickly off-scale" is false.
- **Evidence:** `python3 -I reviewer/independent.py` gives fixed points {0, 2} with g' = {1/2, 3/2}, iterates 1.5, 1.3125, …, 0.068368, and x₄₀ = 1.7e−11 with ratio 0.5. `julia reviewer/print_iterates.jl` shows no clamping: every segment is on the curve.
- **Suggested fix:** Change the heading to e.g. "Repelled from $x^*=2$, converges to $x=0$". Add a sentence: "the iterates move away from the unstable fixed point $x^*=2$ and converge to the other fixed point $x=0$, where $g'(0)=\tfrac12$." Correct the comments in `fixpointdd.jl` to match.

- **Independent check:** confirmed. Severity changed from Misleading to Error. Upgraded from Misleading by the director: the checker independently found the sequence converges to x*=0 (1.7e-11 at n=40), so the heading 'Divergent' is false about the computed sequence, not merely misleading.

### F5 — Misleading — Page match — Case 6 says the staircase "spirals outward"; the true orbit is bounded and settles onto a 4-cycle

- **Location:** index.qmd:67, "iteration diverges while oscillating — the staircase spirals outward from the fixed point."
- **Now:** The page implies unbounded outward growth.
- **True:** The sequence does fail to converge to x* = 2, and it alternates sides of 2 at every step. But it stays inside [−2.6405, 4.2500] and converges to the attracting 4-cycle {4.2500, −2.6405, 3.5772, −0.9876}. It does not keep spiralling outward. Once F1 is fixed so the true orbit is drawn, the GIF will show this.
- **Evidence:** `python3 -I reviewer/ff_longrun.py`, as in F1.
- **Suggested fix:** "…iteration does not converge: the staircase spirals away from $x^*=2$, alternating sides, and settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)."

- **Independent check:** confirmed with correction. Checker: the orbit does spiral outward from x*=2 for about the first 6 steps; the error is that it then stays bounded and settles on an attracting 4-cycle {4.2500, −2.6405, 3.5772, −0.9876}, so 'spirals outward' / 'diverges' wrongly implies unbounded divergence.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `fixpointaa.jl` | yes | 3.1 | fixpointaa.gif |
| `fixpointbb.jl` | yes | 3.1 | fixpointbb.gif |
| `fixpointcc.jl` | yes | 3.2 | fixpointcc.gif |
| `fixpointdd.jl` | yes | 2.9 | fixpointdd.gif |
| `fixpointee.jl` | yes | 2.9 | fixpointee.gif |
| `fixpointff.jl` | yes | 3.1 | fixpointff.gif |

Committed GIFs byte-identical to their regenerated output: **6 of 6**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | Diagram plots the identity line $y=x$ and $y=g(x)$ | All frames: green y = x, magenta g, both drawn with the case's g (code line `plot!(xplot, g.(xplot))`) | confirmed |
| 2 | 13–15 | Staircase: from $x_n$ on the diagonal, vertical to the curve to get $g(x_n)=x_{n+1}$, then horizontal back to the diagonal | print_iterates.jl: every vertical segment ends on g and every horizontal one on y = x, except where clamping applies (→ F1, F2) | confirmed (construction); clamped steps wrong → F1, F2 |
| 3 | 15 | Convergence occurs when $\lvert g'(x^*)\rvert<1$ | Standard local sufficient condition; consistent with cases 1–3 and with x = 0 in case 4 | confirmed |
| 4 | 17 | Julia source scripts are linked under each case | Lines 24, 33, 42, 51, 60, 69 link the scripts aa…ff; manifest shows each produces its GIF | confirmed |
| 5 | 19 | Case 1: Convergent staircase, $g(x)=\sqrt{2x}$, $x_0=0.1$ | fixpointaa.jl:10–11 | confirmed |
| 6 | 21 | $\sqrt{2x}$ intersects $y=x$ at $x^*=2$ | sympy: fixed points {0, 2} | confirmed |
| 7 | 22 | $g'(2)=\tfrac12<1$ | sympy g'(2) = 1/2 | confirmed |
| 8 | 22 | converges from below in a monotone staircase | Iterates 0.1 → 1.99854, all < 2 and increasing | confirmed |
| 9 | 24, 26 | Case 1 link/embed → fixpointaa.jl / .gif; alt text "x₀ = 0.1, starting below" | manifest; frame 1 label x₀ = 0.1 | confirmed |
| 10 | 28 | Case 2: $g(x)=\sqrt{2x}$, $x_0=3.8$, convergent | fixpointbb.jl:10–11; iterates 3.8 → 2.000313 | confirmed |
| 11 | 30–31 | starting above the fixed point; descends monotonically to $x^*=2$ | All iterates > 2 and decreasing | confirmed |
| 12 | 31 | confirming convergence from both sides | Cases 1 and 2 together | confirmed |
| 13 | 33, 35 | Case 2 link/embed and alt text (x₀ = 3.8, above) | manifest; frames | confirmed |
| 14 | 37 | Case 3: Oscillating convergent, $g(x)=8/(x+2)$, $x_0=1.0$ | fixpointcc.jl:11–12; iterates → 1.999707 | confirmed |
| 15 | 39 | $8/(x+2)$ strictly decreasing; $g'(2)=-\tfrac12$ | sympy g'(2) = −1/2; g' = −8/(x+2)² < 0 | confirmed |
| 16 | 40 | $\lvert g'(2)\rvert=\tfrac12<1$, converges, alternates sides of $x^*$ on each step | Side pattern −+−+−+−+−+−+− | confirmed |
| 17 | 42, 44 | Case 3 link/embed and alt text | manifest; frames | confirmed |
| 18 | 46 | Case 4 — Divergent, $g=x^2/4+x/2$, $x_0=1.5$ | Parameters match fixpointdd.jl:10–11; sequence converges to 0 | parameters confirmed; "Divergent" wrong → F4 |
| 19 | 48 | curve is tangent to $y=x$ at $x^*=2$ from below | g'(2) = 3/2 ≠ 1; the curve crosses | wrong → F3 |
| 20 | 49 | $g'(2)=\tfrac32>1$ | sympy | confirmed |
| 21 | 49 | staircase walks away from the fixed point toward the left | Iterates 1.5 → 0.0684, decreasing | confirmed (but ends at x = 0 → F4) |
| 22 | 51, 53 | Case 4 link/embed; alt text "divergent fixed point iteration … x₀ = 1.5" | Wiring correct; "divergent" as in F4 | wiring confirmed; "divergent" → F4 |
| 23 | 55 | Case 5 — Divergent, same g, $x_0=2.5$ | fixpointee.jl:11–12; true iterates → 9.3e5 by x₈ | confirmed |
| 24 | 58 | moves monotonically rightward and diverges | True iterates increase without bound; the GIF instead shows the iterate stuck at 4.0 | page confirmed; GIF contradicts it → F2 |
| 25 | 58 | showing instability from both sides | Cases 4 and 5 both move away from 2 | confirmed |
| 26 | 60, 62 | Case 5 link/embed and alt text | manifest | confirmed |
| 27 | 64 | Case 6 — Oscillating divergent, $g=-x^2/4-x/2+4$, $x_0=1.5$ | fixpointff.jl:11–12; orbit oscillates about 2 and does not converge to it | confirmed (non-convergent, oscillating) |
| 28 | 66 | steeply decreasing at $x^*=2$ (g(2) = 2) | g(2) = 2, g'(2) = −3/2 | confirmed |
| 29 | 67 | $g'(2)=-\tfrac32$, $\lvert g'(2)\rvert=\tfrac32>1$ | sympy | confirmed |
| 30 | 67 | diverges while oscillating — staircase spirals outward from the fixed point | Alternates sides at every step, but bounded and converges to a 4-cycle; the GIF shows a fake {0,4} bounce | partly wrong → F5; GIF → F1 |
| 31 | 69, 71 | Case 6 link/embed and alt text | manifest | confirmed |

## Implementation checks

### fixpointaa.jl
- Method: Plain fixed-point iteration x_{n+1} = g(x_n) with a standard cobweb, starting at (x₀, x₀), going vertical to (x_n, x_{n+1}) and then horizontal to (x_{n+1}, x_{n+1}). No clamping.
- Numbers: Script and independent values (mpmath) agree to every printed digit:
  - x₁ = 0.4472136 (script) vs 0.4472136 (mpmath)
  - x₄ = 1.6585006 vs 1.6585006
  - x₈ = 1.9767322 vs 1.9767322
  - x₁₂ = 1.9985378 vs 1.9985378

  Successive errors shrink by about 1/2, which matches g'(2) = 1/2.
- Reference values: The fixed point x* = 2 and g'(2) = 1/2 were checked with sympy. The script draws no reference marker.
- Picture: I viewed the contact sheet (frames 1, 3, 5, 7, 9, 11, 13). The staircase sits between the curve and the diagonal and approaches (2, 2). Labels match the xs values to 4 decimals. The first frame's label says "x₀" and the others say "x_n". That is cosmetic.

### fixpointbb.jl
- Method: Same as aa. No clamping.
- Numbers:
  - x₁ = 2.7568098 (script) vs 2.7568098 (mpmath)
  - x₄ = 2.0818628 vs 2.0818628
  - x₁₂ = 2.0003134 vs 2.0003134

  All agree.
- Reference values: x* = 2. The script has no explicit reference.
- Picture: I viewed the contact sheet. The descending staircase is drawn from (3.8, 3.8). Labels such as `x_8 = 2.005` and `x_12 = 2.0003` are correct roundings.

### fixpointcc.jl
- Method: Same as aa. No clamping.
- Numbers:
  - x₁ = 2.6666667 (script) vs 2.6666667 (mpmath)
  - x₂ = 1.7142857 vs 1.7142857
  - x₁₂ = 1.9997070 vs 1.999707

  All agree. The side pattern is −+−+…, and the error ratio is about −1/2.
- Reference values: Fixed points of g are 2 (g' = −1/2) and −4 (g' = −2, outside the window). Checked with sympy.
- Picture: I viewed the contact sheet. The nested "spiral box" closes on (2, 2). Labels such as `x_10 = 1.9988` are correct.

### fixpointdd.jl
- Method: Same as aa, with clamping to [0, 4]. The clamp never fires, because every iterate is in [0.068, 1.5].
- Numbers:
  - x₁ = 1.3125 (script) vs 1.3125 (mpmath)
  - x₃ = 0.83880258 vs 0.83880258
  - x₈ = 0.06836813 vs 0.06836813

  All agree. The sequence converges to x = 0 at rate 1/2 (→ F4).
- Reference values: Fixed points are 0 (g' = 1/2) and 2 (g' = 3/2). The comment at line 12, "diverges quickly off-scale", is false (→ F4).
- Picture: I viewed frame 9, the last. The curve crosses the diagonal at (2, 2), so it is not tangent (→ F3). The staircase descends into the origin. The label `x_8 = 0.0684` is correct.

### fixpointee.jl
- Method: Same as aa, with clamping to [0, 4]. The clamp fires from x₃ on.
- Numbers:

  | | Script | Unclamped (mpmath) |
  |---|---|---|
  | x₁ | 2.8125 | 2.8125 |
  | x₂ | 3.3837891 | 3.3837891 |
  | x₃ | 4.0 | 4.5544016 |
  | x₄ | 4.0 | 7.4628444 |
  | x₅ | 4.0 | 17.654934 |
  | x₈ | 4.0 | 927212.28 |

  x₃ to x₈ are wrong in the script (→ F2).
- Reference values: x* = 2 with g'(2) = 3/2, correct.
- Picture: I viewed frame 9, the last. The marker is parked at (4, 4) with label `x_8 = 4.0`. Frames 4–9 all show the same state (→ F2).

### fixpointff.jl
- Method: Same as aa, with clamping to [0, 4]. The clamp fires from x₄ on, and the iteration continues from the clamped values, so every later iterate is wrong (it is computed from a wrong value).
- Numbers:

  | | Script | Unclamped (mpmath) |
  |---|---|---|
  | x₁ | 2.6875 | 2.6875 |
  | x₂ | 0.8505859 | 0.85058594 |
  | x₃ | 3.3938329 | 3.3938329 |
  | x₄ | 0.0 | −0.57644194 |
  | x₅ | 4.0 | 4.2051496 |
  | x₆ | 0.0 | −2.5233957 |
  | x₇ | 4.0 | 3.6698164 |
  | x₈ | 0.0 | −1.2017963 |
  | x₉ | 4.0 | 4.2398196 |
  | x₁₀ | 0.0 | −2.6139273 |

  The true long-run behaviour is an attracting 4-cycle with multiplier −0.0305 (→ F1, F5).
- Reference values: Fixed points are 2 (g' = −3/2) and −8 (g' = 7/2). The 2-cycle {−2, 4} is unstable: its multiplier is (1/2)(−5/2) = −1.25.
- Picture: I viewed the contact sheet (all 11 frames) and frame 11 at full size. Frames 1–4 are correct. From frame 5 on, the path runs along the window edges and the marker alternates between (0,0) and (4,4) with false labels (→ F1). The trial fix in `reviewer/fixpointff_fixed.jl`, which removes the clamp and uses a window of (−3.5, 4.5), shows the correct orbit (`reviewer/ff_fixed_last.png`).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/fixed-point-iteration/`](evidence/fixed-point-iteration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
