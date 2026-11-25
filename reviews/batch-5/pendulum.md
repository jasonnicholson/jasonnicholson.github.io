# Review: Pendulum (batch 5, round 1)

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: `PendulumMod.html` and Links lnk_1–lnk_8 as text; Mathematica input and figure images (gr_14 … gr_233 as listed by the reviewer); `a2001/Animations` has no pendulum animation. Independent computations: numpy RK4, SciPy DOP853 (rtol 1e-13) cross-checked with Radau, mpmath elliptic integrals, a Julia replica of the scripts' `rk4`/`ellK`.

## Findings

### F1 — Page match — Minor (unverified): the closure error of the widest loop is quoted two ways

- **Location:** Case 2 Behavior: "Each loop closes on itself to within $1.8 \times 10^{-5}$."; Example 6, after the Step 2 table: "The loops are run for one period and close to within $1.7 \times 10^{-5}$."
- **True instead:** the largest closure error (k = 0.95) is 1.7453e-5 (script log `closure=1.75e-05`; own numpy 1.745e-05; Julia replica 1.7453e-05). "To within 1.7e-5" is slightly below it; 1.8e-5 is a valid bound. (Example 5's table entry 1.7 × 10⁻⁵ is a rounded value, which is fine.)
- **Fix:** "to within $1.8 \times 10^{-5}$" in Example 6 as well (or $1.75 \times 10^{-5}$ in both places).

### F2 — Page match — Minor (unverified): the 2π-shift agreement "to within 4 × 10⁻¹⁵" is not reproducible

- **Location:** Example 5, Step 4: "with the start shifted by $2\pi$ the Runge-Kutta points shift by $2\pi$, to within $4 \times 10^{-15}$."
- **True instead:** the scripts' own `rk4` on Example 5 (ω₀² = 1) gives a maximum deviation of 5.33e-15 (numpy 1.24e-14); for Example 6 it is 2.9e-15. The figure is evaluation-order rounding noise.
- **Fix:** "to rounding error (about $10^{-14}$)".

### F3 — Page match / Fidelity — Minor (unverified): Mathews' step counts for Examples 5 and 6 are lost

- **Location:** Description, paragraph 2: "the Runge-Kutta runs with Mathews' own step counts, …"; Animations introduction: "Every curve is computed with $m = 100$ steps, as in Mathews' examples."
- **True instead:** Mathews' inputs for Examples 5 and 6 are lost (images gr_99–140 and gr_144–185 missing); m = 100 is confirmed only for Examples 1, 3 and 7. The page itself says correctly in Example 5 that m = 100 follows his Example 7.
- **Fix:** "with Mathews' step counts ($m = 100$; for Examples 5 and 6, whose inputs are lost, the $m = 100$ of his Example 7)".

## Inventory (Phase 1)

3 scripts, 3 GIFs (125, 166, 319 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D8):** confirmed except D7 (F3); the 8th-order reference process claim CND (own DOP853 reproduces every reference number; the scripts' labels use RK4 with h = 0.001 plus bisection, as their headers say).
- **Animations introduction (A1–A9):** confirmed except "as in Mathews'" in A3 (F3).
- **Case 1 (C1.1–C1.16):** confirmed: nonlinear swings wider at first and returns later (1.9766 at 0.9963 vs 1.7036 at 0.6593); first four extremes wider, from the fifth narrower; 9 and 8 zeros; half-swings shorten 2.681 → 2.305; x₁₀₀ = −0.3629 and 0.3838; energy falls 2.919 → 0.4484, below 4.
- **Case 2 (C2.1–C2.13):** confirmed except C2.6 (F1): speeds; amplitudes 28.96°–143.6°; periods 4.515–7.326, all longer than 4.443 (factor 1.649); rotations and mirror image (3.4e-14); 2T_rot; top speeds 2.121, 3.162; shifted loops to 7e-14; Mathews' colours.
- **Case 3 (C3.1–C3.12):** confirmed: Mathews' 14 curves with his starts, intervals, windows and colours; every curve inside its window; tops crossed 2 and 3; energy below 4 at 6.554 and 7.471; mirror pendulums 7′, 8′ (1.7e-13).
- **Theory (T1–T12):** confirmed (period 4K(k)/ω₀; 1.6 %, 7.3 %, 65 % longer; energy and dE/dt = −cy²; equilibria, separatrix; linearisation; Runge2D; factor 16).
- **Examples 1–7 (E1.1–E7.15):** confirmed except E5.9 (F2) and E6.6 (F1): first RK step; error tables; factor 17.4 for m = 200; Example 2 analytic form and extrema; Example 4 comparison table; Example 5–6 tables and separatrix decay; Example 7 table, turns, end points, rest positions, differences from the reference.

## Implementation checks

- **pendulumaa.jl:** classical RK4 (Mathews' Runge2D); x(20), ranges, energies identical to own RK4; linear zeros from the closed form, nonlinear zeros from fine RK4 plus bisection matching DOP853; frames 1, 6, 125 checked.
- **pendulumbb.jl:** same RK4; AGM `ellK` matches mpmath; closures, drifts, rotation ends and shifts identical; frames 50 and 166 checked; no clamping.
- **pendulumcc.jl:** same RK4; `spec` matches Mathews' inputs exactly; end points and top counts identical; trap times 6.5539, 7.4706 match DOP853; frames 100, 125, 204, 319 checked.
