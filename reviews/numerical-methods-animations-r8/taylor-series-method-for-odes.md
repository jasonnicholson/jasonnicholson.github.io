# Taylor Series Method for ODE's — animation review (round 8)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**; 1 refuted and dropped.

## Findings

None.

## Refuted by the independent check (dropped)

- F1. Page match / Fidelity, Minor. The stated "Sign rule" does not reproduce Mathews' negative-run values — **refuted** by the independent check: the checker implemented Mathews' program from the archive with his derivative formulas as he wrote them (multiplied through by powers of y^(1/3)) and the rule Sign(y)|y|^(k/3) for every k. That reproduces all 21 printed y(5) values at order 3 and all 21 at order 4, including 0.1766603 (order 3, m = 12) and −3.4636068 (order 3, m = 14). The reviewer had applied the rule to un-multiplied forms with denominators 3y^(2/3), 9y^(5/3) and 27y^(8/3), and that reading does not reproduce his values. The page's sentences are true.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 12.5 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 11.0 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key:
- **I** = `indep.out` (independent Python: sympy-derived derivatives, own Taylor stepper, DOP853 reference with rtol 1e-13, cross-checked against mpmath `odefun` at 30 digits).
- **X** = `extra.py` output.
- **F** = committed frames.
- **S** = script source.
- **L** = legacy frames.

### Introduction (Animations section)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| 1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | confirmed | S lines 11–27; matches L titles |
| 2 | Each frame is a complete Taylor run with m subintervals, $h=5/m$ | confirmed | S `taylor3(m)`/`taylor4(m)`; F titles "h = 5/m" |
| 3 | 21 values of Mathews' animations, $m=12,14,\dots,150$ (list) | confirmed | S `ms`; L order-3 and order-4 frames show exactly this list |
| 4 | Drawn over a fine-step reference, labelled with computed y(5) and its error | confirmed | S lines 45–47, 95–96; F |
| 5 | Points below y = −0.3 marked by triangles on the bottom edge; the true minimum is printed | confirmed | S lines 74, 87–102; F order-3 m=12/14, order-4 m=12–28 (the min is printed only when a node is off scale) |
| 6 | Real cube root, so negative runs stay real | confirmed | S uses `cbrt` |
| 7 | Uses analytic higher derivatives and a truncated Taylor series; local $O(h^{p+1})$ | confirmed | S derivative formulas match sympy exactly (differences 0 for y'', y''', y''''); local order is standard |
| 8 | Julia source linked under each case | confirmed | page links aa.jl and bb.jl |

### Case 1 (order 3, `taylorderivativeaa`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 9 | Heading: order 3, same IVP, m = 12 to 150 | confirmed | S, F |
| 10 | Three derivative terms per step | confirmed | S line 22 |
| 11 | Local $O(h^4)$, global $O(h^3)$ | confirmed | I: max node error 1.33e-5 at m=100 and 3.81e-6 at m=150 (ratio 3.49 vs 1.5³ = 3.38); y(5) error 1.19e-9 and 3.71e-10 (ratio 3.21) |
| 12 | Reference rises to ≈1.4498 near t = 0.88 | confirmed | I: max 1.449767 at t = 0.88355 |
| 13 | Reference y(5) = 0.0081199 | confirmed | I: DOP853 0.00811992046487, mpmath 0.00811992046487 |
| 14 | m = 12 to 36 visibly leaves the reference in the tail | confirmed | I: max node error 8.6, 109, 0.58, 0.13, 1.20, 0.048, 0.15, 0.15, 0.029 for m = 12…36; F shows a visible bump even at m=36 |
| 15 | y(5) ≈ −4.47 (m=12), −109 (m=14) | confirmed | I: −4.4676549, −109.0749263; F the same |
| 16 | m=20: 0.0068 at t=4, then 1.22 at t=4.25, ends 0.0895 | confirmed | X: 0.00680, 1.21616, 0.0895215 |
| 17 | From m=40 on, decreases steadily after the peak | confirmed | I: monotone after the peak for every m ≥ 40; not monotone at m=36 |
| 18 | From m=40 on, within 3e-4 of the reference at every node | confirmed | I: max 2.50e-4 (m=40), then smaller |
| 19 | m=100: largest node error 1.3e-5, error in y(5) −1.2e-9 | confirmed | I: 1.33e-5, −1.19e-9; F −1.2e-09 |
| 20 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5 | confirmed | I: −41.2554 |
| 21 | Threshold h ≈ 0.0609 (m ≤ 82; here m=12 to 80) | confirmed | I: h* = 0.06091, m* = 82.09 |
| 22 | Order-3 stability limit 2.513 | confirmed | I: brentq on \|R(z)\| = 1 gives 2.512745 |
| 23 | Amplifies once h\|λ\| exceeds the limit (on y' = λy) | confirmed | definition of the real-axis stability interval |
| 24 | For m=12 to 48, error at t=5 exceeds error at the last node before shading | confirmed | I: e.g. m=48: 4.66e-7 vs 9.19e-8; m=52: 1.06e-9 < 6.04e-8, so the cutoff at 48 is right |
| 25 | m=80: shading from t ≈ 4.96, inside the final step (starts 4.9375); every step contracts | confirmed | I: onset 4.958; X: last step factors −0.618, −0.741, −0.879 (all \|·\| < 1) |
| 26 | At least one amplifying step for each m from 12 to 77 | confirmed | X: m with an amplifying step (\|dΦ/dy\| > 1 at the reference) = 12…77, contiguous; none for 78–90 |
| 27 | m=52 to 80: \|error in y(5)\| < 3.1e-9 | confirmed | I: max 3.09e-9 (m=56) |
| 28 | m=12 shading starts t ≈ 3.07 | confirmed | I: 3.066; F "≈ 3.07" |
| 29 | m=90 to 150: below 2.513 up to t=5 | confirmed | I: onset None |
| 30 | Mathews' y(5) reproduced to every printed digit for 19 of 21; exceptions m=12 and 14, which go negative before t=5 | confirmed | I vs L: m=16…150 all match (e.g. −0.0401212, −0.0212395, 0.0251901, 0.0083511, 0.00816); m=12/14 first negative at t = 4.17 and 4.64 |
| 31 | Mathews m=12 shows 0.1766603 | confirmed | L frame 4 |
| 32 | Mechanism: Sign(y)\|y\|^{k/3} for all k; applying it reproduces all 21 | wrong (as tested) | F1 |
| 33 | Alt text: peak near 1.45 at t ≈ 0.88; decays to 0.0081 | confirmed | I |
| 34 | Alt text: off the bottom for m=12 and 14 | confirmed | I: min −8.6, −109; m=24/28 minima −0.040/−0.021 stay in view |
| 35 | Alt text: spike to 1.22 at m=20 | confirmed | X 1.21616 |
| 36 | Alt text: shading for m=12 to 80 (m=80 only part of the final step) | confirmed | I, F |
| 37 | Alt text: from m=40 on the run lies on the reference; y(5) = 0.0081199 at m=150 | confirmed | I, F |
| 38 | Link/embed: aa.jl / aa.gif is the order-3 case | confirmed | S title "Taylor order 3"; F |

### Case 2 (order 4, `taylorderivativebb`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 39 | Heading: order 4, same IVP, m = 12 to 150 | confirmed | S, F |
| 40 | Four analytic derivative terms | confirmed | S; y'''' polynomial form matches sympy exactly |
| 41 | Local $O(h^5)$, global $O(h^4)$ | confirmed | I: max node error 8.02e-7 (m=100) and 1.50e-7 (m=150), ratio 5.35 vs 1.5⁴ = 5.06 |
| 42 | m=12 through 32 leaves the reference and goes negative; exact solution stays positive | confirmed | I: first negative t = 4.17, 3.93, 3.75, 4.44, 4.25, 4.58, 4.82, 5.0; reference min 0.00812 |
| 43 | y(5) ≈ −7666 (m=16) | confirmed | I: −7665.8734 |
| 44 | m=20: negative at t=4.25, ≈ −10.4 at t=4.5, y(5) ≈ −5.25 | confirmed | I: first negative 4.25, min −10.4341 at 4.5, y(5) −5.2535 |
| 45 | y(5) ≈ −0.081 (m=32) | confirmed | I: −0.0806510 |
| 46 | From m=36 on, within 2.7e-3 at every node | confirmed | I: 2.65e-3 (m=36), 1.36e-3 (m=40), then smaller |
| 47 | m=36 and 40 turn up once near the end, by ≈ 0.0015 and 0.0005 | confirmed | X: one increase each, +0.00148 (t = 4.861) and +0.00055 (t = 5) |
| 48 | From m=40 on, error in y(5) falls at every refinement, to 4.8e-12 at m=150 | confirmed | I: 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.23e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12 |
| 49 | m=100: largest node error 8.0e-7, more than 16× smaller than 1.3e-5 | confirmed | I: 8.02e-7; ratio 16.6 |
| 50 | Threshold h ≈ 0.0675 (m ≤ 74; here 12 to 70); limit 2.785 | confirmed | I: h* = 0.06751, m* = 74.06; limit 2.785294 |
| 51 | m=12 to 60: steps that genuinely amplify; error at t=5 exceeds error at the last node before shading | confirmed | X: amplifying-step m range 12…68 contiguous; I: e.g. m=60: 8.23e-9 vs 1.97e-9 |
| 52 | m=70: shading from t ≈ 4.91, one step start (t ≈ 4.93), error factor 0.92, no amplifying step | confirmed | I: onset 4.908; X: factor at 4.9286 = 0.9234; no \|factor\| > 1 |
| 53 | m=70: rise from 5.5e-10 at t ≈ 4.86 to 7.2e-10 at t=5 | confirmed | I: 5.50e-10 at 4.857, 7.16e-10 at 5 |
| 54 | m=12 shading starts t ≈ 3.10 | confirmed | I: 3.103 |
| 55 | m=80 to 150 below 2.785 up to t=5 | confirmed | I: onset None |
| 56 | Mathews reproduced for m=32 to 150; m=12 to 28 go negative before t=5 | confirmed | I vs L: −0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201, 0.00812, 0.0081199 all match; m=12–28 differ |
| 57 | Mathews m=20 shows 0.0711898 | confirmed | L |
| 58 | The same rule (also on y^{8/3}) reproduces all 21 order-4 values | wrong (as tested) | F1 |
| 59 | Alt text: off the bottom for m=12 to 28, as low as −7751 at m=16 | confirmed | I: min −7750.73 at t = 4.0625; m=32 min −0.081 stays in view |
| 60 | Alt text: shading m=12 to 70; from m=36 on the run lies on the reference; y(5) = 0.0081199 at m=150 | confirmed | I, F |
| 61 | Link/embed: bb.jl / bb.gif is the order-4 case | confirmed | S, F |

### Fidelity

| # | Item | Verdict | Evidence |
|---|---|---|---|
| 62 | Same ODE, interval, orders (3 and 4) and m sequence as Mathews' two animations | confirmed | L |
| 63 | Departure for negative runs (m=12,14 order 3; m=12–28 order 4) is disclosed and mathematically justified | confirmed | real-cube-root derivatives are the correct ones; only the stated mechanism is wrong (F1) |

### 3. Implementation checks

### `taylorderivativeaa.jl` (order 3)
- **Method:** a true order-3 Taylor series step, $y+hy'+\tfrac{h^2}{2}y''+\tfrac{h^3}{6}y'''$. The derivatives are total derivatives along y' = f, written in terms of c = cbrt(y). Sympy (`indep.py`) derives them independently via $D g = g_t + g_c f/(3c^2)$, and `simplify(script − mine)` is 0 for y'' and y'''. The formulas hold for negative y with the real cube root, because $d(\mathrm{cbrt}\,y)/dy = 1/(3c^2)$ for all y ≠ 0.
- **Numbers:** my independent stepper reproduces every frame's printed y(5) to all printed digits. Examples:

  | m | script frame | independent |
  |---|---|---|
  | 12 | −4.4676549 | −4.4676549 |
  | 14 | −109.0749263 | −109.0749263 |
  | 20 | 0.0895215 | 0.0895215 |
  | 28 | −0.0212395 | −0.0212395 |
  | 44 | 0.0081600 | 0.0081600 |
  | 150 | 0.0081199 | 0.0081199 |

  The frame errors agree with my DOP853-based errors (−1.2e-9 vs −1.19e-9 at m=100; −3.7e-10 vs −3.71e-10 at m=150). The convergence-rate check is in ledger #11.
- **Reference:** the script uses order-3 Taylor with 50,000 steps. The frames print reference y(5) = 0.0081199, and the error labels agree with my reference to two significant figures down to 1e-10, so the script's reference is accurate to well below 1e-11. DOP853 (rtol 1e-13) and mpmath odefun (30 digits) agree: y(5) = 0.00811992046487.
- **Picture:**
  - Frames 1, 2, 3, 5, 6, 8, 10, 13, 16, 17, 19 and 21 inspected (contact sheet plus individual frames).
  - The shaded span starts at the onset computed from the reference grid. The legend states the threshold 2.513.
  - Off-scale nodes are drawn as triangles at −0.3, with the true min annotated (−8.597 at m=12, −109.1 at m=14).
  - The red endpoint dot is suppressed when y(5) is off scale.
  - No node exceeds the top limit of 1.8 (max node over all runs 1.4497).
  - Title, legend and m all agree with the code.

### `taylorderivativebb.jl` (order 4)
- **Method:** a true order-4 Taylor step. y'''' is written as a polynomial over $27c^8$, and sympy confirms it equals the total derivative of y''' (difference 0).
- **Numbers:** examples of frame y(5) against my independent stepper:

  | m | script frame | independent |
  |---|---|---|
  | 12 | −0.5365789 | −0.5365789 |
  | 14 | 0.1879762 | 0.1879762 |
  | 16 | −7665.8734003 | −7665.8734003 |
  | 20 | −5.2535013 | −5.2535013 |
  | 28 | −951.4473378 | −951.4473382 |

  The m=28 values differ by 4e-7, which is relative 4e-10 in a divergent run. Frame mins match too (−3.115, −7751, −10.43, −951.4). m=150 error is +4.8e-12 in both. The convergence-rate check is in ledger #41.
- **Reference:** order-4 Taylor with 50,000 steps. It agrees with DOP853 and mpmath, as shown by error labels down to 4.8e-12 matching my 4.76e-12.
- **Picture:** frames 1, 2, 3, 5, 7, 8, 9, 11, 13, 15, 17, 19 and 21 inspected. Shading is consistent with the computed onsets (3.10, 3.16, 3.22, 3.34, 3.65, 3.81, 3.95, …). Off-scale triangles and min annotations are correct. No misleading clamping: every off-scale value is reported numerically in the frame.

### Stability-limit computation (both scripts)
The scripts bisect $|R(z)|=1$ on [−3, −2], giving 2.5127 and 2.7853. I computed 2.512745 and 2.785294 independently with brentq.

