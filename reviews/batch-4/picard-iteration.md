# Review: Picard Iteration (batch 4, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** Calibration page: the reviewer worked on a scratch copy with two planted errors (both caught as Errors with its own computations; see the README). The planted findings are not reported; the committed page's versions of those two sentences were confirmed by the same reviewer (ledger entries 25 and 48 below: 1.107, and "widens").

Legacy archive consulted: the module HTML and the notebook `PicardIterationMod.nb` (read as text). Independent computations: SymPy redoing every Picard integral exactly; mpmath at 40–50 digits for error scans and bisection of the tolerance-interval ends; script values from the regeneration logs.

## Findings

### F1 — Page match — Minor (unverified): the Description credits Theorem 2 with a local-convergence statement it does not contain

- **Location:** `index.qmd` line 18: "If $f$ and $\partial f/\partial y$ are continuous near $(x_0, y_0)$, the iterates converge to the unique solution on a small enough interval around $x_0$ (Theorem 2)."
- **True instead:** Theorem 2 (lines 89–104) states the limit (4) with no hypothesis and no interval. The statement is true, but it is the content of the unnumbered "Interval of convergence and error bound" theorem (lines 108–122), or of Theorem 1 with that theorem. A reader following the reference finds no interval in Theorem 2.
- **Fix:** point the reference to the quantitative theorem (or number it, e.g. "Theorem 2′", and cite that).

No Fidelity findings: windows, parameter ranges, colours, iteration counts and numbering match the archive.

## Inventory (Phase 1)

4 scripts, 4 GIFs (9 frames each); all run; every GIF byte-identical to what its script produces; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; 109 entries; reviewer's verdicts)

- **Description (1–4):** the iteration matches the scripts; convergence statement mathematically confirmed, cross-reference wrong (F1); twelve examples with polynomial f confirmed; "recomputed with SymPy" a process claim (could not determine), every iterate independently confirmed.
- **Animations introduction (5–17):** confirmed: frames, Mathews' window and colours (`PlotStyle→Magenta`, red point), log error panel with tolerance 0.01, green shading, titles, `logdraw`/`ydraw` behaviour, timing (fps 1, two duplicate frames), exact rationals with asserts, 256-bit and 20001 points (Example 4 adds x = ±1), Mathews' windows for Examples 3, 4, 7, 11, his grouping in threes, Example 8 as 3-D curves, Example 12 = Example 11 shifted, Examples 1, 2, 5, 9, 10 graphless, Example 6 plots only its exact solution.
- **Case 1 (18–28):** confirmed, including the error near 0 ~ 2|x|^{n+1}/(n+1)!, intervals [−0.0050063, 0.0049938] … [−1.6059, 1.5607] reaching farther left, maximum at x = 3 for every n falling from 22.09 to **1.107** (committed page correct), Y₁(−3) = −8.5 below the window, Y₃(−3) = −7.375 inside.
- **Case 2 (29–36):** confirmed: symmetry in w = 1 − x², Y_n(−1) = 1, intervals merging at n = 4 into [−1.4396, 1.4396], y(0) − Y₄(0) = 0.0099485, n = 6 interval [−1.6743, 1.6743] and maximum 0.013766 at ±1.7, Y₁ and Y₃ below the window beyond √2 and 1.61123.
- **Case 3 (37–45):** confirmed: equal axes, the ellipse x² + 2xy + 2y² = 5, the line and parabola leaving the window, stretch [−0.0027732, 0.0027738] → [−1.4603, 1.4662] (46.6% of 2π), maximum distances 4.2112, 4.7503, 4.1738, 1.3154, 0.9051, 0.15877, 0.088749 alternating ends.
- **Case 4 (46–53):** confirmed, including the interval **widening** (committed page correct) from [−0.0622, 0.064334] to [−1.0504, 1.0093], maximum at −2 for n ≤ 3 and +2 for n ≥ 4 falling from 33.95 to 2.773, the exact solution leaving the window at x ≈ −1.26971 with y(−2) = −36.945.
- **Theorems and algorithm (54–59):** confirmed, including bound (5) and its proof sketch, Mathews' `Series[…, 100]` truncation and n_max = 6 (5 in Example 2), largest degree 31.
- **Examples 1–12 (60–106):** all confirmed, including every exact iterate, the x = 1 and x = ½ tables, the tan x agreement through x^{2n−1} and bound e/(n+1)!, Example 3's table (5.73554 at n = 4), formula (7), formulas (9) and (11) checked exactly against Examples 5–8, Mathews' y₀ typo in (8) (notebook), Example 6's alternative pair starting at (−1, 2), Example 8's distances 6.333 … 1.14251, Example 9's table, Example 10's agreement through x⁷, Examples 11–12 tables. Two process/attribution items could not be determined (50-digit arithmetic claim; Mathews' `DSolve` output, which the notebook does not store).
- **Implementation notes (107–109):** confirmed.

## Implementation checks

- **picardaa.jl** (Example 3): genuine Picard iteration in exact `Rational{BigInt}`, asserting formula (6); maximum errors 22.09, 20.59, 16.09, 10.46, 5.736, 2.698, 1.107 against the reviewer's 22.086 … 1.107; interval ends agree to every printed digit; reference 1 + x + eˣ verified; frames match.
- **picardbb.jl** (Example 4): asserts formula (7) (confirmed exactly for n = 0…6); maximum errors 1.718, 1.041, 0.7450, 0.3802, 0.1514, 0.04954, 0.01377 and the merging intervals match; reference e^{1−x²} verified; frames show the merge at n = 4.
- **picardcc.jl** (Example 7): 2-D Picard (9), asserts X₆ and Y₆; distances, locations and stretches match; reference verified; frames correct.
- **picarddd.jl** (Example 11): second-order Picard (14) as a double integral, asserts Y₆ and both initial conditions; maximum errors 33.95 … 2.773 and intervals match; reference (1 + 3x)e^{−x} verified; frames correct.

No implementation errors in any of the four scripts.
