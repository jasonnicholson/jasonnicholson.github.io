# Euler's Method for ODE's — animation review (round 4)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, nothing misleading and no minor issues of substance.

I checked every numerical, behavioural, count, wiring and method claim on the page (the ledger below) against my own computation and the frames, and every one holds at the precision stated. Both scripts implement the methods they name, match an independent implementation to every printed digit, use a reference accurate to about 1e-14, and draw exactly what they compute.

Observation (not a finding): the brief pointed me to `heunsmethod/`. Mathews' Heun's Method module is a separate module with its own animation (`a2001/Animations/OrdinaryDE/Heun1/`). The Euler module's own Animations links cover only `Euler1` and `MEuler1`, and this page covers both. No page on the site covers Heun's method; `grep -i heun` over `pages/numerical-methods` finds nothing. That is missing content elsewhere on the site, not a defect of this page. Mathews' "modified Euler" in this module is the midpoint method, not Heun (see M1).

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 13.5 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 13.8 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Abbreviations: "indep" is my Python computation (`indep.out`, `extra.out`); "instr" is the instrumented script output; "legacy" is the archive.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | Matches `eulersmethodaa.jl` line 28 | confirmed |
| D2 | Euler LTE $O(h^2)$, global $O(h)$; accuracy improves linearly | Test problem $y'=-y+t$, $y(0)=1$, exact $t-1+2e^{-t}$, $T=2$: error ratios on halving h are 2.016, 2.008, 2.004. On this page's IVP, max error m=60→120 is 0.05698→0.02816 (×2.02) | confirmed |
| D3 | "Mathews' modified Euler method is the explicit midpoint method", $y_{n+1}=y_n+h f(t_n+h/2,\ y_n+\tfrac h2 f(t_n,y_n))$ | Archive `gr_40.gif` shows exactly this formula; the `MEuler` subroutine in `gr_42.gif` is the same; script `bb` line 30 is the same | confirmed |
| D4 | Midpoint improves global accuracy to $O(h^2)$ | Same test problem: ratios 4.16, 4.08, 4.04 | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | Scripts lines 12–15; archive `gr_250.gif`/`gr_228.gif`: "y' = 1 − t ∛y with y(0)=1 over 0≤t≤5"; real cube root as in Mathews' `Sign[y] Abs[y]^(1/3)` (`gr_251.gif`) | confirmed |
| I2 | Each frame is a complete run with m subintervals, h=5/m, with m taken from Mathews' animation | Script loops `ms`; the legacy frames show the same m lists (I2a, I2b) | confirmed |
| I2a | Euler m list = Mathews' | Legacy `Euleraa.gif` shows a blank frame, then m = 10,15,20,25,30,35,40,45,50,55,60,70,80,90,100,110,120,130,140,150 | confirmed |
| I2b | Modified Euler m list = Mathews' | Legacy `MEuleraa.gif` shows a blank frame, then m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 | confirmed |
| I3 | Gray reference = fixed-step RK4, 50 000 steps | Script `rk4(50_000)`. Accuracy: RK4 at 50 000 and 100 000 steps differ by 1.7e-18 at t=5 and at most 1.6e-14 on the nodes; script y(5)=0.008119920465 vs DOP853 0.008119920465 | confirmed |
| I4 | Frames labelled with computed y(5), error at t=5, max error at any grid point | Frames (e.g. `aa/frame_020.png`, `bb/frame_021.png`) and script lines 94–96 | confirmed |
| I5 | Light red band where $h|\partial f/\partial y|$ exceeds the stability limit | `vspan!([ton,T])`, where ton is the first t on the reference with $h|f_y|>2$. Along the reference $|f_y|=t/(3y^{2/3})$ increases after the peak, so the band is exactly that region | confirmed |
| I6 | Legacy note: every y(5) printed in Euleraa/MEuleraa agrees with these runs to 7 decimals | All 20 Euler values agree (e.g. m=35: legacy −0.002737, mine −0.0027370; m=55 and 60: 0.0081157). All 21 midpoint values agree (e.g. m=80: legacy 0.008372, mine 0.0083720; m=56: 0.0365908) | confirmed |
| I7 | Examples 11 and 12 print runs with m=40, 100, 150, and their final values agree | Ex 11 (`gr_233/240/247`, steps 0.125/0.05/0.0333): −0.0174406, 0.00811736, 0.00811821, vs ours −0.0174406, 0.0081174, 0.0081182. Ex 12 (`gr_255/262/269`): 0.0761463, 0.00813852, 0.00812174, vs ours 0.0761463, 0.0081385, 0.0081217 | confirmed |

### Case 1: forward Euler

| # | Claim | Evidence (indep / instr) | Verdict |
|---|---|---|---|
| C1.1 | Heading: forward Euler, the IVP, m = 10 to 150 | Script `euler`, `ms` 10…150; GIF titles | confirmed |
| C1.2 | 20 values of m, listed | `ms` has 20 entries; GIF has 20 frames; list matches the legacy | confirmed |
| C1.3 | Reference rises to about 1.4498 near t=0.88 | Peak 1.449767 at t=0.8836 | confirmed |
| C1.4 | Then decays toward the nullcline $y=1/t^3$ (where $y'=0$) | $1-t y^{1/3}=0 \iff y=t^{-3}$; at the peak $1/t^3=1.44975$ ≈ y | confirmed |
| C1.5 | Reference $y(5)=0.0081199$ | 0.008119920465 | confirmed |
| C1.6 | m=10 to 40: zig-zag in the tail and dip below zero; exact solution stays positive | Every m in 10–40 has negative nodes (min −0.4624, −0.1702, −0.1315, −0.1163, −0.0322, −0.0452, −0.0174), with alternating tail increments (`extra.out`). Reference minimum is 0.00812 > 0 (y can't cross 0 since y'=1 there) | confirmed |
| C1.7 | y(5) ≈ 1.777 (m=10), 0.391 (m=30), −0.0174 (m=40) | 1.7774834, 0.3907263, −0.0174406 | confirmed |
| C1.8 | m=45: last steps still alternate, by less than 0.009 | Last increments +0.00022, −0.00327, +0.00852 | confirmed |
| C1.9 | From m=50 on, runs decrease steadily after their peak | Strictly decreasing after the argmax for every m ≥ 50 | confirmed |
| C1.10 | Error at t=5: −4.2e-6 (m=60), −1.7e-6 (m=150); y(5) ≈ 0.0081182 at m=150 | −4.22e-6, −1.72e-6 (instr −1.715e-6), 0.0081182 | confirmed |
| C1.11 | From m=55 on, the error at t=5 is more than 1e4 times smaller than the max error | Ratios 1.48e4, 1.35e4, 1.34e4, …, 1.31e4 for m=55…150; m=50 is 3.26e3, so the threshold is correctly placed | confirmed |
| C1.12 | For m=45 to 150 the max error lies between t=1.64 and 1.73, after the peak, with the run above the reference | Locations 1.67, 1.70, 1.73, 1.67, 1.64, 1.69, 1.67, 1.65, 1.68, 1.67, 1.65, 1.68, 1.67; error sign + in all | confirmed |
| C1.13 | Max error falls at every refinement and about halves when m doubles: 5.7e-2 (60), 2.8e-2 (120), 2.2e-2 (150) | Strictly decreasing over all 20 m; 0.05698, 0.02816, 0.02247 | confirmed |
| C1.14 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t=5 | −41.2554 | confirmed |
| C1.15 | Threshold h ≈ 0.0485, m ≤ 103 (here m=10 to 100) | 2/41.2554 = 0.04848; 5/h = 103.14 | confirmed |
| C1.16 | Beyond onset each step multiplies the inherited error by $1+hf_y<-1$ | Linearised error recursion of Euler; $hf_y<-2$ past onset | confirmed |
| C1.17 | m=10 onset at t ≈ 2.92 | 2.923 | confirmed |
| C1.18 | m=10 to 45: error at t=5 larger than just before onset | Error at the last node before onset vs error at t=5, for m=10…45: 0.258/1.77, 0.024/1.02, 0.019/0.714, 0.022/0.544, 2.9e-4/0.383, 5.2e-4/0.011, 6.5e-5/0.026, 8.1e-5/7.1e-3; all larger | confirmed |
| C1.19 | m=50 to 100: onset from t≈3.95 (m=50) to t≈4.95 (m=100) | 3.950 … 4.949 | confirmed |
| C1.20 | m=50 to 100: runs decrease steadily, and the error at t=5 is smaller than just before onset | m=50: 4.66e-5 → 2.11e-5; m=55: 3.32e-5 → 4.19e-6; … m=100: 3.04e-6 → 2.56e-6; all smaller and monotone | confirmed |
| C1.21 | m=110 to 150: $h|f_y|$ stays below 2 up to t=5 | No onset for m ≥ 110 (h ≤ 0.04545 < 0.04848) | confirmed |
| C1.22 | Source link `eulersmethodaa.jl`, embed `eulersmethodaa.gif`, and both are the Euler case | Files exist; the script produces that GIF (byte-identical); frame titles read "Euler's method" | confirmed |
| C1.23 | Alt text: reference peaks near 1.45 at t ≈ 0.88 and decays to 0.0081; m=10–40 zig-zag and dip below zero; y(5)=1.777 at m=10; shading for m=10–100; monotone from m=50; y(5)=0.0081182 at m=150; −1.7e-06 and 2.2e-02 at m=150, largest near t=1.67 | All as computed; frame 20 prints "error at t = 5: -1.7e-06", "max \|error\| = 2.2e-02 at t = 1.67" | confirmed |

### Case 2: modified Euler (midpoint)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: modified Euler (midpoint), same IVP, m = 12 to 150 | Script `meuler`, `ms` 12…150 | confirmed |
| C2.2 | 21 values of m, listed | `ms` has 21 entries; GIF has 21 frames; list matches the legacy | confirmed |
| C2.3 | Same reference solution as Case 1 | Identical `rk4(50_000)` code | confirmed |
| C2.4 | m=12 to 24: the tail zig-zags | Tail increments alternate: m=12 (+0.76, −0.75, +1.27, −1.22), m=14, 16, 18, 20 similarly (`extra.out`); m=24 (C2.5) | confirmed |
| C2.5 | m=24: only the last three steps alternate (+0.069, −0.076, +0.489), ending at y(5) ≈ 0.613 | Increments …, +0.0383, +0.0059, +0.0692, −0.0755, +0.4890; y(5)=0.6126681 | confirmed |
| C2.6 | m=28 to 60: the curve turns upward before t=5 | The tail minimum is before t=5 for every m in 28…60; upturns 0.350, 0.108, 0.0747, 0.0572, 0.0466, 0.0375, 0.0302, 0.0248, 0.0150 | confirmed |
| C2.7 | m=28 has one small dip of 0.0075 in the second-to-last step | Increment −0.00754 at step 27; no other sign change after the minimum | confirmed |
| C2.8 | Rises from its minimum by 0.35 (m=28), 0.057 (m=40), 0.015 (m=60) | 0.3501, 0.05716, 0.01500 | confirmed |
| C2.9 | Ends at y(5) ≈ 0.384, 0.0761, 0.0259 | 0.3841123, 0.0761463, 0.0259429 | confirmed |
| C2.10 | m=70 upturn only 0.0008 | 0.000756 | confirmed |
| C2.11 | From m=80 on, runs decrease steadily after their peak | Monotone after the argmax for m=80, 90, 100, 120, 150 | confirmed |
| C2.12 | From m=16 the error at t=5 falls at every refinement, to 2.5e-4 (m=80) and 1.8e-6 (m=150); y(5) ≈ 0.0081217 | 1.11, 0.945, 0.806, 0.605, 0.376, 0.127, 0.0890, 0.0680, 0.0548, 0.0439, 0.0350, 0.0285, 0.0178, 2.02e-3, 2.52e-4, 5.40e-5, 1.86e-5, 5.14e-6, 1.82e-6, strictly decreasing. m=14→16 rises, so "from m=16" is right | confirmed |
| C2.13 | m=16 to 70: the error at t=5 is the largest error of the run | Max-error location is t=5.00 for every m in 16…70 (m=12, 14 have it at 4.58 and 4.64, correctly excluded) | confirmed |
| C2.14 | From m=80 on it is 2.5 to 87 times smaller than the max error, which lies at t=3.19–3.22 | Ratios 2.49, 8.91, 20.6, 49.8, 87.4; locations 3.19, 3.22, 3.20, 3.21, 3.20 | confirmed |
| C2.15 | Max error 6.3e-4 (m=80) and 1.6e-4 (m=150) | 6.27e-4, 1.59e-4 | confirmed |
| C2.16 | Max error m=80→150 falls by 3.9, vs (150/80)² ≈ 3.5; Euler's falls by 1.9, vs 150/80 ≈ 1.9 | 3.949; 3.516; 1.890; 1.875 | confirmed |
| C2.17 | At m=150 about 140 times smaller than Euler's 2.2e-2; the errors at t=5 are about the same size | 141.4; e5 −1.72e-6 vs +1.82e-6 | confirmed |
| C2.18 | Amplification $1+z+z^2/2$ has $|R|\le1$ on the negative real axis exactly for $-2\le z\le0$; limit 2, same as Euler | $R(z)-1=z(1+z/2)\le0$ on [−2,0] and >0 outside; $R\ge1/2$ everywhere | confirmed |
| C2.19 | m ≤ 103 (here m=12 to 100) exceed 2 before t=5, onset from t≈2.99 (m=12) to t≈4.95 (m=100) | 2.987 … 4.949 | confirmed |
| C2.20 | For each of m=12…100, the error at t=5 is larger than just before onset | True for all 19 (e.g. m=80: 3.0e-5 → 2.5e-4; m=100: 1.39e-5 → 1.86e-5) | confirmed |
| C2.21 | m=120 and 150: below 2 up to t=5 | No onset | confirmed |
| C2.22 | Source link `eulersmethodbb.jl`, embed `eulersmethodbb.gif`, and both are the modified Euler case | Byte-identical regeneration; titles read "Modified Euler (midpoint)" | confirmed |
| C2.23 | Alt text: m=12–24 zig-zag (m=24 only the last three steps), m=28–60 upturn, y(5)=0.0761 at m=40, shading m=12–100, monotone from m=80, y(5)=0.0081217 at m=150, +1.8e-06 and 1.6e-04, largest near t=3.20 | All as computed; frame 21 prints exactly these | confirmed |

---

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler)

- **Method.** Line 28, `ys[i+1] = ys[i] + h*f(ts[i], ys[i])`, is forward Euler with uniform h=5/m. `f` uses `cbrt`, the real cube root, which matches Mathews' `Sign[y] Abs[y]^(1/3)` and matters for the negative iterates at m ≤ 40.
- **Numbers.** The instrumented script and my independent Python loop agree on every value, to every printed digit:

  | m | script y(5) | indep y(5) | script e5 | indep e5 | script max\|e\| @t | indep max\|e\| @t |
  |---|---|---|---|---|---|---|
  | 10 | 1.7774834 | 1.7774834 | +1.769 | +1.77 | 1.769 @5.00 | 1.77 @5.00 |
  | 40 | −0.0174406 | −0.0174406 | −2.556e-2 | −2.56e-2 | 0.2232 @4.88 | 0.223 @4.88 |
  | 60 | 0.0081157 | 0.0081157 | −4.223e-6 | −4.22e-6 | 5.698e-2 @1.67 | 5.70e-2 @1.67 |
  | 100 | 0.0081174 | 0.0081174 | −2.556e-6 | −2.56e-6 | 3.386e-2 @1.65 | 3.39e-2 @1.65 |
  | 150 | 0.0081182 | 0.0081182 | −1.715e-6 | −1.72e-6 | 2.247e-2 @1.67 | 2.25e-2 @1.67 |

  The other 15 m agree likewise; compare `eulersmethodaa_instr.out` with `indep.out`. The y(5) values also match Mathews' printed values (I6, I7). The property check of order 1 (D2) passes.
- **Reference.** RK4 with 50 000 steps: y(5)=0.008119920465, identical to DOP853 (rtol 1e-13) and to Radau to 12 digits. Halving the step changes the node values by at most 1.6e-14, far below the smallest error displayed (1.7e-6). `refnodes(m)` samples an RK4 run of at least 50 000 steps at exactly the run's nodes (k=cld(50000,m) substeps per node), so errors are taken at the right points. Onset times from the script (2.923 … 4.950) match mine (2.923 … 4.949).
- **Picture.** Checked frames 1 (m=10), 4 (m=25), 8 (m=45), 12 (m=70) and 20 (m=150), plus the contact sheet. The magenta polyline and markers are the run's nodes, and the red dot is (5, y_m). The band is `[ton,5]`, present for m ≤ 100 and absent for m ≥ 110 (the legend entry disappears accordingly). The labels print y(5), the signed error at t=5, and the max error with its node t, from the same arrays. The title function matches the code. The window (−0.55, 1.9) contains every value of every run; the script asserts this, and my min −0.4624 and max 1.7775 agree. Nothing is clamped or masked.

### `eulersmethodbb.jl` (modified Euler = explicit midpoint)

- **Method.** Line 30 is `y + h*f(t+h/2, y + (h/2) f(t,y))`, the explicit midpoint method. This is the variant Mathews' `MEuler` subroutine uses (archive `gr_42.gif`) and the one the page's Description states. It is not Heun's method.
- **Numbers.** Exact agreement again:

  | m | script y(5) | indep y(5) | script e5 | indep e5 | script max\|e\| @t | indep max\|e\| @t |
  |---|---|---|---|---|---|---|
  | 12 | 0.1958729 | 0.1958729 | +1.878e-1 | +1.88e-1 | 1.409 @4.58 | 1.41 @4.58 |
  | 24 | 0.6126681 | 0.6126681 | +6.045e-1 | +6.05e-1 | 0.6045 @5.00 | 0.605 @5.00 |
  | 40 | 0.0761463 | 0.0761463 | +6.803e-2 | +6.80e-2 | 6.803e-2 @5.00 | 6.80e-2 @5.00 |
  | 80 | 0.0083720 | 0.0083720 | +2.520e-4 | +2.52e-4 | 6.275e-4 @3.19 | 6.27e-4 @3.19 |
  | 150 | 0.0081217 | 0.0081217 | +1.818e-6 | +1.82e-6 | 1.589e-4 @3.20 | 1.59e-4 @3.20 |

  The other 16 m agree likewise. The property check of order 2 on the test problem (D4: ratios 4.16, 4.08, 4.04) passes, and on this IVP the max error m=80→150 falls by 3.95.
- **Reference.** Same RK4 code and accuracy as above.
- **Picture.** Checked frames 1 (m=12), 6 (m=24), 7 (m=28), 15 (m=60), 17 (m=80) and 21 (m=150), plus the contact sheet. They are built the same way as Case 1. The band appears for m ≤ 100. All values lie inside the window: the script asserts it, and my max over all runs is 1.4496. The titles say "Modified Euler (midpoint)", which matches the code.

### Things I could not determine
None of consequence. The page's history and attribution statements are outside scope and were not checked.

