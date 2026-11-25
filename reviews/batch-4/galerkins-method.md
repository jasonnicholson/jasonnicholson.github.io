# Review: Galerkin's Method (batch 4, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `GalerkinMod.html`, lnk_2–9 and the images for Examples 1(a)–(c), 2, 3(a), 3(b), 4(a), 4(b); `a2001/Animations` checked. Independent computations (scratch Python): sympy for Example 1 and exact rational Galerkin for Example 3 (both bases, every n); B for Case 1 assembled by mpmath quadrature (not the script's recursion) and solved at 160 digits, plus NumPy double precision; Example 4's A and B by scipy quadrature and its Fourier coefficients by mpmath.

## Findings

### F1 — Page match — Minor (unverified): "within 2% … for k ≥ 10" just fails at k = 10

- **Location:** `index.qmd` line 52, Case 3 Behavior: "$|c_k|$ is within $2\%$ of $4/(\pi k^3)$ for $k \ge 10$".
- **True instead:** c₁₀ = −1/(245π), so |c₁₀|/(4/(π·10³)) = 250/245 = 1.0204 (2.04%). The ratio is 1.68% at k = 11, 1.41% at k = 12, and smaller after that (k = 9…15: 0.97468, 1.0204, 0.98319, 1.0141, 0.98802, 1.0103, 0.99103).
- **Fix:** "within $2\%$ of $4/(\pi k^3)$ for $k \ge 11$", or "within about $2\%$ … for $k \ge 10$".

No Fidelity findings: equations, intervals, bases, coefficients, condition numbers and colours match Mathews; the page documents its departures (Example 2's stated vs solved equation; the f, g pairs in his 1(b) and 1(c) notebook) and names the examples it does not animate.

## Inventory (Phase 1)

3 scripts, 3 GIFs (18, 7, 17 frames); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D5):** confirmed (largest errors 5.123e−9 to 0.01478).
- **Animations introduction (A1–A14):** confirmed: Mathews' intervals and colours (Magenta/Blue), red boundary dots, gray earlier solutions, log error panels with exact zeros drawn below the panel, timing (100 cs delays, 2 held frames), asserts against Mathews' coefficients, 512/256-bit arithmetic and grid sizes, golden-section refinement, no Mathews animation, cases and wiring, Example 3(a) 5.12e−9, Example 4(a) even coefficients zero.
- **Case 1 (C1.1–C1.15):** confirmed: largest error 0.72964 (n = 1), 0.0147767 (n = 7), 2.37364e−7 (n = 16), falling every step, location 0.66775 → 0.03269; cond∞ 179.0 (n = 2) to 1.1688e28, growth 65.52–85.87 per function, 3.3164e11 at n = 7 as Mathews; double-precision LU agrees to 4 s.f. up to n = 9 (cond 1.4776e15), then 2.261e−4, 4.352e−5, 1.922e−4, 1.807e−3, 2.584e−4; NumPy 1.4e−4 to 6.4e−4.
- **Case 2 (C2.1–C2.12):** confirmed: bases coincide at n = 1 (0.005616 at 0.1568), complete basis 2.069e−8 at n = 5 (about 4.9×10⁴ smaller than 0.001014), Mathews' basis 0.001824 → 0.001823, u′(0) + u′(1) = 1 for every trial function of his basis (sympy, all n), exact 0.9152438609, complete basis 75/82 and 7030/7681, signs at x = 0.0595 and 0.9405.
- **Case 3 (C3.1–C3.10):** confirmed except C3.5 (F1): A diagonal (quadrature off-diagonal ≤ 2.7e−13), c_k inside the Fourier circles (5.18e−13), alternating signs, g″(0) = 0 and g″(π) = −2 giving c_k ≈ −4(−1)^k/(πk³), largest error location 2.8185 → 3.0851, 0.3397, 0.008702, 0.002034, n²·max in [0.4063, 0.4577].
- **Example 1 (E1.1–E1.8):** confirmed (⟨f, g⟩ = 6 on [0, 2]; −130/3; Mathews' notebook pair giving 0; 1(c) = π; his step panel's g giving 0).
- **Weighted residuals, algorithm, conditioning (W1–W6):** confirmed; Mathews' condition numbers are ∞-norm (3.31641e11, 9841.63, 87277.4, 23, 47 reproduced exactly).
- **Example 2 (X2.1–X2.13):** all confirmed (a₁₁ = 49.5, a₇₇ = 14348907/2, b₁ = −7.489890695, the coefficients, the exact solution, all 7 table rows, −0.01478 at 0.107 and 0.002548 at 0.4865 with seven sign changes, 11.52 digits lost, NumPy differences 9.617e−8 and 6.564e−10, the stated equation's solution with 0.001247 at 0.1335 and cond 2.44501e11).
- **Examples 3, 4 and summary (B1–S1):** all confirmed, including every fraction in 3(a) and 3(b) (matching the archive), the 3(b) callout, condition numbers and digits lost, 4(a) and 4(b) tables and coefficients (quadrature agrees to 12 digits), the Fourier-coefficient callout, the summary table.

## Implementation checks

- **galerkinaa.jl:** Galerkin with φ₀ = 1 and φ_j = x^j, exact rational A, B = −∫x^i(L[1] + f), 512-bit solve; double path rounds A, B to Float64 and uses LU. Largest errors and cond∞ match the independent quadrature-assembled 160-digit solve for all 16 n (argmax to 4 decimals). Exact y verified (sympy residual 0). Frames 1, 7, 16 checked; no clamping (u_n in [0.134, 1.109] within (0, 1.15)).
- **galerkinbb.jl:** exact rational Galerkin, φ₀ = x/2, Mathews' basis as in the archive and the complete basis x^i(x − 1); identical largest errors, locations and u′(0) + u′(1) for both bases and every n; 5×5 A, B, c match the archive fractions exactly. Frames 2 and 5 checked.
- **galerkincc.jl:** φ₀ = x/π, basis sin kx, closed-form diagonal A and b_k re-derived by quadrature; every log row (c_n, max error, argmax, n²·max) matches to 4 s.f.; c₁…c₇ match the archive; Fourier coefficients agree to 12 digits. Frames 1 and 15 checked; no clamping (u_n ≤ 4.434 within (0, 4.8)).
