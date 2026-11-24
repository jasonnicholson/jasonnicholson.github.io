# Adams-Bashforth-Moulton Method — animation review (round 8)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: "2.6 times the exact value" attached to the error rather than to y(5)

- Location: `index.qmd` lines 41-42: "at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though that is still 2.6 times the exact value)".
- What is there: "that" grammatically refers to the nearest noun phrase, the error 0.013.
- What is true: the computed value y(5)=0.0214088 is 2.64 times the exact value 0.0081199, but the error 0.0132905 is 1.64 times the exact value. (Compare the parallel sentence at lines 59-60, "ends at y(5)≈0.138, about 17 times the exact value", where the ratio is correctly applied to y(5): 0.13809/0.0081199 = 17.01.)
- How I know: `python3 -I review/indep.py` prints `m= 12 y5=0.0214088 err=+1.33e-02 rel=1.64`; 0.0214088/0.0081199 = 2.64.
- Suggested correction: "at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though $y(5)$ is still 2.6 times the exact value)" or "(though that error is still 1.6 times the exact value)".

No other findings. In particular, every numerical claim on the page was reproduced by an independent computation (below), the method is the standard ABM4 PECE pair, and the page matches the legacy Example 11 animation in function, interval, initial value, the full list of 21 m values, and all 21 end values.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Summary: 0 Error, 0 Misleading, 1 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 14.3 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | ABM is a predictor-corrector multistep scheme for y'=f(t,y); 4-step form: explicit AB predictor, implicit AM corrector immediately refines it | script lines 57-60: AB4 (55,-59,37,-9)/24 predictor, AM (9,19,-5,1)/24 corrector, one correction, f re-evaluated at corrected value (PECE) | confirmed |
| D2 | Not self-starting; initial points by a one-step method such as RK4 | lines 41-49: RK4 for y1..y3 | confirmed |
| A1 | Repeats the step-refinement sweep of Mathews' animation for legacy Example 11 | legacy Example 11 = y'=1-t∛y, y(0)=1, 0≤t≤5 (gr_165); legacy Adamsaa.gif is the m-sweep | confirmed |
| A2 | y'=1-t∛y, y(0)=1, 0≤t≤5 | script lines 12, 66-68 | confirmed |
| A3 | Each frame is a complete ABM4 run with m subintervals, h=5/m, first three steps by RK4 | lines 109-111, 34-64 | confirmed |
| A4 | 21 values m=12,14,...,150 as listed, those of Mathews' animation | script line 69; legacy frame labels read: 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150; GIF has 21 frames | confirmed |
| A5 | Labelled with computed y(5) and its error | frame annotations (lines 129-130); frames 1, 12, 16, 21 viewed | confirmed |
| A6 | Thick gray curve is reference by fixed-step RK4 at h=1e-4 | lines 70-72, 123 | confirmed; accuracy: script ref y(5)=0.008119920465 vs DOP853 rtol 1e-13: 0.0081199205 |
| B1 | Reference rises from 1 to about 1.4498 near t=0.88 | DOP853: peak 1.449767 at t=0.88356; script ref: 1.449767 at 0.8836 | confirmed |
| B2 | decays to y(5)=0.0081199 | 0.0081199205 | confirmed |
| B3 | For m=12 through 52 the computed curve visibly breaks away from the reference in the tail (from t≈3.2 to 4.7, depending on m) | first grid t with abs error >0.01: 3.33, 3.21, 3.13, 3.33, 3.25, 3.96, 3.75, 3.59, 4.03, 4.38, 4.20, 4.48, 4.62 for m=12..52; frames confirm visible departure | confirmed (approximate range) |
| B4 | each of these runs goes below zero somewhere | min y for m=12..52: -0.419, -0.453, -0.275, -0.243, -0.363, -0.144, -0.176, -0.116, -0.119, -0.053, -0.065, -0.0049, -0.033 | confirmed |
| B5 | then ∛y is the real cube root | `cbrt` (line 12); Mathews uses Sign[y]∛|y| (gr_166) | confirmed |
| B6 | at m=48 only to -0.0049, too little to see | min -0.004882; frame 12 shows no visible dip below 0 | confirmed |
| B7 | m=56 and 60 stay on reference until about t=4.8 and 4.9, then rise above it by up to 0.11 and 0.096 | m=56: err 0.012 at t=4.73, 0.085-ref at 4.82, max +0.108 at t=4.911; m=60: first abs err>0.01 at 4.917, max +0.0956 at t=5; both stay positive (min 0.0126, 0.0096) | confirmed |
| B8 | Across m=12-60 end value jumps between y(5)≈-0.363 (m=20) and 0.632 (m=16) | min -0.3628404 (m=20), max 0.6321470 (m=16) | confirmed |
| B9 | m=12: y(5)=0.0214 off by only 0.013 | 0.0214088, err +0.01329 | confirmed |
| B10 | "(though that is still 2.6 times the exact value)" | y(5)/exact = 2.64; error/exact = 1.64 | wrong as worded (F1) |
| B11 | m=12 run off by 0.74 at t≈4.17 | max abs err 0.736 at t=4.167 | confirmed |
| B12 | From m=60 on, error in y(5) falls at every refinement | abs err: 9.56e-2, 2.08e-3, 1.09e-5, 2.94e-7, 4.49e-9, 5.66e-10, 1.36e-10 (m=60,70,80,90,100,120,150) | confirmed |
| B13 | 9.6e-2 (60), 2.1e-3 (70), 1.1e-5 (80), 4.5e-9 (100), 1.4e-10 (150) | as above | confirmed |
| B14 | m=70 error is 26% of y(5), too small to see in frame | 2.08e-3/8.12e-3 = 0.256; 0.002 on a 2.3-unit, ~390 px axis is <1 px; frame 16 shows no separation | confirmed |
| S1 | ∂f/∂y = -t/(3y^{2/3}) reaches -41.3 at t=5 | -5/(3·0.0081199^{2/3}) = -41.255 | confirmed |
| S2 | ABM4 PECE stable on y'=λy, real λ<0, only while h|λ|≤1.285 | independent companion matrix built by applying the scheme to basis vectors, bisection: 1.284816; scan of z∈[-50,0): stable set is exactly [-1.28480, 0), no re-entry; script's own polynomial gives 1.284816 | confirmed |
| S3 | for every m≤160 (h>0.0311) the threshold is exceeded before t=5; includes every frame | critical h = 1.284816/41.255 = 0.031143, m_crit = 160.55; m=160 onset t=4.994, m=161 no onset | confirmed |
| S4 | shaded region from t≈2.83 at m=12 to t≈4.89 at m=150 | onsets 2.826 and 4.890 (both script and independent) | confirmed |
| S5 | For m=12-60 error at last step before shaded region is between 5.6e-5 and 2.2e-3 | min 5.64e-5 (m=60), max 2.17e-3 (m=20) | confirmed |
| S6 | after it the error reaches 0.096 to 0.74 | max post-onset errors range 0.0956 (m=60) to 0.736 (m=12) | confirmed |
| S7 | for m=100,120,150 it is below 1e-8 there, and the error at t=5 is smaller still | pre-onset errors 8.25e-9, 1.12e-9, 1.66e-10; end errors 4.49e-9, 5.66e-10, 1.36e-10 (each smaller) | confirmed |
| S8 | h=0.0311 is a linear stability bound, not an accuracy threshold | follows from S3/S7: all m≤160 cross the bound yet m≥80 are accurate | confirmed |
| S9 | Module's Example 11 solution uses n=50, 100, 150 | lnk_12 code images (n=50, n=100) and final-value images y_51, y_101, y_151 | confirmed |
| S10 | n=100 and 150 runs end at y(5)=0.0081199 | legacy 0.00811992 (gr_179, gr_186); computed 0.008119916, 0.008119920 | confirmed |
| S11 | n=50 run falls to y_48≈-0.0018 at t=4.8 and ends at y(5)≈0.138, about 17 times exact | computed y48=-0.0018309 at t=4.80, y50=0.1380900, ratio 17.01; legacy table gr_170 shows {4.8,-0.0018309}, {5.,0.13809} | confirmed |
| W1 | Heading: ABM4 step-refinement sweep, y'=1-t∛y, y(0)=1, m=12 to 150 | script | confirmed |
| W2 | Julia source link `adamsbashforthmoultonaa.jl`; embed `adamsbashforthmoultonaa.gif` | files exist; script writes that GIF; manifest: byte-identical | confirmed |
| T1 | Alt: reference peaks near 1.45 at t≈0.88, decays to 0.0081 at t=5 | B1, B2 | confirmed |
| T2 | Alt: m=12 to 60 visibly breaks away, ending between -0.363 and 0.632 | B3, B7, B8 | confirmed |
| T3 | Alt: shaded region where h·|∂f/∂y|>1.285, in every frame | S3; all 21 frames shaded (contact sheet + frames 1,12,16,21) | confirmed |
| T4 | Alt: from m=70 on the run lies on the reference at this scale | max abs err over whole run for m≥70: 2.1e-3, 2.6e-5, 1.5e-5, 8.5e-6, 3.5e-6, 1.2e-6 | confirmed |
| T5 | Alt: y(5)=0.0081199 at m=100 and 150 | S10 | confirmed |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**Is the method it claims.** Four-step Adams-Bashforth predictor with coefficients (55,-59,37,-9)/24, Adams-Moulton corrector (9,19,-5,1)/24 applied once, f re-evaluated at the corrected value at the start of the next step: the standard ABM4 in PECE mode. Starting values y1..y3 by classical RK4 with the same h. Order check with the script's own `abm4` (`julia review/instr.jl`): on y'=y over [0,1] the end-error ratio on halving h tends to 16 (7.06, 11.81, 13.95, 14.98); on y'=-2ty (exact e^{-t^2}) 21.4, 18.8, 17.3, 16.7. Fourth order confirmed.

**Numbers are right.** Independent Python ABM4 (`review/indep.py`) agrees with the instrumented script to all printed digits for every m, e.g. y(5): m=12 0.0214088/0.021408783, m=16 0.6321470/0.632146981, m=20 -0.3628404/-0.362840422, m=60 0.1036708/0.103670825, m=100 0.0081199/0.008119916. All 21 end values also equal the y(5) labels in Mathews' legacy animation (0.0214088, 0.031208, 0.632147, 0.5320078, -0.3628404, -0.1443545, 0.0788702, 0.2516957, -0.1185897, 0.1822742, 0.0734851, 0.0481297, 0.0621776, 0.016797, 0.1036708, 0.0102009, 0.008109, 0.0081196, 0.0081199 x3), a third, independent implementation. Stability limit: script 1.284816, independent companion-matrix bisection 1.284816.

**Reference values are right.** Script RK4 h=1e-4 reference y(5)=0.008119920465; scipy DOP853 at rtol 1e-13, atol 1e-15: 0.0081199205. The reference is accurate well below the smallest error it is used to quote (1.4e-10 at m=150): script error -1.356e-10 vs independent -1.36e-10. The reference solution stays positive on [0,5] (min 0.00812), so |∂f/∂y| is finite and the onset computation is well defined.

**Picture shows what was computed.** Frames 1 (m=12), 12 (m=48), 16 (m=70), 21 (m=150) and the contact sheet viewed. Title function y'=1-t·y^(1/3) and m, h=5/m match the code; magenta polyline with markers at every grid point is the ABM4 run; red dot is (5, y_m); annotations y(5), error, reference y(5), and onset time match the instrumented output (e.g. m=12: 0.0214088, +1.3e-02, 2.83; m=150: -1.4e-10, 4.89). Shaded band starts at the computed onset and runs to t=5. y-limits (-0.5, 1.8) contain every computed value (global min -0.453 at m=14, max 1.4498); no clamping or masking is used. Frame count 21 = length of `ms`. No display issue changes what a viewer would conclude.

