# Review: Nelder Mead Method (batch 3, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: the module text, all five example link pages and their images, the textbook PDF `neldermead/NelderMeadProof.pdf` (Section 8.2: Table 8.5, Example 8.6, Table 8.6), and `a2001/Animations/Optimization/Nelder1/`. Independent computations (reviewer's scratch): own Mathews-subroutine Nelder-Mead in Python `Fraction` written from his `Nelder2D` listings (gr_93, gr_142, gr_199); textbook Table 8.5 rules; Rosenbrock runs; a double-precision run against Mathews' printed 50-row table; sympy resultant and mpmath for Exercise 3; a parser comparing every table row on the page with the exact runs.

## Findings

### F1 — Page match — Minor (unverified): "mirror images of these frames" is wrong for Mathews' cumulative pictures

- **Location:** Case 1 Behavior: "Mathews' floating-point run took $\mathbf{R}$ there, so from step 6 on his pictures are the mirror images through $(3, 2)$ of these frames, one step behind"; Example 4, last paragraph: "Mathews' pictures from step 6 on therefore show the exact path reflected through the minimum and one step behind."
- **True instead:** only the *triangles* from Mathews' step 6 on are mirror images of the exact triangles one step earlier. Each of his pictures also draws every earlier triangle, and triangles 0–5 are the same in both runs, not mirrored. Example 4 states the triangle-level fact correctly elsewhere ("his triangle after $k$ steps is the mirror image through $(3, 2)$ of the exact triangle after $k - 1$ steps").
- **Evidence:** Mathews' picture after step 6 (gr_219) shows the unmirrored start triangle (0,0), (1.2,0), (0,0.8) plus the new vertex (4.2, 2.8); mirroring the page's step-5 frame would put (0,0) at (6,4), outside his window. His final picture (gr_237) keeps the early triangles. A double-precision run reproduces his printed 50-row table (rows 5, 6, 7, 15, 20, 30, 40, 45, 50 checked against gr_132), and its triangle k equals the mirror of the exact triangle k−1 for every k = 6…50 (largest difference 8.9e-16).
- **Fix:** Case 1: "…so from step 6 on each new triangle in his pictures is the mirror image through $(3, 2)$ of the triangle here one step earlier (see Example 4)". Example 4: "Mathews' pictures from step 6 on therefore add the exact path's triangles reflected through the minimum and one step behind."

### F2 — Page match — Minor (unverified): "to within $2 \times 10^{-7}$" is just exceeded for case (iii)

- **Location:** Exercise 3, Verification: "Mathews' comparison with `FindMinimum`, whose points agree with the true minimisers to within $2 \times 10^{-7}$".
- **True instead:** Euclidean distances of Mathews' printed `FindMinimum` points to the true minimisers are 5.6e-9 (i), 1.95e-7 (ii) and **2.04e-7** (iii); every coordinate difference is within 1.8e-7. The page measures distance as Euclidean elsewhere.
- **Evidence:** Mathews' points from gr_182, gr_191 (read at 4× zoom: (2.14821202086479, 1.58753556540688)) and gr_198; true minimisers from mpmath `findroot` on ∇f at 40 digits: (−0.0250360933273629, 0.000940207845464535), (2.14821213031934, 1.58753540397321), (−2.18175187312444, 1.60697656265174).
- **Fix:** "agree with the true minimisers to about $2 \times 10^{-7}$" or "to within $2.1 \times 10^{-7}$".

## Inventory (Phase 1)

3 scripts, 3 GIFs; all run; `nelderaa.gif` (19 frames), `nelderbb.gif` (84), `neldercc.gif` (27) byte-identical to what their scripts produce; every reference resolves; no unreferenced file; the section index links `nelder-mead-method/`.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6):** all confirmed, including the 50-step diameter ratio 123,035 (> 100,000), the test-point and shrink formulas, and exact rational arithmetic in every run.
- **Animations introduction (A1–A7):** all confirmed (picture elements, subroutine rule with strict tests and (f, x, y) tie order, triangles match the tables, right-panel conventions, title digit rule, "Under Construction" animation page, 16 static pictures gr_207–237 in [0,5]×[0,3]).
- **Case 1 (C1.1–C1.12):** all confirmed except C1.7 (wording, F1): steps 1–4 test points and values (17.76, 1.44, −6.24), the step-6 tie f(R) = f(W) = −5.88, Mathews' float run taking R (f(R) = −5.880000000000003 in double), move counts 2 E / 3 R / 10 C₁, final B = (2.989709, 1.979285), 0.0231 from (3, 2), f(B) = −6.999678.
- **Case 2 (C2.1–C2.11):** all confirmed: x > 0 at step 29, 77 steps, f(W) − f(B) = 7.653e-6, B = (0.998047, 0.996008), f(B) = 4.609e-6, 23 E / 16 R / 38 C₁, aspect 2 → 9.618 (median) → 102.6, within 25.82° of the valley, sticky right-panel window disclosed (frame 30: E outside, f(E) = 4.62405 in title).
- **Case 3 (C3.1–C3.11):** all confirmed: vertex distances to minima ≤ 0.2025, 0.2632, 0.3014; nearest saddle 1.0144, 1.1783, 1.2659; 17, 22, 20 steps (Mathews' tables 18, 23, 21 rows); distances 6.89e-4, 8.88e-4, 1.05e-3; only (iii) global; final triangles (i), (iii) contain the minimiser, (ii) does not.
- **Triangle and logical decisions (T1–T10):** all confirmed, including Table 8.5 read as printed (case (ii) still contracts after W := R), the three rule differences, the stopping test `While[Or[And[Fw>Fb+ε,k<100],k<2]]`, and the tie pairs as mirror pairs through (3, 2).
- **Example 1 (E1.1–E1.14):** all confirmed, including the textbook table k = 0…9 against Table 8.6 (0 mismatches), the tie-order remark (C₁ = (2.7, 2.0) with f = −6.91 if the other vertex were replaced), 50 steps 3 E / 10 R / 37 C₁, f(B) = −6.9999999999915468…, 3.902e-6 from (3, 2), vertex spread 4.37e-11, Mathews' mirror point gr_135.
- **Example 2 (E2.1–E2.10):** all confirmed, including the Hessian eigenvalues 0.3994 and 1001.6, the lost images gr_144–163, 77 steps, both tables (0 mismatches), |y − x²| ≤ 0.0756, distance 4.444e-3, ε = 1e-10 run (94 steps, 7.563e-5), double precision taking the same steps.
- **Exercise 3 (X1–X10):** all confirmed except X8 (F2): five stationary points from the degree-9 resultant, results table, move counts, three full tables (0 mismatches).
- **Example 4 (E4.1–E4.10):** all confirmed (E4.10 wording covered by F1): table k = 0…15, step 3 and 4 tests, subroutine k+1 = textbook k for k = 3…9, step 6, Mathews agrees through k = 5 apart from tie order, mirror relation k = 6…50.

## Implementation checks

- **nelderaa.jl / nelderbb.jl** (same code, `case` switch): `improve()` is Mathews' `Nelder2D` exactly as listed (E, R, C₁, C₂ each strictly against f(W), else shrink), with re-sorting by (f, x, y); Case 1 fixed 15 steps, Case 2 Mathews' stopping test (script line 117). The subroutine variant, as the page names it. An independent Fraction implementation gives identical triangles, moves and test values (e.g. Case 2 step 77: B (0.9980467, 0.9960081), f = 4.60948e-6, W f = 1.226239e-5; step 29 tests E 4.62405, R 1.848159, C₁ 1.098645), agreeing with frame titles 30 and 78. References: (3, 2), f = −7 analytic; Rosenbrock (1, 1), f = 0. Frames aa 1, 4, 5, 7, 15, 16 and bb 30, 78 checked against computed coordinates; minor label overlaps cosmetic.
- **neldercc.jl:** same subroutine run three times; stationary points by 256-bit Newton (gradient residual < 1e-60) match the resultant and mpmath roots; searches (i) 17 steps, B (−0.02538833, 0.001531836), f −0.0031256772946, gap 7.954e-6; (ii) 22 steps, B (2.148987, 1.58797), f −0.76367575665, gap 7.791e-6; (iii) 20 steps, B (−2.182565, 1.607639), f −1.8462765587, gap 5.779e-6 — identical to the reviewer's and to Mathews' printed tables (gr_178/180, 185/188, 194/196). Frames 1, 12, 23 checked.
