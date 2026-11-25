# Review: Jacobi and Gauss-Seidel Iteration (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `GaussSeidelMod.html` and all 8 example link pages, images gr_30–gr_323, the `a2001/Animations` listing. Independent computations: exact `fractions.Fraction` iteration, 50-digit mpmath norms, numpy eigenvalues, sympy exact solves, a float64 rerun of Example 4.

## Findings

### F1 — Page match — Minor (unverified): Case 3 states the Jacobi ratio range as if it held at the end of the run

- **Location:** `index.qmd` line 47 (Case 3 Behavior): "The Jacobi ratio still wanders between $4.437$ and $6.012$ after 10 sweeps, because the next eigenvalue of $B_J$, $-4.371$, is close in size to $5.092$."
- **True instead:** both ends of that range come from the first two sweeps (6.0122 at k = 1, 4.4367 at k = 2). The ratios for k = 1…10 are 6.0122, 4.4367, 4.5968, 4.7022, 5.6811, 4.7727, 5.2805, 4.8999, 5.2857, 4.9322; over sweeps 6–10 they lie between 4.77 and 5.29, with the swing shrinking roughly like (4.371/5.092)^k ≈ 0.86^k. The conclusion (not settled, unlike Gauss-Seidel) is correct.
- **Evidence:** `/usr/bin/python3 -I review/indep.py`, CASE 3 block, line "rJ all".
- **Fix:** "Over the 10 sweeps the Jacobi ratio ranges from $4.437$ to $6.012$, and at sweeps 9 and 10 it is still $5.286$ and $4.932$, because …".

No Fidelity findings: archive Examples 1–4 and 6 are animated, Example 5 is discussed with corrected spectral radii (Mathews' 0.702014 and 5.37399 are ρ(|B_J|), upper bounds), Example 7 explained; Case 1 is a new 2×2 system and says so.

## Inventory (Phase 1)

3 scripts, 3 GIFs (16, 30, 14 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 85 entries; reviewer's verdicts)

- **Description (1–8):** confirmed (formulas, error recursions with A = D − L − U, ρ(B) < 1 test, average factors 0.5804 vs 0.5801 and 0.3333 vs 0.3273, dominance sufficient, reordering to 5.092/24.22).
- **Animations introduction (9–18):** confirmed (one sweep per frame; slope lines; exact rationals; no archive animation; not-animated list; Example 7's M = B_J; Example 5 radii are bounds from above).
- **Case 1 (19–37):** confirmed: (2, 1); Jacobi corner moves; every GS iterate from k = 1 on line 2; ρ_J = 0.6928, B_J² = −(12/25)I; Jacobi error turns clockwise one quadrant per sweep, ×(−0.48) every two sweeps, ratios 0.6450/0.7442; GS ×(−0.48) exactly from k = 2, alternating sides; 0.02735 and 2.907e−4 after 12; GS 0.02377 after 6.
- **Case 2 (38–53):** confirmed: x* exact; Mathews' step test; GS stops at 14, Jacobi at 26; both start at 0.8521 and decrease every sweep; GS smaller every sweep; dominant eigenvalues; ratio ranges; final errors and steps (step larger than the error every sweep).
- **Case 3 (54–67):** confirmed except 61 (F1): reordered system with no dominant row; ρ 5.092 and 24.22; growth to 1.928e7 and 2.472e14; GS ratio within 0.2 % of ρ from k = 6; signs (−, +, +, −) from k = 2; exact zeros named.
- **Splitting, Examples 1–2 (68–84):** confirmed (first sweeps exact; table rows match the archive; GS faster; Example 2 residuals match the archive; the exact 5 vs Mathews' printed 5.00879 — the difference being Mathematica rounding is CND, a float64 rerun gives 5.0).

## Implementation checks

- **gaussseidelaa.jl:** true Jacobi and Gauss-Seidel; errors identical to the exact run at every k (e.g. 0.0273484 and 2.907455e−4 at k = 12); exact assertions independently confirmed; frames 1, 2, 4, 13 checked.
- **gaussseidelbb.jl:** Mathews' stopping test; 26 and 14 sweeps; final errors, steps and ρ identical; frames 2, 16, 30 checked.
- **gaussseidelcc.jl:** iterates, errors, A·x₁₀ and ρ identical to the exact run; no clamping (asserted and confirmed); frames 1, 2, 11 checked.
