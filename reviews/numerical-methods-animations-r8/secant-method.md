# Secant Method — animation review (round 8)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the script headers matched my independent computation, and every frame I inspected shows what the script computed.

There is one observation that is not a finding: the page has no `## Description` section, although the authoring conventions ask for one. The review standard excludes content the page does not yet have. The Animations introduction states the update rule correctly, as a secant through (p_{n-1}, f(p_{n-1})) and (p_n, f(p_n)) whose x-intercept is p_{n+1}.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 7.0 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 9.2 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 6.6 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 7.7 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 5.1 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Where | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | Secant drawn through the two most recent iterates (p_{n-1},f(p_{n-1})), (p_n,f(p_n)); its x-intercept becomes p_{n+1} | All scripts: frame k draws the line through ps[k], ps[k+1] (p_{k-1}, p_k) and marks ps[k+2] = p_{k+1} with the matching legend index. Checked by hand in aa frame 1 (slope 6 → x-intercept 0.5 in dd frame 1; bb frame 1 slope 37.5 → 0.57333; ee frame 1 → 4.114) | confirmed |
| I2 | Intro | No derivative is required; the slope comes from two function evaluations | Code uses only f values | confirmed |
| I3 | Intro | The method can converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge | Cases 1, 2, 3, 5 respectively (see below) | confirmed |
| I4 | Intro | Scripts linked under each case | Six links, aa to ff, in order. Manifest: every GIF is byte-identical to a regenerated scratch run | confirmed |
| 1a | Case 1 heading | f = 3e^x − 4cos x, p0 = 1.0, p1 = 0.9 | aa.jl lines 10-12; matches Mathews Ex. 3 | confirmed |
| 1b | Case 1 | Root near x ≈ 0.2549 | mpmath root 0.254850059028850 | confirmed |
| 1c | Case 1 | Both starting points on the same side of the root | 1.0 and 0.9 both > 0.2549 | confirmed |
| 1d | Case 1 | p2 ≈ 0.456, still 0.20 from the root | p2 = 0.455750754, error 0.2009 | confirmed |
| 1e | Case 1 | Errors 0.066 (p3), 0.0089 (p4), 4.4e-4 (p5), 3.1e-6 (p6) | 0.06588, 0.008910, 4.435e-4, 3.115e-6 | confirmed |
| 1f | Case 1 | Consistent with order ≈ 1.618 at this simple root | f'(r) = 4.879, f''(r) = 7.742 ≠ 0, so C = f''/(2f') = 0.793. Predicted e5 ≈ C·e4·e3 = 4.65e-4 (actual 4.43e-4); e6 ≈ 3.13e-6 (actual 3.12e-6) | confirmed |
| 1g | Case 1 alt | x-intercept converges rapidly to the root near 0.2549 | Frames 1-9; legend reads p10 = 0.25485 in the last frame | confirmed |
| 2a | Case 2 heading | f = 1 − 10x + 25x², p0 = 1.0, p1 = 0.9 | bb.jl lines 12-14; Mathews Ex. 4 | confirmed |
| 2b | Case 2 | (1−5x)² has a double root at 0.2 with f'(0.2) = 0 | Algebra: (1−5x)² = 1 − 10x + 25x² = 25(x−0.2)² | confirmed |
| 2c | Case 2 | Converges only linearly; the error ratio settles at (√5−1)/2 ≈ 0.618 | Ratios 0.6180 from p9 on, and 0.61803399 by p19 (indep.py) | confirmed |
| 2d | Case 2 | Each step removes only about 38% of the remaining error | 1 − 0.618 = 0.382 | confirmed |
| 2e | Case 2 / alt | Iterates creep toward 0.2 over many iterations | 28 frames, p29 = 0.20000088 (script) vs 0.20000088349 (mpmath) | confirmed |
| 3a | Case 3 heading | arctan, p0 = 1.35, p1 = 1.30 | cc.jl lines 15-17; Mathews Ex. 5 | confirmed |
| 3b | Case 3 | Converges to 0; iterates jump to the opposite side each step | p1..p8 signs +,−,+,−,+,−,+,− (p2 −1.221, p3 0.0180, p4 −0.00672, p5 4.57e-7, p6 −6.89e-12, p7 4.80e-25, p8 −7.6e-48) | confirmed |
| 3c | Case 3 | Flat slope near the start makes the first step overshoot to negative x | Secant slope (0.9151−0.9332)/(−0.05) = 0.363, so p2 = −1.221 | confirmed |
| 3d | Case 3 | Animation ends at p8, which double precision returns as exactly 0 | n_iters = 7, so the last frame shows p8. Script p8 = 0; the legend reads "p8 = 0 (double-precision result)" | confirmed |
| 3e | Case 3 | p6 ≈ −6.9e-12, p7 ≈ 4.8e-25, and computed atan(x) equals x for both | Julia: `atan(p6)==p6` true and `atan(p7)==p7` true; the secant formula then gives 0.0 | confirmed |
| 3f | Case 3 | Exact-arithmetic p8 ≈ −7.6e-48 | mpmath −7.5928e-48 | confirmed |
| 3g | Case 3 alt | Oscillate across 0 with decreasing amplitude | \|p\| decreases monotonically from p1 on | confirmed |
| 4a | Case 4 heading | x³ − x + 3, p0 = 2.0, p1 = 1.0 | dd.jl lines 11-13; Mathews Ex. 6 | confirmed |
| 4b | Case 4 | Real root near x ≈ −1.672 | mpmath −1.67169988165716. It is the only real root, since local max/min values f(∓1/√3) = 3.385 / 2.615 are both > 0 | confirmed |
| 4c | Case 4 | Iterates wander, including a large positive excursion, before converging | p3 = −3, p6 = 3.1639, p9 = −3.034, then convergence to −1.67170 by p16 | confirmed |
| 4d | Case 4 alt | Wanders through positive and negative values, converging to −1.672 | Same sequence; last frame legend p17 = −1.6717 | confirmed |
| 4e | dd.jl comment | ylims cover f(p3) = −21 and f(p9) ≈ −21.9 | −21.0 and −21.9005; also f(p6) = 31.51 < 32, with p6 and p9 inside xlims, so nothing is clamped | confirmed |
| 5a | Case 5 heading | x e^{−x}, p0 = 1.5, p1 = 2.0 | ee.jl lines 11-13; Mathews Ex. 7 | confirmed |
| 5b | Case 5 | Diverges; the shallow negative slope on the decaying tail pushes the intercept right | p increases monotonically, p2..p19 (indep.py) | confirmed |
| 5c | Case 5 | First jump to p2 ≈ 4.11 | 4.113799 | confirmed |
| 5d | Case 5 | After that each step < 1, and the step tends to ln 2 | Steps 0.699, 0.972, 0.811, …; the largest after p2 is 0.9716. The step is 0.7026 at n = 100, 0.69335 at n = 5000 and 0.69320 at n = 20000 (ee_steps.py). The fixed point of d = d·r/(1−r) with r = e^{−d} gives d = ln 2 | confirmed |
| 5e | Case 5 | Animation stops at p10 ≈ 10.57, the first iterate past the right edge | xlims (0, 10.1); p9 = 9.801 inside, p10 = 10.5746 outside. The last frame labels p10 = 10.57 as off chart, with a hollow marker at the edge | confirmed |
| 5f | Case 5 | p16 ≈ 15.11 | 15.10597 | confirmed |
| 5g | Case 5 alt | Steps progressively right until p10 ≈ 10.57 leaves the window | Frames 1-9 | confirmed |
| 6a | Case 6 heading | arctan, p0 = 1.60, p1 = 1.50 | ff.jl lines 12-14; Mathews Ex. 8 | confirmed |
| 6b | Case 6 | Converges to 0 with a larger first overshoot than Case 3 | \|p2\| = 1.842 vs 1.221 | confirmed |
| 6c | Case 6 | Asymptotic order 2 because f''(0) = 0 | For atan, f[a,b,0] ≈ −(a+b)/3, so e_{n+1} ≈ −e_n e_{n−1}(e_n+e_{n−1})/3 ≈ C e_n e_{n−1}², and p² = p + 2 gives p = 2. Measured ln e_{n+1}/ln e_n: 2.29, 1.90, 2.07, 1.97 for n = 6..9. Check: e7 ≈ e6·e5²/3 = 9.2e-17 against actual 9.23e-17 | confirmed |
| 6d | Case 6 alt | Converges after the initial overshoot, super-linearly | As above | confirmed |
| 6e | ff.jl comment | Overshoots to p2 ≈ −1.842, then from p3 on the iterates alternate sides | p3 −0.0975, p4 +0.0762, p5 −5.2e-5, p6 +1.0e-7, p7 −9.2e-17 | confirmed |
| W | Wiring | Each heading's link and embed is that case's script and GIF | aa..ff map to Cases 1..6. Parameters in each heading equal the script's | confirmed |
| F | Fidelity | Functions, starting values and behaviour labels match Mathews | legacy_formulas.png | confirmed |

### 3. Implementation checks

All six scripts use the same core loop, `p_{n+1} = p_n − f(p_n)(p_n − p_{n−1})/(f(p_n) − f(p_{n−1}))`. That is the plain secant method, with no bracketing or safeguard, so it is not regula falsi. The guard against a zero denominator (`|denom| < 1e-14`) only freezes the iterate. It fires in none of the displayed steps except in ways described below.

| Script | Method | Script iterates vs mpmath (selected) | Reference values | Picture |
|---|---|---|---|---|
| aa | Plain secant | p2 0.45575075416 / 0.455750754163; p5 0.25529351342 / 0.255293513424; p8 0.254850059028853 / 0.254850059028853 | Root 0.25485005902885 (mpmath findroot) | Nine frames, secant to p10. At p9 and p10 the denominator is −1.33e-14, just above the guard, and the line is still drawn; p10 = p9 because f(p9) = 0 in double. All legend values round correctly to five digits |
| bb | Plain secant | p2 0.573333 / 0.573333; p10 0.2082595870 / 0.2082595870; p29 0.20000088348569 / 0.20000088348853 (the relative difference of 1e-11 comes from evaluating the expanded quadratic in double) | Root 0.2 exact | 28 frames. Every p_c is inside the window, so the clamps never act. After about frame 10 the plot is visually static and only the 8-digit legend changes. That is consistent with "creeps", so not a finding |
| cc | Plain secant | p2..p6 agree to all printed digits; p7 4.798e-25 / 4.800e-25 (cancellation in p6 − (≈p6)); p8 0 / −7.59e-48 | Root 0 | Seven frames, ending at p8 = 0 with the explicit "(double-precision result)" legend. No clamping of plotted iterates (all within (−3, 2)) |
| dd | Plain secant (early-break never fires before the array is full) | All of p2..p17 agree with mpmath to 12+ digits | Root −1.67169988165716 | 16 frames. All iterates and f-values lie within the window, so the clamps do not move any point |
| ee | Plain secant | p2 4.113798873326 / 4.1137988733264; p10 10.574639777228 / 10.5746397772281 | Root 0, which is never approached | Nine frames. In frame 9, p10 is off chart and is shown honestly with its true value and an edge marker |
| ff | Plain secant | p2..p6 agree; p7 −9.22534420e-17 / −9.22534494e-17 | Root 0 | Six frames, ending at p7 = −9.23e-17. All points are within the window |

The titles name the function each script actually uses. Legend indices match the iterate shown: the diamond is p_{frame+1} and the pair is p_{frame−1}, p_frame. Contact sheets for all six GIFs and dd frame 16 were inspected.

