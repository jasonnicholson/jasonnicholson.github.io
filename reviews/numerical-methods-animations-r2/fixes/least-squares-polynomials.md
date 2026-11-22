# Fix record: least-squares-polynomials

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/least-squares-polynomials/fix/`
- `check.py`: independent sympy/numpy checks (`/usr/bin/python3 -I check.py`)
- `up.jl`: upscales first frames of archive images to `arch/` (`julia up.jl <outdir> <gif>...`)

## Findings

### F1 — Minor (Fidelity) — fixed (R2-A one-sentence "not animated here" note)
- **Reproduced:** Yes. The archive module (`n2003/LeastSqPolyMod.html` and its links) has Examples 1–8. The page animates only Examples 2–5 (degree 2, 3, 4 and 5 fits of the six points). Example 1 (a least-squares parabola for a different 8-point set), the Example 6 graph (`lnk_7`, `gr_85`, code `gr_84`: `Show[graph2, graph3, graph4, graph5, dots, PlotRange -> {{-10, 10}, {-20, 9}}]`) and Example 7 (`lnk_8`, data `gr_86`) are not animated, and the page did not say so. `check.py` gives the same numbers as the review for the page's p2–p5 at x = -10 (-8.175, -10.326, -16.189, -23.953) and x = 10 (2.397, 4.815, -2.228, 8.082). On the data interval [-4.5, 4.1] the four fits differ by at most 0.0921. On [-10, -4.5] they differ by up to 15.778, and on [4.1, 10] by up to 10.310. At the window edge x = -5, p4 = -0.063 and p5 = -0.107, which `ylims=(0, 6.2)` clips.
- **Change:** `index.qmd`, added two source lines, first after the last embed and then moved after the check to the end of the Animations intro (see "Round 2 after check"), that form one paragraph. They follow the Monte Carlo R2-A pattern:
  > The four cases animate Examples 2–5 of Mathews' Least Squares Polynomials module, which fit the least-squares quadratic, cubic, quartic and quintic to the six data points above.
  > The module's Example 1, which fits a least-squares parabola to a different set of points, the graph in Example 6, which plots the quadratic to quintic fits together on an interval wide enough to show them separating outside the data, and Example 7, which fits the same degrees to points sampled from a non-polynomial function to show polynomial wiggle, are not animated here.
- **Why this option:** R2-A says that when a whole Mathews example is left out, the fixer adds one sentence and does not add the example. Example 6's wide view is a separate multi-curve comparison graph, not a parameter of an existing case. Widening the existing partial-sum windows to [-10, 10] would compress the y-range to about [-24, 8] and hide the residual segments that the cases are about. The Description's "can exhibit oscillations … and poor extrapolation" and Case 4's "may still be fragile for extrapolation" are general statements hedged with "can"/"may". They are true for this data (numbers above) and for the Example 7 data (below), so they are left as they are.
- **Check:** see the ledger. `git diff` shows only the 2 added lines in `index.qmd`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd, end of Animations intro (before Case 1), line 1 | "The four cases animate Examples 2–5 of Mathews' Least Squares Polynomials module" | `sed 's/<[^>]*>//g' n2003/LeastSqPolyMod.html` → Ex 2/3/4/5 = "polynomial curve fit of degree = 2/3/4/5", "Least Square Quadratic/Cubic/Quartic/Quintic". Data images: `md5sum gr_38 gr_52 gr_60 gr_68` → all `d472f286…` (identical). Viewed `gr_38` (upscaled): (-4.5,0.7),(-3.2,2.3),(-1.4,3.8),(0.8,5.0),(2.5,5.5),(4.1,5.6) = page data. `grep '^m =' *.jl` → aa 2, ab 3, ac 4, ad 5 | yes |
| same | "which fit the least-squares quadratic, cubic, quartic and quintic to the six data points above" | same as above; the six points are listed in the Description | yes |
| line 2 | "Example 1, which fits a least-squares parabola to a different set of points" | Statement `gr_9` = "a + b x + c x²", `gr_10` = (-1,10),(0,9),(1,7),(2,5),(3,4),(4,3),(5,0),(6,-1). `check.py` → fit −x²/56 − 85x/56 + 69/8 (c ≠ 0, so a parabola). The solution graph `gr_31` plots different points, (-1,10),(0,6),(1,2),(2,1),(3,0),(4,2),(5,4),(6,7), which is an archive inconsistency. That set fits 2x²/3 − 26x/7 + 118/21 (c ≠ 0). Neither set is the page's six points, so "different set of points" holds for both. No points are named on the page | yes |
| line 2 | "the graph in Example 6, which plots the quadratic to quintic fits together on an interval wide enough to show them separating outside the data" | `lnk_7` images: `gr_84` code `Show[graph2, graph3, graph4, graph5, dots, PlotRange -> {{-10,10},{-20,9}}]`. Viewed `gr_85`: four curves and six red dots. The curve values at x = -10 match p2 ≈ -8.2, p3 ≈ -10.3, p4 ≈ -16.2, p5 off-scale (< -20). `check.py` → max spread of p2..p5 on [-4.5, 4.1] = 0.0921; on [-10, -4.5] = 15.778; on [4.1, 10] = 10.310 | yes |
| line 2 | "Example 7, which fits the same degrees" | `lnk_8` text: "least squares polynomial fits of degree n = 2, 3, 4, 5" | yes |
| line 2 | "to points sampled from a non-polynomial function" | `gr_86` (viewed): (0.25,23.1),(1.0,1.68),(1.5,1.0),(2.0,0.84),(2.4,0.826),(5.0,1.2576). `lnk_8` remark: "The points were obtained from [image missing] which is not polynomial." Independently, `check.py` → all six residuals against g(x) = 1.44/x² + 0.24x are exactly 0 (rational arithmetic), and g → +∞ as x → 0⁺, so g is not a polynomial. The formula is not written on the page | yes |
| line 2 | "to show polynomial wiggle" | `LeastSqPolyMod.html`: "This phenomenon is called 'polynomial wiggle.' The next example illustrates this concept." `check.py` on [0.25, 5]: g has 1 critical point (x ≈ 2.289). The fits have 1, 2, 3 and 4 critical points for degrees 2–5. p4 dips to −17.855 at x ≈ 4.204, where the data are near 1. p5 interpolates and rises to 31.216, above the largest datum 23.1. Max \|p − g\| on [1, 5] is 6.837, 11.170, 18.946 and 30.092 | yes |
| line 2 | "are not animated here" | Page cases: aa–ad = m 2–5 on the six-point data only. No other scripts or GIFs in the folder (`ls`) | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. F1 is a text-only fix under R2-A.
- `git status --short -- pages/numerical-methods/least-squares-polynomials` → ` M pages/numerical-methods/least-squares-polynomials/index.qmd` only.

## Legacy archive
- Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/LeastSqPolyMod.html`, `leastsquarespoly/LeastSqPolyMod/Links/LeastSqPolyMod_lnk_1..9.html`, images gr_9, gr_10, gr_30, gr_31, gr_38 (= gr_52 = gr_60 = gr_68 = gr_120 by md5), gr_84, gr_85, gr_86. No animated GIF exists for this topic; the page's cases are reconstructions of Examples 2–5.
- Link mapping: lnk_2 = Ex 1, lnk_3–6 = Ex 2–5, lnk_7 = Ex 6, lnk_8 = Ex 7, lnk_9 = Ex 8.
- Example 6's text answers "why is the RMS error for the quintic essentially zero", which Case 4 already explains. Its "blow up outside the interval" warning and the wide graph are the parts that are not animated.
- Example 7's function image and plots (gr_88–gr_103) are missing from the archive. The data image is present. The generator 1.44/x² + 0.24x was identified by exact fit and is not stated on the page.
- Archive inconsistency: Example 1's statement data (gr_10) and the points in its solution graph (gr_31) differ. The page sentence does not depend on which set is meant.
- Example 8 (lnk_9; data gr_120 identical to the six points) refits the cubic by building the linear-least-squares matrices and solving the normal equations. That is the computation the page's scripts already perform for Case 2, so it is not listed as left out.

## Round 2 after check
- The checker found a Minor placement problem. The note sat after the Case 4 embed, under the "Case 4 - Quintic fit" heading, so it read as part of Case 4. Its content checked out.
- **Change:** I moved the two lines, with the wording unchanged, to the end of the Animations section's introductory text. They now sit after "Julia source scripts … are linked under each case." and before "### Case 1 - Quadratic fit". The page has no legacy/source note outside the case subsections.
- "The six data points above" still reads correctly from the new place: the six points are listed in the Description, which comes before the Animations section.
- **Check:** `git diff -- pages/numerical-methods/least-squares-polynomials` shows only 3 inserted lines (the note and a blank line) between the intro and the Case 1 heading. The end of the file is unchanged from HEAD.

## Notes
- The cosmetic clipping of p4/p5 below y = 0 at x = -5 (−0.063, −0.107) under `ylims = (0.0, 6.2)` is mentioned in the finding only as evidence, not as a defect. Left unchanged.
- No other files touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix is text only. It adds two sentences at the end of `index.qmd`. No script or GIF changed. This is the third remedy the finding offered ("say in one sentence that these archive examples are not animated here"), and it is what R2-A asks for when a whole Mathews example is left out ("Add one sentence ... Do not add the example").
- I checked every claim in the note against the archive (`n2003/LeastSqPolyMod.html`, `leastsquarespoly/LeastSqPolyMod/Links/*_lnk_{2..9}.html`, `Images/`):
  - The module has Examples 1–8. lnk_2 is Ex 1, lnk_3–6 are Ex 2–5, lnk_7 is Ex 6, lnk_8 is Ex 7 and lnk_9 is Ex 8.
  - **Ex 1** is "Find the standard least squares parabola". Its data image `gr_10.gif` holds the 8 points (-1,10), (0,9), (1,7), (2,5), (3,4), (4,3), (5,0), (6,-1). That is a different set from the page's, so the note's "a least-squares parabola to a different set of points" is correct.
  - **Ex 2–5** ask for the "Least Square Quadratic / Cubic / Quartic / Quintic" and the RMS error. Their data images `gr_38`, `gr_52`, `gr_60` and `gr_68` are byte-identical (`cmp`). `gr_38` shows (-4.5,0.7), (-3.2,2.3), (-1.4,3.8), (0.8,5.0), (2.5,5.5), (4.1,5.6), which is the page's dataset. So the note's "Examples 2–5 ... fit the least-squares quadratic, cubic, quartic and quintic to the six data points above" is correct.
  - **Ex 6** asks "Why is the RMS error for p5[x] essentially zero?" It has two graphs:
    - `gr_83`: `Show[graph2..graph5, dots, PlotRange->{{-4.5,4.1},{0,6}}]`, where the four curves coincide;
    - `gr_85`: `PlotRange->{{-10,10},{-20,9}}`, where the curves fan out left of -5 and right of about 5, under "Things might 'blow up' outside the interval where the data is located".

    The note's "the graph in Example 6, which plots the quadratic to quintic fits together on an interval wide enough to show them separating outside the data" picks out `gr_85` correctly. The numbers back it up (numpy.polyfit). At x=-10, p2..p5 = -8.175, -10.326, -16.189, -23.953. At x=10 they are 2.397, 4.815, -2.228, 8.082. At the data ends the spread is ≤0.07.
  - **Ex 7** asks for "least squares polynomial fits of degree n = 2, 3, 4, 5". Its points (`gr_86`) are (0.25,23.1), (1.0,1.68), (1.5,1.0), (2.0,0.84), (2.4,0.826), (5.0,1.2576). The remark says "The points were obtained from [f, image gr_99 not in the archive] which is not polynomial." It is introduced by "This phenomenon is called 'polynomial wiggle.' The next example illustrates this concept." So "fits the same degrees to points sampled from a non-polynomial function to show polynomial wiggle" is correct. The wiggle is real (numpy):
    - p5 interpolates (RMS 0) yet reaches 31.2 on [2.4,5], where the data are ≤1.26;
    - p4 dips to -17.9 near x=4.2;
    - p2 dips to -5.2 near x=3.3.
  - **Ex 8** (linear least-squares, cubic) is not mentioned. The finding said that omission is acceptable because it repeats Case 2's cubic.
- The Description's caution ("polynomial wiggle", poor extrapolation) and Case 4's "fragile for extrapolation" are unchanged. They are true, and the page now says openly that the archive examples showing them are not animated. That resolves the "dropped without a word" complaint.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| End of page, sentence 1 | "The four cases animate Examples 2–5 of Mathews' Least Squares Polynomials module" | lnk_3..lnk_6 are Examples 2–5; module title "Least Squares Polynomials" | True |
| same | "which fit the least-squares quadratic, cubic, quartic and quintic to the six data points above" | Example prompts and identical data images gr_38/52/60/68 = page dataset | True |
| End of page, sentence 2 | "The module's Example 1, which fits a least-squares parabola to a different set of points" | lnk_2 and gr_10 (8 different points) | True |
| same | "the graph in Example 6, which plots the quadratic to quintic fits together on an interval wide enough to show them separating outside the data" | gr_84/gr_85: graph2..graph5 on [-10,10]; numpy spread at ±10 is several units vs ≤0.07 at the data ends | True. "the graph" is slightly loose, because Ex 6 also has a data-interval graph (gr_83), but the relative clause identifies the right one |
| same | "Example 7, which fits the same degrees to points sampled from a non-polynomial function to show polynomial wiggle" | lnk_8: degrees 2,3,4,5; remark "obtained from ... which is not polynomial"; main page introduces it as illustrating "polynomial wiggle"; numpy confirms the overshoot | True |
| same | "are not animated here" | No case uses the Ex 1 data, the [-10,10] window or the Ex 7 data (the scripts and GIFs did not change, and all four use the six-point set) | True |

### New problems
- Minor (placement, optional): the two-sentence note is the last paragraph under the `### Case 4 - Quintic fit` heading. It reads as part of Case 4 (and sits there in the TOC), although it is about the whole page. Putting it at the end of the `## Animations` intro paragraph, or right after the Description's last paragraph, would scope it better. Nothing in it is false.
- No other new problems. This rests on the ledger above and on the fact that the diff is two added lines with no script or GIF changes.

### Reproducibility and conventions
- No script or GIF changed (`fix.diff` lists only `index.qmd`, and `git diff HEAD --stat` on the page folder shows 2 insertions). There was nothing to regenerate.
- Conventions:
  - Description comes before Animations.
  - Each of the four cases still has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks (0 fences).
  - The file ends with a newline.
- Outside the page folder: the working tree has changes on other pages, from other page fixes in this round, plus untracked fix records under `reviews/`. The diff for this page touches only `pages/numerical-methods/least-squares-polynomials/index.qmd`. No tracked file outside `pages/numerical-methods/` is modified.

### Re-check

Re-checked after the note was moved. I read the updated `fix.diff` (blob 34617f4), `git diff HEAD --stat` for the page folder, and the file itself.

- **Nothing else changed.** The diff is a single hunk: 3 insertions (the two sentences plus a blank line) after "Julia source scripts ... are linked under each case." and before `### Case 1`. There are no deletions. The old placement under Case 4 is gone: the file's tail is unchanged from HEAD and ends with the Case 4 GIF embed. Only `index.qmd` is modified in the page folder, and no script or GIF changed. The wording is character-for-character the same as the version checked above.
- **It now reads as page-level.** The note is the last paragraph of the `## Animations` introduction, before any `###` case heading. It sits with the other page-wide intro paragraphs and is no longer scoped to Case 4 in the TOC.
- **The wording is still true where it sits.**
  - "The four cases" now points forward to Cases 1–4 directly below, which are the quadratic to quintic fits. That is correct.
  - "the six data points above" still refers to the displayed dataset in the Description, which is above the note.
  - "are not animated here" means on this page, which is still correct.
  - The archive facts are unchanged. I verified them in the ledger above.
- **The earlier Minor placement problem is resolved.**
- F1 remains resolved. There are no new problems.

**Final status:** committed
