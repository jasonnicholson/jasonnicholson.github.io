# Euler's Method for ODE's — animation review (round 8)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames, at the precision it is stated to. Both implementations are the methods they claim to be, and the reference solution is accurate to about 12 digits.

Counts: Error 0, Misleading 0, Minor 0.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 13.0 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 14.4 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `eulersmethodaa.gif` | 20 | byte-identical | eulersmethodaa |
| `eulersmethodbb.gif` | 21 | byte-identical | eulersmethodbb |

### Page references

- Scripts linked: `eulersmethodaa.jl`, `eulersmethodbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | `eulersmethodaa.jl` l.28 is exactly this | confirmed |
| D2 | Euler local truncation error $O(h^2)$, global error $O(h)$; accuracy improves linearly | My max nodal error at m=400/800/1600/3200 is 8.378e-3, 4.181e-3, 2.089e-3, 1.044e-3, ratios 2.004, 2.002, 2.001 | confirmed |
| D3 | "Mathews' modified Euler method is the explicit midpoint method" $y_{n+1}=y_n+h f(t_n+h/2, y_n+\frac h2 f(t_n,y_n))$ | `eulersmethodbb.jl` l.30 is this formula. Mathews' printed MEuler values match the midpoint values for all 21 m in MEuleraa.gif and for m=40, 100, 150 in Example 12 (m=40 gives 0.0761463 in both). Heun's method at m=40 gives 0.2506, so Mathews' MEuler is not Heun | confirmed |
| D4 | Midpoint global accuracy $O(h^2)$ | My midpoint max error at m=400..3200 is 2.068e-5, 5.052e-6, 1.249e-6, 3.104e-7, ratios 4.09, 4.05, 4.02 | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on $0\le t\le5$ | Both scripts l.12/14–17; Mathews Example 11/12 header image gr_228/gr_250 | confirmed |
| I2 | Each frame is a complete run with m subintervals, $h=5/m$ | The `@animate for m in ms` loop calls `euler(m)` / `meuler(m)` with h=(T−t0)/m | confirmed |
| I3 | m values are those of Mathews' animation | Euleraa.gif labels: 10,15,20,25,30,35,40,45,50,55,60,70,80,90,100,110,120,130,140,150. MEuleraa.gif: 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150. Both equal the script `ms` | confirmed |
| I4 | Gray reference is fixed-step RK4 with 50 000 steps | Script l.49 `rk4(50_000)`. Its y(5)=0.008119920465 equals DOP853 0.008119920465 and Radau 0.008119920465 | confirmed |
| I5 | Each frame is labelled with computed y(5), error at t=5, largest error at any grid point | Code l.94–96 and the frames | confirmed |
| I6 | Light red band where $h|\partial f/\partial y|$ along the reference exceeds the stability limit | `onset(h)` scans the reference grid and `vspan!([ton,T])`. Along the reference $|f_y|$ increases strictly on [0,5] (my check found no non-increasing step on a 5e5-point grid), so [onset, 5] is exactly that region | confirmed |
| I7 | Mathews' Euleraa.gif / MEuleraa.gif "sweep m in the same way; every y(5) printed in them agrees with the runs here when rounded to seven decimals" | All 20 Euler and 21 MEuler printed y(5) values equal mine to 7 decimals, e.g. m=35 −0.002737 vs −0.0027370, MEuler m=80 0.008372 vs 0.0083720, m=16 1.1185921 vs 1.1185921 | confirmed |
| I8 | Examples 11 and 12 print runs m=40, 100, 150 and their final values agree with this page's frames | Ex 11: −0.0174406, 0.00811736, 0.00811821; mine −0.017440619, 0.008117365, 0.008118205. Ex 12: 0.0761463, 0.00813852, 0.00812174; mine 0.076146277, 0.008138516, 0.008121739 | confirmed |

### Case 1 (forward Euler)

| # | Claim | Evidence (mine / script) | Verdict |
|---|---|---|---|
| C1.1 | Heading: forward Euler, same IVP, m = 10 to 150 | Script `ms`, `euler` | confirmed |
| C1.2 | 20 values listed | 20 frames, list equals `ms` | confirmed |
| C1.3 | Reference rises to about 1.4498 near t=0.88 | Max 1.449767 at t=0.88356 | confirmed |
| C1.4 | Then decays toward nullcline $y=1/t^3$ (where $y'=0$) | $1-t y^{1/3}=0 \iff y=t^{-3}$; at t=5, $t^{-3}=0.008$ and y=0.00812 | confirmed |
| C1.5 | Reaches y(5)=0.0081199 | 0.0081199205 | confirmed |
| C1.6 | m=10 to 40 zig-zag in the tail and dip below zero; exact solution stays positive | Negative nodes per run: 2, 3, 3, 2, 3, 3, 2 for m=10..40. Minimum of the reference is 8.12e-3; f(t,0)=1>0, so y cannot cross 0 | confirmed |
| C1.7 | End at y(5)≈1.777 (m=10), 0.391 (m=30), −0.0174 (m=40) | 1.7774834, 0.3907263, −0.0174406 | confirmed |
| C1.8 | m=40 is the first of Example 11's runs (40, 100, 150) | Archive gr_229, gr_236, gr_243 code show n=40, 100, 150 | confirmed |
| C1.9 | At m=45 the last steps still alternate by less than 0.009, too little to see | Last three increments +0.00022, −0.00327, +0.00852. Frame 8 shows no visible zig-zag | confirmed |
| C1.10 | From m=50 on runs decrease steadily after their peak | No positive increment after the peak for any m ≥ 50 | confirmed |
| C1.11 | Error at t=5: −4.2e-6 (m=60), −1.7e-6 (m=150), where y(5)≈0.0081182 | −4.22e-6, −1.72e-6, 0.0081182 | confirmed |
| C1.12 | From m=55 on the error at t=5 is more than 10^4 times smaller than the max error | Ratios 1.48e4, 1.35e4, 1.34e4, 1.34e4, 1.33e4, 1.32e4, …, 1.31e4 (m=55..150) | confirmed |
| C1.13 | For m=45 to 150 the max error is between t=1.64 and 1.73, after the peak, with the run above the reference | Locations 1.67, 1.70, 1.73, 1.67, 1.64, 1.69, 1.67, 1.65, 1.68, 1.67, 1.65, 1.68, 1.67. Sign + in every run | confirmed |
| C1.14 | The max error falls at every refinement | 1.769, 1.017, 0.714, 0.544, 0.383, 0.329, 0.223, 0.0766, 0.0687, 0.0622, 0.0570, 0.0486, 0.0425, 0.0377, 0.0339, 0.0307, 0.0282, 0.0260, 0.0241, 0.0225 | confirmed |
| C1.15 | From m=45 it about halves when m doubles: 5.7e-2 (60), 2.8e-2 (120), 2.2e-2 (150) | 45→90 2.03, 50→100 2.03, 60→120 2.02, 70→140 2.02. Values 5.698e-2, 2.816e-2, 2.247e-2 | confirmed |
| C1.16 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t=5 | −41.2554 | confirmed |
| C1.17 | Steps longer than about h=0.0485 (m≤103; here m=10..100) exceed limit 2 before t=5 (shaded) | h_crit = 2/41.2554 = 0.048478, m_crit = 103.14. Shaded in frames m=10..100 and absent for 110..150 | confirmed |
| C1.18 | Euler stability limit 2; error multiplied by about $1+h f_y<-1$ with alternating sign | $|1+z|\le1 \iff -2\le z\le0$; linearization of the Euler step | confirmed |
| C1.19 | For m=10 to 40 the error grows to more than 25 times the reference solution | max |e|/y_ref = 218, 125, 88, 67, 47.1, 37, 25.4 | confirmed |
| C1.20 | At m=25 the step from t=4.2 takes the error from +0.429 to −0.009 | e(4.2)=+0.4292, e(4.4)=−0.0093 | confirmed |
| C1.21 | At m=10 the onset is t≈2.92 | 2.92272 (script and mine) | confirmed |
| C1.22 | For m=10 to 45 the error at t=5 is larger than just before onset | |e5| vs |e at last node before onset|: 1.77/0.258, 1.02/0.024, 0.71/0.019, 0.54/0.022, 0.38/2.9e-4, 1.1e-2/5.2e-4, 2.6e-2/6.5e-5, 7.1e-3/8.1e-5 | confirmed |
| C1.23 | For m=50 to 100 the onset goes from t≈3.95 to t≈4.95 | 3.9503, 4.0732, 4.1893, 4.4042, 4.6003, 4.7812, 4.9495 | confirmed |
| C1.24 | m=50..100 decrease steadily, and the error at t=5 is smaller than just before onset | Monotone after peak. 2.1e-5<4.7e-5, 4.2e-6<3.3e-5, 4.2e-6<2.1e-5, 3.6e-6<1.2e-5, 3.2e-6<7.0e-6, 2.8e-6<4.2e-6, 2.6e-6<3.0e-6 | confirmed |
| C1.25 | m=110 to 150 stay below 2 up to t=5 | onset none; frames say "h·|∂f/∂y| < 2 up to t = 5" | confirmed |
| C1.26 | Source link `eulersmethodaa.jl` and embed `eulersmethodaa.gif` are this case | Script title and frames read "Euler's method" | confirmed |
| C1.27 | Alt text: reference peaks near 1.45 at t≈0.88 and ends at 0.0081. m=10..40 zig-zag below zero, y(5)=1.777 at m=10. Band for m=10..100. Steady from m=50. y(5)=0.0081182 at m=150. Labels −1.7e-06 and 2.2e-02, largest near t=1.67 | Same evidence as above. Frame 20 shows exactly these labels | confirmed |

### Case 2 (modified Euler = midpoint)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: modified Euler (midpoint), same IVP, m = 12 to 150 | Script | confirmed |
| C2.2 | 21 values listed, same reference | 21 frames, list equals `ms`, same `rk4(50_000)` | confirmed |
| C2.3 | m=12 to 24 tails zig-zag | Alternating increments in the tail for m=12, 14, 16, 18, 20, 24, e.g. m=12: +0.012, +0.758, −0.748, +1.271, −1.224 | confirmed |
| C2.4 | At m=24 only the last three steps alternate (+0.069, −0.076, +0.489), ending at y(5)≈0.613 | All increments from t=3.542 are positive up to 4.583. The last three are +0.06921, −0.07552, +0.48895. y(5)=0.6126681 | confirmed |
| C2.5 | m=28 to 60 turn upward before t=5 | Positive increments run from the minimum to t=5 for m=28..60 | confirmed |
| C2.6 | At m=28 there is one small dip of 0.0075 in the second-to-last step | Increment −0.00754 at 4.643→4.821, and it is the only negative one after the minimum | confirmed |
| C2.7 | Rise from minimum 0.35 (m=28), 0.057 (m=40), 0.015 (m=60) | 0.35007, 0.05716, 0.01500 | confirmed |
| C2.8 | End at y(5)≈0.384, 0.0761, 0.0259; m=40 is the first of Example 12's runs | 0.3841123, 0.0761463, 0.0259429; archive gr_251 code n=40 | confirmed |
| C2.9 | At m=70 the upturn is only 0.0008; from m=80 the runs decrease steadily after the peak | Rise 0.00076; m=80..150 have no positive increment after the peak | confirmed |
| C2.10 | From m=16 the error at t=5 falls at every refinement, to 2.5e-4 (m=80) and 1.8e-6 (m=150), y(5)≈0.0081217 | 1.11, 0.945, 0.806, 0.605, 0.376, 0.127, 0.089, 0.068, 0.0548, 0.0439, 0.0350, 0.0285, 0.0178, 2.02e-3, 2.52e-4, 5.40e-5, 1.86e-5, 5.14e-6, 1.82e-6; y(5)=0.0081217 | confirmed |
| C2.11 | For m=16 to 70 the error at t=5 is the largest error of the run | argmax at t=5.00 for m=16..70 | confirmed |
| C2.12 | From m=80 it is 2.5 to 87 times smaller than the max error, which lies between t=3.19 and 3.22: 6.3e-4 (m=80), 1.6e-4 (m=150) | Ratios 2.49, 8.91, 20.6, 49.8, 87.4. Locations 3.19, 3.22, 3.20, 3.21, 3.20. Values 6.27e-4, 1.59e-4 | confirmed |
| C2.13 | m=80→150 the max error falls by 3.9, close to (150/80)^2≈3.5; Euler's falls by 1.9≈150/80 | 6.2747e-4/1.5891e-4 = 3.95; (1.875)^2 = 3.52; Euler 4.2485e-2/2.2473e-2 = 1.89; 1.875 | confirmed |
| C2.14 | At m=150 it is about 140 times smaller than Euler's 2.2e-2, although the errors at t=5 are about the same size | 2.2473e-2/1.5891e-4 = 141; e5 −1.72e-6 vs +1.82e-6 | confirmed |
| C2.15 | Amplification factor $1+z+z^2/2$ has $|R|\le1$ on the negative real axis exactly for $-2\le z\le0$, so the limit is 2 | R(0)=R(−2)=1, min R(−1)=1/2, R>1 outside [−2,0] | confirmed |
| C2.16 | For m≤103 (here 12..100) shaded from t≈2.99 (m=12) to t≈4.95 (m=100) | 2.98684, 4.94947; band in frames m=12..100 and absent for 120, 150 | confirmed |
| C2.17 | For each of m=12..100 the error at t=5 is larger than just before onset | e.g. m=12 0.188 vs 4.6e-3; m=80 2.5e-4 vs 3.0e-5; m=90 5.4e-5 vs 2.2e-5; m=100 1.86e-5 vs 1.39e-5; every m holds | confirmed |
| C2.18 | m=120, 150 stay below 2 up to t=5 | onset none | confirmed |
| C2.19 | Link `eulersmethodbb.jl` and embed `eulersmethodbb.gif` are this case | Script title and frames read "Modified Euler (midpoint)" | confirmed |
| C2.20 | Alt text: zig-zag m=12..24 (m=24 only last three steps). Upturn m=28..60, y(5)=0.0761 at m=40. Band m=12..100. Steady from m=80. y(5)=0.0081217. Labels +1.8e-06, 1.6e-04 near t=3.20 | Same evidence; frame 21 shows these labels | confirmed |

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler)
- **The method it claims to be:** yes. Line 28 is the plain forward Euler step, and `cbrt` is the real cube root, matching Mathews' `Sign[y] Abs[y]^(1/3)`. Halving h halves the error, so the method is first order (D2).
- **The numbers are right:** yes. The instrumented script output (`instr_aa.jl`) and my independent loop agree on every frame quantity for all 20 m. Examples:

  | m | script y(5) | mine y(5) | script err5 / max (t) | mine err5 / max (t) | onset script / mine |
  |---|---|---|---|---|---|
  | 10 | 1.7774834 | 1.7774834 | +1.8e0 / 1.8e0 (5.00) | +1.769 / 1.769 (5.00) | 2.92 / 2.9227 |
  | 40 | −0.0174406 | −0.0174406 | −2.6e-2 / 2.2e-1 (4.88) | −2.56e-2 / 2.232e-1 (4.88) | 3.68 / 3.6805 |
  | 60 | 0.0081157 | 0.0081157 | −4.2e-6 / 5.7e-2 (1.67) | −4.22e-6 / 5.698e-2 (1.67) | 4.19 / 4.1893 |
  | 150 | 0.0081182 | 0.0081182 | −1.7e-6 / 2.2e-2 (1.67) | −1.72e-6 / 2.247e-2 (1.67) | none / none |

  All 20 values also match Mathews' Euleraa.gif to 7 decimals.
- **The reference values are right:** yes. The 50 000-step RK4 gives y(5)=0.008119920465, and DOP853 (rtol 1e-13) and Radau both give 0.008119920465. The nodal reference `refnodes` uses at least 50 000 steps and lands on the run's nodes. Its errors agree with my DOP853-based errors to the printed precision, even where the error is only 1.7e-6. y>0 holds along the reference, so cbrt is well-behaved.
- **The picture shows what was computed:** yes. I viewed the contact sheet and frames 1 (m=10), 8 (m=45) and 20. The magenta polyline is the run, the red dot is (5, y(5)), the gray curve is the reference, and the band runs from the onset to 5. Every run lies inside the window (−0.55, 1.9), which the script asserts. Titles and legends name the right method and m. The window is not clamped and nothing is masked.

### `eulersmethodbb.jl` (modified Euler = explicit midpoint)
- **The method it claims to be:** yes. Line 30 is the explicit midpoint step. It reproduces Mathews' MEuler outputs (all 21 animation values and Example 12), while Heun's method gives different values (0.2506 vs 0.0761 at m=40). Halving h quarters the error, so the method is second order (D4).
- **The numbers are right:** yes. The script and my computation agree for all 21 m. Examples:

  | m | script y(5) | mine | script err5 / max (t) | mine | onset |
  |---|---|---|---|---|---|
  | 12 | 0.1958729 | 0.1958729 | +1.9e-1 / 1.4e0 (4.58) | +1.88e-1 / 1.4095 (4.58) | 2.99 / 2.9868 |
  | 40 | 0.0761463 | 0.0761463 | +6.8e-2 / 6.8e-2 (5.00) | same | 3.68 |
  | 80 | 0.0083720 | 0.0083720 | +2.5e-4 / 6.3e-4 (3.19) | +2.52e-4 / 6.27e-4 (3.19) | 4.60 |
  | 150 | 0.0081217 | 0.0081217 | +1.8e-6 / 1.6e-4 (3.20) | +1.82e-6 / 1.589e-4 (3.20) | none |

- **The reference values are right:** the same reference as Case 1, verified as above.
- **The picture shows what was computed:** yes. I viewed the contact sheet and frames 6 (m=24) and 21 (m=150). The m=24 frame shows the monotone rise followed by the three alternating last steps. The window holds every value (min 0.0081217, max 1.4497, as the comment says).

### Fidelity to the legacy archive
Both legacy animations (Euleraa, MEuleraa) are reproduced with the same IVP and the same m sequences, and every printed y(5) agrees. The other module examples (1–10) are non-animated worked examples and fall outside the Animations section. No fidelity departures found.

