# Newton-Raphson Method — animation review (round 3)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Every checkable claim on the page, every legend value in the frames, and every script parameter agreed with an independent high-precision computation. Details follow in the ledger and in the implementation checks.

Notes that are not findings, listed so the owner knows they were looked at:
- The page has no `## Description` section, although `.github/agents/animation-page.agent.md` (lines 12, 99, 205) requires one. The review standard says content the page does not yet have is not a finding. It also means there are no Description formulas to check against the scripts.
- `newtoncc.gif` frames 7–8 show legend labels `x₍6₎ = 0.0` and `x₍7₎ = -0.0`. The true values are 2.86e-6 and -1.56e-17, so these are correct at 5 decimals. The `-0.0` is a signed-zero artefact. It is cosmetic and does not mislead.
- The Case 3 heading says "Convergent near inflection point". The only inflection point of arctan is x = 0, which is also the root. The starting point 1.35 is not near it. The heading is defensible, because the iteration converges to an inflection-point root, but it is less informative than Mathews' "Convergence, Oscillation". I judged it not misleading enough to report.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 5.9 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.7 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.6 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.3 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.4 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 7.0 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key: **I** = independent mpmath Newton iteration at 40 digits (`review/indep.py`), using `mp.diff` for f′ so it does not rely on the scripts' hand-coded derivatives; **S** = instrumented scratch copies of the scripts (`review/inst_*.jl`) printing iterates; **C** = `review/checks.py` (sympy/mpmath); **F** = committed frames.

### Introduction
| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| 1 | "Each animation below shows the tangent-line diagram" | confirmed | F: all 6 GIFs draw the segment (xₙ,f(xₙ))→(xₙ₊₁,0) plus a vertical drop |
| 2 | "At each iterate xₙ, a tangent line to f(x) is drawn; its x-intercept gives xₙ₊₁ = xₙ − f(xₙ)/f′(xₙ)" | confirmed | The segment runs from (xₙ,f(xₙ)) to (xₙ₊₁,0), with xₙ₊₁ computed by exactly this formula (every script, line ~26). The hand-coded fp matches a central difference to within 4e-9 (S). Its slope is therefore f′(xₙ), so it lies on the tangent line. |
| 3 | "Julia source scripts … are linked under each case" | confirmed | 6 links, each to the right script (see wiring below) |

### Case 1: `newtonaa`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 4 | Heading: f(x)=3eˣ−4cos(x), x₀=1.0 | confirmed | newtonaa.jl lines 10, 14. The GIF title matches. Same as Mathews Example 3 (`3 Exp[x] - 4 Cos[x]`, p₀=1.0). |
| 5 | "Quadratic convergence" | confirmed | C: eₙ₊₁/eₙ² = 0.405, 0.611, 0.762, 0.7926, 0.7933, which tends to f″/(2f′)(x*) = 0.79333 |
| 6 | "single positive root, x* ≈ 0.2549" | confirmed | I: x* = 0.25485005902885. f′ = 3eˣ+4sin x > 0 for x ≥ 0, so f has only one positive root. |
| 7 | "infinitely many negative roots, outside the plotted window" | confirmed | 3eˣ→0 while cos x oscillates, so there are infinitely many roots. The largest negative root is −1.3812 (C), outside xlims (0, 1.5). |
| 8 | "x₀=1.0 on the convex side of the root" | confirmed | C: min f″ on [x*,1] = 7.74 > 0, and f(1) > 0 |
| 9 | "each tangent line lands between the root and the previous iterate … decrease monotonically" | confirmed | I: 1 > 0.47975 > 0.28574 > 0.25558 > 0.2548505 > 0.25485006, all above x* |
| 10 | Listed iterates "1, 0.4798, 0.2857, 0.2556, 0.254850" | confirmed | I: 1, 0.4797520, 0.2857384, 0.2555769, 0.2548505. S is the same to 1e-15. |
| 11 | "number of correct digits roughly doubles each step" | confirmed | C: −log₁₀|e| = 0.13, 0.65, 1.51, 3.14, 6.38, 12.9 |
| 12 | Alt: "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | confirmed | F frames 1–6. Legend values 1.0, 0.47975, 0.28574, 0.25558, 0.25485, 0.25485 match I. |
| 13 | Wiring: link `newtonaa.jl`, embed `newtonaa.gif` | confirmed | Manifest: the GIF is produced by newtonaa.jl and is byte-identical to a regeneration |

### Case 2: `newtonbb`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 14 | Heading: f(x)=(1−5x)², x₀=1.0 | confirmed | newtonbb.jl lines 11, 15. Matches Mathews Example 4 (`1 − 10x + 25x²`, p₀=1.0). |
| 15 | "Linear convergence (double root)" / "double root at x*=0.2" | confirmed | (1−5x)² has a root of multiplicity 2 at 0.2 |
| 16 | "f′(x*)=0" | confirmed | f′ = −10(1−5x) = 0 at x = 0.2 |
| 17 | "degrades to linear convergence — each step roughly halves the error" | confirmed | C: the Newton map simplifies to g(x) = x/2 + 1/10, so eₙ₊₁ = eₙ/2 exactly. I: 1, 0.6, 0.4, 0.3, 0.25, …, 0.2001953125. |
| 18 | Alt: "slow linear convergence to the double root at x=0.2" | confirmed | F: frame 13 legend `x₍12₎ = 0.2002` (true 0.2001953) |
| 19 | Wiring | confirmed | Manifest, byte-identical regeneration |

### Case 3: `newtoncc`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 20 | Heading: f(x)=arctan(x), x₀=1.35 | confirmed | newtoncc.jl lines 11, 15. Matches Mathews Example 5 (`ArcTan[x]`, p₀=1.35). |
| 21 | "Convergent near inflection point" | confirmed (see the note in §1) | The root 0 is arctan's inflection point, and the iteration converges to it |
| 22 | "The only root is x* = 0" | confirmed | arctan is strictly increasing, with arctan 0 = 0 |
| 23 | "converges only when \|x₀\| < x_c ≈ 1.3917" | confirmed | C: x_c solves 2x = (1+x²)arctan x, giving x_c = 1.3917452. Iterating from 1.3917 converges to 0. From 1.3918 the iterates pass 4.7e7 by step 14. |
| 24 | "x₀ = 1.35 (just inside the convergence radius)" | confirmed | 1.35 < 1.39175 |
| 25 | "converges but requires several oscillating steps before settling in" | confirmed | I: 1.35, −1.2841, 1.1241, −0.7859, 0.2916, −0.01625, 2.86e-6, −1.56e-17, 2.5e-51. The sign alternates, with four large-amplitude swings before rapid convergence. |
| 26 | Alt: "convergent case starting just inside the critical radius at x₀=1.35" | confirmed | F frames 1–9. Legend values match I to 5 decimals. |
| 27 | Wiring | confirmed | Manifest |

### Case 4: `newtondd`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 28 | Heading: f(x)=x³−x+3, x₀=0.0 | confirmed | newtondd.jl lines 12, 16. Matches Mathews Example 6 (`x³ − x + 3`, p₀=0.0). |
| 29 | "Cycling (non-convergence)" | confirmed | See 32 |
| 30 | "f has one real root, x* ≈ −1.6717" | confirmed | C: discriminant −239 < 0, so there is one real root. I: −1.6716998817. |
| 31 | "where the curve crosses the axis at the left of the window" | confirmed | xlims = (−2, 3.5). F: the crossing is visible near −1.67. |
| 32 | "drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | confirmed | I: the limit cycle after 2000 steps is 0.0074461, 3.0004983, 1.9618967, 1.1475016. The product of g′ over the cycle is 0.2325 < 1, so the cycle is attracting. Iterates from 0: 3.0, 1.96154, 1.14718, 0.006579, 3.000389, 1.961818, 1.147430, 0.007256, 3.000473, 1.961879, which approach the cycle. |
| 33 | "never approach the root" | confirmed | All iterates stay in [0, 3.0005]. The sequence converges to the cycle, never to −1.6717. |
| 34 | Alt: "settle into a 4-cycle near 0.0074, 3.0005, 1.9619 and 1.1475 and never reach the real root at x≈−1.6717" | confirmed | F: frame legends 0.0, 3.0, 1.9615, 1.1472, 0.0066, 3.0004, 1.9618, 1.1474, 0.0073, 3.0005, 1.9619 match S/I |
| 35 | Wiring | confirmed | Manifest |

### Case 5: `newtonee`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 36 | Heading: f(x)=xe^{−x}, x₀=2.0 | confirmed | newtonee.jl lines 11, 15. Matches Mathews Example 7 (`x e^{−x}`, p₀=2.0). |
| 37 | "The only root is x* = 0" | confirmed | e^{−x} > 0 |
| 38 | "maximum of f at x = 1" | confirmed | f′ = (1−x)e^{−x} = 0 at x = 1, and f″(1) < 0 |
| 39 | "There f > 0 and f′(x) = (1−x)e^{−x} < 0" | confirmed | For x > 1 |
| 40 | "x_{n+1} = x_n²/(x_n − 1) > x_n" | confirmed | C: sympy simplifies the Newton map to x²/(x−1), and x²/(x−1) > x ⇔ x > 0 for x > 1 |
| 41 | "2, 4, 5.33, 6.56, …, 10.02 after six steps" | confirmed | I: 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 |
| 42 | "run off toward +∞ … while f(xₙ) → 0" | confirmed | xₙ₊₁ − xₙ = xₙ/(xₙ−1) > 1, so xₙ → ∞. S: f(xₙ) = 0.271 … 4.46e-4. |
| 43 | Alt: "each tangent line meets the axis further right … toward +∞" | confirmed | F frames 1–7. All iterates fall inside xlims (0, 11), so the "→ ∞" fallback label never fires. |
| 44 | Wiring | confirmed | Manifest |

### Case 6: `newtonff`
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 45 | Heading: f(x)=arctan(x), x₀=1.4, "Divergent" | confirmed | newtonff.jl lines 11, 15. Matches Mathews Example 8 ("NON Convergence, Divergent Oscillation", `ArcTan[x]`, p₀=1.4). |
| 46 | "just outside the critical convergence radius x_c ≈ 1.3917" | confirmed | 1.4 > 1.39175 (see 23) |
| 47 | "do not converge to the root; they escape toward larger \|x\|" | confirmed | I: 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103. \|x\| grows monotonically. |
| 48 | Alt: "divergent case starting just outside the critical radius at x₀=1.4" | confirmed | F frames 1–7. Frame 7 legend `x₍6₎ = 8.71 (out of range)` is the true value (8.7103), and the tangent from −2.89 is clipped at the right edge x = 5 rather than relabelled. |
| 49 | Wiring | confirmed | Manifest |

### Counts
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 50 | Six cases, six scripts, six GIFs | confirmed | Manifest. Mathews has exactly six scenario examples (Examples 3–8), and the page covers all six with the same f and p₀. |

### 3. Implementation checks

All six scripts implement plain Newton-Raphson, `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`, with no damping, safeguard or variant. The analytic derivatives were checked against central differences (`inst_*.jl`, `fp check`), and all differences are below 4e-9.

| Script | Method | Numbers: script (S) vs independent (I) | Reference values | Picture |
|---|---|---|---|---|
| newtonaa | Newton | S: 1, 0.47975201560571856, 0.28573835913112816, 0.2555769004716556, 0.2548504777343278, 0.25485005902898933. I: 1, 0.4797520156, 0.2857383591, 0.2555769005, 0.2548504777, 0.254850059. They agree to ~1e-14 (the last S value is limited by double precision). | No reference drawn; the page's x* ≈ 0.2549 is checked by I (0.254850059029) | 6 frames = n_iters+1. Tangents and drops are drawn from the right quantities. Legend index equals the frame number and its value equals xs[frame+1]. Title matches f. |
| newtonbb | Newton | S: 1, 0.6, 0.4, 0.3, 0.25, 0.225, 0.2125, 0.20625, 0.203125, 0.2015625, 0.20078125, 0.200390625, 0.2001953125. I is identical (map g = x/2+1/10). | None | 13 frames. The root region is visible. Labels correct. |
| newtoncc | Newton | S: 1.35, −1.28409115, 1.12412311, −0.78587188, 0.29155398, −0.01625100, 2.861055e-6, −1.5613e-17, 0.0. I: the same to ≥9 digits, with I's last value 2.5e-51 (S underflows to 0.0 in double precision). | x_c = 1.3917452 (C) | 9 frames. All iterates lie inside xlims (−3, 2.5), so the visibility guard never hides a step. Labels are correct to 5 decimals (the `-0.0` is cosmetic). |
| newtondd | Newton | S: 0, 3, 1.9615384615, 1.1471759614, 0.0065793715, 3.0003890741, 1.9618181757, 1.1474302285, 0.0072562476, 3.0004731888, 1.9618786464. I is identical to 10 digits. | Root −1.6716998817 (I). 4-cycle 0.0074461/3.0004983/1.9618967/1.1475016 with multiplier 0.2325 (I). | 11 frames. The clamp to ylims (−4, 30) never activates: max f(xₙ) = 27.012, and the min f on the window is f(−2) = −3. Labels correct to 4 decimals. |
| newtonee | Newton | S: 2, 4, 5.333333, 6.564103, 7.743826, 8.892110, 10.018819. I is identical. | None | 7 frames. Every iterate lies inside xlims (0, 11), so no clamping or hiding occurs. Labels correct. |
| newtonff | Newton | S: 1.4, −1.41361865, 1.45012931, −1.55062598, 1.84705408, −2.89356239, 8.71032585. I is identical. | x_c as above | 7 frames. The last tangent leaves the window and is clipped by the axes. The off-window iterate is reported at its true value with "(out of range)", not at a clamped value. |

Regeneration: the manifest records that each committed GIF is byte-identical to its scratch regeneration, so the frames reviewed are what the current scripts produce.

Legacy fidelity: Mathews' Examples 3–8 are, in order, 3eˣ−4cos x (p₀=1.0), 1−10x+25x² (p₀=1.0), arctan x (p₀=1.35), x³−x+3 (p₀=0.0), xe^{−x} (p₀=2.0) and arctan x (p₀=1.4), read from images gr_374/375, 394/395, 433/434, 454/455, 484/485 and 514/515. Cases 1–6 reproduce them one-to-one, with the same behaviour labels (fast, slow, oscillating convergence, cycling, diverging to infinity, divergent oscillation). There is no fidelity departure.

