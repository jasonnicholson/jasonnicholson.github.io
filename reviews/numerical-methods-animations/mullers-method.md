# Muller's Method — animation review

Page: [`pages/numerical-methods/mullers-method/index.qmd`](../../pages/numerical-methods/mullers-method/index.qmd) · Scripts: `mullersaa.jl`, `mullersbb.jl`, `mullerscc.jl` · GIFs: 3

**Result:** 3 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Case 1 is not Muller's method: every step has complex roots and the script silently keeps only the real part

- **Location:** `mullersaa.jl:29-31` (`D = sqrt(complex(b^2 - 4 * f2 * d))` … `return real(p2 - 2 * f2 / E)`). The same code is in `mullersbb.jl` and `mullerscc.jl`, but it only takes effect in case 1.
- **Now:** In case 1 the discriminant b² − 4·f₂·a is negative at **all 8 steps**. So the interpolating parabola has no real root, and Muller's next iterate is complex. The script throws away the imaginary part. Re of the root is −b/(2a) measured from p₂, so the stored "iterate" is the **vertex of the parabola**, not a root of it. The sequence shown (2.0, 1.2873, 1.15809, 1.0552, 1.01, 1.00168, 1.00011, 1.0, 1.0) belongs to a "real-part / vertex" variant. Muller's method does not produce it.
- **True:** True Muller (complex arithmetic) from (2.2, 2.1, 2.0) gives:
  - p₃ = 1.287302 + 0.356345i
  - p₄ = 1.053510 + 0.287163i
  - p₅ = 0.910715 + 0.153591i
  - p₆ = 0.899626 − 0.011015i
  - p₇ = 0.987007 + 0.032583i
  - p₈ = 0.994311 + 0.009817i
  - p₉ = 0.998526 + 0.002601i
  - p₁₀ = 1.000002 + 0.000561i

  It does converge to 1, but through complex iterates and more slowly over the first 8 steps (|err| = 5.6e-4 against the variant's 3.1e-8).
- **Evidence:**
  - `julia iter_aa.jl` prints these discriminants: −20.16, −3.909, −0.5667, −0.03021, −1.007e-3, −1.097e-5, −2.157e-8, −6.52e-12. It also prints complex next values whose imaginary parts are 0.356, 0.184, 0.0847, 0.0248, 4.9e-3, 5.4e-4, 2.4e-5, 4.3e-7, all discarded.
  - `python3 -I indep.py 8` in mode `real` reproduces the script's iterates to 1e-15, and each equals the parabola vertex (`vertex=` column identical). Mode `complex` gives the sequence above.
  - `julia para_aa.jl` gives the minimum of each drawn parabola as 0.80, 0.181, 0.0319, 2.16e-3, 7.8e-5, 8.9e-7, 1.8e-9, 5.4e-13. That is always > 0, and P(next iterate) equals that minimum.
  - Cases 2 and 3 have positive discriminants at every step, so `real()` has no effect there. My complex and real runs agree to 16 digits.
- **Suggested fix:** Pick one of these:
  - (a) Keep the variant, but say so in the page and the script comment: "when the parabola does not reach the axis (complex roots), this animation moves to the real part of the complex root, i.e. the parabola's vertex".
  - (b) Choose starting values for case 1 that bracket or straddle the root so the parabolas cross the axis. One way is to start on both sides of x = 1, but check that the discriminant stays ≥ 0.
  - (c) Run true complex Muller and show the real part while stating the imaginary part.

  At minimum the script should not take `real()` silently.

- **Independent check:** confirmed.

### F2 — Error — Page match — "the next iterate is found where the parabola crosses the x-axis" is false for Case 1

- **Location:** index.qmd:12, "The parabola (dashed blue) passes through the current triple $(p_0, p_1, p_2)$, and the next iterate is found where the parabola crosses the x-axis."
- **Now:** The page says this for every animation.
- **True:** In Case 1 none of the 8 parabolas crosses the x-axis, because f(x) = (x−1)²(x+2) ≥ 0 near the root and all three points lie above the axis. The next iterate is the x-coordinate of the parabola's minimum (see F1). Frame 2 of `mullersaa.gif` shows this: the dashed parabola turns upward near x ≈ 1, above the axis. The statement is true for Cases 2 and 3: P(next) ≈ 1e-16 to 1e-19 at every step.
- **Evidence:** `julia para_aa.jl` gives parabola minima of 0.80, 0.181, 0.0319, 2.16e-3, 7.8e-5, 8.9e-7, 1.8e-9 and 5.4e-13, all strictly positive. `para_bb.jl` and `para_cc.jl` give P(next iterate) at the 1e-16 level, so those parabolas do cross.
- **Suggested fix:** This follows from the choice made for F1. If case 1 is kept as is, add to the case 1 Behavior paragraph: "Because f ≥ 0 near this double root, none of the parabolas reaches the x-axis; their roots are complex, and the animation takes the real part (the parabola's vertex) as the next iterate."

- **Independent check:** confirmed.

### F3 — Error — Page match — Convergence order "≈ 1.84" is the simple-root order; at these double roots it is ≈ 1.23

- **Location:** index.qmd:18, "the iterates approach $p = 1$ with order $\approx 1.84$ convergence"; index.qmd:34, "Muller's method converges superlinearly with order $\approx 1.84$."
- **Now:** The page claims order 1.84 for both double-root cases.
- **True:** 1.84 is Muller's order at a **simple** root. At a double root the method is still superlinear, but the order is ≈ 1.234. That matches the real root of 2t³ − t² − t − 1 = 0, which is 1.23375.
  - Case 3: my 600-digit run gives local order estimates 1.191, 1.23, 1.119, 1.20, 1.212, 1.208 over the 8 animated steps. Asymptotically it settles at **1.234**, with log-ratio 1.234 at every step from k = 16 to 28.
  - Case 2: also 1.234 asymptotically, and 1.21 to 1.37 over the shown steps.
  - Case 1: the script's real-part variant runs at 1.04 to 1.76 over the shown steps and ≈ 1.325 asymptotically. True complex Muller is ≈ 1.234.
- **Evidence:** `python3 -I indep.py 40`, the `order~` column (the k = 16 to 28 lines are quoted above). The cubic's root came from `numpy.roots([2,-1,-1,-1])`, which gives 1.23375. The two numbers agree, so the conclusion does not rest on that formula.
- **Suggested fix:** Replace "with order ≈ 1.84" by "superlinearly (order ≈ 1.23 at a double root, below the 1.84 it achieves at a simple root)". Do this on line 18, keeping the Newton comparison, and on line 34. If F1 is resolved by keeping the vertex variant, do not quote an order for case 1, or quote the observed ≈ 1.3.

- **Independent check:** confirmed. Checker measured order ≈1.234 at the double roots (Cases 1 and 3); the script's real-part variant measures ≈1.3. The claim that it beats Newton's linear rate still holds.

### F4 — Minor — Page match — Case 3 heading says "double root near x = 2"

- **Location:** index.qmd:32, "### Case 3 — Convergent, $f(x) = x^6 - 7x^4 + 15x^2 - 9$, double root near $x = 2$". The script comment at `mullerscc.jl:4` says "near x=2 as stated in problem".
- **Now:** The heading says "near x = 2".
- **True:** The double root is √3 ≈ 1.7321, and the page's own body text (line 34) says so. f also has simple roots at x = ±1, so "near x = 2" is vague. It names a point 0.27 away from the root.
- **Evidence:** `python3 -I sym_newton.py` gives the factorisation (x−1)(x+1)(x²−3)², with real roots −√3, −√3, −1, 1, √3, √3.
- **Suggested fix:** Change the heading to "double root at $p = \sqrt{3}$", in line with the Case 1 and 2 headings.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Implementation — Case 1 first frame shows only two of the three points

- **Location:** `mullersaa.jl:16` (`ylims = (-8.0, 5.0)`) together with `p_init = [2.2, 2.1, 2.0]`
- **Now:** f(p₀) = f(2.2) = 6.048 is above the y-limit of 5, so p₀ is not drawn in frame 1. p₁ (f = 4.961) sits on the top border. The page tells readers "The gray dots are $p_0$ and $p_1$", but frame 1 shows only one gray dot. The drawn parabola segment [1.7, 2.5] also does not reach the next iterate, 1.2873.
- **True:** The opening triple is not fully visible.
- **Evidence:** `julia para_aa.jl` reports "points within ylims: 2/3" for frame 1. `committed/mullersaa/frame_001.png` shows a single gray dot at the top edge.
- **Suggested fix:** Raise the upper y-limit to about 7, for example `ylims = (-8.0, 7.0)`.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `mullersaa.jl` | yes | 3.2 | mullersaa.gif |
| `mullersbb.jl` | yes | 3.1 | mullersbb.gif |
| `mullerscc.jl` | yes | 3.1 | mullerscc.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "showing **Muller's Method** fitting a parabola through three successive approximations of a root" | All three scripts fit the interpolating quadratic through the last three iterates (Lagrange form, node mismatch 0 in `para_*.jl`). Case 1 iterates are not Muller's roots (complex discarded). | confirmed for 2, 3; wrong for 1 (→ F1) |
| 2 | 12 | "The parabola (dashed blue) passes through the current triple $(p_0, p_1, p_2)$" | `ls=:dash`, `color=:steelblue`; `para_*.jl` node mismatch 0.0 in every frame; seen in the frames | confirmed |
| 3 | 12 | "the next iterate is found where the parabola crosses the x-axis" | Case 1 parabolas never cross (min > 0); cases 2 and 3 have P(next) ≈ 1e-16 | wrong for case 1 (→ F2); confirmed for 2, 3 |
| 4 | 12 | "Each frame advances one iteration: the oldest point is dropped, and the new root estimate becomes $p_2$ (red dot)" | `history[i+1] = (q1, q2, q3)`; 9 frames = initial + 8 iterations; red scatter at q2 | confirmed |
| 5 | 12 | "The gray dots are $p_0$ and $p_1$." | `scatter!([q0,q1]...; color=:gray)`. In case 1 frame 1, p₀ is off-screen. | confirmed (minor display gap → F5) |
| 6 | 14 | "Julia source scripts … are linked under each case" | Links at lines 20, 28, 36 | confirmed |
| 7 | 16 | Case 1 heading: "Convergent, $f(x) = x^3 - 3x + 2$, double root at $p = 1$" | Script line 11 has this f. sympy factor (x−1)²(x+2), f'(1) = 0, f''(1) = 6. Iterates → 1 (3.1e-8). | confirmed |
| 8 | 18 | "converges to the double root $p = 1$ of $f(x) = (x-1)^2(x+2)$" | Same as 7 | confirmed (but via the vertex variant, F1) |
| 9 | 18 | "Starting near $p_2 = 2.0$" | `p_init = [2.2, 2.1, 2.0]` | confirmed |
| 10 | 18 | "with order $\approx 1.84$ convergence" | Observed 1.04 to 1.76 locally and 1.325 asymptotically (variant); 1.234 for true Muller | wrong (→ F3) |
| 11 | 18 | "faster than Newton's method, which has only linear convergence on double roots" | Newton from 2.0: error 5.1e-3 after 8 steps with ratio → 0.50. Script: 3.1e-8. | confirmed |
| 12 | 20, 22 | Case 1 link `mullersaa.jl`, embed `mullersaa.gif` | Manifest: mullersaa.gif is produced by mullersaa.jl, byte-identical; parameters match heading | confirmed |
| 13 | 22 | Alt: "converging to the double root at p = 1 starting from p₂ = 2.0" | As 7 and 9 | confirmed |
| 14 | 24 | Case 2 heading: "$f(x) = \sin(x^2 - 2)(x^2 - 2)$, double root at $p = \sqrt{2}$" | Script line 11. sympy: f(√2) = 0, f'(√2) = 0, f''(√2) = 16 ≠ 0. | confirmed |
| 15 | 26 | "converges to the double root $p = \sqrt{2} \approx 1.4142$" | √2 = 1.414214. Iterates → 1.414174 after 8 steps (err 3.9e-5) and to √2 at 600 digits by k = 28. | confirmed |
| 16 | 26 | "starting from $p_2 = 1.0$" | `p_init = [0.8, 0.9, 1.0]` | confirmed |
| 17 | 26 | "double root where $x^2 - 2 = 0$ since both factors vanish simultaneously" | u·sin u ≈ u² with u = x² − 2 having a simple zero; f''(√2) = 16 | confirmed |
| 18 | 26 | "Muller's method locates it efficiently despite the flat tangent at the root" | f'(√2) = 0 (flat tangent) confirmed. "Efficiently": 8 steps give err 3.9e-5, against Newton's 7.8e-4 from the same start. It is qualitative. | confirmed (qualitative) |
| 19 | 28, 30 | Case 2 link/embed `mullersbb.jl` / `mullersbb.gif` | Manifest byte-identical; parameters match | confirmed |
| 20 | 30 | Alt: "converging to the double root at p = sqrt(2) starting from p₂ = 1.0" | As 15 and 16 | confirmed |
| 21 | 32 | Case 3 heading: "$f(x) = x^6 - 7x^4 + 15x^2 - 9$, double root near $x = 2$" | f matches script line 12. Double root is √3 ≈ 1.732. | wrong/imprecise (→ F4) |
| 22 | 34 | "factors as $(x^2-1)(x^2-3)^2$" | sympy: (x−1)(x+1)(x²−3)² | confirmed |
| 23 | 34 | "double root at $p = \sqrt{3} \approx 1.7321$" | √3 = 1.7320508; f''(√3) = 48 ≠ 0 | confirmed |
| 24 | 34 | "Starting from $p_2 = 1.5$, Muller's method converges to the double root" | `p_init = [1.3, 1.4, 1.5]`. Iterates → 1.731988 (err 6.3e-5) after 8 steps and to √3 at 600 digits. Does not go to the nearby simple root 1. | confirmed |
| 25 | 34 | "Newton's method would converge linearly here" | Newton from 1.5: error ratios → 0.50 | confirmed |
| 26 | 34 | "Muller's method converges superlinearly with order $\approx 1.84$" | Superlinear, yes, but the order is 1.234 (local 1.12 to 1.23 over the shown steps) | wrong (→ F3) |
| 27 | 36, 38 | Case 3 link/embed `mullerscc.jl` / `mullerscc.gif` | Manifest byte-identical; parameters match | confirmed |
| 28 | 38 | Alt: "converging to the double root at p = sqrt(3) starting from p₂ = 1.5" | As 23 and 24 | confirmed |

The page has no Description section with formulas, so there was no method-description claim to check beyond line 12.

## Implementation checks

### mullersaa.jl
- **Method:**
  - The update is the standard Muller step. It takes first divided differences δ₀ and δ₁, the second divided difference d = f[p₀,p₁,p₂], b = δ₁ + h₁·d (= f[p₁,p₂] + (p₂−p₁)f[p₀,p₁,p₂]), and c = f₂. The step is p₃ = p₂ − 2c/(b ± √(b² − 4cd)), with the sign chosen to maximise |denominator| (line 30). All of that is correct.
  - However, line 31 returns `real(...)`. Here the discriminant is negative at every step, so the method run is the "real part of the complex Muller root", which is the parabola vertex (F1).
- **Numbers** (script, then my independent 600-digit `real`-mode value, then true complex Muller):

  | k | script | indep (real mode) | true complex Muller |
  |---|---|---|---|
  | 1 | 1.28730158730160 | 1.287301587301587 | 1.287302 + 0.356345i |
  | 2 | 1.15808780200354 | 1.158087802003536 | 1.053510 + 0.287163i |
  | 3 | 1.05520419279069 | 1.055204192790688 | 0.910715 + 0.153591i |
  | 4 | 1.00999919535373 | 1.009999195353728 | 0.899626 − 0.011015i |
  | 5 | 1.00168459149086 | 1.001684591490863 | 0.987007 + 0.032583i |
  | 6 | 1.00010790067738 | 1.00010790067738 | 0.994311 + 0.009817i |
  | 7 | 1.00000300572716 | 1.000003005727122 | 0.998526 + 0.002601i |
  | 8 | 1.00000003117352 | 1.00000003117406 | 1.000002 + 0.000561i |

  At k = 8 the script and my real-mode value differ in the 13th digit. That is floating-point cancellation near the double root, and it is invisible in the 5-decimal label.
- **Reference values:** The root 1 is a double root (sympy: (x−1)²(x+2), f''(1) = 6). The script draws no separate reference.
- **Picture:**
  - I looked at the contact sheet and at full frames 1, 2 and 9. The title function matches line 11.
  - The legend labels p₂ as 2.0, 1.2873, 1.15809, 1.0552, 1.01, 1.00168, 1.00011, 1.0, 1.0. These match `round(q2, 5)`.
  - The parabola passes through all three nodes (mismatch 0) and stays above the axis (frame 2 visibly).
  - Frame 1 hides p₀ above the y-limit (F5).
  - Clamping the parabola to the y-limits is only cosmetic. In frames 1 and 2 it trims the part above y = 5.

### mullersbb.jl
- **Method:** The step is identical to aa. The discriminant is positive at all 8 steps (14.39, 6.729, 1.459, 0.158, 0.0157, 9.1e-4, 2.9e-5, 4.7e-7), so `real()` has no effect and this is genuine Muller's method.
- **Numbers** (script, then independent):

  | k | script | indep |
  |---|---|---|
  | 1 | 1.25431599027444 | 1.254315990274436 |
  | 2 | 1.32229936655868 | 1.322299366558678 |
  | 3 | 1.36889662415287 | 1.368896624152871 |
  | 4 | 1.39705915655748 | 1.397059156557477 |
  | 5 | 1.40841296397692 | 1.408412963976924 |
  | 6 | 1.41269566543747 | 1.412695665437467 |
  | 7 | 1.41392368195523 | 1.413923681955231 |
  | 8 | 1.41417444320775 | 1.414174443207747 |

  All 8 agree. The order tends to 1.234.
- **Reference values:** √2 is a double root: f'(√2) = 0 and f''(√2) = 16 (sympy).
- **Picture:**
  - I looked at the contact sheet. Labels read 1.0, 1.25432, 1.3223, 1.3689, 1.39706, 1.40841, 1.4127, 1.41392, 1.41417, matching the script.
  - The parabola passes through the nodes, and in frames 2 to 8 it visibly dips below the axis at the next iterate.
  - In frame 1 the drawn segment [0.6, 1.2] stops short of the next iterate, 1.254. This is minor and not raised as a finding.
  - The final label 1.41417 differs from √2 = 1.41421 in the 5th decimal. That is a true reflection of 8 iterations with err 3.9e-5, and it is consistent with the page's "≈ 1.4142".

### mullerscc.jl
- **Method:** The step is identical to aa. The discriminant is positive at all 8 steps (45.1, 20.0, 4.89, 0.753, 0.0967, 8.0e-3, 4.1e-4, 1.2e-5), so this is genuine Muller's method.
- **Numbers** (script, then independent):

  | k | script | indep |
  |---|---|---|
  | 1 | 1.62764691360896 | 1.627646913608956 |
  | 2 | 1.67426828898318 | 1.674268288983181 |
  | 3 | 1.70348750470365 | 1.703487504703641 |
  | 4 | 1.72004722293375 | 1.720047222933741 |
  | 5 | 1.72750110119843 | 1.727501101198455 |
  | 6 | 1.73063056388586 | 1.730630563885695 |
  | 7 | 1.73170429346102 | 1.731704293461355 |
  | 8 | 1.73198779863839 | 1.731987798637548 |

  All agree. The order tends to 1.234.
- **Reference values:** The factorisation (x²−1)(x²−3)² is verified (sympy). √3 is a double root with f''(√3) = 48.
- **Picture:**
  - I looked at the contact sheet and full frame 9. The title function matches line 12.
  - The f curve is clamped to [−12, 20] only where |x| > ~2.2, which is cosmetic.
  - Labels read 1.5, 1.62765, 1.67427, 1.70349, 1.72005, 1.7275, 1.73063, 1.7317, 1.73199, matching the script.
  - The parabola passes through the nodes, and the next iterate lies inside the drawn range in every frame.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/mullers-method/`](evidence/mullers-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
