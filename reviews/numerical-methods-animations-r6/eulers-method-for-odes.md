# Euler's Method for ODE's — animation review (round 6)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding.

I checked every numerical and behavioural claim on the page against my own independent computation and against the frames, and each one holds at the precision stated. The ledger in Part 2 gives the evidence for each claim.

Two observations do not rise to findings:

- The red band's onset is computed along the *reference* solution, not along the run being plotted (`onset()`, aa.jl lines 63–68 and bb.jl lines 66–71). The page says only that the band "marks where h·|∂f/∂y| exceeds the method's stability limit". Measuring along the true solution is the standard linear-stability reading, and |∂f/∂y| along the reference increases monotonically after the peak (checked). So the band [onset, 5] is exactly the set where the condition holds. I do not consider it misleading.
- Case 2 says the max-error ratio of 3.9 is "close to (150/80)^2 ≈ 3.5". The numbers are right (3.949 and 3.516). How close counts as "close" is a judgement. A clean halving test gives ratios of 4.26, 4.13 and 4.06, which confirms second order.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 13.0 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 13.5 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Sources for verdicts:
- **I** = independent Python (`indep.out`)
- **S** = instrumented script output (`inst/*.out`)
- **F** = committed frames
- **A** = archive

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | aa.jl line 28 implements exactly this | confirmed |
| D2 | Euler local truncation error $O(h^2)$, global $O(h)$, "improves accuracy linearly" | I: max error at m = 150, 300, 600, 1200 = 2.247e-2, 1.118e-2, 5.578e-3, 2.786e-3 (ratios 2.01, 2.005, 2.002) | confirmed |
| D3 | "Mathews' modified Euler method is the explicit midpoint method", formula $y_n+h f(t_n+h/2, y_n+\tfrac h2 f(t_n,y_n))$ | A: algorithm image gr_40 and `MEuler` subroutine gr_42 show exactly this; bb.jl line 30 matches | confirmed |
| D4 | Midpoint global accuracy $O(h^2)$ | I: max error 1.589e-4, 3.733e-5, 9.050e-6, 2.228e-6 (ratios 4.26, 4.13, 4.06) | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | Both scripts, lines 12–15; A gr_228 shows the same IVP | confirmed |
| I2 | Each frame is a complete run with m subintervals, h = 5/m, for Mathews' m values | Code; F titles; A legacy frames list the same m (see I7) | confirmed |
| I3 | Gray reference = fixed-step RK4 with 50 000 steps | Code `rk4(50_000)`. Its accuracy: refchk max \|RK4−DOP853\| = 9.5e-13; yex5 = 0.0081199205 against mpmath 0.00811992046487 | confirmed |
| I4 | Frames labelled with computed y(5), error at t=5 and largest grid-point error | F: every frame shows all three, and S matches I | confirmed |
| I5 | Light red band marks where h\|∂f/∂y\| exceeds the stability limit | Code (along the reference; see note above). I: \|f_y\| is monotone along the reference after the peak, so [onset, 5] is exactly that set | confirmed |
| I6 | Mathews' `Euleraa.gif` and `MEuleraa.gif` are in the archive and sweep m the same way | A: both present; distinct non-blank frames are 20 and 21, with m lists identical to the scripts' | confirmed |
| I7 | "every y(5) printed in them agrees with the runs here when rounded to seven decimals" | All 41 legacy values read from the frames match I/S, e.g. Euler m=35: legacy −0.002737 vs −0.0027370; m=55 and m=60 both 0.0081157; MEuler m=16: 1.1185921; m=80: 0.008372 vs 0.0083720 | confirmed |
| I8 | Examples 11 and 12 print runs with m = 40, 100, 150, and their final values agree with the frames | A: Ex 11 gives −0.0174406, 0.00811736, 0.00811821; S gives −0.0174406187, 0.0081173646, 0.0081182053. Ex 12 gives 0.0761463, 0.00813852, 0.00812174; S gives 0.0761462774, 0.0081385159, 0.0081217390 | confirmed |

### Case 1 (forward Euler, eulersmethodaa)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading: forward Euler, same IVP, m = 10 to 150 | Code `ms`; F frame 1 shows m=10, frame 20 shows m=150 | confirmed |
| C1.2 | 20 values: 10, 15, …, 60, 70, …, 150 | `ms` has the 20 listed values; GIF has 20 frames (manifest) | confirmed |
| C1.3 | Reference peaks at about 1.4498 near t = 0.88 | I: 1.449767 at t = 0.8836 | confirmed |
| C1.4 | Decays toward the nullcline y = 1/t³ (y' = 0) | y' = 0 ⇔ t·y^{1/3} = 1. I: y(5) − 1/125 = 1.2e-4 > 0, approaching from above | confirmed |
| C1.5 | Reference y(5) = 0.0081199 | I: 0.0081199205 (mpmath 0.00811992046) | confirmed |
| C1.6 | m = 10 to 40 zig-zag in the tail and dip below zero; exact stays positive | I: minima −0.4624, −0.1702, −0.1315, −0.1163, −0.0322, −0.0452, −0.0174, all < 0; alternating increments in the tail (F frames 1–7). Reference minimum on [0,5] = 0.00812 > 0 | confirmed |
| C1.7 | y(5) ≈ 1.777 (m=10), 0.391 (m=30), −0.0174 (m=40) | S/I: 1.7774834, 0.3907263, −0.0174406 | confirmed |
| C1.8 | m = 40 is the first of Example 11's runs | A gr_229: n = 40 | confirmed |
| C1.9 | At m = 45 the last steps alternate by less than 0.009, too little to see | I: last increments −0.00112, +0.00022, −0.00327, +0.00852. F frame 8: not visible | confirmed |
| C1.10 | From m = 50 on, runs decrease steadily after their peak | I: strictly decreasing after argmax for every m ≥ 50 | confirmed |
| C1.11 | Error at t=5: −4.2e-6 (m=60), −1.7e-6 (m=150); y(5) ≈ 0.0081182 at m=150 | S: −4.223e-6, −1.715e-6, 0.0081182053; I agrees | confirmed |
| C1.12 | From m = 55 on, error at t=5 is more than 10⁴ times smaller than max error | I: ratios 14835, 13492, …, 13103 (minimum 1.31e4); m=50 gives 3258, so "from 55" is right | confirmed |
| C1.13 | For m = 45 to 150 the max error lies between t = 1.64 and 1.73, after the peak, with the run above the reference | I/S: t_max ranges from 1.643 (m=70) to 1.727 (m=55); sign + in every case | confirmed |
| C1.14 | Max error falls at every refinement and about halves when m doubles | I: decreasing over all 20 m; 60→120 ratio 2.02 | confirmed |
| C1.15 | Max error 5.7e-2 (m=60), 2.8e-2 (m=120), 2.2e-2 (m=150) | S: 5.698e-2, 2.816e-2, 2.247e-2 | confirmed |
| C1.16 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5 | Formula correct. I: −41.2554 | confirmed |
| C1.17 | Threshold h ≈ 0.0485 (m ≤ 103; here m = 10 to 100) | I: h* = 0.04848, m* = 103.14; onset found for m ≤ 100 and none for m ≥ 110 | confirmed |
| C1.18 | Beyond it, each step multiplies the inherited error by 1 + h f_y < −1 | Linear error propagation of Euler; \|f_y\| increasing after onset (I) | confirmed |
| C1.19 | m = 10 onset at t ≈ 2.92 | S: 2.9228; I: 2.923; F frame 1 shows "≈ 2.92" | confirmed |
| C1.20 | For m = 10 to 45, error at t=5 is larger than just before onset | I: true for all 8 m, e.g. m=45: 7.1e-3 vs −8.1e-5 at t=3.78 | confirmed |
| C1.21 | For m = 50 to 100, onset runs from 3.95 (m=50) to 4.95 (m=100); runs decrease steadily; error at t=5 is smaller than just before onset | S: 3.9503, 4.9495. I: monotone; \|e5\| < \|e_before\| for all 7 m (e.g. m=60: 4.2e-6 vs 2.1e-5) | confirmed |
| C1.22 | For m = 110 to 150, h\|f_y\| < 2 up to t=5 | I/S: no onset. F shows "< 2 up to t = 5" with no band | confirmed |
| C1.23 | Source link → eulersmethodaa.jl; embed → eulersmethodaa.gif | index.qmd lines 72 and 74; the script writes that GIF; committed GIF is byte-identical to the regenerated one (manifest) | confirmed |
| C1.24 | Alt text: reference peaks near 1.45 at t ≈ 0.88 and reaches 0.0081 at t=5; m=10–40 dip below zero, m=10 ends at 1.777; band for m=10–100; monotone from m=50; y(5) = 0.0081182 at m=150; −1.7e-06 and 2.2e-02, largest near t = 1.67 | Covered by C1.3–C1.22. S m=150: t_max = 1.6667 | confirmed |

### Case 2 (modified Euler / midpoint, eulersmethodbb)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: modified Euler (midpoint), same IVP, m = 12 to 150 | Code; F titles | confirmed |
| C2.2 | 21 values: 12, 14, 16, 18, 20, 24, …, 100, 120, 150 | `ms` matches; 21 frames | confirmed |
| C2.3 | Same reference solution as Case 1 | Identical `rk4(50_000)` | confirmed |
| C2.4 | m = 12 to 24 zig-zag in the tail | I: 3–5 sign changes in increments after the peak; F frames 1–6 | confirmed |
| C2.5 | At m=24 only the last three steps alternate (+0.069, −0.076, +0.489); y(5) ≈ 0.613 | I: last increments +0.0383, +0.0059, +0.0692, −0.0755, +0.4889; y(5) = 0.6126681 | confirmed |
| C2.6 | m = 28 to 60 turn upward before t=5; at m=28 one dip of 0.0075 in the second-to-last step | I: minima at t = 3.57 … 4.67, then rising. m=28 second-to-last increment is −0.0075; for m ≥ 32 the rise is monotone | confirmed |
| C2.7 | Rise from minimum: 0.35 (m=28), 0.057 (m=40), 0.015 (m=60, barely visible) | I: 0.3501, 0.05716, 0.0150 | confirmed |
| C2.8 | y(5) ≈ 0.384, 0.0761, 0.0259 | S: 0.3841123, 0.0761463, 0.0259429 | confirmed |
| C2.9 | m=40 is the first of Example 12's runs | A gr_251: n = 40 | confirmed |
| C2.10 | At m=70 the upturn is only 0.0008; from m=80 on, runs decrease steadily after their peak | I: 0.000756; monotone after peak for m = 80, 90, 100, 120, 150 | confirmed |
| C2.11 | From m=16, error at t=5 falls at every refinement | I: \|e5\| = 1.11, 0.945, 0.806, 0.605, 0.376, 0.127, 0.089, 0.068, 0.0548, 0.0439, 0.035, 0.0285, 0.0178, 2.02e-3, 2.52e-4, 5.4e-5, 1.86e-5, 5.14e-6, 1.82e-6, strictly decreasing. 14→16 increases, so "from 16" is right | confirmed |
| C2.12 | 2.5e-4 at m=80, 1.8e-6 at m=150, y(5) ≈ 0.0081217 | S: 2.520e-4, 1.818e-6, 0.0081217390 | confirmed |
| C2.13 | For m = 16 to 70, error at t=5 is the largest error of the run | I/S: t_max = 5.000 for all of them (m=12 and 14 are not, and are excluded) | confirmed |
| C2.14 | From m=80 on, 2.5 to 87 times smaller than the max error | I: 2.49, 8.91, 20.6, 49.8, 87.4 | confirmed |
| C2.15 | Max error between t = 3.19 and 3.22: 6.3e-4 (m=80), 1.6e-4 (m=150) | S: t_max 3.1875, 3.2222, 3.2000, 3.2083, 3.2000; 6.275e-4, 1.589e-4 | confirmed |
| C2.16 | m=80→150 ratio 3.9 vs (150/80)² ≈ 3.5; Euler's 1.9 vs 150/80 ≈ 1.9 | I: 3.949, 3.516; 1.890, 1.875 | confirmed |
| C2.17 | At m=150, about 140 times smaller than Euler's 2.2e-2; the two errors at t=5 are about the same size | I: 141.4; −1.72e-6 vs +1.82e-6 | confirmed |
| C2.18 | Amplification factor 1 + z + z²/2 has \|R\| ≤ 1 on the negative real axis exactly for −2 ≤ z ≤ 0; limit 2, the same as Euler | R − 1 = z(1 + z/2) ≤ 0 on [−2, 0] and > 0 outside it; R ≥ 1/2 for all real z | confirmed |
| C2.19 | m ≤ 103 (here 12 to 100) exceed 2 before t=5, from t ≈ 2.99 (m=12) to 4.95 (m=100) | S: 2.9869, 4.9495; onset present for every m ≤ 100 | confirmed |
| C2.20 | For each of these m, error at t=5 is larger than just before onset | I: true for all 19 m (e.g. m=100: 1.86e-5 vs 1.39e-5) | confirmed |
| C2.21 | For m = 120 and 150, h\|f_y\| < 2 up to t=5 | I/S: no onset; F last frame | confirmed |
| C2.22 | Source link → eulersmethodbb.jl; embed → eulersmethodbb.gif | index.qmd lines 103 and 105; byte-identical regeneration (manifest) | confirmed |
| C2.23 | Alt text: zig-zag m=12–24 (m=24 only last three), upturn m=28–60, 0.0761 at m=40, band m=12–100, monotone from m=80, 0.0081217 at m=150, +1.8e-06 and 1.6e-04, largest near t = 3.20 | Covered above. S m=150: t_max = 3.2000 | confirmed |

---

### 3. Implementation checks

### eulersmethodaa.jl (forward Euler)

1. **Method.** Line 28: `ys[i+1] = ys[i] + h*f(ts[i], ys[i])`. This is forward Euler. `f` uses `cbrt`, the real cube root, which equals Mathews' `Sign[y] Abs[y]^(1/3)` (A, gr_229).
2. **Numbers.** My independent Python Euler agrees with the script to every printed digit. Examples (script vs independent):

   | m | y(5) script / indep | error at t=5 | max error @ t | onset |
   |---|---|---|---|---|
   | 10 | 1.7774833658 / 1.7774834 | +1.769 / +1.77 | 1.769@5.00 / 1.77@5.000 | 2.9228 / 2.923 |
   | 40 | −0.0174406187 / −0.0174406 | −2.556e-2 / −2.56e-2 | 0.2232@4.875 / 0.223@4.875 | 3.6805 / 3.680 |
   | 60 | 0.0081156970 / 0.0081157 | −4.223e-6 / −4.22e-6 | 5.698e-2@1.6667 / 5.70e-2@1.667 | 4.1893 / 4.189 |
   | 150 | 0.0081182053 / 0.0081182 | −1.715e-6 / −1.72e-6 | 2.247e-2@1.6667 / 2.25e-2@1.667 | none / none |

   All 20 rows are in `indep.out` and `inst/aa.out`. Order property: halving h halves the max error (2.01, 2.005, 2.002). All 20 y(5) also match Mathews' legacy frames to 7 decimals.
3. **Reference.** RK4 with 50 000 steps differs from DOP853 (rtol 1e-13) by at most 9.5e-13. y(5) = 0.0081199205 agrees with mpmath to 10 digits. The DOP853 reference satisfies the ODE (finite-difference residual 3.8e-8) and y(0) = 1. `refnodes(m)` uses at least 50 000 RK4 steps on a grid aligned with the run's nodes, so the node errors are accurate far beyond the 2 significant figures displayed.
4. **Picture.** Frames 1, 8 and 20 were viewed in full, and the contact sheet covers m = 10, 20, 30, 40, 50, 60, 80, 100, 120 and 140. Title, m and h match the frame. The magenta run passes through its node values (e.g. m=10 nodes −0.05, 1.10, −0.46, 1.78 visible). The red dot is at (5, y(5)). Annotations equal the S values. The band starts at the printed onset and is absent for m ≥ 110. The fixed window (−0.55, 1.9) contains every value; the script asserts this, and the observed extremes are −0.4624 and 1.7775. Nothing is clamped or masked.

### eulersmethodbb.jl (modified Euler = explicit midpoint)

1. **Method.** Line 30: `ys[i] + h*f(ts[i]+h/2, ys[i]+(h/2)*f(ts[i], ys[i]))`. This is the explicit midpoint method. It matches Mathews' `MEuler` subroutine (A gr_42), and it is the variant the page's Description states. It is not Heun's method.
2. **Numbers.** Independent Python midpoint agrees to every printed digit:

   | m | y(5) script / indep | error at t=5 | max error @ t | onset |
   |---|---|---|---|---|
   | 12 | 0.1958729272 / 0.1958729 | +1.878e-1 / +1.88e-1 | 1.409@4.5833 / 1.41@4.583 | 2.9869 / 2.987 |
   | 24 | 0.6126680617 / 0.6126681 | +6.045e-1 / +6.05e-1 | 0.6045@5 / 0.605@5 | 3.2549 / 3.255 |
   | 80 | 0.0083719546 / 0.0083720 | +2.520e-4 / +2.52e-4 | 6.275e-4@3.1875 / 6.27e-4@3.188 | 4.6004 / 4.600 |
   | 150 | 0.0081217390 / 0.0081217 | +1.818e-6 / +1.82e-6 | 1.589e-4@3.2000 / 1.59e-4@3.200 | none / none |

   All 21 rows are in the output files. Order property: halving h divides the max error by 4.26, 4.13, 4.06. All 21 y(5) match Mathews' `MEuleraa.gif` to 7 decimals, and the Example 12 values match to 8 significant figures.
3. **Reference.** Same RK4 reference as Case 1; verified above.
4. **Picture.** Contact sheet covers m = 12, 16, 20, 28, 36, 44, 52, 60, 80, 100 and 150. Title, label, annotations, band and red endpoint are consistent with S. The zig-zag at m = 12–20 is visible, the upturn at m = 28–60 is visible (barely at 60), and runs from m=80 on are smooth. All values lie inside the window (asserted; observed range 0.0081 to 1.4497).

### Regeneration

Per the manifest, both scratch regenerations are byte-identical to the committed GIFs (20 and 21 frames). My instrumented copies ran without error and printed the values above.

