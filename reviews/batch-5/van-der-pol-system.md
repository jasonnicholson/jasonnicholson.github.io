# Review: van der Pol System (batch 5, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `VanDerPolMod.html`, the Example 1 solution page `Links/VanDerPolMod_lnk_2.html`, images gr_1, 2, 20, 24, 26–30, 39, 49, 60, 70; no van der Pol animation under `a2001/Animations`. Independent computations: Example 1 with mpmath; limit cycles and reference runs with SciPy DOP853 (rtol 1e-13 and 2.3e-14); an own RK4; a second independent reference by RK4 with n = 192000 plus Richardson extrapolation; the μ = 4 slow and fast times.

## Findings

### F1 — Page match — Minor (unverified): two ratios in the "Verification of Examples 2 to 6" table are slightly off

- **Location:** `index.qmd` lines 311–317, column "ratio": 15.99, **16.10**, **15.98**, 15.94, 15.69 for μ = 1/16, 1/4, 1/2, 1, 4.
- **True instead:** the ratio of the largest Euclidean error over all points for n = 6000 to that for n = 12000, from (0, 3), against two independent references:

  | μ | DOP853 rtol 2.3e-14 | RK4 n = 192000 + Richardson | page |
  |---|---|---|---|
  | 1/16 | 15.996 | 15.997 | 15.99 |
  | 1/4 | 15.993 | 15.981 | **16.10** |
  | 1/2 | 15.965 | 15.964 | **15.98** |
  | 1 | 15.938 | 15.938 | 15.94 |
  | 4 | 15.688 | 15.688 | 15.69 |

  The page's 16.10 is about 0.11 too high (a looser DOP853 at rtol 1e-13 already moves it to 16.04, so it likely came from a reference not accurate enough at the n = 12000 error level, about 1.3e-9); 15.98 is 0.015 too high. The conclusion ("a ratio near 16 is the order h⁴") is unaffected.
- **Evidence:** `vdp2.py`, `vdp3.py`.
- **Fix:** 16.10 → 15.99 and 15.98 → 15.96, or give the ratios to three figures (16.0, 16.0, 16.0, 15.9, 15.7); optionally state the tighter reference.

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (130 frames for Case 1); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 147 entries; reviewer's verdicts)

- **Description (1–11):** confirmed (damping sign and dE/dt = μ(1 − x²)y²; unique limit cycle by Liénard; RK4 vector step as in all three scripts; Mathews' six examples, Example 1 settings; lost cells for Examples 2–6; the page's (0, 3), [0, 60], h = 0.01).
- **Animations introduction (12–21):** confirmed (limit cycles by RK4 h = 0.001 from (2, 0); maxima by bisection on one RK step, agreeing with DOP853 to 8 decimals; holds of about 3 s; no Mathews animation; every example animated).
- **Case 1 (22–31):** confirmed: clockwise from the top; end (−9.31101e−7, 2.99999999987); error never decreases, 9.563e−9; radius shortfall never decreases, 1.252e−10; |R(ih)| = 1 − 1.0431e−13 < 1.
- **Case 2 (32–46):** confirmed: magenta outside, blue inside in every panel (cycle crossings 2.0007, 2.0111, 2.0441, 2.1727); maxima monotone toward the cycle; faster for larger μ (ρ = 0.6751, 0.2053, 0.03918, 8.597e−4); tenth maxima; seven-figure agreement from the stated maxima; largest |y| 2.6784 for μ = 1.
- **Case 3 (47–61):** confirmed: both starts inside (3.7623); first maximum 1.957 at 0.6541 below 2.023; on the cycle at the second maximum (t = 10.47; 9.4930 from (0, 0.5), 0.9736 ahead); 3.86 slow drift within 0.022 of y′ = 0; 0.829 fast fall; |y| peak 6.344 at x = −0.9805.
- **Theory (62–85):** confirmed (energy (3); Jacobian and eigenvalue table; Liénard hypotheses; (4) = πμA²(4 − A²)/4; cycle table P, largest x, largest |y|, ρ; e^{−π/8} = 0.6752); the order-8/Radau process claim CND (values confirmed).
- **RK section and Example 1 (86–105):** confirmed (k₁…k₄, Z₁, Z₄₀₀ = Mathews' gr_28; b short of 2π by 3.07e−7; verification table; n table with ratio 16.0).
- **Examples 2–6 (106–138):** confirmed (every maximum sequence, gap factors and ratios; Example 6 times and symmetry; |y| > 2 for 10.8 % of the cycle); two rounding-level gap values (3.8e−14, 6.8e−14) CND at two figures.
- **Verification table (139–143):** end points and errors confirmed; ratio column wrong in two rows (F1); error grows with μ.
- **Implementation notes (144–147):** confirmed.

## Implementation checks

- **vanderpolaa.jl:** classical RK4; Z₄₀₀, the largest error, the radius shrink and the convergence table identical to the independent run; frames 1, 41, 101, 130 checked.
- **vanderpolbb.jl:** classical RK4 with bisection-located maxima; end points identical to 6 decimals; maxima match DOP853 to 1e−9; limit-cycle P, largest x and ρ match; frames 30 and 241 checked; no clamping.
- **vanderpolcc.jl:** same RK4 and event locator; maxima, end points, cycle quantities and fast/slow times match; drawing clamp only on the y′ = 0 curve; frames 40 and 301 checked.
