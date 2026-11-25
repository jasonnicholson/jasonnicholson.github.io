# Review: Painlevé Property (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 0 Minor.** (The reviewer's one finding, that the section index links the deleted flat `painleve-property.qmd`, is withdrawn: section-index links are changed in each page's "Add animations" commit.)

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `PainlevePropertyMod.html`, the Links pages and the relevant images (gr_4 … gr_301); `a2001/Animations` and `Animations/OrdinaryDE` listed (no Painlevé animation). Independent computations: an own Python pole-vaulting and plain RK4 for Examples 7–12, exact solutions from mpmath Airy functions and `odefun`, Mathews' Bessel-function forms transcribed and checked, sympy series and residuals.

## Findings

None.

## Inventory (Phase 1)

3 scripts, 3 GIFs (92, 112, 120 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D10):** confirmed, including the round-1 wording now in place: at each pole in Mathews' runs (all simple) Y crosses zero from positive to negative, so y jumps from +∞ to −∞ — checked at all nine poles of Examples 7–12.
- **Animations introduction (A1–A17):** confirmed.
- **Case 1 (K1.1–K1.13), Case 2 (K2.1–K2.12), Case 3 (K3.1–K3.10):** confirmed (every switch point, interpolated zero, final value and plain-RK4 overflow point).
- **Singularities, Examples 1–3 (S1–S15), Painlevé property, Examples 4–6 (P1–P9):** confirmed.
- **Pole-vaulting theory (T1–T10):** confirmed, including the round-1 wording now in place: y ≈ −k/(x − c) with k = 1, ½, e; RK4 order check (ratios 16.2, 16.3).
- **Examples 7–12 (E7.1–E12.8):** confirmed (every phase and pole table; errors; Example 10's interpolation error explained; backward run; Mathews' Bessel forms agree to better than 1e−30).
- **Front matter (W1–W2):** confirmed.

## Implementation checks

- **painleveaa.jl / painlevebb.jl / painlevecc.jl:** identical code with different parameter blocks; Mathews' PoleVaultRungeKutta (gr_202) step for step; every printed value reproduced by the independent Python run; references verified; frames 38 (aa), 112 (bb), 120 (cc) and the contact sheets checked.
