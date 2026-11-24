# Taylor Series Method for ODE's — animation review (round 9)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by independent computation (Python/sympy/mpmath/scipy) and by the frames. No Error, Misleading or Minor findings.

Note that is not a finding: the page has no `## Description` section, although `.github/agents/animation-page.agent.md` line 12 asks for one. The method formula is given in the Animations introduction instead. The review standard treats content the page does not yet have as out of scope, so this is recorded here only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 12.9 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 10.5 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Independent values come from `taylor.out`, `extra.out`, `extra2.out` and `mathews2.out`. The reference is mpmath `odefun` (dps 25–30) and scipy DOP853 (rtol 1e-13).

### Introduction

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | script lines 13, 26–27; Mathews ex. 11 formula image shows the same IVP | confirmed |
| I2 | each frame is a complete run with $m$ subintervals, $h=5/m$ | `taylor3(m)`/`taylor4(m)`; frame titles show `h = 5/m` | confirmed |
| I3 | 21 values $m=12,\dots,150$ (list), Mathews' values | script `ms`; the legacy GIFs show exactly these 21 values (frames 4–33 / 4–32, read in `legacy_*_labels.png`) | confirmed |
| I4 | drawn over a fine-step reference solution | 50 000-step same-order Taylor run; its y(5)=0.008119920464867961 vs mpmath 0.00811992046486796 | confirmed |
| I5 | labelled with computed y(5) and its error | annotate lines 95–96; frames | confirmed |
| I6 | points below y=−0.3 marked by triangles on bottom edge, true minimum printed | lines 74, 87–90, 99–102; aa frames 1–2, bb frames 1–7 | confirmed |
| I7 | ∛y is the real cube root | `cbrt` everywhere | confirmed |
| I8 | truncated Taylor series $y_{n+1}=y_n+hy'_n+\frac{h^2}{2}y''_n+\cdots$, local accuracy $O(h^{p+1})$ | one-step local error vs mpmath at t=3.5: ratios 15.50, 15.75 (order 3, →16) and 31.49, 31.75 (order 4, →32) (`extra2.out`) | confirmed |

### Case 1 (order 3)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | heading: order 3, m=12 to 150 | script | confirmed |
| A2 | three derivative terms per step | y', y'', y''' (line 22) | confirmed |
| A3 | LTE O(h⁴), global O(h³), same order as RK3 | local ratio ≈16; global max-node-error ratio m=100→200: 8.41, 150→300: 8.30 | confirmed |
| A4 | reference rises to about 1.4498 near t=0.88 | mpmath peak y=1.449766696 at t=0.8835558 | confirmed |
| A5 | reference y(5)=0.0081199 | 0.00811992046 | confirmed |
| A6 | m=12–36 visibly leaves the reference in the tail | max node errors 8.6, 109, 0.58, 0.13, 1.20, 0.048, 0.15, 0.15, 0.029 (m=36: a 0.030 blip at t=4.86 that is visible in frame 9) | confirmed |
| A7 | y(5)≈−4.47 at m=12, −109 at m=14 | −4.4676549, −109.0749263 | confirmed |
| A8 | m=20: 0.0068 at t=4 → 1.22 at t=4.25, ends 0.0895 | 0.00680, 1.21616, 0.0895215 | confirmed |
| A9 | from m=40 on: decreases steadily after the peak, within 3e-4 of the reference at every node | monotone after argmax for every m≥40; max node error m=40 2.50e-4, then smaller | confirmed |
| A10 | m=100: largest node error 1.3e-5, error in y(5) −1.2e-9 | 1.33e-5, −1.19e-9 | confirmed |
| A11 | ∂f/∂y=−t/(3y^{2/3}) reaches −41.3 at t=5 | −41.2554 | confirmed |
| A12 | threshold h≈0.0609 (m≤82; here m=12 to 80) | 2.51275/41.2554 = 0.060907 → m < 82.09 | confirmed |
| A13 | order-3 stability limit 2.513 | root of R(z)=−1: 2.512745 | confirmed |
| A14 | m=12–48: error at t=5 larger than at last node before the shaded region | True for every m in 12..48; False for 52..80 | confirmed |
| A15 | m=80: shading begins t≈4.96 inside the final step (starts 4.9375), every step contracts | onset 4.958; step starts in the shaded region: none; max |dΦ/dy| over steps 0.999 | confirmed |
| A16 | at least one step amplifies errors for each m 12–77 | number of steps with |dΦ/dy|>1 is ≥1 for every m in 12..77 and 0 for 78..90 (both along the computed run and along the reference) | confirmed |
| A17 | m=52–80: error in y(5) below 3.1e-9 | +1.06e-9, −3.09e-9, −2.93e-9, −2.40e-9, −1.92e-9 | confirmed |
| A18 | m=12 shading starts t≈3.07 | 3.066 (Python), 3.07 (script) | confirmed |
| A19 | m=90–150 stay below 2.513 up to t=5 | onset none (h ≤ 0.0556 < 0.0609) | confirmed |
| A20 | Mathews' y(5) reproduced to every printed digit for 19 of 21 m; exceptions m=12, 14 | legacy labels vs script: all 19 others match (e.g. 0.1563161, −0.0401212, 0.0251901, 0.00816, 0.0081204, 0.0081199) | confirmed |
| A21 | the m=12 and m=14 runs go negative before t=5 | first negative node t=4.167 (m=12), t=4.643 (m=14); m=24/28 are negative only at t=5 | confirmed |
| A22 | Mathews m=12 shows 0.1766603 | legacy frame 4 | confirmed |
| A23 | his program replaces y^{k/3} by Sign(y)|y|^{k/3} incl. even k, flipping y^{2/3}, y^{4/3} | Mathews ex. 11 code (`ex11_formulas.png`) shows exactly these ReplaceAll rules, with num/den multiplied by y^{1/3} | confirmed |
| A24 | applying his rule reproduces all 21 of his order-3 values | `mathews2.py`: 0.17666026, −3.4636068 (legacy −3.463?068, one digit hidden by the curve), and all others to the printed digits | confirmed |
| A25 | wiring: link `taylorderivativeaa.jl`, embed `taylorderivativeaa.gif` | script is order 3; manifest: GIF byte-identical to a fresh run | confirmed |
| A26 | alt text: gray reference peaks near 1.45 at t≈0.88, 0.0081 at t=5; m=12–36 leave; drop off for m=12,14; spike to 1.22 at m=20; shaded for m=12–80 (m=80 only part of the final step); from m=40 lies on the reference; y(5)=0.0081199 at m=150 | frames 1, 2, 5, 9, 17, 21 and numbers above; m=16–36 minimum ≥ −0.040, so only m=12 and 14 go off scale | confirmed |

### Case 2 (order 4)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | heading: order 4, m=12 to 150 | script | confirmed |
| B2 | four derivative terms, all analytic | yd1..yd4; sympy confirms yd4 equals the total derivative (difference simplifies to 0) | confirmed |
| B3 | LTE O(h⁵), global O(h⁴), same order as RK4 | local ratio ≈32; global ratios 17.5, 17.2 | confirmed |
| B4 | m=12–32 visibly leave and go negative; the exact solution stays positive | every m in 12..32 has a negative node (m=32 only at t=5: −0.0807); exact solution min 0.00812 > 0 | confirmed |
| B5 | y(5)≈−7666 at m=16 | −7665.8734 | confirmed |
| B6 | m=20 turns negative at t=4.25, about −10.4 at 4.5, ends −5.25 | first negative 4.25; −10.434 at 4.5; −5.2535 | confirmed |
| B7 | y(5)≈−0.081 at m=32 | −0.0806510 | confirmed |
| B8 | from m=36 on within 2.7e-3 at every node | m=36 2.65e-3, m=40 1.36e-3, smaller after | confirmed |
| B9 | m=36 and 40 turn up once near the end, by about 0.0015 and 0.0005 | the only post-peak increases are +0.00148 (t=4.86) and +0.00055 (t=5) | confirmed |
| B10 | from m=40 on the error in y(5) falls at every refinement, to 4.8e-12 at m=150 | 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.23e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12 | confirmed |
| B11 | m=100 largest node error 8.0e-7, >16× smaller than 1.3e-5 | 8.02e-7; ratio 16.6 | confirmed |
| B12 | threshold h≈0.0675 (m≤74; here m=12 to 70) | 2.785294/41.2554 = 0.067513 → m < 74.06 | confirmed |
| B13 | order-4 stability limit 2.785 | root of R(z)=1: 2.785294 | confirmed |
| B14 | m=12–60: steps that genuinely amplify; error at t=5 larger than at the last node before the shaded region | amplifying steps ≥2 for every listed m ≤60 (≥1 up to m=68); the comparison is True for all | confirmed |
| B15 | m=70: shading from t≈4.91 holds one step start (t≈4.93), error factor 0.92, no step amplifies | onset 4.908; only step start 4.9286; dΦ/dy=0.9234; 0 amplifying steps | confirmed |
| B16 | m=70 error rises from 5.5e-10 at t≈4.86 to 7.2e-10 at t=5 | mpmath: 5.501e-10 at 4.8571, 7.158e-10 at 5 | confirmed |
| B17 | m=12 shading starts t≈3.10 | 3.103 | confirmed |
| B18 | m=80–150 stay below 2.785 | onset none | confirmed |
| B19 | Mathews reproduced to every printed digit for m=32–150 | e.g. −0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201, 0.00812, 0.0081199 all match | confirmed |
| B20 | m=12–28 runs go negative before t=5 | first negative node 4.17, 3.93, 3.75, 4.44, 4.25, 4.58, 4.82 | confirmed |
| B21 | Mathews m=20 shows 0.0711898 | legacy bb frame 12 | confirmed |
| B22 | the same rule, also applied to y^{8/3}, reproduces all 21 order-4 values | `mathews2.out`: 0.49296784, 0.20269553, −554.44545, 0.066606581, 0.071189781, −39.08622, −21.680298, … all match; d4's numerator contains c^8 | confirmed |
| B23 | wiring: `taylorderivativebb.jl` / `.gif` | script is order 4; GIF byte-identical | confirmed |
| B24 | alt text: drops off bottom for m=12–28 (as low as −7751 at m=16); shaded for m=12–70; from m=36 lies on the reference; y(5)=0.0081199 at m=150 | min −7750.7 at m=16 (the lowest of any run); m=14 min −0.738 is off scale; m=32 min −0.081 is on scale; bb frames | confirmed |

### 3. Implementation checks

### `taylorderivativeaa.jl` (order-3 Taylor)

- **Method:** each step is the plain Taylor series of order 3 using y', y'', y''' as total derivatives along y'=f. There are no hybrid parts.
- **Derivatives:** sympy (`sym.py`), with y=c³ and D = ∂t + (1/(3c²))∂c·f, reproduces the script's yd2 and yd3 exactly (difference 0). The identities are rational in c, so they also hold for negative real c.
- **Numbers:** an independent Python implementation (derivatives obtained by sympy lambdify, not taken from the script) matches the instrumented script copy to every printed digit for all 21 m. For example m=12 −4.4676549, m=20 0.0895215, m=150 0.0081199 with error −3.7e-10 (script −3.7e-10, Python −3.71e-10). Order checks: local ratios 15.5/15.7 and global 8.4/8.3, which fit order 3.
- **Reference:** the 50 000-step order-3 run gives y(5)=0.008119920464867961. mpmath gives 0.00811992046486796 and scipy DOP853 gives 0.008119920464867977. The peak 1.4497667 at t=0.8836 matches mpmath's 1.449766696 at 0.88356. This is ample for every comparison on the page.
- **Stability limit:** bisection gives 2.5127453, the same as an independent root of 1+z+z²/2+z³/6=−1.
- **Picture:** frames 1, 2, 5, 9, 17 and 21 match the computed runs. The off-scale nodes are drawn as triangles at −0.3, and the true y(5) and minimum are printed, so clamping does not mislead. The shaded span starts at the computed onset. The title, legend and annotations name the right m and h.

### `taylorderivativebb.jl` (order-4 Taylor)

- **Method:** each step is the order-4 Taylor series with y'''' analytic.
- **Derivatives:** sympy shows the simplified yd4 equals the total derivative of yd3 (difference 0).
- **Numbers:** independent Python matches the instrumented script for all 21 m. For example m=16 −7665.8734003, m=20 −5.2535013, m=70 error +7.2e-10, m=150 +4.8e-12 (Python 4.76e-12). Order checks: local ratios 31.5/31.8 and global 17.5/17.2, which fit order 4.
- **Reference:** the same agreement with mpmath as for order 3 (to about 1e-17 at t=5).
- **Stability limit:** 2.7852936, matching an independent root of R₄(z)=1.
- **Picture:** frames 3, 9, 16 and the contact sheet match the computed runs. Off-scale handling is correct (m=12 shows y(5)=−0.54 as a triangle, with the printed value correct). The shading matches the onsets.

### Legacy fidelity

Mathews' two animations use the same IVP, interval, orders 3 and 4, and the same 21 values of m. The page reproduces his printed y(5) wherever his program evaluates true derivatives. Where it departs (order 3 at m=12 and 14; order 4 at m=12–28), the departure is for mathematical correctness: Mathews' Sign-rule derivatives are wrong for y<0. The page states this, and I verified it by reproducing all 42 of his values with his rule. No archive case is dropped. There is no fidelity finding.

