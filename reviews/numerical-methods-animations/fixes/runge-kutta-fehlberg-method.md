# Fix record: runge-kutta-fehlberg-method

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/runge-kutta-fehlberg-method/fix/` (below: `$FIX`). Python checks run as `/usr/bin/python3 -I $FIX/py/<script>.py $FIX/py [args]`, and each output is saved beside its script as `<script>.out`.

- `py/rkf.py`: an independent RKF4(5) implementation. It uses the exact rational tableau and both controller rules: `perstep` (the old one) and `perunit` (the new one).
- `py/f4_scaling.py`: |y5 − y4| for one step as h is halved (F4).
- `py/orig_case2.py`, `py/newrule.py`: the old controller reproduced independently (F1, F2).
- `py/stability.py`: exact stability polynomials of the y4 and y5 updates (sympy), and their real-axis limits (mpmath).
- `py/case2.py`, `py/case2_more.py`: Case 2 under the new rule: the step table, h·|∂f/∂y|, the tolerance-scaling test, |J| monotonicity, the steepest slope and the peak.
- `py/tolscan.py`: accepted-step counts against tolerance.
- `py/check_pts.py`, `py/ledger.py`, `py/c1_mono.py`: compare the page scripts' own accepted points with the independent code, and compute every number on the page.
- `jl/inst.jl`: runs a page script up to the animation and dumps the accepted points (`jl/pts_aa.txt`, `jl/pts_bb.txt`, `jl/inst_*.out`).
- `r1/`: the round-1 evidence, copied. `r1/controller_orig.out` is a re-run of `reviewer/controller.jl` against the old code.
- `orig_gif/`, `new_gif/`: extracted frames, contact sheets and `frames.md5` for the committed and the regenerated GIFs.

## Findings

### F1 — Error — fixed
- **Reproduced:** `py/orig_case2.py` (independent, old controller) and `r1/controller_orig.out` (the old script's code):
  - Case 2 takes the cap h = 0.25 for every step from t = 0.1 to 2.35.
  - The smallest step is 0.0540, at t = 3.2732. Tail steps for t ≥ 3 are 0.054–0.0725.
  - The largest error at the accepted points is 2.41e-6 (RKF45) and 8.06e-7 (RKF54).
  - The polyline is at most 0.0091 from the reference, at t = 0.475.
  - The steepest slope is y′ = −0.9303 at t = 2.1945 (`py/case2.py`, DOP853 rtol 1e-13).

  So the steps do not tighten in the steep part. The finding holds.
- **Change:** the controller changed for F4 (see below), so all of Case 2's step numbers were recomputed for the new code before writing. In `index.qmd`, the Case 2 Behavior paragraph is replaced. It now says:
  - the runs match the reference to 7e-7;
  - the step is held at the cap 0.25 over the hump (0.1 ≤ t ≤ 1.35) and stays between 0.189 and 0.25 until t ≈ 2.4, past the steepest point;
  - the step is cut below 0.04 from t = 3, with the smallest step 0.027 at t ≈ 3.27;
  - the visible corners come from the drawn segments (up to 0.0091 below the curve near t = 0.48), not from integration error;
  - a D2 sentence on the stability limit.
- **Check:** see `py/ledger.out` and `py/case2.out`, and the ledger rows below. The RKF45 step table in `py/case2.out` shows h = 0.25 at t_i = 0.10, 0.35, 0.60, 0.85 and 1.10, then 0.2435, 0.2176, 0.1989, 0.1891 and 0.2001 up to t = 2.3992, then 0.1029, and from there down to 0.0274 at t = 3.2716. In frame 7 of the new GIF (t up to 1.35) the dashed curve shows above the straight magenta/blue segments on the hump.

### F2 — Misleading — fixed
- **Reproduced:**
  - `r1/controller_orig.out` shows `case1 rkf45 accepted=59 rejected=12 attempts=71` and the same counts for rkf54. Over the points, max |t45 − t54| = 7.616e-07 and the largest relative difference in h is 2.402e-06.
  - `py/newrule.py` (independent) gives the same counts. y(1.1) is 139.913371 for RKF45 and 139.898228 for RKF54, with errors 3.053e-2 and 1.539e-2.
  - Committed `orig_gif/aa/frame_060.png` shows no magenta: the blue line is drawn over it at the same width.

  The finding holds.
- **Change:**
  - In both scripts, RKF45 is now drawn underneath at `lw=5` with marker `ms=7`, and RKF54 on top at `lw=2` with marker `ms=4`. Before, both were drawn at lw 2.2 with ms 4.
  - In `index.qmd`, the Case 1 sentence "The accepted-step distributions differ slightly, reflecting the 4th-order vs 5th-order accepted update choice." is replaced. The new text says the two runs share the error estimate and step rule, so their steps agree to within 0.05% and the curves coincide (blue over magenta). They differ only in whether y4 or y5 is carried forward, and RKF54 ends closer to the exact value: errors 3.2e-3 against 4.5e-3 at t = 1.1. These numbers are for the new controller.
- **Check:**
  - `py/check_pts.out` (the script's own points) gives a largest relative h difference of 4.105e-4 (excluding the clipped last step) and max |t45 − t54| = 1.0e-7. The end errors are 4.517e-3 and 3.154e-3, a ratio of 1.43.
  - In `new_gif/aa/frame_066.png` and `new_gif/bb/frame_081.png` the magenta band is visible on both sides of the blue line, and the legend shows the thick magenta and thin blue lines.

### F3 — Misleading — fixed
- **Reproduced:**
  - In `orig_gif/aa/frames.md5`, the last 31 frames (30–60) share one checksum.
  - mpmath gives y = 20 at t = 1.0571903, a pole at 1.1071487 and y(1.1) = 139.88284 (`py/check_pts.out`).

  The finding holds.
- **Change:** `rungekuttafehlbergaa.jl`:
  - The y-axis is now logarithmic: `yscale=:log10`, `ylims = (0.4, 200)`, explicit ticks 0.5 to 100, and ylabel "y (log scale)". Before, `ylims = (0.0, 20.0)`.
  - `xlims` (0, 1.1) → (−0.02, 1.12), so the start and end markers are not clipped.
  - The new controller (F4) accepts 258 steps, so the frames go through every 4th accepted point plus the last: `frames = unique(vcat(1:4:n_points, n_points))`, 66 frames at fps = 2.
  - Page: the Case 1 Behavior paragraph now says the log axis keeps the whole run in view. It gives the accuracy, y(1.1) = 139.88, the pole, how the step shrinks from 0.136 to 5e-5, that 187 of 259 points lie in t ≥ 1.05, and that the marker slows. The alt text adds "with y on a logarithmic axis".
- **Check:**
  - `new_gif/aa/frames.md5` has 66 frames with no repeated consecutive checksum (`uniq -c` printed nothing above 1). The same holds for bb (81 frames).
  - Frame 66 shows the markers at (1.1, ≈140), just above the 100 tick and inside the frame.
  - Per-frame advance in t never increases (`py/c1_mono.out`: True). 48 of the 66 frames have the marker at t ≥ 1.05 (`py/ledger.out`), so the slow-down is visible.

### F4 — Minor — fixed
- **Reproduced:** `py/f4_scaling.py` (independent) gives |y5 − y4| for one step with h = 0.2/2^k:
  - Case 1, t = 0: ratios per halving 9.70, 24.98, 29.14, 30.71 and 31.35 (p → 4.97).
  - Case 2, t = 1: ratios 34.69, 33.19, 32.56, 32.33 and 33.25 (p → 5.06).

  So err ∝ h^5, and (tol/err)^{1/4} is not the asymptotically consistent pairing. The archive shows Mathews' rule as s = (εh/(2|z − y|))^{1/4} = 0.840896(εh/|z − y|)^{1/4} (image `RungeKuttaFehlbergMod_gr_5.gif`), and 0.5^{1/4} = 0.8408964. The finding holds.
- **Change:**
  - Both scripts: the acceptance test `err <= tol` → `err <= tol * h`, and `s = 0.84 * (tol / err)^(1/4)` → `s = 0.84 * (tol * h / err)^(1/4)`, with comments. The tolerance stays 1e-6, and hmin, hmax and h0 are unchanged. The tolerance is now per unit step, which is consistent with the 1/4 exponent because err/h ∝ h^4.
  - `index.qmd` Description: the rule is now written out, with |y5 − y4| estimating the local error of y4, shrinking like h^5, the error per unit step |y5 − y4|/h, acceptance when that is ≤ ε, and s = 0.84(εh/|y5 − y4|)^{1/4}.
  - `rungekuttafehlbergbb.jl`: fps 2 → 3, because Case 2 now has 81 frames (RKF54 has 80 accepted steps), which plays in 27 s.
- **Check:**
  - `py/check_pts.out`: the scripts' accepted points match the independent `perunit` implementation. Case 1 has 259 points in both (max |Δt| 7.5e-8). Case 2 has 80 and 81 points (max |Δt| 1.8e-10). The final values are 139.887359 / 139.885997 and 0.0081198889 / 0.0081199107.
  - Accuracy improved in both cases. Case 1's largest relative error is 3.23e-5, against 2.18e-4 before. Case 2's largest error is 6.6e-7 / 9.4e-8, against 2.4e-6 / 8.1e-7.

### D2 (ODE step size) — applied to Case 2
- RKF is adaptive, so no fixed step was chosen. I checked that the controller's steps are stable and that they are set by accuracy rather than stability.
- **Stability limits** (`py/stability.py`, exact): R4(z) = 1 + z + z²/2 + z³/6 + z⁴/24 + z⁵/104, real-axis limit −3.0200175, so h < 0.07320 at J(5) = −41.2554. R5(z) = … + z⁵/120 + z⁶/2080, limit −3.6777066, so h < 0.08914.
- |J| increases monotonically on [0,5] (`py/case2_more.out`: True).
- The accepted steps keep h·|J(t_{i+1})| ≤ 1.270 (RKF45) and 1.274 (RKF54), well inside the limit.
- **Accuracy-limited** (`py/case2_more.out`): changing tol from 1e-6 to 1e-8 changes h at t = 3.27 from 0.0274 to 0.0089 (×3.08) and at t = 4.5 from 0.0344 to 0.0116 (×2.97). Pure accuracy control predicts 100^{1/4} = 3.16.
- One sentence was added to the Case 2 Behavior paragraph. After the shared D2 wording correction (`patterns/d2wording.md`), it says that for fixed steps longer than about 0.0732, h|∂f/∂y| would exceed the RKF4 limit 3.02 before t = 5, and that every accepted step keeps h|∂f/∂y| below 1.3. It no longer says "become unstable". It is true of what the controller does: the accepted steps' largest h|J| is 1.270 (RKF45) and 1.274 (RKF54), so no accepted step comes near the threshold.
- At tol = 1e-4 (not used) the controller accepted a step with h|J| = 4.49 > 3.02 (`py/case2_more.out`), so the page does not claim that the controller always keeps the steps stable. It only reports the values for this run.

## Ledger of changed text

All "script points" values come from `jl/inst.jl`, which dumps the page scripts' own accepted points. Reference for Case 1: mpmath tan at 30 digits. Reference for Case 2: scipy DOP853, rtol 1e-13 / atol 1e-16. Round-1 checks put the page's RK4 h = 1e-4 reference within 3.7e-13 of it.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Description | "$\|y_5-y_4\|$ estimates the local error of $y_4$" | y5 is order 5 and y4 order 4 (round-1 `order_conditions.py`: b4 meets the conditions to order 4, b5 to order 5), so y5 − y4 = (y5 − y) − (y4 − y) ≈ −(local error of y4) | yes |
| index.qmd Description | "It shrinks like $h^5$" | `py/f4_scaling.out`: ratios → 31.35 (case 1) and 33.25 (case 2), p = 4.97 / 5.06 | yes |
| index.qmd Description | "$\|y_5-y_4\|/h$ is an error per unit step that shrinks like $h^4$" | follows from h^5 / h | yes |
| index.qmd Description | "accepted when $\|y_5-y_4\|/h\le\varepsilon$" | script: `if err <= tol * h \|\| h <= hmin`. The hmin branch is never used: the smallest controller step is 4.97e-5 > 1e-6 (`py/ledger.out`) | yes |
| index.qmd Description | "$h_{new}=sh$ with $s=0.84\,(\varepsilon h/\|y_5-y_4\|)^{1/4}$" | script: `s = 0.84 * (tol * h / err)^(1 / 4)`, `h = clamp(s*h, hmin, hmax)`. The clamp is mentioned in Case 2 as "the maximum step $h=0.25$" | yes |
| Case 1 Behavior | "relative error of $3.3\times10^{-5}$" | `py/ledger.out`: max rel err 3.229e-5 (RKF45) and 2.255e-5 (RKF54) | yes |
| Case 1 Behavior | "$y(1.1)=139.88$" | mpmath 139.88284 | yes |
| Case 1 Behavior | "pole of $\tan$ at $t=1.1071$" | mpmath π/2 − atan(1/2) = 1.1071487 | yes |
| Case 1 Behavior | "the logarithmic $y$-axis keeps the whole run in view" | `new_gif/aa/frame_066.png`: the end marker at y ≈ 140 is inside ylims (0.4, 200), and the start (0, 0.5) is inside | yes |
| Case 1 Behavior | "step shrinks from $0.136$ near $t=0.1$ to $5\times10^{-5}$ near $t=1.1$" | `py/ledger.out`: largest h 0.1360, at t = 0.100; smallest controller step 4.97e-5, at t = 1.09992 | yes |
| Case 1 Behavior | "187 of the 259 computed points lie in $t\ge1.05$" | `py/ledger.out`: pts t ≥ 1.05: 187/259 (both modes) | yes |
| Case 1 Behavior | "the marker slows as it nears the pole" | `py/c1_mono.out`: per-frame t advance never increases (True); it is 0.396 in the first frame and 2e-4 near the end | yes |
| Case 1 Behavior | "each frame adds up to four accepted steps" | script `stride = 4`, frames 1, 5, …, 257, 259 (`jl/inst_aa.out`); the last frame adds 2 | yes |
| Case 1 Behavior | "share the error estimate and the step rule" | both modes call the same `rkf_integrate`; only `y = mode == :rkf45 ? y4 : y5` differs | yes |
| Case 1 Behavior | "steps agree to within $0.05\%$" | `py/ledger.out`: max relative h difference 4.105e-4 (excluding the clipped last step) | yes |
| Case 1 Behavior | "the curves coincide (blue over magenta)" | the largest relative error of each is ≤ 3.3e-5, below pixel scale; frames 30 and 66 show the blue line inside the magenta band | yes |
| Case 1 Behavior | "errors $3.2\times10^{-3}$ against $4.5\times10^{-3}$ at $t=1.1$" | `py/ledger.out`: 3.154e-3 (RKF54) and 4.517e-3 (RKF45) | yes |
| Case 1 alt text | "with y on a logarithmic axis" | script `yscale=:log10` | yes |
| Case 2 Behavior | "within $7\times10^{-7}$ at every accepted point" | `py/ledger.out`: max err 6.577e-7 (RKF45) and 9.435e-8 (RKF54) | yes |
| Case 2 Behavior | "maximum step $h=0.25$ over the hump ($0.1\le t\le1.35$)" | `py/ledger.out`: cap steps from t = 0.1000 to t = 1.3500 (both modes). Peak at t = 0.8836 (`py/case2.out`) | yes |
| Case 2 Behavior | "keeps $h$ between $0.189$ and $0.25$ until $t\approx2.4$" | `py/ledger.out`: h ∈ [0.1891, 0.2500] for 0.1 ≤ t_i < 2.39 (both modes); the step ending at 2.3992 starts at 2.1991 | yes |
| Case 2 Behavior | "steepest point ($y'=-0.930$ at $t=2.19$)" | `py/case2.out`: steepest y′ = −0.9303 at t = 2.1945 | yes |
| Case 2 Behavior | "below $0.04$ from $t=3$ on" | `py/ledger.out`: t_i ≥ 3 max h 0.0399; from t_i = 2.9959 on, every later h < 0.04 (both modes) | yes |
| Case 2 Behavior | "smallest step it chooses is $0.027$, near $t=3.27$" | `py/ledger.out`: min controller h 0.0274 at t = 3.2716 (both modes). RKF54's final step of 0.0006 is the clip to land on t = 5, not the controller's choice | yes |
| Case 2 Behavior | "solution bends into its flat tail" | `py/case2_more.out`: y″ is largest, 1.283, at t = 2.953. \|y′\| falls from 0.35 at t = 3.0 to 0.005 at t = 5 (`py/case2.out` table) | yes |
| Case 2 Behavior | "corners visible on the hump … straight segments … $0.25$ apart (up to $0.0091$ below the curve, near $t=0.48$), not integration error" | `py/ledger.out`: polyline − reference min −0.0091 at t = 0.475, inside the h = 0.25 segment [0.35, 0.60]. The point errors are ≤ 6.6e-7. Visible in `new_gif/bb/frame_007.png` | yes |
| Case 2 Behavior | "These steps are set by the tolerance, not by stability" | `py/case2_more.out`: h ∝ tol^{1/4} (×3.08 and ×2.97 against 3.16 predicted); h\|J\| ≤ 1.274 < 3.02 | yes |
| Case 2 Behavior | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | ∂/∂y(1 − t·y^{1/3}) = −t/(3y^{2/3}); `py/ledger.out`: J(5) = −41.2554 | yes |
| Case 2 Behavior (D2, reworded per `patterns/d2wording.md`) | "for fixed steps longer than about $h=0.0732$, $h\,\|\partial f/\partial y\|$ would exceed the 4th-order RKF update's stability limit $3.02$ before $t=5$" | `py/stability.out`: R4 limit −3.020017544, \|R4\| ≤ 1 on [−3.02, 0]. 3.0200175/41.2554 = 0.0732029 (`py/ledger.out`). \|J\| is strictly increasing (`py/case2_more.out`), so for h > 0.0732, h\|J(5)\| > 3.02 and the crossing is before t = 5. The sentence makes no claim of visible blow-up and does not tie the onset to the flat tail. No old fixed step exists on this page, so no onset time is quoted | yes |
| Case 2 Behavior | "accepted steps keep $h\,\|\partial f/\partial y\|$ below $1.3$" | `py/ledger.out`: max h\|J(t_{i+1})\| 1.270 / 1.274. \|J\| is increasing, so the step end is the worst point in each step | yes |
| aa.jl comment | "y(1.1) = 139.9 (pole of tan at t = 1.1071)" | mpmath as above | yes |
| aa.jl comment | "the steps crowd together near t = 1.1" | 187/259 points in t ≥ 1.05 | yes |
| aa.jl / bb.jl comment | "local error estimate for y4; scales like h^5" | `py/f4_scaling.out` | yes |
| bb.jl comment | "end point (5, 0.0081)" | script points y(5) = 0.0081198889 / 0.0081199107 | yes |

## Scripts and GIFs
- **Scripts changed:** `rungekuttafehlbergaa.jl` (controller rule, log y-axis, x margins, frame stride 4, RKF45 drawn wide underneath) and `rungekuttafehlbergbb.jl` (controller rule, x margins (−0.1, 5.1), RKF45 drawn wide underneath, fps 3).
- **GIFs regenerated:** `rungekuttafehlbergaa.gif` (66 frames, fps 2) and `rungekuttafehlbergbb.gif` (81 frames, fps 3). A second run of aa.jl after a comment-only edit gave the same md5 (d1a7795e…).
- **Frames viewed in full:**
  - aa frame 1: dashed exact curve on the log axis from 0.5 to ≈140, start marker at (0, 0.5) clear of the border.
  - aa frame 30: marker at y ≈ 37. The magenta band and the blue line are both visible.
  - aa frame 66: the end marker at (1.1, ≈140) is inside the frame, and the legend, title and ticks (0.5–100) are legible.
  - bb frame 7: the hump drawn with h = 0.25 segments, with the dashed curve visible above the chords.
  - bb frame 81: the end marker at (5, 0.0081) is fully inside the frame.
  - Contact sheets `new_gif/aa/sheet.png` and `new_gif/bb/sheet.png`: the marker advances steadily, with no frozen frames.
- **git status** (`git status --short -- pages/numerical-methods/runge-kutta-fehlberg-method`): `M index.qmd`, `M rungekuttafehlbergaa.gif`, `M rungekuttafehlbergaa.jl`, `M rungekuttafehlbergbb.gif`, `M rungekuttafehlbergbb.jl`. This is the expected set.

## Legacy archive
Consulted: `n2003/RungeKuttaFehlbergMod.html`, `rungekuttafehlberg/RungeKuttaFehlbergMod/Links/*_lnk_2–7.html` and the graph-sized images.
- **Example 1** (gr_27–29, gr_44–46): y′ = 1 + y², y(0) = 0.5 on [0, 1.1]. This matches Case 1.
  - Mathews' NDSolve plot (gr_47–55) uses `PlotRange → {0, 20}`. The page's old 0–20 window copied it, and it has the same clipping.
  - The Example 1 solution images (gr_30–43) are missing from the archive. The tolerance he used could not be recovered, so his step sequence was not reproduced.
- **Step rule** (gr_5): s = (εh/(2|z − y|))^{1/4} = 0.840896(εh/|z − y|)^{1/4}. This is the per-unit-step form the page now uses.
- **Mathews' subroutine** (gr_15) differs from the page in three ways:
  - It accepts on err < ε (per step).
  - It clamps s to [0.1, 4].
  - It uses hmin = 0.001, hmax = 0.25 and h0 = 0.25.

  The page uses the consistent Burden–Faires-type test err/h ≤ ε and keeps the script's own hmin = 1e-6, h0 = 0.1 and no clamp on s. The mathematics (err/h ∝ h⁴) supports the per-unit acceptance, and the archive's mixed acceptance is not copied.
- **Examples 4/5** (gr_70–102): his RKF45 and RKF54 runs reach the hmin = 0.001 floor from t ≈ 1.054 and end at 139.953 and 139.947. The maximum errors are 0.0704 and 0.0645, and he remarks "The RKF54 is slightly better for this example". The page's new statement that RKF54 ends closer (3.2e-3 against 4.5e-3) is computed for the page's own run, not taken from the archive.
- The archive has no RKF animation: `grep -ci animat RungeKuttaFehlbergMod.html` → 0. This agrees with the page's existing sentence about the recovered archive.
- Case 2 (y′ = 1 − t·y^{1/3}) is not one of Mathews' RKF examples. The page takes it from the other ODE pages.

## Notes
- **Choosing the F4 fix.** The review offered three options: the per-unit rule, exponent 1/5, or calling the rule a heuristic. I chose the per-unit rule because it matches the archive's step formula and the RKF rule the Description presents. It changes both runs:
  - Case 1 goes from 59 to 258 accepted steps and Case 2 from 48 to 79/80.
  - All step-related numbers in F1–F3 were recomputed for the new code. The round-1 numbers (hmax over [0.1, 2.35], min 0.054, end errors 3.05e-2 / 1.54e-2) no longer apply.
  - tol stays 1e-6, so the GIF titles are unchanged. The titles do not say that the tolerance is per unit step; the Description does.
- **Frame pacing.** Case 1 animates every 4th accepted point (66 frames, fps 2). Case 2 keeps one frame per accepted point but at fps 3. Both are my choices, made to keep the loops near 30 s.
- **End marker.** The bb end marker was half-clipped at x = 5 in the committed GIF, and no finding named it. I widened xlims while regenerating, as on the Runge-Kutta page. In the aa GIF the start and end markers have the same margin.
- **Left unchanged.** The intro sentence "Because the recovered archive did not include legacy RKF animated GIF portals…" is consistent with the archive. The "(Planned)" stubs were not touched.

## Resolution check (independent checker, not shown this record)

Work files (all in this folder): `indep.py` (independent Python RKF controller, DOP853 rtol=1e-13 reference, RK4 h=1e-4 reference, polyline gap, slopes, h|f_y|), `stab.py` (sympy stability polynomials of the y4/y5 updates, error-vs-h halving), `run/` (scratch copies of both scripts, regenerated GIFs, `hcheck.jl`/`h2.jl` re-running the exact Julia controller for the numbers), `frames_aa/`, `frames_bb/` (all frames, contact sheets, framemd5).

Note: the fix changed the controller (F4), so every step-size number on the page is new and was checked against the new controller.

### Original findings

### F1 — resolved
- The false sentence ("adaptive steps tighten through the steeper part") is gone. The replacement puts the h = 0.25 cap over the hump, keeps h in [0.189, 0.25] past the steepest point, and puts the step cut in the bend into the flat tail. It attributes the visible corners to straight segments between widely spaced points, not to integration error.
- New controller, Julia and Python agree. Steps starting at t = 0.1, 0.35, 0.6, 0.85, 1.1 are h = 0.25 (ending at 1.35). The next steps are 0.2435, 0.2176, 0.1989, 0.1891, 0.2001, ending at t = 2.399. Then h falls: 0.103, 0.088, …, and every step starting at t ≥ 3 is < 0.0399. The smallest unclipped step is 0.027356 at t = 3.2716.
- Steepest slope: y' = −0.93027 at t = 2.1945 (DOP853). Max polyline gap: 0.00911 (polyline below the curve) at t = 0.475. Max point error against DOP853: 6.58e-7 (RKF45) and 9.4e-8 (RKF54). The RK4 h=1e-4 reference agrees with DOP853 to 9.7e-13.
- The GIF matches: the frames show visible corners on the hump and dense points in the tail.

### F2 — resolved
- The "accepted-step distributions differ slightly" sentence is gone. The page now says the steps agree and the curves coincide, and it gives the final errors of both runs.
- Checked in Julia:
  - Both runs have 259 points, and the steps agree to a maximum relative difference of 4.1e-4 (within the page's 0.05%).
  - Final errors at t = 1.1: 4.517e-3 (RKF45) and 3.154e-3 (RKF54), as the page says.
  - A Python reimplementation gives 6.4e-4 instead, because accept/reject near the pole is sensitive to last-ulp differences in `pow`. This is not a page error, since the page describes the Julia run.
- Plotting: RKF45 is now drawn at lw=5 under RKF54 at lw=2, and the RKF45 marker is ms=7 under the ms=4 RKF54 marker. In every full-size frame I looked at (aa 1, 33, 66; bb 40, 81), a magenta border is visible around the blue trace and marker. The legend shows the thick magenta line.

### F3 — resolved
- The y-axis is now log10 over [0.4, 200], with ticks 0.5 to 100. The run ends at y = 139.887 at t = 1.1, and frame 66 shows the marker at the end, just under the top of the window.
- The frames went from 60 to 66, each adding up to 4 points (1:4:259 plus 259). All 66 frames have distinct framemd5, so no frozen tail remains (before, 31 frames were identical).
- Page claims checked:
  - y(1.1) = 139.8828 and the pole at t = 1.107149 (mpmath).
  - The step falls from 0.1360 (the step starting at t = 0.1) to about 4.97e-5 (the smallest unclipped step, just before t = 1.1).
  - 187 of 259 points lie in t ≥ 1.05, for both runs.
  - Max relative error is 3.23e-5 (RKF45) and 2.25e-5 (RKF54), which is ≤ 3.3e-5.

### F4 — resolved
- Code (both scripts): accept if `err <= tol*h`, `s = 0.84*(tol*h/err)^(1/4)`. This is the Burden–Faires RKF rule (R = |y5−y4|/h ≤ ε, δ = 0.84(ε/R)^{1/4}), and the page text states exactly this rule.
- Scaling claim: halving h for a single step divides |y5−y4| by 25.0, 29.1, 30.7, 31.5 in Case 1 (p → 4.98) and by 33.3, 32.6, 32.6 in Case 2 (p → 5.02). So it shrinks like h^5, and err/h shrinks like h^4, as the page says.
- The controller now behaves well: 4 rejections out of 262 attempts in Case 1, and 3 out of 82/83 in Case 2.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Description | \|y5−y4\| estimates local error of y4, shrinks like h^5 | step halving: p → 4.98 / 5.02 | correct |
| Description | \|y5−y4\|/h is error per unit step ∝ h^4 | follows from the above | correct |
| Description | accept when \|y5−y4\|/h ≤ ε; s = 0.84(εh/\|y5−y4\|)^{1/4} | matches code lines in both scripts; is the B–F rule | correct |
| Case 1 | rel. error ≤ 3.3e-5 all the way | 3.229e-5 / 2.255e-5 (Julia and Python) | correct |
| Case 1 | y(1.1) = 139.88; pole at t = 1.1071 | 139.8828; π/2 − atan 0.5 = 1.107149 | correct |
| Case 1 | log y-axis keeps whole run in view | ylims (0.4, 200), last frame shows marker at ≈140 | correct |
| Case 1 | step 0.136 near t = 0.1 | h = 0.136002 for step starting at t = 0.1 | correct |
| Case 1 | 5e-5 near t = 1.1 | smallest unclipped step 4.97e-5 at t ≈ 1.0999 (final clipped step 2.8e-5) | correct |
| Case 1 | 187 of 259 computed points in t ≥ 1.05 | 187/259 both runs | correct |
| Case 1 | marker slows; each frame adds up to four accepted steps | frames = 1:4:259 ∪ {259}; 66 frames | correct |
| Case 1 | share error estimate and step rule; steps agree within 0.05% | same code path; max rel diff 4.1e-4 (Julia) | correct (narrow margin; Python reimpl gives 6.4e-4) |
| Case 1 | curves coincide (blue over magenta) | frames 1/33/66 | correct |
| Case 1 | differ only in carrying y4 vs y5 | code `y = mode == :rkf45 ? y4 : y5` | correct |
| Case 1 | errors 3.2e-3 (RKF54) vs 4.5e-3 (RKF45) at t = 1.1 | 3.154e-3 / 4.517e-3 | correct |
| Case 1 alt | "...with y on a logarithmic axis" | yscale=:log10 | correct |
| Case 2 | match dashed reference within 7e-7 at every accepted point | 6.58e-7 (RKF45), 9.4e-8 (RKF54) vs DOP853 and vs interpolated RK4 ref | correct |
| Case 2 | max step 0.25 over hump (0.1 ≤ t ≤ 1.35) | steps from 0.1 to 1.35 all 0.25 | correct |
| Case 2 | h between 0.189 and 0.25 until t ≈ 2.4 | 0.2435, 0.2176, 0.1989, 0.1891, 0.2001 → t = 2.399 | correct |
| Case 2 | steepest point y' = −0.930 at t = 2.19 | −0.93027 at t = 2.1945 | correct |
| Case 2 | cuts step as solution bends into flat tail | h drops from 0.2 to 0.103 at t = 2.4 and to 0.04 by t ≈ 2.96, while \|y'\| falls | correct |
| Case 2 | below 0.04 from t = 3 on | max h for steps starting at t ≥ 3: 0.03988 | correct |
| Case 2 | smallest chosen step 0.027 near t = 3.27 | 0.027356 at t = 3.2716 | correct |
| Case 2 | corners = straight segments between points 0.25 apart; up to 0.0091 below curve near t = 0.48 | max gap +0.00911 (curve above polyline) at t = 0.475 | correct |
| Case 2 | steps set by tolerance, not stability | max h\|f_y\| = 1.27 ≪ 3.02; step sequence smooth, no stability-limited oscillation | correct |
| Case 2 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | y(5) = 0.0081199, f_y = −41.255 | correct |
| Case 2 | fixed h > 0.0732 would exceed limit 3.02 before t = 5 | 3.02/41.255 = 0.0732; \|f_y\| increases monotonically on the tail | correct |
| Case 2 | 4th-order RKF update's stability limit 3.02 | y4 stability polynomial 1+z+z²/2+z³/6+z⁴/24+z⁵/104; real boundary −3.0200 | correct |
| Case 2 | every accepted step keeps h\|f_y\| below 1.3 | max 1.246 (at step start), 1.274 (at step end) | correct |
| aa.jl | xlims (−0.02, 1.12), ylims (0.4, 200), yticks, ylabel "y (log scale)" | frames: start and end markers unclipped, labels legible | correct |
| aa.jl | stride 4 framing | 66 distinct frames | correct |
| bb.jl | xlims (−0.1, 5.1); comment "end point (5, 0.0081)" | y(5) = 0.00812 | correct |
| bb.jl | fps 2 → 3 | 81 frames, 27 s | fine |
| both .jl | RKF45 lw 5 / ms 7 under RKF54 lw 2 / ms 4 | magenta visible as border in frames | correct |

### New problems

None. This rests on the following:
- Every changed sentence and number was checked above against an independent Python implementation, a DOP853 reference, sympy, and re-runs of the exact Julia controller.
- I looked at full-size frames aa 1, 33, 66 and bb 40, 81, plus both contact sheets.
- All frames are distinct.

Observations that are not defects:
- (a) The thick RKF45 line now fully covers the dashed exact/reference curve behind the marker. The dashed curve is visible only ahead of the marker. The page's "dashed black curve" description still holds, and the curve was already covered by the lw-2.2 trace before the fix.
- (b) The 0.05% step-agreement margin is narrow (4.1e-4 measured). It would not survive an implementation that differs in the last ulp, but it is true for the committed script.

### Reproducibility and conventions

- I ran both scripts from scratch copies (`run/`). The output GIFs are byte-identical to the working-tree GIFs:
  - aa sha256 6e391540…61d3
  - bb sha256 11dee679…86ac
  - These match the new LFS oids in the diff. The scripts print 259/259 (aa) and 80/81 (bb) accepted points.
- Page conventions:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks, and math uses KaTeX.
- Within the page's own scope, only files in the page folder changed (index.qmd, 2 .jl, 2 .gif). Outside the page folder, `git status` shows only workflow notes under `reviews/numerical-methods-animations/fixes/` (including a new `runge-kutta-fehlberg-method.md`) and other pages being fixed in the same session. There are no site-content changes for this page outside its folder.

**Final status:** committed
