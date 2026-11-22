# Aitken's Method & Steffensen's Acceleration — animation review (round 5)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. Every numeric claim on the page reproduces from the scripts' own computation to the precision stated, the exact-arithmetic claims reproduce from an independent multiprecision computation, the formulas in the Description are the ones the scripts implement, and the frames show what was computed.

Things I examined and decided are not findings (recorded so the clean result can be trusted):

- **Bottom panel x-axis "Iteration k" puts Steffensen outer step k beside Newton step k**, although one Steffensen step costs two Newton steps. The Description states the cost ("Each outer iteration consumes two Newton steps", table "Two Newton evals per step"), Case 2 says "4 steps (8 Newton steps)", and the cost-matched comparison is even more lopsided than needed for the page's point (Case 1: S_3 = 6 Newton steps, error 6.6e-9, vs Newton x_6 error 2.0e-2). The reader's conclusion does not change. Not a finding.
- **Rounding-dependent numbers (Description line 20; Case 3 steps 4–6).** These depend on how the polynomial is evaluated. My Python Float64 reimplementation (C `pow`) gives different noise (Case 1: f==0 first at Newton step 30, error 3.6e-9; Case 3 Steffensen S_4..S_6 errors 5.3e-8, 3.5e-9, 2.2e-8), but the page quotes the values the Julia scripts actually produce and labels them as rounding effects ("In double precision, rounding in f…", "comparable to the rounding error…"). The Julia values match the page exactly. Not a finding.
- **Mathews Example 6 says "the multiple root near x = 2"**; the page says p = √3 ≈ 1.732. The double roots of x⁶−7x⁴+15x²−9 = (x²−1)(x²−3)² are ±√3 (±1 are simple), and Mathews' own Example 5 for the same function states p = √3. The page is right.
- **Mathews Examples 1, 3, 5 (Aitken Δ² applied to the Newton sequence) are not animated.** The page says so explicitly (line 69), so it is not a silent drop; an animation of plain Aitken Δ² would be content the page does not yet have.
- **Case 1 starts at x₀ = 2 instead of Mathews' p₀ = 1.** Disclosed with the correct reason (see ledger L-31). Not a finding.
- Cosmetic: the red `S_k=` annotation overlaps the curve slightly in Case 3, and S_0 is hidden under the Newton marker in frame 0 of each GIF. Readable; not misleading.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 11.5 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 10.1 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 12.5 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `aitkenab.gif` | 23 | byte-identical | aitkenab |
| `aitkencd.gif` | 23 | byte-identical | aitkencd |
| `aitkenef.gif` | 23 | byte-identical | aitkenef |

### Page references

- Scripts linked: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: C = confirmed, W = wrong, ? = could not determine. Evidence key: **J** = instrumented Julia copy output (`aitken*_inst.out`), **M** = mpmath (`exact.out`), **F** = frames, **A** = archive, **S** = script source.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L-1 | Newton converges quadratically at simple roots | C | standard; not page-specific |
| L-2 | At a root of multiplicity m, lim \|x_{k+1}−p\|/\|x_k−p\| = (m−1)/m | C | Newton map g'(p) = 1−1/m; M: ratio e22/e21 = 0.50000 in all three cases (m = 2) |
| L-3 | Double root: ratio 1/2, "each Newton step only halves the error" | C | J: Case 1 errors 3.1893e-4 → 1.5947e-4 → 7.9738e-5 …; M ratio 0.5 |
| L-4 | "about 50 iterations" to go from error ~1 to 1e-16; 2^-53 ≈ 1.1e-16 | C | 2^-53 = 1.11e-16; 53 halvings ≈ "about 50" |
| L-5 | Expanded polynomials of Cases 1 and 3: f evaluates to exactly 0 after 28 and 25 Newton steps | C | J: "Newton: f(x_28)==0 exactly" (Case 1), "f(x_25)==0 exactly" (Case 3) |
| L-6 | …at errors 1.5e-9 and 2.6e-10 | C | J: 1.5211e-09, 2.5538e-10 |
| L-7 | Δx_k = x_{k+1}−x_k, Δ²x_k = x_{k+2}−2x_{k+1}+x_k | C | definition; matches Mathews' forward-difference definition |
| L-8 | x̂_k = x_k − (Δx_k)²/Δ²x_k, expanded form | C | algebra checked; S line 48 implements the same with x_k→p0, x_{k+1}→q1, x_{k+2}→q2 |
| L-9 | Theorem: x_k→p, x_k≠p, (x_{k+1}−p)/(x_k−p)→A, \|A\|<1 ⇒ (x̂_k−p)/(x_k−p)→0 | C | with e_{k+1}=r_k e_k: (x̂_k−p)/e_k = r_k(r_{k+1}−r_k)/(r_k r_{k+1}−2r_k+1) → A·0/(1−A)² = 0; matches Mathews' theorem statement |
| L-10 | Steffensen applies Aitken directly to the Newton iteration | C | S lines 42–48 (ab) / 46–60 (cd, ef); matches Mathews ("When Aitken's process is combined with the fixed point iteration in Newton's method…") |
| L-11 | Algorithm steps 1–3 (q1, q2 Newton steps; p1 = p0 − (q1−p0)²/(q2−2q1+p0); restart) | C | S, identical formulas |
| L-12 | "superlinear convergence even at double roots" / "restores roughly quadratic convergence" | C | M: e_{k+1}/e_k² constant — Case 1: 0.085, 0.083, 0.083; Case 2: 0.213, 0.177, 0.177; Case 3: 0.58, 0.577, 0.577 |
| L-13 | Each outer iteration consumes two Newton steps; correction far more accurate than either | C | S; J Case 1: q2 error 0.298 vs S_1 error 0.057 |
| L-14 | Table: Newton simple – quadratic; Newton double – linear (1/2); Steffensen double – ≈2, two Newton evals per step | C | L-2, L-12, S |

### Animations — introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L-15 | Two synchronized panels per function | C | F, S layout (2,1) |
| L-16 | Top: Newton tangent steps, one per frame, current x_k in legend | C | F frames 1, 3, 23 (legend "Newton x_0…x_22"); S `n_pts = 1+2*frame`; 23 frames = k 0…22 |
| L-17 | Top: Steffensen iterates marked on the x-axis | C | F red diamonds at y = 0; S line 91 |
| L-18 | Bottom: log10\|x_k−p\| vs iteration for both methods | C | F; S lines 61–64, 111–114; clamp 1e-16 never active (smallest error 6.66e-16) |
| L-19 | Newton steps shorter than one pixel after the first 8, 5, 4 steps in Cases 1, 2, 3 | C | pixels.txt: plot box ≈ 596–599 px; step lengths (px) Case 1: …7: 2.09, 8: 1.05, 9: 0.53; Case 2: …5: 1.34, 6: 0.66; Case 3: …4: 1.83, 5: 0.90. Vertical extents f(x_k) at those steps are < 1 px too |
| L-20 | So top panel shows only the start of Newton's run; tail in bottom panel | C | F frame 23 of each |
| L-21 | Julia source scripts linked under each case | C | index.qmd lines 75, 83, 91 |
| L-22 | Cases 1–3 use functions and Newton-vs-Steffensen comparisons of Mathews Examples 2, 4, 6 | C | A: Ex 2 f = x³−3x+2, p = 1; Ex 4 f = sin(x²−2)(x²−2), p = √2; Ex 6 f = x⁶−7x⁴+15x²−9 (gr_58/59, 138/139, 218); each "Use Newton's method and Steffensen's acceleration method" |
| L-23 | Starting values of Mathews for Cases 2 and 3 | C | A: Ex 4 p0 = 1 (gr_140), Ex 6 p0 = 1.5 (gr_219); S x0 = 1.0, 1.5 |
| L-24 | Example 2's stated p0 = 1 is the root, f'(1) = 0, Newton step undefined | C | A: gr_60 decoded pixel-for-pixel = "p₀ = 1" (byte-identical to Ex 4's gr_140); f(1) = 0, f'(1) = 3−3 = 0 |
| L-25 | Examples 1, 3, 5 apply Aitken Δ² to the Newton sequence for the same three functions | C | A: Ex 1 p = 1, Ex 3 p = √2, Ex 5 p = √3 (gr_33, 113, 193) and their text |

### Case 1

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L-26 | Heading: f = x³−3x+2, double root p = 1, x0 = 2.0 | C | S lines 13, 16–17; (x−1)²(x+2) expands to x³−3x+2 |
| L-27 | Newton converges linearly to p = 1; f = (x−1)²(x+2) | C | J; algebra |
| L-28 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 in 3 steps | C | J: 1.0000e+00, 5.7471e-02, 2.8049e-04, 6.5560e-09; M agrees to all shown digits |
| L-29 | Newton still at 3.1e-7 after 22 steps | C | J: 3.1148e-07; M: 3.115e-7 |
| L-30 | At S_3 the expanded polynomial evaluates to exactly 0, Δ² denominator 0, sequence stops | C | J: f(S_3) = 0.0, unguarded q1 = q2 = S_3, den = 0; stop_reason "Δ² denominator = 0", n_done = 3; F frame 23 legend "Steffensen (3 steps; stopped: Δ² denominator = 0)" |
| L-31 | Alt text: stopping after 3 steps at error 6.6e-9 | C | as L-28; F bottom panel last red point at log10 = −8.18 |
| L-32 | Link `aitkenab.jl` / embed `aitkenab.gif` are this case | C | S header and title "f(x) = x³−3x+2 (p = 1)"; manifest byte-identical regen |

### Case 2

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L-33 | Heading: f = (x²−2)sin(x²−2), double root √2, x0 = 1.0 | C | S lines 13, 16–17; f ~ (x²−2)² near √2 |
| L-34 | f' in script correct | C | d/dx[u sin u], u = x²−2: 2x(sin u + u cos u) = S line 14 |
| L-35 | Steffensen error 6.7e-16 after 4 steps (8 Newton steps) | C | J: S_4 error 6.6613e-16 |
| L-36 | That is three units in the last place | C | S_4 = 1.4142135623730945 vs fl(√2) = 1.4142135623730951; ulp in [1,2) = 2.22e-16; 6.66e-16 = 3 ulp |
| L-37 | Newton still at 4.7e-8 after 22 | C | J: 4.7272e-08; M: 4.727e-8 |
| L-38 | Errors measured from double-precision √2; from exact √2 final error 5.7e-16 | C | S `root = sqrt(2.0)`; independent: \|S_4 − √2\| = 5.695e-16 (indep.out) |
| L-39 | Stops at S_4 because \|f'(S_4)\| below 1e-14 cutoff | C | J: f'(S_4) = −8.7925e-15, stop_reason "\|f'(S_4)\| < 1e-14"; F legend shows it |
| L-40 | Alt text: 6.7e-16 from double √2 (5.7e-16 exact) after 4 steps | C | as above; F last red point at −15.18 |
| L-41 | Wiring `aitkencd.jl` / `aitkencd.gif` | C | S header/title; manifest |

### Case 3

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L-42 | Heading: f = x⁶−7x⁴+15x²−9, double root √3, x0 = 1.5 | C | S; (x²−1)(x²−3)² expands to the given polynomial |
| L-43 | f' in script correct | C | 6x⁵−28x³+30x |
| L-44 | √3 ≈ 1.732 | C | |
| L-45 | Newton tangent steps shorter than a pixel after first four | C | L-19 |
| L-46 | Steffensen error 2.8e-8 in 3 steps | C | J: 2.7592e-08; M: 2.76e-8 |
| L-47 | Then stalls; polynomial values near the root of order 1e-14 | C | J: f(S_3) = 2.13e-14, f(S_4) = 7.8e-14, f(S_5) = 7.1e-15, f(S_6) = 0 |
| L-48 | …comparable to the rounding error of evaluating the polynomial | C | terms x⁶ ≈ 27, 7x⁴ ≈ 63, 15x² ≈ 45; ulp(63) ≈ 1.4e-14 |
| L-49 | Steps 4–6 errors 5.4e-8, 2.1e-8, 1.5e-8 | C | J: 5.4422e-08, 2.1477e-08, 1.4585e-08 |
| L-50 | About where Newton is after 22 steps (2.4e-8) | C | J: 2.4023e-08 (M exact: 2.237e-8; the Float64 value is what is plotted) |
| L-51 | In exact arithmetic step 4 would reach 4.4e-16 | C | M: 4.398e-16 at 60 and 200 digits |
| L-52 | Alt text: levels off at a few times 1e-8 after 3 steps | C | F frame 23 bottom panel; J |
| L-53 | No guard fires (script comment) / 6 steps drawn | C | J: n_done = 6, stop_reason empty; F legend "Steffensen (6 steps)" |
| L-54 | Wiring `aitkenef.jl` / `aitkenef.gif` | C | S header/title; manifest |

No claim was left at "could not determine". One limitation: I could not compare the page's numbers with Mathews' own iterate tables because those solution images are not in the archive.

---

### 3. Implementation checks

All three scripts share one structure: 22 Newton steps from x0; Steffensen = two Newton steps then the Aitken Δ² formula, restarted from each accelerated value, with guards (ab: |Δ²| < 1e-15; cd/ef: |f'(S)| < 1e-14, |f'(q1)| < 1e-14, |Δ²| < 1e-15) that truncate the sequence without padding.

### `aitkenab.jl` — f = x³−3x+2, p = 1, x0 = 2

1. **Method.** Newton (S line 29) and Steffensen-on-Newton (lines 42–48), as described in the Description and in Mathews. This is Mathews' variant, applying Aitken to the Newton map. It is not the derivative-free Steffensen root iteration, and the page describes this variant correctly.
2. **Numbers.** Script (J) beside independent mpmath (M):

   | | script | independent |
   |---|---|---|
   | Newton x_1, x_2, x_3 error | 5.5556e-1, 2.9791e-1, 1.5539e-1 | 0.5556, 0.2979, 0.1554 |
   | Newton x_22 error | 3.1148e-7 | 3.115e-7 |
   | S_1, S_2, S_3 error | 5.7471e-2, 2.8049e-4, 6.5560e-9 | 0.05747, 2.805e-4, 6.557e-9 |
   | S_4 | not computed (Δ² = 0 in Float64) | 3.583e-18 (exact arithmetic) |

   The Newton error ratio tends to 0.5 and Steffensen's e_{k+1}/e_k² is constant at ≈0.083, so both rates are the known ones.
3. **Reference.** root = 1.0 is exact.
4. **Picture.** Tangent path: (x_i, 0) → (x_i, f(x_i)) → (x_{i+1}, 0), which is the correct Newton geometry. The title function matches the code. The legend index matches the frame (x_0 in frame 1, x_22 in frame 23), and `S_k=` annotations match J values (S_2 = 0.9997195119, S_3 = 0.9999999934). Axis limits keep all of Newton's visible motion and the root in view. The log-error clamp (1e-16) is never reached.

### `aitkencd.jl` — f = (x²−2)sin(x²−2), p = √2, x0 = 1

1. **Method.** As above, with derivative guards. The Newton guard never fires within 22 steps (J: all x_k distinct, f' ≈ 1e-6 at x_22).
2. **Numbers.**

   | | script | independent |
   |---|---|---|
   | Newton x_1, x_2, x_3 error | 1.0972e-1, 5.1689e-2, 2.5263e-2 | 0.1097, 0.05169, 0.02526 |
   | Newton x_22 error | 4.7272e-8 | 4.727e-8 |
   | S_1..S_4 error | 3.8023e-2, 3.0775e-4, 1.6772e-8, 6.6613e-16 | 0.03802, 3.077e-4, 1.677e-8, 4.973e-17 (exact arith.) |

   S_4 agrees with the exact-arithmetic S_4 to double resolution (5.7e-16 from exact √2). The stop is correct: f'(S_4) = −8.79e-15, and an unguarded step 5 would have Δ² = 0 (J).
3. **Reference.** root = sqrt(2.0), the correctly rounded double. The page states that errors are measured from it and gives the exact-√2 value.
4. **Picture.** Same construction. Title, ylabel "log₁₀ |xₖ − √2|", legend stop reason and `S_4=1.4142135624` all match. The final red point at −15.18 = log10(6.66e-16).

### `aitkenef.jl` — f = x⁶−7x⁴+15x²−9, p = √3, x0 = 1.5

1. **Method.** As above. No guard fires within 6 Steffensen steps (n_done = 6). Note that S_6 already has f = 0, so a 7th step would hit Δ² = 0, but the script stops at 6 and the page claims only 6.
2. **Numbers.**

   | | script | independent |
   |---|---|---|
   | Newton x_1, x_2, x_3 error | 5.3479e-2, 2.4879e-2, 1.2062e-2 | 0.05348, 0.02488, 0.01206 |
   | Newton x_22 error | 2.4023e-8 (Float64) | 2.237e-8 (exact arith.) |
   | S_1, S_2, S_3 error | 1.9424e-2, 2.1863e-4, 2.7592e-8 | 0.01942, 2.186e-4, 2.76e-8 |
   | S_4, S_5, S_6 error | 5.4422e-8, 2.1477e-8, 1.4585e-8 | 4.398e-16, 1.1e-31, … (exact arith.) |

   S_1–S_3 agree. From S_4 on, Float64 rounding in f dominates, exactly as the page explains. The Float64 Newton tail (2.40e-8 vs exact 2.24e-8) is also rounding-perturbed near the end (Newton hits f = 0 at step 25). The page quotes the Float64 value it plots.
3. **Reference.** root = sqrt(3.0); errors ~1e-8 make the 1e-16 rounding of the reference irrelevant.
4. **Picture.** Same construction. xlims (0.6, 2.6) show the root, the simple root at 1 and the start point. The title and labels match the code. The bottom-panel stall at S_3–S_6 is visible (F frame 23), matching J.

