# Fix record: newton-raphson-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r9fix/newton-raphson-method/fix/` (`repro.jl`, `mp.py`, `labels.jl`, `origscript/`, `old/` and `new/` frame extractions).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `julia repro.jl` (Newton on atan from 1.35, the script's update and old label expression) gives:
  - x6 = 2.861054894189724e-6, shown as `0.0`;
  - x7 = -1.561293480026489e-17, shown as `-0.0` (signbit true);
  - x8 = 0.0 exactly (+0.0), shown as `0.0`.

  x0–x5 show as 1.35, -1.28409, 1.12412, -0.78587, 0.29155, -0.01625. Independent check: `/usr/bin/python3 -I mp.py` (mpmath, 80 digits) gives x6 = 2.86105489419e-6, x7 = -1.56130342577e-17 and x8 = 2.537293336e-51. So the finding holds:
  - the labels for x6 and x7 show 0 for nonzero iterates, and x7's label carries a negative zero;
  - x8 is an exact double-precision zero, but the true iterate is not zero.

  The Float64 x7 agrees with the exact value only to about 4 significant figures (-1.561293e-17 against -1.561303e-17), because of cancellation in x6 − atan(x6)(1+x6²). For that reason the label uses 3 significant figures.
- **Change:** `newtoncc.jl`:
  - adds `using Printf`;
  - adds a formatter (with a two-line comment), `fmt_x(x) = x == 0 ? "0 (double-precision result)" : abs(x) >= 1e-3 ? string(round(x; digits=5)) : @sprintf("%.2e", x)`;
  - the two `scatter!` labels change from `$(round(x_cur; digits=5))` to `$(fmt_x(x_cur))`.

  Labels for |x| ≥ 1e-3 keep their old text. The exact-zero wording follows the Secant Case 3 pattern (R5-B, `secantmethodcc.jl`), so the two pages read consistently. `newtoncc.gif` was regenerated.
- **Check:**
  - `julia labels.jl` prints `["1.35", "-1.28409", "1.12412", "-0.78587", "0.29155", "-0.01625", "2.86e-06", "-1.56e-17", "0 (double-precision result)"]`. 2.86e-06 and -1.56e-17 agree with mpmath to the digits shown.
  - Full-size frames 1, 7, 8 and 9 of the new GIF were viewed. They show `x₍0₎ = 1.35`, `x₍6₎ = 2.86e-06`, `x₍7₎ = -1.56e-17` and `x₍8₎ = 0 (double-precision result)`. Each legend is legible and inside the frame and overlaps no drawn element.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `newtoncc.jl` comment | "Legend format: 5 decimals for \|x\| >= 1e-3, otherwise 3 significant figures." | Matches `fmt_x`. `%.2e` gives 3 significant figures. `labels.jl` output above. | yes |
| `newtoncc.jl` comment | "An iterate that is exactly 0.0 is a double-precision result, not the exact Newton iterate." | `repro.jl`: Float64 x8 = 0.0. `mp.py`: exact x8 = 2.537e-51 ≠ 0. | yes |
| `newtoncc.gif` frame 7 legend | `x₍6₎ = 2.86e-06` | Julia 2.861054894e-6; mpmath 2.86105489419e-6 | yes |
| `newtoncc.gif` frame 8 legend | `x₍7₎ = -1.56e-17` | Julia -1.561293e-17; mpmath -1.561303e-17. Both round to -1.56e-17. | yes |
| `newtoncc.gif` frame 9 legend | `x₍8₎ = 0 (double-precision result)` | Julia x8 == 0.0 (signbit false); exact 2.537e-51 | yes |
| `newtoncc.gif` frames 1–6 legends | unchanged text (1.35 … -0.01625) | `labels.jl`: same strings as the old `round(digits=5)` | yes |

`index.qmd` is unchanged. Neither the Case 3 Behavior paragraph nor its alt text quotes a legend value. The Behavior text says "converges … after several oscillating steps", and the alt text says "convergent case starting just inside the critical radius". Neither is affected by the label change.

## Scripts and GIFs
- **Script changed:** `newtoncc.jl`. **GIF regenerated:** `newtoncc.gif`, 9 frames as before, new sha256 6b394576…707e.
- **Baseline:** the original script, run from the scratch copy `origscript/`, reproduces the committed GIF byte for byte (sha256 84febee0…e886, matching the LFS pointer's oid). Old and new frames were compared from that baseline.
- **Pixel differences:** every frame's md5 changed. The pixel differences in frames 1–6 are spread over the whole plot (bounding box about 11–629 × 2–582), not just the legend. This fits a GIF palette that changed because the later frames gained new legend text. Frames 1 and 7–9 were viewed at full size; the curve, tangent segments and marker are unchanged.
- **Other scripts:** the other five scripts were not touched or rerun, so their GIFs are unchanged.
- `git status --short -- pages/numerical-methods/newton-raphson-method`:
  ```
   M newtoncc.gif
   M newtoncc.jl
  ```

## Legacy archive
- **Consulted:** `n2003/newtonsmethod/`. The main `Newton'sMethodMod.html` named in the brief is not present. Only the link pages `Newton'sMethodMod/Links/*_lnk_1..9.html` and the formula images are there.
  - `_lnk_6.html` is "Example 5. Convergence, Oscillation", the page's Case 3. Its formula and starting value are images; the round-9 review confirmed them from those images.
  - `a2001/Animations/RootFinding/NewtonMethod/` has `Newtoncc.html`, but no `Newtoncc.gif`, so there is no legacy animation to compare against for this case.
- The fix changes only label formatting, so it raises no fidelity question.

## Notes
- The page has no `## Description` section, a pre-existing convention gap that no finding names. Not added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `newtoncc.jl` now formats legend values with `fmt_x`: 5 decimals for |x| >= 1e-3, `%.2e` (3 significant figures) below that, and "0 (double-precision result)" for an exact Float64 zero. Rerun from a scratch copy, the labels are 1.35, -1.28409, 1.12412, -0.78587, 0.29155, -0.01625, 2.86e-06, -1.56e-17, 0 (double-precision result).
- An mpmath (80-digit) Newton run from the double 1.35 gives x6 = 2.86105489419e-6, x7 = -1.56130342577e-17 and x8 = 2.537e-51. A Float64 run gives x6 = 2.861054894e-6, x7 = -1.561293480e-17 and x8 = 0.0. All three new labels are correct to the digits they show. The "0" label states truthfully that it is the double-precision result. The `-0.0` and the misleading `0.0` at step 6 are gone.
- I read frames 7, 8 and 9 of the committed GIF at full size. They show `x₍6₎ = 2.86e-06`, `x₍7₎ = -1.56e-17` and `x₍8₎ = 0 (double-precision result)`, all legible, and the legend box widens without covering any data. The labels in frames 1–6 are unchanged.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| newtoncc.jl l.8 | `using Printf` | needed for @sprintf | OK |
| newtoncc.jl l.31 | "5 decimals for \|x\| >= 1e-3, otherwise 3 significant figures" | `%.2e` gives 3 significant figures; the branch threshold is 1e-3 | true |
| newtoncc.jl l.32 | "exactly 0.0 is a double-precision result, not the exact Newton iterate" | exact x8 = 2.54e-51 ≠ 0; Float64 x8 = 0.0 | true |
| newtoncc.jl l.33 | fmt_x | outputs above match mpmath to the digits shown | OK |
| GIF frame 7 | x₍6₎ = 2.86e-06 | mpmath 2.86105e-6 | correct |
| GIF frame 8 | x₍7₎ = -1.56e-17 | mpmath -1.56130e-17, Float64 -1.56129e-17 | correct |
| GIF frame 9 | x₍8₎ = 0 (double-precision result) | Float64 0.0; exact 2.5e-51 | correct, labelled honestly |
| GIF frames 1–6 | 1.35, -1.28409, 1.12412, -0.78587, 0.29155, -0.01625 | Float64 rounded to 5 decimals | unchanged, correct |

### New problems
None. This rests on the following:
- The fix touches only the label formatter, and the geometry code is unchanged.
- Outside the legend box, old and new frames differ by at most a few pixels of palette-quantisation noise (summed RGB difference ≤ 93 on ≤ 6 pixels).
- The index.qmd text for Case 3 is unchanged and still consistent.

### Reproducibility and conventions
- Running a scratch copy of `newtoncc.jl` produced a GIF byte-identical to the committed one (sha256 6b394576…707e), with identical framemd5.
- Only `newtoncc.jl` and `newtoncc.gif` changed in the page folder, and index.qmd is untouched. It still has a source link and an embed per case (6 and 6), descriptive alt text and no code blocks.
- The page has no separate "Description" heading. That is pre-existing, the fix did not touch it, and it is not attributable to the fix.
- Other modified files in the working tree are other pages' round-9 work (the Lagrange and Newton-interpolation `lagnewt_animations_all.jl` files, under R9-B) and the fix-plan README. None of them belongs to this page's fix diff.

**Final status:** committed
