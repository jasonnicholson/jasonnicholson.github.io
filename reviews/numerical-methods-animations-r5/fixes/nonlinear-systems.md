# Fix record: nonlinear-systems

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/nonlinear-systems/fix/check.py` (run with `/usr/bin/python3 check.py`; sympy + 50-digit mpmath).

## Findings

### F1 — Minor — fixed
- Reproduced: `check.py` builds the Newton map G_N(X) = X − J⁻¹F(X) for the page's system symbolically and evaluates its Jacobian at both solutions (50 digits): all four entries ≤ 3.1e-51 at each root, i.e. zero, as theory gives (G_N′(X*) = I − J⁻¹J = 0). Iterating that map (Newton) gives errors 0.445 → 0.237 → 0.0237 → 2.92e-4 → 4.57e-8 → 1.12e-15 (Case 1 start) with e_{k+1}/e_k → 0 and e_{k+1}/e_k² → 0.535: quadratic, not linear. So the table cell "Linear (when it converges)" is contradicted by Mathews' Example 4, which the page itself names. For contrast, Mathews' Example 1 fixed-point form G = ((2x²−2y³+1)/4, (−x⁴−4y⁴+8y+4)/12) (checked: G − X = (f₁/4, −f₂/12)) has spectral radius ρ = 0.16026 at Solution 1, and iterating it from (0, 1) gives e_{k+1}/e_k → 0.1603: linear with factor ρ.
- Change: `index.qmd` line 63, Comparison table, Fixed-Point column. Before: "Linear (when it converges)". After: "Linear when 0 < ρ < 1, where ρ is the spectral radius of the Jacobian of **G** at **X*** (the error eventually shrinks by a factor of about ρ per step); superlinear when ρ = 0, as for Newton's method written as a fixed-point iteration, whose **G** has zero Jacobian at **X***". The review's suggested wording "faster only if that Jacobian vanishes" was not used: the exact condition for superlinear (R-)convergence is ρ = 0, which a nilpotent nonzero Jacobian also satisfies, so "only if the Jacobian vanishes" would be too strong. No "only" is used.
- Check: `check.py` output quoted above; `quarto pandoc index.qmd -t html` renders the table with 5 rows (header + 4) and the inline math in the cell.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.63 | "Linear when 0 < ρ < 1 … error eventually shrinks by a factor of about ρ per step" | Standard local theory (lim sup ‖e_k‖^{1/k} = ρ for typical starts). Illustrated on this system: `check.py` → Example 1 form, Solution 1: eigenvalues 0.061142, 0.16026; e_{k+1}/e_k = 0.1609, 0.1602, 0.1603, … 0.1603 | yes |
| index.qmd l.63 | "superlinear when ρ = 0" | ρ = 0 ⇒ lim sup ‖e_k‖^{1/k} ≤ ρ + ε for every ε > 0 ⇒ R-superlinear (standard) | yes |
| index.qmd l.63 | "Newton's method written as a fixed-point iteration, whose G has zero Jacobian at X*" | `check.py` → Newton-map Jacobian at Solution 1: [2.6e-52, 1.5e-52, −5.3e-55, 1.7e-51]; at Solution 2: [3.1e-51, 1.3e-51, 6.9e-52, −2.4e-51] (zero at 50 digits); Newton errors quadratic (e_{k+1}/e_k² → 0.535 and 0.96) | yes |

## Scripts and GIFs
- No script changed, no GIF regenerated (the finding is in the Description table only; the review found both GIFs byte-identical to their scripts' output).
- `git status --short -- pages/numerical-methods/nonlinear-systems` → ` M pages/numerical-methods/nonlinear-systems/index.qmd` only.

## Legacy archive
Consulted: `n2003/NewtonSystemMod.html` (text, tags stripped). It contains Example 1 (fixed-point iteration on this system), Example 2 (Newton), Example 3 (equivalence of the two systems) and Example 4 ("Show how Newton's method is in reality a fixed point iteration"), matching the page's not-animated list. The formulas are in images; the Example 1 form used above is the one the round-5 review read from them, and it was verified symbolically to have the same fixed points as the page's system. The archive's text states no convergence rate for fixed-point iteration; the new cell follows the mathematics.

## Notes
- Side observation, not put on the page: in Mathews' Example 1 form, Solution 2 is repelling (ρ = 2.09, row sums 2.05 and 2.18), so that fixed-point form cannot find Solution 2; from (1.5, −0.5) it goes to Solution 1 (error to Solution 2 → 1.98, the distance between the solutions).
- The new cell covers 0 < ρ < 1 and ρ = 0; it says nothing about ρ = 1 (where a convergent iteration can be sublinear). The old "(when it converges)" qualifier was dropped because the conditions on ρ replace it.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false cell "Linear (when it converges)" is gone (index.qmd line 63). The new cell says the rate is linear when 0 < ρ < 1 (ρ = spectral radius of the Jacobian of G at X*), with the error eventually shrinking by about ρ per step, and superlinear when ρ = 0, "as for Newton's method written as a fixed-point iteration, whose G has zero Jacobian at X*". I checked each part myself (scripts `rates.py` and `rates2.py` in this folder, mpmath at 50–60 digits):
  - Newton map N(X) = X − J⁻¹F(X) on the page's system. The central-difference Jacobian of N at both roots, (0.0617701, 0.7244905) and (1.5560975, −0.5756508), has norm about 2e-40. That is zero to working precision, so ρ = 0 holds. Iterating N from (0.5, 0.8) gives errors 0.445, 0.237, 0.0237, 2.92e-4, 4.57e-8, 1.12e-15, 6.7e-31, with measured orders 2.18, 2.08, 2.04, 2.02. So the convergence is superlinear (in fact quadratic). This agrees with the page's Case 1 numbers and with Newton's "Quadratic" column, so the row is consistent.
  - Linear rate ≈ ρ when 0 < ρ < 1. I used the chord fixed-point map G(X) = X − J(X₀)⁻¹F(X) from (2, −1). Its ρ(DG(X*)) is 0.5585, a complex pair 0.5446 ± 0.1239i. The per-step error ratio oscillates between about 0.50 and 0.56. The geometric-mean ratio over steps 100–199 is 0.563 ≈ ρ, so "about ρ per step" holds as an average. For a Jordan-block test with ρ = 0.5, the ratios are 0.59 → 0.524 → 0.505 → 0.503, which tends to ρ.
  - With ρ = 0 and a nilpotent Jacobian that is not zero (G = (y + x², x² + y²) at 0), the errors 0.14, 0.11, 0.034, 0.014, 1.4e-3, 1.9e-4, 2e-6, 3.5e-8, 3.8e-12 still fall superlinearly. So "superlinear when ρ = 0" holds beyond the Newton example as well.
  - Side check: the naive form x = (1 + 2x² − 2y³)/4, y = (4 − x⁴ − 4y⁴)/4 has ρ = 1.52 and ρ = 2.58 at the two roots. It does not converge (it falls into a 2-cycle), so the new cell is right not to promise convergence for every G. I could not read Mathews' exact Example 1 G, because the archive's equations are images. The cell does not depend on it.
- No script or GIF was involved. The finding was text-only.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.63, Fixed-Point cell | "Linear when 0 < ρ < 1, ρ = spectral radius of the Jacobian of G at X*" | Chord-map test: measured mean ratio 0.563 vs ρ 0.5585; Jordan test: ratio → 0.5 = ρ | Correct |
| same | "(the error eventually shrinks by a factor of about ρ per step)" | True asymptotically and on average. When the eigenvalues are complex the per-step ratio oscillates (0.50–0.56 for ρ = 0.5585); "about" and "eventually" cover this | Correct |
| same | "superlinear when ρ = 0" | Newton map orders 2.18 → 2.02; nilpotent test also superlinear | Correct |
| same | "as for Newton's method written as a fixed-point iteration, whose G has zero Jacobian at X*" | ‖DN(X*)‖ ≈ 2e-40 at both roots of the page's system (nonsingular J there) | Correct |
| same | Markdown/math rendering | Rendered the Comparison section with pandoc --mathjax. All five math spans parse, `X^*` does not trigger emphasis, and the table stays intact (3 columns) | Correct |

### New problems

None. This rests on the following:
- The only change is one table cell (`git diff --numstat`: 1 line in, 1 line out of index.qmd).
- Every claim in that cell was checked numerically, as above.
- The cell is consistent with line 38 (convergence iff ρ < 1 from nearby starts) and with the Newton column ("Quadratic").
- The pandoc render is clean.

The only cosmetic point, not a defect: the cell is now much longer than its neighbours in an equal-width three-column table.

### Reproducibility and conventions

- No script or GIF in the page folder changed (`git diff --quiet HEAD` on *.gif and *.jl is clean). There was nothing to regenerate or compare.
- Conventions still hold:
  - Description comes before Animations.
  - Each case (1 and 2) has a source link and a GIF embed.
  - The alt text is descriptive and unchanged.
  - The page has no code blocks (0 code fences).
- Files outside the page folder: this fix's diff touches only `pages/numerical-methods/nonlinear-systems/index.qmd`. The working tree also has changes in other page folders (broydens-method, laurent-series, maclaurin-and-taylor-series, mullers-method, runge-kutta-fehlberg-method, secant-method) and untracked review folders. They are not part of this page's diff and look like other pages' round-5 fixes, but I cannot attribute them from here.

**Final status:** committed
