# Fix record: cubic-splines

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/cubic-splines/fix/` (`err.py`, `frames/`).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:**
  - Page (before) lines 25 and 37–38 said that the sin(x) example is new and that Examples 1–3 are not animated, but gave no reason for using sin(x). Confirmed by reading `index.qmd`.
  - Archive `n2003/CubicSplinesMod.html`: `grep -n -E 'Example|Exploration'` with tags stripped gives Examples 1, 2 and 3 only, and no Explorations. The solution links are lnk_2 (Solution 1), lnk_3 (Solution 2) and lnk_4 (Solution 3); lnk_1 is the module header page.
  - Statement images: gr_25, gr_34 and gr_53 all have md5 `20be64a49ca1b3b3082ebc619ecf5641`. Viewed gr_25: "(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)".
  - Boundary conditions: viewed gr_26 (= gr_35, same md5 `d5c97478…`): "S''(0)=0 and S''(6)=0". Viewed gr_54: "S'(0)=-0.2 and S'(6)=-2.5".
  - Solution code: viewed gr_27 (Ex 1), gr_36 (Ex 2) and gr_55 (Ex 3). Each begins `XY = {{0.,1.},…,{6.,1.}}` and calls `NaturalSpline[XY]`, `SplineFit[XY, Cubic]` or `ClampedSpline[XY, -0.2, -2.5]` respectively. No function is given from which the data were sampled.
  - The finding holds.
- **Decision applied:**
  - Under R3-B, the R2-A rule applies. R2-A says "follow Mathews" for a parameter of an existing case, and "add one sentence, do not add the example" when a whole example is left out.
  - Case 1 is a node-refinement sweep whose error can only be measured against a known function. Mathews' examples are a fixed 7-point table with no underlying function, so swapping in his data is not a parameter change; it would remove what the case shows.
  - I therefore kept the case, kept the existing "not animated here" sentence, and added the one-sentence reason that the finding asks for (its first suggested correction). No natural-versus-clamped case was added, because R2-A says not to add the example.
- **Change:** `index.qmd`
  - Added after "… is new to this page rather than taken from that module.": "It is used because $\sin(x)$ has a closed form, so each frame can report the spline's maximum error; the module's examples interpolate a table of data points with no underlying function."
  - "the $\sin(x)$ example above" → "the $\sin(x)$ example in Case 1", because the sentence now comes before Case 1 (R3-D).
- **Check:**
  - The frame titles report max err. Script line 63 has `title=… (max err ≈ $(round(err, sigdigits=3)))`. Frame 6 viewed at full size reads "9 nodes (max err ≈ 0.00107".
  - Independent SciPy check (`/usr/bin/python3 -I err.py`): the max errors for n = 3,4,5,6,7,9 are 1.0, 0.109, 0.02, 0.00897, 0.00407, 0.00107, so the error is measurable against sin.
  - "No underlying function": confirmed from the statement text ("for the points …") and from the three solution code images (gr_27, gr_36, gr_55), which contain only the XY table.

### R3-D — placement of the "not animated here" sentence — done

- **Change:** The two-sentence paragraph ("Mathews' Cubic Splines module has no animation … are not animated here.") moved from after the Case 1 GIF embed to the Animations introduction. It now sits after "Julia source scripts that generated these animations are linked under each case." and before "### Case 1". "example above" was reworded to "example in Case 1" so that it reads correctly in its new place.
- **Content re-verified against every example in the module (R2-A pattern):**
  - The module has Examples 1–3 and no Explorations.
  - Ex 1 is a natural spline: its statement BC image gr_26 shows S''(0)=S''(6)=0, and its code calls `NaturalSpline`.
  - Ex 2 is natural via SplineFit: its statement says "natural cubic spline … Use Mathematica's procedure SplineFit", it uses the same BC image (gr_35 = gr_26), its code calls `SplineFit[XY, Cubic]`, and Solution 2 says "the same curve that was obtained in Example 1".
  - Ex 3 is clamped: its BC image gr_54 shows S'(0)=-0.2 and S'(6)=-2.5, and its code calls `ClampedSpline`.
  - All three use one data set (md5 identical).
  - The page animates none of them. Its only case is sin(x).
  - "Module has no animation": the module HTML links only lnk_1–4, Proof, Prog and Bib. `a2001/Animations/Interpolation` has no spline folder (Chebyshev, FourierSeries, gifs, Lagrange, Pade, series, Series). The only spline animation, `Quadrature/Spline/Splineaa.gif`, is listed in Animations7.html against `SplineQuadMod.html` ("Cubic Spline Quadrature"), not this module.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Animations intro (moved) | "Mathews' Cubic Splines module has no animation" | `grep -o 'Links/[^"]*lnk_[0-9]*\.html' CubicSplinesMod.html` → lnk_1–4 only. `ls a2001/Animations/Interpolation` → no spline folder. `Animations7.html` l.82–83 → the spline animation belongs to SplineQuadMod | yes |
| Animations intro | "the $\sin(x)$ example in Case 1 is new to this page rather than taken from that module" | Module statements and code use only the XY table (gr_25, gr_27, gr_36, gr_55 viewed). The script uses `f(x)=sin(x)` (l.47) | yes |
| Animations intro (new) | "It is used because $\sin(x)$ has a closed form, so each frame can report the spline's maximum error" | Script l.58 computes `err = maximum(abs.(S .- f.(x_plot)))`, and l.63 puts it in the title. In frame_006.png the title reads "max err ≈ 0.00107". `err.py` (SciPy natural spline, 4e5 points) gives 1.0, 0.109, 0.02, 0.00897, 0.00407, 0.00107 | yes |
| Animations intro (new) | "the module's examples interpolate a table of data points with no underlying function" | Statement text "Construct the … spline for the points …". gr_25 shows the 7 points. The code images gr_27, gr_36 and gr_55 define only `XY = {{0.,1.},…}` | yes |
| Animations intro (moved, unchanged) | "Examples 1–3 … natural (Examples 1 and 2, the second with … SplineFit) and a clamped cubic spline (Example 3) through one shared set of data points, are not animated here" | Full Example/Exploration grep → Ex 1–3 only. BC images gr_26/gr_35/gr_54 and code images as above. md5 of gr_25 = gr_34 = gr_53 = `20be64a4…` | yes |

No numbers were added to the page.

## Scripts and GIFs

- No script changed and no GIF was regenerated. F1 is fixed in the text only.
- Frames of the committed `cubicsplineaa.gif` were extracted with `giftools.jl` to `fix/frames/` (6 frames). Frame 6 was viewed at full size: the title shows the node count and max err, and the legend reads sin(x) / S(x) / data nodes.
- `git status --short -- pages/numerical-methods/cubic-splines` → ` M index.qmd` only.

## Legacy archive

- Consulted: `n2003/CubicSplinesMod.html`, its Links lnk_1–4 and Images gr_25–27, 36, 54 and 55, plus `a2001/Animations/` (Interpolation folder, Animations7.html, Quadrature/Spline).
- What it shows:
  - The module has no animation.
  - Examples 1–3 use one 7-point table, (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1), with no underlying function.
  - Ex 1 and Ex 2 are natural (S''=0 at both ends). Ex 3 is clamped with S'(0)=−0.2, S'(6)=−2.5.
- Context check (not on the page): SciPy on that table gives natural S'(0) = S'(6) = −1.2 and clamped S''(0) = −3.467, S''(6) = −4.506. So the two end conditions do produce different end behaviour, as the reviewer saw in gr_28 and gr_56.
- Difference from the page: the page keeps sin(x) rather than Mathews' table, because the case is a refinement sweep whose error needs a known function. The page now says so.

## Notes

- **Ambiguity:**
  - R2-A lists "function" as a parameter to follow Mathews on. Here Mathews has no function, only a data table, so I treated this as a whole example left out (add one sentence) plus the R2-A exception (keep the page, say why in one sentence).
  - If Jason wants the natural-versus-clamped contrast on Mathews' data, that would be a new Case 2, and R2-A currently says not to add it.
- **Not acted on (reviewer observations, not findings):**
  - The title's closing parenthesis is clipped in frames 4–6. All digits remain legible (frame 6 viewed: "0.00107" is fully visible).
  - Frame 4's title reads "0.00896". That is the 600-point sample error 0.0089649. The fine-grid error is 0.0089651, which rounds to 0.00897, so the last digit differs because of the sampling. The title says "≈", so I left it.
- **Convention gaps:** none relevant were noticed. The page already has Description before Animations, a source link and an embed per case, and alt text.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The fixer kept the sin(x) case and added a reason (index.qmd line 29): "It is used because $\sin(x)$ has a closed form, so each frame can report the spline's maximum error; the module's examples interpolate a table of data points with no underlying function." That is the first of the two corrections the finding suggested.
- The reason is true. Each of the 6 frames of cubicsplineaa.gif reports "max err ≈ …" in its title (checked on the contact sheet). The module's only data set is the table (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1) (I viewed CubicSplinesMod_gr_25.gif), and no function is given for it, so it has no error to measure.
- Judged against R2-A: keeping sin(x) is justified. The "Follow Mathews" branch covers a parameter of an existing case, such as a different interval, start, centre or function in a case that Mathews also has. Mathews' Cubic Splines module has no animation. The only legacy natural-cubic-spline GIF, a2001/Animations/Quadrature/Spline/Splineaa.gif, is linked from Animations7.html to SplineQuadMod, which is a different page. The module's Examples 1–3 use one fixed table of 7 points. A case that converges as nodes are added cannot be re-parameterised onto that table, because it has no node sequence and no function to measure error against. Using the table would add a different example. So this is the R2-A branch where a whole example is left out: "add one sentence saying what was left out; do not add the example". The page has that sentence (line 30). The added reason is a sentence of justification, which R2-A itself asks for when the page departs from Mathews. Nothing in R2-A required replacing the case.
- R3-B (check the omission sentence against every example): the module has exactly Examples 1, 2 and 3. Examples 1 and 2 are natural splines, the second using SplineFit; Example 3 is a clamped spline. All three use the same data. The sentence covers all three and describes each correctly.
- R3-D: the "not animated here" sentence, now preceded by the source statement, has moved from after the Case 1 embed into the Animations introduction, before "### Case 1". This matches the reference pattern on Improved Newton (it follows the "Julia source scripts…" line).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.29 | "Mathews' Cubic Splines module has no animation" | CubicSplinesMod.html and its Links/ have no animation. The only legacy natural-cubic-spline animation (Quadrature/Spline) belongs to SplineQuadMod | True |
| l.29 | "the $\sin(x)$ example in Case 1 is new to this page rather than taken from that module" | The module's examples use only the 7-point table; sin(x) does not appear | True |
| l.29 | "$\sin(x)$ has a closed form, so each frame can report the spline's maximum error" | All 6 frame titles show max err. I recomputed them independently with scipy CubicSpline(bc='natural') on a 200001-point grid: 1, 0.109, 0.02, 0.00897, 0.00407, 0.00107. The GIF shows 1.0, 0.109, 0.02, 0.00896, 0.00407, 0.00107. The 6-node value differs only in the last digit because the script samples 600 points | True |
| l.29 | "the module's examples interpolate a table of data points with no underlying function" | gr_25 shows the data table (0,1)…(6,1). The example text says "Construct the … spline for the points …" and gives no f | True |
| l.30 | "Examples 1–3 … natural cubic spline (Examples 1 and 2, the second with Mathematica's SplineFit procedure) and a clamped cubic spline (Example 3) through one shared set of data points, are not animated here" | Links lnk_2/3/4: Ex1 natural; Ex2 natural with SplineFit ("Which is the same curve that was obtained in Example 1"); Ex3 clamped. The module has no Example 4 or later | True |
| l.29–30 position | Moved to Animations intro before Case 1 | R3-D pattern (Improved Newton) | Compliant |
| removed l.37–38 (old) | Old copy of the sentence after the embed | Deleted, so the sentence does not appear twice | OK |

### New problems
None. This rests on: every added sentence checked against the module text and images and against an independent computation of the error values; the GIF and script unchanged (git diff HEAD is empty for both); and the page structure intact.

### Reproducibility and conventions
- The fix changed no script or GIF; only index.qmd changed in the page folder. As a sanity check, I ran a scratch copy of cubicsplineaa.jl. Its output (md5 70ebeb2bdd1867fc644f7f8a2a4e1717) is byte-identical to the GIF in the working tree, which `git diff HEAD` reports as unchanged. The HEAD blob is an LFS pointer.
- Conventions: Description comes before Animations. Case 1 has a source link `[Julia source](cubicsplineaa.jl)` and a GIF embed with descriptive alt text. There are no code blocks.
- No file outside the page folder is touched by this fix: the diff lists only the page's index.qmd. The other modified files in the working tree belong to other pages' fixes.
- An observation carried over from the original review, unchanged and not a finding: the frame 4–6 titles are clipped at the right edge, but all digits remain readable.

**Final status:** committed
