# Review: Conic Fit (batch 13, text-only)

Page: `pages/numerical-methods/conic-fit.qmd` (382 lines). Module: `n2003/ConicFitMod.html` ("Conic Curve Fit"), example folder `n2003/conicfit/ConicFitMod/` (13 link pages). The reviewer consulted the archive (module, all 13 link pages, point-set images gr_98, gr_113, gr_128, gr_143, gr_158). All arithmetic on the page is correct: every coefficient, verification row, Δ and point set.

**Findings: 1 Error, 1 Misleading, 2 Minor.** Both the Error and the Misleading finding were confirmed by an independent check.

## Findings

### F1. Page text, Error: the classification rule leaves out the nondegeneracy hypothesis

*Independent check: **confirmed** (Error): stated unconditionally, with simple counterexamples. The checker notes the Δ > 0 bullet is true as written; the Δ < 0 and Δ = 0 bullets are not, and the rule also tacitly needs $A, B, C$ not all zero.*

- **Location:** lines 364–369, the "Quick Classification Rule" (Δ<0 ellipse or circle; Δ=0 parabola; Δ>0 hyperbola "including intersecting-line degeneracies").
- **True:** the sign of $B^2-4AC$ decides the type only for a nondegenerate conic ($\det\begin{pmatrix}A&B/2&D/2\\B/2&C&E/2\\D/2&E/2&F\end{pmatrix} \ne 0$ and real points). Counterexamples: $x^2-1$ (Δ=0, parallel lines), $x^2$ (double line), $x^2+1$ (Δ=0, empty), $x^2+y^2$ (Δ=−4, a point), $x^2+y^2+1$ (Δ=−4, empty).
- **Fix:** begin "For a nondegenerate conic (the 3×3 determinant above is nonzero and the curve has real points):"; add that degenerate cases are intersecting lines (Δ>0), parallel or coincident lines or no points (Δ=0), a single point or no points (Δ<0); drop the hyperbola bullet's parenthetical.

### F2. Page text / Fidelity, Misleading: legacy Example 11 is labelled "Hyperbola" but is a pair of intersecting lines

*Independent check: **confirmed** (Misleading, close to Error). The 5×6 system still has rank 5, so the conic is unique; it is forced to be degenerate because (3,5), (5,4), (7,3) are collinear, as are (1,1), (5,4), (9,7).*

- **Location:** line 379, "| 11 | $(1,1),(3,5),(5,4),(7,3),(9,7)$ | $3x^2+2xy-8y^2-38x+54y-13=0$ | Hyperbola ($\Delta=100$) |"
- **True:** the equation and Δ are correct, but it factors as $(x+2y-13)(3x-4y+1)=0$ (3×3 determinant 0): two lines crossing at (5, 4). Mathews' Solution 11 says "The conic is the pair of intersecting lines shown in Figure 11" (`ConicFitMod_lnk_12.html`).
- **Fix:** "Degenerate: intersecting lines $(x+2y-13)(3x-4y+1)=0$ ($\Delta=100$)".

### F3. Page text, Minor (unverified): the Definition admits lines as conics

- **Location:** line 27, "with coefficients not all zero." **Fix:** "with $A$, $B$, $C$ not all zero."

### F4. Fidelity, Minor (unverified): archive Examples 2 and 3 (vertical and horizontal lines) dropped

- **Archive:** lines through (3,1) and (3,4), and through (1,4) and (5,4). The determinant (2) gives $-3(x-3)=0$ and $4(y-4)=0$; the vertical case is where the page's two-point slope form divides by zero, the case showing why the determinant form is useful. **Fix:** a short example or remark applying (2) to (3,1), (3,4).

## Inventory (mechanical checks)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 48 entries)

Confirmed: exact interpolation by implicit fit; five points in (rank-defined) general position determine a unique conic (rank 5 for all legacy sets); determinant formulas (2)–(7), each run on its example; Example 1 (slope −1/4, $x+4y-17=0$, rows); Example 2 ($D, E, F = -67/7, -65/7, 208/7$, both forms, every term of every row); Example 3a ($7x^2-61x-20y+134=0$) and 3b ($7y^2-45y-6x+74=0$), every term; Example 4 ($C=8, D=-33, E=-60, F=142$ with $A=3$; a real ellipse); legacy Example 8 ($2x^2-4xy+2y^2-x-y+4=0$, a nondegenerate parabola), 9 (real ellipse, Δ=−256), 10 (hyperbola, Δ=64, nondegenerate), 12 (the circle $(x-5)^2+(y-5)^2=25$); all point sets against the archive images; every equation checked at all five points; markup.

Not confirmed: line 27 (F3); lines 366–368 (F1); line 379's label (F2); archive Examples 2–3 (F4).

## Checks

Every determinant formula run as written (symbolic first row, `Matrix.det()`) and every linear system solved directly; results match the page (table in the reviewer's report; e.g. legacy 11's determinant = 400·(x+2y−13)(3x−4y+1), 3×3 det 0). Nothing undetermined.
