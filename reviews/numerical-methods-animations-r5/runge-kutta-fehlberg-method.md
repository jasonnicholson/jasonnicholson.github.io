# Runge-Kutta-Fehlberg Method — animation review (round 5)

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Page match, Minor. The Description's step-size rule leaves out the $h_{max}=0.25$ cap, which is binding in Case 2

- **Location:** `index.qmd` lines 19–21: "...and the next step size is $h_{new} = s h$ with $s = 0.84\,(\varepsilon h/|y_5 - y_4|)^{1/4}$." The code is `rungekuttafehlbergaa.jl:45` and `rungekuttafehlbergbb.jl:63`: `h = clamp(s * h, hmin, hmax)` with `hmin=1e-6, hmax=0.25` (signature at lines 11 / 29).
- **What is there now:** The Description gives the update as $h_{new}=sh$ with no limits.
- **What is true:**
  - The scripts clamp $sh$ to $[10^{-6}, 0.25]$. They also set $s=2$ when the error estimate is exactly 0, and they force-accept any step with $h\le h_{min}$.
  - In Case 2 the upper clamp sets five consecutive steps. The unclamped $sh$ would have been 0.3228, 0.3789, 0.3526, 0.3119 and 0.2750 (from `py/cap.py`). That is why the steps on $0.1\le t\le1.35$ are exactly 0.25.
  - The Case 2 Behavior paragraph does say "The controller takes the maximum step $h=0.25$". But the Description never introduces a maximum, so a reader applying the stated rule would expect steps of about 0.32–0.38 there.
  - The $h_{min}$ clamp and the forced acceptance never trigger in either case: the smallest step is $2.8\times10^{-5}$ in Case 1 and 0.027 in Case 2, and the forced-accept count is 0 (`py/case1.py`). So only $h_{max}$ matters.
- **How I know:** `py/cap.py` prints, for each attempted step, the unclamped `s*h` next to the `h` actually used.
- **Suggested correction:** Add to the Description's last sentence: "...clamped to at most $h_{max}=0.25$ (the scripts also impose $h_{min}=10^{-6}$, which is never reached here)."

No other findings. Every numerical, behavioural, wiring and archive claim on the page checked out (ledger below).

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**1 finding: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttafehlbergaa.jl` | 0 | 10.1 | rungekuttafehlbergaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `rungekuttafehlbergbb.jl` | 0 | 13.4 | rungekuttafehlbergbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Abbreviations: P45/P54 = the page's controller in RKF45/RKF54 mode. M45/M54 = Mathews' module subroutines. Values come from my own runs unless a row says otherwise.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "adaptive-step one-step solver ... embedded 4th- and 5th-order approximations from the same stage evaluations" | Tableau row sums $c_i=\sum_j a_{ij}$ hold (exact fractions). Against a 60-digit mpmath reference, the local error ratio on halving $h$ tends to 32 ($h^5$) for $b_4$ and 64 ($h^6$) for $b_5$ on three problems. For example, $y'=y\cos t+t^2$ gives ratios 31.22, 31.68, 31.86, 31.93 for $b_4$ and 71.4, 69.2, 67.0, 65.6 for $b_5$. So the method orders are 4 and 5. The Python step with this tableau reproduces the Julia trajectories (Case 2 max $|dy|=1.6\times10^{-10}$). | confirmed |
| D2 | "$|y_5-y_4|$ estimates the local error of $y_4$. It shrinks like $h^5$" | Same test. $y_5$ is one order more accurate, so $y_5-y_4\approx$ the error of $y_4$, which is $O(h^5)$. | confirmed |
| D3 | "$|y_5-y_4|/h$ ... shrinks like $h^4$" | Follows from D2. | confirmed |
| D4 | "A step is accepted when $|y_5-y_4|/h\le\varepsilon$" | Code: `err <= tol * h`. The extra `|| h <= hmin` never fires (0 forced accepts). | confirmed |
| D5 | "$h_{new}=sh$, $s=0.84(\varepsilon h/|y_5-y_4|)^{1/4}$" | The formula matches the code, but the code also clamps $h$ to $[10^{-6},0.25]$, and the cap binds in Case 2. | confirmed formula, incomplete (F1) |

### Animations intro

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | "reconstructs the legacy Example 1 setup ...: $y'=1+y^2$, $y(0)=0.5$, on $[0,1.1]$" | Archive `gr_27/28/29`: `y' = 1 + y^2`, `y(0.0) = 0.5`, `[0.0, 1.1]`. Script lines 8, 51–53. | confirmed |
| A2 | Exact solution $y=\tan(t+\arctan 0.5)$ | sympy: $y'-(1+y^2)=0$ and $y(0)=1/2$. | confirmed |
| A3 | "The step controller is not the module's: its RKF45 and RKF54 subroutines accept a step when $|y_5-y_4|<\varepsilon$" | `gr_15`/`gr_26`: `If[Or[err < ε, h < 2 hmin], ...]`, where `err = Abs[r1 k1+...]`. The `r` coefficients equal $b_5-b_4$ exactly (`py/order.py`). | confirmed |
| A4 | "start from $h=0.25$ (here $0.1$)" | `gr_15`: `h = 0.2500`. Scripts: `h0=0.1`. | confirmed |
| A5 | "minimum step size $h_{min}=0.001$, which the run reaches at $t\approx1.055$" | `gr_15`: `hmin = 0.001`. My transcription of the module first steps at $h=h_{min}$ from $t=1.05524$ (step 75), in both M45 and M54. | confirmed |
| A6 | "at the same $\varepsilon=10^{-6}$ they take 120 points and end with errors of $7.0\times10^{-2}$ (RKF45) and $6.5\times10^{-2}$ (RKF54) at $t=1.1$" | Transcription: 120 points each, end errors $7.0410\times10^{-2}$ and $6.4500\times10^{-2}$. These match the archive's own tables to every printed digit: `gr_78` ends `-0.0704102` and `gr_93` ends `-0.0645005`; the first entries `5.73703e-6` and `5.56972e-6` and the second `6.66288e-6` and `6.45871e-6` also match. | confirmed |
| A7 | "against $4.5\times10^{-3}$ and $3.2\times10^{-3}$ here (Case 1)" | P45 $4.5168\times10^{-3}$, P54 $3.1542\times10^{-3}$ (Julia output against the mpmath exact value). | confirmed |
| A8 | "the first step of 0.25: its error estimate, $1.7\times10^{-7}$, passes either acceptance test" | $|y_5-y_4|=1.6731\times10^{-7}$. That is $<10^{-6}$ and $\le\varepsilon h=2.5\times10^{-7}$. | confirmed |
| A9 | "its true error is $5.6$–$5.7\times10^{-6}$" | $y_4$: $5.7370\times10^{-6}$. $y_5$: $5.5697\times10^{-6}$. | confirmed |
| A10 | "which this problem magnifies about $1.1\times10^4$ times by $t=1.1$" | Variational factor $(1+y(1.1)^2)/(1+y(0.25)^2)=11183$. | confirmed |
| A11 | "started from $h=0.25$, the controller used here ends with errors of $6.6\times10^{-2}$ and $6.3\times10^{-2}$" | P45 $6.6418\times10^{-2}$, P54 $6.2847\times10^{-2}$ with `h0=0.25`. This supports "most of that difference". | confirmed |
| A12 | "the recovered archive did not include legacy RKF animated GIF portals for this topic" | `a2001/Animations/OrdinaryDE/` has Adams, Euler, Heun, MEuler, Milne, RungeKutta and Taylor, with no RKF. A `grep -ri fehlberg` there finds nothing. | confirmed |
| A13 | "Examples 6–8 ... Riccati equation $y'=t^2+y^2$ ... RKF45 and RKF54 (Ex. 6), ... closed-form Bessel-function solution (Ex. 7) ... DSolve (Ex. 8), are not animated here" | Archive `lnk_7`/`gr_103`: `y' = t^2 + y^2`, solved with `RKF45[...]`. `lnk_8`/`gr_123`: BesselJ closed form. `lnk_9`: DSolve. The page has no Riccati case. | confirmed |
| A14 | Second animation uses the same IVP as the Euler (forward and modified), Runge-Kutta, Taylor Series and ABM pages | Each of those pages' `index.qmd` uses $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $[0,5]$: Euler Cases 1 and 2, RK Case 1, Taylor Cases 1 and 2, ABM Case 1. | confirmed |
| A15 | "$y'=1-t\sqrt[3]{y}$, $y(0)=1$, on $[0,5]$, with a dashed ... reference ... from fixed-step RK4 at $h=10^{-4}$" | `rungekuttafehlbergbb.jl` lines 8, 69–76 and 100 (black dashed). The RK4 reference differs from an mpmath `odefun` solution by at most $6\times10^{-15}$ at $t=0.5$–$5$, which is ample for the $7\times10^{-7}$ comparison. | confirmed |
| A16 | "This IVP is not one of the module's examples" | The module's examples are $1+y^2$ and $t^2+y^2$ only. | confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading: RKF45 vs RKF54, $y'=1+y^2$, $y(0)=0.5$, $t\in[0,1.1]$, tol shown $10^{-6}$ in title | Script lines 8, 51–57 and 83. Frame titles read "RKF45/RKF54: y' = 1 + y^2, y(0)=0.5, tol=1e-6". | confirmed |
| C1.2 | "Both adaptive traces follow the exact solution to within a relative error of $3.3\times10^{-5}$ all the way" | Max relative error over all accepted points: P45 $3.229\times10^{-5}$ and P54 $2.255\times10^{-5}$, both largest at $t=1.1$. The stated bound holds. | confirmed |
| C1.3 | "to $y(1.1)=139.88$" | mpmath $\tan(1.1+\arctan0.5)=139.8828$. The script ends at 139.8874 (P45) and 139.8860 (P54). | confirmed |
| C1.4 | "just short of the pole of $\tan$ at $t=1.1071$" | $\pi/2-\arctan0.5=1.107149$. | confirmed |
| C1.5 | "the logarithmic $y$-axis keeps the whole run in view" | `yscale=:log10` with ylims (0.4, 200). The data run from 0.5 to 139.9. Last frame (`frame_066.png`): the marker sits at about 140, inside the box. | confirmed |
| C1.6 | "The step shrinks from $0.136$ near $t=0.1$ to $5\times10^{-5}$ near $t=1.1$" | The step from $t=0.1$ is 0.13600 (the maximum step). The last full steps are $4.97$–$5.13\times10^{-5}$, followed by a final clipped step of $2.8\times10^{-5}$ that lands on 1.1. | confirmed |
| C1.7 | "187 of the 259 computed points lie in $t\ge1.05$" | Julia output: 259 points each, 187 with $t\ge1.05$ (the same in Python). | confirmed |
| C1.8 | "the marker slows as it nears the pole (each frame adds up to four accepted steps)" | `stride = 4`. Frames are points 1, 5, ..., 257, 259, which is 66 frames and matches the committed GIF. With a fixed point count per frame and shrinking $h$, the marker's $t$-advance per frame shrinks. | confirmed |
| C1.9 | "RKF45 and RKF54 share the error estimate and the step rule, so their steps agree to within $0.05\%$" | Code: same `err` and `s`. Max relative step difference is 0.041% (Julia output) and 0.033% (Python). | confirmed |
| C1.10 | "the curves coincide (blue over magenta)" | Code draws RKF45 magenta at lw=5, then RKF54 royalblue at lw=2. In the frames the blue line runs inside a magenta border, and the legend agrees. The curves differ by at most a relative $1.1\times10^{-5}$. | confirmed |
| C1.11 | "They differ only in whether $y_4$ or $y_5$ is carried forward" | Code: `y = mode == :rkf45 ? y4 : y5`. | confirmed |
| C1.12 | "RKF54 ends closer to the exact value: errors $3.2\times10^{-3}$ against $4.5\times10^{-3}$ at $t=1.1$" | $3.154\times10^{-3}$ and $4.517\times10^{-3}$. | confirmed |
| C1.13 | Alt text: "...versus exact solution for y' = 1 + y^2, y(0)=0.5 on [0,1.1], with y on a logarithmic axis" | Matches the frames. | confirmed |
| C1.14 | Wiring: `[Julia source](rungekuttafehlbergaa.jl)` and `![...](rungekuttafehlbergaa.gif)` | The script writes `rungekuttafehlbergaa.gif`, and the regenerated GIF is byte-identical (manifest). | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $t\in[0,5]$ | Script lines 8 and 69–72. Frame title "y' = 1 - t*cbrt(y), y(0)=1, tol=1e-6". | confirmed |
| C2.2 | "RKF45 and RKF54 match the dashed reference to within $7\times10^{-7}$ at every accepted point" | Max $|y-y_{ref}|$: P45 $6.58\times10^{-7}$ (at $t=2.01$) and P54 $9.4\times10^{-8}$, against both mpmath and the RK4 reference. | confirmed |
| C2.3 | "takes the maximum step $h=0.25$ over the hump ($0.1\le t\le1.35$)" | Steps of 0.25 start at 0.1, 0.35, 0.6, 0.85 and 1.1, ending at 1.35. The cap is binding there (F1). | confirmed |
| C2.4 | "keeps $h$ between $0.189$ and $0.25$ until $t\approx2.4$" | Steps after 1.35 are 0.2435, 0.2176, 0.1989, 0.1891 and 0.2001, ending at $t=2.399$; the next is 0.1029. | confirmed |
| C2.5 | "past the steepest point ($y'=-0.930$ at $t=2.19$)" | Along the reference, min $y'=-0.93027$ at $t=2.1945$. | confirmed |
| C2.6 | "below $0.04$ from $t=3$ on" | The largest step starting at $t\ge3$ is 0.03988. The step starting at 2.996 is 0.037. | confirmed |
| C2.7 | "the smallest step it chooses is $0.027$, near $t=3.27$" | Smallest is 0.027356, starting at $t=3.2716$, in both modes. RKF54 also has a final clipped landing step of $6.4\times10^{-4}$ at $t=4.99936$. That step is set by `h = tf - t`, not by the controller, so "chooses" holds. | confirmed |
| C2.8 | "The corners visible on the hump are the straight segments drawn between accepted points 0.25 apart (up to 0.0091 below the curve, near $t=0.48$), not integration error" | Largest gap between a chord and the reference: $+0.00911$ (reference above chord) at $t=0.475$. The integration error there is under $10^{-6}$. Corners are visible in `frame_081.png`. | confirmed |
| C2.9 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | The derivative is correct. Its value at $t=5$, $y=0.0081199$, is $-41.255$. $|\partial f/\partial y|$ increases monotonically along the solution. | confirmed |
| C2.10 | "for fixed steps longer than about $h=0.0732$, $h|\partial f/\partial y|$ would exceed the 4th-order RKF update's stability limit $3.02$ before $t=5$" | The $b_4$ stability polynomial is $1+z+z^2/2+z^3/6+z^4/24+z^5/104$ (sympy), with real-axis limit $-3.02002$. $3.02/41.2554=0.07320$. The statement is specific to the 4th-order update, which RKF45 carries. For the record, the $b_5$ update's limit is 3.678. | confirmed |
| C2.11 | "every accepted step keeps $h|\partial f/\partial y|$ below 1.3" | Max 1.246 / 1.270 (P45, evaluated at step start / end) and 1.250 / 1.274 (P54). | confirmed |
| C2.12 | Legend "Reference (RK4 h=1e-4)", dashed black, RKF45 magenta, RKF54 blue | Code lines 100–103 and the frames. | confirmed |
| C2.13 | Alt text: "...versus high-accuracy RK4 reference for y' = 1 - t cbrt(y), y(0)=1 on [0,5]" | Matches. | confirmed |
| C2.14 | Wiring: `rungekuttafehlbergbb.jl` / `.gif` | The script writes that GIF, and the regenerated GIF is byte-identical. There are 81 frames (= RKF54 point count; RKF45 has 80, so its marker holds on the last frame). | confirmed |

### Fidelity to the archive

- Example 1 is reproduced with the same equation and interval. The controller differences ($h_0$ and the per-unit-step test) are disclosed and quantified correctly (A3–A11).
- Examples 6–8 (the Riccati problem) are dropped, but the page says so and why (A13).
- Examples 2–5 are NDSolve/DSolve comparisons and error tables for Example 1. The page covers their substance: the exact solution, and the end errors of the module's RKF45 and RKF54.
- Case 2 is a non-archive IVP, used with a stated reason (A16).
- **No fidelity findings.**

---

### 3. Implementation checks

### `rungekuttafehlbergaa.jl` (Case 1)

- **The method is the one claimed.**
  - It runs six Fehlberg stages with the classical RKF45 coefficients: $c=(0,\tfrac14,\tfrac38,\tfrac{12}{13},1,\tfrac12)$, the $a_{ij}$ table, $b_4=(\tfrac{25}{216},0,\tfrac{1408}{2565},\tfrac{2197}{4104},-\tfrac15,0)$ and $b_5=(\tfrac{16}{135},0,\tfrac{6656}{12825},\tfrac{28561}{56430},-\tfrac{9}{50},\tfrac{2}{55})$.
  - I did not rely on memory to confirm these. Exact-fraction row sums hold. Local error orders measured against a 60-digit reference are 5 and 6. $b_5-b_4$ equals Mathews' `r` vector exactly.
  - "RKF45" carries $y_4$ and "RKF54" carries $y_5$ (local extrapolation), as the module's RKF54 does.
  - The controller is the per-unit-step variant (accept iff $|y_5-y_4|\le\varepsilon h$, with $s=0.84(\varepsilon h/|y_5-y_4|)^{1/4}$). This is a legitimate variant, the one in Burden–Faires Algorithm 5.3 but without that algorithm's [0.1, 4] limit on $s$. It differs from Mathews' module ($|y_5-y_4|<\varepsilon$, $s$ clamped to [0.1, 4], $h_0=0.25$), and the page says so.
- **The numbers are right.**
  - My independent Python step and controller (`py/rkf.py`) gives the same point count (259/259) and final values to $4\times10^{-6}$ relative.
  - The residual difference comes from rounding in $y_5-y_4$ near the pole, where $y\approx100$ and the error estimate is about $10^{-9}$. That rounding nudges individual step sizes by $\lesssim10^{-7}$ in $t$.
  - Script against my exact value at $t=1.1$:

    | | Script $y(1.1)$ | Error |
    |---|---|---|
    | P45 | 139.887359 | $+4.517\times10^{-3}$ |
    | P54 | 139.885997 | $+3.154\times10^{-3}$ |
    | Exact (mpmath) | 139.882842 | |

  - No forced ($h\le h_{min}$) acceptances occur.
- **The reference values are right.** $\tan(t+\arctan0.5)$ satisfies the ODE and the initial condition exactly (sympy). It is drawn on 800 points to $t=1.1$, before the pole at 1.10715.
- **The picture shows what was computed.**
  - Frames 1, mid-sheet and 66 show the polyline through the accepted points with a marker at the current point, over the exact curve.
  - The log axis with ylims (0.4, 200) contains all data. Nothing is clamped or masked.
  - The title and legend are correct.
  - There are 66 frames (points 1:4:259 plus 259).

### `rungekuttafehlbergbb.jl` (Case 2)

- **The method is the one claimed.** It uses the same `rkf_integrate` as Case 1 (identical text) and the same tableau checks.
- **The numbers are right.**
  - Python and Julia agree: 80/81 points, max $|dt|=1.8\times10^{-10}$, max $|dy|=1.6\times10^{-10}$.
  - Final values: P45 $y(5)=0.0081198889$, P54 $0.0081199107$, mpmath $0.0081199205$.
  - Accuracy against the reference: max errors $6.6\times10^{-7}$ (P45) and $9.4\times10^{-8}$ (P54).
- **The reference values are right.**
  - The fixed-step RK4 at $h=10^{-4}$ (50,000 steps) is a standard RK4. I re-implemented it in Python and compared it with mpmath `odefun` (Taylor series, 30 digits). The difference is at most $6\times10^{-15}$ at $t\in\{0.5,1,2,3,4,5\}$.
  - The solution stays positive (minimum 0.00812 at $t=5$), so `cbrt` of a negative number never arises.
- **The picture shows what was computed.**
  - The frames show RKF polylines through the accepted points over the dashed reference.
  - Axis limits (−0.1 to 5.1, −0.1 to 1.55) contain the hump (max 1.4498 at $t=0.88$) and the endpoint (5, 0.0081).
  - The visible hump corners are chord sag of up to 0.0091, as the page says, not integration error.
  - There are 81 frames (the RKF54 point count). The RKF45 marker holds at $t=5$ on the last frame, which is harmless.
  - The title and legend are correct.

