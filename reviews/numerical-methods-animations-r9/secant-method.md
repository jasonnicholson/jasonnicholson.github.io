# Secant Method — animation review (round 9)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding.

These are notes only, not findings:

- The page has no `## Description` section. The authoring conventions (`.github/agents/animation-page.agent.md`, lines 12 and 205) require one. Under the review standard, missing content is not a finding. Because there is no Description, I had no method formulas there to check. The intro paragraph's statement of the method is checked in the ledger below.
- `secantmethoddd.jl` lines 32–36 hold an early-exit `break` and set an unused variable `n_iters_actual`. If the break fired before the last pass of the loop, `ps` would keep uninitialised entries that the animation loop still reads. In this run the break fires only at `i = 17`, the final pass (|p17 − p16| = 6.2e-10 < 1e-8), so every `ps` entry is defined. The 18 values match my independent run (section 3). This is latent fragility, not a present error.
- Examples 1 and 2 of the archive's `SecantMethodMod.html` are worked Mathematica examples with no animation, and the page does not carry them. The archive's animation set (a2001 `Secantaa` to `Secantff`, which are n2003 Examples 3 to 8) is complete on the page. Each function and starting pair matches the archive exactly, so I raise no Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 7.8 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 9.3 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 7.1 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 6.4 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 5.2 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.7 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 7 | byte-identical | secantmethodcc |
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

Commands used for the evidence:
- `/usr/bin/python3 indep.py`: an independent secant iteration at 80 digits (mpmath) from the stated starting values, with true roots from `mp.findroot`.
- `julia iter_XX.jl`: each script's own parameter and iteration block, copied unchanged with the plotting removed, printing every `ps` entry, `f(p)`, and whether `f(p) == p`.
- `/usr/bin/python3 -I ee_long.py`: Case 5 run for 20,000 steps.
- Viewing of the committed frames (all GIFs are byte-identical to the scratch regeneration, per the manifest).

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "a secant line is drawn through the two most recent iterates (p_{n-1},f(p_{n-1})) and (p_n,f(p_n)); its x-intercept becomes p_{n+1}" | All six scripts compute `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`. The drawn line goes through (pa,fa) with slope (fb−fa)/(pb−pa). The red diamond sits at its intercept in every frame I viewed. | confirmed |
| 2 | Intro | "no derivative is required — the slope is approximated from two function evaluations" | The code uses no derivative. | confirmed |
| 3 | Intro | the method "can converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge" | Cases 1, 2, 3 and 5 show these respectively (see below). | confirmed |
| 4 | Intro | "Julia source scripts … are linked under each case" | Six links are present and each points at the matching script. | confirmed |
| 5 | Case 1 heading | f = 3e^x − 4cos x, p0 = 1.0, p1 = 0.9 | `secantmethodaa.jl` lines 10–12. The archive's Example 3 is the same. | confirmed |
| 6 | Case 1 | "converges quickly to the root near x ≈ 0.2549" | True root 0.2548500590 (findroot). Script p9 = 0.25485005902885027. | confirmed |
| 7 | Case 1 | "Both starting points are on the same side of the root" | 1.0 and 0.9 are both > 0.2549. | confirmed |
| 8 | Case 1 | "p2 ≈ 0.456, still 0.20 from the root" | p2 = 0.4557507542, error 0.2009. | confirmed |
| 9 | Case 1 | errors "0.066 at p3, 0.0089 at p4, 4.4e-4 at p5, 3.1e-6 at p6" | 0.06588, 0.00891, 4.435e-4, 3.115e-6 | confirmed |
| 10 | Case 1 | "consistent with the secant method's order ≈ 1.618 at this simple root" | ln e_{n+1}/ln e_n = 1.695, 1.736, 1.636, 1.642, 1.627, 1.626, 1.622, tending to 1.618. f''(r) = 3e^r + 4cos r ≈ 5.76 ≠ 0. | confirmed |
| 11 | Case 1 alt | "x-intercept converges rapidly to the root near x=0.2549" | The frames show this. The legend reads p6 to p10 = 0.25485. | confirmed |
| 12 | Case 1 wiring | link `secantmethodaa.jl`, embed `secantmethodaa.gif` | The GIF title is "f(x) = 3eˣ − 4cos(x)" and frame 1 shows p0 = 1, p1 = 0.9. | confirmed |
| 13 | Case 2 heading | f = 1 − 10x + 25x², p0 = 1.0, p1 = 0.9, "Slow Convergence (Double Root)" | `secantmethodbb.jl` lines 12–14. The archive's Example 4 is the same. | confirmed |
| 14 | Case 2 | "(1−5x)² has a double root at x = 0.2 where f'(0.2) = 0", "f(x) = 25(x−0.2)²" | Algebraic identity. f'(x) = 50(x−0.2). | confirmed |
| 15 | Case 2 | "converges, but only linearly … ratio of successive errors settles at (√5−1)/2 ≈ 0.618" | Independent ratios 0.6053, 0.6230, 0.6162, 0.6188, …, 0.618034 from p14 onward. | confirmed |
| 16 | Case 2 | "each step removes only about 38% of the remaining error" | 1 − 0.618 = 0.382 | confirmed |
| 17 | Case 2 | "iterates creep toward the root over many iterations" | 28 frames. The final legend reads p29 = 0.20000088 (error 8.8e-7). | confirmed |
| 18 | Case 2 alt | "iterates slowly approach the double root at x=0.2, demonstrating linear convergence" | The frames and the ratio above agree. | confirmed |
| 19 | Case 2 wiring | bb script and GIF | The GIF title is "f(x) = 1 − 10x + 25x² (double root)". | confirmed |
| 20 | Case 3 heading | f = arctan x, p0 = 1.35, p1 = 1.30 | `secantmethodcc.jl` lines 15–17. The archive's Example 5 is the same. | confirmed |
| 21 | Case 3 | "converges to the root at x = 0" | Exact iterates reach 5.8e-97 by p9. | confirmed |
| 22 | Case 3 | "the iterates oscillate — jumping to the opposite side of the root each step before settling" | Signs from p2: −, +, −, +, −, +, − (p2 to p8, exact). They alternate at every step after the two same-side starting values. | confirmed |
| 23 | Case 3 | "flat slope … causes the secant line to overshoot to negative x on the first step" | p2 = −1.2213792. Frame 1 shows the shallow secant meeting the axis at −1.22. | confirmed |
| 24 | Case 3 | "The animation ends at p8" | n_iters = 7, giving 7 frames. Frame 7's legend reads "p8 = 0 (double-precision result)". | confirmed |
| 25 | Case 3 | "which double precision returns as exactly 0" | Julia gives p8 = 0. | confirmed |
| 26 | Case 3 | "p6 ≈ −6.9e-12 and p7 ≈ 4.8e-25" | Double: −6.8886e-12 and 4.7983e-25. Exact: −6.8886e-12 and 4.8002e-25. | confirmed |
| 27 | Case 3 | "the computed arctan(x) equals x" at p6 and p7 | Julia `atan(p) == p` is true for p6 and p7 (false for p5). | confirmed |
| 28 | Case 3 | "so the secant through them passes through the origin" | This follows because f(p) = p exactly at both points, and p8 = 0 bears it out. | confirmed |
| 29 | Case 3 | "In exact arithmetic p8 ≈ −7.6e-48" | mpmath gives −7.5928e-48. | confirmed |
| 30 | Case 3 alt | "iterates oscillate across x=0 with decreasing amplitude before converging" | Consistent with #22. | confirmed |
| 31 | Case 4 heading | f = x³ − x + 3, p0 = 2.0, p1 = 1.0 | `secantmethoddd.jl` lines 11–13. The archive's Example 6 is the same. | confirmed |
| 32 | Case 4 | "a real root near x ≈ −1.672" | −1.6716998817. The discriminant 4 − 243 < 0, so this is the only real root. | confirmed |
| 33 | Case 4 | "Starting from positive values far from the root" | The distances are 3.67 and 2.67. | confirmed |
| 34 | Case 4 | "iterates wander — including a large positive excursion — before eventually converging" | p3 = −3, p4 = 0.111, p5 = −0.265, p6 = 3.164, p7 = −0.659, p8 = −1.118, p9 = −3.034, then convergence (p17 error 1e-15). | confirmed |
| 35 | Case 4 | "convergence can occur even when the path is non-monotone" | Same sequence as #34. | confirmed |
| 36 | Case 4 alt | "iterates wander through positive and negative values before converging to the root near x=-1.672" | The final legend reads p17 = −1.6717. | confirmed |
| 37 | Case 4 wiring | dd script and GIF | The GIF title is "f(x) = x³ − x + 3". | confirmed |
| 38 | Case 5 heading | f = x e^{−x}, p0 = 1.5, p1 = 2.0, "NON Convergence (Diverging to Infinity)" | `secantmethodee.jl` lines 11–13. The archive's Example 7 is the same. | confirmed |
| 39 | Case 5 | "has a root at x = 0 … the secant method diverges" | Iterates p2 to p18 increase to 16.59. The p20000 of 13873.8 grows like n·ln 2. | confirmed |
| 40 | Case 5 | "secant line through points on the decaying tail has a shallow negative slope whose x-intercept falls to the right" | Both starting values are past the maximum at x = 1. Every secant slope is negative and every intercept lies to the right. | confirmed |
| 41 | Case 5 | "after the first jump to p2 ≈ 4.11" | 4.1137989 | confirmed |
| 42 | Case 5 | "each step moves right by less than 1" | The largest step after p2 is 0.97156 (p3 to p4). | confirmed |
| 43 | Case 5 | "the step tends to ln 2 ≈ 0.693" | Steps are 0.7737 at n = 10, 0.7026 at n = 100, 0.69414 at n = 1000 and 0.693197 at n = 20000. ln 2 = 0.693147. The fixed point h = h/(eʰ − 1) is stable (g' = 1 − 2 ln 2 ≈ −0.386). | confirmed |
| 44 | Case 5 | "The animation stops at p10 ≈ 10.57, the first iterate past the right edge of the window" | xlims = (0, 10.1). p9 = 9.801 is inside and p10 = 10.5746 is outside. Frame 9 labels "p10 = 10.57 (off chart)". | confirmed |
| 45 | Case 5 | "p16 ≈ 15.11" | 15.10597 | confirmed |
| 46 | Case 5 alt | "x-intercept steps progressively further right until p10≈10.57 leaves the window" | The frames agree. | confirmed |
| 47 | Case 6 heading | f = arctan x, p0 = 1.60, p1 = 1.50 | `secantmethodff.jl` lines 12–14. The archive's Example 8 is the same. | confirmed |
| 48 | Case 6 | "slightly larger starting values than Case 3, the method again converges to x = 0" | Exact iterates reach 8.9e-64 by p9. | confirmed |
| 49 | Case 6 | "Despite a larger first overshoot" | p2 = −1.8425 here, against −1.2214 in Case 3. | confirmed |
| 50 | Case 6 | "subsequent steps quickly close in on the root" | p3 = −0.0975, p4 = 0.0762, p5 = −5.2e-5, p6 = 1.0e-7, p7 = −9.2e-17. | confirmed |
| 51 | Case 6 | "super-linear … because f''(0) = 0 for arctan its asymptotic order here is 2 rather than … 1.618" | The successive-error model gives e_{n+1} ≈ −(1/3) e_n e_{n−1}(e_n + e_{n−1}), so p² = p + 2 and p = 2. As a check, −(1/3)(1.011e-7)(−5.237e-5)(−5.227e-5) = −9.2e-17, the true p7. Log-ratio orders 2.29, 1.90, 2.07 (and 2.18, 1.94, 2.04 in Case 3) tend to 2. | confirmed |
| 52 | Case 6 alt | "iterates converge to x=0 after initial overshoot, showing super-linear convergence" | The frames agree. The final legend reads p7 = −9.23e-17. | confirmed |
| 53 | Wiring, all | Each heading's parameters equal the linked script's parameters and the embedded GIF's title and frame-1 points. | Checked for all six. The manifest shows each committed GIF is byte-identical to its script's regeneration. | confirmed |
| 54 | Counts | Six cases, six scripts, six GIFs | aa 9, bb 28, cc 7, dd 16, ee 9 and ff 6 frames, equal to each `n_iters`. | confirmed |

### 3. Implementation checks

All six scripts run the same core loop: the textbook two-point secant iteration (not regula falsi, since no bracket is kept). There is a stall guard: if |f(p_n) − f(p_{n−1})| < 1e-14, then p_{n+1} = p_n. I checked every denominator used for a displayed iterate. The guard **never fires** on a displayed iterate. The smallest denominator is |f(p9) − f(p8)| = 1.33e-14 in Case 1, which gives p10 = p9, the same as exact arithmetic to double precision. `ee` adds a divergence cap at |p| > 1e6, which is never reached in 10 iterates. `dd` adds an early break that fires only on the last pass (see notes). So each script is the plain secant method.

Script values (double precision, Julia) are set beside independent values (mpmath, 80 digits) below.

| Case | Iterate | Script | Independent |
|---|---|---|---|
| aa | p2 | 0.45575075416314531 | 0.45575075416315 |
| aa | p5 | 0.25529351342420903 | 0.25529351342421 |
| aa | p8 | 0.25485005902885299 | 0.25485005902885 (root 0.254850059029) |
| bb | p2 | 0.57333333333333347 | 0.57333333333333 |
| bb | p14 | 0.20120507854529351 | 0.2012050785453 |
| bb | p29 | 0.20000088348568937 | 0.20000088348853 (diff 2.8e-12, roundoff in f near the double root; legend `%.8f` is unaffected) |
| cc | p2 | −1.2213792056860207 | −1.221379205686 |
| cc | p5 | 4.5722058130987647e-07 | 4.5722058130982e-07 |
| cc | p6 | −6.8886493391088996e-12 | −6.8886493390956e-12 |
| cc | p7 | 4.7982937876611176e-25 | 4.8001833131675e-25 |
| cc | p8 | 0 (exact double result) | −7.5928e-48 |
| dd | p3, p6, p9 | −3, 3.1639049160972332, −3.0342275767851379 | −3.0, 3.1639049160972, −3.0342275767851 |
| dd | p17 | −1.67169988165716 | −1.6716998816572 (root −1.67169988166) |
| ee | p2, p10 | 4.113798873326397, 10.574639777228054 | 4.1137988733264, 10.574639777228 |
| ff | p2, p5, p7 | −1.8424619601336367, −5.2368150304113459e-05, −9.2253442014789448e-17 | −1.8424619601336, −5.2368150304106e-05, −9.2253449358627e-17 |

The four questions for each script:

- **secantmethodaa.jl.**
  - Method: the plain secant method.
  - Numbers: they match the independent run. The observed order tends to 1.618.
  - Reference: the true root comes from findroot and needs no extra reference.
  - Picture: the secant goes through ps[frame] and ps[frame+1], and its intercept marker is labelled p_{frame+1}, which is correct indexing. The blue pair is labelled "p_{frame−1}, p_frame". In frames 7–9 the iterates coincide at the root. In frame 9 the line is built from pairs that differ by an ulp, giving slope 4.92, close to f'(r) = 4.87. It looks like a near-tangent and does not mislead.
- **secantmethodbb.jl.**
  - Method: the plain secant method.
  - Numbers: they match (see the table).
  - Reference: the root 0.2 is exact.
  - Picture: the y-window is [0, 16]. Clamping is a no-op because the maximum f is f(1) = 16 and all f ≥ 0. After about frame 10 the secant lies on the axis and the change is visible only in the legend. That fits the "creep" message and is not misleading.
- **secantmethodcc.jl.**
  - Method: the plain secant method.
  - Numbers: they match. The double-precision p8 = 0 and the statement atan(x) == x at p6 and p7 are verified in Julia.
  - Reference: the exact p8 comes from mpmath.
  - Picture: the legend switches to scientific notation below 1e-3, and p8 is labelled "0 (double-precision result)", which is honest. All f values lie within the ylims, so clamping never acts.
  - Header comment: the comment "f(p8)−f(p7) ~ 1e-25" is correct in magnitude (−4.8e-25).
- **secantmethoddd.jl.**
  - Method: the plain secant method.
  - Numbers: they match through p17.
  - Reference: the root −1.6717 is verified.
  - Picture: the window (−3.2, 3.5) × (−25, 32) contains every iterate and every f(p), the extremes being p6 = 3.164 with f = 31.51 and p9 = −3.034 with f = −21.90. So no clamp ever acts. Comment line 17 ("f(p3) = −21 and f(p9) ≈ −21.9") is correct.
- **secantmethodee.jl.**
  - Method: the plain secant method.
  - Numbers: they match.
  - Reference: not applicable.
  - Picture: frames 1–8 show the intercepts p2 to p9 inside the window. Frame 9 shows p10 = 10.57 off the chart, with a hollow edge marker, a legend entry and a text annotation giving its real value. No clamped value is presented as real. The `n_iters` comment is correct.
- **secantmethodff.jl.**
  - Method: the plain secant method.
  - Numbers: they match.
  - Reference: not applicable.
  - Picture: the legend formatting is correct. The header comment holds: p2 is about −1.842, and from p3 on the iterates alternate sides (signs from p3 are −, +, −, +, −).

Order-of-convergence claims were checked by property, from the error sequence and the error recurrence, without relying on a remembered constant. The value is 1.618 for Case 1, the linear ratio 0.618 for Case 2, and 2 for the arctan cases.

