# Runge-Kutta-Fehlberg Method — animation review

Page: [`pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd`](../../pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd) · Scripts: `rungekuttafehlbergaa.jl`, `rungekuttafehlbergbb.jl` · GIFs: 2

**Result:** 1 error, 2 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 2 "Behavior" puts the step tightening in the wrong place, and says the wrong thing causes the visible differences

- **Location:** index.qmd lines 50–52: "RKF45 and RKF54 closely follow the dashed RK4 reference trajectory, with only small visible differences as adaptive steps tighten through the steeper part of the solution."
- **Now:** The sentence says the steps get smaller where the solution is steep, and links the small visible differences to that.
- **True:**
  - The steepest part of the solution is y' = −0.930 at t = 2.195. The whole stretch t ∈ [0.1, 2.35], which contains it, is integrated at the step cap `hmax = 0.25`. There the steps are as large as the code allows.
  - The steps start to shrink only after t = 2.35. They reach their smallest value, h = 0.0540, at t ≈ 3.27, where the slope is only y' ≈ −0.07. They stay small (0.054–0.073) through the nearly flat tail t ∈ [3, 5], where |y'| falls from 0.34 to 0.005.
  - In the tail, h·|∂f/∂y| grows steadily from 0.2 to 2.3, because ∂f/∂y = −t/(3y^{2/3}) grows to −41 as y → 0. So the step size follows the bend into the tail and the growing stiffness, not the steepness.
  - The visible differences have nothing to do with tight steps. The accepted values agree with the reference to within 2.4e-6 (RKF45) and 8.1e-7 (RKF54), which is invisible at this scale. What can be seen is the straight-line polyline between accepted points cutting the chord of the hump: the maximum gap is 0.0091 at t = 0.475, where h = 0.25 (frame 49, near t ≈ 0.3–1.3). That is exactly where the steps are at their largest.
- **Evidence:**
  - `reviewer/inst_bb.jl` → `out_bb.txt`: the accepted t and h sequence. h = 0.25 for every step from t = 0.35 to 2.35, then 0.153, 0.122, … down to 0.0540 at t = 3.2732.
  - `reviewer/steps_vs_slope.py`: a table of h against |y'| and ∂f/∂y at each accepted point, for example:
    - t = 2.10: h = 0.25, |y'| = 0.92
    - t = 3.27: h = 0.054, |y'| = 0.084
    - t = 4.84: h = 0.062, |y'| = 0.006
  - `reviewer/independent.py`: a DOP853 reference with rtol = 1e-13. It gives the steepest slope −0.9303 at t = 2.195; the maximum point error of RKF45/RKF54 against the reference (2.41e-6 / 8.06e-7); and the maximum polyline-versus-reference gap of 0.0091 at t = 0.475.
  - `reviewer/controller.jl`: smallest accepted step (excluding the final clipped step) 0.05404 at t = 3.273.
- **Suggested fix:** Replace with something like: "RKF45 and RKF54 both match the dashed RK4 reference to about 1e-6 at every accepted point. The controller takes the maximum step h = 0.25 through the hump and the steep descent. It cuts the step to about 0.05–0.07 only where the solution bends into its flat tail (t ≳ 2.4), because ∂f/∂y = −t/(3y^{2/3}) grows large as y → 0. The slight visible gap near the peak comes from straight segments drawn between widely spaced accepted points, not from integration error."

- **Independent check:** confirmed.

### F2 — Misleading — Page match — Case 1: the RKF45 and RKF54 runs are the same to about 6 digits, and the RKF45 trace cannot be seen

- **Location:** index.qmd lines 41–42: "The accepted-step distributions differ slightly, reflecting the 4th-order vs 5th-order accepted update choice." The same applies to the plotting code at rungekuttafehlbergaa.jl lines 84–85 and 87–88.
- **Now:** The page says the two runs' accepted steps differ, as if there were a visible contrast between the two variants.
- **True:**
  - The two runs make the same 71 attempts, accept 59 steps each, and reject 12 steps each.
  - Their accepted times agree to within 7.6e-7, and their step sizes agree to 2.4e-6 relative. The reason is that both modes compute the same `err = |y5 − y4|` and use the same controller, so propagating y4 or y5 shifts y only by about 1e-5 relative.
  - In every frame, RKF54 (royal blue, drawn second, same line width 2.2) lies exactly on top of RKF45 (magenta). The magenta curve never shows (frames 1–60), so the viewer cannot see any difference.
  - (In Case 2 the step sequences do separate a little in the tail, with up to 2.9% relative difference in h after t ≈ 3.4, but they still overlap visually.)
- **Evidence:** `reviewer/controller.jl` prints:
  - `case1 rkf45 accepted=59 rejected=12 attempts=71` and the same line for rkf54
  - `case1: n45=60 n54=60 max |t45-t54| over points=7.616e-07 max rel diff in h (excl. last)=2.402e-06`

  `reviewer/out_aa.txt` lists the accepted points side by side. Committed `frame_029.png` and `frame_060.png` show only the blue curve over the dashed one.
- **Suggested fix:** Say instead that the two runs pick essentially the same steps, because the error estimate and controller are shared, and differ only in the propagated value. RKF54 (local extrapolation) ends about 2× closer to the exact value: final errors 1.54e-2 against 3.05e-2 at t = 1.1. If the comparison is meant to be visible, draw RKF45 with markers or a thinner or dashed line, or plot the error against t on a log scale.

- **Independent check:** confirmed.

### F3 — Misleading — Implementation (picture) — Case 1: the second half of the GIF is a frozen frame because the y-window stops at 20 while the solution reaches 139.9

- **Location:** rungekuttafehlbergaa.jl line 62 `ylims = (0.0, 20.0)` and line 64 `n_frames = max(length(ts45), length(ts54))`. Page line 40–41: "while the curve rapidly steepens near $t=1.1$."
- **Now:**
  - The animation has one frame per accepted point, 60 in all.
  - The solution passes y = 20 at t = 1.05719. The pole of tan(t + arctan 0.5) is at t = 1.10715, just beyond the interval, so y(1.1) = 139.88.
  - Accepted points 30–60 all have y > 20, so the current-point markers and new segments are clipped out of view.
  - Committed frames 30–60 (31 of 60 frames, 15.5 s of the 30 s loop at fps = 2) are pixel-identical.
- **True / consequence:**
  - The viewer never sees the last half of the integration. That half covers the region where the adaptive step shrinks from 4.1e-3 down to 4.0e-4, which is the most "adaptive" part of the run.
  - The viewer also never sees where the run ends (t = 1.1, y ≈ 139.9). The animation appears to stall at t ≈ 1.055.
  - The page's "rapidly steepens near t = 1.1" is right about the mathematics, but the steepening the reader can see ends at t ≈ 1.057.
- **Evidence:**
  - `reviewer/inst_aa.jl` → `out_aa.txt`: the column `onscreen=false` for points 30–60. Point 29: t = 1.05506, y = 19.18. Point 30: t = 1.05914, y = 20.82.
  - `reviewer/independent.py`: "case1 y=20 reached at t = 1.0571903", "y(1.1)= 139.8828".
  - `md5sum committed/rungekuttafehlbergaa/frame_0*.png`: frames 30 through 60 share one checksum (0597037f…).
- **Suggested fix:** Pick one of these:
  - Plot y on a log scale, or use ylims up to about 150.
  - Add a second panel with the step size h against t, which also shows the adaptivity.
  - Stop the interval earlier (e.g. at t = 1.05).

  If you keep the current window, say on the page that the solution leaves the window at t ≈ 1.06 and that the last half of the frames add points off-screen.

- **Independent check:** confirmed.

### F4 — Minor — Page match / Implementation — the step-size rule pairs the per-step error with the exponent that belongs to the per-unit-step error

- **Location:** index.qmd lines 17–20: "a practical error estimate is $|y_5 - y_4|$. The next step size is chosen using a scaling rule of the form $h_{new} = s h$ with $s \propto (\varepsilon/\text{err})^{1/4}$". Code: rungekuttafehlbergaa.jl line 43 and rungekuttafehlbergbb.jl line 61, `s = 0.84 * (tol / err)^(1/4)` with `err = abs(y5 - y4)`.
- **Now:** The page and code use err = |y5 − y4|, which is the error per step, with exponent 1/4.
- **True:**
  - |y5 − y4| is the local error estimate of the 4th-order solution and scales like h^5. Checked numerically: halving h divides it by about 32.
  - So the scaling that is consistent asymptotically is either s ∝ (ε/err)^{1/5} (error per step), or s ∝ (ε h/err)^{1/4} with err/h, the error per unit step. The second is the usual Burden–Faires / Mathews RKF rule, with q = 0.84(ε h/|y5 − y4|)^{1/4}, and it is where the constant 0.84 and the exponent 1/4 come from.
  - The script's mixed rule still works as a controller (it is a stable feedback loop). It needed 12 and 7 rejections in the two cases, and the accepted steps had err/tol medians of 0.68 and 0.44. But it is not the RKF rule, and the page presents it as the rule.
- **Evidence:** `reviewer/err_scaling.jl` gives |y5 − y4| for one step against h:
  - Case 1 at t = 0: ratios per halving 9.7, 25.0, 29.1, 30.7, so p → 4.94
  - Case 2 at t = 1: ratios 34.7, 33.2, 32.6, 32.3, so p → 5.01

  `reviewer/controller.jl` gives the rejections and err/tol statistics.
- **Suggested fix:** Either write the rule as $s = 0.84\,(\varepsilon h / |y_5 - y_4|)^{1/4}$ and change line 43/61 to `0.84 * (tol * h / err)^(1/4)` (accepting when `err/h <= tol`, so the tolerance is per unit step), or keep the error per step and use exponent 1/5. If the page keeps the current rule, call it a heuristic variant.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `rungekuttafehlbergaa.jl` | yes | 5.4 | rungekuttafehlbergaa.gif |
| `rungekuttafehlbergbb.jl` | yes | 4.9 | rungekuttafehlbergbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | "RKF45 is an adaptive-step one-step solver for initial value problems" | Code lines 19–45: a one-step update with the step adapted by err | confirmed |
| 2 | 13–14 | "computes embedded 4th- and 5th-order approximations from the same stage evaluations" | `order_conditions.py`: b4 satisfies all rooted-tree conditions through order 4 and fails order 5; b5 satisfies through order 5 and fails order 6. Both use the same 6 stages, and the row sums of A equal c. Empirical order from step halving with the script's routine (`empirical_order.jl`, `empirical_order_big.jl`): ratio → 15.7 (y4) / 34.8→32 (y5) on y′ = y; 17.8 / 33.3 on y′ = −2ty + t; 20.4→16 / 31.9 on y′ = y cos t + cos t | confirmed |
| 3 | 14 | "estimates local error from their difference" | `err = abs(y5 - y4)`, which scales as h^5 (`err_scaling.jl`) | confirmed |
| 4 | 15 | "then adjusts step size to meet a tolerance" | Accept if err ≤ tol, then h ← clamp(0.84(tol/err)^{1/4}h, 1e-6, 0.25) | confirmed (the tolerance is per step and absolute; the global error is much larger, e.g. 3.05e-2 at t = 1.1 in Case 1, but the page makes no claim about global error) |
| 5 | 17–18 | "a practical error estimate is \|y5 − y4\|" | Same as code | confirmed |
| 6 | 18–20 | "h_new = s h with s ∝ (ε/err)^{1/4}" | Matches the code, but the exponent does not fit err ∝ h^5 | confirmed as a description of the code; the rule itself is questionable → F4 |
| 7 | 24–25 | Case 1 IVP "y′ = 1 + y², y(0)=0.5, on [0,1.1]" | aa.jl lines 8, 50–52 | confirmed |
| 8 | 25–27 | "The dashed black curve is the exact solution y(t)=tan(t+arctan(0.5))" | sympy: residual 0, y(0) = 1/2. aa.jl line 83 draws it black and dashed | confirmed |
| 9 | 29–31 | Case 2 "uses the same IVP shown on the Adams-Bashforth-Moulton, Euler, and Modified Euler pages: y′ = 1 − t∛y, y(0)=1, on [0,5]" | bb.jl lines 8, 68–70. adams-bashforth-moulton-method/index.qmd line 24 and eulers-method-for-odes/index.qmd lines 28, 37, 53 (Modified Euler is Case 2 of the Euler page) give the same IVP | confirmed |
| 10 | 31–32 | "dashed high-accuracy reference trajectory from fixed-step RK4 at h=10⁻⁴" | bb.jl lines 10–27, 75, 99. Agrees with DOP853 (rtol 1e-13) to 3.7e-13 at sampled points; y(5) = 0.0081199204648680 in both | confirmed |
| 11 | 34–36 | Reconstructed from legacy worked-example equations | History/legacy | out of scope |
| 12 | 38 | Case 1 heading: "Adaptive RKF45 vs RKF54, y′ = 1 + y², y(0)=0.5, t∈[0,1.1]" | RKF45 propagates y4 and "RKF54" propagates y5 (local extrapolation); aa.jl line 38. Parameters match | confirmed (the name "RKF54" is not defined in the Description; the Behavior line explains it) |
| 13 | 40–41 | "Both adaptive traces follow the exact solution well" | Relative error ≤ 3.0e-5 at the visible points (y ≤ 20) and ≤ 2.2e-4 at t = 1.1 (`out_aa.txt`) | confirmed |
| 14 | 40–41 | "while the curve rapidly steepens near t=1.1" | True mathematically (pole at t = 1.10715, y(1.1) = 139.9), but the plotted window ends at y = 20 (t ≈ 1.057) and the last 31 frames are identical | confirmed for the mathematics; the display hides it → F3 |
| 15 | 41–42 | "The accepted-step distributions differ slightly, reflecting the 4th-order vs 5th-order accepted update choice" | Same 59 accepted / 12 rejected steps; h agrees to 2.4e-6 relative; the traces coincide | wrong in effect → F2 |
| 16 | 44, 46 | Case 1 links rungekuttafehlbergaa.jl and embeds rungekuttafehlbergaa.gif | manifest: aa.gif is produced by aa.jl and is byte-identical | confirmed |
| 17 | 46 | Alt: "Adaptive RKF45 and RKF54 trajectories versus exact solution for y′ = 1 + y², y(0)=0.5 on [0,1.1]" | Frames and code | confirmed |
| 18 | 48 | Case 2 heading: "Adaptive RKF45 vs RKF54, y′ = 1 − t∛y, y(0)=1, t∈[0,5]" | bb.jl lines 8, 68–74 | confirmed |
| 19 | 50–51 | "RKF45 and RKF54 closely follow the dashed RK4 reference trajectory" | Maximum point error 2.41e-6 / 8.06e-7 (`independent.py`) | confirmed |
| 20 | 51–52 | "with only small visible differences as adaptive steps tighten through the steeper part of the solution" | Steps are at hmax = 0.25 through the steepest part (y′ = −0.93 at t = 2.195) and smallest (0.054) at t ≈ 3.27 where y′ ≈ −0.07. The visible gap (0.0091 at t = 0.475) is the chord of h = 0.25 segments | wrong → F1 |
| 21 | 54, 56 | Case 2 links rungekuttafehlbergbb.jl and embeds rungekuttafehlbergbb.gif | manifest: produced by bb.jl and byte-identical | confirmed |
| 22 | 56 | Alt: "Adaptive RKF45 and RKF54 trajectories versus high-accuracy RK4 reference for y′ = 1 − t cbrt(y), y(0)=1 on [0,5]" | Frames and code | confirmed |

## Implementation checks

### rungekuttafehlbergaa.jl
- **Method:**
  - The method is Runge–Kutta–Fehlberg 4(5).
  - It uses the nodes c = (0, 1/4, 3/8, 12/13, 1, 1/2) and the A matrix from lines 24–29, with weights b4 (line 31) and b5 (line 32).
  - I checked the tableau by property rather than from memory (`reviewer/order_conditions.py`, exact rational arithmetic, rooted trees generated automatically: 1, 1, 2, 4, 9 and 20 trees for orders 1–6):
    - The row sums of A equal c.
    - b4 satisfies every condition through order 4 and violates order 5.
    - b5 satisfies every condition through order 5 and violates order 6.
    - Σ(b5 − b4) = 0.
  - Mode `:rkf45` propagates y4, which is Fehlberg's classical choice. Mode `:rkf54` propagates y5 (local extrapolation, a legitimate variant). Both modes use the same err = |y5 − y4| and the same controller.
  - The controller accepts a step if err ≤ tol or h ≤ hmin, then sets h ← clamp(0.84(tol/err)^{1/4} h, 1e-6, 0.25). The exponent issue is F4. The hmin forced-acceptance branch is never triggered (`controller.jl`: any h == hmin → false).
  - The last step is clipped to land exactly on tf (final t = 1.1 exactly).
- **Numbers (script beside independent):**
  - Fixed-step runs of the script's own `rkf_integrate`, forced with hmin = hmax = h:
    - y′ = y: error ratio per halving 13.9, 15.0, 15.5, 15.7 for y4 (order 4); 30.5, 31.2, 31.6 for y5 (order 5).
    - y′ = −2ty + t, T = 2, BigFloat: 41.7 → 17.8 (y4) and 52.1 → 33.3 (y5).
    - y′ = y cos t + cos t, T = 3: 30.1 → 20.4, still decreasing toward 16 (y4), and 23.5 → 31.9 (y5).
  - Adaptive run, from the script's own output against the closed form:

    | | RKF45 | RKF54 | exact |
    |---|---|---|---|
    | y(1.1) | 139.91337 | 139.89823 | 139.88284 |
    | y(0.1) | 0.6320425646 | 0.6320425791 | 0.6320425638 |

  - Accepted steps: 59 per mode (60 points), with 12 rejections in each mode.
- **Reference values:**
  - y = tan(t + arctan ½) satisfies y′ = 1 + y² exactly (sympy residual 0) and y(0) = ½.
  - The pole is at t = π/2 − arctan ½ = 1.10715, outside [0, 1.1], so the curve is finite on the plotted interval.
- **Picture:**
  - I looked at the contact sheet and at full-size frames 29 and 60. The title, legend (Exact, RKF45, RKF54) and function match the code.
  - The current-point markers sit on the curve.
  - The magenta RKF45 curve is hidden under the blue RKF54 curve in every frame (F2).
  - The y-window [0, 20] clips everything after t ≈ 1.057; frames 30–60 are pixel-identical (F3).

### rungekuttafehlbergbb.jl
- **Method:** `rkf_integrate` is character-for-character the same as in aa.jl (lines 29–66; checked with `diff`), so the tableau and controller checks above apply. The reference is classical RK4 (lines 10–27, standard 1/6, 2/6, 2/6, 1/6 weights) with h = 1e-4 and 50 000 steps.
- **Numbers (script beside independent):**
  - Accepted steps: 48 per mode, with 7 rejections each.
  - Final value y(5): RKF45 0.0081196869, RKF54 0.0081197826, DOP853 reference 0.0081199205. The errors are 2.3e-7 and 1.4e-7.
  - Maximum error at the accepted points: 2.41e-6 (RKF45) and 8.06e-7 (RKF54), both at t = 3.162.
  - Step pattern: h = 0.25 (the cap) from t = 0.35 to 2.35; the minimum is 0.0540 at t = 3.273; then 0.06–0.073 to t = 5 (F1).
  - Relative step difference between the modes: up to 2.9%, in the tail.
- **Reference values:**
  - The RK4 h = 1e-4 reference agrees with scipy DOP853 (rtol 1e-13, atol 1e-15) to within 3.7e-13 at every 1000th point.
  - The solution stays positive (minimum 0.00812, at t = 5), so cbrt is used away from its non-Lipschitz point at y = 0.
  - The peak is 1.44977 at t = 0.884, inside ylims (−0.1, 1.55).
- **Picture:**
  - I looked at the contact sheet and at full-size frame 49. The title "y' = 1 - t*cbrt(y)" and the legend "Reference (RK4 h=1e-4)" match the code, and the markers advance one accepted point per frame.
  - The visible gap below the dashed curve near the peak comes from the straight segments between points 0.25 apart (maximum 0.0091 at t = 0.475), not from integration error (F1).
  - RKF45 is again hidden under RKF54 (F2 applies, less strongly, since the page does not claim a difference for Case 2).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/runge-kutta-fehlberg-method/`](evidence/runge-kutta-fehlberg-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
