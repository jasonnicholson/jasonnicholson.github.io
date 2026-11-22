# Secant Method — animation review (round 5)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Case 3 animation: last frames show "p8 = 0" and then three static frames with filler iterates (Implementation/display, Minor)

- **Where:** `secantmethodcc.jl` lines 15 (`n_iters = 10`), 26–33 (guard `ps[i+1] = ps[i]` when `|denom| < 1e-14`), 81 (secant drawn only when `|fb-fa| > 1e-14`); committed `secantmethodcc.gif` frames 7–10.
- **What is there now:** In double precision, once |x| < ~1e-8, `atan(x) == x` exactly, so the secant through (p6, p6) and (p7, p7) passes exactly through the origin and the script computes p8 = 0.0 exactly. Frame 7's legend reads "p8 = 0". In frames 8, 9, 10 the denominator f(p8)−f(p7) = −4.8e-25 is below the 1e-14 guard, so no secant line and no new iterate are drawn; the legend just lists "p7, p8", "p8, p9", "p9, p10", where p9 and p10 are copies of p8 written by the guard, not secant iterates. Three of the ten frames are identical apart from the legend indices.
- **What is true:** In exact arithmetic the method never lands on the root: p8 = −7.59e-48, p9 = 5.83e-97, p10 = −1.12e-191 (mpmath, `indep.py`). The script's p1–p7 agree with the exact values to double precision (e.g. p7 script 4.798e-25, exact 4.800e-25; both shown as 4.80e-25).
- **How I know:** `julia review/iter_cc.jl` prints p8 = p9 = p10 = p11 = 0.0 with f = 0.0; `indep.py` gives the exact values above. Frames 7–10 inspected.
- **Consequence:** small. A viewer might read "p8 = 0" as the method hitting the root exactly in finitely many steps; the page text does not claim this.
- **Suggested correction:** set `n_iters = 7` (last frame shows p8, the step at which double precision is exhausted), or keep 10 and change the label for an exact-zero iterate to something like "p8 = 0 (to double precision)". Either removes the three dead frames or explains them.

No other findings. All page numbers, behaviour statements, wiring and legacy fidelity checked out (see ledger).

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Total: 0 Error, 0 Misleading, 1 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 8.0 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 8.3 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 6.3 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 6.0 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 4.7 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.3 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 10 | byte-identical | secantmethodcc |
| `secantmethoddd.gif` | 16 | byte-identical | secantmethoddd |
| `secantmethodee.gif` | 9 | byte-identical | secantmethodee |
| `secantmethodff.gif` | 6 | byte-identical | secantmethodff |

### Page references

- Scripts linked: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Page has no Description section; the ledger covers the Animations intro, six headings, six Behavior paragraphs, six alt texts, six source links and six embeds.

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | secant line through $(p_{n-1},f(p_{n-1}))$ and $(p_n,f(p_n))$; its x-intercept becomes $p_{n+1}$ | All scripts: `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`; drawn line through `ps[frame]`, `ps[frame+1]`; red diamond at `ps[frame+2]` | confirmed |
| I2 | Intro | no derivative required; slope from two function evaluations | Code uses only f | confirmed |
| I3 | Intro | can converge quickly, slowly near repeated roots, oscillate while converging, or diverge | Cases 1, 2, 3/6, 5 as computed below | confirmed |
| I4 | Intro | Julia source linked under each case | six `[Julia source]` links | confirmed |
| C1a | Case 1 heading | f = 3eˣ − 4cos x, p0 = 1.0, p1 = 0.9 | `secantmethodaa.jl` l.10–12 | confirmed |
| C1b | Case 1 | converges quickly to root near x ≈ 0.2549 | root 0.254850059028850 (findroot); script p9 = 0.2548500590288503 | confirmed |
| C1c | Case 1 | both starting points on the same side of the root | 1.0, 0.9 > 0.2549 | confirmed |
| C1d | Case 1 | p2 ≈ 0.456, still 0.20 from the root | p2 = 0.455751, err 0.200901 | confirmed |
| C1e | Case 1 | errors 0.066 (p3), 0.0089 (p4), 4.4e-4 (p5), 3.1e-6 (p6) | 0.0658805, 0.00891019, 4.43454e-4, 3.11512e-6 | confirmed |
| C1f | Case 1 | consistent with order ≈ 1.618 | order estimates 1.50, 1.65, 1.60, 1.62, 1.616, … → 1.61803 | confirmed |
| C1g | Case 1 alt | x-intercept converges rapidly to the root near x = 0.2549 | frames 1–9; legend p6…p10 = 0.25485 | confirmed |
| C1h | Case 1 wiring | link `secantmethodaa.jl`, embed `secantmethodaa.gif` | script writes that GIF; params match heading | confirmed |
| C2a | Case 2 heading | f = 1 − 10x + 25x², p0 = 1.0, p1 = 0.9 | `secantmethodbb.jl` l.12–14 | confirmed |
| C2b | Case 2 | (1−5x)² has a double root at 0.2, f′(0.2) = 0; f = 25(x−0.2)² | algebra: 25(x−0.2)² = 25x² − 10x + 1 | confirmed |
| C2c | Case 2 | converges, but only linearly | order estimates → 1.000 | confirmed |
| C2d | Case 2 | ratio of successive errors settles at (√5−1)/2 ≈ 0.618; each step removes ~38% | e_n/e_{n−1} = 0.618034 from n ≈ 14 on | confirmed |
| C2e | Case 2 | iterates creep toward the root over many iterations | p29 err 8.8e-7 after 29 steps | confirmed |
| C2f | Case 2 alt | iterates slowly approach x = 0.2, linear convergence | frames 1–28; legend values p2…p29 checked against mpmath to 8 decimals | confirmed |
| C2g | Case 2 wiring | `secantmethodbb.jl` / `.gif` | match | confirmed |
| C3a | Case 3 heading | f = arctan x, p0 = 1.35, p1 = 1.30 | `secantmethodcc.jl` l.12–14 | confirmed |
| C3b | Case 3 | converges to x = 0 | p7 = 4.8e-25 | confirmed |
| C3c | Case 3 | iterates oscillate, jumping to the opposite side each step | signs p1..p14: +,−,+,−,+,−,… (mpmath) | confirmed |
| C3d | Case 3 | flat slope near the start makes the first step overshoot to negative x | slope 0.363 (vs f′(0) = 1); p2 = −1.22138 | confirmed |
| C3e | Case 3 alt | iterates oscillate across 0 with decreasing amplitude | 1.30, −1.22, 0.018, −0.0067, 4.6e-7, … | confirmed (see F1 for the last frames) |
| C3f | Case 3 wiring | `secantmethodcc.jl` / `.gif` | match | confirmed |
| C4a | Case 4 heading | f = x³ − x + 3, p0 = 2.0, p1 = 1.0 | `secantmethoddd.jl` l.11–13 | confirmed |
| C4b | Case 4 | real root near x ≈ −1.672 | −1.671699881657161 | confirmed |
| C4c | Case 4 | iterates wander, including a large positive excursion, before converging | p3 = −3.0, p6 = 3.1639, p9 = −3.034, then p12…p17 → root | confirmed |
| C4d | Case 4 | convergence can occur from far starting points with a non-monotone path | as above; final order → 1.618 | confirmed |
| C4e | Case 4 alt | wander through positive and negative values, converge to ≈ −1.672 | frames 1–16; legend p17 = −1.6717 | confirmed |
| C4f | Case 4 wiring | `secantmethoddd.jl` / `.gif` | match | confirmed |
| C5a | Case 5 heading | f = x e^{−x}, p0 = 1.5, p1 = 2.0; non-convergence | `secantmethodee.jl` l.11–13 | confirmed |
| C5b | Case 5 | root at x = 0, method diverges | iterates increase without bound (p3000 = 2088.4) | confirmed |
| C5c | Case 5 | secant through the decaying tail has shallow negative slope; intercept falls to the right | f decreasing for x > 1; all iterates ≥ 1.5 move right | confirmed |
| C5d | Case 5 | first jump to p2 ≈ 4.11 | 4.113799 | confirmed |
| C5e | Case 5 | each later step moves right by less than 1 | steps 0.699, 0.972, 0.811, 0.833, 0.799, 0.793, 0.781, 0.774, … | confirmed |
| C5f | Case 5 | step tends to ln 2 ≈ 0.693 | step at p100 0.7026, p1000 0.69414, p3000 0.69348; ln 2 = 0.693147 | confirmed |
| C5g | Case 5 | animation stops at p10 ≈ 10.57, first iterate past the right edge | xlims (0, 10.1); p9 = 9.801, p10 = 10.5746; 9 frames, frame 9 shows "p10 = 10.57 (off chart)" | confirmed |
| C5h | Case 5 | p16 ≈ 15.11 | 15.10597 | confirmed |
| C5i | Case 5 alt | intercept steps further right until p10 ≈ 10.57 leaves the window | frames 1–9 | confirmed |
| C5j | Case 5 wiring | `secantmethodee.jl` / `.gif` | match | confirmed |
| C6a | Case 6 heading | f = arctan x, p0 = 1.60, p1 = 1.50 | `secantmethodff.jl` l.12–14 | confirmed |
| C6b | Case 6 | slightly larger starts than Case 3; again converges to 0 | p7 = −9.2e-17 | confirmed |
| C6c | Case 6 | larger first overshoot | |p2| = 1.842 vs 1.221 in Case 3 | confirmed |
| C6d | Case 6 | super-linear; f″(0) = 0 so asymptotic order 2 rather than 1.618 | order estimates (3000 digits) 1.89, 2.06, 1.97, 2.014, 1.993, 2.004; theory e_{n+1} ≈ (f‴/6f′) e_n e_{n−1}² gives p² = p + 2, p = 2; check e7 ≈ −(1/3)·e6·e5² = −9.2e-17 matches | confirmed |
| C6e | Case 6 alt | converge to 0 after initial overshoot, super-linear | frames 1–6; legend values match mpmath | confirmed |
| C6f | Case 6 wiring | `secantmethodff.jl` / `.gif` | match | confirmed |

Legacy fidelity: the six cases are Mathews' Examples 3–8 / Animations 1–6 in order. Function, starting values and iterate values agree (Mathews frames show e.g. p2 = 0.455750754163146, p27 = 0.200002, p2 = −1.22138, p6 = 3.16390, p9 = 9.80099, p6 = 1.01113e-7). Mathews' Case 5 stops at p9, the page at p10; Mathews' Case 2 at p27, the page at p29. Neither change matters to a reader. No case dropped. No fidelity findings.

### 3. Implementation checks

All six scripts share the same core loop (two-point secant, guard that copies the previous iterate when |f(p_n) − f(p_{n−1})| < 1e-14). Indexing: `ps[k] = p_{k−1}`. In frame `j` the script draws the secant through p_{j−1}, p_j and marks p_{j+1}. Legend indices match.

**Is it the method claimed?** Yes in all six. It is the plain secant method (no bracketing, no regula-falsi retention, no Newton fallback).

### secantmethodaa.jl (Case 1)
- Numbers: script vs mpmath: p2 0.4557507541631453 / 0.45575075416314564; p4 0.2637602526350553 / 0.26376025263505522; p6 0.2548531741452458 / 0.25485317414524574; p8 0.254850059028853 / 0.25485005902885296. Agreement to double precision.
- Reference: root 0.254850059028850 (findroot, residual 0).
- Picture: secant through the two blue points, red diamond at the intercept, dashed drop to the curve; legend values rounded to 5 decimals match. Frames 6–9 look the same because the iterates have already converged. This is accurate.

### secantmethodbb.jl (Case 2)
- Numbers: p29 script 0.20000088348568937 vs exact 0.20000088348853019 (diff 2.8e-12 from cancellation in the expanded quadratic; the error is 8.8e-7, so this is negligible, and the 8-decimal label 0.20000088 agrees). All 10 sheet labels checked to 8 decimals.
- Reference: double root 0.2, exact.
- Rate: e_n/e_{n−1} → 0.618034 = (√5−1)/2 exactly as stated.
- Picture: clamping is inactive (all iterates in [0.2, 1], f ≤ 16 = ylim). In late frames the secant is nearly flat on the axis and the movement can only be read from the legend. This is accurate, not misleading.

### secantmethodcc.jl (Case 3)
- Numbers: p2 −1.2213792056860207 / −1.2213792056860117; p3 0.01803629819672592 / 0.018036298196728075; p5 4.5722058130987647e-7 / 4.572205813098165e-7; p7 4.798e-25 / 4.800e-25. p8 onward: see F1.
- Reference root 0 (exact).
- Order (not claimed on the page for this case) also → 2 (1.93, 2.04, 1.98, 2.009).
- Picture: correct for frames 1–7; frames 8–10 static (F1). Clamping only applies to history points that are already inside the window.

### secantmethoddd.jl (Case 4)
- Numbers: every iterate p0–p17 matches mpmath to ≥ 15 digits (e.g. p6 3.1639049160972332 / 3.1639049160972343; p17 −1.67169988165716 / −1.671699881657161).
- Reference: root −1.671699881657161 (findroot).
- The `n_iters_actual` early break fires only at i = 17, the final pass, because |p17 − p16| = 6.2e-10. So `ps` is fully filled and none of the `undef` entries are drawn. The variable is unused (and local to the loop). It is a latent hazard if the parameters change, but it has no effect here.
- Picture: all iterates fall inside xlims (−3.2, 3.5) and all f values inside ylims (−25, 32) (max f(p6) = 31.51, min f(p9) = −21.90, as the l.17 comment says). So the clamping never changes a drawn position. Legend values (4 decimals) match.

### secantmethodee.jl (Case 5)
- Numbers: p2 4.113798873326397 / 4.1137988733263955; p10 10.574639777228054 / 10.574639777228051. Divergence guards (|p| > 1e6, NaN) never trigger within 9 frames.
- Reference: no root approached; the asymptotic step ln 2 was confirmed by a 3000-step mpmath run and by fixed-point analysis: Δ = Δ/(e^Δ − 1) gives e^Δ = 2, and the derivative 1 − 2 ln 2 = −0.386 makes this fixed point stable.
- Picture: frame 9 draws the secant through p8 and p9, puts a hollow diamond at the right edge, and labels it with the true value "p10 = 10.57 (off chart, marker at edge)". This display is honest. The `n_valid` soft-scope warning on stderr has no effect.

### secantmethodff.jl (Case 6)
- Numbers: p2 −1.8424619601336367 / −1.8424619601336275; p4 0.07619322951467797 / 0.076193229514675137; p6 1.0111340931960545e-7 / 1.0111340931957673e-7; p7 −9.225344201478945e-17 / −9.2253449358627186e-17.
- Reference root 0. Order 2 confirmed (see C6d). The header comment "from p3 on the iterates alternate sides" is correct (p2, p3 both negative; then +, −, +, −).
- Picture: all six frames correct; legend values in %.5f / %.2e match.

