# Review: Predictor-Corrector Methods (batch 4, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: `n2003/PredictCorrectMod.html` is an empty "This Module is …" placeholder, and `a2001/Animations/OrdinaryDE/` holds only Adams1, Euler1, Heun1, MEuler1, Milne1, RungeKutta1 and Taylor*; there is nothing to be faithful to and no Fidelity finding. Independent computation: Python/mpmath (60 and 40 digits) for every run on the page, sympy for the error constants and the PECE characteristic polynomial, a 10⁻⁴ z-grid plus bisection for the stability intervals.

## Findings

### F1 — Page match — Minor (unverified): one table cell rounded wrongly

- **Location:** `index.qmd` line 400, Example 3, "Accuracy of Milne's estimate" table, row h = 0.025, column "true / principal term": `0.972`.
- **True instead:** true local error −6.2260191e−6, principal term −(1/12)h³y'''(0.5) = −6.4088448e−6, ratio **0.9714729 → 0.971** (likely double rounding 0.97147 → 0.9715 → 0.972). The other cells in the row (−6.226e−6, −6.338e−6, 1.018, −6.409e−6) are correct.
- **Evidence:** a single PECE step from tan(0.5 − h), tan(0.5) at 40 digits printed `-6.2260191e-6 -6.337609e-6 1.0179232 -6.4088448e-6 0.9714729`.
- **Fix:** 0.972 → 0.971.

### F2 — Page match — Minor (unverified): the corrector-convergence theorem's global conclusion is applied where only a local version holds

- **Location:** lines 104–111, "Convergence of the corrector iteration (general)": "Suppose f satisfies a Lipschitz condition … then the implicit formula has exactly one solution y_{n+1}, and the iteration converges to it from any starting value"; line 347 applies it with "condition (3) holds: on the strip |y| ≤ 1.6 … L = 3.2 and h|b₋₁|L = 0.16".
- **True instead:** "exactly one solution" and "from any starting value" need a global Lipschitz condition, which f = 1 + y² does not satisfy; the same paragraph shows the corrector equation has two roots (0.2030668192 and 19.7969), and iteration from a large enough start diverges. On the strip the conclusion holds for solutions and starts inside it, because G(y) = c + 0.05y² maps [−1.6, 1.6] into itself at every step (worst step c ≈ 1.45, G ≤ 1.578 < 1.6), but the page does not say so.
- **Fix:** add "in the strip, since G maps the strip into itself" at line 347; or state the theorem for a region the map sends into itself; or say the Lipschitz condition must hold for all y.

## Inventory (Phase 1)

3 scripts, 3 GIFs (12, 9, 8 frames); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; 90 entries; reviewer's verdicts)

- **Description (1–6):** confirmed; the 50-digit/200-bit process claim could not be determined (numbers reproduced independently).
- **Animations introduction (7–12):** confirmed (problem, AB2 + trapezoid, h = 0.1, Heun y₁ = 0.1005, frame counts, log panels, timing, 256-bit with asserts against the tables, not-animated list).
- **Case 1 (13–25):** all confirmed: signs of tan t_n − p_n and y_n − tan t_n for n = 1…10; corrector error growing monotonically to −8.920795e−3; predictor error 6.9500e−4 → 5.7902e−4 (n = 4) → 4.7895e−3; p_n closer than y_n from n = 4; 0.01206 and 0.0513444; Milne ratios 1.0405494 … 1.4687 rising every step.
- **Case 2 (26–38):** all confirmed: Y* = 0.203066819152026, slope 0.0203067, window widths 1.441e−3 and 4.962e−12, p₂ < tan 0.2 < y^[1] < Y*, distances −1.0518e−3 … −7.3554621e−14, factors 0.020254 then 0.020306–0.020307, plateau −3.56784e−4, the single correction closest to tan 0.2.
- **Case 3 (39–46):** all confirmed: PE 0.0513444 (positive from n = 2), PECE −0.00892079, then −0.0148573, −0.0155579, −0.0156493, −0.015664; distances 6.7008e−2 … 1.4723e−5 with factors 9.94, 8.36, 7.61, 7.20; e_n < 0 throughout for m ≥ 1.
- **Linear multistep formulas (47–51):** confirmed, including all eight orders and error constants by sympy Taylor expansion (Euler 1/2, AB2 5/12, trapezoid −1/12, AM3 −1/24, AB4 251/720, AM4 −19/720, Milne 14/45, Simpson −1/90); theorem (3) confirmed as general (see F2 for its use).
- **Framework (52–66):** confirmed: modes, Heun as PECE and distinct from the Euler page's midpoint method, the order theorem's cases, the warning box, Milne's device and the pair constants, the modifiers (the Milne-Simpson page quotes 28/29), the PECLE identity, the characteristic polynomial (4(ζ − 1)² at z = −2), stability intervals PE −1, PEC −0.5, PECE −2, P(EC)²E −1.47797, P(EC)³E −2, PECLE −2.4, trapezoid A-stable.
- **Worked examples (67–87):** all confirmed except the one cell in 86 (F1): Example 1's steps and all 11 table rows to 14 digits, the 36-cell Milne table, y''' values 29.83 and 56.70, Example 2(a)'s quadratic and roots (largest |y| over all runs 1.57307 < 1.6) and table, Example 2(b)'s y₁₀ values, "about 57%" (0.5695), Example 3's 20 errors and 16 ratios, PECE 3.3% better than the trapezoid at h = 0.00625 (0.96677), PECLE 141 times smaller (141.36), the PE, PEC, Heun and PMECE rows and their stated properties, y'''(0.5) = 4.92199, "11% … under 1%".
- **Implementation notes (88–90):** confirmed (the Milne and ABM pages start with three RK4 steps; evaluation counts).

## Implementation checks

- **predcorraa.jl:** Heun start then genuine PECE (AB2, E, trapezoid, E); true local error from exact back values; estimate −(y − p)/6. p₁₀ = 1.5526181985, y₁₀ = 1.5663285195, n = 10 estimate/true −2.2851e−3/−1.5558e−3, ratio at n = 2 1.0405 — identical to the independent run. Frames 1, 5, 10 checked; nothing clamped.
- **predcorrbb.jl:** fixed-point iteration of the trapezoid corrector G(y) = c + (h/2)y² from p₂; Y* the small root (residual asserted < 1e−70); every iterate, distance and ratio matches; cobweb segments correct; frames 1, 2, 3, 7 checked; the tan 0.2 line leaves the window with an honest legend note.
- **predcorrcc.jl:** P(EC)^m E for m = 0…4 and the exact trapezoid by the stable quadratic formula 2c/(1 + √(1 − 2hc)) with residuals asserted; all six y₁₀, e₁₀ and distances match; frames 1, 3, 6 checked.
