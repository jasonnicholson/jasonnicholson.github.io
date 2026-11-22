# Runge-Kutta-Fehlberg Method — animation review (round 3)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None** (0 Error, 0 Misleading, 0 Minor).

I checked every numerical, behavioural, count and wiring claim on the page against my own computations and the frames. All of them hold at the precision stated. Section 2 lists each claim with its evidence, and Section 3 covers the implementation. I looked at the following and decided they are not findings:

- **Controller differs from Mathews' RKF45 subroutine (not a finding).** Mathews (gr_15) accepts a step when `err < ε` (absolute, per step). He uses `s = (εh/(2 err))^{1/4}`, limits s to [0.1, 4], and sets `h0 = 0.25`, `hmin = 0.001`, `hmax = 0.25`. The scripts accept when `err ≤ ε h` (per unit step, the Burden–Faires form), use `s = 0.84 (εh/err)^{1/4}` with no limit on s, and set `h0 = 0.1`, `hmin = 1e-6`, `hmax = 0.25`. The page's Description states exactly the rule the scripts use. The step-size formula is numerically the same as Mathews' (0.84 vs 0.840896), and the page never claims to reproduce Mathews' numbers. So this is a valid variant that is described correctly. It is not a fidelity error. (Mathews' own Example 1 reaches hmin = 0.001 near the pole, and his errors at t = 1.1 are −0.0704 for RKF45 and −0.0645 for RKF54 (gr_78, gr_93). The page's controller gives 4.5e-3 and 3.2e-3. The page does not compare the two.)
- **Stability limit applies only to the RKF45 update (not a finding).** In Case 2 the page quotes "the 4th-order RKF update's stability limit 3.02". RKF54 carries the 5th-order update forward, and that update's real-axis limit is 3.678 (computed below), so the fixed-step bound h ≈ 0.0732 applies to RKF45 only. The text names the 4th-order update explicitly, and the conclusion (accepted steps keep h|J| < 1.3, well inside both limits) holds for both. I judge this accurate as written.
- **RKF54's last step is 0.00064 (not a finding).** RKF54's final step in Case 2 is 0.00064 at t = 4.99936. This is the end-of-interval truncation `h = tf − t`, not a step the controller chose, so "the smallest step it chooses is 0.027" stands.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 10.7 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 12.8 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Script values come from instrumented copies (`review/inst_aa.jl`, `review/inst_bb.jl`), which dump every accepted (t, y) to `review/dump_inst_*.txt`. Independent values come from `review/indep.py`, `review/claims_aa.py`, `review/claims_bb.py`, `review/stab_sag.py`, `review/tableau_check.py` and `review/order.py`, all run with `/usr/bin/python3 -I`.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | RKF45 "computes embedded 4th- and 5th-order approximations from the same stage evaluations" | `tableau_check.py`, exact sympy rationals: row sums of A equal c = (0, 1/4, 3/8, 12/13, 1, 1/2). b4 satisfies all 8 order conditions through order 4 and fails the order-5 ones (residuals −1/2080 …). b5 satisfies all 17 order conditions through order 5. Fixed-step global errors on y' = −2ty over [0, 2] (`order.py`): ratios on halving h are 27.1, 21.6, 18.8 (→ 16) for b4 and 40.7, 36.3, 34.1 (→ 32) for b5 | confirmed |
| D2 | "\|y5 − y4\| estimates the local error of y4. It shrinks like h^5" | Single step from (0, 0.5) for y' = 1 + y²: ratio of \|y5 − y4\| at h and h/2 is 25.0, 29.1, 30.7 for h = 0.1, 0.05, 0.025 (→ 32) | confirmed |
| D3 | "\|y5 − y4\|/h is an error per unit step that shrinks like h^4" | Follows from D2 | confirmed |
| D4 | "A step is accepted when \|y5 − y4\|/h ≤ ε" | Script line 37 / 55: `err <= tol*h \|\| h <= hmin`. The hmin escape never fires: smallest step 2.8e-5 (Case 1) is greater than hmin = 1e-6 | confirmed |
| D5 | "h_new = s h with s = 0.84 (εh/\|y5 − y4\|)^{1/4}" | Script lines 44–45 / 62–63 (plus hmax = 0.25 clamp, which Case 2 text mentions as "the maximum step h = 0.25") | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | First animation reconstructs legacy Example 1: y' = 1 + y², y(0) = 0.5, on [0, 1.1] | Archive gr_27, gr_28, gr_29; script lines 8, 51–53 | confirmed |
| I2 | Dashed black curve is the exact solution y = tan(t + arctan 0.5) | mpmath: y(0) = 0.5. The ODE residual y' − (1 + y²) at t = 0.3, 0.9, 1.1 is 0, −1.9e-29, −5.1e-25. Script line 90 plots it black dashed | confirmed |
| I3 | Archive has no legacy RKF animated GIF portals | `find` over the archive and `a2001/Animations` turns up no RKF animation | confirmed |
| I4 | Examples 6–8 solve the Riccati equation y' = t² + y² with RKF45/RKF54 (Ex 6), compare with a closed-form Bessel solution (Ex 7), derive it with DSolve (Ex 8); not animated | gr_103, gr_106, gr_144 show y' = t² + y². gr_108 shows the RKF45 call. gr_123 shows the BesselJ/Gamma closed form. lnk_9 text: "Use Mathematica's DSolve procedure" | confirmed |
| I5 | Second animation uses the same IVP as the Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages: y' = 1 − t∛y, y(0) = 1, [0, 5] | grep of `eulersmethodaa/bb.jl`, `rungekuttaaa.jl`, `taylorderivativeaa/bb.jl`, `adamsbashforthmoultonaa.jl`: all use `f = 1 - t*cbrt(y)`, `t0, y0 = 0, 1`, `T = 5`. The Euler page headings are Forward Euler and Modified Euler | confirmed |
| I6 | Reference is fixed-step RK4 at h = 1e-4, "high-accuracy" | Script line 76. Max \|RK4 ref − DOP853 (rtol 1e-13)\| over all 50,001 nodes = 9.5e-13 | confirmed |
| I7 | This IVP is not one of the module's examples | Module examples are y' = 1 + y² (Ex 1–5) and y' = t² + y² (Ex 6–8) | confirmed |

### Case 1: y' = 1 + y², y(0) = 0.5, [0, 1.1]

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading parameters | Script lines 8, 51–54 | confirmed |
| C1.2 | Both traces within relative error 3.3e-5 of the exact solution all the way | Max rel. error, RKF45 3.229e-5 (at t = 1.1), RKF54 2.255e-5 | confirmed |
| C1.3 | y(1.1) = 139.88 | mpmath 139.8828425 | confirmed |
| C1.4 | Pole of tan at t = 1.1071 | π/2 − arctan 0.5 = 1.1071487 | confirmed |
| C1.5 | Log y-axis keeps the whole run in view | ylims (0.4, 200), data 0.5–139.89. Last frame (frame_066) shows the end marker at ~140 inside the box | confirmed |
| C1.6 | Step shrinks from 0.136 near t = 0.1 to 5e-5 near t = 1.1 | Step from t = 0.1: 0.13600. Last regular steps 5.08e-5, 5.02e-5, 4.97e-5, then a truncated final step 2.82e-5 to reach 1.1 | confirmed |
| C1.7 | 187 of the 259 computed points lie in t ≥ 1.05 | Count from the dump: 187 of 259 (both modes) | confirmed |
| C1.8 | Marker slows as it nears the pole; each frame adds up to four accepted steps | stride = 4, frames 1:4:259 ∪ {259} gives 66 frames (committed GIF has 66). About 47 of the 66 frames cover t ≥ 1.05 | confirmed |
| C1.9 | RKF45 and RKF54 share the error estimate and the step rule and differ only in whether y4 or y5 is carried forward | Same `rkf_integrate`, line 39 `y = mode == :rkf45 ? y4 : y5` | confirmed |
| C1.10 | Their steps agree to within 0.05% | Max relative step difference across all 258 steps = 0.041% (t ≈ 1.09967) | confirmed |
| C1.11 | Curves coincide (blue over magenta) | RKF54 royalblue lw 2 drawn after RKF45 magenta lw 5. Frames 002 and 066 show a blue line on a magenta band | confirmed |
| C1.12 | RKF54 ends closer: errors 3.2e-3 vs 4.5e-3 at t = 1.1 | RKF54 y = 139.8859967, error 3.154e-3. RKF45 y = 139.8873593, error 4.517e-3 | confirmed |
| C1.13 | Source link / embed are Case 1 | `rungekuttafehlbergaa.jl` / `.gif`. Committed GIF byte-identical to a fresh regeneration (md5 d1a7795e…) | confirmed |
| C1.14 | Alt text: RKF45 and RKF54 vs exact, y' = 1 + y², y(0) = 0.5, [0, 1.1], log y-axis | Matches script and frames | confirmed |

### Case 2: y' = 1 − t∛y, y(0) = 1, [0, 5]

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading parameters | Script lines 8, 69–72 | confirmed |
| C2.2 | Both match the reference to within 7e-7 at every accepted point | Max \|y − ref\|: RKF45 6.58e-7 (vs script's own RK4 ref, interpolated) and 6.577e-7 (vs DOP853). RKF54 9.4e-8 | confirmed |
| C2.3 | Maximum step h = 0.25 over the hump (0.1 ≤ t ≤ 1.35) | Steps from t = 0.1, 0.35, 0.6, 0.85, 1.1 are all 0.25 (hump max y = 1.44977 at t = 0.8836) | confirmed |
| C2.4 | h between 0.189 and 0.25 until t ≈ 2.4 | Steps from 1.35 … 2.199: 0.2435, 0.2176, 0.1989, 0.1891, 0.2001 (to t = 2.3992), then 0.1029 | confirmed |
| C2.5 | Steepest point y' = −0.930 at t = 2.19 | Bounded minimisation of f(t, y(t)): t = 2.1945, y' = −0.93027 | confirmed |
| C2.6 | Below 0.04 from t = 3 on | Largest step starting at t ≥ 3: 0.03988 (RKF45), 0.03987 (RKF54) | confirmed |
| C2.7 | Smallest step it chooses is 0.027, near t = 3.27 | 0.027356 at t = 3.2716 (both modes). RKF54's final 0.00064 step is the forced truncation to t = 5 | confirmed |
| C2.8 | Corners on the hump are straight segments between points 0.25 apart, up to 0.0091 below the curve near t = 0.48 | Max (reference − chord) = 0.009112 at t = 0.4752 on segment [0.35, 0.60]. The chord lies below the curve. Visible in frame_012 and frame_081 | confirmed |
| C2.9 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | Derivative of −t y^{1/3} is correct. With y(5) = 0.0081199205: J(5) = −41.255 | confirmed |
| C2.10 | 4th-order RKF update's stability limit 3.02 | R(z) = 1 + z b4ᵀ(I − zA)⁻¹e evaluated directly. Real-axis root of \|R\| = 1 is z = −3.020018 (coefficients 1, 1/2, 1/6, 1/24, 0.0096154, so a 5-stage, not a classical-RK4, polynomial). For reference, the y5 update's limit is 3.6777 | confirmed |
| C2.11 | Fixed steps longer than about h = 0.0732 would exceed that limit before t = 5 | 3.02/41.255 = 0.07320. \|J\| grows monotonically in the tail | confirmed |
| C2.12 | Every accepted step keeps h\|∂f/∂y\| below 1.3 | Max over each step (exact solution sampled on the step): RKF45 1.2697, RKF54 1.2737 | confirmed |
| C2.13 | Steps are set by the tolerance, not by stability | Accepted h\|J\| is at most 1.27, against a limit of 3.02. At t = 3.27 the step is 0.027 against a stability-allowed ≈ 0.30. Consistent with accuracy-limited control | confirmed |
| C2.14 | Source link / embed are Case 2 | `rungekuttafehlbergbb.jl` / `.gif`. Byte-identical to regeneration (md5 c2573236…). 81 frames = RKF54 point count | confirmed |
| C2.15 | Alt text: RKF45 and RKF54 vs high-accuracy RK4 reference, y' = 1 − t cbrt(y), y(0) = 1, [0, 5] | Matches the script legend "Reference (RK4 h=1e-4)" and the frames | confirmed |

### 3. Implementation checks

### `rungekuttafehlbergaa.jl`

- **Is the method it claims.** It is Fehlberg's RK4(5) embedded pair, 6 stages. I checked the coefficients without relying on memory: sympy order conditions (b4 exactly order 4, b5 exactly order 5) and node sums. Step control is the Burden–Faires per-unit-step form described on the page. `:rkf45` carries y4. `:rkf54` carries y5 (local extrapolation), which matches Mathews' "RKF54" remark (accept the order-5 value).
- **Numbers.** I wrote an independent Python implementation (`indep.py`: Butcher-matrix stage loop, same controller as the page Description). Both versions give 259 points with 4 rejections and the same step sequence to rounding (max \|Δt\| = 8.9e-8, from floating-point ordering amplified by the controller near the pole). Final y(1.1): independent RKF45 139.8873593, RKF54 139.8859967, matching the script to all printed digits. Errors 4.5168e-3 and 3.1542e-3, identical to the script's.
- **Reference.** tan(t + arctan 0.5) satisfies the ODE and the IC (mpmath residuals ≤ 5e-25). Plotted on 800 points over [0, 1.1], all short of the pole at 1.10715.
- **Picture.** Frames 001, 002, the sheet and 066 checked. Frame k shows accepted points 1…(4k−3), and the marker sits at the last accepted point of each trace (frame 002: t = 0.3957, y ≈ 1.16, matching the dump). Log axis, no clamping, nothing clipped. The title shows the right ODE, IC and tol.

### `rungekuttafehlbergbb.jl`

- **Is the method it claims.** Same `rkf_integrate` as aa (identical source text), so the same conclusions apply.
- **Numbers.** Independent implementation: RKF45 has 80 points, 3 rejections. RKF54 has 81 points, 3 rejections. Max \|Δt\| vs the script is 2.5e-10 and max \|Δy\| is 2.2e-10. Final y(5): RKF45 0.008119888901, RKF54 0.008119910749, against DOP853 0.008119920465.
- **Reference.** Fixed-step RK4 with h = 1e-4 (50,000 steps, range lands exactly on 5.0) agrees with scipy DOP853 (rtol 1e-13, atol 1e-16) to 9.5e-13 everywhere. This is more than accurate enough for a comparison at the 1e-7 level.
- **Picture.** Frames 001, 012 (marker at t = 2.3992, y ≈ 0.49, matching the dump), the sheet and 081 checked. ylims (−0.1, 1.55) contain the hump (1.4498) and the end point (0.0081). There are 81 frames, and RKF45 holds its last point in the final frame. Title and legend match the code.

### Regeneration

Both committed GIFs are byte-identical to the isolated regenerations (md5 compared). The frame counts, 66 and 81, match the scripts' frame logic.

