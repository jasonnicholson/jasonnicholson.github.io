# Review: Compartment Model (batch 6, round 1)

**Findings: 0 Error, 0 Misleading, 0 Minor.**

The reviewer reported two link findings that are not findings of this batch and are withdrawn by the director:

- *The Description's link `../matrix-exponential.qmd` does not resolve.* It resolves on this batch's branch, where Matrix Exponential is still the flat page `matrix-exponential.qmd`. Matrix Exponential is a batch 9 page; it was moved to a folder in the working tree ahead of its batch, and this link is changed to `../matrix-exponential/` in the batch 9 commit that moves it.
- *The section index links the deleted flat file.* The director changes section-index links in each page's "Add animations" commit; the review ran from the working tree before that commit.

Legacy archive consulted: the module page, the Example 1–3 solution pages and their images, and the empty proof and program placeholder pages. Independent computations: sympy matrix exponentials of all three systems, closed-form checks of every callout, recursion (4) and eigenvectors, SciPy DOP853 comparisons, direction checks on fine grids.

## Findings

None.

## Inventory (Phase 1)

3 scripts, 3 GIFs (93, 156, 113 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 115 entries; reviewer's verdicts)

- **Description (1–5):** confirmed (balance law; eigenvalue method; three examples; residuals 0 and DOP853 agreement to 2e-13).
- **Animations introduction (6–15):** confirmed: widths ∝ V and shared height, so height = concentration and area ∝ amount; a tank fills exactly while below its feeder; a maximum when heights are level (peak residuals ~1e-50); exact rational eigenvectors, 256-bit evaluation; no Mathews animation; not-animated list matches the archive.
- **Case 1 (16–27):** confirmed: x₂ max 4.096 at 4.463; x₃ max 3.248 at 9.866; one sign change of each x_i′; S flat at the start then decreasing in all 81 frames; t = 40 values 9.851, 0.1488, 0.1339 (90% in tank 3); Mathews' ranges (gr_53–86).
- **Case 2 (28–39):** confirmed: S ≡ 10; equilibrium 0.1 and (4, 2, 4); tank 2 first to equilibrium (0.6435 vs 3.785, 5.356); overshoot 0.1294 at π/2; within 0.035 at t = 5; envelopes 2√10e^{−t}, 4√5e^{−t} (max ratio 0.99999999989); crossings 2π apart; 2.21e-5 at t = 12.5.
- **Case 3 (40–47):** confirmed: maxima later and lower (4.219 at 2.877 … 2.828 at 16.48); S(5) = 9.916 vs 9.178; S′ = −(4/25)x₅; t = 50 values (99.4% in tanks 4–5); Mathews' window and colours.
- **Model I and Example 1 (48–76):** confirmed (defective-matrix callout and argument; washout theorem; eigenvectors, c = (10, 50, 180); all table values; single maxima; S formula; 1.5% at t = 40); "within 4×10⁻¹⁴" of their solver CND (own 2.0e-13).
- **Model II and Example 2 (77–101):** confirmed (characteristic polynomial, eigenvectors, c = (2, −2, −4), e^{At} symbolically, table, turning points and direction words, e^{−2π} shrink); "within 2×10⁻¹³" CND (own 1.8e-13).
- **Model III and Example 3 (102–115):** confirmed (Mathews' duplicated x₅(0) noted correctly; eigenvectors; c; table; maxima; S′); solver tolerance claims CND (own 1.1e-13).

## Implementation checks

- **compartmentaa.jl:** eigenvalue method with recursion (4) in `Rational{BigInt}`; coefficients identical to sympy expm; residual 8.5e-76; maxima identical to mpmath; frame 20 checked (tank heights).
- **compartmentbb.jl:** complex-pair method with `@assert`-verified eigenvectors; c and crossings match closed forms; |S − 10| ≤ 1.4e-76; log-panel styles follow the sign; clamping at crossings below the panel floor is honest.
- **compartmentcc.jl:** same code as aa (diffed); coefficients identical to sympy expm; maxima identical; frames 21 and 113 checked.
