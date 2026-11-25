# Review: Linear Programming and the Simplex Method (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** (The reviewer's other finding, that the section index links the deleted flat `linear-programming-simplex-method.qmd`, is withdrawn: section-index links are changed in each page's "Add animations" commit.)

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `LinearProgrammingMod.html`, Links lnk_1–lnk_11, and the images, enlarged 2–4× to read the numbers. Independent computations: a Fraction-exact simplex with selectable tie-breaks, sympy vertex enumeration and face/edge counts, SciPy `linprog` (HiGHS) for every optimum. The reviewer re-derived Example 6 from Mathews' data (second constraint ≤ 300; gr_452–455) and confirmed the page's degenerate second pivot and the optimum 1324 at (96, 44, 44, 16).

## Findings

### F1 — Page match (Description and Definition box) — Minor (unverified): the feasible region is called a polygon or polytope without the boundedness condition

- **Location:** line 12, "The region is a convex polygon in two variables and a convex polytope in more"; the Definition box (lines 84–92), "The feasible set $\mathcal{R} = \{\ldots A\mathbf{x}\le\mathbf{b}, \mathbf{x}\ge 0\}$ is a convex polytope (or a convex polygon in two variables)."
- **True instead:** in the usual sense a polygon or polytope is bounded; {Ax ≤ b, x ≥ 0} can be unbounded (e.g. x − y ≤ 1, x, y ≥ 0) or empty. The page's own theorem (line 97) adds "nonempty and bounded" as a hypothesis. Mathews uses "polytope" for any finite intersection of half-spaces, but the page does not give that definition. All four regions on the page are bounded.
- **Fix:** "a convex polyhedral set (a convex polygon or polytope when it is bounded)", or give Mathews' definition explicitly.

No Fidelity findings.

## Inventory (Phase 1)

4 scripts, 4 GIFs (28, 14, 20, 24 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 108 entries; reviewer's verdicts)

- **Description (1–12):** confirmed except 5 (F1).
- **Animations introduction (13–27):** confirmed, including the round-1 wording now in place: the colour key per case (Cases 2 and 3; Case 1's blue line through the maximum and orange chord; Case 4 without level lines); Example 6's degenerate second pivot and optimum 1324.
- **Cases 1–4 (28–82):** confirmed (level-line sweep values and cuts; tableaux entry by entry against Mathews' gr_153/164/171/195; both Example 3 paths and Mathews' printed ratios 18, 6, 8, 13; polyhedron 8/12/6 and the three pivots to 141).
- **Background and theory (83–86):** confirmed except 84 (F1).
- **Examples 1–3 (87–106):** confirmed (Example 1's word statement vs input, 646 at (17, 23); all tables; 3(b) objective and Mathews' 10x + 15y solution).
- **Page frame (107):** confirmed.

## Implementation checks

- **simplexaa.jl:** level-line sweep with exact cuts; spot-checked cut points; frames 3, 19, 21, 28 checked.
- **simplexbb.jl:** tableau simplex (Dantzig, minimum ratio, no ties); tableaux equal own and Mathews'; the frames-per-pivot comment (round-1 fix) is accurate; 14 frames.
- **simplexcc.jl:** first-column tie rule as Mathews; both paths and ratios match; edge names correct; 20 frames.
- **simplexdd.jl:** exact polyhedron; path, ratios and final tableau match Mathews' gr_419–421; 24 frames.
