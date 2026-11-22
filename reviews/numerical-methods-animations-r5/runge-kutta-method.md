# Runge-Kutta Method — animation review (round 5)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every checkable claim in the Animations section, the alt text, the script header and comments, and the frame labels agrees with independent computation (see the ledger). One claim is true only under one of two standard ways of splitting the error. I explain it under ledger entry B17. I judged that it does not need a finding.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 12.6 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttaaa.gif` | 21 | byte-identical | rungekuttaaa |

### Page references

- Scripts linked: `rungekuttaaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Reference values used below: y(5) = 0.00811992046486796 (mpmath odefun, 30 digits) = 0.008119920464867977 (DOP853). The script's own reference `yex5 = 0.008119920464868` (RK4, 50 000 steps) agrees to about 1e-17.

### Intro paragraph

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | script l.11–14: `f = 1 - t*cbrt(y)`, `t0,y0 = 0,1`, `T = 5`; legacy frames show the same ODE | confirmed |
| I2 | Each frame is a complete RK4 run with $m$ subintervals, $h=5/m$ | script l.21–35 and l.62–63; frame titles "m = …, h = 5/m" | confirmed |
| I3 | 21 values of Mathews' animation, m = 12, 14, …, 120, 150 (list) | script l.15 matches the list; 21 GIF frames; the legacy GIF's "Using m = …" labels (36 frames incl. a blank first frame and repeats) give exactly the same 21 values in the same order | confirmed |
| I4 | drawn over a fine-step reference solution | l.38: RK4 with 50 000 steps, gray curve in every frame; agrees with mpmath to ~1e-17 at t=5 | confirmed |
| I5 | labelled with the computed y(5) and its error | frame annotations "y(5) = …", "error = …" (l.83–84); values match the instrumented output | confirmed |
| I6 | RK4 computes four slopes $k_1..k_4$ and takes a weighted average | l.28–32: classical RK4 (1,2,2,1)/6 with stages at t, t+h/2, t+h/2, t+h | confirmed |
| I7 | for smooth f: $O(h^5)$ local, $O(h^4)$ global | standard; numerically, error ratios on halving h are 15.85, 15.96 on y'=−2ty (smooth) and 30.3, 20.4, 18.1, 17.1 → 16 for this IVP at m = 100…1600 (`order.py`) | confirmed |
| I8 | f not smooth at y=0, $\partial f/\partial y=-t/(3y^{2/3})$ unbounded | direct differentiation | confirmed |
| I9 | the coarser runs evaluate it at negative y | RK4 stage values < 0 occur for m = 12…52 (see B19) | confirmed |
| I10 | Julia source scripts linked under each case | `[Julia source](rungekuttaaa.jl)` exists in folder | confirmed |

### Case 1 heading

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| H1 | RK4 step-refinement sweep, same IVP, m = 12 to 150 | script l.15 | confirmed |

### Behavior paragraph

| # | Claim | Independent value | Verdict |
|---|---|---|---|
| B1 | reference rises from y(0)=1 to about 1.4498 near t=0.88 | peak where f=0: t = 0.883556, y = 1.449767 | confirmed |
| B2 | then decays toward the nullcline $y=1/t^3$ (where $y'=0$) | f=0 ⇔ t y^{1/3}=1 ⇔ y=1/t³; for t > peak, y − 1/t³ > 0 throughout (minimum 1.199e-4, reached at t=5) so y'<0 and the solution approaches the nullcline from above | confirmed |
| B3 | reaches y(5)=0.0081199 | 0.00811992046 | confirmed |
| B4 | m=12 through 52 visibly turn upward before t=5 | upward steps after the peak: m=12:5, 14:5, 16:5, 18:6, 20:6, 24:6, 28:6, 32:6, 36:5, 40:5, 44:4, 48:3, 52:2; frames 1–13 show it (m=52 rise of 0.028 is small but visible as the red end dot lifts off the gray curve, frame_013) | confirmed |
| B5 | y(5)≈0.588 (m=12), 0.289 (m=20), 0.0377 (m=52) | 0.5883471, 0.2891074, 0.0376958 | confirmed |
| B6 | m=56 still turns upward on the last step, by $8.1\times10^{-4}$, too little to see | only upward step after peak is the last one, rise = +8.053e-4; frame_014 shows no visible upturn | confirmed |
| B7 | m=56 ends at y(5)≈0.0099 | 0.0098571 | confirmed |
| B8 | error in y(5) falls at every refinement in the sweep | \|err\| strictly decreasing over all 20 consecutive pairs (`indep.py` column "dec" all True) | confirmed |
| B9 | 3.4e-4 at m=60, 2.8e-5 at m=70, 6.8e-6 at m=80, 1.8e-7 at m=150 | 3.431e-4, 2.765e-5, 6.805e-6, 1.757e-7 | confirmed |
| B10 | at m=150 y(5)≈0.0081201 | 0.0081200962 | confirmed |
| B11 | along the reference, ∂f/∂y reaches −41.3 at t=5 | −41.2554; \|f_y\| along reference is maximal at t=5 | confirmed |
| B12 | RK4 linear stability limit 2.785 | real root of \|R(z)\|=1, R = 1+z+z²/2+z³/6+z⁴/24: z = −2.785294 (brentq) | confirmed |
| B13 | steps longer than about h=0.0675 (m≤74; here 12 to 70) exceed it on the reference before t=5 | h* = 2.785294/41.2554 = 0.067513, 5/h* = 74.06; onset exists for m=12…70 and not for m=80 | confirmed |
| B14 | shaded region in those frames | `vspan!` from onset to 5 drawn in frames 1–16 (m=12…70), absent in frames 17–21 | confirmed |
| B15 | m=70: from t≈4.91; m=12: from t≈3.10 | onset 4.908 and 3.103 (mine), 4.9083 and 3.1033 (script) | confirmed |
| B16 | m=80 to 150 stay below 2.785 up to t=5 | max h\|f_y\| on reference = 5/m·41.255 ≤ 2.578 < 2.785 | confirmed |
| B17a | m=12 to 24: the run's own h\|∂f/∂y\| at its grid values stays below 2.42 | max over grid values: 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 | confirmed |
| B17b | m=12 to 18: upturn begins with one long step starting before the shaded region (t≈2.92 to 3.33 for m=12) | first upward step after peak: m=12 2.917→3.333 (onset 3.103); m=14 2.857→3.214 (3.162); m=16 3.125→3.438 (3.219); m=18 3.056→3.333 (3.278) | confirmed |
| B17c | 94 to 100% of the error just after it (0.168 for m=12) is that step's own truncation error | e after step for m=12 = 0.1681. Local error measured by stepping RK4 from the reference point, as a fraction of the error after the step: 0.996, 0.999, 0.937, 0.980 for m=12, 14, 16, 18 → range 94–100% | confirmed (see note) |
| B17d | m=20 to 56: error after the first upward step is mostly carried error, which that step multiplies by 2.9 to 18.6 | [Φ(y_i)−Φ(Y_i)] as a fraction of e_{i+1}: 0.80, 0.985, 0.966, 0.984, 0.997, 0.970, 0.983, 0.988, 0.990, 0.990; multiplier [Φ(y_i)−Φ(Y_i)]/e_i = 5.01, 6.93, **2.91**, 5.66, **18.57**, 3.57, 4.06, 4.24, 4.06, 3.65 → range 2.9–18.6 | confirmed (see note) |
| B18 | m=60 and 70: bound crossed but the run does not turn upward | no upward step after the peak for either; last-step change −2.27e-4 and −3.57e-4 | confirmed |
| B19 | the size of the upturns depends on how ∛y is taken for y<0; in every run from m=12 to 52 and no other, some stage falls below 0 (as low as −1.15) | negative stages exist for exactly m=12…52; global minimum −1.1542 (m=12) | confirmed |
| B20 | first negative stage is always $y_i+k_3$; in the first upward step for m=12–24 and 36, the step after it for m=28, 32, 40–52 | first negative (step, stage) vs first upward step: 12 (7,k4-arg) / 7; 14 8/8; 16 10/10; 18 11/11; 20 13/13; 24 17/17; 28 22/21; 32 27/26; 36 31/31; 40 36/35; 44 41/40; 48 46/45; 52 51/50; always stage index 3 (y+k3) | confirmed |
| B21 | the script takes the real cube root, so f = 1 + t\|y\|^{1/3} > 1 there | l.11 uses `cbrt`, which is the real cube root; for y<0, −t·cbrt(y) = +t\|y\|^{1/3} | confirmed |
| B22 | as Mathews' printed y(5) values show he did | all 21 legacy labels (0.5883471, 0.4685529, 0.3876236, 0.3316264, 0.2891074, 0.2274383, 0.1108585, 0.1082442, 0.0834665, 0.0698482, 0.0604713, 0.0538504, 0.0376958, 0.0098571, 0.008463, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201) equal the real-cbrt values to every printed digit; the max(y,0) variant gives different values (e.g. −0.2392 for m=12) | confirmed |
| B23 | with ∛max(y,0), summed upward steps after the peak shrink in each of these runs (0.46→0 for m=12, 0.028→0.012 for m=52) | shrinks for every m=12…52 (e.g. 0.4597→0, 0.3650→0, 0.4148→0.0013, …, 0.02795→0.01153) | confirmed |
| B24 | and y(5) becomes −0.239 (m=12), 0.0054 (m=20), 0.021 (m=52) | −0.2392, +0.0054, +0.0213 | confirmed |
| B25 | the m=56 run has no negative stage, so its last-step rise is the same either way | min stage +0.0048; both variants give y(5)=0.0099, rise 0.0008 | confirmed |

**Note on B17c/B17d.** The split into "own truncation error" and "carried error" depends on which standard decomposition is used. The page's numbers come out exactly under the textbook global-error recurrence, which this review calls decomposition B: e_{i+1} = [Φ(y_i) − Φ(Y(t_i))] + [Φ(Y(t_i)) − Y(t_{i+1})]. The first bracket is the earlier error carried by the RK4 map. The second is the local truncation error of a step started on the true solution. Under the other common split, decomposition A, the earlier error is carried by the exact flow and the local error is measured from the computed point. There the carried part shrinks to 0.02–0.13 × e_i, because the ODE itself is strongly contractive there, and the step's own local error is ≥ 98.7% of e_{i+1} for every m from 12 to 56 (`indep2.py`). So under A the page's contrast between m≤18 and m≥20 would disappear. Decomposition B is the definition in Mathews and the usual intro texts, and it matches the page's sense of "that step multiplies" the carried error. I therefore count the claim as confirmed. If the owner wants to protect the sentence, he could add "(propagated by the RK4 step)".

### Image alt text

| # | Claim | Verdict |
|---|---|---|
| A1 | y' = 1 − t·y^(1/3), y(0)=1 on [0,5], each frame a complete run, m = 12 to 150 | confirmed |
| A2 | gray reference curve peaks near 1.45 at t ≈ 0.88, decays to 0.0081 at t=5 | confirmed (1.4498 at 0.8836; 0.00812) |
| A3 | m = 12 to 52 visibly turn upward; y(5) = 0.588 for m=12; at m=56 too small to see | confirmed (B4–B6; frames 1, 13, 14) |
| A4 | for m = 12 to 70 a shaded region marks where h·\|∂f/∂y\| on the reference exceeds 2.785 | confirmed (B14) |
| A5 | runs settle onto the reference as m grows; y(5)=0.0081201 at m=150 | confirmed (frames 15–21; 0.0081200962) |

### Wiring

| # | Claim | Verdict |
|---|---|---|
| W1 | `[Julia source](rungekuttaaa.jl)` is the case's script | confirmed (only script; produces this GIF) |
| W2 | embed `rungekuttaaa.gif` is that script's output | confirmed (manifest: byte-identical regeneration; frame titles show the heading's IVP and m list) |

### Script header / comments (claims in the code)

| # | Claim | Verdict |
|---|---|---|
| S1 | l.2–3: RK4 sweep, Mathews' sequence of m | confirmed |
| S2 | l.18: every grid value of every run lies in (min 0.0081, max 1.4498); stage values reach −1.15 | confirmed: grid min 0.0081201, max 1.4497506; stage min −1.1542. All inside ylims (−0.05, 1.8), so nothing is clipped |
| S3 | l.37: reference error far below plotting resolution | confirmed (agrees with mpmath to ~1e-17) |
| S4 | l.51: zlim = 2.7853 | confirmed (2.7852935634) |

There is no separate Description section with formulas. The only method description is the intro (I6–I7), and the script implements it.

---

### 3. Implementation checks: `rungekuttaaa.jl`

**It is the method it claims to be.** Lines 26–33 are classical 4-stage RK4: k1 = h f(t,y), k2 = h f(t+h/2, y+k1/2), k3 = h f(t+h/2, y+k2/2), k4 = h f(t+h, y+k3), y⁺ = y + (k1+2k2+2k3+k4)/6. To check this without relying on memory of the coefficients, I ran the same structure on y' = −2ty. Its errors at m = 10, 20, 40 were 1.63e-6, 1.03e-7, 6.41e-9, ratios 15.85 and 16.0, which is order 4. On this IVP the ratios approach 16 (30.3, 20.4, 18.1, 17.1 for m = 100→1600). The true solution stays ≥ 0.0081 > 0, so the asymptotic order is 4.

**The numbers are right.** I instrumented a copy (`inst/inst.jl`) and set its output beside my independent Python RK4 (`indep.py`):

| m | script y(5) | independent y(5) | script onset | independent onset |
|---|---|---|---|---|
| 12 | 0.5883470625 | 0.5883471 | 3.1033 | 3.103 |
| 20 | 0.2891074072 | 0.2891074 | 3.3417 | 3.342 |
| 52 | 0.0376958174 | 0.0376958 | 4.4532 | 4.453 |
| 56 | 0.0098570759 | 0.0098571 | 4.5622 | 4.562 |
| 60 | 0.0084629872 | 0.0084630 | 4.6663 | 4.666 |
| 70 | 0.0081475680 | 0.0081476 | 4.9083 | 4.908 |
| 80 | 0.0081267250 | 0.0081267 | none | none |
| 150 | 0.0081200962 | 0.0081201 | none | none |

All 21 runs agree. All 21 also equal Mathews' printed y(5) values to 7 digits (B22). The stability limit was found by bisection in the script and by brentq on \|R(z)\|=1 in my check, and both give 2.78529356.

**Its reference values are right.** The reference is RK4 with 50 000 steps. At t=5 it gives 0.008119920464868, against 0.00811992046486796 from mpmath `odefun` (Taylor series, 30 digits) and 0.008119920464867977 from DOP853 at rtol 1e-13. It satisfies y(0)=1. The peak at t=0.883556 satisfies f=0 there (the root of f(t, Y(t)) found with brentq). This is far more than accurate enough for errors printed to 2 significant figures down to 1.8e-7.

**The picture shows what was computed.** I viewed frames 1, 13, 14, 16 and 21 and the contact sheet (frames 1, 3, 5, …, 21):
- The magenta polyline with markers is (ts, ys) of the run, and the red dot is (5, ys[end]).
- The gray curve is the reference.
- The shaded span runs from the onset to 5, and the legend wording says the criterion is on the reference.
- The title names the right ODE, m and h.
- The annotations match the instrumented output: y(5) to 7 digits, error to 2 significant figures, reference y(5), and onset to 2 decimals.

Nothing is clipped or masked: all grid values are inside the y-limits, and stages are not drawn. There are 21 frames, one per m, in order.

**Fidelity to Mathews.** The ODE, initial value, interval, m sequence and printed y(5) values are identical to Mathews' animation. The page adds the reference curve, the error label and the stability shading. It drops only Mathews' blank first frame and his duplicated frames, which changes nothing a reader would conclude. There is no Fidelity finding.

