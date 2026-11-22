# Adams-Bashforth-Moulton Method — animation review (round 3)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, no misleading statements and no fidelity departures. Every numerical and behavioural claim on the page agrees with my independent computation at the precision it is stated to (see the ledger). The animation reproduces Mathews' 21-value m sweep, and each y(5) value matches Mathews' frame labels to every printed digit.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 15.0 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adamsbashforthmoultonaa.gif` | 21 | byte-identical | adamsbashforthmoultonaa |

### Page references

- Scripts linked: `adamsbashforthmoultonaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Commands: `python3 -I indep.py`, `python3 -I stab.py`, `python3 -I onset.py`, `julia instr.jl`. All were run in the review folder. "Ref" means the solve_ivp DOP853 solution (rtol 1e-13, atol 1e-15), which agrees with Radau to 12 digits.

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | ABM is a predictor-corrector multistep scheme for y'=f(t,y). The 4-step form is an explicit AB predictor followed by an implicit AM corrector that "immediately refines it" | Script lines 57-60: AB4 predictor (55,-59,37,-9)/24, then one AM corrector (9,19,-5,1)/24 evaluated at f(t_{n+1}, y_pred), i.e. PECE. Order check below shows 4th order | confirmed |
| D2 | Not self-starting; initial points come from a one-step method (such as RK4) | Lines 40-49: RK4 for y1..y3 | confirmed |
| D3 | After startup, each new value reuses prior f evaluations (low per-step cost) | 2 new f evaluations per step (f at y_n and at y_pred). The script recomputes fn1..fn3 rather than caching them, which is a performance matter only | confirmed |
| A1 | Repeats Mathews' step-refinement sweep for legacy Example 11 | lnk_12 is Example 11 and links Animation 1 (Adamsaa) | confirmed |
| A2 | y' = 1 - t∛y, y(0)=1, 0≤t≤5 | Script line 12 (cbrt = real cube root), lines 66-68. Mathews gr_165/gr_166 use 1 - t Sign[y]·∛|y| | confirmed |
| A3 | Each frame is a complete ABM4 run with m subintervals, h=5/m, first three steps by RK4 | Lines 109-111 and 34-61 | confirmed |
| A4 | 21 values m = 12,14,…,120,150 as in Mathews' animation | Script line 69. Legacy GIF: a blank frame, then m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 (read from the frames). Committed GIF has 21 frames | confirmed |
| A5 | Frames are labelled with computed y(5) and its error | Lines 129-130. Frames 1, 12, 14, 16, 21 and the contact sheet viewed | confirmed |
| A6 | Gray reference is RK4 at h=1e-4, high accuracy | RK4 h=1e-4 vs DOP853: max difference on the grid 9.7e-13, y(5) difference 1e-17 | confirmed |
| B1 | Reference rises from 1 to about 1.4498 near t=0.88 | Peak 1.449767 at t=0.88356 (root of f(t,y(t))=0) | confirmed |
| B2 | Reference y(5)=0.0081199 | 0.00811992046 (DOP853, Radau, RK4 all agree). Mathews prints 0.00811992 | confirmed |
| B3 | m=12 to 52 visibly break away in the tail from t≈3.2 to 4.7 depending on m | First grid t with \|err\|>0.02: m=12 3.33, 14 3.21, 16 3.44, 18 3.33, 20 3.50, 24 3.96, 28 3.75, 32 3.75, 36 4.17, 40 4.38, 44 4.20, 48 4.69, 52 4.62. Frames agree | confirmed |
| B4 | Each of m=12 to 52 goes below zero somewhere | min y: -0.419, -0.453, -0.275, -0.243, -0.363, -0.144, -0.176, -0.116, -0.119, -0.053, -0.065, -0.0049, -0.033 (all negative) | confirmed |
| B5 | At m=48 only to -0.0049, too little to see | min y = -0.004882 at t=4.896. Frame 12 shows no visible dip | confirmed |
| B6 | m=56 and 60 stay on the reference until about t=4.8 and 4.9, then rise above it by up to 0.11 and 0.096 | First \|err\|>0.02: 4.82 and 4.92. Max error +0.1080 (t=4.911) and +0.09555 (t=5). min y stays positive (0.0126, 0.0096) | confirmed |
| B7 | Across m=12 to 60 the end value ranges between -0.363 (m=20) and 0.632 (m=16) | Min y(5) = -0.3628404 (m=20), max = 0.6321470 (m=16) | confirmed |
| B8 | m=12: y(5)=0.0214, yet off by 0.74 at t≈4.17 | y(5)=0.0214088. Max \|err\| = 0.7364 at t=4.167 | confirmed |
| B9 | From m=60 on, the error in y(5) falls at every refinement | \|err(5)\| for m=60…150: 9.555e-2, 2.081e-3, 1.094e-5, 2.940e-7, 4.489e-9, 5.655e-10, 1.356e-10 (strictly decreasing) | confirmed |
| B10 | 9.6e-2 (m=60), 2.1e-3 (m=70), 1.1e-5 (m=80), 4.5e-9 (m=100), 1.4e-10 (m=150) | As in B9 | confirmed |
| B11 | m=70 error is 26% of y(5) but too small to see | 2.081e-3/8.1199e-3 = 25.6%. Frame 16 shows no visible gap | confirmed |
| S1 | ∂f/∂y = -t/(3y^{2/3}) reaches -41.3 at t=5 | -5/(3·0.0081199^{2/3}) = -41.255. \|∂f/∂y\| is increasing on [0.88,5], so t=5 is the maximum | confirmed |
| S2 | This ABM4 PECE is stable on real λ<0 only while h\|λ\|≤1.285 | Characteristic polynomial derived independently with sympy (it matches script line 81 coefficient by coefficient). Spectral radius <1 on (-1.28482, 0) and >1 on [-60, -1.2849]. Brute-force recurrence: decays at z=-1.284, grows at -1.2852. Limit 1.284816 | confirmed |
| S3 | Every m≤160 (h>0.0311) exceeds 1.285 before t=5, so every frame does | 1.284816/41.255 = 0.031143 gives m < 160.55 | confirmed |
| S4 | Shaded region starts at t≈2.83 (m=12) to t≈4.89 (m=150) | Onsets computed independently with brentq: 2.826 and 4.890. The script prints 2.826 and 4.8896 | confirmed |
| S5 | m=12 to 60: error at the last step before shading is between 5.6e-5 and 2.2e-3; after it the error reaches 0.096 to 0.74 | Pre-onset errors span 5.64e-5 (m=60) to 2.17e-3 (m=20). Post-onset max errors span 0.0955 (m=60) to 0.736 (m=12) | confirmed |
| S6 | m=100, 120, 150: below 1e-8 at that step, and the error at t=5 is smaller still | Pre-onset 8.25e-9, 1.12e-9, 1.66e-10. At t=5: 4.49e-9, 5.66e-10, 1.36e-10 (each smaller) | confirmed |
| S7 | h=0.0311 is a linear stability bound, not an accuracy threshold | m=70 to 150 all have h>0.0311 yet are accurate (B9) | confirmed |
| M1 | Module's worked solution uses n=50, 100 and 150 | gr_166 (n=50), gr_179 (Y_101), gr_186 (Y_151) | confirmed |
| M2 | n=100 and 150 end at y(5)=0.0081199 | Mathews: 0.00811992 for both. Mine: 0.0081199160 and 0.0081199203 | confirmed |
| M3 | n=50 (h=0.1) falls to y_48 ≈ -0.0018 at t=4.8 and ends at y(5) ≈ 0.138, about 17 times the exact value | Mine: y_48 = -0.0018309, y_50 = 0.13809, ratio 17.01. Mathews gr_170: {4.8, -0.0018309}, {5., 0.13809} | confirmed |
| W1 | Link `[Julia source](adamsbashforthmoultonaa.jl)` and embed `adamsbashforthmoultonaa.gif` are this case | The script writes exactly that GIF. The regenerated GIF is byte-identical | confirmed |
| W2 | Heading: ABM4 PECE sweep, y'=1-t∛y, y(0)=1, m=12 to 150 | Script line 69 | confirmed |
| T1 | Alt text: the reference peaks near 1.45 at t≈0.88 and decays to 0.0081 | B1, B2 | confirmed |
| T2 | Alt text: m=12 to 60 visibly break away, ending between -0.363 and 0.632 | B3, B6, B7 | confirmed |
| T3 | Alt text: shaded region where h·\|∂f/∂y\| > 1.285 appears in every frame | S3. Every frame viewed on the contact sheet has shading | confirmed |
| T4 | Alt text: from m=70 on the run lies on the reference at this scale; y(5)=0.0081199 at m=100 and 150 | Max \|err\| for m≥70 is ≤2.1e-3, below one pixel (about 0.006 per pixel). Frames 16 and 21 | confirmed |
| C1 | Script comment line 95: zlim 1.2848 | 1.284816 | confirmed |
| C2 | Script comment line 106: every value lies inside the y-limits; min -0.453 at m=14, max 1.4498 | Global min -0.45300 (m=14), max 1.449767 (reference). ylims (-0.5, 1.8). No clipping | confirmed |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**It is the method it claims to be.** The script runs a 4th-order Adams-Bashforth predictor and a 4th-order Adams-Moulton corrector in PECE mode, with one correction per step and f re-evaluated at the corrected value on the next step. The first three steps use classical RK4. This is the same variant, coefficient for coefficient, as Mathews' Mathematica `ABM` subroutine (archive image gr_38): RK4 start, `p = Y_j + h/24(-9F0+37F1-59F2+55F3)`, corrector `Y_j + h/24(F1-5F2+19F3+9f(T_{j+1},p))`. The page's Description of the method matches it.

**The numbers are right.**
- Order property: my independent Python implementation of the same scheme, run on y'=-y+t, y(0)=1 (exact solution t-1+2e^{-t}) at t=2 with m=10…160, gave error ratios on halving of 20.4, 18.8, 17.5 and 16.8. These approach 16, which is 4th order.
- Agreement with the script: the script's instrumented output and my Python agree in all printed digits for all 21 runs. Examples of y(5):

| m | script | independent | Mathews' frame |
|---|---|---|---|
| 12 | 0.021408782921 | 0.0214088 | 0.0214088 |
| 16 | 0.632146980620 | 0.6321470 | 0.632147 |
| 20 | -0.362840421848 | -0.3628404 | -0.3628404 |
| 60 | 0.103670824582 | 0.1036708 | 0.1036708 |
| 80 | 0.008108983361 | 0.0081090 | 0.008109 |
| 150 | 0.008119920329 | 0.0081199 | 0.0081199 |

  The other 15 m values also match Mathews' labels.
- Stability limit (script lines 79-95): I derived the PECE characteristic polynomial myself with sympy. It is identical to the coefficients on line 81, and the limit is z = -1.284816 by both root-finding and direct simulation of the recurrence. The spectral radius is below 1 on the whole of (-1.2848, 0) and above 1 down to z=-60. The script's bisection bracket [-1.5, -1.0] therefore contains the only crossing.

**Its reference values are right.** The reference is RK4 with h=1e-4. Against DOP853 (rtol 1e-13), its maximum difference on the grid is 9.7e-13, far below the smallest error the page discusses (1.4e-10 at m=150, about 700 times larger). Radau gives the same y(5)=0.00811992046487. Because the reference stays positive, the real-cube-root branch is not an issue for it.

**The picture shows what was computed.** I viewed frames 1 (m=12), 12 (m=48), 14 (m=56), 16 (m=70) and 21 (m=150), and the contact sheet (m=12…150). Titles state the right f, m and h. The annotations show the computed y(5), the signed error, the reference y(5) and the onset time, all matching the instrumented output. The shaded vspan begins at the computed onset. The magenta polyline passes through the ABM nodes, and the red dot is at (5, y_m). The y-limits (-0.5, 1.8) contain every computed value (the global min is -0.453), so nothing is clamped. Since 21 frames are produced for 21 m values, every frame is a run. One display detail is not misleading: for m=12 the magenta chords visibly cut inside the gray reference near the peak (t≈0.4 to 1.25). That is linear interpolation between widely spaced nodes, and the nodes themselves lie on the reference.

### Notes
- The page's Example 11 departs from Mathews in no material way. It adds a reference curve, the stability shading and error labels, and it uses the same function, interval, initial value and m sequence. The legacy animation's leading blank frame is omitted, which does not matter.
- Placeholder and legacy-inventory sections were not reviewed, per the brief.

