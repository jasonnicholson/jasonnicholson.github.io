# Runge-Kutta-Fehlberg Method — animation review (round 9)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Description and Animations sections matches my independent computation, the instrumented script output, or the frames. Details are in the ledger below.

Observations below the bar for a finding (no action needed):
- The Case 2 stability sentence quotes the limit of the 4th-order update, 3.02. In RKF54 mode the carried update is the 5th-order one, whose limit is 3.68. The sentence names the 4th-order update explicitly, so it is accurate as written, and the conclusion ("set by the tolerance, not by stability") holds for both.
- In Case 1 the last accepted step is 2.8e-5. It is truncated to land exactly on t = 1.1. The last step the controller actually chooses is about 5.0e-5, which is what the page quotes ("5e-5 near t=1.1"). The same applies to the 0.00064 final step of RKF54 in Case 2: the page's "smallest step it chooses is 0.027" correctly excludes it.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 10.1 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 14.7 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | RKF45 is an adaptive one-step solver; computes embedded 4th- and 5th-order approximations from the same stage evaluations | confirmed | Both updates use the same k1..k6 (y4 uses k1..k5). Order conditions: the y4 weights satisfy all 8 conditions up to order 4 and violate all 9 at order 5; the y5 weights satisfy all 17 up to order 5 and violate all 20 at order 6 (`tableau_check.py`). |
| D2 | \|y5−y4\| estimates the local error of y4, shrinks like h^5; divided by h it shrinks like h^4 | confirmed | Since y4 is order 4 and y5 is order 5, y5−y4 = O(h^5). Numerically, on y'=1+y² from t=0, \|y5−y4\| is 1.41e-7, 1.46e-8, 5.83e-10, 2.00e-11 for h = 0.2, 0.1, 0.05, 0.025. The ratios 9.7, 25 and 29 approach 32. |
| D3 | Accept when \|y5−y4\|/h ≤ ε | confirmed | Script line 37 (aa) / 55 (bb): `err <= tol * h` |
| D4 | h_new = s h, s = 0.84 (εh/\|y5−y4\|)^{1/4}, clamped to at most h_max = 0.25 | confirmed | aa lines 44–45 / bb 62–63; `hmax=0.25` |
| D5 | Scripts impose h_min = 1e-6, which neither case reaches | confirmed | The smallest accepted step is 2.82e-5 (Case 1, final truncated step) and 0.00064 (Case 2). No step was accepted through `h <= hmin` (flag `hmin-accepted=False` in `case1.py` and `case2.py`). |

### Animations introduction (Case 1 context and module comparison)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Reconstructs legacy Example 1: y'=1+y², y(0)=0.5, on [0,1.1] | confirmed | Archive gr_44 "y' = 1 + y^2", gr_45 "y(0) = 0.5", gr_46 "[0, 1.1]"; script lines 8, 51–53 |
| A2 | Exact solution y = tan(t + arctan 0.5) | confirmed | mpmath: the ODE residual at t=0.7 is 4e-40 and y(0)=0.5 |
| A3 | Module subroutines accept when \|y5−y4\| < ε or h < 2h_min | confirmed | gr_15/gr_26: `If[Or[err < ε, h < 2 hmin], ...]`, err = \|Σ r_i k_i\| = \|y5−y4\| (r1 = 1/360 = 16/135−25/216, and so on) |
| A4 | Module starts from h = 0.25 (here 0.1), h_min = 0.001 | confirmed | gr_15/26: `h = 0.2500`, `hmin = 0.001`. The script has `h0=0.1`. |
| A5 | At ε = 1e-6 the module takes 120 points | confirmed | Emulation: 120 points (119 steps) for both. The emulated t-list matches archive gr_71 (0, 0.25, 0.327661, 0.434978, 0.50781, 0.561351, … 1.09924, 1.1). |
| A6 | The step reaches h_min at t ≈ 1.055 | confirmed | The first step at h_min begins at t = 1.05524 (both modes) |
| A7 | The last 8 of the 119 steps, from t ≈ 1.092 on, are accepted only by h < 2h_min | confirmed | Exactly 8 steps (indices 111 to 118, contiguous to the end) have err ≥ ε. The first of them starts at t = 1.09224. |
| A8 | Module end errors 7.0e-2 (RKF45) and 6.5e-2 (RKF54) at t = 1.1 | confirmed | Emulation gives 7.0410e-2 and 6.4500e-2. The archive's own error tables, gr_78 and gr_93, end with −0.0704102 and −0.0645005, which my emulation reproduces digit for digit. |
| A9 | Page's own errors 4.5e-3 and 3.2e-3 (Case 1) | confirmed | Instrumented Julia: 4.5168e-3 (RKF45), 3.1542e-3 (RKF54) |
| A10 | The first step of 0.25 has error estimate 1.7e-7, which passes either acceptance test | confirmed | err = 1.6731e-7. It is < 1e-6 (module) and err/h = 6.7e-7 ≤ 1e-6 (page). |
| A11 | True error of that step is 5.6–5.7e-6 | confirmed | Emulation gives 5.7370e-6 (RKF45) and 5.5697e-6 (RKF54). These match archive gr_78 and gr_93 (−5.73703e-6, −5.56972e-6). |
| A12 | The problem magnifies it about 1.1e4 times by t = 1.1 | confirmed | The linearized propagation factor (1+y(1.1)²)/(1+y(0.25)²) = 11183 |
| A13 | Started from h = 0.25, the page's controller ends with errors 6.6e-2 and 6.3e-2 | confirmed | `page_ctrl(h0=0.25)` gives 6.6418e-2 and 6.2847e-2 |
| A14 | "Most of that difference is the first step of 0.25" | confirmed | It follows from A9 and A13: 4.5e-3 rises to 6.6e-2 from the start step alone, against the module's 7.0e-2. |
| A15 | The recovered archive has no RKF animated GIF portals | confirmed | No RKF, Runge or Fehlberg entries in `a2001/Animations/`. No animation links in the module page. |
| A16 | Examples 6–8 solve the Riccati equation y' = t² + y² with RKF45/RKF54 (Ex 6), compare it with the closed-form Bessel solution (Ex 7), and derive it with DSolve (Ex 8); not animated | confirmed | gr_103 "y' = t^2 + y^2", gr_104 "y(0.0) = 0.5", gr_123 is a BesselJ/Gamma closed form, gr_144 is the Ex 8 equation. The module text matches the description of each example. |
| A17 | Second IVP y' = 1 − t∛y, y(0)=1, [0,5] is the one used on the Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages | confirmed | Grep: `eulers-method-for-odes` Cases 1 and 2 (forward and modified Euler), `runge-kutta-method`, `taylor-series-method-for-odes` and `adams-bashforth-moulton-method` all use it. |
| A18 | Dashed reference from fixed-step RK4 at h = 1e-4 | confirmed | bb lines 10–27 and 76. Its maximum deviation from an mpmath Taylor ODE solution (30 digits) on a 0.1 grid is 1.2e-14. |
| A19 | This IVP is not one of the module's examples | confirmed | The module's examples use only y'=1+y² (Ex 1–5) and y'=t²+y² (Ex 6–8) |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: y'=1+y², y(0)=0.5, t∈[0,1.1] | confirmed | Script lines 8, 51–53 |
| C1.2 | Both traces stay within a relative error of 3.3e-5 all the way | confirmed | Maximum relative error is 3.229e-5 (RKF45) and 2.255e-5 (RKF54), both at t = 1.1 (Julia output against the mpmath exact solution) |
| C1.3 | y(1.1) = 139.88 | confirmed | 139.88284 |
| C1.4 | Just short of the pole at t = 1.1071 | confirmed | π/2 − arctan 0.5 = 1.107149 |
| C1.5 | The log y-axis keeps the whole run in view | confirmed | ylims (0.4, 200). In frame 66 the end marker is visible at about 140. |
| C1.6 | Step shrinks from 0.136 near t=0.1 to 5e-5 near t=1.1 | confirmed | The step from t=0.1 is 0.13600, the largest of the run. The last controller-chosen steps are 5.18e-5 down to 4.97e-5. |
| C1.7 | 187 of the 259 computed points lie in t ≥ 1.05 | confirmed | 259 points and 187 with t ≥ 1.05, for both modes (Julia) |
| C1.8 | Each frame adds up to four accepted steps | confirmed | frames = 1:4:259 ∪ {259} gives 66 frames, with a maximum increment of 4. The committed GIF has 66 frames. |
| C1.9 | RKF45 and RKF54 share the error estimate and step rule | confirmed | Same `rkf_integrate`; only line 39 (`y4` or `y5`) differs |
| C1.10 | Their steps agree to within 0.05% | confirmed | Maximum relative step difference is 0.041% (Julia output) |
| C1.11 | Curves coincide, blue over magenta | confirmed | RKF54 royalblue lw=2 is drawn after RKF45 magenta lw=5. Frame 66 shows a thin blue line inside the magenta band. |
| C1.12 | RKF54 ends closer: 3.2e-3 against 4.5e-3 at t = 1.1 | confirmed | 3.154e-3 against 4.517e-3. The final t is exactly 1.1 in both runs. |
| C1.13 | Alt text (log axis, both traces against the exact solution) | confirmed | Matches the frames and the script |
| C1.14 | Link and embed → `rungekuttafehlbergaa.jl` / `.gif` | confirmed | The committed GIF is byte-identical to the regenerated one (manifest) and has the Case 1 title |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: y'=1−t∛y, y(0)=1, t∈[0,5] | confirmed | bb lines 8, 69–71 |
| C2.2 | Both runs are within 7e-7 of the reference at every accepted point | confirmed | Maximum \|y−ref\| is 6.58e-7 (RKF45, t=2.01) and 9.4e-8 (RKF54) |
| C2.3 | Takes h = 0.25 over the hump (0.1 ≤ t ≤ 1.35) | confirmed | Five steps of 0.25 from t=0.1 to t=1.35, in both modes. The hump peak is y = 1.4498 at t = 0.884. |
| C2.4 | h stays between 0.189 and 0.25 until t ≈ 2.4 | confirmed | Steps from 1.35 to 2.399 are 0.2435, 0.2176, 0.1989, 0.1891, 0.2001. The next step is 0.1029 at t=2.399. |
| C2.5 | Steepest point y' = −0.930 at t = 2.19 | confirmed | min y' = −0.93027 at t = 2.1945 (DOP853, rtol 1e-13) |
| C2.6 | Step is below 0.04 from t = 3 on | confirmed | The first step < 0.04 starts at t = 2.9959 (h = 0.0370). No step ≥ 0.04 starts at t ≥ 3. |
| C2.7 | Smallest chosen step 0.027, near t = 3.27 | confirmed | 0.027356 at t0 = 3.2716 (both modes, excluding the truncated final step) |
| C2.8 | Corners on the hump are 0.25-chords, up to 0.0091 below the curve near t = 0.48 | confirmed | The largest curve-minus-chord gap is 0.009112 at t = 0.475, on segment [0.35, 0.6] |
| C2.9 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | confirmed | y(5) = 0.0081199 gives −41.255. \|f_y\| increases monotonically on [4, 5]. |
| C2.10 | Fixed steps longer than about 0.0732 would exceed the limit before t = 5 | confirmed | 3.020018/41.255 = 0.07320 |
| C2.11 | 4th-order RKF update's stability limit 3.02 | confirmed | R(z) = 1+z+z²/2+z³/6+z⁴/24+z⁵/104 has a real root of R = −1 at z = −3.020018 |
| C2.12 | Every accepted step keeps h\|f_y\| below 1.3 | confirmed | max is 1.270 (RKF45) and 1.274 (RKF54), evaluated at either end of each step |
| C2.13 | Steps are set by tolerance, not stability | confirmed | Follows from C2.11 and C2.12 |
| C2.14 | Alt text | confirmed | Matches the frames and the script legend "Reference (RK4 h=1e-4)" |
| C2.15 | Link and embed → `rungekuttafehlbergbb.jl` / `.gif` | confirmed | Byte-identical regeneration. The title matches Case 2. 81 frames = max(80, 81) accepted points. |

### 3. Implementation checks

### `rungekuttafehlbergaa.jl`
- **Method:** this is Fehlberg's 4(5) pair with a Burden–Faires-style controller: tolerance per unit step, s = 0.84(εh/err)^{1/4}, no [0.1, 4] clamp on s, h clamped to [1e-6, 0.25], and h = 0.1 to start. RKF45 carries y4 and RKF54 carries y5. The stage coefficients and both weight vectors are identical to Mathews' (gr_2, gr_15, gr_26). Their order is confirmed independently through the rooted-tree conditions (y4 is exactly order 4 and y5 exactly order 5). The c-nodes in the code equal the row sums of A.
- **Numbers:** my independent Python stepper and controller reproduce the script's runs: 259 points each and 4 rejections. The maximum difference in t is 4.7e-8 and the maximum relative difference in y is 4.3e-6. Both come from floating-point summation order, amplified near the pole. My final errors are 4.5168e-3 and 3.1542e-3; Julia's are 4.5168e-3 and 3.1542e-3.
- **Reference:** tan(t + atan 0.5) satisfies the ODE (residual 4e-40) and y(0) = 0.5. It is sampled at 800 points up to t = 1.1, short of the pole at 1.10715.
- **Picture:** frames 1, 2 to 11 (contact sheet) and 66 were inspected. The dashed exact curve, the magenta wide RKF45 line, the blue thin RKF54 line on top, and the markers at the current accepted point are all built from the right arrays. The title matches the code. The log axis and its limits clip nothing. The frame count is 66.

### `rungekuttafehlbergbb.jl`
- **Method:** same routine as `aa` (identical `rkf_integrate`).
- **Numbers:** my independent run reproduces 80 (RKF45) and 81 (RKF54) points. The maximum difference against Julia is 1.8e-10 in t and 1.6e-10 in y. Every step size quoted on the page was recomputed (see ledger C2.3 to C2.12).
- **Reference:** the RK4 reference at h = 1e-4 agrees with an mpmath 30-digit Taylor solution to 1.2e-14, far below the 7e-7 comparison it supports. y(5) = 0.00811992.
- **Picture:** the contact sheet and frame 81 were inspected. The hump corners are the visible 0.25-chords. The end point (5, 0.0081) is inside the axes. The title and legend are correct. There are 81 frames.

### Legacy fidelity
Case 1 is the module's Example 1 with the same IVP and interval. The page openly uses a different step controller and quantifies the consequences correctly (A3 to A14). My emulation of Mathews' own subroutine reproduces his printed error tables exactly. Examples 6 to 8 are explicitly acknowledged as not animated. Examples 2 to 5 are NDSolve/DSolve/error-table companions to Example 1, and the page's text covers their substance (the exact solution and the end errors). Case 2 is openly labelled as not from the module. No fidelity finding.

