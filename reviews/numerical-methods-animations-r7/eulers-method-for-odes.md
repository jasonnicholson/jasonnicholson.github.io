# Euler's Method for ODE's — animation review (round 7)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 1 Misleading, 2 Minor**.

## Findings

### F1. Page match, Misleading: "each step multiplies the error ... by $1+h\,\partial f/\partial y<-1$" is false once the error is large

- **Where:** `index.qmd` lines 63-65 (Case 1): "From then on each step multiplies the error it inherits by $1+h\,\partial f/\partial y<-1$, amplifying it with alternating sign instead of damping it."
- **What is there:** a universal statement about every step after the onset, offered as the cause of the coarse-grid behaviour, for $m=10$ to $100$.
- **What is true:** this is the linearization about the reference solution. It holds only while the error is small compared with $y$. The exact one-step relation is $e_{n+1}=A_n e_n+d_n$ with the secant factor $A_n=1+h\,\dfrac{f(t_n,y_n)-f(t_n,Y_n)}{y_n-Y_n}$ and $d_n$ the local error. For $m=10$ to $40$, **11 of the 53 steps at or after the onset have $-1\le A_n<0$**, so they shrink the inherited error rather than amplify it. The cube root is strongly concave, so when a zig-zag has thrown $y_n$ far above the reference the secant slope is much smaller than the tangent slope at the reference.
- **Worked example ($m=25$, step from $t=4.20$):** $y_n=0.44313$, $Y_n=0.01392$, $e_n=+0.42921$. The page's factor (tangent at the reference) is $-3.84$, which would give $e_{n+1}\approx-1.65$. The true factor is $A_n=-0.021$ and the true next error is $-0.00932$, **46 times smaller**. This is the visible collapse of the large spike in the $m=25$ frame.
- **How I know:** `python3 review/tails.py` and `review/band.py`.

| $m$ | steps at/after onset | $A_n<-1$ | $-1\le A_n<0$ | range of $A_n$ |
|---|---|---|---|---|
| 10 | 4 | 3 | 1 | -13.89 .. -0.43 |
| 15 | 5 | 3 | 2 | -13.67 .. -0.21 |
| 20 | 7 | 5 | 2 | -14.38 .. -0.07 |
| 25 | 8 | 7 | 1 | -7.46 .. -0.02 |
| 30 | 9 | 7 | 2 | -13.01 .. -0.11 |
| 35 | 10 | 8 | 2 | -14.25 .. -0.03 |
| 40 | 10 | 9 | 1 | -13.45 .. -0.11 |
| 45 to 100 | 1 to 10 each | all | 0 | below -1 throughout |

- **Suggested correction:** "While the error is small compared with $y$, each step multiplies the error it inherits by about $1+h\,\partial f/\partial y<-1$, amplifying it with alternating sign instead of damping it. Once the error is comparable to $y$ this linear picture no longer holds and individual steps can shrink it: at $m=25$ the step from $t=4.2$ takes the error from $+0.429$ to $-0.009$."

- **Independent check:** confirmed with correction. The statement fails for m = 10 to 40 and holds for m = 45 to 100. Across the 110 post-onset steps, the factor is below −1 at all 110 only when ∂f/∂y is evaluated on the reference solution. The true multiplier of the inherited error is below −1 at 99 steps; at the other 11 (m = 10 to 40) it lies in (−1, 0), so the error keeps alternating but shrinks.

### F2. Page match, Minor: the shaded band is evaluated on the reference solution, but neither the page nor the frame says so

- **Where:** `index.qmd` lines 33-34 ("A light red band marks where $h\,|\partial f/\partial y|$ exceeds the method's stability limit"), lines 61-63 and 97-99; the frame legend and label "h·|∂f/∂y| > 2 from t ≈ ..." (`eulersmethodaa.jl` lines 62-68, 86, 92-93; `eulersmethodbb.jl` lines 65-71, 89, 95-96).
- **What is there:** $\partial f/\partial y$ depends on $y$, and the page does not say which $y$. The code uses the reference solution (`onset` reads `yref`); only a script comment records this.
- **What is true:** a reader will naturally read the band as a statement about the plotted run, and for the coarse runs that reading is false. Evaluated at the run's own nodes, in **Case 2 at $m=14,16,18,20,24$ no node of the run has $h|\partial f/\partial y|>2$ at all**, although each of those frames is shaded from about $t=3$ to $5$ and labelled "> 2".
- **Evidence (`python3 review/band.py`), in-band step-start nodes whose own $h|f_y(t_n,y_n)|\le2$:**
  - Case 2: $m=12$: 3 of 4; 14: 5/5; 16: 6/6; 18: 6/6; 20: 7/7; 24: 8/8; 28: 7/9; 32: 7/9; 36: 6/10; 40: 5/10; 44: 4/10; 48: 3/10; 52: 2/10; 56: 1/10; 60 to 90: none; 100: 1/1.
  - Case 1: $m=10$: 2/4; 15: 4/5; 20: 4/7; 25: 5/8; 30: 2/9; 35: 3/10; 40: 1/10; 45 and up: none. Conversely, two nodes outside the band do exceed 2 on the run itself ($m=15$ at $t=3.000$, $m=25$ at $t=3.200$).
- **Suggested correction:** line 33: "A light red band marks where $h\,|\partial f/\partial y|$, evaluated along the reference solution, exceeds the method's stability limit." Optionally change the legend to "h·|∂f/∂y| > 2 on reference".

- **Independent check:** not run (Minor finding, unverified)

### F3. Page match, Minor: "about halves when $m$ doubles" holds only from $m=45$, but the sentence is written for the whole sweep

- **Where:** `index.qmd` lines 58-60: "It falls at every refinement in the sweep and about halves when $m$ doubles, as expected of a first-order method".
- **What is there:** one sentence joins a whole-sweep statement (true: strict decrease across all 20 values) to the halving statement.
- **What is true:** of the 12 doubling pairs in the sweep, the 5 starting at $m\ge45$ give a ratio of 2.02 to 2.03. The 7 starting at $m\le40$ give 2.48 to 7.92, because those runs are dominated by the instability.

| $m\to2m$ | 10 | 15 | 20 | 25 | 30 | 35 | 40 | 45 | 50 | 55 | 60 | 70 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| max-error ratio | 2.48 | 2.66 | 3.20 | 7.92 | 6.71 | 6.76 | 5.25 | 2.03 | 2.03 | 2.02 | 2.02 | 2.02 |

- **How I know:** `python3 review/tails.py` ("doubling" line).
- **Suggested correction:** "It falls at every refinement in the sweep and, from $m=45$ on, about halves when $m$ doubles, as expected of a first-order method: ..."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 13.3 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 14.0 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **C** confirmed, **W** wrong, **?** could not determine. Evidence codes: *T* = independent table (`indep.py`, agreeing with the instrumented scripts through `cmp.py`), *L* = legacy archive, *F* = frames viewed, *S* = script read.

### Description

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | C | S line 28; L subroutine image |
| 2 | Euler LTE $O(h^2)$, global $O(h)$; accuracy improves linearly | C | `order.jl` on $y'=-2ty$: observed orders 1.002, 1.001, 1.001 |
| 3 | Mathews' modified Euler is the explicit midpoint method, with the stated formula | C | L `MEuler` subroutine image (`gr_42`); his $m=40$ first value 1.11703 = midpoint 1.117028 (Heun 1.116875); his $y(5)$ 0.0761463 = midpoint (Heun 0.2506350) |
| 4 | Midpoint: half Euler step, slope there | C | S `bb` line 30 |
| 5 | Midpoint global accuracy $O(h^2)$ | C | `order.jl`: observed orders 2.016, 2.008, 2.004 |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 6 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | C | S; L title and `f1` |
| 7 | Each frame a complete run with $m$ subintervals, $h=5/m$ | C | S |
| 8 | $m$ values are those of Mathews' animation | C | L: OCR of all unique legacy frames, 50/52/55/56 confirmed by eye |
| 9 | Gray reference is fixed-step RK4, 50 000 steps | C | S; RK4 = 0.0081199204649 |
| 10 | Frame labelled with computed $y(5)$, error at $t=5$, largest grid-point error | C | S, F; values match T |
| 11 | Red band marks $h|\partial f/\partial y|>$ stability limit | C, see F2 | True on the reference solution; unstated |
| 12 | Legacy GIFs sweep $m$ the same way | C | L: 20 and 21 distinct curves, same order |
| 13 | Every legacy $y(5)$ agrees to seven decimals | C | All 41 values match T (see section 3) |
| 14 | Examples 11 and 12 each print $m=40,100,150$ | C | L images `gr_233/240/247`, `gr_255/262/269` |
| 15 | Their final values agree with this page's frames | C | E: -0.0174406, 0.00811736, 0.00811821; M: 0.0761463, 0.00813852, 0.00812174 |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 16 | Heading: forward Euler, $m=10$ to $150$ | C | S |
| 17 | 20 values, the listed sequence | C | S line 16, 20 frames, L |
| 18 | Reference rises to about 1.4498 near $t=0.88$ | C | Peak 1.449767 at $t=0.883556$ |
| 19 | Decays toward nullcline $y=1/t^3$ ($y'=0$) | C | Algebra; $y(5)-1/125=1.2\times10^{-4}$ |
| 20 | $y(5)=0.0081199$ | C | 0.00811992046 (DOP853, RK4 50k, 25-digit RK4 with Richardson) |
| 21 | $m=10$ to $40$ zig-zag in the tail and dip below zero | C | Sign-alternating increments; negative nodes in each |
| 22 | Exact solution stays positive | C | $y'=1$ at $y=0$; $y>0$ on the whole grid |
| 23 | $y(5)\approx1.777$ ($m=10$), $0.391$ ($m=30$), $-0.0174$ ($m=40$) | C | 1.7774834, 0.3907263, -0.0174406 |
| 24 | $m=40$ is the first Example 11 run | C | L |
| 25 | $m=45$: last steps alternate by less than 0.009 | C | +0.00022, -0.00327, +0.00852 |
| 26 | From $m=50$ runs decrease steadily after peak | C | Monotone for all 12 values |
| 27 | Error at $t=5$: $-4.2\times10^{-6}$ ($m=60$), $-1.7\times10^{-6}$ ($m=150$) | C | -4.2235e-6, -1.7152e-6 |
| 28 | $y(5)\approx0.0081182$ at $m=150$ | C | 0.0081182053 |
| 29 | Strongly negative $\partial f/\partial y$ damps earlier error | C | $\int_{1.67}^{5}f_y\,dt=-45.6$ along the reference |
| 30 | From $m=55$, error at $t=5$ is more than $10^4$ times below the largest | C | Smallest ratio 13 103 ($m=150$); $m=50$ is 3 258 |
| 31 | $m=45$ to $150$: largest error between $t=1.64$ and $1.73$ | C | 1.643 to 1.727 |
| 32 | It lies after the peak, with the run above the reference | C | Sign + in all; run peak near 0.9 |
| 33 | Largest error falls at every refinement | C | Strict decrease across all 20 |
| 34 | About halves when $m$ doubles | **C for $m\ge45$; not for $m\le40$, see F3** | Ratios above |
| 35 | $5.7\times10^{-2}$, $2.8\times10^{-2}$, $2.2\times10^{-2}$ at $m=60,120,150$ | C | 5.698e-2, 2.816e-2, 2.247e-2 |
| 36 | $\partial f/\partial y=-t/(3y^{2/3})$ | C | Finite difference: -7.368063 both |
| 37 | Reaches $-41.3$ at $t=5$ | C | -41.2554 |
| 38 | Threshold $h\approx0.0485$, $m\le103$; here $m=10$ to $100$ | C | $h=0.04848$, $m=103.14$ |
| 39 | Euler stability limit 2 | C | $\lvert1+z\rvert\le1$ exactly on $[-2,0]$ |
| 40 | Shaded in those frames | C | F: band in $m\le100$, none from 110 |
| 41 | Each step multiplies inherited error by $1+h f_y<-1$ | **W as stated, see F1** | 11 of 53 steps for $m\le40$ have $-1\le A_n<0$ |
| 42 | Onset at $t\approx2.92$ for $m=10$ | C | 2.923 |
| 43 | $m=10$ to $45$: error at $t=5$ larger than just before onset | C | Ratios 6.9, 41.7, 38.1, 24.5, 1310, 20.9, 395, 88.5 |
| 44 | $m=50$ to $100$: onset from $t\approx3.95$ to $4.95$ | C | 3.950, 4.949 |
| 45 | Those runs decrease steadily; error at $t=5$ smaller than before onset | C | Ratios 0.45, 0.13, 0.20, 0.30, 0.45, 0.68, 0.84 |
| 46 | $m=110$ to $150$: stays below 2 up to $t=5$ | C | Largest value 1.875 ($m=110$) |
| 47 | Source link and embed are Case 1 | C | Lines 72, 74; GIF byte-identical to regeneration |
| 48 | Alt text (all numbers) | C | Reference 1.45/0.88/0.0081, 1.777, 0.0081182, -1.7e-06, 2.2e-02, $t\approx1.67$ |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 49 | Heading: midpoint, same IVP, $m=12$ to $150$ | C | S |
| 50 | 21 values, the listed sequence | C | S line 18, 21 frames, L |
| 51 | $m=12$ to $24$: tail zig-zags | C | Alternating last increments, F |
| 52 | $m=24$: only last three steps alternate ($+0.069,-0.076,+0.489$) | C | +0.06921, -0.07552, +0.48895; the four steps before them are all +, and the run has only 3 sign changes after its peak |
| 53 | Ending at $y(5)\approx0.613$ | C | 0.6126681 |
| 54 | $m=28$ to $60$: curve turns upward before $t=5$ | C | Increments positive at the end, F |
| 55 | $m=28$: one dip of 0.0075 in second-to-last step | C | -0.00754 |
| 56 | Rise from minimum 0.35, 0.057, 0.015 at $m=28,40,60$ | C | 0.35007, 0.05716, 0.01500 |
| 57 | End at 0.384, 0.0761, 0.0259 | C | 0.3841123, 0.0761463, 0.0259429 |
| 58 | $m=40$ is the first Example 12 run | C | L |
| 59 | $m=70$: upturn 0.0008, too small to see | C | 0.00076; F |
| 60 | From $m=80$ runs decrease steadily after peak | C | Monotone for all five |
| 61 | From $m=16$ error at $t=5$ falls at every refinement | C | T |
| 62 | $2.5\times10^{-4}$ ($m=80$), $1.8\times10^{-6}$ ($m=150$) | C | 2.52e-4, 1.8185e-6 |
| 63 | $y(5)\approx0.0081217$ at $m=150$ | C | 0.0081217390 |
| 64 | $m=16$ to $70$: error at $t=5$ is the largest | C | Max at $t=5$ in all |
| 65 | From $m=80$: 2.5 to 87 times smaller than the largest | C | 2.5, 8.9, 20.6, 49.8, 87.4 |
| 66 | Largest error between $t=3.19$ and $3.22$ | C | 3.188 to 3.222 |
| 67 | $6.3\times10^{-4}$ ($m=80$), $1.6\times10^{-4}$ ($m=150$) | C | 6.27e-4, 1.589e-4 |
| 68 | Falls by 3.9, close to $(150/80)^2\approx3.5$ | C | 3.949, 3.516 |
| 69 | Euler's falls by 1.9, close to $150/80\approx1.9$ | C | 1.890, 1.875 |
| 70 | About 140 times smaller than Euler's $2.2\times10^{-2}$ | C | 141.4 |
| 71 | The two errors at $t=5$ are about the same size | C | -1.72e-6, +1.82e-6 |
| 72 | $R(z)=1+z+z^2/2$, $\lvert R\rvert\le1$ exactly on $[-2,0]$ | C | Grid of 500 001 points; min $R=0.5$ |
| 73 | $m\le103$, here $m=12$ to $100$, exceed 2 before $t=5$ | C | As 38 |
| 74 | From $t\approx2.99$ ($m=12$) to $t\approx4.95$ ($m=100$) | C | 2.987, 4.949 |
| 75 | For each of these, error at $t=5$ larger than before onset | C | Ratios from 1.34 ($m=100$) to 1050 |
| 76 | $m=120,150$ stay below 2 | C | 1.72, 1.38 |
| 77 | Source link and embed are Case 2 | C | Lines 103, 105; GIF byte-identical to regeneration |
| 78 | Alt text (all numbers) | C | 0.0761, 0.0081217, +1.8e-06, 1.6e-04, $t\approx3.20$ |

No claim was left undetermined.

---

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler)

- **It is the method claimed.** Line 28 is forward Euler. The routine extracted verbatim and run on $y'=-2ty$, $y(0)=1$, with exact $e^{-4}$ at $T=2$, gave errors 6.125e-4, 3.058e-4, 1.528e-4, 7.635e-5 for $m=200,400,800,1600$: observed orders **1.002, 1.001, 1.001**.
- **The numbers are right.** An instrumented copy printed every run. It reproduced the committed GIF byte for byte. Against an independent Python implementation with a DOP853 reference (rtol 1e-13) over all 20 runs, the largest differences were: $y(5)$ 6.4e-15, error at $t=5$ 6.4e-15, max error 3.9e-13, location of max 0, onset 9.8e-5 (the spacing of the reference grid).

| $m$ | script $y(5)$ | independent $y(5)$ | script max error | independent |
|---|---|---|---|---|
| 10 | 1.7774833658 | 1.7774833658 | 1.76936e+00 | 1.76936e+00 |
| 40 | -0.0174406187 | -0.0174406187 | 2.23221e-01 | 2.23221e-01 |
| 60 | 0.0081156970 | 0.0081156970 | 5.69817e-02 | 5.69817e-02 |
| 150 | 0.0081182053 | 0.0081182053 | 2.24733e-02 | 2.24733e-02 |

- **Reference values.** RK4 50 000 steps: 0.0081199204649. DOP853: 0.0081199204649. Independent 25-digit RK4 with Richardson extrapolation: 0.0081199204648678. The reference is accurate to about 1e-13, far below the smallest error it is used to measure (1.7e-6).
- **The picture shows what was computed.** Frames 1, 8, 15 and the contact sheet were viewed. Title, legend, $m$, $y(5)$, errors and onset match the computed values. Band present for $m\le100$ and absent from 110. The axis limits contain every computed value (the script errors otherwise; the comment's -0.4624 and 1.7775 are correct); no clamping or masking. The band's evaluation on the reference is F2.
- **Legacy.** All 20 printed $y(5)$ values and all $m$ labels match. Mathews' `Sign[y] Abs[y]^(1/3)` is the script's `cbrt`.

### `eulersmethodbb.jl` (modified Euler, midpoint)

- **It is the method claimed.** Line 30 is explicit midpoint, identical to Mathews' `MEuler` subroutine (image `gr_42`). Not Heun: Heun gives $y(5)=0.2506350$ at $m=40$ against Mathews' 0.0761463. The routine on the closed-form problem gave errors 6.245e-6, 1.544e-6, 3.837e-7, 9.566e-8: observed orders **2.016, 2.008, 2.004**.
- **The numbers are right.** The instrumented copy reproduced the committed GIF byte for byte. Over all 21 runs the largest differences from the independent computation were: $y(5)$ 1.1e-15, error at $t=5$ 1.1e-15, max error 2.6e-15, location 0, onset 9.8e-5.

| $m$ | script $y(5)$ | independent $y(5)$ | script max error | independent |
|---|---|---|---|---|
| 12 | 0.1958729272 | 0.1958729272 | 1.40948e+00 | 1.40948e+00 |
| 40 | 0.0761462774 | 0.0761462774 | 6.80264e-02 | 6.80264e-02 |
| 60 | 0.0259428590 | 0.0259428590 | 1.78229e-02 | 1.78229e-02 |
| 150 | 0.0081217390 | 0.0081217390 | 1.58906e-04 | 1.58906e-04 |

- **Reference values.** Same reference as the Euler script, verified above.
- **The picture shows what was computed.** Frames 6, 16 and the contact sheet were viewed; all labels match. The script comment's bounds are correct (global max 1.449720, min 0.0081217 at $m=150$). No clamping or masking. The band's evaluation on the reference is F2.
- **Legacy.** All 21 printed $y(5)$ values and all $m$ labels match.

### Legacy archive (consulted)

- Animations `Euleraa.gif` (30 frames, 20 runs plus a blank opening and holds) and `MEuleraa.gif` (32 frames, 21 runs) were extracted. Labels were read by OCR. The OCR confusions (5 read as 9 in 50, 52, 55, 56, and a line crossing the digits of 1.7774834) were resolved by viewing the crops.
- The full printed tables of Examples 11 and 12 were compared with the runs (`tables.py`). Of 586 printed pairs, 537 matched automatically. The 13 flagged mismatches were all OCR misreads (typically 8 read as 6), and each was checked by eye against the image and agrees. The remaining pairs were not parsed by OCR, so they were not individually compared; the six final values were read directly from the images and agree.
- Both legacy animation portals are represented on the page, with the same function, interval, initial value and $m$ sequences. **No Fidelity finding.**

