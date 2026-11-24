# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 9)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0. Misleading: 0. Minor: 0.

Every checkable claim on the page and in the script headers was confirmed against independent computation and the frames (ledger below). Two items could not be determined because the source is not available here; they are listed in the ledger and are not findings.

Observation (not a finding): the scripts' one departure from `newton_real` (storing P'(z_{k-1}) rather than P(z_{k-1}) in `fz0`) does not change any of the three animations: with the reference's storage, my transcription gives the same iterates, kinds and stages in Cases 1, 2 and 3 (only the stage-test ratios differ, never crossing 1). It does change the Description's x₀ = −0.7 example: with the reference's storage the run takes 21 steps, 18 of them linear Stage-2 steps (errors halving from 0.21 to 1.8e-6), instead of the 5 the page quotes. The page states explicitly that its description is of the corrected implementation, so the quoted 5-step run is correct for what the page describes. The correction is also mathematically sound on its face: the reference's `fwz = fz0 - fz1` subtracts P'(z_k) from P(z_{k-1}), which is dimensionally inconsistent, while P'(z_{k-1}) − P'(z_k) over z_{k-1} − z_k is a difference quotient for P''.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.8 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 11.1 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 10.6 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `madsreidaa.gif` | 7 | byte-identical | madsreidaa |
| `madsreidab.gif` | 6 | byte-identical | madsreidab |
| `madsreidac.gif` | 9 | byte-identical | madsreidac |

### Page references

- Scripts linked: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| D1 | Scripts port the iteration of `newton_real` with one correction (Stage 2) | Confirmed | Line-by-line comparison of `newton_real_iterates` with `Newton_Real.cpp` lines 229–312: feval, upperbound (2^-52 = `pow(2,-DBL_MANT_DIG+1)`), eps = 4n²f0·2^-106, rounding test 2^-26 (C integer division −53/2 = −26), alterdirection, stage test, r0 cap, halving/lengthening loop, `ff = f` at iter2, rounding-domain retry all match. Only difference: `fz0 = fz1` (script line 111) vs `fz0 = fz` (C line 264). Start points for Cases 1–2 differ, which the page states. |
| D2 | Newton is linear at multiplicity m, f/f' ≈ (x−x*)/m, error factor (m−1)/m | Confirmed | Standard; plain Newton from 4 on (x−1)²(x+2): error ratios → 0.500 (chk.py). |
| D3 | Stage 1 lengthening: if z−Δz does not increase |f|², tries z−2Δz, …, up to z−(n+1)Δz, stops at first trial that does not lower |f|², keeps the one before | Confirmed | Loop i = 1..n with `wz -= dz` reaches z0−(n+1)dz; `fw >= f` break (C lines 272–296). |
| D4 | Near a root of multiplicity m that point is z−mΔz; quadratic while in Stage 1 | Confirmed (for m = 2 here) | Case 2: k = 2 at every step after the first; errors 8.6e-2 → 1.2e-3 → 2.3e-7, e_{k+1}/e_k² ≈ 0.16, 0.17. |
| D5 | Stage 2 takes plain Newton steps, linear at a multiple root | Confirmed | Code; reference-storage x₀ = −0.7 run shows halving errors in Stage 2. |
| D6 | Near a double root the two sides of the stage test tend to equality | Confirmed | Case 2 stage-test ratios (squared form) at steps 3–5: 0.49, 1.087, 1.005; x₀ = −0.7 run: 1.53, 1.44, 1.02. Analytically 2|f||f''| = |f'|² for c(x−1)². |
| D7 | Case 2 stays in Stage 1 throughout | Confirmed | All 5 steps Stage 1 (Julia trace and mr.py). |
| D8 | x₀ = −0.7: plain Newton step past the root to x₁ ≈ 1.7556 | Confirmed | x₁ = 1.7555555555555553; trial 2Δx = 4.21 has |P|² = 4102 > 4.596, so plain; −0.7 < 1 < 1.7556. |
| D9 | then one Stage-2 step to x₂ ≈ 1.4123 (error 0.76 → 0.41) | Confirmed | x₂ = 1.4123058542; errors 0.7556, 0.4123. |
| D10 | stage test then fails, left side 1.24 × right side | Confirmed | squared ratio 1.534, so ratio of sides √1.534 = 1.2385. |
| D11 | three lengthened Stage-1 steps with k = 2, errors 2.3e-2, 9.1e-5, 1.4e-9 | Confirmed | 2.349e-2, 9.090e-5, 1.377e-9; all k = 2. |
| D12 | computed |f|² exactly 0, run stops after 5 steps | Confirmed | f = 0 at step 5; 5 steps. |
| D13 | r0 reset to 5|Δz| (pre-cap length) | Confirmed | Script line 106 / C line 260. |
| D14 | Step longer than r0 is cut to r0 and rotated 53.13° | Confirmed | alterdirection(dz, r0/r); atan2(0.8, 0.6) = 53.130°. |
| D15 | Cases 1 and 2 scripts stop with an error if a rotation occurs | Confirmed | `madsreidaa.jl` lines 180–181 (same in ab). |
| D16 | No Newton step in the three animations is longer than r0 | Confirmed | r/r0 per step: Case 1 0.708/15, 0.394/3.54, 0.0914/1.97, …; Case 2 1.2/20, 0.343/6, 0.0423/1.71, …; Case 3 2.5/5, 8.125/12.5, 1.98/40.6, 0.449/9.90, … ; `cap=0` throughout. |
| D17 | Δz = f(z)/f'(z) | Confirmed | dz = fz·conj(fz1)/|fz1|². |
| D18 | Stage 1 halving: each halving kept only while it lowers |f|² below the previous trial | Confirmed | `fw >= f` compares with the previous accepted trial. |
| D19 | Two helpful halvings → alterdirection rotates and halves once more, multiplication by 0.5(0.6+0.8i), accepted | Confirmed | C lines 289–295; Case 3 step 2 reproduces it. |
| D20 | Stage 2 has no trial points; ends when |f(z)| ≤ Adams' bound | Confirmed | eps = upperbound (squared) compared with f = |P|² in loop condition. |
| D21 | Stage 2 used only when previous step was plain (search left it unchanged) and 2|f(z_k)||w| ≤ |f'(z_k)|²|z_{k−1}−z_k| | Confirmed | `stage1 = f2/u > u/f/4 || f != ff`; algebraically equivalent to the stated inequality. |
| D22 | w/(z_{k−1}−z_k) estimates f''; test estimates Kantorovich's 2|f||f''| ≤ |f'|² | Confirmed | With the scripts' storage, w is a difference of P' values. |
| D23 | Madsen and Reid's test (2.9) requires P'(z_{k−1}) | Could not determine | Report AERE-R.7986 not available locally. |
| D24 | The reference's initial fz0 is f'(0) | Confirmed | fz0 = a[n−1] = P'(0). |
| D25 | Saddle branch: previous step rotated 53.13° and lengthened 5×; rounding-domain branch as described; neither reached | Confirmed | Code; `saddle=0`, `rounding=0` in all traces. |
| D26 | Not a guarantee of decrease (halving vs previous trial, rotated step unchecked, Stage 2 unchecked) | Confirmed | Code. |
| D27 | In all three animations |f|² decreases at every step | Confirmed | Case 1: 289, 3.17, 0.637, 2.38e-3, 5.2e-8, 2.6e-17, 3.2e-30. Case 2: 2916, 0.746, 5.1e-4, 1.7e-11, 2.5e-26, 0. Case 3: 25, 16.5, 12.37, 2.19, 0.0405, 6.1e-6, 1.5e-13, 7.9e-29, 1.0e-59. |
| D28 | Only f and f' plus extra f evaluations at trials | Confirmed | Code. |
| D29 | Deflation by 1 or 2, final linear/quadratic solved analytically | Confirmed | C lines 314–333 (not run in scripts, which the script header says). |
| D30 | Generalization note (real f, n+1 bound and Adams' bound polynomial-specific, rotation needs complex evaluation, Cases 1–2 stay real) | Confirmed | Code and traces (all Case 1–2 imaginary parts 0). |
| D31 | "globally convergent" (first sentence) | Could not determine | A property of the published method; not checkable from the scripts; the source report is not available. |

### Animations intro

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = plain Newton z−Δz; green = lengthened z−kΔz, k ≥ 2, drawn as tangent to Newton point then along axis; orange = halved or rotated | Confirmed | `stepcolor`; plotting lines 207–209; frames. |
| A2 | Label names the stage of the step that reached the point | Confirmed | `stage2[frame]` in the label; frames. |
| A3 | Cases 1–2 start with r0 = 5|x0|, not the reference's start rule; Case 3 starts where the reference does | Confirmed | r0 = 15, 20; startpoint(z²+4) = 2, z = 1, r0 = 2.5u = 5. |
| A4 | Case 3 star markers show the exact roots | Confirmed | stars at ±2i; frames. |
| A5 | Julia sources linked under each case | Confirmed | |

### Case 1 — x³ − 3x − 1, x₀ = 3.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading function and x₀ | Confirmed | coeff [1,0,−3,−1], x0 = 3.0. |
| C1.2 | Three simple real roots | Confirmed | 2cos(π/9), 2cos(5π/9), 2cos(7π/9). |
| C1.3 | |P|² = 17.3, 3.17, 8.73 for Δx, 2Δx, 3Δx | Confirmed | 17.31, 3.171, 8.732. |
| C1.4 | x₁ = x₀ − 2Δx ≈ 1.5833, green, passes the root | Confirmed | 1.583333…; 3 > 1.8794 > 1.5833; green in frames. |
| C1.5 | Every later step plain (blue); step 2 Stage 1; steps 3–6 Stage 2; no halving | Confirmed | Trace. |
| C1.6 | Root x* ≈ 1.8794 | Confirmed | 1.879385241571816768… |
| C1.7 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5 | Confirmed | 9.783e-2, 6.397e-3, 3.015e-5, 6.749e-10. |
| C1.8 | x₆ equals x* to double precision | Confirmed | x₆ = 1.8793852415718169 = float(x*) (nearest double). |
| C1.9 | |P| below Adams' bound there, run stops | Confirmed | |P|² = 3.16e-30 ≤ eps = 2.45e-27; 6 steps. |
| C1.10 | Alt text (doubled first step to 1.5833, plain Newton steps, Stage 2 from step 3, quadratic to 1.8794) | Confirmed | |
| C1.11 | Link/embed wiring | Confirmed | madsreidaa.jl / madsreidaa.gif, title matches. |

### Case 2 — (x−1)²(x+2), x₀ = 4.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading function and x₀; double root at 1, P'(1) = 0 | Confirmed | coeff [1,0,−3,2] = (x−1)²(x+2). |
| C2.2 | Plain Newton from 4: error roughly halves, still 3.4e-4 after 14 steps | Confirmed | step 14 error 3.354e-4; ratios → 0.50. |
| C2.3 | Lengthened every step, all green, all Stage 1; lengthened step never leads to Stage 2 | Confirmed | Trace; f ≠ ff after a lengthened step forces Stage 1. |
| C2.4 | 3Δx to x₁ = 0.4, past the root | Confirmed | trials 2.8 (241.9), 1.6 (1.68), 0.4 (0.7465), −0.8 (15.12). |
| C2.5 | then 2Δx four times | Confirmed | k = 2 at steps 2–5. |
| C2.6 | Errors 8.6e-2, 1.2e-3, 2.3e-7 of x₂–x₄, quadratic | Confirmed | 8.571e-2, 1.174e-3, 2.296e-7. |
| C2.7 | x₅ ≈ 0.99999999952, error 4.8e-10 | Confirmed | 0.9999999995193409; 4.807e-10. |
| C2.8 | Computed |P(x₅)|² exactly 0, true ≈ 4.8e-37; run stops | Confirmed | float Horner gives 0; mpmath 4.804e-37. |
| C2.9 | No step halved | Confirmed | |
| C2.10 | From x₂ on, window zooms on each step; steps shrink 0.69 → 2.3e-7 | Confirmed | frames 3–6 zoomed; |x₂−x₁| = 0.6857, |x₅−x₄| = 2.30e-7. |
| C2.11 | Zoomed frame shows tangent reaching axis halfway, then second Δx along axis | Confirmed | frames 3–6 (e.g. frame 6: Newton point 1.000000115, end 0.99999999952). |
| C2.12 | Alt text | Confirmed | |
| C2.13 | Wiring | Confirmed | madsreidab.jl / madsreidab.gif. |

### Case 3 — z² + 4, z₀ = 1 + 0i

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Roots ±2i, no real roots | Confirmed | |
| C3.2 | Reference solves quadratics in closed form; loop run directly from z₀ = 1, r0 = 5 | Confirmed | C `while (n > 2)` then `quadratic`; startpoint = 2. |
| C3.3 | Full step to −1.5 increases |P|² (39.1 vs 25) | Confirmed | 39.06 vs 25. |
| C3.4 | One halving to z₁ = −0.25; second halving to 0.375 does not help | Confirmed | 16.50 then 17.14. |
| C3.5 | At z₁ full step to 7.875 increases |P|²; halvings to 3.8125, 1.78125 both help | Confirmed | 4358, 343.6, 51.45 vs f0 = 16.5. |
| C3.6 | Rotation and further halving give z₂ = 0.359375 + 0.8125i | Confirmed | −0.25 − (−8.125/4)(0.5)(0.6+0.8i). |
| C3.7 | Orange: halved steps 1 and 3, rotated step 2 | Confirmed | Trace kinds; frames. |
| C3.8 | Step 4 plain in Stage 1; steps 5–8 Stage 2, blue; quadratic to +2i | Confirmed | errors 0.050, 6.2e-4, 9.6e-8, 2.2e-15. |
| C3.9 | Stops at z₈, |P| ≈ 3.2e-30 below Adams' bound | Confirmed | |P| = 3.155e-30; bound √eps = 6.2e-15; step 7 had |P|² = 7.9e-29 > eps 3.87e-29, so it continued. |
| C3.10 | No lengthened step; path is a polyline | Confirmed | |
| C3.11 | Alt text | Confirmed | |
| C3.12 | Wiring | Confirmed | madsreidac.jl / madsreidac.gif. |

### Script headers/comments

| # | Claim | Verdict |
|---|---|---|
| H1 | aa: root at x* ≈ 1.8794 | Confirmed |
| H2 | ab: (x−1)²(x+2) = x³ − 3x + 2, double root 1, simple −2 | Confirmed |
| H3 | ac: two helpful halvings at z₁ trigger the rotation; reference start z₀ = 1, r0 = 5 | Confirmed |
| H4 | r0 = 2.5u for a start at u/2 (= 5|x₀|) | Confirmed |

### 3. Implementation checks

### madsreidaa.jl (Case 1)
- Method: a faithful port of `newton_real`'s loop (one documented change). Variant: Vestermark's implementation of Madsen's method, with the P'-storage correction in the stage test.
- Numbers: independent transcription `mr.py` gives bit-identical iterates: 1.583333333333333, 1.9772145417306708, 1.885782136079089, 1.8794153957913198, 1.879385242246684, 1.8793852415718169 (Julia `run.out` identical in every digit), same kinds/stages, same |P|² and eps values.
- Reference values: root 2cos(π/9) = 1.87938524157181677 (mpmath, P(r) = 0 at 50 digits).
- Picture: frames 1, 2, 3, 7 viewed: tangent from (3, 17) to the Newton point 2.2917, axis segment to 1.5833, vertical to P(1.5833) = −1.78; step 2 tangent at x₁ to 1.977. Colours and labels match the trace. Later steps are sub-pixel, which the page does not deny. Window (−0.5, 3.5) × (−5, 22) contains every element.

### madsreidab.jl (Case 2)
- Method: same port.
- Numbers: bit-identical to `mr.py`: 0.3999999999999999, 1.0857142857142854, 1.0011741682974553, 1.0000002296437014, 0.9999999995193409; all lengthened (k = 3, 2, 2, 2, 2), all Stage 1.
- Reference values: double root 1 (exact factorisation).
- Picture: all 6 frames viewed. Zoom windows contain the start, Newton point and end of each step; the tangent meets the axis halfway (k = 2); the labels carry 11 significant digits and match the trace. The curve at the deepest zoom (|P| ~ 1e-13) is smooth (Float64 cancellation noise ~4e-16, about 0.3% of the scale).

### madsreidac.jl (Case 3)
- Method: same port, run on a quadratic (the reference would solve that in closed form; the page says so).
- Numbers: bit-identical to `mr.py` for z₁…z₈ (−0.25; 0.359375+0.8125i; −0.18577342058459634+1.638759472626044i; 0.043709164712013915+2.0243302797252594i; …; −7.888609052210118e-31+2i).
- Reference values: roots ±2i exact.
- Picture: all 9 frames viewed. The polyline joins consecutive accepted iterates with the right colours; the stars are at ±2i; the window (−2.5, 2.5) × (−2.8, 2.8) contains all iterates (trial points such as −1.5 and 7.875 are not drawn, and the page does not say they are); the legend labels match the trace at their printed precision.

### Regeneration
All three scratch copies (identical to the committed scripts) reproduce the committed GIFs byte for byte (md5sum check).

