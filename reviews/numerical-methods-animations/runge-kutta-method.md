# Runge-Kutta Method — animation review

Page: [`pages/numerical-methods/runge-kutta-method/index.qmd`](../../pages/numerical-methods/runge-kutta-method/index.qmd) · Scripts: `rungekuttaaa.jl` · GIFs: 1

**Result:** 2 error, 0 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — With h = 0.25, RK4 is unstable from about t = 3.25, so the second half of the animated trajectory is a numerical artifact

- **Location:** `rungekuttaaa.jl:12` (`n = 20`, so `h = 0.25`); visible in frames 14–21 of `rungekuttaaa.gif` and in the final annotation `t=5.0  y≈0.2891`.
- **Now:** The trace falls to y ≈ 0.050 at t = 3.25, then turns up and zig-zags (0.0975, 0.1221, 0.1342, 0.1567, 0.2457, 0.1603, 0.2891), ending at y ≈ 0.2891. The GIF draws no reference curve, so a viewer reads this rise and zig-zag as the solution's behaviour.
- **True:** The exact solution keeps decreasing toward the nullcline y = 1/t³. At t = 3.5, 4, 4.5 and 5 it is 0.025358, 0.016236, 0.011230 and 0.0081199. The script's error is 1.5e-3 at t = 3, 1.2e-2 at t = 3.25 and 0.281 at t = 5, where the displayed value is 35 times the true one. The cause is stiffness: h·∂f/∂y = −h·t/(3y^{2/3}) along the true solution is −1.25 at t = 3, −2.38 at t = 3.25 and −3.38 at t = 3.5, which crosses RK4's real-axis stability limit of −2.785 between t = 3.25 and 3.5. From step 14 on, the RK4 stage values y + k3 go negative (as low as −0.55), and cbrt then returns large positive slopes (k4 up to +1.27). The method is coded correctly, as the Implementation checks show. The fault is the step size, which makes the picture show instability where the page describes accurate tracking.
- **Evidence:** `julia rk4_instrumented.jl` prints the script's values and stages (step 14: stage y+k3 = −0.01307, k4 = 0.456; step 20: y+k3 = −0.5497, k4 = 1.274). `python3 -I reference.py` gives a Radau/DOP853/LSODA reference at rtol 1e-13 (the three agree to 5e-13) and the per-point errors listed above. `python3 -I stability.py` gives z* = −2.78529. `python3 -I fix_check.py` (independent RK4, max error over the grid): n=20 2.81e-1; n=40 6.17e-2; n=60 3.43e-4; n=80 1.29e-5; n=100 4.89e-6. For n ≥ 80 no stage goes negative.
- **Suggested fix:** Use `n = 80` (h = 0.0625, max error 1.3e-5) or more. To keep the frame count reasonable, raise `fps` or plot every 4th point while computing with n = 80. Better still, also draw the reference solution as a thin curve so the accuracy can be seen. If the author wants to keep h = 0.25 on purpose, recast the case as a demonstration of RK4 instability on a stiff problem: draw the reference curve and rewrite the page text to match.

- **Independent check:** confirmed. Checker: genuine method behaviour — h·∂f/∂y passes RK4's limit (−2.785) at t≈3.34 and reaches −10.3 by t=5; the final label y≈0.2891 is ≈35× the true y(5)=0.0081199. An independent RK4 reproduces the committed frame exactly; n=80 gives error 6.8e-6 at t=5.

### F2 — Error — Page match — "RK4 tracks this with fourth-order accuracy even with the relatively coarse step size h=0.25" is false for the animation shown

- **Location:** index.qmd:18, "The solution starts at $y(0)=1$ and the right-hand side … pulls $y$ toward the fixed curve where $y=1/t^3$. RK4 tracks this with fourth-order accuracy even with the relatively coarse step size $h=0.25$."
- **Now:** The page says RK4 at h = 0.25 tracks a solution that is pulled toward y = 1/t³.
- **True:** The exact solution is pulled toward y = 1/t³ (y(5) = 0.0081199 against 1/125 = 0.008). The h = 0.25 RK4 trace does not track it: after t = 3.25 it moves away from that curve, ending at 0.2891 (see F1). Halving h near the end of the interval does not show fourth-order behaviour either. The error at t = 5 falls by a factor of 4.55 from n = 20 to n = 40 (fourth order would give about 16), then by 9070 from n = 40 to n = 80, because the instability disappears. On [0, 2] the h = 0.25 results are accurate to a few 1e-6 and do show order-4 ratios (≈14–16), so only the "even with … h=0.25" over [0, 5] part fails. Also, y = 1/t³ is the nullcline (where y′ = 0), not a "fixed curve". It is not itself a solution, since d(1/t³)/dt = −3/t⁴ ≠ 0.
- **Evidence:** Same commands as F1. Step halving at T = 5 with the script's own routine gives y(5) = 0.289107 (n=20), 0.069848 (n=40), 0.0081267 (n=80), 0.0081201 (n=160), against the reference 0.0081199.
- **Suggested fix:** After fixing F1 (n ≥ 80), change the sentence to name the actual step, for example "…pulls $y$ toward the nullcline $y = 1/t^3$ (where $y'=0$). With $h = 0.0625$ RK4 tracks the solution to about $10^{-5}$." Alternatively, if h = 0.25 is kept as an instability demonstration, say that RK4 tracks the solution until about t ≈ 3, then becomes unstable because h·∂f/∂y passes −2.785.

- **Independent check:** confirmed with correction. Checker: false on [0,5] (error 0.281 at t=5; halving ratios 4.6 then 9072), though fourth order does hold on [0,3] (ratios ≈14–19). The 'fixed curve' wording (y=1/t³ is a nullcline) is only a wording problem — Misleading at most — since the true solution is drawn toward it.

### F3 — Minor — Page match — "giving $O(h^4)$ local accuracy" states the wrong error kind

- **Location:** index.qmd:12, "RK4 computes four slope estimates ($k_1, k_2, k_3, k_4$) per step and takes a weighted average — giving $O(h^4)$ local accuracy."
- **Now:** It says local accuracy is O(h⁴).
- **True:** RK4's local truncation error per step is O(h⁵). Its global error is O(h⁴).
- **Evidence:** Step halving with the script's own RK4 routine (`julia rk4_instrumented.jl`): global error ratios on y′=y over [0,1] are 14.7, 15.3, 15.7, 15.8 (p → 3.99); on the non-autonomous y′ = t·y (exact e^{t²/2}) they are 17.4, 17.0, 16.6, 16.3 (p → 4.03); on y′ = cos t they are 16.00 (p = 4.000). These are global-error ratios of 2⁴. Sympy confirms that the tableau satisfies all eight order-4 conditions (`reference.py`), which gives local error O(h⁵).
- **Suggested fix:** "…giving $O(h^5)$ local truncation error and $O(h^4)$ global error."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `rungekuttaaa.jl` | yes | 3.5 | rungekuttaaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Each animation below shows the **RK4 solution trace** building step by step" | Script runs classical RK4 (lines 24–32) and reveals one point per frame | confirmed (one animation, not several, which is harmless) |
| 2 | 12 | IVP "$y' = 1 - t\sqrt[3]{y}$, $y(0)=1$" | Script line 9 `f(t,y) = 1.0 - t*cbrt(y)`, line 10 `y0 = 1.0`; GIF title matches | confirmed |
| 3 | 12 | "over $[0,5]$" | Script `t0=0`, `T=5`; last frame t = 5.0 | confirmed |
| 4 | 12 | "Each frame adds one new solution point; the connecting curve reveals the numerical trajectory" | 21 frames; frame k shows points 1..k joined by line, red marker on point k (frames 1, 14, 21 viewed full size, plus contact sheet) | confirmed |
| 5 | 12 | "RK4 computes four slope estimates ($k_1, k_2, k_3, k_4$) per step and takes a weighted average" | Code lines 26–31: k_i with weights 1,2,2,1 /6; tableau checked against order conditions in sympy | confirmed |
| 6 | 12 | "giving $O(h^4)$ local accuracy" | Local error O(h⁵), global O(h⁴) | wrong (→ F3) |
| 7 | 14 | "Julia source scripts … are linked under each case" | Line 20 links `rungekuttaaa.jl`, which exists | confirmed |
| 8 | 16 | Heading: "RK4, $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$, $n=20$ steps" | Script `n = 20`; 20 steps, 21 frames | confirmed |
| 9 | 18 | "The solution starts at $y(0)=1$" | ys[1] = 1.0; frame 1 label "t=0.0 y≈1.0" | confirmed |
| 10 | 18 | "$f(t,y)=1-t\sqrt[3]{y}$ pulls $y$ toward the fixed curve where $y=1/t^3$" | f = 0 exactly on y = 1/t³; f > 0 below it and f < 0 above it; exact solution approaches it (y(5)=0.0081199 vs 0.008). It is a nullcline, not a "fixed curve" or a solution | confirmed for the exact solution (wording loose, see F2). The animated trace contradicts it after t = 3.25 (→ F1) |
| 11 | 18 | "RK4 tracks this with fourth-order accuracy even with the relatively coarse step size $h=0.25$" | h = 5/20 = 0.25 is correct, but error grows to 0.281 at t=5; instability past t ≈ 3.25 | wrong (→ F2, F1) |
| 12 | 18 | Step size "$h=0.25$" | (5−0)/20 = 0.25 | confirmed |
| 13 | 20 | Source link `rungekuttaaa.jl` | File exists and is the script that produces the GIF (manifest: byte-identical regen) | confirmed |
| 14 | 22 | Embed `rungekuttaaa.gif` | Exists; produced by `rungekuttaaa.jl` | confirmed |
| 15 | 22 | Alt text: "numerical solution trace builds from left to right for y' = 1 - t·y^(1/3) with y(0)=1; each frame adds one RK4 step" | Matches script and frames | confirmed |

## Implementation checks

### rungekuttaaa.jl
- **Method:** It is classical RK4 with c = (0, ½, ½, 1), a21 = ½, a32 = ½, a43 = 1 and b = (1/6, 1/3, 1/3, 1/6) (lines 26–31, written with k_i = h·f). Sympy confirms all eight order conditions up to order 4 and the row-sum condition (`reference.py`). Empirical order with the script's own routine (`rk4_instrumented.jl`, T = 1, n = 5…80): y′=y gives ratios 14.7/15.3/15.7/15.8; non-autonomous y′=t·y gives 17.4/17.0/16.6/16.3; y′=cos t gives 16.00. Order 4 is confirmed, including the time placement of the stages.
- **Numbers (script vs independent reference, Radau rtol 1e-13; DOP853 and LSODA agree to 5e-13):**

  | t | script | reference | abs err |
  |---|---|---|---|
  | 0.25 | 1.2172614932 | 1.2172625271 | 1.0e-6 |
  | 0.50 | 1.3648174751 | 1.3648187148 | 1.2e-6 |
  | 1.00 | 1.4421677820 | 1.4421683555 | 5.7e-7 |
  | 1.50 | 1.2498671714 | 1.2498664147 | 7.6e-7 |
  | 2.00 | 0.8595929564 | 0.8595887358 | 4.2e-6 |
  | 2.50 | 0.4045082077 | 0.4044620727 | 4.6e-5 |
  | 3.00 | 0.0913583631 | 0.0898316681 | 1.5e-3 |
  | 3.25 | 0.0499825702 | 0.0384599515 | 1.2e-2 |
  | 3.50 | 0.0974961613 | 0.0253577004 | 7.2e-2 |
  | 4.00 | 0.1342102870 | 0.0162357438 | 1.2e-1 |
  | 4.50 | 0.2456971279 | 0.0112304066 | 2.3e-1 |
  | 4.75 | 0.1603325490 | 0.0095042016 | 1.5e-1 |
  | 5.00 | 0.2891074072 | 0.0081199205 | 2.8e-1 |

  My independent Python RK4 (`fix_check.py`) reproduces the script's y(5) = 0.289107 at n = 20, so the script computes RK4 correctly. The large errors come from instability (F1), not from a coding mistake.
- **Reference values:** The script draws no reference curve and no exact value. The true solution has no simple closed form, so I used three tight-tolerance scipy integrators that agree. The true solution stays positive: at y = 0, f = 1 > 0, so cbrt's non-Lipschitz point at 0 is never reached by the exact solution. Only the unstable RK4 stages go negative.
- **Picture:** I viewed the contact sheet (frames 1, 3, 5, …, 21) and frames 14 and 21 at full size. The line joins (ts[1:k], ys[1:k]) and the red marker sits at (ts[k], ys[k]). The annotation `t=…  y≈…` matches the computed values to 4 decimals in every frame I read (1.3648, 1.4422, 1.2499, 0.8596, 0.4045, 0.0914, 0.05, 0.0975, 0.1342, 0.2457, 0.2891). The trailing zero is dropped at t = 3.25 ("0.05"), which is cosmetic. The title shows the literal text `y^{1/3}` with braces because it is not a LaTeX string. It is readable and is not a finding. No stage slopes (k_i) are drawn, so there are none to check. The axis limits (0–5, 0–1.8) contain every computed point, and no clamping or masking is used. The feature the viewer would notice, the turn-up and zig-zag after t = 3.25, is the instability artifact of F1. No reference curve is drawn to reveal it.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/runge-kutta-method/`](evidence/runge-kutta-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
