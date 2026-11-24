# Runge-Kutta-Fehlberg Method — animation review (round 8)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was reproduced by independent computation (see ledger). No implementation, page-match or fidelity errors were found.

Observations that are not findings (recorded so the clean result can be trusted):

- Case 1, "their steps agree to within 0.05%": the script's actual run gives a maximum relative step difference of 0.041% (including the final truncated step). Near the pole $y\approx140$ and $|y_5-y_4|\approx 5\times10^{-11}$, so the error estimate carries only 3-4 significant digits (eps(140) ≈ 2.8e-14); the step sequence is therefore rounding-sensitive at the 1e-4 level. My Python reimplementation, differing only in floating-point evaluation order, gave 0.018% on controller-chosen steps but 0.22% on the final truncated step. The page's figure is correct for the script that produced the GIF; it would not be robust to a reimplementation. Not reported as a finding.
- Case 2, RKF54's final step is truncated to $h=6.4\times10^{-4}$ (to land on $t=5$), so RKF54 has 81 points vs RKF45's 80. The page says "the smallest step it chooses is 0.027", which is correct for controller-chosen steps; the truncated step is forced, not chosen.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 15.4 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 17.4 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "embedded 4th- and 5th-order approximations from the same stage evaluations" | confirmed | `tableau.py`: B-series order conditions on the script's coefficients. $b_4$: orders 1-4 all satisfied (1,1,2,4), order 5 0/9. $b_5$: orders 1-5 all satisfied (1,1,2,4,9), order 6 0/20. Row sums equal the $c_i$ used in the script. |
| D2 | $|y_5-y_4|$ estimates local error of $y_4$, shrinks like $h^5$; $/h$ shrinks like $h^4$ | confirmed | follows from D1 (y4 order 4 ⇒ local error $O(h^5)$) |
| D3 | accept when $|y_5-y_4|/h\le\varepsilon$ | confirmed | script line 37: `err <= tol*h` |
| D4 | $h_{new}=sh$, $s=0.84(\varepsilon h/|y_5-y_4|)^{1/4}$, clamped to at most $h_{max}=0.25$ | confirmed | script lines 44-45; matches Mathews' formula gr_5 ($0.840896(\epsilon h/|z-y|)^{1/4}$) |
| D5 | scripts impose $h_{min}=10^{-6}$, which neither case reaches | confirmed | smallest step: Case 1 2.82e-5 (final truncated), Case 2 6.4e-4 (RKF54 final truncated) |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | first animation reconstructs legacy Example 1: $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$ | confirmed | archive gr_27/28/29; script lines 8, 51-53 |
| I2 | exact solution $\tan(t+\arctan 0.5)$ | confirmed | mpmath: $y(0)=0.5$, ODE residual at $t=0.7$: -3.7e-40 |
| I3 | module accepts when $|y_5-y_4|<\varepsilon$ or $h<2h_{min}$, starts $h=0.25$ (here 0.1), $h_{min}=0.001$ | confirmed | archive gr_15 / gr_26 subroutine code; script `h0=0.1` |
| I4 | at $\varepsilon=10^{-6}$ module takes 120 points | confirmed | my reimplementation of the module subroutine: 120 points, 119 steps (both variants) |
| I5 | step reaches $h_{min}$ at $t\approx1.055$ | confirmed | 1.05524 |
| I6 | last 8 of 119 steps, from $t\approx1.092$, accepted only by $h<2h_{min}$ | confirmed | 8 steps (indices 111-118), first at t=1.09224 |
| I7 | module errors $7.0\times10^{-2}$ (RKF45), $6.5\times10^{-2}$ (RKF54) at $t=1.1$ | confirmed | mine: 0.0704102, 0.0645005; identical to archive gr_78 / gr_93 last entries |
| I8 | vs $4.5\times10^{-3}$ and $3.2\times10^{-3}$ here | confirmed | script run: 4.5168e-3, 3.1542e-3 |
| I9 | first step 0.25: error estimate $1.7\times10^{-7}$ passes either acceptance test | confirmed | 1.673e-7 < 1e-6 (module) and < $\varepsilon h$=2.5e-7 (page) |
| I10 | true error of that step $5.6$–$5.7\times10^{-6}$ | confirmed | 5.737e-6 (y4), 5.570e-6 (y5); archive gr_78/gr_93 second entries agree |
| I11 | magnified about $1.1\times10^4$ by $t=1.1$ | confirmed | linearised factor $(1+y(1.1)^2)/(1+y(0.25)^2)$ = 11183 |
| I12 | started from $h=0.25$, the page's controller ends with $6.6\times10^{-2}$ and $6.3\times10^{-2}$ | confirmed | 6.642e-2, 6.285e-2 |
| I13 | archive has no legacy RKF animated GIFs | confirmed | `a2001/Animations/OrdinaryDE/` has Adams1, Euler1, Heun1, MEuler1, Milne1, RungeKutta1, Taylor*; no RKF; grep for "fehlberg" in a2001 empty |
| I14 | Examples 6-8: Riccati $y'=t^2+y^2$, RKF45/RKF54 (Ex 6), Bessel closed form (Ex 7), DSolve (Ex 8), not animated | confirmed | archive gr_103/gr_144 ($y'=t^2+y^2$), gr_123 (BesselJ solution), lnk_7-9 text |
| I15 | second IVP is the one used on Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages | confirmed | grep of those pages' index.qmd and scripts: all use $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$ (eulersmethodaa/bb, rungekuttaaa, taylorderivativeaa/bb, adamsbashforthmoultonaa) |
| I16 | dashed reference from fixed-step RK4 at $h=10^{-4}$ | confirmed | script lines 76, 100; max deviation from scipy DOP853 (rtol 1e-13) = 9.7e-13 |
| I17 | this IVP is not one of the module's examples | confirmed | archive examples are $1+y^2$ and $t^2+y^2$ only |

### Case 1
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | heading: RKF45 vs RKF54, $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$ | confirmed | script lines 8, 51-57; GIF title |
| C1.2 | both traces within relative error $3.3\times10^{-5}$ all the way | confirmed | script run: max rel 3.229e-5 (RKF45), 2.255e-5 (RKF54) |
| C1.3 | $y(1.1)=139.88$ | confirmed | 139.88284 |
| C1.4 | pole of tan at $t=1.1071$ | confirmed | $\pi/2-\arctan0.5$ = 1.1071487 |
| C1.5 | log $y$-axis keeps whole run in view | confirmed | frame_066: end marker at ~140 inside ylims (0.4, 200) |
| C1.6 | step shrinks from 0.136 near $t=0.1$ to $5\times10^{-5}$ near $t=1.1$ | confirmed | step from t=0.1 is 0.13600 (largest); last controller steps 5.18e-5 … 4.97e-5 (final truncated step 2.82e-5) |
| C1.7 | 187 of the 259 points lie in $t\ge1.05$ | confirmed | script run: 259 points, 187 with t ≥ 1.05 (both variants) |
| C1.8 | marker slows near the pole; each frame adds up to four accepted steps | confirmed | stride=4, 66 frames (1:4:257 plus 259); contact sheet shows marker t advancing 0→0.9→1.0→1.05→… then crawling |
| C1.9 | RKF45 and RKF54 share error estimate and step rule | confirmed | same `rkf_integrate`, only `mode` differs (line 39) |
| C1.10 | steps agree to within 0.05% | confirmed | script run: max relative step difference 0.041% (see observation in section 1) |
| C1.11 | curves coincide (blue over magenta) | confirmed | lines 92-93 (magenta lw 5 under royalblue lw 2); frames |
| C1.12 | differ only in whether $y_4$ or $y_5$ is carried forward | confirmed | line 39 |
| C1.13 | RKF54 ends closer: $3.2\times10^{-3}$ vs $4.5\times10^{-3}$ | confirmed | 3.154e-3 vs 4.517e-3 |
| C1.14 | link `rungekuttafehlbergaa.jl`, embed `rungekuttafehlbergaa.gif` are this case | confirmed | manifest: GIF byte-identical to regen of that script |
| C1.15 | alt text: RKF45/RKF54 vs exact, the IVP, log axis | confirmed | frames |

### Case 2
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | heading: $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$ | confirmed | script lines 8, 69-72 |
| C2.2 | both match the reference within $7\times10^{-7}$ at every accepted point | confirmed | script run with Hermite-interpolated reference: 6.577e-7 (RKF45, at t=2.010), 9.43e-8 (RKF54); Python vs DOP853: same |
| C2.3 | max step 0.25 over the hump ($0.1\le t\le1.35$) | confirmed | steps of 0.25 start at 0.1, 0.35, 0.6, 0.85, 1.1 → end 1.35 |
| C2.4 | $h$ between 0.189 and 0.25 until $t\approx2.4$ | confirmed | steps 0.2435, 0.2176, 0.1989, 0.1891, 0.2001, ending at 2.3992 |
| C2.5 | steepest point $y'=-0.930$ at $t=2.19$ | confirmed | min of $f(t,y_{ref}(t))$ = -0.93027 at t = 2.1945 |
| C2.6 | below 0.04 from $t=3$ on | confirmed | first step < 0.04 starts at t=2.9959; max step starting at t ≥ 3 is 0.03988 |
| C2.7 | smallest chosen step 0.027 near $t=3.27$ | confirmed | 0.027356 starting at t=3.2716 (both variants; RKF54's forced final step 6.4e-4 excluded as not chosen) |
| C2.8 | corners up to 0.0091 below the curve near $t=0.48$ | confirmed | max(reference − RKF45 polyline) = 0.009112 at t = 0.475 |
| C2.9 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$ | confirmed | -41.255 |
| C2.10 | fixed steps longer than about $h=0.0732$ exceed 3.02 before $t=5$ | confirmed | 3.0200/41.255 = 0.07320; $|f_y|$ along the reference is largest at t=5 (at h=0.0732 the product stays just below 3.02 on [0,5]) |
| C2.11 | 4th-order RKF update's stability limit 3.02 | confirmed | stability polynomial from tableau: $R(z)=1+z+z^2/2+z^3/6+z^4/24+z^5/104$; real interval left end −3.0200 (5th-order update: −3.678) |
| C2.12 | every accepted step keeps $h|\partial f/\partial y|$ below 1.3 | confirmed | max 1.2697 (RKF45), 1.2737 (RKF54), checked at endpoints and along the reference inside each step |
| C2.13 | steps set by tolerance, not stability | confirmed | follows from C2.12 vs C2.11 |
| C2.14 | link `rungekuttafehlbergbb.jl`, embed `rungekuttafehlbergbb.gif` are this case | confirmed | manifest: byte-identical regen |
| C2.15 | alt text: RKF45/RKF54 vs high-accuracy RK4 reference, the IVP | confirmed | frames, legend "Reference (RK4 h=1e-4)" |

### 3. Implementation checks

### `rungekuttafehlbergaa.jl`
- **Method:** Fehlberg 4(5) tableau with 6 stages; `:rkf45` carries $y_4$, `:rkf54` carries $y_5$ (Mathews' RKF54 convention, archive gr_26). Coefficients verified by order conditions (`tableau.py`), not by recall. The controller is the per-unit-step variant ($\text{err}\le\varepsilon h$), described as such on the page; it differs from Mathews' (absolute $\text{err}<\varepsilon$, $s=(\varepsilon h/2\,\text{err})^{1/4}$ clamped to [0.1, 4], $h_0=0.25$, $h_{min}=0.001$), and the page says so.
- **Numbers:** instrumented copy `inst_aa.jl` vs independent Python (`sim.py`/`case1.py`):

  | quantity | script | independent |
  |---|---|---|
  | points (45/54) | 259 / 259 | 259 / 259 (4 rejections each) |
  | y(1.1) RKF45 | 139.887359 | 139.887359 |
  | err RKF45 / RKF54 | 4.5168e-3 / 3.1542e-3 | 4.5168e-3 / 3.1542e-3 |
  | max rel err 45 / 54 | 3.229e-5 / 2.255e-5 | 3.229e-5 / 2.255e-5 |
  | second step | 0.136002 | 0.136002 |
  | points t ≥ 1.05 | 187 | 187 |
  | frames | 66 | 66 |

- **Reference:** $\tan(t+\arctan0.5)$ satisfies the ODE and IC (mpmath, 40 digits).
- **Picture:** first, middle and last frames checked; legend, colours, markers at the current accepted point; log axis with ylims (0.4, 200) contains y(1.1)=139.9; title matches the code's $f$, $y_0$, tol.

### `rungekuttafehlbergbb.jl`
- **Method:** same `rkf_integrate` as above (identical code). Reference `rk4_reference` is classical RK4 at $h=10^{-4}$.
- **Numbers:** `inst_bb.jl` vs Python:

  | quantity | script | independent |
  |---|---|---|
  | points 45 / 54 | 80 / 81 | 80 / 81 (3 rejections each) |
  | max err vs reference 45 / 54 | 6.577e-7 / 9.43e-8 | 6.577e-7 / 9.435e-8 (vs DOP853) |
  | smallest chosen step | 0.0273558 at t=3.27161 | 0.0273558 at t=3.27161 |
  | y(5) RKF45 | 0.00811989 | 0.00811992 (reference) |
  | frames | 81 | 81 |

  (A first instrumented pass using nearest-grid lookup into the reference reported 3.8e-5; that was my lookup's t-offset error, corrected with Hermite interpolation.)
- **Reference:** RK4 $h=10^{-4}$ vs scipy DOP853 (rtol 1e-13, atol 1e-15): max deviation 9.7e-13; adequate for a 7e-7 comparison.
- **Picture:** frames 1, sheet samples and 81 checked; polyline through accepted points, reference dashed; axis limits contain the whole run (y from 0.0081 to 1.4498); title matches the code.

