# Fix record: least-squares-polynomials

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/least-squares-polynomials/fix/`

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: `grep -n -E 'Example|Exploration' n2003/LeastSqPolyMod.html` gives Examples 1–8 (lines 78, 89, 100, 111, 122, 133, 154, 203). There are no Explorations. I matched each example to its solution page by stripping the main page to the sequence of `Example N` and `lnk_N` tokens: Example k → `LeastSqPolyMod_lnk_{k+1}.html`, and `lnk_1` is the module's title/credits page. Example 8 (`lnk_9`) reads: "Use the linear least squares method to find the polynomial curve fit of degree = 3 for the points …". Its solution builds the matrices F and Y, solves FᵀF C = FᵀY and compares the result with Mathematica's `Fit`. The page's sentence listed only Examples 1, 6 and 7 as not animated, so the finding holds.
- Correction to the review's evidence: the review says Example 8's data image is missing (gr_121). gr_121 is the solution's code image, and it is missing. The statement's data image is gr_120, and it is present. `md5sum` of gr_38, gr_52, gr_60, gr_68 (the data images of Examples 2–5) and gr_120 all give `d472f286636608f8f330dc7bc9bba21c`, so they are byte-identical. Viewed at 3× (`topng.jl`), gr_120 reads (−4.5,0.7), (−3.2,2.3), (−1.4,3.8), (0.8,5.0), (2.5,5.5), (4.1,5.6). Example 8 is therefore the degree-3 fit to the same six points, the same problem as Example 3. Its solution's own data entry (gr_121) is missing, so I could not check that the solution's input matches the statement.
- Change: `index.qmd` line 41: "…, and Example 7, which fits … polynomial wiggle, are not animated here." → "…, Example 7, which fits … polynomial wiggle, and Example 8, which recomputes the cubic fit to the same six points from the module's general linear least-squares theorem, are not animated here."
- Check: `/usr/bin/python3 -I ex8check.py` builds the general linear-least-squares matrix F with basis xʲ, j = 0..3, on the six points and solves FᵀF C = FᵀY exactly in sympy. Output: `rank F = 4`, coefficients 4.6686264, 0.48939249, −0.074238666, 0.0026765941. These agree with the page's Case 2 cubic (4.66863, 0.48939, −0.07424, 0.00268). Because F has full rank, the solution is unique, so "recomputes the cubic fit" is accurate. Placement (R3-D): the sentence is already in the Animations introduction, after the "Julia source scripts…" line and before Case 1, so it did not need to move.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.41 | "Example 8" exists and is omitted from the page | `grep -n -E 'Example\|Exploration' LeastSqPolyMod.html` → Examples 1–8. The page animates only degrees 2–5 of Examples 2–5 (four cases). | yes |
| index.qmd l.41 | "recomputes the cubic fit" | lnk_9 text: "degree = 3". sympy (`ex8check.py`) → coefficients equal to Case 2's / Example 3's cubic, rank F = 4, unique | yes |
| index.qmd l.41 | "to the same six points" | `md5sum` gr_120 = gr_38 = gr_52 = gr_60 = gr_68 = d472f286…. I viewed gr_120 and it shows the six points of the page. | yes (statement image; solution's data image gr_121 is missing) |
| index.qmd l.41 | "from the module's general linear least-squares theorem" | Main page text: section "Linear Least Squares" → "Theorem (Linear Least Squares) … creating the matrix F … solving the linear system" sits directly before Example 8. lnk_9: "Construct the matrices … Solve the linear system". | yes |
| index.qmd l.41 | Completeness of the list (Examples 1, 6, 7, 8) | Every example checked. Ex 1 (lnk_2, statement image gr_10): different points (−1,10)…(6,−1), not animated. Ex 2–5 (lnk_3..6): animated as Cases 1–4. Ex 6 (lnk_7): asks why RMS of p₅ is essentially zero. Its graph gr_85 (from `Show[graph2..graph5, dots, PlotRange→{{−10,10},{−20,9}}]`, gr_84) shows the four fits separating outside the data, and it is not animated. Ex 7 (lnk_8, gr_86): different points (0.25,23.1)…(5.0,1.2576) from a non-polynomial function, not animated. Ex 8: as above. The other module sections are the theorems, proof, the LSParabola subroutine and links (lab project, REU), and none of them are examples. | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. The finding concerns only the page text.
- `git status --short -- pages/numerical-methods/least-squares-polynomials` → ` M pages/numerical-methods/least-squares-polynomials/index.qmd` (only).

## Legacy archive
Consulted: `n2003/LeastSqPolyMod.html`, `n2003/leastsquarespoly/LeastSqPolyMod/Links/lnk_1..9`, and statement and graph images gr_9, gr_10, gr_38, gr_76, gr_84, gr_85, gr_86, gr_120 (converted to PNG in scratch). The module has Examples 1–8 and no Explorations. Examples 2–5 match Cases 1–4. Example 8 repeats the degree-3 fit on the same six points (its statement image is byte-identical to the data image of Examples 2–5) via the general linear least-squares theorem. Its solution images gr_121–gr_147 are all missing from the archive, as are Example 7's solution images gr_87–gr_103. One small archive inconsistency, noted for context: the round-3 review quotes Example 1's points from gr_11 ({−1,10},{0,6},…), while the statement image gr_10 reads (−1,10),(0,9),(1,7),… Either way they are "a different set of points", so the page's wording holds.

## Notes
- No decision ambiguity. R3-D placement was already satisfied.
- The page has a `## Description` section and follows conventions. No convention gaps were noticed.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix changes one line, `index.qmd` line 41. Example 8 is now listed among the examples not animated: "... and Example 8, which recomputes the cubic fit to the same six points from the module's general linear least-squares theorem, are not animated here."
- The list is now complete. The legacy module `n2003/LeastSqPolyMod.html` has exactly Examples 1–8. Examples 2–5 are animated (line 40), and Examples 1, 6, 7 and 8 are named as not animated (line 41). Every example is covered, as decision R3-B requires.
- The sentence is in the Animations introduction before Case 1, which is where R3-D puts it.
- The "same six points" claim is true. The finding said Example 8's data could not be read because image gr_121 is missing. But the main module page shows Example 8's points in a different image, `LeastSqPolyMod_gr_120.gif` (main page line 205, right after "Example 8"). That file is byte-identical (md5 d472f286…) to gr_38, gr_52, gr_60 and gr_68, the point images for Examples 2–5. Viewing it shows `(-4.5, 0.7), (-3.2, 2.3), (-1.4, 3.8), (0.8, 5.0), (2.5, 5.5), (4.1, 5.6)`, which matches page line 30.
- The "recomputes the cubic fit" claim is true. I built F = [1, x, x², x³] on the six points and solved FᵀF C = FᵀY in 50-digit mpmath. The result is C = (4.6686264, 0.48939249, −0.074238666, 0.0026765941) with RMS 0.02767321. The gradient Fᵀr is about 1e-49, so C is the least-squares minimiser. numpy's QR-based `lstsq` gives the same C. This matches Case 2's p₃ and RMS on the page, as it must, because linear least squares on the monomial basis up to x³ is the cubic least-squares polynomial.
- The "general linear least-squares theorem" wording is accurate. The module's "Theorem (Linear Least Squares)" is stated for any set of linearly independent functions f_j, using the matrix F and the system FᵀF C = FᵀY. Example 8 applies it with degree 3 (lnk_9: "Construct the matrices … Solve the linear system … Construct the polynomial", with an Aside comparing the result to `Fit`).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:41 | "Example 1, which fits a least-squares parabola to a different set of points" | lnk_2: "standard least squares parabola" for points gr_10 = (-1,10),(0,9),(1,7),(2,5),(3,4),(4,3),(5,0),(6,-1), which are 8 different points | True (text unchanged from before) |
| index.qmd:41 | "the graph in Example 6, which plots the quadratic to quintic fits together on an interval wide enough to show them separating outside the data" | lnk_7: gr_84 `Show[graph2, graph3, graph4, graph5, dots, PlotRange→{{-10,10},{-20,9}}]`. In gr_85 the four curves agree on [-4.5, 4.1] and fan out beyond it | True (unchanged) |
| index.qmd:41 | "Example 7, which fits the same degrees to points sampled from a non-polynomial function to show polynomial wiggle" | lnk_8: degrees n = 2, 3, 4, 5, with points gr_86 (0.25,23.1)…(5.0,1.2576). The Remark says the points "were obtained from [f] which is not polynomial". The main page says this example illustrates "polynomial wiggle" | True (unchanged) |
| index.qmd:41 | "Example 8" exists and is omitted from the animations | The main page and lnk_9 both contain Example 8. No case on the page animates it | True |
| index.qmd:41 | "recomputes the cubic fit" | Example 8 asks for degree 3. A 50-digit solve of FᵀF C = FᵀY reproduces Case 2's p₃ (4.66863, 0.48939, −0.07424, 0.00268) and RMS 0.02767 | True |
| index.qmd:41 | "to the same six points" | gr_120 is byte-identical to the Examples 2–5 point images and visually shows the page's six points | True |
| index.qmd:41 | "from the module's general linear least-squares theorem" | The module's "Theorem (Linear Least Squares)" (general basis f_j, matrix F, FᵀF C = FᵀY) is applied in lnk_9 | True |
| index.qmd:41 | "are not animated here" | 4 cases ↔ Examples 2–5. Examples 1, 6, 7 and 8 are listed. The module has no Example 9 | True, complete |

### New problems

None. This rests on:
- the one-line diff, with every clause checked against the archive as shown in the ledger;
- an independent high-precision solve for the only mathematical claim ("recomputes the cubic fit").

One observation, not a defect: the sentence is now a four-item list in which each item has its own "which" clause, separated only by commas. It is grammatical and correct but heavy to read. Splitting it into two sentences would read better. Optional.

### Reproducibility and conventions

- No script or GIF changed (fix.diff lists only `index.qmd`; `git diff --stat` shows 1 file, 1 line changed), so there was nothing to regenerate. The page's GIFs are untouched.
- Conventions still hold: Description comes before Animations. Each of the 4 cases has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code blocks. The "not animated" sentence is in the Animations introduction (R3-D).
- Files outside the page folder: the working tree has changes on other numerical-methods pages and untracked round-3 fix records, including `reviews/numerical-methods-animations-r3/fixes/least-squares-polynomials.md`, which I did not read. These belong to the other parallel fixes and the fixer's own record. Nothing attributable to this fix changed a published file outside `pages/numerical-methods/least-squares-polynomials/`.

**Final status:** committed
