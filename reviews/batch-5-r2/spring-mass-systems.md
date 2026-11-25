# Review: Spring-Mass Systems (batch 5, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `SpringMassMod.html`, Links lnk_1–lnk_11, the surviving images for Examples 2, 3, 5, 6, 7, 9, 10 and the problem statements of all ten examples. Independent computations: sympy for all ten examples (polynomials, eigenvalues, ρ, residuals, energy, initial-condition formulas, frequency ratios), SciPy DOP853 and RK45 integrations.

## Findings

### F1 — Fidelity / page match — Minor (unverified): Mathews' own summary of the roots drops a factor 2

- **Location:** `index.qmd` line 415 (warning box "Mathews' first frequency in Example 5"): "Mathews' roots, eigenvalues and printed eigenfrequencies are correct, but the ω₁ he assigns …"
- **True instead:** Mathematica's `Solve` output is correct (`SpringMassMod_gr_164.gif`: r → ±2i√(1+√2), ±i√(2(2−√2))), but his own summary line right after it (`gr_165`) reads "r = ±i√(1+√2), ±i√(2(2−√2))", dropping the factor 2; that slip is what carries into his ω₁ = √(1+√2) (`gr_166`, `gr_167`). His eigenvalues and eigenfrequencies (`gr_171new`) are correct, as the page says.
- **Evidence:** archive images gr_164, gr_165, gr_166, gr_171new (montage `review/arch/ex5a.png`); sympy: s = −4 − 4√2, −4 + 2√2, so ω₁ = 2√(1+√2) ≈ 3.107548.
- **Fix:** "Mathews' computed roots (the `Solve` output), eigenvalues and printed eigenfrequencies are correct, but his summary of the roots drops the factor 2 (r = ±i√(1+√2)), and the ω₁ he assigns and uses … is √(1+√2) …".

## Inventory (Phase 1)

2 scripts, 2 GIFs (139 and 179 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 80 entries; reviewer's verdicts)

- **Description (1–8), Animations introduction (9–23):** confirmed (13: DOP853 agreement within 1e−11 holds for atol ≤ 1e−13; the page does not state atol).
- **Case 1, Example 6 (24–31), Case 2, Example 5 (32–44):** confirmed, including the round-1 wording now in place in Case 2: Mathews' first-mode pictures use ω₁ ≈ 1.554 and ratio 1.396, so in them the masses move the same way.
- **Theory (45–60):** confirmed, including the round-1 wording now in place: "in every surviving example except Example 5" the first picture shows opposite directions, and Example 5's pictures show the same direction although his text says opposite (60: rtol 1e−11 agreement holds for atol ≤ 1e−12).
- **Examples 1–10 (61–76):** confirmed except the "roots … correct" clause in 66 (F1).
- **Long-term section (77–80):** confirmed.

## Implementation checks

- **springaa.jl:** closed-form solution (4); ω, ρ identical to sympy; 2π-periodicity 2.0e−14; DOP853 agreement 3.7e−12; frames 1, 50, 121 checked.
- **springbb.jl:** closed form with the corrected ω₁; values identical; extrema within the continuous ones; DOP853 agreement 8.5e−12; frames 1, 80, 161 checked.
