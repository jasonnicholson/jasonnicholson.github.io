# Adams-Bashforth-Moulton Method — animation review (round 9)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Animations section, alt text and Description was confirmed against independent computation, the instrumented script and the frames (ledger below). No implementation, page-match or fidelity defect found.

Counts: Error 0, Misleading 0, Minor 0.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 28.1 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | ABM is a predictor-corrector multistep scheme; "4-step form": explicit AB predictor, implicit AM corrector "immediately refines it" | Script lines 57-60: AB4 predictor (55,-59,37,-9)/24, one AM3/4-step corrector evaluation (9,19,-5,1)/24 = PECE, one correction. Order check (y'=-2ty on [0,2]): error ratios 31.95, 24.77, 20.62, 18.38, 17.21 -> 16, i.e. order 4 | confirmed |
| D2 | Not self-starting; starting values from a one-step method such as RK4 | Script lines 41-49: classical RK4 for y1..y3 | confirmed |
| A1 | Repeats the step-refinement sweep of Mathews' animation for legacy Example 11 | Mathews Example 11 (gr_165): y' = 1 - t*cbrt(y), y(0)=1, 0<=t<=5; Adamsaa.gif is a sweep over m | confirmed |
| A2 | y' = 1 - t cbrt(y), y(0)=1, 0<=t<=5 | script lines 12, 66-68 | confirmed |
| A3 | Each frame a complete ABM4 run with m subintervals, h=5/m, first three steps RK4 | script lines 34-64, 109-111 | confirmed |
| A4 | "the 21 values of Mathews' animation, m = 12,14,...,150" | Mathews GIF: 39 frames, 22 distinct = blank + m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 (read from `labels.png`); script `ms` identical; Mathews' printed y(5) per frame agree with the script's to every digit shown (e.g. 0.031208, 0.5320078, 0.0102009, 0.008109, 0.0081196) | confirmed |
| A5 | Frames labelled with computed y(5) and its error | script lines 129-130; frames 1, 12, 14, 16, 21 viewed | confirmed |
| A6 | Thick gray curve = reference from fixed-step RK4 at h=1e-4; no closed form used | script lines 15-32, 70-73, 123 (gray70, lw=4). Accuracy: script yex5 = 0.008119920464868; mpmath odefun (30 digits) 0.00811992046486796; DOP853 rtol 1e-13 0.00811992046487 -> agreement ~1e-17, ample for the smallest error shown (1.4e-10) | confirmed |
| B1 | Reference rises to about 1.4498 near t=0.88 | peak t=0.883556, y=1.449767 (Brent on f=0 with DOP853 dense output); script ref max 1.44976669 | confirmed |
| B2 | Reference y(5)=0.0081199 | 0.0081199205 | confirmed |
| B3 | m=12..52 visibly break away in the tail, from t≈3.2 to 4.7 depending on m | first node with |err|>0.02: 3.21 (m=14) ... 4.69 (m=48); at 0.01: 3.12..4.62; frames show visible departure for every m=12..52 | confirmed |
| B4 | Each of m=12..52 goes below zero somewhere | min y: -0.419, -0.453, -0.275, -0.243, -0.363, -0.144, -0.176, -0.116, -0.119, -0.053, -0.065, -0.0049, -0.033 (all <0); m=56,60 stay >0 | confirmed |
| B5 | then cbrt(y) is the real cube root | script uses `cbrt`; Mathews uses Sign[y]*cbrt(|y|) (gr_166) - same function | confirmed |
| B6 | at m=48 only to -0.0049, too little to see | min -0.00488 at t=4.896; ~0.8 px at frame scale; frame 12 viewed | confirmed |
| B7 | m=56 and 60 stay on reference until about t=4.8 and 4.9, then rise above it by up to 0.11 and 0.096 | |err|>0.02 first at t=4.82 (m=56), 4.92 (m=60); max signed error +0.108 and +0.0956, min signed error only -0.0002 / -0.0007 | confirmed |
| B8 | Across m=12..60 end value jumps between -0.363 (m=20) and 0.632 (m=16) | y(5) min -0.3628404 (m=20), max 0.6321470 (m=16) | confirmed |
| B9 | m=12: y(5)=0.0214, off by 0.013, error 1.6x exact, y(5) 2.6x exact, run off by 0.74 at t≈4.17 | 0.0214088, err +0.01329, rel 1.637, ratio 2.637, max |err| 0.736 at t=4.167 | confirmed |
| B10 | From m=60 on error in y(5) falls at every refinement: 9.6e-2, 2.1e-3 (26% of y(5)), 1.1e-5, 4.5e-9 (m=100), 1.4e-10 (m=150) | 9.555e-2, 2.081e-3 (25.6%), 1.094e-5, 2.94e-7 (m=90), 4.489e-9, 5.655e-10 (m=120), 1.356e-10 - strictly decreasing | confirmed |
| B11 | m=70 error too small to see in the frame | 0.0021 ~0.35 px; frame 16 viewed, curve on reference | confirmed |
| S1 | df/dy = -t/(3y^(2/3)) reaches -41.3 at t=5 | -41.2554 at t=5; |df/dy| monotone increasing for t>1, max at t=5 | confirmed |
| S2 | ABM4 PECE stable on y'=λy, real λ<0, only while h|λ|<=1.285 | own characteristic polynomial ζ^4-ζ^3-(z/24)(9P+19ζ^3-5ζ^2+ζ) via numpy roots: boundary z=-1.284816; max root modulus <1 on (-1.2848,0); min modulus 1.00005 >1 on [-60,-1.2849] (no re-entry) | confirmed |
| S3 | for every m<=160 (h>0.0311) h|df/dy| exceeds 1.285 before t=5 | h_crit=1.284816/41.2554=0.03114 (m=160.55); m=160 exceeds, m=161 does not | confirmed |
| S4 | shaded region from t≈2.83 (m=12) to t≈4.89 (m=150) | onset 2.826 / 4.890 (Python), 2.8260 / 4.8896 (script) | confirmed |
| S5 | m=12..60: error at last step before shaded region 5.6e-5..2.2e-3; after it 0.096..0.74 | last pre-onset errors range 5.64e-5 (m=60) .. 2.17e-3 (m=20); post-onset max 0.0956 (m=60) .. 0.736 (m=12) | confirmed |
| S6 | m=100,120,150: below 1e-8 there, error at t=5 smaller still | pre-onset 8.25e-9, 1.12e-9, 1.66e-10; at t=5 4.49e-9, 5.66e-10, 1.36e-10 | confirmed |
| S7 | h=0.0311 is a linear stability bound, not an accuracy threshold | follows from S5/S6 (m=100..150 accurate despite exceeding it) | confirmed |
| L1 | Module's worked Example 11 uses n=50, 100, 150 | lnk_12 images gr_167/170 (n=50, step 0.1), gr_177 (step 0.05), gr_184 (step 1/30) | confirmed |
| L2 | n=100 and 150 runs end at y(5)=0.0081199 | Mathews 0.00811992 both; own 0.008119916, 0.00811992 | confirmed |
| L3 | n=50 (h=0.1) falls to y48≈-0.0018 at t=4.8, ends at y(5)≈0.138, about 17x exact | own -0.00183 at t=4.80, 0.13809, ratio 17.01; Mathews table gr_170: {4.8, -0.0018309}, {5., 0.13809} | confirmed |
| T1 | Case heading: ABM4 PC sweep, same ODE/IC, m=12 to 150 | script | confirmed |
| W1 | `[Julia source](adamsbashforthmoultonaa.jl)` and embedded `adamsbashforthmoultonaa.gif` are this case | both files in page folder; GIF byte-identical to regeneration; frames show this ODE and the m sequence | confirmed |
| Alt1 | gray reference peaks near 1.45 at t≈0.88, decays to 0.0081 at t=5 | B1, B2 | confirmed |
| Alt2 | m=12..60 visibly break away, ending between -0.363 and 0.632 | B3, B7, B8 | confirmed |
| Alt3 | shaded region where h|df/dy|>1.285, in every frame | onset exists for all 21 m (S3, S4); shading visible in all frames on the contact sheet incl. m=150 | confirmed |
| Alt4 | from m=70 on the run lies on the reference at this scale; y(5)=0.0081199 at m=100 and 150 | max |err| over run for m>=70 is 0.0021; B10 | confirmed |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

1. **Method is what it claims.** AB4 predictor + single AM corrector evaluation (PECE, no iteration of the corrector), RK4 start for y1..y3. Coefficients compared by property, not memory: on y'=-2ty, y(2)=e^-4 the error ratio under halving tends to 16 (31.95, 24.77, 20.62, 18.38, 17.21), so the scheme is 4th order. Further, my independent Python implementation reproduces Mathews' printed Mathematica tables for n=50, 100, 150 to all 6 printed digits at every sampled node (e.g. n=50: 1.44217 at t=1, 0.0897596 at t=3, 0.13809 at t=5), which is an external check of the coefficient set.
2. **Numbers are right.** Instrumented scratch copy (`instr.jl`) prints y(5) for all 21 m; they match my independent Python values to all printed digits (e.g. m=20 -0.3628404218 vs -0.3628404; m=100 0.0081199160 vs 0.0081199; m=150 err -1.3558e-10 vs -1.356e-10). Stability limit: script `zlim`=1.28481626 (companion matrix) vs mine 1.284816 (numpy roots of independently built polynomial). Onset times match to 4 decimals for every m.
3. **Reference values are right.** RK4 h=1e-4 y(5) = 0.008119920464868 vs mpmath 30-digit Taylor ODE solver 0.00811992046486796 and DOP853 0.00811992046487. Solution stays positive (min 0.00812 at t=5) so the real cube root has no sign issue on the reference.
4. **Picture shows what was computed.** Frames 1 (m=12), 12 (m=48), 14 (m=56), 16 (m=70) and the contact sheet (m=12..150) viewed: magenta polyline through the m+1 nodes, red dot at (5, y_m), gray reference, shaded span [onset, 5] where h|df/dy| along the reference exceeds 1.285; annotation text matches computed y(5), error, reference y(5) and onset. ylims (-0.5, 1.8) contain every computed value (min -0.453 at m=14, max 1.44975), so no clipping; xlims (-0.1, 5.1) contain the interval. 21 frames at 1 fps.

### Fidelity

Example function, IC, interval, the full 21-value m sequence and every Mathews y(5) label match the archive; the archive's three worked runs (n=50/100/150) are described correctly. No dropped archive case (the module has a single animation item).

