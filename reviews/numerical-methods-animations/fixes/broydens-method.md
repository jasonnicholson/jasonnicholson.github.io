# Fix record: broydens-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/broydens-method/fix/`

- `indep_fix.py`: an independent sympy/mpmath computation (30 digits). It gives the resultant, all solutions of the system, a check of which solutions lie in the window, the rounding of the Case B root, a plain Broyden iteration written separately from the scripts, and error ratios. Run `/usr/bin/python3 -I indep_fix.py`.
- `instr_aa.jl`, `instr_bb.jl`: lines 1–66 of each script (system, Jacobian, start, `run_broyden`), unchanged, plus a print of every iterate, |F| and the legend rounding. Run `julia instr_aa.jl` and `julia instr_bb.jl`.
- `committed_aa/`, `committed_bb/`: frames of the GIFs before the fix. `new_bb/`: frames of the regenerated broydenbb.gif. `committed_md5.txt`: md5 of the GIFs before the fix.

## Findings

### F1 — Minor — fixed
- Reproduced: `indep_fix.py` gives the Case B root `x=2.80845705219506 y=-1.66448698091455` (mpmath findroot, 30 digits), `round 3dp: -1.664`, `|y* - (-1.665)| = 0.00051302`, `|y* - (-1.664)| = 0.00048698`. `instr_bb.jl` gives the script's final iterate `X_7 = (2.8084570521950516, -1.6644869809145124)  |F| = 2.16e-13`, with legend `(2.8085, -1.6645)`. Committed frame_008 title reads "(2.808, -1.665)". So −1.665 is a misrounding, and −1.664 is the value to 3 d.p.
- Change: index.qmd:80 heading `(2.808,\,-1.665)` → `(2.808,\,-1.664)`; index.qmd:86 alt text "near (2.808, -1.665)" → "near (2.808, -1.664)"; broydenbb.jl:2 comment and broydenbb.jl:29 `title_str` "-1.665" → "-1.664". broydenbb.gif regenerated.
- Check: `grep -rn '1\.665'` in the page folder returns nothing. Frames new_bb/frame_001, 004 and 008 were viewed at full size. The title reads "Broyden's Method: solution near (2.808, -1.664)" and fits the frame. The legends are unchanged (frame_008 "X_7 = (2.8085, -1.6645)").

### F2 — Minor — fixed
- Reproduced: `indep_fix.py` gives the resultant `16*y**4 + 64*y**3 + 8*y**2 - 80*y + 17`, with `number of complex solutions: 4  real: 4`. The roots are (−2.46318293193711, −3.39022654406169) [outside the window], (−0.0881259899488592, 0.827053909973337), (1.74285186969091, 0.227659615002911) and (2.80845705219506, −1.66448698091455) [all three inside the window x ∈ [−1, 3.5], y ∈ [−2.5, 2], which is the `xlims`/`ylims` of both scripts]. Two conics have at most 4 intersections (Bézout), so these are all of them. Committed frame_008 of broydenbb.gif shows the curves crossing near (1.74, 0.23), and no text mentions this crossing.
- Change: index.qmd:68 gets one sentence: "The system has four real solutions; three of them, near $(-0.088,\,0.827)$, $(1.743,\,0.228)$ and $(2.808,\,-1.664)$, lie inside the plotted window." index.qmd:82 "converges to the second solution" → "converges to that lower-right solution". broydenaa.jl:2 "solution 1" → "the upper-left solution"; broydenbb.jl:2 "solution 2" → "the lower-right solution".
- Check: in-window flags from `indep_fix.py` are listed above. The roots rounded to 3 d.p. are −0.088/0.827, 1.743/0.228 and 2.808/−1.664. Among the three visible solutions, (−0.088, 0.827) has the smallest x and the largest y, so it is upper-left. (2.808, −1.664) has the largest x and the smallest y, so it is lower-right. The text already calls the Case A start "near the upper-left intersection" and the Case B start "near the lower-right intersection".

### F3 — Minor — fixed
- Reproduced: `diff broydenaa.jl broydenbb.jl` (before the fix) differs only in the header comments, `x0, y0`, `title_str` and the output filename. Both scripts use the same `F`, `Jac` and 2-D state, so Case B says nothing about dimension. Starting-point dependence does hold: from (0, 1) the run ends at X_6 = (−0.0881259899487075, 0.8270539099733472), and from (2.5, −1.5) it ends at X_7 = (2.8084570521950516, −1.6644869809145124) (`instr_aa.jl`, `instr_bb.jl`; the separate mpmath Broyden in `indep_fix.py` agrees: A final −0.0881259899487, 0.827053909973; B final 2.8084570522, −1.66448698091).
- Change: index.qmd:82 "This case illustrates that the method is dimension-independent and starting-point dependent: …" → "This case illustrates that the method is starting-point dependent: a different initial guess finds a different root."
- Check: as above. The two starts converge to two different roots.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:68 | "The system has four real solutions" | `indep_fix.py` → `resultant in y: 16*y**4 + 64*y**3 + 8*y**2 - 80*y + 17`, `number of complex solutions: 4  real: 4` | yes |
| index.qmd:68 | "three of them … lie inside the plotted window" | `indep_fix.py` in-window flags: True, True, True, False (the one outside is (−2.463, −3.390)). Window = `xlims=(-1.0,3.5)`, `ylims=(-2.5,2.0)` in both scripts | yes |
| index.qmd:68 | (−0.088, 0.827) | `indep_fix.py` → `x=-0.0881259899488592 y=0.827053909973337  x3=-0.088 y3=0.827` | yes |
| index.qmd:68 | (1.743, 0.228) | `indep_fix.py` → `x=1.74285186969091 y=0.227659615002911  x3=1.743 y3=0.228` | yes |
| index.qmd:68 | (2.808, −1.664) | `indep_fix.py` → `x=2.80845705219506 y=-1.66448698091455  x3=2.808 y3=-1.664` | yes |
| index.qmd:80 heading | root ≈ (2.808, −1.664) | same as above. Script X_7 = (2.80845705, −1.66448698) (`instr_bb.jl`) | yes |
| index.qmd:82 | "converges to that lower-right solution" | `instr_bb.jl` final X_7 = (2.8085, −1.6645), \|F\| = 2.16e-13. Lower-right among the visible solutions (largest x, smallest y) | yes |
| index.qmd:82 | "starting-point dependent: a different initial guess finds a different root" | `instr_aa.jl` final (−0.0881, 0.8271) vs `instr_bb.jl` final (2.8085, −1.6645). mpmath Broyden agrees | yes |
| index.qmd:86 alt | "converge superlinearly to the root near (2.808, -1.664)" | Root as above. Superlinear (an unchanged claim, re-checked because the sentence was edited): `indep_fix.py` Case B ratios e_{k+1}/e_k = 0.0714, 0.099, 0.207, 0.0428, 0.0039, 0.000377, 0.00133. They tend to 0 but not monotonically, and the last one is at the 4.3e-14 error level where the run stops | yes |
| broydenbb.jl:29 title (all frames of broydenbb.gif) | "solution near (2.808, -1.664)" | as for the heading. Viewed in new_bb/frame_001, 004, 008 | yes |
| broydenbb.jl:2 comment | "convergence to the lower-right solution near (2.808, -1.664)" | as above | yes |
| broydenaa.jl:2 comment | "convergence to the upper-left solution near (-0.088, 0.827)" | `indep_fix.py` → (−0.0881259899488592, 0.827053909973337). Upper-left among the visible solutions | yes |

## Scripts and GIFs

- Scripts changed: broydenaa.jl (header comment only), broydenbb.jl (header comment and `title_str`).
- GIFs regenerated: both scripts were run from the page folder. broydenaa.gif came out byte-identical (md5 `c3a0a0ee81dcd99d5acd11c63e7fb454` before and after), so it does not appear as modified. broydenbb.gif changed (md5 `729ac93b…` → `fcb60abe…`). All 8 frame hashes differ because the title is on every frame. The frame count is still 8.
- Frames viewed (new_bb, full size): 001 (X_0 = (2.5, −1.5)), 004 (X_3 = (2.8083, −1.664)) and 008 (X_7 = (2.8085, −1.6645)). The title shows −1.664 and fits. The iterates, path and legend values are unchanged from the committed GIF and match `instr_bb.jl`. The third intersection near (1.74, 0.23) is visible in every frame.
- `git status --short -- pages/numerical-methods/broydens-method` after regeneration:
  ```
   M pages/numerical-methods/broydens-method/broydenaa.jl
   M pages/numerical-methods/broydens-method/broydenbb.gif
   M pages/numerical-methods/broydens-method/broydenbb.jl
   M pages/numerical-methods/broydens-method/index.qmd
  ```

## Legacy archive

Consulted: `n2003/BroydenMethodMod.html` and `broydenmethod/BroydenMethodMod/Links/*_lnk_N.html`. The example-solution pages (lnk_7, Example 5 "Use Broyden's method to solve the nonlinear system") reference graph images gr_213–241, but only gr_211–213 are in the archive's Images folder. So Mathews' plots and numerical answers for this example could not be checked. Example 5's system, read from image gr_213, is f₁ = 1 − 4x + 2x² − 2y³ and f₂ = −4 + x⁴ + 4y + y⁴. **This is not the page's system** (the page uses −2y², x², y²). The archive text also says Example 5 asks for "the solution near" two starting points, which fits two cases. No finding concerns the choice of system, and the page's system is computed correctly on its own terms, so nothing was changed for this. It is noted here for Jason. The archive's 3-D exercises ("There are four solutions") are separate from this 2-D example.

## Notes

- The legend uses `round(…; digits=4)`, which drops trailing zeros. In frame 4 of broydenbb.gif, X_3 shows as "−1.664": the true value is −1.6639955, which correctly rounds to −1.6640, so the label is right but has 3 decimals. This is cosmetic, pre-existing and not a finding, so it was left alone.
- The legend shows only the current iterate. The `label`s "f₁(x,y) = 0" and "f₂(x,y) = 0" given to `contour!` do not appear in the legend (pre-existing and not a finding). The page text explains the colours.
- No convention gaps were added or changed.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Independent computation (`check/sol.py`: sympy resultant, then mpmath findroot at 30 digits) gives the root (2.80845705219506, -1.66448698091455), which is (2.808, -1.664) to 3 d.p. All four locations named in the finding now read -1.664: index.qmd Case B heading, Case B alt text, broydenbb.jl header comment (line 2), and `title_str` (line 29). A grep of the page folder for `1.665` finds nothing. In the regenerated broydenbb.gif, frames 1, 4 and 8 (viewed full size) have the title "Broyden's Method: solution near (2.808, -1.664)". The frame 8 legend reads "X_7 = (2.8085, -1.6645)", which is correct to 4 d.p. and consistent with the title.

### F2 — resolved
- Evidence: The resultant in y is 16y^4 + 64y^3 + 8y^2 - 80y + 17. Its four roots are all real, and by Bezout (2 x 2) there are no other intersections. The four solutions are (-0.08813, 0.82705), (1.74285, 0.22766), (2.80846, -1.66449) and (-2.46318, -3.39023). The first three lie in the window x in [-1, 3.5], y in [-2.5, 2] and the fourth lies outside it. The new sentence in the Animations intro ("four real solutions; three of them, near (-0.088, 0.827), (1.743, 0.228) and (2.808, -1.664), lie inside the plotted window") is correct in count, membership and each 3-d.p. value. "the second solution" is replaced by "that lower-right solution", and the script comments now say "upper-left solution" and "lower-right solution". All of these labels are accurate for the visible intersections, and the frames show the three crossings at those places. A grep finds no remaining "second solution" or "solution 1/2".

### F3 — resolved
- Evidence: "dimension-independent and" has been removed. The sentence now reads "This case illustrates that the method is starting-point dependent: a different initial guess finds a different root." This is true: Case A started at (0,1) converges to (-0.088, 0.827) and Case B started at (2.5,-1.5) converges to (2.808, -1.664). Both were confirmed by my own Broyden rerun at 50 digits, which matches the script's algorithm.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| broydenaa.jl l.2 | "upper-left solution near (-0.088, 0.827)" | root (-0.0881260, 0.8270539). Of the visible roots it is the leftmost and the highest | correct |
| broydenbb.jl l.2 | "lower-right solution near (2.808, -1.664)" | root (2.8084571, -1.6644870). Of the visible roots it is the rightmost and the lowest | correct |
| broydenbb.jl l.29 / GIF title | "(2.808, -1.664)" | as above | correct |
| index.qmd Animations intro | "four real solutions" | quartic resultant has 4 real roots, each gives one real x satisfying both equations | correct |
| index.qmd Animations intro | "three of them ... lie inside the plotted window" | 3 inside, (-2.463, -3.390) outside, matches the xlims/ylims in both scripts | correct |
| index.qmd Animations intro | (-0.088, 0.827), (1.743, 0.228), (2.808, -1.664) | 3-d.p. rounding of the 30-digit roots | correct |
| index.qmd Case B heading | root ≈ (2.808, -1.664) | as above | correct |
| index.qmd Case B behavior | "converges to that lower-right solution" | Broyden rerun: the iterates from (2.5,-1.5) converge to (2.80846, -1.66449) | correct |
| index.qmd Case B behavior | "starting-point dependent: a different initial guess finds a different root" | Case A and Case B reach different roots | correct |
| index.qmd Case B alt | "converge superlinearly to the root near (2.808, -1.664)" | error sequence 0.35, 2.5e-2, 2.5e-3, 5.1e-4, 2.2e-5, 8.6e-8, 3.2e-11, 4.3e-14. The ratios e_{k+1}/e_k fall towards 0, so the convergence is superlinear | correct |

### New problems
None. This rests on the following checks:
- Every changed line was verified against high-precision roots computed independently.
- Frames 1, 4 and 8 of the new broydenbb.gif were viewed at full size. The curves, the iterate path and the legend are unchanged, only the title text differs, and it is legible.
- A pixel diff of old against new frames shows the only substantive change in the title band. The other differences are small palette-quantization shifts (max channel diff ≤ 41, one pixel above 40), with no visible content change.
- broydenaa.gif was not changed.

### Reproducibility and conventions
- broydenbb.jl and broydenaa.jl were run from scratch copies. The output is byte-identical to the working-tree GIFs: sha256 e3cfcaf5… for bb, which matches the new LFS oid, and f32d283a… for aa.
- The page still has Description before Animations, a [Julia source] link and an embed per case, and descriptive alt text. It has no code blocks (0 fences), and it is still linked from pages/numerical-methods/index.qmd.
- The diff for this page is confined to pages/numerical-methods/broydens-method/. The working tree also has changes to other pages and untracked reviews/…/fixes/*.md files. These come from the parallel fixes of other pages, not from this fix.

**Final status:** committed
