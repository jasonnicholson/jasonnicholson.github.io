# Fix record: richardson-extrapolation

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/richardson-extrapolation/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`.

- `values.jl` (`julia values.jl` → `$FIX/values.out`): instrumented copy of the computations in `richexaa.jl`, no plotting. For each frame it prints err3, err5, the old annotation string and the new one.
- `indep.py` (`/usr/bin/python3 -I indep.py` → `$FIX/indep.out`): independent check. It uses mpmath at 50 digits on the same 700-point grid [h, π−h], with a sympy check of f'.
- Frames: `$FIX/orig_aa` holds the committed `richexaa.gif` from before the fix, and `$FIX/new_aa` holds the regenerated one. `$FIX/orig_richexaa.gif` and `$FIX/orig_richexab.gif` are copies of the committed GIFs.

## Findings

### F1 — Misleading — fixed

- **Reproduced:**
  - `values.jl`: the old annotation used `round(…; digits=6)`. For frames 5–9 (h = 0.08, 0.05, 0.03, 0.02, 0.01) it printed "max|error D5| ≈ 0.0", although the true values are 2.890315e-07, 4.701289e-08, 6.351436e-09, 1.280565e-09 and 8.167544e-11.
  - Frame 3 (h = 0.2) printed "9.0e-6" for a true 8.560666e-06, and frame 4 (h = 0.12) printed "1.0e-6" for a true 1.339567e-06. The D3 value printed "0.0003" at h = 0.03 (true 2.997100e-04) and "3.3e-5" at h = 0.01 (true 3.332970e-05).
  - `indep.py` (mpmath) gives the same maxima, for example h = 0.08: 2.890315e-7 and h = 0.01: 8.1675496e-11.
  - Full-size `$FIX/orig_aa/frame_005.png` reads "max|error D3| ≈ 0.002119   max|error D5| ≈ 0.0".
  - The checker's correction also holds. Each value is a correct 6-decimal rounding, so the fault is in the display: it shows a false 0.0, and "9.0e-6" and "1.0e-6" read as wrong two-significant-figure values.
- **Change:** `richexaa.jl`
  - added `using Printf` (standard library), at line 6;
  - annotation (line 54): `text("max|error D3| ≈ $(round(err3; digits=6))   max|error D5| ≈ $(round(err5; digits=6))", …)` → `text(@sprintf("max|error D3| ≈ %.2e   max|error D5| ≈ %.2e", err3, err5), …)`.
  - `index.qmd` is unchanged, because the page text quotes none of these numbers.
- **Check:**
  - I regenerated `richexaa.gif` and viewed `new_aa/frame_001.png`, `frame_005.png` and `frame_009.png` at full size, plus `sheet.png`.
  - The 9 annotations read (D3, D5): 6.81e-02, 1.32e-04 | 3.12e-02, 4.08e-05 | 1.28e-02, 8.56e-06 | 4.73e-03, 1.34e-06 | 2.12e-03, 2.89e-07 | 8.31e-04, 4.70e-08 | 3.00e-04, 6.35e-09 | 1.33e-04, 1.28e-09 | 3.33e-05, 8.17e-11.
  - These strings are the same as the NEW lines in `values.out` and as the `fmt:` columns in `indep.out` (mpmath).
  - No D5 value now reads 0, and the annotation fits inside the plot in every frame.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| richexaa.jl:54 annotation, D3 part | "max\|error D3\| ≈ %.2e" → 6.81e-02, 3.12e-02, 1.28e-02, 4.73e-03, 2.12e-03, 8.31e-04, 3.00e-04, 1.33e-04, 3.33e-05 | `/usr/bin/python3 -I indep.py` → mpmath max e3 = 0.068065434, 0.031161808, 0.012833346, 0.0047308868, 0.0021192376, 0.00083113053, 0.00029970995, 0.00013327559, 3.3329695e-5. Each rounds to the value shown. `julia values.jl` gives the same strings, and they are what the frames show | yes |
| richexaa.jl:54 annotation, D5 part | "max\|error D5\| ≈ %.2e" → 1.32e-04, 4.08e-05, 8.56e-06, 1.34e-06, 2.89e-07, 4.70e-08, 6.35e-09, 1.28e-09, 8.17e-11 | `indep.py` → mpmath max e5 = 0.00013214367, 4.0758971e-5, 8.5606661e-6, 1.3395673e-6, 2.890315e-7, 4.7012886e-8, 6.3514354e-9, 1.280565e-9, 8.1675496e-11. Each rounds to the value shown. `values.jl` gives the same strings, and they are what the frames show | yes |
| richexaa.jl:6 | `using Printf` | Standard library, so no package dependency was added. The script runs (`julia richexaa.jl` → "Saved: richexaa.gif") | yes |
| index.qmd:34 (unchanged, rechecked) | "Both approximations converge as h shrinks, but the Richardson curve tracks f'(x) much more closely" | `values.out`: both max errors decrease in every frame (dec3 and dec5 are true in all 9). err3/err5 runs from 515 at h = 0.5 to 4.08e+05 at h = 0.01 | yes |

## Scripts and GIFs

- **Script changed:** `richexaa.jl` only. The `@__DIR__` output path is unchanged and no package was added.
- **GIFs regenerated:**
  - `richexaa.gif` was rebuilt by `julia richexaa.jl` and has 9 frames.
  - I also ran `richexab.jl`. `cmp` against the copy of the committed file shows that `richexab.gif` came out byte-identical, as expected.
- **Frames viewed:**
  - At full size: `new_aa` frames 1, 5 and 9, plus the 9-frame sheet.
  - The annotation numbers are as in the ledger and the text is legible and inside the frame.
  - The curves, title and legend are unchanged from `orig_aa`. Only the annotation string differs.
- **git status of the page folder after regeneration:**
  ```
   M pages/numerical-methods/richardson-extrapolation/richexaa.gif
   M pages/numerical-methods/richardson-extrapolation/richexaa.jl
  ```

## Legacy archive

- **Consulted:** `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RichardsonExtrapMod.html` (the module sits at the archive root, not inside `richardsonextrap/`), the example solutions in `richardsonextrap/RichardsonExtrapMod/Links/`, and the formula and graph images.
- **What it showed:**
  - Example 1's function is f(x) = e^{-x} sin x (image gr_34), as on the page.
  - Example 2 uses step sizes h = 0.1 and 0.01 (image gr_58).
  - Example 3 plots the absolute error over the interval. Graph gr_136 has an error axis in units of 1e-8.
- **Bearing on F1:** the archive does not affect this display-formatting fix. It agrees with the page's function and interval, and nothing on the page conflicts with it.

## Notes

- The finding's statement that the D5 error falls by about h⁴ is consistent with `values.out`: err5/h⁴ = 0.0021 at h = 0.5 and 0.0082 at h = 0.01. Nothing on the page was changed on the strength of it.
- I made no other changes to the page.

## Resolution check (independent checker, not shown this record)

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/richardson-extrapolation/check/`
(`indep.py` = 50-digit mpmath reference; `jl.jl` = the new format string applied to the script's own Float64 maxima; `run/` = scratch run of `richexaa.jl`; `new_frames/`, `old_frames/` = decoded frames of the new GIF and of the pre-fix GIF (taken from HEAD with `git lfs smudge`, sha256 4c5212…bf46 = old LFS oid); `pixdiff*.py` = old vs new pixel comparison.)

### Original findings

### F1 — resolved
- Evidence: `richexaa.jl:54` now uses `@sprintf("max|error D3| ≈ %.2e   max|error D5| ≈ %.2e", err3, err5)` (with `using Printf` added). The maxima are computed exactly as before (`err3`/`err5` over the 700-point grid [h, π−h]), so only the display changed.
- The independent 50-digit mpmath maxima on the same grid, rounded to 3 significant figures, match the strings the script produces in every frame:

  | frame | h | D3 shown | D3 mpmath | D5 shown | D5 mpmath |
  |---|---|---|---|---|---|
  | 1 | 0.5 | 6.81e-02 | 6.81e-02 | 1.32e-04 | 1.32e-04 |
  | 2 | 0.32 | 3.12e-02 | 3.12e-02 | 4.08e-05 | 4.08e-05 |
  | 3 | 0.2 | 1.28e-02 | 1.28e-02 | 8.56e-06 | 8.56e-06 |
  | 4 | 0.12 | 4.73e-03 | 4.73e-03 | 1.34e-06 | 1.34e-06 |
  | 5 | 0.08 | 2.12e-03 | 2.12e-03 | 2.89e-07 | 2.89e-07 |
  | 6 | 0.05 | 8.31e-04 | 8.31e-04 | 4.70e-08 | 4.70e-08 |
  | 7 | 0.03 | 3.00e-04 | 3.00e-04 | 6.35e-09 | 6.35e-09 |
  | 8 | 0.02 | 1.33e-04 | 1.33e-04 | 1.28e-09 | 1.28e-09 |
  | 9 | 0.01 | 3.33e-05 | 3.33e-05 | 8.17e-11 | 8.17e-11 |

- No frame shows "0.0" any more. h=0.2 and h=0.12 now read 8.56e-06 and 1.34e-06, not 9.0e-6 and 1.0e-6. The D3 values at h = 0.03 and 0.01 keep 3 significant figures. The decay is now visible: err3/h² → 0.3333 = |f'''|max/6-type constant, and err5/h⁴ settles at ≈0.008 (steps 0.0071, 0.0075, 0.0078, 0.0080, 0.0082 for h = 0.08…0.01), which is consistent with O(h²) and O(h⁴).
- Frames viewed at full size: frame 1 reads "max|error D3| ≈ 6.81e-02   max|error D5| ≈ 1.32e-04", frame 5 (middle) reads "≈ 2.12e-03 … ≈ 2.89e-07", and frame 9 reads "≈ 3.33e-05 … ≈ 8.17e-11". All three match the table and are legible. The text stays inside the plot box and does not collide with the curves or the legend.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `richexaa.jl:6` | `using Printf` | Needed for `@sprintf`; script runs | OK |
| `richexaa.jl:54` | format `max|error D3| ≈ %.2e   max|error D5| ≈ %.2e` | Labels name the right quantities (err3 = max over grid of abs(D3 − f'), err5 likewise for D5, lines 27–28) | OK |
| `richexaa.gif` frames 1–9 | 18 displayed error values | Each one matches the mpmath reference to 3 s.f. (table above) | OK |

`index.qmd` and `richexab.*` are unchanged.

### New problems

None. This rests on four checks:
- All 18 displayed numbers were checked against a 50-digit reference.
- Frames 1, 5 and 9 were viewed at full size.
- Old and new frames were compared pixel by pixel. Outside the annotation box (rows 375–405, cols 80–520), each frame has about 3k pixels that differ, but almost all differ by ≤16 per channel (max 55). This is GIF palette re-quantisation caused by the new text, not a change to the plot. Curves, title, legend and axes are unchanged, as the full-size frames confirm.
- In Float64 at h = 0.01, roundoff in D5 (~ε/h ≈ 1e-14) is far below the 8.17e-11 shown, so the smallest value is truncation error, not noise.

### Reproducibility and conventions

- Reproducibility: the scratch copy of `richexaa.jl` regenerates `richexaa.gif` byte for byte (sha256 f3f42730…3e69, which is also the new LFS oid in the diff). `richexab.gif` is unchanged by the fix.
- Conventions (in `index.qmd`, unchanged): Description comes before Animations, each case has a source link and an embed, the alt text is descriptive, and there are no code blocks (0 fences).
- Files outside the page folder: the fix diff covers only `richexaa.jl` and `richexaa.gif`. The other entries in the working tree are other pages' fixes and the untracked fix record `reviews/numerical-methods-animations/fixes/richardson-extrapolation.md`, which follows the existing pattern of committed fix records. No other file was changed for this page.

**Final status:** committed
