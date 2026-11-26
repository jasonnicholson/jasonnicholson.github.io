# Review: Simpson's Rule for Numerical Integration (overview page, light-pass pilot)

**Mode:** overview (action *extend*). The diff against `main` rewrites and extends `## Description` and adds the heading id `{#case-1}`; it changes no script or GIF, so the animation was not re-reviewed.

**Result: 0 Error, 0 Misleading, 0 Minor.**

## Findings

None.

Two judgement calls the reviewer considered and decided were not findings:

- "the higher-degree Simpson's 3/8 Rule and Boole's Rule": literally true of the interpolant degrees (2, 3, 4). It does not claim 3/8 has a higher order, and the Newton-Cotes page explains that 3/8 is also O(h⁴).
- "Adaptive Simpson's Rule applies the rule panel by panel": loose, but not false. The adaptive page applies S(a, b) on each panel and splits those that fail the test.

## Inventory (Phase 1)

- Diff touches only `index.qmd` (23 insertions, 4 deletions; one heading line changed).
- GIF: simpsonsaa, 24 frames, extracted from the committed file. Regeneration skipped (no script changed).
- Mechanical checks: no control characters, no leftover sections, no `localhost` link, no code block; every link resolves (`#case-1` exists as an explicit heading id; the six sibling folders exist).
- Description prose: 334 words (inline math as one word; 341 if split on spaces). Within 150–400.
- Archive: found; the reviewer read `n2003/simpsonsrulemod.html` and its formula images gr_16–gr_48.

## Claim ledger (reviewer's)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | Equally spaced points, h = (b−a)/n, x_k = a + kh | confirmed | script lines 27–30; Mathews gr_19–23 |
| 2 | Parabola through the three nodes on each [x_{2k−2}, x_{2k}] | confirmed | script lines 41–55 |
| 3 | S_n display formula | confirmed | script lines 28–29 weights h/3·(1,4,2,…,4,1); Mathews gr_35–37 with n = 2m |
| 4 | n must be even | confirmed | definitional |
| 5 | S_n converges for any continuous f | confirmed | S_{2m} = (T_m + 2M_m)/3, a convex combination of Riemann sums |
| 6 | Error formula needs f ∈ C⁴[a, b] | confirmed | Mathews gr_39 |
| 7 | Exact for every cubic; first missed term involves f⁽⁴⁾ | confirmed | sympy, n = 4 on [0, 2]: error 0 for x⁰…x³, −1/60 for x⁴ = −(2/180)·24·(1/2)⁴ |
| 8 | Cubic error cancels by symmetry about the panel midpoint | confirmed | (x − m)³ is odd about m |
| 9 | ∫ − S_n = −(b−a) f⁽⁴⁾(c) h⁴/180, a < c < b, "as Mathews states it" | confirmed | Mathews gr_38–43; sign checked on x⁴ |
| 10 | O(h⁴), halving divides by about 16 (general, under C⁴) | confirmed | Mathews gr_46–48 |
| 11 | The animation does not show this rate (integrand not C⁴) | confirmed | f′ unbounded |
| 12 | Case 1 integrand e^{−x} sin(8x^{2/3}) + 1 | confirmed | script line 8 |
| 13 | f′ unbounded at 0 | confirmed | lim x^{1/3} f′(x) = 16/3 (sympy) |
| 14–15 | Error ~ h^{5/3}; ratios 3.38, 3.22 → 2^{5/3} ≈ 3.17 | confirmed | 3.3803, 3.2214, 3.1887, 3.1801, 3.1772, 3.1759 (to n = 1536); 2^{5/3} = 3.17480 |
| 16 | Trapezoidal error also ~ h^{5/3} | confirmed | T ratios 3.1415, 3.1583, 3.1647 |
| 17 | Simpson error about 3.5× smaller than trapezoidal for n from 48 to 108 | confirmed | 3.495, 3.517, 3.533, 3.544, 3.556, 3.564, 3.571 at the frames' n |
| 18 | For n ≤ 6 Simpson's error is larger than trapezoidal | confirmed | n = 2: 0.4750 vs 0.3567; n = 4: 0.4045 vs 0.2142; n = 6: 0.1757 vs 0.1611; n = 8 reverses (0.0748 vs 0.1097) |
| 19–23 | Table rows n = 6, 12, 24, 48, 96 (h, S_n, S_n − I, ratio) | confirmed | mpmath: 1.84056021 / −0.175720; 1.991249238 / −0.0250305 / 7.0202; 2.010369629 / −0.00591009 / 4.2352; 2.014531336 / −0.00174838 / 3.3803; 2.015736986 / −0.000542734 / 3.2214; frames 004, 007, 012, 018, 023 show 1.84056, 1.991249, 2.01037, 2.014531, 2.015737 |
| 24 | Rows are frames of Case 1, each halving h | confirmed | all five n in `n_seq`; frames inspected |
| 25 | I ≈ 2.016280 | confirmed | 2.0162797196… by two quadratures (x = t³ substitution; split interval) |
| 26 | Ratio = previous row's error / this row's | confirmed | |
| 27 | Degree-2 member of Newton-Cotes, between trapezoidal and the higher-degree 3/8 and Boole | confirmed | consistent with newton-cotes-integration line 13 |
| 28 | S_{2n} = (4T_{2n} − T_n)/3 | confirmed | exact for n = 4, 8 (mpmath) |
| 29 | Second column of Romberg | confirmed | R_{k,2} = S_{2^{k−1}} from the Romberg page's definitions |
| 30 | Adaptive Simpson applies the rule panel by panel | confirmed (loose) | adaptive page lines 27, 33 |
| 31–32 | Six sibling links and `#case-1` resolve | confirmed | |

## Standard and implementation checks

- Six points present: problem (line 12), formula (display, matches script), assumptions (n even; C⁴ for the error term), accuracy (general, with hypothesis, and says the animation does not show it), failure mode (non-smooth integrand → Case 1; worse than trapezoidal for n ≤ 6), where it fits (one sentence, links).
- The worked example is a 5-row table from the animated problem; it adds errors and ratios the GIF does not show. No proof, no callout box, no MATLAB or Mathematica.
- Consistent with the Case 1 Behavior paragraph (I, last frame 2.015834 and 0.000446 low, 3.38, 2^{5/3}, f′ ≈ (16/3)x^{−1/3}) and with the Animations intro's notation. The removed clause "typically much smaller than trapezoidal error at the same spacing" was replaced by text correct for this integrand.
- Outside the Description: only the heading id. No moves.
- Script: `simpson_sum` (lines 26–31) is the composite 1/3 rule with the Description's weights. Frame annotations agree with independent mpmath sums at n = 4, 6, 8, 12, 24, 48, 96, 108. 24 frames = opening frame + 23 values of `n_seq`.
- Fidelity: the error term and its hypothesis are as in Mathews' corollary. No Fidelity finding.
