# Review: Successive Over-Relaxation (SOR) (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `SORmethodMod.html`, Links lnk_2–lnk_4, images gr_51–gr_158 as listed in the reviewer's notes, the `a2001/Animations` listing. Independent computations: Example 1 in exact `Fraction` arithmetic and numpy spectral radii; the ω sweep in double precision and in 40-digit mpmath; Example 2 rebuilt from the boundary values, solved with sympy, iterated exactly, and the characteristic polynomial of T_{5/4} factored.

## Findings

### F1 — Page match — Minor (unverified): "each legend gives the spectral radius ρ" does not hold for Case 2

- **Location:** `index.qmd` line 26 (Animations introduction): "…and each legend gives the spectral radius $\rho$ of that method's iteration matrix."
- **True instead:** true for Cases 1 and 3. In Case 2 (`sorb.jl` lines 97–98) the legend entry reads only "slope ρ(ω)ᵏ"; ρ(ω) is given in the panel titles (e.g. "ρ(ω) = 0.5279 at optimal ω = 1.528", frame_030) and drawn as the purple curve.
- **Evidence:** `sorb.jl` lines 97–118; committed frames sorb/frame_001, frame_030, frame_042.
- **Fix:** "each legend (in Case 2, each panel title) gives the spectral radius ρ…", or limit the clause to Cases 1 and 3.

Observations, not findings:
- Mathews' printed boundary array (gr_154) has 120 in the corner where 180 meets 80; the average is 130, which the page draws "as in Mathews' remark". His 120 looks like a slip; the page follows his stated rule.
- "The number of sweeps follows [ρ]" (line 42) has one small inversion: ρ(1.65) = 0.650 < ρ(1.50) = 0.6513 but 36 > 34 sweeps.

## Inventory (Phase 1)

3 scripts, 3 GIFs (24, 42, 14 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D10):** confirmed (SOR formula, T_ω, Kahan bound, Ostrowski–Reich, ρ(T₁) = ρ_J² (0.904508; 0.5), ω_opt = 1.5278640 with ρ = ω_opt − 1).
- **Animations introduction (I1–I12):** confirmed except I4 (F1): infinity norms; exact rationals in Cases 1 and 3; Case 2 doubles give the same sweep counts as 40 digits for all 39 ω; Mathews' Euclidean errors 1.40545, 0.853708, 0.0494849; no archive animation.
- **Case 1 (C1.1–C1.18):** confirmed: first-sweep overshoot (−0.5, −0.1427); SOR ahead from k = 2; P10 equals Mathews' gr_68; errors at 10 and 20; GS falls every sweep, ratio → 0.9045; Jacobi changes only at even sweeps from k = 4; SOR rise 8 → 9 (0.04102 → 0.04371); average ratio 0.6488 vs 0.6513.
- **Case 2 (C2.1–C2.14):** confirmed: ρ falls from 0.9949 to 0.5279 then ρ = ω − 1 to 0.95; sweep counts 2685, 138, 80, 34, 26 (fewest, at ω_opt), 28, 272; rises 0 for ω ≤ 1.45, at most one for 1.50–1.60, then 4 … 115 (115 of 272 at 1.95); all eigenvalues of modulus ω − 1 above ω_opt, eight complex.
- **Case 3 (C3.1–C3.15):** confirmed: grid and boundary reproduce Mathews' A and B; corners averaged; P10 equals gr_128; p* exact; errors 2.895e-4, 3.234, 0.1385; GS exactly halved from k = 2; Jacobi halved every two sweeps; ω = 1.25 above ω_opt = 1.172; all nine eigenvalues of T_{1.25} of modulus ¼ (exact factorization); SOR falls every sweep, average 0.2763.
- **Residual section and worked example (R1–R14):** confirmed (Mathews' text says ω = 1.25 while his command and iterates use 1.5; with 1.25 the error would be 0.1887; worked step 1; printed iterates; verification table; errors 0.708008, 0.379622, 0.02401).

## Implementation checks

- **sora.jl:** true Jacobi and in-place SOR in `Rational{BigInt}`; errors, x₁₀ and ρ identical to the independent run; frames 1, 2, 11, 24 checked; nothing clamped.
- **sorb.jl:** in-place tridiagonal SOR; all 39 (ω, sweeps, ρ) lines equal the double and 40-digit runs; runs past 150 sweeps leave the window with an honest legend; frames 1, 30, 42 checked.
- **sorc.jl:** same functions on Mathews' A and B, ω = 5/4; sequences and p₁₀ match; grid placement asserted and independently rebuilt; frames 1, 6, 14 checked.
