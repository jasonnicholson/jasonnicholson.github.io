# Review: Lotka-Volterra Model (batch 5, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).** Calibration page (second calibration; see the README): the reviewer worked on a scratch copy with two planted errors in the Case 3 Behavior paragraph (the rabbit minimum 1190.2 written as 1109.2, and "both populations grow at first" written as "fall at first") and reported both as Errors from its own computations, without comparing the copy with the repository. The planted findings are not reported; the committed page's versions were confirmed by the same reviewer (minimum 1190.19763 at t = 3.248705; x′(0) = 5000 > 0, y′(0) = 20 > 0, both rising in frame 5).

Legacy archive consulted: the module HTML, solution pages lnk_2–lnk_7, surviving program, output and graph images for Examples 2–5 (Example 1's and 6's images are lost). Independent computations: NumPy RK4, SciPy DOP853 at rtol 1e-13, mpmath `odefun` at 30 digits with `findroot` and `lambertw`.

## Findings

### F1 — Page match — Minor (unverified): "more than 10⁴ times smaller" is not true of every error in the table

- **Location:** `index.qmd` line 304: "The Runge-Kutta errors above are more than $10^4$ times smaller than that gap."
- **True instead:** against the gap 0.003615 the table's errors give ratios of about 1.98e4 (run a, 1.8e-7), 2.26e4 (run b, 1.6e-7) and only 4.8e3 (run c, 7.6e-7). Run (a)'s largest error along the run, 4.9e-7, also gives only about 7.4e3.
- **Evidence:** `c1.py`: end errors 1.83e-7, 1.60e-7, 7.58e-7; largest along run (a) 4.87e-7; gap 0.003615388.
- **Fix:** "The end-point errors of runs (a) and (b) are about $2 \times 10^4$ times smaller than that gap."

### F2 — Page match — Minor (unverified): the distance from the orbit is called "its error"

- **Location:** line 30 ("so the run's distance from it is its error") and line 477, Numerical Notes (the change of V "measures the accuracy of a run").
- **True instead:** the distance from the level curve is only the part of the error across the orbit; the timing (phase) error along it is invisible. Run (a) at t = 3.3: full error 2.1e-7, distance from the orbit (|ΔV|/|∇V|) 4.9e-8. The distance is a lower bound on the error.
- **Fix:** line 30 "so the run's distance from it shows the part of its error across the orbit"; line 477 "detects drift off the orbit (though not timing error along it)".

No Fidelity findings: every archive case is animated or listed with a reason; functions, intervals, step counts, colours and zoom window match the archive.

## Inventory (Phase 1)

3 scripts, 3 GIFs (74, 68, 130 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 132 entries; reviewer's verdicts)

- **Description (1–8):** confirmed (equations, RK4 vector form, closed orbits, conserved V, predators peak after prey: k = 1 orbit 0 then 1.146; Example 6 0.9656 then 1.859).
- **Animations introduction (9–18):** confirmed except 12 (F2): exact orbit by bisection on rays, ranges [1190.20, 9498.08] × [97.896, 356.230]; holds; no Mathews animation; Mathews' windows, colours, n = 50 and zoom window (gr_150/157/168/187).
- **Case 1 (19–33):** confirmed: (a) counterclockwise over the top, (b) clockwise; max ΔV 2.3e-7; t = 1.146, 2.764, −1.617; ends (0.438644, 0.731545), (0.439650, 0.728073) = Mathews' printout; 0.003615 apart; ends on either side of the point at ±T/2 = ±3.304; 6.6 < T = 6.608.
- **Case 2 (34–45):** confirmed: smaller orbit, shorter period (6.608 → 6.302); inner points ahead (0.524 vs 0.499 of a period at t = 3.3); outer run 0.0085 short; max ΔV 3.7e-6.
- **Case 3 (46–59):** confirmed (both planted sentences excluded): 9498.1 at 0.9656; 356.2 at 1.859; lag 0.8938; growing again by t = 5; fox minimum 97.90 at 5.047; end (3813.6, 97.982); T = 5.267; max ΔV 3.5e-7.
- **Theory (60–70):** confirmed (equilibria, Jacobian, saddle at the origin, ±i√(k₁k₃), conserved quantity, convexity, counterclockwise motion, averages, period exceeds 2π/√(k₁k₃) for larger orbits, derivation).
- **RK and Example 1 (71–80):** confirmed (Mathews' slope names CND, images lost): m = 50 from lost image sizes; every table value; error ratios 17.60, 16.80, 16.40.
- **Example 2 (81–103):** confirmed except 91 (F1): step 1 to mpmath; end points and 30-digit references; Mathews' m = 200 run; T = 6.6084826712; extremes; aside table.
- **Examples 3–5 (104–113):** confirmed (separation, ImplicitPlot deviations 1.4e-9, Lambert W branches and table).
- **Example 6 (114–129):** confirmed except 127 (the reference run's 2.2e-12 drift: CND, own DOP853 1.25e-11 with the 30-digit values agreeing): half-unit table, m = 50/100 errors and ratios 14.8, 19.3, events table, lags 0.894 and 1.798, averages 4000 and 200.
- **Numerical Notes (130–132):** confirmed except 130 (F2): drift −1.9e-8, −2.1e-7, −2.1e-6 over about 1, 10, 100 periods.

## Implementation checks

- **Shared `rk4`:** classical RK4 in vector form, weights 1-2-2-1; matches (6)/(7).
- **lotkaaa.jl:** ends and gap identical to the independent RK4; T by bisection 6.6084826712 (mpmath 6.60848267124); half-way point matches; frames 1, 26, 51, 74 checked.
- **lotkabb.jl:** five runs match every printed digit; periods match mpmath to 8 digits; frames 26, 68 checked (dotted line bends, diamonds at (Tᵢ, x₀ᵢ)).
- **lotkacc.jl:** end (3813.5739, 97.982440) and max |ΔV| 3.516e-7 match; extremes and period match mpmath; frames 5, 130 checked; axes contain the orbit.
