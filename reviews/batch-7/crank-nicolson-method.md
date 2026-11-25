# Review: Crank-Nicolson Method (batch 7, round 1)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page: the reviewer worked on a scratch copy with two planted errors in the Case 1 and Case 2 Behavior paragraphs and reported both as Errors from its own computations (see the README). The planted findings are not reported; the committed page's versions of those two sentences were confirmed by the same reviewer (computed rows lie below the exact solution, "allneg True" for every row; G₁ = 0.665779740, matching the page's 0.665780, its alt text, Example 2 and the GIF legend).

Legacy archive consulted: module HTML, example pages, program images, tables and plots (images 22–131). Independent computations: Examples 1–2 in exact rational arithmetic with an mpmath (30-digit) Fourier series; Examples 3–4 by a dense solve of the undivided form (6) and an own Thomas solve of Mathews' divided form; mode factors, the refinement study, sawtooth runs; regeneration logs; frames of all four GIFs.

## Findings

None.

## Inventory (Phase 1)

4 scripts, 4 GIFs; all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D4):** confirmed (G_p formula; CN formula derived from (4)/(5); refinement ratios 4.000; Mathews' runs r = 0.5, 0.875, 1, 2 — archive images 25, 50, 89, 129).
- **Animations introduction (A1–A6):** confirmed (exact series to p = 1999 for Examples 1–2, closed form for 3–4; title values 0.07281/0.1178, 0.002716/0.001381, 0.4441, 5.569; no PDE animation in `a2001/Animations`).
- **Case 1 (C1.1–C1.10):** confirmed: averaging at r = ½; errors negative at every interior point for t > 0; 0.0241097 at x = 0.2/0.8 in the first step, then at x = 0.4/0.6; peak 0.0258234 at t = 0.1, 0.0185339 at t = 0.2; u = 233/3200, 377/3200 at t = 0.2.
- **Case 2 (C2.1–C2.11):** confirmed: only modes 1 and 3 (A₂, A₄ ≈ 1e−16); G₁ = 0.665780 vs e^{−π²k} = 0.707912; G₃ = −1.290780 vs 0.044649, sign change each step; |A₃| > A₁ from row 7 (0.1643 > 0.0898); 0.444108 vs exact 0.0326205 at t = 0.35; leaves the axis at row 16 (1.553); 5.56876 vs 0.00103105 at t = 0.70; A₃ = 5.85516.
- **Case 3 (C3.1–C3.7):** confirmed: positive, no oscillation; r = 1 errors 0.004998 → 0.002028 → 0.002716; r = 2 0.0738 then monotone to 0.001381; below Example 3's from t = 0.08 (0.002534 < 0.002582).
- **Case 4 (C4.1–C4.10):** confirmed: sign alternation in x and t for both methods; FD factor 7 for four steps then 6.973 … 6.858 (|G₉| = 6.804226); leaves the axis at t = 0.08 (2.679); 2.611e5; CN 0.5867–0.6930 per step to 1.05464e−5.
- **Heat equation, grid, forward differences (H1–H3):** confirmed.
- **Example 1 (E1.1–E1.11):** confirmed, including the module's "r = 1" (image 22), the whole exact table, Mathews' six-digit printing (image 42), coefficients 32/(p³π³), truncation within 1.1e−10 at the grid points.
- **Example 2 (E2.1–E2.10):** confirmed, including every printed entry (image 67), the sign-change pattern, the two-mode closed form (3.3e−16), (−1.290780)¹⁰ = 12.8387, r ≤ 0.763932, the jagged surface (image 55).
- **Crank-Nicolson section (CN1–CN7):** confirmed, including the divided form (images 78, 80), matrix eigenvalues > 2, G_p = (1 − 2rs_p)/(1 + 2rs_p).
- **Example 3 (E3.1–E3.14):** confirmed, including the first step (residual 2.2e−16), the full table, hump location 0.195913, G₁ = 0.906680, G₃ = 0.416215, the refinement ratios 3.9996, 4.0002, 4.0001.
- **Example 4 (E4.1–E4.13):** confirmed, including the module statement repeating Example 3 (images 112–129), the first step and table, G₃ = 0.096233 vs 0.169225, G₁ = 0.821681 vs 0.820869, FD max error 0.8014 vs CN 0.0738, sawtooth results, r = 1 on Example 3's grid (52.58; 1.189e−5).
- **Summary (S1–S3):** confirmed.

## Implementation checks

- **cranknicolsonaa.jl:** formula (3) in `Rational{BigInt}`; all 11 rows identical to the independent exact run; reference series agrees with mpmath to 6 decimals; titles and argmax locations correct.
- **cranknicolsonbb.jl:** formula (3) exact; rows 1–21 match (row 16 max 1.55276, row 21 5.56876); DST coefficients 1.03136 and 0.0355219; `ydraw` clamping visible and labelled "(off scale)" with the true max|u|; marker signs correct.
- **cranknicolsoncc.jl:** Mathews' divided CN form with a Thomas solve on the interior unknowns; every entry matches the dense solve of (6) and an independent Thomas solve; closed form reproduces the runs to ≤ 4.4e−16; log axis contains every value.
- **cranknicolsondd.jl:** FD and CN with the stated sawtooth; max|δ| sequences and perturbed FD max|u| = 2.67866 identical to the independent runs; G₉ = −6.804226 (FD), −0.592013 (CN); clamping flagged "(off scale)".
