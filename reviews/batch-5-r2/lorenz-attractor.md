# Review: Lorenz Attractor (batch 5, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted (module text, example equation images, solution link pages, Runge3D image gr_16, the `a2001/Animations` folder). Independent computations: an own Taylor-series integrator in 240-bit fixed-point integer arithmetic (order 32, step 0.01; cross-checked at order 24), dense evaluation for extrema and crossings, an own float RK4, SciPy 1.11.4 for the adaptive-solver claims, sympy/numpy for the algebra, a tangent-vector RK4 for Lyapunov exponents.

## Findings

### F1 — Page match — Minor (unverified): the fourth RK4 error ratio is 16.5, not 16.6

- **Location:** `index.qmd` line 158: "the error at t = 0.5 falls by the factors 21.0, 18.4, 17.2, 16.6 and 16.3 as h is halved from 0.02 to 0.000625".
- **True instead:** the Euclidean errors are 2.751e−3, 1.311e−4, 7.107e−6, 4.144e−7, 2.504e−8, 1.539e−9, giving ratios 20.990, 18.441, 17.152, **16.548**, 16.265 (a long-double rerun agrees). No other norm reproduces the page's list; 16.6 looks like double rounding (16.548 → 16.55 → 16.6).
- **Evidence:** `py/ratio.py` against the Taylor reference at t = 0.5.
- **Fix:** "21.0, 18.4, 17.2, 16.5 and 16.3".

Not a finding (could not determine): the page's "estimates from runs of length 2000 to 40000 lie between 0.069 and 0.074 and settle near 0.071" for the Rössler Lyapunov exponent. This reviewer's own estimates are 0.0644 (T = 2000), 0.0686 (T = 4000), 0.0721 (10000) and 0.0711 (40000); finite-time estimates depend on the procedure (start, transient, renormalisation), and "about 0.07, settling near 0.071" is confirmed.

## Inventory (Phase 1)

3 scripts, 3 GIFs (231 frames each); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 125 entries; reviewer's verdicts)

- **Description (1–5), Animations introduction (6–12):** confirmed (the author's exact 2.2e−14 comparison is of the same order as the reviewer's 2.1e−14/2.8e−14).
- **Case 1 (13–26), Case 2 (27–40):** confirmed.
- **Case 3 (41–52):** confirmed, including the round-1 correction now in place: Example 6's four tallest spikes run from 51.80 to 65.98.
- **The Lorenz equations (53–70):** confirmed.
- **Runge–Kutta section (71–75):** confirmed except 73 (F1).
- **Example 1 (76–84):** confirmed, including the round-1 header now in place (first crossings checked at t = 0, 0.02, …, 20); Lyapunov digits CND (0.90 confirmed).
- **Example 2 (85–91), Examples 3–4 (92–106):** confirmed (Example 4 Lyapunov digits CND; positive confirmed).
- **Rössler section (107–111):** confirmed, including the round-1 correction now in place: after-spike minima 1.8 to 5.0.
- **Example 5 (112–119):** confirmed except 117 (CND, as noted above).
- **Example 6 (120–125):** confirmed.

## Implementation checks

- **lorenzaa.jl:** classical RK4 and a correct Taylor recurrence; RK path and reference match the independent ones bitwise; frames checked; no clamping.
- **lorenzbb.jl:** two Taylor runs in BigFloat; distances match the exact fixed-point difference to 7e−16 relative; frames checked.
- **lorenzcc.jl:** RK4 and a correct Rössler Taylor recurrence; all dumped values match the independent runs exactly; axis limits contain all data.
