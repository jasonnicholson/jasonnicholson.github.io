# Euler's Method for ODE's — animation review (round 9)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. Every checkable claim in the ledger below agrees with my independent computation at the precision the page states it to.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 19.7 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

Independent reference: scipy DOP853 (rtol 1e-13, atol 1e-16), cross-checked against mpmath `odefun` at 30 digits. It gives y(5) = 0.00811992046487 from both. Independent Euler and midpoint loops are in `indep.py`.

### Description
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| D1 | Euler: y_{n+1}=y_n+h f(t_n,y_n) | confirmed | script line 28 |
| D2 | Euler LTE O(h^2), global O(h), linear improvement | confirmed | the script's `euler` on y'=-y+t, y(0)=1 (closed form): error ratios on halving h are 2.008, 2.004, 2.002 |
| D3 | Mathews' modified Euler = explicit midpoint y_n+h f(t_n+h/2, y_n+h/2 f(t_n,y_n)) | confirmed | archive `gr_42.gif` MEuler subroutine; script line 30 |
| D4 | Midpoint global O(h^2) | confirmed | the script's `meuler` on the same problem: ratios 4.030, 4.015, 4.008 |

### Animations intro
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | IVP y'=1-t·cbrt(y), y(0)=1, 0≤t≤5 | confirmed | both scripts lines 12-15 / 14-17; Mathews Ex. 11 code `gr_229` |
| I2 | each frame a complete run, h=5/m, m values of Mathews' animation | confirmed | m lists match label crops `labels_E.png` (20 values) and `labels_M.png` (21 values) |
| I3 | gray reference = fixed-step RK4, 50 000 steps | confirmed | script `rk4(50_000)`; its y(5)=0.008119920464868 vs mpmath 0.00811992046486796 |
| I4 | frames labelled with y(5), error at t=5, largest grid-point error | confirmed | annotate lines 94-96; frames |
| I5 | red band: h·\|f_y\| along reference exceeds the stability limit | confirmed | `onset` uses tref/yref; zlim=2 |
| I6 | every y(5) printed in Euleraa.gif / MEuleraa.gif agrees to 7 decimals | confirmed | all 41 legacy labels equal my values rounded to 7 d.p. (indep.out "legacy" column) |
| I7 | Examples 11/12 print m=40,100,150 and final values agree | confirmed | Ex.11: -0.0174406, 0.00811736, 0.00811821 (archive `gr_235/242/249`) vs computed -0.0174406187, 0.0081173646, 0.0081182053. Ex.12: 0.0761463, 0.00813852, 0.00812174 (`gr_257/264/271`) vs 0.0761462774, 0.0081385159, 0.0081217390 |

### Case 1 (Euler)
| # | Claim | Verdict | Evidence (computed) |
|---|---|---|---|
| A1 | heading m=10 to 150; 20 values listed | confirmed | script `ms`; 20 committed frames |
| A2 | reference peak about 1.4498 near t=0.88 | confirmed | 1.449767 at t=0.88356 |
| A3 | decays toward nullcline y=1/t^3 (y'=0) | confirmed | 1-t·y^{1/3}=0 ⇔ y=t^-3; y(5)=0.008120 > 1/125=0.008 |
| A4 | reference y(5)=0.0081199 | confirmed | 0.0081199205 |
| A5 | m=10..40 zig-zag in tail and dip below zero; exact stays positive | confirmed | min y: -0.4624, -0.1702, -0.1315, -0.1163, -0.0322, -0.0452, -0.0174; reference min on [0,5] is 0.00812 |
| A6 | y(5)≈1.777 (m=10), 0.391 (m=30), -0.0174 (m=40) | confirmed | 1.7774834, 0.3907263, -0.0174406 |
| A7 | m=40 is the first Example 11 run | confirmed | archive |
| A8 | m=45 last steps alternate by less than 0.009 | confirmed | final increments +0.00022, -0.00327, +0.00852 |
| A9 | from m=50 runs decrease steadily after peak | confirmed | zero positive increments after the peak for m=50..150 |
| A10 | error at t=5: -4.2e-6 (m=60), -1.7e-6 (m=150); y(5)≈0.0081182 | confirmed | -4.22e-6, -1.715e-6, 0.0081182053 |
| A11 | from m=55, error at t=5 more than 1e4 times smaller than max error | confirmed | ratios 1.5e4 (m=55), 1.3e4 for m=60..150; m=50 is 3.3e3, so "from 55" is right |
| A12 | m=45..150 max error at t in [1.64,1.73], after peak, run above reference | confirmed | t from 1.643 to 1.727, all errors positive |
| A13 | max error falls at every refinement | confirmed | monotone over all 20 m |
| A14 | from m=45, about halves when m doubles | confirmed | ratios 45→90 2.031, 50→100 2.029, 55→110 2.024, 60→120 2.024, 70→140 2.019 |
| A15 | 5.7e-2 (60), 2.8e-2 (120), 2.2e-2 (150) | confirmed | 5.698e-2, 2.816e-2, 2.247e-2 |
| A16 | f_y=-t/(3y^{2/3}) reaches -41.3 at t=5 | confirmed | -41.2554 (also the maximum of \|f_y\| on [0,5]) |
| A17 | threshold h≈0.0485, m≤103; here m=10..100 | confirmed | 2/41.2554=0.048478, i.e. m>103.14 crosses; onset exists for m≤100, none for m≥110 |
| A18 | 1+h f_y<-1 amplifies with alternating sign | confirmed | follows from h\|f_y\|>2 (linearised error recursion) |
| A19 | m=10..40 error exceeds 25× reference at same t | confirmed | max \|e\|/Y: 217.9, 125.3, 88.0, 67.0, 47.1, 37.0, 25.44 (m=40, the tightest) |
| A20 | m=25 step from t=4.2: error +0.429 → -0.009 | confirmed | +0.4292 → -0.0093 |
| A21 | m=10 onset t≈2.92 | confirmed | 2.9228 (script), 2.92 (mine) |
| A22 | m=10..45 error at t=5 larger than just before onset | confirmed | e.g. m=10 1.77 vs 0.258; m=45 7.1e-3 vs 8.1e-5; all seven hold |
| A23 | m=50..100 onset from t≈3.95 to t≈4.95 | confirmed | 3.9503 … 4.9495 |
| A24 | m=50..100 steady decrease, error at t=5 smaller than before onset | confirmed | e.g. m=50 2.11e-5 vs 4.66e-5; m=100 2.56e-6 vs 3.04e-6; all seven hold |
| A25 | m=110..150 h\|f_y\|<2 up to t=5 | confirmed | onset none |
| A26 | link/embed eulersmethodaa.jl / .gif | confirmed | correct files; GIF byte-identical to regen |
| A27 | alt text: peak near 1.45 at t≈0.88, decays to 0.0081; 1.777 at m=10; band m=10..100; steady from m=50; 0.0081182; -1.7e-06 and 2.2e-02 at t≈1.67 | confirmed | as above; m=150 argmax at t=1.667 |

### Case 2 (modified Euler / midpoint)
| # | Claim | Verdict | Evidence (computed) |
|---|---|---|---|
| B1 | heading m=12 to 150; 21 values listed | confirmed | script `ms`; 21 frames; Mathews labels |
| B2 | m=12..24 tail zig-zags | confirmed | tail increment signs alternate at the end for every m (e.g. m=12 `+-+-`, m=20 `-+++-+-+`); frames |
| B3 | m=24 only last three steps alternate (+0.069, -0.076, +0.489), y(5)≈0.613 | confirmed | +0.0692, -0.0755, +0.4889; earlier tail increments -,-,+,+,+,+ do not alternate; 0.6126681 |
| B4 | m=28..60 turn upward before t=5 | confirmed | after the minimum every increment is positive for m=32..60 |
| B5 | m=28 one small dip 0.0075 in second-to-last step | confirmed | -0.0075 at t=4.643 is the only negative increment after the minimum |
| B6 | rise from minimum 0.35 (28), 0.057 (40), 0.015 (60) | confirmed | 0.3501, 0.05716, 0.01500 |
| B7 | y(5)≈0.384, 0.0761, 0.0259 | confirmed | 0.3841123, 0.0761463, 0.0259429 |
| B8 | m=40 is the first Example 12 run | confirmed | archive |
| B9 | m=70 upturn 0.0008; m≥80 decrease steadily | confirmed | 0.000756; zero positive increments after the peak for m≥80 |
| B10 | from m=16 error at t=5 falls at every refinement; 2.5e-4 (80), 1.8e-6 (150); y(5)≈0.0081217 | confirmed | monotone from m=16 (m=14→16 rises, consistent with "from m=16"); 2.52e-4, 1.82e-6, 0.0081217390 |
| B11 | m=16..70 error at t=5 is the largest error | confirmed | argmax at t=5.00 for each |
| B12 | m≥80 error at t=5 is 2.5 to 87 times smaller than the max error; max at t in [3.19,3.22] | confirmed | ratios 2.5, 8.9, 21, 50, 87; t=3.188, 3.222, 3.200, 3.208, 3.200 |
| B13 | max error 6.3e-4 (80), 1.6e-4 (150) | confirmed | 6.275e-4, 1.589e-4 |
| B14 | factor 3.9 from 80 to 150 vs (150/80)^2≈3.5; Euler 1.9 vs 1.9 | confirmed | 3.949; 3.516; 1.890; 1.875 |
| B15 | at m=150 about 140× smaller than Euler's 2.2e-2; errors at t=5 about the same size | confirmed | 141.4; -1.72e-6 vs +1.82e-6 |
| B16 | R(z)=1+z+z²/2, \|R\|≤1 on negative real axis exactly for -2≤z≤0 | confirmed | numerical scan gives [-2.00000, 0.00000] |
| B17 | m≤103 (here 12..100) exceed 2; onset from 2.99 (m=12) to 4.95 (m=100) | confirmed | 2.9869, 4.9495 |
| B18 | for each of m=12..100 error at t=5 larger than just before onset | confirmed | all 19 hold; tightest m=100: 1.86e-5 vs 1.39e-5 |
| B19 | m=120,150 below 2 up to t=5 | confirmed | onset none |
| B20 | link/embed eulersmethodbb.jl / .gif | confirmed | correct files; GIF byte-identical to regen |
| B21 | alt text: zig-zag 12..24 (24 only last three steps), upturn 28..60, 0.0761 at m=40, band 12..100, steady from 80, 0.0081217, +1.8e-06 and 1.6e-04 near t=3.20 | confirmed | as above |

### 3. Implementation checks

### `eulersmethodaa.jl`
- **Method:** this is plain forward Euler (line 28). It uses the real cube root `cbrt`, the same as Mathews' `Sign[y] Abs[y]^(1/3)`.
- **Numbers:** the instrumented copy (`inst_aa.out`) and my Python (`indep.out`) agree to every printed digit for all 20 m. Some pairs, script / mine: m=10 y(5) 1.7774833658 / 1.7774834; m=40 -0.0174406187 / -0.0174406187; m=150 0.0081182053 / 0.0081182; max error at m=150 2.2473e-2 at t=1.667 / 2.2473e-2 at t=1.667. Onsets also agree, e.g. m=10 2.9228 / 2.92.
- **Order:** on a closed-form IVP the script's own `euler` routine gives error ratios of about 2.00 on halving h.
- **Reference:** RK4 with 50 000 steps gives y(5) = 0.008119920464868, which matches mpmath to about 1e-14. `refnodes` uses at least 50 000 substeps, so its error is many orders of magnitude below the smallest quoted error (1.7e-6).
- **Picture:** I viewed the contact sheet and frames 8 (m=45) and the m=10/40/150 tiles. The titles name the right function and m. The band starts at the computed onset. The annotations match the computed values. The y-limits (-0.55, 1.9) contain every value: global min -0.4624, max 1.7775, as the script comment says, and an `error()` guard enforces it. Nothing is clamped.

### `eulersmethodbb.jl`
- **Method:** this is the explicit midpoint method (line 30). It is identical to Mathews' MEuler subroutine (archive `gr_42`) and to the Description formula.
- **Numbers:** all 21 runs agree with my Python. Some pairs, script / mine: m=24 0.6126680617 / 0.6126681; m=80 0.0083719546 / 0.0083720; m=150 max error 1.5891e-4 at t=3.200 / 1.59e-4 at 3.20.
- **Order:** the script's `meuler` on the closed-form IVP gives ratios of about 4.0.
- **Reference:** same RK4 as Case 1, verified above.
- **Picture:** I viewed the contact sheet and frame 6 (m=24). It shows the three-step alternation and the annotations y(5)=0.6126681 and max error 6.0e-01 at t=5.00. The script comment's window bounds (min 0.0081 at m=150, max 1.4497) are right: computed 0.008122 and 1.449720.

### GIFs
Both committed GIFs are byte-identical to fresh runs of the scratch copies (manifest), so the frames show exactly what the scripts compute.

### Fidelity to the legacy archive
- The function, initial value and interval match Mathews.
- The m sequences match both animations exactly: 20 and 21 runs.
- Every printed y(5) matches.
- Both of Mathews' animation portals (Euler1, MEuler1) are covered, and each holds exactly one item.
- No departures found.

