# Fix record: nonlinear-systems

Scratch folder (all evidence scripts): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/nonlinear-systems/fix/` (below: `$FIX`).

## Findings

### F1 — Misleading — fixed
- Reproduced: two independent grid runs over a 301×301 grid of starts covering each script's plot window, counting iterations until the Euclidean distance to a solution is below 1e-10.
  - `/usr/bin/python3 $FIX/basin.py` and `$FIX/excursion.py` (vectorised float64 Newton, explicit 2×2 solve).
  - `julia $FIX/grid_instr.jl` (instrumented copy of the scripts' own `f1`, `f2`, `F`, `Jac` and update `p - Jac \ F(p)`).
  - Results:
    - Case 1 window [-0.25, 2.25] × [-1.25, 1.5]: median 6 (Sol 1) and 7 (Sol 2), 91.3% of starts within ≤10 iterations, 1813 starts need ≥24, max 246.
    - Case 2 window [-0.25, 2.75] × [-1.5, 1.25]: median 6 and 7, 93.2% within ≤10, 1362 starts need ≥24, max 203.
  - Reviewer's worst start (0.26667, −0.62667) needs 36 iterations in both my Python and Julia runs (det J₀ = −0.0042), matching the review. "A handful of iterations from anywhere in the basin" is false.
  - Difference from the review: the review reports 131–173 starts not converged within 200 iterations and maxima 78/83. In my runs every grid start converges (cap 3000), with exactly one start per window needing more than 200. The review's grid/counting rule probably differs. The finding (a few starts need many dozens of iterations) holds either way.
- Change: `index.qmd` line 76, last sentence of the Animations intro.
  - Before: "Quadratic convergence means the error roughly squares each step — the path reaches the intersection within a handful of iterations from anywhere in the basin."
  - After: "Quadratic convergence is a local property, though: the error roughly squares each step only once the iterate is close to an intersection. Over a $301 \times 301$ grid of starting points covering each plot window, more than 90% get within $10^{-10}$ of a solution in at most 10 iterations. Starts near the curve where the Jacobian is singular ($\det J = 0$) can instead be thrown far outside the window and need dozens of iterations to come back, over 200 for the slowest start in each window."
  - The review's suggested wording said "from starts far away"; I did not use it because starts more than 1.0 from both solutions have a median of 7–8 iterations (`basin.py`), so distance alone is not what makes a start slow.
- Check: see ledger rows L1–L6.

### F2 — Minor — fixed
- Reproduced:
  - Archive: `NewtonSystemMod.html` lists Example 1 (fixed-point iteration), Example 2 (Newton), Example 3, Example 4 and Exercise 5. The page animates only Newton's method on the 2D system, from (0.5, 0.8) and (2, −1). Its folder has only `newtonsysaa.jl/.gif` and `newtonsysab.jl/.gif`. No fixed-point case and no note.
  - `NewtonSystemMod_gr_75.gif` (viewed upscaled) gives g1 = (2x² − 2y³ + 1)/4 and g2 = (−x⁴ − 4y⁴ + 8y + 4)/12.
  - `/usr/bin/python3 $FIX/fixpt.py` checks the rest:
    - x − g1 = −f1/4 and y − g2 = f2/12, so this is the same system.
    - The resultant in y has degree 12 and gives two real solutions.
    - J_G at Solution 1 (0.06177, 0.72449): row sums 0.849 and 0.160, eigenvalues 0.061 and 0.160.
    - J_G at Solution 2 (1.55610, −0.57565): row sums 2.053 and 2.177, eigenvalues 2.090 and 0.387.
    - Fixed-point iteration from (1.55, −0.57) ends at Solution 1 after 60 iterations.
  - The finding holds. Note that Solution 2 is a saddle of G, with one eigenvalue below 1, not a pure repeller. So the page sentence makes no behaviour claim about Example 1.
- Change: per decision R2-A ("add one sentence, do not add the example"), one sentence was added after the last embed (the page has no legacy note):
  - "The examples in Mathews' module that are not animated here are fixed-point iteration $\mathbf{X} = \mathbf{G}(\mathbf{X})$ on this same system (Example 1), a check that this fixed-point form and the system above are equivalent (Example 3), Newton's method on this system written as a fixed-point iteration (Example 4) and Newton's method for a system of three equations in three unknowns (Exercise 5)."
- Check: ledger rows L7–L11.

## Ledger of changed text
| # | Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|---|
| L1 | index.qmd L76 | "the error roughly squares each step only once the iterate is close to an intersection" | `julia $FIX/slow_instr.jl` gives the distance sequences for the case starts and the slow starts. Close in, they square: (0.5, 0.8): 2.37e−2 → 2.92e−4 → 4.57e−8; slow start (0.26667, −0.62667): 6.18e−3 → 4.76e−5 → 2.82e−9, with e_k/e_{k−1}² ≈ 1.25. Far out, they do not: 5.83e3 → 4.40e3 → 3.29e3 (ratio ≈ 0.75, linear). | yes |
| L2 | index.qmd L76 | "$301 \times 301$ grid … covering each plot window" | The grid in `basin.py`, `excursion.py` and `grid_instr.jl` is `range(xlims…, 301)` × `range(ylims…, 301)`, using the scripts' xlims/ylims (aa: (−0.25, 2.25) × (−1.25, 1.50); ab: (−0.25, 2.75) × (−1.5, 1.25)). That is N = 90601 per window. | yes |
| L3 | index.qmd L76 | "more than 90% get within $10^{-10}$ of a solution in at most 10 iterations" | `grid_instr.jl` gives a fraction ≤10 of 0.9132 (Case 1) and 0.9321 (Case 2). `excursion.py`: 82736/90601 and 84448/90601. | yes |
| L4 | index.qmd L76 | "Starts near the curve where the Jacobian is singular ($\det J = 0$)" | `basin.py` takes the zero crossings of det J on a 1201² grid. Distance from the slow starts (≥24 iterations) to that curve: median 0.037 and 0.040, max 0.181 and 0.183. For random converged starts the median is 0.536 and 0.694. Worst starts: det J₀ = −0.0042 at (0.26667, −0.62667) and 0.0164 at (0.19, −0.62917). | yes |
| L5 | index.qmd L76 | "can instead be thrown far outside the window and need dozens of iterations to come back" | `excursion.py` and `grid_instr.jl`: every start needing ≥24 iterations (1813 and 1362 starts) leaves the window, with a maximum distance from both solutions of at least 26.8 and 27.2, against window diagonals of about 3.7 and 4.1. All of them eventually converge (none hits the 3000 cap). Example: (0.26667, −0.62667) jumps to distance 5.3e3 and then needs 36 iterations. | yes |
| L6 | index.qmd L76 | "over 200 for the slowest start in each window" | `grid_instr.jl`: max 246 (Case 1) and 203 (Case 2). Exactly 1 start per window needs more than 200. | yes |
| L7 | index.qmd last para | "fixed-point iteration $\mathbf{X} = \mathbf{G}(\mathbf{X})$ on this same system (Example 1)" | Archive `NewtonSystemMod.html` line 260 has "Example 1. Use fixed point iteration…", and `lnk_2` is its solution. `gr_75` shows g1 and g2. `fixpt.py`: x − g1 ≡ −f1/4 and y − g2 ≡ f2/12 (sympy) → True, True. | yes |
| L8 | same | "a check that this fixed-point form and the system above are equivalent (Example 3)" | Archive: "Example 3. Show that the systems in examples 1 and 2 are equivalent". `gr_274` is the G form. Equivalence by sympy as in L7. | yes |
| L9 | same | "Newton's method on this system written as a fixed-point iteration (Example 4)" | Archive: "Example 4. Show how Newton's method is in reality a fixed point iteration scheme. Use the system". `gr_288` (viewed) shows the same f1 and f2 as the page. | yes |
| L10 | same | "Newton's method for a system of three equations in three unknowns (Exercise 5)" | Archive: "Exercise 5 … Use the subroutine NewtonSystem to solve the nonlinear system in 3D space". `gr_357`, `gr_358` and `gr_359` (viewed) show 9x²+36y²+4z²−36, x²−2y²−20z and x²−y²+z², all = 0: three equations in x, y, z. | yes |
| L11 | same | "not animated here" | The page folder has only `newtonsysaa` and `newtonsysab` (Newton's method on the 2D system). Example 2 is the Newton example the page does animate. | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none. Both findings are text-only. The animations were confirmed correct by the review (iterates match mpmath), and no page text cites a frame that changed.
- `git status --short -- pages/numerical-methods/nonlinear-systems` → ` M pages/numerical-methods/nonlinear-systems/index.qmd` only.

## Legacy archive
- Consulted: `n2003/NewtonSystemMod.html` (the same file as `FixPointNewtonMod.html`, whose tag-stripped text gives no diff) and `newtonsystem/NewtonSystemMod/Links/lnk_1…6`.
- Images viewed: `gr_75`, `gr_221`, `gr_274`, `gr_288`, `gr_357`, `gr_358` and `gr_359`.
- What it showed:
  - Example 2 is exactly the page's system (`gr_221`).
  - Example 1 is fixed-point iteration with G as above (`gr_75`).
  - Its printed second solution, {1.5560974843220556, −0.5756507696188449}, agrees with my resultant solution (1.556097484322053, −0.5756507696188434) to about 1e−15.
  - The `lnk_2` text says the row sums at Solution 2 are "too big", which agrees with 2.053 and 2.177.
  - No archived animated GIF exists for this topic under `a2001/Animations/` (no system/nonlinear folder).
- The Example 1/2 starting-point images are missing (as the review said), so the page's starts could not be compared.

## Notes
- Independent check of the review's numbers: my grid counts differ from the review's (no non-converged starts with a 3000 cap; maxima 246 and 203 rather than 78 and 83 for Solution 2). The cause is probably a different grid or stopping rule in the review's `basin.py`, which I did not have. The page uses only my own computed numbers.
- Reviewer's cosmetic notes (marker over the start diamond, legend superscripts, red marker colour) were not findings and were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The false clause "the path reaches the intersection within a handful of iterations from anywhere in the basin" is gone (index.qmd line 76). It is replaced by: quadratic convergence is local; >90% of a 301×301 grid per window reach 1e-10 in ≤10 iterations; starts near det J = 0 can be thrown far outside the window and need dozens of iterations, over 200 for the slowest start in each window.
- My own computation is in `check/grid.py`, a vectorised float64 Newton run with the scripts' Jacobian and Cramer's-rule solve. It uses a 301×301 `linspace` grid over each script window, 5000 iterations at most, and success means within 1e-10 of one of the two real solutions. The solutions come from a sympy resultant, then mpmath polishing: (0.0617701337, 0.7244905200) and (1.5560974843, −0.5756507696).
  - Case 1 window [-0.25, 2.25]×[-1.25, 1.5]: every start converges. 91.3% need ≤10 iterations. Solution 1 has median 6, p90 10, max 36. Solution 2 has median 7, p90 9, max 246. One start needs >200: (−0.10833, −0.69083) takes 246 iterations.
  - Case 2 window [-0.25, 2.75]×[-1.5, 1.25]: every start converges. 93.2% need ≤10 iterations. Solution 1 has max 47. Solution 2 has max 203. One start needs >200: (−0.2, −0.675) takes 203 iterations.
- Robustness checks:
  - `check/trace.py` reproduces 246 and 203 exactly with `np.linalg.solve`.
  - `check/jl.jl` runs the same grid in Julia with backslash, as the scripts do. It also gives max 246 and 203, and one start >200 per window. (My Julia Solution-1 constant was truncated to 8 digits, so its ≤10 fraction is not usable. The Python run is the source for the 90% figure.)
- Mechanism: the slow starts lie near the det J = 0 curve. For starts needing ≥20 iterations, the median distance to the curve is 0.034 (p90 0.125). Over all starts the median is 0.54 (Case 1) and 0.70 (Case 2).
  - The slowest start in Case 1 is 0.061 from the curve. Its first steps go to |X| ≈ 6, then 66, then 2×10⁶, with a peak of |X| ≈ 2×10²⁹. It then contracts back by about 3/4 per step.
  - The slowest start in Case 2 is 0.051 from the curve, with a peak of |X| ≈ 9×10²³.
  - So "thrown far outside the window" and "dozens of iterations to come back" are accurate.
- Note: the reviewer's finding reported 131–173 starts not converging within 200 and per-solution maxima of 78/83. I find only one start >200 per window, and nothing that fails to converge. The page's new text does not repeat the reviewer's numbers, and every number it does state agrees with my independent runs.
- Script and GIFs: not affected by this finding and not changed.

### F2 — resolved
- A sentence now follows Case 2 (index.qmd line 96). It lists the archive examples that are not animated: Example 1 (fixed-point X = G(X) on the same system), Example 3 (equivalence of the two forms), Example 4 (Newton written as a fixed-point iteration, on this system) and Exercise 5 (3×3 system). This is the R2-A "add one sentence" remedy.
- Checked against the archive `newtonsystem/NewtonSystemMod/Links/lnk_2..lnk_6`, and the main page lists only Examples 1–4 and Exercise 5:
  - Example 1: G = ((2x²−2y³+1)/4, (−x⁴−4y⁴+8y+4)/12), image gr_75. It rearranges exactly to f1 = 0 and f2 = 0, so "this same system" is correct.
  - Example 2: Newton on this system. This is what the page animates.
  - Example 3: "Show that the systems in examples 1 and 2 are equivalent" (gr_274/275).
  - Example 4: "Show how Newton's method is in reality a fixed point iteration scheme", on the same f1, f2 (gr_288).
  - Exercise 5: three equations in x, y, z (gr_357–359: 9x²+36y²+4z²−36, x²−2y²−20z, x²−y²+z²).
- The list is complete and accurate.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.76 | "Quadratic convergence is a local property … only once the iterate is close to an intersection" | standard theory; consistent with the grid (fast starts quadratic, slow ones wander first) | correct |
| l.76 | "301 × 301 grid of starting points covering each plot window" | windows match the scripts' xlims/ylims; grid run as stated | correct |
| l.76 | "more than 90% get within 10⁻¹⁰ … in at most 10 iterations" | 91.3% (Case 1), 93.2% (Case 2) | correct (Case 1 margin is 1.3 points) |
| l.76 | "Starts near the curve where the Jacobian is singular (det J = 0)" | slow starts: median distance 0.034 to the curve vs 0.54–0.70 overall | correct |
| l.76 | "thrown far outside the window" | the slowest starts reach \|X\| of 10²³–10²⁹ | correct |
| l.76 | "need dozens of iterations to come back" | 2487 (Case 1) and 1883 (Case 2) starts need 20–200 | correct |
| l.76 | "over 200 for the slowest start in each window" | 246 and 203; same in numpy, Cramer and Julia backslash | correct (Case 2 is only just over) |
| l.96 | Example 1 / 3 / 4 / Exercise 5 descriptions | archive lnk_2, lnk_4, lnk_5, lnk_6 and images gr_75, gr_274/275, gr_288, gr_357–359 | correct |

### New problems
None. This rests on the following:
- Every number in the new text was recomputed independently, in two languages and with two linear solvers.
- The archive was read for every listed example.
- No script or GIF changed, so no picture can have regressed.

The new sentence sits at the end of the page, after Case 2's embed rather than in the Animations introduction. That is acceptable placement and not a defect.

### Reproducibility and conventions
- `git status` of the page folder shows only `index.qmd` modified. No .jl or .gif changed, so no regeneration was needed, and the committed GIFs are the HEAD versions.
- The working-tree changes outside this folder belong to other pages or fix records from the parallel run. None of them touches nonlinear-systems.
- Conventions are kept:
  - Description comes before Animations.
  - Each case has a "Julia source" link and a GIF embed with descriptive alt text.
  - There are no code blocks (grep for ``` finds nothing).
- Evidence scripts: `check/grid.py`, `check/trace.py`, `check/jl.jl` (with outputs `Case1.npz` and `Case2.npz`).

**Final status:** committed
