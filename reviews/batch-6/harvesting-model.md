# Review: Harvesting Model (batch 6, round 1)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page: the reviewer worked on a scratch copy with two planted errors (Case 3's t₀ for x₀ = 1, and Case 2's direction of the runs between 1 and 3) and reported both as Errors from its own computations (see the README). The planted findings are not reported; the committed page's versions were confirmed by the same reviewer (t₀ = 2π/(9√3) = 0.403066525…; the five runs between 1 and 3 are strictly increasing toward 3).

Legacy archive consulted: the module text, all 20 solution pages, program and graph images. Independent computations: own modified Euler (midpoint form) in IEEE double; exact solutions in 256-bit mpmath from an independent Riccati derivation (not the page's formulas); ordering, monotonicity and sign-change checks; extinction times as ∫dx/(−f) by mpmath quadrature; sympy residuals for every formula on the page.

## Findings

None. Not checked: the Example 1 remark that Mathematica and Maple return only the case (iii) general solution (could not determine; those archive images are missing).

## Inventory (Phase 1)

4 scripts, 4 GIFs (55, 55, 45, 95 frames); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file.

## Claim ledger (whole page; 114 entries; reviewer's verdicts)

- **Description (1–8):** confirmed (case structure; Mathews' MEuler midpoint form, gr_63/64; m = 110; parameter sets).
- **Animations introduction (9–24):** confirmed: shared clock, Mathews' intervals, windows ([0,4]×[0,6], [0,1]×[0,8], [0,0.75]×[0,6]) and colours (gr_158–166, 276–284, 326), gray band and dashed past-extinction curves, crosses and asymptote lines, log error panels, exact zeros not drawn, 256-bit exact references, Case 4 colours, band, phase line, pauses (95 frames), no Mathews animation.
- **Case 1 (25–37):** confirmed: t₀ = 1/4, 2/3, 3/2, 4; y₁₁₀ = −0.333319, −0.499876, 8.2344e−5, 7.641e−4; errors ordered by x₀ at every step; largest 2.3604e−2 at t = 0.10909; 4/5 error growing every step.
- **Case 2 (38–52):** confirmed: runs above 3 fall toward it and those between 1 and 3 rise toward it; t₀ = 0.077075, 0.18386, 0.34657, 0.64964; y₁₁₀ = −0.485740, −1.111568, −3.166983, −3.085534; t₁ values; largest 2.0865e−3 at 0.081818; ≤ 5.1816e−6 between the stationary solutions; the dip at the sign change in (0.61818, 0.62727); 7.0561e−3 at t = 1.
- **Case 3 (53–64):** confirmed: t₀ = 0.4031 for x₀ = 1 and 0.6046 … 0.7460; end values; first point below −1 at 0.60682; y₁₁₀ = −5.347969; t₁ = 0.8061 the earliest; 9.2456e−3 at 0.027273; 4.8143e−2 at 0.75, 0.056133 before the asymptote.
- **Case 4 (65–75):** confirmed (r₁,₂ = 2 ∓ √(4 − k); x₀ = 0.5 dies from k = 1.8 with t₀ = 1.1035; k = 3, 4, 4.1 statements; all die from k = 5.4; t₀ = 1.5459 at k = 6).
- **Background and theory (76–94):** confirmed, including the logistic values, formulas (5)–(7) by sympy, the theorems' t₀, t₁ formulas, Mathews' printed t₁ = 2(π/2 − c)/w (gr_56) giving 0.4031 and 0.0601 where x = 3.182, second-order ratios 4.53 and 4.26.
- **Examples 1–19 and summary (95–114):** confirmed (95's Mathematica remark could not determine), including every table and window (gr_87, 116, 158–166, 194, 208, 217, 243–245, 276–284, 301–304, 322, 326).

## Implementation checks

- **harvestaa.jl:** Mathews' MEuler midpoint loop (line 81), h = b/110; all ten runs match the independent run to every printed digit; exact solution verified (sympy residual 0); frames 1 and 55 checked.
- **harvestbb.jl:** same loop; exact solution in an equivalent form of (6); all sixteen runs match; t₀, t₁ verified by sympy; frame 55 checked (dip at the computed sign change).
- **harvestcc.jl:** same loop; (7) with w = √27; values match; frames 14 and 45 checked (x₀ = 1 cross at ≈ 0.403; below-window note correct; `ydraw` only affects drawing).
- **harvestdd.jl:** exact solutions only, all three branches satisfy the ODE; extinction times agree with the independent integral (e.g. 1.1035347, 4.4713994, 9.1892124, 1.5459306); frames 1, 25, 37, 55, 64, 95 checked.
