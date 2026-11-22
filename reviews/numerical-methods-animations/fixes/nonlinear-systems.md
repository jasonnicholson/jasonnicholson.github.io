# Fix record: nonlinear-systems

Scratch folder (all scripts and outputs below): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/nonlinear-systems/fix/`
(`check.py` → `check.out`, `errs.py` → `errs.out`, `basin.py` → `basin.out`, `detJ.out`, `frames_newtonsysaa/`, `frames_newtonsysab/`). Python is `/usr/bin/python3 -I`.

All four findings were text errors; both animations are correct, so no script was changed and no GIF was regenerated.

## Findings

### F1 — Misleading — fixed
- Reproduced: `python3 check.py`. Reviewer's map G(x,y) = (0.6x + 0.6y + 0.05 sin y, 0.1y): Jacobian at (0,0) has row sums [1.25, 0.1] and eigenvalues [0.6, 0.1]; 60 iterations from (5,-3) give (6.5e-14, -3e-60), which converges. My own linear example A = [[0.5, 1.0], [-0.1, 0.2]]: row sums [1.5, 0.3] (condition fails), eigenvalues 0.35 ± 0.278i, spectral radius 0.4472; 200 iterations from 100 random starts in [-1,1]² give max |X| = 3.5e-70. So the row-sum condition is sufficient but not necessary, and "diverges regardless of how close the starting point is" is false.
- Change: index.qmd:38 "When these inequalities are violated the iteration typically diverges, regardless of how close the starting point is." → "The row-sum condition is sufficient, not necessary. When it fails, convergence is no longer guaranteed, but the iteration can still converge: from starts sufficiently close to X* it converges whenever the spectral radius (the largest eigenvalue magnitude) of the Jacobian of G at X* is less than 1." index.qmd:65 table cell "Requires row-sum condition" → "Row-sum condition is sufficient (not necessary)".
- Check: the new sentence is the standard local-convergence theorem for C¹ maps (spectral radius < 1 ⇒ local convergence); the row-sum test is ‖J_G‖_∞ < 1, which bounds the spectral radius, so it is the stronger (sufficient) test. Both counterexamples above have row-sum test failing and spectral radius < 1, and both converge.

### F2 — Minor — fixed
- Reproduced: `python3 check.py`. Resultant in x has exactly two real roots, so there are exactly two real intersections: S1 = (0.0617701263, 0.7244905153), S2 = (1.5560974843, -0.5756507696). f2 = 0 is 4y⁴ + 4y = 4 - x⁴; h(y) = 4y⁴ + 4y has minimum -1.88988 at y = -0.629961, so the curve spans |x| ≤ 1.55785 with rightmost point (1.55785, -0.629961); exactly two y-values at x = 0, 0.5, 1, 1.5, 1.55 (e.g. x = 0: y ∈ {-1.2207, 0.7245}). No inner/outer loop. Distance S2 to rightmost point = 0.0543. Lowest point of f1 = 0 is y = -0.7937 (x = 1); f2 = 0 reaches y = -1.2207. |y*| = 0.576 < 0.724 (S1). Newton errors for Case 2 (mpmath, `errs.py`): 0.6141, 0.2142, 0.03367, 0.0010515, 1.0583e-6, 1.0757e-12, so the first step does not bring the iterate "close". Final frame of newtonsysab.gif (frame_009.png) shows S2 at the right-hand tip of the red curve.
- Change: index.qmd:90 "…the intersection near the bottom of the curves. This solution has a large negative y component and lies at the outer loop of the f₂ = 0 curve. Again convergence is quadratic: the first step brings the iterate close to the solution, and subsequent steps nail it to full precision." → "…the lower-right intersection, where the blue curve crosses the red curve f₂ = 0 close to its rightmost point (1.5579, −0.6300). Again convergence is quadratic: from the start through step 5 the distance to the solution falls 0.61 → 0.21 → 0.034 → 1.1×10⁻³ → 1.1×10⁻⁶ → 1.1×10⁻¹², each error roughly the square of the previous one."
- Check: numbers from `errs.out`; ratios e_{k+1}/e_k² = 0.568, 0.734, 0.928, 0.957, 0.96 (roughly the square). "crosses": det J(S2) = 32.08, gradients 45.4° apart (`detJ.out`), a transversal crossing. "lower-right": S2 is right of and below S1 and right of/below the centre of the window (x 1.556 > 1.25, y -0.576 < -0.125). Alt text and GIF title already consistent (unchanged).

### F3 — Minor — fixed
- Reproduced: `python3 check.py`: f1(0.5,0.8) = -1.5240, f2(0.5,0.8) = +0.9009. At x = 0.5, f2 = 0 has y ∈ {-1.2182, 0.7182} (start is 0.0818 above the top) and f1 = 0 has y = -0.6300. Frame 1 of newtonsysaa.gif shows the start just above the flat top of the red curve. Note: the reviewer's "No part of either curve lies above it" is not right for the whole window: the blue curve reaches y = 1.0204 at x = -0.25. So the fix states the position at x = 0.5 only.
- Change: index.qmd:82 "Starting in the upper region between the two curves," → "Starting just above the red curve and well above the blue curve at x = 0.5,".
- Check: 0.8 - 0.7182 = 0.0818 above red; 0.8 - (-0.6300) = 1.43 above blue (`check.out`).

### F4 — Minor — fixed
- Reproduced: on this page g is the second equation (line 14) or the fixed-point components g1, g2 (line 30); neither has a scalar derivative g'. sympy Jacobian of N(X) = X − J⁻¹F at S1 and S2 is zero to ~1e-40 (`check.out`), but the animation shows the error sequence, not that Jacobian.
- Change: index.qmd:82 "The path reaches machine precision in a few steps, demonstrating |g'(x*)| ≈ 0 — quadratic convergence in 2D." → "From the start through step 5 the distance to the solution falls 0.44 → 0.24 → 0.024 → 3×10⁻⁴ → 5×10⁻⁸ → 1×10⁻¹⁵, each error roughly the square of the previous one (quadratic convergence)."
- Check: `errs.out` Case 1: 0.44469, 0.23671, 0.023738, 0.00029233, 4.5688e-8, 1.1165e-15; ratios e_{k+1}/e_k² = 1.2, 0.424, 0.519, 0.535, 0.535. Float64 iteration as in the script gives the same first six errors (0.445 … 1.08e-15, `check.out`).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:38 | "sufficient, not necessary" | check.py → reviewer G: row sums 1.25/0.1, eig 0.6/0.1, converges to (6.5e-14, -3e-60); own A: row sums 1.5/0.3, ρ = 0.4472, max |X_200| = 3.5e-70 | yes |
| index.qmd:38 | "converges whenever the spectral radius … is less than 1" (local, sufficiently close starts) | standard theorem (C¹ map, ρ(J_G(X*)) < 1 ⇒ local convergence); consistent with both examples above | yes (general statement, labelled as such) |
| index.qmd:65 | "Row-sum condition is sufficient (not necessary)" | same as line 38 | yes |
| index.qmd:82 | "just above the red curve" | check.py → red top at x = 0.5 is 0.7182, gap 0.0818 | yes |
| index.qmd:82 | "well above the blue curve at x = 0.5" | check.py → blue at x = 0.5 is y = -0.6300, gap 1.43 | yes |
| index.qmd:82 | 0.44, 0.24, 0.024, 3×10⁻⁴, 5×10⁻⁸, 1×10⁻¹⁵ | errs.py → 0.44469, 0.23671, 0.023738, 2.9233e-4, 4.5688e-8, 1.1165e-15 | yes |
| index.qmd:82 | "each error roughly the square of the previous one" | errs.py → e_{k+1}/e_k² = 1.2, 0.424, 0.519, 0.535, 0.535 | yes |
| index.qmd:90 | "lower-right intersection" | check.py → only two real intersections (resultant); S2 = (1.5561, -0.5757) right of and below S1 = (0.0618, 0.7245) | yes |
| index.qmd:90 | "blue curve crosses the red curve" | detJ.out → det J(S2) = 32.08, gradients 45.4° apart | yes |
| index.qmd:90 | rightmost point (1.5579, −0.6300); "close to" | check.py → (1.55785, -0.629961); distance from S2 = 0.0543 | yes |
| index.qmd:90 | 0.61, 0.21, 0.034, 1.1×10⁻³, 1.1×10⁻⁶, 1.1×10⁻¹² | errs.py → 0.6141, 0.2142, 0.03367, 1.0515e-3, 1.0583e-6, 1.0757e-12 | yes |
| index.qmd:90 | "each error roughly the square of the previous one" | errs.py → e_{k+1}/e_k² = 0.568, 0.734, 0.928, 0.957, 0.96 | yes |
| index.qmd:82, 90 | Solutions (0.0618, 0.7245), (1.5561, −0.5757) (unchanged, re-checked) | check.py → mpmath findroot 0.0617701263, 0.7244905153; 1.5560974843, -0.5756507696 (matches Mathews' 1.5560974843220556, -0.5756507696188449) | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (both animations are correct: Newton steps solve J ΔX = −F with the right Jacobian; labels round to 4 digits and show correct values).
- Frames viewed (`giftools.jl`, 9 frames each): newtonsysaa frame 1 (start (0.5, 0.8) just above the red curve; blue curve reaches y ≈ 1.02 at the left edge), newtonsysab frame 9 (x⁽⁸⁾ = (1.5561, -0.5757) at the right-hand tip of the red curve; red curve is cut by the left window edge, which is why the text says "red curve" rather than "closed curve").
- `git status --short -- pages/numerical-methods/nonlinear-systems` after editing: ` M pages/numerical-methods/nonlinear-systems/index.qmd` only.

## Legacy archive
Consulted: `n2003/NewtonSystemMod.html` (FixPointNewtonMod.html is the same module) and `newtonsystem/NewtonSystemMod/Links/NewtonSystemMod_lnk_2.html`, `_lnk_3.html`. Mathews' Examples 1 (fixed-point) and 2 (Newton) use this same system; his quoted second solution (1.5560974843220556, -0.5756507696188449) agrees with my mpmath root. His starting points are in formula images and were not needed. His theorem states the row-sum condition as a sufficient condition ("We now turn to the study of sufficient conditions which will guarantee convergence") and adds "If these conditions are not met, the iteration might diverge, which is usually the case"; in Example 1 he shows fixed-point iteration failing near Solution 2 where the row sum is too big. That is consistent with the fixed page, which keeps the condition as sufficient and drops the page's stronger claim that the iteration diverges however close the start is.

## Notes
- Not a listed finding, not changed: index.qmd:76 says Newton's method "reaches the intersection within a handful of iterations from anywhere in the basin". `basin.py` (151×151 grid of starts over x ∈ [-0.25, 2.75], y ∈ [-1.5, 1.5], tolerance 1e-10) finds that starts converging to Solution 1 need a median of 6 and up to 38 iterations, and to Solution 2 a median of 7 and up to 178; 8.6% and 6.2% of those starts need more than 10. "from anywhere in the basin" is therefore false as written; a possible fix is to drop that clause or say "from starts near the solution". Left for the director/Jason to decide.
- index.qmd:68 "requires careful formulation of G to satisfy the convergence condition" was left as is: formulating G to satisfy the (sufficient) condition is a legitimate way to get a guarantee, and line 38 now says the condition is not necessary.
- Nothing outside the page folder was touched.

### Director note

The fixer found a further false sentence that is not a round-1 finding and was left unchanged: index.qmd:76 says Newton converges 'within a handful of iterations from anywhere in the basin', but on a grid of starting points some need up to 38 (Solution 1) and 178 (Solution 2) iterations. Evidence is in the Notes above. Flagged for Jason / the round-2 review.

## Resolution check (independent checker, not shown this record)

Scope of the fix: only `index.qmd` changed (4 lines: 38, 65, 82, 90). Both scripts and both GIFs are unchanged from HEAD (`git diff --quiet HEAD -- *.gif` clean; scripts not in the diff).

Work files: `check/calc.py` (mpmath 60-digit Newton, resultant, geometry), `check/run/` (scratch script copies), `check/fa`, `check/fb` (decoded frames).

### Original findings

### F1 — resolved
- Evidence: line 38 now reads "The row-sum condition is sufficient, not necessary. When it fails, convergence is no longer guaranteed, but the iteration can still converge: from starts sufficiently close to X* it converges whenever the spectral radius (the largest eigenvalue magnitude) of the Jacobian of G at X* is less than 1." This is the standard local-convergence theorem (Ostrowski) for C¹ G, and the definition of spectral radius is correct. Own check: G(x,y) = (0.6x + 0.6y + 0.05 sin y, 0.1y) has Jacobian at 0 with row sums 1.25, 0.1 (condition fails), eigenvalues 0.6, 0.1; 80 iterations from (0.5,0.5) give (2.1e-18, 5e-81) — converges, as the new sentence says. The false "diverges regardless of how close" claim is gone.
- Table row 65 now "Row-sum condition is sufficient (not necessary)" — true.
- Note (not blocking): line 68 (unchanged, not in the original finding) still says fixed-point iteration "requires careful formulation of G to satisfy the convergence condition". Read as practical advice it is fine, and the page now says two paragraphs earlier that the condition is only sufficient; at most an optional wording polish ("…to make it converge").

### F2 — resolved
- Evidence: "near the bottom of the curves", "large negative y", "outer loop" and "the first step brings the iterate close" are all gone.
- New text: "the lower-right intersection, where the blue curve crosses the red curve f₂ = 0 close to its rightmost point (1.5579, −0.6300)". Checked: the resultant in y of f1, f2 has exactly two real roots (y = 0.72449, −0.57565), giving exactly two real intersections (0.061770, 0.724491) and (1.556097, −0.575651); the second is the lower-right one. Rightmost point of f₂ = 0: h(y)=4y⁴+4y minimized at y = −(1/4)^(1/3) = −0.629961, h = −1.889882, x_max = (4−h)^(1/4) = 1.557854 → (1.5579, −0.6300) correct. Distance from Solution 2 to that point is 0.054, so "close to" is fair; frame 9 of newtonsysab shows the red dot at the right-hand tip of the red curve.
- Error sequence (see ledger) verified at 60 digits and in Float64.

### F3 — resolved
- Evidence: "between the two curves" is gone. New: "Starting just above the red curve and well above the blue curve at x = 0.5". At x = 0.5, f₂ = 0 has y ∈ {−1.21825, 0.71825} and f₁ = 0 has y = −0.62996; the start y = 0.8 is 0.082 above the red curve's upper branch and 1.43 above the blue curve. Frame 1 of newtonsysaa shows the start marker just above the flat top of the red curve. True.

### F4 — resolved
- Evidence: "|g'(x*)| ≈ 0" removed (grep finds no `g'` on the page). Replaced by an error sequence that the animation actually supports; verified below.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:38 | "row-sum condition is sufficient, not necessary" | Counterexample above (row sum 1.25, converges) + the page's own line 34 theorem | True |
| index.qmd:38 | "converges whenever the spectral radius … < 1" from starts sufficiently close | Ostrowski's theorem for C¹ G; numerical counterexample converges with ρ = 0.6 | True |
| index.qmd:38 | "(the largest eigenvalue magnitude)" | Definition of spectral radius | True |
| index.qmd:65 | "Row-sum condition is sufficient (not necessary)" | As above | True |
| index.qmd:82 | "just above the red curve and well above the blue curve at x = 0.5" | Red top at x=0.5: 0.71825; blue: −0.62996; start y=0.8 | True |
| index.qmd:82 | 0.44 (start) | ‖(0.5,0.8) − X₁*‖₂ = 0.44469 | True |
| index.qmd:82 | 0.24 | 0.2370 | True |
| index.qmd:82 | 0.024 | 0.02370 | True |
| index.qmd:82 | 3×10⁻⁴ | 2.92e-4 | True |
| index.qmd:82 | 5×10⁻⁸ | 4.57e-8 | True |
| index.qmd:82 | 1×10⁻¹⁵ | 1.12e-15 exact arithmetic; 1.08e-15 in the script's Float64 | True |
| index.qmd:82 | "From the start through step 5" (6 values) | x⁽⁰⁾…x⁽⁵⁾ | True |
| index.qmd:82 | "each error roughly the square of the previous one" | e_{k+1}/e_k² = 1.2, 0.42, 0.52, 0.54, 0.54 (→ 0.535) | True |
| index.qmd:82 | (0.0618, 0.7245) (unchanged) | 0.0617701, 0.7244905 | True |
| index.qmd:90 | "the lower-right intersection" | Only two real intersections; this is the lower-right one | True |
| index.qmd:90 | "close to its rightmost point (1.5579, −0.6300)" | (1.557854, −0.629961); distance 0.054 | True |
| index.qmd:90 | 0.61 | 0.61410 | True |
| index.qmd:90 | 0.21 | 0.2140 | True |
| index.qmd:90 | 0.034 | 0.03370 | True |
| index.qmd:90 | 1.1×10⁻³ | 1.05e-3 | True |
| index.qmd:90 | 1.1×10⁻⁶ | 1.06e-6 | True |
| index.qmd:90 | 1.1×10⁻¹² | 1.08e-12 | True |
| index.qmd:90 | "each error roughly the square of the previous one" | e_{k+1}/e_k² = 0.57, 0.73, 0.93, 0.96, 0.96 | True |
| index.qmd:90 | (1.5561, −0.5757) (unchanged) | 1.5560975, −0.5756508 | True |

Float64 iterates from the script match the exact ones through step 5 (Case 1: (−0.1731, 0.7537), (0.0381, 0.7259), (0.0615, 0.7245), …; Case 2: (1.75, −0.6667), (1.5897, −0.5779), (1.5571, −0.5756), …), consistent with the plotted paths.

### New problems

None. Rests on: every changed sentence and number checked above; GIFs and scripts untouched by the fix and still byte-reproducible; frames 1, 5, 9 of both GIFs inspected at full size and consistent with the new text (start marker above both curves in Case 1; Solution 2 at the right tip of the red curve in Case 2; final legend labels (0.0618, 0.7245) and (1.5561, −0.5757)).

Pre-existing, not introduced by this fix, not counted: the legend label renders as "x⁽8⁾" (the iteration digit is not superscripted, only the parentheses are); line 76 "from anywhere in the basin" is loose; line 68 wording noted under F1.

### Reproducibility and conventions

- Both scripts run from scratch copies (`check/run/`); output `newtonsysaa.gif` and `newtonsysab.gif` are byte-identical (`cmp`) to the committed GIFs. 9 frames each.
- Conventions: `## Description` (line 10) precedes `## Animations` (line 70); each case has a `[Julia source]` link and a GIF embed; alt texts are descriptive and their numbers ((0.062, 0.724), (1.556, −0.576)) are correct; no code blocks; section index still links the page.
- Files outside the page folder: the fix diff for this page touches only `pages/numerical-methods/nonlinear-systems/index.qmd`. The working tree has many other modified pages and untracked `reviews/numerical-methods-animations/fixes/*.md` files from the parallel fix campaign; none of them is attributable to this page's fix from the evidence available (the fixer's note `fixes/nonlinear-systems.md` exists but was deliberately not read).

**Final status:** committed
