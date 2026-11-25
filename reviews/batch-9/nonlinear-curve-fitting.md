# Review: Nonlinear Curve Fitting (batch 9, round 1)

**Findings: 0 Error, 1 Misleading (independently confirmed), 1 Minor (unverified).**

Legacy archive consulted: `NonLinearCurveFitMod.html`, Links lnk_1–lnk_3, the surviving images gr_19, 33, 110, 113–116, 124; `a2001/Animations` has no curve-fitting folder. Independent computations: 50-digit mpmath linearized and direct least-squares fits (reduced equation, sign-change scan, Hessian), a 60-digit Gauss–Newton with normal-equation steps, a brute-force reconstruction of the Example 2 data, grid searches around each direct fit; the checker cross-checked the direct fits with SciPy `least_squares` from 27 starts each.

## Findings

### F1 — Page match — Misleading (confirmed by an independent checker): the two Example 3 fits are not where linearization costs the most by the factor quoted

- **Location:** `index.qmd` line 27 (Animations introduction): "Case 3 shows the two fits where linearization costs the most (factors $4.20$ and $5.99$ in $E$)."
- **True instead:** the factors (linearized E / direct E) are 1.22519 (Example 1), **4.81980** (Example 2, power), 4.19569 (Example 3, exponential), **5.98872** (Example 3, power). By factor the two costliest are Example 3 power and Example 2 power; Example 3 exponential is third. The page's own table (line 414) lists "1.23, 4.82, 4.20 and 5.99". The claim holds only in absolute terms: E rises by 0.0092, 0.0372, 3.4485, 7.5217.
- **Evidence:** reviewer `direct.py` ("factor lin/direct" 1.22519, 4.8198, 4.19569, 5.98872); checker `check/factors.py` and `xcheck.py` (same minima from 27 SciPy starts each).
- **Fix:** "Case 3 shows the two fits where linearization costs the most in absolute terms (E rises by 3.45 and 7.52 above the minimum, factors 4.20 and 5.99)", or drop the "costs the most" justification.

### F2 — Fidelity — Minor (unverified): Mathews' "3(b)" does have a graph

- **Location:** line 27: "Part 3(b) is a discussion with no graph."
- **True instead:** in Mathews' problem statement 3(b) is the discussion question, but in his Solution 3 (`Links/NonLinearCurveFitMod_lnk_3.html`, lines 65–103) the section headed "3 (b)" is the power fit, ending in a plot-sized image gr_148 (288×178, now lost). The page treats the power fit as part of 3(a), a reasonable reading of the statement.
- **Fix:** "Part 3(b) of the problem statement is a discussion (Mathews' solution uses the label 3(b) for the power fit, which Case 3 includes)", or say the discussion part has no graph.

## Inventory (Phase 1)

3 scripts, 3 GIFs (28, 28, 12 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (1–8):** confirmed (transformations; normal equations; a = A, c = e^B; linearized curve is not least squares in y); the 50-digit process claim CND, every value agrees.
- **Animations introduction (9–21):** confirmed except 19 (F2) and the comparison in 20 (F1): line through the centroid; slope sweeps up past A* and back; panels; Gauss–Newton in Case 3; no Mathews animation; lost graphs.
- **Case 1 (22–32):** confirmed: centroid (2, 1.239772); S(A) = S* + 10(A − A*)², falls from 1.538 to 0.00796547 at 0.391202; fit 1.57991e^{0.391202x}, E = 0.0500688; above the window for slopes > 0.5314; true E kept in titles (101.2 at A = 0.8).
- **Case 2 (33–42):** confirmed: reconstructed data unique; centroid; S from 1.149 to 0.00262346 at 1.44232, B = 0.0709788 (Mathews' gr_110, 114, 115); E = 0.0469525; through (1, c); above the window for slopes > 1.821.
- **Case 3 (43–61):** confirmed: undamped Gauss–Newton; E₀ 4.52766 and 9.02945; exponential E falls every step to 1.07912 with a_k alternating and ratio ≈ −0.05 from step 3; power E rises to 11.0572 at step 1 then falls to 1.50774, a_k from above with ratio ≈ 0.09; linear convergence at a nonzero-residual minimum; six-digit agreement from step 5; Hessian ratios ≈ 1500 and 280; final residuals.
- **Least-squares line, Examples 1–3, "Linearization is not least squares" (62 onward):** confirmed (every table entry and sum; data recovery callout; direct fits and E; one sign change of the reduced equation; positive definite Hessians; grid search; factors 1.23, 4.82, 4.20, 5.99; reweighting callout).

## Implementation checks

- **curvefitaa.jl:** closed-form linearization; A*, B*, c*, S*, E* and sweep values identical to 50-digit values; frames 1, 17, 28 checked; clamping only for drawing.
- **curvefitbb.jl:** same with X = ln x; values identical; asserts match Mathews' printed B, a, c; frames 1, 17, 28 checked.
- **curvefitcc.jl:** plain Gauss–Newton with correct Jacobians and full steps; agrees with the 60-digit run to about 10 digits at every k; converged points equal independent roots of (7); frames 1, 2, 12 checked.
