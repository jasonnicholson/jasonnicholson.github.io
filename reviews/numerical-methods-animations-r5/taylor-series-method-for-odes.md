# Taylor Series Method for ODE's — animation review (round 5)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every claim in the Animations section against computed evidence (ledger below), and every one is confirmed. Both implementations are correct, and their reference values are accurate to about 1e-17.

Two observations that I judged **not** to be findings:

- **(Fidelity, not a finding.)** For order 3 at m = 12 and 14, and for order 4 at m = 12 to 28, the page's runs differ from Mathews' frames. For example, order 3 at m = 12 gives y(5) = -4.4676549 on the page and 0.1766603 in Mathews' frame. The page says so explicitly, gives the reason (the runs go negative and the page uses the real cube root), and states that Mathews' treatment of negative y "has not been reproduced". I tried three plausible alternatives in `variants.py`: |y|^(1/3), the principal complex root carried through as complex y, and the real part taken after each step. None reproduces Mathews' numbers. For example, order 3 at m = 12 gives 0.2698, -0.0898-1.81i and 0.3679, against Mathews' 0.1766603. The page's disclosure is accurate, and the real-cube-root choice is mathematically sound because the exact solution never goes negative.
- The page says "Just above h=0.0609 the shading covers only the last steps (m=80: from t≈4.96)". For m = 80 (order 3) and m = 70 (order 4), the shaded region actually starts inside the final step: last nodes 4.9375 and 4.857, onsets 4.9577 and 4.9082. "The last steps" is loose wording, but a reader would not take away anything false.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 12.5 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 8.9 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `taylorderivativeaa.gif` | 21 | byte-identical | taylorderivativeaa |
| `taylorderivativebb.gif` | 21 | byte-identical | taylorderivativebb |

### Page references

- Scripts linked: `taylorderivativeaa.jl`, `taylorderivativebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

The true values below come from my own computation. "Script" means the instrumented copy, which agrees with my independent float64 implementation to a relative difference of ≤ 3.7e-10 at every node of every run. The largest differences occur in the blown-up runs; in stable runs the difference is ~1e-15.

### Introduction

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| I1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | confirmed | scripts lines 13/19 (aa), 13 (bb); `T=5.0`, `y0=1.0` |
| I2 | Each frame is a complete Taylor-method run with $m$ subintervals ($h=5/m$) | confirmed | `taylor3(m)` / `taylor4(m)` are called per frame, with `h=(T-t0)/m` |
| I3 | 21 values of Mathews' animations, $m=12,14,\dots,150$ (list) | confirmed | the `ms` array matches the page list; Mathews' GIF frames show exactly these 21 values (one or two frames each); committed GIFs have 21 frames |
| I4 | drawn over a fine-step reference solution | confirmed | reference = the same Taylor method with 50 000 steps; script `yex5 = 8.119920464867961e-3` vs mpmath 0.0081199204648679610 |
| I5 | labelled with the computed $y(5)$ and its error | confirmed | annotate lines 95–96 / 104–105; frames show these |
| I6 | Computed points below $y=-0.3$ are marked by triangles on the bottom edge | confirmed | `scatter!` at `ylims[1]` with `:dtriangle`; frame 1 (aa, m=12) shows triangles at t=4.58 and 5.00, the two nodes < -0.3 (values -8.597 and -4.468) |
| I7 | the run's true minimum is printed | confirmed | `min y = -8.597 at t ≈ 4.58` (aa m=12) matches computed min -8.597 at 4.583 |
| I8 | $\sqrt[3]{y}$ is the real cube root | confirmed | `cbrt` is used throughout both scripts |
| I9 | truncated Taylor series $y_{n+1} = y_n + hy'_n + \frac{h^2}{2}y''_n + \cdots$ | confirmed | step functions lines 22 (aa) and 31 (bb) |
| I10 | local accuracy $O(h^{p+1})$ for order $p$ | confirmed (theory) | consistent with the global orders observed below |

### Case 1 (order 3)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: order 3, same IVP, $m=12$ to $150$ | confirmed | `taylor3`, `ms` |
| C1.2 | three derivative terms are used per step | confirmed | yd1, yd2, yd3 |
| C1.3 | local error $O(h^4)$, global $O(h^3)$ | confirmed | script routine, error at t=2, m=100→200→400→800: ratios 8.04, 8.02, 8.01 |
| C1.4 | reference rises to about 1.4498 near t=0.88 | confirmed | mpmath peak y=1.449766696 at t=0.8835558 |
| C1.5 | decays to $y(5)=0.0081199$ | confirmed | 0.0081199205 |
| C1.6 | For m=12 through 36 the curve visibly leaves the reference in the tail | confirmed | max node errors: 8.61, 109, 0.582, 0.126, 1.20, 0.048, 0.151, 0.152, 0.029 (m=36: bump at t=4.86 is visible in frame 9); none of these runs decreases monotonically after its peak |
| C1.7 | ends at $y(5)\approx-4.47$ for m=12 | confirmed | -4.4676549 |
| C1.8 | $-109$ for m=14 | confirmed | -109.0749263 |
| C1.9 | m=20: 0.0068 at t=4, 1.22 at t=4.25, ends at 0.0895 | confirmed | 0.00680, 1.21616, 0.0895215 |
| C1.10 | From m=40 on, each run decreases steadily after its peak | confirmed | `np.all(diff<0)` after the argmax is True for m=40…150 |
| C1.11 | …and stays within $3\times10^{-4}$ of the reference at every node | confirmed | max node error 2.50e-4 (m=40), decreasing thereafter |
| C1.12 | m=100: largest node error $1.3\times10^{-5}$ | confirmed | 1.33e-5 |
| C1.13 | m=100: error in y(5) is $-1.2\times10^{-9}$ | confirmed | -1.19e-9 (frame shows -1.2e-09) |
| C1.14 | $\partial f/\partial y=-t/(3y^{2/3})$ | confirmed | the derivative of $1-t y^{1/3}$ |
| C1.15 | reaches $-41.3$ at $t=5$ | confirmed | -41.2554 (mpmath); its largest magnitude on [0,5] is at t=5 |
| C1.16 | threshold $h\approx0.0609$, $m\le82$; here m=12 to 80 | confirmed | 2.51275/41.2554 = 0.060907; at m=82, h·\|f_y\| at t=5 exceeds the limit by +0.0028; at m=83 it falls short by -0.027 |
| C1.17 | order-3 stability limit 2.513 | confirmed | real root of R(z)=-1: z=-2.5127453 (sympy), script 2.5127453266 |
| C1.18 | on $y'=\lambda y$ the method amplifies errors once $h\|\lambda\|$ exceeds the limit | confirmed | R is monotone increasing, so \|R\|>1 for z<-2.5127 |
| C1.19 | For m=12 to 48 the error at t=5 exceeds the error at the last node before the shaded region | confirmed | holds for all of 12…48 (e.g. m=48: 4.66e-7 vs 9.19e-8); fails from m=52 on, which the page does not claim |
| C1.20 | m=80: shading from t≈4.96 | confirmed | onset 4.9577 (mpmath), 4.9578 (script) |
| C1.21 | for m=52 to 80 the error in y(5) stays below $3.1\times10^{-9}$ | confirmed | largest 3.09e-9 (m=56) |
| C1.22 | at m=12 the shading starts at t≈3.07 | confirmed | 3.0663 |
| C1.23 | For m=90 to 150, $h\|f_y\|$ stays below 2.513 up to t=5 | confirmed | no onset for m≥83 |
| C1.24 | Mathews' printed y(5) reproduced to every printed digit for 19 of 21 m | confirmed | all of m=16…150 match the 7-decimal values (m=44 "0.00816" = 0.0081600) |
| C1.25 | exceptions m=12 and 14, whose runs go negative before t=5 | confirmed | first negative node at 4.17 and 4.64; m=24 and 28 go negative only at t=5 and still match |
| C1.26 | Mathews' frame shows $y(5)=0.1766603$ at m=12 | confirmed | Mathews `Tayloraa.gif` frames 4–5 |
| C1.27 | Mathews' negative-y treatment not reproduced | confirmed (as a statement) | three variants tried, none matches (see Findings) |
| C1.28 | Source link `taylorderivativeaa.jl` and embed `taylorderivativeaa.gif` are this case | confirmed | the script is order 3; GIF title "Taylor order 3" |
| C1.29 | Alt: reference peaks near 1.45 at t≈0.88, decays to 0.0081 | confirmed | as in C1.4–C1.5 |
| C1.30 | Alt: drops off the bottom for m=12 and 14 (only) | confirmed | only these two order-3 runs have nodes < -0.3 |
| C1.31 | Alt: spiking to 1.22 at m=20 | confirmed | 1.21616 |
| C1.32 | Alt: shaded for m=12 to 80 | confirmed | onset exists for exactly these |
| C1.33 | Alt: from m=40 on the run lies on the reference; y(5)=0.0081199 at m=150 | confirmed | max node error ≤2.5e-4; y(5)=0.0081199 |

### Case 2 (order 4)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: order 4, same IVP, $m=12$ to $150$ | confirmed | `taylor4`, `ms` |
| C2.2 | four derivative terms, all computed analytically | confirmed | yd1–yd4; yd4 is the simplified rational form, and sympy confirms script yd4 − (true y'''') = 0 |
| C2.3 | local $O(h^5)$, global $O(h^4)$ | confirmed | error at t=2, m=100→…→800: ratios 18.5, 17.4, 16.7 (→16) |
| C2.4 | For m=12 through 32 the curve leaves the reference in the tail and goes negative | confirmed | first negative node: 4.17, 3.93, 3.75, 4.44, 4.25, 4.58, 4.82, 5.00 |
| C2.5 | the exact solution stays positive | confirmed | at y=0, y'=1>0, so y cannot cross 0; mpmath y(5)=0.00812>0 |
| C2.6 | $y(5)\approx-7666$ for m=16 | confirmed | -7665.8734 |
| C2.7 | m=20: negative at t=4.25, about -10.4 at t=4.5, ends at -5.25 | confirmed | -0.0465 at 4.25, -10.434 at 4.5, -5.2535 at 5 |
| C2.8 | $y(5)\approx-0.081$ for m=32 | confirmed | -0.0806510 |
| C2.9 | From m=36 on, within $2.7\times10^{-3}$ of the reference at every node | confirmed | largest 2.65e-3 (m=36) |
| C2.10 | m=36 and 40 turn up once near the end, by about 0.0015 and 0.0005 | confirmed | one rise each: +0.00148 (t 4.72→4.86) and +0.00055 (4.875→5.0); m≥44 decrease monotonically |
| C2.11 | too little to see | confirmed | frames 9 and 10 of bb show no visible departure |
| C2.12 | from m=40 on the error in y(5) falls at every refinement, to $4.8\times10^{-12}$ at m=150 | confirmed | 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.23e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12 |
| C2.13 | m=100 largest node error $8.0\times10^{-7}$ | confirmed | 8.02e-7 |
| C2.14 | more than 16 times smaller than the $1.3\times10^{-5}$ of order 3 | confirmed | 1.33e-5/8.02e-7 = 16.6 |
| C2.15 | threshold $h\approx0.0675$, $m\le74$; here m=12 to 70 | confirmed | 2.78529/41.2554 = 0.067513; at m=74, h·\|f_y\| at t=5 exceeds the limit by +0.0022; at m=75 it falls short by -0.035 |
| C2.16 | order-4 stability limit 2.785 | confirmed | real root of R(z)=1 in (-3,-2): -2.7852936 |
| C2.17 | for all of m=12 to 70 the error at t=5 exceeds the error at the last node before the shading | confirmed | holds for every m (closest: m=70, 7.16e-10 vs 5.50e-10) |
| C2.18 | m=70: shading from t≈4.91 | confirmed | 4.9082 |
| C2.19 | m=12: starts at t≈3.10 | confirmed | 3.1032 |
| C2.20 | m=80 to 150 stays below 2.785 | confirmed | no onset for m≥75 |
| C2.21 | Mathews' y(5) reproduced for m=32 to 150 | confirmed | all match to the printed digits (m=56 "0.00812" = 0.0081200) |
| C2.22 | m=12 to 28 go negative before t=5 and differ from Mathews | confirmed | see C2.4; values differ (e.g. m=16: -7665.87 vs -554.44545) |
| C2.23 | Mathews' $y(5)=0.0711898$ at m=20 | confirmed | `Taylorbb.gif` frames 9–10 |
| C2.24 | Source link `taylorderivativebb.jl` and embed `taylorderivativebb.gif` are this case | confirmed | the script is order 4; GIF title "Taylor order 4" |
| C2.25 | Alt: drops off the bottom for m=12 to 28 | confirmed | min y: -3.115, -0.738, -7751, -19.9, -10.4, -1505, -951 (all < -0.3); m=32 min -0.081 stays in window |
| C2.26 | Alt: as low as -7751 at m=16 | confirmed | -7751 at t=4.06 (frame 3 annotation) |
| C2.27 | Alt: shaded for m=12 to 70 | confirmed | onset exists for exactly these |
| C2.28 | Alt: from m=36 on the run lies on the reference; y(5)=0.0081199 at m=150 | confirmed | max node error ≤2.65e-3, invisible at this scale (frame 9) |

The page has no Description section with formulas beyond the introduction's series. Its other sections are placeholders or the legacy inventory and were not reviewed, as the brief instructs.

---

### 3. Implementation checks

### `taylorderivativeaa.jl` (Taylor order 3)

- **The method it claims to be.** It is the plain Taylor series method of order 3: each step computes y', y'' and y''' as total derivatives along the ODE and adds the first three terms of the series. It is not a Runge–Kutta method and not a lower-order simplification.
- **The numbers.**
  - Derivatives: sympy shows script `yd2` − d/dt(f) = 0 and script `yd3` − d/dt(y'') = 0, both taken along y' = f. The header comments on lines 13–15 state the same formulas.
  - Runs: I implemented Taylor 3 independently (derivatives from sympy in terms of c = ∛y, so they are valid for negative y with the real cube root). For all 21 m it agrees with the script at every node to a relative difference of ≤ 2.7e-10, and ≤ 1e-14 in stable runs.
  - Convergence: run through the script's own routine, the error at t=2 for m = 100, 200, 400 and 800 is -7.19e-6, -8.95e-7, -1.12e-7, -1.39e-8, giving ratios 8.04, 8.02, 8.01. That is third order.
- **The reference values.**
  - `yex5` = 0.008119920464867961 agrees with mpmath `odefun` (30 digits), 0.0081199204648679610, to every printed digit.
  - Reference peak: script 1.44976669 at t=0.8836 (grid); mpmath 1.4497666959 at 0.8835558.
  - Stability limit: the script's bisection gives 2.5127453266. sympy's real root of R(z) = -1 is -2.5127453266. The bracket comment on line 52 (\|R(-3)\|=2>1, \|R(-2)\|=0.333<1) is correct, and the root is unique because R is monotone.
  - Shading onset: the script uses its reference solution on a 1e-4 grid; my mpmath root-finding gives the same value to ≤1e-4 (m=12: 3.0663 vs 3.0664; m=80: 4.9577 vs 4.9578).
- **The picture.**
  - Frames 1, 2, 5, 6, 9 and 21 (m = 12, 14, 20, 24, 36, 150), plus the contact sheet: the title shows the correct order, m and h. The y(5) and error labels equal the computed values. The shaded span starts at the computed onset. Triangles sit at exactly the nodes below -0.3. The "min y" line matches argmin.
  - Display devices: the plot window is fixed at y ∈ [-0.3, 1.8] and the line runs off the bottom edge for m = 12 and 14. Because the true minimum and true y(5) are printed, this does not mislead.

### `taylorderivativebb.jl` (Taylor order 4)

- **The method it claims to be.** It is the plain Taylor series method of order 4 (four analytic derivatives, four series terms).
- **The numbers.**
  - Derivatives: `yd1`–`yd3` are identical to the order-3 versions and verified as above. For `yd4`, sympy shows that the script's simplified rational form in c minus the true fourth total derivative is 0.
  - Runs: the independent Taylor 4 run agrees with the script at every node of all 21 runs to a relative difference of ≤ 3.7e-10.
  - Convergence: run through the script's own routine, the error at t=2 for m = 100, 200, 400 and 800 is 7.06e-9, 3.81e-10, 2.19e-11, 1.31e-12, giving ratios 18.5, 17.4, 16.7 and tending to 16. That is fourth order.
- **The reference values.**
  - The reference is the order-4 run with 50 000 steps; `yex5` is identical to the order-3 reference value and to mpmath.
  - Stability limit: the script gives 2.7852935634; sympy's root of R(z) = 1 in (-3,-2) is -2.7852935634. The bracket comment is correct (R(-3)=1.375, R(-2)=0.333), and the root is unique there because R decreases on (-∞, -1.596).
  - Onsets match mpmath: m=12 3.1032 vs 3.1033; m=70 4.9082 vs 4.9083.
- **The picture.**
  - Frames 2, 8, 9 and 10 (m = 14, 32, 36, 40), plus the contact sheet: the labels, shading, triangles and min annotations all match the computed values.
  - For example, m=14 shows a triangle at t=3.93 with "min y = -0.7376 at t ≈ 3.93", which matches the computed value. m=16 shows "min y = -7751 at t ≈ 4.06", also matching.

