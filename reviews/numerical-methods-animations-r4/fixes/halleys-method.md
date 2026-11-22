# Fix record: halleys-method

Scratch folder (evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/halleys-method/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced: `julia fix/instr.jl` (same Halley iteration as `halleysba.jl`, x₀ = −2.2) prints
  `x2 = -2.0000000029138016  round8=-2.0  err=-2.913801644410796e-9` and `x3 = -2.0  err=0.0`.
  Independent Python double-precision run `/usr/bin/python3 -I fix/indep.py` prints
  `2 -2.0000000029138016 ... False` and `3 -2.0 ... True` (x₃ is the first iterate equal to −2.0).
  So the old annotation `round(x_cur; digits=8)` printed "x₂ = -2.0", which reads as exact and contradicts the page's "Halley [first reaches −2 exactly] at x₃". Seen in the committed GIF's 3rd frame (bottom right).
- Change: `halleysba.jl` — added `using Printf`; line 88 annotation
  `text("x$(SUB[frame+1]) = $(round(x_cur; digits=8))", …)` → `text("x$(SUB[frame+1]) = $(@sprintf("%.10f", x_cur))", …)`.
  Regenerated `halleysba.gif`. No change to `index.qmd` (its text was already correct).
- Check: frames extracted with giftools into `fix/frames_new/` (6 frames, as before). Frame annotations now read:
  x₀ = -2.2000000000, x₁ = -2.0020618557, x₂ = -2.0000000029, x₃ = x₄ = x₅ = -2.0000000000.
  These match `@sprintf("%.10f", x)` of the computed iterates printed by `fix/instr.jl` (`%.10f=` column) and by `fix/indep.py` (`"%.10f"` column). x₃–x₅ are exactly −2.0 (err 0.0), so "= -2.0000000000" is exact there; x₂ now visibly differs from −2, consistent with the page's "Halley at x₃".

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| halleysba.gif frame 1 annotation | x₀ = -2.2000000000 | `julia fix/instr.jl` → `x0 … %.10f=-2.2000000000` | yes |
| halleysba.gif frame 2 annotation | x₁ = -2.0020618557 | instr.jl → `-2.0020618557`; indep.py → `-2.0020618557` | yes |
| halleysba.gif frame 3 annotation | x₂ = -2.0000000029 | instr.jl → `-2.0000000029` (repr -2.0000000029138016); indep.py same | yes |
| halleysba.gif frames 4–6 annotation | x₃, x₄, x₅ = -2.0000000000 | instr.jl → err = 0.0 for x3–x5; indep.py → `True` (== −2.0) | yes |

No sentence, heading, alt text, title or legend label was added or changed. The legend labels ("Newton xₙ₊₁ ≈ …", "Halley xₙ₊₁ ≈ …") are unchanged and already use ≈.

## Scripts and GIFs
- Script changed: `pages/numerical-methods/halleys-method/halleysba.jl` (Printf import, annotation format only).
- GIF regenerated: `halleysba.gif` (md5 80218298… → e1d8a2fc…). `halleysaa.jl` and `halleysab.jl` not touched and not regenerated.
- Frames viewed at full size: 1, 3, 4, 6. Checked: annotation fits inside the frame at bottom right and is legible; index subscripts are correct; nothing else in the picture changed (curve, hyperbola, tangent, markers, legend identical in layout).
- `git status --short -- pages/numerical-methods/halleys-method` after regeneration:
  ```
   M halleysba.gif
   M halleysba.jl
  ```

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/Halley'sMethodMod.html` (text stripped). It contains Examples 1(a), 1(b) (Newton and Halley on the square-root problem) and Example 2; the functions and starting values are images, so the text alone does not show them. The text notes that multiple-precision arithmetic is needed to show the difference between second- and third-order convergence. F1 is a label-formatting issue and the archive has no bearing on it. The round-4 review's fidelity check (all three cases match Examples 1(a), 1(b), 2(b)) was not re-done.

## Notes
- Case 1a (`halleysaa.jl`) uses the same `round(…; digits=8)` annotation. It was not named by any finding and I checked that it does not mislead: its Newton iterates are 2.0, 1.5 (both exact), 1.41666667, 1.41421569, 1.41421356, 1.41421356 (`julia fix/aa_check.jl`). No change.
- With `%.10f`, x₁ = -2.0020618557 is shown rounded beside "=", the same convention Case 1b already uses (`round(…; digits=10)` with "="). I kept "=" for consistency with Case 1b rather than switching to "≈".

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix changes the annotation in `halleysba.jl` line 88 to `@sprintf("%.10f", x_cur)` and adds `using Printf` (a stdlib). The page text is unchanged.
- I ran the iteration independently in Python double precision (`check/indep.py`): x0 = -2.2, x1 = -2.002061855670103, x2 = -2.0000000029138016 (error -2.91e-9), x3 = x4 = x5 = -2.0 exactly. In mpmath (60 digits) the errors are -2.0619e-3, -2.9138e-9 and -8.2463e-27, which matches the page's "2.1×10⁻³, 2.9×10⁻⁹ and 8.2×10⁻²⁷".
- In the regenerated GIF the frame annotations read: x₀ = -2.2000000000, x₁ = -2.0020618557, x₂ = -2.0000000029, x₃ = x₄ = x₅ = -2.0000000000. Each one is the %.10f rendering of the double iterate. Frame 3 now shows x₂ ≠ -2, so it agrees with the page's "Halley [first reaches −2 exactly] at x₃". The first frame where the annotation shows -2.0000000000 is x₃, and that iterate is exactly -2.0 in double precision.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| halleysba.jl l.7 | `using Printf` | Stdlib; the script runs cleanly | OK |
| halleysba.jl l.88 / GIF frame 1 | x₀ = -2.2000000000 | Matches the start value | OK |
| GIF frame 2 | x₁ = -2.0020618557 | Python: -2.002061855670103 → rounds to -2.0020618557 | OK |
| GIF frame 3 | x₂ = -2.0000000029 | Python: -2.0000000029138016 | OK (this was the finding) |
| GIF frames 4–6 | x₃, x₄, x₅ = -2.0000000000 | Python: exactly -2.0 | OK |
| index.qmd | (no changes) | — | — |

### New problems
None. The basis for this:
- Old and new frames, compared at full size (frames 1, 3 and 6), differ only in the bottom-right annotation. The pixel differences elsewhere are palette-quantization noise: about 20 antialiasing pixels per frame with large differences outside the annotation box, and no visible change.
- As a control, I regenerated the HEAD (pre-fix) script in scratch. It reproduces the old committed GIF byte for byte, so the only source of change is the one-line edit.
- The right-aligned annotation at (2.3, -4.5) fits inside the axes and is legible.
- The untouched legend labels are still correct. Frame 1 has Newton ≈ -2.02222 and Halley ≈ -2.002062. The later "≈ -2.0" labels use ≈, so they are not exactness claims.

### Reproducibility and conventions
- I ran a scratch copy of the current `halleysba.jl`. Its output is byte-identical to the working-tree `halleysba.gif` (cmp), which is a real GIF, 700x550 with 6 frames, not an LFS pointer.
- The fix touches only `halleysba.jl` and `halleysba.gif` in the page folder (`git diff --stat`). The other modified files in the working tree belong to other pages in this round and are not part of this diff.
- index.qmd is unchanged. Description comes before Animations, each of the three cases has a source link and an embed with descriptive alt text, and there are no code blocks (no ``` in the file).

**Final status:** committed
