# Review: Eigenvalues and Eigenvectors (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 5 Minor (unverified).**

Director's adjustments to the reviewer's report:
- The reviewer rated the Example 11 table entry 2.9 × 10⁻⁸ (true 2.849 × 10⁻⁸) an Error "with small effect". It is a last-digit rounding slip (2.849 rounded twice), which the review standard does not count as wrong beyond the last digit; it is recorded here as Minor (F1), as batch 4 recorded 0.972 for 0.971.
- The reviewer also reported that the section index links the deleted flat `eigenvalues-and-eigenvectors.qmd`. Withdrawn: section-index links are changed in each page's "Add animations" commit, and the review ran from the working tree before that commit.

Legacy archive consulted: the module HTML, solution pages lnk_2–lnk_13, the images for Examples 1–10. Independent computations: Newton–Raphson in exact and double arithmetic; scaled powers and Case 1 geometry; Examples 1–9 in sympy and numpy; Case 4 and Example 11 with an exact Faddeev–LeVerrier characteristic polynomial, mpmath `polyroots` at 100 digits and `eigsy`; exact-coefficient roots at 80 digits.

## Findings

### F1 — Page match (Example 11 table) — Minor (unverified): 2.9 × 10⁻⁸ should be 2.8 × 10⁻⁸

- **Location:** `index.qmd` line 613: `| 20 | $1.9 \times 10^{-15}$ | $2.9 \times 10^{-8}$ | $0$ |`.
- **True instead:** the largest root error of the rounded polynomial at n = 20 is 2.849 × 10⁻⁸, which rounds to 2.8 × 10⁻⁸.
- **Evidence:** `c4.py`: `20 ... roots err 2.8490e-08`; the script's regen log (Aberth at 512 bits): `n=20 ... roots err 2.849e-08`. The other root-error entries check out (4.4225e-13; 5.0503e-5; 1.4958e-2; 1.0864e-2; 5.6245e-2; 1.0339e-1).
- **Fix:** 2.8 × 10⁻⁸.

### F2 — Page match (Case 3 Behavior) — Minor (unverified): the "within 6 % / 10 %" bounds are measured the wrong way round

- **Location:** line 48: "They are within $6\%$ of the measured error at every step of run (a) and within $10\%$ from $k = 3$ on in run (b)".
- **True instead:** relative to the measured error, the prediction C·e²ₖ₋₁ is 6.07 % too large at run (a) k = 1 (0.002602 vs 0.002453) and 10.98 % too large at run (b) k = 3 (0.008519 vs 0.007677). The bounds hold only relative to the prediction (5.7 % and 9.9 %).
- **Evidence:** `c23.py`: `pred/meas-1=0.06066`, `pred/meas-1=0.1098`.
- **Fix:** "within 7 % … and within 11 %", or "the measured error is within 6 % (10 %) of the prediction".

### F3 — Page match (Case 3 Behavior) — Minor (unverified): "up … down" is wrong for run (b)'s first step

- **Location:** line 48: "a vertical line up to the curve, then the tangent line down to the axis."
- **True instead:** on run (b)'s first step p(1.5) = −1.75: the vertical line goes *down* to the curve and the tangent rises *up* to the axis at 3.25 (frames 2–10 of `eigencc.gif`; script lines 85–86).
- **Fix:** "a vertical line to the curve, then the tangent line back to the axis".

### F4 — Page match (Case 4 Behavior) — Minor (unverified): "the table above" is below

- **Location:** line 56: "measured as in the table above".
- **True instead:** the table is in the Example 11 section (line 610), after the Animations section.
- **Fix:** "as in the table of the Example 11 section below".

### F5 — Fidelity (Example 8) — Minor (unverified): two of Mathews' eigenvectors are the negatives of the page's

- **Location:** line 521: "These agree with Mathews' `Eigensystem` output."
- **True instead:** in `EigenvaluesMod_gr_336.gif` Mathews' V₃ (for 2.44504) is (−c, −a, b, b, −a, −c) and V₅ (for 0.75302) is (−b, c, −a, −a, c, −b), the negatives of the page's (scaled to a positive first component). Example 9 notes this kind of sign difference; Example 8 does not.
- **Fix:** "These agree with Mathews' `Eigensystem` output, except that his eigenvectors for 2.44504 and 0.75302 are the negatives of these."

## Inventory (Phase 1)

4 scripts, 4 GIFs (64 frames for Case 1); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D5), Animations introduction (A1–A6):** confirmed (A = [1 2; 1 1], λ = 1 ∓ √2; n = 11 coefficients equal Mathews' gr_351; exact rationals; marker convention; no archive animation; Example 3's Newton output lost).
- **Case 1 (C1.1–C1.14):** confirmed: semi-axes 2.618, 0.3820; eigen-angles 35.26°, 144.74°, 215.26°, 324.74°; ±V₂ same direction, ±V₁ reversed and shortened; det[X, AX] = 1 − 3 sin²t and its sign; 70.53°; major axis at 31.72°.
- **Case 2 (C2.1–C2.14):** confirmed: aₖ alternates and shrinks; xₖ = 0, 1, 2/3, 5/7, 12/17; |aₖV₁| < 0.0063 from k = 3; |eₖ| decreases and alternates, within 2e-4 of −0.171573 from k = 5; cₖ − λ₂ = 2eₖ₋₁ exactly; 3.644e-7 and 3.126e-8.
- **Case 3 (C3.1–C3.16):** confirmed except C3.2 (F3) and C3.11 (F2): approaches from below / overshoot to 3.25 then from above; steeper at every step; C = 0.3536; ratios settle at ∓0.3536; last errors −8.993e-25, 8.151e-21.
- **Case 4 (C4.1–C4.14):** confirmed except C4.3 (F4): error 4.4e-13 → 0.056, falling only at 17→18, 19→20, 25→26, 31→32, 35→36; real up to n = 28; first complex pair at 29 (Im 0.0037); n = 40: 10 complex roots, Re 0.78–1.04, Im up to 0.10; `eigvals` 6e-16 to 3.8e-15; the table's NumPy column CND (LAPACK-build dependent; rounding level confirmed).
- **Homogeneous systems and theory (H1–H4, T1–T5):** confirmed (Example 1; Mathews' "m > n … independent" slip).
- **Example 2 and Newton tables (E2.1–E2.11):** confirmed (every table entry; Mathews' p₃; double residuals −2.78e-17 and 0; exact residuals 2.5e-24, 2.3e-20).
- **Examples 3–9:** confirmed except E8.5 (F5) (all RREFs, eigenvectors and residuals; Example 7 callout; Example 8 cubics and a, b, c; Example 9 Galois group S₅, negated V for 1.49766; NSolve agreement CND from images).
- **Examples 10–11 (E10.1–E11.8):** confirmed except E11.3 (F1); E11.5 CND (LAPACK build).
- **Powers section (P1–P8):** confirmed.

## Implementation checks

- **eigenaa.jl:** angles and semi-axes identical; AX = λX asserted at the eigen-angles; frame 6 and a t = 60° title checked.
- **eigenbb.jl:** power method with max-component scaling in exact rationals; every value equals `c12.py`; aV₁ hidden below 0.02 as stated.
- **eigencc.jl:** plain Newton in exact rationals; every iterate, residual, error, ratio equal; tangent geometry and prediction crosses correct.
- **eigendd.jl:** recurrence for the characteristic polynomial with exact checks; Aberth roots at 512 bits; Sturm bisection for the true eigenvalues; root errors and imaginary parts agree with the independent pipeline to every printed digit.
