# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 5)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, nothing misleading and no minor issue that meets the standard.

Two claims could not be fully determined. Neither is a finding.
- The Description says the scripts' derivative storage is "as Madsen and Reid's test (2.9) requires". AERE-R.7986 is not available to me, so I could not check equation (2.9). The parts I could check do hold: (a) with this change the test is exactly the Kantorovich-type inequality the page writes, and (b) the reference's own initialisation `fz0 = a[n-1]` with `z0 = 0` is P′(0), not P(0).
- "a robust, globally convergent Newton-based algorithm" (Description, first sentence) characterises the method. I did not try to prove or refute global convergence. The page itself qualifies the descent property ("It is not a guarantee").



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.8 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 9.6 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Scripts port the iteration of `newton_real` "with one correction (Stage 2)" | Read side by side with `Newton_Real.cpp` lines 204–312. The only change in the loop is `fz0 = fz1` (C++ line 264 has `fz0 = fz`). The start point and r0 are case inputs, and that is disclosed. Deflation and `quadratic` are not run, also disclosed. My translation reproduces every Julia iterate bit for bit. | confirmed |
| D2 | Newton at a root of multiplicity m: f/f′ ≈ (x−x*)/m, error factor (m−1)/m | Standard. Plain Newton on Case 2 from 4: error ratios 0.58, 0.557, 0.537, … → 0.5 = (2−1)/2 | confirmed |
| D3 | Stage 1, if z−Δz does not increase \|f\|², tries z−2Δz … z−(n+1)Δz, stops at first non-decrease, keeps previous | C++ 272–288: `div2 = f > f0`, `i = 1..n`, `wz -= dz`, `break` on `fw >= f`. Same in `.jl` 121–132 | confirmed |
| D4 | Near a root of multiplicity m the kept point is z − mΔz (multiplicity-corrected) | Case 2 (m = 2): k = 2 four times. Property run on (x−2)³(x+1) from 5: k = 3 three times after the first step, error 2.5e-2 → 7.0e-5 → 3.9e-8 | confirmed |
| D5 | Convergence to a multiple root is quadratic while in Stage 1 (Case 2: until rounding takes over) | Case 2 errors 8.57e-2, 1.174e-3, 2.296e-7: e3/e2² = 0.160, e4/e3² = 0.167. The last step gives 4.8e-10, not about 9e-15, so rounding took over | confirmed |
| D6 | Stage 2 takes plain Newton steps, linear at a multiple root | Code: no trial points in Stage 2. Reference-mode run from −0.7: 19 Stage-2 steps with errors halving | confirmed |
| D7 | Near a double root the two sides of the stage test tend to equality | Case 2 lhs/rhs (squared form): 0.41, 13, 0.49, 1.087, 1.0054 (converging to 1) | confirmed |
| D8 | Case 2 stays in Stage 1 throughout | Trace: stage 1 at all 5 steps | confirmed |
| D9 | x0 = −0.7: a plain Newton step past the root to x1 ≈ 1.7556 | mr.py (r0 = 5·0.7 = 3.5): x1 = 1.7555555555555553, Stage 1, plain (2Δx trial gives 4101.66 > 4.596) | confirmed |
| D10 | then one Stage-2 step to x2 ≈ 1.4123 (error 0.76 → 0.41) | x2 = 1.4123058542413378, stage 2. Errors 0.7556 → 0.4123 | confirmed |
| D11 | Stage test then fails (left side 1.24 × right side) | At step 3: f2/u = 10.144, u/(4f) = 6.6147, f == ff. In the page's form the ratio is sqrt(10.144/6.6147) = 1.2384 | confirmed |
| D12 | three lengthened Stage-1 steps with k = 2: errors 2.3e-2, 9.1e-5, 1.4e-9 | 0.023490, 9.090e-5, 1.377e-9, all k = 2, stage 1 | confirmed |
| D13 | computed \|f\|² is exactly 0, run stops after 5 steps | Step 5 \|P\|² = 0, loop ends (f > eps fails), 5 steps | confirmed |
| D14 | r0 ← 5\|Δz\| (pre-cap length), a longer step is cut to r0 and rotated 53.13° | C++ 257–260. atan2(0.8, 0.6) = 53.13° | confirmed |
| D15 | A rotation would take Cases 1–2 off the axis, and their scripts stop with an error | `.jl` lines 180–181 | confirmed |
| D16 | No Newton step in the three animations is longer than r0 (cap never acts) | Trace `cap=0` at every step of all three cases. My translation also never triggers `r > r0` | confirmed |
| D17 | Stage 1 halving: each halving kept only while it lowers \|f\|² below the previous trial | C++ 284 compares with the running `f` | confirmed |
| D18 | Two helpful halvings: rotate 53.13° and halve once more, multiplication by 0.5(0.6+0.8i), accepted | C++ 289–295 | confirmed |
| D19 | Stage 2: no trial points, and the run ends once \|f(z)\| ≤ Adams' bound | C++ 298–302, loop condition `f > eps` with f = \|P\|² and eps = bound² | confirmed |
| D20 | Stage 2 used only after a plain Newton step and when 2\|f(z_k)\|\|w\| ≤ \|f′(z_k)\|²\|z_{k−1}−z_k\| | `stage1 = f2/u > u/f/4 \|\| f != ff` rearranges to exactly this. `f == ff` holds only if the search left the Newton point unchanged | confirmed |
| D21 | w/(z_{k−1}−z_k) estimates f″, so the test estimates Kantorovich 2\|f\|\|f″\| ≤ \|f′\|² | With w = P′(z_{k−1}) − P′(z_k) (scripts' version) | confirmed |
| D22 | Reference stores f(z_{k−1}) where the scripts store f′(z_{k−1}). The reference's initial value f′(0) implies the latter | C++ 232 `fz0 = a[n-1]` = P′(0). C++ 264 `fz0 = fz` = P | confirmed |
| D23 | …as Madsen and Reid's test (2.9) requires | Report not available | could not determine |
| D24 | Saddle branch: f′ = 0, previous step rotated 53.13° and lengthened ×5. Rounding branch: step shorter than 2⁻²⁶\|z\| that does not lower \|f\|² is retried rotated and halved | C++ 246–247, 304–311 (−DBL_MANT_DIG/2 = −26) | confirmed |
| D25 | Neither branch is reached in the three animations | Trace `saddle=0 rounding=0` everywhere, and the same in mr.py | confirmed |
| D26 | Descent is not guaranteed (halving compared with previous trial, rotated step unchecked, Stage 2 unchecked) | Code reading | confirmed |
| D27 | In all three animations \|f\|² decreases at every step | Case 1: 289 → 3.17 → 0.637 → 2.38e-3 → 5.2e-8 → 2.6e-17 → 3.2e-30. Case 2: 2916 → 0.746 → 5.1e-4 → 1.7e-11 → 2.5e-26 → 0. Case 3: 25 → 16.50 → 12.37 → 2.19 → 0.0405 → 6.1e-6 → 1.5e-13 → 7.9e-29 → 1.0e-59 | confirmed |
| D28 | Uses only f and f′ plus extra f evaluations at trial points | Code | confirmed |
| D29 | After each root, deflation by 1 or 2, then the remaining linear or quadratic is solved analytically | C++ 317–333 | confirmed |
| D30 | Generalization note: real-axis parts need only f, f′. n+1 bound and Adams' bound come from the polynomial. The rotation needs complex evaluation (Case 3 uses it) | Code reading. Case 3 step 2 is the rotation | confirmed |
| D31 | "robust, globally convergent" | Characterisation, not tested | could not determine |

### Animations intro

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Blue = plain Newton steps, green = lengthened k ≥ 2 drawn as tangent to Newton point then along the axis, orange = halved or rotated | `stepcolor`, plotting loop lines 202–210. Frames: aa frame 2 and ab frames 2–6 show the tangent to the Newton point and then the thick axis segment | confirmed |
| A2 | The label of the current point names the stage of the step that reached it | `stage2[frame]` is that step's stage. aa frame labels: Stage 1, 1, 2, 2, 2, 2 matches the trace | confirmed |
| A3 | Cases 1 and 2 use their own x0 with r0 = 5\|x0\| | Line 15 `r0 = 5.0*abs(x0)` | confirmed |
| A4 | Case 3 starts where the reference does | `startpoint` for z²+4 gives u = 2 (a[1] = 0 skipped). z = ±u/2 = 1 (a[n−1] = 0 gives sign +), r0 = 2.5u = 5. Script uses 1, 5 | confirmed |
| A5 | Case 3 star markers show the exact roots | Stars at ±2i (frame 1) | confirmed |

### Case 1: x³ − 3x − 1, x0 = 3.0

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading function and x0 | `coeff = [1,0,-3,-1]`, `x0 = 3.0`. GIF title matches | confirmed |
| C1.2 | Three simple real roots | mpmath polyroots: −1.5320889, −0.34729636, 1.8793852 | confirmed |
| C1.3 | \|P\|² = 17.3, 3.17, 8.73 for Δx, 2Δx, 3Δx | mr.py trials: 17.3075, 3.17079, 8.73249 | confirmed |
| C1.4 | First move lengthened to x1 ≈ 1.5833 (green), passes the root | 1.583333333333333 < x* = 1.8794. Frame 2 shows a green tangent to 2.2917 and then the axis to 1.5833 | confirmed |
| C1.5 | Later steps plain Newton (blue). Step 2 in Stage 1, steps 3–6 Stage 2. No halving | Trace: 2 stage1 plain, 3–6 stage2, halvings = 0 everywhere | confirmed |
| C1.6 | x* ≈ 1.8794 | 2cos(π/9) = 1.87938524157… | confirmed |
| C1.7 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5, quadratic | mpmath: 9.7829e-2, 6.3969e-3, 3.0154e-5, 6.7487e-10. e_{k+1}/e_k² → 0.74 = P″/(2P′) at x* | confirmed |
| C1.8 | x6 equals x* to double precision | float(x*) = 1.8793852415718169 = x6 (equal) | confirmed |
| C1.9 | At x6 \|P\| is below Adams' bound, and the run stops | \|P\|² = 3.155e-30 ≤ eps = 2.453e-27 | confirmed |
| C1.10 | Alt text (doubled first step to ≈1.5833, plain steps, Stage 2 from step 3, quadratic to ≈1.8794) | As above | confirmed |
| C1.11 | Wiring: link `madsreidaa.jl`, embed `madsreidaa.gif` | That script writes that GIF, and the committed GIF is byte-identical to the regenerated one (manifest) | confirmed |

### Case 2: (x−1)²(x+2), x0 = 4.0

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading function and x0 | x³−3x+2 = (x−1)²(x+2) (expanded by hand). `x0 = 4.0` | confirmed |
| C2.2 | Double root at 1 with P′(1) = 0 | P′ = 3x²−3 | confirmed |
| C2.3 | Plain Newton from 4: error roughly halves, still 3.4e-4 after 14 steps | Python: e14 = 3.3541e-4. Ratios 0.58 → 0.50 | confirmed |
| C2.4 | Lengthened every step, all green, all Stage 1. A lengthened step never leads to Stage 2 | Trace: 5 × lengthened, stage 1. f ≠ ff after any accepted lengthening forces stage1 | confirmed |
| C2.5 | 3Δx to x1 = 0.4, past the root | x1 = 0.3999999999999999, trials 241.9, 1.68, 0.746, 15.1 | confirmed |
| C2.6 | then 2Δx four times | k = 2 at steps 2–5 | confirmed |
| C2.7 | Errors 8.6e-2, 1.2e-3, 2.3e-7 of x2–x4, quadratic | 8.571e-2, 1.174e-3, 2.296e-7. Constant ratio about 0.16 | confirmed |
| C2.8 | x5 ≈ 0.99999999952, error 4.8e-10 | 0.9999999995193409, error 4.807e-10 | confirmed |
| C2.9 | Computed \|P(x5)\|² exactly 0, true about 4.8e-37 | Float P(x5) = 0.0. mpmath gives 4.8039e-37 | confirmed |
| C2.10 | No step halved | halvings = 0 | confirmed |
| C2.11 | From x2 on the window zooms. Steps shrink from 0.69 to 2.3e-7 | Code zooms for frame ≥ 2. Steps \|x2−x1\| = 0.6857, \|x5−x4\| = 2.301e-7. Frames 3–6 zoomed | confirmed |
| C2.12 | Each zoomed frame shows the tangent reaching the axis halfway, then the second Δx along the axis | Frames 3–6: Newton points 0.7429, 1.0434, 1.000587, 1.000000115 are the midpoints of their steps, and the frames show them so | confirmed |
| C2.13 | Alt text (five lengthened steps, 3Δx then 2Δx ×4, quadratic until rounding ends at x5, zoom from x2) | As above | confirmed |
| C2.14 | Wiring `madsreidab.jl` / `.gif` | Same check as Case 1 | confirmed |

### Case 3: z² + 4, z0 = 1 + 0i

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading function and z0 | `coeff = [1,0,4]`, `z0 = 1` | confirmed |
| C3.2 | Roots ±2i, no real roots | Trivial | confirmed |
| C3.3 | Reference solves a quadratic in closed form, so the loop is run directly. Start z0 = 1, r0 = 5 | C++ `while (n > 2)` then `quadratic`. A4 | confirmed |
| C3.4 | Full step to −1.5 increases \|P\|² (39.1 vs 25) | 39.0625 vs 25 | confirmed |
| C3.5 | One halving reaches z1 = −0.25. Second halving to 0.375 does not help | 16.504, then 17.145 ≥ 16.504 | confirmed |
| C3.6 | At z1 full step to 7.875 increases \|P\|², two halvings both help (3.8125, 1.78125) | 4358.06 > 16.50. 343.55 < 4358, then 51.45 < 343.55 | confirmed |
| C3.7 | Rotate and halve: z2 = 0.359375 + 0.8125i | −0.25 − (−8.125/4)·0.5·(0.6+0.8i) = 0.359375+0.8125i. Trace agrees | confirmed |
| C3.8 | Orange = halved steps 1 and 3 and rotated step 2 | Trace: halved, rotated, halved. Frames 2–4 orange | confirmed |
| C3.9 | Step 4 plain Newton in Stage 1, steps 5–8 Stage 2 (blue) | Trace | confirmed |
| C3.10 | Quadratic convergence to +2i | Errors 5.00e-2, 6.18e-4, 9.55e-8, 2.23e-15, 7.9e-31. e_{k+1}/e_k² about 0.25 | confirmed |
| C3.11 | Run stops at z8, \|P\| ≈ 3.2e-30 below Adams' bound | \|P\|² = 9.957e-60, so \|P\| = 3.155e-30. Bound sqrt(3.865e-29) = 6.2e-15 | confirmed |
| C3.12 | No lengthened step. Path is a polyline | Trace. Frames | confirmed |
| C3.13 | Alt text | As above | confirmed |
| C3.14 | Wiring `madsreidac.jl` / `.gif` | Same check | confirmed |

### 3. Implementation checks

All three scripts share the routine `newton_real_iterates`, which is identical in all three files (`diff` shows only the header, polynomial, parameters and plotting differ).

**It is the method it claims to be.** I compared the routine line by line with `newton_real` (C++ 229–312). Every branch matches: `feval`/`upperbound` Horner schemes, the 2⁻¹⁰⁶ and 2⁻⁵² constants, `alterdirection`, the saddle branch, the stage test, the r0 cap, the lengthen/halve loop with its i = 2 rotation, Adams' test in Stage 2, and the rounding-domain retry. It departs in the one declared line (`fz0 = fz1`). Start and r0 are inputs, and only the first-root loop runs. Both are disclosed in the script header and on the page. The departure does not change any of the three animated sequences: with `fz0 = fz` (reference mode) mr.py gives the same iterates and stages in all three cases. It changes only the x0 = −0.7 example in the Description, which the page presents with the scripts' version.

**The numbers are right.** My independent translation, written from the C++, matches the Julia trace exactly:

| Case | Step | Julia | Python (mr.py) |
|---|---|---|---|
| 1 | x1…x6 | 1.583333333333333, 1.9772145417306708, 1.885782136079089, 1.8794153957913198, 1.879385242246684, 1.8793852415718169 | identical |
| 1 | stages/kinds | S1 k=2, S1 plain, S2 ×4 | identical |
| 2 | x1…x5 | 0.3999999999999999, 1.0857142857142854, 1.0011741682974553, 1.0000002296437014, 0.9999999995193409 | identical |
| 2 | kinds | k=3, k=2 ×4, all S1 | identical |
| 3 | z1…z8 | −0.25, 0.359375+0.8125i, −0.18577342058459634+1.638759472626044i, 0.043709164712013915+2.0243302797252594i, 0.0005321210650972158+1.9996858191949973i, −8.359196767833248e-8+1.9999999538596989i, 1.9284792715761333e-15+1.999999999999999i, −7.888609052210118e-31+2.0i | identical |
| 3 | kinds | halved, rotated, halved, plain S1, S2 ×4 | identical |
| all | eps (Adams) | e.g. Case 1 final 2.4531296047199128e-27, Case 3 final 3.8654184355829578e-29 | identical |

I also made checks that do not depend on the port:
- Final residuals: Case 1 |P|² = 3.2e-30, Case 2 0 (true 4.8e-37), Case 3 1.0e-59.
- Rates against theory: Case 1 constant 0.74 = P″/(2P′)(x*). Case 2 Stage 1 constant about 0.16. Case 3 constant about 0.25 = |P″/(2P′)| at 2i = 1/4.
- The multiplicity property k = m on a triple root.

**Its reference values are right.** x* = 2cos(π/9) = 1.8793852415718168 (mpmath, and the nearest double equals x6). The double root is x* = 1 (factored form). The Case 3 stars are at ±2i. All are exact.

**The picture shows what was computed.** All committed GIFs are byte-identical to fresh regenerations (manifest). I checked frames as follows:
- aa: frames 1, 2 and 7. The frame-2 tangent goes from (3, 17) to 2.2917 = 3 − 17/24, the thick green axis segment runs to 1.5833, and a vertical line reaches P = −1.76. Labels "x1 = 1.58333 (Stage 1)" … "x6 = 1.87939 (Stage 2)" match. Steps 4–6 are sub-pixel at the fixed window, but only the labels report them and the page does not claim more.
- ab: all 6 frames. Frame 2 runs 4 → 2.8 (Newton point) → 0.4 with a vertical line to P(0.4) = 0.864. Zoomed frames 3–6 have Newton points at the midpoints. The tick formatter is precise enough to tell ticks apart (8 decimals in frame 6). The labels show 11 significant digits, which match the trace.
- ac: all 9 frames. The segments z_k → z_{k+1} have the colours of the trace. Labels (fmt) match, for example "z2 = 0.359 + 0.812i", "z8 = −7.9e-31 + 2.000i". Axis limits (−2.5..2.5, −2.8..2.8) contain the whole path and both roots. No clamping, no masking.
- Frame counts: 7 (x0..x6), 6 (x0..x5), 9 (z0..z8). Each equals 1 + the number of steps.

