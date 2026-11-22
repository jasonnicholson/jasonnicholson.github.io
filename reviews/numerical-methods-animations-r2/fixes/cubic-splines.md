# Fix record: cubic-splines

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/cubic-splines/fix/` (`archive_check.py`, `up.jl`, `nframes.jl`, `arch/`).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced.**
  - The page has one case (`grep -c '^### Case' index.qmd` → 1), one script (`cubicsplineaa.jl`, `f(x) = sin(x)` on `range(0, 2π, length=nn)`) and one GIF. Nothing on the page mentions Mathews' examples.
  - The archive module `n2003/CubicSplinesMod.html` has three worked examples:
    - Example 1 (`_lnk_2`) and Example 2 (`_lnk_3`) are natural cubic splines.
    - Example 3 (`_lnk_4`) is a clamped cubic spline.
    - All three use the same points, `(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)`. The statement images `gr_25`, `gr_34` and `gr_53` were viewed at 4× and are identical.
  - So the finding holds: the page's sin(x) example is not from the module, and the page does not say so.
- **Change.** Following decision R2-A ("Add one sentence when a whole Mathews example … is left out … Do not add the example"), I added two source lines to `index.qmd`, directly after the Case 1 embed. The page has no legacy note, so this is the place the pattern gives. No script or GIF changed.
  - The first line says the module has no animation and that the sin(x) example is new to this page. This is the "what the page does reproduce" sentence of the pattern, adapted because the page reproduces nothing from the module.
  - The second line is the R2-A sentence in the Monte Carlo pattern's form. It names the examples by kind, with no numbers or formulas.
- **Check.** Each claim in the two lines is checked in the ledger below. Rendered placement: after the embed, as one paragraph made of two source lines. Quarto was not run, as the brief requires.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd, after Case 1 embed, line 1 | "Mathews' Cubic Splines module has no animation" | (a) `grep -o -i 'src="[^"]*"' n2003/CubicSplinesMod.html` → only `CubicSplinesMod_gr_*.gif` plus the `/gifs/brul.gif` and `/gifs/brur.gif` header ornaments. (b) `julia nframes.jl Images/*.gif` → all 61 `gr_*` images have 1 frame (`arch/nframes.txt`, no line with a count other than 1). `brul.gif` also has 1 frame. (c) The module's links (`_lnk_1..4`, Proof, Prog, Bib, MathWorld, `.nb`) contain no animation. (d) In `a2001/Animations/`, the only spline animation is `Quadrature/Spline/Splineaa.gif`, listed in `Animations7.html` under "Natural Cubic Spline Module" and linked to `SplineQuadMod.html`. That is the spline-quadrature topic, not this module. The sentence is scoped to "Cubic Splines module", so it is true. | yes |
| same line | "the $\sin(x)$ example above is new to this page rather than taken from that module" | The stripped module text and the stripped `_lnk_2..4` contain no function, only the data-point statement images (`gr_25/34/53`: the seven points). The solution code images `gr_27`, `gr_36` and `gr_55` use only `XY` = those points. No sine appears anywhere in the module. | yes |
| line 2 | "The module's Examples 1–3" | `grep -o 'Example[^<]*' CubicSplinesMod.html` → three occurrences. Stripped text: "Example 1. Construct the natural cubic spline…", "Example 2. … Use Mathematica's procedure SplineFit", "Example 3. Construct the clamped cubic spline…". The solution links map one to one (`_lnk_2` → Solution 1, `_lnk_3` → Solution 2, `_lnk_4` → Solution 3). `_lnk_1` is the module title page, not an example. | yes |
| line 2 | "construct a natural cubic spline (Examples 1 and 2 …)" | Statement images `gr_26` and `gr_35` read "S''(0) = 0 and S''(6) = 0". `gr_27` calls `NaturalSpline[XY]`. `archive_check.py` (SciPy `bc_type='natural'`) → M = [0, 1.2, 1.2, 0, −1.2, −1.2, 0], min −0.1500 at x = 1.5000, max 2.1500 at x = 4.5000, node residual 1.1e-16. This matches the archive graphs `gr_28` (Ex 1) and `gr_37` (Ex 2), each with a dip just below 0 near x = 1.5 and a peak just above 2 near x = 4.5. | yes |
| line 2 | "the second with Mathematica's SplineFit procedure" | `_lnk_3` text: "Use Mathematica's procedure SplineFit … Which is the same curve that was obtained in Example 1". `gr_36` shows `Needs["NumericalMath`SplineFit`"]` and `SplineFit[XY, Cubic]`, plotted parametrically. Independent check: a natural spline through (i, i) for x(t) is exactly linear (`archive_check.py`: max\|x(t) − t\| = 0.0), so the parametric natural spline is the same curve as Example 1. I first wrote "built-in" and dropped it, because SplineFit is loaded from a `Needs` package. | yes |
| line 2 | "and a clamped cubic spline (Example 3)" | `gr_54` reads "S'(0) = −0.2 and S'(6) = −2.5". `gr_55` calls `ClampedSpline[XY, -0.2, -2.5]`. SciPy `bc_type=((1,-0.2),(1,-2.5))` → S'(0) = −0.200000, S'(6) = −2.500000, min −0.1922 at x = 1.4676, max 2.0982 at x = 4.4216. This matches graph `gr_56`. The clamped spline differs from the natural one by up to 0.221, so they are different examples. | yes |
| line 2 | "through one shared set of data points" | `gr_25`, `gr_34` and `gr_53` (viewed at 4×) and the `XY = …` lines in `gr_27`, `gr_36` and `gr_55` all show the same seven points. | yes |
| line 2 | "are not animated here" | Page folder: `cubicsplineaa.gif`, `cubicsplineaa.jl` and `index.qmd` only. The single case is sin(x). No script uses the seven points. | yes |

No numbers were added to the page apart from the example identifiers "1–3", "1 and 2" and "3".

## Scripts and GIFs

- No scripts changed and no GIFs regenerated. F1 was a text-only fix under R2-A.
- `git status --short -- pages/numerical-methods/cubic-splines` → ` M pages/numerical-methods/cubic-splines/index.qmd` only.

## Legacy archive

- **Consulted:** `n2003/CubicSplinesMod.html`, `splines/CubicSplinesMod/Links/_lnk_1..4`, and the images `gr_25–28`, `gr_34–37` and `gr_53–56` (viewed). I also counted the frames of all 61 images and searched `a2001/Animations/`.
- **What it showed:**
  - There is no animated GIF for this module.
  - There are three worked examples on the same seven points: natural (Ex 1), natural with SplineFit (Ex 2), and clamped with S'(0) = −0.2 and S'(6) = −2.5 (Ex 3). My SciPy recomputation matches each archive graph.
  - The only spline animation in `a2001` belongs to spline quadrature (`Quadrature/Spline/Splineaa.gif`), which is another page's topic.
- **Difference from the page:** the page keeps its new sin(x) convergence animation, which round 2 found mathematically correct. R2-A says to add a note rather than add the example, so the note now says plainly that the sin(x) example is new and that Mathews' three examples are not animated.

## Notes

- The convention file (`animation-page.agent.md`, Legacy Availability Decision step 3) would have the animation reconstructed from the worked examples. R2-A, Jason's later decision, says not to add left-out examples, so I followed R2-A. If Jason later wants the archive examples animated, the recomputed values above (natural M, clamped extrema) are ready for checking.
- The reviewer's cosmetic note, a clipped closing `)` in the titles of frames 4–6, is not a finding and was not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix chose the finding's second option, which also matches owner decision R2-A ("Add one sentence when a whole Mathews example or topic is left out, saying what was left out. Do not add the example."). It added two sentences after the Case 1 embed. They say that the sin(x) example is new and that Mathews' Examples 1–3 (natural, natural via SplineFit, and clamped) are not animated. The script and GIF are unchanged, and that is correct for this option.
- I checked every claim against the archive myself (see the ledger):
  - `n2003/CubicSplinesMod.html` has exactly three examples (Example 1, 2, 3), and no `anim` string appears in the Mod, Prog, Proof or Bib pages.
  - None of the 61 GIFs under `splines/CubicSplinesMod/Images/` or `Web/CubicSplinesMod/` is animated: none has a NETSCAPE2.0 loop block or more than one graphic-control extension.
  - Under `a2001/Animations/`, the only spline animation is `Quadrature/Spline/Splineaa.gif`. `Animations7.html` line 82–83 lists it as "Natural Cubic Spline" and links it to `n2003/SplineQuadMod.html`, the Cubic Spline Quadrature module, not to the Cubic Splines module.
  - No sin function appears in the module, its Links pages or the Prog page.
- The page text is now accurate, and the reason for the departure is stated.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd, new line 37 | "Mathews' Cubic Splines module has no animation" | Searched the Mod, Prog, Proof and Bib HTML for "anim" (0 hits) and scanned all module GIFs for animation (none). In the a2001 index, the only spline animation (Splineaa) is linked to SplineQuadMod, a different module. | True |
| index.qmd, new line 37 | "the $\sin(x)$ example above is new to this page rather than taken from that module" | The examples' data are the 7 points (images gr_25, gr_34, gr_53). No sin function appears anywhere in the module or its Links pages. | True |
| index.qmd, new line 38 | "The module's Examples 1–3" | The module text has exactly Example 1, 2 and 3. | True |
| index.qmd, new line 38 | "construct a natural cubic spline (Examples 1 and 2 …)" | lnk_2 and lnk_3 both say "Construct the natural cubic spline". gr_26 and gr_35 give S''(0)=0 and S''(6)=0. | True |
| index.qmd, new line 38 | "the second with Mathematica's SplineFit procedure" | Module text and lnk_3: "Use Mathematica's procedure SplineFit"; lnk_3 adds "Which is the same curve that was obtained in Example 1." | True |
| index.qmd, new line 38 | "a clamped cubic spline (Example 3)" | lnk_4: "Construct the clamped cubic spline". gr_54 gives S'(0) = -0.2 and S'(6) = -2.5. | True |
| index.qmd, new line 38 | "through one shared set of data points" | Images gr_25, gr_34 and gr_53 all read (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1). | True |
| index.qmd, new line 38 | "are not animated here" | The page has a single case (sin(x)) and a single GIF. | True |

No numbers were added apart from the example indices 1–3, which are checked above.

### New problems
None. This rests on:
- every claim in the ledger being checked against the archive;
- the diff being confined to three added lines in `index.qmd`, with no script or GIF touched.

Two non-defect observations:
- R2-A asks for "one sentence" and the fix uses two. The content is still the single required statement of what was left out, plus the "new example" note that the finding asked for.
- The note sits under the `### Case 1` heading after the embed, not in the Animations intro. It still reads clearly, and it does not break the one-source-link-and-one-embed-per-case structure.

### Reproducibility and conventions
- No script or GIF changed: `git diff --stat HEAD` for the page shows only `index.qmd | 3 +++`. No regeneration was needed. The committed `cubicsplineaa.gif` is unchanged from HEAD.
- The page conventions still hold:
  - Description comes before Animations.
  - Case 1 has a `[Julia source](cubicsplineaa.jl)` link and an embed with descriptive alt text.
  - There are no code blocks: grep for triple backticks finds nothing.
- Nothing outside the page folder belongs to this fix. The diff for this page touches only `index.qmd`. Other modified or untracked files in the working tree belong to other pages' fixes and are not attributable to this one.

**Final status:** committed
