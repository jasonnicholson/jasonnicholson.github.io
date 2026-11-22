# Taylor Series Method for ODE's — animation review

Page: [`pages/numerical-methods/taylor-series-method-for-odes/index.qmd`](../../pages/numerical-methods/taylor-series-method-for-odes/index.qmd) · Scripts: `taylorderivativeaa.jl`, `taylorderivativebb.jl` · GIFs: 2

**Result:** 3 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — With h = 0.25 both methods are unstable for t ≳ 3.25, so the last third of each animation shows a numerical blow-up, not the solution

- **Location:** `taylorderivativeaa.jl:27-29` and `taylorderivativebb.jl:29-31` (`T = 5.0`, `n = 20`, `h = 0.25`); `ylims = (0.0, 1.8)` at aa:32 / bb:34. The page presents these as solutions of the IVP over [0,5] (index.qmd:12, "shows the **Taylor series solution trace** … over $[0,5]$"), and nothing on the page mentions instability.
- **Now:** The true solution decays smoothly toward the slow manifold y ≈ t⁻³ (y(4.25)=0.01342, y(5)=0.008120). Order 3 drops to 0.0068 at t=4, jumps to **1.2162 at t=4.25**, then 0.4529, 0.0399, 0.0895. The spike to y≈1.2 is clearly visible in frames 18–21 and looks like a feature of the solution. Order 4 goes **negative**: −0.0465 at t=4.25, then **−10.4513, −7.7892, −5.2675**. With `ylims=(0,1.8)` the purple trace leaves the bottom of the plot at t≈4.05 and the red marker is off-screen in frames 18–21. Only the annotation ("y≈-10.4513", "y≈-5.2675") shows what happened. The true solution can never become negative, because y' = 1 > 0 at y = 0.
- **True:** Along the solution, ∂f/∂y = −t/(3·y^{2/3}), so h·∂f/∂y = −0.18 (t=2), −1.25 (t=3), −2.38 (t=3.25), −3.38 (t=3.5), −5.20 (t=4) and −10.3 (t=5). On the negative real axis the order-3 Taylor method is stable only down to about −2.51 and the order-4 method down to about −2.79, so both lose stability between t=3.25 and t=3.5. The nodal errors are below 1e-3 up to t=2.75. After that they oscillate in sign, and from t=4.25 on they are of order 1 to 10.
- **Evidence:** `julia values_aa.jl`, `julia values_bb.jl` (script values); `/usr/bin/python3 indep.py` (Radau with rtol=1e-13 and LSODA with rtol=1e-12 agree to about 1e-11; h·∂f/∂y table above); `/usr/bin/python3 errtable.py`:

  | t | reference | order 3 (script) | order 4 (script) |
  |---|---|---|---|
  | 3.00 | 0.089832 | 0.090539 | 0.090247 |
  | 3.50 | 0.025358 | 0.024006 | 0.024733 |
  | 4.00 | 0.016236 | 0.006795 | 0.014189 |
  | 4.25 | 0.013416 | 1.216164 | −0.046492 |
  | 4.50 | 0.011230 | 0.452905 | −10.451291 |
  | 5.00 | 0.008120 | 0.089522 | −5.267457 |

  Frames checked: aa frames 18 and 21 (spike at t=4.25), bb frames 18 and 21 (trace exits below y=0, marker not visible).
- **Suggested fix:** Use a stable step. `julia fixcheck.jl` shows that n=80 (h=0.0625) on [0,5] gives a maximum nodal error of 2.7e-5 (order 3) and 2.0e-6 (order 4), with y(5)=0.0081199 for both. n=40 is still marginal: the order-4 error grows to 1.4e-3 at t=5 and exceeds order 3's. Another option is to keep h=0.25 and end the interval at t=3. If the large step is kept on purpose, say on the page that the instability is the point (stiffness: h·∂f/∂y leaves the stability interval), widen `ylims` so the order-4 divergence is visible, and draw the reference solution for comparison.

- **Independent check:** confirmed. Checker: derivatives match sympy to 5e-15; h·∂f/∂y falls from −2.4 (t=3.25) to −10.3 (t=5), past the stability limits −2.51 (order 3) and −2.79 (order 4) — genuine method behaviour, not a bug. The checker would rate the page's silence Misleading; the director kept Error for consistency with runge-kutta-method F1, where the same unstable artifact is presented as the solution.

### F2 — Error — Page match — "slightly better accuracy than order 3" is false in both directions

- **Location:** index.qmd:26, "giving slightly better accuracy than order 3 with the same step size $h=0.25$."
- **Now:** The page says order 4 is slightly better than order 3.
- **True:** Where the methods are stable (t ≤ 2.75), order 4 is 10 to 500 times more accurate, not slightly: at t=1 the errors are 6.5e-4 (order 3) and 3.3e-5 (order 4), at t=2 they are 9.3e-4 and 9.6e-6, and at t=2.25 they are 9.7e-4 and 1.7e-6. Over the frames shown last (t ≥ 4.5), order 4 is far worse: 10.46 against 0.44 at t=4.5, and 5.28 against 0.081 at t=5. The final frames a reader compares (y≈0.0895 against y≈−5.2675) show order 4 as the much worse result.
- **Evidence:** `/usr/bin/python3 errtable.py` (full per-node table in that output; the numbers are quoted above).
- **Suggested fix:** After fixing F1, state the measured gain, for example "order 4 is roughly 20–100× more accurate than order 3 at h=0.25 on [0,2.5]". Or, if the h=0.25 instability is kept, describe what the frames actually show.

- **Independent check:** confirmed. Checker: order 4 is 10–600× more accurate up to t=2.75, far worse from t=4.5 (max error 10.45 vs 1.20).

### F3 — Error — Page match — Order-3 Taylor does not match RK4 in order

- **Location:** index.qmd:18, "The local truncation error is $O(h^4)$, matching RK4 in order."
- **Now:** The page equates order-3 Taylor with RK4.
- **True:** RK4 is a fourth-order method, with local error O(h⁵) and global error O(h⁴). Order-3 Taylor has local error O(h⁴) and global error O(h³), so it matches RK3. The order-4 Taylor method of Case 2 is the one that matches RK4. The measured global error ratio of the script's order-3 method under step halving is 8.20, 8.10, 8.05, 8.02, so it is third order.
- **Evidence:** `julia order.jl <pagedir> 0.8595887358114 0.4044620726786 0.008119920464868` (errors at T=2: 9.35e-4, 1.14e-4, 1.41e-5, 1.75e-6, 2.18e-7).
- **Suggested fix:** Replace "matching RK4 in order" with "the same order as a third-order Runge–Kutta method (global error $O(h^3)$)", or move the RK4 comparison to Case 2.

- **Independent check:** confirmed with correction. Checker: order 3 measures 3.00 globally vs RK4's 4, so 'matching RK4 in order' is false; but the 'local truncation error O(h⁴)' clause on line 18 is correct (one-step slope 4.00).

### F4 — Misleading — Implementation / Page match — The "order 4" script gets y'''' by a finite difference, not analytically

- **Location:** `taylorderivativebb.jl:23-24`: `eps_h = h * 1e-5; d4 = (yd3_f(t + eps_h, y + eps_h * d1) - d3) / eps_h`. The script comment at line 9 says only "one more derivative term". The page claims: index.qmd:12, "The Taylor method uses the ODE to compute higher derivatives analytically"; index.qmd:18, "requires explicit symbolic derivatives"; index.qmd:26, "four derivative terms are used per step".
- **Now:** y', y'' and y''' are analytic and correct (sympy difference 0). The fourth derivative is a forward-difference directional derivative of y''' along (1, f).
- **True:** This is a hybrid Taylor/finite-difference scheme. Numerically it is harmless here: the relative error in d4 is 1e-7 to 2e-5 at sample points, it changes the first step by 5.7e-10, and the measured order is still 4 (error ratios 24.5, 21.3, 19.1, 17.7 toward 16 at T=2, and 8.1, 12.6, 14.5, 15.3 at T=2.5). But it is not the method the page describes. A reader opening the "Julia source" to see how the fourth derivative is obtained will find a different technique. The exact expression is short: y'''' = (3t⁴y − 15t³y^{2/3} + 18t²y^{5/3} + 22t²y^{1/3} − 39t·y^{4/3} − 10t + 27y^{7/3} + 18y) / (27·y^{8/3}).
- **Evidence:** `/usr/bin/python3 indep.py` (sympy total derivatives); `julia d4check.jl <pagedir>`. The finite difference against the exact value: at (0,1), 1.6666631 against 1.6666667; at (3, 0.09), −18.37611 against −18.37598.
- **Suggested fix:** Replace line 24 with the analytic y'''' above, written with `cbrt` like the other derivatives. Or keep the finite difference and say so in the script comment and in the Case 2 text.

- **Independent check:** confirmed with correction. Checker: the forward difference contradicts only line 12 (line 18 describes the fully analytic order-3 script); it changes the trajectory by ≤6.3e-7 through t=4 — no visible effect.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `taylorderivativeaa.jl` | yes | 3.5 | taylorderivativeaa.gif |
| `taylorderivativebb.jl` | yes | 3.5 | taylorderivativebb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | IVP "$y' = 1 - t\sqrt[3]{y}$, $y(0)=1$" | aa:17-18, 26; bb:11, 28 | confirmed |
| 2 | 12 | "over $[0,5]$" | `T = 5.0`, xlims (0,5) in both | confirmed |
| 3 | 12 | "shows the **Taylor series solution trace**" for the IVP | values after t≈3.25 are a numerical instability, not the solution | wrong (→ F1) |
| 4 | 12 | "Each frame adds one new solution point" | 21 frames = n+1; frame 1 shows only (0,1); each later frame extends the line by one node (contact sheets, frames 1, 18, 21) | confirmed |
| 5 | 12 | "uses the ODE to compute higher derivatives analytically" | true for aa; bb's y'''' is a finite difference | wrong for Case 2 (→ F4) |
| 6 | 12 | "$y_{n+1} = y_n + hy'_n + \frac{h^2}{2}y''_n + \cdots$" | aa:23, bb:25 | confirmed |
| 7 | 12 | "local accuracy of $O(h^{p+1})$ for order $p$" | global error ratios ≈8 (p=3) and →16 (p=4), so local error is p+1 | confirmed |
| 8 | 14 | Julia scripts "linked under each case" | lines 20, 28 | confirmed |
| 9 | 16 | Case 1 "Taylor Order 3", same IVP | aa: three-term Taylor step; title "(n=3)" | confirmed |
| 10 | 18 | "With order $p=3$, three derivative terms are used per step" | aa:23 uses y', y'', y''' | confirmed |
| 11 | 18 | "The local truncation error is $O(h^4)$" | step-halving global ratio 8.02, so local O(h⁴) | confirmed |
| 12 | 18 | "matching RK4 in order" | RK4 is 4th order; this method is 3rd | wrong (→ F3) |
| 13 | 18 | "requires explicit symbolic derivatives of the ODE right-hand side" | aa: y'', y''' match sympy exactly. As a statement about Case 2's code it fails (F4) | confirmed for Case 1; see F4 |
| 14 | 20 | "[Julia source](taylorderivativeaa.jl)" is Case 1 | aa is order 3 and produces taylorderivativeaa.gif (manifest) | confirmed |
| 15 | 22 | alt: "numerical solution trace builds from left to right … each frame adds one Taylor order-3 step" | frames | confirmed |
| 16 | 24 | Case 2 "Taylor Order 4", same IVP | bb: four-term step (4th term by finite difference) | confirmed (method caveat F4) |
| 17 | 26 | "four derivative terms are used per step" | bb:25 uses d1..d4 | confirmed (d4 not analytic, F4) |
| 18 | 26 | "The local truncation error is $O(h^5)$" | global ratios 17.7 (T=2) and 15.3 (T=2.5) at h=1/64, tending to 16 | confirmed |
| 19 | 26 | "slightly better accuracy than order 3" | 10–500× better for t ≤ 2.75; far worse for t ≥ 4.5 | wrong (→ F2) |
| 20 | 26 | "with the same step size $h=0.25$" | both scripts: (5−0)/20 = 0.25 | confirmed |
| 21 | 28 | "[Julia source](taylorderivativebb.jl)" is Case 2 | bb is order 4 and produces taylorderivativebb.gif | confirmed |
| 22 | 30 | alt: "trace builds from left to right … each frame adds one Taylor order-4 step" | frames; but in frames 18–21 the new points fall off-plot (y<0) | confirmed (display issue covered in F1) |

## Implementation checks

### taylorderivativeaa.jl
- **Method:** Third-order Taylor method, y_{n+1} = y + h y' + h²/2 y'' + h³/6 y''' (line 23), with analytic total derivatives. sympy's total derivatives D_t + f·D_y of f = 1 − t y^{1/3} agree exactly with the hand-coded y'' and y''' (`indep.py`: both differences simplify to 0). This is the method named.
- **Numbers:** My independent order-3 Taylor in mpmath (30 digits, sympy derivatives) reproduces every script node to 12 significant digits. For example, at t=0.25 the script gives 1.2170138888888888 and mine gives 1.217013888889. At t=2 it is 0.85865425187298 against 0.858654251873, and at t=4.25 it is 1.21616373829520 against 1.216163738295. Step halving with the script's own `taylor3_step` gives error ratios at T=2 of 8.20, 8.10, 8.05, 8.02, and at T=2.5 of 8.40, 8.21, 8.10, 8.05, so the method is third order. The values themselves are correct for the method. The problem is the step size and interval (F1).
- **Reference values:** The script draws no reference curve. My reference comes from solve_ivp Radau (rtol 1e-13, atol 1e-15/1e-16) and is cross-checked with LSODA (rtol 1e-12): the two agree to about 6e-12. It starts at y(0)=1. The ODE residual of the dense output, measured by a central difference, is ≤ 3.8e-6, which is limited by the interpolant and the differencing. For large t the reference behaves like 1/t³ (y(5)=0.008120 against 1/125=0.008). No closed form is available.
- **Picture:** I looked at the contact sheet and frames 1, 18 and 21. The line plus marker at the current node is built from `ts[1:frame]` and `ys[1:frame]`. The annotation "t=… y≈…" is the current node rounded to 4 digits, and the readable values match the computed ones (frame 18: t=4.25, y≈1.2162; frame 21: t=5.0, y≈0.0895). The spike at t=4.25 is drawn faithfully; it is a numerical artefact presented without comment (F1). The title text renders the braces literally ("y^{1/3}") and uses "n=3" for the order while the code's `n` is the step count; both are cosmetic. Fragility, not a finding: `y^(1/3)` (line 17) would throw a DomainError if y ever went negative, and here it does not (minimum y = 0.0068).

### taylorderivativebb.jl
- **Method:** "Order-4 Taylor" with analytic y', y'', y''' (identical formulas to aa, written with `cbrt`; `cbrt(y)^(-5)` = y^{-5/3}, so this is correct). y'''' is a forward-difference directional derivative of y''' along (1, f) with step h·1e-5 (lines 23-24). This is a legitimate hybrid, but not the pure analytic Taylor method the page describes (F4).
- **Numbers:** My order-4 Taylor with the exact sympy y'''' agrees with the script to about 1e-9 while y > 0. At t=0.25 the script gives 1.2172851556773 and mine gives 1.2172851562500. At t=2 it is 0.85959837859867 against 0.8595983788446, and at t=4.25 it is −0.046491864 against −0.046527334, where amplification is already large. My version stops at y ≤ 0 because the real-valued y^{1/3} is undefined in my symbolic form; the script's `cbrt` continues to −10.45 and onward. The finite-difference d4 has relative error 1e-7 to 2e-5 (`d4check.jl`). Step halving with the script's own `taylor4_step` gives error ratios at T=2 of 24.5, 21.3, 19.1, 17.7, and at T=2.5 of 8.1, 12.6, 14.5, 15.3. Both sequences tend to 16, so the method is fourth order.
- **Reference values:** None drawn; same reference as above.
- **Picture:** I looked at the contact sheet and frames 1, 18 and 21. The construction is the same as aa. The annotations match the computed values (frame 18: y≈-0.0465; frame 21: y≈-5.2675). With `ylims=(0,1.8)` the trace exits below the axis at about t=4.05, and the marker for frames 18–21 is outside the plot. A viewer sees the curve simply stop near t=4 unless they read the annotation, which hides a divergence of order 10 (part of F1).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/taylor-series-method-for-odes/`](evidence/taylor-series-method-for-odes/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
