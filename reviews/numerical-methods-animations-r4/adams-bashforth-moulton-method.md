# Adams-Bashforth-Moulton Method — animation review (round 4)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors and nothing misleading or minor in the implementation, the page text, the alt text, the wiring or fidelity to the archive. Every checkable claim on the page agrees with my independent computation at the precision the page states. The ledger and the checks below show the evidence.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 12.7 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Sources: `indep.out` (independent Python, reference from mpmath/scipy), `instr.out` (the script's own values), `order.out`, frames under `committed/adamsbashforthmoultonaa/`.

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "predictor-corrector multistep scheme for initial value problems $y'=f(t,y)$" | Script lines 51–61: AB predictor, then an AM corrector using f at the predicted value, then f is re-evaluated at the corrected value on the next step (PECE) | confirmed |
| D2 | "In the 4-step form, an explicit Adams-Bashforth predictor estimates $y_{n+1}$ from recent history" | Line 57: coefficients 55, −59, 37, −9 over 24 on f_n…f_{n−3}. Exact for y'=4t³ (error 1.8e-15) and not for y'=5t⁴ (5.4e-4) (`props.out`), so this is the 4-step, 4th-order AB rule | confirmed |
| D3 | "an implicit Adams-Moulton corrector immediately refines it" | Line 60: 9, 19, −5, 1 over 24 on f(pred), f_n, f_{n−1}, f_{n−2}, the 4th-order AM rule, applied once in PECE mode (the standard ABM4 variant, and the one in Mathews' module) | confirmed |
| D4 | "not self-starting, initial points are generated with a one-step method (such as RK4)" | Lines 41–49: y1, y2, y3 from classical RK4 | confirmed |
| D5 | "each new value uses prior function evaluations, giving high accuracy with low per-step cost" | 2 f-evaluations per step after startup. 4th order confirmed: error ratios on y'=−2ty are 21.7, 19.2, 17.7, 16.8 and on y'=y are 7.1, 11.8, 14.0, 15.0, both approaching 16 (`props.out`) | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Repeats the step-refinement sweep of Mathews' animation for legacy Example 11 | `lnk_12.html` is Example 11 and links Animation 1, `Adamsaa.gif`. Its frames show the same problem and the same sweep | confirmed |
| A2 | $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | Script lines 12, 66–68. Archive image `gr_165`: "y' = 1 − t∛y with y(0)=1 over 0 ≤ t ≤ 5" | confirmed |
| A3 | Each frame is a complete ABM4 run with m subintervals, h = 5/m, the first three steps by RK4 | Lines 109–111, `abm4` | confirmed |
| A4 | The 21 values m = 12, 14, …, 60, 70, 80, 90, 100, 120, 150 are those of Mathews' animation | Line 69. Legacy GIF labels (`labels1/2.png`): 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150. Every legacy y(5) label equals the script's value to all printed digits (e.g. 0.0214088, 0.632147, −0.3628404, 0.016797, 0.0102009, 0.008109, 0.0081196, 0.0081199) | confirmed |
| A5 | Labelled with the computed y(5) and its error | Annotations at lines 129–130. Frames 1, 12, 14, 16 checked | confirmed |
| A6 | Thick gray curve = reference from fixed-step RK4 at h = 1e-4 | Lines 70–72, 123 (gray70, lw = 4). Script's yex5 = 0.00811992046486796 vs mpmath 0.008119920464867961, so the difference is below 1e-17 | confirmed |
| A7 | "no closed-form exact solution is used for this case" | True: the script uses a numerical reference | confirmed |

### Case 1 heading and Behavior

| # | Claim | Independent value | Verdict |
|---|---|---|---|
| B1 | Heading: ABM4 PC sweep, the ODE, y(0)=1, m = 12 to 150 | matches the script | confirmed |
| B2 | Reference rises to about 1.4498 near t = 0.88 | peak 1.4497667 at t = 0.88356 (scipy plus root of y' = 0) | confirmed |
| B3 | Decays to y(5) = 0.0081199 | 0.00811992046 (mpmath) | confirmed |
| B4 | m = 12–52 visibly break away in the tail, from t ≈ 3.2 to 4.7 depending on m | first node with abs(error) > 0.01: 3.13 (m=16) … 4.62 (m=52). With > 0.05: 3.33 … 4.69 (`order.out`). The frames show the breakaway | confirmed (approximate as stated) |
| B5 | Each of m = 12–52 goes below zero somewhere | minima: −0.419, −0.453, −0.275, −0.243, −0.363, −0.144, −0.176, −0.116, −0.119, −0.0535, −0.0646, −0.00488, −0.0334. All are negative | confirmed |
| B6 | "at m=48 only to −0.0049, too little to see" | min −0.004882 at t = 4.896. Frame 12 shows no visible dip below the axis | confirmed |
| B7 | m = 56 and 60 stay on the reference until about t = 4.8 and 4.9 | error first > 0.01 at t = 4.73 (m=56, 0.013) and 4.92 (m=60). The visible departures are at 4.82 (0.076) and 4.92 (0.051) | confirmed |
| B8 | …then rise above it by up to 0.11 and 0.096 | max signed error +0.1080 (m=56, t=4.911) and +0.0956 (m=60, t=5). The most negative errors are only −2.4e-4 and −7.4e-4 | confirmed |
| B9 | End values across m = 12–60 range from −0.363 (m=20) to 0.632 (m=16) | min −0.3628404 (m=20), max 0.6321470 (m=16) | confirmed |
| B10 | m=12: y(5) = 0.0214, off by 0.74 at t ≈ 4.17 | 0.0214088. Max abs error 0.736 at t = 4.1667 | confirmed |
| B11 | From m = 60 on, the error in y(5) falls at every refinement | 9.56e-2, 2.08e-3, 1.09e-5, 2.94e-7, 4.49e-9, 5.66e-10, 1.36e-10, which is strictly decreasing | confirmed |
| B12 | 9.6e-2 at m=60 | +9.555e-2 | confirmed |
| B13 | 2.1e-3 at m=70, 26% of y(5), too small to see | +2.081e-3, which is 25.6% of y(5). In frame 16 it is under 1 px | confirmed |
| B14 | 1.1e-5 at m=80 | −1.094e-5 | confirmed |
| B15 | 4.5e-9 at m=100 | −4.489e-9 | confirmed |
| B16 | 1.4e-10 at m=150 | −1.356e-10 | confirmed |
| B17 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | −41.2554 | confirmed |
| B18 | ABM4 PC is stable on y'=λy, real λ<0, only while h·abs(λ) ≤ 1.285 | Independent root computation gives 1.2848163. The stable set on the negative real axis is contiguous (no root of modulus > 1 on (−1.2848, 0)). Direct simulation (`stabsim.out`) decays at z = −1.284 and grows at −1.29 | confirmed |
| B19 | Every m ≤ 160 (h > 0.0311) crosses before t = 5, including every frame | critical h = 1.2848/41.255 = 0.031143, i.e. m = 160.55. The maximum of abs(∂f/∂y) on [0,5] is at t = 5, where the reference minimum is | confirmed |
| B20 | Shaded region from t ≈ 2.83 (m=12) to t ≈ 4.89 (m=150) | onsets 2.8260 and 4.8896 (both independent and from the script) | confirmed |
| B21 | m = 12–60: error at the last step before the shaded region is 5.6e-5 to 2.2e-3 | 5.64e-5 (m=60) … 2.17e-3 (m=20) | confirmed |
| B22 | …and after it the error reaches 0.096 to 0.74 | post-onset maxima 0.0956 (m=60) … 0.736 (m=12) | confirmed |
| B23 | m = 100, 120, 150: error there below 1e-8, and the error at t = 5 smaller still | last pre-onset errors 8.25e-9, 1.12e-9, 1.66e-10. Errors at t=5 are 4.49e-9, 5.66e-10, 1.36e-10, each smaller | confirmed |
| B24 | h = 0.0311 is a linear stability bound, not an accuracy threshold | B23 shows runs with h > 0.0311 that are accurate to 1e-10 | confirmed |
| B25 | The module's worked Example 11 uses n = 50, 100, 150 steps | archive `gr_168/175/182`: "Using n = 51 / 101 / 151 points", i.e. 50/100/150 steps | confirmed |
| B26 | n=100 and 150 runs (frames m=100, 150) end at y(5) = 0.0081199 | 0.0081199160 and 0.0081199203. Archive: 0.00811992 for both | confirmed |
| B27 | n=50 falls to y_48 ≈ −0.0018 at t = 4.8 | −0.0018309 (independent and script). Archive table: {4.8, −0.0018309} | confirmed |
| B28 | …and ends at y(5) ≈ 0.138, about 17 times the exact value | 0.1380900. Ratio 17.006. Archive: 0.13809 | confirmed |
| B29 | (aside) when y < 0, ∛y is the real cube root | `cbrt` on line 12 | confirmed |

### Wiring, alt text, counts

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| W1 | `[Julia source](adamsbashforthmoultonaa.jl)` is this case's script | File exists, and it is the only script | confirmed |
| W2 | Embed `adamsbashforthmoultonaa.gif` is produced by that script | Manifest: byte-identical on regeneration | confirmed |
| W3 | 21 frames, one per m | Committed GIF has 21 frames. Frame k is labelled m = ms[k] (sheet: frames 1, 3, …, 21 show m = 12, 16, 20, 28, 36, 44, 52, 60, 80, 100, 150) | confirmed |
| L1 | Alt: "each frame is a complete ABM4 run with m subintervals, m = 12 to 150" | as A3/W3 | confirmed |
| L2 | Alt: gray reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081 at t = 5 | B2, B3 | confirmed |
| L3 | Alt: for m = 12 to 60 the run visibly breaks away in the tail | B4, B7, B8 (deviations of 0.096 or more in every one of these frames) | confirmed |
| L4 | Alt: ending between y(5) = −0.363 and 0.632 | B9 | confirmed |
| L5 | Alt: shaded region marks h·abs(∂f/∂y) > 1.285, which happens in every frame | B19, B20. The shading is present in all frames in the sheet, including m=150 (from 4.89) | confirmed |
| L6 | Alt: from m = 70 on, the run lies on the reference at this scale | max abs error for m ≥ 70 is 2.1e-3 (m=70) and below 3e-5 from m=80. Frames 16 to 21 show it | confirmed |
| L7 | Alt: y(5) = 0.0081199 at m = 100 and 150 | B26 | confirmed |
| F1 | Frame legend "h·abs(∂f/∂y) > 1.285", "reference solution", "ABM4, m = …", and the onset text "from t ≈ 2.83" etc. | consistent with B18/B20 in every frame inspected (1, 12, 14, 16, sheet) | confirmed |

Fidelity: the example function, interval, initial value, the m sequence (all 21 values) and every y(5) value match Mathews' animation. The n = 50/100/150 worked outputs match too. No archive case is dropped: the module's Animations section has the single animation. The other module examples (1–10) are static worked examples, not animations, and the page does not claim to cover them.

---

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

**It is the method it claims.** Lines 51–61 implement the ABM4 predictor-corrector in PECE mode: a 4-step AB predictor (55, −59, 37, −9)/24 and the 4th-order AM corrector (9, 19, −5, 1)/24, applied once. On the next step f is re-evaluated at the corrected value. Lines 41–49 give the RK4 start. I confirmed the coefficient tables by properties, without relying on memory:
- The script's `abm4` integrates y'=4t³ exactly (error 1.8e-15) but not y'=5t⁴ (5.4e-4). So each rule is exact on cubic f and the RK4 start reduces to Simpson. This is the degree of precision of the 4th-order Adams pair.
- Halving h on y'=−2ty (exact e^{−t²}) gives error ratios 21.7, 19.2, 17.7, 16.8, and on y'=y gives 7.1, 11.8, 14.0, 15.0. Both tend to 2⁴ = 16.
- On the page's problem, the max-error ratios for m = 100 → 1600 are 27.6, 23.1, 20.1, 18.2, tending to 16.

**The numbers are right.** Script values (`instr.out`) and independent Python values (`indep.out`) for y(5):

| m | script | independent | m | script | independent |
|---|---|---|---|---|---|
| 12 | 0.021408782921 | 0.0214088 | 48 | 0.048129711183 | 0.0481297 |
| 14 | 0.031208039146 | 0.0312080 | 52 | 0.062177624423 | 0.0621776 |
| 16 | 0.632146980620 | 0.6321470 | 56 | 0.016796968232 | 0.0167970 |
| 18 | 0.532007804564 | 0.5320078 | 60 | 0.103670824582 | 0.1036708 |
| 20 | −0.362840421848 | −0.3628404 | 70 | 0.010200922113 | 0.0102009 |
| 24 | −0.144354472135 | −0.1443545 | 80 | 0.008108983361 | 0.0081090 |
| 28 | 0.078870248849 | 0.0788702 | 90 | 0.008119626482 | 0.0081196 |
| 32 | 0.251695662842 | 0.2516957 | 100 | 0.008119915976 | 0.0081199 (err −4.49e-9) |
| 36 | −0.118589745164 | −0.1185897 | 120 | 0.008119919899 | 0.0081199 (err −5.66e-10) |
| 40 | 0.182274213274 | 0.1822742 | 150 | 0.008119920329 | 0.0081199 (err −1.36e-10) |
| 44 | 0.073485092652 | 0.0734851 | | | |

Errors agree to every digit printed. Mathews' own animation labels agree with both columns (A4).

**Stability limit.** The script's `stab_limit()` gives 1.2848162631. An independent `numpy.poly1d` characteristic polynomial gives 1.284816263. A direct recurrence simulation decays at z = −1.284 and grows at z = −1.29. I re-derived the polynomial in the comment on line 77 and the coefficients on line 81, and they are correct. The onset times from `onset()` match my fine-grid computation (2.826 … 4.8896).

**The reference values are right.** The RK4 reference at h = 1e-4 gives y(5) = 0.00811992046486796. mpmath `odefun` (30 digits) gives 0.008119920464867961, and scipy DOP853 gives 0.008119920464867971. The reference stays positive (min = y(5)), so the cube root is never evaluated on the reference at a negative argument. Its peak is 1.4497667 at t = 0.88356. The reference is far more accurate than any comparison needs, the smallest being the 1.4e-10 error at m=150.

**The picture shows what was computed.** I checked frames 1 (m=12), 12 (m=48), 14 (m=56) and 16 (m=70), and the contact sheet (frames 1, 3, …, 21):
- Magenta polyline with markers = ABM4 nodes. Red dot = (5, y_m).
- The gray thick curve is the reference.
- The red shading runs from onset to t=5.
- The annotations give y(5), the signed error against the reference y(5), and the onset time.
- The title states the right ODE and m, with h = 5/m.

The y-limits (−0.5, 1.8) contain every computed value (global min −0.4530 at m=14, max 1.44975), so nothing is clipped. Shapes match the computed sequences: the m=12 spike to 0.75 at t ≈ 4.17 and dip to −0.42 at 4.58, the m=48 bump with no visible negative dip, and the m=56 bump to 0.117 at 4.91. Frame order matches `ms`, and fps = 1.

Could not determine: nothing material. "Visibly breaks away from t ≈ 3.2 to 4.7" (B4) depends on a visual threshold. Thresholds of 0.01 and 0.05 both bracket the stated range, so I have marked it confirmed as an approximate claim.

