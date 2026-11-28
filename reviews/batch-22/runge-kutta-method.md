# Runge-Kutta Method — batch 22 review, round 1 (overview mode)

SUMMARY: 1 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/runge-kutta-method/index.qmd` (overview page, light-pass batch 22). The diff changes no script or GIF, so the animation is not under review. Evidence and scratch files are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/runge-kutta-method/reviewer/ (chk.py, cex.py, wc.py, thm.png). I consulted the Mathews archive: n2003/RungeKuttaMod.html and its formula images gr_9 to gr_18.

## 1. Findings

**F1 — Page text, Error.** index.qmd line 30.
- **Current text:** "The error result needs more: in general, if the solution is smooth enough, $y \in C^5[t_0, b]$, the local truncation error of a step is $O(h^5)$ and the global error is $|y(t_i) - y_i| = O(h^4)$ …"
- **What is true instead:** this is stated as a general result, and as a general result it is false. Line 29 adds that f is continuous and Lipschitz in y, but even with that, a smooth solution does not give RK4 order 4. RK4 evaluates f at stage values $y_i + k_1/2$, $y_i + k_2/2$ and $y_i + k_3$, which lie off the solution curve. Its local error expansion therefore needs f itself to be smooth in a neighbourhood of the solution, with continuous partial derivatives through order 4. That condition implies y ∈ C⁵, but y ∈ C⁵ does not imply it.
- **How I know:** I built a counterexample (cex.py). Take f(t,y) = cos t + |y − sin t| with y(0) = 0. This f is continuous and Lipschitz with constant 1, and the solution is y = sin t ∈ C^∞. RK4 on [0,2] with m = 20, 40, 80, 160, 320 gives errors 1.50e-3, 3.86e-4, 9.76e-5, 2.46e-5, 6.16e-6. The observed orders are 1.96, 1.98, 1.99, 2.00, so the method is order 2, not 4.
- **Context:** the wording follows Mathews' own Precision theorem, whose hypothesis is on y(t) (the superscript in gr_12.gif is too small at 17 px to read with certainty). The page applies the result to Case 1 correctly: on line 33 it argues from "f is smooth along it", which is the right hypothesis. Only the general statement on line 30 is wrong.
- **Suggested correction:** "The error result needs more: in general, if $f$ has continuous partial derivatives through order 4 near the solution (which makes $y \in C^5[t_0, b]$), the local truncation error …"

No other findings.

## 2. Claim ledger (text added by the diff)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | RK4 solves $y'=f(t,y)$, $y(t_0)=y_0$ over $[t_0,b]$ | confirmed | definition; matches script |
| 2 | $t_i=t_0+ih$, $m$ subintervals, $h=(b-t_0)/m$ | confirmed | script: `h=(T-t0)/m`, `ts=t0+i*h` |
| 3 | f is evaluated four times: once at the start, twice at the midpoint, once at the end | confirmed | script k1 to k4 at t, t+h/2, t+h/2, t+h |
| 4 | Display formulas for k1 to k4 and $y_{i+1}=y_i+(k_1+2k_2+2k_3+k_4)/6$ | confirmed | identical to `rk4()` in rungekuttaaa.jl, same notation (t, y, h, k) |
| 5 | If f depends on t alone, $k_2=k_3$ and the step is Simpson's rule on $[t_i,t_i+h]$ | confirmed | the step becomes $(h/6)[f(t_i)+4f(t_i+h/2)+f(t_i+h)]$ |
| 6 | Mathews' theorem assumes f continuous and Lipschitz in y, so the solution is unique | confirmed | RungeKuttaMod.html theorem text: "continuous and satisfies a Lipschits condition in the variable y" |
| 7 | If y ∈ C⁵ the local error is O(h⁵) and the global error O(h⁴) (general) | wrong as a general statement | F1; counterexample gives order 2 |
| 8 | For small enough h, halving the step divides the final error by about 16 | confirmed (under the corrected hypothesis) | on the page's problem, m = 800 → 1600 gives 1.27e-10 / 7.46e-12 = 17.0 |
| 9 | Case 1: $f=1-t\sqrt[3]{y}$, $y(0)=1$, [0,5] | confirmed | script lines 10–14 |
| 10 | The solution stays positive, down to y(5) = 0.0081199 | confirmed | mpmath odefun at 30 digits gives y(5) = 0.0081199204649; the minimum on a 501-point grid is at t = 5; the maximum is 1.44976 at t = 0.88 |
| 11 | f is smooth along the solution, so the general rate applies, but only for steps smaller than the animation shows | confirmed | y ≥ 0.00812 > 0, so f is C^∞ near the solution; observed orders below are still above 4 at the frame resolution |
| 12 | Observed order 4.90 between m = 120 and 150 | confirmed | 4.902 (errors 5.25e-7, 1.76e-7 against the mpmath reference) |
| 13 | Observed order 4.07 between m = 1200 and 1600 | confirmed | 4.074 (errors 2.41e-11, 7.46e-12); intermediate pairs give 4.28 (300/400) and 4.14 (600/800), approaching 4 |
| 14 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | confirmed | −41.255; \|∂f/∂y\| along the solution is nondecreasing for t > 1, so t = 5 is its maximum |
| 15 | For every step longer than about h = 0.0675 (m ≤ 74), h\|∂f/∂y\| exceeds 2.785 before t = 5 | confirmed | critical h = 2.78529/41.255 = 0.067513, which is m = 74.06 |
| 16 | RK4 real-axis linear stability limit 2.785 | confirmed | R(−2.7853) = 1.0000097, R(−2.7852) < 1; the script's bisection gives 2.7853 |
| 17 | f is not Lipschitz near y = 0 | confirmed | \|∂f/∂y\| → ∞ as y → 0 for t > 0 |
| 18 | In every run from m = 12 to 52 some stage value falls below 0 | confirmed | chk.py: minimum stage is negative for all 13 runs m = 12 to 52 (−1.1542 at m = 12, −0.0086 at m = 52) and positive from m = 56 (0.0048) on |
| 19 | In those same runs the computed curve visibly turns upward in the tail | confirmed | rise after the peak for m = 12 to 52 (and at m = 56, which the Description does not claim as visible); frames 001 and 013 show the upturn, small but visible at m = 52 |
| 20 | Ending at y(5) ≈ 0.588 for m = 12 | confirmed | 0.5883471, matching frame 001's label |
| 21 | The case's Behavior note separates the causes | confirmed | the Behavior paragraph has separate stability and negative-stage discussions; no contradiction with the Description |
| 22 | Euler (order 1), Heun (order 2) and Taylor animate the same sweep on the same problem | confirmed | each page uses y' = 1 − t∛y, y(0) = 1, [0,5] in a step-refinement sweep. Euler's Case 1 starts at m = 10, not 12; it is the same kind of sweep, not the identical list, which I judge not misleading |
| 23 | RKF pairs embedded 4th- and 5th-order formulas to choose h adaptively | confirmed | runge-kutta-fehlberg-method/index.qmd line 13 |
| 24 | ABM takes its starting values from a one-step method such as RK4 | confirmed | adams-bashforth-moulton-method/index.qmd lines 28 and 45 ("the first three steps by RK4") |
| 25 | New heading id `{#case-1}` on the Case 1 heading | confirmed | line 49; the link on line 32 `[Case 1](#case-1)` resolves |

## 3. Checks

**The six points of the overview standard:**
1. Problem: present, lines 12–13.
2. Core formula: present as display math in the scripts' notation, lines 16–25.
3. Assumptions: present, line 29.
4. Accuracy: present, line 30, and checked on Case 1 at lines 32–34. Its hypothesis is wrong (F1).
5. Failure modes: present, lines 36–39. Stability and the non-Lipschitz point at y = 0, both tied to Case 1 and verified.
6. Where it fits: present, line 41.

No proofs, theorem boxes or callouts.

**Word count:** the manifest gives 354. My own count, with inline math as one word and link targets stripped, gives 377. Both are inside 150–400.

**Links and anchors:** all of these directories exist: `../simpsons-rule-for-numerical-integration/`, `../eulers-method-for-odes/`, `../heuns-method/`, `../taylor-series-method-for-odes/`, `../runge-kutta-fehlberg-method/` and `../adams-bashforth-moulton-method/`. `#case-1` matches the explicit id on line 49.

**Diff scope:** the diff adds the `## Description` (lines 10–42) and the `{#case-1}` id on the Case 1 heading. Nothing else in Animations or other sections changed, so the diff is within the allowed scope. The unchanged Animations intro (line 45) repeats the O(h⁵)/O(h⁴) statement "for smooth f", which is consistent with the Description.

**Other checks:**
- Frames: I inspected frames 001 (m = 12) and 013 (m = 52). Their labels (y(5) = 0.5883471 and 0.0376958, and the shading onsets t ≈ 3.10 and 4.45) agree with my computation.
- Reference value: the script's reference is RK4 with 50000 steps. Its error is about 1e-17 by fourth-order scaling, so it agrees with mpmath to every printed digit.
- I did not run MATLAB, quarto or the page's script, and I modified nothing in the repository.


## Independent check of F1 (a separate checker given only the allegation)

**F1: confirmed. Error is the right severity.**

**The claim.** Line 30 says that "in general, if the solution is smooth enough, $y \in C^5[t_0,b]$", RK4's local truncation error is $O(h^5)$ and its global error is $O(h^4)$. That is false as a general statement. RK4's error expansion Taylor-expands $f$ at the stage points $y_i + k_1/2$, $y_i + k_2/2$ and $y_i + k_3$. Those points lie off the solution curve, so the result needs smoothness of $f$ near the solution (about $f \in C^4$, which also gives $y \in C^5$). Smoothness of $y$ alone is not enough.

**Counterexample.** I computed it in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/runge-kutta-method/checker/cex.py`:
- Take $f(t,y) = |y - \sin t| + \cos t$ with $y(0) = 0$ on $[0,2]$.
- $f$ is continuous and Lipschitz in $y$ with $L = 1$, so it meets Mathews' hypotheses.
- The exact solution is $y = \sin t$, which is $C^\infty$, so it is in $C^5$.
- Error in $y(2)$:

| $m$ | error in $y(2)$ | observed order |
|---|---|---|
| 10 | 5.73e-3 | – |
| 20 | 1.50e-3 | 1.93 |
| 40 | 3.86e-4 | 1.96 |
| 80 | 9.76e-5 | 1.98 |
| 160 | 2.46e-5 | 1.99 |
| 320 | 6.16e-6 | 1.996 |
| 640 | 1.54e-6 | 1.998 |

- One step from the exact value at $t = 1$, the local error for $h = 0.1, 0.05, 0.025, 0.0125$ is 7.15e-5, 8.86e-6, 1.10e-6, 1.37e-7. Each halving divides it by about 8, so it is $O(h^3)$.
- So the global error is $O(h^2)$, not $O(h^4)$, even though $y \in C^\infty$.
- The cause: $y_i + k_1/2$ misses $y(t_i + h/2)$ by $O(h^2)$, and the kink in $|\cdot|$ turns that miss into an $O(h^2)$ slope error.

**Severity.**
- I could not read Mathews' precision-theorem hypothesis directly, because the module shows its math as images and the text extraction lost it. Taking it as $y \in C^5$, as you said it is, the page copies a common textbook shortcut.
- Still, the page does not attribute this sentence to Mathews. It writes it in its own voice as the stronger condition ("The error result needs more: in general…"), right after noting that Mathews' theorem only assumes continuity plus Lipschitz. So it presents itself as a correction of the theorem, and the correction is itself false. A reader would come away believing that a smooth solution guarantees fourth order.
- That fits Error (a false statement), not just Misleading.
- What limits the harm: the next paragraph's reasoning for Case 1 rests on "$f$ is smooth along it", which is the right condition, since the solution stays positive and $f$ is smooth near it. The Animations intro also correctly says "for smooth $f$". The conclusions for Case 1 are therefore unaffected.
- If you want to downgrade, Misleading is the furthest I would go, given the textbook precedent. I recommend keeping Error.

**Suggested fix.** "if $f$ is smooth enough near the solution ($f \in C^4$, which makes $y \in C^5$), the local truncation error … is $O(h^5)$ and the global error … $O(h^4)$". Mathews' $y \in C^5$ could be kept as an attributed remark, not as the general condition.
