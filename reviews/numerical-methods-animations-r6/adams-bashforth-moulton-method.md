# Adams-Bashforth-Moulton Method — animation review (round 6)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the alt text, in the frames and in the script's comments agrees with my independent computation at the precision it is stated to. The legacy archive agrees with the page as well: same ODE, same initial condition, same interval, same 21 values of m, and the same y(5) labels to every digit Mathews printed.

Two points looked like possible problems. I checked both and neither is a finding:
- **"Implicit Adams-Moulton corrector" versus the code.** The Description calls the corrector implicit. The code applies it once in PECE mode, without iterating to convergence. The page says the corrector "immediately refines" the prediction, which describes a single correction, and the stability paragraph's analysis is the PECE one. They are consistent.
- **Where the shaded region is computed.** The region is computed from h·|∂f/∂y| along the *reference* solution, not along each computed run. The page's "∂f/∂y … reaches −41.3 at t = 5" is likewise evaluated on the reference. This is the natural frozen-coefficient reading and is consistent throughout.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 13.7 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words, abridged) | Evidence | Verdict |
|---|---|---|---|
| D1 | ABM is a predictor-corrector multistep scheme; 4-step form: explicit AB predictor, implicit AM corrector "immediately refines it" | Code lines 57/60: AB4 (55,−59,37,−9)/24 and AM (9,19,−5,1)/24, one correction per step (PECE). Matches Mathews' theorem. | confirmed |
| D2 | Not self-starting; initial points generated with a one-step method (such as RK4) | Lines 41–49: RK4 for y1..y3 | confirmed |
| A1 | Repeats the step-refinement sweep of Mathews' animation for legacy Example 11 | Legacy Adamsaa.gif: same sweep, same ODE (gr_165: y' = 1 − t·∛y, y(0)=1, 0≤t≤5) | confirmed |
| A2 | y' = 1 − t∛y, y(0)=1, 0 ≤ t ≤ 5 | Script lines 12, 66–68; title of every frame | confirmed |
| A3 | Each frame is a complete ABM4 run with m subintervals, h = 5/m, first three steps by RK4 | Code; 21 frames, all distinct (md5) | confirmed |
| A4 | The 21 values m = 12, 14, …, 120, 150 are Mathews' | Script line 69; legacy frames read: 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 | confirmed |
| A5 | Frames labelled with computed y(5) and its error | Lines 129–130; frames 2, 14, 16 viewed | confirmed |
| A6 | Gray curve = reference by fixed-step RK4 at h = 1e-4 | Line 70/72. Script yex5 = 0.00811992046487; DOP853 0.00811992046487; Radau 0.00811992046487 | confirmed (accurate to about 1e-12) |
| B1 | Reference rises from 1 to about 1.4498 near t = 0.88 | Independent: max 1.449767 at t = 0.88356 | confirmed |
| B2 | Reference decays to y(5) = 0.0081199 | 0.0081199205 | confirmed |
| B3 | m = 12 through 52 break away in the tail, from t ≈ 3.2 to 4.7 depending on m | First t with \|err\| > 0.02: 3.21 (m=14) to 4.69 (m=48). With a 0.01 threshold, 3.13 to 4.62 | confirmed (threshold-dependent, as worded) |
| B4 | Each of m = 12..52 goes below zero somewhere | min y: −0.419, −0.453, −0.275, −0.243, −0.363, −0.144, −0.176, −0.116, −0.119, −0.054, −0.065, −0.0049, −0.033 | confirmed |
| B5 | At m = 48 only to −0.0049, too little to see | min −0.0049 at t = 4.896 (under 1 px at 480 px / 2.3 units) | confirmed |
| B6 | m = 56 and 60 stay on the reference until about t = 4.8 and 4.9 | First \|err\| > 0.02: 4.82 and 4.92 (m=56 err +0.013 at 4.73, +0.076 at 4.82) | confirmed |
| B7 | …then rise above it by up to 0.11 and 0.096 | max positive err 0.1080 (t=4.911), 0.0956 (t=5); m=56/60 min y > 0 | confirmed |
| B8 | Across m = 12..60, y(5) ranges from −0.363 (m=20) to 0.632 (m=16) | min −0.3628404 (m=20), max 0.6321470 (m=16) | confirmed |
| B9 | m = 12: y(5) = 0.0214, but off by 0.74 at t ≈ 4.17 | y(5) 0.0214088; max \|err\| 0.7364 at t = 4.167 | confirmed |
| B10 | From m = 60 on, the y(5) error falls at every refinement | 9.56e-2, 2.08e-3, 1.09e-5, 2.94e-7, 4.49e-9, 5.66e-10, 1.36e-10 (strictly decreasing) | confirmed |
| B11 | 9.6e-2 (m=60), 2.1e-3 (m=70), 1.1e-5 (m=80), 4.5e-9 (m=100), 1.4e-10 (m=150) | +9.56e-2, +2.08e-3, −1.09e-5, −4.49e-9, −1.36e-10 (magnitudes) | confirmed |
| B12 | m = 70 error is 26% of y(5), too small to see | 2.081e-3 / 8.120e-3 = 25.6%; under 1 px | confirmed |
| S1 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | −41.2554 | confirmed |
| S2 | ABM4 PECE stable on y' = λy, real λ < 0, only while h\|λ\| ≤ 1.285 | Independent sympy derivation of the characteristic polynomial; spectral radius ≤ 1 exactly on [−1.284816, 0), contiguous (z scanned at 1e-4 spacing); script zlim 1.28481626 | confirmed |
| S3 | Every m ≤ 160 (h > 0.0311) exceeds 1.285 before t = 5, which includes every frame | h* = 1.284816/41.2554 = 0.031143, so m < 160.55 | confirmed |
| S4 | Shaded region from t ≈ 2.83 (m=12) to t ≈ 4.89 (m=150) | Onset 2.8260 and 4.8896 (independent); frames show 2.83 and 4.89 | confirmed |
| S5 | m = 12..60: error at the last step before the shaded region is between 5.6e-5 and 2.2e-3 | min 5.64e-5 (m=60), max 2.17e-3 (m=20) | confirmed |
| S6 | …and after it the error reaches 0.096 to 0.74 | max error after onset: 0.0956 (m=60) to 0.7364 (m=12) | confirmed |
| S7 | m = 100, 120, 150: below 1e-8 there, and the error at t = 5 is smaller still | before-onset 8.25e-9, 1.12e-9, 1.66e-10; at t=5 4.49e-9, 5.66e-10, 1.36e-10 | confirmed |
| S8 | h = 0.0311 is a linear stability bound, not an accuracy threshold | Follows from S5–S7 (m = 100..150 accurate despite exceeding the bound) | confirmed |
| L1 | Module's worked solution uses n = 50, 100, 150 | lnk_12: n = 50 (gr_166/170/172), 100 (gr_177/179), 150 (gr_184/186) | confirmed |
| L2 | n = 100 and 150 end at y(5) = 0.0081199 (frames m=100, 150) | Legacy 0.00811992 both; script 0.0081199 both | confirmed |
| L3 | n = 50 falls to y48 ≈ −0.0018 at t = 4.8 and ends at y(5) ≈ 0.138, about 17× exact | Independent: y48 = −0.0018309, y(5) = 0.138090, ratio 17.01; legacy gr_170: −0.0018309, 0.13809 | confirmed |
| W1 | Link `adamsbashforthmoultonaa.jl` and embed `adamsbashforthmoultonaa.gif` are this case | Only script/GIF; regeneration byte-identical | confirmed |
| W2 | Case heading: ABM4 PECE sweep, same ODE, m = 12 to 150 | ms[1]=12, ms[end]=150 | confirmed |
| T1 | Alt: gray reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081 at t = 5 | B1, B2 | confirmed |
| T2 | Alt: m = 12 to 60 visibly break away, ending between −0.363 and 0.632 | B3, B6, B8 | confirmed |
| T3 | Alt: shaded region where h·\|∂f/∂y\| > 1.285, present in every frame | S3; all 21 frames show it | confirmed |
| T4 | Alt: from m = 70 on the run lies on the reference at this scale; y(5) = 0.0081199 at m = 100 and 150 | max \|err\| for m ≥ 70 is 2.08e-3; frames 16–21 | confirmed |
| C1 | Script comment l.95: zlim 1.2848 | 1.284816 | confirmed |
| C2 | Script comment l.106: every value inside (−0.5, 1.8); min −0.453 at m = 14, max 1.4498 | min −0.4530 (m=14); max over runs 1.44975 | confirmed (no clipping) |

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**It is the method it claims to be.** It is the 4th-order Adams-Bashforth predictor (55, −59, 37, −9)/24 with the 3-step Adams-Moulton corrector (9, 19, −5, 1)/24, used in PECE mode: f is re-evaluated at the corrected value on the next step (line 52). The start is classical RK4 for y1..y3. This is the standard ABM4 and Mathews' algorithm. The variant is PECE with no iteration of the corrector and no Milne-type error correction, and the page does not describe a different variant.

**The numbers are right.**
- My independent Python ABM4 (`indep.py`) reproduces the script's y(5) for all 21 values of m to the 7 printed digits. Examples, script vs independent:

  | m | script y(5) | independent y(5) |
  |---|---|---|
  | 12 | 0.0214088 | 0.0214088 |
  | 16 | 0.6321470 | 0.6321470 |
  | 20 | −0.3628404 | −0.3628404 |
  | 60 | 0.1036708 | 0.1036708 |
  | 80 | 0.0081090 | 0.0081090 |
  | 150 | 0.0081199 | 0.0081199 |

  The min and max of each run also agree.
- The values also match Mathews' printed labels for all 21 frames: 0.0214088, 0.031208, 0.632147, 0.5320078, −0.3628404, −0.1443545, 0.0788702, 0.2516957, −0.1185897, 0.1822742, 0.0734851, 0.0481297, 0.0621776, 0.016797, 0.1036708, 0.0102009, 0.008109, 0.0081196, then 0.0081199 three times.
- Order check using the script's own `abm4` on y' = −2ty, y(0)=1 (exact solution e^{−t²}) over [0,2]:
  - errors at n = 20/40/80/160/320: 1.51e-5, 4.71e-7, 1.90e-8, 9.22e-10, 5.02e-11;
  - ratios 32, 24.8, 20.6, 18.4, tending to 16 (order 4).
- On the page's ODE over [0,2], the error ratio from n = 20 to 40 is 40. After that the error reaches the reference's floor of about 3e-11.

**Its reference values are right.**
- The RK4 reference (h = 1e-4) gives y(5) = 0.00811992046487. DOP853 (rtol 1e-13) and Radau (rtol 1e-12) both give 0.00811992046487.
- The DOP853 dense output satisfies the ODE to 7.8e-11 (finite-difference residual).
- The peak is 1.449767 at t = 0.8836 in both.
- The stability limit zlim was rederived independently. I built the PECE characteristic polynomial in sympy from the scheme itself, not from the script's coefficient vector. Its spectral radius is ≤ 1 on the whole interval [−1.284816, 0) and > 1 just beyond it, so the script's bisection, which assumes a single crossing, is valid. Script value: 1.28481626.

**The picture shows what was computed.**
- Frames viewed: contact sheet (12 frames), plus frames 2 (m=14), 14 (m=56) and 16 (m=70) at full size.
- The magenta polyline with markers is the ABM4 run. The red dot is (5, y_m). The gray curve is the reference.
- The shaded span runs from the first t at which h·|∂f/∂y| along the reference exceeds zlim, out to t = 5. |∂f/∂y| rises monotonically after the peak, so the span is exactly the set where the condition holds.
- The title shows m and h = 5/m. Annotations show y(5), the signed error against the reference y(5), and the onset time (2.83 … 4.89, matching the independent 2.8260 … 4.8896).
- The y-limits (−0.5, 1.8) contain every computed value (global min −0.453), so nothing is clamped. There are 21 frames, all distinct, in the order of `ms`.
- The legend and annotations do not cover any part of a run.

