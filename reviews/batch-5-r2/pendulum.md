# Review: Pendulum (batch 5, round 2)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page for this round: the reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (the first swing 1.9766 changed to 1.9466, and "half-swings that shorten from 2.681 to 2.305" changed to "lengthen from 2.305 to 2.681") and reported both as Errors from its own computations (first maximum 1.976621 at t = 0.9963; half-swings 2.6810, 2.5449, …, 2.3046 in time order, matching frame 125). It found nothing else on the page, so that review stands as the Pendulum round-2 review, with the planted findings removed.

This was a fresh, independent review: the reviewer read no earlier review or fix record. Legacy archive consulted (PendulumMod.html, Links lnk_1–lnk_8, images including gr_20/95, 21, 40–56, 60, 76–78, 141, 186–233); no pendulum animation in `a2001/Animations`. Independent computations: own RK4, SciPy DOP853 at rtol 1e-13, mpmath `ellipk`, scaling and reflection checks.

## Findings

None.

## Inventory (Phase 1)

3 scripts, 3 GIFs (125, 166, 319 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 120 entries; reviewer's verdicts)

- **Description (1–7), Animations introduction (8–16):** confirmed, including the round-1 wording now in place (m = 100, with Example 7's value used for Examples 5 and 6, whose inputs are lost); the reference-integrator process claim CND (values reproduced).
- **Case 1 (17–33):** confirmed apart from the two planted sentences.
- **Case 2 (34–44):** confirmed, including the closure bound 1.8e−5 (max 1.745e−5).
- **Case 3 (45–55):** confirmed.
- **Theory (56–63), RK section (64–65), Examples 1–7 (66–120):** confirmed, including the round-1 wording now in place (Example 5's 2π shift to rounding error about 1e−14; Example 6's loops close within 1.8e−5).

## Implementation checks

- **pendulumaa.jl:** classical RK4 (Runge2D); ranges, x(20), E(20) identical; zeros match DOP853; final title lists the half-swings in decreasing order; 125 frames.
- **pendulumbb.jl:** AGM periods identical to mpmath; closures, drifts, rotations, shift identical; 166 frames.
- **pendulumcc.jl:** all 14 endpoints, energies, extrema and top counts identical; trap times match DOP853; 319 frames.
