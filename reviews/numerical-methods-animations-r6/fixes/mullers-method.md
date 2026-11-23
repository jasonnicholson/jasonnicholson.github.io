# Fix record: mullers-method

Scratch folder (`$S` below): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/mullers-method/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:** yes, with one correction to the review's numbers.
  - `/usr/bin/python3 $S/indep.py` (60-digit Muller, parabola roots by `mpmath.polyroots`) gives the Case 3 iterates. Steps are 1.2765e-1, 4.6621e-2, 2.9219e-2, 1.6560e-2, 7.4539e-3, 3.1295e-3, 1.0737e-3, 2.8351e-4, 5.5204e-5. Errors of the next iterate in frames 6 to 9 are 1.42e-3, 3.47e-4, 6.3e-5, 7.8e-6, as the review says.
  - In the old fixed window (1.2 units over about 560 px) the step to the axis crossing is 0.50, 0.13 and 0.03 px in frames 7, 8 and 9, so the step is not visible.
  - Frame comparison of the committed GIF (PIL difference, threshold 30, legend area excluded): frames 7→8 differ only in x 356–550, y 130–354, and 8→9 only in x 359–550, y 139–353. That is the parabola's dashed arms. Nothing changes at the root.
  - **Correction to the review:** it gives the triple's x-span in frames 7–9 as 1.07e-3, 2.8e-4, 5.5e-5 and "under 0.5 px". Those are the step sizes. The actual spans are 1.06e-2, 4.2e-3 and 1.4e-3, which is 4.9, 2.0 and 0.63 px. The conclusion holds: all are smaller than the markers, so the gray dots sit under the red dot (seen in old frame 8).
- **Change:**
  - `mullerscc.jl`: fixed `xlims`/`ylims` replaced by the per-frame zoom of `mullersbb.jl`; open red circle added at the axis crossing; inset added for the step from p₂ to the crossing; `using Printf` added (standard library); header comment updated.
  - **One deliberate difference from Case 2:** the inset box is `bbox(0.60, 0.12, 0.36, 0.28)`, not Case 2's `bbox(0.52, 0.12, 0.44, 0.38)`. With Case 2's box, the inset covered the red p₂ point in frame 1 (seen in the first regeneration; `$S/inset_clear.py` reports the hit at x = 1.5).
  - `mullerscc.gif` regenerated (9 frames, as before).
  - `index.qmd`: one sentence added to Case 3 Behavior; alt text extended.
- **Check:**
  - `$S/instr/cc_values.jl` (the script's own values) matches `indep.py` for all nine next iterates and steps to the digits printed.
  - `/usr/bin/python3 $S/final_checks.py`: the new inset covers no point, crossing or curve in any frame (hits `[]`, smallest gap below it 0.044 of the panel height). The four marks are at least 18 px apart in every frame (142 in frame 1, 18 in frame 9, for a 540 px panel).
  - Frames 1, 2, 7 and 9 viewed at full size, plus the contact sheet of all nine: see below.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 3 Behavior | "Each frame is zoomed to the current points" | `mullerscc.jl` window = [min − δ, max + δ] over q0, q1, q2, q3; all nine frames viewed on the sheet | yes |
| Case 3 Behavior | "the inset shows the step from $p_2$ to the parabola's axis crossing (open red circle), which is the next iterate" (was "magnifies"; changed after the independent check) | Inset spans q2 − 0.15s … q3 + 0.8s; circle drawn at (q3, 0), q3 = `muller_step`; `indep.py` next iterates match. `/usr/bin/python3 $S/inset_scale.py` → inset scale relative to the main panel is 0.550 in x and 0.404 in y in frame 1, and above 1 on both axes in frames 2–9 (x 1.195–5.479, y 1.228–121.6), so "magnifies" was false for frame 1 and "shows" holds for all nine | yes |
| Case 3 Behavior | "the step shrinks from 0.13 to $5.5 \times 10^{-5}$" | `final_checks.py` → strictly decreasing, first 0.1276, last 5.520e-05 | yes |
| Case 3 Behavior | "over the nine frames" | `giftools.jl` → 9 frames | yes |
| Case 3 alt text | "each frame is zoomed to the current points, and an inset shows the step from p₂ to the parabola's axis crossing, the next iterate" (was "magnifies") | Same as the rows above, including `inset_scale.py` | yes |
| GIF legend | "axis crossing = next p₂" | Circle at (q3, 0); next frame's p₂ label equals q3 to 5 digits (for example frame 1 q3 = 1.62765, frame 2 label 1.62765) | yes |
| GIF legend | "p₂ = …" (unchanged format) | `cc_values.jl`: 1.5, 1.62765, 1.67427, 1.70349, 1.72005, 1.7275, 1.73063, 1.7317, 1.73199 | yes |
| GIF inset title | "step to next p₂: …" 1.28e-01, 4.66e-02, 2.92e-02, 1.66e-02, 7.45e-03, 3.13e-03, 1.07e-03, 2.84e-04, 5.52e-05 | `cc_values.jl` and `indep.py` steps | yes |
| Script header | "The three points close in on sqrt(3)" | `indep.py`: all points below √3, error of p₂ falls 0.232 → 6.3e-5 | yes |
| Script comment | Inset "clear of f, the parabola and the points in every frame" | `final_checks.py` → hits `[]` | yes |

## Scripts and GIFs

- **Script changed:** `mullerscc.jl`. **GIF regenerated:** `mullerscc.gif`.
- A second run from a scratch copy gives a byte-identical GIF (`cmp` clean).
- **Frames viewed at full size:** 1, 2, 7 and 9 of the final GIF, plus the contact sheet of all nine. In each: the two gray dots and the red dot are separate, the parabola passes through them, the open red circle is on the x-axis at the next iterate, the legend value of p₂ and the inset title are right, and the inset covers nothing.
- `mullersaa.*` and `mullersbb.*` are unchanged (`git diff --quiet` on all four files).
- `git status -- pages/numerical-methods/mullers-method`: `M index.qmd`, `M mullerscc.gif`, `M mullerscc.jl`.

## Legacy archive

Consulted: `n2003/MullersMethodMod.html` and `n2003/mullersmethod/MullersMethodMod/Links/MullersMethodMod_lnk_4.html` (Example 3).

- `gr_143.gif` shows f[x] = x⁶ − 7x⁴ + 15x² − 9, the page's function. The problem statement says "the multiple root near x = 2"; the root is √3.
- `gr_144.gif` shows p₀ = 1.5, the start for Newton's method in the example.
- Mathews' Muller starting triple is in images `gr_145` onward, which are missing from the archive, so it could not be determined. The page's start (1.3, 1.4, 1.5) is unchanged.
- The archive has no animated Muller GIF under `a2001/Animations` (`find -iname '*muller*'` returned nothing). The window change does not affect fidelity to any Mathews parameter.

## Notes

- Decision R6-A followed: only Case 3 changed. Case 1 keeps its real-part variant.
- Case 2's inset uses the larger box, but `$S/case2_inset.py` finds no point or crossing of Case 2 under it, so nothing needs raising there.
- **Independent-check follow-up (Case 3 wording):** "magnifies" became "shows" in the Behavior sentence and alt text. The frame-1 scale computes to 0.55x in x and 0.40x in y; the checker's message gave 0.39x in y. The inset occupies 117 of the main panel's 418 px in height in frame 1, matching the 0.28 box fraction used in the computation.
- **Not changed, for the director to decide:**
  - `mullerscc.jl` lines 7 and 99 still say the inset "magnifies" / is a "magnified view". The instruction was no script or GIF change, and these are comments only.
  - Case 2 has the same wording in its Behavior sentence and alt text, and its frame-1 inset is also a reduced view: 0.468x in x, 0.515x in y (`inset_scale.py`). Case 2 was left alone as instructed.
  - Case 1's "magnifies" wording was not checked.
- The page has no `## Description` section. This is a pre-existing convention gap that no finding names, so it was not added.

## Director note

The two `mullerscc.jl` comments that said the inset "magnifies" the step now say "shows", matching the page text. Comment-only change. Case 2 has the same wording; it is outside decision R6-A and is flagged for Jason, unchanged.

### Director note

Line 99 of mullerscc.jl was also reworded (magnified view to view). Case 1 and Case 2 still say the inset magnifies; Case 2's frame 1 is a reduced view. Those cases are outside R6-A and are left for Jason.

## Resolution check (independent checker, not shown this record)

Second pass, after the wording fix for the Minor problem raised in the first pass. The refreshed `fix.diff` matches `git diff HEAD` of the page folder on every changed line.

### Original findings

### F1 — resolved
- Evidence: `mullerscc.jl` no longer has a fixed window. Each frame is zoomed to the current triple and the next iterate, and the axis crossing is marked with the open red circle, as R6-A asks.
- All 9 decoded frames are distinct (9 unique frame hashes). I viewed the contact sheet and frames 1, 5 and 9 at full size.
- In the frames that were indistinguishable before (7, 8, 9), the points are now separate. The p₂-to-crossing distance in the main panel is 45.3, 31.0 and 19.2 px, and the gray dots are visible in each. In frame 9 the markers do not overlap.
- Independent 60-digit iteration (divided-difference form, not the script's Lagrange form) gives p₂ = 1.5, 1.62765, 1.67427, 1.70349, 1.72005, 1.7275, 1.73063, 1.7317, 1.73199, matching the legends. The discriminant is positive in all 9 frames, so a real crossing exists in each. The parabola residual at the marked crossing is below 5e-16.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 3 | "Each frame is zoomed to the current points" | Script window = min/max of (q0,q1,q2,q3) ± 8%; frames viewed | True |
| index.qmd Case 3 | "the inset shows the step from $p_2$ to the parabola's axis crossing" | In all 9 frames, p₂ and the crossing lie inside the inset limits, and pixel analysis finds exactly two red markers in the inset, with centres 98.3–105.3 px apart in x and 83.4–84.0 px in y (expected about 105 and 84) | True in all 9 frames |
| index.qmd Case 3 | "(open red circle), which is the next iterate" | Crossing q3 equals the next frame's p₂ in all frames | True |
| index.qmd Case 3 | "from 0.13" | First step 0.1276469 | True |
| index.qmd Case 3 | "to $5.5 \times 10^{-5}$" | Last step 5.520408e-5 | True |
| index.qmd Case 3 | "shrinks ... over the nine frames" | 9 frames; steps strictly decrease: 1.28e-1, 4.66e-2, 2.92e-2, 1.66e-2, 7.45e-3, 3.13e-3, 1.07e-3, 2.84e-4, 5.52e-5 | True |
| index.qmd alt text | "zoomed to the current points" | As above | True |
| index.qmd alt text | "an inset shows the step from p₂ to the parabola's axis crossing, the next iterate" | As above | True in all 9 frames |
| GIF inset titles | "step to next p₂: 1.28e-01 ... 5.52e-05" | Equal to the independent steps at 3 significant figures | True |
| GIF legend | "axis crossing = next p₂" | As above | True |
| GIF legend | "p₂ = ..." | Independent iterates | True |
| mullerscc.jl line 7 | "an inset shows the step" | As above | True |
| mullerscc.jl line 99 | "Inset: view of the step from p₂ to the axis crossing" | As above | True |
| mullerscc.jl line 63 | "Inset: zoomed to the step from q2 to q3" (unchanged in this pass) | The inset's data window is narrower than the main panel's in every frame (x ratio 0.07–0.65, y ratio below 0.01–0.69). This holds in frame 1 too, although its drawn scale is smaller there | True as a statement about the window |

Unchanged claims rechecked: the factorisation $(x^2-1)(x^2-3)^2$ (sympy), and order ≈ 1.23 at the double root (measured 1.2337 at high precision; the root of $2r^3 - r^2 - r - 1$ is 1.23375).

### New problems

None. The first-pass Minor problem ("magnifies" was false in frame 1, where the inset is drawn at 0.55× in x and 0.39× in y) is resolved by the new wording. This rests on the per-frame limits and marker check above, and on the inset not covering f, the parabola or any point in any frame.

Not counted:
- Case 2 uses the same "magnifies" wording. Per the coordinator it is outside this round's decision and is being flagged to the owner.
- Case 1 also says its inset "magnifies the vertex", in the sentence and the alt text. Case 1 is unchanged under R6-A, and I did not measure its inset scale.

### Reproducibility and conventions

- Reproducibility: a fresh scratch copy of the current `mullerscc.jl` produced a GIF byte-identical to the working-tree `mullerscc.gif` (sha256 `abd1e279a370b76191725d9eef010b77622e1bb2a6356a6aaa49eda75ce9e99f`). With comments stripped, the script's code is identical to the version from the first pass.
- R6-A: `mullersaa.jl`, `mullersaa.gif`, `mullersbb.jl` and `mullersbb.gif` are unchanged against HEAD. Only Case 3 changed.
- Source link, embed and descriptive alt text are present for each case; there are no code blocks.
- **Description before Animations: not met, and not caused by this fix.** The page has no `## Description` heading, either now or at HEAD. 42 of the 54 numerical-methods index pages have one.
- Files outside the page folder: the fix's diff is limited to this folder. The working tree does hold changes to other pages and to `reviews/numerical-methods-animations-r6` (chebyshev-approximation-polynomial, laurent-series, pade-approximation, the-tangent-parabola). I did not attribute those to any fixer, so this check cannot by itself prove the Muller fixer touched nothing else.

**Final status:** committed
