# Adams-Bashforth-Moulton Method — animation review (round 2)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match, Misleading: the h = 0.0311 "stability limit" is presented as the step size above which ABM4 fails on this problem. In practice errors stay tiny up to about h = 0.07.

**Location.** `index.qmd` lines 25 and 36 to 40:
> "computed with $n=200$ steps ($h=0.025$) instead of the $n=50$ steps ($h=0.1$) of the module's first run (see Behavior)"

> "For steps longer than about $h=0.0311$, $h\,|\partial f/\partial y|$ exceeds the ABM4 predictor-corrector's stability limit $1.285$ before $t=5$ ..., and from then on errors are amplified instead of damped; just above $h=0.0311$ this affects only the last steps"

The script comment at line 64 makes the same point: "h = 0.025 keeps h*|df/dy| below ABM4 PECE's limit 1.285 up to t = 5".

**What is there now.** Every number in this passage is right:
- The real-axis stability boundary of ABM4 PECE is z = −1.28482.
- |df/dy|(5) = 41.255.
- The threshold is h = 1.28482/41.255 = 0.031143.
- For h = 0.1 the onset is at t = 3.4526.

The problem is the framing. The passage presents a frozen-coefficient linear-stability bound as the point past which the computed solution degrades, and it gives that bound as the reason for choosing n = 200. A reader concludes that ABM4 with h above about 0.031 gives amplified, untrustworthy values on this problem.

**What is true instead.** The ABM4 results stay accurate well beyond h = 0.0311:

| n | h | onset t where h\|f_y\| = 1.285 | error at t = 5 | max error over grid |
|---|---|---|---|---|
| 150 | 0.0333 | 4.890 | 1.36e-10 | 1.2e-6 |
| 100 | 0.05 | 4.283 | 4.49e-9 | 8.5e-6 |
| 80 | 0.0625 | | 1.09e-5 | 2.6e-5 |
| 75 | 0.0667 | | 4.4e-5 | 5.5e-5 |
| 70 | 0.0714 | | 2.1e-3 | 2.1e-3 |
| 50 | 0.1 | 3.453 | 0.130 | 0.130 |

- For n = 150 the error falls steadily through the "unstable" last steps: from −1.59e-9 at t = 4.17 to −1.36e-10 at t = 5.
- For n = 100 it only drifts between −1.4e-9 and −4.5e-9 over t = 4.3 to 5.
- The legacy module's own second and third runs of Example 11 (n = 100 and n = 150; archive images gr_177 and gr_184) both end at y(5) = 0.00811992, which is correct.

So the n = 200 run was not needed to get an accurate result. The page names only the failed n = 50 run, and the reader never learns that the module's next two runs succeeded. The linear bound marks where a parasitic root first exceeds 1 in modulus. It is not where the error becomes visible: that happens near h ≈ 0.07 (n ≈ 70), because the local error being amplified is tiny.

**How I know.**
- `/usr/bin/python3 -I review/stab.py` gives the boundary −1.284816, the threshold h 0.031143, and onset times 3.4526 (h = 0.1), 4.2830 (h = 0.05) and 4.8896 (h = 0.0333).
- `/usr/bin/python3 -I review/sweep.py` gives the error histories and the n sweep in the table.
- My independent ABM4 reproduces the legacy tables (n = 50: y48 = −0.0018309 and y50 = 0.13809; n = 100: y(5) = 0.0081199; n = 60: y(5) = 0.10367, which matches the 0.1036708 in the legacy animation frame).

**Suggested correction.** Keep the numbers, but say plainly that 0.0311 is the linearized (frozen-coefficient) bound and not an accuracy threshold. Add that in practice the computed solution stays accurate to better than 1e-5 down to about n = 80 (h = 0.0625) and fails visibly only near h ≈ 0.07 and above, as the module's own n = 100 and n = 150 runs show (both give y(5) = 0.0081199). Line 25 could then read "with n = 200 steps (h = 0.025), safely inside the linear stability bound," and drop the implication that n = 200 was required. Soften the script comment at line 64 the same way.

- **Independent check:** confirmed with correction: errors stay small well past h = 0.0311 (stated boundary numbers z = −1.284816, f_y(5) = −41.2554, h_crit = 0.031143 are themselves correct); practical degradation sets in at h ≈ 0.066–0.068 — about 0.066 by relative error at t = 5, where h = 0.07 already gives 7–26% relative error

### F2. Fidelity, Minor: the legacy animation's content (a sweep over the number of subintervals) is replaced by a single fixed-step trajectory, and the page does not say so.

**Location.** `index.qmd` line 23, "The animation below reconstructs legacy Example 11 from the Mathews module", together with the animation itself.

**What is there now.** The GIF builds one ABM4 trajectory at n = 200 that lies on the reference throughout. Nothing in it varies with step size.

**What the archive has.** Example 11's "Animation 1" (`a2001/Animations/OrdinaryDE/Adams1/Adamsaa.gif`, 39 frames) does something else:
- Each frame is a complete ABM solution for an increasing number of subintervals, from m = 12 to m = 150. Contact-sheet frames are labelled m = 12, 16, 20, 28, 36, 44, 52, 60, 100 and 150.
- Each frame is annotated with y(5): 0.0214, 0.632, −0.363, 0.0789, −0.119, 0.0735, 0.0622, 0.104, 0.0081199 and 0.0081199.

Its lesson is that coarse steps give oscillating, wrong end values and that the result settles once the step is small enough. The Example 11 solution also has three runs (n = 50, 100 and 150), of which the page mentions only the first. The page's text does discuss the n = 50 failure, but the animation, which the page says reconstructs this example, shows none of it.

**How I know.** I extracted the frames with `julia .../tools/giftools.jl .../Adamsaa.gif review/legacy_anim` and viewed `review/legacy_anim/sheet.png` and `frame_039.png`. I read the archive text of `AdamsBashforthMod_lnk_12.html` and viewed images gr_166, gr_170, gr_177, gr_180, gr_181 and gr_184.

**Suggested correction.** Either add a second case that sweeps n (for example n = 50, 55, 60, ... 100, 150 with y(5) in the title), or change line 23 to say that the animation shows only the converged run of Example 11 and that the module's animation instead varied the number of subintervals.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Summary: Error 0, Misleading 1, Minor 1.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 8.1 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adamsbashforthmoultonaa.gif` | 51 | byte-identical | adamsbashforthmoultonaa |

### Page references

- Scripts linked: `adamsbashforthmoultonaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description: "4-step form, an explicit Adams-Bashforth predictor estimates $y_{n+1}$ ... an implicit Adams-Moulton corrector immediately refines it" | Script lines 52 to 55: AB4 predictor, then one AM4 corrector application (PECE). The coefficients match the sympy derivation: AB4 [55, −59, 37, −9]/24 and AM4 [9, 19, −5, 1]/24. | confirmed |
| 2 | Description: "not self-starting, initial points are generated with a one-step method (such as RK4)" | Script lines 35 to 44 use classical RK4 for y1, y2 and y3 with the same h. | confirmed |
| 3 | Description: "each new value uses prior function evaluations, giving high accuracy with low per-step cost" | Two new f evaluations per step (f_n is recomputed, which is harmless). Order 4 confirmed (claim 21). | confirmed |
| 4 | "reconstructs legacy Example 11 from the Mathews module" | The ODE, interval and IC match archive gr_165. The animation content differs from the archive's (F2). | confirmed for the problem; see F2 |
| 5 | $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$, $0 \le t \le 5$ | Script lines 8 and 61 to 63 | confirmed |
| 6 | $n=200$ steps ($h=0.025$) | Script line 64; abm4 uses h = (5 − 0)/200 | confirmed |
| 7 | "instead of the $n=50$ steps ($h=0.1$) of the module's first run" | Archive gr_166: n = 50 is the first run. Later runs n = 100 and 150 are not mentioned (F1, F2). | confirmed as stated; see F1 |
| 8 | "Each frame adds four steps (0.1 in $t$)" | stride = 4, h = 0.025. Frame indices run 1:4:201. | confirmed |
| 9 | "the connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` draws a polyline through all computed points. | confirmed |
| 10 | Dashed black curve is "fixed-step RK4 at $h=10^{-4}$" | Script lines 66, 69 and 88 | confirmed |
| 11 | "high-accuracy reference trajectory" | Maximum difference from the mpmath solution at the 201 step points is 1.2e-14; at t = 5 it is 0.0. | confirmed |
| 12 | "no closed-form exact solution is used for this case" | True; the script uses only the RK4 reference. | confirmed |
| 13 | Case heading: ABM4 predictor-corrector, same ODE, IC, interval, n = 200, h = 0.025 | Matches the script | confirmed |
| 14 | "stay within $3.1\times10^{-7}$ of the exact solution at all 201 step points" | Max error 3.087e-7 (script vs mpmath and script vs RK4 reference agree) | confirmed |
| 15 | "the largest error is near $t=3.3$" | argmax at t = 3.300 | confirmed |
| 16 | "error at $t=5$ is $2.6\times10^{-11}$" | 2.579e-11 | confirmed |
| 17 | "exact $y(5)=0.0081199$" | mpmath 0.00811992046486796 | confirmed |
| 18 | ABM4 PECE "stability limit $1.285$" | Real-axis boundary at z = −1.284816 (stab.py) | confirmed |
| 19 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | Derivative is correct; value −41.255 | confirmed |
| 20 | "For steps longer than about $h=0.0311$ ... exceeds ... before $t=5$" | 1.284816/41.255 = 0.031143 | confirmed |
| 21 | (implicit) method is fourth order | Script's abm4 on y' = −y + t over [0, 2]: errors 2.02e-6, 1.08e-7, 6.16e-9 and 3.67e-10 for n = 20, 40, 80 and 160 (ratios 18.8, 17.5 and 16.8, about 2^4) | confirmed |
| 22 | "from then on errors are amplified instead of damped; just above h = 0.0311 this affects only the last steps" | The linear-stability statement is true. Actual errors are not visibly amplified at h = 0.0333 or 0.05 (F1). | misleading (F1) |
| 23 | "at the module's $h=0.1$ ($n=50$) it starts at $t\approx3.45$" | Onset t = 3.4526 | confirmed |
| 24 | "computed values fall to $y_{48}\approx-0.0018$ at $t=4.8$ (below zero)" | y48 = −0.0018309 (independent; archive gr_170 shows −0.0018309) | confirmed |
| 25 | "then turn upward and end at $y(5)\approx0.138$" | y49 = 0.030813, y50 = 0.13809 | confirmed |
| 26 | "about 17 times the exact value" | 0.13809/0.0081199 = 17.006 | confirmed |
| 27 | Source link `adamsbashforthmoultonaa.jl` | The file exists and is the script that produces the embedded GIF | confirmed |
| 28 | Embed `adamsbashforthmoultonaa.gif` | Exists and is byte-identical to a regeneration | confirmed |
| 29 | Alt: "magenta trace builds four steps per frame" | Frames: magenta line, +4 steps per frame | confirmed |
| 30 | Alt: "lies on the dashed RK4 reference throughout" | Max deviation 3.1e-7; indistinguishable in all frames | confirmed |
| 31 | Alt: "rising to about 1.45 near t = 0.9" | Exact max 1.44977 at t = 0.8836; the script's grid max is 1.44973 at t = 0.875 | confirmed |
| 32 | Alt: "falling to y ≈ 0.0081 at t = 5" | 0.0081199 | confirmed |
| 33 | Frame title "ABM4, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" | Matches script line 8 and the parameters | confirmed |
| 34 | Legend "y_k" on the red marker | The marker is at (ts[frame], ys[frame]) and labelled frame − 1. Frame 6 is labelled y_20 at t = 0.5, y ≈ 1.37; the true y(0.5) is 1.3648. The last frame is y_200 at (5, 0.0081). | confirmed |
| 35 | Frame count (51, not stated on the page) | 1:4:201 gives 51 frames, which matches the GIF | confirmed |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**It is the method it claims to be.**
- The script runs the fourth-order Adams-Bashforth-Moulton method in PECE mode: an AB4 predictor, f evaluated at the prediction, one AM4 (3-step implicit, 4th-order) corrector, and f re-evaluated at the corrected value on the next pass.
- It starts with three classical RK4 steps.
- This is the standard ABM4 that Mathews uses. The page's Description does not specify P(EC)^k, and one corrector pass is consistent with "immediately refines it".
- I derived the coefficients independently by integrating the Lagrange interpolants with sympy: AB4 ×24 = [55, −59, 37, −9] and AM4 ×24 = [9, 19, −5, 1]. Both match lines 52 and 55.

**The numbers are right.**
- The instrumented copy's ys against my independent Python ABM4: maximum difference 2.2e-16 over all 201 points.
- Selected values, script vs exact (mpmath):

  | t | script | exact |
  |---|---|---|
  | 0.1 | 1.0948955787 | 1.0948955793 |
  | 2.5 | 0.4044620693 | 0.4044620727 |
  | 3.3 | 0.0342704734 | 0.0342701647 |
  | 5.0 | 0.008119920439 | 0.008119920465 |

- Order test with the script's own `abm4` on y' = −y + t, y(0) = 1 (exact y = t − 1 + 2e^−t): halving h divides the error by 18.8, 17.5 and 16.8, so the method is fourth order.
- Legacy cross-check: my ABM4 reproduces Mathews' n = 50 table (y48 = −0.0018309, y50 = 0.13809), the n = 100 final value 0.00811992 and the animation's m = 60 value 0.1036708.

**Its reference values are right.**
- The RK4 reference at h = 1e-4 agrees with a 30-digit mpmath Taylor ODE solution to 1.2e-14 at every step point, and exactly at t = 5 to double precision.
- scipy DOP853 at rtol 2.2e-14 gives y(5) = 0.008119920464867965, which also agrees.
- The exact solution stays positive on [0, 5] (minimum 0.00812 at t = 5), so cbrt is evaluated on positive arguments and the reference is valid.

**The picture shows what was computed.**
- I viewed the contact sheet (frames 1, 6, 11, ..., 51) and frame 51.
- The dashed black reference spans the whole interval in every frame. The magenta polyline grows by 4 steps per frame. The red marker sits at the newest point with the right index label.
- The title matches the code. The axis limits (−0.1 to 5.1, −0.05 to 1.55) contain the whole solution, including the maximum near 1.45 and the endpoint (5, 0.0081). There is no clamping or masking.
- The ABM4 trace covers the reference completely, which is accurate since the maximum error is 3e-7.
- Because nothing in the picture shows the method's error or its step-size behaviour, the instability discussed in the text is not visible (see F2).

