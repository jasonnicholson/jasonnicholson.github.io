# Review: Painlevé Property (batch 9, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: the module HTML, the Solution pages for Examples 1–3 and 5–12 and their images (the reviewer could not list `a2001/Animations` in this host; the director's Phase 2 check found no Painlevé animation there). Independent computations: an own Python RK4 pole-vaulting method and plain RK4 for all six runs (Examples 7–12), exact poles from mpmath Airy functions and from `mp.odefun` Taylor solutions, sympy series and residuals, Mathews' Bessel-function forms against the exact solutions.

## Findings

### F1 — Page match (Description) — Minor (unverified): the jump direction is stated as if it held for every simple pole

- **Location:** `index.qmd` line 20: "At a simple pole, the kind met in all of Mathews' runs, $Y$ crosses zero, $y = 1/Y$ jumps from $+\infty$ to $-\infty$…"
- **True instead:** +∞ → −∞ holds at every pole in Mathews' six runs (Y goes from positive to negative across each: e.g. Ex7 9.36e−11 → −0.004; Ex8 7.96e−4 → −4.20e−3 and 2.39e−3 → −2.61e−3; Ex11 3.06e−3 → −5.69e−3 and 8.49e−3 → −2.57e−4), but not at simple poles in general: y′ = −y², y(0) = −1 gives y = 1/(x − 1), which goes from −∞ to +∞.
- **Fix:** "At each pole in Mathews' runs (all of them simple), $Y$ crosses zero from positive to negative, and $y = 1/Y$ jumps from $+\infty$ to $-\infty$…"

### F2 — Page match — Minor (unverified): "a negative multiple" followed by positive multiples

- **Location:** line 328: "near it $y$ behaves like a negative multiple of $1/(x - c)$ (the multiple is $1$ in Examples 7, 8, 11 and 12, $\tfrac12$ in Example 9 and $e$ in Example 10)".
- **True instead:** y ≈ −k/(x − c) with k = 1, ½, e (Ex7 y = −1/(x − 1); Ex9 1/(1 − x²) ≈ −(½)/(x − 1); Ex10 1/(1 − ln x) ≈ −e/(x − e); Ex8, 11, 12 −1/(x − c)); the multiple itself is −1, −½, −e.
- **Fix:** "near it $y \approx -k/(x - c)$ with $k = 1$ in Examples 7, 8, 11 and 12, $k = \tfrac12$ in Example 9 and $k = e$ in Example 10".

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (92, 112, 120 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 131 entries; reviewer's verdicts)

- **Description (1–11):** confirmed except 8 (F1): pole of y′ = y² movable; switch at |y| = 3 (Mathews' `big = 3`); companion equation; the "two independent implementations" process claim CND (own Python run agrees with every number).
- **Animations introduction (12–27):** confirmed (Mathews' step sizes and window; colours; bands; arrowheads with true values; frame schedule and totals; broken curves at sign changes; module links no animation).
- **Case 1, Example 7 (28–40):** confirmed: switch at 0.668 (3.012); Y = 1 − x; pole at a grid point (Y = 9.358e−11, y = 1.069e10); −0.004 / −250.0 one step later; zero 1.0000000001; switch back at 1.336; y(2) = −1.000; plain RK4 2050, 2.525e13, 1.194e174, overflow at 1.012, all positive.
- **Case 2, Example 8 (41–53):** confirmed: switches 1.25, 1.895, 4.395; zeros 1.5707963231 and 4.7123889802; ends at −3.381 in a Y phase; plain RK4 868.7, 3.234e9, 1.781e113, overflow at 1.585.
- **Case 3, Example 11 (54–63):** confirmed: Airy form, poles 0.9306 and 3.1235; switches; zeros 0.9305644959 and 3.1234930240 vs exact 0.9305645085 and 3.1234930040; y crosses zero near u′ = 0 at 2.113; y(3.5) = −2.215; plain RK4 294.2 (true 326.3), 3.046e6 past the pole (true −175.9).
- **Singularities, Examples 1–6 (64–80):** confirmed (classification table; sin x/x series to x¹⁴ vs gr_31; tan/sec/csc series; Mathews' graph ranges; Examples 4–6 solutions, companions and Taylor series vs gr_126).
- **Companion equation and extended RK (81–89):** confirmed except 89's wording (F2): every Y phase starts with |Y| just under 1/3 and ends at ≥ 1/3; Y changes sign in every phase.
- **Examples 7–12 text (90–131):** confirmed (every phase and pole table; errors; plain RK4 comparisons; Example 10's larger interpolation error explained by curvature and h; backward run; Mathews' Bessel forms agree to 15+ digits; Example 12 poles and largest |y| = 5281.4 just past the first pole).

## Implementation checks

- **painleveaa.jl / painlevebb.jl / painlevecc.jl:** the same code with different parameter blocks (diffed); Mathews' PoleVaultRungeKutta step for step (gr_202); every switch, zero, final value and overflow point agrees with the independent Python run to every printed digit; halving h gives error ratios 17.0, 16.2, 16.3 (fourth order); references verified (tan/cot; Airy constants reproduce u(0) = 1, u′(0) = −1; poles to 1e−11); frames checked (arrowheads with true values, broken curves, × labels).
