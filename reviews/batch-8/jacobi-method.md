# Review: Jacobi Method (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: the module HTML, subroutine images gr_9–gr_11, the Example 1–6 solution images, the textbook proof PDF `jacobimethod/JacobiMethodProof.pdf` (§11.3); `a2001/Animations` has no Jacobi or eigen animation. Independent computations: own Jacobi code in Python/mpmath at 300 bits applying each rotation as a full matrix product the way Mathews' ZeroPQ does (not the page's formula (4)), run with the zeroed pair stored as an exact zero or left with its residue, in 300-bit and double precision; automatic cell-by-cell table comparison.

## Findings

### F1 — Page match — Minor (unverified): "brings the surface down to 0" — two of the zeroed entries are negative

- **Location:** `index.qmd` line 51 (Case 3 Behavior): "Each rotation brings the surface down to $0$ at the pair it zeroes".
- **True instead:** values just before each rotation are +3.000 (1,3), **−3.6985** (1,4), +1.867 (1,5), +5.027 (2,5), **−1.414** (3,4), +3.080 (3,5), +1.781 (2,3); at the negative ones the surface rises to 0. In Case 4, 16 of the 39 zeroed entries are negative.
- **Evidence:** `signs.py`.
- **Fix:** "Each rotation brings the surface to $0$ at the pair it zeroes (down from a peak or up from a dip)."

### F2 — Page match — Minor (unverified): not all five diagonal dots are "visibly off" their ticks

- **Location:** line 51: "The diagonal dots, 3.728, 8.133, 13.63, 9.166 and −3.656, are still visibly off the eigenvalue ticks".
- **True instead:** d₅₅ = −3.6565 is 0.127 from its tick at −3.7839, about 2.7 px on an axis of about 21 px per unit against a dot about 14 px wide; in `committed/jacobicc/frame_012.png` it sits on its tick. d₃₃ = 13.630 is 0.29 (about 6 px) from 13.92 and touches its tick. Only d₁₁, d₂₂, d₄₄ (errors 0.33, 0.95, 1.12) are clearly off. The quoted range 0.13–1.12 is correct.
- **Fix:** "...three of them are visibly off the eigenvalue ticks, and all are between 0.13 and 1.12 from the nearest eigenvalue."

### F3 — Page match — Minor (unverified): the cyclic run does not "meet the tolerance 10⁻¹¹" in absolute terms

- **Location:** line 372 (Example 2): "Both meet the tolerance $\epsilon = 10^{-11}$ that Mathews set."
- **True instead:** the cyclic run ends with |d₂₃| = 1.038 × 10⁻¹¹ and residuals 1.04 × 10⁻¹¹, both above 10⁻¹¹; it passes only Mathews' relative test ε√(T/n) = 8.093 × 10⁻¹¹.
- **Evidence:** `ex2.py`: final (1,4) = −5.957e-12, (2,3) = −1.038e-11; residuals 5.957e-12, 1.038e-11, 1.038e-11, 5.957e-12; threshold 8.093e-11.
- **Fix:** "Both pass Mathews' stopping test $\epsilon\sqrt{T/n} = 8.093 \times 10^{-11}$ with $\epsilon = 10^{-11}$."

No Fidelity findings.

## Inventory (Phase 1)

4 scripts, 4 GIFs (24, 25, 12, 44 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 152 entries; reviewer's verdicts)

- **Description (1–8):** confirmed (formulas zero d_pq to 5.9e-90; off² falls by exactly 2d_pq²; a zeroed entry can return; classical vs cyclic as in gr_10/gr_11).
- **Animations introduction (9–16):** confirmed (grid and surface displays as Mathews' eigenvalue movie; 300-bit arithmetic; residue below 6e-90; eight surviving stills; no archive animation).
- **Case 1 (17–31):** confirmed: 20 rotations; rotation 2 turns zeros into 0.5800 and 0.9293; largest entry falls every rotation from 3.000 to 5.107e-11; ratios 0.448–0.771 then 0.441–0.493 inside bound (8); 7.49e-4 at 17, 1.62e-7 at 20; diagonal settled from rotation 13; stop below 8.093e-11; off(D₁₉) ≈ √2 × 5.107e-11; final 1.167e-17.
- **Case 2 (32–40):** confirmed: sweep order; sweep 4 skips four pairs; rises at rotations 2, 4, 7, 10, 13; cyclic off above classical after every rotation (1.693e-11 vs 1.167e-17); diagonal settled from rotation 15.
- **Case 3 (41–51):** confirmed except 44 (F1) and 48 (F2): ε = 0.2, 7 rotations, off 12.08 → 3.716, stop at 1.600 < 1.705.
- **Case 4 (52–62):** confirmed: 39 rotations in 6 sweeps (10, 10, 10, 8, 1, 0); off per sweep; within 0.05 of a tick from rotation 18, 0.01 from 25; diagonal within 1e-23.
- **Rotations, general step, convergence, algorithm (64–85):** confirmed (module's D_j typo; θ ≥ 10¹⁹ branch; theorem (7) with S + T = 262; classical bound 5/6; stopping rules as gr_10/gr_11; Demmel–Veselić remark).
- **Example 1 (86–110):** confirmed (steps 1–2; all 105 table cells, 0 mismatches; thresholds; batch ratios; D₂₀, V and Mathews' Λ, V; residuals; double-precision residuals 6.7e-16–2.9e-15 in Mathews' form).
- **Example 2 (111–126):** confirmed except 126 (F3).
- **Examples 3–5 (127–140):** confirmed (timings; Mathews' printed matrices give 30/750/42/60 and 139/13 900/213/270); random-matrix means CND (no seed given; own seeded runs agree closely).
- **Example 6 (141–152):** confirmed (sweep thresholds, eight frames = eight archive graphs, final diagonal and errors, rerun at 1e-11).

## Implementation checks

- **jacobiaa.jl:** Mathews' JacobiClassic and ZeroPQ (exact-zero variant; Mathews mode gives the same 20 rotations); log equals the independent 300-bit run at every k; bound (8) asserted and confirmed; frames 1, 3, 21, 24 checked.
- **jacobibb.jl:** Mathews' JacobiCyclic; log equals the independent run; grey classical curve correct; frames 11 and 25 checked.
- **jacobicc.jl:** JacobiMovie with ε = 0.2; log equals the independent run; eigenvalue ticks match mp.eigsy; no clamping (z ≥ −4 asserted); frames 1, 5, 12 checked.
- **jacobidd.jl:** same with ε = 1e-11; all 39 rotations match; frames 19 and 44 checked.
