# Review: Spring-Mass Systems (batch 5, round 1)

**Findings: 1 Error (independently confirmed), 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `SpringMassMod.html` and the ten solution pages (Links lnk_2–lnk_11) as text; the problem-statement images and notebook images of Examples 2, 3, 5, 6, 7, 9, 10 (Examples 1, 4 and 8 are lost). Independent computations: sympy (characteristic polynomials, eigenvectors, residuals, energy, initial-condition formulas) and numpy/SciPy DOP853 integrations; pixel tracking of Mathews' Example 5 pictures.

## Findings

### F1 — Fidelity (page claim about the archive) — Error (confirmed by an independent checker): Mathews' Example 5 first-mode pictures show the masses moving in the same direction

- **Location:** `index.qmd` line 153 ("How Mathews presents each example"): "In every example whose plots survive, the first picture shows the masses moving in opposite directions at frequency ω₁, the second in the same direction at ω₂."
- **True instead:** Example 5's plots survive (`SpringMassMod_lnk_6.html`, images gr_160–gr_192 all present). Mathews plotted his incorrect first mode x = cos(√(1+√2) t), y = (7−√2)/4 · cos(√(1+√2) t), with positive ratio ≈ 1.396, so in his against-time plot (gr_177/gr_178) and space-time picture (gr_186/gr_187) the masses peak and cross zero together: they move in the **same** direction, although his text says opposite. The page's own callout (line 415) gives his first mode as y ≈ 1.396447x.
- **Evidence:** reviewer: pixel tracking in gr_187 (red and blue right-hand extremes on the same rows 68, 100, 136, …); checker: the images viewed, `check/ex5.py` (his plotted functions over [0, 10π] have x·y < 0 at 0 % of points, correlation +1.0, 7.77 cycles; his mode has residual −9√2/4 ≈ −3.18 in the second equation; the true first mode has ρ = 1 − √2 ≈ −0.414).
- **Fix:** "In every example whose plots survive except Example 5, the first picture shows the masses moving in opposite directions at frequency ω₁, the second in the same direction at ω₂. In Example 5 Mathews' incorrect first mode (ω₁ = √(1+√2), y = (7−√2)/4·x ≈ 1.396x) makes both of his pictures show the masses moving in the same direction, although his text says opposite (see the warning under Example 5)." In the Example 5 "Mathews' plots" paragraph (line 418), add that his first-mode plots use the ratio 1.396 and frequency ≈ 1.554 and so show same-direction motion; optionally note in Case 2 that the animated first mode differs from his picture in direction as well as frequency.

### F2 — Fidelity — Minor (unverified): Mathews' printed eigenfrequencies are correct

- **Location:** line 415 (Example 5 callout): "Mathews' roots and eigenvalues are correct, but his frequency list, general solution and first mode use ω₁ = √(1+√2)…".
- **True instead:** his printed "Eigen frequencies = {2√(1+√2), √(2(2−√2))}" line is also correct; only the assigned ω₁ = √(1+√2), and what is built on it, is wrong.
- **Fix:** "Mathews' roots, eigenvalues and printed eigenfrequencies are correct, but the ω₁ he assigns and uses in the general solution and first mode is √(1+√2)…".

## Inventory (Phase 1)

2 scripts, 2 GIFs (139 and 179 frames); all run; every GIF byte-identical to what its script produces; every reference resolves. (`springbb.gif` is 3.12 MB.)

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6):** confirmed (matrix A for one and two walls; elimination to a quartic; −ω_j² eigenvalues in all ten examples; (4)/(5) with residual 0; faster mode opposite, slower same, in general via ρ₁ρ₂ = −m₁/m₂).
- **Animations introduction (A1–A11):** confirmed (layout; exact solution; DOP853 agreement within 1e-11, conditional on atol; colours from Mathews' PlotStyle; walls outside all motions; modes from rest; combination inside its parallelogram; no Mathews animation; lost plots).
- **Case 1, Example 6 (C1.1–C1.10):** confirmed: ω₁ = 3, ρ₁ = −1, 7.5 oscillations; ω₂ = 1, ρ₂ = 1, 2.5 oscillations; start (2, 0, 4, −2), E = 20; period 2π (2.4e-14); range ±2.656893; square parallelogram.
- **Case 2, Example 5 (C2.1–C2.11):** confirmed: ω₁ = 3.108, ρ₁ = −0.4142; 15.54 oscillations, twice 7.77; ω₂ = 1.082, ρ₂ = 1.707; start (2, 1.293), E = 18; ratio √(4+3√2) ≈ 2.871, irrational, dense; ranges.
- **Body sections (B1–B47):** confirmed except B12 (F1) and the omission in B25 (F2): elimination, theorem, energy, initial-condition formulas, all ten examples' quantities and tables, Mathews' plot windows and line positions, the caption callout, periodicity table.
- **Direction and comparison words:** each checked separately; all confirmed except line 153 (F1).

## Implementation checks

- **springaa.jl:** closed-form solution (4) with ω from the quadratic in r²; values identical to sympy; residual at FD truncation level; DOP853 agreement 3.7e-12; frames 61 and 121 checked; blocks never overlap.
- **springbb.jl:** same with k₃ = 0 and the corrected ω₁; values identical; extrema match the continuous ones to 3 decimals; frames 1, 81, 161 checked.
