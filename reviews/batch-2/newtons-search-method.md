# Newton's Search Method: review, batch 2 round 1

**Result: 0 Error, 0 Misleading, 6 Minor (unverified by an independent checker; M1 reproduced by the director).** No implementation or drawing errors.

The reviewer consulted the archive: `NewtonSearchMod.html`, links lnk_1–lnk_7, the notebook `NewtonSearchMod.nb`, and the printout images gr_35, gr_59, gr_143, gr_180, gr_190, gr_192, gr_195, gr_203. The Example 6 printout images (gr_225 onward) are missing. `a2001/Animations/Optimization/` has no Newton search animation.

## Findings

### M1. Minor (page match): convergence-table range for the run from (−1.0, 0.8), line 529

- **Now:** "Example 5 from (−1.0, 0.8) | … | saddle | between 0.25 and 3.1", under a heading that says the ratios were "measured in 400-digit arithmetic over the first eight steps".
- **True:** the eight ratios e_{k+1}/e_k² are 0.1115 (the first, which the page allows to be left out), 1.48, 0.3151, 3.014, 0.2547, 0.2518, 3.068, 0.2429. The minimum rounds to 0.24. The page's range is what seven ratios give. (Director reproduced the eight values exactly at 400 digits.)
- **Fix:** "between 0.24 and 3.1", or say "first seven steps" (under seven steps the other rows still hold: Example 5(i) 0.07–1.52, from (1.0, 0.8) 0.06–3.25, Example 6 1.059).

### M2. Minor (page match): Example 6 ratio, line 486 vs line 38

- **Now:** Case 2 (line 38): "rises from 0.15 to 1.05". Line 486, right after the five-step table: "rises from 0.15 to about 1.06". Line 530: "→ 1.06".
- **True:** over the five steps shown the ratios are 0.1543, 0.4507, 1.009, 1.046, 1.054; later 1.058, 1.059, 1.060.
- **Fix:** at line 486 say "1.05" (it describes the five-row table), or "about 1.06 in the limit".

### M3. Minor (page match): double-precision rerun values for Example 4, line 325

- **Now:** "a double-precision rerun gives 5.40 × 10⁻²⁵ and 2.7 × 10⁻²⁹".
- **True:** f(P₄), f(P₅) in double precision depend on how the gradient is coded: factored gradient (Julia Cramer, `\`, `inv`; numpy `solve`, `inv`) gives 5.386e−25 and exactly 0; Mathews' `Together` form gives 5.402e−25 and 1.9e−29 (solve) or 3.2e−29 (inverse); the expanded form gives 5.39e−25 and 1.5e−28 or 1.7e−27. The reviewer could not reproduce 2.7e−29 (`dbl.jl`, `dbl2.py`). The page's point that these are rounding noise stands.
- **Fix:** "a double-precision rerun gives about 5.4 × 10⁻²⁵ and then rounding noise between 0 and about 10⁻²⁸, depending on how the gradient is coded".

### M4. Minor (page match): zoom-unit wording in Case 1, line 30

- **Now:** "axes in units of a power of ten that shrinks from 10⁻¹ to 10⁻²⁹".
- **True:** the unit shrinks within each run and resets at the next: (i) −2, −3, −8, −15, −29; (ii) −1, −2, −3, −6, −11, −22; (iii) −1, −2, −3, −5, −10, −19; from (1.0, 0.8) −2, −4, −9, −18; from (−1.0, 0.8) −1, −3, −6, −12. Frame 1 is at 10⁻², and 10⁻²⁹ comes at frame 5, before 10⁻¹ appears.
- **Fix:** "shrinks within each run (overall from 10⁻¹ down to 10⁻²⁹)".

### M5. Minor (fidelity): saddle run from (1.0, 0.8) shortened, line 30, lines 419–431, `newtonsearchaa.jl` line 47

- **Now:** the page and animation run 3 steps from (1.0, 0.8).
- **Mathews:** `NewtonSearch[X0, 5]`; his printout gr_190 shows k = 0…5. Iterates 3–5 agree to 12 decimals, so nothing is lost mathematically, but the page keeps Mathews' counts for the three minimum runs ("4, 5 and 5 steps as in Mathews' tables") and silently shortens this one.
- **Fix:** run 5 steps, or add a clause that steps 4 and 5 repeat P₃ to 12 decimals.

### M6. Minor (fidelity): "not animated" sentence incomplete, line 24

- **Now:** "… his `FindMinimum` run in Example 4 and the enhanced method … are not animated."
- **Archive:** Mathews also compares with `FindMinimum` in Example 3, all three cases of Example 5 (each also with WorkingPrecision → 25) and Example 6, and draws `PlotVectorField` plots of −∇f in Examples 5 and 6.
- **Fix:** "Mathews' `FindMinimum` comparisons (Examples 3 to 6) and his gradient vector-field plots (Examples 5 and 6)".

## Inventory (Phase 1)

- Scripts `newtonsearchaa.jl`, `newtonsearchbb.jl`, `newtonsearchcc.jl`; each ran from a scratch copy and produced a GIF byte-identical to the committed one (25, 11 and 6 frames).
- The page links and embeds exactly these; no orphan files; the section index links the page.
- Packages: Plots, Printf.

## Claim ledger

C = confirmed, W = wrong (minor), CND = could not determine.

**Description (lines 12–18):** Newton step H ΔP = −∇f (all scripts solve it by Cramer's rule) C; Newton-Raphson on ∇f = 0 and the 1-D form C; quadratic convergence near a minimum (general) and one-step minimisation of a quadratic (Example 3) C; convergence to saddles and maxima, runaway C; "every one has been recomputed in 60-digit arithmetic" CND (process claim; the values themselves are confirmed).

**Animations introduction (lines 22–26):** markers and Hessian classification C; title contents C (in Case 1 the H type is in the zoom title; for the divergent run the distance is ‖P_k‖); frame k = row k C; Case 2 to k = 10 as Mathews C; 256-bit arithmetic and 80-digit rerun of titles C (reviewer's 600-bit reruns print identical values except the ‖∇f‖ residual); no Mathews animation, all new C; windows [−3, 3] × [−0.5, 2] and [−4, 4]² are his C; not-animated list W (M6).

**Case 1 (`newtonsearchaa`):** function, three minima and two saddles C; 25 frames, 4/5/5 steps as Mathews C, 3 steps for each saddle run C (Mathews runs 5, M5); window and nullclines, five crossings (degree-9 eliminant, 5 real roots) C; zoom unit wording W (M4); contours and arrow to the stationary point of Q (frames 1, 5, 12, 18, 22, 25) C; H positive definite at every iterate on minimum runs, indefinite on saddle runs with eigenvalues −4.79 and 33.75 at both starts C; saddles (0.9685, 0.7784) and (−0.9021, 0.7210), "just as fast" C; f rises on the first step of both saddle runs (+0.003482, +0.0358) C; f vs Q contour differences up to 5.611% at P₀ and below 0.0775% from P₂ on C; case (ii) distances 0.172, 0.0450, 0.00203, 4.39e−6, 2.07e−11, 4.59e−22 C; each iterate closer than the last C; alt text and wiring C.

**Case 2 (`newtonsearchbb`):** function and starts C; 11 frames C; blue run to (−1, 1), H positive definite, f decreasing C; errors 1.063, 0.1743, 0.0137, 1.893e−4, 3.748e−8, 1.481e−15 C; ratio 0.15 → 1.05 C (1.054; see M2 for line 486); stops after 5 as Mathews C; P₁ = (−5.763, 3.579) leaves the window, right window widens every frame C; H indefinite and f rising toward 0 at every step C; growth factors 1.882 … 1.500 C; ‖P₁₀‖ = 281.6 at (−241.0, 145.6), f = −0.004876 C; alt text and wiring C.

**Case 3 (`newtonsearchcc`):** Rosenbrock starts C; k = 0…5, valley floor dashed C; left window [0.984, 1.004] × [0.97, 1.015] much smaller than Mathews' [0.5, 1.5]² C; H(P₀) indefinite, step 1 on the floor (y − x² = −4.03e−6) with distance 0.01414 → 0.02673 C; then H positive definite, distances 1.636e−4, 6.056e−7, 8.305e−14, 1.571e−25 C; right panel, H positive definite at every iterate, f not monotone C; P₁ = (1.798, 3.233), f 416.8 → 0.6369 C; P₂ = (1.001, 0.3653), f rises to 40.44, annotated (frame 3) C; return to the floor, f(P₅) = 4.045e−32 C; alt text and wiring C.

**Definitions and Example 1:** gradient, Jacobian, Hessian, Lemmas 1–2 C; f_x, f_y and second derivatives (sympy, differences 0) C; ∇f(−3, −2) = (1/25, −19/225) C; Hessian 138, −78, −122 over 3375 (matches gr_35) C; det −1528/759375, eigenvalues −0.042550, 0.047290 C.

**Example 2:** Q at (−3, −2) (matches gr_59) C; its stationary point (−1791/382, −622/191) and f = −0.041401 there C; (b) f(P) = −50/213, gradient, H, Q coefficients, eigenvalues 0.215457 and 0.612392, minimiser (−0.831690, 1.045402) with Q = −0.521790, f = −0.495985 C; stationary points of f C; minimiser of Q = P₁ of Example 6 (same rationals) C.

**Method section:** formulas (3)–(4), Newton-Raphson equivalence, theorem, algorithm, "solve, don't invert" C.

**Example 3:** gradient, H eigenvalues 1 and 3, ΔP₀ = (3, 2), ∇f(3, 2) = 0, table including 3.61 and 4.12, f(3, 2) = −7 global minimum C.

**Example 4:** gradient and Hessian, values at P₀, ΔP₀ = (−1/498, −28117/830000), P₁, f(P₁) = 1.441945e−4, main table every cell (programmatic, half-unit tolerance), det −1992, eigenvalues −2.04 and 976.16, ratio alternating about 0.23 and 23, digits 1.6e−4 … 1.6e−25, Mathews' printout 5.40e−25 and 3.16e−30 (gr_143), exact values 5.38e−25 and 4.9e−51, same points to 12 decimals in double, H(1, 1) eigenvalues 0.3994 and 1001.6 (ratio 2508), `FindMinimum` and "flat" remark, variant table from (1.8, 1.2) every cell, k = 1 eigenvalues 0.144 and 2788, f 0.637 → 40.4, verification C; double-precision rerun values W (M3).

**Example 5:** derivatives, f_x = 0 curve and asymptote, degree-9 eliminant (irreducible, 5 real roots), stationary-point table (all 5 rows), exact first steps and −7999/2560000, tables (i)–(iii) every cell, agreement with Mathews to 12 decimals (gr_180, gr_195, gr_203), H positive definite and f decreasing, ratios settling at 1.073 and 1.017, saddle tables and gr_190, Mathews' "(1.0, 0.8)" typo, f rising 1.7892 → 1.7927 and 1.2892 → 1.3250, eigenvalues −4.79 and 33.75, neighbour values (gr_192), ∇f(1, 0.8) = (−0.15, −0.104), ‖∇f‖ < 1e−17 within five steps at all limits, global minimum −1.846283: C.

**Example 6:** stationary points by adding and subtracting, step 1 rationals and f(P₁), step 2, five-step table every cell, H positive definite and f decreasing, verification, (−3, 2) gradient, H = (1/675)[−6 18; 18 22], eigenvalues −0.0219 and 0.0456, ΔP₀ = (−105/38, 30/19), P₁ = (−219/38, 68/19), f −1/3 → −0.194535, divergence table every cell, factor 1.5000 to five digits from k = 20 (true; already from k = 11), f rising toward 0 and P₁₀, H indefinite and uphill for k = 0…12 (and all 80), symmetry argument and the run from (0.3, −0.2) to the maximum (1, −1) with H = −I/4, 1-D statement about maxima: C; ratio "to about 1.06" W (M2).

**Convergence table, enhanced method, implementation notes:** every row C except (−1.0, 0.8) W (M1); order estimates approach 2 in every run C; enhanced algorithm (t = 1 is plain Newton, descent when H is positive definite, uphill argument for (−3, 2)) C; n(n+1)/2 second derivatives C; f(P₄) prints −0.500000000000 while 3.7e−8 away C; Rosenbrock eigenvalues 0.40 and 1002 C.

## Implementation checks

- **`newtonsearchaa.jl` (Example 5):** plain Newton step, H ΔP = −∇f by Cramer's rule; derivatives match sympy. Every printed iterate matches the reviewer's mpmath run (`check1.py`) to 12 decimals, e.g. case (ii) P₂ = (2.149904635808, 1.588649103038) in both; run from (−1.0, 0.8) P₃ = (−0.902145787278, 0.721019500715), e = 6.67e−12 vs 6.672e−12. Limits from 40 extra Newton steps agree with `findroot` on the eliminant roots; ‖∇f‖ < 1e−75 at 256 bits. Frames drawn from the right quantities; no clamping; at j = n the zoom uses P_{n+1}, which the method does compute.
- **`newtonsearchbb.jl` (Example 6):** same step; quotient-rule derivatives verified symbolically. Both runs match to every printed digit (P₅ error 1.48e−15; P₁₀ = (−241.019696, 145.628489); ratios 1.8815 … 1.5001). (−1, 1) and (1, −1) are exact stationary points with H = ±I/4. `segdraw`/`pathdraw` only shorten drawn segments of the off-window run, the annotation says so, labels keep true values; the widening window widens every frame; log panel plots true values (frames 1, 6, 11).
- **`newtonsearchcc.jl` (Example 4):** same step, Rosenbrock derivatives match sympy; both runs match to 12 decimals, including f(P₅) = 4.937e−51 and 4.045e−32, and the H types and eigenvalues. (1, 1) exact. The f-rise annotation appears from k = 2; the log axis to 1e−52 shows f(P₅) inside the frame (frames 1, 3, 6).
- **Precision robustness:** 600-bit reruns of all three scripts (GIF output disabled) print the same stdout as the committed 256-bit runs, except the ‖∇f‖ residual at the limits.
