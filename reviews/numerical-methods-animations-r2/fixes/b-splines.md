# Fix record: b-splines

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/b-splines/fix/`
- `check_archive.py` / `check_archive.out`: independent sympy/scipy check of the archive's construction and Example 1
- `conv.jl`: converts archive images to upscaled PNGs; `legacy/gr_*.png`: the images viewed

## Findings

### F1 — Misleading (fidelity) — fixed
- **Reproduced.**
  - The archive module `n2003/B-SplinesMod.html` is titled "Cubic spline construction using the B-spline function". `grep -n -i -E 'Method|Example|Solution'` lists exactly Example 1 (line 378, solution `Links/B-SplinesMod_lnk_2.html`) and Example 2 (line 388, solution `Links/B-SplinesMod_lnk_3.html`). `lnk_1` is only the module title page.
  - Example 1 statement (`gr_111`, `gr_112`): the natural cubic spline through (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1) with S''(0)=S''(6)=0. The solution's equations (`gr_133`) are c₋₁=2c₀−c₁, c_{k−1}+4c_k+c_{k+1}=y_k (k=0..6), c₇=2c₆−c₅. Its graph (`gr_151`) shows the spline through the red data points.
  - Example 2 (`lnk_3` text plus `gr_176`/`gr_177`, `gr_201`/`gr_202`, `gr_226`/`gr_227`) graphs the 9 translated functions b_i on [−4,10], then the weighted terms c_j b_j, then the partial sums Σ_{j=−1}^{i} c_j b_j up to the full spline.
  - Independent check (`python3 -I check_archive.py`):
    - B(x) from `gr_23` equals 6 × the cardinal cubic B-spline on knots −2..2 (max diff 8.9e-16). B(0)=4, B(±1)=1, and the jumps of B, B′, B″ at the joins are all 0.
    - Solving the 9×9 system gives c₋₁..c₇ = 11/30, 1/6, −1/30, −1/30, 1/6, 11/30, 11/30, 1/6, −1/30 (= 0.36667 … −0.03333, matching the review and the archive's printed sum in `gr_227`).
    - s(0..6) = [1,0,0,1,2,2,1] exactly; s″(0)=s″(6)=0.
    - min −0.15000 at x=1.5 and max 2.15000 at x=4.5. These equal scipy's natural `CubicSpline` to 8.9e-16.
  - The page has no interpolation through data, no linear system and no natural end conditions. `grep -i 'interpol|natural|data point|linear system'` over `index.qmd` and both scripts hits only Description line 22 (endpoint interpolation of control points). Both scripts build `t_knots` as the clamped vector, and Case 1 plots a parametric curve (`cx`, `cy` versus t).
  - The finding holds.
- **Change.** Following R2-A ("add one sentence when a whole Mathews example or topic is left out … do not add the example") and the Monte Carlo π pattern for where the sentence goes: `index.qmd` gets one new paragraph at the very end, after the Case 2 embed. The page has no legacy note, so the sentence goes right after the last embed. Before: the page ended at the `bsplinebb.gif` embed. After: the new sentence is added (see the ledger). No numbers are in the sentence. The left-out examples are named by kind.
- **Check.** Every clause is checked in the ledger below. `git diff` shows only that one added line (plus a blank separator).

## Ledger of changed text

Sentence added at the end of `index.qmd`:

> Unlike this page, which uses a clamped knot vector to define parametric B-spline curves, the B-Splines module of the cited Mathews site uses cubic B-splines for interpolation: its Example 1 builds the natural cubic spline through equally spaced data points as a weighted sum of translated copies of one cubic B-spline, with the weights found by solving a linear system, and its Example 2 graphs those translated B-splines, the weighted terms and their partial sums; neither example is animated here.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd last line | "this page … uses a clamped knot vector to define parametric B-spline curves" | `grep -n t_knots` in both scripts: `vcat(zeros(k), …)` gives [0,0,0,0,1,2,3,4,4,4,4] (also r2 ledger #20). Case 1 plots `cx[1:idx_end]`, `cy[1:idx_end]` from `bspline_curve_point(t, …)`, a parametric curve. Case 2 shows the basis functions of that curve | yes |
| same | "the B-Splines module of the cited Mathews site" | Line 8 cites `@mathewsSite` (references.bib: "Numerical Analysis - Numerical Methods Modules", n2003/NumericalUndergradMod.html). The module is `n2003/B-SplinesMod.html`, titled "Module for B-Splines" | yes |
| same | "uses cubic B-splines for interpolation" | Module text: "Construction of cubic B-spline interpolation …", "you must have a uniform grid … interpolation nodes"; lnk_3 closes with "only interpolation" | yes |
| same | "Example 1 builds the natural cubic spline through equally spaced data points" | `gr_111`: x = 0..6 (spacing 1); `gr_112`: S''(0)=0 and S''(6)=0. check_archive.py: s(0..6)=[1,0,0,1,2,2,1], s''(0)=s''(6)=0, equal to scipy natural CubicSpline to 8.9e-16 | yes |
| same | "as a weighted sum of translated copies of one cubic B-spline" | `gr_227`: Σ c_j B[x−j] for j = −1..7. check_archive.py: B = 6·(cardinal cubic B-spline on −2..2), max diff 8.9e-16; piecewise cubic, C² (jumps in B, B′, B″ all 0) | yes |
| same | "with the weights found by solving a linear system" | `gr_133` "Solve the equations": 9 linear equations. check_archive.py solves them: c = 11/30, 1/6, −1/30, −1/30, 1/6, 11/30, 11/30, 1/6, −1/30 | yes |
| same | "Example 2 graphs those translated B-splines" | lnk_3 "Graphs of the basic functions used to form the B-spline". `gr_176` plots `Table[b_i[x], {i,−1,n+1}]` on [−4,10]; `gr_177` shows 9 translated bumps of peak 4 | yes |
| same | "the weighted terms" | lnk_3 "Graphs of the terms". `gr_202` shows the c_j b_j curves (peaks ≈1.47 = 4·11/30, ≈0.67 = 4·1/6, negative ones for −1/30) | yes |
| same | "and their partial sums" | lnk_3 "The next loop finds the partial sums". `gr_201` loops over Σ_{j=−1}^{i} c_j b_j; the final `gr_226` is the full spline | yes |
| same | "neither example is animated here" | The page has 2 cases (bsplineaa: clamped parametric curve; bsplinebb: clamped normalised basis plus partition-of-unity sum). Neither has data points, a solved system, c_j B_j terms or partial sums of them. `ls` of the page folder: only bsplineaa/bb .jl/.gif | yes |
| same | number of Examples in the module ("Example 1", "Example 2") | `grep -n -i -E 'Method|Example|Solution' B-SplinesMod.html` → Example 1 (l.378) and Example 2 (l.388) only | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated, because the fix is text only.
- `git status --short -- pages/numerical-methods/b-splines` after the edit gives ` M pages/numerical-methods/b-splines/index.qmd` only.

## Legacy archive
- Consulted: `n2003/B-SplinesMod.html`, `bsplines/B-SplinesMod/Links/lnk_1..3.html`, and the images gr_23, 26, 111, 112, 133, 150, 151, 158, 176, 177, 201, 202, 226 and 227 (converted to PNG in scratch `legacy/`).
- What it showed: the module's subject is uniform cubic B-spline *interpolation*. B is the unnormalised cubic B-spline (peak 4). Example 1 is the natural spline through 7 points, found by solving a 9×9 system, and Example 2 graphs the translated basis, the weighted terms and the partial sums. All of this was reproduced independently (see F1).
- No B-spline animation exists in `a2001/Animations/`. `find -iname '*spline*'` finds only `Quadrature/Spline`, which is spline quadrature, and `grep -ril bspline` finds nothing.
- Difference from the page: the page teaches parametric clamped B-spline curves. Per R2-A, the page keeps its own (mathematically correct) cases and now says what it leaves out. The archive example is not added.

## Notes
- The review's "not findings" (literal `N_{i,4}` label rendering in `bsplinebb.gif`, the half-open k=1 indicator, the unlabelled red marker) were left untouched, because they are not findings.
- The sentence goes at the end of the page (Monte Carlo π pattern) rather than in the Description or Animations intro that the review's option (b) suggested. The pattern-setter rule says it is a statement about the source.
- The page has no legacy/source note paragraph, so there was no stale note to correct.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix is text-only. It adds one sentence at the end of the Animations section (index.qmd line 46). No script or GIF changed (`git status` of the page folder shows only `M index.qmd`; `git diff HEAD --stat` gives 1 file, 1 insertion).
- The fix follows the owner's decision R2-A: when a whole Mathews example or topic is left out, add one sentence saying so and do not add the example. B-Splines is named there explicitly. Suggested correction (b) is therefore the right remedy. Not adding option (a), the animation, is not a defect.
- The silent substitution is gone. The page now says that Mathews' module uses cubic B-splines for interpolation, while this page uses a clamped knot vector for parametric curves. It summarises both archive examples and says that neither is animated.
- I checked every claim in the sentence against the archive and by my own computation (see the ledger). All of them are true.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:46 | "this page … uses a clamped knot vector to define parametric B-spline curves" | Description line 15 has C(t)=ΣP_i N_{i,k}(t), and Case 2 (line 40) has the knot vector (0,0,0,0,1,2,3,4,4,4,4). | True |
| index.qmd:46 | "the B-Splines module of the cited Mathews site" | `mathewsSite` in references.bib is the Numerical Analysis modules index. NumericalUndergradMod.html line 170 lists "B-Splines", which links to B-SplinesMod.html. | True |
| index.qmd:46 | "uses cubic B-splines for interpolation" | B-SplinesMod.html is titled "Cubic spline construction using the B-spline function". It speaks of "cubic B-spline interpolation" and ends with "only interpolation". | True |
| index.qmd:46 | "Example 1 builds the natural cubic spline through equally spaced data points" | lnk_2 reads "Construct the natural cubic spline for the 7 points". The abscissas are x=0..6 with h=1, and the end constraints are s''=0. My own solve (`check/ex1n.py`) fits the data with residuals of 4e-16 or less and gives s''(0)=s''(6)≈1e-16. Its largest difference from scipy's natural CubicSpline is 2.1e-13. | True |
| index.qmd:46 | "as a weighted sum of translated copies of one cubic B-spline" | Example 1 uses s(x)=Σ_{i=-1}^{7} c_i B(x−i), with h=1 so the copies are pure translates. I built B from truncated powers; it has values (0,1,4,1,0) at −2..2, matching the archive's peak of 4. In general the module uses B((x−x_i)/h), which also scales by h; for this example, h=1. | True |
| index.qmd:46 | "with the weights found by solving a linear system" | The archive image (gr_151 area) shows the 9 equations "Solve the equations c_{-1}=2c_0−c_1, c_{-1}+4c_0+c_1=1, …". My solve gives c_{-1..7}=(0.36667, 0.16667, −0.03333, −0.03333, 0.16667, 0.36667, 0.36667, 0.16667, −0.03333). The spline's minimum is −0.15 at x=1.5 and its maximum is 2.15 at x=4.5. Both match the archive graph. | True |
| index.qmd:46 | "its Example 2 graphs those translated B-splines, the weighted terms and their partial sums" | lnk_3 text reads "Graphs of the basic functions … Graphs of the terms … The next loop finds the partial sums". The archive images (montage `check/archive_montage.png`, gr_158–gr_236) show nine single translated bumps on [−4,10], all nine together, the weighted terms c_iB_i, and then a magenta partial sum that grows term by term into the spline. | True |
| index.qmd:46 | "neither example is animated here" | Case 1 is a parametric curve from 7 control points. Case 2 shows the normalised clamped basis N_{i,4} and its partition of unity. Neither case uses data interpolation or the coefficients c_i. | True |

### New problems
None.

This rests on the ledger above, where every claim checks out against the archive text, the archive images and my own computation. I also considered these points:
- The sentence sits after the Case 2 embed rather than in the Description or the intro, but it opens with "Unlike this page", so it reads as a note about the whole page. The Monte Carlo π fix in this round (commit a00bf75) puts its sentence in the same end-of-page place, so the placement is consistent across the site.
- The sentence is long (one sentence with a semicolon), as R2-A's one-sentence rule requires. It is not wrong.

### Reproducibility and conventions
- **Scripts and GIFs:** none changed, so there was nothing to regenerate. bsplineaa.gif and bsplinebb.gif are unchanged from HEAD.
- **Conventions:** these are intact.
  - Description comes before Animations.
  - Each case has a Julia source link and a GIF embed with descriptive alt text.
  - There are no code blocks (0 code fences).
  - The added sentence contains no math or markup that could break rendering.
- **Scope:** the page-folder diff touches only `index.qmd`. The working tree also has modifications in other page folders. They come from the other pages being fixed in parallel in this round and are not part of this page's diff, so I cannot attribute them to this fix.
- **Repository:** I modified nothing in the repository and ran no state-changing git commands. All my work is in `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/b-splines/check/`.

**Final status:** committed
