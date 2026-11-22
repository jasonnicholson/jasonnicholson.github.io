# Adams-Bashforth-Moulton Method — animation review

Page: [`pages/numerical-methods/adams-bashforth-moulton-method/index.qmd`](../../pages/numerical-methods/adams-bashforth-moulton-method/index.qmd) · Scripts: `adamsbashforthmoultonaa.jl` · GIFs: 1

**Result:** 1 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — The ABM run goes unstable near the end; it does not track the reference "over the full interval"

- **Location:** index.qmd:32-33, "**Behavior:** The ABM trajectory tracks the reference curve closely over the full interval while keeping a smooth and stable descent toward the right endpoint."
- **Now:** The page says ABM stays close to the reference all the way to t = 5 and descends smoothly and stably to the endpoint.
- **True:** With n = 50 (h = 0.1), the computed ABM4 solution loses stability once y becomes small. The local Jacobian is ∂f/∂y = −t/(3·y^{2/3}). The quantity h·∂f/∂y, evaluated on the reference solution, passes −1.28 near t ≈ 3.4. Below about −1.285 this PECE pair is unstable on the negative real axis. From about t = 3.3 on, the error changes sign every few steps and grows. ABM gives y_48 = −0.00183 at t = 4.8, which is negative while the true solution is +0.00920. It gives y_49 = 0.03081 (true value 0.00864) and ends at **y_50 = 0.13809 against the true y(5) = 0.0081199**, about 17 times too large. The last two frames of the GIF (frame_050, frame_051) show this clearly: the magenta curve dips just under the dashed reference near t = 4.2-4.8, then turns sharply upward at t = 4.9-5.0. The red marker ends well above the reference. The script prints the mismatch itself ("Final y(5) = 0.13808997897009537" vs "Reference y(5) = 0.008119920464867961").
- **Evidence:**
  - `cd reviewer && julia abm_values.jl` prints the following (ABM value, reference value, error, h·∂f/∂y): t=3.3: 0.0344077 / 0.0342702 / +1.4e-4 / −1.04; t=4.0: 0.0169702 / 0.0162357 / +7.3e-4 / −2.08; t=4.5: 0.0066973 / 0.0112304 / −4.5e-3 / −2.99; t=4.8: −0.0018309 / 0.0092030 / −1.1e-2 / −3.64; t=4.9: 0.0308130 / 0.0086385 / +2.2e-2; t=5.0: 0.1380900 / 0.0081199 / +1.3e-1. Minimum of ys = −0.00183.
  - `/usr/bin/python3 indep.py` gives: an independent ABM with the same values to 10 digits; Radau (rtol 1e-12) y(5) = 0.008119920464867836; PECE real stability interval ≈ [−1.285, 0].
  - The same file shows the method itself is correct: on y = exp(−t²) the error ratios on step halving are 21.4, 18.8, 17.3, 16.7, approaching 16, so the order is 4. The failure is step-size instability on this problem, not a coding bug.
  - `julia abm_props.jl` shows that with n = 100 the script's routine gives y(5) = 0.0081199160 (error 4.5e-9), and min y stays positive.
- **Suggested fix:** Either
  - (a) keep n = 50 and rewrite the Behavior paragraph to describe what happens. For example: "ABM tracks the reference closely up to about t ≈ 3.3. As y approaches 0 the problem becomes stiff (∂f/∂y = −t/(3y^{2/3})), h·∂f/∂y leaves the PECE stability interval (about −1.28), and the error oscillates and grows. The iterate briefly goes negative (y_48 ≈ −0.0018) and ends at y_50 ≈ 0.138 versus the true y(5) ≈ 0.00812."
  - or (b) change `n_steps` to 100 in adamsbashforthmoultonaa.jl:64. This also requires editing index.qmd:25, "n=50-step setup (51 mesh points)", and regenerating the GIF. With n = 100 the current Behavior text would be accurate.

  Option (a) keeps a useful lesson about stability. In either case, the Description's "giving high accuracy" (line 19) should not stand next to a run that ends 17 times off without a comment.

- **Independent check:** confirmed. Checker: genuine method behaviour, not a bug — the problem becomes stiff as y→0 (h·∂f/∂y reaches −4.1 vs ABM4 PECE's real stability limit ≈ −1.285); with N=100 it converges at 4th order.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | yes | 4.7 | adamsbashforthmoultonaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12-13 | "predictor-corrector multistep scheme for initial value problems $y' = f(t,y)$" | Script lines 46-56: predictor then corrector, using past f values | confirmed |
| 2 | 13-14 | "In the 4-step form, an explicit Adams-Bashforth predictor estimates $y_{n+1}$ from recent history" | Line 52 uses f_n..f_{n-3} with coefficients (55,−59,37,−9)/24, identical to the coefficients derived by integrating the cubic interpolant (indep.py); exact for f = s^0..s^3 and not s^4 | confirmed |
| 3 | 14-15 | "an implicit Adams-Moulton corrector immediately refines it" | Line 55: (9,19,−5,1)/24 on f_{n+1}(pred), f_n, f_{n-1}, f_{n-2}, identical to the derived AM coefficients; exact for f = s^0..s^3, not s^4. One corrector pass (PECE); the implicit equation is not iterated. This is the standard reading of "refines it" | confirmed |
| 4 | 17-18 | "ABM is not self-starting, initial points are generated with a one-step method (such as RK4)" | Lines 35-44: classical RK4 generates y1, y2, y3 with the same h. Starter is exact for y = t^4 (abm_props.jl max err 1.1e-16) | confirmed |
| 5 | 18-19 | "each new value uses prior function evaluations, giving high accuracy with low per-step cost" | Order 4 confirmed (ratios approach 16 on exp(−t²)). However, the page's own run ends 17× off (→ F1). The cost wording is a general claim and was not checked (the script recomputes past f values, which is performance, not a finding) | confirmed as a general statement; contradicted on this page's run, see F1 |
| 6 | 24 | "$y' = 1 - t\sqrt[3]{y}$, $y(0)=1$" | Script line 8 `f(t,y)=1 - t*cbrt(y)`, line 63 y0=1.0 | confirmed |
| 7 | 24 | "over $0 \le t \le 5$" | Lines 61-62 | confirmed |
| 8 | 25 | "$n=50$-step setup (51 mesh points)" | Line 64 n_steps=50; length(ts)=51; GIF has 51 frames | confirmed ("historical" attribution not checked: out of scope) |
| 9 | 27-28 | "dashed black curve is a high-accuracy reference trajectory computed with fixed-step RK4 at $h=10^{-4}$" | Lines 65, 68, 87. Reference y(5)=0.008119920464867961 vs Radau 0.008119920464867836 and DOP853 0.008119920464867971. Max h·∂f/∂y ≈ −4e-3, well inside RK4 stability | confirmed |
| 10 | 28 | "no closed-form exact solution is used for this case" | Script uses no closed form | confirmed |
| 11 | 30 | Case heading "ABM4 predictor-corrector, $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$, $0 \le t \le 5$" | Same as 2, 3, 6, 7 | confirmed |
| 12 | 32 | "The ABM trajectory tracks the reference curve closely over the full interval" | Error grows from 1e-4 at t=3.3 to 0.13 at t=5 (relative error 17×) | wrong (→ F1) |
| 13 | 33 | "keeping a smooth and stable descent toward the right endpoint" | Error oscillates in sign from t≈3.3, y_48<0, then the curve jumps up to 0.138 at t=5 (frames 50-51) | wrong (→ F1) |
| 14 | 35 | Link "[Julia source](adamsbashforthmoultonaa.jl)" | File exists; it is the only script; manifest shows it produces the embedded GIF | confirmed |
| 15 | 37 | Embed adamsbashforthmoultonaa.gif | Committed GIF byte-identical to the script's output (manifest) | confirmed |
| 16 | 37 | Alt text "predictor-corrector trajectory versus high-accuracy reference for y' = 1 - t cbrt(y), y(0)=1 on [0,5]" | Matches the frames (magenta ABM4 vs dashed reference, title matches) | confirmed |

## Implementation checks

### adamsbashforthmoultonaa.jl
- **Method:** This is the classical ABM4 in PECE mode, a legitimate standard variant. It uses a 4-step Adams-Bashforth predictor and a 3-step (fourth-order) Adams-Moulton corrector, applied once with no corrector iteration. RK4 is the starter for y1..y3. I verified the coefficients by property, not from memory:
  - Integrating the Lagrange cubic through nodes {0,−1,−2,−3} (AB) and {1,0,−1,−2} (AM) over [0,1] gives exactly 24·(55,−59,37,−9)/24 and (9,19,−5,1)/24.
  - Both rules integrate s^0..s^3 exactly. They fail on s^4 with errors 251/30 for AB and −19/30 for AM, which are the known error constants (indep.py).
  - Through the script's own routine (abm_props.jl): y = t^4 is reproduced to 1.1e-16 and y = t^5 is not (1.7e-5).
  - Empirical order on y' = −2ty, y(0)=1 (exact exp(−t²)) on [0,1]: errors 4.53e-5, 2.12e-6, 1.13e-7, 6.50e-9, 3.91e-10, with ratios 21.4, 18.8, 17.3, 16.7, so order 4.
  - I confirmed that 1 pass is used by comparing with my independent 1-pass PECE, which matches to 10 digits. A 2-pass version gives y(5) = −0.104, which differs.
- **Numbers:** The script's values match my independent Python PECE to all 10 printed digits at t = 0, 1, 2, 3, 3.3, 4, 4.5, 4.7, 4.8, 4.9, 5. Script's value beside the reference (Radau):
  - t=1: 1.4421673592 / 1.4421683555
  - t=2: 0.8595892148 / 0.8595887358
  - t=3: 0.0897596330 / 0.0898316681
  - t=4: 0.0169702225 / 0.0162357438
  - t=4.8: −0.0018309036 / 0.0092030375
  - t=5: 0.1380899790 / 0.0081199205

  The numbers are what ABM4-PECE with h = 0.1 produces. The large late error is genuine method behaviour (instability: h·∂f/∂y reaches −4.1 against a stability limit of about −1.285), not a bug. With n = 100 the error at t = 5 is 4.5e-9.
- **Reference values:** No closed form. The RK4 reference at h = 1e-4 agrees with scipy Radau (rtol 1e-12, atol 1e-14) and DOP853 (rtol 1e-13) at t = 5 to about 1e-16. The solution stays positive (min ≈ 0.0081), so the cube root is evaluated away from its singular point. The reference is more than adequate.
- **Picture:** I looked at the contact sheet and at frames 001, 050 and 051 at full size.
  - Title "ABM4: y' = 1 - t*cbrt(y), y(0)=1" matches f.
  - The dashed black line is the RK4 reference. The magenta polyline joins the ABM points y_0..y_k.
  - The red marker is at (t_k, y_k), and its legend label y_k uses the correct index (frame − 1). There are 51 frames for 51 mesh points.
  - ylims = (0, 1.55) hides y_48 = −0.0018 below the axis. That is about half a pixel, so it does not change what a viewer concludes.
  - The upward hook at t = 4.9-5.0 is plainly visible in the final frames. This contradicts the Behavior text (F1).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/adams-bashforth-moulton-method/`](evidence/adams-bashforth-moulton-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
