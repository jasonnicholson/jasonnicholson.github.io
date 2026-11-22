# Secant Method — animation review (round 2)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Implementation (script comment), Minor
- **Location:** `pages/numerical-methods/secant-method/secantmethodff.jl`, line 4: `# Root at x=0; method converges directly`
- **Now:** the header says the method "converges directly" (in contrast with `secantmethodcc.jl` line 4, "method oscillates but converges").
- **True:** the iterates overshoot far to the other side and then alternate sides of the root exactly as in Case 3: p0=1.6, p1=1.5, p2=−1.842462, p3=−0.097483, p4=+0.076193, p5=−5.2368e−5, p6=+1.0111e−7, p7=−9.2253e−17. For arctan (f''(0)=0, f'''(0)=−2) the asymptotic error law is e_{n+1} ≈ −(1/3)·e_n·e_{n−1}², which forces sign alternation in both arctan cases. Checked: −(1/3)(1.0111e−7)(5.2368e−5)² = −9.24e−17 vs computed p7 = −9.2253e−17.
- **How I know:** `julia review/inst_ff.jl` and `/usr/bin/python3 -I review/indep.py` (both give the sequence above, agreeing to all printed digits).
- **Fix:** change line 4 to e.g. `# Root at x=0; overshoots to p2 ≈ -1.842, then converges while alternating sides`. (The page text for Case 6 does not repeat the "directly" claim — it says "Despite a larger first overshoot, subsequent steps quickly close in" — so no page change is required, though the page could note that Case 6 also alternates sides.)

- **Independent check:** not run (Minor finding, unverified)

### F2 — Implementation (display/legend), Minor
- **Location:** `pages/numerical-methods/secant-method/secantmethodbb.jl`, line 86: `label="p$(frame+1) = $(round(pc; digits=5))"`
- **Now:** in the last four frames of the slow-convergence (double-root) GIF the legend reads `p26 = 0.2`, `p27 = 0.2`, `p28 = 0.2`, `p29 = 0.2` (frame_028.png shows `p29 = 0.2`). The final frame therefore states the iterate equals the root.
- **True:** p26 = 0.2000037425, p27 = 0.2000023130, p28 = 0.2000014295, p29 = 0.2000008835 — still 3.7e−6 … 8.8e−7 from the root after 29 steps. This residual error is the whole point of Case 2 ("creep toward the root over many iterations"), and the 5-decimal label hides it, so the final frame reads as exact convergence. (Same display quirk, of less consequence, in `secantmethodcc.jl` line 90 and `secantmethodff.jl` line 85, which print `p5 = 0.0`, `p6 = -0.0`, `p7 = -0.0` for values of order 1e−7 to 1e−17.)
- **How I know:** `julia review/inst_bb.jl` (values above); `round(0.200003742517971; digits=5)` → `0.2`; frames `committed/secantmethodbb/frame_025..028.png` show the `= 0.2` labels.
- **Fix:** label with more significant digits or the error, e.g. `label = @sprintf("p%d = %.8f  (err %.1e)", frame+1, pc, pc-0.2)` (needs `using Printf`), or use `round(pc; sigdigits=...)`/scientific format for the arctan cases.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Summary: 0 Error, 0 Misleading, 2 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 5.8 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 7.1 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 6.3 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 7.0 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 5.3 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.6 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | "a secant line is drawn through the two most recent iterates (p_{n−1}, f(p_{n−1})) and (p_n, f(p_n)); its x-intercept becomes p_{n+1}" | Every script: `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`; plotted segment uses slope (fb−fa)/(pb−pa) through (pa,fa) with pa=p_{frame−1}, pb=p_frame; red diamond at pc=p_{frame+1} on y=0; frames show the line hitting y=0 at the diamond | confirmed |
| I2 | Intro | "no derivative is required — the slope is approximated from two function evaluations" | No derivative in any script | confirmed |
| I3 | Intro | method can "converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge" | Cases 1, 2, 3, 5 respectively (see below) | confirmed |
| I4 | Intro | "Julia source scripts … are linked under each case" | Six links present, each to the matching script | confirmed |
| 1a | Case 1 heading | f(x)=3eˣ−4cos(x), p0=1.0, p1=0.9 | `secantmethodaa.jl` lines 10–12; matches Mathews Example 3 | confirmed |
| 1b | Case 1 | "converges quickly to the root near x ≈ 0.2549" | root 0.254850059028850 (mpmath findroot); script p9 = 0.25485005902885 | confirmed |
| 1c | Case 1 | "Both starting points are on the same side of the root" | 1.0 and 0.9 both > 0.2549 | confirmed |
| 1d | Case 1 | "first secant step lands at p2 ≈ 0.456, still 0.20 from the root" | p2 = 0.455750754, err 0.2009 | confirmed |
| 1e | Case 1 | errors "0.066 at p3, 0.0089 at p4, 4.4×10⁻⁴ at p5, 3.1×10⁻⁶ at p6" | 0.06588, 0.0089102, 4.4345e−4, 3.1151e−6 | confirmed |
| 1f | Case 1 | "consistent with the secant method's order ≈ 1.618 at this simple root" | log e_{n+1}/log e_n: 1.69, 1.74, 1.64, 1.64, 1.63, 1.626, 1.622, 1.621, 1.620, 1.619, 1.618 (`order.py`); f''(r)=3e^r+4cos r ≠ 0 | confirmed |
| 1g | Case 1 alt | "x-intercept converges rapidly to the root near x=0.2549" | frames 1–9: diamond labels 0.45575, 0.32073, 0.26376, 0.25529, 0.25485… | confirmed |
| 1h | Case 1 wiring | link `secantmethodaa.jl`, embed `secantmethodaa.gif` | manifest: GIF byte-identical to scratch regen of that script | confirmed |
| 2a | Case 2 heading | f(x)=1−10x+25x², p0=1.0, p1=0.9 | `secantmethodbb.jl` lines 11–13; Mathews Example 4 | confirmed |
| 2b | Case 2 | "(1−5x)² has a double root at x=0.2 where f'(0.2)=0"; "f(x)=25(x−0.2)²" | algebra: 25(x−0.2)² = 25x²−10x+1; f'(x)=50(x−0.2) | confirmed |
| 2c | Case 2 | "converges, but only linearly … ratio of successive errors settles at (√5−1)/2 ≈ 0.618" | error ratios 0.533, 0.652, 0.605, 0.623, 0.616, 0.6188, 0.6178, 0.61814, 0.617994, 0.618049, … 0.618034 from p15 on (`indep.py`) | confirmed |
| 2d | Case 2 | "each step removes only about 38% of the remaining error" | 1−0.618 = 0.382 | confirmed |
| 2e | Case 2 | "iterates creep toward the root over many iterations" | monotone from right; err still 8.8e−7 at p29 (last iterate drawn) | confirmed (but see F2: final legend says `p29 = 0.2`) |
| 2f | Case 2 alt | "iterates slowly approach the double root at x=0.2, demonstrating linear convergence" | frames 1–28 | confirmed |
| 2g | Case 2 wiring | `secantmethodbb.jl` / `.gif` | manifest byte-identical | confirmed |
| 3a | Case 3 heading | f(x)=arctan(x), p0=1.35, p1=1.30 | `secantmethodcc.jl` 11–13; Mathews Example 5 | confirmed |
| 3b | Case 3 | "converges to the root at x=0" | p7 = 4.8e−25, then 0 in double | confirmed |
| 3c | Case 3 | "iterates oscillate — jumping to the opposite side of the root each step before settling" | signs from p1: +, −, +, −, +, −, + (1.30, −1.2214, 0.018036, −0.0067233, 4.57e−7, −6.89e−12, 4.80e−25) | confirmed |
| 3d | Case 3 | "relatively flat slope of arctan near the starting points causes the secant line to overshoot to negative x on the first step" | secant slope (0.9151−0.93325)/(−0.05)=0.363 vs f'(0)=1; p2 = −1.22138 | confirmed |
| 3e | Case 3 alt | "iterates oscillate across x=0 with decreasing amplitude before converging" | |p| : 1.35, 1.30, 1.22, 0.018, 0.0067, 4.6e−7 … strictly decreasing | confirmed |
| 3f | Case 3 wiring | `secantmethodcc.jl` / `.gif` | manifest byte-identical | confirmed |
| 4a | Case 4 heading | f(x)=x³−x+3, p0=2.0, p1=1.0 | `secantmethoddd.jl` 11–13; Mathews Example 6 | confirmed |
| 4b | Case 4 | "has a real root near x ≈ −1.672" | −1.67169988165716 (mpmath); discriminant 4−243<0 so it is the only real root | confirmed |
| 4c | Case 4 | "Starting from positive values far from the root" | p0=2, p1=1; distances 3.67, 2.67 | confirmed |
| 4d | Case 4 | "iterates wander — including a large positive excursion — before eventually converging" | 0.5, −3.0, 0.111, −0.265, **3.1639**, −0.659, −1.118, −3.034, −1.329, −1.471, −1.735, −1.6625, −1.67132, −1.671702, −1.6716999 | confirmed |
| 4e | Case 4 | "convergence can occur even when the path is non-monotone" | sequence above | confirmed |
| 4f | Case 4 alt | "iterates wander through positive and negative values before converging to the root near x=−1.672" | frames; last label `p17 = -1.6717` | confirmed |
| 4g | Case 4 wiring | `secantmethoddd.jl` / `.gif` | manifest byte-identical | confirmed |
| 5a | Case 5 heading | f(x)=xe^{−x}, p0=1.5, p1=2.0 | `secantmethodee.jl` 11–13; Mathews Example 7 | confirmed |
| 5b | Case 5 | "has a root at x=0, the secant method diverges with these starting points" | iterates 4.11, 4.81, 5.78, … 17.33 at p19, 13874 at p20000 (`ee_asym.py`) | confirmed |
| 5c | Case 5 | "secant line through points on the decaying tail has a shallow negative slope whose x-intercept falls to the right — each step pushes the estimate further from the root" | p0,p1 > 1 (past the maximum); every step positive | confirmed |
| 5d | Case 5 | "after the first jump to p2 ≈ 4.11" | p2 = 4.113799 | confirmed |
| 5e | Case 5 | "each step moves right by less than 1" | max step after p2 over 20 000 iterations = 0.97156 (p4−p3) | confirmed |
| 5f | Case 5 | "the step tends to ln 2 ≈ 0.693" | steps 0.7737 (p10), 0.7360 (p20), 0.7026 (p100), 0.69414 (p1000), 0.69320 (p20000) → 0.693147; heuristic: fixed step d needs e^{−d}/(1−e^{−d})=1 ⇒ d=ln 2 | confirmed |
| 5g | Case 5 | "animation stops at p10 ≈ 10.57, the first iterate past the right edge of the window" | xlims (0,10.1); p9=9.801 inside, p10=10.5746 outside; n_iters=9; frame_009 legend "p10 = 10.57 (off chart, marker at edge)" | confirmed |
| 5h | Case 5 | "p16 ≈ 15.11" | 15.10597 | confirmed |
| 5i | Case 5 alt | "x-intercept steps progressively further right until p10≈10.57 leaves the window, illustrating slow divergence" | frames 1–9 | confirmed |
| 5j | Case 5 wiring | `secantmethodee.jl` / `.gif` | manifest byte-identical | confirmed |
| 6a | Case 6 heading | f(x)=arctan(x), p0=1.60, p1=1.50 | `secantmethodff.jl` 11–13; Mathews Example 8 | confirmed |
| 6b | Case 6 | "slightly larger starting values than Case 3, the method again converges to x=0" | p7 = −9.2e−17 | confirmed |
| 6c | Case 6 | "Despite a larger first overshoot" | p2 = −1.8425 vs Case 3 p2 = −1.2214 | confirmed |
| 6d | Case 6 | "subsequent steps quickly close in on the root" | −0.0975, 0.0762, −5.2e−5, 1.0e−7, −9.2e−17 | confirmed (note: closes in from alternating sides, see F1) |
| 6e | Case 6 | "convergence is super-linear, but because f''(0)=0 … asymptotic order here is 2 rather than … ≈1.618" | log-ratio sequence (400-digit run) 1.11, 3.83, 1.63, 2.29, 1.90, 2.07, 1.975, 2.016, 1.994 → 2; theory e_{n+1} ≈ (f'''/6f')e_n e_{n−1}² ⇒ p²=p+2 ⇒ p=2; constant check −(1/3)e6·e5² = −9.24e−17 vs p7 = −9.2253e−17 | confirmed |
| 6f | Case 6 alt | "iterates converge to x=0 after initial overshoot, showing super-linear convergence" | frames 1–6 | confirmed |
| 6g | Case 6 wiring | `secantmethodff.jl` / `.gif` | manifest byte-identical | confirmed |
| C1 | Counts | six cases, six scripts, six GIFs | manifest: 6 scripts, 6 GIFs, all linked/embedded | confirmed |

Fidelity: all six animated cases reproduce Mathews Examples 3–8 in function, starting values, plotting window (Mathews `PlotRange` matches the script `xlims`/`ylims` for Examples 3, 4, 6, 7, 8) and iteration count (9, 28, 16, 6; Example 5's count is unreadable because its images are missing). The one departure — Case 5 animates 9 steps instead of Mathews' n=16 — is stated and justified on the page (stops when the iterate leaves the identical 0–10.1 window, and quotes p16). Mathews Examples 1–2 are worked text examples (and Example 2 is about Newton's method), not animations; their absence is not a fidelity finding. No fidelity findings.

### 3. Implementation checks

Common to all six scripts: `ps[1]=p0, ps[2]=p1`, `ps[i+1] = ps[i] − f(ps[i])(ps[i]−ps[i−1])/(f(ps[i])−f(ps[i−1]))` — the plain two-point secant method (no bracketing/regula-falsi logic, no safeguards beyond a zero-denominator guard). Index bookkeeping: frame k draws the secant through ps[k]=p_{k−1} and ps[k+1]=p_k and marks ps[k+2]=p_{k+1}; legend labels `p$(frame-1)`, `p$frame`, `p$(frame+1)` therefore carry the correct indices. The clip routine computes the visible segment of the line through (pa,fa) with that slope; the drawn line passes through both blue points and the red diamond in every frame inspected. All committed GIFs are byte-identical to scratch regeneration (manifest), so the frames reflect the current scripts.

Script vs independent (double-precision Julia copy vs 50-digit mpmath):

| Case | Script iterates (Julia, `inst_*.jl`) | Independent (mpmath, `indep.py`) | Reference value |
|---|---|---|---|
| aa | p2 0.455750754163145, p3 0.320730532759921, p4 0.263760252635055, p5 0.255293513424209, p6 0.254853174145246, p7 0.254850060124434, p10 0.25485005902885 | 0.455750754163, 0.32073053276, 0.263760252635, 0.255293513424, 0.254853174145, 0.254850060124, 0.254850059029 | root 0.254850059028850 (findroot, residual 0) |
| bb | p2 0.573333333333333, p7 0.235, p15 0.200744779890941, p29 0.200000883485689 | 0.573333333333, 0.235, 0.200744779891, 0.200000883489 | exact root 0.2 (algebraic) |
| cc | p2 −1.22137920568602, p3 0.0180362981967259, p4 −0.006723294978555, p5 4.5722058131e−7, p6 −6.8886493391e−12, p7 4.798e−25, p8..p11 0 | −1.22137920569, 0.0180362981967, −0.00672329497856, 4.5722058131e−7, −6.8886493391e−12, 4.80018e−25, −7.59e−48 | exact root 0 |
| dd | p3 −3, p6 3.16390491609723, p9 −3.03422757678514, p12 −1.73465854048893, p15 −1.67170227686251, p17 −1.67169988165716 | −3.0, 3.1639049161, −3.03422757679, −1.73465854049, −1.67170227686, −1.67169988166 | root −1.67169988165716 |
| ee | p2 4.1137988733264, p5 6.59486756179027, p9 9.80098664631658, p10 10.5746397772281 | 4.11379887333, 6.59486756179, 9.80098664632, 10.5746397772 | root 0; divergence confirmed to p20000 = 13874 |
| ff | p2 −1.84246196013364, p3 −0.0974833864747393, p4 0.076193229514678, p5 −5.23681503041e−5, p6 1.01113409320e−7, p7 −9.225344e−17 | −1.84246196013, −0.0974833864747, 0.0761932295147, −5.23681503041e−5, 1.0111340932e−7, −9.22534493586e−17 | exact root 0 |

Agreement is to every printed digit except where double precision legitimately bottoms out (cc p7 4.7983e−25 vs 4.8002e−25, cc p8 = 0 vs −7.6e−48, ff p7 last digits) — irrelevant to anything shown.

Per script:

- **secantmethodaa.jl** — Method: plain secant. Numbers: match independent run (table). Reference: root 0.2548500590 verified by mpmath findroot; order → 1.618 verified. Picture: frames 1, 2, 5, 9 inspected; secant through (p0,f(p0)) and (p1,f(p1)) hits y=0 at the diamond labelled `p2 = 0.45575`; window (0,1)×(−1,6) contains all iterates (f(p0)=5.994 just inside). Title function matches code. No issues.
- **secantmethodbb.jl** — Method: plain secant. Numbers: match (table); error ratio → 0.618034 verified. Reference: exact root 0.2. Picture: frames 1, 4, 10, 28 inspected; geometry correct; clamping never activates (all iterates in [0,1], f ≤ 16). The visual creep is invisible after ~frame 10 at this scale (inherent to Mathews' window, not a finding), and the legend's 5-decimal rounding shows `= 0.2` for p26–p29 → **F2**.
- **secantmethodcc.jl** — Method: plain secant. Numbers: match. Reference: root 0. Picture: frames 1–10 inspected; frame 1 secant through (1.35, 0.933) and (1.30, 0.915) meets y=0 at −1.22138. Frames 8–10 contain no secant and no new iterate because in double precision p8 = p9 = … = 0 exactly (p7 − atan(p7)·1 cancels), so f(pb)−f(pa) < 1e−14 and the drawing block is skipped; those three frames only re-show the converged point — harmless padding, not reported. Labels `p5 = 0.0`, `p6 = -0.0` hide the sign alternation the page describes; mentioned under F2.
- **secantmethoddd.jl** — Method: plain secant with an early-exit test (`abs(ps[i+1]-ps[i]) < 1e-8 && i > 4`). That test first fires at i = 17 (|p17−p16| = 6.2e−10), which is the final loop iteration, so it has no effect; `n_iters_actual` is unused. (Had it fired earlier, the remaining `undef` entries would have been plotted — a latent robustness issue only, not a finding.) Numbers: match. Reference: root −1.6716999 verified; comment "Real root near x ≈ −1.6717" and the ylims comment "f(p3) = −21 and f(p9) ≈ −21.9" verified (f(−3) = −21, f(−3.0342) = −21.90). Picture: frames 1, 3, 5, 8, 16 inspected; p6 = 3.1639 with f = 31.51 stays inside ylims 32 and xlims 3.5, so no clamping affects any drawn iterate; diamond labels to 4 decimals correct.
- **secantmethodee.jl** — Method: plain secant with a divergence cut-off at |p|>1e6 (never reached in 9 steps). Numbers: match. Reference: root 0; step limit ln 2 verified. Picture: frames 1, 5, 9 inspected; frame 9 correctly reports the off-window iterate as `p10 = 10.57 (off chart, marker at edge)` with a hollow edge marker — the clamped marker is labelled with the true value, so it is not misleading. The soft-scope warning about `n_valid` (unused) is harmless.
- **secantmethodff.jl** — Method: plain secant. Numbers: match. Reference: root 0; order 2 verified numerically and by the error-constant check. Picture: frames 1–6 inspected; frame 1 secant through (1.6, 1.012) and (1.5, 0.983) meets y=0 at −1.84246 within xlims (−3,2). Header comment "converges directly" is false → **F1**.

Could not determine: Mathews' iteration count and window for Example 5 (arctan, p0=1.35) — the archive images gr_368–383 are missing; the script's 10 iterations and window (−3,2)×(−1.25,1.15) (same as Example 8) are plausible but unverified against the source.

