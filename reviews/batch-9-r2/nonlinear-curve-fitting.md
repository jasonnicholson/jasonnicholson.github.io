# Review: Nonlinear Curve Fitting (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: the module HTML, the three solution pages and the surviving images (gr_19, 28, 30, 33, 34, 110–116, 124). Independent computations: 50-digit mpmath linearized and direct fits, Hessian eigenvalues, sign-change scans, a 60-digit Gauss–Newton with normal equations, a 2001×2001 grid search, and a brute-force search confirming the Example 2 data reconstruction is unique.

## Findings

### F1 — Implementation (picture) — Minor (unverified): the power panel's title lists contour levels the plot cannot show

- **Location:** `curvefitcc.jl` line 153, title string `"E(a, c) for $(m.form):  contours 1.1, 1.25, 1.5, 2, 3, 5, 10, …, 500"`, used for both models, so it appears on the middle-right panel of every frame of `curvefitcc.gif`.
- **True instead:** the minimum of E for the power model is 1.50774224, so the levels 1.1, 1.25 and 1.5 are never drawn there; the innermost ellipse in that panel is E = 2. (The exponential panel is fine: its minimum is 1.0791.)
- **Evidence:** `direct.py`: Ex3p E* = 1.50774224043; frame `committed/curvefitcc/frame_012.png`, right panel.
- **Fix:** list only the levels that exist for each model (e.g. "2, 3, 5, 10, …, 500" for the power model), via a per-model label or per-model level sets; regenerate the GIF.

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (28, 28, 12 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 86 entries; reviewer's verdicts)

- **Description (1–7), Animations introduction (8–18):** confirmed, including the round-1 wording now in place: Case 3 shows the two fits where linearization costs the most in absolute terms (E above the direct minimum by 3.45 and 7.52, factors 4.20 and 5.99); Mathews' solution uses the heading 3(b) for the power fit.
- **Case 1 (19–29), Case 2 (30–40):** confirmed.
- **Case 3 (41–60):** confirmed (undamped Gauss–Newton; exponential E falls every step, alternating with ratio −0.05; power E rises to 11.0572 then falls, approaching from above with ratio 0.09; six-digit agreement from step 5; steps 6.98e−10 and 8.15e−9; Hessian ratios 1500 and 280; final residuals).
- **Least-squares line, Examples 1–3 (61–77):** confirmed (every table entry; unique data reconstruction).
- **Linearization is not least squares (78–86):** confirmed (direct fits, one sign change, positive definite Hessians, grid search, factors 1.23, 4.82, 4.20, 5.99).

## Implementation checks

- **curvefitaa.jl, curvefitbb.jl:** formula (2) on the transformed data; sweep lines through the centroid; values identical to 50-digit computation; frames checked.
- **curvefitcc.jl:** plain undamped Gauss–Newton with analytic Jacobian and QR step; every iterate reproduced; reference values agree with an independent root of (7); frames 1, 2, 12 checked; the contour-level title is F1.
