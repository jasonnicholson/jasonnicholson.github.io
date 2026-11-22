# Fix record: hermite-polynomial-interpolation

Scratch folder with all evidence scripts and frame extractions:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/hermite-polynomial-interpolation/fix/`
- `aa_instr.jl`: lines 9–40 of `hermitepolyaa.jl` copied verbatim (basis, `hermite_eval`, f, grid). It prints the script's error and its `round(err, sigdigits=3)` string for n = 1…64, with the plotting removed.
- `indep.py`: independent check, run with `/usr/bin/python3 -I indep.py`. It uses scipy `CubicHermiteSpline` on 600-point and 200001-point grids, mpmath critical points for the exact n = 1 error, and sympy for the basis conditions and the partial sums of Case 2.
- `committed/{aa,bb}/` and `new/{aa,bb}/`: frames extracted from the old and new GIFs with `giftools.jl`.

## Findings

### F1 — Misleading — fixed
- Reproduced:
  - `julia aa_instr.jl` (the script's 600-point grid) gives max errors 4.253746e-01, 2.146006e-01, 1.079052e-02 and 9.061985e-04 for n = 1, 2, 4, 8. The ratios are 1.982, 19.888 and 11.907. Beyond the frames shown they are 14.958 (n=16), 15.742 (n=32) and 15.938 (n=64).
  - `indep.py` (scipy, 200001-point grid) gives 4.253816e-01, 2.146018e-01, 1.079068e-02 and 9.062162e-04, with ratios 1.982, 19.888, 11.907, 14.958, 15.738 and 15.934.
  - The exact n = 1 error from mpmath critical points is 0.425381602674369.
  - So the page's "doubling n divides the error by ≈16" does not hold for the frames shown.
- Change: index.qmd, Case 1 Behavior.
  - Before: "Doubling $n$ decreases the maximum error by approximately $2^4 = 16$, consistent with the $O(h^4)$ convergence rate."
  - After: "The maximum errors in the four frames are 0.425, 0.215, 0.0108 and 0.000906, so the doublings shown divide the error by about 2.0, 19.9 and 11.9. For smooth $f$ the error is $O(h^4)$, but these coarse meshes are not yet in the asymptotic range; the ratio approaches $2^4 = 16$ only on finer meshes (15.0 for $n = 8 \to 16$, 15.7 for $16 \to 32$, 15.9 for $32 \to 64$)."
  - Alt text: "the error shrinks rapidly as the mesh is refined" → "the maximum error falls from 0.425 at n=1 to 0.000906 at n=8".
  - `n_intervals_list` was not extended (decision D7: the text was changed to describe the animation).
- Check: the numbers above. Both grids give the same 3-significant-figure values and the same 1-decimal ratios. The new frame titles (F2) show the same four errors.

### F2 — Minor — fixed
- Reproduced: in the committed `committed/aa/frame_004.png` the title ends "(max err ≈ 0.000" at the right edge. The value and the closing parenthesis are cut off.
- Change: hermitepolyaa.jl:53.
  - The title changed from "Piecewise Cubic Hermite for sin(x) — $n interval(s)  (max err ≈ …)" to "Cubic Hermite for sin(x), n = $n  (max err ≈ $(round(err, sigdigits=3)))", with a one-line comment.
  - The error formatting was already 3 significant figures and is unchanged. The GIF was regenerated.
- Check: the new frames `new/aa/frame_001.png` and `frame_004.png` (full size) and `new/aa/sheet.png` show the full titles "… n = 1 (max err ≈ 0.425)", "n = 2 … 0.215", "n = 4 … 0.0108" and "n = 8 … 0.000906", each with its closing parenthesis and inside the frame. These match the `aa_instr.jl` round3 column: 0.425, 0.215, 0.0108 and 0.000906.

### F3 — Minor — fixed
- Reproduced: `indep.py` (sympy) gives the partial sums S1 = y0·H00 = (x−1)²(2x+1) and S2 = S1 + h·y0'·H10 = (x−1)²(3x+1).
  - S1 falls below 0.8 from x = 0.287, so 71.3% of the grid points lie below that level.
  - S2 has max 1.0535 at x = 0.1111 and falls below 0.8 from x = 0.395 (60.5% of grid points).
  - Both have value 0 and slope 0 at x = 1, so with ylims (0.8, 3.0) they leave the window. The committed `committed/bb/frame_001.png` shows the blue curve leaving at x ≈ 0.29.
  - S3 and S4 both have min 1.0000 and max 2.7183, so they are inside the window.
  - The alt text claimed the individual contributions are "revealed one at a time", but only running sums are drawn.
- Change:
  - hermitepolybb.jl:40: `ylims=(0.8, 3.0)` → `ylims=(-0.2, 3.0)`, with a comment. The GIF was regenerated.
  - index.qmd Case 2 Behavior gains one sentence: "The frames add the weighted terms one at a time and draw the running sum; the first two partial sums fall to 0 with zero slope at $x = 1$, because $H_{00}$ and $H_{10}$ have zero value and zero slope there."
  - The alt text changed to "Running sum of the four weighted Hermite basis terms for e^x on [0,1], adding one term per frame until it forms the complete cubic Hermite interpolant". Following D7 and the smallest-change lesson, the text now describes the cumulative animation. The individual terms were not overlaid.
- Check:
  - All four partial sums lie in [0, 2.7183], inside (−0.2, 3.0) (`indep.py`).
  - New frames `new/bb/frame_002.png` (full size) and `new/bb/sheet.png`: frames 1 and 2 show the whole curve descending to 0 with a flat end at x = 1. In frame 2 the bump near x ≈ 0.11 (max 1.05) is visible. Frames 3 and 4 are unchanged in shape.
  - The legend (top left) does not cover any curve.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 | max errors 0.425, 0.215, 0.0108, 0.000906 in the four frames | `julia aa_instr.jl` → 4.253746e-01, 2.146006e-01, 1.079052e-02, 9.061985e-04; `indep.py` fine grid → 4.253816e-01, 2.146018e-01, 1.079068e-02, 9.062162e-04 | yes |
| index.qmd Case 1 | doublings shown divide error by about 2.0, 19.9, 11.9 | `aa_instr.jl` and `indep.py` → ratios 1.982, 19.888, 11.907 | yes |
| index.qmd Case 1 | "For smooth $f$ the error is $O(h^4)$" (general, labelled as such) | standard result; ratios tend to 16 here: 14.958, 15.738, 15.934 (`indep.py`) | yes |
| index.qmd Case 1 | coarse meshes not yet asymptotic; ratio approaches 16 only on finer meshes: 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | `indep.py` → 14.958, 15.738, 15.934 (600-pt grid: 14.958, 15.742, 15.938); shown ratios 2.0, 19.9, 11.9 are all ≥3.9 from 16 | yes |
| index.qmd Case 1 alt | max error falls from 0.425 at n=1 to 0.000906 at n=8 | as row 1 | yes |
| index.qmd Case 2 | frames add weighted terms one at a time and draw the running sum | hermitepolybb.jl `stages` are cumulative sums term1, term1+term2, …; new frames 1–4 viewed | yes |
| index.qmd Case 2 | first two partial sums fall to 0 with zero slope at x = 1 | `indep.py` sympy → S1, S2 value,slope at 1 = 0,0; S1 = (x−1)²(2x+1), S2 = (x−1)²(3x+1) | yes |
| index.qmd Case 2 | because H00 and H10 have zero value and zero slope at 1 | `indep.py` → H00 [H(0),H'(0),H(1),H'(1)] = [1,0,0,0]; H10 = [0,1,0,0] | yes |
| index.qmd Case 2 | (kept) each basis function carries one degree of freedom; H equals f and matches slope at both endpoints | `indep.py` → basis conditions identity; S4 value,slope at 0 = 1,1, at 1 = E,E | yes |
| index.qmd Case 2 alt | running sum, adding one term per frame until complete interpolant | new GIF has 4 frames, each adds one term (`new/bb/sheet.png`) | yes |
| hermitepolyaa.jl title | "Cubic Hermite for sin(x), n = $n  (max err ≈ …)" → 0.425, 0.215, 0.0108, 0.000906 | `aa_instr.jl` round3 column; new frames viewed, fully visible | yes |
| hermitepolyaa.jl comment | "Short title so the 3-significant-figure error fits in the 700-px frame" | `round(err, sigdigits=3)`; frame width 700 (`size=(700, 500)`); new frame 4 fits | yes |
| hermitepolybb.jl ylims/comment | (−0.2, 3.0); first two partial sums fall to 0 at x = 1 | `indep.py` → S1, S2 min 0.0000 at x = 1; all sums in [0, 2.7183] | yes |

## Scripts and GIFs
- Scripts changed: `hermitepolyaa.jl` (title only) and `hermitepolybb.jl` (ylims only). Both were regenerated with `julia <script>.jl` from the page folder, and each GIF still has 4 frames.
- Frames viewed:
  - aa: frames 1 and 4 at full size, plus the contact sheet. The titles are complete and the values are correct.
  - bb: frame 2 at full size, plus the contact sheet. Every partial sum is fully in view and the zero-value, zero-slope end at x = 1 is visible.
  - Committed frames aa/4 and bb/1 were viewed to confirm F2 and F3.
- `git status --short -- pages/numerical-methods/hermite-polynomial-interpolation` after regeneration:
  - M hermitepolyaa.gif
  - M hermitepolyaa.jl
  - M hermitepolybb.gif
  - M hermitepolybb.jl
  - M index.qmd (after the text edits)
  - Both GIF changes are intended.

## Legacy archive
- Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/HermitePolyMod.html` (read as text), the `Links/HermitePolyMod_lnk_1–4.html` files (text, which holds only headers and copyright), and the graph image `HermitePolyMod_gr_6.gif`.
- What it showed:
  - The module covers a single clamped cubic Hermite polynomial on [x0, x1], illustrated by gr_6 (a cubic through (x0,y0) and (x1,y1) with its tangent lines at both ends).
  - Example 1 is a clamped cubic. Examples 2 and 3 are clamped and natural cubic splines, with their data in formula images.
  - It has no sin(x) mesh-refinement example and no e^x basis-build example, so it does not bear on these fixes. The fixed page does not conflict with it.

## Notes
- Not a finding, left untouched: hermitepolyaa.jl lines 61–68 draw a gray "→" glyph at every node. The comment calls these "slope markers", but the glyph is always horizontal, whatever the slope, and the computed `dx_arrow` and `slope` are unused. The glyphs are tiny and mostly hidden behind the node markers. Jason may want to remove them or draw true tangent segments.
- The alternative F1 fix (extending `n_intervals_list` to 16 and 32) was not taken, per D7. The page now quotes those ratios in text instead.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/verify.py` (independent numerics), `check/run/` (scratch copies of both scripts, rerun), `check/frames_new_*` and `check/frames_old_*` (decoded frames of the committed and pre-fix GIFs; the pre-fix GIFs were obtained with `git show HEAD:... | git lfs smudge`).

### Original findings

### F1 — resolved
- The false sentence ("Doubling n decreases the maximum error by approximately 16") is gone. Its replacement gives the shown errors 0.425, 0.215, 0.0108 and 0.000906, the ratios 2.0, 19.9 and 11.9, says the coarse meshes are pre-asymptotic, and gives the finer-mesh ratios 15.0, 15.7 and 15.9.
- Independent check: scipy `CubicHermiteSpline` (sin, cos at n+1 uniform nodes on [0, 2π]). True max error was found by a per-interval dense scan followed by bounded refinement:
  - Errors: n=1 4.253816e-01, n=2 2.146018e-01, n=4 1.079068e-02, n=8 9.062162e-04, n=16 6.058555e-05, n=32 3.849578e-06, n=64 2.415879e-07.
  - Ratios: 1.982, 19.888, 11.907, 14.958, 15.738, 15.934. On the script's 600-point grid they are the same to 3 significant figures (15.742 for 16→32, which still rounds to 15.7).
  - All the numbers in the new sentence round correctly.
- "For smooth f the error is O(h^4)" is true. A sanity check against the standard bound h⁴/384·max|f⁗|: at h=π/4 the bound is 9.9e-4, which is at least the observed 9.06e-4. The measured ratios tend to 16 (16.0 at 64→128).

### F2 — resolved
- The title is now "Cubic Hermite for sin(x), n = $n  (max err ≈ …)". I viewed frames 1–4 of the committed hermitepolyaa.gif at full size. Each title is fully visible, including the closing parenthesis: "≈ 0.425", "≈ 0.215", "≈ 0.0108", "≈ 0.000906". The longest one, frame 4, still fits inside the 700-px canvas.
- These values match my independent errors above. The pre-fix frame 4 shows "≈ 0.000" cut off at the edge, which confirms the original problem.

### F3 — resolved
- `ylims` changed from (0.8, 3.0) to (-0.2, 3.0). Independent values on the script's 400-point grid:
  - p1 = y0·H00: min 0 (at x=1), max 1.
  - p2: min 0, max 1.05350.
  - p3 and p4: min 1, max e = 2.71828.
  - All four partial sums therefore lie inside [-0.2, 3.0].
- I viewed frames 1–4 at full size:
  - Frames 1 and 2 now show the whole curve descending to 0 at x=1 with a flat tangent.
  - Frame 3 rises to e with zero slope at x=1.
  - Frame 4 overlays eˣ.
- The optional suggestion (drawing each term on its own) was not taken. Instead the alt text now says "Running sum of the four weighted Hermite basis terms … adding one term per frame", and the Behavior paragraph says the frames "draw the running sum". The page now describes what is shown, so the mismatch the finding named is gone.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | max errors 0.425, 0.215, 0.0108, 0.000906 | scipy true max 0.4253816, 0.2146018, 0.01079068, 0.0009062162; 600-pt grid the same to 3 sig figs | correct |
| index.qmd Case 1 Behavior | ratios 2.0, 19.9, 11.9 | 1.982, 19.888, 11.907 | correct |
| index.qmd Case 1 Behavior | "error is O(h^4)" for smooth f | ratios → 16 (15.98 at 64→128); h⁴/384·max\|f⁗\| bound holds | correct |
| index.qmd Case 1 Behavior | "coarse meshes not yet in asymptotic range; ratio approaches 2^4 = 16 only on finer meshes" | measured ratio sequence | correct |
| index.qmd Case 1 Behavior | 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | 14.958, 15.738, 15.934 | correct |
| index.qmd Case 1 alt text | "n=1,2,4,8 intervals; max error falls from 0.425 at n=1 to 0.000906 at n=8" | n_intervals_list = [1,2,4,8]; errors above; frame titles | correct |
| index.qmd Case 2 Behavior | "frames add the weighted terms one at a time and draw the running sum" | script `stages` are cumulative sums; frames 1–4 viewed | correct |
| index.qmd Case 2 Behavior | "first two partial sums fall to 0 with zero slope at x = 1, because H00 and H10 have zero value and zero slope there" | sympy: H00(1)=0, H00'(1)=0, H10(1)=0, H10'(1)=0; p1(1)=p2(1)=0 numerically; visible in frames 1–2 | correct |
| index.qmd Case 2 alt text | "Running sum of the four weighted Hermite basis terms for e^x on [0,1], adding one term per frame until it forms the complete cubic Hermite interpolant" | 4 frames, cumulative; frame 4 = full H, which matches eˣ at the ends (sympy: p4 slope 1 at t=0, e at t=1) | correct |
| hermitepolyaa.jl:53–54 | new comment and title string | frames 1–4 fully legible; values correct | correct |
| hermitepolybb.jl:40–41 | new comment ("first two partial sums … fall to 0 at x = 1"), ylims (-0.2, 3.0) | min of p1 and p2 is 0, at x=1; all sums within [0, e] | correct |

### New problems

None. This rests on four things:
- Every changed sentence, number and label was checked above by independent computation (scipy, sympy).
- I viewed all 4 frames of each regenerated GIF at full size.
- Nothing that was right before broke. The curves, legends and endpoint markers are unchanged apart from the y-window and the title text.
- Both GIFs reproduce byte for byte.

Pre-existing items that the fix did not touch and that were not in the findings (noted only, not counted as new problems):
- hermitepolyaa.jl calls them "slope markers". They are a fixed horizontal "→" glyph at every node, independent of the slope, and almost hidden under the node dots.
- hermitepolybb.jl has two inaccurate comments:
  - "Frames: show basis functions one at a time, then cumulative sum": only cumulative sums are drawn.
  - "Endpoint markers with slope arrows": no arrows are drawn.

These are comments in the source, not page claims.

### Reproducibility and conventions

- Both scripts were copied to `check/run/` and run with `julia <script>.jl`. `cmp` against the committed files shows both identical:
  - hermitepolyaa.gif, sha256 dc90d82f…4d55
  - hermitepolybb.gif, sha256 a760e60e…8e83
- Conventions still hold:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks.
- Within the page folder, only the 5 files listed in the diff changed.
- Outside `pages/numerical-methods`, the working tree has workflow review logs under `reviews/numerical-methods-animations/fixes/`:
  - an untracked `hermite-polynomial-interpolation.md`;
  - other pages' logs, including a modified `runge-kutta-method.md`.

  None of these are site pages. The modified runge-kutta log belongs to another page's fix, not this one.

**Final status:** committed
