# Fix record: derive-numerical-differentiation-formulae

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/derive-numerical-differentiation-formulae/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced: Read the legacy module as text: `sed 's/<[^>]*>//g' n2003/NumericalDiffFormulaeMod.html | sed '/^[[:space:]]*$/d'` and the same for `differentiationformulae/NumericalDiffFormulaeMod/Links/NumericalDiffFormulaeMod_lnk_{1,2,3}.html`. No concrete function is named anywhere; all derivations use a symbolic `f[x0 + j h]`. Listed every image with HEIGHT ≥ 90 (`grep -ohi 'gr_[0-9]*.gif"[^>]*HEIGHT="*[0-9]*' ... | awk -F'HEIGHT=' '$2>=90'`, 25 entries) and viewed gr_35, gr_105, gr_128, gr_135, gr_193, gr_199, gr_201, gr_211, gr_219: all are Mathematica input or symbolic output (the Taylor systems, the solved three- and five-point central formulas, the `BackwardDiff` subroutine, and the backward/forward difference tables). None evaluates a concrete f and none is a plot. The page's "legacy test function" attribution is therefore false.
- Change: `index.qmd` line 18, "…using the legacy test function $f(x)=e^{-x}\sin(x)$." → "…to the test function $f(x)=e^{-x}\sin(x)$ … The legacy module derives the formulas symbolically and has no numerical example, so this function was chosen for this page." (full new text in the ledger)
- Check: `git diff` shows only line 18 changed. The function is `f(x) = exp(-x) * sin(x)` in all three scripts (`grep -n 'f(x) =' *.jl`: diffformaa.jl:8, diffformab.jl:9, diffformac.jl:9).

### F2 — Minor — fixed
- Reproduced: `grep -n 'd1_\|d2_\|label' *.jl`. diffformab.jl computes `approx3 = d1_3`, `approx5 = d1_5` (l.26-27) and plots "three-point estimate" and "five-point estimate" (l.58-59). diffformac.jl computes `y3 = d2_3`, `y5 = d2_5` (l.26-27) and plots "3-point d2" and "5-point d2" (l.50-51). diffformaa.jl uses only `d1_3`. Frame 1 of each committed GIF (extracted with giftools.jl into `committed/<gif>/frame_001.png`) shows two estimate curves in the Case 2 and Case 3 legends and one ("formula slope") in Case 1. "One derived stencil formula" per animation is false for Cases 2 and 3.
- Change: same sentence as F1; now says Case 1 shows the three-point first-derivative formula and Cases 2 and 3 compare three-point and five-point stencils for the first and second derivative.
- Check: `check_stencils.py` (sympy, in scratch folder) confirms each script stencil's offsets, derivative and order (output in the ledger).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.18 | "applies the derived central-difference stencils" | `/usr/bin/python3 -I check_stencils.py` → aa d1_3 offsets [-1,1]; ab d1_3 [-1,1], d1_5 [-2,-1,1,2]; ac d2_3 [-1,0,1], d2_5 [-2,-1,0,1,2]; all `symmetric True` (central) | yes |
| index.qmd l.18 | "to the test function $f(x)=e^{-x}\sin(x)$" | `grep -n 'f(x) =' *.jl` → `exp(-x) * sin(x)` in all three scripts | yes |
| index.qmd l.18 | "Case 1 shows the three-point first-derivative formula" | diffformaa.jl uses only `d1_3` (l.11, 27); check_stencils → derivative 1, error h^2; frame_001 legend: one estimate ("formula slope") | yes |
| index.qmd l.18 | "Cases 2 and 3 compare the three-point and five-point stencils for the first and the second derivative" | diffformab.jl `d1_3`,`d1_5` (derivative 1); diffformac.jl `d2_3`,`d2_5` (derivative 2), per check_stencils; frame_001 of each shows both estimates in the legend | yes |
| index.qmd l.18 | "The legacy module derives the formulas symbolically and has no numerical example" | Archive HTML text (main + lnk_1..3) names no function; all 25 graph-sized image entries are Mathematica code/symbolic output, 9 viewed (list in F1); the module's `.nb` is not in the archive. `ls a2001/Animations/Derivative/`: those animations link to `n2003/NumericalDiffMod.html` (the other numerical-differentiation module), not this one (`grep -o '<A HREF="[^"]*"' Derivative/Derivative.html`) | yes |
| index.qmd l.18 | "so this function was chosen for this page" | follows from the line above | yes |

No numbers were added or changed.

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (both findings are text-only, D7).
- Frames viewed (committed GIFs, via giftools.jl): frame_001 of diffformaa (12 frames), diffformab (11), diffformac (11), to confirm the legend contents.
- `git status --short -- pages/numerical-methods/derive-numerical-differentiation-formulae` → ` M .../index.qmd` only.

## Legacy archive
- Consulted: `n2003/NumericalDiffFormulaeMod.html` and `n2003/differentiationformulae/NumericalDiffFormulaeMod/` (Links lnk_1-3, Images). It is a purely symbolic Mathematica derivation (three- and five-point central formulas, with f''' and f'''' at five points, plus forward/backward difference subroutines and tables). It has no numerical function, step size or plot, so it offers no parameters to follow under R2-A.
- a2001: `ls Animations | grep -i diff` returns nothing, as the reviewer said, but there is an `Animations/Derivative/` folder ("Animations for Numerical Differentiation": forward, backward and central difference GIFs). Its links all point to `n2003/NumericalDiffMod.html` (and RichardsonExtrapMod), not to this module, so it belongs to the numerical-differentiation page, not this one. It does not change F1.

## Notes
- R3-D: this page has no "not animated here" sentence, so there is nothing to move. (The R3-D list's "Numerical Differentiation" is the separate `numerical-differentiation` page.) The archive's forward/backward formulas and the five-point f''', f'''' formulas are not on the page; the reviewer did not count this as a dropped example because the module has no numerical examples to drop, and no finding asks for a sentence, so none was added.
- Nothing outside the page folder was touched apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The phrase "the legacy test function" is gone from `index.qmd` line 18. The new sentence says: "The legacy module derives the formulas symbolically and has no numerical example, so this function was chosen for this page." I checked this myself:
  - Plain text of `NumericalDiffFormulaeMod.html` and lnk_1 to lnk_3 (tags stripped): no exp, sin, cos, "example" or named f. The text describes only Taylor series, Solve, Normal and ReplaceAll, plus the forward/backward subroutines.
  - Graphics images viewed: gr_105 (Taylor equations for f[x0 +/- h], f[x0 +/- 2h]), gr_201 (backward 4-point formulas), gr_219 (forward 8-point formulas). All are symbolic in f[...] and h. None evaluates a concrete function.
- The sentence sits in the Animations intro, before Case 1, as a statement about the source. That matches the placement in R3-D.

### F2 — resolved
- Evidence: "visualizes one derived stencil formula" is replaced by: "Case 1 shows the three-point first-derivative formula, and Cases 2 and 3 compare the three-point and five-point stencils for the first and the second derivative." This matches the scripts and frames:
  - `diffformaa.jl` draws only d1_3. Frame 1 legend: f(x), formula slope, true tangent, x0-h/x0/x0+h.
  - `diffformab.jl` draws d1_3 and d1_5. Frame 1 legend has both "three-point estimate" and "five-point estimate", and both errors are printed.
  - `diffformac.jl` draws d2_3 and d2_5. Frame 1 legend has "3-point d2" and "5-point d2".
- "Respectively" is implied by "first and the second": Case 2 is the first derivative and Case 3 the second.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd L18 | "applies the derived central-difference stencils" | All four stencils in the scripts are symmetric about x (d1_3, d1_5, d2_3, d2_5). Step halving at x0=1 in mpmath (50 digits), h=1/8..1/128, gives observed orders 2.000, 4.000, 2.000, 4.000. These are the correct central formulas. | correct |
| index.qmd L18 | "test function f(x)=e^{-x} sin(x)" | f(x)=exp(-x)*sin(x) in all three scripts | correct |
| index.qmd L18 | "Case 1 shows the three-point first-derivative formula" | diffformaa.jl L11/L27; frame 1 viewed | correct |
| index.qmd L18 | "Cases 2 and 3 compare the three-point and five-point stencils for the first and the second derivative" | diffformab.jl L26-27/L58-59; diffformac.jl L26-27/L50-51; frame 1 of each viewed | correct |
| index.qmd L18 | "The legacy module derives the formulas symbolically and has no numerical example" | legacy text dump and images gr_105, gr_201, gr_219 (see F1) | correct |
| index.qmd L18 | "so this function was chosen for this page" | follows from the line above; it is an attribution, not a math claim | acceptable |

### New problems
None. This rests on three things:
- The diff is one sentence, and every clause in it is checked above.
- No script or GIF changed, so no picture can have broken.
- The sentence agrees with the unchanged case headings and Behavior paragraphs:
  - Case 2's heading names the five-point formula, and its Behavior paragraph compares it with the three-point one.
  - Case 3's Behavior paragraph compares the two stencils.

### Reproducibility and conventions
- Changed files: `git status` of the page folder shows only `index.qmd` modified. The .jl and .gif files are unchanged, so there was nothing to regenerate or compare by bytes. I viewed the first frames of the committed GIFs to check the new sentence against them.
- Conventions kept:
  - Description comes before Animations.
  - Each of the 3 cases has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - The page has no code blocks (0 fences).
- Outside the page folder: `fix.diff` touches only this page's `index.qmd`. Other pages are modified in the working tree, but they are not part of this fix's diff, and I attribute them to other pages' fixes.

**Final status:** committed
