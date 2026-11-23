# Runge-Kutta-Fehlberg Method — animation review (round 6)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every checkable claim on the page against values I computed myself, and all of them hold at the precision they are stated to. Both scripts implement the classical Fehlberg 4(5) pair correctly. Every reference curve is accurate. The frames show what was computed.

Two observations follow. Neither is a finding.

- In Case 2, RKF54 ends with a forced final step of 6.4e-4, from t = 4.99936 to 5. This is why it has 81 points to RKF45's 80, and the GIF has 81 frames. The page says "the smallest step it chooses is 0.027". That is true of the steps the controller chooses: the 6.4e-4 step is the truncation `h = tf - t`. The page states no point count for Case 2, so nothing on the page is contradicted.
- The same applies in Case 1. The last step of each run is the truncated remainder of 2.8e-5, while the last step the controller chose is 4.97e-5. The page's "to 5e-5 near t = 1.1" describes the chosen steps correctly.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 10.7 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 17.1 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttafehlbergaa.gif` | 66 | byte-identical | rungekuttafehlbergaa |
| `rungekuttafehlbergbb.gif` | 81 | byte-identical | rungekuttafehlbergbb |

### Page references

- Scripts linked: `rungekuttafehlbergaa.jl`, `rungekuttafehlbergbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "computes embedded 4th- and 5th-order approximations from the same stage evaluations" | Rooted-tree order conditions in exact Fractions, with coefficients copied from the script. y4 satisfies all trees of order ≤4 (1+1+2+4) and fails at order 5 (max deviation 1.28e-3). y5 satisfies all trees of order ≤5 (9 at order 5) and fails at order 6. Both use the same k1..k6. | confirmed |
| D2 | "\|y5−y4\| estimates the local error of y4. It shrinks like h^5" | Follows from D1: y4 has order 4, so its local error is O(h^5), and y5−y4 is O(h^5). | confirmed |
| D3 | "\|y5−y4\|/h is an error per unit step that shrinks like h^4" | Follows from D2. | confirmed |
| D4 | "A step is accepted when \|y5−y4\|/h ≤ ε" | Script line 37 / 55: `err <= tol * h` (or `h <= hmin`, which is never reached; see D7). | confirmed |
| D5 | "h_new = s h with s = 0.84 (ε h/\|y5−y4\|)^{1/4}" | Script line 44 / 62. | confirmed |
| D6 | "clamped to at most h_max = 0.25" | Line 45 / 63, `clamp(s*h, hmin, hmax)` with hmax = 0.25. | confirmed |
| D7 | "minimum h_min = 10^-6, which neither case below reaches" | Python replica flag `hits_min = False` in all four runs. The smallest h in any run is 2.82e-5 (Case 1, final truncated step) and 6.4e-4 (Case 2 RKF54, final truncated step). | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | The first animation reconstructs legacy Example 1: y' = 1 + y², y(0) = 0.5, on [0, 1.1] | Archive gr_27/28/29: "y' = 1 + y^2", "y(0.0) = 0.5", "[0.0, 1.1]". Script lines 8 and 51–53. | confirmed |
| I2 | Exact solution y(t) = tan(t + arctan 0.5) | mpmath at 40 digits: y(0) = 0.5, ODE residual at t = 0.7 is −3.7e-40. Script line 9. | confirmed |
| I3 | The module's subroutines accept when \|y5−y4\| < ε, start from h = 0.25, and have h_min = 0.001 | Archive gr_15/gr_26: `If[Or[err < ε, h < 2 hmin]`, `h = 0.2500`, `hmin = 0.001` | confirmed |
| I4 | "(here 0.1)" | `h0=0.1` (script line 56/57) | confirmed |
| I5 | h_min "which the run reaches at t ≈ 1.055" | Replica of the Mathews subroutine: the first step of size 0.001 starts at t = 1.05524. The archive T list (gr_71) shows the same spacing: 1.05424 → 1.05524 → 1.05624. | confirmed |
| I6 | "at the same ε = 10^-6 they take 120 points" | Replica: 120 points for both RKF45 and RKF54. The replica's T list matches archive gr_71 (0, 0.25, 0.327661, 0.434978, …). | confirmed |
| I7 | Module ends with errors 7.0e-2 (RKF45) and 6.5e-2 (RKF54) at t = 1.1 | Replica: 7.04102e-2 and 6.45005e-2. Archive gr_84 and gr_99 read "maximum error is 0.0704102" and "0.0645005". | confirmed |
| I8 | "against 4.5e-3 and 3.2e-3 here (Case 1)" | Julia dump: 4.5168e-3 and 3.1542e-3 | confirmed |
| I9 | The first step of 0.25 has an error estimate of 1.7e-7 that "passes either acceptance test" | Estimate is 1.673e-7. Page test: ≤ ε h = 2.5e-7, passes. Module test: < 1e-6, passes. | confirmed |
| I10 | "its true error is 5.6–5.7e-6" | y4 − exact = 5.737e-6; y5 − exact = 5.570e-6 | confirmed |
| I11 | "magnifies about 1.1e4 times by t = 1.1" | ∂y(1.1)/∂y(0.25) = (1 + y(1.1)²)/(1 + y(0.25)²) = 11183 | confirmed |
| I12 | Starting from h = 0.25, the page's controller ends with errors 6.6e-2 and 6.3e-2 | Replica with h0 = 0.25: 6.6418e-2 and 6.2847e-2 | confirmed |
| I13 | No legacy RKF animated GIF in the archive | No RKF/Fehlberg file under `a2001/Animations` (searched recursively); the module links contain no animation | confirmed |
| I14 | Module Examples 6–8 solve the Riccati equation y' = t² + y² with RKF45/RKF54 (Ex 6), compare with a Bessel-function closed form (Ex 7), and derive it with DSolve (Ex 8) | Archive gr_103 "y' = t^2 + y^2"; Link 8 text and gr_123 (BesselJ formula); Link 9 text "Use Mathematica's DSolve" | confirmed |
| I15 | Case 2 IVP y' = 1 − t∛y, y(0) = 1, [0, 5] is the one used on the Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages | `eulersmethodaa.jl`, `eulersmethodbb.jl` (modified Euler), `rungekuttaaa.jl`, `taylorderivativeaa/bb.jl` and `adamsbashforthmoultonaa.jl` all use `1 - t*cbrt(y)`, t0 = 0, y0 = 1, T = 5 | confirmed |
| I16 | Dashed reference from fixed-step RK4 at h = 1e-4 | Script lines 10–27 and 76; the legend reads "Reference (RK4 h=1e-4)" | confirmed |
| I17 | "This IVP is not one of the module's examples" | The module's examples are y' = 1 + y² (Ex 1–5) and y' = t² + y² (Ex 6–8) | confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading: RKF45 vs RKF54, y' = 1 + y², y(0) = 0.5, t ∈ [0, 1.1] | Script parameters; GIF title "RKF45/RKF54: y' = 1 + y^2, y(0)=0.5, tol=1e-6" | confirmed |
| C1.2 | "follow the exact solution to within a relative error of 3.3e-5 all the way" | Julia dump against mpmath exact: maximum relative error 3.229e-5 (RKF45, at t = 1.1) and 2.255e-5 (RKF54) | confirmed |
| C1.3 | "y(1.1) = 139.88" | mpmath gives 139.88284 | confirmed |
| C1.4 | "pole of tan at t = 1.1071" | π/2 − arctan 0.5 = 1.107149 | confirmed |
| C1.5 | "the logarithmic y-axis keeps the whole run in view" | ylims (0.4, 200) cover y ∈ [0.5, 139.89]; final frame 066 shows the marker at about 140, inside the box | confirmed |
| C1.6 | "The step shrinks from 0.136 near t = 0.1 to 5e-5 near t = 1.1" | Julia: step 2 (from t = 0.1) is 0.13600, the largest. The last chosen step is 4.97e-5. The final truncated step is 2.8e-5 (see the observation in section 1). | confirmed |
| C1.7 | "187 of the 259 computed points lie in t ≥ 1.05" | Julia: 259 points per method, 187 with t ≥ 1.05, for both | confirmed |
| C1.8 | "the marker slows as it nears the pole (each frame adds up to four accepted steps)" | `stride = 4`; frames 1:4:259 ∪ {259} = 66 frames, matching the committed GIF's 66 frames. The last frame adds 2 steps. Frame 002 marker is at t ≈ 0.40, matching index 5 (t = 0.3956). | confirmed |
| C1.9 | "share the error estimate and the step rule, so their steps agree to within 0.05%" | Julia step sizes: maximum relative difference 0.041% over all 258 steps | confirmed |
| C1.10 | "the curves coincide (blue over magenta)" | Code draws magenta lw = 5 under royalblue lw = 2. Frame 066 shows a blue line inside a magenta band. | confirmed |
| C1.11 | "They differ only in whether y4 or y5 is carried forward" | Line 39: `y = mode == :rkf45 ? y4 : y5`; nothing else depends on mode | confirmed |
| C1.12 | "RKF54 ends closer … errors 3.2e-3 against 4.5e-3 at t = 1.1" | 3.1542e-3 against 4.5168e-3 | confirmed |
| C1.13 | Dashed black curve is the exact solution | Line 90, `y_exact` on 800 points; legend "Exact y(t)" | confirmed |
| C1.14 | Link and embed are `rungekuttafehlbergaa.jl` / `.gif` | index.qmd; the manifest shows the committed GIF is byte-identical to the scratch regeneration | confirmed |
| C1.15 | Alt text: "Adaptive RKF45 and RKF54 trajectories versus exact solution for y' = 1 + y^2, y(0)=0.5 on [0,1.1], with y on a logarithmic axis" | Matches the script and the frames | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: y' = 1 − t∛y, y(0) = 1, t ∈ [0, 5] | Script lines 8 and 69–71; GIF title | confirmed |
| C2.2 | "match the dashed reference to within 7e-7 at every accepted point" | Against mpmath: maximum \|err\| is 6.577e-7 (RKF45, at t = 2.01) and 9.4e-8 (RKF54). The RK4 reference differs from mpmath by at most 1.2e-14. | confirmed |
| C2.3 | "takes the maximum step h = 0.25 over the hump (0.1 ≤ t ≤ 1.35)" | Steps of 0.25 start at t = 0.1, 0.35, 0.6, 0.85 and 1.1, ending at 1.35 (both methods). The maximum of y is at t = 0.884. | confirmed |
| C2.4 | "keeps h between 0.189 and 0.25 until t ≈ 2.4" | Steps from t = 0.1 to 2.3992 are 0.18909 to 0.25; the next step, from 2.3992, is 0.1029 | confirmed |
| C2.5 | "steepest point (y' = −0.930 at t = 2.19)" | mpmath, root of y'' = 0: t = 2.19459, y' = −0.930274 | confirmed |
| C2.6 | "below 0.04 from t = 3 on" | The last step ≥ 0.04 starts at t = 2.9557. All steps starting at t ≥ 2.99 are ≤ 0.03988. | confirmed |
| C2.7 | "the smallest step it chooses is 0.027, near t = 3.27" | 0.027356 from t = 3.2716 (both methods). The RKF54 forced final step is 6.4e-4; see the observation in section 1. | confirmed |
| C2.8 | The corners are chords between points 0.25 apart, "up to 0.0091 below the curve, near t = 0.48", not integration error | Curve minus chord maximum is 0.00911 at t = 0.475 (both methods); the integration error is < 7e-7 | confirmed |
| C2.9 | "∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5" | Derivative is correct; the value at t = 5 is −41.255. \|J\| is monotone increasing on [2, 5]. | confirmed |
| C2.10 | "the 4th-order RKF update's stability limit 3.02" | Stability polynomial of the y4 update: 1 + z + z²/2 + z³/6 + z⁴/24 + z⁵/104, with the real root of R = −1 at −3.02002. For y5 the limit is 3.6777, but the page names the 4th-order update. | confirmed |
| C2.11 | "for fixed steps longer than about h = 0.0732, h\|∂f/∂y\| would exceed 3.02 before t = 5" | 3.020018 / 41.2554 = 0.07320 | confirmed |
| C2.12 | "every accepted step here keeps h\|∂f/∂y\| below 1.3" | Maximum over accepted steps, evaluated at either endpoint: 1.270 (RKF45) and 1.274 (RKF54) | confirmed |
| C2.13 | Legend and colours: dashed reference, RKF45 magenta, RKF54 blue | Lines 100–106; frames 008 and 081 | confirmed |
| C2.14 | Link and embed are `rungekuttafehlbergbb.jl` / `.gif` | index.qmd; manifest byte-identical; 81 frames = max(80, 81) accepted points | confirmed |
| C2.15 | Alt text: "Adaptive RKF45 and RKF54 trajectories versus high-accuracy RK4 reference for y' = 1 - t cbrt(y), y(0)=1 on [0,5]" | Matches | confirmed |
| C2.16 | Script comment: end point (5, 0.0081) | y(5) = 0.0081199 (mpmath, RK4 and both RKF runs) | confirmed |

**Fidelity.** Case 1 is the module's Example 1. The page states openly that its step controller differs from the module's and quantifies the effect (I3–I12, all verified). The page also says openly that Examples 6–8 (the Riccati problem) are not animated and that Case 2 is not a module example. Examples 2–5 use the Example 1 problem; Examples 4/5 are the error curves, and their numbers are quoted correctly (I7). I found no undisclosed departure.

### 3. Implementation checks

### `rungekuttafehlbergaa.jl` (Case 1)

1. **It is the method it claims.** It is the classical Fehlberg RKF4(5) tableau with nodes 0, 1/4, 3/8, 12/13, 1, 1/2. Row sums equal the nodes. The order conditions were checked by rooted trees in exact arithmetic: y4 has order exactly 4 and y5 order exactly 5 (`order.py`). A fixed-step convergence test on y' = 1 + y² over [0, 0.4] gives observed order 4.96 for y5. For y4 it gives 3.93 over [0, 0.8], approaching 4; its asymptotic regime is reached slowly, and the tree check is the decisive test (`conv.py`, `conv2.py`).
   - The controller is a legitimate variant: an error-per-unit-step test `err ≤ tol·h`, and s = 0.84(tol·h/err)^{1/4} with no clamp on the growth factor. This is the Burden–Faires form, and it is the one the page's Description states.
   - "RKF54" carries y5 forward (local extrapolation), as the page says.
2. **The numbers are right.** My independent Python stepper and controller (`repro.py`) reproduce the Julia run: 259 points for each method, 4 rejected steps, the same step sequence (|Δt| ≤ 8.6e-8). The remaining differences come from floating-point ordering, amplified near the pole.
   - Julia values against the exact solution: end y = 139.887359 for RKF45 and 139.885997 for RKF54, exact 139.882842. The errors are 4.5168e-3 and 3.1542e-3; maximum relative errors 3.229e-5 and 2.255e-5.
3. **Its reference values are right.** The exact solution tan(t + arctan 0.5) satisfies the ODE (residual 4e-40 at 40 digits) and the initial condition.
4. **The picture shows what was computed.** The log axis holds the full range. Frames 001, 002 and 066 match the computed points (the frame-2 marker is at t ≈ 0.40, matching index 5). The title, legend and colours match the code. There is no clamping or masking. The 66 frames match the stride formula.

### `rungekuttafehlbergbb.jl` (Case 2)

1. **It is the method it claims.** The RKF code is identical to aa.jl (checked with diff; only the problem, the reference and the plotting differ), so the checks in item 1 above apply.
2. **The numbers are right.** The Python replica matches Julia: 80 points (RKF45) and 81 (RKF54), 3 rejected steps each, |Δt| ≤ 2.5e-10 and |Δy| ≤ 2.2e-10.
   - Against mpmath `odefun`: maximum error 6.58e-7 (RKF45) and 9.4e-8 (RKF54).
   - The step-size profile, the maximum h|J| (1.27), and the hmin flag are as listed in the ledger.
3. **Its reference values are right.** RK4 with h = 1e-4, sampled every 100 points (502 samples including t = 5), differs from the 30-digit mpmath Taylor solution by at most 1.2e-14. y(5) = 0.008119920464867961 in both. That is far below the 7e-7 differences it is used to judge.
4. **The picture shows what was computed.** ylims (−0.1, 1.55) contain the maximum y of 1.45 and the end value of 0.008. Frames 001, 008 and 081 match the computed points. The polyline corners on the hump are chord sag (0.0091), as the page explains. The 81 frames are one per accepted point of the longer run; RKF45's marker holds at t = 5 in the last frame.

