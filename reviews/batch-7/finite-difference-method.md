# Review: Finite-Difference Method for the Wave Equation (batch 7, round 1)

**Findings: 1 Error (independently confirmed), 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: `FiniteDifferencePDEMod.html`, Links lnk_1–lnk_4, equation and plot images (gr_20, 21, 25–31, 40, 41, 50, 53–55, 58–60, 62, 77, 78, 80, 81), `FiniteDifferencePDEProof.pdf` (as text), the `a2001/Animations` listing. Independent computations: Python (numpy, sympy, exact fractions) for all three examples, the d'Alembert solution, modal (DST) analysis and the stability roots.

## Findings

### F1 — Page match (method description) — Error (confirmed by an independent checker): the d'Alembert boundary-condition statement is false

- **Location:** `index.qmd` line 193: "The boundary conditions $u(0, t) = u(a, t) = 0$ hold when $F$ and $G$ are odd and have period $2a$: $F(-z) = -F(z)$, $F(z + 2a) = F(z)$, and likewise for $G$."
- **True instead:** with F and G odd, u(0, t) = F(ct) + G(−ct) = F(ct) − G(ct), which vanishes for all t only if G = F. The general conditions are G(z) = −F(−z) (from u(0, t) = 0) and F 2a-periodic (from u(a, t) = 0). For odd F, G this means F = G, as in (11), where F = G = f̃/2. Mathews' proof PDF (p. 550) has the same loose proviso.
- **Evidence:** F(z) = sin(πz/a), G = 0 are both odd and 2a-periodic, yet u(0, t) = sin(πct/a) ≠ 0 (reviewer: u(0, 0.25) = 1.0 at c = 2, a = 1). The checker's sympy check adds F = sin(πz/a), G = sin(2πz/a): u(0, ¼) = −0.2929 at a = c = 1; control F = G gives u(0, t) = u(a, t) = 0.
- **Fix:** "The boundary conditions hold when $G(z) = -F(-z)$ and $F$ has period $2a$; in particular they hold when $G = F$ with $F$ odd and of period $2a$, as in (11) below."

### F2 — Page match — Minor (unverified): F and G are swapped in the proof relative to (10)

- **Location:** line 216: "so by (10) every exact grid value has the form $u_{i,j} = F((i - j)h) + G((i + j - 2)h)$".
- **True instead:** (10) is F(x + ct) + G(x − ct), and x_i + ct_j = (i + j − 2)h, so by (10) u_{i,j} = F((i+j−2)h) + G((i−j)h). The algebra on lines 220–223 is correct for the swapped labelling, so the conclusion stands. Mathews' (18) has the same swap.
- **Fix:** write $u_{i,j} = F((i+j-2)h) + G((i-j)h)$ and swap the F and G lines of the display, or write "has the form $\Phi((i-j)h) + \Psi((i+j-2)h)$ for some functions $\Phi, \Psi$".

### F3 — Page match — Minor (unverified): "Implicit methods … have no stability restriction on r" is too general

- **Location:** line 177.
- **True instead:** it holds for the usual implicit schemes (e.g. the weighted θ-scheme with θ ≥ ¼) but not for every implicit scheme (θ in (0, ¼) is implicit and only conditionally stable). Mathews (proof PDF p. 549) says the same. Qualitative check (standard von Neumann result), not computed.
- **Fix:** "Suitable implicit methods, which are more work to implement, have no stability restriction on r."

### F4 — Page match (alt text) — Minor (unverified): "|c₉| alternating in sign"

- **Location:** line 52 (Case 3 alt text): "...shows |c₉| alternating in sign and growing from 0.01219 to 0.7997...".
- **True instead:** an absolute value cannot change sign; c₉ alternates (−0.01219, +0.01255, −0.01366, …), shown in the plot as |c₉| with open and filled markers.
- **Fix:** "...shows |c₉|, with c₉ alternating in sign (open and filled markers), growing from 0.01219 to 0.7997...".

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (26 frames each: 21 rows plus 5 held); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 131 entries; reviewer's verdicts)

- **Description (1–9):** confirmed (scheme (6), Taylor second row, explicit, stable for r ≤ 1, growth at r = 1.02 with |λ| = 1.276154 for p = 9, exactness at r = 1).
- **Animations introduction (10–16):** confirmed (titles agree with the tables; no PDE animation in the archive).
- **Case 1 (17–28):** confirmed: run (8) within 1.5e-15; run (7) off by 0.2212 in row 2, reaching 0.3976 at t = 0.15, 0.35, 0.65, 0.85 without damping; back to rounding level (8.9e-16, 7.8e-16) at t = 0.5 and 1, with the stated reason checked on random second rows.
- **Case 2 (29–38):** confirmed: corners move apart one h per k; reflections at x = 1 (t = 0.2) and x = 0 (t = 0.3); string at or below the axis for t ∈ [0.3, 0.7]; lowest −0.6 at x = 0.4, t = 0.5; reversal to f at t = 1 exactly; error ≤ 4.5e-16.
- **Case 3 (39–57):** confirmed except the alt-text wording (F4): first-step error 0.00255; sin(9πxᵢ) = (−1)ⁱ sin(πxᵢ); r²s₉ = 1.0149; c₉ alternates and grows at every step, ratio → 1.2762 (1.2761 at the last step), ×66 to 0.7997; error grows at every step, within 3 % of |c₉| from row 13; beyond 0.6 from row 18; max |u| = 1.312 at t = 1.02 inside the axis.
- **Derivation, starting values, stability (58–78):** confirmed except 77 (F3): (3)–(8); (9) and its roots; CFL domain of dependence; coarse-grid threshold 1.0125, only p = 9 unstable at 1.02.
- **d'Alembert and the theorem (79–86):** 80 wrong (F1); 85's labelling (F2); the rest confirmed ((10) by substitution; (11) matches Example 2 exactly at 231 points; (8) reduces to (13) and is exact).
- **Algorithm (87–89):** confirmed (Mathews' FDgrid/FDsolve, ListPlot3D settings).
- **Example 1 (90–106):** confirmed (every table entry; worked steps; Mathews' three slips — cos(πt) residual, h = 0.2/k = 0.04 remark, ±0.951056 rounding; r = 0.5 refinement ratios 3.857, 3.996, 4.002).
- **Example 2 (107–117):** confirmed (exact rationals for every entry; multiples of 0.025; slope −0.25; u(x, 0.5) = −f(1 − x)).
- **Example 3 (118–131):** confirmed (disclosed reconstruction k = 0.051; roots −1.2762, −0.7836; DST coefficient; tables; more than twice the largest true displacement).

## Implementation checks

- **fdpdeaa.jl:** scheme (6) with (8) or (7) for the second row; Mathews' FDgrid/FDsolve; errors match Python to all printed digits (1.499e-15; 0.397557); (14) checked symbolically; log panel excludes the zero row-1 error.
- **fdpdebb.jl:** U matches exact rationals; reference is the odd period-2 extension in (11); corners match; frames 1, 11, 21 checked.
- **fdpdecc.jl:** all 21 rows of max |u|, error, c₉ and ratio match an independent DST projection; λ = −1.276154; fixed ±1.45 axis contains every row (no clamping); frames 2 and 21 checked.
