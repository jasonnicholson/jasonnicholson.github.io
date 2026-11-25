# Review: Steepest Descent - Gradient Search (batch 3, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: module text, program images gr_56 and gr_166, solution and table images for Examples 1–4, Links lnk_2 and lnk_7, the a2001 Gradient1 pages. Independent computations: an mpmath/sympy implementation of Mathews' Qmin/GradSearch transcribed from gr_56 (keeping his in-loop h < δ test, gradients by sympy, exact line minima by a 2000-point scan and 400 bisections); a parser comparing every cell of the six tables at half a unit in the last printed digit; counter-removed runs at 30–200 digits; 60- vs 120-digit comparisons; a resultant for Example 3's stationary points; Mathews' printed tables transcribed from the archive images.

## Findings

### F1 — Page match — Minor (unverified): "agrees with a 120-digit run to more than 50 digits" holds absolutely, not relatively

- **Location:** Description, `index.qmd` line 20: "Every tabulated run below was recomputed with his line search and stopping rule in 60-digit arithmetic and agrees with a 120-digit run to more than 50 digits."
- **True instead:** in absolute terms every x, y, f and h_k agrees to within 5.6e-52. In relative terms the smallest step lengths agree to fewer digits: Example 4 h₇ = 6.38e-11 to a relative 8.8e-42 (about 41 digits); Example 3(i) h₆ = 2.1e-10 to 9.2e-48 (about 47 digits). All coordinates and function values agree to more than 51 relative digits. Minimum agreeing relative digits per run: 52.3 (Ex 1), 51.6 (Ex 2), 47.0 (Ex 3(i)), 52.5 (Ex 3(ii)), 51.8 (Ex 3(iii)), 41.1 (Ex 4); the shortfall is only in h_k (Ex 4 k = 7: absolute 5.59e-52, relative 8.77e-42). No printed digit is affected.
- **Fix:** "agrees with a 120-digit run to within $10^{-50}$" (absolute), or "to more than 40 significant digits".

## Inventory (Phase 1)

4 scripts, 4 GIFs; all run; `gradientaa.gif` (19 frames), `gradientbb.gif` (12), `gradientcc.gif` (41), `gradientdd.gif` (11) byte-identical to what their scripts produce; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6):** confirmed except D5 (F1, relative sense); link `../quadratic-interpolative-search/` resolves.
- **Animations introduction (A1–A15):** all confirmed: frame counts 19, 12, 41, 11; panel elements; offset scaling (e.g. tick −0.7959 at ×10² = −0.007959); middle-panel levels as Mathews' gr_166 `contval`; trial points before/after the loop, 5h segment; exact line minimum agrees with an independent bisection on every step; tangency (frames aa 1, 7, 16); right panel (extends to 2.15h, cosmetic); titles; the omitted h < δ test never fires (smallest bracket h 3.7e-10 vs δ = 1e-10); 256-bit; script logs = independent run = tables, 0 mismatches; "Under Construction" animation page; Example 5 images gr_168–208 absent; Example 5 window drawn in Case 1.
- **Case 1 (C1.1–C1.9):** all confirmed: exact vertex (relative difference < 1e-50), doublings only, 0.5673° from an axis, 90.0° turns, ratio 8670000/34690201, gap 7.0223e-10, 3.41082e-5 from (3, 2), P₃ on inside the Example 5 window, counter 64 with Err = 2.0e-11 but h = 1.05e-5 > δ.
- **Case 2 (C2.1–C2.7):** all confirmed: 892.1648, six halvings, h₀ −0.606%, cross steps 9.493e-6 to 8.127e-5 within 0.00386%, down-valley 5–8 doublings overshooting 0.0559%–0.3946%, counter 61, 1.67380e-4.
- **Case 3 (C3.1–C3.8):** all confirmed: path lengths 0.02596, 0.2287, 0.2827; max axis deviation 0.98°, 0.92°, 1.0997°; run (i) 0.02505 start, 7 steps to 1.361e-11; counters 63; 0.004633, 0.003658; shortfalls 0.0384%, 1.651%, 2.006%.
- **Case 4 (C4.1–C4.7):** all confirmed: level circles, overshoot 4.819 vs 3.293, 4.283 vs 3.606, ratios 0.712, 0.695, 0.813, 0.951, 0.4876°, last search not bracketed (Y₀ + ½ = 5.08e-22 < Y₁ + ½ = 1.19e-20), 5.206e-20, counter 47.
- **Gradient section and theorems (T1–T8):** all confirmed, including the exact-line-search theorem under the first-local-minimiser hypothesis (reviewer's own proof sketch, C¹ f) and the x² − y² saddle example.
- **Mathews' implementation (M1–M7):** all confirmed against gr_56 and the call images (gr_79, 95, 115, 120, 128, 157); h stays above δ in every run including counter-removed runs at 30–200 digits (smallest bracket h 1.07e-13 vs δ = 1e-14).
- **Example 1 (E1.1–E1.13):** all confirmed, including exact rationals, 0 table mismatches, ratios, 34 counter-removed iterations at ≥ 40 digits, Mathews within 1.63e-11 and 4.49e-13.
- **Example 2 (E2.1–E2.15):** all confirmed, including κ ≈ 2508, 0 table mismatches, 28 counter-removed iterations, Mathews within 3.17e-11 (gr_96).
- **Example 3 (E3.1–E3.11):** all confirmed, including five stationary points (degree-9 resultant), 0 table mismatches, **113 and 103 counter-removed iterations at 100, 120, 150, 200 digits and other counts at 30, 40, 60, 80, 90 digits**, Err ≤ 1e-14 from iterations 52 and 54, last steps < 2e-12 (max 1.9e-12), Mathews within 1.14e-10.
- **Example 4 (E4.1–E4.13):** confirmed except E4.7 (textbook Example 8.9 not available to the reviewer: could not determine); Mathews' rows within 9.09e-13, his 9th iteration (gr_158).
- **Example 5 (E5.1–E5.3):** confirmed (gr_166: h = 0.2, counter 20, Hmin = h/3 when d < 0).
- **Fidelity:** Mathews' functions and starts used; Example 5 not rebuildable and the page says so; his second illustration value ∇f(3, 2) = (121/4, −5) is not on the page (negligible).

## Implementation checks

All four scripts share one engine (checked with `diff`): steepest descent with normalised −∇f, Mathews' Qmin (one parabola fit after up to 15 halve/double passes), his next-trial-step rule, Err/δ/ε stopping and work counter 60, matching gr_56; the in-loop h < δ test is omitted and never fires. The independent 60-digit run reproduces the logs exactly (Ex 1 h₀ = 1.500222028, P₁₆ = (2.999969402, 1.999984929); Ex 2 h₀ = 0.01332998765, P₉ = (1.000071141, 1.000151509); Ex 3 step counts and counters; Ex 4 h₀ = 4.818676039, last pass "HHHHHHHHHHHHHHH", h = 3.725464041e-10, P₈ at 5.206e-20). References: P* exact for Examples 1, 2, 4; Example 3 P* by Newton polishing agrees with resultant + findroot to 12 digits (e.g. (2.148212130, 1.587535404), f* = −0.7636800592); γ* agrees with independent bisection (Ex 4 k = 0: 3.292600376; Ex 2 k = 2: 0.002257971454). Frames aa 1, 7, 16; bb 1, 2, 3, 8, 9; cc 1, 22, 38; dd 1, 3, 7, 8 checked; the left-panel blue level curve is clamped at a gap of 1e-12 for late steps of Ex 3(i) and Ex 4, where it is sub-pixel anyway (not a finding).
