# Review: Logistic Curve (batch 6, round 1)

**Findings: 0 Error, 1 Misleading (independently confirmed), 1 Minor (unverified).**

The reviewer also reported that the section index links the deleted flat `logistic-curve.qmd`. The director withdraws it: section-index links are changed in each page's "Add animations" commit, and the review ran from the working tree before that commit.

Legacy archive consulted: `LogisticEquationMod.html`, its four solution pages, the surviving images gr_1, gr_79, gr_81, gr_82, `LogisticEquationProof.html`, the `a2001/Animations` listings. Independent computations: mpmath at 40–80 digits (data linearization and the L sweep; Gauss–Newton with a numerically differentiated Jacobian; Newton on ∇E; Hessian; the L = 800 profile fit), DOP853 ODE solves, sympy proofs of every formula.

## Findings

### F1 — Page match — Misleading (confirmed by an independent checker): the Hessian eigenvector does not show that "E changes little when L changes"

- **Location:** `index.qmd` line 378 (Example 5, Verification): "The eigenvector of the very small first eigenvalue points almost exactly along the $L$ axis, so $E$ changes little when $L$ changes: the data determine $L$ only weakly."
- **True instead:** the eigenvector is (0.9999284, 0.011966, 9.09e-6) in (L, c, a). It is "almost along L" only because the coordinates are unscaled: per unit of L, c changes by 0.01197, and c/L = 0.01132, so L and c change in nearly the same proportion (the softest direction of the Hessian rescaled by diag(L, c, a) is (0.668, 0.708, −0.230)). Changing L alone, with c and a held at the minimizer, raises E quickly: ∂²E/∂L² = 1.2776; ΔL = ±1 gives E = 102.699, ±10 gives 165.94, ±50 gives 1699.0. Along the eigenvector, ΔL = +10 raises E only to 102.094. What supports "the data determine L only weakly" is the profile: with L fixed and c, a refitted, E = 103.116 (L = 600), 102.756 (700), 106.505 (800).
- **Evidence:** reviewer `check2.py`, `check4.py` (eigenvalues 6.78217e-4, 819.67, 1.10638e9); checker `check/c.py` (50-digit mpmath, same minimizer and eigenpairs).
- **Fix:** "The eigenvector of the very small first eigenvalue is dominated by L but also moves c, and slightly a: raising L by 10 along it (c up by 0.120, a by 9.1×10⁻⁵) raises E only from 102.060 to 102.094, whereas raising L by 10 with c and a fixed raises E to 165.9. So once c and a are allowed to adjust, the data determine L only weakly; fixing L = 800 and choosing c and a by least squares raises E only from 102.06 to 106.50 million²."

### F2 — Page match — Minor (unverified): the sign of the correlation coefficient

- **Location:** line 38 (Case 1 Behavior): "the correlation coefficient of the transformed points, $0.988$ at $L = 300$, is at least $0.9978$ from $L = 500$ on."
- **True instead:** the slope is negative, so r is negative: r = −0.988063 at L = 300, and between −0.997866 (L = 1200) and −0.9999 for L = 500…1200. The magnitudes are right.
- **Evidence:** `check1.py`: "corr 300 -0.988063 min |corr| L>=500 0.997866".
- **Fix:** "the size of the correlation coefficient, |r| = 0.988 at L = 300, is at least 0.9978 from L = 500 on" (or quote r = −0.988 and r ≤ −0.9978).

No Fidelity findings: Examples 1–4, the caveat and Remarks 1–3 are represented; Example 5 and Case 3 are labelled new; every checkable archive value agrees (L = 800 "for illustration", the 1990 entry 249438712, P(2000) = 282124631, 0.373687, 0.132455 %).

## Inventory (Phase 1)

3 scripts, 3 GIFs (71, 64, 57 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6):** confirmed (ODE residual 0; rises from 0 toward L for a < 0, c > 0; linearization; 281.75 within 0.13 %).
- **Animations introduction (A1–A7):** confirmed (no Mathews animation; lost plots; 256-bit arithmetic).
- **Case 1 (C1.1–C1.21):** confirmed except C1.9 (F2): L = 300 residual pattern; E = 665.3, f(2000) = 252.0 (10.68 % low); E falls to 102.13 at L = 660 then rises to 129.9; all above the true minimum 102.06; finer grid 655.3/102.126; f(2000) increases with L, crossing 282.1246 near 820.0 with E = 108.2; L = 800 values; 1.36 % at 655.3.
- **Case 2 (C2.1–C2.19):** confirmed: undamped Gauss–Newton; overshoot to 596.9, E 107.06 → 206.85, largest residual 5.041 → 7.637; back to 650.84/102.72; 8.6e-7 at k = 3; alternation; linear rate 0.039–0.042 for |L − L*| and its square 0.0017 for E − E_min, to 1.550e-12 and 8.300e-28.
- **Case 3 (C3.1–C3.17):** confirmed: r = 0.0160987; f₁(1900) = 78.4243; concavity; t* = 1968.24, 2037.86, 2127.57, 2214.86; rL/4 = 3.220; y₀ = 600 concave down, (3) gives 1831.76; 638.0 and 788.4 at 2300.
- **Theory (T1–T12):** confirmed by sympy (solution, monotonicity, inflection, symmetry, Mathews' form).
- **Linearization and Examples 1–4 (E1–E24):** confirmed (every table entry; A, B, c; E = 107.06; RK8 agreement 4.56e-10 < 5e-10; 0.373687 and 0.132455 %; L-table; smallest E at L = 700).
- **Example 5 (G1–G18):** confirmed except G11 (F1): table k = 0…5; f₂; Newton agreement to 20 digits; Hessian eigenvalues; L = 800 profile 106.50; f₂(2000) = 278.3600, 1.3344 % low; fits better, predicts worse; breakdown from L ≥ 1100.

## Implementation checks

- **logisticaa.jl:** closed-form normal equations; A, B, c, E, f(2000) match the independent fit for every L; E_min and f₂(2000) match Newton to 20 digits; frames 1, 30, 71 checked; nothing clamped.
- **logisticbb.jl:** undamped Gauss–Newton (not LM, no line search); hand-coded partials checked by a numerical Jacobian; every iterate reproduced; reference after 80 steps equals Newton's root; frames 1, 6, 64 checked.
- **logisticcc.jl:** exact solution (2); r, y₀, rL/4, t* and y(2300) match; frames 1, 17, 57 checked.
