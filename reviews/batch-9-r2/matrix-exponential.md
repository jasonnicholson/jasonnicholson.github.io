# Review: Matrix Exponential (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page for this round: the reviewer worked on a scratch copy with two planted errors in the Case 2 Behavior paragraph (the final radius 0.06039 changed to 0.06309, and "the points turn counterclockwise" changed to "clockwise") and reported both as Errors from its own computations (2e^{−3.5} = 0.0603948; the solution from (2, 0) is at (0.6554, 1.0208) at t = 0.5, confirmed in frame 11). It found nothing else on the page, so that review stands as the Matrix Exponential round-2 review, with the planted findings removed.

This was a fresh, independent review: the reviewer read no earlier review or fix record. Legacy archive consulted (MatrixExponentialMod.html, Links lnk_1–lnk_10, the surviving images for Examples 1(b) and 3–6); no animation for this module in `a2001/Animations`. Independent computations: mpmath at 50–60 digits for Example 1 and Case 1, sympy for Examples 2–6 and the Example 6 extrema, SciPy `expm` and `solve_ivp` for Cases 3–4 and the verification figures.

## Findings

None. (Tool-dependent verification residuals quoted on the page, such as "below 10⁻¹⁵" against a numerical `expm`, are could-not-determine for the exact figure; the reviewer's own values are at the same rounding level.)

## Inventory (Phase 1)

4 scripts, 4 GIFs (23, 79, 89, 109 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 124 entries; reviewer's verdicts)

- **Description (1–5), Animations introduction (6–13):** confirmed (process claim 5 CND; all matrices independently confirmed).
- **Case 1 (14–29):** confirmed, including the round-1 wording now in place: every term after the first, I, has positive entries, so each partial sum lies below the exact entry for t > 0; errors at t = 1 fall from 10.40 to 8.350e−10; 1.045e−3 at t = 2.
- **Case 2 (30–40):** confirmed apart from the two planted sentences (e^{−t}R(2t); 7 rad ≈ 1.114 turns; alt text 0.06039 and counterclockwise).
- **Case 3 (41–55), Case 4 (56–65):** confirmed (distance 1.414 → 0.02590; ellipse of period π; angle 81.95° → 0.6895°, rising twice before t = 0.75; distance 12.25 → 0.1898 decreasing every frame).
- **Theory (66–73):** confirmed, including the round-1 wording now in place: the term bound (‖A‖|t|)ⁿ/n! in an operator norm.
- **Examples 1–6 (74–124):** confirmed (powers, eigenpairs, S₅ and S₁₀ coefficients against gr_131/133, e^A, both tables, Examples 2–5 closed forms against Mathews, extents, Example 6's defective statement matrix and its solution's turning points); tool-dependent residuals CND.

## Implementation checks

- **matexpaa.jl:** truncated Taylor series with exact powers in 512-bit; titles match mpmath; frames 1 and 20 checked.
- **matexpbb.jl:** closed form asserted against `exp(A t)`; final title 0.06039; counterclockwise in frame 11.
- **matexpcc.jl:** boxed e^{At} asserted; edge-on projection correct; frames 1, 21, 81 checked.
- **matexpdd.jl:** boxed e^{At} asserted; angle and distance match SciPy at every frame; frames 16 and 101 checked.
