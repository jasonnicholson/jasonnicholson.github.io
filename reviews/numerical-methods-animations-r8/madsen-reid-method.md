# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 8)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

I found no Error, Misleading or Minor finding. Every checkable claim in the Animations section and the algorithmic parts of the Description was confirmed against my own computation and the frames (ledger below). Items I could not determine are listed in the ledger and are not counted as findings.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.1 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 10.1 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 9.8 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `madsreidaa.gif` | 7 | byte-identical | madsreidaa |
| `madsreidab.gif` | 6 | byte-identical | madsreidab |
| `madsreidac.gif` | 9 | byte-identical | madsreidac |

### Page references

- Scripts linked: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words, abbreviated) | Verdict | Evidence |
|---|---|---|---|
| D1 | Scripts port the iteration of `newton_real` with one correction (Stage 2) | Confirmed | Line-by-line comparison of `newton_real_iterates` with Newton_Real.cpp lines 239-311: loop condition, `feval`, `upperbound` (2^-52 = `pow(2,-DBL_MANT_DIG+1)`), rounding threshold 2^-26 (`-DBL_MANT_DIG/2` integer division), initial `eps = 4n^2 f0 2^-106`, `r0 = r*5`, the `div2` loop over i = 1..n, `alterdirection(dz,0.5)` after two helpful halvings, the `goto iter2` retry. Only behavioural departure: `fz0 = fz1` instead of `fz0 = fz` (C++ line 264). The scripts' own start (Cases 1, 2) and the absence of deflation are disclosed elsewhere on the page and in the script headers. |
| D2 | Newton at a root of multiplicity m: f/f' ~ (x-x*)/m, error factor (m-1)/m per step | Confirmed | Standard; Case 2 plain Newton from 4 shows ratio -> 0.5 (below). |
| D3 | Stage 1: if z - dz does not increase \|f\|^2, tries z-2dz ... up to z-(n+1)dz, stops at first trial that does not lower \|f\|^2, keeps the trial before | Confirmed | C++ `div2 = f > f0`; `wz -= dz` for i = 1..n gives up to (n+1)dz; `if (fw >= f) break`. |
| D4 | Near a root of multiplicity m that point is z - m dz, so convergence to a multiple root is quadratic in Stage 1 | Confirmed | Model f ~ c e^m gives \|f(z-k dz)\|^2 ~ \|1-k/m\|^{2m}, decreasing to k = m, increasing at k = m+1. Case 2: every step after the first picks k = 2; e3/e2^2 = 0.160, e4/e3^2 = 0.167 (quadratic). |
| D5 | Stage 2 takes plain Newton steps, linear at a multiple root | Confirmed | Code; D2. |
| D6 | Near a double root the two sides of the stage test tend to equality | Confirmed | Model: 2\|f\|\|f''\|/\|f'\|^2 = 1 for f = c e^2. Computed ratio (f2/u)/(u/4f): Case 2 steps 4, 5: 1.087, 1.003; -0.7 start steps 3-5: 1.534, 1.438, 1.024. |
| D7 | Case 2 stays in Stage 1 throughout | Confirmed | Script trace: all five steps `stage1`. |
| D8 | From x0 = -0.7: plain Newton step past the root to x1 ~ 1.7556, one Stage-2 step to x2 ~ 1.4123 (error 0.76 -> 0.41) | Confirmed | Script routine (`ab_core.jl`): x1 = 1.7555555555555553 (plain, Stage 1; 2dx trial 4.211 has \|P\|^2 = 4102 > 4.60), x2 = 1.4123058542413378 (Stage 2); errors 0.7556, 0.4123. Python agrees. |
| D9 | The stage test then fails (left side 1.24 times right side) | Confirmed | Ratio of squared sides 1.534 at step 3, sqrt = 1.2386; previous step plain so f = ff, i.e. Stage 1 is due to the test alone. |
| D10 | Three lengthened Stage-1 steps with k = 2: errors 2.3e-2, 9.1e-5, 1.4e-9; computed \|f\|^2 exactly 0; stops after 5 steps | Confirmed | Script: errors 0.02349, 9.09e-5, 1.377e-9; step 5 \|P\|^2 = 0; 5 steps. |
| D11 | r0 <- 5\|dz\|, reset after each Newton step to five times the uncapped length | Confirmed | C++ lines 257-260 (r computed before cap; not reset in the saddle branch, which is not a Newton step). |
| D12 | A step longer than r0 is cut to r0 and rotated by 53.13 deg by `alterdirection` | Confirmed | `alterdirection(dz, r0/r)` multiplies by (0.6+0.8i) r0/r; atan2(0.8,0.6) = 53.130 deg, \|0.6+0.8i\| = 1. |
| D13 | No Newton step in the three animations is longer than r0; Cases 1, 2 scripts stop with an error on a rotation | Confirmed | `cap=0` on every step of all three traces; the `all(... imag == 0 ...) || error(...)` guard in aa/ab. |
| D14 | Each iteration computes dz = f/f' | Confirmed | `dz = fz * conj(fz1) / \|fz1\|^2`. |
| D15 | Stage 1 halving: step halved, each halving kept only while it lowers \|f\|^2 below the previous trial | Confirmed | C++ loop: `dz *= 0.5; wz = z0 - dz; if (fw >= f) break; f = fw`. |
| D16 | Two helpful halvings: rotate 53.13 deg and halve once more (x 0.5(0.6+0.8i)), point accepted | Confirmed | C++ lines 289-294; accepted without a comparison. |
| D17 | Stage 2: z - dz, no trial points; run ends once \|f(z)\| <= Adams' bound | Confirmed | `eps = upperbound(z)` (squared bound) then loop test `f > eps`. |
| D18 | Stage 2 used only when previous step was plain Newton and 2\|f(z_k)\|\|w\| <= \|f'(z_k)\|^2 \|z_{k-1}-z_k\| | Confirmed | `stage1 = f2/u > u/f/4 \|\| f != ff` is equivalent (square roots of 4 f f2 > u^2); `f != ff` exactly when the search moved off the Newton point. |
| D19 | w/(z_{k-1}-z_k) estimates f''; the test estimates Kantorovich's 2\|f\|\|f''\| <= \|f'\|^2 | Confirmed | Holds with the scripts' w = f'(z_{k-1}) - f'(z_k); Kantorovich h = \|f\|\|f''\|/\|f'\|^2 <= 1/2. |
| D20 | The scripts store f'(z_{k-1}); `newton_real` stores f(z_{k-1}); reference's initial value f'(0) | Confirmed | C++ line 264 `fz0 = fz` (P); line 232 `fz0 = a[n-1]` = P'(0); script line 111 `fz0 = fz1`. Effect on these three runs: none: `mr.py` with `store_deriv=False` gives identical iterates and stages in all three cases (only the test ratios differ). |
| D21 | "as Madsen and Reid's test (2.9) requires" | Could not determine | The 1975 AERE report is not available here; the mathematical justification (D19) holds. |
| D22 | Saddle branch (f' = 0): previous step rotated 53.13 deg and lengthened 5x; rounding branch (step shorter than 2^-26\|z\| that does not lower \|f\|^2: retried, rotated, halved); neither reached | Confirmed | C++ lines 246-247, 304-311; `saddle=0 rounding=0` on every step. |
| D23 | Not a guarantee of descent: halving compared with previous trial, rotated step unchecked, Stage 2 unchecked | Confirmed | Code. |
| D24 | In all three animations \|f\|^2 decreases at every step | Confirmed | Case 1: 289 -> 3.17 -> 0.637 -> 2.38e-3 -> 5.2e-8 -> 2.6e-17 -> 3.2e-30. Case 2: 2916 -> 0.746 -> 5.1e-4 -> 1.7e-11 -> 2.5e-26 -> 0. Case 3: 25 -> 16.5 -> 12.37 -> 2.19 -> 0.0405 -> 6.1e-6 -> 1.5e-13 -> 7.9e-29 -> 1e-59. |
| D25 | Uses only f and f' plus extra f evaluations at trial points; Halley/Householder need f'' etc. | Confirmed | Code; standard. |
| D26 | Deflation after each root, degree -1 or -2, remaining linear/quadratic solved analytically | Confirmed | C++ lines 315-330 and `while (n > 2)`, `quadratic(n,a,res)` (describes the reference; the scripts run only the first-root loop, as their headers say). |
| D27 | "robust, globally convergent" | Could not determine | No proof available here; the page itself notes descent is not guaranteed in this implementation. Not raised as a finding. |
| D28 | Generalization note: lengthening bound n+1 and Adams' bound depend on the polynomial; rotation needs complex evaluation; Cases 1 and 2 never leave the real axis | Confirmed | Code; traces (all imag parts 0 in Cases 1, 2). |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = plain Newton steps, green = lengthened (k >= 2) drawn as tangent to the Newton point then along the axis, orange = halved or rotated | Confirmed | `stepcolor`; plotting loop (tangent `[xn, xt[k]]`, thick axis segment `[xt[k], xn1]`); frames aa/002-003, ab/002-006, ac/002-009. |
| A2 | Label of the current point names the stage of the step that reached it | Confirmed | `stage2[frame]` in the label; frames. |
| A3 | Cases 1, 2 start from own x0 with r0 = 5\|x0\|; Case 3 starts where the reference does | Confirmed | aa/ab line 15. Reference `startpoint` on z^2+4: u = exp((ln 4 - ln 1)/2) = 2 (a1 = 0 skipped); z = 1 (a[n-1] = 0) times u/2 = 1; r0 = 2.5u = 5. |
| A4 | In Case 3, star markers show the exact roots | Confirmed | Green stars at +-2i, frames ac/*. |
| A5 | Source scripts linked under each case | Confirmed | Links and embeds match the scripts/GIFs (manifest, page lines 51-69). |

### Case 1: P(x) = x^3 - 3x - 1, x0 = 3.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: P, x0 = 3.0 | Confirmed | aa lines 10-14. |
| C1.2 | Three simple real roots | Confirmed | 2cos(pi/9), 2cos(5pi/9), 2cos(7pi/9) (discriminant > 0). |
| C1.3 | \|P\|^2 = 17.3, 3.17, 8.73 for dx, 2dx, 3dx; first move x1 = x0 - 2dx ~ 1.5833 (green), passes the root | Confirmed | Trials: 2.29167 -> 17.3075, 1.58333 -> 3.17079, 0.875 -> 8.73249; x1 = 1.583333333333333 < 1.8794. |
| C1.4 | Every later step plain Newton (blue); step 2 Stage 1, steps 3-6 Stage 2; no halving | Confirmed | Script trace kinds `plain`, then `stage2` x4; halvings = 0 throughout. |
| C1.5 | Root x* ~ 1.8794 | Confirmed | mpmath 1.879385241571816768... |
| C1.6 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2-5; quadratic | Confirmed | 0.097829, 0.0063969, 3.0154e-5, 6.7487e-10; e_{k+1}/e_k^2 = 0.668, 0.737, 0.742 -> \|P''/(2P')\| = x*/(x*^2-1) = 0.742. |
| C1.7 | x6 equals x* to double precision; \|P\| below Adams' bound; run stops | Confirmed | x6 = 1.8793852415718169, x6 - x* = 8.8e-17 < half-ulp 1.1e-16 (the other neighbour is 1.3e-16 away), so x6 is the correctly rounded root; \|P\|^2 = 3.16e-30 <= eps = 2.45e-27; 6 steps. |
| C1.8 | Alt text: doubled first step to 1.5833, plain Newton steps, Stage 2 from step 3 on, converging quadratically to 1.8794 | Confirmed | As above; frames aa/001-007. |

### Case 2: P(x) = (x-1)^2(x+2), x0 = 4.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: P, x0 = 4.0 | Confirmed | ab lines 10-14 (x^3 - 3x + 2 = (x-1)^2(x+2)). |
| C2.2 | Double root at 1 where P'(1) = 0 | Confirmed | Factorization. |
| C2.3 | Standard Newton from 4: error roughly halves, still 3.4e-4 after 14 steps | Confirmed | Plain Newton: e14 = 3.354e-4; ratios -> 0.50. |
| C2.4 | Lengthened step every time, all green, all Stage 1; run starts in Stage 1 (f != ff on the first iteration) | Confirmed | Trace; first iteration test ratio 0.41 alone would allow Stage 2 but ff = 2a_n^2 = 8 != f = 2916. |
| C2.5 | 3dx to x1 = 0.4, past the root | Confirmed | P(4) = 54, P'(4) = 45, dx = 1.2; 4 - 3.6 = 0.4; 4dx trial at -0.8 gives 15.1 > 0.746. |
| C2.6 | Then 2dx four times | Confirmed | k = 2 on steps 2-5. |
| C2.7 | Errors 8.6e-2, 1.2e-3, 2.3e-7 of x2-x4, quadratic | Confirmed | 0.085714, 0.0011742, 2.2964e-7; ratios 0.160, 0.167. |
| C2.8 | x5 ~ 0.99999999952 (error 4.8e-10); computed \|P(x5)\|^2 exactly 0; true value ~ 4.8e-37; run stops | Confirmed | x5 = 0.9999999995193409, error 4.807e-10; script \|P\|^2 = 0; exact ((x-1)^2(x+2))^2 = 4.804e-37. (My independent complex-Horner implementation reaches a different x5, 0.99999999984, from rounding in an ill-conditioned evaluation; the page attributes the end to rounding, consistent.) |
| C2.9 | No step halved | Confirmed | halvings = 0. |
| C2.10 | From x2 on, the window zooms on each step; steps shrink from 0.69 to 2.3e-7; tangent meets the axis halfway, then second dx along the axis | Confirmed | `frame >= 2` zoom code; step lengths 0.6857 and 2.30e-7; frames ab/003-006 show tangent to the midpoint then thick axis segment. |
| C2.11 | Alt text: five lengthened steps (3dx, then 2dx four times), zooming from x2 on | Confirmed | As above. |

### Case 3: P(z) = z^2 + 4, z0 = 1 + 0i

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Roots +-2i, no real roots | Confirmed | |
| C3.2 | Reference solves quadratics in closed form; the case runs the loop directly from z0 = 1, r0 = 5 | Confirmed | C++ `while (n > 2)`; A3. |
| C3.3 | Full step to -1.5 increases \|P\|^2 (39.1 vs 25); one halving to z1 = -0.25; second halving to 0.375 does not help | Confirmed | Trials: -1.5 -> 39.0625; -0.25 -> 16.5039; 0.375 -> 17.1448 > 16.5039. |
| C3.4 | At z1 the full step to 7.875 increases \|P\|^2; two halvings help (3.8125, 1.78125); rotate and halve: z2 = 0.359375 + 0.8125i | Confirmed | Trials 4358.1, 343.55, 51.45; hand check: dz = -8.125, /4 = -2.03125, x 0.5(0.6+0.8i) = -0.609375 - 0.8125i, z2 = 0.359375 + 0.8125i; script identical. |
| C3.5 | Orange = halved steps 1, 3 and rotated step 2 | Confirmed | Kinds halved, rotated, halved; frames ac/002-004. |
| C3.6 | Step 4 plain Newton in Stage 1; steps 5-8 Stage 2 (blue), quadratic to +2i | Confirmed | Trace; errors 0.050, 6.2e-4, 9.6e-8, 1.9e-15; e_{k+1}/e_k^2 ~ 0.25 = 1/\|2z*\|... (Newton on z^2+4: e_{k+1} = e_k^2/(2z_k)). |
| C3.7 | Run stops at z8, \|P\| ~ 3.2e-30 below Adams' bound | Confirmed | \|P\|^2 = 9.957e-60 -> \|P\| = 3.16e-30; eps (squared bound) = 3.87e-29. z7 had \|P\|^2 = 7.9e-29 > eps, so it did not stop earlier. |
| C3.8 | No lengthened step; path is a polyline | Confirmed | Trace; plotting code. |
| C3.9 | Alt text: halved, rotated after two helpful halvings, further halved, plain Newton to +2i | Confirmed | As above. |

### 3. Implementation checks

All three scripts share the identical routine `newton_real_iterates` (diff confirms only header, coefficients, start, plotting differ), so the method check applies to all three.

**It is the method it claims to be.** The routine is a faithful port of the first-root iteration of Vestermark's `newton_real` (Madsen's modified Newton), differing in one disclosed line (`fz0 = fz1`). The bookkeeping fields (`kind`, `k`, `nhalf`) are recorded alongside without altering control flow. The page names exactly this variant. The disclosed correction does not change any of the three trajectories (D20).

**The numbers are right.** Independent Python implementation `mr.py` vs script traces:

| Case / step | Script z | Independent z |
|---|---|---|
| 1 / 1-6 | 1.583333333333333, 1.9772145417306708, 1.885782136079089, 1.8794153957913198, 1.879385242246684, 1.8793852415718169 | 1.583333333333333, 1.977214541730671, 1.8857821360790887, 1.87941539579132, 1.879385242246684, 1.8793852415718169 |
| 2 / 1-5 | 0.3999999999999999, 1.0857142857142854, 1.0011741682974553, 1.0000002296437014, 0.9999999995193409 | 0.3999999999999999, 1.0857142857142859, 1.0011741682974553, 1.0000002296437018, 0.9999999998416449 (rounding-dominated at a double root) |
| 3 / 1-8 | -0.25, 0.359375+0.8125i, -0.18577342058459634+1.638759472626044i, 0.043709164712013915+2.0243302797252594i, 0.000532121+1.99968582i, -8.359e-8+1.99999995i, 1.93e-15+1.999999999999999i, -7.9e-31+2i | identical to all printed digits except z8 real part -1.18e-30 (rounding) |

Stages, step kinds, k, halving counts and stopping steps agree in every case. Properties checked: quadratic convergence at the simple roots with the theoretical constant (Case 1: 0.742; Case 3: ~0.25), quadratic convergence of the k = 2 steps at the double root (Case 2), final residuals at or below Adams' bound.

**Reference values.** Case 1 root 1.8794 = 2cos(pi/9) (mpmath). Case 2 double root 1, Case 3 roots +-2i: exact by factorization. The stars in Case 3 are at exactly +-2i.

**The picture shows what was computed.** Frames inspected: aa/002, aa/003 (full size) and all frames via contact sheets; ab all frames, ab/006 full size; ac all frames, ac/009 full size. Tangent in aa/002 runs from (3, 17) to (2.2917, 0), slope 24 = P'(3); thick green axis segment from 2.2917 to 1.5833; vertical to P(1.5833) = -1.78. Case 2 zoomed frames each show the current step's tangent to the midpoint and the second dx along the axis; tick precision adapts (8 decimals in the last frame). Case 3 polyline segments match the computed z's with correct colours. Labels show the right index, value (5 decimals / 11 significant digits / 3 decimals) and stage. No clamping or NaN masking; axis limits keep every iterate and the relevant root visible (Case 3 limits computed from the iterates, clamp not triggered). Frame counts: 7, 6, 9 (initial point plus one per step), as computed.

