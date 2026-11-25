# Review: Logistic Curve (batch 6, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `LogisticEquationMod.html`, Links lnk_1–lnk_4, the surviving images gr_79 and gr_82, `LogisticEquationProof.html`, a recursive search of `a2001/Animations`. Independent computations (mpmath at 60 digits unless noted): linearization by a centred least-squares formula, golden-section minimum of E(L), Newton on ∇E from a different start, the Hessian and the L = 800 profile fit, Gauss–Newton solved by QR (not the script's normal equations), the starting-value caution on a fine grid, and a SciPy DOP853 check of the ODE claims.

## Findings

### F1 — Page match (alt text) — Minor (unverified): not every solution below 800 is S-shaped in the window

- **Location:** `index.qmd` line 62, alt text of `logisticcc.gif`: "solutions below 800 rise in S-shaped curves, those starting below 400 marked with diamonds…".
- **True instead:** the solutions from y₀ = 400 and y₀ = 600 are concave down throughout 1900–2300: the 400 solution starts at its own inflection point, and the 600 solution's inflection (1831.76) is before the window. The Behavior paragraph (line 58) states both facts correctly.
- **Evidence:** `indep5.py`: t* = 1900.000 (y₀ = 400) and 1831.758 (y₀ = 600); final frame `committed/logisticcc/frame_057.png` shows both curves concave down only.
- **Fix:** "solutions starting below 400 rise in S-shaped curves, those from 400 and 600 rise concave down, …", or "solutions below 800 rise toward it".

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (71, 64, 57 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 106 entries; reviewer's verdicts)

- **Description (1–5), Animations introduction (6–12):** confirmed (Gauss–Newton breakdown from L ≥ 1100 on a fine grid; convergence up to 1090).
- **Case 1 (13–30):** confirmed, including the round-1 wording now in place: |r| = 0.988 at L = 300, at least 0.9978 from L = 500 (minimum 0.997866), r negative since the line falls; E falls to 102.13 at L = 660 then rises to 129.9; finer grid 655.3/102.126; f(2000) increases with L and crosses 282.1246 near 820.0 (E = 108.2).
- **Case 2 (31–47):** confirmed (overshoot to 596.9 and 206.85; back to 650.84/102.72; linear rates 0.039–0.042 and 0.0017; 8.300e−28 and 1.550e−12).
- **Case 3 (48–59):** confirmed except the alt-text clause in 58 (F1).
- **Theory (60–67), linearization and Examples 1–4 (68–90):** confirmed (every table cell; DOP853 agreement 3.6e−10, within the stated 5e−10).
- **Example 5 (91–106):** confirmed, including the round-1 wording now in place: the small-eigenvalue eigenvector moves L and c together (ΔL = 10 along it gives E = 102.094; L alone gives 165.9); the L = 800 profile 106.50. The "50-digit arithmetic" process claim CND (values agree with 60-digit and 256-bit runs).

## Implementation checks

- **logisticaa.jl:** normal-equation closed form; values match the centred formula; reference E_min and f₂(2000) match Newton; frames 1, 22, 30, 71 checked; nothing clipped that matters.
- **logisticbb.jl:** undamped Gauss–Newton with analytic J; every iterate reproduced by a QR-based run; reference confirmed; frames 1, 6, 16, 64 checked.
- **logisticcc.jl:** closed form (2) with r = −A; values match; DOP853 agrees to 4e−10; frames 1, 17, 57 checked.
