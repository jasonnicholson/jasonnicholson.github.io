# Damped Newton with Acceleration (Madsen-Reid Method) — animation review

Page: [`pages/numerical-methods/madsen-reid-method/index.qmd`](../../pages/numerical-methods/madsen-reid-method/index.qmd) · Scripts: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl` · GIFs: 3

**Result:** 3 error, 0 misleading, 4 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — The "acceleration" the page names the method after is not implemented; r0 is only a cap that never activates

- **Location:** madsreidaa.jl:44-48, madsreidab.jl:41-45, madsreidac.jl:42-46; page index.qmd:12-18 ("Madsen-Reid avoids this by taking **multiple steps in the same direction** — the step-size limit $r_0$ is *increased* fivefold after each accepted step: $r_0 \leftarrow 5|\Delta z|$ … This acceleration allows the iterates to accelerate toward the root rather than stalling, recovering quadratic-like convergence in practice"), and title "Damped Newton with Acceleration".
- **Now:** The only "acceleration" code is `r0 = r * 5.0`, where `r` is the length of the current (unclipped) Newton step, executed on every iteration including damped ones. r0 is used only as an upper bound: `if r > r0; dz = dz*(r0/r)`. A cap can only shorten a Newton step, never lengthen it, and the code never tries z − k·Δz for k ≥ 2.
- **True:** r0 is *reset* to 5× the latest Newton step, so it shrinks as the steps shrink (Case 2 trace: r0 = 10, 6, 3.79, 2.31, 1.34, 0.745, … 0.00335). It is not "increased fivefold after each accepted step". It never clipped any step in any of the three animations, so it has no effect on what is shown. With no step-lengthening mechanism, the iteration at a double root is exactly plain Newton and converges linearly (see F2). The page's own description of the mechanism ("multiple steps in the same direction") is absent from the code. (From the reviewer's recollection, not verifiable here because the 1975 report is unavailable: Madsen's algorithm, after a successful step, tries z − pΔz for p = 2, 3, … up to the degree while |f| keeps decreasing. That matches the page's wording, not the code.)
- **Evidence:** `julia reviewer/instr.jl`: every iteration of aa (6 steps), ab (14 steps) and ac (7 steps) prints `clip=false`. ab error ratios → 0.6000, 0.5789, 0.5571, …, 0.5001 (linear, ratio 1/2). `python3 reviewer/indep.py`: plain Newton written from scratch reproduces the ab iterates to ≥12 digits (e.g. x14 = 1.000335413657…), so the script's "Madsen-Reid" sequence is identical to unmodified Newton. For illustration, the same script with a k·Δz acceleration (k ≤ 3) gives errors −0.6, 8.6e-2, 1.2e-3, 2.3e-7, 8.8e-15 (superlinear).
- **Suggested fix:** Either implement the acceleration the page describes (after a decreasing step, try z − 2Δz, z − 3Δz, … up to the degree n while |f|² keeps decreasing, and keep the best point), and then regenerate Case 2. Or retitle and rewrite the page as "damped (backtracking) Newton on |f|²", delete the acceleration claims in lines 12-18 and 53, and describe r0 as a step-length cap of 5× the previous step.

- **Independent check:** confirmed.

### F2 — Error — Page match — Case 2 claims damping, acceleration and faster-than-linear convergence; the animation shows plain linear Newton with no damping

- **Location:** index.qmd:53 ("The Madsen-Reid acceleration mechanism — growing $r_0$ fivefold each step — allows the iterates to accelerate past the stalling zone, recovering faster-than-linear convergence. Orange (Stage 1) frames show where the step is damped to control overshoot; blue (Stage 2) frames show the accelerated Newton phase."); alt text index.qmd:57 ("mixed Stage 1 damping and Stage 2 acceleration converging to the double root at x=1").
- **Now:** The page and alt text describe orange damped frames, an accelerated phase and faster-than-linear convergence.
- **True:** All 14 steps are full, undamped Newton steps (label `:newton`, 0 halvings, no clip). There is no orange segment in any of the 15 frames. The error ratio is 0.60, 0.58, 0.56, … → 0.5001: linear convergence with ratio (m−1)/m = 1/2, exactly what the page says standard Newton would do. The run stops at the iteration cap (n_iters = 14), not the tolerance, with x14 = 1.000335 (error 3.35e-4, |P| ≈ 3.4e-7). The last legend reads "x14 = 1.00034".
- **Evidence:** `julia reviewer/instr.jl` (=== ab block) and `python3 reviewer/indep.py` ("Case2 plain Newton" and "error ratios"). Frames viewed: committed/madsreidab/sheet.png and frame_015.png, all blue.
- **Suggested fix:** If the acceleration is implemented (F1), regenerate and rewrite this paragraph from the new numbers. Otherwise rewrite it to say that every step is an accepted undamped Newton step, that convergence is linear with the error halving each step (ratio → 0.5), and that after 14 steps x ≈ 1.00034. Fix the alt text to match.

- **Independent check:** confirmed.

### F3 — Error — Page match — Wrong explanation of why Newton slows at a multiple root

- **Location:** index.qmd:14 ("Standard Newton-Raphson degrades to *linear* convergence at a root of multiplicity $m > 1$ because $f'(x^*) = 0$, which inflates each step.")
- **Now:** The page says the step is "inflated".
- **True:** Near a root of multiplicity m, f/f' ≈ (x − x*)/m, so each Newton step is too *short*: it covers only 1/m of the remaining distance, and the error ratio is (m−1)/m. The iterates undershoot; they are not inflated.
- **Evidence:** Case 2 (m = 2) trace: step/remaining-error = 1.2/3.0 = 0.40 on the first step, → 0.50 thereafter; error ratio → 0.5 (`reviewer/instr.jl`, `reviewer/indep.py`).
- **Suggested fix:** "…because $f'(x^*) = 0$: near the root $f/f' \approx (x-x^*)/m$, so each Newton step covers only $1/m$ of the remaining distance and the error shrinks by the factor $(m-1)/m$ per step."

- **Independent check:** confirmed. Severity changed from Misleading to Error. Upgraded from Misleading by the director: the checker showed the Newton step at the double root is exactly half the distance to the root in the limit (0.4999 in the run), so the page states the opposite of what happens.

### F4 — Minor — Page match — "The star markers show the exact root(s)": Cases 1 and 2 have no root markers

- **Location:** index.qmd:39.
- **Now:** The section intro says star markers show the exact roots.
- **True:** Only madsreidac.jl draws stars (line 118). madsreidaa.jl and madsreidab.jl draw no root marker of any kind.
- **Evidence:** Code reading (no `scatter!` of a root in aa/ab); frames committed/madsreidaa/sheet.png and committed/madsreidab/sheet.png show no star.
- **Suggested fix:** Add a star at x* = 1.879385 (aa) and x* = 1 (ab, optionally −2), or say "In Case 3, star markers show the exact roots."

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Page match — Case 1 implies damping in the first frames; there is none

- **Location:** index.qmd:45 ("…with no damping needed after the first couple of frames.")
- **Now:** The text implies the first couple of steps are damped.
- **True:** All 6 steps are full Newton steps (label `:newton`, 0 halvings, no clip). There is no orange segment in any frame.
- **Evidence:** `julia reviewer/instr.jl` (=== aa block); committed/madsreidaa/sheet.png, all segments blue.
- **Suggested fix:** "…converges quadratically to x* ≈ 1.8794 using full Newton steps throughout; no damping occurs."

- **Independent check:** not run (minor finding, unverified).

### F6 — Minor — Page match — Case 3: not every orange segment is an alterdirection escape, and the path is not curved

- **Location:** index.qmd:61 ("The path traces a curved trajectory in $\mathbb{C}$ … orange segments with direction changes are the `alterdirection` escapes.")
- **Now:** The text implies the orange segments are alterdirection escapes.
- **True:** There are 3 orange segments. Segment 1 (z0 = 1 → z1 = −0.25) is a single halving of the real Newton step. Segment 2 (z1 → z2 = 0.0547 + 0.4063i) is the only alterdirection step (all 4 halvings failed: |f|² 16.536 vs 16.504, then a rotation of 53.13°). Segment 3 (z2 → z3 = −0.284 + 2.722i) is again a single halving (the full Newton step would give |f|² = 480). Segments 4-7 are blue full Newton steps. The path is a polyline of straight segments, not a curve.
- **Evidence:** `julia reviewer/instr.jl` (=== ac block: `halv=1 alt=false`, `halv=4 alt=true`, `halv=1 alt=false`). An independent hand replay in `reviewer/indep.py` reproduces z1, z2, z3 and the full-Newton |f|² = 480.4. Frames committed/madsreidac/frame_004.png and frame_008.png viewed.
- **Suggested fix:** "Orange segments are Stage 1 steps: the first and third are halved Newton steps, and the second is the `alterdirection` rotation that leaves the real axis. The path is a polyline converging to +2i."

- **Independent check:** not run (minor finding, unverified).

### F7 — Minor — Implementation / Page match — alterdirection is accepted unchecked; in the real scripts it is a reversal, not a 53° rotation

- **Location:** madsreidaa.jl:22-26, 67-70; madsreidab.jl:22-24, 64-67; madsreidac.jl:65-68; page index.qmd:25 ("`alterdirection` rotates the step by approximately $53°$") and index.qmd:27 ("The dual-stage structure guarantees that $|f(z)|^2$ is a monotonically non-increasing Lyapunov function").
- **Now:** The page says alterdirection rotates the step and that the dual-stage structure guarantees |f|² never increases.
- **True:** After failed halvings, the alterdirection point is accepted without a descent test, so the code does not guarantee monotone |f|². In aa/ab, `alterdirection(dz) = −0.6·dz` reverses the (descent) step, which to first order *increases* |f|². Applying that routine to x² + 4 at x = −0.25 (where the halvings fail) gives |f|² 16.504 → 18.556. This path is never exercised in Cases 1 and 2, and in Case 3 the accepted rotated step happened to decrease |f|² (16.504 → 14.732). So all three animations are monotone in |f|², but by circumstance rather than by guarantee.
- **Evidence:** `python3 reviewer/indep.py` ("real alterdirection test"); `julia reviewer/instr.jl` (|f|² columns strictly decreasing in all three runs).
- **Suggested fix:** In the code, after alterdirection, check |f|² and keep rotating or shrinking until it decreases (or keep the old z), and make the real-script routine a genuine rotation (or remove it, since a real iterate cannot be rotated without going complex). On the page, soften "guarantees" to "is designed so that".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `madsreidaa.jl` | yes | 2.9 | madsreidaa.gif |
| `madsreidab.jl` | yes | 3.4 | madsreidab.gif |
| `madsreidac.jl` | yes | 3.4 | madsreidac.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 2 | Title "Damped Newton with Acceleration" | Damping present; no acceleration in code | wrong (→ F1) |
| 2 | 14 | "Standard Newton-Raphson degrades to *linear* convergence at a root of multiplicity m>1" | ab ratios → 0.5 | confirmed |
| 3 | 14 | "because f'(x*)=0, which inflates each step" | steps are 1/m of remaining distance (undershoot) | wrong (→ F3) |
| 4 | 14 | "Madsen-Reid avoids this by taking multiple steps in the same direction" | no k·Δz step anywhere in code | wrong (→ F1) |
| 5 | 14-16 | "step-size limit r0 is increased fivefold after each accepted step: r0 ← 5\|Δz\|" | r0 reset to 5·\|Newton step\| every iteration; decreasing; never clips | wrong (→ F1) |
| 6 | 18 | "acceleration allows the iterates to accelerate … recovering quadratic-like convergence … even when f'(x*) is small" | Case 2 linear, ratio 0.5 | wrong (→ F1, F2) |
| 7 | 22 | Stages chosen by "whether the current Newton step reduces \|f\|²" | code lines aa:53, ab:50, ac:51 | confirmed |
| 8 | 24 | Stage 2: full step Δz = f/f' accepted if it reduces \|f\|² | code; trace | confirmed (when the r0 cap is inactive, which is always in these runs) |
| 9 | 25 | Stage 1: "step is repeatedly halved (up to 4 times)" | `for _ in 1:4; dz*=0.5` | confirmed |
| 10 | 25 | "If halving fails, alterdirection rotates the step by approximately 53° and scales it" | ac: rotation atan2(0.8,0.6) = 53.13°, scale m (=1 here); aa/ab: ×(−0.6), not a rotation | confirmed for ac; wrong for aa/ab, never exercised there (→ F7) |
| 11 | 27 | "guarantees that \|f(z)\|² is monotonically non-increasing" | alterdirection accepted unchecked; real version increases \|f\|² in a test; all three runs happen to be monotone | wrong as a guarantee (→ F7) |
| 12 | 31 | Uses "only f and f′" | code evaluates only f, fp | confirmed |
| 13 | 33 | Deflation after each root | no deflation in any script; each animation finds a single root | could not determine (not part of the animated code; not contradicted for one-root animations) |
| 14 | 35 | Generalization note | not checkable against these scripts | could not determine (not a checkable claim about the scripts) |
| 15 | 39 | "Each animation shows the iteration path of the Madsen-Reid method" | shows a damped-Newton path (see F1) | wrong (→ F1) |
| 16 | 39 | "Blue segments indicate accepted Newton steps (Stage 2); orange … damped or direction-altered steps (Stage 1)" | colouring code aa:96, ab:93, ac:127 matches labels | confirmed |
| 17 | 39 | "The star markers show the exact root(s)" | stars only in ac | wrong (→ F4) |
| 18 | 41 | Julia source linked under each case | lines 47/55/63 link to the producing scripts (manifest) | confirmed |
| 19 | 43 | Case 1: P(x)=x³−3x−1, x0=3.0 | aa:10, aa:14 | confirmed |
| 20 | 45 | "Three simple real roots exist" | mpmath: −1.532089, −0.347296, 1.879385 | confirmed |
| 21 | 45 | "begins with Stage 2 Newton steps" | all 6 steps `:newton` | confirmed |
| 22 | 45 | "converges rapidly to the root near x* ≈ 1.8794" | x6 = 1.879385241571817; 2cos(π/9) = 1.8793852415718 | confirmed |
| 23 | 45 | "convergence is quadratically fast" | errors 4.1e-1, 8.6e-2, 5.0e-3, 1.9e-5, 2.6e-10; e_{k+1}/e_k² → 0.74 ≈ f''/(2f') = 0.742 | confirmed |
| 24 | 45 | "no damping needed after the first couple of frames" | no damping at any step | wrong (→ F5) |
| 25 | 49 | Alt: "tangent-line animation … rapid Stage 2 Newton convergence from x₀=3.0 to … x≈1.8794" | segments from (x_n, P(x_n)) to (x_{n+1}, 0) are tangents since all steps are full Newton; frames viewed | confirmed |
| 26 | 51 | Case 2: P(x)=(x−1)²(x+2), x0=4.0 | ab:10 (sympy factor = (x−1)²(x+2)), ab:14 | confirmed |
| 27 | 53 | "double root at x*=1 where P'(x*)=0" | P'(1)=0; numpy roots −2, 1, 1 | confirmed |
| 28 | 53 | "Standard Newton-Raphson would converge only linearly here" | ratio → 0.5 | confirmed |
| 29 | 53 | "acceleration … growing r0 fivefold each step … recovering faster-than-linear convergence" | linear ratio 0.5, r0 decreasing, never clips | wrong (→ F2) |
| 30 | 53 | "Orange (Stage 1) frames show where the step is damped" | no orange; 0 halvings in all 14 steps | wrong (→ F2) |
| 31 | 53 | "blue (Stage 2) frames show the accelerated Newton phase" | blue = plain Newton, identical to unmodified Newton | wrong (→ F2) |
| 32 | 53 | "The simple root at x=−2 may also be found depending on which root the deflation targets first" | no deflation; this run only approaches x=1 | wrong for this animation (→ F2, which asks for this paragraph to be rewritten) |
| 33 | 57 | Alt: "mixed Stage 1 damping and Stage 2 acceleration converging to the double root at x=1" | no Stage 1; approaches 1 linearly; last iterate 1.000335 at the iteration cap | wrong (→ F2) |
| 34 | 59 | Case 3: P(z)=z²+4, z0=1+0i | ac:12, ac:78 | confirmed |
| 35 | 61 | "roots are z*=±2i — there are no real roots" | mpmath polyroots ±2i | confirmed |
| 36 | 61 | "real-axis Newton iterates cannot reach a real root and stagnate" | one real step to −0.25; next real Newton step and all 4 halvings fail to reduce \|f\|² (16.536 vs 16.504) | confirmed (loosely: "stagnate" = backtracking fails at z1) |
| 37 | 61 | "alterdirection mechanism rotates the step into the complex plane, allowing the iterates to escape the real axis" | step 2: 53.13° rotation to 0.0547+0.4063i | confirmed |
| 38 | 61 | "The path traces a curved trajectory" | polyline of straight segments | wrong (→ F6) |
| 39 | 61 | "converging to z*=+2i" | z7 = 1.0e-12 + 2.0000000000004i; \|z7−2i\| = 1.1e-12 | confirmed |
| 40 | 61 | "Blue segments are Stage 2 Newton steps" | segments 4-7 blue, all full Newton | confirmed |
| 41 | 61 | "orange segments with direction changes are the alterdirection escapes" | only segment 2 of 3 orange is alterdirection | wrong (→ F6) |
| 42 | 65 | Alt: "iterates escape the real axis via alterdirection and converge to the root at z=+2i" | as above | confirmed |

## Implementation checks

### madsreidaa.jl
- **Method:** backtracking Newton on |f|² with an r0 cap and a reversal fallback (see header). In this run only full Newton steps occur (6/6 `:newton`, no clip, no halving), so the animation is plain Newton's method.
- **Numbers:** script x0..x6 = 3.0, 2.291666666666667, 1.965507463363731, 1.884402431976105, 1.879403819763339, 1.879385241827991, 1.879385241571817. Independent plain Newton in mpmath (indep.py) gives the same values to all printed digits. Quadratic constant e_{k+1}/e_k² → 0.74, which matches f''/(2f') = 0.742 at x*.
- **Reference values:** root 1.87938524157181676… (mpmath polyroots = 2cos(π/9)); page "≈ 1.8794" is correct. No reference marker is drawn (F4).
- **Picture:** contact sheet (all 7 frames). Segments run from (x_n, P(x_n)) to (x_{n+1}, 0) plus a vertical line back to the curve, all blue as the labels say. Legend "x_k = …" matches the computed iterates rounded to 5 digits. P(3) = 17 lies within ylims (−5, 22). No clamping involved.

### madsreidab.jl
- **Method:** same as aa. All 14 steps are full Newton (no clip, no halving), so the run is identical to unmodified Newton. It stops at n_iters = 14, not at the tolerance.
- **Numbers:** script x14 = 1.000335413657196 vs independent mpmath Newton 1.000335413657244 (agreement to about 13 digits; the difference is float rounding near the double root). Error ratios 0.6000, 0.5789, 0.5571, 0.5375, 0.5225, 0.5126, 0.5067, 0.5035, 0.5018, 0.5009, 0.5004, 0.5002, 0.5001, 0.5001: linear, as theory gives for m = 2.
- **Reference values:** roots −2, 1, 1 (numpy roots, sympy factor). No marker drawn.
- **Picture:** contact sheet and frame_015. All segments are blue, and the legend "x14 = 1.00034" matches. P(4) = 54 lies within ylims (−4, 60). Nothing is clamped. Nothing in the frames shows damping or acceleration (F2).

### madsreidac.jl
- **Method:** same scheme in ℂ; here alterdirection is a genuine rotation by 53.13° times m. Steps: 1 halved (damped), 2 alterdirection after 4 failed halvings, 3 halved, 4-7 full Newton. The r0 cap (rotating clip) never fires.
- **Numbers:** script z1..z7 = −0.25; 0.0546875 + 0.40625i; −0.2844475 + 2.7224136i; −0.0662946 + 2.0879157i; −0.0027633 + 2.0008862i; −1.226e-6 + 1.9999983i; 1.05e-12 + 2.0000000000004i. An independent mpmath replay following the page's stated stage rules (indep.py) reproduces every value to all printed digits. |f|² decreases monotonically: 25 → 16.50 → 14.73 → 13.49 → 0.203 → 1.35e-4 → 7.1e-11 → 2.0e-23.
- **Reference values:** stars at ±2i; mpmath polyroots gives ±2i. Correct.
- **Picture:** frames 4 and 8 checked. Path segments connect consecutive iterates with the correct colours (3 orange, 4 blue). The legend "z7 = 0.0 + 2.0i" and the axis limits (Re −2.5..2.5, Im −2.8..3.22) contain every iterate, so nothing is clamped. The aspect ratio is equal. The plotted path is a polyline (F6).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/madsen-reid-method/`](evidence/madsen-reid-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
