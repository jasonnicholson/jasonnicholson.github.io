# Review round 2: Conic Fit (batch 13, text-only)

Page: `pages/numerical-methods/conic-fit.qmd` (429 lines after the round-1 fixes). Module: `n2003/ConicFitMod.html`. The reviewer consulted the archive (module, all 13 link pages, images gr_49, 91, 93, 97, 98, 108, 110, 113, 128, 143, 158) and did not read earlier rounds' reports.

**Findings: 0 Error, 0 Misleading, 2 Minor** (unverified).

## Findings

### F1. Page text, Minor: the uniqueness theorem's hypothesis is circular

- **Location:** line 32, "Five points determine a unique conic (up to a nonzero scale factor) when they are in general position, meaning they do not force a degenerate rank condition in the fitting system."
- **True:** the definition restates the conclusion (rank 5) and gives "general position" (usually: no three collinear) a different meaning. Through any five points passes at least one conic (5 homogeneous equations in 6 unknowns); it is unique exactly when no four of the points are collinear; if no three are collinear it is also nondegenerate. Legacy Example 11 (three collinear, rank 5, unique but degenerate) illustrates it, and the page describes that case correctly at line 429.
- **Fix:** "Through any five points passes at least one conic. It is unique (up to a nonzero scale factor) exactly when no four of the points are collinear, which is when the 5×6 fitting system has rank 5. If in addition no three are collinear, the conic is nondegenerate."

### F2. Fidelity, Minor: Example 5 (legacy Example 8) never states its conic type

- **Location:** lines 341–381; the classification table (lines 422–427) covers only legacy Examples 9–12.
- **True:** $\Delta = 16 - 16 = 0$ and determinant (9) $= -2 \ne 0$, with five real points: a nondegenerate parabola, as Mathews says ("The conic is the parabola shown in Figure 8", gr_110).
- **Fix:** after the boxed equation (line 370): "Here $\Delta = B^2 - 4AC = 16 - 16 = 0$ and the determinant (9) equals $-2 \ne 0$, so the conic is a parabola."

Considered and not findings: the page's definition of nondegenerate (including real points) groups imaginary ellipses with the degenerate cases, which is non-standard but explicitly defined and consistently applied; legacy Example 12 is a circle, covered by "(or circle as a special case)"; the column order in (4) and (5) only flips the determinant's sign; the archive's own Example 7 text calls an ellipse a circle, and the page correctly says ellipse.

## Inventory (mechanical checks, rerun after the fixes)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 64 entries)

Confirmed, apart from F1–F2: the implicit-fit idea; the conic definition with $A, B, C$ not all zero; the determinant mechanism and formulas (2)–(7), each run on its example; Example 1 and the new vertical/horizontal line examples (every cofactor); Examples 2–4 (every coefficient, the boxed equations, every verification term); Example 5's equation and rows; $\Delta$; the nondegeneracy definition, the classification rule and the degenerate cases; the legacy table (point sets against gr_113, 128, 143, 158; equations; $\Delta$ values; types; the factorization of Example 11; determinant (9) values −4096, −256, 0, −25; the collinear triples); markup.

## Checks

`check.py` (sympy exact): `det_fit` expands every determinant formula; exact solves of every linear system; null spaces, $\Delta$ and determinant (9) for all five legacy five-point sets (rank 5 each). All match the page. All 12 archive examples are present with the same data.
