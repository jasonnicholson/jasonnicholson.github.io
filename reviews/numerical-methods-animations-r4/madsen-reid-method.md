# Damped Newton with Acceleration (Madsen-Reid Method) — animation review (round 4)

Page: `pages/numerical-methods/madsen-reid-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match (method description), Minor: the "Note on generalization" overstates how far the method's structure carries over
- **Location:** `index.qmd` line 39: "The core ideas — dual-stage damped stepping, acceleration by repeated steps in the same direction, and direction alteration near saddle points — are not limited to polynomials. The same framework can be applied to general nonlinear equations $f(x) = 0$ or systems $\mathbf{F}(\mathbf{x}) = \mathbf{0}$, where it provides a reliable alternative to trust-region methods. … the algorithmic structure translates directly to general scalar and vector problems."
- **What is there now:** the note says the whole structure, including the direction alteration, "translates directly" to real scalar equations and to systems, and that it is "a reliable alternative to trust-region methods".
- **What is true instead:** the direction alteration the page describes (lines 20, 26, 29) and the scripts implement (`alterdirection`, lines 59–64 of each script) multiplies the step by the complex number 0.6 + 0.8i. That only means something for an f that can be evaluated off the real axis, as a polynomial can (Case 3 relies on exactly this). For a real f(x) = 0 on the reals there is no direction to rotate into. Cases 1 and 2 show this themselves: their scripts stop with an error if a rotation occurs (lines 178–181). For a system F(x) = 0 there is no single canonical rotation either. The page gives no evidence for the comparison with trust-region methods.
- **How I know:** I read the code (`alterdirection`; C++ lines 164–171) together with the page's own statement on line 20 that "a rotation would take Cases 1 and 2 off the real axis".
- **Suggested correction:** limit the note to the parts that do carry over (the descent test on |f|², the step lengthening and halving, and the Kantorovich-style switch to plain Newton). Say that the 53.13° rotation needs complex arithmetic and has no direct counterpart for real equations or systems. Drop "a reliable alternative to trust-region methods", or support it with a reference.

No other findings. Every numerical, behavioural, diagram and wiring claim in the Animations section and in the Description's algorithm text checked out against independent computation (ledger below).

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `madsreidaa.jl` | 0 | 9.3 | madsreidaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidab.jl` | 0 | 9.4 | madsreidab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `madsreidac.jl` | 0 | 9.6 | madsreidac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **C** = confirmed, **W** = wrong, **CND** = could not determine.

### Description (algorithm and formula claims)
| # | Claim (page wording, abridged) | Verdict | Evidence |
|---|---|---|---|
| D1 | Scripts port `newton_real`'s iteration "with one correction (Stage 2)" | C | I compared the port line by line with C++ lines 223–312. The only semantic difference is port line 111 (`fz0 = fz1` against C++ line 264 `fz0 = fz`). Index shifts (a1, feval, fz0 = a[n] ↔ C++ a[n-1]) and constants (2^-52 = `_DBL_RADIX^(-DBL_MANT_DIG+1)`, 2^-106, 2^-26 = integer `-53/2`) all match. My independent Python transliteration reproduces every iterate, |P|² and eps of all three scripts bit for bit. |
| D2 | Newton at a root of multiplicity m: f/f′ ≈ (x−x*)/m, error shrinks by (m−1)/m per step | C | Plain Newton on Case 2 from 4: error ratios 0.579, 0.557, 0.537, 0.522, 0.513, 0.507, 0.503 → 1/2 |
| D3 | Stage 1 lengthening: if z−Δz does not increase \|f\|², try z−2Δz, … up to z−(n+1)Δz, stop at the first trial that does not lower \|f\|² and keep the one before | C | Code: `div2 = f > f0`, loop `i in 1:n`, `wz -= dz`, `fw >= f && break`. Trials printed by `mr.py`, for example Case 2 step 1: 241.9, 1.68, 0.7465, 15.12 → k = 3 |
| D4 | Near a root of multiplicity m that point is z − mΔz, so convergence is quadratic while in Stage 1 (Case 2: until rounding takes over) | C | Case 2: k = 2 at steps 2–5 (mpmath k = 2.0, 2.0, 2.0, 2.004). Errors 8.571e-2 → 1.174e-3 → 2.296e-7, so e_{k+1}/e_k² ≈ 0.16, 0.167 (constant). Step 5 error 4.8e-10 is far above the quadratic prediction ~9e-15, so rounding has taken over |
| D5 | Stage 2 takes plain Newton steps, linear at a multiple root | C | Code; reference-mode run from −0.7 shows 18 Stage-2 steps with error halving |
| D6 | Near a double root the two sides of the stage test tend to equality | C | Ratios L/R: Case 2 steps 4, 5: 1.043, 1.003; −0.7 run steps 3–5: 1.238, 1.199, 1.012. Theory: P≈ce², P′≈2ce, P″≈2c gives 2\|P\|\|P″\| = \|P′\|² |
| D7 | Case 2 stays in Stage 1 throughout | C | Trace: all 5 steps stage1 |
| D8 | From x0 = −0.7: plain Newton step past the root to x1 ≈ 1.7556, one Stage-2 step to x2 ≈ 1.4123 (error 0.76 → 0.41) | C | Julia port (`m07.jl`) and Python both give x1 = 1.7555555555555553 (Stage 1, plain), x2 = 1.4123058542413378 (Stage 2); errors 0.756, 0.412 |
| D9 | Stage test then fails, left side 1.24 × right side | C | mpmath directly from P, P′: 1.23839; port/Python: 1.238 |
| D10 | Three lengthened Stage-1 steps with k = 2, errors 2.3e-2, 9.1e-5, 1.4e-9; computed \|f\|² exactly 0; stops after 5 steps | C | x3 = 1.02349 (2.35e-2), x4 = 1.0000909 (9.09e-5), x5 = 1.000000001377 (1.38e-9), \|P\|² = 0, 5 steps |
| D11 | r0 ← 5\|Δz\|, reset after each Newton step from the length before the cap | C | Port line 106 / C++ 260: `r0 = r*5` with r the pre-cap length |
| D12 | A step longer than r0 is cut to length r0 and rotated by 53.13° | C | `alterdirection(dz, r0/r)`: \|0.6+0.8i\| = 1, atan2(0.8, 0.6) = 53.13° |
| D13 | Scripts for Cases 1, 2 stop with an error if a rotation occurs | C | Lines 178–181 check imag(z) and imag(zN) |
| D14 | No Newton step in the three animations is longer than r0; the cap never acts | C | Trace cap = 0 for all 19 steps (Python and Julia) |
| D15 | Δz = f/f′, capped at r0 | C | Port lines 93–94 compute fz·conj(fz1)/\|fz1\|² |
| D16 | Stage 1 halving: halving kept only while it lowers \|f\|² below the previous trial; two helpful halvings → rotate 53.13° and halve once more (×0.5(0.6+0.8i)), point accepted | C | Code; Case 3 step 2 reproduced by hand: −0.25 − (−8.125/4)·0.5·(0.6+0.8i) = 0.359375+0.8125i |
| D17 | Stage 2 takes z − Δz with no trials, ends the run once \|f\| ≤ Adams' bound | C (mechanism) / CND (that `upperbound` is Adams' bound) | Loop condition `f > eps` with eps = `upperbound(z)`. `upperbound` is identical to the reference; I did not derive Adams' bound independently |
| D18 | Stage 2 used only when the previous step was plain (search left it unchanged) and 2\|f(z_k)\|\|w\| ≤ \|f′(z_k)\|²\|z_{k−1}−z_k\| | C | Code: `stage1 = f2/u > u/f/4 \|\| f != ff`; algebra: f2/u ≤ u/(4f) ⇔ 4\|P\|²\|w\|²/\|Δ\|² ≤ \|P′\|⁴ ⇔ the page's inequality. f == ff iff the search left the Newton point |
| D19 | w/(z_{k−1}−z_k) estimates f″; test estimates Kantorovich 2\|f\|\|f″\| ≤ \|f′\|² | C | Standard Kantorovich h ≤ 1/2 |
| D20 | Reference's initial fz0 = f′(0) implies storing f′ | C | C++ line 232 `fz0 = a[n-1]` with z0 = 0, and a[n−1] = P′(0). Storing P (line 264) makes fz0 − fz1 a difference of P and P′, which is dimensionally inconsistent |
| D21 | Madsen and Reid's test (2.9) requires f′(z_{k−1}) | CND | The report AERE-R.7986 is not available locally |
| D22 | The scripts' change does not alter the animations (implied by "one correction") | C (supplementary) | Reference mode (`mr.py value`) gives identical stage decisions and iterates in all three cases. It matters only for the −0.7 example (reference mode: 18 Stage-2 linear steps, 21 total), which the page correctly attributes to the scripts' version |
| D23 | Saddle branch (f′ = 0): previous step rotated 53.13° and lengthened 5×; rounding-domain branch: short step not lowering \|f\|² retried rotated and halved; neither reached | C | Code lines 90–91, 149–156; trace saddle = 0, rounding = 0 everywhere |
| D24 | Halvings compared with the previous trial, rotated step unchecked, Stage-2 unchecked | C | Code; Case 3 step 2 halvings give 343.6, 51.45, both above f(z1) = 16.50 |
| D25 | In all three animations \|f\|² decreases at every step | C | Case 1: 289 → 3.17 → 0.637 → 2.38e-3 → 5.2e-8 → 2.6e-17 → 3.2e-30. Case 2: 2916 → 0.746 → 5.1e-4 → 1.7e-11 → 2.5e-26 → 0. Case 3: 25 → 16.50 → 12.37 → 2.19 → 0.0405 → 6.1e-6 → 1.5e-13 → 7.9e-29 → 1.0e-59 |
| D26 | Uses only f and f′, plus extra f evaluations at trial points | C | Code evaluates only P (`feval(a)`) and P′ (`feval(a1)`) |
| D27 | After each root, deflation by degree 1 or 2 until a linear/quadratic is solved analytically | C (of the reference) | C++ lines 223, 317–333. The scripts do not deflate, and their headers say so |
| D28 | "robust, globally convergent" | CND | Literature claim; not checkable from the code |
| D29 | Generalization note: structure "translates directly" to scalar/vector problems; "reliable alternative to trust-region methods" | W (see F1) | |

### Animations section
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Blue = plain Newton steps; green = lengthened (tangent to Newton point, then along axis); orange = halved/rotated | C | `stepcolor`; frames aa/003, ab/002–006, ac/002–009 |
| A2 | Label of the current point names the stage of the step that reached it | C | `stage2[frame]`; labels match the trace in every frame |
| A3 | Cases 1, 2 start at their own x0 with r0 = 5\|x0\| | C | Scripts line 15: r0 = 15, 20 |
| A4 | Case 3 starts where the reference does | C | `startpoint` for z²+4: u = exp(log 4 / 2) = 2; a[1] = 0 → z = 1·u/2 = 1; r0 = 2.5u = 5 |
| A5 | Case 3 star markers show exact roots | C | Stars at ±2i, frames ac/* |
| A6 | Each case links and embeds its own script/GIF | C | aa/ab/ac links and embeds; manifest: byte-identical regeneration |

### Case 1: P = x³ − 3x − 1, x0 = 3.0
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1.1 | Function and x0 | C | `coeff`, `f`, `x0 = 3.0` |
| 1.2 | Three simple real roots | C | mpmath: 1.8793852415718168, −0.3472963553338607, −1.5320888862379561 |
| 1.3 | \|P\|² = 17.3, 3.17, 8.73 for Δx, 2Δx, 3Δx | C | 17.3075, 3.17079, 8.73249 |
| 1.4 | First move x1 = x0 − 2Δx ≈ 1.5833 (green), passes the root | C | 1.583333333333333 < 1.8794 |
| 1.5 | Later steps plain Newton; step 2 Stage 1, steps 3–6 Stage 2; no halving | C | Trace; step 2 trial 2Δx gave 27.22 > 0.637 → k = 1 |
| 1.6 | x* ≈ 1.8794 | C | 2cos(π/9) = 1.87938524… |
| 1.7 | Errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2–5, quadratic | C | 9.783e-2, 6.397e-3, 3.015e-5, 6.749e-10; e_{k+1}/e_k² = 0.668, 0.737, 0.742 → P″/(2P′) = 0.7422 |
| 1.8 | x6 equals x* to double precision; \|P\| below Adams' bound; stop | C | float(x*) = 1.8793852415718169 = x6; \|P\|² = 3.16e-30 < eps = 2.45e-27 |
| 1.9 | Alt text | C | Matches the frames and the trace |

### Case 2: P = (x−1)²(x+2), x0 = 4.0
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 2.1 | P = (x−1)²(x+2) (coded as x³−3x+2) | C | Expansion |
| 2.2 | Double root at 1, P′(1) = 0 | C | |
| 2.3 | Plain Newton from 4: error roughly halves, still 3.4e-4 after 14 steps | C | 3.354e-4 after 14 steps |
| 2.4 | Lengthened step every time, all green, all Stage 1; a lengthened step never leads to Stage 2 | C | Trace; after a lengthened step f < ff strictly, so `f != ff` forces Stage 1 |
| 2.5 | 3Δx to x1 = 0.4, past the root | C | 0.3999999999999999 |
| 2.6 | Then 2Δx four times | C | k = 2 at steps 2–5 |
| 2.7 | Errors 8.6e-2, 1.2e-3, 2.3e-7 of x2–x4, falling quadratically | C | 8.571e-2, 1.174e-3, 2.296e-7; ratio e/e² ≈ 0.16, 0.167 |
| 2.8 | x5 ≈ 0.99999999952, error 4.8e-10 | C | 0.9999999995193409; −4.807e-10 |
| 2.9 | Computed \|P(x5)\|² exactly 0; true ≈ 4.8e-37; run stops | C | Horner gives 0; mpmath 4.804e-37 |
| 2.10 | No step halved | C | |
| 2.11 | From x2 on the window zooms; steps shrink from 0.69 to 2.3e-7 | C | Step lengths 0.6857 … 2.301e-7; `frame ≥ 2` zoom; frames ab/003–006 |
| 2.12 | Each zoomed frame: tangent reaches the axis halfway, then the second Δx along the axis | C | Frames ab/003–006; mpmath k = 2.0 |
| 2.13 | Alt text | C | |

### Case 3: P = z² + 4, z0 = 1
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 3.1 | Roots ±2i, no real roots | C | |
| 3.2 | Reference solves a quadratic in closed form; here the loop runs on z²+4 from z0 = 1, r0 = 5 | C | C++ `while (n > 2)` then `quadratic`; script lines 172–173 |
| 3.3 | Full step to −1.5 increases \|P\|² (39.1 vs 25) | C | 39.0625 vs 25 |
| 3.4 | One halving reaches z1 = −0.25; second halving to 0.375 does not help | C | 16.504; 17.14 ≥ 16.504 |
| 3.5 | At z1 the full step to 7.875 increases \|P\|²; halvings to 3.8125, 1.78125 both help | C | 4358 > 16.5; 343.6 < 4358; 51.45 < 343.6 |
| 3.6 | Rotation gives z2 = 0.359375 + 0.8125i | C | Exact by hand and in the trace. Frame label shows "0.359 + 0.812i", which is %.3f rounding |
| 3.7 | Orange = halved steps 1, 3 and rotated step 2 | C | Trace kinds; frames ac/002–004 |
| 3.8 | Step 4 plain in Stage 1; steps 5–8 Stage 2 (blue) | C | Trace; frame labels |
| 3.9 | Quadratic convergence to +2i | C | \|e\|: 0.0500, 6.18e-4, 9.55e-8, 2.2e-15; e/e² = 0.247, 0.250, 0.244 (theory 1/(2\|z*\|) = 0.25) |
| 3.10 | Stops at z8 with \|P\| ≈ 3.2e-30 below Adams' bound | C | \|P(z8)\| = 3.155e-30; bound √3.865e-29 = 6.2e-15. At z7 \|P\|² = 7.9e-29 > eps, so the run continues to z8 |
| 3.11 | No lengthened step occurs | C | Step 4 trial 2Δz gives 4.737 > 0.0405 |
| 3.12 | Path is a polyline | C | Code lines 221–226 |
| 3.13 | Alt text | C | |

---

### 3. Implementation checks

All three scripts share the same `newton_real_iterates` (`diff` shows only the polynomial, start, window and plotting differ), so points 1–3 are established once and the numbers are given per script.

**It is the method it claims to be.** The method is Madsen's Newton-based polynomial root finder as coded in Vestermark's `newton_real`: the Stage-1 descent search with lengthening and halving, the saddle rotation, the r0 step cap with rotation, the Kantorovich-style switch to Stage 2, and Adams' rounding-error stop. I compared the port with C++ lines 223–312 statement by statement. The only behavioural difference is the disclosed `fz0 = fz1` (port line 111) in place of `fz0 = fz` (C++ line 264). That change is internally justified: the reference initialises fz0 to P′(0), and the stage test needs a P′ difference. In all three animations it changes no decision or iterate; my `mr.py value` run reproduces the same traces. Only the first-root loop is run, with no deflation, and the script headers and page say so.

**The numbers are right.** My independent Python transliteration (written from the C++) matches every Julia iterate, |P|², eps, kind, k and halving count to the last digit, for all three cases and for the −0.7 example. Further checks that do not depend on either transliteration:
- madsreidaa: trial |P|² at x0 − kΔx computed directly are 17.3075, 3.17079, 8.73249, so k = 2 is right. The Stage-2 test ratio computed directly from P, P′ (mpmath) at the step-3 decision is 0.2238, which is ≤ 1, so Stage 2 is right; at the step-2 decision it is 2.396, so Stage 1 is right. Errors give e/e² → 0.7422 = P″/(2P′)(x*), so convergence is quadratic.
- madsreidab: (x_{k−1} − x_k)/(P/P′)(x_{k−1}) in mpmath gives 3.0, 2.0, 2.0, 2.0, 2.004, matching the reported k. Errors are quadratic with constant ≈ 1/6 until rounding.
- madsreidac: hand computation of each trial (−1.5 → 39.06; −0.25 → 16.50; 0.375 → 17.14; 7.875 → 4358; 3.8125 → 343.6; 1.78125 → 51.45; rotation → 0.359375+0.8125i) and quadratic convergence with constant 0.25 = 1/(2|2i|).

**Its reference values are right.** Case 1 root: mpmath 1.8793852415718168 = 2cos(π/9), and the script header's "≈ 1.8794" is right. Case 2 roots 1 (double) and −2: exact. Case 3 stars at ±2i: exact.

**The picture shows what was computed.**
- madsreidaa (7 frames = x0 + 6 steps): tangents run from (x_k, P(x_k)) to the Newton intercept `real(s.zN)`, then along the axis to x_{k+1} and vertically to the curve. Frame 2 shows the green 2Δx step, 3 → 2.2917 → 1.5833. Frame 3 shows the blue step to 1.97721. Later steps are sub-pixel, but the labels give the values (1.88578, 1.87942, 1.87939) and stages (2, 2, 2, 2). The window (−0.5..3.5 × −5..22) holds every drawn element.
- madsreidab (6 frames): frames 1–2 use the full window (P(4) = 54 < 60). Frames 3–6 zoom on the latest step, the Newton point sits midway, the legend avoids the start point, and the tick decimals (8 at the last frame) keep ticks distinct. Curve noise from evaluating the expanded cubic near x = 1 is about 1e-15 against a y-range of 2e-13, which is not visible. Labels use 11 significant digits and match the trace.
- madsreidac (9 frames): the complex-plane polyline uses the right colours per step kind, stars at ±2i, and labels match the trace, rounded to 3 decimals. The window −2.5..2.5 × −2.8..2.8 contains every iterate. The intermediate trial points (7.875 and so on) are not drawn, which the page acknowledges ("The path is a polyline").
- No clamping or NaN masking is used. Nothing the page discusses falls outside a window.

