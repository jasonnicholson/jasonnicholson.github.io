# Fix record: graeffes-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/graeffes-method/fix/`
- `indep.py`: builds p_m directly from the roots raised to 2^m (sympy, exact integers) and forms the separated-root estimates in mpmath (60 digits). It does not use the script's squaring recurrence.
- `digits.py`: the same construction at 120 digits. It prints the correct digits d_m = −log10|e_m|, the step ratio d_{m+1}/d_m, and |e_{m+1}|/e_m² for all four Case 1 estimates.
- `before_ab/`, `after_ab/`, `aa_frames/`: frames and contact sheets of the Case 2 GIF before and after the fix, and of the (unchanged) Case 1 GIF.

## Findings

### F1 — Minor — fixed
- **Reproduced:** `/usr/bin/python3 -I indep.py` gives these r₂ estimates (|r₂| = 3) for m = 1…5: 3.0166206257996712, 2.9409170813408397, 2.9787825755126738, 2.9984158052786656, 2.9999908003675412. The errors are +0.0166, −0.0591, −0.0212, −0.00158, −9.2e−6, so the error grows from m = 1 to m = 2 (|e₂|/e₁² = 214). These values match the review table to every digit.
  - `digits.py` gives the digit ratio d_{m+1}/d_m for all four estimates:

    | Step | r₁ | r₂ | r₃ | r₄ |
    |---|---|---|---|---|
    | 0→1 | 0.56 | −3.27 | 16.5 | 5.41 |
    | 1→2 | −2.78 | 0.69 | 1.89 | 2.18 |
    | 2→3 | 2.76 | 1.36 | 1.87 | 1.91 |
    | 3→4 | 2.00 | 1.67 | 1.84 | 1.83 |
    | 4→5 | 1.88 | 1.80 | 1.84 | 1.85 |
    | 5→6 | 1.88 | 1.85 | 1.87 | 1.89 |
    | 6→7 | 1.90 | 1.89 | 1.91 | 1.93 |
    | 7→8 | 1.93 | 1.92 | 1.94 | 1.96 |

  - So "error roughly squares at each step" fails for the first steps (r₁ in 1→2 and r₂ in 1→2 and 2→3). From m = 3 on, every estimate's correct digits grow by a factor of 1.67–1.96 per step.
  - |e_{m+1}|/e_m² for m ≥ 3 ranges from 1.0 to 64 and grows with m, so I phrased the fix as "digits roughly double" and not as "the error roughly squares". This also matches the Description's general sentence.
- **Change:** `index.qmd`, Case 1 Behavior.
  - Before: "All four estimates converge **quadratically** — the error roughly squares at each step because …"
  - After: "All four estimates converge **quadratically**: from $m = 3$ on, the number of correct digits in each estimate roughly doubles at every step, because … The first steps are irregular: the $r_2$ estimate is accidentally close at $m = 1$ (3.017) and moves away to 2.941 at $m = 2$ before converging."
  - The rest of the paragraph is unchanged.
- **Check:** I checked the numbers against the `indep.py` and `digits.py` output above.
  - "Accidentally close": at m = 1 the estimate is √(e₂/e₁) of the squared roots {16, 9, 4, 1}, which is √(273/30). That equals 3·√(1.896/1.875): the correction factors in the numerator (1 + 129/144) and the denominator (1 + 14/16) nearly cancel, so 3.017 lands close to 3 by coincidence, not by separation. At m = 2 the estimate is (26481/354)^{1/4} = 2.941.
  - "Before converging": after m = 2 the r₂ error magnitudes decrease at every step: 0.0591, 0.0212, 0.00158, 9.2e−6, 4.7e−10, 2.4e−18, 1.2e−34.
  - Case 1 GIF frame 3 (m = 2) shows the r₂ point at 3.02 and then 2.94, just below the dashed line at 3, so the GIF matches the text. The GIF was not regenerated because its script is unchanged.

### F2 — Minor — fixed
- **Reproduced:** `graeffesab.jl` had `linestyles = [:solid, :dash, :solid, :solid]`, which drew the r₂ trace in dashed steelblue. That is the same colour and style as the `hline!` at 5. In the committed `before_ab/frame_011.png` the r₂ trace from m ≈ 5 on is indistinguishable from the reference line except for the diamond markers.
- **Change:** `graeffesab.jl` line 49.
  - Before: `linestyles = [:solid, :dash, :solid, :solid]`
  - After: `linestyles = [:solid, :solid, :solid, :solid]   # traces solid; dashed is reserved for the true-value lines`
  - This is the smallest change the review suggested. r₂ keeps its steelblue colour and diamond markers, and r₁ keeps circles, so the legend still separates them.
- **Check:** I regenerated the GIF with `julia graeffesab.jl` and extracted 11 frames into `after_ab/`.
  - In `after_ab/frame_011.png` and `sheet.png` the r₂ trace is solid with diamonds, and the only dashed lines are the references at 5, 2 and 1.
  - The legend shows r₂ as a solid line with a diamond marker.
  - Plotted values, title, annotation and axes are unchanged from the old frames.
  - The page key "Dashed horizontal lines mark the true root magnitudes" now holds for every frame. The Case 2 alt text ("two blue traces … approach the dashed line at 5 slowly") is still accurate.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 Behavior | "converge quadratically" | `digits.py` → digit ratio approaches 2 (1.93–1.96 at 7→8); errors at m = 8 ≤ 1.6e−34. The review's ledger C1-3 confirmed this (unchanged wording) | yes |
| same | "from $m = 3$ on" | `digits.py` → steps 3→4 … 7→8: all four ratios in [1.67, 2.00]; step 2→3 has r₂ at 1.36 and r₁ at 2.76; step 1→2 has negative ratios | yes |
| same | "the number of correct digits in each estimate roughly doubles at every step" | `digits.py` → ratios 1.67–1.96 for all four estimates over m = 3…8 (r₄ at m=8: d=79.5 vs 40.6) | yes |
| same | "because $\|r_k/r_{k+1}\|^{2^m} \to \infty$ doubly exponentially …" | unchanged wording, re-attached; the review's claim ledger C1-5 confirmed it | yes (unchanged) |
| same | "The first steps are irregular" | `digits.py` → step ratios at 0→1 and 1→2 range −3.27 to 16.5 | yes |
| same | "$r_2$ estimate is accidentally close at $m = 1$ (3.017)" | `indep.py` → 3.0166206257996712 (error +0.0166). Near-cancellation: 9·(1+129/144)/(1+14/16) = 9.1 = 273/30 | yes |
| same | "moves away to 2.941 at $m = 2$" | `indep.py` → 2.9409170813408397 (error −0.0591, larger than +0.0166) | yes |
| same | "before converging" | `indep.py` → \|error\| decreases monotonically from m = 2: 0.0591, 0.0212, 0.00158, 9.2e−6, 4.7e−10, 2.4e−18, 1.2e−34 | yes |
| graeffesab.jl l.49 comment | "traces solid; dashed is reserved for the true-value lines" | Code read: the only `ls=:dash` uses are the `hline!` calls; `after_ab/frame_011.png` viewed | yes |

## Scripts and GIFs
- **Script changed:** `graeffesab.jl` (one line). `graeffesaa.jl` is unchanged and was not regenerated.
- **GIF regenerated:** `graeffesab.gif` (11 frames, m = 0…10).
  - I viewed frame 1, the contact sheet covering frames 1–11, and frame 11 at full size.
  - Checked: r₂ is solid with diamonds and is distinguishable from the dashed reference at 5; the legend is correct; the title m index matches the frame; the last-frame annotation is unchanged.
- **Case 1 GIF:** extracted only to check the text against it. In frame 3 (m = 2) the r₂ point dips just below the dashed line at 3.
- **`git status --short -- pages/numerical-methods/graeffes-method` after regeneration:**
  ```
   M pages/numerical-methods/graeffes-method/graeffesab.gif
   M pages/numerical-methods/graeffes-method/graeffesab.jl
   M pages/numerical-methods/graeffes-method/index.qmd
  ```

## Legacy archive
- **What was consulted:** `n2003/graeffemethod/` is present. It contains `GraeffeMethodMod/Images` (282 formula and output images) and `Links/GraeffeMethodMod_lnk_1…10.html`. The main `GraeffeMethodMod.html` named in the brief is not in the folder.
- **What it shows:** the link pages list Examples 1–9, with the formulas as images. The topics include repeated real roots (Examples 6 and 7) and unequal real roots of equal magnitude (Example 9). No Graeffe GIF exists under `a2001/Animations/RootFinding`.
- **Bearing on the fixes:** both findings are about wording and line style, not about which example or parameters to use, so the archive did not affect them. Nothing on the page was changed to follow or depart from Mathews.

## Notes
- **Description sentence left as is:** "the approximation error decreases quadratically with each root-squaring step — the number of accurate digits roughly doubles per iteration" is a general statement, labelled as such ("For polynomials with real roots of distinct magnitudes"), and no finding names it. Like Case 1, it holds only asymptotically.
- **No "not animated here" sentence:** the page has none, and no finding asks for one, so R3-D does not apply here. Mathews' Examples 7–9 (a second repeated-root case, Graeffe2, and equal-magnitude unequal roots) are not animated. Whether the R2-A "add one sentence" rule should cover this page is for the director to decide; I did not add one, because it was not a finding.
- **Cosmetic issue left alone:** the integer iteration axis has ticks at 0, 2.5, 5.0, 7.5, 10.0. The review also noted this and did not report it.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The old sentence ("the error roughly squares at each step") is gone. New text: "from $m = 3$ on, the number of correct digits in each estimate roughly doubles at every step ... The first steps are irregular: the $r_2$ estimate is accidentally close at $m = 1$ (3.017) and moves away to 2.941 at $m = 2$ before converging."
- I checked it independently. `check/indep.py` uses Python big-int Graeffe squaring (p(x)p(-x) built generically, not the script's closed form) and mpmath at 80 digits. Correct digits, -log10|err|, for Case 1:
  - r1: 1.30, 2.60, 4.90, 9.20, 17.5, 33.8 for m = 3..8
  - r2: 1.67, 2.80, 5.04, 9.33, 17.6, 33.9
  - r3: 2.02, 3.72, 6.84, 12.8, 24.4, 47.2
  - r4: 3.29, 6.02, 11.1, 21.1, 40.6, 79.5
- Step ratios run from 1.68 (r2, m=3→4) up to about 2.0, so "roughly doubles from m = 3 on" holds. Before m = 3 it does not hold, for example r2: 1.78 → 1.23. That is the irregularity the page now names.
- The r2 estimates are 3.0166206 at m = 1 and 2.9409171 at m = 2, so 3.017 and 2.941 are correct. The finding's table is reproduced to all printed digits.

### F2 — resolved
- `graeffesab.jl`: `linestyles[2]` changed from `:dash` to `:solid`. All four traces are now solid, and dashed lines are used only for the true-value hlines at 5, 2 and 1.
- In new frames 001, 006 and 011 at full size, the r2 trace (steelblue, solid, diamond markers) is distinct from the dashed reference at 5. The legend shows a solid line with a diamond for r2.
- From m ≈ 6 on, the r1 and r2 traces still sit on the 5-line, because they converge to it. That is unavoidable, and the solid trace now visibly covers the dashed line rather than imitating it.
- The page's key "Dashed horizontal lines mark the true root magnitudes" now holds for Case 2.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "converge quadratically" | Asymptotic digit ratios → 2 (1.93–1.99 at m=7→8) | OK |
| same | "from m = 3 on ... correct digits ... roughly doubles at every step" | Digit sequences above; ratios 1.68–2.0 for m≥3, not before | OK (1.68 for r2 at 3→4 is the weakest, still "roughly") |
| same | "r2 estimate is accidentally close at m = 1 (3.017)" | 3.0166206257996712, err +0.0166 vs m=0 err 3.5 | OK |
| same | "moves away to 2.941 at m = 2 before converging" | 2.9409170813408397 (err -0.059, larger than at m=1); then 2.9788, 2.9984, 2.99999 | OK |
| graeffesab.jl comment | "traces solid; dashed is reserved for the true-value lines" | Matches the code (hline! ls=:dash; traces ls=:solid) | OK |
| graeffesab.gif | Regenerated; values 9, 7.416, 5.966, ... / 1.444, 3.998, 4.246, ... / 3.46, 1.945, 2.005 / 1.111, 0.867, 0.984 | Match indep.py Case 2 values | OK |

Case 2 text, alt text and the overflow numbers are unchanged. I re-checked them anyway:
- 8.6362e434 for Case 2 p8 max coefficient.
- Both expanded polynomials match the factored forms (sympy).
- The double-root errors halve each step (0.0136 → 0.00677 → 0.00339).

### New problems
None. This rests on:
- independent recomputation of every new number and claim;
- full-size viewing of new frames 1, 6 and 11 of graeffesab.gif (the title, legend and annotation are legible and correct, and no element regressed);
- the Case 2 alt text ("two blue traces ... approach the dashed line at 5") staying accurate.

### Reproducibility and conventions
- Ran a scratch copy of graeffesab.jl. Its output is byte-identical to the committed graeffesab.gif (sha256 d1a6227c…c2c8).
- Old vs new decoded frames: all 11 differ. This is expected, because the r2 legend sample and trace style change in every frame.
- graeffesaa.jl and graeffesaa.gif were not changed.
- Conventions hold:
  - Description comes before Animations.
  - Each case has a source link and an embed.
  - The alt text is descriptive.
  - There are no code blocks (0 fences).
- fix.diff touches only the page folder. Other modified paths in the working tree belong to other pages' parallel fixes and are not part of this diff.

**Final status:** committed
