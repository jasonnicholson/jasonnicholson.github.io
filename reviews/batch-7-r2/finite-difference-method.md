# Review: Finite Difference Method for the wave equation (batch 7, round 2)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `FiniteDifferencePDEMod.html`, link pages lnk_1–lnk_4, images gr_1–gr_81 (gr_82–gr_94 are missing), `FiniteDifferencePDEProof.pdf`, the `a2001/Animations` folder. Independent computations: Example 1 in float64 (with a random-second-row test and the r = 0.5 refinement), Example 2 in exact rational arithmetic, Example 3 in 40-digit mpmath.

## Findings

### F1 — Page match — Minor (unverified): it is the grid diagonals, not the grid lines, that lie on the characteristics

- **Location:** `index.qmd` line 202: "When $r = 1$, that is $k = h/c$, the grid lines line up with the characteristics $x \pm ct = \text{const}$, and the method becomes exact."
- **True instead:** the grid lines are x = const and t = const; with r = 1 it is the cell diagonals that lie on x ± ct = const, since x_i ± ct_j = (i − 1)h ± (j − 1)h. Case 2 says this correctly ("their paths run along the diagonals of the grid"), and the Case 2 frames show it.
- **Fix:** "…the diagonals of the grid line up with the characteristics $x \pm ct = \text{const}$…".

### F2 — Fidelity / page match — Minor (unverified): Example 3's grid is presented as Mathews' without the hedge in two places

- **Location:** line 24 (Animations introduction): "All three cases use Mathews' grid, $n = 11$ and $m = 21$"; line 248 (Algorithm): "In all three examples below … the grid has $n = 11$ columns and $m = 21$ rows."
- **True instead:** the archive lost the lines of Example 3 that state its grid (lnk_4 references gr_82–gr_94, none of which exist); only the rectangle 0 ≤ t ≤ 1.02 survives (gr_80). The page says so at line 364 and the script header calls it a reconstruction, but the two sentences above read as Mathews' grid for all three examples.
- **Fix:** line 24: "Mathews' grid of Examples 1 and 2, $n = 11$ and $m = 21$ (kept for Example 3, whose grid the archive has lost)"; optionally a similar clause at line 248.

## Inventory (Phase 1)

3 scripts, 3 GIFs (26 frames each); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 127 entries; reviewer's verdicts)

- **Description (1–8), Animations introduction (9–17):** confirmed (12's "Mathews' grid" wording is F2).
- **Case 1 (18–28), Case 2 (29–36), Case 3 (37–52):** confirmed, including the round-1 wording now in place in the Case 3 alt text (|c₉|, with c₉ alternating in sign).
- **Definition, derivation, starting values, stability (53–72):** confirmed, including the round-1 wording "Suitable implicit methods … have no stability restriction".
- **d'Alembert and the theorem (73–79):** confirmed, including the round-1 corrections now in place: the boundary conditions hold when G(z) = −F(−z) with F of period 2a (G = F odd as a special case); the proof's F and G labels follow (10). Entry 76's wording is F1.
- **Algorithm (80–82), Examples 1–3 (83–127):** confirmed (every table entry; Mathews' three slips; r = 0.5 refinement ratios; Example 3 tables); entry 82 for Example 3 is F2.

## Implementation checks

- **fdpdeaa.jl:** scheme (6) with (8) or (7); every value identical to the independent run; reference checked by sympy; frames 1, 4, 21 checked.
- **fdpdebb.jl:** scheme (6) at r = 1; exact rational agreement with d'Alembert; corner paths correct; frames 7, 11, 21 checked.
- **fdpdecc.jl:** scheme (6) at r = 1.02; c₉, ratios and errors match 40-digit values; nothing clamped; frames 1, 13, 21 checked.
