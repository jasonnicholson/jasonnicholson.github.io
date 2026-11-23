# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 6)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with the computed values and the frames, at the precision stated. Section 2 shows the evidence for each claim. I found no implementation error, no page mismatch and no fidelity issue (there is no archive topic).

Observations below the bar for a finding (for information only):
- The one stated departure from `newton_real` (storing P′(z_{k−1}) instead of P(z_{k−1}) for the stage test) does not change any of the three animations. With the original `fz0 = fz`, my port gives the same stage, step kind and iterate sequence for Cases 1–3; only the stage-test ratios differ. The change only matters in the Description's x0 = −0.7 example: there the original reference stays in Stage 2 and needs 22 steps instead of 5. The page claims nothing that conflicts with this.
- Case 2, x5: my port with plain Horner and Python complex division gives x5 = 0.99999999984. Using the reference's evaluation scheme gives 0.9999999995193409, bit-identical to the script. The page's "0.99999999952" is the value of the reference-faithful computation. The last digits are rounding noise either way, and the page says so ("rounding makes ...").
- The intro's "globally convergent" is a property of the published method that I could not determine (see ledger D1). The page itself says the descent is "not a guarantee", and the port caps the iteration at MAXITER = 50.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 8.9 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 10.4 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 10.1 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: C = confirmed, W = wrong, ? = could not determine.

### Description

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| D1 | "a robust, globally convergent Newton-based algorithm for finding all roots of a real-coefficient polynomial" | ? | Global convergence is a theoretical property of the published method. I do not have the Madsen/Madsen-Reid papers to check it. The implementation finds all roots by deflation (C++ lines 223–333). |
| D2 | Scripts port `newton_real`'s iteration "with one correction (Stage 2)" | C | Line-by-line comparison of `newton_real_iterates` with C++ lines 229–312: the only change in the loop is `fz0 = fz1` (C++ `fz0 = fz`). Start point and r0 are case parameters, which the Animations intro discloses. Bit-identical traces between the Julia script and my reference-faithful Python port (Section 3). |
| D3 | Newton at multiplicity m: f/f′ ≈ (x−x*)/m, error factor (m−1)/m, linear | C | Standard result. Plain Newton on Case 2 from x0 = 4: errors fall by 0.58 … 0.50 per step (`checks.py`). |
| D4 | Stage 1, when z−Δz does not increase \|f\|², tries z−2Δz, …, up to z−(n+1)Δz, stops at the first trial that does not lower \|f\|² and keeps the trial before it | C | C++ 272–288: `div2 = f > f0`, `wz -= dz` for i = 1..n, `if (fw >= f) break`. Largest multiple is n+1. |
| D5 | Near a root of multiplicity m that point is z−mΔz, so convergence is quadratic in Stage 1 (Case 2 until rounding takes over) | C | Case 2 takes k = 2 at every step from x1 on. Errors 8.57e-2, 1.174e-3, 2.296e-7, with e_{k+1}/e_k² = 0.160 and 0.167. x5 error 4.8e-10 is not quadratic (would be ~9e-15), so rounding has taken over. |
| D6 | Stage 2 takes plain Newton steps, linear at a multiple root | C | Code: Stage 2 does no search. With the original reference from −0.7, the Stage-2 run halves the error per step (0.0235 → 0.0129 → … → 8.9e-7), which shows the linear rate. |
| D7 | Near a double root the two sides of the stage test tend to equality | C | Case 2 stage-test LHS/RHS: 0.70, 1.043, 1.001. From −0.7: 1.238, 1.199, 1.012 (`indep.py`). |
| D8 | Case 2 stays in Stage 1 throughout | C | Trace: stage1 on all 5 steps. |
| D9 | From x0 = −0.7: plain Newton step past the root to x1 ≈ 1.7556 | C | x1 = 1.7555555555555553 (Julia `ab_core.jl` and Python). Stage 1, k = 2 trial at 4.2111 rejected, so a plain step. −0.7 < 1 < 1.7556. |
| D10 | then one Stage-2 step to x2 ≈ 1.4123 (error 0.76 → 0.41) | C | x2 = 1.4123058542413378, Stage 2. Errors 0.75556 → 0.41231. |
| D11 | stage test then fails, left side 1.24 × right side | C | LHS/RHS = 1.238 at step 3. |
| D12 | three lengthened Stage-1 steps with k = 2, errors 2.3e-2, 9.1e-5, 1.4e-9 | C | 2.349e-2, 9.090e-5, 1.377e-9. All k = 2, Stage 1. |
| D13 | computed \|f\|² exactly 0, run stops after 5 steps | C | Step 5 has \|P\|² = 0; trace length 5. |
| D14 | r0 reset after each Newton step to 5\|Δz\| before the cap | C | C++ 257–260: `r = |dz|` before `alterdirection`, `r0 = r*5`. |
| D15 | A step longer than r0 is cut to r0 and rotated by 53.13° | C | `alterdirection(dz, r0/r)`. atan2(0.8, 0.6) = 53.130°, \|0.6+0.8i\| = 1. |
| D16 | Cases 1 and 2 stop with an error if a rotation occurs | C | Lines 180–181 of `madsreidaa.jl` / `madsreidab.jl` check `imag(s.z) == 0 && imag(s.zN) == 0`. |
| D17 | No Newton step in the three animations is longer than r0, so the cap never acts | C | cap = 0 on every step of all three traces, in Julia and in my independent port. |
| D18 | Each iteration computes Δz = f/f′, caps it at r0 | C | C++ 250, 258. |
| D19 | Stage 1 halving: if z−Δz increases \|f\|², halve; each halving kept only while it lowers \|f\|² below the previous trial | C | C++ 274–288. |
| D20 | Two helpful halvings → rotate by 53.13° and halve once more (× 0.5(0.6+0.8i)), point accepted | C | C++ 289–295: `alterdirection(&dz, 0.5)`, then accepted with no comparison. |
| D21 | Rotation makes the step complex, so it can only be shown in Case 3 | C | Case 3 step 2 is the only rotation (trace). |
| D22 | Stage 2 takes z−Δz with no trial points and ends the run once \|f(z)\| ≤ Adams' bound | C | C++ 298–302 sets `eps = upperbound²`. The loop condition `f > eps` compares squares. |
| D23 | Stage 2 used only when the previous step was plain (search left it unchanged) and 2\|f(z_k)\|\|w\| ≤ \|f′(z_k)\|²\|z_{k−1}−z_k\| | C | `stage1 = f2/u > u/f/4 \|\| f != ff` is algebraically equivalent to 4\|P\|²\|w\|² > \|P′\|⁴\|Δ\|², i.e. NOT(2\|P\|\|w\| ≤ \|P′\|²\|Δ\|), or f ≠ ff. `ff` is \|f\|² at the Newton point, so f ≠ ff exactly when the search moved off it. |
| D24 | w/(z_{k−1}−z_k) estimates f″; the test estimates Kantorovich's 2\|f\|\|f″\| ≤ \|f′\|² | C | Difference quotient of f′; Kantorovich h = \|f/f′\|·L/\|f′\| ≤ 1/2 is the same inequality. |
| D25 | Scripts store f′(z_{k−1}), as Madsen–Reid test (2.9) requires and as the reference's initial value f′(0) implies; `newton_real` stores f(z_{k−1}) | C / ? | Script line 111 `fz0 = fz1` (P′). C++ 264 `fz0 = fz` (P). C++ 232 initialises `fz0 = a[n-1]`, the z¹ coefficient, which is P′(0). Confirmed. The equation number "(2.9)" in Madsen–Reid 1975: ? (paper not available to me). Mathematically only P′ makes w estimate f″. |
| D26 | True saddle (f′ = 0): previous step rotated 53.13° and lengthened 5× | C | C++ 246–247 `alterdirection(&dz, 5.0)`. |
| D27 | Rounding domain: a Newton step shorter than 2^−26\|z\| that does not lower \|f\|² is retried from its start, rotated and halved | C | C++ 304–311: `pow(2, -53/2)` = 2^−26 in integer arithmetic. `z = z0; alterdirection(&dz, 0.5); goto iter2`. |
| D28 | Neither branch is reached in the three animations | C | saddle = 0 and rounding = 0 on every step (traces). |
| D29 | Each halving is compared with the previous trial, not \|f(z_k)\|²; the rotated step is accepted unchecked; Stage 2 is unchecked | C | Code as above. Case 3 step 2: halvings to 343.6 and 51.4, both above f(z1) = 16.5, both "help". |
| D30 | In all three animations \|f\|² decreases at every step | C | Case 1: 289 → 3.17 → 0.637 → 2.38e-3 → 5.25e-8 → 2.63e-17 → 3.16e-30. Case 2: 2916 → 0.746 → 5.14e-4 → 1.71e-11 → 2.51e-26 → 0. Case 3: 25 → 16.50 → 12.37 → 2.19 → 0.0405 → 6.1e-6 → 1.5e-13 → 7.9e-29 → 1.0e-59. |
| D31 | Uses only f and f′ (plus extra f at trial points) | C | Only `feval(a, …)` and `feval(a1, …)` are called. |
| D32 | "far more reliable than unguarded Newton on difficult polynomials" | ? | General claim, not tested by any case on this page. |
| D33 | After each root, deflate by degree 1 or 2, solve the last linear/quadratic analytically | C | C++ 317–333 (`realdeflation`, `complexdeflation`, `quadratic`). The scripts do not deflate, and their headers say so. |
| D34 | Generalisation note: descent, lengthening, halving and the stage switch need only f, f′ in real arithmetic; Cases 1 and 2 never leave the real axis; the n+1 bound and Adams' bound come from the polynomial; the rotation needs complex f (Case 3 uses it) | C | Code inspection. Real-axis checks passed in Cases 1 and 2. The "no counterpart for systems" remark is commentary, not checked. |

### Animations intro

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = plain Newton z−Δz; green = lengthened z−kΔz, k ≥ 2, drawn as the tangent to the Newton point then along the axis; orange = halved or rotated | C | `stepcolor`: halved/rotated → orange, lengthened → seagreen, otherwise steelblue. Drawing: tangent `[xn, xt[k]]` where `xt` is the Newton point recorded before the search, axis segment to `xn1`, vertical to P(xn1). Seen in frames aa/007 and ab/002–006. |
| A2 | The current point's label names the stage of the step that reached it | C | `stage2[frame] = !steps[frame].stage1`. Frames: aa x1, x2 Stage 1, x3–x6 Stage 2. ab x1–x5 Stage 1. ac z1–z4 Stage 1, z5–z8 Stage 2. All match the traces. |
| A3 | Cases 1 and 2 start from their own x0 with r0 = 5\|x0\|, not from the reference's start rule; Case 3 starts where the reference does | C | Scripts: r0 = 5·\|x0\| (15, 20). The reference rule would start Case 1 at −1/6 (r0 = 0.833) and Case 2 at 1/3 (r0 = 1.667). For z²+4: u = 2, z = 1, r0 = 5 (`checks.py`). |
| A4 | Case 3 star markers show the exact roots | C | `scatter!` stars at (0, ±2); frames ac/*. The roots of z²+4 are ±2i. |

### Case 1: P(x) = x³ − 3x − 1, x0 = 3.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading: P, x0 = 3.0 | C | `coeff = [1,0,-3,-1]`, `x0 = 3.0`; frame title. |
| C1.2 | Three simple real roots | C | mpmath: −1.532089, −0.347296, 1.879385. |
| C1.3 | \|P\|² = 17.3, 3.17, 8.73 for Δx, 2Δx, 3Δx | C | 17.3075, 3.1708, 8.7325 (trial points 2.2917, 1.5833, 0.875). |
| C1.4 | First move is the lengthened step x1 = x0 − 2Δx ≈ 1.5833 (green), passing the root | C | x1 = 1.583333333333333, k = 2. 1.5833 < x* = 1.8794 < 3. Green in frame aa/002. |
| C1.5 | Every later step is plain Newton (blue): step 2 checked in Stage 1, steps 3–6 Stage 2; no step halved | C | Trace: step 2 is stage1 plain (k = 2 trial rejected, 27.2 > 0.637); steps 3–6 are stage2; halvings = 0. |
| C1.6 | Quadratic convergence to x* ≈ 1.8794 | C | x* = 2cos 20° = 1.8793852415718168. e_{k+1}/e_k² = 0.668, 0.737, 0.742 → P″/(2P′) = 0.742. |
| C1.7 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5 | C | 9.7829e-2, 6.3969e-3, 3.0154e-5, 6.7487e-10 (mpmath). |
| C1.8 | x6 equals x* to double precision | C | float(2cos 20°) = 1.8793852415718169 = x6 (True). |
| C1.9 | There \|P\| is below Adams' bound and the run stops | C | \|P(x6)\| = 1.78e-15 < √eps = 4.95e-14; the trace ends at step 6. |
| C1.10 | Alt text: doubled first step 3.0 → 1.5833, then plain Newton, Stage 2 from step 3, quadratic to ≈ 1.8794 | C | As above. |
| C1.11 | Wiring: link `madsreidaa.jl`, embed `madsreidaa.gif` | C | Manifest: the script produces exactly this GIF, byte-identical. |

### Case 2: P(x) = (x−1)²(x+2), x0 = 4.0

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading: P, x0 = 4.0 | C | `coeff = [1,0,-3,2]` = (x−1)²(x+2) (expanded by hand); `x0 = 4.0`. |
| C2.2 | Double root x* = 1, P′(1) = 0 | C | P′ = 3x²−3 = 0 at 1. |
| C2.3 | Standard Newton from 4: error roughly halves; still 3.4e-4 after 14 steps | C | Error ratios 0.58 … 0.50. Step 14 error 3.354e-4. |
| C2.4 | Lengthened step every time, all green, all Stage 1; the run starts in Stage 1 and a lengthened step never leads to Stage 2 | C | Trace: 5 × lengthened, all stage1. First iteration has f = 2916 ≠ ff = 8. After lengthening f ≠ ff, which forces stage1. |
| C2.5 | 3Δx to x1 = 0.4, past the root | C | k = 3, x1 = 0.3999999999999999. Trials 2.8, 1.6, 0.4 accepted; −0.8 rejected (15.1 > 0.746). |
| C2.6 | then 2Δx four times | C | k = 2 on steps 2–5. |
| C2.7 | Errors 8.6e-2, 1.2e-3, 2.3e-7 of x2–x4, quadratic | C | 8.5714e-2, 1.1742e-3, 2.2964e-7. Ratios 0.160 and 0.167. |
| C2.8 | x5 ≈ 0.99999999952 (error 4.8e-10) | C | x5 = 0.9999999995193409 (script and reference-faithful port). Error −4.807e-10. |
| C2.9 | Computed \|P(x5)\|² exactly 0; true value ≈ 4.8e-37; run stops | C | Trace \|P\|² = 0. mpmath ((x5−1)²(x5+2))² = 4.804e-37. |
| C2.10 | No step halved | C | halvings = 0. |
| C2.11 | From x2 on the window zooms on each new step; steps shrink from 0.69 to 2.3e-7 | C | `frame ≥ 2` zoom branch. Step lengths x1→x2 0.6857, … x4→x5 2.301e-7. Frames ab/003–006 are zoomed. |
| C2.12 | Each zoomed frame shows the tangent reaching the axis halfway along the step, then the second Δx along the axis | C | Frames ab/003–006: e.g. frame 3, tangent from 0.4 meets the axis at 0.743 = midpoint of 0.4 → 1.086. For k = 2 the Newton point is the midpoint by construction. |
| C2.13 | Alt text: five lengthened steps (3Δx, then 2Δx ×4), 4.0 → 1, quadratic until rounding ends at x5, zoom from x2 | C | As above. |
| C2.14 | Wiring: `madsreidab.jl` / `madsreidab.gif` | C | Manifest. |

### Case 3: P(z) = z² + 4, z0 = 1 + 0i

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Heading: P, z0 = 1 + 0i | C | `coeff = [1,0,4]`, `z0 = complex(1.0, 0.0)`. |
| C3.2 | Roots ±2i, no real roots | C | Exact. |
| C3.3 | The reference solves a quadratic in closed form, so the loop is run directly; reference start z0 = 1, r0 = 5 | C | C++ `while (n > 2)` then `quadratic()`. startpoint gives u = 2, z = 1, r0 = 2.5u = 5. |
| C3.4 | Full Newton step to −1.5 increases \|P\|² (39.1 vs 25) | C | 39.0625 vs 25. |
| C3.5 | One halving reaches z1 = −0.25; a second halving to 0.375 does not help | C | 16.504 at −0.25; 17.145 at 0.375 ≥ 16.504, rejected. |
| C3.6 | At z1 the full step to 7.875 increases \|P\|²; two halvings help (3.8125, then 1.78125) | C | 4358.1 > 16.5; 343.55 < 4358.1; 51.45 < 343.55. |
| C3.7 | alterdirection rotates and halves: z2 = 0.359375 + 0.8125i | C | Trace and hand check: −0.25 + 2.03125·0.5·(0.6+0.8i) = 0.359375 + 0.8125i. |
| C3.8 | Orange = halved steps 1 and 3 and rotated step 2 | C | Kinds: halved, rotated, halved. Frames ac/002–004 are orange. |
| C3.9 | Step 4 plain Newton checked in Stage 1; steps 5–8 Stage-2 plain Newton (blue) | C | Trace and frame labels. |
| C3.10 | Converging quadratically to +2i | C | Errors 5.00e-2, 6.18e-4, 9.55e-8, 2.2e-15. e_{k+1}/e_k² = 0.247, 0.250, 0.244 (≈ 1/(2\|z*\|) = 0.25). |
| C3.11 | Stops at z8, \|P\| ≈ 3.2e-30 below Adams' bound | C | \|P(z8)\| = 3.155e-30 (script and port; mpmath at the stored z8: 3.1554e-30). √eps = 6.2e-15. |
| C3.12 | No lengthened step occurs; the path is a polyline | C | k = 1 throughout. Straight segments between iterates. |
| C3.13 | Alt text: halved step, rotation off axis after two helpful halvings, further halved step, plain Newton to +2i | C | As above. |
| C3.14 | Wiring: `madsreidac.jl` / `madsreidac.gif` | C | Manifest. |

### 3. Implementation checks

### All three scripts (shared routine `newton_real_iterates`)

The three scripts' routines are textually identical: `diff` shows changes only in the parameters and the plotting.

- **Is it the method it claims to be?** Yes. It is the iteration loop of Vestermark's `newton_real` (Madsen's method). I compared it against Newton_Real.cpp lines 229–312 statement by statement:
  - initial state: z0 = 0, f0 = ff = 2a_n², fz0 = a_{n−1}, eps = 4n²f0·2^−106;
  - loop condition;
  - saddle branch;
  - Newton step by the conjugate formula;
  - stage test;
  - cap with rotation;
  - r0 = 5r;
  - iter2 search: lengthening up to i = n, halving, rotation at i = 2;
  - Stage-2 Adams bound with 2^−52;
  - rounding-domain retry with 2^−26 (`-DBL_MANT_DIG/2` = −26 in integer division).

  The single change is line 111 `fz0 = fz1`, which the script comments and the page disclose. Running only the first root (no deflation) is stated in the header comment.
- **Are the numbers right?** I wrote an independent Python port from the C++ (`review/indep.py`) and used it two ways:
  - With plain Horner and Python complex division, it gives the same step kinds, stages and iterates for all three cases. They agree to all printed digits except rounding-level last digits near convergence (Case 2 x5, Case 3 z8).
  - With the reference's own `feval` scheme and division formula (`review/checks2.py`), it is **bit-identical** to the script trace in every step of all three cases. Examples: Case 1 x6 = 1.8793852415718169; Case 2 x5 = 0.9999999995193409; Case 3 z8 = −7.888609052210118e-31 + 2.0i; and every \|P\|² and eps value.

  Property checks: quadratic rates as listed in C1.6, C2.7 and C3.10, the multiplicity-corrected k = 2 at the double root, and residuals at the final iterates below Adams' bound.
- **Are the reference values right?** Case 1 x* = 2cos 20° (closed form, mpmath to 40 digits). Case 2 x* = 1 (by factorisation). Case 3 ±2i (exact). Case 3 draws the stars at the exact roots. Cases 1 and 2 draw no reference marker; their curves use `f(x)`, which is the same polynomial as `coeff` (checked by expansion).
- **Does the picture show what was computed?**
  - *madsreidaa* (frames 1–7): tangent from (x_k, P(x_k)) to the recorded Newton point `xt`, so the slope is P/(P/P′) = P′. Then the axis segment to x_{k+1} and the vertical to P(x_{k+1}). The green first step goes 3 → 2.29 → 1.58 (frame 7). All iterates lie in the window (−0.5, 3.5). Labels show x_k to 5 decimals and the stage of step k, matching the trace.
  - *madsreidab* (frames 1–6): full window for x0 and x1. From x2 on, a zoom to the latest step with adaptive tick decimals. Each zoom contains the step start, the Newton point and the end. The y-range is 1.25 × max\|P\| at the ends. The tangent meets the axis at the midpoint as stated. Labels show 11 significant digits (x5 = 0.99999999952). Near 1e-13 the curve is drawn with naive `f`, so cancellation noise of about 1e-15 is present, but it is not visible at the plotted scale (frame 6 looks smooth).
  - *madsreidac* (frames 1–9): straight segments z_k → z_{k+1}, coloured by kind (orange, orange, orange, blue × 5), with equal aspect. The window is (−2.5, 2.5) × (−2.8, 2.8) and contains all iterates and both roots. Labels use 3 decimals or 1-digit scientific notation (e.g. "z8 = −7.9e-31 + 2.000i (Stage 2)"), consistent with the trace. Steps 6–8 are sub-pixel, and the page claims nothing about their visibility.
  - No clamping, NaN masking or off-window features in any GIF.

Nothing could not be determined, except D1 (the global-convergence property of the published method), D32 (the general reliability claim) and the equation number "(2.9)" in D25, because the source papers are not available here.

