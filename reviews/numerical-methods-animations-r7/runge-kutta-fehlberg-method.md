# Runge-Kutta-Fehlberg Method — animation review (round 7)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the module's acceptance test is stated without its second branch

- **Location:** `index.qmd` lines 31–33: "its RKF45 and RKF54 subroutines accept a step when $|y_5 - y_4| < \varepsilon$, start from $h=0.25$ (here $0.1$) and have a minimum step size $h_{min}=0.001$".
- **What is there now:** a single acceptance condition.
- **What is true:** both subroutines test `If[Or[err < ε, h < 2 hmin], ...]` (archive images `gr_15`, `gr_26`). In the Example 1 run, 8 of the 119 steps fail $|y_5-y_4|<\varepsilon$ and are accepted only by the second branch. All 8 lie in $t \ge 1.0922$, with estimates up to $2.69\times10^{-5}$, which is 27 times $\varepsilon$. So the sentence as written is false for those steps.
- **How I know:** `/usr/bin/python3 review/c5.py review` on a transcription of the subroutine, which reproduces the archive's printed output (see section 3):
  `keep 4 steps 119 accepted with err>=eps (only via h<2hmin): 8 first at t=1.0922 h=0.00100 err=1.17e-06 largest err 2.69e-05 at t=1.0982`. RKF54 gives the same counts.
- **Consequence:** small. No number on the page changes, and the page's explanation (the first step of 0.25 causes most of the error) still holds.
- **Suggested correction:** "accept a step when $|y_5 - y_4| < \varepsilon$ or $h < 2h_{min}$, start from $h=0.25$ (here $0.1$) and have a minimum step size $h_{min}=0.001$, which the run reaches at $t \approx 1.055$; 8 of its 119 steps, all after $t \approx 1.092$, are accepted only by the $h < 2h_{min}$ condition."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 9.8 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 15.4 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Script values are from the instrumented scratch copies; "independent" values are from my own code. Every entry was checked.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Adaptive one-step solver for IVPs | Code lines 19–46 of both scripts | confirmed |
| D2 | "embedded 4th- and 5th-order approximations from the same stage evaluations" | Same six stages. Exact rational check: $b_5$ meets all 17 conditions to order 5; $b_4$ meets the 8 to order 4 and fails all 9 of order 5. Fixed-step error ratios on the exact problem: $y_4$ 16.2–16.3, $y_5$ 27.0→30.1 | confirmed |
| D3 | $\lvert y_5-y_4\rvert$ estimates the local error of $y_4$, shrinks like $h^5$ | Halving ratio of the estimate 24.98, 29.14, 30.98, 31.75 (→ 32) | confirmed |
| D4 | $\lvert y_5-y_4\rvert/h$ is an error per unit step that shrinks like $h^4$ | Follows from D3 | confirmed |
| D5 | Accepted when $\lvert y_5-y_4\rvert/h \le \varepsilon$ | Line 37 (the extra `h <= hmin` branch never fires, see D8) | confirmed |
| D6 | $h_{new}=sh$, $s=0.84(\varepsilon h/\lvert y_5-y_4\rvert)^{1/4}$ | Lines 44–45 | confirmed |
| D7 | Clamped to at most $h_{max}=0.25$ | Line 45 | confirmed |
| D8 | Minimum $h_{min}=10^{-6}$, "which neither case below reaches" | Smallest attempted $h$: $2.82\times10^{-5}$ (Case 1), $6.4\times10^{-4}$ (Case 2) | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Legacy Example 1: $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$ | Archive `gr_27`–`gr_29`; script lines 8, 52–53 | confirmed |
| A2 | Dashed black curve is the exact solution $\tan(t+\arctan 0.5)$ | $\frac{d}{dt}\tan u = 1+\tan^2 u$, and $\tan(\arctan 0.5)=0.5$; script line 9, drawn dashed black at line 90 | confirmed |
| A3 | Module accepts when $\lvert y_5-y_4\rvert<\varepsilon$ | True but incomplete: the test is `err < ε` **or** `h < 2 hmin` | **wrong (F1)** |
| A4 | Module starts from $h=0.25$ (here $0.1$) | `gr_15`, `gr_26`; script `h0=0.1` | confirmed |
| A5 | Module $h_{min}=0.001$, reached at $t\approx1.055$ | `gr_15`; first step of exactly 0.001 starts at $t=1.05524$ | confirmed |
| A6 | At $\varepsilon=10^{-6}$ the module takes 120 points | Transcription gives 120; counting the archive's printed $X$ list (`gr_71`, `gr_86`) gives 120 | confirmed |
| A7 | Module errors $7.0\times10^{-2}$ (RKF45), $6.5\times10^{-2}$ (RKF54) at $t=1.1$ | Transcription $7.041021\times10^{-2}$, $6.450047\times10^{-2}$; archive prints 0.0704102, 0.0645005 | confirmed |
| A8 | Against $4.5\times10^{-3}$ and $3.2\times10^{-3}$ here | Script $4.51679\times10^{-3}$, $3.15422\times10^{-3}$ | confirmed |
| A9 | "Most of that difference is the first step of 0.25" | Page's controller from $h_0=0.25$: $6.64\times10^{-2}$, $6.29\times10^{-2}$. Module's controller from $h_0=0.1$: $9.4\times10^{-3}$, $5.3\times10^{-3}$. Both counterfactuals agree | confirmed |
| A10 | First-step estimate $1.7\times10^{-7}$ "passes either acceptance test" | $1.673\times10^{-7} < 10^{-6}$ and $< 0.25\times10^{-6}$ | confirmed |
| A11 | Its true error is $5.6$–$5.7\times10^{-6}$ | $y_5$: $5.570\times10^{-6}$; $y_4$: $5.737\times10^{-6}$ | confirmed |
| A12 | Magnified about $1.1\times10^4$ times by $t=1.1$ | $(1+y(1.1)^2)/(1+y(0.25)^2)=1.118\times10^4$ | confirmed |
| A13 | From $h=0.25$ the page's controller ends with $6.6\times10^{-2}$, $6.3\times10^{-2}$ | $6.642\times10^{-2}$, $6.285\times10^{-2}$ | confirmed |
| A14 | Examples 6–8: Riccati $y'=t^2+y^2$; RKF45/54 (Ex 6), Bessel comparison (Ex 7), DSolve (Ex 8) | `gr_103`–`gr_105`, `gr_120`–`gr_123`, `gr_144`–`gr_146`. The Bessel form gives $y(0)=0.5$ and ODE residual below $10^{-59}$ at $t=0.7, 1.2$ | confirmed |
| A15 | Second IVP is the one on the Euler (forward and modified), Runge-Kutta, Taylor and ABM pages | `f`, $y_0=1$ and $T=5$ read from `eulersmethodaa.jl`, `eulersmethodbb.jl`, `rungekuttaaa.jl`, `taylorderivativeaa.jl`, `adamsbashforthmoultonaa.jl`; Euler's Case 2 heading says "same IVP" | confirmed |
| A16 | $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$, dashed RK4 reference at $h=10^{-4}$ | Script lines 8, 70–71, 76, 100 | confirmed |
| A17 | This IVP is not one of the module's examples | The module's examples use only $1+y^2$ and $t^2+y^2$ | confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading parameters | Lines 8, 52–54 | confirmed |
| C1.2 | Relative error within $3.3\times10^{-5}$ throughout | Max $3.229\times10^{-5}$ (RKF45), $2.255\times10^{-5}$ (RKF54), both at $t=1.1$. The page's figure is a valid upper bound | confirmed |
| C1.3 | $y(1.1)=139.88$ | 139.88284 | confirmed |
| C1.4 | Pole at $t=1.1071$ | $\pi/2-\arctan 0.5=1.10715$ | confirmed |
| C1.5 | Log $y$-axis keeps the whole run in view | Limits (0.4, 200); $y$ spans 0.5–139.89; end marker visible in frame 66 | confirmed |
| C1.6 | Step shrinks from 0.136 near $t=0.1$ to $5\times10^{-5}$ near $t=1.1$ | Step at $t=0.1$ is 0.1360; smallest chosen step $4.97\times10^{-5}$ (the truncated last step is $2.82\times10^{-5}$) | confirmed |
| C1.7 | 187 of 259 points in $t\ge1.05$ | 187 of 259 for both | confirmed |
| C1.8 | Marker slows near the pole | $\Delta t$ per frame falls 0.396 → $8\times10^{-5}$; $\Delta\log_{10}y$ per frame 0.366 → 0.005 | confirmed |
| C1.9 | Each frame adds up to four accepted steps | `stride = 4`; 66 frames; the last adds two | confirmed |
| C1.10 | Share estimate and step rule; steps agree within 0.05% | Same code. Script max difference 0.041% | confirmed |
| C1.11 | Curves coincide, blue over magenta | Plot order lines 92–93; frames 1, 66 and contact sheet | confirmed |
| C1.12 | Differ only in carrying $y_4$ or $y_5$ | Line 39 | confirmed |
| C1.13 | RKF54 ends closer: $3.2\times10^{-3}$ vs $4.5\times10^{-3}$ | See A8 | confirmed |
| C1.14 | Source link and embed | `rungekuttafehlbergaa.jl` / `.gif`; parameters match | confirmed |
| C1.15 | Alt text | Matches title, axis and curves | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading parameters | Lines 8, 70–72 | confirmed |
| C2.2 | Both match the reference within $7\times10^{-7}$ at every accepted point | Max $6.58\times10^{-7}$ (RKF45), $9.4\times10^{-8}$ (RKF54) | confirmed |
| C2.3 | Maximum step 0.25 over the hump, $0.1\le t\le1.35$ | Exactly five contiguous steps of 0.25 from 0.1 to 1.35 | confirmed |
| C2.4 | $h$ between 0.189 and 0.25 until $t\approx2.4$ | Steps 0.2435, 0.2176, 0.1989, 0.1891, 0.2001, ending at $t=2.3992$ | confirmed |
| C2.5 | Steepest point $y'=-0.930$ at $t=2.19$ | $y''=0$ at $t=2.1945$, $y'=-0.93027$ | confirmed |
| C2.6 | Below 0.04 from $t=3$ on | Last $h\ge0.04$ starts at 2.9557 and ends before 3; max afterwards 0.0399 at $t=3.80$ | confirmed |
| C2.7 | Smallest chosen step 0.027 near $t=3.27$ | 0.02736 at $t=3.2716$ (RKF54's forced final step of 0.00064 is not a chosen step) | confirmed |
| C2.8 | Corners are straight segments between points 0.25 apart | Plot joins accepted points; segments in the hump span 0.25 | confirmed |
| C2.9 | Up to 0.0091 below the curve near $t=0.48$ | Max over all segments 0.00911 at $t=0.4752$ on $[0.35,0.60]$ | confirmed |
| C2.10 | "not integration error" | Point errors at most $6.6\times10^{-7}$, four orders smaller | confirmed |
| C2.11 | Steps set by the tolerance, not stability | Tail mean $h$ scales about 1.7 per decade of tol for $10^{-8}$ to $10^{-5}$ (0.0117, 0.0203, 0.0348, 0.0590), close to $10^{1/4}=1.78$, with $h\lvert J\rvert$ well below the limit at $10^{-6}$ | confirmed |
| C2.12 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$ | $-41.2554$; $\lvert J\rvert$ is monotone on the run | confirmed |
| C2.13 | Stability limit 3.02 of the 4th-order update | From the tableau, $R(z)$ has $z^5$ coefficient 1/104; real-axis limit 3.02002 | confirmed |
| C2.14 | Fixed steps above about 0.0732 would exceed it before $t=5$ | $3.02002/41.2554=0.07320$ | confirmed |
| C2.15 | Every accepted step keeps $h\lvert J\rvert$ below 1.3 | Max 1.2697 (RKF45), 1.2737 (RKF54), at step ends | confirmed |
| C2.16 | Source link and embed | `rungekuttafehlbergbb.jl` / `.gif`; parameters match | confirmed |
| C2.17 | Alt text | Matches title and curves | confirmed |

---

### 3. Implementation checks

Both scripts share an identical `rkf_integrate` (`diff` of the two function bodies is empty).

### `rungekuttafehlbergaa.jl`

- **It is the method claimed.** Fehlberg's 4(5) pair. RKF45 carries $y_4$; RKF54 carries $y_5$ (local extrapolation), matching the module's two subroutines. The step rule is the tolerance-per-unit-step variant, which the page states and distinguishes from the module's.
- **The numbers are right.**
  - The script's own stage lines, run in 200-bit BigFloat on a generic non-autonomous $f$, match the exact rational tableau to about $10^{-46}$ (`stagecheck.jl`, `c4.py`). That tableau passes all order conditions exactly.
  - Independent double-precision run against the script: same 259 points and 4 rejections.
  - The grids differ by up to $4.7\times10^{-8}$ in $t$, because near the pole the estimate ($\approx5\times10^{-11}$) is computed with rounding noise. A 50-digit run of the same controller gives the same 259 points and the same final errors to six digits (0.00451679, 0.00315422), so the page's figures are not artefacts of rounding.

| Quantity | Script | Independent |
|---|---|---|
| Points | 259 / 259 | 259 / 259 (double and 50-digit) |
| Final error RKF45 | $4.51679\times10^{-3}$ | $4.51679\times10^{-3}$ (50-digit) |
| Final error RKF54 | $3.15422\times10^{-3}$ | $3.15422\times10^{-3}$ (50-digit) |
| Max relative error | $3.22898\times10^{-5}$ | $3.22898\times10^{-5}$ |

- **Reference is right.** Closed form satisfies the ODE and initial condition (A2).
- **The picture shows what was computed.** Frames 1, 66 and the contact sheet show the exact curve, both traces and markers at the computed points. Title function and tolerance match the code. Axis limits clip nothing; no clamping or masking. 66 frames as the code implies. The committed GIF is byte-identical to the regenerated one (manifest).

### `rungekuttafehlbergbb.jl`

- **It is the method claimed.** Same integrator.
- **The numbers are right.** Independent run against the script: 80 and 81 points, 3 rejections each, maximum differences $1.6\times10^{-10}$ in $y$ and $1.8\times10^{-10}$ in $t$.
- **Reference is right.** RK4 at $h=10^{-4}$ against DOP853 (rtol $10^{-13}$): max difference $1.19\times10^{-12}$ over 502 samples. DOP853 against Radau: $2.1\times10^{-12}$. This is about five orders below the $6.6\times10^{-7}$ it is used to judge. $y(5)=0.00811992$, and $y$ stays positive, so the cube root is never at its singular point.
- **The picture shows what was computed.** Frames 1, 6, 81 and the contact sheet: frame 6 places the marker at $t=1.1$ as the step list requires; the chord corners on the hump are visible as the page describes; the final marker is at $(5, 0.0081)$. Limits clip nothing. 81 frames, the longer of the two runs. The committed GIF is byte-identical to the regenerated one (manifest).

### Legacy controller transcription (support for A3–A13)

My transcription of `gr_15` and `gr_26` reproduces the archive's printed output:

| Quantity | Transcription | Archive (`gr_71`–`gr_102`) |
|---|---|---|
| $T$, first six | 0, 0.25, 0.327661, 0.434978, 0.50781, 0.561351 | same |
| $Y$ (RKF45), last three | 112.329, 126.545, 139.953 | same |
| $Y$ (RKF54), last three | 112.329, 126.545, 139.947 | same |
| Max error RKF45 | 0.07041021 | 0.0704102 |
| Max error RKF54 | 0.06450047 | 0.0645005 |
| Points | 120 | 120 (counted) |

### Fidelity to the archive

- Case 1 uses Example 1's problem. The page discloses and quantifies its different step controller.
- Examples 3–5 (the exact solution and the RKF45/RKF54 errors) are carried by the exact overlay and the quoted errors. Examples 6–8 are disclosed as not animated.
- Example 2 (the same IVP with Mathematica's NDSolve) is not mentioned. It is a tool demonstration on the same curve and I do not count it as a finding.
- No legacy animated GIF for this topic exists in the archive, as the page says.

### Could not determine

Nothing on the page. Example 1's own call and plots (`gr_30`–`gr_43`) are missing from the archive, so $\varepsilon=10^{-6}$ for that example is established indirectly, by the exact reproduction of its printed output above.

